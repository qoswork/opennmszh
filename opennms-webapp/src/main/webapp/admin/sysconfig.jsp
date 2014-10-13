<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2008-2012 The OpenNMS Group, Inc.
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
	import="org.opennms.web.springframework.security.Authentication,
		org.opennms.core.resource.Vault
	"
%>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="OpenNMS系统配置" />
  <jsp:param name="headTitle" value="系统配置" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="系统配置" />
</jsp:include>

<script type="text/javascript">
    
        function cancel()
        {
                document.snmpConfigForm.action="admin/index.jsp";
                document.snmpConfigForm.submit();
        }
</script>


  <div class="TwoColLeft">
  <h3>OpenNMS配置</h3>
  	<div class="boxWrapper">
 	<table class="standard">
 	  <tr>
    <td class="standardheader">OpenNMS版本:</td>
    <td class="standard"><%=Vault.getProperty("version.display")%></td>
  </tr>
 	<tr>
    <td class="standardheader">主目录:</td>
    <td class="standard"><%=Vault.getProperty("opennms.home")%></td>
  </tr>
  <tr>
    <td class="standardheader">RRD分组存储:</td>
    <td class="standard"><%=Vault.getProperty("org.opennms.rrd.storeByGroup")%></td>
  </tr>
  <tr>
    <td class="standardheader">RRD store by Foreign Source:</td>
    <td class="standard"><%=Vault.getProperty("org.opennms.rrd.storeByForeignSource")%></td>
  </tr>
  <tr>
    <td class="standardheader">Web-Application Logfiles:</td>
    <td class="standard"><%=Vault.getProperty("opennms.webapplogs.dir")%></td>
  </tr>
  <tr>
    <td class="standardheader">Reports directory:</td>
    <td class="standard"><%=Vault.getProperty("opennms.report.dir")%></td>
  </tr>
  <tr>
    <td class="standardheader">Jetty http host:</td>
    <td class="standard"><%=Vault.getProperty("org.opennms.netmgt.jetty.host")%></td>
  </tr>
  <tr>
    <td class="standardheader">Jetty http port:</td>
    <td class="standard"><%=Vault.getProperty("org.opennms.netmgt.jetty.port")%></td>
  </tr>
   <tr>
    <td class="standardheader">Jetty https host:</td>
    <td class="standard"><%=Vault.getProperty("org.opennms.netmgt.jetty.https-host")%></td>
  </tr>
  <tr>
    <td class="standardheader">Jetty https port:</td>
    <td class="standard"><%=Vault.getProperty("org.opennms.netmgt.jetty.https-port")%></td>
  </tr>

</table>
</div>
</div>
<div class="TwoColRight">
  <h3>系统配置</h3>
  	<div class="boxWrapper">
 	<table class="standard">
  <tr>
    <td class="standardheader">服务器时间:</td>
    <td class="standard"><%=new java.util.Date()%></td>
  </tr>
  <tr>
    <td class="standardheader">客户端时间:</td>
    <td class="standard"><script type="text/javascript"> document.write( new Date().toString()) </script></td>
  </tr>
  <tr>
    <td class="standardheader">Java版本:</td>
    <td class="standard"><%=System.getProperty( "java.version" )%> <%=System.getProperty( "java.vendor" )%></td>
  </tr>  
  <tr>
    <td class="standardheader">Java虚拟机:</td>
    <td class="standard"><%=System.getProperty( "java.vm.version" )%> <%=System.getProperty( "java.vm.vendor" )%></td>
  </tr>
  <tr>
    <td class="standardheader">操作系统:</td>
    <td class="standard"><%=System.getProperty( "os.name" )%> <%=System.getProperty( "os.version" )%> (<%=System.getProperty( "os.arch" )%>)</td>
  </tr>
  <tr>
    <td class="standardheader">Servlet 容器:</td>
    <td class="standard"><%=application.getServerInfo()%> (Servlet Spec <%=application.getMajorVersion()%>.<%=application.getMinorVersion()%>)</td>
  </tr>
  <tr>
    <td class="standardheader">用户浏览器:</td>
    <td class="standard"><%=request.getHeader( "User-Agent" )%></td>
  </tr>    
</table>
</div>
  </div>

  <div class="TwoColRAdmin">
  </div>

<jsp:include page="/includes/footer.jsp" flush="false" />
