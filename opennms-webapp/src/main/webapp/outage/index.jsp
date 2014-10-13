<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2006-2012 The OpenNMS Group, Inc.
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
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="故障" />
  <jsp:param name="headTitle" value="故障" />
  <jsp:param name="location" value="outage" />
  <jsp:param name="breadcrumb" value="故障" />  
</jsp:include>

<script type="text/javascript">
function validateId() {
  var outageId = document.outageIdForm.id.value;
  if (outageId.length > 1 && parseInt(outageId).toString() == outageId) {
    return true;
  } else {
    alert("请输入一个有效的故障ID。");
    return false;
  }
}
</script>

  <div class="TwoColLeft">
      <h3>故障菜单</h3>    
		<div class="boxWrapper">
        <form name="outageIdForm" method="get" action="outage/detail.htm" onsubmit="return validateId();">
          <p align="right">故障ID:
				<input type="text" name="id" />
				<input type="submit" value="查询" /></p>
        </form>
			<ul class="plain">
				<li><a href="outage/list.htm?outtype=current">当前故障</a></li>
				<li><a href="outage/list.htm?outtype=both">所有故障</a></li>
			</ul>
      </div>
  </div>
  <div class="TwoColRight">
      <h3>故障和服务级别可用性</h3>
		<div class="boxWrapper">
			<p>OpenNMS通过轮询服务来跟踪故障。如果本次轮询服务不响应，服务故障将被创建并且影响服务可用性级别。
			服务故障会创建通知。</p>
		</div>
  </div>
  <hr />                                   
<jsp:include page="/includes/footer.jsp" flush="false" />
