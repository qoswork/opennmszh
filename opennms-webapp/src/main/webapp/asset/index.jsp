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
	import="org.opennms.web.asset.*,
		java.util.*,
		org.opennms.web.element.NetworkElementFactory
	"
%>

<%!
    protected AssetModel model;

    public void init() throws ServletException {
        this.model = new AssetModel();
    }
%>

<%
    Asset[] allAssets = this.model.getAllAssets();
    ArrayList assetsList = new ArrayList();

    for( int i=0; i < allAssets.length; i++ ) {
        if( !"".equals(allAssets[i].getAssetNumber()) ) {
            assetsList.add( allAssets[i] );
        }
    }

    int assetCount = assetsList.size();
    int middle = assetCount/2;  //integer division so it should round down
    if( assetCount%2 == 1 ) {
        middle++;  //make sure the one odd entry is on the left side
    }
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="资产" />
  <jsp:param name="headTitle" value="资产" />
  <jsp:param name="location" value="asset" />
  <jsp:param name="breadcrumb" value="资产" />
</jsp:include>

  <div class="TwoColLeft">
    <h3>查询资产信息</h3>
    <div class="boxWrapper">
      <form action="asset/nodelist.jsp" method="get">
        <p align="right">资产分类: 
        <input type="hidden" name="column" value="category" />
        <select name="searchvalue" size="1">
          <% for( int i=0; i < Asset.CATEGORIES.length; i++ ) { %>
            <option><%=Asset.CATEGORIES[i]%></option> 
          <% } %>
        </select>
        <input type="submit" value="查询" />
      </form>
      <ul class="plain">
        <li><a href="asset/nodelist.jsp?column=_allNonEmpty">所有节点的资产信息</a></li>
      </ul>
    </div>
  </div>

  <div class="TwoColRight">
    <h3>资产清单</h3>
    <div class="boxWrapper">
        <p>OpenNMS系统提供了一种让你可以轻松地跟踪和共享你组织的重要资产信息。 
            这些在OpenNMS系统网络发现期间，获得的有关网络的信息数据，可以作为解决问题的强大工具， 
            也可以跟踪设备的维修状态，以及网络或系统相关的移动，添加，或改变。 
        </p>
        <p>有两种方法添加或修改OpenNMS系统中存储的资产数据:</p>
        <ul>
          <li>从其他来源导入数据 (在<em>管理</em>页面导入资产数据)</li>
          <li>通过手工输入的数据</li>
        </ul>
          <p>一旦你开始将数据添加到OpenNMS系统的资产库页面， 
            任一节点将会有一个资产编号(例如，条形码)并被显示在此页的下半部分，为你提供了一键式的机制，跟踪当前设备的物理状态。 
            如果你想搜索特定的资产分类，只需点击标有<b>资产分类</b>的下拉框， 
            选择所需的分类，然后单击<b>[查询]</b>检索与该分类相关联的所有资产清单。 
            只需单击<b>所有节点的资产信息</b>链接 
            将出现一个完整的节点列表，不管其是否有相关联的资产编号。 
        </p>
      </div>
  </div>
  <hr />
  <h3>资产数</h3>
  <div class="boxWrapper">
    <ul class="plain" style="width:48%; margin-right:2%; float:left;">
    <% for( int i=0; i < middle; i++ ) {%>
      <%  Asset asset = (Asset)assetsList.get(i); %>
      <li> <%=asset.getAssetNumber()%>: <a href="asset/modify.jsp?node=<%=asset.getNodeId()%>"><%=NetworkElementFactory.getInstance(getServletContext()).getNodeLabel(asset.getNodeId())%></a></li>
    <% } %>
    </ul>
    <ul class="plain" style="width:50%; float:left;">
    <% for( int i=middle; i < assetCount; i++ ) {%>
      <%  Asset asset = (Asset)assetsList.get(i); %>
      <li><%=asset.getAssetNumber()%>: <a href="asset/modify.jsp?node=<%=asset.getNodeId()%>"><%=NetworkElementFactory.getInstance(getServletContext()).getNodeLabel(asset.getNodeId())%></a></li>
    <% } %>
    </ul>
    <hr />
  </div>
<jsp:include page="/includes/footer.jsp" flush="false"/>
