<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2006-2014 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2014 The OpenNMS Group, Inc.
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
	import="org.opennms.core.utils.WebSecurityUtils,
			org.opennms.web.element.*,
			org.opennms.netmgt.model.OnmsNode,
			org.opennms.web.servlet.MissingParameterException"
%>

<%
    int nodeId = -1;
    
    String nodeIdString = request.getParameter("node");

    if (nodeIdString == null) {
        throw new MissingParameterException("node");
    }
    try {
        nodeId = WebSecurityUtils.safeParseInt(nodeIdString);
    } catch (NumberFormatException numE) {
        throw new ServletException(numE);
    }

    if (nodeId < -1) {
        throw new ServletException("Invalid node ID.");
    }
        
    //get the database node info
    OnmsNode node_db = NetworkElementFactory.getInstance(getServletContext()).getNode(nodeId);
    if (node_db == null) {
        // XXX handle this WAY better, very awful
        throw new ServletException("No such node in database");
    }
    
    boolean isRequisitioned = (node_db.getForeignSource() != null && node_db.getForeignSource().length() != 0);
%>

<%@page import="org.opennms.core.resource.Vault"%>
<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="节点管理" />
  <jsp:param name="headTitle" value="节点管理" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="nodemanagement" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="节点管理" />
</jsp:include>

<script type="text/javascript" >

  function getInterfacesPost()
  {
      document.getInterfaces.submit();
  }
</script>

<form method="post" name="getInterfaces"
      action="admin/nodemanagement/getInterfaces">
  <input name="node" value="<%=nodeId%>" type="hidden"/>
</form>

<h2>节点:<%=node_db.getLabel()%> (ID: <%=node_db.getId()%>)</h2>
<% if (isRequisitioned) { %>
<h2><em>创建通过设备配置导入 <strong><%=node_db.getForeignSource()%></strong> (设备配置导入ID: <strong><%=node_db.getForeignId()%></strong>)</em></h2>
<% } else { %>
<h2><em>不是设备配置导入的成员</em></h2>
<% } %>

<div class="TwoColLAdmin">
  <h3>管理选项</h3>

  <% if (!isRequisitioned) { %>
  <p>
    <a href="admin/nodelabel.jsp?node=<%=nodeId%>">修改节点名称</a>
  </p>
  <% } %>

  <p>
    <a href="javascript:getInterfacesPost()">管理接口和服务
    </a>
  </p>

  <p>
    <a href="admin/snmpGetInterfaces?node=<%=nodeId%>&nodelabel=<%=node_db.getLabel()%>">
    配置接口SNMP数据采集</a>
  </p>

  <% if (!isRequisitioned) { %>
  <p>
    <a href="admin/nodemanagement/deletenode.jsp?node=<%=nodeId%>">删除节点
    </a>
  </p>
  <% } %>

  <p>
    <a href="admin/nodemanagement/setPathOutage.jsp?node=<%=nodeId%>">
    配置路径故障</a>
  </p>
  
      <% if ("true".equalsIgnoreCase(Vault.getProperty("opennms.rancidIntegrationEnabled"))) { %>
  <p>
    <a href="admin/rancid/rancidAdmin.htm?node=<%=nodeId%>">
    配置Rancid Integration</a>
  
  </p>

  <p>
    <a href="admin/storage/storageAdmin.htm?node=<%=nodeId%>">
    配置软件图片</a>
  </p>

  <% } %>
</div>
      
<div class="TwoColRAdmin">

  <h3>选项说明</h3>

  <% if (!isRequisitioned) { %>
  <p>
    <b>修改节点名称</b> 允许管理员指定一个节点名称，或让系统自动选择节点的名称。
  </p>
  <% } %>

  <p>
    <b>配置接口和服务</b>允许您更改你的OpenNMS的配置，随着网络变化。
    当OpenNMS首次启动，在网络中的节点，接口，和服务服务会<em>自动发现</em>或通过一个或多个的<em>设备配置导入</em>添加。随着网络的增长和变化，你要管理的TCP/IP范围，以及在这些范围内的接口和服务可能会修改。对于设备配置导入的节点，最好是修改设备配置导入，而不是修改以下选项。当有大量的节点管理时，最好通过灵活的设备配置导入来自动管理。
  </p>

  <p>
    <b>管理SNMP接口数据采集</b>允许你配置非IP接口的SNMP数据采集。
    对于小范围的网络，可通过这里进行配置。如果是大范围的改变，应该通过灵活修改设备配置导入来实现。
  </p>
        
  <p>
    <% if (!isRequisitioned) { %>
    <b>删除节点</b>允许你从数据库中永久删除当前节点。
    <% } %>
  </p>
        
  <p>
    <b>配置路径故障</b> 设置关键路径和服务来进行测试，当发送节点Down通知之前。
  </p>
  
  <% if (isRequisitioned) { %>
  <p>
    <b>To delete this node or change its label</b>, either directly edit the
    &quot;<em><%=node_db.getForeignSource() %></em>&quot; requisition and synchronize it or,
    if that requisition is automatically generated by an integration process,
    contact your OpenNMS administrator for assistance.
  </p>
  <% } %>
  
        <% if ("true".equalsIgnoreCase(Vault.getProperty("opennms.rancidIntegrationEnabled"))) { %>
  <p>
    <b>Configure Rancid</b> Configure RANCID group router.db files and rancid cloginrc
     authentication data.
  </p>

  <p>
    <b>配置软件图片</b> 添加和删除软件图片。
  </p>

  <% } %>
  
</div>

<jsp:include page="/includes/footer.jsp" flush="false"/>
