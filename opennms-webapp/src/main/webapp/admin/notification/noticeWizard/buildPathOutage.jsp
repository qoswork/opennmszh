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
	import="org.opennms.web.admin.notification.noticeWizard.*"
%>

<%
    String newRule = request.getParameter("newRule");
    String criticalIp = request.getParameter("criticalIp");
    String showNodes = request.getParameter("showNodes");
    String returnTo = request.getParameter("returnTo");
%>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="配置路径故障" />
  <jsp:param name="headTitle" value="配置路径故障" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="配置路径故障" />
</jsp:include>

<script type="text/javascript" >

    function next()
    {
        document.crpth.nextPage.value="<%=NotificationWizardServlet.SOURCE_PAGE_VALIDATE_PATH_OUTAGE%>";
        document.crpth.submit();
    }
    
</script>

<form method="post" name="crpth"
      action="admin/notification/noticeWizard/notificationWizard" >
      
      
    <% String mode = request.getParameter("mode");
       if (mode != null && mode.endsWith("failed")) { %>
       
        <h3 style="color:red"><%=mode%>。 请检查输入的错误后重新提交。</h3>
              
    <% } %>

    <h3>定义关键路径</h3>

    输入关键路径IP地址。 (或保持为空，以清除之前设置的路径。)

    <br/><br/>

    <input type="text" name="criticalIp" value = '<%= (criticalIp != null ? criticalIp : "") %>' size="17" maxlength="15" />

    <br/><br/>

    关键路径服务:

    <br/><br/>

    <select name="criticalSvc" value="ICMP" size="1">
        <option value="ICMP">ICMP</option>
    </select>
      <input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_PATH_OUTAGE%>"/>
      <input type="hidden" name="nextPage" value=""/>
      <input type="hidden" name="returnTo" value="<%= returnTo%>"/>
    <h3>构建规则确定哪些节点将应用关键路径。</h3>
            <p>过滤TCP/IP地址允许你使用四个IP段进行灵活的方式查询。 星号'*'可以匹配所有值(1-255)。破折号'-'可以列出一个地址范围。 逗号','可以界定多个单一值。
            </p>
            <p>例如，下面的几个实例都代表相同的地址范围， 从 192.168.0.0 到 192.168.3.255:
	       </p>
               <ul>
                  <li>192.168.0-3.*
                  <li>192.168.0-3.0-255
                  <li>192.168.0,1,2,3.*
               </ul>
	    <p>使用如上所述的基于TCP/IP地址的规则，输入<br/><br/>
	       IPADDR IPLIKE *.*.*.*<br/><br/>在"当前规则"输入框中，替换为你所期望的地址子段。
	       <br/>另外，你可以输入任意有效的规则。
	    </p>
	    当前规则:<br/>
	    <input type="text" size=100 name="newRule" value="<%=newRule%>"/>
           <br/><br/>

	    显示匹配的节点列表::
            <% if (showNodes == null) { %>
            <input type="checkbox" name="showNodes" checked="true" >
            <% } else { %>
            <input type="checkbox" name="showNodes">
            <% } %>
           <br/>

           <br/>
            <input type="reset" value="重置"/>
           <br/><br/>
           <a href="javascript:next()">验证规则结果 &#155;&#155;&#155;</a>
    </form>

<jsp:include page="/includes/footer.jsp" flush="false" />

