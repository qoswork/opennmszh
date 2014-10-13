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
<%@page import="java.util.*" %>
<%@page import="javax.servlet.*" %>
<%@page import="org.opennms.netmgt.config.*" %>
<%@page import="org.opennms.netmgt.config.users.*" %>
<%
	UserManager userFactory;
  	Map users = null;
	
	try
    	{
		UserFactory.init();
		userFactory = UserFactory.getInstance();
      		users = userFactory.getUsers();
	}
	catch(Throwable e)
	{
		throw new ServletException("User:list " + e.getMessage());
	}
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="用户配置" />
  <jsp:param name="headTitle" value="列表" />
  <jsp:param name="headTitle" value="用户" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/userGroupView/index.jsp'>用户和组</a>" />
  <jsp:param name="breadcrumb" value="用户列表" />
</jsp:include>

<script type="text/javascript" >

    function addNewUser()
    {
        document.allUsers.action="admin/userGroupView/users/newUser.jsp?action=new";
        document.allUsers.submit();
        
    }
    
    function detailUser(userID)
    {
        document.allUsers.action="admin/userGroupView/users/userDetail.jsp?userID=" + userID;
        document.allUsers.submit();
    }
    
    function deleteUser(userID)
    {
        document.allUsers.action="admin/userGroupView/users/deleteUser";
        document.allUsers.userID.value=userID;
        document.allUsers.submit();
    }
    
    function modifyUser(userID)
    {
        document.allUsers.action="admin/userGroupView/users/modifyUser";
        document.allUsers.userID.value=userID;
        document.allUsers.submit();
    }
    
    function renameUser(userID)
    {
        document.allUsers.userID.value=userID;
        var newID = prompt("输入新用户名。", userID);
        
        if (newID != null && newID != "")
        {
          document.allUsers.newID.value = newID;
          document.allUsers.action="admin/userGroupView/users/renameUser";
          document.allUsers.submit();
        }
    }
    
</script>


<form method="post" name="allUsers">
<input type="hidden" name="redirect"/>
<input type="hidden" name="userID"/>
<input type="hidden" name="newID"/>
<input type="hidden" name="password"/>

<h3>用户配置</h3>

<p>
  点击<i>用户ID</i>的链接查看用户的详细信息。
</p>

<a id="doNewUser" href="javascript:addNewUser()"><img src="images/add1.gif" alt="添加新用户" border="0"></a>
<a href="javascript:addNewUser()">添加新用户</a>

