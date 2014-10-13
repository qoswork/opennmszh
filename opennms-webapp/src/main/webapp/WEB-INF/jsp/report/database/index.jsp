<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2009-2012 The OpenNMS Group, Inc.
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

<jsp:include page="/includes/header.jsp" flush="false">
  <jsp:param name="title" value="数据库报表" />
  <jsp:param name="headTitle" value="数据库报表" />
	<jsp:param name="breadcrumb"
		value="<a href='report/index.jsp'>报表</a>" />
	<jsp:param name="breadcrumb" value="数据库" />
</jsp:include>

  <div class="TwoColLeft">
    <h3>数据库报表</h3>
    <div class="boxWrapper">
      <ul class="plain">
        <li><a href="report/database/reportList.htm">报表列表</a></li>
        <li><a href="report/database/manage.htm">查看和管理执行报表</a></li>
        <li><a href="report/database/manageSchedule.htm">管理计划报表</a></li>
      </ul>
    </div>
  </div>

  <div class="TwoColRight">
    <h3>说明</h3>
    <div class="boxWrapper">
      <p>这些报表提供了图表、数字形式的指标数据的展示，包括月报表、上个月报表、上一年报表等。
      </p>
      
      <p>你可以查看或计划执行报表。
      你也能将执行的报表发送电子邮件。
      你也可以将这些报表保存到OpenNMS系统服务器上，以便稍后查看
      </p>
            
      <p>你可以将这些报表保存为HTML，PDF，SVG格式。你也可以删除不需要的报表。
      </p>
    </div>
  </div>
  <hr />
<jsp:include page="/includes/footer.jsp" flush="false"/>
