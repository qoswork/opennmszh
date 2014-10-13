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

<%@ page contentType="text/html;charset=UTF-8" language="java" import="org.opennms.web.api.Util" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<jsp:include page="/includes/header.jsp" flush="false">
	<jsp:param name="title" value="分类" />
	<jsp:param name="headTitle" value="分类" />
	<jsp:param name="breadcrumb"
               value="<a href='admin/index.jsp'>管理</a>" />
	<jsp:param name="breadcrumb" value="分类" />
</jsp:include>

<h3>监视分类</h3>
<script type="text/javascript">

   var surveillanceCategories = {
		   <c:set var="first" value="true"/>
		   <c:forEach var="surveillanceCat" items="${surveillanceCategories}" varStatus="count">
		     <c:choose>
		       <c:when test="${first == true}">
		         <c:set var="first" value="false" />
		         "${surveillanceCat}":"${surveillanceCat}"
		       </c:when>
		       <c:otherwise>
		         ,"${surveillanceCat}":"${surveillanceCat}"
		       </c:otherwise>
		     </c:choose>
		   </c:forEach>
   };

   function deleteCategory(categoryName, categoryId){
	   if(surveillanceCategories.hasOwnProperty(categoryName)){
           if(confirm("这个监视分类也是在你的surveillance-views.xml配置。\n请编辑surveillance-views.xml，以反映更改。")){
               location = "<%= Util.calculateUrlBase(request, "admin/categories.htm") %>?removeCategoryId=" + categoryId;
           }
       }else{
           location = "<%= Util.calculateUrlBase(request, "admin/categories.htm") %>?removeCategoryId=" + categoryId;
       }
   }
</script>
<table>
  <tr>
    <th>删除</th>
    <th>编辑</th>
    <th>分类</th>
  </tr>
  <c:forEach items="${categories}" var="category">
	  <tr>
	    <td><a onclick="deleteCategory('${fn:escapeXml(category.name)}', ${category.id})" ><img src="images/trash.gif" alt="删除分类"/></a></td>
	    <td><a href="admin/categories.htm?categoryid=${category.id}&edit"><img src="images/modify.gif" alt="编辑分类"/></a></td>
	    <td><a href="admin/categories.htm?categoryid=${category.id}">${fn:escapeXml(category.name)}</a></td> 
  	  </tr>
  </c:forEach>
  <tr>
    <td></td>
    <td></td>
    <td>
      <form action="admin/categories.htm">
        <input type="textfield" name="newCategoryName" size="40"/>
        <input type="submit" value="添加新分类"/>
      </form>
  </tr>
</table>

<jsp:include page="/includes/footer.jsp" flush="false"/>
