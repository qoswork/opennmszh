<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2011-2012 The OpenNMS Group, Inc.
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
	import="
        java.util.Map,
        java.util.TreeMap,
        java.util.Enumeration,
        org.opennms.netmgt.config.PollerConfigFactory,
        org.opennms.netmgt.config.PollerConfig,
        org.opennms.netmgt.config.poller.Package,
        org.opennms.netmgt.config.poller.Service,
        org.opennms.netmgt.config.poller.Parameter,
        org.opennms.netmgt.model.OnmsMonitoredService,
        org.opennms.netmgt.poller.ServiceMonitor,
        org.opennms.web.springframework.security.Authentication
	"
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%
    OnmsMonitoredService service = (OnmsMonitoredService)request.getAttribute("service");

    String ipAddr = service.getIpAddress().getHostAddress();
    String serviceName = service.getServiceName();

    PollerConfigFactory.init();
    PollerConfig pollerCfgFactory = PollerConfigFactory.getInstance();
    pollerCfgFactory.rebuildPackageIpListMap();

    Package lastPkg = null;
    Enumeration<Package> en = pollerCfgFactory.enumeratePackage();
    while (en.hasMoreElements()) {
        Package pkg = en.nextElement();
        if (!pkg.getRemote() &&
            pollerCfgFactory.isServiceInPackageAndEnabled(serviceName, pkg) &&
            pollerCfgFactory.isInterfaceInPackage(ipAddr, pkg)) {
            lastPkg = pkg;
        }
    }
    pageContext.setAttribute("packageName", lastPkg == null ? "N/A" : lastPkg.getName());

    ServiceMonitor monitor = pollerCfgFactory.getServiceMonitor(serviceName);
    pageContext.setAttribute("monitorClass", monitor == null ? "N/A" : monitor.getClass().getName());

    Map<String,String> parameters = new TreeMap<String,String>();
    Map<String,String> xmlParams  = new TreeMap<String,String>();
    if (lastPkg != null) {
        for (Service s : lastPkg.getServiceCollection()) {
            if (s.getName().equalsIgnoreCase(serviceName)) {
                for (Parameter p : s.getParameterCollection()) {
                    if (p.getKey().toLowerCase().contains("password")) {
                        continue; // Hide passwords for security reasons
                    }
                    if (p.getValue() == null) {
                        xmlParams.put(p.getKey(), p.getAnyObject().toString().replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("[\\r\\n]+", "<br/>").replaceAll(" ","&nbsp;").replaceAll("(password|user-info)=\"[^\"]+\"", "$1=\"XXXX\"").replaceAll("key=\"([^\"]*pass(word|wd)[^\"]*)\"(\\s|&nbsp;)+value=\"[^\"]+\"", "key=\"$1\" value=\"XXXX\""));
                    } else {
                        parameters.put(p.getKey(), p.getValue());
                    }
                }
            }
        }
        pageContext.setAttribute("parameters", parameters);
        pageContext.setAttribute("xmlParams", xmlParams);
    }
%>

<c:url var="eventUrl" value="event/list.htm">
  <c:param name="filter" value="node= ${service.ipInterface.node.id}"/> 
  <c:param name="filter" value="interface= ${service.ipInterface.ipAddress.hostAddress}"/>
  <c:param name="filter" value="service= ${service.serviceId}"/>
</c:url>
<c:url var="nodeLink" value="element/node.jsp">
  <c:param name="node" value="${service.ipInterface.node.id}"/>
</c:url>
<c:url var="interfaceLink" value="element/interface.jsp">
  <c:param name="ipinterfaceid" value="${service.ipInterface.id}"/>
</c:url>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="服务" />
  <jsp:param name="headTitle" value="${service.serviceName} 服务在 ${service.ipInterface.ipAddress.hostAddress}" />
  <jsp:param name="breadcrumb" value="<a href='element/index.jsp'>查询</a>" />
  <jsp:param name="breadcrumb" value="<a href='${fn:escapeXml(nodeLink)}'>节点</a>" />
  <jsp:param name="breadcrumb" value="<a href='${fn:escapeXml(interfaceLink)}'>接口</a>" />
  <jsp:param name="breadcrumb" value="服务" />
