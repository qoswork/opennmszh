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
	import="java.util.Date"
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="通知" />
  <jsp:param name="headTitle" value="通知" />
  <jsp:param name="location" value="notification" />
  <jsp:param name="breadcrumb" value="通知" />
</jsp:include>

  <div class="TwoColLeft">
      <h3>通知查询</h3>
      <div class="boxWrapper">
        <form method="get" action="notification/browse">
          <p align="right">用户:
          <input type="text" name="user"/>
          <input type="submit" value="查询通知" /></p>
        </form>
        <form method="get" action="notification/detail.jsp" >
          <p align="right">通知:
          <input type="text" name="notice" />
          <input type="submit" value="查询详细" /></p>       
        </form>
        <ul class="plain">
          <li><a href="notification/browse?acktype=unack&filter=<%= java.net.URLEncoder.encode("user="+request.getRemoteUser()) %>">你的活动通知</a></li>
          <li><a href="notification/browse?acktype=unack">所有活动通知</a></li>
          <li><a href="notification/browse?acktype=ack">所有已确认通知</a></li>
        </ul>
      </div>
  </div>

  <div class="TwoColRight">
    <h3>活动和已确认通知</h3>
    <div class="boxWrapper">
      <p>当OpenNMS检测到重要的事件，用户可能会收到一个<em>通知</em>，一个描述性的信息会自动发送到寻呼机，电子邮件地址，或两者兼而有之。 
为了收到通知，用户必须在他们的用户配置文件中配置通知信息(需要你的管理员提供帮助)，
通知状态必须是<em>开启</em>(看此窗口的右上角)，并且必须收到重要的事件。
      </p>

      <p>从这个面板中，你可以:<strong>查看你的活动通知</strong>， 
        将显示发送到你用户ID的所有取消确认通知；
        <strong>查看所有活动通知</strong>，, 将显示所有用户的所有取消确认通知； 
        或 <strong>查看所有已确认通知</strong>， 
        将提供所有用户的已发送的和已确认所有通知。
      </p>

      <p>你也可以搜索与一个特定的用户ID相关联的通知 
        ，通过在<strong>查看用户通知</strong>的文本框中输入用户ID。
        最后，你可以快速跳转到给定通知标识的详细页面，通过在<strong>查询详细</strong>的文本框中输入数字标识。
        注意，这是特别有用的，如果你使用的是一个数字寻呼服务，并且收到通知数字标识。 
      </p>
    </div>
    <h3>通知上报</h3>
    <div class="boxWrapper">
        <p>一旦通知被发送，它就被认为是<em>活动</em>的，直到有人通过OpenNMS的通知接口<em>确认</em>。 
            如果触发通知的事件是有关管理的网络设备或系统，<strong>网络/系统</strong>组成员将被一个接一个的通知，并且发送间隔15分钟。 
            这个通知<em>上报</em>的过程，可能随时停止因为通知确认。
            注意，触发的通知和确认事件是不一样。 
            如果组里的所有成员都被通知并且通知没有被确认， 
            通知将被升级到<strong>管理</strong>组，该组的所有成员将被立即通知，没有15分钟的升级间隔。 
        </p>
      </div>
  </div>
  <hr />
<jsp:include page="/includes/footer.jsp" flush="false"/>
