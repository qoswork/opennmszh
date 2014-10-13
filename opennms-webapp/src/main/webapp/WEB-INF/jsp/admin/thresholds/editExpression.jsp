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

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="表达式门限编辑" />
	<jsp:param name="headTitle" value="编辑表达式门限" />
	<jsp:param name="headTitle" value="门限" />
	<jsp:param name="headTitle" value="管理" />
	<jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
    <jsp:param name="breadcrumb" value="<a href='admin/thresholds/index.jsp'>门限组</a>" />
    <jsp:param name="breadcrumb" value="<a href='admin/thresholds/index.jsp?groupName=${groupName}&editGroup'>编辑组</a>" />
	<jsp:param name="breadcrumb" value="编辑门限" />
</jsp:include>
<h3>编辑表达式门限</h3>

<form name="frm" action="admin/thresholds/index.htm" method="post">
<input type="hidden" name="finishExpressionEdit" value="1"/>
<input type="hidden" name="expressionIndex" value="${expressionIndex}"/>
<input type="hidden" name="groupName" value="${groupName}"/>
<input type="hidden" name="isNew" value="${isNew}"/>
  <table class="normal">
    <tr>
    	<th class="standardheader">类型</th>
    	<th class="standardheader">表达式</th>
    	<th class="standardheader">数据源类型</th>
    	<th class="standardheader">数据源名称</th>
    	<th class="standardheader">门限值</th>
    	<th class="standardheader">恢复值</th>
    	<th class="standardheader">触发</th>
    </tr>
    	<tr>
    		<td class="standard">
    			<select name="type">
    				<c:forEach items="${thresholdTypes}" var="thisType">
   						<c:choose>
  							<c:when test="${expression.type==thisType}">
    							<c:set var="selected">selected="selected"</c:set>
  							</c:when>
	 						<c:otherwise>
	    						<c:set var="selected" value=""/>
	  						</c:otherwise>
						</c:choose>
						<option ${selected} value='${thisType}'>${thisType}</option>
    				</c:forEach>
    			</select>
    		</td>
    		<td class="standard"><input type="text" name="expression" size=30" value="${expression.expression}"/></td>
    		<td class="standard">
    		   	<select name="dsType">
    				<c:forEach items="${dsTypes}" var="thisDsType">
   						<c:choose>
  							<c:when test="${expression.dsType==thisDsType.key}">
    							<c:set var="selected">selected="selected"</c:set>
  							</c:when>
	 						<c:otherwise>
	    						<c:set var="selected" value=""/>
	  						</c:otherwise>
						</c:choose>
						<option ${selected} value='${thisDsType.key}'>${thisDsType.value}</option>
    				</c:forEach>
    			</select></td>
 			<td class="standard"><input type="text" name="dsLabel" size=30" value="${expression.dsLabel}"/></td>
    		<td class="standard"><input type="text" name="value" size=10" value="${expression.value}"/></td>
    		<td class="standard"><input type="text" name="rearm" size=10" value="${expression.rearm}"/></td>
    		<td class="standard"><input type="text" name="trigger" size=10" value="${expression.trigger}"/></td>
    	</tr>
    </table>
    <table class="normal">
         <tr>
                <th class="standardheader">说明</th>
                <th class="standardheader">触发UEI</th>
                <th class="standardheader">恢复UEI</th>
        </tr>
    	<tr>
			<td class="standard"><input type="text" name="description" size="60" value="${expression.description}"/></td>
			<td class="standard"><input type="text" name="triggeredUEI" size="60" value="${expression.triggeredUEI}"/></td>
		    <td class="standard"><input type="text" name="rearmedUEI" size="60" value="${expression.rearmedUEI}"/></td>
    	</tr>
  </table>
  <input type="submit" name="submitAction" value="${saveButtonTitle}"/>
  <input type="submit" name="submitAction" value="${cancelButtonTitle}"/>
  
<input type="hidden" name="filterSelected" value="${filterSelected}"/>
<h3>资源过滤</h3>
<table class="normal">
    <tr><td>过滤操作</td>
    <td><select name="filterOperator">
        <c:forEach items="${filterOperators}" var="thisOperator">
            <c:choose>
                <c:when test="${expression.filterOperator==thisOperator}">
                    <c:set var="selected">selected="selected"</c:set>
                </c:when>
                <c:otherwise>
                    <c:set var="selected" value=""/>
                </c:otherwise>
            </c:choose>
            <option ${selected} value='${thisOperator}'>${thisOperator}</option>
        </c:forEach>
    </select></td></tr>
