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
	import="org.opennms.netmgt.config.UserFactory,
	org.opennms.netmgt.config.UserManager,
	org.opennms.netmgt.config.users.User,
    org.springframework.web.context.WebApplicationContext,
    org.springframework.web.context.support.WebApplicationContextUtils,
    org.opennms.web.springframework.security.Authentication"
%>

<%
	boolean canEdit = false;
    String userid = request.getRemoteUser();
    if (request.isUserInRole(Authentication.ROLE_ADMIN)) {
        canEdit = true;
    } else {
	    try {
            final WebApplicationContext webAppContext = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
            final UserManager userFactory = webAppContext.getBean("userManager", org.opennms.netmgt.config.UserManager.class);
       		User user = userFactory.getUser(userid);
       		if (!user.isReadOnly()) {
       		    canEdit = true;
       		}
	    } catch (Throwable e) {
	    	throw new ServletException("Couldn't initialize UserFactory", e);
	    }
	}
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="用户账户自助服务" />
  <jsp:param name="headTitle" value="用户账户自助服务" />
  <jsp:param name="breadcrumb" value="用户账户自助服务" />
</jsp:include>

<script type="text/javascript">
  function changePassword() {
	  <% if (canEdit) { %>
    document.selfServiceForm.action = "account/selfService/newPasswordEntry";
    document.selfServiceForm.submit();
<% } else { %>
	alert("用户 <%= userid %> 是只读的！请管理员更改你的密码。");
<% } %>
  }
</script>

<div class="TwoColLeft">
    <h3>用户账户自助服务</h3>
        <div class="boxWrapper">
        <ul class="plain">
        <li><a href="javascript:changePassword()">修改密码</a></li>
        </ul>
        </div>
</div>

<div class="TwoColRight">
    <h3>账户自助服务选项</h3>
    <div class="boxWrapper">
    <p>
    目前，帐户自助服务仅限于更改密码。
    在这里你可以方便的修改密码，避免过多的操作。
    </p>
    <p>
    如果你需要进一步修改您的帐户，请联系你们负责维持OpenNMS的人。
    </p>
    </div>
</div>

<form name="selfServiceForm" method="post"></form>

<jsp:include page="/includes/footer.jsp" flush="false" />
