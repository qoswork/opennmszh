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
	import="java.util.*,
		org.opennms.web.element.*,
		org.opennms.web.asset.*
		"
%>

<%!
    protected AssetModel model;
    protected String[][] columns;

    public void init() throws ServletException {
        this.model = new AssetModel();
        this.columns = this.model.getColumns();
    }
%>

<%
    Map serviceNameMap = new TreeMap(NetworkElementFactory.getInstance(getServletContext()).getServiceNameToIdMap());
    List serviceNameList = new ArrayList(serviceNameMap.keySet());
    Collections.sort(serviceNameList);
    Iterator serviceNameIterator = serviceNameList.iterator();
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="节点查询" />
  <jsp:param name="headTitle" value="节点查询" />
  <jsp:param name="location" value="element" />
  <jsp:param name="breadcrumb" value="查询" />
</jsp:include>

  <div class="TwoColLeft">
      <h3>查询节点</h3>
		<div class="boxWrapper">
            <form action="element/nodeList.htm" method="get">
					<p align="right">名称包含:          
              <input type="hidden" name="listInterfaces" value="false"/>
              <input type="text" name="nodename" />
              <input type="submit" value="查询"/></p>                
            </form>

            <form action="element/nodeList.htm" method="get">
					<p align="right">TCP/IP地址like:          
              <input type="hidden" name="listInterfaces" value="false"/>
              <input type="text" name="iplike" value="" placeholder="*.*.*.*" />
              <input type="submit" value="查询"/></p>                
            </form>

            <form action="element/nodeList.htm" method="get">
					<p align="right">
					    <select name="snmpParm" size="1">
                            <option>ifAlias</option> 
                            <option>ifName</option>
                            <option>ifDescr</option>
                        </select>
                        <select name="snmpParmMatchType" size="1">
                            <option>contains</option> 
                            <option>equals</option>
                        </select>:        
						<input type="hidden" name="listInterfaces" value="false"/>
						<input type="text" name="snmpParmValue" />
						<input type="submit" value="查询"/></p>                
            </form>

            <form action="element/nodeList.htm" method="get">
					<p align="right">提供服务:          
						<input type="hidden" name="listInterfaces" value="false"/>
						<select name="service" size="1">
						  <% while( serviceNameIterator.hasNext() ) { %>
						    <% String name = (String)serviceNameIterator.next(); %> 
						    <option value="<%=serviceNameMap.get(name)%>"><%=name%></option>
						  <% } %>          
						</select>
						<input type="submit" value="查询"/></p>                
            </form>
            
            <form action="element/nodeList.htm" method="get">
					<p align="right">MAC地址:          
						<input type="hidden" name="listInterfaces" value="false"/>
						<input type="text" name="maclike" />
						<input type="submit" value="查询"/></p>                
            </form>
            
            <form action="element/nodeList.htm" method="get">
                    <p align="right">Foreign Source name like:
                        <input type="hidden" name="listInterfaces" value="false"/>
                        <input type="text" name="foreignSource"/>
                        <input type="submit" value="查询"/>
                    </p>
            </form>
                        
			<ul class="plain">
				<li><a href="element/nodeList.htm">所有节点</a></li>
				<li><a href="element/nodeList.htm?listInterfaces=true">所有节点和接口</a></li>
			</ul>
		</div>
		
		<h3>查询资产信息</h3>
		<div class="boxWrapper">
        <%-- category --%>
        <form action="asset/nodelist.jsp" method="get">
          <p align="right">分类: 
          <input type="hidden" name="column" value="category" />
          <select name="searchvalue" size="1">
            <% for( int i=0; i < Asset.CATEGORIES.length; i++ ) { %>
              <option><%=Asset.CATEGORIES[i]%></option> 
            <% } %>
          </select>
          <input type="submit" value="查询" />
			</p>
        </form>
		
        <form action="asset/nodelist.jsp" method="get">
          <p align="right">字段:
				<select name="column" size="1">
				  <% for( int i=0; i < this.columns.length; i++ ) { %>
				    <option value="<%=this.columns[i][1]%>"><%=this.columns[i][0]%></option>
				  <% } %>
				</select><br />
				包含文本 <input type="text" name="searchvalue" />
				<input type="submit" value="查询" /></p>
        </form>
		<ul class="plain">
			<li><a href="asset/nodelist.jsp?column=_allNonEmpty">所有节点资产信息</a></li>
      </ul>
		</div>
  </div>


  <div class="TwoColRight">
      <h3>查询选项</h3>
     <div class="boxWrapper"> 
      <p>根据名称查询，是不区分大小写，例如，
        查询 <em>serv</em>，你将查询出<em>serv</em>，<em>Service</em>，<em>Reserved</em>，<em>NTSERV</em>，<em>UserVortex</em>等。 
        下划线'_'匹配单一字符。
        百分号'%'匹配多个字符。
      </p>
        
      <p>根据IP地址查询，允许你使用四个IP段进行灵活的方式查询。
        星号'*'可以匹配所有值(1-255)。
        破折号'-'可以列出一个地址范围。
        逗号','可以界定多个单一值。
      </p>
        
      <p>例如，下面的几个实例都代表相同的地址范围，
        从 192.168.0.0 到 192.168.255.255:
      </p>
      
        <ul>
            <li>192.168.*.*
            <li>192.168.0-255.0-255
            <li>192.168.0,1,2,3-255.*
        </ul>

      <p>根据接口的接口别名，接口名称，接口描述进行模糊查询。
        可以忽略大小写，和上面的名称查询类似。
        你也可以选择'equals'条件进行精确匹配。
      </p>

      <p>根据服务查询，在下拉列表中选择一个服务进行查询。
      </p>

      <p>根据MAC地址进行查询，可以和硬件接口的MAC地址进行匹配。
         字符匹配忽略大小写。例如，如果你只输入前6个MAC地址字符，将查询出此厂商的所有接口。
         MAC地址字段间的分隔符(:或-)可以忽略。
      </p>

      <p>资产信息查询，允许你根据资产的各个字段进行查询，你可以选择(从下拉列表中)或输入文本值进行匹配。
        文本框值匹配类似于上面的名称查询方式。
      </p>

      <p>另外，你可以通过<em>所有节点资产信息</em>链接查询出所有的节点资产信息。
      </p>
		</div>
  </div>
<hr />
<jsp:include page="/includes/footer.jsp" flush="false"/>
