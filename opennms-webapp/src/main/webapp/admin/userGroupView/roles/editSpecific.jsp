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
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="角色配置" />
	<jsp:param name="headTitle" value="编辑值班表" />
	<jsp:param name="headTitle" value="角色" />
	<jsp:param name="headTitle" value="管理" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb" value="<a href='admin/userGroupView/index.jsp'>用户，组和角色</a>" />
	<jsp:param name="breadcrumb" value="<a href='admin/userGroupView/roles'>角色列表</a>" />
	<jsp:param name="breadcrumb" value="编辑条目" />
</jsp:include>

<h3>编辑值班表</h3>

<div class="error">${error}</div>

<form action="<c:url value='${reqUrl}'/>" method="post" name="saveEntryForm">
  <input type="hidden" name="operation" value="saveEntry"/>
  <input type="hidden" name="role" value="${role.name}"/>
  <input type="hidden" name="schedIndex" value="${schedIndex}"/>
  <input type="hidden" name="timeIndex" value="${timeIndex}" /> 
  
  <table>
	         <tr>
    		    <th>角色</th>
				<td>${role.name}</td>
    		    <th>用户</th>
				<td>
					<select name="roleUser">
					<c:forEach var="user" items="${role.membershipGroup.users}">
						<c:choose>
							<c:when test="${user == scheduledUser}"><option selected>${user}</option></c:when>
							<c:otherwise><option>${user}</option></c:otherwise>
						</c:choose>
					</c:forEach>
					</select>
				</td>
          	</tr>
	        <tr>
    		    <th>开始日期</th>
				<td> 
					<c:import url="/includes/dateControl.jsp">
						<c:param name="prefix" value="start"/>
						<c:param name="date"><fmt:formatDate value="${start}" pattern="dd-MM-yyyy"/></c:param>
					</c:import>
				</td>
    		    		<th>开始时间</th>
    		    		<td>
					<c:import url="/includes/timeControl.jsp">
						<c:param name="prefix" value="start"/>
						<c:param name="time"><fmt:formatDate value="${start}" pattern="HH:mm:ss"/></c:param>
					</c:import>
				</td>
          	</tr>
	         <tr>
    		    		<th>结束日期</th>
				<td>
    		    			<c:import url="/includes/dateControl.jsp">
						<c:param name="prefix" value="end"/>
						<c:param name="date"><fmt:formatDate value="${end}" pattern="dd-MM-yyyy"/></c:param>
					</c:import>
				</td>
    		    		<th>结束时间</th>
				<td>
					<c:import url="/includes/timeControl.jsp">
						<c:param name="prefix" value="end"/>
						<c:param name="time"><fmt:formatDate value="${end}" pattern="HH:mm:ss"/></c:param>
					</c:import>
				</td>
          	</tr>
		</table>
  <br/>
  <input type="submit" name="save" value="保存" />
  &nbsp;&nbsp;&nbsp;
  <input type="submit" name="cancel" value="取消" />
</form>

<jsp:include page="/includes/footer.jsp" flush="false" />
