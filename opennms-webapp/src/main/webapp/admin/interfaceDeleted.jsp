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
	import="org.opennms.web.element.*,
		org.opennms.web.category.*,
		org.opennms.core.utils.WebSecurityUtils,
		java.util.*,
		org.opennms.web.event.*,
		org.opennms.web.servlet.MissingParameterException
	"
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
	
    String nodeIdString = request.getParameter( "node" );
    String ipAddr = request.getParameter( "intf" );
    String ifIndexString = request.getParameter("ifindex");

    if( nodeIdString == null ) {
        throw new MissingParameterException( "node", new String[] { "node", "intf or ifindex" } );
    }

    if( ipAddr == null && ifIndexString == null ) {
        throw new MissingParameterException( "intf or ifindex", new String[] { "node", "intf or ifindex" } );
    }

    int nodeId = -1;

    try {
        nodeId = WebSecurityUtils.safeParseInt( nodeIdString );
    }
    catch( NumberFormatException e ) {
        //throw new WrongParameterDataTypeException
        throw new ServletException( "Wrong data type, should be integer but got '"+nodeIdString+"'", e );
    }
    
    int ifIndex = -1;
    if (ifIndexString != null && ifIndexString.length() != 0) {
        try {
            ifIndex = WebSecurityUtils.safeParseInt( ifIndexString );
        }
        catch( NumberFormatException e ) {
            //throw new WrongParameterDataTypeException
            throw new ServletException( "Wrong data type, should be integer but got '"+ifIndexString+"'", e );
        }
    }
	
%>

<c:url var="nodeLink" value="element/node.jsp">
  <c:param name="node" value="<%=String.valueOf(nodeId)%>"/>
</c:url>
<c:url var="interfaceLink" value="element/interface.jsp">
  <c:param name="node" value="<%=String.valueOf(nodeId)%>"/>
  <c:param name="intf" value="<%=ipAddr%>"/>
</c:url>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="接口已删除" />
  <jsp:param name="headTitle" value="<%= ipAddr %>" />
  <jsp:param name="breadcrumb" value="<a href='element/index.jsp'>查询</a>" />
  <jsp:param name="breadcrumb" value="<a href='${fn:escapeXml(nodeLink)}'>节点</a>" />
  <jsp:param name="breadcrumb" value="<a href='${fn:escapeXml(interfaceLink)}'>接口</a>" />
  <jsp:param name="breadcrumb" value="接口已删除" />
</jsp:include>

<% if (ifIndex == -1) { %>
<h3>完成删除接口 <%= ipAddr %></h3>
<% } else if (!"0.0.0.0".equals(ipAddr) && ipAddr != null && ipAddr.length() !=0){ %>
<h3>完成删除接口 <%= ipAddr %> 接口索引 <%= ifIndex %></h3>
<% } else { %>
<h3>完成删除接口，接口索引 <%= ifIndex %></h3>
<% } %>
<p>
  OpenNMS应该不需要重新启动，但它可能需要片刻时间更新分类。
</p>

<jsp:include page="/includes/footer.jsp" flush="false" />
