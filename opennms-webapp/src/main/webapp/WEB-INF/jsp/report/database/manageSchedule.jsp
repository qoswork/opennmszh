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
  <jsp:param name="title" value="管理计划报表" />
  <jsp:param name="headTitle" value="管理计划报表" />
  <jsp:param name="breadcrumb" value="<a href='report/index.jsp'>报表</a>" />
  <jsp:param name="breadcrumb" 
		value="<a href='report/database/index.htm'>数据库</a>" />
  <jsp:param name="breadcrumb" value="管理计划报表"/>
</jsp:include>

<jsp:useBean id="pagedListHolder" scope="request"
	type="org.springframework.beans.support.PagedListHolder" />
<c:url value="/report/database/manageSchedule.htm" var="pagedLink">
	<c:param name="p" value="~" />
</c:url>


<c:choose>
	<c:when test="${empty pagedListHolder.pageList}">
		<p>计划报表为空。</p>
	</c:when>

	<c:otherwise>
		<form:form commandName="ManageReportScheduleCommand">
		<element:pagedList pagedListHolder="${pagedListHolder}"
			pagedLink="${pagedLink}" />

		<div class="spacer"><!--  --></div>
		<table>
			<thead>
				<tr>
					<th>触发器名称</th>
					<th>下次执行时间</th>
					<th>选择</th>
				</tr>
			</thead>
			<%-- // show only current page worth of data --%>
			<c:forEach items="${pagedListHolder.pageList}" var="trigger">
				<tr>
					<td>${trigger.triggerName}</td>
					<td>${trigger.nextFireTime}</td>
					<td><form:checkbox path="triggerNames" value="${trigger.triggerName}"/></td>
				</tr>
			</c:forEach>
		</table>
		<input type="submit" value="取消计划"/>
	</form:form>
	</c:otherwise>
</c:choose>


<jsp:include page="/includes/footer.jsp" flush="false" />
