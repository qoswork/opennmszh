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

<%@ page language="java" contentType="text/html" session="true" import="
	org.opennms.web.controller.ksc.CustomGraphChooseResourceController,
	org.opennms.web.controller.ksc.CustomGraphChooseParentResourceController,
	org.opennms.web.controller.ksc.CustomGraphEditDetailsController
"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% final String baseHref = org.opennms.web.api.Util.calculateUrlBase(request); %>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="SNMP自定义性能报表" />
  <jsp:param name="headTitle" value="选择资源" />
  <jsp:param name="headTitle" value="自定义" />
  <jsp:param name="headTitle" value="报表" />
  <jsp:param name="breadcrumb" value="<a href='${baseHref}report/index.jsp'>报表</a>" />
  <jsp:param name="breadcrumb" value="<a href='${baseHref}KSC/index.htm'>自定义报表</a>" />
  <jsp:param name="breadcrumb" value="自定义图" />
</jsp:include>
<c:set var="totalRecords" value="${fn:length(resources)}"/>
<script type="text/javascript">
	var data = {total:"${totalRecords}", records:[
					<c:forEach var="resource" items="${resources}" varStatus="rowCounter">
					   <c:choose>
					    <c:when test="${rowCounter.count == 1}">
					         {id:"${resource.id}",count:"${rowCounter.count}", value:"${resource.resourceType.label}: ${resource.label}", type:"${resource.resourceType.label}"}
					    </c:when>
					    <c:otherwise>
					         ,{id:"${resource.id}",count:"${rowCounter.count}", value:"${resource.resourceType.label}: ${resource.label}", type:"${resource.resourceType.label}"}
					    </c:otherwise>
					   </c:choose>
					</c:forEach>
		            ]
			}
</script>
  <%--
  <script type="text/javascript" >
  
      function validateResource()
      {
          var isChecked = false
          for (i = 0; i < document.report.resourceId.length; i++) {
              //make sure something is checked before proceeding
              if (document.report.resourceId[i].selected) {
                  isChecked=true;
              }
          }
  
          if (!isChecked) {
              alert("请选择资源，你要添加到报表。");
          }
          return isChecked;
      }
      
      
      function validateResourceSelect()
      {
          var isChecked = false
          for (i = 0; i < document.report.resourceId.length; i++) {
              //make sure something is checked before proceeding
              if (document.report.resourceId[i].selected) {
                  document.reportSelect.resourceId.value = document.report.resourceId[i].value;
                  isChecked=true;
              }
          }
  
          if (!isChecked) {
              alert("请选择资源，你要添加到报表。");
          }
          return isChecked;
      }
  
      function submitForm() {
          if (validateResource()) {
              document.report.submit();
          }
      }
      
      function submitFormSelect() {
          if (validateResourceSelect()) {
              document.reportSelect.submit();
          }
      }
  </script>
  --%>

<h2>
  <c:choose>
    <c:when test="${empty parentResource}">
      顶层
    </c:when>
    
    <c:otherwise>
      <c:if test="${!empty parentResource.parent}">
        ${parentResource.parent.resourceType.label}:
        <c:choose>
          <c:when test="${!empty parentResource.parent.link}">
            <a href="<c:url value='${parentResource.parent.link}'/>">${parentResource.parent.label}</a>
          </c:when>
          <c:otherwise>
            ${parentResource.parent.label}
          </c:otherwise>
        </c:choose>
        <br />
      </c:if>
      
      ${parentResource.resourceType.label}:
      <c:choose>
        <c:when test="${!empty parentResource.link}">
          <a href="<c:url value='${parentResource.link}'/>">${parentResource.label}</a>
        </c:when>
        <c:otherwise>
          ${parentResource.label}
        </c:otherwise>
      </c:choose>
    </c:otherwise>
  </c:choose>
</h2>

