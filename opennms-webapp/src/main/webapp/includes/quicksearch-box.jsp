<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2010-2012 The OpenNMS Group, Inc.
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
	import="
		java.util.*,
		org.opennms.web.element.*,
		org.opennms.web.asset.*
	"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  pageContext.setAttribute("serviceNameMap", new TreeMap(NetworkElementFactory.getInstance(getServletContext()).getServiceNameToIdMap()).entrySet());
%>
<h3 class="o-box">快速查询</h3>
<div class="boxWrapper">
  <div class="searchHost" style="position:relative; left: 0px;">
    <form action="element/nodeList.htm" method="get">
      <font style="font-size: 70%; line-height: 1.25em; align=left">节点ID:</font><br />
      <input type="hidden" name="listInterfaces" value="false"/>
      <input type="text" size="20" name="nodeId" />
      <input type="submit" value="查询"/>
    </form>
    <form action="element/nodeList.htm" method="get">
      <font style="font-size: 70%; line-height: 1.25em; align=left">节点名称like:</font><br />
      <input type="hidden" name="listInterfaces" value="true"/>
      <input type="text" size="20" name="nodename" />
      <input type="submit" value="查询"/>
    </form>
    <form action="element/nodeList.htm" method="get">
      <font style="font-size: 70%; line-height: 1.25em; align=left">TCP/IP地址like:</font><br />
      <input type="hidden" name="listInterfaces" value="false"/>
      <input type="text" name="iplike" value="" placeholder="*.*.*.*" />
      <input type="submit" value="查询"/>               
    </form>
    <form action="element/nodeList.htm" method="get">
      <font style="font-size: 70%; line-height: 1.25em; align=left">服务:</font><br />
      <input type="hidden" name="listInterfaces" value="false"/>
      <select name="service" size="1">
      <c:forEach var="serviceNameId" items="${serviceNameMap}">
        <option value="${serviceNameId.value}">${serviceNameId.key}</option>
      </c:forEach>
      </select>
      <input type="submit" value="查询"/>               
    </form>
  </div>
</div>
