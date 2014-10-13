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
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="事件" />
  <jsp:param name="headTitle" value="事件" />
  <jsp:param name="location" value="event" />  
  <jsp:param name="breadcrumb" value="事件" />
</jsp:include>

  <div class="TwoColLeft">
      <h3>事件查询</h3>
      <div class="boxWrapper">
      <%--<jsp:include page="/includes/event-querypanel.jsp" flush="false" />--%>
			<form action="event/detail.jsp" method="get">
				<p align="right">事件ID:          
					<input type="text" name="id" />
					<input type="submit" value="查询"/></p>               
			</form>
			
			<ul class="plain">
				<li><a href="event/list" title="查看所有活动事件">所有事件</a></li>
				<li><a href="event/advsearch.jsp" title="更多高级查询和排序选项">高级查询</a></li>
			</ul>
		</div>
  </div>
      
  <div class="TwoColRight">
      <h3>活动和已确认事件</h3>
		<div class="boxWrapper">
      <p>事件可以从用户视图中 <em>确认</em>，或删除，选择需要 <em>确认</em> 的事件点击 <em>确认事件</em> 按钮。可以将确认事件的权限分配给有能力解决网络或系统相关问题的个人。事件如果没有确认将一直显示在所有用户的页面上并称为<em>活动</em>。
      </p>
            
      <p>如果事件被错误确认，你可以点击 <em>查看所有已确认事件</em> 链接，找到事件，并 <em>取消确认</em>，使它重新显示到所有用户视图中。 
      </p>
        
      <p>如果你有一个特殊的事件标识，并且要查看这个事件的详情，你可以通过 <em>ID查询事件</em> 功能查询出事件详情信息。
      </p>
		</div>
  </div>
	<hr />
<jsp:include page="/includes/footer.jsp" flush="false"/>
