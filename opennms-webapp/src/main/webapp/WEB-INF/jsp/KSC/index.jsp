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

<%@page language="java"
  contentType="text/html"
  session="true"
  import="
  org.opennms.web.api.Util,
  org.opennms.web.servlet.XssRequestWrapper
  "
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    final HttpServletRequest req = new XssRequestWrapper(request);
    final String match = req.getParameter("match");
    pageContext.setAttribute("match", match);
    final String baseHref = Util.calculateUrlBase(request);
%>
    
<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="SNMP自定义性能报表" />
  <jsp:param name="headTitle" value="性能" />
  <jsp:param name="headTitle" value="报表" />
  <jsp:param name="headTitle" value="自定义" />
  <jsp:param name="breadcrumb" value="<a href='${baseHref}report/index.jsp'>报表</a>" />
  <jsp:param name="breadcrumb" value="自定义报表" />
</jsp:include>

<div class="TwoColLeft">
 
  <h3 class="o-box">自定义报表</h3>

  <div class="boxWrapper">
  <p>从下面的列表中选择你要查看或修改的报表标题。有${fn:length(reports)}个自定义报告可供选择。</p>
	<script type="text/javascript">
		var customData = {total:"${fn:length(reports)}", records:[
											<c:set var="first" value="true"/>
											<c:forEach var="report" items="${reports}">
											  <c:if test="${match == null || match == '' || fn:containsIgnoreCase(report.value,match)}">
											    <c:choose>
											      <c:when test="${first == true}">
												<c:set var="first" value="false"/>
											        {id:"${report.key}", value:"${report.value}", type:"custom"}
											      </c:when>
											      <c:otherwise>
											        ,{id:"${report.key}", value:"${report.value}", type:"custom"}
											      </c:otherwise>
											    </c:choose>
											  </c:if>
											</c:forEach>
				                             ]};
		
		
	</script>
    <opennms:kscCustomReportList id="kscReportList" dataObject="customData"></opennms:kscCustomReportList>
    <!-- For IE Only -->
    <div name="opennms-kscCustomReportList" id="kscReportList-ie" dataObject="customData"></div>
  </div>

  <h3 class="o-box">节点和域的接口报表</h3>
  <div class="boxWrapper">
  <p>选择想要查看性能报表的资源</p>
    <script type="text/javascript">
      var standardResourceData = {total:"${fn:length(topLevelResources)}", records:[
												<c:set var="first" value="true"/>
												<c:forEach var="resource" items="${topLevelResources}" varStatus="resourceCount">
												  <c:if test="${match == null || match == '' || fn:containsIgnoreCase(resource.label,match)}">
												    <c:choose>
												      <c:when test="${first == true}">
													    <c:set var="first" value="false"/>
													    {id:"${resource.name}", value:"${resource.resourceType.label}: ${resource.label}", type:"${resource.resourceType.name}"}
												      </c:when>
												      <c:otherwise>
													    ,{id:"${resource.name}", value:"${resource.resourceType.label}: ${resource.label}", type:"${resource.resourceType.name}"}
												      </c:otherwise>
												    </c:choose>
												  </c:if>
												</c:forEach>
      	                                  	]};
    </script>
    <div id="snmp-reports"></div>
    <opennms:nodeSnmpReportList id="nodeSnmpList" dataObject="standardResourceData"></opennms:nodeSnmpReportList>
    <div name="opennms-nodeSnmpReportList" id="nodeSnmpList-ie" dataObject="standardResourceData"></div>
  </div>

</div>

<div class="TwoColRight">
  <h3 class="o-box">说明</h3>

  <div class="boxWrapper">
    <p>
      <b>自定义报表</b>
      <c:choose>
        <c:when test="${kscReadOnly == false }">
          allow users to create, view, and edit customized reports containing
        </c:when>
        <c:otherwise>
          allow users to view customized reports containing any number of
        </c:otherwise>
      </c:choose>
    </p>

    <p>
      <b>节点和域接口报表</b>
      <c:choose>
        <c:when test="${kscReadOnly == false }">
          allow users to view automatically generated reports for interfaces on
        </c:when>
        <c:otherwise>
          allow users to view automatically generated reports for interfaces on
        </c:otherwise>
      </c:choose>

    </p>
  </div>
</div>
<script type="text/javascript">
function doReload() {
    if (confirm("你确定要这样做吗？")) {
        document.location = "<%=Util.calculateUrlBase(request, "KSC/index.htm?reloadConfig=true")%>";
    }
}
</script>
<input type="button" onclick="doReload()" value="要求重新载入自定义报表配置"/>

<jsp:include page="/includes/footer.jsp" flush="false"/>
