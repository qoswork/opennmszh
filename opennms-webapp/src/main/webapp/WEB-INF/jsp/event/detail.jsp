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

<%@page language="java"	contentType="text/html"	session="true" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="org.springframework.util.Assert"%>

<%@page import="org.opennms.netmgt.EventConstants"%>
<%@page import="org.opennms.core.utils.WebSecurityUtils"%>
<%@page import="org.opennms.web.servlet.XssRequestWrapper"%>
<%@page import="org.opennms.web.event.Event"%>
<%@page import="org.opennms.web.event.AcknowledgeType"%>

<%

	XssRequestWrapper req = new XssRequestWrapper(request);
	Event[] events = (Event[])req.getAttribute("events");
	Event event = null;
	String action = null;
    String buttonName=null;
    HashMap<String, String> parms = new HashMap<String, String>();
	if ( events.length > 0 ) {
		Assert.isTrue(events.length == 1, "event detail filter should match only one event: event found:" + events.length);

    	event = events[0];
    
	    if (event.getAcknowledgeTime()==null)
	    {
	        buttonName = "确认";
	        action = AcknowledgeType.ACKNOWLEDGED.getShortName();
	    }
	    else
	    {
	        buttonName = "取消确认";
	        action = AcknowledgeType.UNACKNOWLEDGED.getShortName();
	    }

		Pattern p = Pattern.compile("([^=]+)=(.*)\\((\\w+),(\\w+)\\)");
	    
	    if (event.getParms() != null) {
			String[] parmStrings = event.getParms().split(";");
			for (String parmString : parmStrings) {
				Matcher m = p.matcher(parmString);
				if (!m.matches()) {
					log("Could not match event parameter string element '"
						+ parmString + "' in event ID " + event.getId());
					continue;
				}
				
				parms.put(m.group(1), m.group(2));
			}
	    }
	}    

%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="事件详细" />
  <jsp:param name="headTitle" value="详细" />
  <jsp:param name="headTtitle" value="事件" />
  <jsp:param name="breadcrumb" value="<a href='event/index.jsp'>事件</a>" />
  <jsp:param name="breadcrumb" value="详细" />
