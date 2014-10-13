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

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags/tree" prefix="tree" %>
<%@ taglib tagdir="/WEB-INF/tags/springx" prefix="springx" %>

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="设备配置导入" /> 
	<jsp:param name="headTitle" value="设备配置导入" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb" value="<a href='admin/provisioningGroups.htm'>设备配置导入</a>" />
	<jsp:param name="breadcrumb" value="编辑导入" />
</jsp:include>

<h3>导入节点组: ${fn:escapeXml(nodeEditForm.groupName)}</h3>

 <tree:form commandName="nodeEditForm"> 

  <input type="hidden" id="groupName" name="groupName" value="${fn:escapeXml(nodeEditForm.groupName)}"/> 
 
 <p>
 <c:choose>
  <c:when test="${freeFormEditing == true}">
   编辑服务和分类名称为开启。 <tree:action label="[关闭?]" action="toggleFreeForm" />
  </c:when>
  <c:otherwise>
   编辑服务和分类名称为关闭。 <tree:action label="[开启?]" action="toggleFreeForm" />
  </c:otherwise>
 </c:choose>
 </p>
 <tree:actionButton label="完成" action="done" />
 <tree:actionButton label="添加节点" action="addNode"/> 

  <!-- FIXME: I have no idea how to get the errors from BindException.reject() to bubble up to here -->

  <tree:tree root="${nodeEditForm.formData}" childProperty="node" var="node" varStatus="nodeIter">
    <!-- Form for editing node fields -->
    <tree:nodeForm>

      <tree:field label="节点" property="nodeLabel" size="48" />
      <tree:field label="外源ID" property="foreignId" />
      <tree:field label="站点" property="building" />
      <tree:action label="[添加接口]" action="addInterface" />
      <tree:action label="[添加节点分类]" action="addCategory" />
      <tree:action label="[添加节点资产]" action="addAssetField" />
      <br/>
      <label>父关系(路径故障):</label>
      <br/>
      <tree:field label="外源" property="parentForeignSource" />
      <tree:field label="外源ID" property="parentForeignId" />
      <tree:field label="节点名称" property="parentNodeLabel" />

    </tree:nodeForm> 
    
    <!--  Tree of interface under the node -->
    <tree:tree root="${node}" childProperty="interface" var="ipInterface" varStatus="ipIter">
    
      <!-- Form for editing an interface -->
      <tree:nodeForm>
        <tree:field label="IP接口" property="ipAddr" size="36"/>
        <tree:field label="说明" property="descr" />
        
        <tree:select label="状态" property="status" items="${statusChoices}" fieldSize="1"/>
        <tree:select label="SNMP主接口" property="snmpPrimary" items="${snmpPrimaryChoices}" fieldSize="1" />
        <tree:action label="添加服务" action="addService" />
      </tree:nodeForm>

      <!-- Tree of services under the interface -->
      <tree:tree root="${ipInterface}" childProperty="monitoredService" var="svc" varStatus="svcIter">
      
        <!--  Form for editing a service -->
        <tree:nodeForm>  
            <c:choose>
              <c:when test="${freeFormEditing == true}">
                <tree:field label="服务" property="serviceName" size="48" />
              </c:when>
              <c:otherwise>
                <tree:select label="服务" property="serviceName" items="${services}" />
              </c:otherwise>
            </c:choose>
        </tree:nodeForm>
      </tree:tree>

    </tree:tree>
    
    <!--  Tree of categories for a node -->
    <tree:tree root="${node}" childProperty="category" var="category" varStatus="catIter">
    
      <!--  Form for editing a category -->
      <tree:nodeForm>
        <c:choose>
          <c:when test="${freeFormEditing == true}">
            <tree:field label="节点分类" property="name" size="48" />
          </c:when>
          <c:otherwise>
            <tree:select label="节点分类" property="name" items="${categories}"/>
          </c:otherwise>
        </c:choose>
      </tree:nodeForm>
      
    </tree:tree>
    
    <!--  Tree of assets for a node -->
    <tree:tree root="${node}" childProperty="asset" var="asset" varStatus="assetIter">
    
      <!--  Form for editing a category -->
      <tree:nodeForm>
      	<tree:select label="资产" property="name" items="${资产Fields}"/>
        <tree:field label="" property="value" />
      </tree:nodeForm>
      
    </tree:tree>
    
 </tree:tree>

</tree:form> 
<jsp:include page="/includes/footer.jsp" flush="false"/>
