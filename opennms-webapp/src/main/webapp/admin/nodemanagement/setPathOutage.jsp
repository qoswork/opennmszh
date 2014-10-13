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
	import="org.opennms.core.utils.WebSecurityUtils,
		org.opennms.web.element.*,
		org.opennms.netmgt.model.OnmsNode,
		org.opennms.web.servlet.MissingParameterException
	"
%>

<%
    int nodeId = -1;
    String nodeIdString = request.getParameter("node");
    String task = request.getParameter("task");

    if (nodeIdString == null) {
        throw new MissingParameterException("node");
    }

    try {
        nodeId = WebSecurityUtils.safeParseInt(nodeIdString);
    } catch (NumberFormatException numE)  {
        throw new ServletException(numE);
    }
    
    if (nodeId < 0) {
        throw new ServletException("Invalid node ID.");
    }
        
    //get the database node info
    OnmsNode node_db = NetworkElementFactory.getInstance(getServletContext()).getNode(nodeId);
    if (node_db == null) {
        throw new ServletException("No such node in database.");
    }
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="配置路径故障" />
  <jsp:param name="headTitle" value="节点管理" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="节点管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="配置路径故障" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/ipv6.js'></script>" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/lib/jsbn.js'></script>" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/lib/jsbn2.js'></script>" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/lib/sprintf.js'></script>" />
</jsp:include>

<style type="text/css">
LABEL
{
  font-weight: bold;
}
</style>
<script type="text/javascript" >

  function verifyIpAddress() {
    var prompt = new String("IP Address");
    var errorMsg = new String("");
    var ipValue = new String(document.setCriticalPath.criticalIp.value);

    if (!isValidIPAddress(ipValue)) {
        alert (ipValue + " 不是一个有效的IP地址！");
        document.setCriticalPath.action="admin/nodemanagement/setPathOutage.jsp?node=<%=nodeId%>&task=Enter a valid IP address";
        return false;
    } else {
        document.setCriticalPath.action="admin/setCriticalPath?task=Submit";
        return true;
    }
  }


  function deletePathOutage()
  {
      if (confirm("你确定要继续吗？这个操作会删除这个节点上所有的关键路径。"))
      {
          document.setCriticalPath.action="admin/setCriticalPath?task=Delete";
      } else {
          document.setCriticalPath.action="admin/nodemanagement/index.jsp?node=<%=nodeId%>";
      }
      document.setCriticalPath.submit();

  }
  
  function cancel()
  {
      document.setCriticalPath.action="admin/nodemanagement/index.jsp?node=<%=nodeId%>";
      document.setCriticalPath.submit();
  }
</script>

<h2>节点:<%=node_db.getLabel()%></h2>

<% if (task != null) { %>
  <h2><%=task%></h2>
<% } %>

<hr/>

<p>
  配置链路故障由IP地址/服务来定义该节点的关键路径。当节点Down的时候，将测试关键路径。如果关键路径没有响应，那么节点Down的通知将被取消，取而代之将会产生链路故障事件(可以转换为告警))。测试关键路径通常使用ICMP协议，并且目前只能使用ICMP。
  
</p>

<br/> 
  
<form method="post" name="setCriticalPath" action="admin/setCriticalPath" onsubmit="return verifyIpAddress();">

<input name="node" value=<%=nodeId%> type="hidden"/>

<p>
<label for="criticalIp">关键路径IP地址格式:</label><br/>
<input id="criticalIp" type="text" name="criticalIp" size="17" maxlength="15" />
</p>

<p>
<label for="criticalSvc">关键路径服务:</label><br/>

  <select id="criticalSvc" name="criticalSvc" value="ICMP" size="1">
        <option value="ICMP">ICMP</option>
  </select>
</p>

<p>
<input type="submit" name="task" value="提交"/>
&nbsp;
<input type="button" name="task" value="取消" onClick="cancel()"/>
</p>

<br/>

<h2>删除节点关键路径</h2>
<br/>
<p>
<input type="button" name="task" value="删除" onClick="deletePathOutage()"/>
</p>

</form>

<jsp:include page="/includes/footer.jsp" flush="true"/>
