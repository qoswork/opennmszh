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
	import="org.opennms.web.admin.notification.noticeWizard.*,
	org.opennms.web.api.Util"
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="门限组" />
	<jsp:param name="headTitle" value="编辑组" />
	<jsp:param name="headTitle" value="门限" />
	<jsp:param name="headTitle" value="管理" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
    <jsp:param name="breadcrumb" value="<a href='admin/thresholds/index.jsp'>门限组</a>" />
    <jsp:param name="breadcrumb" value="编辑组" />
</jsp:include>

<script type="text/javascript">
    function submitNewNotificationForm(uei) {
    	document.getElementById("uei").value=uei;
    	document.add_notification_form.submit();
    }
</script>

	  <!-- hidden form for adding a new Notification -->
	  <form action="admin/notification/noticeWizard/notificationWizard" method="post" name="add_notification_form">
	  	<input type="hidden" name="sourcePage" value="<%=NotificationWizardServlet.SOURCE_PAGE_OTHER_WEBUI%>" />
	  	<input type="hidden" id="uei" name="uei" value="" /> <!-- Set by java script -->
	  	<input type="hidden" name="returnPage" value="<%=Util.calculateUrlBase(request)%>admin/thresholds/index.htm?groupName=${group.name}&editGroup" />
	  </form>

<h3>编辑组 ${group.name}</h3>

<form action="admin/thresholds/index.htm" method="post">
  <h2>基本门限</h2>
  <table class="normal">
    <tr>
        <th class="standardheader">类型</th>
        <th class="standardheader">说明</th>
        <th class="standardheader">数据源</th>
        <th class="standardheader">数据源类型</th>
        <th class="standardheader">数据源名称</th>
        <th class="standardheader">门限值</th>
        <th class="standardheader">恢复值</th>
        <th class="standardheader">触发</th>
        <th class="standardheader">触发UEI</th>
        <th class="standardheader">恢复UEI</th>
        <th class="standardheader">&nbsp;</th>
        <th class="standardheader">&nbsp;</th>
    </tr>
    <c:forEach items="${group.threshold}" varStatus="thresholdIndex" var="threshold">
        <tr>
			<td class="standard">${threshold.type}</td>
			<td class="standard">${threshold.description}</td>
			<td class="standard">${threshold.dsName}</td>
			<td class="standard">${threshold.dsType}</td>
			<td class="standard">${threshold.dsLabel}</td>
			<td class="standard">${threshold.value}</td>
			<td class="standard">${threshold.rearm}</td>
			<td class="standard">${threshold.trigger}</td>
			<td class="standard"><a href="javascript: void submitNewNotificationForm('${threshold.triggeredUEI}');" title="编辑此UEI的通知">${threshold.triggeredUEI}</a></td>
			<td class="standard"><a href="javascript: void submitNewNotificationForm('${threshold.rearmedUEI}');" title="编辑此UEI的通知">${threshold.rearmedUEI}</a></td>
			<td class="standard"><a href="admin/thresholds/index.htm?groupName=${group.name}&thresholdIndex=${thresholdIndex.index}&editThreshold">编辑</a></td>
			<td class="standard"><a href="admin/thresholds/index.htm?groupName=${group.name}&thresholdIndex=${thresholdIndex.index}&deleteThreshold">删除</a></td>
        </tr>
    </c:forEach>
  </table>
  <a href="admin/thresholds/index.htm?groupName=${group.name}&newThreshold">创建新门限</a>
  <br/><br/>
  <h2>基于表达式的门限</h2>
  <table class="normal">
    <tr>
        <th class="standardheader">类型</th>
        <th class="standardheader">说明</th>
        <th class="standardheader">表达式</th>
        <th class="standardheader">数据源类型</th>
        <th class="standardheader">数据源名称</th>
        <th class="standardheader">门限值</th>
        <th class="standardheader">恢复值</th>
        <th class="standardheader">触发</th>
		<th class="standardheader">触发UEI</th>
        <th class="standardheader">恢复UEI</th>
        <th class="standardheader">&nbsp;</th>
        <th class="standardheader">&nbsp;</th>
    </tr>
      <c:forEach items="${group.expression}" varStatus="expressionIndex" var="expression">
        <tr>
			<td class="standard">${expression.type}</td>
			<td class="standard">${expression.description}</td>
			<td class="standard">${expression.expression}</td>
			<td class="standard">${expression.dsType}</td>
			<td class="standard">${expression.dsLabel}</td>
			<td class="standard">${expression.value}</td>
			<td class="standard">${expression.rearm}</td>
			<td class="standard">${expression.trigger}</td>
			<td class="standard"><a href="javascript: void submitNewNotificationForm('${expression.triggeredUEI}');" title="编辑此UEI的通知">${expression.triggeredUEI}</a></td>
			<td class="standard"><a href="javascript: void submitNewNotificationForm('${expression.rearmedUEI}');" title="编辑此UEI的通知">${expression.rearmedUEI}</a></td>
			<td class="standard"><a href="admin/thresholds/index.htm?groupName=${group.name}&expressionIndex=${expressionIndex.index}&editExpression">编辑</a></td>
			<td class="standard"><a href="admin/thresholds/index.htm?groupName=${group.name}&expressionIndex=${expressionIndex.index}&deleteExpression">删除</a></td>
        </tr>
    </c:forEach>
    </table>
    <a href="admin/thresholds/index.htm?groupName=${group.name}&newExpression">创建新的基于表达式的门限</a>
</form>
<h3>帮助</h3>
<p>
上半部分是基本的门限(门限在一个单一的数据源。所显示的编辑门限的详细信息，请点击"编辑"链接在同一行上的临界线。  
要删除门限，点击你要删除的门限在同一行上的"删除"。<br/>
要创建一个新的门限，点击"创建新门限"链路<br/>
下面部分是基于表达式的门限，被检查的值是一个数学表达式，包括一个或多个数据源。功能和基本门限部分是相同的
<br/>
如果你有一个自定义UEI触发或恢复的门限，那么这将是一个超链接。点击该链路，是该UEI的通知向导，让你看到这个UEI现有的通知，并有可能为该UEI创建一个新的通知。
</p>
<jsp:include page="/includes/footer.jsp" flush="false"/>
