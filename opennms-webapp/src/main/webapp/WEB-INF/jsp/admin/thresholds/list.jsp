<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2007-2012 The OpenNMS Group, Inc.
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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" import="org.opennms.web.api.Util" %>

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="门限配置" />
	<jsp:param name="headTitle" value="列表" />
	<jsp:param name="headTitle" value="Thresholds" />
	<jsp:param name="headTitle" value="管理" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
    <jsp:param name="breadcrumb" value="门限组" />
</jsp:include>

<h3>门限配置</h3>

<form method="post" name="allGroups">
<table class="standard">
        <tr>
                <th class="standardheader">名称</th>
                <th class="standardheader">RRD资源库</th>
                <th class="standardheader">&nbsp;</th>
        </tr>
        <c:forEach var="mapEntry" items="${groupMap}">
                <tr>
                        <td class="standard">${mapEntry.key}</td>
                        <td class="standard">${mapEntry.value.rrdRepository}</td>
                        <td class="standard"><a href="<%= Util.calculateUrlBase(request, "admin/thresholds/index.htm") %>?groupName=${mapEntry.key}&editGroup">编辑</a></td>
                </tr>
        </c:forEach>
</table>
</form>
<script type="text/javascript">
function doReload() {
    if (confirm("你确定想这样做吗？")) {
        document.location = "<%= Util.calculateUrlBase(request, "admin/thresholds/index.htm") %>?reloadThreshdConfig";
    }
}
</script>
<input type="button" onclick="doReload()" value="要求重新载入门限配置"/>
<jsp:include page="/includes/footer.jsp" flush="false" />
