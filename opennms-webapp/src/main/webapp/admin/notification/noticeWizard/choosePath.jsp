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
		org.opennms.netmgt.config.notifications.*,
        org.opennms.netmgt.config.destinationPaths.*,
		org.opennms.netmgt.config.*
	"
%>

<%!
    public void init() throws ServletException {
        try {
            DestinationPathFactory.init();
        }
        catch( Exception e ) {
            throw new ServletException( "Cannot load configuration file", e );
        }
    }
%>

<%
    HttpSession user = request.getSession(true);
    Notification newNotice = (Notification)user.getAttribute("newNotice");
    Varbind varbind=newNotice.getVarbind();
    String varbindName="";
    String varbindValue="";
    if(varbind!=null) {
        
        if(varbind.getVbname()!=null) {
            varbindName=varbind.getVbname();
		}
        if(varbind.getVbvalue()!=null) {
         	varbindValue=varbind.getVbvalue();
        }
    }
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="选择路径" />
  <jsp:param name="headTitle" value="选择路径" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="选择路径" />
</jsp:include>

<script language="JAVASCRIPT" >
  
    function trimString(str) 
    {
        while (str.charAt(0)==" ")
        {
          str = str.substring(1);
        }
        while (str.charAt(str.length - 1)==" ")
        {
          str = str.substring(0, str.length - 1);
        }
        return str;
    }
    
    function finish()
    {
        trimmedName = trimString(document.info.name.value);
        trimmedText = trimString(document.info.textMsg.value);
        if (trimmedName=="")
        {
            alert("请输入这个通知的名称。");
        }
        else if (trimmedText=="")
        {
            alert("请输入此通知的文本信息。");
        }
        else if (document.info.path.selectedIndex==-1)
        {
            alert("请为此通知选择一个目的路径。");
        }
        else
        {
            document.info.submit();
        }
    }
  
</script>

<h2><%=(newNotice.getName()!=null ? "编辑通知: " + newNotice.getName() + "<br/>" : "")%></h2>

<h3>选择目的路径并输入发送通知的信息</h3>

<form method="post" name="info"
      action="admin/notification/noticeWizard/notificationWizard">
      <input type="hidden" name="userAction" value=""/>
      <input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_PATH%>"/>
      <table width="100%" cellspacing="2" cellpadding="2" border="0">
        <tr>
          <td width="10%" valign="top" align="left">
            名称:
          </td>
          <td valign="top" align="left">
            <input type="text" size="100" name="name" value='<%=(newNotice.getName()!=null ? newNotice.getName() : "")%>'/>
          </td>
        </tr>
        <tr>
          <td width="10%" valign="top" align="left">
            说明:
          </td>
          <td valign="top" align="left">
            <input type="text" size="100" name="description" value='<%=(newNotice.getDescription()!=null ? newNotice.getDescription() : "")%>'/>
          </td>
        </tr>
        <tr>
          <td width="10%" valign="top" align="left">
            参数:
          </td>
          <td valign="top" align="left">
            名称: <input type="text" size="30" name="varbindName" value='<%=varbindName%>'/>
			值: <input type="text" size="30" name="varbindValue" value='<%=varbindValue%>'/>
          </td>
        </tr>
        <tr>
          <td width="10%" valign="top" align="left">
            选择一个路径:
          </td>
          <td valign="top" align="left">
            <%=buildPathSelect(newNotice.getDestinationPath())%>
          </td>
         </tr>
         <tr>
          <td width="10%" valign="top" align="left">
            文本消息:
          </td>
          <td valign="top" align="left">
            <textarea rows="3" cols="100" name="textMsg"><%=(newNotice.getTextMessage()!=null ? newNotice.getTextMessage() : "")%></textarea>
          </td>
         </tr>
         <tr>
          <td width="10%" valign="top" align="left">
            短消息:
          </td>
          <td valign="top" align="left">
            <textarea rows="1" cols="100" name="numMsg"><%=(newNotice.getNumericMessage()!=null ? newNotice.getNumericMessage() : "")%></textarea>
          </td>
         </tr>
         <tr>
          <td width="10%" valign="top" align="left">
            电子邮件主题:
          </td>
          <td valign="top" align="left">
            <input type="text" size="100" name="subject" value='<%=(newNotice.getSubject()!=null ? newNotice.getSubject() : "")%>'/>
          </td>
         </tr>
         <tr>
          <td width="10%" valign="top" align="left">
            特殊值:
          </td>
          <td valign="top" align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="1">
              <tr>
                <td colspan="3">可以用在文本消息和电子邮件主题:</td>
              </tr>
              <tr>
                <td>%noticeid% = 通知ID号码</td>
                <td>%time% = 发送时间</td>
                <td>%severity% = 事件级别</td>                          
              </tr>
              <tr>
                <td>%nodelabel% = 可能是IP地址或空</td>
                <td>%interface% = IP地址，可能是空的</td>
                <td>%service% = 服务名称，可能是空的</td>
              </tr>
              <tr>
				<td>%eventid% = 事件ID，可能是空的</td>
				<td>%parm[a_parm_name]% = 命名的事件参数的值</td>
				<td>%parm[#N]% = 索引为N的事件参数的值</td>
			  </tr>
			  <tr>
			    <td>%ifalias% = 相关接口的SNMP接口别名</td>
			    <td>%interfaceresolve% = 接口IP地址的反向DNS名称</td>
               <td>%operinstruct% = 事件定义的操作说明</td>		     
			  </tr>
            </table>
          </td>
         </tr>
         
        <tr>
          <td colspan="2">
            <a HREF="javascript:finish()">完成</a>
          </td>
        </tr>
      </table>
      </form>

<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
    public String buildPathSelect(String currentPath)
      throws ServletException
    {
         StringBuffer buffer = new StringBuffer("<select NAME=\"path\">");
         
         Map<String, Path> pathsMap = null;
         
         try {
            pathsMap = new TreeMap<String, Path>(DestinationPathFactory.getInstance().getPaths());
         Iterator iterator = pathsMap.keySet().iterator();
         while(iterator.hasNext())
         { 
                 String key = (String)iterator.next();
                 if (key.equals(currentPath))
                 {
                    buffer.append("<option SELECTED VALUE=" + key + ">" + key + "</option>");
                 }
                 else
                 {
                    buffer.append("<option VALUE=" + key + ">" + key + "</option>");
                 }
            }
         } catch (Throwable e)
         {
            throw new ServletException("couldn't get destination path list.", e);
         }
         buffer.append("</select>");
         
         return buffer.toString();
    }
%>
