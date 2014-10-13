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
		java.sql.*,
		org.opennms.web.admin.notification.noticeWizard.*,
		org.opennms.netmgt.config.*,
		org.opennms.netmgt.config.notifications.*
	"
%>

<%
    HttpSession user = request.getSession(true);
    Notification newNotice = (Notification)user.getAttribute("newNotice");
    String newRule = request.getParameter("newRule");
%>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="建立规则" />
  <jsp:param name="headTitle" value="选择目标" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/noticeWizard/eventNotices.jsp'>事件通知</a>" />
  <jsp:param name="breadcrumb" value="建立规则" />
</jsp:include>

<script type="text/javascript" >

    function next()
    {
        document.rule.nextPage.value="<%=NotificationWizardServlet.SOURCE_PAGE_VALIDATE%>";
        document.rule.submit();
    }
    
    function skipVerification()
    {
        document.rule.nextPage.value="<%=NotificationWizardServlet.SOURCE_PAGE_PATH%>";
        document.rule.submit();
    }

</script>

    <h2><%=(newNotice.getName()!=null ? "编辑通知: " + newNotice.getName() + "<br/>" : "")%></h2>
    <h3><% String mode = request.getParameter("mode");
           if ("failed".equals(mode)) { %>
              <font color="FF0000">输入的规则是无效的，可能是由于一个违规的TCP/IP地址或无效的规则语法。请更正规则后继续。
		      </font>
           <% } else { %>
              建立通知规则取决于事件中包含的接口和服务信息。
           <% } %>
    </h3>
<form method="post" name="rule"
      action="admin/notification/noticeWizard/notificationWizard" >
      <input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_RULE%>"/>
      <input type="hidden" name="nextPage" value=""/>
      <table width="100%" cellspacing="2" cellpadding="2" border="0">
        <tr>
          <td valign="top" align="left">
            <p>TCP/IP地址过滤可以使用非常灵活的格式，允许你将一个TCP/IP地址分为特定四个八位字节(字段)来查询。
               星号'*'可以匹配所有值(1-255)。破折号'-'可以列出一个地址范围。逗号','可以界定多个单一值。
            </p>
            <p>例如，下面的几个实例都代表相同的地址范围，从 192.168.0.0 到 192.168.255.255。
            </p>
            
               <ul>
                  <li>192.168.0-3.*
                  <li>192.168.0-3.0-255
                  <li>192.168.0,1,2,3.*
               </ul>
	    <p>如上所述使用基于TCP/IP地址的规则，在下面的当前规则框输入<br/><br/>IPADDR IPLIKE *.*.*.*<br/><br/>将*.*.*.*替换为你希望的地址字段。<br/><br/>
	       <br/>另外，你可以输入任何有效的规则。
	    </p>
	    当前规则:<br/>
	    <input type="text" size=100 name="newRule" value="<%=newRule%>"/>
          </td>
        </tr>
        <tr>
          <td valign="top" align="left">
			<table>
				<tr>
					<td>
              			<p>选择你想结合前面TCP/IP地址过滤的每个服务。
               			   例如选择了HTTP和FTP，将匹配支持HTTP <b>或</b> FTP的TCP/IP地址。
             			</p>
             			服务:<br/><select size="10" multiple name="services"><%=buildServiceOptions(newRule)%></select>
          			</td>
          			<td valign="top" align="left">
              			<p>选择你想在与TCP/IP地址做NOT过滤的每个服务。选择多个项目，其中他们之间是与运算，例如选择了HTTP和FTP将匹配(不包含HTTP)和(不包含FTP)的事件。
              			</p>
              			不支持服务:<br/><select size="10" multiple name="notServices"><%=buildNotServiceOptions(newRule)%></select>
          			</td>
        		</tr>
			</table>
			</td>
		</tr>
        <tr>
          <td colspan="2">
            <input type="reset" value="重置地址和服务"/>
          </td>
        </tr>
        <tr>
          <td colspan="2">
           <a href="javascript:next()">验证规则的结果 &#155;&#155;&#155;</a>
          </td>
        </tr>
        <tr>
          <td colspan="2">
           <a href="javascript:skipVerification()">跳过验证结果 &#155;&#155;&#155;</a>
          </td>
        </tr>
      </table>
    </form>

<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
    public String buildServiceOptions(String rule)
        throws SQLException
    {
        List services = NotificationFactory.getInstance().getServiceNames();
        StringBuffer buffer = new StringBuffer();
        
        for (int i = 0; i < services.size(); i++)
        {
            int serviceIndex = rule.indexOf((String)services.get(i));
            //check for !is<service name>
            if (serviceIndex>0 && rule.charAt(serviceIndex-3) != '!')
            {
                buffer.append("<option selected VALUE='" + services.get(i) + "'>" + services.get(i) + "</option>");
            }
            else
            {
                buffer.append("<option VALUE='" + services.get(i) + "'>" + services.get(i) + "</option>");
            }
        }
        
        return buffer.toString();
    }

    public String buildNotServiceOptions(String rule)
        throws SQLException
    {
        List services = NotificationFactory.getInstance().getServiceNames();
        StringBuffer buffer = new StringBuffer();
        
        for (int i = 0; i < services.size(); i++)
        {
            //find services in the rule, but start looking after the first "!" (not), to avoid
            //the first service listing
            int serviceIndex = rule.indexOf((String)services.get(i), rule.indexOf("!"));
            //check for !is<service name>
            if (serviceIndex>0 && rule.charAt(serviceIndex-3) == '!')
            {
                buffer.append("<option selected VALUE='" + services.get(i) + "'>" + services.get(i) + "</option>");
            }
            else
            {
                buffer.append("<option VALUE='" + services.get(i) + "'>" + services.get(i) + "</option>");
            }
        }
        
        return buffer.toString();
    }

    public String getIpaddr(String rule)
        throws org.apache.regexp.RESyntaxException
    {
        org.apache.regexp.RE dirRegEx = null;
        dirRegEx = new org.apache.regexp.RE( ".+\\..+\\..+\\..+");
        
        if (dirRegEx == null)
        {
            return "*.*.*.*";
        }
        
        StringTokenizer tokens = new StringTokenizer(rule, " ");
        while(tokens.hasMoreTokens())
        {
            String nextToken = tokens.nextToken();
            if (dirRegEx.match( nextToken ))
            {
                return nextToken;
            }
        }
        
        return "*.*.*.*";
    }
%>
