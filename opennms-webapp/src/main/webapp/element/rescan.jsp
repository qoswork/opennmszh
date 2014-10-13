<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2006-2014 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2014 The OpenNMS Group, Inc.
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
	import="org.opennms.core.utils.WebSecurityUtils,
		org.opennms.web.element.*,
        org.opennms.web.api.Util,
	org.opennms.web.servlet.MissingParameterException
	"
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    String nodeIdString = request.getParameter("node");
    String ipAddr = request.getParameter("ipaddr");
    
    if( nodeIdString == null ) {
        throw new MissingParameterException("node");
    }
    
    int nodeId = WebSecurityUtils.safeParseInt(nodeIdString);
    String nodeLabel = NetworkElementFactory.getInstance(getServletContext()).getNodeLabel(nodeId);
%>

<c:url var="nodeLink" value="element/node.jsp">
	<c:param name="node" value="<%=String.valueOf(nodeId)%>"/>
</c:url>
<c:choose>
	<c:when test="<%=(ipAddr == null)%>">
		<c:set var="returnUrl" value="${nodeLink}"/>
		<jsp:include page="/includes/header.jsp" flush="false" >
			<jsp:param name="title" value="重新扫描" />
			<jsp:param name="headTitle" value="重新扫描" />
			<jsp:param name="headTitle" value="元素" />
			<jsp:param name="breadcrumb" value="<a href='element/index.jsp'>查询</a>" />
			<jsp:param name="breadcrumb" value="<a href='${fn:escapeXml(nodeLink)}'>节点</a>" />
			<jsp:param name="breadcrumb" value="重新扫描" />
		</jsp:include>
	</c:when>
	<c:otherwise>
		<c:url var="interfaceLink" value="element/interface.jsp">
			<c:param name="node" value="<%=String.valueOf(nodeId)%>"/>
			<c:param name="intf" value="<%=ipAddr%>"/>
		</c:url>
		<c:set var="returnUrl" value="${interfaceLink}"/>
		<jsp:include page="/includes/header.jsp" flush="false" >
			<jsp:param name="title" value="重新扫描" />
			<jsp:param name="headTitle" value="重新扫描" />
			<jsp:param name="headTitle" value="元素" />
			<jsp:param name="breadcrumb" value="<a href='element/index.jsp'>查询</a>" />
			<jsp:param name="breadcrumb" value="<a href='${fn:escapeXml(nodeLink)}'>节点</a>" />
			<jsp:param name="breadcrumb" value="<a href='${fn:escapeXml(interfaceLink)}'>接口</a>" />
			<jsp:param name="breadcrumb" value="重新扫描" />
		</jsp:include>
	</c:otherwise>
</c:choose>

<div class="TwoColLAdmin">
      <h3>功能重新扫描</h3>
      
      <p>你确定要重新扫描 <nobr><%=nodeLabel%></nobr>
        <% if( ipAddr==null ) { %>
            节点？
        <% } else { %>
            节点 <%=ipAddr%>?
        <% } %>
      </p>
      
      <form method="post" action="element/rescan">
        <p>
          <input type="hidden" name="node" value="<%=nodeId%>" />
          <input type="hidden" name="returnUrl" value="${fn:escapeXml(returnUrl)}" />

          <input type="submit" value="重新扫描" />
          <input type="button" value="取消" onClick="window.open('<%= Util.calculateUrlBase(request)%>${returnUrl}', '_self')" />
        </p>
      </form>
  </div>

<div class="TwoColRAdmin">
      <h3>节点重新扫描</h3>
    
      <p>
        <em>重新扫描</em> 一个节点通知设备配置子系统重新探测哪些 <em>服务</em> 出现在设备接口和适用于新的 <em>策略</em>。
        如果节点的SNMP配置正确， 重新扫描可以使节点的SNMP属性 (<em>系统位置</em>， <em>系统联系人</em>， <em>等。</em>) 被刷新。
      </p>      
  </div>

<jsp:include page="/includes/footer.jsp" flush="false" />
