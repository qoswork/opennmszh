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
	import="org.opennms.netmgt.config.NotifdConfigFactory"
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="管理" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="管理" />
</jsp:include>

<script type="text/javascript" >

  function addInterfacePost()
  {
      document.addInterface.action="admin/newInterface.jsp?action=new";
      document.addInterface.submit();
  }
  
  function deletePost()
  {
      document.deleteNodes.submit();
  }

  function submitPost()
  {
      document.getNodes.submit();
  }

  function manageRanges()
  {
    document.manageRanges.submit();
  }
  
  function snmpManagePost()
  {
    document.snmpManage.submit();
  }
  
  function manageSnmp()
  {
    document.manageSnmp.submit();
  }
  
  function snmpConfigPost()
  {
    document.snmpConfig.action="admin/snmpConfig.jsp";
    document.snmpConfig.submit();
  }
  
  function networkConnection()
  {
    document.networkConnection.submit();
  }
  
  function dns()
  {
    document.dns.submit();
  }
  
  function communication()
  {
      document.communication.submit();
  }
  
</script>

<form method="post" name="getNodes" action="admin/getNodes">
  <input type="hidden"/>
</form>

<form method="post" name="addInterface">
  <input type="hidden"/>
</form>

<form method="post" name="deleteNodes" action="admin/deleteNodes">
  <input type="hidden"/>
</form>

<form method="post" name="snmpManage" action="admin/snmpGetNodes">
  <input type="hidden"/>
</form>

<form method="post" name="snmpConfig" action="admin/snmpConfig">
  <input type="hidden"/>
