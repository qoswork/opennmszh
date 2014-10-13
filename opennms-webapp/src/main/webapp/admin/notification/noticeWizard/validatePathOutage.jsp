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
		org.opennms.web.api.Util,
        org.opennms.netmgt.filter.FilterDaoFactory,
        org.opennms.netmgt.filter.FilterParseException
	"
%>


<%
   String newRule = request.getParameter("newRule");
   String criticalIp = request.getParameter("criticalIp");
   if (criticalIp == null) { criticalIp = ""; }
   String criticalSvc = request.getParameter("criticalSvc");
   String showNodes = request.getParameter("showNodes");
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="验证路径故障" />
  <jsp:param name="headTitle" value="验证路径故障" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/noticeWizard/buildPathOutage.jsp?newRule=IPADDR+IPLIKE+*.*.*.*&showNodes=on'>配置路径故障</a>" />
  <jsp:param name="breadcrumb" value="验证路径故障" />
</jsp:include>

<script type="text/javascript" >
  
  function next()
  {
      document.addresses.userAction.value="next";
      document.addresses.submit();
  }
  
  function rebuild()
  {
      document.addresses.userAction.value="rebuild";
      document.addresses.submit();
  }
  
</script>


<h3>
<% if (showNodes != null && showNodes.equals("on")) { %>
    检查下面的节点确定符合规则结果。
    如果不符合规则点击"重建"链接。
    如果符合规则点击"完成"链接。
<% } else { %>
    规则有效。点击"重建"链接修改规则或点击"完成"链接继续。
<% } %>
</h3>


      当前规则: <%=newRule%>
      <br/>关键路径IP地址 = <%=criticalIp%>
      <br/>关键路径服务 = <%=criticalSvc%>
      <br/>
      <br/>
      <form METHOD="POST" NAME="addresses" ACTION="admin/notification/noticeWizard/notificationWizard">
        <%=Util.makeHiddenTags(request)%>
        <input type="hidden" name="userAction" value=""/>
        <input type="hidden" name="newRule" value="<%=newRule%>"/>
        <input type="hidden" name="criticalIp" value="<%=criticalIp%>"/>
        <input type="hidden" name="criticalSvc" value="<%=criticalSvc%>"/>
        <input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_VALIDATE_PATH_OUTAGE%>"/>
        <% if (showNodes != null && showNodes.equals("on")) { %>
          <table width="50%" cellspacing="2" cellpadding="2" border="1">
            <tr bgcolor="#999999">
              <td>
                <b>节点ID</b>
              </td>
              <td>
                <b>节点名称</b>
              </td>
            </tr>
            <%=buildNodeTable(newRule)%>
          </table>
        <% } %>
        <br/><br/>
        <% if (criticalIp.equals("")) { %>
          <p style="color:red">你没有选择关键路径IP。
             点击"完成"将清除之前设置的关键路径。
             : <%= newRule %></p>
          <br/><br/>
        <% } %>
           <a HREF="javascript:rebuild()">&#139;&#139;&#139; 重建</a>&nbsp;&nbsp;&nbsp;
           <a HREF="javascript:next()">完成 &#155;&#155;&#155;</a>
      </form>

<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
  private String buildNodeTable(String rule)
      throws FilterParseException
  {
          StringBuffer buffer = new StringBuffer();
          SortedMap nodes = FilterDaoFactory.getInstance().getNodeMap(rule);
          Iterator i = nodes.keySet().iterator();
          while(i.hasNext())
          {
              Integer key = (Integer)i.next();
              buffer.append("<tr><td width=\"50%\" valign=\"top\">").append(key).append("</td>");
              buffer.append("<td width=\"50%\">");
              buffer.append(nodes.get(key));
              buffer.append("</td>");
              buffer.append("</tr>");
          }
          return buffer.toString();
  }
%>
