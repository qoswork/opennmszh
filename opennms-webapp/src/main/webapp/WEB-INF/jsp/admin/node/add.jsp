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

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@page import="java.util.Set"%>

<%@page import="org.opennms.netmgt.provision.persist.foreignsource.ForeignSource" %>
<%@page import="org.opennms.web.servlet.XssRequestWrapper" %>

<jsp:include page="/includes/header.jsp" flush="false" >
	<jsp:param name="title" value="导入节点" />
	<jsp:param name="headTitle" value="设备配置导入" />
	<jsp:param name="headTitle" value="添加节点" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb" value="<a href='admin/provisioningGroups.htm'>设备配置导入</a>" />
	<jsp:param name="breadcrumb" value="节点快速添加" />
</jsp:include>

<br />

<c:if test="${success}">
	<div style="border: 1px solid black; background-color: #bbffcc; margin: 2px; padding: 3px;">
		<h2>成功</h2>
		<p>你的节点已经被添加到 ${foreignSource} 导入。</p>
	</div>
</c:if>

<div class="TwoColLeft">
<c:choose>
<c:when test="${empty requisitions}">
	<h2>缺少设备配置导入</h2>
	<p>你必须先 <a href='admin/provisioningGroups.htm'>创建设备配置导入</a> 使用此页之前。</p>
</c:when>
<c:otherwise>
<form action="admin/node/add.htm">
	<script type="text/javascript">
	function addCategoryRow() {
		var categoryMembershipTable = document.getElementById("categoryMembershipTable");
		var initialCategoryRow = document.getElementById("initialCategoryRow");
		var newCategoryRow = initialCategoryRow.cloneNode(true);
		newCategoryRow.id = "";
		categoryMembershipTable.appendChild(newCategoryRow);
	}
	</script>
	<input type="hidden" name="actionCode" value="add" />
	<h3>基本属性 (必填)</h3>
	<div class="boxWrapper">
		<table class="normal">
			<tr>
				<td>导入:</td>
				<td colspan="3">
					<select name="foreignSource">
						<c:forEach var="req" items="${requisitions}">
							<option><c:out value="${req.foreignSource}" /></option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td>IP地址:</td>
				<td><input type="text" name="ipAddress" /></td>

				<td>节点名称:</td>
				<td><input type="text" name="nodeLabel" /></td>
			</tr>
		</table>
	</div>

	<h3>Surveillance Category Memberships (optional)</h3>
	<div class="boxWrapper">
		<table class="normal">
		<tbody id="categoryMembershipTable">
			<tr id="initialCategoryRow">
				<td>Category:</td>
				<td>
					<select name="category">
							<option value="">--</option>
						<c:forEach var="cat" items="${categories}">
							<option><c:out value="${cat}" /></option>
						</c:forEach>
					</select>
				</td>

				<td>Category:</td>
				<td>
					<select name="category">
							<option value="">--</option>
						<c:forEach var="cat" items="${categories}">
							<option><c:out value="${cat}" /></option>
						</c:forEach>
					</select>
				</td>
				<td><a href="javascript:addCategoryRow()">More...</a></td>
			</tr>
		</tbody>
		</table>
	</div>

	<h3>SNMP Parameters (optional)</h3>
	<div class="boxWrapper">
		<table class="normal">
			<tr>
				<td>Community String:</td>
				<td><input type="text" name="community" /></td>

				<td>Version</td>
				<td><select name="snmpVersion"><option>v1</option><option selected>v2c</option></select></td>

				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
			    <td><label for="noSNMP">No SNMP:</label></td>
			    <td><input id="noSNMP" type="checkbox" name="noSNMP" value="true" selected="false" /></td>
			</tr>
		</table>
	</div>

	<h3>CLI Authentication Parameters (optional)</h3>
	<div class="boxWrapper">
		<table class="normal">
			<tr>
				<td>Device Username:</td>
				<td colspan="3"><input type="text" name="deviceUsername" /></td>
			</tr>
			<tr>
				<td>Device Password:</td>
				<td><input type="text" name="devicePassword" /></td>
				
				<td>Enable Password:</td>
				<td><input type="text" name="enablePassword" /></td>
			</tr>
			<tr>
				<td>Access Method:</td>
				<td>
					<select name="accessMethod" >
					<option value="" selected="true">--</option>
					<option value="rsh">RSH</option>
					<option value="ssh">SSH</option>
					<option value="telnet">Telnet</option>
					</select>  
				</td>
				<td><label for="autoEnableControl">Auto Enable:</label></td>
				<td>
					<input id="autoEnableControl" type="checkbox" name="autoEnable" selected="false" />
				</td>
			</tr>
		</table>
	</div>

	<input type="submit" value="Provision" />
	<input type="reset" />
</form>

</c:otherwise>
</c:choose> <!--  empty requisitions -->
</div>

<div class="TwoColRight">
	<h3>节点快速添加</h3>
	<div class="boxWrapper">
		<p>
		这个工作流程提供了一个快速的方法对添加现有的设备配置导入到OpenNMS系统。
		</p>

		<p>
		<strong>注意:此操作<em>将</em>覆盖所有没有同步过的设备配置导入。
		</p>

		<p>
		<em>基本属性</em>是所有节点公用的。
		选择一个设备配置导入添加节点，提供一个IP地址给OpenNMS进行通信，然后输入一个节点名称。
		节点名称将作为节点在OpenNMS的显示的名称。
		</p>

		<p>
		<em>监视分类成员</em>是可选的标签。
		一个节点可以加入多个监视分类，这些分类的名称在OpenNMS是非常有用的。
		</p>

		<p>
		<em>SNMP参数</em>是可选的并且只应用于节点初始的设备配置导入。
		如果在这里没有指定值，OpenNMS系统将使用<em>基本属性</em>配置。
		如果节点不支持SNMP，应该选中"No SNMP"。
		Web UI不支持SNMP V3参数配置；如果要配置节点SNMPV3参数请联系你的OpenNMS系统管理员。
		</p>

		<p>
		<em>CLI 认证参数</em> 是可选的并且只用来提供给相应的适配器。
		通常情况是OpenNMS系统整合其它管理系统。
		</p>
	</div>
</div>

<br />

<jsp:include page="/includes/footer.jsp" flush="false" />
