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
			org.opennms.core.utils.WebSecurityUtils,
            org.opennms.web.api.Util,
            org.opennms.netmgt.config.*,
            org.opennms.netmgt.config.destinationPaths.*"
%>

<%!public void init() throws ServletException {
        try {
            UserFactory.init();
            GroupFactory.init();
            DestinationPathFactory.init();
        } catch (Throwable e) {
            throw new ServletException("Cannot load configuration file", e);
        }
    }%>

<%
            HttpSession user = request.getSession(true);
            Path newPath = (Path) user.getAttribute("newPath");

            Collection targets = null;

            int index = WebSecurityUtils.safeParseInt(request.getParameter("targetIndex"));
            if (index < 0) {
                targets = newPath.getTargetCollection();
            } else {
                targets = newPath.getEscalate()[index].getTargetCollection();
            }
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="选择目标" />
  <jsp:param name="headTitle" value="选择目标" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/destinationPaths.jsp'>目标路径</a>" />
  <jsp:param name="breadcrumb" value="选择目标" />
</jsp:include>

<script type="text/javascript" >

    function next() 
    {
        if (document.targets.groups.selectedIndex >= 0)
        {
            selectAllEmails();
            document.targets.nextPage.value="groupIntervals.jsp";
            document.targets.submit();
        } 
        else if (document.targets.users.selectedIndex >= 0)
        {
            selectAllEmails();
            document.targets.nextPage.value="chooseCommands.jsp";
            document.targets.submit();
        }
        else if (document.targets.roles.selectedIndex >= 0)
        {
        		selectAllEmails();
            document.targets.nextPage.value="chooseCommands.jsp";
            document.targets.submit();
        }
        else if (document.targets.emails.length>0)
        {
            selectAllEmails();
            // document.targets.nextPage.value="pathOutline.jsp";
            document.targets.nextPage.value="chooseCommands.jsp";
            document.targets.submit();
        }
        else
        {
            alert("请选择至少一个用户，组，或电子邮件地址作为目标。");
        }
    }
    
    function selectAllEmails()
    {
        //select all emails to they get sent to the servlet
        for (i=0; i < document.targets.emails.length; i++) 
        {
            document.targets.emails.options[i].selected = true;
        }
    }
    
    function addAddress()
    {
        var address = prompt("请输入一个电子邮件地址的类型。");
        
        if (address!="")
        {
            if(address.indexOf("@",0)==-1)
            {
                alert("地址 '"+address+"' 不包含'@'符号，并且可能与一个用户或组的名称相混淆。请输入新的电子邮件地址。");
            }
        else
        {
                document.targets.emails.options[document.targets.emails.length]= new Option(address);
            }
        }
    }
    
    function removeAddress()
    {
        if (document.targets.emails.selectedIndex >=0)
        {
            for ( i=(document.targets.emails.length-1); i>=0; i--) 
            {
                if (document.targets.emails.options[i].selected == true ) 
                {
                    document.targets.emails.options[i] = null;
                }
            }
        }
        else
        {
            alert("请在列表中选择一个要删除的地址。");
        }
    }

</script>


<h2><%=(newPath.getName() != null ? "编辑路径: "
                            + newPath.getName() + "<br/>" : "")%></h2>

<h3>选择发送通知的用户和组。</h3>

<form method="post" name="targets"
action="admin/notification/destinationWizard" >
<%=Util.makeHiddenTags(request)%>
<input type="hidden" name="sourcePage" value="chooseTargets.jsp"/>
<input type="hidden" name="nextPage"/>

