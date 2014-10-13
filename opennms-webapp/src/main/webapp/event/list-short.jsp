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

<%@page language="java"	contentType="text/html"	session="true" %>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%@page import="org.opennms.core.utils.WebSecurityUtils" %>
<%@page import="org.opennms.web.servlet.XssRequestWrapper" %>
<%@page import="org.opennms.web.springframework.security.Authentication" %>
<%@page import="org.opennms.web.api.Util" %>

<%@page import="org.opennms.web.filter.Filter"%>

<%@page import="org.opennms.web.event.AcknowledgeType" %>
<%@page import="org.opennms.web.event.EventUtil"%>
<%@page import="org.opennms.web.event.Event"%>
<%@page import="org.opennms.web.event.EventQueryParms"%>

<%@page import="org.opennms.web.event.filter.ExactUEIFilter"%>
<%@page import="org.opennms.web.event.filter.NegativeExactUEIFilter"%>
<%@page import="org.opennms.web.event.filter.SeverityFilter"%>
<%@page import="org.opennms.web.event.filter.NegativeSeverityFilter"%>
<%@page import="org.opennms.web.event.filter.AfterDateFilter"%>
<%@page import="org.opennms.web.event.filter.BeforeDateFilter"%>
<%@page import="org.opennms.web.event.filter.NodeFilter"%>
<%@page import="org.opennms.web.event.filter.NegativeNodeFilter"%>
<%@page import="org.opennms.web.event.filter.InterfaceFilter"%>
<%@page import="org.opennms.web.event.filter.NegativeInterfaceFilter"%>
<%@page import="org.opennms.web.event.filter.ServiceFilter"%>
<%@page import="org.opennms.web.event.filter.NegativeServiceFilter"%>
<%@page import="org.opennms.web.event.filter.AcknowledgedByFilter"%>
<%@page import="org.opennms.web.event.filter.NegativeAcknowledgedByFilter"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%--
  This page is written to be the display (view) portion of the EventQueryServlet
  at the /event/list URL.  It will not work by itself, as it requires two request
  attributes be set:
  
  1) events: the list of org.opennms.web.element.Event instances to display
  2) parms: an org.opennms.web.event.EventQueryParms object that holds all the 
     parameters used to make this query
--%>

<%
	XssRequestWrapper req = new XssRequestWrapper(request);

    //required attributes
    Event[] events = (Event[])req.getAttribute( "events" );
    Integer eventCount = (Integer)req.getAttribute( "eventCount" );
    EventQueryParms parms = (EventQueryParms)req.getAttribute( "parms" );

    if( events == null || parms == null ) {
        throw new ServletException( "Missing either the events or parms request attribute." );
    }
    if (eventCount == null) {
	    eventCount = Integer.valueOf(-1);
	}

    String action = null;

    if ( parms.ackType != null ) {
    	action = parms.ackType.getShortName();
    }

    //useful constant strings
    String addPositiveFilterString = "[+]";
    String addNegativeFilterString = "[-]";
    String addBeforeDateFilterString = "[&gt;]";
    String addAfterDateFilterString  = "[&lt;]";    
%>




<%@page import="org.opennms.web.event.AcknowledgeType"%>
<%@page import="org.opennms.web.event.SortStyle"%><jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="事件列表" />
  <jsp:param name="headTitle" value="列表" />
  <jsp:param name="headTitle" value="事件" />
  <jsp:param name="breadcrumb" value="<a href= 'event/index.jsp' title='事件系统页面'>事件</a>" />
  <jsp:param name="breadcrumb" value="列表" />
