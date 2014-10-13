<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2007-2011 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2011 The OpenNMS Group, Inc.
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
	isErrorPage="true"
	import="org.opennms.web.alarm.*"
%>

<%
     AlarmIdNotFoundException einfe = null;
    
    if( exception instanceof AlarmIdNotFoundException ) {
        einfe = (AlarmIdNotFoundException)exception;
    }
    else if( exception instanceof ServletException ) {
        einfe = (AlarmIdNotFoundException)((ServletException)exception).getRootCause();
    }
    else {
        throw new ServletException( "This error page does not handle this exception type.", exception );
    }
%>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="错误" />
  <jsp:param name="headTitle" value="告警ID没有发现" />
  <jsp:param name="headTitle" value="错误" />
  <jsp:param name="breadcrumb" value="错误" />
</jsp:include>

<h1>告警ID没有发现</h1>

<p>
  告警ID <%=einfe.getBadID()%> 是无效的。 <%=einfe.getMessage()%>
  <br/>
  你可以重新进入这里查看或 <a href="alarm/list.htm?acktyp=unack">浏览全部
  找到你正在寻找的告警。</a> to find the alarm you are looking for.
</p>

<form method="get" action="alarm/detail.jsp">
  <p>
    获取告警根据ID:
    <br/>
    <input type="text" name="id"/>
    <input type="submit" value="查询"/>
  </p>
</form>

<jsp:include page="/includes/footer.jsp" flush="false" />
