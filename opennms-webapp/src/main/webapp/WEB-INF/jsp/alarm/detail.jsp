<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2012 The OpenNMS Group, Inc.
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
        import="java.util.List,
        org.opennms.core.utils.WebSecurityUtils,
        org.opennms.web.controller.alarm.*,
        org.opennms.web.alarm.*,
        org.opennms.netmgt.model.OnmsAcknowledgment,
        org.opennms.netmgt.model.OnmsSeverity,
        org.opennms.web.springframework.security.Authentication"
        %>

<%@page import="org.opennms.web.alarm.Alarm" %>


<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib tagdir="/WEB-INF/tags/form" prefix="form" %>

<%@page import="org.opennms.web.servlet.XssRequestWrapper"%>
<%@page import="org.opennms.web.alarm.Alarm" %>

<%!
    public String alarmTicketLink(Alarm alarm) {
        String template = System.getProperty("opennms.alarmTroubleTicketLinkTemplate");
        if (template == null) {
            return alarm.getTroubleTicket();
        } else {
            return template.replaceAll("\\$\\{id\\}", alarm.getTroubleTicket());
        }
    }

%>

<%
    XssRequestWrapper req = new XssRequestWrapper(request);
    Alarm alarm = (Alarm)request.getAttribute("alarm");
    final String alarmId = (String)req.getAttribute("alarmId");

    if (alarm == null) {
        throw new AlarmIdNotFoundException("Missing alarm request attribute.", alarmId);
    }

    pageContext.setAttribute("alarm", alarm);

    String action = null;
    String ackButtonName = null;
    boolean showEscalate = false;
    boolean showClear = false;

    if (alarm.getAcknowledgeTime() == null) {
        ackButtonName = "Acknowledge";
        action = AcknowledgeType.ACKNOWLEDGED.getShortName();
    } else {
        ackButtonName = "Unacknowledge";
        action = AcknowledgeType.UNACKNOWLEDGED.getShortName();
    }

    String escalateAction = AlarmSeverityChangeController.ESCALATE_ACTION;
    String clearAction = AlarmSeverityChangeController.CLEAR_ACTION;
    if (alarm.getSeverity() == OnmsSeverity.CLEARED || (alarm.getSeverity().isGreaterThan(OnmsSeverity.NORMAL) && alarm.getSeverity().isLessThan(OnmsSeverity.CRITICAL))) {
        showEscalate = true;
    }
    if (alarm.getSeverity().isGreaterThanOrEqual(OnmsSeverity.NORMAL) && alarm.getSeverity().isLessThanOrEqual(OnmsSeverity.CRITICAL)) {
        showClear = true;
    }
    
    List<OnmsAcknowledgment> acks = (List<OnmsAcknowledgment>) request.getAttribute("acknowledgments");
%>

<%@page import="org.opennms.core.resource.Vault"%>
<jsp:include page="/includes/header.jsp" flush="false" >
    <jsp:param name="title" value="告警详细" />
    <jsp:param name="headTitle" value="详细" />
    <jsp:param name="headTitle" value="告警" />
    <jsp:param name="breadcrumb" value="<a href='alarm/index.jsp'>告警</a>" />
    <jsp:param name="breadcrumb" value="详细" />
</jsp:include>

<h3>告警 <%=alarm.getId()%></h3>