<br/>
<br/>

     <table width="100%" border="1" cellspacing="0" cellpadding="2" bordercolor="black">

         <tr bgcolor="#999999">
          <td width="5%"><b>删除</b></td>
          <td width="5%"><b>修改</b></td>
          <td width="5%"><b>重命名</b></td>
          <td width="5%"><b>用户ID</b></td>
          <td width="15%"><b>全名</b></td>
          <td width="15%"><b>电子邮件</b></td>
          <td width="15%"><b>寻呼机邮件</b></td>
          <td width="15%"><b>XMPP Address</b></td>
          <!--
          <td width="10%"><b>Num Service</b></td>
          <td width="10%"><b>Num Pin</b></td>
          <td width="15%"><b>Text Service</b></td>
          <td width="15%"><b>Text Pin</b></td>
          -->
        </tr>
        <% Iterator i = users.keySet().iterator();
           int row = 0;
           while(i.hasNext()) 
           {
              User curUser = (User)users.get(i.next());
	      String userid = curUser.getUserId();
	      String email = userFactory.getEmail(userid);
	      String pagerEmail = userFactory.getPagerEmail(userid);
	      String xmppAddress = userFactory.getXMPPAddress(userid);
	      String numericService = userFactory.getNumericPage(userid);
	      String textService = userFactory.getTextPage(userid);
	      String numericPin = userFactory.getNumericPin(userid);
	      String textPin = userFactory.getTextPin(userid);
         %>
         <tr bgcolor=<%=row%2==0 ? "#ffffff" : "#cccccc"%>>
          <% if (!curUser.getUserId().equals("admin")) { %>
          <td width="5%" rowspan="2" align="center"> 
            <a id="<%= "users("+curUser.getUserId()+").doDelete" %>" href="javascript:deleteUser('<%=curUser.getUserId()%>')" onclick="return confirm('你确定要删除用户 <%=curUser.getUserId()%>?')"><img src="images/trash.gif" alt="<%="删除 " + curUser.getUserId()%>"></a> 
            
          </td>
          <% } else { %>
          <td width="5%" rowspan="2" align="center">
            <img id="<%= "users("+curUser.getUserId()+").doDelete" %>" src="images/trash.gif" alt="不能删除管理员用户">
          </td>
          <% } %>
          <td width="5%" rowspan="2" align="center">
            <a id="<%= "users("+curUser.getUserId()+").doModify" %>" href="javascript:modifyUser('<%=curUser.getUserId()%>')"><img src="images/modify.gif"></a>
          </td>
          <td width="5%" rowspan="2" align="center">
            <% if ( !curUser.getUserId().equals("admin")) { %>
                <input id="<%= "users("+curUser.getUserId()+").doRename" %>" type="button" name="rename" value="重命名" onclick="renameUser('<%=curUser.getUserId()%>')">
              <% } else { %>
                <input id="<%= "users("+curUser.getUserId()+").doRename" %>" type="button" name="rename" value="重命名" onclick="alert('抱歉，管理员用户不能更名。')">
              <% } %>
          </td>
          <td width="5%">
            <a id="<%= "users("+curUser.getUserId()+").doDetails" %>" href="javascript:detailUser('<%=curUser.getUserId()%>')"><%=curUser.getUserId()%></a>
          </td>
          <td width="15%">
           <div id="<%= "users("+curUser.getUserId()+").fullName" %>">
	    <% if(curUser.getFullName() != null){ %>
		    <%= (curUser.getFullName().equals("") ? "&nbsp;" : curUser.getFullName()) %>
	    <% } %>
	      </div>
          </td>
          <td width="15%">
            <div id="<%= "users("+curUser.getUserId()+").email" %>">
            <%= ((email == null || email.equals("")) ? "&nbsp;" : email) %>
            </div>
          </td>
          <td width="15%">
           <div id="<%= "users("+curUser.getUserId()+").pagerEmail" %>">
            <%= ((pagerEmail == null || pagerEmail.equals("")) ? "&nbsp;" : pagerEmail) %>
            </div>
          </td>
          <td width="15">
           <div id="<%= "users("+curUser.getUserId()+").xmppAddress" %>">
            <%= ((xmppAddress == null || xmppAddress.equals("")) ? "&nbsp;" : xmppAddress) %>
           </div>
          </td>
          <!--
          <td width="10%">
            <div id="<%= "users("+curUser.getUserId()+").numericService" %>">
            <%= ((numericService == null || numericService.equals("")) ? "&nbsp;" : numericService) %>
            </div>
          </td>
          <td width="10%">
            <div id="<%= "users("+curUser.getUserId()+").numericPin" %>">
            <%= ((numericPin == null || numericPin.equals("")) ? "&nbsp;" : numericPin) %>
            </div>
          </td>
          <td width="15%">
           <div id="<%= "users("+curUser.getUserId()+").textService" %>">
            <%= ((textService == null || textService.equals("")) ? "&nbsp;" : textService) %>
            </div>
          </td>
          <td width="15%">
           <div id="<%= "users("+curUser.getUserId()+").textPin" %>">
            <%= ((textPin == null || textPin.equals("")) ? "&nbsp;" : textPin) %>
           </div>
          </td>
          -->
          </tr>
          <tr bgcolor=<%=row%2==0 ? "#ffffff" : "#cccccc"%>>
            <td colspan="5">
             <div id="<%= "users("+curUser.getUserId()+").userComments" %>">
	      <% if(curUser.getUserComments() != null){ %>
		      <%= (curUser.getUserComments().equals("") ? "No Comments" : curUser.getUserComments()) %>
		   
	      <% } %>
	        </div>
            </td>
          </tr>
         <% row++;
            } %>
     </table>

</form>

<jsp:include page="/includes/footer.jsp" flush="false" />