<table cellspacing="2" cellpadding="2" border="0">
        <tr>
          <td valign="top"><h4>发送给选定的用户:</h4></td>
          <td>&nbsp;</td>
          <td valign="top"><h4>发送给选定的组:</h4></td>
          <td>&nbsp;</td>
          <td valign="top"><h4>发送给选定的角色:</h4></td>
          <td>&nbsp;</td>
          <td valign="top"><h4>发送给电子邮件地址:</h4></td>
        </tr>
        <tr>
          <td valign="top">突出每个需要收到通知的用户。</td>
          <td>&nbsp;</td>
          <td valign="top">突出每个需要收到通知的组。每个组中的用户将收到通知。
              </td>
          <td>&nbsp;</td>
          <td valign="top">突出每一个需要收到通知的角色。用户在值班时间时，将收到通知。
              </td>
          <td>&nbsp;</td>
          <td valign="top">添加任何你要被发送通知的电子邮件地址。</td>
        </tr>
        <tr>
          <td width="25%" valign="top" align="left">
            <select WIDTH="200" STYLE="width: 200px" NAME="users" SIZE="10" multiple>
             <%
                         Map users = getUsers(targets);
                         Iterator iterator = users.keySet().iterator();
                         while (iterator.hasNext()) {
                             String key = (String) iterator.next();
                             if (((Boolean) users.get(key)).booleanValue()) {
             %>
                    <option selected VALUE=<%=key%>><%=key%></option>
            <%
            } else {
            %>
                    <option VALUE=<%=key%>><%=key%></option>
            <%
                        }
                        }
            %>
            </select>
          </td>
          <td>&nbsp;</td>
          <td width="25%" valign="top" align="left">
            <select WIDTH="200" STYLE="width: 200px" NAME="groups" SIZE="10" multiple>
             <%
                         Map groups = getGroups(targets);
                         iterator = groups.keySet().iterator();
                         while (iterator.hasNext()) {
                             String key = (String) iterator.next();
                             if (((Boolean) groups.get(key)).booleanValue()) {
             %>
                    <option selected VALUE=<%=key%>><%=key%></option>
            <%
            } else {
            %>
                    <option VALUE="<%=key%>"><%=key%></option>
            <%
                        }
                        }
            %>
            </select>
           </td>
           <td>&nbsp;</td>
          <td width="25%" valign="top" align="left">
            <select WIDTH="200" STYLE="width: 200px" NAME="roles" SIZE="10" multiple>
             <%
                         Map roles = getRoles(targets);
                         iterator = roles.keySet().iterator();
                         while (iterator.hasNext()) {
                             String key = (String) iterator.next();
                             if (((Boolean) roles.get(key)).booleanValue()) {
             %>
                    <option selected VALUE=<%=key%>><%=key%></option>
            <%
            } else {
            %>
                    <option VALUE=<%=key%>><%=key%></option>
            <%
                        }
                        }
            %>
            </select>
           </td>
           <td>&nbsp;</td>
           <td width="25%" valign="top" align="left">
            <input type="button" value="添加地址" onclick="javascript:addAddress()"/>
            <br/>&nbsp;<br/>
            <select  WIDTH="200" STYLE="width: 200px" NAME="emails" SIZE="7" multiple>
             <%
                         Map emails = getEmails(targets);
                         iterator = emails.keySet().iterator();
                         while (iterator.hasNext()) {
                             String key = (String) iterator.next();
             %>
                    <option VALUE=<%=key%>><%=key%></option>
            <%
            }
            %>
            </select>
            <br/>
            <input type="button" value="删除地址" onclick="javascript:removeAddress()"/>
            </td>
            
        </tr>
        <tr>
          <td colspan="2">
            <input type="reset"/>
          </td>
        </tr>
        <tr>
          <td colspan="2">
           <a href="javascript:next()">下一步 &#155;&#155;&#155;</a>
          </td>
        </tr>
      </table>
    </form>

<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
public Map getUsers(Collection targets) throws ServletException {
        Map<String, Boolean> allUsers = null;

        try {
            allUsers = new TreeMap<String, Boolean>(new Comparator() {
                public int compare(Object o1, Object o2) {
                    return ((String)o1).compareToIgnoreCase((String)o2);
                }

            });
            
            Collection targetNames = getTargetNames(targets);
            for (String key : UserFactory.getInstance().getUserNames()) {
                allUsers.put(key, targetNames.contains(key));
            }

        } catch (Throwable e) {
            throw new ServletException("could not get list of all users.", e);
        }

        return allUsers;
    }

    public Map getGroups(Collection targets) throws ServletException {
        try {
            Collection targetNames = getTargetNames(targets);

            Map<String, Boolean> allGroups = new TreeMap<String, Boolean>();
            for(String key : GroupFactory.getInstance().getGroupNames()) {
                allGroups.put(key, targetNames.contains(key));
            }
            return allGroups;
            
        } catch (Throwable e) {
            throw new ServletException("could not get list of all groups.", e);
        }
    }

    public Map getRoles(Collection targets) throws ServletException {
        try {
            Map<String, Boolean> rolesMap = new TreeMap<String, Boolean>();

            Collection targetNames = getTargetNames(targets);

            for(String key : GroupFactory.getInstance().getRoleNames()) {
                rolesMap.put(key, targetNames.contains(key));
            }

            return rolesMap;
        } catch (Throwable e) {
            throw new ServletException("could not get list of all groups.", e);
        }
    }

    public Map getEmails(Collection targets) throws ServletException {
        Map<String, String> emails = new TreeMap<String, String>();

        try {
            Collection targetNames = getTargetNames(targets);

            Iterator i = targetNames.iterator();
            while (i.hasNext()) {
                String key = (String) i.next();
                if (key.indexOf("@") > -1) {
                    emails.put(key, key);
                }
            }
        } catch (Throwable e) {
            throw new ServletException("could not get list of email targets.",
                    e);
        }

        return emails;
    }

    public Collection<String> getTargetNames(Collection targets) {
        Collection<String> targetNames = new ArrayList<String>();

        Iterator i = targets.iterator();
        while (i.hasNext()) {
            targetNames.add(((Target) i.next()).getName());
        }
        return targetNames;
    }%>
