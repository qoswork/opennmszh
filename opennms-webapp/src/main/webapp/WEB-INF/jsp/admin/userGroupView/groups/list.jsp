<%--
/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2009-2012 The OpenNMS Group, Inc.
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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="组配置" />
  <jsp:param name="headTitle" value="列表" />
  <jsp:param name="headTitle" value="组" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/userGroupView/index.jsp'>用户和组</a>" />
  <jsp:param name="breadcrumb" value="组列表" />
</jsp:include>

<script type="text/javascript" >

    function addNewGroup()
    {
        document.allGroups.action="admin/userGroupView/groups/modifyGroup";
        document.allGroups.operation.value="create";
        document.allGroups.submit();
    }
    
    function detailGroup(groupName)
    {
        document.allGroups.action="admin/userGroupView/groups/modifyGroup";
        document.allGroups.operation.value="show";
        document.allGroups.groupName.value=groupName;
        document.allGroups.submit();
    }
    
    function deleteGroup(groupName)
    {
        document.allGroups.action="admin/userGroupView/groups/modifyGroup";
        document.allGroups.operation.value="delete";
        document.allGroups.groupName.value=groupName;
        document.allGroups.submit();
    }
    
    function modifyGroup(groupName)
    {
        document.allGroups.action="admin/userGroupView/groups/modifyGroup";
        document.allGroups.operation.value="edit"
        document.allGroups.groupName.value=groupName;
        document.allGroups.submit();
    }

    function renameGroup(groupName)
    {
        var newName = prompt("输入新的组名称。", groupName);

        if (newName != null && newName != "")
        {
          document.allGroups.newName.value = newName;
          document.allGroups.groupName.value=groupName;
          document.allGroups.operation.value="rename";
          document.allGroups.action="admin/userGroupView/groups/modifyGroup";
          document.allGroups.submit();
        }
    }

</script>

<h3>组配置</h3>

<form method="post" name="allGroups">
  <input type="hidden" name="operation"/>
  <input type="hidden" name="groupName"/>
  <input type="hidden" name="newName"/>

       <a href="javascript:addNewGroup()"> <img src="images/add1.gif" alt="添加新组"> 添加新组</a>

  <table>

         <tr>
          <th>删除</th>
          <th>修改</th>
          <th>重命名</th>
          <th>组名称</th>
          <th>注释</th>
        </tr>
         <c:forEach var="group" varStatus="groupStatus" items="${groups}">
         <tr class="divider ${groupStatus.index % 2 == 0 ?  'even' : 'odd'}" >
          <td width="5%" align="center">
            <c:choose>
              <c:when test='${group.name != "Admin"}'>
                <a href="javascript:deleteGroup('${group.name}')" onclick="return confirm('你确定要删除组 ${group.name}?')"><img src="images/trash.gif"></a>              
              </c:when>
              <c:otherwise>
                <img src="images/trash.gif" title="不能删除组 ${group.name} 组">
              </c:otherwise>
            </c:choose>
          </td>
          <td width="5%" align="center">
            <a href="javascript:modifyGroup('${group.name}')"><img src="images/modify.gif"></a>
          </td>
          <td width="5%" align="center">
            <c:choose>
              <c:when test='${group.name != "Admin"}'>
                <input id="${group.name}.doRename" type="button" name="rename" value="重命名" onclick="renameGroup('${group.name}')">
              </c:when>
              <c:otherwise>
                <input id="${group.name}.doRename" type="button" name="rename" value="重命名" onclick="alert('很抱歉，管理组不能更名。')">
              </c:otherwise>
            </c:choose>
          </td>
          <td>
            <a href="javascript:detailGroup('${group.name}')">${group.name}</a>
          </td>
            <td>
              <c:choose>
                <c:when test="${!empty group.comments}">
                  ${group.comments}
                </c:when>
                
                <c:otherwise>
                  没有注释
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
     </table>
</form>
<p>
  点击 <i>组名称</i> 的链接，查看有关组的详细信息。
</p>

<jsp:include page="/includes/footer.jsp" flush="false" />
