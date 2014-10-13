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
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="配置自动发现" />
  <jsp:param name="headTitle" value="自动发现" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="自动发现" />
</jsp:include>


<!-- Body -->

  <div class="TwoColLAdmin">
    <h3>自动发现</h3>
		<p>
			<a href="admin/discovery/modifyDiscoveryConfig">修改配置</a>
		</p>
  </div>
      
  	<div class="TwoColRAdmin">
      <h3>配置</h3>
        <p>在这里配置自动发现。
        在你添加，删除IP地址或范围后，你必需要保存配置并重新启动服务。
        </p>       
  </div>
  <hr />


<jsp:include page="/includes/footer.jsp" flush="false" />

