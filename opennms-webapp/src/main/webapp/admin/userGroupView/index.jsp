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
	import="java.util.Date"
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="配置用户和组" />
  <jsp:param name="headTitle" value="用户和组" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="用户和组" />
</jsp:include>

<div class="TwoColLAdmin" >
      <h3>用户和组</h3>

      <p>
        <a HREF="admin/userGroupView/users/list.jsp">配置用户</a>
      </p>
      <p>
        <a HREF="admin/userGroupView/groups/list.htm">配置组</a>
      </p>
      <p>
        <a HREF="admin/userGroupView/roles">配置角色</a>
      </p>
      <!--
      <p>
        <a HREF="admin/userGroupView/views/list.jsp">Configure Views</a>
      </p>
      -->
</div>

<div  class="TwoColRAdmin">
      <h3>用户</h3>
      <p>
        添加新 <em>用户</em>，更改用户名和密码，并且编辑通知信息。
      </p>

      <h3>组</h3>
      <p>
        分配 <em>用户</em> 到 <em>组</em>。
      </p>

      <h3>角色</h3>
      <p>
        配置角色是指为用户定义值班表。
      </p>
      <!--
      <h3>Views</h3>
      <p>
        Assign and unassign <em>Users</em> and <em>Groups</em> to <em>Views</em>.
      </p>
      -->
</div>


<jsp:include page="/includes/footer.jsp" flush="true"/>