<table>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th width="100em">级别</th>
        <td class="divider" width="28%"><%=alarm.getSeverity().getLabel()%></td>
        <th width="100em">节点</th>
        <td class="divider" width="28%">
            <% if (alarm.getNodeId() > 0) {%>
            <c:url var="nodeLink" value="element/node.jsp">
                <c:param name="node" value="<%=String.valueOf(alarm.getNodeId())%>"/>
            </c:url>
            <a href="${nodeLink}"><c:out value="<%=alarm.getNodeLabel()%>"/></a>
            <% } else {%>
            &nbsp;
            <% }%>
        </td>
    </tr>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th>最后&nbsp;事件</th>
        <td><span title="事件 <%= alarm.getLastEventID()%>"><a href="event/detail.jsp?id=<%= alarm.getLastEventID()%>"><fmt:formatDate value="<%=alarm.getLastEventTime()%>" type="BOTH" /></a></span></td>
        <th>接口</th>
        <td>
            <% if (alarm.getIpAddress() != null) {%>
            <% if (alarm.getNodeId() > 0) {%>
            <c:url var="interfaceLink" value="element/interface.jsp">
                <c:param name="node" value="<%=String.valueOf(alarm.getNodeId())%>"/>
                <c:param name="intf" value="<%=alarm.getIpAddress()%>"/>
            </c:url>
            <a href="${interfaceLink}"><%=alarm.getIpAddress()%></a>
            <% } else {%>
            <%=alarm.getIpAddress()%>
            <% }%>
            <% } else {%>
            &nbsp;
            <% }%>
        </td>
    </tr>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th>第一个&nbsp;事件</th>
        <td><fmt:formatDate value="<%=alarm.getFirstEventTime()%>" type="BOTH" /></td>
        <th>服务</th>
        <td>
            <% if (alarm.getServiceName() != null) {%>
            <% if (alarm.getIpAddress() != null && alarm.getNodeId() > 0) {%>
            <c:url var="serviceLink" value="element/service.jsp">
                <c:param name="node" value="<%=String.valueOf(alarm.getNodeId())%>"/>
                <c:param name="intf" value="<%=alarm.getIpAddress()%>"/>
                <c:param name="service" value="<%=String.valueOf(alarm.getServiceId())%>"/>
            </c:url>
            <a href="${serviceLink}"><c:out value="<%=alarm.getServiceName()%>"/></a>
            <% } else {%>
            <c:out value="<%=alarm.getServiceName()%>"/>
            <% }%>
            <% } else {%>
            &nbsp;
            <% }%>
        </td>
    </tr> 
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th>数量</th>
        <td><%=alarm.getCount()%></td>
        <th>UEI</th>
        <td>
            <% if (alarm.getUei() != null) {%>
            <%=alarm.getUei()%>
            <% } else {%>
            &nbsp;
            <% }%>
        </td>
    </tr>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th>Ticket&nbsp;ID</th>
        <td><% if (alarm.getTroubleTicket() == null) {%>
            &nbsp;
            <% } else {%>
            <%= alarmTicketLink(alarm)%> 
            <% }%>
        </td>
        <th>Ticket&nbsp;State</th>
        <td><% if (alarm.getTroubleTicketState() == null) {%>
            &nbsp;
            <% } else {%>
            <%= alarm.getTroubleTicketState()%> 
            <% }%>
        </td>
    </tr>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th>Reduct.&nbsp;Key</th>
        <td colspan="3">
            <% if (alarm.getReductionKey() != null) {%>
            <%=alarm.getReductionKey()%>
            <% } else {%>
            &nbsp;
            <% }%>
        </td>
    </tr>
</table>

<table>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th>日志&nbsp;信息</th>
    </tr>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <td><%=alarm.getLogMessage()%></td>
    </tr>
</table>

<% if (acks != null) {%>
<table>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th>确认&nbsp;通过</th>
        <th>确认&nbsp;类型</th>
        <th>确认&nbsp;时间</th>
    </tr>
    <% for (OnmsAcknowledgment ack : acks) {%>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <td><%=ack.getAckUser()%></td>
        <td><%=ack.getAckAction()%></td>
        <td><%=ack.getAckTime()%></td>
    </tr>
    <% }%>
</table>
<% }%>

<table>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th>说明</th>
    </tr>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <td><%=alarm.getDescription()%></td>
    </tr>
</table>

<table>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th colspan="3" width="50%">Sticky Memo</th>
        <th colspan="3" width="50%">Journal Memo</th>
    </tr>

    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <td colspan="3">
            <form method="post" action="alarm/saveSticky.htm">        
                <textarea style="width:99%" name="stickyMemoBody" ><%=alarm.getStickyMemo().getBody() != null ? alarm.getStickyMemo().getBody() : ""%></textarea>
                <br/>
                <input type="hidden" name="alarmId" value="<%=alarm.getId()%>"/>
                <form:input type="submit" value="保存" />    
            </form>
            <form method="post" action="alarm/clearSticky.htm">
                 <input type="hidden" name="alarmId" value="<%=alarm.getId()%>"/>
                 <form:input type="submit" value="清除" />
            </form>
        </td>

        <td colspan="3"> 
            <form method="post" action="alarm/saveJournal.htm">        
                <textarea style="width:99%" name="journalMemoBody" ><%=alarm.getReductionKeyMemo().getBody() != null ? alarm.getReductionKeyMemo().getBody() : ""%></textarea>
                <br/>
                <input type="hidden" name="alarmId" value="<%=alarm.getId()%>"/>
                <form:input type="submit" value="保存" />    
            </form>
            <form method="post" action="alarm/clearJournal.htm">
                <input type="hidden" name="alarmId" value="<%=alarm.getId()%>"/>
                <form:input type="submit" value="清除" />    
            </form>
        </td>
    </tr>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <td><strong>作者:</strong>&nbsp;<%=alarm.getStickyMemo().getAuthor() != null ? alarm.getStickyMemo().getAuthor() : ""%></td>
        <td><strong>更新:</strong>&nbsp;<fmt:formatDate value="<%=alarm.getStickyMemo().getUpdated()%>" type="BOTH" /></td>
        <td><strong>创建:</strong>&nbsp;<fmt:formatDate value="<%=alarm.getStickyMemo().getCreated()%>" type="BOTH" /></td>
        
        <td><strong>作者:&nbsp;</strong><%=alarm.getReductionKeyMemo().getAuthor() != null ? alarm.getReductionKeyMemo().getAuthor() : ""%></td>
        <td><strong>更新:</strong>&nbsp;<fmt:formatDate value="<%=alarm.getReductionKeyMemo().getUpdated()%>" type="BOTH" /></td>
        <td><strong>创建:</strong>&nbsp;<fmt:formatDate value="<%=alarm.getReductionKeyMemo().getCreated()%>" type="BOTH" /></td>
    </tr>
