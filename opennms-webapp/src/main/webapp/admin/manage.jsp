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
    
    //EventConfFactory eventFactory = EventConfFactory.getInstance();
    
    interfaceIndex = 0;
    serviceIndex = 0;
    
    if (userSession != null)
    {
		  	nodes = (List)userSession.getAttribute("listAll.manage.jsp");
        lineItems = (Integer)userSession.getAttribute("lineItems.manage.jsp");
    }
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="管理接口和服务" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="管理接口" />
</jsp:include>


<script type="text/javascript" >

  function applyChanges()
  {
      if (confirm("你确定要继续吗？这可能需要几分钟，将所做的更改更新到数据库。"))
      {
          document.manageAll.submit();
      }
  }
  
  function cancel()
  {
      document.manageAll.action="admin/index.jsp";
      document.manageAll.submit();
  }
  
  function checkAll()
  {
      for (var c = 0; c < document.manageAll.elements.length; c++)
      {  
          if (document.manageAll.elements[c].type == "checkbox")
          {
              document.manageAll.elements[c].checked = true;
          }
      }
  }
  
  function uncheckAll()
  {
      for (var c = 0; c < document.manageAll.elements.length; c++)
      {  
          if (document.manageAll.elements[c].type == "checkbox")
          {
              
              document.manageAll.elements[c].checked = false;
          }
      }
  }
  
  function updateServices(interfaceIndex, serviceIndexes)
  {
      for (var i = 0; i < serviceIndexes.length; i++)
      {
          document.manageAll.serviceCheck[serviceIndexes[i]].checked = document.manageAll.interfaceCheck[interfaceIndex].checked;
      }
  }
  
  function verifyManagedInterface(interfaceIndex, serviceIndex)
  {
      //if the service is currently unmanged then the user is trying to manage it,
      //but we need to make sure its interface is managed before we let the service be managed
      if (!document.manageAll.interfaceCheck[interfaceIndex].checked)
      {
          if (document.manageAll.serviceCheck[serviceIndex].checked)
          {
              alert("接口上的服务没有被管理。请将接口上的服务置为管理。");
              document.manageAll.serviceCheck[serviceIndex].checked = false;
              return false;
          }
      }
      
      return true;
  }

</script>


<form method="post" name="manageAll" action="admin/manageNodes">

<%
  int halfway = 0;
  int midCount = 0;
  int midNodeIndex = 0;
  
  if (lineItems.intValue() > 0)
  {
    halfway = lineItems.intValue()/2;
    for (int nodeCount = 0; nodeCount < nodes.size(); nodeCount++)
    {
        if (midCount < halfway)
        {
            midCount++; //one row for each interface
            ManagedInterface curInterface = (ManagedInterface)nodes.get(nodeCount);
            midCount += curInterface.getServiceCount();
        }
        else 
        {
            midNodeIndex = nodeCount;
            break;
        }
    }
  }
%>

    <h3>管理接口和服务</h3>

          <p>下面的列表显示当前管理的节点，接口，服务。状态一列表示当前接口或服务是否被管理，选中代表处于管理，未选中代表取消管理。
          每个不同接口的起始行没有服务列，并且以下是接口上存在的服务。</p>
          <p>接口的管理状态将自动标记接口上服务的管理状态。如果接口标记为取消管理，则其上的服务也为取消管理。
          </p>

          <input type="button" value="应用修改" onClick="applyChanges()">
          <input type="button" value="取消" onClick="cancel()">
          <input type="button" value="全选" onClick="checkAll()">
          <input type="button" value="取消全选" onClick="uncheckAll()">
          <input type="reset"><br/>&nbsp;

	<br/>
      
      <% if (nodes.size() > 0) { %>
	<div id="contentleft">
          <table class="standardfirst">
            <tr>
              <td class="standardheader" width="5%">状态</td>
              <td class="standardheader" width="10%">节点名称</td>
              <td class="standardheader" width="5%">接口</td>
              <td class="standardheader" width="5%">服务</td>
            </tr>
            
            <%=buildManageTableRows(nodes, 0, midNodeIndex)%>
            
          </table>
	</div>
          <% } /*end if*/ %>
        
      <!--see if there is a second column to draw-->
      <% if (midNodeIndex < nodes.size()) { %>
	<div id="contentright">
          <table class="standardfirst">
            <tr>
              <td class="standardheader" width="5%">状态</td>
              <td class="standardheader" width="10%">节点名称</td>
              <td class="standardheader" width="5%">接口</td>
              <td class="standardheader" width="5%">服务</td>
            </tr>
            
            <%=buildManageTableRows(nodes, midNodeIndex, nodes.size())%>
               
          </table>
	</div>
        <% } /*end if */ %>

	<div class="spacer"><!-- --></div>
	<br/>

          <input type="button" value="应用修改" onClick="applyChanges()">
          <input type="button" value="取消" onClick="cancel()"> |
          <input type="button" value="全选" onClick="checkAll()">
          <input type="button" value="取消全选" onClick="uncheckAll()">
          <input type="reset">