</jsp:include>
  
  
<sec:authorize url="admin/deleteService">

<script type="text/javascript" >
function doDelete() {
     if (confirm("您确定要继续吗？此操作将永久删除此服务，不能被撤销。"))
     {
         document.forms["delete"].submit();
     }
     return false;
}
</script>

</sec:authorize>
	
      <h2>${service.serviceName} service on ${service.ipAddress.hostAddress}</h2>

       <sec:authorize url="admin/deleteService">
         <form method="post" name="delete" action="admin/deleteService">
         <input type="hidden" name="node" value="${service.ipInterface.node.id}"/>
         <input type="hidden" name="intf" value="${service.ipInterface.ipAddress.hostAddress}"/>
         <input type="hidden" name="service" value="${service.serviceType.id}"/>
       </sec:authorize>

        
      <p>
         <a href="${eventUrl}">查看事件</a>
         
 	
       <sec:authorize url="admin/deleteService">
         &nbsp;&nbsp;&nbsp;<a href="admin/deleteService" onClick="return do删除()">删除</a>
       </sec:authorize>

	

      </p>
 
          

      <sec:authorize url="admin/deleteService">
         </form>
      </sec:authorize>


      <div class="TwoColLeft">
            <!-- general info box -->
            <h3>基本信息</h3>
            <table>
              <tr>
                <c:url var="nodeLink" value="element/node.jsp">
                  <c:param name="node" value="${service.ipInterface.node.id}"/>
                </c:url>
                <th>节点</th>
                <td><a href="${fn:escapeXml(nodeLink)}">${service.ipInterface.node.label}</a></td>
              </tr>
              <tr>
                <c:url var="interfaceLink" value="element/interface.jsp">
                  <c:param name="ipinterfaceid" value="${service.ipInterface.id}"/> 
                </c:url>
                <th>接口</th> 
                <td><a href="${fn:escapeXml(interfaceLink)}">${service.ipInterface.ipAddress.hostAddress}</a></td>
              </tr>              
              <tr>
                <th>轮询状态</th>
                <td>${service.statusLong}</td>
              </tr>
              <tr>
                <th>轮询实例</th>
                <td>${packageName}</td>
              </tr>
              <tr>
                <th>监控类</th>
                <td>${monitorClass}</td>
              </tr>
            </table>
            <c:if test="${parameters != null}">
              <h3>服务参数</h3>
              <table class="o-box">
              <c:forEach var="entry" items="${parameters}">
                <tr>
                  <th nowrap>${entry.key}</th>
                  <td>${entry.value}</td>
                </tr>
              </c:forEach>
              </table>
            </c:if>
            <c:if test="${xmlParams != null}">
              <c:forEach var="entry" items="${xmlParams}">
                <h3>${entry.key}</h3>
                <table class="o-box">
                  <tr><td>${entry.value}</td></tr>
                </table>
              </c:forEach>
            </c:if>

            <!-- Availability box -->
            <jsp:include page="/includes/serviceAvailability-box.jsp" flush="false" />
            
            <jsp:include page="/includes/serviceApplication-box.htm" flush="false" />
            
      </div> <!-- class="TwoColLeft" -->

      <div class="TwoColRight">
            <!-- events list box -->
            <jsp:include page="/includes/eventlist.jsp" flush="false" >
              <jsp:param name="node" value="${service.ipInterface.node.id}" />
              <jsp:param name="ipAddr" value="${service.ipInterface.ipAddress.hostAddress}" />
              <jsp:param name="service" value="${service.serviceType.id}" />
              <jsp:param name="throttle" value="5" />
              <jsp:param name="header" value="<a href='${fn:escapeXml(eventUrl)}'>最近的事件</a>" />
              <jsp:param name="moreUrl" value="${fn:escapeXml(eventUrl)}" />
            </jsp:include>
      
            <!-- Recent outages box -->
            <jsp:include page="/outage/serviceOutages-box.htm" flush="false" />
      </div> <!-- class="TwoColRight" -->

<jsp:include page="/includes/footer.jsp" flush="false" />


