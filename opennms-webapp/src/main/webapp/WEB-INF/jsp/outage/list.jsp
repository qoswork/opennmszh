<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2007-2012 The OpenNMS Group, Inc.
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

<%@page language="java"	contentType="text/html"	session="true" %>

<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="org.opennms.web.element.ElementUtil"%>
<%@page import="org.opennms.web.filter.Filter"%>
<%@page import="org.opennms.web.outage.Outage"%>
<%@page import="org.opennms.web.outage.OutageQueryParms"%>
<%@page import="org.opennms.web.outage.OutageUtil"%>
<%@page import="org.opennms.web.outage.SortStyle"%>
<%@page import="org.opennms.web.outage.filter.NodeFilter"%>
<%@page import="org.opennms.web.outage.filter.NegativeNodeFilter"%>
<%@page import="org.opennms.web.outage.filter.InterfaceFilter"%>
<%@page import="org.opennms.web.outage.filter.NegativeInterfaceFilter"%>
<%@page import="org.opennms.web.outage.filter.ServiceFilter"%>
<%@page import="org.opennms.web.outage.filter.NegativeServiceFilter"%>
<%@page import="org.opennms.web.outage.filter.LostServiceDateAfterFilter"%>
<%@page import="org.opennms.web.outage.filter.LostServiceDateBeforeFilter"%>
<%@page import="org.opennms.web.outage.filter.RegainedServiceDateAfterFilter"%>
<%@page import="org.opennms.web.outage.filter.RegainedServiceDateBeforeFilter"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%--
  This page is written to be the display (view) portion of the OutageFilterServlet
  at the /outage/list.htm URL.  It will not work by itself, as it requires two request
  attributes be set:
  
  1) outages: the list of org.opennms.web.outage.Outage instances to display
  2) parms: an org.opennms.web.outage.OutageQueryParms object that holds all the 
     parameters used to make this query
--%>

<%!
    //useful constant strings
    public static final String ZOOM_IN_ICON = "[+]";
    public static final String DISCARD_ICON = "[-]";
    public static final String BEFORE_ICON  = "[&gt;]";
    public static final String AFTER_ICON   = "[&lt;]";
    
    public static final DateFormat DATE_FORMAT = DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.MEDIUM);
%>

<%
    //required attributes
    Outage[] outages = (Outage[])request.getAttribute( "outages" );
    OutageQueryParms parms = (OutageQueryParms)request.getAttribute( "parms" );
    int outageCount = (Integer)request.getAttribute( "outageCount" );

    if( outages == null || parms == null ) {
        throw new ServletException( "Missing either the outages or parms request attribute." );
    }
%>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="故障列表" />
  <jsp:param name="headTitle" value="列表" />
  <jsp:param name="headTitle" value="故障" />
  <jsp:param name="breadcrumb" value="<a href='outage/index.jsp' title='故障系统页面'>故障</a>" />
  <jsp:param name="breadcrumb" value="列表" />
