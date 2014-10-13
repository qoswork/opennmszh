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
    org.opennms.web.controller.ksc.FormProcReportController
"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<% final String baseHref = org.opennms.web.api.Util.calculateUrlBase( request ); %>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="SNMP自定义性能报表" />
  <jsp:param name="headTitle" value="性能" />
  <jsp:param name="headTitle" value="报表" />
  <jsp:param name="headTitle" value="自定义" />
  <jsp:param name="location" value="自定义报表" />
  <jsp:param name="breadcrumb" value="<a href='report/index.jsp'>报表</a>" />
  <jsp:param name="breadcrumb" value="<a href='KSC/index.htm'>自定义报表</a>" />
  <jsp:param name="breadcrumb" value="自定义报表" />
</jsp:include>


<%-- A script to Save the file --%>
<script type="text/javascript">
    function saveReport()
    {
        document.customize_form.action.value = "<c:out value="<%=FormProcReportController.Actions.Save.toString()%>"/>"; 
        document.customize_form.submit();
    }
 
    function addNewGraph()
    {
        document.customize_form.action.value = "<c:out value="<%=FormProcReportController.Actions.AddGraph.toString()%>"/>"; 
        document.customize_form.submit();
    }
 
    function modifyGraph(graph_index)
    {
        document.customize_form.action.value = "<c:out value="<%=FormProcReportController.Actions.ModGraph.toString()%>"/>"; 
        document.customize_form.graph_index.value = graph_index; 
        document.customize_form.submit();
    }
 
    function deleteGraph(graph_index)
    {
        document.customize_form.action.value = "<c:out value="<%=FormProcReportController.Actions.DelGraph.toString()%>"/>";
        document.customize_form.graph_index.value = graph_index; 
        document.customize_form.submit();
    }
 
    function cancelReport()
    {
        if (confirm("你真的要取消配置的修改？")) {
            setLocation("index.jsp");
        }
    }
    
</script>


<h3>自定义报表配置</h3>
<div class="boxWrapper">
    <form name="customize_form" method="get" action="<%= baseHref %>KSC/formProcReport.htm">
        <input type="hidden" name="<%=FormProcReportController.Parameters.action%>" value="none"/>
        <input type="hidden" name="<%=FormProcReportController.Parameters.graph_index%>" value="-1"/>

        <p>
          标题: 
          <input type="text" name="<%=FormProcReportController.Parameters.report_title%>" value="${title}" size="80" maxlength="80"/>
        </p>

            <table class="normal" width="100%" border="2">
              <c:if test="${fn:length(resultSets) > 0}">
                <c:forEach var="graphNum" begin="0" end="${fn:length(resultSets) - 1}">
                  <c:set var="resultSet" value="${resultSets[graphNum]}"/>
                    <tr>
                        <td>
                            <input type="button" value="修改" onclick="modifyGraph(${graphNum})"/>
                            <br/>
                            <input type="button" value="删除" onclick="deleteGraph(${graphNum})"/>
                        </td>
                        <td align="right">
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
                            <br/>
                            从: ${resultSet.start}
                            <br/>
                            到: ${resultSet.end}
                        </td>
              
                        <td align="left">
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
                  </c:forEach>
                </c:if>
            </table>  

        <p>
            <input type="button" value="添加新图" onclick="addNewGraph()" alt="添加一个新图到报表"/>
        </p>

        <table class="normal">
             <tr>
                 <td class="normal">
                     <c:choose>
                       <c:when test="${showTimeSpan}">
                         <c:set var="checked" value="checked"/>
                       </c:when>
                       
                       <c:otherwise>
                         <c:set var="checked" value=""/>
                       </c:otherwise>
                     </c:choose>
                     <input type="checkbox" name="<%=FormProcReportController.Parameters.show_timespan%>" ${checked} />
                 </td>
                 <td class="normal">
                     显示时间跨度按钮(允许全局操作报表的时间跨度)
                 </td>
             </tr>
             <tr>
                 <td class="normal">
                     <c:choose>
                       <c:when test="${showGraphType}">
                         <c:set var="checked" value="checked"/>
                       </c:when>
                       
                       <c:otherwise>
                         <c:set var="checked" value=""/>
                       </c:otherwise>
                     </c:choose>
                     <input type="checkbox" name="<%=FormProcReportController.Parameters.show_graphtype%>" ${checked} />
                 </td>
                 <td class="normal">
                     显示图类型按钮(允许全局操作报表的预制图类型)
                 </td>
             </tr>
             <tr>
                 <td class="normal">
                        <select name="<%=FormProcReportController.Parameters.graphs_per_line%>">
                           <c:choose>
                             <c:when test="${graphsPerLine == 0}">
                                <option selected value="0">默认</option>
                             </c:when>
                             <c:otherwise>
                                <option value="0">默认</option>
                             </c:otherwise>
                           </c:choose>
                           <c:choose>
                             <c:when test="${graphsPerLine == 1}">
                                <option selected value="1">1</option>
                             </c:when>
                             <c:otherwise>
                                <option value="1">1</option>
                             </c:otherwise>
                           </c:choose>
                           <c:choose>
                             <c:when test="${graphsPerLine == 2}">
                                <option selected value="2">2</option>
                             </c:when>
                             <c:otherwise>
                                <option value="2">2</option>
                             </c:otherwise>
                           </c:choose>
                           <c:choose>
                             <c:when test="${graphsPerLine == 3}">
                                <option selected value="3">3</option>
                             </c:when>
                             <c:otherwise>
                                <option value="3">3</option>
                             </c:otherwise>
                           </c:choose>
                           <c:choose>
                             <c:when test="${graphsPerLine == 4}">
                                <option selected value="4">4</option>
                             </c:when>
                             <c:otherwise>
                                <option value="4">4</option>
                             </c:otherwise>
                           </c:choose>
                           <c:choose>
                             <c:when test="${graphsPerLine == 5}">
                                <option selected value="5">5</option>
                             </c:when>
                             <c:otherwise>
                                <option value="5">5</option>
                             </c:otherwise>
                           </c:choose>
                           <c:choose>
                             <c:when test="${graphsPerLine == 6}">
                                <option selected value="6">6</option>
                             </c:when>
                             <c:otherwise>
                                <option value="6">6</option>
                             </c:otherwise>
                           </c:choose>
                        </select>
                 </td>
                 <td class="normal">
                     在报表中，每行显示的图数量。
                 </td>
             </tr>

        </table> 

        <p>
                <input type="button" value="保存" onclick="saveReport()" alt="报表保存到文件"/>
                <input type="button" value="取消" onclick="cancelReport()" alt="取消报表配置"/>
        </p>

      <p>
              如果你做了任何改动，请确保保存当你完成的报表。只有使用此页上的"保存"按钮才能将变化保存。
      </p>

    </form>
</div>

<jsp:include page="/includes/footer.jsp" flush="false"/>
