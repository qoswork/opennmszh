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

<%@page language="java" contentType="text/html" session="true" import="org.opennms.netmgt.config.discovery.*, org.opennms.web.admin.discovery.ActionDiscoveryServlet" %>
<% 
	response.setDateHeader("Expires", 0);
	response.setHeader("Pragma", "no-cache");
	if (request.getProtocol().equals("HTTP/1.1")) {
		response.setHeader("Cache-Control", "no-cache");
	}

%>

<html>

<head>
  <title>添加排除范围 | 管理 | OpenNMS Web控制台</title>
  <base href="<%=org.opennms.web.api.Util.calculateUrlBase( request )%>" />
  <link rel="stylesheet" type="text/css" href="css/styles.css" />
  <script type='text/javascript' src='js/ipv6/ipv6.js'></script>
  <script type='text/javascript' src='js/ipv6/lib/jsbn.js'></script>
  <script type='text/javascript' src='js/ipv6/lib/jsbn2.js'></script>
  <script type='text/javascript' src='js/ipv6/lib/sprintf.js'></script>

</head>

<body>
<script type="text/javascript">
function v4BigInteger(ip) {
    var a = ip.split('.');
    return parseInt(a[0])*Math.pow(2,24) + parseInt(a[1])*Math.pow(2,16) + parseInt(a[2])*Math.pow(2,8) + parseInt(a[3]);
};

function checkIpRange(ip1, ip2){
    if (verifyIPv4Address(ip1) && verifyIPv4Address(ip2)) {
        var a = v4BigInteger(ip1);
        var b = v4BigInteger(ip2);
        return b >= a;
    }
    if (verifyIPv6Address(ip1) && verifyIPv6Address(ip2)) {
        var a = new v6.Address(ip1).bigInteger();
        var b = new v6.Address(ip2).bigInteger();
        return b.compareTo(a) >= 0;
    }
    return false;
}

function addExcludeRange(){
	if(!isValidIPAddress(document.getElementById("begin").value)){
		alert("Begin Address not valid.");
		document.getElementById("begin").focus();
		return;
	}

	if(!isValidIPAddress(document.getElementById("end").value)){
		alert("End Address not valid.");
		document.getElementById("end").focus();
		return;
	}
	
	if(!checkIpRange(document.getElementById("begin").value, document.getElementById("end").value)){
		alert("Address Range not valid.");
		document.getElementById("end").focus();
		return;
	}
	
	opener.document.getElementById("erbegin").value=document.getElementById("begin").value;
	opener.document.getElementById("erend").value=document.getElementById("end").value;
	opener.document.getElementById("modifyDiscoveryConfig").action=opener.document.getElementById("modifyDiscoveryConfig").action+"?action=<%=ActionDiscoveryServlet.addExcludeRangeAction%>";
	opener.document.getElementById("modifyDiscoveryConfig").submit();
	window.close();
	opener.document.focus();
	
}

</script>

<h3>添加自动发现的排除范围</h3>
<div class="boxWrapper">
		  <p>添加自动发现的排除IP地址范围<br/>
			 输入<i>开始</i> 和 <i>结束</i> IP地址，然后点击 <i>添加</i> 提交。
	      </p>
</div>
<table class="standard">
<tr>
 <td class="standard" align="center" width="35%">开始IP地址:<input type="text" id="begin" name="begin" size="15" value=''/></td>
 <td class="standard" align="center" width="35%">结束IP地址:<input type="text" id="end" name="end" size="15"  value=''/></td>
</tr>
</table>


<input type="button" name="addExcludeRange" id="addExcludeRange" value="添加" onclick="addExcludeRange();" />
<input type="button" name="cancel" id="cancel" value="取消" onclick="window.close();opener.document.focus();" />

<hr/>

</body>

</html>