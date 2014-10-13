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
	org.opennms.web.controller.ksc.FormProcGraphController,
	org.opennms.web.controller.ksc.CustomGraphEditDetailsController
"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% final String baseHref = org.opennms.web.api.Util.calculateUrlBase( request ); %>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="SNMP自定义性能报表" />
  <jsp:param name="headTitle" value="性能 " />
  <jsp:param name="headTitle" value="报表" />
  <jsp:param name="headTitle" value="自定义" />
  <jsp:param name="location" value="自定义报表" />
  <jsp:param name="breadcrumb" value="<a href='report/index.jsp'>报表</a>" />
  <jsp:param name="breadcrumb" value="<a href='KSC/index.htm'>自定义报表</a>" />
  <jsp:param name="breadcrumb" value="自定义图" />
</jsp:include>

<script type="text/javascript">
 
    function saveGraph()
    {
        document.customize_graph.action.value="Save";
        document.customize_graph.submit();
    }

    function chooseResource()
    {
        document.customize_graph.action.value="ChooseResource";
        document.customize_graph.submit();
    }
        
    function updateGraph()
    {
        document.customize_graph.action.value="Update";
        document.customize_graph.submit();
    }
   
    function cancelGraph()
    {
        if (confirm("Do you really want to cancel graph configuration changes?")) {
            document.customize_graph.action.value="Cancel";
            document.customize_graph.submit();
        }
    }
  
</script>

<h2>自定义报表图定义</h2>

  <c:choose>
    <c:when test="${fn:length(prefabGraphs) == 0}">
      <h3>无图可供选择</h3>
      <div class="boxWrapper">
        <p>
          没有可用的图选项。
          这个资源可能没有任何数据可以绘制预制的图。
          尝试选择另一个资源。
          你还可以检查数据采集是否正确和报表定义是否合适。
        </p>
      </div>
    </c:when>
                
    <c:otherwise>
      <h3>示例图</h3>
      <div class="boxWrapper">
                    <table class="normal">
                        <tr>
                            <td class="normal" align="right">
                                ${resultSet.title}
                                <br/>
                                  <c:if test="${!empty resultSet.resource.parent}">
                                    ${resultSet.resource.parent.resourceType.label}:
                                    <c:choose>
                                      <c:when test="${!empty resultSet.resource.parent.link}">
                                        <a href="<c:url value='${resultSet.resource.parent.link}'/>">${resultSet.resource.parent.label}</a>
                                      </c:when>
                                      <c:otherwise>
                                        ${resultSet.resource.parent.label}
                                      </c:otherwise>
                                    </c:choose>
                                    <br />
                                  </c:if>
                              
                                  ${resultSet.resource.resourceType.label}:
                                  <c:choose>
                                    <c:when test="${!empty resultSet.resource.link}">
                                      <a href="<c:url value='${resultSet.resource.link}'/>">${resultSet.resource.label}</a>
                                    </c:when>
                                    <c:otherwise>
                                      ${resultSet.resource.label}
                                    </c:otherwise>
                                  </c:choose>

                                <br/>
                                <b>从</b> ${resultSet.start}
                                <br/>
                                <b>到</b> ${resultSet.end}
                            </td>
              
                            <td class="normal" align="left">
                              <c:url var="graphUrl" value="${baseHref}graph/graph.png">
                                <c:param name="resourceId" value="${resultSet.resource.id}"/>
                                <c:param name="report" value="${resultSet.prefabGraph.name}"/>
                                <c:param name="start" value="${resultSet.start.time}"/>
                                <c:param name="end" value="${resultSet.end.time}"/>
                                <c:param name="zoom" value="true"/>
                              </c:url>
                              
                              <img src="${graphUrl}" alt="资源图: ${resultSet.prefabGraph.title}" />
                            </td>
                        </tr>
                    </table>
      </div>

      <h3>选择图选项</h3>
      <div class="boxWrapper">

      <form name="customize_graph" method="get" action="<%= baseHref %>KSC/formProcGraph.htm" >
        <input type="hidden" name="<%=FormProcGraphController.Parameters.action%>" value="none" />

                    <table class="normal">
                        <tr>
                          <td class="normal">
                            标题
                          </td>
                          <td class="normal">
                            <input type="text" name="<%=FormProcGraphController.Parameters.title%>" value="${resultSet.title}" size="40" maxlength="40"/>
                          </td>
                        </tr>
                        <tr>
                            <td class="normal">
                              时间跨度
                            </td>
                            <td class="normal">
                                <select name="<%=FormProcGraphController.Parameters.timespan%>">
                                  <c:forEach var="option" items="${timeSpans}">
                                    <c:choose>
                                      <c:when test="${timeSpan == option.key}">
                                        <c:set var="timespanSelected">selected="selected"</c:set>
                                      </c:when>
                                      
                                      <c:otherwise>
                                        <c:set var="timespanSelected" value=""/>
                                      </c:otherwise>
                                    </c:choose>
                                    <option value="${option.key}" ${timespanSelected}>${option.value}</option>
                                  </c:forEach>
                                </select>  
                                (选择此报表的相对开始和停止时间) 
                            </td>
                        </tr>
                        <tr>
                            <td class="normal">
                                预制报表
                            </td>
                            <td class="normal">
                                <select name="<%=FormProcGraphController.Parameters.graphtype%>">
                                  <c:forEach var="prefabGraph" items="${prefabGraphs}">
                                    <c:choose>
                                      <c:when test="${resultSet.prefabGraph.name == prefabGraph.name}">
                                        <c:set var="prefabSelected">selected="selected"</c:set>
                                      </c:when>
                                      
                                      <c:otherwise>
                                        <c:set var="prefabSelected" value=""/>
                                      </c:otherwise>
                                    </c:choose>
                                    <option value="${prefabGraph.name}" ${prefabSelected}>${prefabGraph.name}</option>
                                  </c:forEach>
                                </select>  
                                (选择要使用的预制图报表) 
                            </td>
                        </tr>
                        <tr>
                            <td class="normal">
                                <!-- Select Graph Index -->
                                图索引  
                            </td>
                            <td class="normal">
                                <select name="<%=FormProcGraphController.Parameters.graphindex%>">
                                  <c:forEach var="index" begin="1" end="${maxGraphIndex}">
                                    <c:choose>
                                      <c:when test="${index == (graphIndex + 1)}">
                                        <c:set var="indexSelected">selected="selected"</c:set>
                                      </c:when>
                                      
                                      <c:otherwise>
                                        <c:set var="indexSelected" value=""/>
                                      </c:otherwise>
                                    </c:choose>
                                    <option value="${index}" ${indexSelected}>${index}</option>
                                  </c:forEach>
                                </select>  
                                (选择图要插入到报表中所需的位置) 
                            </td>
                        </tr>
                    </table>

                    <input type="button" value="取消编辑这个图" onclick="cancelGraph()" alt="取消此图配置"/>
                    <input type="button" value="刷新示例查看" onclick="updateGraph()" alt="更新改变示例图"/>
                    <input type="button" value="选择不同的资源" onclick="chooseResource()" alt="选择不同的资源作图"/>
                    <input type="button" value="已完成编辑此图" onclick="saveGraph()" alt="此图配置完成"/>
      </form>
      </div>

    </c:otherwise>
  </c:choose>

<jsp:include page="/includes/footer.jsp" flush="false" />
