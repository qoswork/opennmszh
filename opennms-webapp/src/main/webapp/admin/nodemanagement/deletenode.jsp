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
	import="org.opennms.web.element.*,
		org.opennms.netmgt.model.OnmsNode,
		org.opennms.core.utils.WebSecurityUtils,
		org.opennms.web.element.NetworkElementFactory,
		org.opennms.web.servlet.MissingParameterException
	"
%>

<%
    int nodeId = -1;
    String nodeIdString = request.getParameter("node");

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
  <jsp:param name="title" value="删除节点" />
  <jsp:param name="headTitle" value="节点管理" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="节点管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="节点管理" />
</jsp:include>

<script type="text/javascript" >

  function applyChanges()
  {
        var hasCheckedItems = false;
        for (var i = 0; i < document.deleteNode.elements.length; i++)
        {
                if (document.deleteNode.elements[i].type == "checkbox")
                {
                        if (document.deleteNode.elements[i].checked)
                        {
                                hasCheckedItems = true;
                                break;
                        }
                }
        }
                
        if (hasCheckedItems)
        {
                // Return true if we want the form to submit, false otherwise
                return confirm("你确定要继续吗？这一操作将永久删除选中的项目，不能撤消。");
        }
        else
        {
                alert("没有节点或数据项被选中！");
                // Return false so that the form is not submitted
                return false;
        }
  }
</script>

<h2>节点:<%=node_db.getLabel()%></h2>

<hr/>

<p>
  要永久删除一个节点(包括及其相关的所有接口，故障，事件和通知)，选中"节点"框并点击"删除"。
</p>

<p>
  选中"数据"框将从系统中删除相关的SNMP性能和响应时间数据。
  注意，在目录删除 <i>之后</i> 有可能删除节点的事件还没有发送到整个系统。因此，系统可能会重新创建一个新目录。在这种情况下，该目录将需要手动删除。
</p>

<p>
  <b>注意:</b> 如果节点设备上任一接口的IP地址仍然配置在自动发现列表中并且可以pings通，那么节点将会被重新发现。为了避免这种情况，你可以从自动发现列表中删除这个IP地址或者将其添加到排除列表中。
</p>

<hr/> 
  
<form method="post" name="deleteNode" action="admin/deleteSelNodes" onSubmit="return applyChanges();">

<h2>节点:<%=node_db.getLabel()%></h2>

<p>
<input type="checkbox" name="nodeCheck" id="nodeCheck" value='<%= nodeId %>'><label for="nodeCheck">节点</label>
</p>

<p>
<input type="checkbox" name="nodeData" id="nodeData" value='<%= nodeId %>'><label for="nodeData">数据</label>
</p>

<input type="submit" value="删除">
<a href="admin/nodemanagement/index.jsp?node=<%=nodeId%>" style="font-size: 11px;">取消</a>

</form>

<jsp:include page="/includes/footer.jsp" flush="true"/>
