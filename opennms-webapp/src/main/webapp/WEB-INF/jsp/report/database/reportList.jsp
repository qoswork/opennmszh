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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib tagdir="/WEB-INF/tags/element" prefix="element" %>

<jsp:include page="/includes/header.jsp" flush="false">
    <jsp:param name="title" value="报表列表"/>
    <jsp:param name="headTitle" value="报表列表"/>
    <jsp:param name="breadcrumb" value="<a href='report/index.jsp'>报表</a>"/>
    <jsp:param name="breadcrumb" value="<a href='report/database/index.htm'>数据库</a>"/>
    <jsp:param name="breadcrumb" value="报表列表"/>
</jsp:include>

<c:choose>
    <c:when test="${empty repositoryList}">
        <p>无报表可用。</p>
    </c:when>

    <c:otherwise>
        <c:forEach var="mapEntry" items="${repositoryList}">
            <c:url value="/report/database/reportList.htm" var="pagedLink">
                <c:param name="p_${mapEntry.key.id}" value="~"/>
            </c:url>

            <div class="spacer" style="height: 15px"><!--  --></div>

            <element:pagedList pagedListHolder="${mapEntry.value}" pagedLink="${pagedLink}"/>
            <table>
                <thead>
                <tr>
                    <td colspan="5" id="o-repository-title"><c:out value="${mapEntry.key.displayName}"/></td>
                </tr>
                <tr>
                    <th>名称</th>
                    <th>说明</th>
                    <th colspan="3" style="width: 1px; text-align: center;">操作</th>
                </tr>
                </thead>
                    <%-- // show only current page worth of data --%>
                <c:forEach items="${mapEntry.value.pageList}" var="report">
                    <tr>
                        <td width="25%">${report.displayName}</td>
                        <td>${report.description}</td>
                        <c:choose>
                            <c:when test="${report.allowAccess}">
                                <c:choose>
                                    <c:when test="${report.isOnline}">
                                        <td id="o-report-online"><a
                                                href="report/database/onlineReport.htm?reportId=${report.id}"
                                                title="执行此报表"/></td>
                                    </c:when>
                                    <c:otherwise>
                                        <td>&nbsp;</td>
                                    </c:otherwise>
                                </c:choose>
                                <td id="o-report-deliver"><a
                                        href="report/database/batchReport.htm?reportId=${report.id}&schedule=false"
                                        title="保存报表或发送电子邮件"/></td>
                                <td id="o-report-schedule"><a
                                        href="report/database/batchReport.htm?reportId=${report.id}&schedule=true"
                                        title="创建计划报表"/></td>
                            </c:when>
                            <c:otherwise>
                                <td colspan="3" id="o-report-subscribe"><a href="${mapEntry.key.managementUrl}"
                                                                           id="o-report-subscribe">Get this report!</a>
                                </td>
                            </c:otherwise>
                        </c:choose>
                    </tr>
                </c:forEach>
            </table>
        </c:forEach>
    </c:otherwise>
</c:choose>
<jsp:include page="/includes/footer.jsp" flush="false"/>
