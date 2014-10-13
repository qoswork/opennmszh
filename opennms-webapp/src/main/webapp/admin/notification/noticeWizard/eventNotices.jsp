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
	import="java.util.*,
		org.opennms.web.admin.notification.noticeWizard.*,
		org.opennms.netmgt.config.*,
		org.opennms.netmgt.config.notifications.*,
		org.opennms.core.utils.ConfigFileConstants,
		org.springframework.core.io.FileSystemResource
	"
%>

<%!
	private DefaultEventConfDao m_eventconfFactory;
	private NotificationFactory m_notificationFactory;

	public void init() throws ServletException {
		try {
			NotificationFactory.init();
		} catch (Throwable t) {
			throw new ServletException("Could not initialize NotificationFactory: " + t.getMessage(), t);
		}

		try {
			m_eventconfFactory = new DefaultEventConfDao();
			m_eventconfFactory.setConfigResource(new FileSystemResource(ConfigFileConstants.getFile(ConfigFileConstants.EVENT_CONF_FILE_NAME)));
			m_eventconfFactory.afterPropertiesSet();
		} catch (Throwable e) {
			throw new ServletException("Cannot load configuration file", e);
		}

		m_notificationFactory = NotificationFactory.getInstance();
	}
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="事件通知" />
  <jsp:param name="headTitle" value="事件通知" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="事件通知" />
</jsp:include>

<script type="text/javascript" >

    function editNotice(name)
    {
        document.notices.userAction.value="edit";
        document.notices.notice.value=name;
        document.notices.submit();
    }
    
    function deleteNotice(name)
    {
        if (confirm("你确定要删除通知 " + name + "?"))
        {
          document.notices.userAction.value="delete";
          document.notices.notice.value=name;
          document.notices.submit();
        }
    }
    
    function setStatus(name, status)
    {
        document.notices.userAction.value=status;
        document.notices.notice.value=name;
        document.notices.submit();
    }
    
    function newNotice()
    {
        document.notices.userAction.value="new";
        document.notices.submit();
    }
    
</script>

<h2>事件通知</h2>


<h3>添加一个事件通知，或编辑现有的事件通知</h3>
<form method="post" name="notices" action="admin/notification/noticeWizard/notificationWizard">
  <input type="hidden" name="userAction" value=""/>
  <input type="hidden" name="notice" value=""/>
  <input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_NOTICES%>"/>
  <table>
    <tr>
      <td> <input type="button" value="添加新事件通知" onclick="javascript:newNotice()"/>
    </tr>
    <tr>
      <td valign="top">
        <h4>事件通知</h4>
        <table width="100%" cellspacing="2" cellpadding="2" border="1">
          <tr bgcolor="#999999">
            <td colspan="3">
              <b>操作</b>
            </td>
            <td>
              <b>通知</b>
            </td>
            <td>
              <b>事件</b>
            </td>
            <td>
              <b>UEI</b>
            </td>
          </tr>
          <% Map<String, Notification> noticeMap = new TreeMap<String, Notification>(m_notificationFactory.getNotifications());
             for(String key : noticeMap.keySet()) {
               Notification curNotif = (Notification)noticeMap.get(key);
               String ekey = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(key);
          %>
          <tr>
            <td>
              <input type="button" value="编辑" onclick="javascript:editNotice('<%=ekey%>')"/>
            </td>
            <td>
              <input type="button" value="删除"  onclick="javascript:deleteNotice('<%=ekey%>')"/>
            </td>
            <td>
              <%if (curNotif.getStatus().equals("on")) { %>
                <input type="radio" value="Off" onclick="javascript:setStatus('<%=ekey%>','off')"/>关闭
                <input type="radio" value="On" CHECKED onclick="javascript:setStatus('<%=ekey%>','on')"/>开启
              <% } else { %>
                <input type="radio" value="Off" CHECKED onclick="javascript:setStatus('<%=ekey%>','off')"/>关闭
                <input type="radio" value="On" onclick="javascript:setStatus('<%=ekey%>','on')"/>开启
              <% } %>
            </td>
            <td>
              <%=key%>
            </td>
            <td>
              <%=m_eventconfFactory.getEventLabel(curNotif.getUei())%>
            </td>
            <td>
              <% if (curNotif.getUei().startsWith("~")) { %>REGEX: <%=curNotif.getUei().substring(1)%><% } else { %><%=curNotif.getUei()%><% } %>
            </td>
          </tr>
          <% } %>
        </table>
      </td>
    </tr>
  </table>
</form>

<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
  public String stripUei(String uei)
    {
        String leftover = uei;
        
        for (int i = 0; i < 3; i++)
        {
            leftover = leftover.substring(leftover.indexOf('/')+1);
        }
        
        return leftover;
     }
%>
