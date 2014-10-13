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
	import="org.springframework.web.context.WebApplicationContext,
        org.springframework.web.context.support.WebApplicationContextUtils,
        org.opennms.core.soa.ServiceRegistry,
        org.opennms.web.navigate.PageNavEntry,
        java.util.Collection"
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="告警" />
  <jsp:param name="headTitle" value="告警" />
  <jsp:param name="location" value="alarm" />  
  <jsp:param name="breadcrumb" value="告警" />
</jsp:include>

  <div class="TwoColLeft">
      <h3>告警查询</h3>
      <div class="boxWrapper">
       <%-- <jsp:include page="/includes/alarm-querypanel.jsp" flush="false" />--%>
        <form action="alarm/detail.htm" method="get">
          <p align="right">告警ID:          
            <input type="TEXT" NAME="id" />
            <input type="submit" value="查询"/></p>                
        </form>
        <ul class="plain">
          <li><a href="alarm/list.htm" title="查看基本的活动告警">所有告警 (主要信息)</a></li>
          <li><a href="alarm/list.htm?display=long" title="查看详细的活动告警">所有告警 (详细信息)</a></li>
          <li><a href="alarm/advsearch.jsp" title="更多高级查询和排序选项">高级查询</a></li>
          <%=getAlarmPageNavItems() %>
        </ul>  
      </div>
  </div>

  <div class="TwoColRight">
    <h3>活动和已确认告警</h3>
    <div class="boxWrapper">
      <p>告警可以被 <em>确认</em>，或删除从所有用户的默认视图，选中需要 <em>确认</em> 的告警然后点击 <em>确认告警</em> 按钮。
        可以将确认告警的权限分配给有能力解决网络或系统相关问题的人。告警如果没有确认将一直显示在所有用户的页面上并称为<em>活动告警</em>。
      </p>
            
      <p>要想查看已确认告警，进入 <em>所有告警</em> (<em>主要</em> 或 <em>详情</em>) 列表，然后点击 <em>"活动告警"</em>查询条件旁边的减号 "-"。
      </p>

      <p>如果告警被误确认，你可以通过 <em>查看所有已确认告警</em> 链接，找到告警，并 <em>取消确认</em> 它，使它重新显示到所有用户视图中。
      </p>
        
      <p>如果你有一个特殊的告警标识，并且要查看这个告警的详情，你可以通过 <em>ID查询告警</em> 功能查询出告警详情信息。
      </p>
    </div>
  </div>
  <hr />
<jsp:include page="/includes/footer.jsp" flush="false"/>

<%!
    protected String getAlarmPageNavItems(){
        String retVal = "";
        WebApplicationContext webappContext = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());
        ServiceRegistry registry = webappContext.getBean(ServiceRegistry.class);
        Collection<PageNavEntry> navEntries = registry.findProviders(PageNavEntry.class, "(Page=alarms)");
        
        for(PageNavEntry navEntry : navEntries){
            retVal += "<li><a href=\"" + navEntry.getUrl() + "\" >" + navEntry.getName() + "</a></li>";
        }
        
        return retVal;
    }

%>
