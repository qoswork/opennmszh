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
  <jsp:param name="title" value="导入/导出资产" />
  <jsp:param name="headTitle" value="导入/导出" />
  <jsp:param name="headTitle" value="资产" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="导入/导出资产" />
</jsp:include>

<div class="TwoColLAdmin">
  <h3>导入和导出资产</h3>

  <p>
    <a href="admin/asset/import.jsp">导入资产</a>
  </p>

  <p>
    <a href="admin/asset/assets.csv">导出资产</a>
  </p>
</div>

<div class="TwoColRAdmin">
  <h3>导入资产信息</h3>

  <p>
    资产导入页面可以导入一个逗号分隔值的文件 (.csv)，
    (可以是从电子表格导出的)到资产数据库。
  </p>

  <h3>导出资产信息</h3>

  <p>
    所有节点的资产信息将被导出为一个逗号分隔值的文件(.csv)，可以适用于电子表格。 
  </p>
</div>

<jsp:include page="/includes/footer.jsp" flush="false" />
