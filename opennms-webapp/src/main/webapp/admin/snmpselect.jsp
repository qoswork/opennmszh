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
	import="java.io.File,
		java.util.*,
		org.opennms.core.utils.WebSecurityUtils,
		org.opennms.web.element.NetworkElementFactory,
		org.opennms.web.admin.nodeManagement.*
	"
%>

<%!
	int interfaceIndex;
%>

<%
	String nodeIdString = request.getParameter( "node" );

	if( nodeIdString == null ) {
		throw new org.opennms.web.servlet.MissingParameterException( "node" );
	}

	int nodeId = WebSecurityUtils.safeParseInt( nodeIdString );

	String nodeLabel = request.getParameter( "nodelabel" );

	if( nodeLabel == null ) {
		throw new org.opennms.web.servlet.MissingParameterException( "nodelabel" );
	}

	HttpSession userSession = request.getSession(false);
	List<SnmpManagedInterface> interfaces = null;

	interfaceIndex = 0;

	if (userSession != null) {
		interfaces = (List<SnmpManagedInterface>)userSession.getAttribute("listInterfacesForNode.snmpselect.jsp");
	}
%>

<jsp:include page="/includes/header.jsp" flush="false" >
	<jsp:param name="title" value="选择SNMP接口" />
	<jsp:param name="headTitle" value="选择SNMP接口" />
	<jsp:param name="headTitle" value="管理"/>
	<jsp:param name="location" value="admin" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb" value="选择SNMP接口" />
</jsp:include>

<script type="text/javascript" >
	
	function applyChanges() {
		if (confirm("你确定要继续吗？这个操作可以撤消返回当前状态。")) {
			document.chooseSnmpNodes.submit();
		}
	}

	function cancel() {
		document.chooseSnmpNodes.action="admin/index.jsp";
		document.chooseSnmpNodes.submit();
	}

	function collectAll() {
		for (var c = 0; c < document.chooseSnmpNodes.elements.length; c++) {
			var elementType = document.chooseSnmpNodes.elements[c].type;
			if (elementType == "select" || elementType == "select-one") {
				document.chooseSnmpNodes.elements[c].options[0].selected = true;
				document.chooseSnmpNodes.elements[c].options[1].selected = false;
				document.chooseSnmpNodes.elements[c].options[2].selected = false;
			}
		}
	}

	function collectNone() {
		for (var c = 0; c < document.chooseSnmpNodes.elements.length; c++) {
			var elementType = document.chooseSnmpNodes.elements[c].type;
			if (elementType == "select" || elementType == "select-one") {
				document.chooseSnmpNodes.elements[c].options[0].selected = false;
				document.chooseSnmpNodes.elements[c].options[1].selected = true;
				document.chooseSnmpNodes.elements[c].options[2].selected = false;
			}
		}
	}
	function collectDefault() {
		for (var c = 0; c < document.chooseSnmpNodes.elements.length; c++) {
			var elementType = document.chooseSnmpNodes.elements[c].type;
			if (elementType == "select" || elementType == "select-one") {
				document.chooseSnmpNodes.elements[c].options[0].selected = false;
				document.chooseSnmpNodes.elements[c].options[1].selected = false;
				document.chooseSnmpNodes.elements[c].options[2].selected = true;
			}
		}
	}
</script>

<form method="post" name="chooseSnmpNodes" action="admin/changeCollectStatus">
	<input type="hidden" name="node" value="<%=nodeId%>" />

	<h3 class="o-box">选择数据采集的SNMP接口</h3>

	<p>
		下面列出了节点上发现的所有接口。如果采集实例的"snmpStorageFlag"标志设置为"select"那么只有主接口和下面被选中接口的SNMP数据会存储。如果"snmpStorageFlag"标志设置为"primary"或"all"则此处的设置无效。
	</p>

	<p>
		为了改变接口采集，只需点击采集列的下拉框。然后，选择采集类型，它会立即更新，
	</p>

	<p>
		<strong>注意:</strong>
		标记为主或第二的接口将始终被选中数据采集。如果要将它们删除，可以编辑的collectd配置文件中的IP地址范围。
	</p>
	<br/>
	<%=listNodeName(nodeId, nodeLabel)%>
	<br/>
	
	<opennms:snmpSelectList id="selectList"></opennms:snmpSelectList>
	<!-- For IE -->
	<div name="opennms-snmpSelectList" id="selectList-ie"></div>
	<% if (interfaces.size() > 0) { %>
	<%-- <table class="standardfirst">
		<tr>
			<td class="standardheader" width="5%" align="center">接口索引</td>
			<td class="standardheader" width="10%" align="center">IP主机名</td>
			<td class="standardheader" width="5%" align="center">接口类型</td>
			<td class="standardheader" width="10%" align="center">接口描述</td>
			<td class="standardheader" width="10%" align="center">接口名称</td>
			<td class="standardheader" width="10%" align="center">接口别名</td>
			<td class="standardheader" width="10%" align="center">SNMP状态</td>
			<td class="standardheader" width="5%" align="center">采集？
				<a href="#" onClick="javascript:collectAll(); return false;">[All]</a>
				<a href="#" onClick="javascript:collectNone(); return false;">[None]</a>
				<a href="#" onClick="javascript:collectDefault(); return false;">[Default]</a>
			</td>
		</tr>
		<%=buildTableRows(interfaces, nodeId, interfaces.size())%>
	</table>--%>
	<% } /*end if*/ %>

	<%--<br/>
	<input type="button" value="更新采集" onClick="applyChanges()" />
	<input type="button" value="取消" onClick="cancel()" /> 
	<input type="reset" />--%>
