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
	import="java.lang.*"
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="配置通知" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="配置通知" />
</jsp:include>

<h3>配置通知</h3>

<div class="TwoColLAdmin">
  <p>
    <a href="admin/notification/noticeWizard/eventNotices.jsp">配置事件通知</a>
  </p>

  <p>
    <a href="admin/notification/destinationPaths.jsp">配置目标路径</a>
  </p>

  <p>
    <a href="admin/notification/noticeWizard/buildPathOutage.jsp?newRule=IPADDR+IPLIKE+*.*.*.*&showNodes=on">配置路径故障</a>
  </p>
</div>

<div class="TwoColRAdmin">
  <h3>事件通知</h3>

  <p>
    每个事件都可以被配置为每当该事件被触发时，发送一个通知。
    该向导将引导你完成所需的步骤，配置事件发送通知。
  </p>

  <h3>目标路径</h3>

  <p>
    目标路径描述了哪些用户或组将收到通知，如果需要上报，通知将如何被发送的，通知给谁。
    该向导将引导你通过建立一个可重用的名单，与谁联系，以及如何与他们联系，这是用在事件配置里。
  </p>

  <h3>路径故障</h3>

  <p>
    配置的路径故障，包括选择一个IP地址/服务IP地址/服务对，来定义的关键路径的一组节点。
    当一个节点出现Down状态,并且是组中的一个节点，关键路径将接受测试。
    如果没有响应，节点Down的通知将被抑制。
    关键路径的服务通常是ICMP，并且当前，ICMP是唯一关键路径支持的服务。
  </p>
</div>

<jsp:include page="/includes/footer.jsp" flush="false" />