</jsp:include>
	 <% if (event == null ) { %>
      <h3>事件在数据库中未发现</h3>
	<% } else { %>
      <h3>事件 <%=event.getId()%></h3>

      <% String acknowledgeEvent = System.getProperty("opennms.eventlist.acknowledge"); %>

      <table>
        <tr class="<%= event.getSeverity().getLabel() %>">
          <th class="divider" width="100em">级别</th>
          <td class="divider" width="28%"><%= event.getSeverity().getLabel() %></td>
          <th class="divider" width="100em">节点</th>
          <td class="divider" width="28%">
            <% if( event.getNodeId() > 0 ) { %>
              <a href="element/node.jsp?node=<%=event.getNodeId()%>"><%=event.getNodeLabel()%></a>
            <% } else {%>
              &nbsp;
            <% } %>
          </td>
          <% if ("true".equals(acknowledgeEvent)) { %>
          <th class="divider" width="100em">已确认</th>
          <td class="divider" width="28%"><%=event.getAcknowledgeUser()!=null ? event.getAcknowledgeUser() : "&nbsp;"%></td>
          <% } else { %>
          <td class="divider" colspan="2">&nbsp;</td>
          <% } %>
        </tr>
        
        <tr  class="<%= event.getSeverity().getLabel() %>">
          <th>时间</th>
          <td><%=org.opennms.web.api.Util.formatDateToUIString(event.getTime())%></td>
          <th>接口</th>
          <td>
            <% if( event.getIpAddress() != null ) { %>
              <% if( event.getNodeId() > 0 ) { %>
                <c:url var="interfaceLink" value="element/interface.jsp">
                  <c:param name="node" value="<%=String.valueOf(event.getNodeId())%>"/>
                  <c:param name="intf" value="<%=event.getIpAddress()%>"/>
                </c:url>
                <a href="${interfaceLink}"><%=event.getIpAddress()%></a>
              <% } else { %>
                <%=event.getIpAddress()%>
              <% } %>
            <% } else {%>
              &nbsp;
            <% } %>
          </td>
          <% if ("true".equals(acknowledgeEvent)) { %>
          <th>确认时间</th>
          <td><%=event.getAcknowledgeTime()!=null ? org.opennms.web.api.Util.formatDateToUIString(event.getAcknowledgeTime()) : "&nbsp;"%></td>
          <% } else { %>
          <td colspan="2">&nbsp;</td>
          <% } %>
        </tr>
        
        <tr class="<%= event.getSeverity().getLabel() %>">
          <th>服务</th>
          <td>
            <% if( event.getServiceName() != null ) { %>
              <% if( event.getIpAddress() != null && event.getNodeId() > 0 ) { %>
                <c:url var="serviceLink" value="element/service.jsp">
                  <c:param name="node" value="<%=String.valueOf(event.getNodeId())%>"/>
                  <c:param name="intf" value="<%=event.getIpAddress()%>"/>
                  <c:param name="service" value="<%=String.valueOf(event.getServiceId())%>"/>
                </c:url>
                <a href="${serviceLink}"><c:out value="<%=event.getServiceName()%>"/></a>
              <% } else { %>
                <c:out value="<%=event.getServiceName()%>"/>
              <% } %>
            <% } else {%>
              &nbsp;
            <% } %>
          </td>
          <% if (parms.containsKey(EventConstants.PARM_LOCATION_MONITOR_ID)) { %>
            <th>监控位置ID</th>
            <td><a href="distributed/locationMonitorDetails.htm?monitorId=<%= parms.get(EventConstants.PARM_LOCATION_MONITOR_ID)%>"><%= parms.get(EventConstants.PARM_LOCATION_MONITOR_ID) %></a></td>
            <td colspan="2">&nbsp;</td>
          <% } else { %>
            <td colspan="4">&nbsp;</td>
          <% } %>
        </tr> 
          
        <tr class="<%= event.getSeverity().getLabel() %>">
          	<th>UEI</th>
                <td>
          	<% if( event.getUei() != null ) { %>
          	      <%=event.getUei()%>
          	<% } else {%>
                	&nbsp;
          	<% } %>
                </td>
                <td colspan="4">&nbsp;</td>
        </tr>
      </table>

      <table>
        <tr class="<%= event.getSeverity().getLabel() %>">
          <th>日志消息</th>
        </tr>
        <tr class="<%= event.getSeverity().getLabel() %>">
          <td><%=event.getLogMessage()%></td>
        </tr>
      </table>

      <table>
        <tr class="<%= event.getSeverity().getLabel() %>">
          <th>说明</th>
        </tr>
        <tr class="<%= event.getSeverity().getLabel() %>">
          <td><%=event.getDescription()%></td>
        </tr>
      </table>
      
      <table>
        <tr class="<%= event.getSeverity().getLabel() %>">
          <th>选项说明</th>
        </tr>
        <tr class="<%= event.getSeverity().getLabel() %>">
          <td>
	    <%if (event.getOperatorInstruction()==null) { %>
              无可用说明
            <% } else { %>
              <%=event.getOperatorInstruction()%>
            <% } %>
	  </td>
        </tr>
      </table>

      <% 
      if( ( request.isUserInRole( org.opennms.web.springframework.security.Authentication.ROLE_ADMIN ) || !request.isUserInRole( org.opennms.web.springframework.security.Authentication.ROLE_READONLY ) ) && "true".equals(acknowledgeEvent)) { %>
        <form method="post" action="event/acknowledge">
          <input type="hidden" name="actionCode" value="<%=action%>" />
          <input type="hidden" name="event" value="<%=event.getId()%>"/>
          <input type="hidden" name="redirect" value="<%= "detail.jsp?" + request.getQueryString()%>" />
          <input type="submit" value="<%=buttonName%>"/>
        </form>
      <% } %>
   <% } %>   
<jsp:include page="/includes/footer.jsp" flush="false" />
