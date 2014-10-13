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

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="应用" />
	<jsp:param name="headTitle" value="应用" />
	<jsp:param name="breadcrumb"
               value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb"
	           value="<a href='admin/applications.htm'>应用</a>" />
	<jsp:param name="breadcrumb" value="显示" />
</jsp:include>

<h3>应用: ${fn:escapeXml(model.application.name)}</h3>

<p>
应用 '${fn:escapeXml(model.application.name)}' 有 ${fn:length(model.memberServices)} 个服务。
</p>

<p>
<a href="admin/applications.htm?edit=edit&applicationid=${model.application.id}">编辑应用</a>
</p>

<table>
  <tr>
    <th>节点</th>
    <th>接口</th>
    <th>服务</th>
  </tr>
  <c:forEach items="${model.memberServices}" var="service">
    <tr>
    	<td><a href="element/node.jsp?node=${service.ipInterface.node.id}">${fn:escapeXml(service.ipInterface.node.label)}</a></td> 
    	<td><a href="element/interface.jsp?ipinterfaceid=${service.ipInterface.id}">${service.ipInterface.ipAddress}</a></td> 
    	<td><a href="element/service.jsp?ifserviceid=${service.id}">${fn:escapeXml(service.serviceName)}</a></td> 
    </tr>
  </c:forEach>
</table>

<jsp:include page="/includes/footer.jsp" flush="false"/>
