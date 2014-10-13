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
	import="org.opennms.core.utils.WebSecurityUtils,
		org.opennms.web.element.*,
		org.opennms.netmgt.model.OnmsNode,
		org.opennms.web.servlet.MissingParameterException"
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="管理接口完成" />
  <jsp:param name="headTitle" value="管理接口" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="管理接口完成" />
</jsp:include>

<%

	OnmsNode node = null;
	String nodeIdString = request.getParameter("node");
	if (nodeIdString != null) {
		try {
			int nodeId = WebSecurityUtils.safeParseInt(nodeIdString);
			node = NetworkElementFactory.getInstance(getServletContext()).getNode(nodeId);
		} catch (NumberFormatException e) {
			// ignore this, we just won't put a link if it fails
		}
	}
%>

<h3>修改已更新到数据库</h3>

<p>
  OpenNMS应该不需要重新启动，更改已生效。
</p>

<p>
  要想对节点的更改生效，需要对该节点执行强制重新扫描(节点重新扫描后可能会出现Down)。
</p>

<% if (node != null) { %>
<p>
  <a href="element/node.jsp?node=<%= node.getId() %>">返回节点页面</a>
</p>
<% } %>

<jsp:include page="/includes/footer.jsp" flush="true"/>
