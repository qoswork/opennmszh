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


<%@page import="org.opennms.core.resource.Vault"%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="报表" />
  <jsp:param name="headTitle" value="报表" />
  <jsp:param name="location" value="report" />
  <jsp:param name="breadcrumb" value="报表" />
</jsp:include>


  <div class="TwoColLeft">
    <h3>报表</h3>
    <div class="boxWrapper">
      <form action="graph/index.jsp" method="get">
        <p align="right">名称包含
        <input type="text" name="match" size="16" />
        <input type="submit" value="资源图"/></p>
      </form>
      <form action="KSC/index.htm" method="get">
        <p align="right">名称包含
        <input type="text" name="match" />
        <input type="submit" value="自定义报表"/></p>
      </form>
      <ul class="plain">
        <li><a href="graph/index.jsp">资源图</a></li>
        <li><a href="KSC/index.htm">自定义性能，节点，域</a></li>
        <li><a href="report/database/index.htm">数据库报表</a></li>
<% if ("true".equalsIgnoreCase(Vault.getProperty("opennms.rancidIntegrationEnabled"))) {%>
        <li><a href="inventory/rancidReport.htm">清单</a></li>
<% }%>
        <li><a href="statisticsReports/index.htm">统计报表</a></li>
      </ul>
    </div>
  <!-- more reports will follow -->
  </div>

  <div class="TwoColRight">
    <h3>说明</h3>
    <div class="boxWrapper">
      <p><b>资源图</b>提供了一个简单的方法，以可视化的方式查看关键SNMP，响应时间及其他从整个网络的管理节点采集的数据。
      </p>
      <p>你可能需要通过在"名称包含"字段输入查询字符串缩小选择资源。
          资源名称字符串匹配不区分大小写。
      </p>
      <p><b>SNMP自定义性能报表</b>，<b>节点报表</b>
          和<b>域报表</b>。自定义报表允许用户使用预定义的图表类型创建和查看SNMP性能数据。
          该报表在时间跨度和图类型上提供了极大的灵活性。
          自定义报表的配置允许用户指定一个报表名称并保存下来，以便将来查看。
          节点报表显示节点上的所有SNMP接口的SNMP数据。
          域报表显示一个域里的所有SNMP接口的SNMP数据。
          节点报表和域报表可以被加载到定制并保存为一个自定义报表。
      </p>
      <p>你可能需要通过在"名称包含"字段输入查询字符串缩小选择资源。
          资源名称字符串匹配不区分大小写。
      </p>

      <p><b>数据库报表</b>提供图形或数字务的服务水平指标显示，可以按照当月，上个月和最近12个月查看。
      </p>
      
<% if ("true".equalsIgnoreCase(Vault.getProperty("opennms.rancidIntegrationEnabled"))) {%>
      <p><b>Inventory Reports</b> provide html or XML report list of 
       nodes inventories and rancid devices matching at a specific date using
       a search matching criteria .
      </p>
<% } %> 
      <p><b>统计报表</b>提供定期对采集到的数值数据的统计报表(响应时间，SNMP性能数据等)。
      </p>
    </div>
  </div>
  <hr />
<jsp:include page="/includes/footer.jsp" flush="false"/>
