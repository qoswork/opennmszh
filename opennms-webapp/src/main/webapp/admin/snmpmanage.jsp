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
	import="java.io.File,
		java.util.*,
		org.opennms.web.element.NetworkElementFactory,
		org.opennms.web.admin.nodeManagement.*
	"
%>

<%!
    int interfaceIndex;
%>

<%
    HttpSession userSession = request.getSession(false);
    List nodes = null;
    Integer lineItems= new Integer(0);
    
    interfaceIndex = 0;
    
    if (userSession == null) {
	throw new ServletException("session is null");
    }

    nodes = (List)userSession.getAttribute("listAllnodes.snmpmanage.jsp");
    lineItems = (Integer)userSession.getAttribute("lineNodeItems.snmpmanage.jsp");

    if (nodes == null) {
	throw new ServletException("session attribute listAllnodes.snmpmanage.jsp is null");
    }
    if (lineItems == null) {
	throw new ServletException("session attribute lineNodeItems.snmpmanage.jsp is null");
    }
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="管理SNMP通过接口" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="管理SNMP通过接口" />
</jsp:include>

<%
  int midNodeIndex = 1;
  
  if (nodes.size() > 1)
  {
    midNodeIndex = nodes.size()/2;
  }
%>

<h3>管理接口SNMP数据采集</h3>

<p>
  在配置文件datacollection-config.xml中，每个不同的采集实例都有一个<code>snmpStorageFlag</code>参数。如果此值设置为"primary"，那么只有节点或主SNMP接口的数据将存储在系统中。如果此值设置为"all"，那么将存储所有接口的数据。
</p>

<p>
  如果这个参数设置为"select"，那么可以选择接口数据存储。默认情况下，只有主和第二接口的SNMP信息被保存，但也可以通过这个界面选择其它非IP接口。
</p>

<p>
  只需选择下面的节点，并按照页面上的指示操作。
</p>

      
   <% if (nodes.size() > 0) { %>
	<div id="contentleft">
          <table class="standardfirst">
            <tr>
              <td class="standardheader" width="5%" align="center">节点ID</td>
              <td class="standardheader" width="10%" align="center">节点名称</td>
            </tr>
            <%=buildTableRows(nodes, 0, midNodeIndex)%>
            
          </table>
	</div>
          <% } /*end if*/ %>
        
      <!--see if there is a second column to draw-->
      <% if (midNodeIndex < nodes.size()) { %>
	<div id="contentright">
          <table class="standardfirst">
            <tr>
              <td class="standardheader" width="5%" align="center">节点ID</td>
              <td class="standardheader" width="10%" align="center">节点名称</td>
            </tr>
            
            <%=buildTableRows(nodes, midNodeIndex, nodes.size())%>
               
          </table>
	</div>
        <% } /*end if */ %>

<jsp:include page="/includes/footer.jsp" flush="true"/>

<%!
      public String buildTableRows(List nodes, int start, int stop)
      	throws java.sql.SQLException
      {
          StringBuffer row = new StringBuffer();
          
          for (int i = start; i < stop; i++)
          {
                
                SnmpManagedNode curNode = (SnmpManagedNode)nodes.get(i);
                String nodelabel = NetworkElementFactory.getInstance(getServletContext()).getNodeLabel(curNode.getNodeID());
		int nodeid = curNode.getNodeID();
                 
          row.append("<tr>\n");
          row.append("<td class=\"standard\" width=\"5%\" align=\"center\">");
	  row.append(nodeid);
          row.append("</td>\n");
          row.append("<td class=\"standard\" width=\"10%\" align=\"left\">");
          row.append("<a href=\"admin/snmpGetInterfaces?node=");
	  row.append(nodeid);
          row.append("&nodelabel=");
	  row.append(nodelabel);
          row.append("\">");
	  row.append(nodelabel);
          row.append("</a>");
          row.append("</td>\n");
          row.append("</tr>\n");
          } /* end i for */
          
          return row.toString();
      }
      
%>