</form>

<jsp:include page="/includes/footer.jsp" flush="true"/>
<%!
	public String listNodeName(int intnodeid, String nodelabel) {
		StringBuffer nodename = new StringBuffer();

		nodename.append("<strong style='font-weight:bold;'>节点ID</strong>: ");
		nodename.append(intnodeid);
		nodename.append("<br/>");
		nodename.append("<strong style='font-weight:bold;'>节点名称</strong>: ");
		nodename.append(nodelabel);
		nodename.append("<br/>\n");
		return nodename.toString();
	}
%>

<%!

public String buildTableRows(List<SnmpManagedInterface> interfaces, int intnodeid, int stop) throws java.sql.SQLException {
	StringBuffer row = new StringBuffer();
	String collStatus = "Not Collected";

	for (SnmpManagedInterface curInterface : interfaces) {
		String statusTest = curInterface.getStatus();
		if (statusTest == null) {
			statusTest = "N";
		}

		String collFlag = curInterface.getCollectFlag();
		if (collFlag == null) {
			collFlag = "N";
		}

		String collDefaultString = "Default (Don't Collect)";
		Map<String,String> collOptions = new LinkedHashMap<String,String>();
		collOptions.put("UC", "Collect");
		collOptions.put("UN", "Don't Collect");

		if (statusTest.equals("P")) {
			collStatus = "Primary";
			collOptions.put("C", "Default (Collect)");
		}
		else if (statusTest.equals("S")) {
			collStatus = "Secondary";
			collOptions.put("N", "Default (Don't Collect)");
		}
		else {
			collStatus = "Not Eligible";
			collOptions.put("N", "Default (Don't Collect)");
		}

		if (curInterface.getNodeid() == intnodeid) {
			String ipHostname = curInterface.getIpHostname();
			if (ipHostname == null) {
				ipHostname = "";
			}

			row.append("<tr>\n");

			row.append("<td class=\"standard\" width=\"5%\" align=\"center\">");
			if ( curInterface.getIfIndex() > 0 ) {
				row.append(curInterface.getIfIndex());
			} else {
				row.append("&nbsp;");
			}
			row.append("</td>\n");

			row.append("<td class=\"standard\" width=\"20%\" align=\"left\">");
		  	row.append(ipHostname);
			row.append("</td>\n");

			row.append("<td class=\"standard\" width=\"5%\" align=\"center\">");
			row.append(curInterface.getIfType());
			row.append("</td>\n");

			row.append("<td class=\"standard\" width=\"10%\" align=\"center\">");
			row.append(curInterface.getIfDescr());
			row.append("</td>\n");

			row.append("<td class=\"standard\" width=\"10%\" align=\"center\">");
			row.append(curInterface.getIfName());
			row.append("</td>\n");

			row.append("<td class=\"standard\" width=\"10%\" align=\"center\">");
			row.append(curInterface.getIfAlias());
			row.append("</td>\n");

			row.append("<td class=\"standard\" width=\"10%\" align=\"center\">");
			row.append(collStatus);
			row.append("</td>\n");

			row.append("<td class=\"standard\" width=\"5%\" align=\"center\">");
			row.append("<select name=\"collect-").append(curInterface.getIfIndex()).append("\">");
			for (Map.Entry<String,String> option : collOptions.entrySet()) {
				row.append("<option value=\"").append(option.getKey()).append("\"");
				if (collFlag.equals(option.getKey())) {
					row.append(" selected");
				}
				row.append(">").append(option.getValue()).append("</option>");
			}
			row.append("</select>");

			row.append("</td>\n");

			row.append("</tr>\n");
		}
	}

	return row.toString();
}
      
%>