</jsp:include>

    <% if( outageCount > 0 ) { %>
      <% String baseUrl = OutageUtil.makeLink(request, parms); %>
      <jsp:include page="/includes/resultsIndex.jsp" flush="false" >
        <jsp:param name="count"    value="<%=outageCount%>" />
        <jsp:param name="baseurl"  value="<%=baseUrl%>" />
        <jsp:param name="limit"    value="<%=parms.limit%>" />
        <jsp:param name="multiple" value="<%=parms.multiple%>" />
      </jsp:include>
    <% } %>           
    <jsp:include page="/includes/search-constraints-box.jsp" />
    <table>
      <tr>
        <th><%=this.makeSortLink(request, parms, SortStyle.ID,                SortStyle.REVERSE_ID,                "ID",                        "ID" )%></th>
        <th><%=this.makeSortLink(request, parms, SortStyle.NODE,              SortStyle.REVERSE_NODE,              "节点",                      "节点")%></th>
        <th><%=this.makeSortLink(request, parms, SortStyle.INTERFACE,         SortStyle.REVERSE_INTERFACE,         "接口",                 "接口")%></th>
        <th><%=this.makeSortLink(request, parms, SortStyle.SERVICE,           SortStyle.REVERSE_SERVICE,           "服务",                   "服务")%></th>
        <th><%=this.makeSortLink(request, parms, SortStyle.IFLOSTSERVICE,     SortStyle.REVERSE_IFLOSTSERVICE,     "服务故障时间",     "Down")%></th>
        <th><%=this.makeSortLink(request, parms, SortStyle.IFREGAINEDSERVICE, SortStyle.REVERSE_IFREGAINEDSERVICE, "服务恢复时间", "Up")%></th>
      </tr>      
      
      <%
        for( int i=0; i < outages.length; i++ ) {
        Outage outage = outages[i];
      	pageContext.setAttribute("outage", outage);
      %>
        <tr class="<%=OutageUtil.getStatusColor(outages[i])%>">
        
          <!-- outage id -->
          <td>
            <a href="outage/detail.htm?id=<%=outages[i].getId()%>"><%=outages[i].getId()%></a>
          </td>
          
          <!-- node -->
          <td class="noWrap">
            <% if(outages[i].getNodeId() != 0 ) { %>             
              <% String longLabel  = outages[i].getNodeLabel(); %>
              <% String shortLabel = ElementUtil.truncateLabel(longLabel, 32); %>
              <a href="element/node.jsp?node=<%=outages[i].getNodeId()%>" title="<%=longLabel%>"><%=shortLabel%></a>
              <% Filter nodeFilter = new NodeFilter(outages[i].getNodeId(), getServletContext()); %>
              <% if( !parms.filters.contains(nodeFilter) ) { %>
                  <a href="<%=OutageUtil.makeLink( request, parms, nodeFilter, true)%>" title="只显示此节点的故障"><%=ZOOM_IN_ICON%></a>
                  <a href="<%=OutageUtil.makeLink( request, parms, new NegativeNodeFilter(outages[i].getNodeId(), getServletContext()), true)%>" title="不显示此节点的故障"><%=DISCARD_ICON%></a>              
              <% } %>                          
            <% } %>
          </td>
          
          <!-- interface -->
          <td class="noWrap">
            <% if(outages[i].getIpAddress() != null ) { %>
              <% if( outages[i].getNodeId() != 0 ) { %>
                <c:url var="interfaceLink" value="element/interface.jsp">
                  <c:param name="node" value="<%=String.valueOf(outages[i].getNodeId())%>"/>
                  <c:param name="intf" value="<%=outages[i].getIpAddress()%>"/>
                </c:url>
                <a href="${interfaceLink}" title="这个接口上的更多信息"><%=outages[i].getIpAddress()%></a>
              <% } else { %>
                 <%=outages[i].getIpAddress()%>
              <% } %>
              
              <% Filter intfFilter = new InterfaceFilter(outages[i].getIpAddress()); %>
              <% if( !parms.filters.contains(intfFilter) ) { %>
                  <a href="<%=OutageUtil.makeLink( request, parms, intfFilter, true)%>" title="只显示这个IP地址上的故障"><%=ZOOM_IN_ICON%></a>
                  <a href="<%=OutageUtil.makeLink( request, parms, new NegativeInterfaceFilter(outages[i].getIpAddress()), true)%>" title="不显示这个接口上的故障"><%=DISCARD_ICON%></a>                                            
              <% } %>                          
            <% } %>
          </td>
          
          <!-- service -->
          <td class="noWrap">
            <% if(outages[i].getServiceName() != null) { %>
              <% if( outages[i].getNodeId() != 0 && outages[i].getIpAddress() != null ) { %>
                <c:url var="serviceLink" value="element/service.jsp">
                  <c:param name="node" value="<%=String.valueOf(outages[i].getNodeId())%>"/>
                  <c:param name="intf" value="<%=outages[i].getIpAddress()%>"/>
                  <c:param name="service" value="<%=String.valueOf(outages[i].getServiceId())%>"/>
                </c:url>
                <a href="${serviceLink}" title="这个服务上的更多信息"><c:out value="<%=outages[i].getServiceName()%>"/></a>
              <% } else { %>
                <c:out value="<%=outages[i].getServiceName()%>"/>
              <% } %>                
              
              <% Filter serviceFilter = new ServiceFilter(outages[i].getServiceId(), getServletContext()); %>
              <% if( !parms.filters.contains( serviceFilter )) { %>
                  <a href="<%=OutageUtil.makeLink( request, parms, serviceFilter, true)%>" title="只显示此服务类型的故障"><%=ZOOM_IN_ICON%></a>
                  <a href="<%=OutageUtil.makeLink( request, parms, new NegativeServiceFilter(outages[i].getServiceId(), getServletContext()), true)%>" title="不显示此服务的故障"><%=DISCARD_ICON%></a>
              <% } %>              
            <% } %>          
          </td>
            
          <!-- lost service time -->
          <td class="noWrap">
	    <fmt:formatDate value="${outage.lostServiceTime}" type="date" dateStyle="default"/>&nbsp;<fmt:formatDate value="${outage.lostServiceTime}" type="time" pattern="HH:mm:ss"/>
              <a href="<%=OutageUtil.makeLink( request, parms, new LostServiceDateAfterFilter(outages[i].getLostServiceTime()), true)%>" title="只显示此故障发生之后的"><%=AFTER_ICON%></a>            
              <a href="<%=OutageUtil.makeLink( request, parms, new LostServiceDateBeforeFilter(outages[i].getLostServiceTime()), true)%>" title="只显示此故障发生之前的"><%=BEFORE_ICON%></a>            
          </td>
          
          <!-- regained service time -->
          <% Date regainedTime = outages[i].getRegainedServiceTime(); %>
          <% if(regainedTime != null ) { %>
            <td class="noWrap">
	    <fmt:formatDate value="${outage.regainedServiceTime}" type="date" dateStyle="default"/>&nbsp;<fmt:formatDate value="${outage.regainedServiceTime}" type="time" pattern="HH:mm:ss"/>
                <a href="<%=OutageUtil.makeLink( request, parms, new RegainedServiceDateAfterFilter(outages[i].getRegainedServiceTime()), true)%>" title="只显示此故障恢复之后的"><%=AFTER_ICON%></a>            
                <a href="<%=OutageUtil.makeLink( request, parms, new RegainedServiceDateBeforeFilter(outages[i].getRegainedServiceTime()), true)%>" title="只显示此故障恢复之前的"><%=BEFORE_ICON%></a>            
            </td>
          <% } else { %>
            <td class="bright"><%=OutageUtil.getStatusLabel(outages[i])%></td>
          <% } %>
        </tr>
      <% } %>
    </table>
 
     <% if( outageCount > 0 ) { %>
       <% String baseUrl = OutageUtil.makeLink(request, parms); %>
       <jsp:include page="/includes/resultsIndex.jsp" flush="false" >
         <jsp:param name="count"    value="<%=outageCount%>" />
         <jsp:param name="baseurl"  value="<%=baseUrl%>" />
         <jsp:param name="limit"    value="<%=parms.limit%>" />
         <jsp:param name="multiple" value="<%=parms.multiple%>" />
       </jsp:include>
     <% } %>           
 

