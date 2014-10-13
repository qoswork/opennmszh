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

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="事件级别图例" />
  <jsp:param name="headTitle" value="级别图例" />
  <jsp:param name="headTitle" value="事件" />
  <jsp:param name="quiet" value="true" />
</jsp:include>


<table>
  <tr class="Critical">
    <td class="bright">&nbsp;</td>
    <td class="divider"><b>严重</b></td>
    <td class="divider">该事件意味着网络上的许多设备都将受到影响。每个人都应该停止他们当前的工作，并重点解决这个问题。</td>
  </tr>
  <tr class="Major">
    <td class="bright">&nbsp;</td>
    <td class="divider"><b>主要</b></td>
    <td class="divider">一个设备完全Down或处于危险之中。是完全或下去的危险。需要立即注意这个问题。</td>
  </tr>
  <tr class="Minor">
    <td class="bright">&nbsp;</td>
    <td class="divider"><b>次要</b></td>
    <td class="divider">一个设备的一部分(服务，接口，电源等)。需要引起注意。</td>
  </tr>
  <tr class="Warning">
    <td class="bright">&nbsp;</td>
    <td class="divider"><b>警告</b></td>
    <td class="divider">事件发生，可能需要采取行动。。此严重性，，可以用来表示一个信号(记录)，但并不需要直接行动。</td>
  </tr>
  <tr class="Indeterminate">
    <td class="bright">&nbsp;</td>
    <td class="divider"><b>不确定</b></td>
    <td class="divider">没有级别可以关联到此事件。</td>
  </tr>
  <tr class="Normal">
    <td class="bright">&nbsp;</td>
    <td class="divider"><b>一般</b></td>
    <td class="divider">信息性消息。不需要采取任何行动。</td>
  </tr>
  <tr class="Cleared">
    <td class="bright">&nbsp;</td>
    <td class="divider"><b>已清除</b></td><td class="divider">该事件表明，之前的错误已得到纠正并且服务已恢复</td>
  </tr>
</table>

<jsp:include page="/includes/footer.jsp" flush="false" >
  <jsp:param name="quiet" value="true" />
</jsp:include>

