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

<%@page language="java"
	contentType="text/html"
	session="true"
	import="org.opennms.netmgt.config.*,
		java.util.*,
		java.text.*,
		org.opennms.netmgt.config.groups.*,
		org.opennms.netmgt.config.users.DutySchedule,
                org.opennms.web.servlet.MissingParameterException
	"
%>

<%@page import="org.opennms.web.group.WebGroup"%>

<%

    WebGroup group = (WebGroup)request.getAttribute("group");


%>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="组详细" />
  <jsp:param name="headTitle" value="组详细" />
  <jsp:param name="headTitle" value="组" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/userGroupView/index.jsp'>用户和组</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/userGroupView/groups/list.htm'>组列表</a>" />
  <jsp:param name="breadcrumb" value="组详细" />
</jsp:include>

<h2>组详细:<%=group.getName()%></h2>

    <table width="100%" border="0" cellspacing="0" cellpadding="2" >
      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="2">
            <tr>
              <td width="10%" valign="top">
                <b>注释:</b>
              </td>
              <td width="90%" valign="top">
                <%=group.getComments()%>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="2">
            <tr>
              <td width="10%" valign="top">
                <b>默认地图:</b>
              </td>
              <td width="90%" valign="top">
                <%=group.getDefaultMap()%>
              </td>
            </tr>
          </table>
        </td>
      </tr>

      <tr>
        <td>
          <table width="100%" border="0" cellspacing="0" cellpadding="2" >
            <tr>
              <td>
                <b>已分配用户:</b>
                <% Collection users = group.getUsers();
                if (users.size() < 1)
                { %>
                  <table width="50%" border="0" cellspacing="0" cellpadding="2" >
                    <tr>
                      <td>
                        没有用户属于这个组。
                      </td>
                    </tr>
                  </table>
                <% }
                else { %>
                  <table width="50%" border="1" cellspacing="0" cellpadding="2" >
                    <% 	Iterator usersIter = (Iterator)users.iterator(); 
			while (usersIter != null && usersIter.hasNext()) { %>
                      <tr>
                        <td>
                          <%=(String)usersIter.next()%>
                        </td>
                      </tr>
                    <% } %>
                  </table>
                <% } %>
              </td>
            </tr>
            <tr>
              <td>
              <b>值班表:</b>
                    <table width="50%" border="1" cellspacing="0" cellpadding="2" >
                      <% Collection dutySchedules = group.getDutySchedules(); %>
                      <%
                              int i =0;
                              Iterator iter = dutySchedules.iterator();
                              while(iter.hasNext())
                              {
                                      DutySchedule tmp = new DutySchedule((String)iter.next());
                                      Vector curSched = tmp.getAsVector();
                                      i++;
                      %>
                      <tr>
                         <% ChoiceFormat days = new ChoiceFormat("0#Mo|1#Tu|2#We|3#Th|4#Fr|5#Sa|6#Su");
                           for (int j = 0; j < 7; j++)
                           {
                               Boolean curDay = (Boolean)curSched.get(j);
                         %>
                         <td width="5%">
                           <%= (curDay.booleanValue() ? days.format(j) : "X")%>
                         </td>
                         <% } %>
                         <td width="5%">
                           <%=curSched.get(7)%>
                         </td>
                         <td width="5%">
                           <%=curSched.get(8)%>
                         </td>
                       </tr>
                       <% } %>
                     </table>
                 </td>
               </tr>      
          </table>
        </td>
      </tr>
    </table>

<jsp:include page="/includes/footer.jsp" flush="false"/>
