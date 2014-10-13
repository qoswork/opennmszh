<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2007-2012 The OpenNMS Group, Inc.
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
	import="org.opennms.netmgt.config.*,
		java.util.*,
		org.opennms.netmgt.config.users.*
	"
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="修改密码" />
  <jsp:param name="headTitle" value="修改密码" />
  <jsp:param name="breadcrumb" value="<a href='account/selfService/index.jsp'>自助服务</a>" />
  <jsp:param name="breadcrumb" value="修改密码" />
</jsp:include>

<script type="text/javascript">
  function verifyGoForm() 
  {
    if (document.goForm.pass1.value == document.goForm.pass2.value) 
    {
      document.goForm.currentPassword.value=document.goForm.oldpass.value;
      document.goForm.newPassword.value=document.goForm.pass1.value;
      document.goForm.action="account/selfService/newPasswordAction";
      return true;
    } 
    else
    {
      alert("两个新密码不匹配！");
    }
}
</script>

<% if ("redo".equals(request.getParameter("action"))) { %>
<h3>当前密码不正确。请再试一次。</h3>
<% } else { %>
<h3>请输入旧密码和新密码并确认。</h3>
<% } %>

<br/>
<form method="post" name="goForm" onSubmit="verifyGoForm()">
<input type="hidden" name="currentPassword" value="">
<input type="hidden" name="newPassword" value="">

<table>
  <tr>
    <td width="10%">
      目前的密码:
    </td>
    <td width="100%">
      <input type="password" name="oldpass">
    </td>
  </tr>

  <tr>
    <td width="10%">
      确认新密码:
    </td>
    <td width="100%">
      <input type="password" name="pass1">
    </td>
  </tr>
  
  <tr>
    <td width="10%">
      确认密码:
    </td>
    <td width="100%">
      <input type="password" name="pass2">
    </td>
  </tr>
  
  <tr>
    <td>
      <input type="submit" value="OK"/>
    </td>
    <td>
      <a href="account/selfService/index.jsp">取消</a>
    </tr>
</table>
</form>

<jsp:include page="/includes/footer.jsp" flush="false" />