</form>


<jsp:include page="/includes/footer.jsp" flush="true"/>

<%!
      public String buildManageTableRows(List nodes, int start, int stop)
      	throws java.sql.SQLException
      {
          StringBuffer rows = new StringBuffer();
          
          for (int i = start; i < stop; i++)
          {
                
                ManagedInterface curInterface = (ManagedInterface)nodes.get(i);
                String nodelabel = NetworkElementFactory.getInstance(getServletContext()).getNodeLabel(curInterface.getNodeid());
		String intKey = curInterface.getNodeid() + "-" + curInterface.getAddress();
                StringBuffer serviceArray = new StringBuffer("[");
                String prepend = "";
                for (int serviceCount = 0; serviceCount < curInterface.getServiceCount(); serviceCount++)
                {
                    serviceArray.append(prepend).append(serviceIndex+serviceCount);
                    prepend = ",";
                }
                serviceArray.append("]");
                
                rows.append(buildInterfaceRow(intKey, 
                                              interfaceIndex, 
                                              serviceArray.toString(), 
                                              (curInterface.getStatus().equals("managed") ? "checked" : ""),
                                              nodelabel,
                                              curInterface.getAddress()));
                    
                  
                List interfaceServices = curInterface.getServices();
                for (int k = 0; k < interfaceServices.size(); k++) 
                {
                     ManagedService curService = (ManagedService)interfaceServices.get(k);
                     String serviceKey = curInterface.getNodeid() + "-" + curInterface.getAddress() + "-" + curService.getId();
                     rows.append(buildServiceRow(serviceKey,
                                                 interfaceIndex,
                                                 serviceIndex,
                                                 (curService.getStatus().equals("managed") ? "checked" : ""),
                                                 nodelabel,
                                                 curInterface.getAddress(),
                                                 curService.getName()));
                     serviceIndex++;
                
                } /*end k for */
                
                interfaceIndex++;
                
          } /* end i for */
          
          return rows.toString();
      }
      
      public String buildInterfaceRow(String key, int interfaceIndex, String serviceArray, String status, String nodeLabel, String address)
      {
          StringBuffer row = new StringBuffer( "<tr bgcolor=\"#999999\">");
          
          row.append("<td class=\"standardheaderplain\" width=\"5%\" align=\"center\">");
          row.append("<input type=\"checkbox\" name=\"interfaceCheck\" value=\"").append(key).append("\" onClick=\"javascript:updateServices(" + interfaceIndex + ", " + serviceArray + ")\" ").append(status).append(" >");
          row.append("</td>").append("\n");
          row.append("<td class=\"standardheaderplain\" width=\"10%\">");
          row.append(nodeLabel);
          row.append("</td>").append("\n");
          row.append("<td class=\"standardheaderplain\" width=\"5%\">");
          row.append(address);
          row.append("</td>").append("\n");
          row.append("<td class=\"standardheaderplain\" width=\"5%\">").append("&nbsp;").append("</td></tr>").append("\n");
          
          return row.toString();
      }
      
      public String buildServiceRow(String key, int interfaceIndex, int serviceIndex, String status, String nodeLabel, String address, String service)
      {
          StringBuffer row = new StringBuffer( "<tr bgcolor=\"#cccccc\">");
          
          row.append("<td class=\"standard\" width=\"5%\" align=\"center\">");
          row.append("<input type=\"checkbox\" name=\"serviceCheck\" value=\"").append(key).append("\" onClick=\"javascript:verifyManagedInterface(" + interfaceIndex + ", " + serviceIndex + ")\" ").append(status).append(" >");
          row.append("</td>").append("\n");
          row.append("<td class=\"standard\" width=\"10%\">").append(nodeLabel).append("</td>").append("\n");
          row.append("<td class=\"standard\" width=\"5%\">").append(address).append("</td>").append("\n");
          row.append("<td class=\"standard\" width=\"5%\">").append(service).append("</td></tr>").append("\n");
          
          return row.toString();
      }
%>
