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

<%@page language="java" contentType="text/html" session="true"
	import="java.util.Iterator,
		java.util.List,
                org.opennms.netmgt.config.OpennmsServerConfigFactory,
                org.opennms.web.pathOutage.*" %>



<jsp:include page="/includes/header.jsp" flush="false">
  <jsp:param name="title" value="路径故障" />
  <jsp:param name="headTitle" value="路径故障" />
  <jsp:param name="location" value="pathOutage" />
  <jsp:param name="breadcrumb" value="路径故障" />
</jsp:include>

<% OpennmsServerConfigFactory.init(); %>
    

<%
        List<String[]> testPaths = PathOutageFactory.getAllCriticalPaths();
        String dcpip = OpennmsServerConfigFactory.getInstance().getDefaultCriticalPathIp();
        String[] pthData = PathOutageFactory.getCriticalPathData(dcpip, "ICMP");
%>
<% if (dcpip != null && !dcpip.equals("")) { %>
	<p>默认关键路径 = <%= dcpip %> ICMP</p>
<% } %>
	<h3>所有路径故障</h3>
	<table>
		<tr>
			<th>关键路径节点</th>
			<th><%= "关键路径IP" %></th>
			<th><%= "关键路径服务" %></th>
			<th>节点</th>
		</tr>
		<%          Iterator<String[]> iter2 = testPaths.iterator();
		while( iter2.hasNext() ) {
			String[] pth = iter2.next();
			pthData = PathOutageFactory.getCriticalPathData(pth[0], pth[1]); %>
			<tr class="CellStatus">
				<% if((pthData[0] == null) || (pthData[0].equals(""))) { %>
					<td>(接口不在数据库中)</td>
					<% } else if (pthData[0].indexOf("nodes have this IP") > -1) { %>
						<td><a href="element/nodeList.htm?iplike=<%= pth[0] %>"><%= pthData[0] %></a></td>
						<% } else { %>
							<td><a href="element/node.jsp?node=<%= pthData[1] %>"><%= pthData[0] %></a></td>
							<% } %>
							<td><%= pth[0] %></td>
							<td class="<%= pthData[3] %>" align="center"><%= pth[1] %></td>
							<td><a href="pathOutage/showNodes.jsp?critIp=<%= pth[0] %>&critSvc=<%= pth[1] %>"><%= pthData[2] %></a></td>
						</tr>
						<% } %>
</table>



<jsp:include page="/includes/footer.jsp" flush="false" />
