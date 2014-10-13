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
	session="true"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="角色配置" />
	<jsp:param name="headTitle" value="编辑" />
	<jsp:param name="headTitle" value="角色" />
	<jsp:param name="headTitle" value="管理" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb" value="<a href='admin/userGroupView/index.jsp'>用户，组和角色</a>" />
	<jsp:param name="breadcrumb" value="<a href='admin/userGroupView/roles'>角色列表</a>" />
	<jsp:param name="breadcrumb" value="编辑角色" />
</jsp:include>

<script type="text/javascript" >

	function changeDisplay() {
		document.displayForm.submit();
	}
	
	function prevMonth() {
		document.prevMonthForm.submit();
	}
	
	function nextMonth() {
		document.nextMonthForm.submit();
	}

</script>

<h3>编辑角色</h3>

<form action="<c:url value='${reqUrl}'/>" method="post" name="editForm">
  <input type="hidden" name="operation" value="saveDetails"/>
  <input type="hidden" name="role" value="${role.name}"/>
  
		 <table>
	         <tr>
    		    		<th>名称</th>
				<td><input name="roleName" type="text" value="${role.name}"/></td>
    		    		<th>当前值班</th>
				<td>
					<c:forEach var="scheduledUser" items="${role.currentUsers}">
						${scheduledUser}
					</c:forEach>	
				</td>
          	</tr>
	         <tr>
    		    		<th>监督</th>
				<td>
					<select name="roleUser">
					<c:forEach var="user" items="${userManager.users}">
						<c:choose>
							<c:when test="${user == role.defaultUser}">
								<option selected>${user}</option>
							</c:when>
							<c:otherwise>
								<option>${user}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					</select>
				</td>
    		    		<th>组</th>
				<td>
					<select name="roleGroup">
					<c:forEach var="group" items="${groupManager.groups}">
						<c:choose>
							<c:when test="${group == role.membershipGroup}">
								<option selected>${group}</option>
							</c:when>
							<c:otherwise>
								<option>${group}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					</select>
				</td>
          	</tr>
          	<tr>
    		    		<th>说明</th>
				<td colspan="3"><input name="roleDescr" size="100" type="text" value="${role.description}"/></td>
          	</tr>
		</table>

  <br/>
  <input type="submit" name="save" value="保存" />
  &nbsp;&nbsp;&nbsp;
  <input type="submit" name="cancel" value="取消" />
</form>

<jsp:include page="/includes/footer.jsp" flush="false" />
