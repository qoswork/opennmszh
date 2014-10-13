<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2008-2012 The OpenNMS Group, Inc.
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

<%@page import="org.opennms.web.alarm.filter.NegativeAcknowledgedByFilter"%>
<%@page import="org.opennms.web.alarm.filter.AcknowledgedByFilter"%>
<%@page language="java"
	contentType="text/html"
	session="true" %>
	
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>

<%@page import="org.opennms.web.api.Util"%>
<%@page import="org.opennms.core.utils.WebSecurityUtils" %>
<%@page import="org.opennms.web.servlet.XssRequestWrapper" %>
<%@page import="org.opennms.web.springframework.security.Authentication" %>

<%@page import="org.opennms.web.controller.alarm.AcknowledgeAlarmController" %>
<%@page import="org.opennms.web.controller.alarm.AlarmSeverityChangeController" %>

<%@page import="org.opennms.web.filter.Filter" %>
<%@page import="org.opennms.web.alarm.Alarm" %>
<%@page import="org.opennms.web.alarm.AlarmQueryParms" %>
<%@page import="org.opennms.web.alarm.SortStyle" %>
<%@page import="org.opennms.web.alarm.AcknowledgeType" %>
<%@page import="org.opennms.web.alarm.AlarmUtil" %>
<%@page import="org.opennms.web.alarm.filter.ExactUEIFilter" %>
<%@page import="org.opennms.web.alarm.filter.NegativeExactUEIFilter" %>
<%@page import="org.opennms.web.alarm.filter.SeverityFilter" %>
<%@page import="org.opennms.web.alarm.filter.NegativeSeverityFilter" %>
<%@page import="org.opennms.web.alarm.filter.NodeFilter" %>
<%@page import="org.opennms.web.alarm.filter.NegativeNodeFilter" %>
<%@page import="org.opennms.web.alarm.filter.InterfaceFilter" %>
<%@page import="org.opennms.web.alarm.filter.NegativeInterfaceFilter" %>
<%@page import="org.opennms.web.alarm.filter.ServiceFilter" %>
<%@page import="org.opennms.web.alarm.filter.NegativeServiceFilter" %>
<%@page import="org.opennms.web.alarm.filter.AfterLastEventTimeFilter" %>
<%@page import="org.opennms.web.alarm.filter.BeforeLastEventTimeFilter" %>
<%@page import="org.opennms.web.alarm.filter.AfterFirstEventTimeFilter" %>
<%@page import="org.opennms.web.alarm.filter.BeforeFirstEventTimeFilter" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%--
  This page is written to be the display (view) portion of the AlarmQueryServlet
  at the /alarm/list.htm URL.  It will not work by itself, as it requires two request
  attributes be set:
  
  1) alarms: the list of org.opennms.web.element.Alarm instances to display
  2) parms: an org.opennms.web.alarm.AlarmQueryParms object that holds all the 
     parameters used to make this query
--%>

<%
    urlBase = (String) request.getAttribute("relativeRequestPath");

    XssRequestWrapper req = new XssRequestWrapper(request);

    //required attributes
    Alarm[] alarms = (Alarm[])req.getAttribute( "alarms" );
    int alarmCount = req.getAttribute("alarmCount") == null ? -1 : (Integer)req.getAttribute("alarmCount");
    AlarmQueryParms parms = (AlarmQueryParms)req.getAttribute( "parms" );

    if( alarms == null || parms == null ) {
        throw new ServletException( "Missing either the alarms or parms request attribute." );
    }

    // Make 'action' the opposite of the current acknowledgement state
    String action = AcknowledgeType.ACKNOWLEDGED.getShortName();
    if (parms.ackType != null && parms.ackType == AcknowledgeType.ACKNOWLEDGED) {
        action = AcknowledgeType.UNACKNOWLEDGED.getShortName();
    }

    pageContext.setAttribute("addPositiveFilter", "[+]");
    pageContext.setAttribute("addNegativeFilter", "[-]");
    pageContext.setAttribute("addBeforeFilter", "[&gt;]");
    pageContext.setAttribute("addAfterFilter", "[&lt;]");
    
    final String baseHref = org.opennms.web.api.Util.calculateUrlBase(request);
