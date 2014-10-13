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
	import="org.opennms.netmgt.EventConstants,
		org.opennms.netmgt.xml.event.Event,
		org.opennms.core.utils.WebSecurityUtils,
		org.opennms.web.servlet.MissingParameterException,
		org.opennms.web.api.Util,
		org.opennms.core.utils.InetAddressUtils"
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%!
    private void sendSNMPRestartEvent(int nodeid, String primeInt) throws ServletException {
        Event snmpRestart = new Event();
        snmpRestart.setUei("uei.opennms.org/nodes/reinitializePrimarySnmpInterface");
        snmpRestart.setNodeid(Long.valueOf(nodeid));
        snmpRestart.setInterface(primeInt);
        snmpRestart.setSource("web ui");
        snmpRestart.setTime(EventConstants.formatToString(new java.util.Date()));

        try {
                Util.createEventProxy().send(snmpRestart);
        } catch (Throwable e) {
                throw new ServletException("Could not send event " + snmpRestart.getUei(), e);
        }

    }
%>

<%
    String nodeIdString = request.getParameter("node");
    String ipAddr = request.getParameter("ipaddr");
    String[] requiredParameters = new String[] { "node", "ipaddr" };
    
    if (nodeIdString == null) {
        throw new MissingParameterException("node", requiredParameters);
    }
    
    if (ipAddr == null) {
        throw new MissingParameterException("ipaddr", requiredParameters);
    }

    int nodeId = WebSecurityUtils.safeParseInt(nodeIdString);

    sendSNMPRestartEvent(nodeId, ipAddr);
    
        
%>

<c:url var="nodeLink" value="element/node.jsp">
  <c:param name="node" value="<%=String.valueOf(nodeId)%>"/>
</c:url>
<c:url var="interfaceLink" value="element/interface.jsp">
  <c:param name="node" value="<%=String.valueOf(nodeId)%>"/>
  <c:param name="intf" value="<%=ipAddr%>"/>
</c:url>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="更新SNMP信息" />
  <jsp:param name="headTitle" value="重新扫描" />
  <jsp:param name="headTitle" value="SNMP信息" />
  <jsp:param name="breadcrumb" value="<a href='element/index.jsp'>查询</a>" />
  <jsp:param name="breadcrumb" value="<a href='${fn:escapeXml(nodeLink)}'>节点</a>" />
  <jsp:param name="breadcrumb" value="<a href='${fn:escapeXml(interfaceLink)}'>接口</a>" />
  <jsp:param name="breadcrumb" value="更新SNMP信息" />
</jsp:include>

<h3>更新SNMP信息</h3>
      
<p>
  该接口SNMP信息已更新。这个操作应当是因为SNMP团体名的修改，并要使采集生效。
</p>

<jsp:include page="/includes/footer.jsp" flush="false" />
