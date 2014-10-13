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

<%@page language="java" contentType="text/html" session="true"
	import="org.opennms.netmgt.config.*,
		java.util.*,
		org.opennms.netmgt.config.users.*
	"
%>

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="新用户" />
	<jsp:param name="headTitle" value="新" />
	<jsp:param name="headTitle" value="用户" />
	<jsp:param name="headTitle" value="管理" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb" value="<a href='admin/userGroupView/index.jsp'>用户和组</a>" />
	<jsp:param name="breadcrumb" value="<a href='admin/userGroupView/users/list.jsp'>用户列表</a>" />
	<jsp:param name="breadcrumb" value="新用户" />
</jsp:include>

<script type="text/javascript">
  function validateFormInput() 
  {
    var id = new String(document.newUserForm.userID.value);
    if (id.toLowerCase()=="admin")
    {
        alert("用户ID '" + document.newUserForm.userID.value + "' 不能使用。它可能会混淆管理员用户的ID 'admin'。");
        return false;
    }
    
    if (document.newUserForm.pass1.value == document.newUserForm.pass2.value) 
    {
      document.newUserForm.action="admin/userGroupView/users/addNewUser";
      return true;
    } 
    else
    {
      alert("两个密码字段不匹配！");
      document.newUserForm.pass1.value = "";
      document.newUserForm.pass2.value = "";
      return false;
    }
  }    
  function cancelUser()
  {
      document.newUserForm.action="admin/userGroupView/users/list.jsp";
      document.newUserForm.submit();
  }

</script>

<%if ("redo".equals(request.getParameter("action"))) { %>
  <h3>用户 <%=request.getParameter("userID")%> 已经存在。
    请输入一个不同的用户ID。</h3>
<%} else { %>
  <h3>请输入用户ID和密码</h3>
<%}%>

<form id="newUserForm" method="post" name="newUserForm" onsubmit="return validateFormInput();">
  <table>
    <tr>
      <td width="10%"><label id="userIDLabel" for="userID">用户ID:</label></td>
      <td width="100%"><input id="userID" type="text" name="userID"/></td>
    </tr>

    <tr>
      <td width="10%"><label id="pass1Label" for="password1">密码:</label></td>
      <td width="100%"><input id="pass1" type="password" name="pass1"/></td>
    </tr>

    <tr>
      <td width="10%"><label id="pass2Label" for="password2">确认密码:</label></td>
      <td width="100%"><input id="pass2" type="password" name="pass2"/></td>
    </tr>

    <tr>
      <td><input id="doOK" type="submit" value="确认"/></td>
      <td><input id="doCancel" type="button" value="取消" onclick="cancelUser()"/></td>
    </tr>
</table>
</form>

<jsp:include page="/includes/footer.jsp" flush="false" />
