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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="添加接口" />
  <jsp:param name="headTitle" value="添加接口" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="添加接口" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/ipv6.js'></script>" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/lib/jsbn.js'></script>" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/lib/jsbn2.js'></script>" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/lib/sprintf.js'></script>" />
</jsp:include>

<%--
 XXX Can't do this because body is in the header:
	onLoad="document.newIpForm.ipAddress.focus()"
--%>


<script type="text/javascript">
        function verifyIpAddress () {
                var prompt = new String("IP Address");
                var errorMsg = new String("");
                var ipValue = new String(document.newIpForm.ipAddress.value);

                if (!isValidIPAddress(ipValue)) {
                        alert (ipValue + "不是一个有效的IP地址！");
						return false;
                }
                else{
                        document.newIpForm.action="admin/addNewInterface";
                        return true;
                }
        }
    
        function cancel()
        {
                document.newIpForm.action="admin/index.jsp";
                document.newIpForm.submit();
        }
</script>

<div class="TwoColLAdmin">
<form method="post" name="newIpForm" onsubmit="return verifyIpAddress();">
  <h3>输入IP地址</h3>
  <div class="boxWrapper">
    <c:if test="${param.action == 'redo'}">
      <ul class="error">
        <li>
          IP地址 ${param.ipAddress}已经存在。请输入一个不同的IP地址。
        </li>
      </ul>
    </c:if>

    <p>
      IP地址:
      <input size="15" name="ipAddress">
    </p>

    <p>
      <input type="submit" value="添加">
      <input type="button" value="取消" onclick="cancel()">
    </p>

  </div>
</form>
</div>

        <div class="TwoColRAdmin">
      <h3>添加接口</h3>
        <p>
        输入一个有效 IP地址来产生一个添加节点的事件。这将添加一个节点到OpenNMS数据库。注意:如果IP地址已经存在，则会用重新扫描来更新这个节点的信息，即使这个IP上没有任何服务，节点仍然会被添加。
        </p>
  </div>
  <hr />

<jsp:include page="/includes/footer.jsp" flush="false" />
