<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2009-2012 The OpenNMS Group, Inc.
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
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib tagdir="/WEB-INF/tags/element" prefix="element"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="管理报表" />
  <jsp:param name="headTitle" value="管理报表" />
  <jsp:param name="breadcrumb" value="<a href='report/index.jsp'>报表</a>" />
  <jsp:param name="breadcrumb" 
		value="<a href='report/database/index.htm'>数据库</a>" />
  <jsp:param name="breadcrumb" value="管理报表"/>
</jsp:include>

<jsp:useBean id="pagedListHolder" scope="request"
	type="org.springframework.beans.support.PagedListHolder" />
<c:url value="/report/database/manage.htm" var="pagedLink">
	<c:param name="p" value="~" />
</c:url>


<c:choose>
	<c:when test="${empty pagedListHolder.pageList}">
		<p>没有发现。</p>
	</c:when>

	<c:otherwise>
		<form:form commandName="ManageDatabaseReportCommand">
		<element:pagedList pagedListHolder="${pagedListHolder}"
			pagedLink="${pagedLink}" />

		<div class="spacer"><!--  --></div>
		<table>
			<thead>
				<tr>
					<th>标题</th>
					<th>报表ID</th>
					<th>执行时间</th>
					<th>查看报表</th>
					<th>选择</th>
				</tr>
			</thead>
			<%-- // show only current page worth of data --%>
			<c:forEach items="${pagedListHolder.pageList}" var="report">
				<tr>
					<td>${report.title}</td>
					<td>${report.reportId}</td>
					<td>${report.date}</td>
					<td>
                    <c:if test="${empty formatMap[report.reportId]}">
                        <a href="report/database/downloadReport.htm?fileName=${report.location}">下载</a>
                    </c:if>
					<c:forEach items='${formatMap[report.reportId]}' var="format">
						<a href="report/database/downloadReport.htm?locatorId=${report.id}&format=${format}">${format}</a>
					</c:forEach>
					</td>
					<td><form:checkbox path="ids" value="${report.id}"/></td>
				</tr>
			</c:forEach>
		</table>
		<input type="submit" value="删除选择的报表"/>
	</form:form>
	</c:otherwise>
</c:choose>


<jsp:include page="/includes/footer.jsp" flush="false" />
