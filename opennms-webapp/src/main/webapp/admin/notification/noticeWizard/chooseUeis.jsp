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
	import="
		java.io.*,
		java.util.*,
		org.opennms.web.admin.notification.noticeWizard.*,
		org.opennms.netmgt.config.*,
		org.opennms.netmgt.config.notifications.*,
		org.opennms.core.utils.BundleLists,
		org.opennms.core.utils.ConfigFileConstants,
		org.opennms.netmgt.xml.eventconf.Event,
		org.springframework.core.io.FileSystemResource
	"
%>

<%!
	private DefaultEventConfDao m_eventConfDao;

	public void init() throws ServletException {
		try {
			m_eventConfDao = new DefaultEventConfDao();
			m_eventConfDao.setConfigResource(new FileSystemResource(ConfigFileConstants.getFile(ConfigFileConstants.EVENT_CONF_FILE_NAME)));
			m_eventConfDao.afterPropertiesSet();
		} catch (Throwable e) {
			throw new ServletException("Cannot load configuration file", e);
		}
	}
%>

<%
    HttpSession user = request.getSession(true);
    Notification newNotice = (Notification)user.getAttribute("newNotice");
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="选择事件" />
  <jsp:param name="headTitle" value="选择事件" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/noticeWizard/eventNotices.jsp'>事件通知</a>" />
  <jsp:param name="breadcrumb" value="选择事件" />
</jsp:include>

<script type="text/javascript" src="js/jquery/jquery.js"></script>

<script type="text/javascript" >

    function next()
    {
        if (document.events.uei.selectedIndex==-1)
        {
            alert("请选择一个与此通知关联的UEI。");
        }
        else
        {
            document.events.submit();
        }
    }

$(document).ready(function() {

  $("select#uei").change(function(e) {
    var label = $(e.target.options[e.target.selectedIndex]).text();
    $('#regexp').prop('disabled', label !== 'REGEX_FIELD');
  });

  $('#regexp').change(function(e) {
    var value = e.target.value;
    if (!value.match("^~")) {
      alert("无效的正则表达式字段: [" + value + "]，值不能以 ~开头\n" +
        "重置值为默认。\n"
      );
      e.target.value = e.target.defaultValue;
      return false;
    }
    var uei = $('#uei')[0];
    $(uei.options[uei.selectedIndex]).val(value);
    uei.selectmenu('refresh');
  });
  if ($('#regexp').val() === '~^$') {
    $('#regexp').prop('disabled', true);
  }

});

</script>

<h2><%=(newNotice.getName()!=null ? "编辑通知:" + newNotice.getName() + "<br/>" : "")%></h2>

<h3>选择事件的UEI将触发此通知。</h3>

<form method="post" name="events"
      action="admin/notification/noticeWizard/notificationWizard" >
      <input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_UEIS%>"/>
      <table width="50%" cellspacing="2" cellpadding="2" border="0">
        <tr>
          <td valign="top" align="left">
            <h4>事件</h4>
            <select id="uei" NAME="uei" SIZE="20" >
             <%=buildEventSelect(newNotice)%>
            </select><br />
            正则表达式字段:
            <input id="regexp" name="regexp" type="text" size="96" value="<%=(newNotice.getUei()!=null ? newNotice.getUei() : "")%>" />
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <input type="reset"/>
          </td>
        </tr>
        <tr>
          <td colspan="2">
           <a HREF="javascript:next()">下一步 &#155;&#155;&#155;</a>
          </td>
        </tr>
      </table>
    </form>

<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
    public String buildEventSelect(Notification notice)
      throws IOException, FileNotFoundException
    {
        List events = m_eventConfDao.getEventsByLabel();
        StringBuffer buffer = new StringBuffer();

        if (notice.getUei() != null && notice.getUei().startsWith("~")) {
            buffer.append("<option selected value=\""+notice.getUei()+"\">REGEX_FIELD</option>\n");
        } else {
            buffer.append("<option value=\"~^$\">REGEX_FIELD</option>\n");
        }

        List excludeList = getExcludeList();
	TreeMap<String, String> sortedMap = new TreeMap<String, String>();

        Iterator i = events.iterator();

        while(i.hasNext()) //for (int i = 0; i < events.size(); i++)
        {
            Event e = (Event)i.next();
            String uei = e.getUei();
            //System.out.println(uei);

            String label = e.getEventLabel();
            //System.out.println(label);

            String trimmedUei = stripUei(uei);
            //System.out.println(trimmedUei);
            
            if (!excludeList.contains(trimmedUei)) {
		sortedMap.put(label,uei);
            }
	}
	i=sortedMap.keySet().iterator();
	while(i.hasNext()) {
		String label=(String)i.next();
		String uei=(String)sortedMap.get(label);
		if (uei.equals(notice.getUei())) {
			buffer.append("<option selected VALUE=" + uei + ">" + label + "</option>");
		} else {
			buffer.append("<option value=" + uei + ">" + label + "</option>");
		}
        }
        
        return buffer.toString();
    }
    
    public String stripUei(String uei)
    {
        String leftover = uei;
        
        for (int i = 0; i < 3; i++)
        {
            leftover = leftover.substring(leftover.indexOf('/')+1);
        }
        
        return leftover;
     }
     
     public List getExcludeList()
      throws IOException, FileNotFoundException
     {
        List<String> excludes = new ArrayList<String>();
        
        Properties excludeProperties = new Properties();
	excludeProperties.load( new FileInputStream( ConfigFileConstants.getFile(ConfigFileConstants.EXCLUDE_UEI_FILE_NAME )));
        String[] ueis = BundleLists.parseBundleList( excludeProperties.getProperty( "excludes" ));
        
        for (int i = 0; i < ueis.length; i++)
        {
            excludes.add(ueis[i]);
        }
        
        return excludes;
     }
%>
