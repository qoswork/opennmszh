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

<%@page language="java" contentType="text/html" session="true" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ec" uri="http://www.extremecomponents.org" %>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="统计报表列表" />
  <jsp:param name="headTitle" value="统计报表列表" />
  <jsp:param name="location" value="reports" />
  <jsp:param name="breadcrumb" value="<a href='report/index.jsp'>报表</a>"/>
  <jsp:param name="breadcrumb" value="<a href='statisticsReports/index.htm'>统计报表</a>"/>
  <jsp:param name="breadcrumb" value="列表"/>
</jsp:include>

<c:choose>
  <c:when test="${empty model}">
    <h3>报表列表</h3>
    <div class="boxWrapper">
      <p>
        没有发现。
      </p>
    </div>
  </c:when>

  <c:otherwise>
    <!-- We need the </script>, otherwise IE7 breaks -->
    <script type="text/javascript" src="js/extremecomponents.js"></script>
      
    <link rel="stylesheet" type="text/css" href="css/onms-extremecomponents.css"/>
        
    <form id="form" action="${relativeRequestPath}" method="post">
      <ec:table items="model" var="row"
        action="${relativeRequestPath}?${pageContext.request.queryString}"
        filterable="true"
        imagePath="images/table/compact/*.gif"
        title="统计报表列表"
        tableId="reportList"
        form="form"
        rowsDisplayed="25"
        view="org.opennms.web.svclayer.etable.FixedRowCompact"
        showExports="true" showStatusBar="true" 
        autoIncludeParameters="false"
        >
      
        <ec:exportPdf fileName="统计报表列表.pdf" tooltip="导出PDF"
          headerColor="black" headerBackgroundColor="#b6c2da"
          headerTitle="统计报表列表" />
        <ec:exportXls fileName="统计报表列表.xls" tooltip="导出Excel" />
      
        <ec:row highlightRow="false">
        <%--
          <ec:column property="name" interceptor="org.opennms.web.svclayer.outage.GroupColumnInterceptor"/>
          --%>

          <ec:column property="description" title="输入过滤内容 <br/> <br/> 报表说明">
          	<c:url var="reportUrl" value="statisticsReports/report.htm">
          		<c:param name="id" value="${row.id}" />
          	</c:url>
          	<a href="${reportUrl}">${row.description}</a>
          </ec:column>

          <ec:column property="startDate" title="输入过滤内容 <br/> <br/> 报表执行时间" cell="date" format="MMM d, yyyy  HH:mm:ss"/>
          <ec:column property="endDate" title="输入过滤内容 <br/> <br/> 报表执行完成时间"  cell="date" format="MMM d, yyyy  HH:mm:ss"/>
		  <ec:column property="duration" title="输入过滤内容 <br/> <br/> 执行周期">
            ${row.durationString}
          </ec:column>
          
          
        <%--
          <ec:column property="jobStartedDate" title="Enter Filter Text Above <br/> <br/> Job Started"  cell="date" format="MMM d, yyyy  HH:mm:ss"/>
          <ec:column property="jobCompletedDate" title="Enter Filter Text Above <br/> <br/> Job Completed"  cell="date" format="MMM d, yyyy  HH:mm:ss"/>
          <ec:column property="Enter Filter Text Above <br/> <br/> jobDuration" title="Job Run Time">
            ${row.jobDurationString}
          </ec:column>
        --%>

          <ec:column property="maxDatumValue" title="输入过滤内容 <br/> <br/> 最大值">
            ${row.maxDatumValue}
          </ec:column>
          <ec:column property="minDatumValue" title="输入过滤内容 <br/> <br/> 最小值">
            ${row.minDatumValue}
          </ec:column>

          <ec:column property="purgeDate" title="输入过滤内容 <br/> <br/> 保存时间" cell="date" format="MMM d, yyyy  HH:mm:ss"/>
        </ec:row>
      </ec:table>
    </form>
  </c:otherwise>
</c:choose>


<jsp:include page="/includes/footer.jsp" flush="false"/>