</jsp:include>

  <script type="text/javascript">
    function checkAllCheckboxes() {
       if( document.acknowledge_form.event.length ) {  
         for( i = 0; i < document.acknowledge_form.event.length; i++ ) {
           document.acknowledge_form.event[i].checked = true
         }
       }
       else {
         document.acknowledge_form.event.checked = true
       }
         
    }
    
    function submitForm(anAction)
    {
        var isChecked = false
        var numChecked = 0;
 
        if (document.acknowledge_form.event.length)
        {
            for( i = 0; i < document.acknowledge_form.event.length; i++ ) 
            {
              //make sure something is checked before proceeding
              if (document.acknowledge_form.event[i].checked)
              {
                isChecked=true;
                numChecked+=1;
              }
            }
            
            if (isChecked && document.acknowledge_form.multiple)
            {
              if (numChecked == parseInt(document.acknowledge_form.event.length)) 
              { 
                var newPageNum = parseInt(document.acknowledge_form.multiple.value) - 1;
                var findVal = "multiple=" + document.acknowledge_form.multiple.value;
                var replaceWith = "multiple=" + newPageNum;
                var tmpRedirect = document.acknowledge_form.redirectParms.value;
                document.acknowledge_form.redirectParms.value = tmpRedirect.replace(findVal, replaceWith);
                document.acknowledge_form.submit();
              } 
              else 
              {
                document.acknowledge_form.submit();
              }
            }
            else if (isChecked)
            {
              document.acknowledge_form.submit();
            }
            else
            {
                alert("请选中你想" + anAction + "的事件。");
            }
        }
        else
        {
            if (document.acknowledge_form.event.checked)
            {
                document.acknowledge_form.submit();
            }
            else
            {
                alert("请选中你想" + anAction + "的事件。");
            }
        }
    }

  </script>




      <!-- menu -->
      <div id="linkbar">
      <ul>
        <li><a href="<c:out value="<%=this.makeLink( parms, new ArrayList<Filter>())%>"/>" title="删除所有查询条件" >查看所有事件</a></li>
        <li><a href="event/advsearch.jsp" title="更多高级查询和排序选项">高级查询</a></li>
        <li><a href="<%= Util.calculateUrlBase(req, "event/severity.jsp") %>">级别图例</a></li>
      
      <% if( req.isUserInRole( Authentication.ROLE_ADMIN ) || !req.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
        <% if( parms.ackType == AcknowledgeType.UNACKNOWLEDGED ) { %> 
          <% if ( eventCount == -1 ) { %>
            <li><a href="javascript: void document.acknowledge_by_filter_form.submit()" onclick="return confirm('你确定要确认当前查询下的所有事件，包括那些在屏幕上没有显示的？')" title="确认当前查询条件下的所有事件，甚至那些没有显示在屏幕上的">确认整个查询</a></li>
          <% } else { %>
            <li><a href="javascript: void document.acknowledge_by_filter_form.submit()" onclick="return confirm('你确定要确认当前查询下的所有事件，包括那些在屏幕上没有显示的？  (<%=eventCount%> 条事件)')" title="确认当前查询条件下的所有事件，甚至那些没有显示在屏幕上的">确认整个查询</a></li>
          <% } %>
        <% } else { %>
          <% if ( eventCount == -1 ) { %>
            <li><a href="javascript: void document.acknowledge_by_filter_form.submit()" onclick="return confirm('你确定要取消确认当前查询下的所有事件，包括那些在屏幕上没有显示的？')" title="取消确认当前查询条件下的所有事件，甚至那些没有显示在屏幕上的">取消确认整个查询</a></li>
          <% } else { %>
            <li><a href="javascript: void document.acknowledge_by_filter_form.submit()" onclick="return confirm('你确定要取消确认当前查询下的所有事件，包括那些在屏幕上没有显示的？  (<%=eventCount%> 条事件)')" title="取消确认当前查询条件下的所有事件，甚至那些没有显示在屏幕上的">取消确认整个查询</a></li>
          <% } %>
        <% } %>
      <% } %>
      </ul>
      </div>
      <!-- end menu -->


      <!-- hidden form for acknowledging the result set --> 
      <form action="event/acknowledgeByFilter" method="post" name="acknowledge_by_filter_form">    
        <input type="hidden" name="redirectParms" value="<c:out value="<%=req.getQueryString()%>"/>" />
        <input type="hidden" name="action" value="<%=action%>" />
        <%=org.opennms.web.api.Util.makeHiddenTags(req)%>
      </form>      

      <jsp:include page="/includes/event-querypanel.jsp" flush="false" />

            <% if( events.length > 0 ) { %>
              <% String baseUrl = this.makeLink(parms); %>
              <% if ( eventCount == -1 ) { %>
                <jsp:include page="/includes/resultsIndexNoCount.jsp" flush="false" >
                  <jsp:param name="itemCount"    value="<%=events.length%>" />
                  <jsp:param name="baseurl"  value="<%=baseUrl%>"    />
                  <jsp:param name="limit"    value="<%=parms.limit%>"      />
                  <jsp:param name="multiple" value="<%=parms.multiple%>"   />
                </jsp:include>
              <% } else { %>
                <jsp:include page="/includes/resultsIndex.jsp" flush="false" >
                  <jsp:param name="count"    value="<%=eventCount%>" />
                  <jsp:param name="baseurl"  value="<%=baseUrl%>"    />
                  <jsp:param name="limit"    value="<%=parms.limit%>"      />
                  <jsp:param name="multiple" value="<%=parms.multiple%>"   />
                </jsp:include>
              <% } %>
            <% } %>          

            <% if( parms.filters.size() > 0 || parms.ackType == AcknowledgeType.UNACKNOWLEDGED || parms.ackType == AcknowledgeType.ACKNOWLEDGED ) { %>
              <% int length = parms.filters.size(); %>

              <p>查询条件:
                  <% if( parms.ackType == AcknowledgeType.UNACKNOWLEDGED ) { %>
                  <span class="filter">活动事件 <a href="<c:out value="<%=this.makeLink(parms, AcknowledgeType.ACKNOWLEDGED)%>"/>" title="显示已确认事件">[-]</a></span>
                  <% } else if( parms.ackType == AcknowledgeType.ACKNOWLEDGED ) { %>
                  <span class="filter">已确认事件 <a href="<c:out value="<%=this.makeLink(parms, AcknowledgeType.UNACKNOWLEDGED)%>"/>" title="显示活动事件">[-]</a></span>
                  <% } %>
									<% for( int i=0; i < length; i++ ) { %>
									  <% Filter filter = (Filter)parms.filters.get(i); %>
									    &nbsp; <span class="filter"><%=WebSecurityUtils.sanitizeString(filter.getTextDescription())%> <a href="<c:out value="<%=this.makeLink( parms, filter, false)%>"/>" title="删除过滤条件">[-]</a></span>
									<% } %>
              </p>           
            <% } %>

    <% if( req.isUserInRole( Authentication.ROLE_ADMIN ) || !req.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
      <form action="event/acknowledge" method="post" name="acknowledge_form">
        <input type="hidden" name="redirectParms" value="<c:out value="<%=req.getQueryString()%>"/>"/>
        <input type="hidden" name="action" value="<%=action%>" />
        <%=org.opennms.web.api.Util.makeHiddenTags(req)%>
    <% } %>
		<jsp:include page="/includes/key.jsp" flush="false" />
      <table>
        <thead>
        <tr>
					<th></th>
          <th><%=this.makeSortLink( parms, SortStyle.ID,        SortStyle.REVERSE_ID,        "id",        "ID" )%></th>
          <th><%=this.makeSortLink( parms, SortStyle.SEVERITY,  SortStyle.REVERSE_SEVERITY,  "severity",  "级别"  )%></th>
          <th><%=this.makeSortLink( parms, SortStyle.TIME,      SortStyle.REVERSE_TIME,      "time",      "时间"      )%></th>
          <th><%=this.makeSortLink( parms, SortStyle.NODE,      SortStyle.REVERSE_NODE,      "node",      "节点"      )%></th>
          <th><%=this.makeSortLink( parms, SortStyle.INTERFACE, SortStyle.REVERSE_INTERFACE, "interface", "接口" )%></th>
          <th><%=this.makeSortLink( parms, SortStyle.SERVICE,   SortStyle.REVERSE_SERVICE,   "service",   "服务"   )%></th>
          <th>已确认</th>
        </tr>
        </thead>     
      <% for( int i=0; i < events.length; i++ ) {
        Event event = events[i];
        pageContext.setAttribute("event", event);
      %>
        <tr class="<%= events[i].getSeverity().getLabel() %>">
          <% if( req.isUserInRole( Authentication.ROLE_ADMIN ) || !req.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
          <td><input type="checkbox" name="event" value="<%=events[i].getId()%>" /></td>
            <% } %>
          <td class="noWrap"><a href="event/detail.jsp?id=<%=events[i].getId()%>"><%=events[i].getId()%></a>
						<% if(events[i].getUei() != null) { %>
	            <% Filter exactUEIFilter = new ExactUEIFilter(events[i].getUei()); %>
	              <abbr title="<%=events[i].getUei()%>">UEI</abbr>
	            <% if( !parms.filters.contains( exactUEIFilter )) { %>
	                <a href="<c:out value="<%=this.makeLink( parms, exactUEIFilter, true)%>"/>" class="filterLink" title="只显示此UEI的事件"><%=addPositiveFilterString%></a>
	                <a href="<c:out value="<%=this.makeLink( parms, new NegativeExactUEIFilter(events[i].getUei()), true)%>"/>" class="filterLink" title="不显示此UEI的事件"><%=addNegativeFilterString%></a>
	            <% } %>                            
	          <% } %>
						</td>

          <td class="bright noWrap"> 
            <%= events[i].getSeverity().getLabel() %>
            <% Filter severityFilter = new SeverityFilter(events[i].getSeverity()); %>      
            <% if( !parms.filters.contains( severityFilter )) { %>
                <a href="<c:out value="<%=this.makeLink( parms, severityFilter, true)%>"/>" class="filterLink" title="只显示此级别的事件"><%=addPositiveFilterString%></a>
                <a href="<c:out value="<%=this.makeLink( parms, new NegativeSeverityFilter(events[i].getSeverity()), true)%>"/>" class="filterLink" title="不显示此级别的事件"><%=addNegativeFilterString%></a>
            <% } %>
          </td>
          <td class="noWrap">
	              <a href="<c:out value="<%=this.makeLink( parms, new AfterDateFilter(events[i].getTime()), true)%>"/>"  class="filterLink" title="只显示此事件发生之后"><%=addAfterDateFilterString%></a> 
								<fmt:formatDate value="${event.time}" type="date" dateStyle="default"/>&nbsp;<fmt:formatDate value="${event.time}" type="time" pattern="HH:mm:ss"/>           
              <a href="<c:out value="<%=this.makeLink( parms, new BeforeDateFilter(events[i].getTime()), true)%>"/>" class="filterLink" title="只显示此事件发生之前"><%=addBeforeDateFilterString%></a>
          </td>
          <td class="noWrap">
	    <% if(events[i].getNodeId() != 0 && events[i].getNodeLabel()!= null ) { %>
              <% Filter nodeFilter = new NodeFilter(events[i].getNodeId(), getServletContext()); %>             
              <% String[] labels = this.getNodeLabels( events[i].getNodeLabel() ); %>
              <a href="element/node.jsp?node=<%=events[i].getNodeId()%>" title="<%=labels[1]%>"><c:out value="<%=labels[0]%>"/></a>
              <% if( !parms.filters.contains(nodeFilter) ) { %>
                  <a href="<c:out value="<%=this.makeLink( parms, nodeFilter, true)%>"/>" class="filterLink" title="只显示此节点的事件"><%=addPositiveFilterString%></a>
                  <a href="<c:out value="<%=this.makeLink( parms, new NegativeNodeFilter(events[i].getNodeId(), getServletContext()), true)%>"/>" class="filterLink" title="不显示此节点的事件"><%=addNegativeFilterString%></a>
              <% } %>
            <% } %>
          </td>
          <td class="noWrap">
            <% if(events[i].getIpAddress() != null ) { %>
              <% Filter intfFilter = new InterfaceFilter(events[i].getIpAddress()); %>
              <% if( events[i].getNodeId() != 0 ) { %>
                 <c:url var="interfaceLink" value="element/interface.jsp">
                     <c:param name="node" value="<%=String.valueOf(events[i].getNodeId())%>"/>
                     <c:param name="intf" value="<%=events[i].getIpAddress()%>"/>
                 </c:url>
                 <a href="${interfaceLink}" title="这个接口上的更多信息"><%=events[i].getIpAddress()%></a>
              <% } else { %>
                 <%=events[i].getIpAddress()%>
              <% } %>
              <% if( !parms.filters.contains(intfFilter) ) { %>
                  <a href="<c:out value="<%=this.makeLink( parms, intfFilter, true)%>"/>" class="filterLink" title="只显示此IP地址的事件"><%=addPositiveFilterString%></a>
                  <a href="<c:out value="<%=this.makeLink( parms, new NegativeInterfaceFilter(events[i].getIpAddress()), true)%>"/>" class="filterLink" title="不显示此接口的事件"><%=addNegativeFilterString%></a>
              <% } %>
            <% } %>
          </td>
          <td class="noWrap">
            <% if(events[i].getServiceName() != null) { %>
              <% Filter serviceFilter = new ServiceFilter(events[i].getServiceId(), getServletContext()); %>
              <% if( events[i].getNodeId() != 0 && events[i].getIpAddress() != null ) { %>
                <c:url var="serviceLink" value="element/service.jsp">
                  <c:param name="node" value="<%=String.valueOf(events[i].getNodeId())%>"/>
                  <c:param name="intf" value="<%=events[i].getIpAddress()%>"/>
                  <c:param name="service" value="<%=String.valueOf(events[i].getServiceId())%>"/>
                </c:url>
                <a href="${serviceLink}" title="这个服务上的更多信息"><c:out value="<%=events[i].getServiceName()%>"/></a>
              <% } else { %>
                <c:out value="<%=events[i].getServiceName()%>"/>
              <% } %>
              <% if( !parms.filters.contains( serviceFilter )) { %>
                  <a href="<c:out value="<%=this.makeLink( parms, serviceFilter, true)%>"/>" class="filterLink" title="只显示此服务类型的事件"><%=addPositiveFilterString%></a>
                  <a href="<c:out value="<%=this.makeLink( parms, new NegativeServiceFilter(events[i].getServiceId(), getServletContext()), true)%>"/>" class="filterLink" title="不显示此服务的事件"><%=addNegativeFilterString%></a>
              <% } %>                            
            <% } %>
          </td>         
          <td><div class="clip">
            <% if (events[i].isAcknowledged()) { %>
              <% Filter acknByFilter = new AcknowledgedByFilter(events[i].getAcknowledgeUser()); %>      
              <%=events[i].getAcknowledgeUser()%>
              <% if( !parms.filters.contains( acknByFilter )) { %>
                <nobr>
                  <a href="<c:out value="<%=this.makeLink( parms, acknByFilter, true)%>"/>" class="filterLink" title="只显示此用户确认的事件"><%=addPositiveFilterString%></a>
                  <a href="<c:out value="<%=this.makeLink( parms, new NegativeAcknowledgedByFilter(events[i].getAcknowledgeUser()), true)%>"/>" class="filterLink" title="不显示此用户确认的事件"><%=addNegativeFilterString%></a>
                </nobr>
              <% } %>              
            <% } %>
						<% if (events[i].isAcknowledged()) { %>
						  <fmt:formatDate value="${event.acknowledgeTime}" type="date" dateStyle="default"/>&nbsp;<fmt:formatDate value="${event.acknowledgeTime}" type="time" pattern="HH:mm:ss"/>
						<% } else { %>
						  &nbsp;
						<% } %>
						</div>
          </td>
        </tr>
       
      <% } /*end for*/%>
      </table>
        <hr />
        <p style="margin-top:10px;"><% if( req.isUserInRole( Authentication.ROLE_ADMIN ) || !req.isUserInRole( Authentication.ROLE_READONLY ) ) { %>
            <% if( parms.ackType == AcknowledgeType.UNACKNOWLEDGED ) { %>
							<input TYPE="reset" />
							<input TYPE="button" VALUE="选择所有" onClick="checkAllCheckboxes()"/>
              <input type="button" value="确认事件" onClick="submitForm('acknowledge')"/>
            <% } else if( parms.ackType == AcknowledgeType.ACKNOWLEDGED ) { %>
              <input TYPE="reset" />
							<input TYPE="button" VALUE="选择所有" onClick="checkAllCheckboxes()"/>
							<input type="button" value="取消确认事件" onClick="submitForm('unacknowledge')"/>
            <% } %>
          <% } %>
        </p>
      </form>

            <% if( events.length > 0 ) { %>
              <% String baseUrl = this.makeLink(parms); %>
              <% if ( eventCount == -1 ) { %>
                <jsp:include page="/includes/resultsIndexNoCount.jsp" flush="false" >
                  <jsp:param name="itemCount"    value="<%=events.length%>" />
                  <jsp:param name="baseurl"  value="<%=baseUrl%>"    />
                  <jsp:param name="limit"    value="<%=parms.limit%>"      />
                  <jsp:param name="multiple" value="<%=parms.multiple%>"   />
                </jsp:include>
              <% } else { %>
                <jsp:include page="/includes/resultsIndex.jsp" flush="false" >
                  <jsp:param name="count"    value="<%=eventCount%>" />
                  <jsp:param name="baseurl"  value="<%=baseUrl%>"    />
                  <jsp:param name="limit"    value="<%=parms.limit%>"      />
                  <jsp:param name="multiple" value="<%=parms.multiple%>"   />
                </jsp:include>
              <% } %>
            <% } %>          

      <%--<br/>
      <% if(req.isUserInRole(Authentication.ROLE_ADMIN)) { %>
        <a HREF="admin/events.jsp" title="确认或取消确认所有事件">[确认或取消确认所有事件]</a>
      <% } %>--%>