%>



<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="告警列表" />
  <jsp:param name="headTitle" value="列表" />
  <jsp:param name="headTitle" value="告警" />
  <jsp:param name="breadcrumb" value="<a href='${baseHref}alarm/index.jsp' title='告警系统页面'>告警</a>" />
  <jsp:param name="breadcrumb" value="列表" />
</jsp:include>


  <script type="text/javascript">
    function checkAllCheckboxes() {
       if( document.alarm_action_form.alarm.length ) {  
         for( i = 0; i < document.alarm_action_form.alarm.length; i++ ) {
           document.alarm_action_form.alarm[i].checked = true
         }
       }
       else {
         document.alarm_action_form.alarm.checked = true
       }
         
    }
    
    function submitForm(anAction)
    {
        var isChecked = false
        var numChecked = 0;
        
        // Decide to which servlet we will submit
        if (anAction == "clear" || anAction == "escalate") {
        	document.alarm_action_form.action = "alarm/changeSeverity";
        } else if (anAction == "acknowledge" || anAction == "unacknowledge") {
        	document.alarm_action_form.action = "alarm/acknowledge";
        }
        
        // Decide what our action should be
        if (anAction == "escalate") {
        	document.alarm_action_form.actionCode.value = "<%=AlarmSeverityChangeController.ESCALATE_ACTION%>";
        } else if (anAction == "clear") {
        	document.alarm_action_form.actionCode.value = "<%=AlarmSeverityChangeController.CLEAR_ACTION%>";
        } else if (anAction == "acknowledge") {
        	document.alarm_action_form.actionCode.value = "<%= AcknowledgeType.ACKNOWLEDGED.getShortName() %>";
        } else if (anAction == "unacknowledge") {
        	document.alarm_action_form.actionCode.value = "<%= AcknowledgeType.UNACKNOWLEDGED.getShortName() %>";
        }
 
        if (document.alarm_action_form.alarm.length)
        {
            for( i = 0; i < document.alarm_action_form.alarm.length; i++ ) 
            {
              //make sure something is checked before proceeding
              if (document.alarm_action_form.alarm[i].checked)
              {
                isChecked=true;
                numChecked+=1;
              }
            }
            
            if (isChecked && document.alarm_action_form.multiple)
            {
              if (numChecked == parseInt(document.alarm_action_form.alarm.length)) 
              { 
                var newPageNum = parseInt(document.alarm_action_form.multiple.value) - 1;
                var findVal = "multiple=" + document.alarm_action_form.multiple.value;
                var replaceWith = "multiple=" + newPageNum;
                var tmpRedirect = document.alarm_action_form.redirectParms.value;
                document.alarm_action_form.redirectParms.value = tmpRedirect.replace(findVal, replaceWith);
                document.alarm_action_form.submit();
              } 
              else 
              {
                document.alarm_action_form.submit();
              }
            }
            else if (isChecked)
            {
              document.alarm_action_form.submit();
            }
            else
            {
                alert("请选中告警 " + anAction + "。");
            }
        }
        else
        {
            if (document.alarm_action_form.alarm.checked)
            {
                document.alarm_action_form.submit();
            }
            else
            {
                alert("请选中告警 " + anAction + "。");
            }
        }
    }

  </script>


      <!-- menu -->
      <div id="linkbar">
      <ul>
      <li><a href="<%=this.makeLink( parms, new ArrayList<Filter>())%>" title="删除所有查询条件" >查看所有告警</a></li>
      <li><a href="alarm/advsearch.jsp" title="更多高级查询和排序选项">高级查询</a></li>
      <c:choose>
        <c:when test="${param.display == 'long'}">
      <li><a href="<%=this.makeLink(parms, "short")%>" title="简略告警列表">简略列表</a></li>
        </c:when>
        <c:otherwise>
      <li><a href="<%=this.makeLink(parms, "long")%>" title="详细告警列表">详细列表</a></li>
        </c:otherwise>
      </c:choose>
      <li><a href="javascript:void()" onclick="javascript:window.open('<%=Util.calculateUrlBase(req, "alarm/severity.jsp")%>','', 'fullscreen=no,toolbar=no,status=no,menubar=no,scrollbars=no,resizable=yes,directories=no,location=no,width=525,height=158')" title="打开一个窗口，查看告警严重性">告警级别图例</a></li>
      
      <% if( req.isUserInRole( Authentication.ROLE_ADMIN ) || !req.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
        <% if ( alarmCount > 0 ) { %>
          <li>
            <!-- hidden form for acknowledging the result set -->
            <form style="display:inline" method="post" action="<%= Util.calculateUrlBase(req, "alarm/acknowledgeByFilter") %>" name="acknowledge_by_filter_form">
              <input type="hidden" name="redirectParms" value="<c:out value="<%=req.getQueryString()%>"/>" />
              <input type="hidden" name="actionCode" value="<%=action%>" />
              <%=Util.makeHiddenTags(req)%>
            </form>
            <% if( parms.ackType == AcknowledgeType.UNACKNOWLEDGED ) { %> 
              <a href="javascript:void()" onclick="if (confirm('你确定要确认在当前的查询条件下所有的告警，包括那些在屏幕上没有显示的？ (<%=alarmCount%> 条告警)')) { document.acknowledge_by_filter_form.submit(); }" title="确认符合当前查询条件的所有告警，即使是那些没有显示在屏幕上的">确认整个查询</a>
            <% } else { %>
              <a href="javascript:void()" onclick="if (confirm('你确定要取消确认在当前的查询条件下所有的告警，包括那些在屏幕上没有显示的？ (<%=alarmCount%> 条告警)')) { document.acknowledge_by_filter_form.submit(); }" title="取消确认符合当前查询条件的所有告警，即使是那些没有显示在屏幕上的">取消确认整个查询</a>
            <% } %>
          </li>
        <% } %>
      <% } %>
      </ul>
      </div>
      <!-- end menu -->


            <jsp:include page="/includes/alarm-querypanel.jsp" flush="false" />
          
            <% if( alarmCount > 0 ) { %>
              <% String baseUrl = this.makeLink(parms); %>
              <jsp:include page="/includes/resultsIndex.jsp" flush="false" >
                <jsp:param name="count"    value="<%=alarmCount%>" />
                <jsp:param name="baseurl"  value="<%=baseUrl%>"    />
                <jsp:param name="limit"    value="<%=parms.limit%>"      />
                <jsp:param name="multiple" value="<%=parms.multiple%>"   />
              </jsp:include>
            <% } %>          


            <% if( parms.filters.size() > 0 || parms.ackType == AcknowledgeType.UNACKNOWLEDGED || parms.ackType == AcknowledgeType.ACKNOWLEDGED ) { %>
              <% int length = parms.filters.size(); %>
              <p>查询条件:
                  <% if( parms.ackType == AcknowledgeType.UNACKNOWLEDGED ) { %>
                    <span class="filter">活动告警 <a href="<%=this.makeLink(parms, AcknowledgeType.ACKNOWLEDGED)%>" title="显示已确认告警">[-]</a></span>
                  <% } else if( parms.ackType == AcknowledgeType.ACKNOWLEDGED ) { %>
                    <span class="filter">已确认告警 <a href="<%=this.makeLink(parms, AcknowledgeType.UNACKNOWLEDGED)%>" title="显示活动告警">[-]</a></span>
                  <% } %>            
                
                  <% for( int i=0; i < length; i++ ) { %>
                    <% Filter filter = parms.filters.get(i); %>
                    &nbsp; <span class="filter"><%=WebSecurityUtils.sanitizeString(filter.getTextDescription())%> <a href="<%=this.makeLink( parms, filter, false)%>" title="删除过滤条件">[-]</a></span>
                  <% } %>
              </p>           
            <% } %>

      <% if( req.isUserInRole( Authentication.ROLE_ADMIN ) || !req.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
          <form action="<%= Util.calculateUrlBase(request, "alarm/acknowledge") %>" method="post" name="alarm_action_form">
          <input type="hidden" name="redirectParms" value="<c:out value="<%=req.getQueryString()%>"/>" />
          <input type="hidden" name="actionCode" value="<%=action%>" />
          <%=Util.makeHiddenTags(req)%>
      <% } %>
			<jsp:include page="/includes/key.jsp" flush="false" />
      <table>
				<thead>
					<tr>
                                             <% if( req.isUserInRole( Authentication.ROLE_ADMIN ) || !req.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
						<% if ( parms.ackType == AcknowledgeType.UNACKNOWLEDGED ) { %>
						<th width="1%">确认</th>
						<% } else if ( parms.ackType == AcknowledgeType.ACKNOWLEDGED ) { %>
						<th width="1%">取消确认</th>
						<% } else if ( parms.ackType == AcknowledgeType.BOTH ) { %>
						<th width="1%">确认?</th>
						<% } %>
                    <% } else { %>
                        <th width="1%">&nbsp;</th>
                    <% } %>



			<th width="7%">
              <%=this.makeSortLink( parms, SortStyle.ID,        SortStyle.REVERSE_ID,        "id",        "ID" )%>
              <br />
              <%=this.makeSortLink( parms, SortStyle.SEVERITY,  SortStyle.REVERSE_SEVERITY,  "severity",  "级别"  )%>
            </th>
			<th width="19%">
              <%=this.makeSortLink( parms, SortStyle.NODE,      SortStyle.REVERSE_NODE,      "node",      "节点"      )%>
              <c:if test="${param.display == 'long'}">
              <br />
              <%=this.makeSortLink( parms, SortStyle.INTERFACE, SortStyle.REVERSE_INTERFACE, "interface", "接口" )%>
              <br />
              <%=this.makeSortLink( parms, SortStyle.SERVICE,   SortStyle.REVERSE_SERVICE,   "service",   "服务"   )%>
              </c:if>
            </th>
			<th width="3%">
              <%=this.makeSortLink( parms, SortStyle.COUNT,  SortStyle.REVERSE_COUNT,  "count",  "次数"  )%>
            </th>
			<th width="13%">
              <%=this.makeSortLink( parms, SortStyle.LASTEVENTTIME,  SortStyle.REVERSE_LASTEVENTTIME,  "lasteventtime",  "最后事件时间"  )%>
              <c:if test="${param.display == 'long'}">
              <br />
              <%=this.makeSortLink( parms, SortStyle.FIRSTEVENTTIME,  SortStyle.REVERSE_FIRSTEVENTTIME,  "firsteventtime",  "第一个事件时间"  )%>
              <br />
              <% if ( parms.ackType == AcknowledgeType.ACKNOWLEDGED ) { %>
              <%=this.makeSortLink( parms, SortStyle.ACKUSER,  SortStyle.REVERSE_ACKUSER,  "ackuser",  "确认通过"  )%>
              <% } %>
              </c:if>
            </th>
			<th width="56%">日志信息</th>
		</tr>
	</thead>

      <% for( int i=0; i < alarms.length; i++ ) { 
      	Alarm alarm = alarms[i];
      	pageContext.setAttribute("alarm", alarm);
      %> 

        <tr class="<%=alarms[i].getSeverity().getLabel()%>">
          <% if( parms.ackType == AcknowledgeType.BOTH ) { %>
              <td class="divider" valign="middle" rowspan="1">
                <nobr>
                  <input type="checkbox" name="alarm" disabled="true" <%=alarms[i].isAcknowledged() ? "checked='true'" : ""%> /> 
                </nobr>
          <% } else if( req.isUserInRole( Authentication.ROLE_ADMIN ) || !req.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
              <td class="divider" valign="middle" rowspan="1">
                <nobr>
                  <input type="checkbox" name="alarm" value="<%=alarms[i].getId()%>" /> 
                </nobr>
          <% } else { %>
            <td valign="middle" rowspan="1" class="divider">&nbsp;
          <% } %>
          </td>

          
          <td class="divider bright" valign="middle" rowspan="1">
            
            <a style="vertical-align:middle" href="<%= Util.calculateUrlBase(request, "alarm/detail.htm?id=" + alarms[i].getId()) %>"><%=alarms[i].getId()%></a>
            <c:if test="<%= alarms[i].getStickyMemo().getId() != null%>">
                <img style="vertical-align:middle" src="images/AlarmMemos/StickyMemo.png" width="20" height="20" 
		     title="<%=alarms[i].getStickyMemo().getBody() %>"/>
            </c:if>
            <c:if test="<%= alarms[i].getReductionKeyMemo().getId() != null%>">
                <img style="vertical-align:middle" src="images/AlarmMemos/JournalMemo.png" width="20" height="20" 
                     title="<%=alarms[i].getReductionKeyMemo().getBody() %>"/>
            </c:if>

          <c:if test="${param.display == 'long'}">
            <% if(alarms[i].getUei() != null) { %>
              <% Filter exactUEIFilter = new ExactUEIFilter(alarms[i].getUei()); %>
                <br />UEI
              <% if( !parms.filters.contains( exactUEIFilter )) { %>
                <nobr>
                  <a href="<%=this.makeLink( parms, exactUEIFilter, true)%>" class="filterLink" title="只显示此UEI的事件">${addPositiveFilter}</a>
                  <a href="<%=this.makeLink( parms, new NegativeExactUEIFilter(alarms[i].getUei()), true)%>" class="filterLink" title="不显示此UEI的事件">${addNegativeFilter}</a>
                </nobr>
              <% } %>
            <% } else { %>
              &nbsp;
            <% } %>
            <% Filter severityFilter = new SeverityFilter(alarms[i].getSeverity()); %>      
            <% if( !parms.filters.contains( severityFilter )) { %>
		<br />Sev.
              <nobr>
                <a href="<%=this.makeLink( parms, severityFilter, true)%>" class="filterLink" title="只显示此级别的告警">${addPositiveFilter}</a>
                <a href="<%=this.makeLink( parms, new NegativeSeverityFilter(alarms[i].getSeverity()), true)%>" class="filterLink" title="不只显示此级别的告警">${addNegativeFilter}</a>

              </nobr>
            <% } %>
          </c:if>
          </td>
          <td class="divider">
	    <% if(alarms[i].getNodeId() != 0 && alarms[i].getNodeLabel()!= null ) { %>
              <% Filter nodeFilter = new NodeFilter(alarms[i].getNodeId(), getServletContext()); %>             
              <% String[] labels = this.getNodeLabels( alarms[i].getNodeLabel() ); %>
              <a href="element/node.jsp?node=<%=alarms[i].getNodeId()%>" title="<%=labels[1]%>"><%=labels[0]%></a>
                    
              <% if( !parms.filters.contains(nodeFilter) ) { %>
                <nobr>
                  <a href="<%=this.makeLink( parms, nodeFilter, true)%>" class="filterLink" title="只显示此节点上的告警">${addPositiveFilter}</a>
                  <a href="<%=this.makeLink( parms, new NegativeNodeFilter(alarms[i].getNodeId(), getServletContext()), true)%>" class="filterLink" title="不显示此节点上的告警">${addNegativeFilter}</a>
                </nobr>
              <% } %>
            <% } else { %>
              &nbsp;
            <% } %>
          <c:if test="${param.display == 'long'}">
		<br />
            <% if(alarms[i].getIpAddress() != null ) { %>
              <% Filter intfFilter = new InterfaceFilter(alarms[i].getIpAddress()); %>
              <% if( alarms[i].getNodeId() != 0 ) { %>
                <c:url var="interfaceLink" value="element/interface.jsp">
                  <c:param name="node" value="<%=String.valueOf(alarms[i].getNodeId())%>"/>
                  <c:param name="intf" value="<%=alarms[i].getIpAddress()%>"/>
                </c:url>
                <a href="<c:out value="${interfaceLink}"/>" title="这个接口上的更多信息"><%=alarms[i].getIpAddress()%></a>
              <% } else { %>
                <%=alarms[i].getIpAddress()%>
              <% } %>
              <% if( !parms.filters.contains(intfFilter) ) { %>
                <nobr>
                  <a href="<%=this.makeLink( parms, intfFilter, true)%>" class="filterLink" title="只显示这个IP地址上的告警">${addPositiveFilter}</a>
                  <a href="<%=this.makeLink( parms, new NegativeInterfaceFilter(alarms[i].getIpAddress()), true)%>" class="filterLink" title="不显示此接口的告警">${addNegativeFilter}</a>
                </nobr>
              <% } %>
            <% } else { %>
              &nbsp;
            <% } %>
          <br />
            <% if(alarms[i].getServiceName() != null && alarms[i].getServiceName() != "") { %>
              <% Filter serviceFilter = new ServiceFilter(alarms[i].getServiceId(), getServletContext()); %>
              <% if( alarms[i].getNodeId() != 0 && alarms[i].getIpAddress() != null ) { %>
                <c:url var="serviceLink" value="element/service.jsp">
                  <c:param name="node" value="<%=String.valueOf(alarms[i].getNodeId())%>"/>
                  <c:param name="intf" value="<%=alarms[i].getIpAddress()%>"/>
                  <c:param name="service" value="<%=String.valueOf(alarms[i].getServiceId())%>"/>
                </c:url>
                <a href="<c:out value="${serviceLink}"/>" title="这个服务上的更多信息"><c:out value="<%=alarms[i].getServiceName()%>"/></a>
              <% } else { %>
                <c:out value="<%=alarms[i].getServiceName()%>"/>
              <% } %>
              <% if( !parms.filters.contains( serviceFilter )) { %>
                <nobr>
                  <a href="<%=this.makeLink( parms, serviceFilter, true)%>" class="filterLink" title="只显示此服务类型的告警">${addPositiveFilter}</a>
                  <a href="<%=this.makeLink( parms, new NegativeServiceFilter(alarms[i].getServiceId(), getServletContext()), true)%>" class="filterLink" title="不显示此服务类型的告警">${addNegativeFilter}</a>
                </nobr>
              <% } %>                            
            <% } %>
            </c:if>
          </td>          
          <td class="divider" valign="middle" rowspan="1" >
	    <% if(alarms[i].getId() > 0 ) { %>           
                <nobr>
                  <a href="event/list.htm?sortby=id&amp;acktype=unack&amp;filter=alarm%3d<%=alarms[i].getId()%>"><%=alarms[i].getCount()%></a>
                </nobr>
            <% } else { %>
            <%=alarms[i].getCount()%>
            <% } %>
          </td>
          <td class="divider">
            <nobr><span title="事件 <%= alarms[i].getLastEventID() %>"><a href="event/detail.htm?id=<%= alarms[i].getLastEventID() %>"><fmt:formatDate value="${alarm.lastEventTime}" type="date" dateStyle="default"/>&nbsp;<fmt:formatDate value="${alarm.lastEventTime}" type="time" pattern="HH:mm:ss"/></a></span></nobr>
            <nobr>
              <a href="<%=this.makeLink( parms, new AfterLastEventTimeFilter(alarms[i].getLastEventTime()), true)%>"  class="filterLink" title="只显示此时间之后发生的告警">${addAfterFilter}</a>            
              <a href="<%=this.makeLink( parms, new BeforeLastEventTimeFilter(alarms[i].getLastEventTime()), true)%>" class="filterLink" title="只显示此时间之前发生的告警">${addBeforeFilter}</a>
            </nobr>
          <c:if test="${param.display == 'long'}">
          <br />
            <nobr><fmt:formatDate value="${alarm.firstEventTime}" type="date" dateStyle="default"/>&nbsp;<fmt:formatDate value="${alarm.firstEventTime}" type="time" pattern="HH:mm:ss"/></nobr>
            <nobr>
              <a href="<%=this.makeLink( parms, new AfterFirstEventTimeFilter(alarms[i].getFirstEventTime()), true)%>"  class="filterLink" title="只显示此时间之后发生的告警">${addAfterFilter}</a>            
              <a href="<%=this.makeLink( parms, new BeforeFirstEventTimeFilter(alarms[i].getFirstEventTime()), true)%>" class="filterLink" title="只显示此时间之前发生的告警">${addBeforeFilter}</a>
            </nobr>
          <br />
              <% if ( parms.ackType == AcknowledgeType.ACKNOWLEDGED ) { %>
			<nobr><%=alarm.getAcknowledgeUser()%></nobr>          
            <nobr>
              <a href="<%=this.makeLink( parms, new AcknowledgedByFilter(alarms[i].getAcknowledgeUser()), true)%>"  class="filterLink" title="Only show alarms ack by this user">${addPositiveFilter}</a>            
              <a href="<%=this.makeLink( parms, new NegativeAcknowledgedByFilter(alarms[i].getAcknowledgeUser()), true)%>" class="filterLink" title="Only show alarms ack by other users">${addNegativeFilter}</a>
            </nobr>
			<% }%>
          </c:if>
          </td>
          <td class="divider"><%=alarms[i].getLogMessage()%></td>
        </tr> 
      <% } /*end for*/%>

      </table>
			<hr />
			 <p><%=alarms.length%> 告警 &nbsp;
      <% if( req.isUserInRole( Authentication.ROLE_ADMIN ) || !req.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
          <input TYPE="reset" />
          <input TYPE="button" VALUE="选择所有" onClick="checkAllCheckboxes()"/>
          <select name="alarmAction">
        <% if( parms.ackType == AcknowledgeType.UNACKNOWLEDGED ) { %>
          <option value="acknowledge">确认告警</option>
        <% } else if( parms.ackType == AcknowledgeType.ACKNOWLEDGED ) { %>
          <option value="unacknowledge">取消确认告警</option>
        <% } %>
          <option value="clear">清除告警</option>
          <option value="escalate">升级告警</option>
          </select>
          <input type="button" value="提交" onClick="submitForm(document.alarm_action_form.alarmAction.value)" />
      <% } %>
        </p>
      </form>

      <%--<br/>
      <% if(req.isUserInRole(Authentication.ROLE_ADMIN)) { %>
        <a HREF="admin/alarms.jsp" title="Acknowledge or Unacknowledge All Alarms">[Acknowledge or Unacknowledge All Alarms]</a>
      <% } %>--%>

 <!-- id="eventlist" -->

            <% if( alarmCount > 0 ) { %>
              <% String baseUrl = this.makeLink(parms); %>
              <jsp:include page="/includes/resultsIndex.jsp" flush="false" >
                <jsp:param name="count"    value="<%=alarmCount%>" />
                <jsp:param name="baseurl"  value="<%=baseUrl%>"    />
                <jsp:param name="limit"    value="<%=parms.limit%>"      />
                <jsp:param name="multiple" value="<%=parms.multiple%>"   />
              </jsp:include>
            <% } %>


