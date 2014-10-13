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
  <jsp:param name="title" value="高级事件查询" />
  <jsp:param name="headTitle" value="高级查询" />
  <jsp:param name="headTitle" value="事件" />
  <jsp:param name="breadcrumb" value="<a href='event/index.jsp'>事件</a>" />
  <jsp:param name="breadcrumb" value="高级事件查询" />
</jsp:include>

  <div id="contentleft">
      <h3>高级事件查询</h3>

      <jsp:include page="/includes/event-advquerypanel.jsp" flush="false" />
  </div> <!-- id="contentleft" -->

  <div id="contentright">
      <h3>查询说明</h3>

      <p><strong>高级事件查询</strong> 页面可以根据事件的多个字段进行查询。填写你希望用来缩小搜索范围的字段。
      </p>

      <p>根据事件产生时间查询事件，首先选中时间框，然后填写时间字段。
      </p>

      <p>如果你想选择一个特定时间跨度内的事件，同时选中开始和结束<em>两个</em>范围框。
      </p>
  </div> <!-- id="contentright" -->

<jsp:include page="/includes/footer.jsp" flush="false" />
