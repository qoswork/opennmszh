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

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="分类" />
	<jsp:param name="headTitle" value="分类" />
	<jsp:param name="breadcrumb"
               value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb"
	           value="<a href='admin/categories.htm'>分类</a>" />
	<jsp:param name="breadcrumb" value="显示" />
</jsp:include>

<script type="text/javascript">
var nodesToAddAuto = {
  <c:forEach items="${model.nodes}" var="node"><c:if test="${node.foreignSource == null}">"${node.id}": "${node.label}",</c:if>
  </c:forEach>
};

var nodesToDeleteAuto = {
  <c:forEach items="${model.sortedMemberNodes}" var="node"><c:if test="${node.foreignSource == null}">"${node.id}": "${node.label}",</c:if>
  </c:forEach>
};

var nodesToAddReq = {
  <c:forEach items="${model.nodes}" var="node"><c:if test="${node.foreignSource != null}">"${node.id}": "${node.label}",</c:if>
  </c:forEach>
};

var nodesToDeleteReq = {
  <c:forEach items="${model.sortedMemberNodes}" var="node"><c:if test="${node.foreignSource != null}">"${node.id}": "${node.label}",</c:if>
  </c:forEach>
};

function populateOptGroupFromList(elementName, list) {
	var optgroupElem = document.getElementById(elementName);
	if (optgroupElem == null) {
		return;
	}
	while (optgroupElem.childElementCount > 0) {
		optgroupElem.remove(0);
	}
	
	for (var nodeId in list) {
		var optionElem = document.createElement("option");
		optionElem.value = nodeId;
		optionElem.textContent = list[nodeId];
		optgroupElem.appendChild(optionElem);
	}
}

function populateAutoNodes() {
	populateOptGroupFromList("toAddAutoGroup", nodesToAddAuto);
	populateOptGroupFromList("toDeleteAutoGroup", nodesToDeleteAuto);
}

function populateReqNodes() {
	populateOptGroupFromList("toAddReqGroup", nodesToAddReq);
	populateOptGroupFromList("toDeleteReqGroup", nodesToDeleteReq);
}

function toggleReqNodes() {
	var addGroup = document.getElementById("toAddReqGroup");
	var deleteGroup = document.getElementById("toDeleteReqGroup");
	addGroup.disabled = !(addGroup.disabled);
	deleteGroup.disabled = !(deleteGroup.disabled);
}
</script>

<h3>编辑监视分类 ${model.category.name}</h3>

<p>
分类 '${model.category.name}' 有 ${fn:length(model.sortedMemberNodes)} 个节点  
</p>

<form action="admin/categories.htm" method="get">
  <input type="hidden" name="categoryid" value="${model.category.id}"/>
  <input type="hidden" name="edit" value=""/>
  
  <table class="normal">
    <tr>
      <td class="normal" align="center">
		可用的节点
      </td>
      
      <td class="normal">  
      </td>

      <td class="normal" align="center">
      	分类上的节点
      </td>
    </tr>
      
    <tr>
      <td class="normal">
    <select id="toAdd" name="toAdd" size="20" multiple>
        <optgroup id="toAddAutoGroup" label="自动配置节点"></optgroup>
	    <optgroup id="toAddReqGroup" disabled="true" label="导入节点"></optgroup>
    </select>
      </td>
      
      <td class="normal" style="text-align:center; vertical-align:middle;">  
        <input type="submit" name="action" value="Add &#155;&#155;"/>
        <br/>
        <br/>
        <input type="submit" name="action" value="&#139;&#139; Remove"/>
      </td>
    
      <td class="normal">
    <select id="toDelete" name="toDelete" size="20" multiple>
        <optgroup id="toDeleteAutoGroup" label="自动配置节点"></optgroup>
	    <optgroup id="toDeleteReqGroup" disabled="true" label="导入节点"></optgroup>
    </select>
      </td>
    </tr>
    <tr>
      <td colspan="3">
        <input id="toggleCheckbox" type="checkbox" onchange="javascript:toggleReqNodes()" />
        <label for="toggleCheckbox">选中则使能导入节点 (改变 <strong>将</strong> 被丢失在下一次同步)</label>
      </td>
    </tr>
  </table>
</form>

<script type="text/javascript">
populateAutoNodes();
populateReqNodes();
</script>

<jsp:include page="/includes/footer.jsp" flush="false"/>