<div class="TwoColLeft">

  <h3 class="o-box">选择现有的资源</h3>
  <div class="boxWrapper">
    <c:choose>
      <c:when test="${empty parentResource}">
        <p>
          你目前在顶层资源。
          选择一个子资源。
        </p>
      </c:when>

      <c:when test="${empty parentResourcePrefabGraphs}">
        <p>
          这个资源资源有没有可用预制的图。
          选择一个子资源或父资源(如果有)。
        </p>
      </c:when>

      <c:otherwise>
        <p>
          这个资源有以下预制图:
        </p>
        <ul>
          <c:forEach var="prefabGraph" items="${parentResourcePrefabGraphs}">
            <li>${prefabGraph.name}</li>
          </c:forEach>
        </ul>
        
        <form method="get" name="resourceSelected" action="<%= org.opennms.web.api.Util.calculateUrlBase( request, "KSC/customGraphEditDetails.htm" ) %>" >
          <input type="hidden" name="<%=CustomGraphEditDetailsController.Parameters.resourceId%>" value="${parentResource.id}"/>
          <input type="submit" value="选择此资源"/>
        </form>
      </c:otherwise>
    </c:choose>
  </div>

  <h3 class="o-box">子资源</h3>
  <div class="boxWrapper">
    <c:choose>
      <c:when test="${empty resources}">
        <p>
          没有发现此资源的子资源。
        </p>
      </c:when>
      
      <c:otherwise>
      	<opennms:kscChooseResourceList id="resourceList" dataObject="data" ></opennms:kscChooseResourceList>
      	<div name="opennms-kscChooseResourceList" id="resourceList-ie" dataObject="data" ></div>
        <%-- <form method="get" name="report" action="<%= org.opennms.web.api.Util.calculateUrlBase( request, "KSC/customGraphChooseResource.htm" ) %>" >
          <input type="hidden" name="selectedResourceId" value="${param.selectedResourceId}"/>
          <select name="resourceId" size="10">
            <c:forEach var="resource" items="${resources}">
              <c:set var="selected" value=""/>
              <c:if test="${!empty selectedResourceAndParents[resource.id]}">
                <c:set var="selected">selected="selected"</c:set>
              </c:if>
              <option value="${resource.id}" ${selected}>${resource.resourceType.label}: ${resource.label}</option>
            </c:forEach>
          </select>

          <br/>
          <input type="button" value="子资源" onclick="submitForm()" />
        </form>
        
        <form method="get" name="reportSelect" action="<%= org.opennms.web.api.Util.calculateUrlBase( request, "KSC/customGraphEditDetails.htm" ) %>" >
          <input type="hidden" name="resourceId" value="" />
          <input type="button" value="选择子资源" onclick="submitFormSelect()" />
        </form>--%>
      </c:otherwise>
    </c:choose>
  </div>

  <h3 class="o-box">父资源</h3>
  <div class="boxWrapper">
    <c:choose>
      <c:when test="${empty parentResource}">
        <p>
          这个资源有没有父资源。你正在搜索顶层资源。
        </p>
      </c:when>
      
      <c:when test="${empty parentResource.parent}">
        <p>
          这个资源没有父资源。你可以使用"查看顶层资源"按钮，看到所有的顶层资源。
        </p>
        
        <form method="get" name="viewTopLevel" action="<%= org.opennms.web.api.Util.calculateUrlBase( request, "KSC/customGraphChooseParentResource.htm" ) %>" >
          <input type="hidden" name="<%=CustomGraphChooseParentResourceController.Parameters.selectedResourceId%>" value="${param.selectedResourceId}" />
          <input type="submit" value="顶层资源" />
        </form>
      </c:when>
    
      <c:otherwise>
        <form method="get" name="viewParent" action="<%= org.opennms.web.api.Util.calculateUrlBase( request, "KSC/customGraphChooseResource.htm" ) %>" >
          <input type="hidden" name="<%=CustomGraphChooseResourceController.Parameters.selectedResourceId%>" value="${param.selectedResourceId}"/>
          <input type="hidden" name="<%=CustomGraphChooseResourceController.Parameters.resourceId%>" value="${parentResource.parent.id}"/>
          <input type="submit" value="父资源"/>
        </form>
      </c:otherwise>
    </c:choose>
  </div>

</div>

<div class="TwoColRight">
  <h3 class="o-box">说明</h3>
  <div class="boxWrapper">
    <p>
      The menu on the left lets you choose a specific resource that you want
      to use in a graph.
      A resource can be any graphable resource such as SNMP data (node-level,
      interface-level or generic indexed data), response time data, or
      distributed response time data.
    </p>
    
    <p>
      These resources are organized first by top-level resources, such as
      nodes or domains (if enabled), and then by child resources under the
      top-level resources, like SNMP node-level data, response time data,
      etc..
    </p>
    
    <p>
      The resource you are currently looking at (if any) is shown just below
      the menu-bar on the left side of the page.
      If the resource has any available prefabricated graphs, they will be
      listed in the <b>Choose the current resource</b> box along with a
      "Choose this resource" button which will take you to the graph
      customization page.
    </p>
    
    <p>
      If the current resource has child resources (or if you are at the
      top-level) a list of available child resources will be shown in the
      <b>View child resources</b> box.
      You can select a child resource and click the "View child resource"
      button to view the details of the selected child resource, including
      any available graphs and any sub-children.
      If you know the resource you are selecting has graphs, you can go
      straight to the graph customization page by clicking "Choose child
      resource".
    </p>
    
    <p>
      The <b>View the parent resource</b> box lets you see the parent resource
      of the current resource (or see all top-level resources).
      For example, if you are looking at an SNMP interface resource, its
      parent resource would be the node which owns that SNMP interface.
      If you are looking at a node, you would have the option to see all
      top-level resources.
    </p>
  </div>
</div>

<jsp:include page="/includes/footer.jsp" flush="false" />