<jsp:include page="/includes/bookmark.jsp" flush="false" />
<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
    protected String makeSortLink(HttpServletRequest request, OutageQueryParms parms, SortStyle style, SortStyle revStyle, String sortString, String title ) {
      StringBuffer buffer = new StringBuffer();


      if( parms.sortStyle == style ) {
          buffer.append( "<img src=\"images/arrowdown.gif\" hspace=\"0\" vspace=\"0\" border=\"0\" alt=\"" );
          buffer.append( title );
          buffer.append( " 升序排序\"/>" );
          buffer.append( "&nbsp;<a href=\"" );
          buffer.append( OutageUtil.makeLink(request, parms, revStyle ));
          buffer.append( "\" title=\"反向排序\">" );
      } else if( parms.sortStyle == revStyle ) {
          buffer.append( "<img src=\"images/arrowup.gif\" hspace=\"0\" vspace=\"0\" border=\"0\" alt=\"" );
          buffer.append( title );
          buffer.append( " 降序排序\"/>" );
          buffer.append( "&nbsp;<a href=\"" );
          buffer.append( OutageUtil.makeLink(request, parms, style )); 
          buffer.append( "\" title=\"反向排序\">" );
      } else {
          buffer.append( "<a href=\"" );
          buffer.append( OutageUtil.makeLink(request, parms, style ));
          buffer.append( "\" title=\"排序 " );
          buffer.append( sortString );
          buffer.append( "\">" );   
      }

      buffer.append( title );
      buffer.append( "</a>" );

      return( buffer.toString() );
    }  
%>
