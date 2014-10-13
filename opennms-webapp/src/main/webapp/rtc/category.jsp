<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2006-2012 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2012 The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is a registered trademark of The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * OpenNMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OpenNMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     OpenNMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/

--%>

<%@page language="java"
	contentType="text/html"
	session="true"
	import="
		org.opennms.web.category.*,
		org.opennms.web.api.Util,
		org.opennms.web.element.NetworkElementFactory,
		org.opennms.web.servlet.MissingParameterException,
		java.util.*,
		org.opennms.netmgt.xml.rtc.Node,
		org.opennms.web.servlet.XssRequestWrapper,
		org.opennms.web.springframework.security.AclUtils,
		org.opennms.web.springframework.security.AclUtils.NodeAccessChecker,
		org.springframework.security.core.context.SecurityContextHolder
		"
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<%!
    public CategoryModel model = null;
    
    public void init() throws ServletException {
        try {
            this.model = CategoryModel.getInstance();            
        }
        catch( java.io.IOException e ) {
            throw new ServletException("Could not instantiate the CategoryModel", e);
        }
        catch( org.exolab.castor.xml.MarshalException e ) {
            throw new ServletException("Could not instantiate the CategoryModel", e);
        }
        catch( org.exolab.castor.xml.ValidationException e ) {
            throw new ServletException("Could not instantiate the CategoryModel", e);
        }        

    }
%>

<%

   HttpServletRequest req = new XssRequestWrapper(request);
   String categoryName = req.getParameter("category");

    if (categoryName == null) {
        throw new MissingParameterException("category");
    }

    Category category = this.model.getCategory(categoryName);

    if (category == null) {
        throw new CategoryNotFoundException(categoryName);
    }
    
    AclUtils.NodeAccessChecker accessChecker = AclUtils.getNodeAccessChecker(getServletContext());

    //put the nodes in a tree map to sort by name
    TreeMap<String,Node> nodeMap = new TreeMap<String,Node>();
    Enumeration<Node> nodeEnum = category.enumerateNode();
    
    while (nodeEnum.hasMoreElements()) {
        Node node = nodeEnum.nextElement();
        int nodeId = (int)node.getNodeid();
        String nodeLabel =
		NetworkElementFactory.getInstance(getServletContext()).getNodeLabel(nodeId);
        // nodeMap.put( nodeLabel, node );

        if (accessChecker.isNodeAccessible(nodeId)) {
            if (nodeLabel != null && !nodeMap.containsKey(nodeLabel)) {
                nodeMap.put(nodeLabel, node);
            } else if (nodeLabel != null) {
                nodeMap.put(nodeLabel+" (nodeid="+node.getNodeid()+")", node);
            } else {
                nodeMap.put("nodeId=" + node.getNodeid(), node);
            }
        }
    }
    
    Set<String> keySet = nodeMap.keySet();
    Iterator<String> nameIterator = keySet.iterator();
%>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="分类服务级别监控" />
  <jsp:param name="headTitle" value="<%=category.getName()%>" />
  <jsp:param name="headTitle" value="分类" />
  <jsp:param name="headTitle" value="SLM" />
  <jsp:param name="breadcrumb" value="<a href='rtc/index.jsp'>SLM</a>" />
  <jsp:param name="breadcrumb" value="分类"/>
</jsp:include>

<h3>
  <span title="最后更新 <c:out value="<%=category.getLastUpdated().toString()%>"/>">
    <c:out value="<%=category.getName()%>"/>
  </span>
</h3>

<form name="showoutages">
  <p>
    显示接口:
	<% String showoutages = req.getParameter("showoutages"); %>

        <%  
        if(showoutages == null ) {
           showoutages = "avail";
        } %>

              <input type="radio" name="showout" <%=(showoutages.equals("all") ? "checked" : "")%>
               onclick="top.location = '<%= Util.calculateUrlBase( req , "rtc/category.jsp?category=" + Util.encode(category.getName()) + "&amp;showoutages=all") %>'" ></input>所有


              <input type="radio" name="showout" <%=(showoutages.equals("outages") ? "checked" : "")%>
               onclick="top.location = '<%= Util.calculateUrlBase( req , "rtc/category.jsp?category=" + Util.encode(category.getName()) + "&amp;showoutages=outages") %>'" ></input>有故障


              <input type="radio" name="showout" <%=(showoutages.equals("avail") ? "checked" : "")%>
               onclick="top.location = '<%= Util.calculateUrlBase( req , "rtc/category.jsp?category=" + Util.encode(category.getName()) + "&amp;showoutages=avail") %>'" ></input>可用性 &lt; 100% 

  </p>
</form>

      <% if( category.getComment() != null ) { %>      
        <p><c:out value="<%=category.getComment()%>"/></p>
      <% } %>
      <% if( AclUtils.shouldFilter(SecurityContextHolder.getContext().getAuthentication().getAuthorities()) ) { %>
        <p style="color: red"> 这个列表已过滤，根据你的用户组访问节点的权限。 </p>
      <% } %>
      <c:out escapeXml="false" value="<!-- Last updated "/><c:out value="<%=category.getLastUpdated().toString()%>"/><c:out escapeXml="false" value=" -->"/>

      <table>
        <tr>
          <th>节点</th>
          <th>故障</th>
          <th>24小时可用性</th>
        </tr>
      
        <%  
	    int valuecnt = 0;
	    int outagecnt = 0;

            while( nameIterator.hasNext() ) {
                String nodeLabel = nameIterator.next();
                Node node = nodeMap.get(nodeLabel);
                
                double value = node.getNodevalue();
        
                if( value >= 0 ) {
                    long serviceCount = node.getNodesvccount();        
                    long serviceDownCount = node.getNodesvcdowncount();
                    double servicePercentage = 100.0;
                
                    if( serviceCount > 0 ) {
                       servicePercentage = ((double)(serviceCount-serviceDownCount))/(double)serviceCount*100.0;
                    }
                
                    String availClass = CategoryUtil.getCategoryClass( category, value );
                    String outageClass = CategoryUtil.getCategoryClass( category, servicePercentage );

		    if ( showoutages.equals("all") | (showoutages.equals("outages") & serviceDownCount > 0 ) | (showoutages.equals("avail") & value < 100 ) ) {
        %>
                    <tr class="CellStatus">
                      <td><a href="element/node.jsp?node=<%=node.getNodeid()%>"><c:out value="<%=nodeLabel%>"/></a></td>
                      <td class="<%=outageClass%>" align="right"><%=serviceDownCount%> of <%=serviceCount%></td>
                      <td class="<%=availClass%>" align="right" width="30%"><b><%=CategoryUtil.formatValue(value)%>%</b></td>
                    </tr>
            	    <%  } 
		    if (value < 100 )
		        ++valuecnt;
		    if (serviceDownCount > 0 )
		        ++outagecnt;
		    %>
            <%  } %>
        <%  } %>

	<% if ( showoutages.equals("outages") & outagecnt == 0 ) { %>
		<tr>
                  <td colspan="3">
		    目前此分类中没有故障
		  </td>
                </tr>
        <%  } %>

	<% if ( showoutages.equals("avail") & valuecnt == 0 ) { %>
		<tr>
                  <td colspan="3">
		    此分类中所有服务的可用性都是 100%
		  </td>
                </tr>
        <%  } %>
        
    </table>


<jsp:include page="/includes/footer.jsp" flush="false" />
