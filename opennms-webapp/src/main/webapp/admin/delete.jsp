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
	import="java.io.File,
		java.util.*,
		org.opennms.web.element.NetworkElementFactory,
		org.opennms.web.admin.nodeManagement.*
	"
%>

<%!
    int interfaceIndex;
    int serviceIndex;
%>

<%
    HttpSession userSession = request.getSession(false);
    List nodes = null;
    Integer lineItems= new Integer(0);
    
    interfaceIndex = 0;
    serviceIndex = 0;
    
    if (userSession != null)
    {
  	nodes = (List)userSession.getAttribute("listAll.delete.jsp");
        lineItems = (Integer)userSession.getAttribute("lineItems.delete.jsp");
    }
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="删除节点" />
  <jsp:param name="headTitle" value="删除节点" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="删除节点" />
</jsp:include>

<script type="text/javascript" >

  function applyChanges()
  {
        var hasCheckedItems = false;
        for (var i = 0; i < document.deleteAll.elements.length; i++)
        {
                if (document.deleteAll.elements[i].type == "checkbox")
                {
                        if (document.deleteAll.elements[i].checked)
                        {
                                hasCheckedItems = true;
                                break;
                        }
                }
        }
                
        if (hasCheckedItems)
        {
                if (confirm("你确定要继续吗？这一操作将永久删除选中的节点，并不能撤消。"))
                {
                        document.deleteAll.submit();
                }
        }
        else
        {
                alert("没有节点和数据项被选中！");
        }
  }
  
  function cancel()
  {
      document.deleteAll.action="admin/index.jsp";
      document.deleteAll.submit();
  }
  
  function checkAll()
  {
      for (var c = 0; c < document.deleteAll.elements.length; c++)
      {  
          if (document.deleteAll.elements[c].type == "checkbox")
          {
              document.deleteAll.elements[c].checked = true;
          }
      }
  }
  
  function uncheckAll()
  {
      for (var c = 0; c < document.deleteAll.elements.length; c++)
      {  
          if (document.deleteAll.elements[c].type == "checkbox")
          {
              
              document.deleteAll.elements[c].checked = false;
          }
      }
  }
  
</script>

<form method="post" name="deleteAll" action="admin/deleteSelNodes">

<%
  int midNodeIndex = 1;
  
  if (nodes.size() > 1)
  {
    midNodeIndex = nodes.size()/2;
  }
%>

    <h3>删除节点</h3>

	<P>下面列出了系统中存在的节点。要永久删除一个节点(以及所有相关的接口，服务，故障，事件和通知)，选中节点ID旁边的"删除？"框，并单击"删除节点"。你可以选择多个。
        </P>
	<P>选中"数据？"框会删除系统中的SNMP性能数据和响应时间的目录。请注意，可能系统在还未处理完删除节点操作<i>之前</i>节点目录已被删除。因此，系统的其它模块可能会重新创建目录。在这种情况下，该目录将需要手动删除。
	</P>
        <P><b>注意:</b> 如果节点的接口IP地址仍然配置为自动发现并且可以pings通，那么该节点将被再次发现。为了防止这种情况，可以将IP地址从自动发现配置中删除或者将节点置为取消管理。
        </P>

	<br/>

          <input type="button" value="删除节点" onClick="applyChanges()">
          <input type="button" value="取消" onClick="cancel()">
          <input type="button" value="全选" onClick="checkAll()">
          <input type="button" value="取消全选" onClick="uncheckAll()">
          <input type="reset"><br/>&nbsp;

	<br/>
      
   <% if (nodes.size() > 0) { %>
	<div id="contentleft">
          <table class="standardfirst">
            <tr>
              <td class="standardheader" width="5%" align="center">删除？</td>
              <td class="standardheader" width="5%" align="center">数据？</td>
              <td class="standardheader" width="5%" align="center">节点ID</td>
              <td class="standardheader" width="10%" align="center">节点名称</td>
            </tr>
            
            <%=buildTableRows(nodes, 0, midNodeIndex)%>
            
          </table>
	</div>
          <% } /*end if*/ %>

      <!--see if there is a second column to draw-->
      <% if (midNodeIndex < nodes.size()) { %>
	<div id="contentright">
          <table class="standardfirst">
            <tr>
              <td class="standardheader" width="5%" align="center">删除？</td>
              <td class="standardheader" width="5%" align="center">数据？</td>
              <td class="standardheader" width="5%" align="center">节点ID</td>
              <td class="standardheader" width="10%" align="center">节点名称</td>
            </tr>
            
            <%=buildTableRows(nodes, midNodeIndex, nodes.size())%>
               
          </table>
	</div>
        <% } /*end if */ %>

	<div class="spacer"><!-- --></div>

	<br/>

          <input type="button" value="删除节点" onClick="applyChanges()">
          <input type="button" value="取消" onClick="cancel()"> 
          <input type="button" value="全选" onClick="checkAll()">
          <input type="button" value="取消全选" onClick="uncheckAll()">
          <input type="reset">
</form>


<jsp:include page="/includes/footer.jsp" flush="true"/>

<%!
      public String buildTableRows(List nodes, int start, int stop)
      	throws java.sql.SQLException
      {
          StringBuffer row = new StringBuffer();
          
          for (int i = start; i < stop; i++)
          {
                
                ManagedNode curNode = (ManagedNode)nodes.get(i);
                String nodelabel = NetworkElementFactory.getInstance(getServletContext()).getNodeLabel(curNode.getNodeID());
		int nodeid = curNode.getNodeID();
                 
          row.append("<tr>\n");
          row.append("<td class=\"standard\" width=\"5%\" align=\"center\">");
          row.append("<input type=\"checkbox\" name=\"nodeCheck\" value=\""+ nodeid +"\" >");
          row.append("</td>\n");
          row.append("<td class=\"standard\" width=\"5%\" align=\"center\">");
          row.append("<input type=\"checkbox\" name=\"nodeData\" value=\""+ nodeid +"\" >");
          row.append("</td>\n");
          row.append("<td class=\"standard\" width=\"5%\" align=\"center\">");
	  row.append(nodeid);
          row.append("</td>\n");
          row.append("<td class=\"standard\" width=\"10%\" align=\"left\">");
	  row.append(nodelabel);
          row.append("</td>\n");
          row.append("</tr>\n");
          } /* end i for */
          
          return row.toString();
      }
      
%>