</table>
<table class="normal">
<tr><th>字段名称</th><th>正则表达式</th><th>操作</th></tr>
  <c:forEach items="${expression.resourceFilter}" var="filter" varStatus="i">
    <tr>
        <c:choose>
          <c:when test="${i.count==filterSelected}">
            <td><input type="text" name="updateFilterField" size="60" value="${filter.field}"/></td>
            <td><input type="text" name="updateFilterRegexp" size="60" value="${filter.content}"/></td>          
            <td><input type="submit" name="submitAction" value="${updateButtonTitle}" onClick="document.frm.filterSelected.value='${i.count}'"/></td>          
          </c:when>
          <c:otherwise>
            <td class="standard"><input type="text" disabled="true" size="60" value="${filter.field}"/></td>
            <td class="standard"><input type="text" disabled="true" size="60" value="${filter.content}"/></td>
            <td><input type="submit" name="submitAction" value="${editButtonTitle}" onClick="document.frm.filterSelected.value='${i.count}'"/>
                <input type="submit" name="submitAction" value="${deleteButtonTitle}" onClick="document.frm.filterSelected.value='${i.count}'"/>
                <input type="submit" name="submitAction" value="${moveUpButtonTitle}" onClick="document.frm.filterSelected.value='${i.count}'"/>
                <input type="submit" name="submitAction" value="${moveDownButtonTitle}" onClick="document.frm.filterSelected.value='${i.count}'"/>
                </td>
          </c:otherwise>
        </c:choose>
    </tr>
  </c:forEach>
    <tr>
        <td><input type="text" name="filterField" size="60"/></td>
        <td><input type="text" name="filterRegexp" size="60"/></td>
        <td><input type="submit" name="submitAction" value="${addFilterButtonTitle}" onClick="setFilterAction('add')"/></td>
    </tr>
</table>
  
</form>
<h3>帮助</h3>
<p>
<b>说明</b>:一个可选的表达式门限描述，以帮助确定他们的目的是什么。<br/>
<b>类型</b>:<br/>
&nbsp;&nbsp;<b>high</b>:触发的数据源的值超过了"门限值"，并重新恢复，当值低于"恢复值"的时候。<br/>
&nbsp;&nbsp;<b>low</b>:触发的数据源的值低于"门限值"，并重新恢复，当值超过了"恢复值"的时候。<br/>
&nbsp;&nbsp;<b>relativeChange</b>:当数据源的值的变化，从一次采集到下一次大于百分比"门限值"触发。恢复值和触发不被使用。
  <br/>
&nbsp;&nbsp;<b>absoluteChange</b>:触发值的变化超过规定数额。恢复值和触发不被使用。<br/>
&nbsp;&nbsp;<b>rearmingAbsoluteChange</b>:像absoluteChange，当值的变化超过规定数额时触发。然而，"触发"用来重新恢复后，多少次的反反复复不变的情况。恢复值不被使用。
  <br/>
<b>表达式</b>:将计算和比较的门限的数学表达式涉及的数据源名称<br/>
<b>数据源类型</b>:"node"对应节点级数据项，"interface"对应接口级数据项。  <br/>
<b>数据源名称</b>:采集的"string"型的数据项的名称作为报告此门限时的名称<br/>
<b>门限值</b>:使用依赖于门限的类型<br/>
<b>恢复值</b>:使用依赖于门限的类型；对于relativeChange门限它是未使用/忽略<br/>
<b>触发</b>:门限的次数必须在"超出"此值时，该门限将被触发。不用于relativeChange门限。<br/>
<b>触发UEI</b>一个自定义的UEI发送到事件系统，当此门限触发时。如果留空，则默认标准门限UEIs。<br/>
<b>恢复UEI</b>一个自定义的UEI发送到事件系统，此门限重新恢复时。如果留空，则默认标准门限UEIs。<br/>
<b>例子UEIs</b>:一个典型的UEI的格式是<i>"uei.opennms.org/&lt;category&gt;/&lt;name&gt;"</i>。建议为门限创建自定义UEIs时，<br/>
你用一个贵公司的名称作为类别，以避免名称冲突。在"名称"部分是你来决定。<br/>
<b>过滤条件操作</b>定义的逻辑函数将被应用在门限过滤器上，决定是否使用门限。<br />
<b>过滤条件</b>:只适用于接口和通用资源。他们按顺序应用。<br/>
&nbsp;&nbsp;<b>操作=OR</b>:如果任何资源匹配，门限将被处理。<br/>
&nbsp;&nbsp;<b>操作=AND</b>:资源必须符合所有过滤器。
</p>
<jsp:include page="/includes/footer.jsp" flush="false"/>