</tr>

</table>

<table>
    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <th>操作&nbsp;说明</th>
    </tr>

    <tr class="<%=alarm.getSeverity().getLabel()%>">
        <td>
            <%if (alarm.getOperatorInstruction() == null) {%>
            没有可用的说明
            <% } else {%>
            <%=alarm.getOperatorInstruction()%>
            <% }%>
        </td>
    </tr>
</table>

<% if (request.isUserInRole(Authentication.ROLE_ADMIN) || !request.isUserInRole(Authentication.ROLE_READONLY)) {%>
<table>
    <tbody>
        <tr class="<%=alarm.getSeverity().getLabel()%>">
            <th colspan="2">确认&nbsp;和&nbsp;级别&nbsp;操作</th>
        </tr>
        <tr class="<%=alarm.getSeverity().getLabel()%>">
            <td>
                <form method="post" action="alarm/acknowledge">
                    <input type="hidden" name="actionCode" value="<%=action%>" />
                    <input type="hidden" name="alarm" value="<%=alarm.getId()%>"/>
                    <input type="hidden" name="redirect" value="<%= "detail.htm" + "?" + request.getQueryString()%>" />
                    <input type="submit" value="<%=ackButtonName%>" />
                </form>
            </td>
            <td><%=ackButtonName%> 此告警</td>
        </tr>

        <%if (showEscalate || showClear) {%>
        <tr class="<%=alarm.getSeverity().getLabel()%>">
            <td>
                <form method="post" action="alarm/changeSeverity">
                    <input type="hidden" name="alarm" value="<%=alarm.getId()%>"/>
                    <input type="hidden" name="redirect" value="<%= "detail.htm" + "?" + request.getQueryString()%>" />	  
                    <select name="actionCode">
                        <%if (showEscalate) {%>
                        <option value="<%=escalateAction%>">升级</option>
                        <% }%>
                        <%if (showClear) {%>
                        <option value="<%=clearAction%>">清除</option>
                        <% }%>
                    </select>
                    <input type="submit" value="完成"/>
                </form>
            </td>
            <td>
                <%if (showEscalate) {%>
                升级
                <% }%>
                <%if (showEscalate && showClear) {%>
                或
                <% }%>
                <%if (showClear) {%>
                清除
                <% }%>
                此告警
            </td>
        </tr>
        <% } // showEscalate || showClear %>      
    </tbody>
</table>

<br/>

<% if ("true".equalsIgnoreCase(Vault.getProperty("opennms.alarmTroubleTicketEnabled"))) {%>

<form method="post" action="alarm/ticket/create.htm">
    <input type="hidden" name="alarm" value="<%=alarm.getId()%>"/>
    <input type="hidden" name="redirect" value="<%="/alarm/detail.htm" + "?" + request.getQueryString()%>" />
    <form:input type="submit" value="Create Ticket" disabled="${(!empty alarm.troubleTicketState) && (alarm.troubleTicketState != 'CREATE_FAILED')}" />
</form>

<form method="post" action="alarm/ticket/update.htm">
    <input type="hidden" name="alarm" value="<%=alarm.getId()%>"/>
    <input type="hidden" name="redirect" value="<%="/alarm/detail.htm" + "?" + request.getQueryString()%>" />
    <form:input type="submit" value="Update Ticket" disabled="${(empty alarm.troubleTicket)}"/>
</form>

<form method="post" action="alarm/ticket/close.htm">
    <input type="hidden" name="alarm" value="<%=alarm.getId()%>"/>
    <input type="hidden" name="redirect" value="<%="/alarm/detail.htm" + "?" + request.getQueryString()%>" />
    <form:input type="submit" value="Close Ticket" disabled="${(empty alarm.troubleTicketState) || ((alarm.troubleTicketState != 'OPEN') && (alarm.troubleTicketState != 'CLOSE_FAILED')) }" />
</form>

<% } // alarmTroubleTicketEnabled %>
<% } // isUserInRole%>

<jsp:include page="/includes/footer.jsp" flush="false" />
