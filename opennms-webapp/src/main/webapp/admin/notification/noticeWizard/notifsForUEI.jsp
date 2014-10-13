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
	import="java.util.*,
		org.opennms.web.admin.notification.noticeWizard.*,
		org.opennms.netmgt.config.*,
		org.opennms.netmgt.config.notifications.*
	"
%>

<%!
    public void init() throws ServletException {
        try {
            NotificationFactory.init();
        }
        catch( Exception e ) {
            throw new ServletException( "Cannot load configuration file", e );
        }
    }
%>

<%
    HttpSession user = request.getSession(true);
	String uei=request.getParameter("uei");
	Map<String, Notification> allNotifications=NotificationFactory.getInstance().getNotifications();
	List<Notification> notifsForUEI=new ArrayList<Notification>();
	for(String key : allNotifications.keySet()) {
	    Notification notif=allNotifications.get(key);
		if(notif.getUei().equals(uei)) {
		    notifsForUEI.add(notif);
		}
	}
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="选择事件" />
  <jsp:param name="headTitle" value="选择事件" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/noticeWizard/eventNotices.jsp'>事件通知</a>" />
  <jsp:param name="breadcrumb" value="UEI已添加的通知" />
</jsp:include>

<script type="text/javascript" >

    function next()
    {
        if (document.events.uei.selectedIndex==-1)
        {
            alert("请选择一个UEI关联到这个通知");
        }
        else
        {
            document.events.submit();
        }
    }
	function submitEditForm(noticeName) {
		document.getElementById("notice").value=noticeName;
		document.editForm.submit();
	}

</script>
<!-- Hidden form that will cause the notification to be edited -->
<form action="admin/notification/noticeWizard/notificationWizard"  method="post" name="editForm">
	<input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_NOTIFS_FOR_UEI%>"/>
	<input type="hidden" name="userAction" value="edit"/>
	<input type="hidden" id="notice" name="notice" value=""/>
</form>

<form action="admin/notification/noticeWizard/notificationWizard"  method="post" name="newNotificationForm">
	<input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_NOTIFS_FOR_UEI%>"/>
	<input type="hidden" name="userAction" value="new"/>
	<input type="hidden" name="uei" value="<%=uei%>"/>
</form>

<h2>此UEI已添加的通知 <%=uei%></h2>
      <table width="50%" cellspacing="2" cellpadding="2" border="0">
      	 <tr><th>名称</th><th>说明</th><th>规则</th><th>目标路径</th><th>变量</th><th>操作</th></tr>
      <% for(Notification notif : notifsForUEI) { 
          	String varbindDescription="";
          	Varbind varbind=notif.getVarbind();
          	if(varbind!=null) {
          		varbindDescription=varbind.getVbname()+"="+varbind.getVbvalue();
          	}
      		%>
	        <tr>
	        	<td><%=notif.getName()%></td>
	        	<td><%=notif.getDescription()!=null?notif.getDescription():""%></td>
	        	<td><%=notif.getRule()%></td>
	        	<td><%=notif.getDestinationPath()%></td>
	        	<td><%=varbindDescription%></td>
	        	<td><a href="javascript: void submitEditForm('<%=notif.getName()%>');">Edit</a></td>
			</tr>
<% } %>
		<tr><td colspan="6"><a href="javascript: document.newNotificationForm.submit()">新建通知</a></td></tr>
      </table>
<jsp:include page="/includes/footer.jsp" flush="false" />