<jsp:include page="/includes/bookmark.jsp" flush="false" />
<jsp:include page="/includes/footer.jsp" flush="false" />


<%!
    String urlBase;

    protected String makeSortLink( AlarmQueryParms parms, SortStyle style, SortStyle revStyle, String sortString, String title ) {
      StringBuffer buffer = new StringBuffer();

      buffer.append( "<nobr>" );
      
      if( parms.sortStyle == style ) {
          buffer.append( "<img src=\"images/arrowdown.gif\" hspace=\"0\" vspace=\"0\" border=\"0\" alt=\"" );
          buffer.append( title );
          buffer.append( " 升序\"/>" );
          buffer.append( "&nbsp;<a href=\"" );
          buffer.append( this.makeLink( parms, revStyle ));
          buffer.append( "\" title=\"反向排序\">" );
      } else if( parms.sortStyle == revStyle ) {
          buffer.append( "<img src=\"images/arrowup.gif\" hspace=\"0\" vspace=\"0\" border=\"0\" alt=\"" );
          buffer.append( title );
          buffer.append( " Descending Sort\"/>" );
          buffer.append( "&nbsp;<a href=\"" );
          buffer.append( this.makeLink( parms, style )); 
          buffer.append( "\" title=\"反向排序\">" );
      } else {
          buffer.append( "<a href=\"" );
          buffer.append( this.makeLink( parms, style ));
          buffer.append( "\" title=\"排序" );
          buffer.append( sortString );
          buffer.append( "\">" );   
      }

      buffer.append( title );
      buffer.append( "</a>" );

      buffer.append( "</nobr>" );

      return( buffer.toString() );
    }

    
    public String getFiltersAsString(List<Filter> filters ) {
        StringBuffer buffer = new StringBuffer();
    
        if( filters != null ) {
            for( int i=0; i < filters.size(); i++ ) {
                buffer.append( "&amp;filter=" );
                String filterString = AlarmUtil.getFilterString(filters.get(i));
                buffer.append(Util.encode(filterString));
            }
        }      
    
        return( buffer.toString() );
    }
    
    public String makeLink( SortStyle sortStyle, AcknowledgeType ackType, List<Filter> filters, int limit, String display ) {
      StringBuffer buffer = new StringBuffer( this.urlBase );
      buffer.append( "?sortby=" );
      buffer.append( sortStyle.getShortName() );
      buffer.append( "&amp;acktype=" );
      buffer.append( ackType.getShortName() );
      if (limit > 0) {
          buffer.append( "&amp;limit=" ).append(limit);
      }
      if (display != null) {
          buffer.append( "&amp;display=" ).append(display);
      }
      buffer.append( this.getFiltersAsString(filters) );

      return( buffer.toString() );
    }

    public String eventMakeLink( AlarmQueryParms parms, Filter filter, boolean add ) {
      List<Filter> filters = new ArrayList<Filter>( parms.filters );
      if( add ) {
        filters.add( filter );
      }
      else {
        filters.remove( filter );
      }
      StringBuffer buffer = new StringBuffer( "event/list.htm" );
      buffer.append( "?sortby=" );
      buffer.append( parms.sortStyle.getShortName() );
      buffer.append( "&amp;acktype=" );
      buffer.append( parms.ackType.getShortName() );
      buffer.append( this.getFiltersAsString(filters) );

      return( buffer.toString() );
    }


    public String makeLink( AlarmQueryParms parms ) {
      return( this.makeLink( parms.sortStyle, parms.ackType, parms.filters, parms.limit, parms.display) );
    }

    public String makeLink(AlarmQueryParms parms, String display) {
      return makeLink(parms.sortStyle, parms.ackType, parms.filters, parms.limit, display);
    }

    public String makeLink( AlarmQueryParms parms, SortStyle sortStyle ) {
      return( this.makeLink( sortStyle, parms.ackType, parms.filters, parms.limit, parms.display) );
    }


    public String makeLink( AlarmQueryParms parms, AcknowledgeType ackType ) {
      return( this.makeLink( parms.sortStyle, ackType, parms.filters, parms.limit, parms.display) );
    }


    public String makeLink( AlarmQueryParms parms, List<Filter> filters ) {
      return( this.makeLink( parms.sortStyle, parms.ackType, filters, parms.limit, parms.display) );
    }

    public String makeLink( AlarmQueryParms parms, Filter filter, boolean add ) {
      List<Filter> newList = new ArrayList<Filter>( parms.filters );
      if( add ) {
        newList.add( filter );
      }
      else {
        newList.remove( filter );
      }

      return( this.makeLink( parms.sortStyle, parms.ackType, newList, parms.limit, parms.display ));
    }

    public String[] getNodeLabels( String nodeLabel ) {
        String[] labels = null;

        if( nodeLabel.length() > 32 ) {
            String shortLabel = nodeLabel.substring( 0, 31 ) + "...";                        
            labels = new String[] { shortLabel, nodeLabel };
        }
        else {
            labels = new String[] { nodeLabel, nodeLabel };
        }

        return( labels );
    }

%>