<jsp:include page="/includes/footer.jsp" flush="false" />


<%!
    String urlBase = "event/list";

    protected String makeSortLink( EventQueryParms parms, SortStyle style, SortStyle revStyle, String sortString, String title ) {
      StringBuffer buffer = new StringBuffer();

      buffer.append( "<nobr>" );
      
      if( parms.sortStyle == style ) {
          buffer.append( "<img src=\"images/arrowdown.gif\" hspace=\"0\" vspace=\"0\" border=\"0\" alt=\"" );
          buffer.append( title );
          buffer.append( " 升序排序\"/>" );
          buffer.append( "&nbsp;<a href=\"" );
          buffer.append( this.makeLink( parms, revStyle ));
          buffer.append( "\" title=\"反向排序\">" );
      } else if( parms.sortStyle == revStyle ) {
          buffer.append( "<img src=\"images/arrowup.gif\" hspace=\"0\" vspace=\"0\" border=\"0\" alt=\"" );
          buffer.append( title );
          buffer.append( " 降序排序\"/>" );
          buffer.append( "&nbsp;<a href=\"" );
          buffer.append( this.makeLink( parms, style )); 
          buffer.append( "\" title=\"反向排序\">" );
      } else {
          buffer.append( "<a href=\"" );
          buffer.append( this.makeLink( parms, style ));
          buffer.append( "\" title=\"排序 " );
          buffer.append( sortString );
          buffer.append( "\">" );   
      }

      buffer.append( title );
      buffer.append( "</a>" );

      return( buffer.toString() );
    }

    
    public String getFiltersAsString(List<Filter> filters ) {
        StringBuffer buffer = new StringBuffer();
    
        if( filters != null ) {
            for( int i=0; i < filters.size(); i++ ) {
                buffer.append( "&filter=" );
                String filterString = EventUtil.getFilterString(filters.get(i));
                buffer.append( java.net.URLEncoder.encode(filterString) );
            }
        }      
    
        return( buffer.toString() );
    }

    public String makeLink( SortStyle sortStyle, AcknowledgeType ackType, List<Filter> filters, int limit ) {
      StringBuffer buffer = new StringBuffer( this.urlBase );
      buffer.append( "?sortby=" );
      buffer.append( sortStyle.getShortName() );
      buffer.append( "&acktype=" );
      buffer.append( ackType.getShortName() );
      if (limit > 0) {
          buffer.append( "&limit=" ).append(limit);
      }
      buffer.append( this.getFiltersAsString(filters) );

      return( buffer.toString() );
    }


    public String makeLink( EventQueryParms parms ) {
      return( this.makeLink( parms.sortStyle, parms.ackType, parms.filters, parms.limit) );
    }


    public String makeLink( EventQueryParms parms, SortStyle sortStyle ) {
      return( this.makeLink( sortStyle, parms.ackType, parms.filters, parms.limit) );
    }


    public String makeLink( EventQueryParms parms, AcknowledgeType ackType ) {
      return( this.makeLink( parms.sortStyle, ackType, parms.filters, parms.limit) );
    }


    public String makeLink( EventQueryParms parms, List<Filter> filters ) {
      return( this.makeLink( parms.sortStyle, parms.ackType, filters, parms.limit) );
    }


    public String makeLink( EventQueryParms parms, Filter filter, boolean add ) {
      List<Filter> newList = new ArrayList<Filter>( parms.filters );
      if( add ) {
        newList.add( filter );
      }
      else {
        newList.remove( filter );
      }

      return( this.makeLink( parms.sortStyle, parms.ackType, newList, parms.limit ));
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