</form>

  <div class="TwoColLeft">
    <h3>OpenNMS系统</h3>
    <div class="boxWrapper">
      <ul class="plain">  
        <li><a href="admin/userGroupView/index.jsp">配置用户 组和角色</a></li>
        <li><a href="admin/sysconfig.jsp">系统信息</a></li>
        <li><a href="admin/nodemanagement/instrumentationLogReader.jsp">日志信息</a></li>
      </ul>
    </div>

    <h3>操作</h3>
    
    <div class="boxWrapper">
      <ul class="plain">  
        <li><a href="admin/discovery/modifyDiscoveryConfig">配置自动发现</a></li>
        <li><a href="javascript:snmpConfigPost()">通过IP配置SNMP团体名</a></li>
        <li><a href="javascript:snmpManagePost()">配置每个接口SNMP数据采集</a></li>
		<!-- Removed this - see bug 586
        	<li><a href="admin/pollerConfig/index.jsp">Configure Pollers</a></li>
		-->        
        <li><a href="javascript:submitPost()">管理接口和服务</a></li>
        <li><a href="admin/thresholds/index.htm">管理门限</a></li>
        <!-- Secret function 
        	<a href="admin/eventconf/list.jsp">Configure Events</a> 
        -->
        <li><a href="admin/sendevent.jsp">发送事件</a></li>
        <li><a href="admin/notification/index.jsp">配置通知</a></li>
        <li><a href="admin/sched-outages/index.jsp">计划故障</a></li>
        <li><a href="admin/mibCompiler.jsp">SNMPMib编译</a></li>
        <li><a href="admin/manageEvents.jsp">管理事件配置</a></li>
        <li><a href="admin/manageSnmpCollections.jsp">管理SNMP采集和数据采集组</a></li>
      </ul>
    </div>
	<div class="boxWrapper">
      <form method="post" name="notificationStatus" action="admin/updateNotificationStatus">
        <%String status = "Unknown";
         try
          {
            NotifdConfigFactory.init();
            status = NotifdConfigFactory.getInstance().getPrettyStatus();
          } catch (Throwable e) { /*if factory can't be initialized, status is already 'Unknown'*/ }
        %>
          <p align="right">通知状态:
            <%if (status.equals("Unknown")) { %>
              未知<br />
            <% } %>
              <input type="radio" name="status" id="on" value="on" <%=(status.equals("On") ? "checked" : "")%> /> <label for="on">开启</label>&nbsp;&nbsp;&nbsp;
              <input type="radio" name="status" id="off" value="off" <%=(status.equals("Off") ? "checked" : "")%> /> <label for="off">关闭</label>
              <input type="submit" value="更新" />
            </p>
        </form>
      </div>    

    <h3>节点服务</h3>
    <div class="boxWrapper">
      <ul class="plain">  
        <li><a href="javascript:addInterfacePost()">添加接口扫描</a></li>
        <li><a href="admin/provisioningGroups.htm">管理设备配置导入</a></li>
        <li><a href="admin/asset/index.jsp">导入和导出资产信息</a></li>
        <li><a href="admin/categories.htm">管理监视分类</a></li>
        <li><a href="javascript:deletePost()">删除节点</a></li>
      </ul>
    </div>

	<h3>分布式监控</h3>
    <div class="boxWrapper">
      <ul class="plain">  
        <li><a href="admin/applications.htm">管理应用</a></li>
        <li><a href="distributed/locationMonitorList.htm">管理位置监控</a></li>
      </ul>
    </div>


    
  </div>
      
  <div class="TwoColRight">
      <h3>说明</h3>
      <div class="boxWrapper">
      <p>所有操作的详细资料，可以在<a title="OpenNMS 项目 wiki" href="http://www.opennms.org" target="new">OpenNMS wiki</a>上查找。
      </p>
        <p><b>配置用户，组和角色</b>:添加，修改或删除现有用户。组包含用户。
            构建组角色，并提供一个人员轮换的值班表。(用户:普通用户，组:管理员，角色:值班人员)
        </p>
        
       <p><b>通知状态</b>:只有此设置为<em>开启</em>时，通知才被发送出去。这是一个系统级的设置。只要此设置为<em>关闭</em>OpenNMS则不会创建通知。
			通知的当前状态也可以在OpenNMS右上角的界面看到，<em>通知 开启</em> 或 <em>通知 关闭</em>。
        </p>
        
        <p><b>配置自动发现</b>:配置IP地址(单一地址或地址段)给OpenNMS定期执行pings，以便及时发现新的节点。
         </p>
        
	<P><B><B>通过IP配置SNMP团体名</B>:配置的团体名用来进行SNMP数据采集和其它SNMP操作。OpenNMS附带了一个默认为"public"的团体名。
	如果你已经在设备上设置了不同的<em>读</em>团体名，则必须在这里进行设置，以便从这些设备上采集数据。
	</P>           

	<P><B>配置接口SNMP数据采集</B>:这里你可以配置哪些接口进行SNMP数据采集。
	</P>

        <p><b>管理接口和服务</b>:<em>管理</em>意味着OpenNMS将对接口或服务执行测试。在这里可以设置是否启用测试。
        一个典型的例子是，如果一个Web服务同时监听在内部和外部两个接口上，如果测试失败你会得到两份通知。如果你想只有一个通知，对一个接口取消管理服务。
        </p>
              

     <p><b>管理门限</b>:允许你配置(添加/删除/修改)门限。</p>

     <p><b>发送事件</b>:允许你建立一个特定的事件，并将其发送到系统中。</p>

        <p><b>配置通知</b>:创建和管理通知升级计划，称为<em>目标路径</em>。目标路径和OpenNMS事件相关联。
            每个路径可以有任意数量的上报或目标(用户，组，角色)，并且通知可以通过电子邮件，寻呼机等等发送。OpenNMS事件可能进一步和相关的接口或服务一起触发目标路径。
        </p>


	<p><b>计划故障</b>:添加和编辑计划故障。你可以对节点/接口暂停通知，轮询，门限和数据采集(或任何这四个的组合)。
	</p>

    <p><b>SNMPMib编译</b>: Mib编译，以生成Trap事件或性能指标的数据采集组的定义。
      </p>

    <p><b>管理事件配置</b>: 添加和编辑的事件定义的配置文件。</p>

    <p><b>管理SNMP数据采集和数据采集组</b>: 管理SNMP采集和数据采集组的文件内容。
      </p>

        <p><b>添加接口扫描</b>:添加一个IPv4或IPv6接口触发扫描。如果此接口的IP地址存在于现有节点的IP地址表中，那么接口将被添加到节点。否则，将创建一个新的节点。
        </p>

	<p><b>管理设备配置导入</b>:添加节点，接口和服务到OpenNMS或通过设备配置导入灵活的发现网络。
	</p>

        <p><b>导入和导出资产信息</b>:从OpenNMS导入和导出资产清单。大多数电子表格和数据库都支持逗号分隔的文件格式。通过此链接可以使用导入和导出功能。             
        </p>

	<p><b>管理监视分类</b>:管理监视分类(又称节点分类)和编辑属于每个分类的节点列表。
	</p>
        
        <p><b>删除节点</b>:从数据库中永久删除节点。
        </p>
<!--
        <p><b>Configure Pollers</b> provides an easy way to modify the polling status of 
            standard services.  It also enables the user to add and delete custom services.
        </p>
-->        



	<p><b>管理应用</b> <b>管理位置监控</b>:分布式监控配置。
	</p>
	

 
      </div>
  </div>
  <hr />
<jsp:include page="/includes/footer.jsp" flush="false"/>
