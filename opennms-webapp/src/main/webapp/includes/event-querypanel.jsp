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
		org.opennms.web.element.NetworkElementFactory,
		org.opennms.web.event.*
		"
%>

<script type="text/javascript">
<!--
function Blank_TextField_Validator()
{
  if(document.event_search.msgmatchany.value == "")
     {
     alert("请输入事件查询文本");
     document.event_search.msgmatchany.focus();
     return false;
     }
  return true;
}
-->
</script>

<form name="event_search" action="event/query" method="get" onsubmit="return Blank_TextField_Validator()">
      <p>事件文本:<input type="text" name="msgmatchany" /> &nbsp; 时间:
        <select name="relativetime" size="1">
          <option value="0" selected>所有</option>
          <option value="1">最后小时</option>
          <option value="2">最后4小时</option>
          <option value="3">最后8小时</option>
          <option value="4">最后12小时</option>
          <option value="5">最后1天</option>
          <option value="6">最后1周</option>
          <option value="7">最后1月</option>                
        </select>
        <input type="submit" value="查询" />
</form>



