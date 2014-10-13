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
		org.opennms.netmgt.config.destinationPaths.*,
        org.opennms.netmgt.config.notificationCommands.Command
	"
%>

<%!
    public void init() throws ServletException {
        try {
            UserFactory.init();
            GroupFactory.init();
            DestinationPathFactory.init();
            NotificationCommandFactory.init();
        }
        catch( Exception e ) {
            throw new ServletException( "Cannot load configuration file", e );
        }
    }
%>

<%
    HttpSession user = request.getSession(true);
    Path newPath = (Path)user.getAttribute("newPath");
%>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="选择命令" />
  <jsp:param name="headTitle" value="选择命令" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/destinationPaths.jsp'>目标路径</a>" />
  <jsp:param name="breadcrumb" value="选择命令" />
</jsp:include>

<script type="text/javascript" >

    function next() 
    {
        var missingCommands=false;
        for (i=0; i<document.commands.length; i++)
        {
            if (document.commands.elements[i].type=="select-multiple" && 
                document.commands.elements[i].selectedIndex==-1)
            {
                missingCommands=true;
            }
        }
        
        if (missingCommands)
        {
            alert("请为每个用户和组至少选择一个命令。");
        }
        else
        {
            document.commands.submit();
        }
    }

</script>

<h2><%=(newPath.getName()!=null ? "编辑路径: " + newPath.getName() + "<br/>" : "")%></h2>

<h3>选择为每个用户和组使用的命令。
可以选择多个命令(电子邮件地址除外)。
也可以选择所需的行为为"Up"事件的自动通知。</h3>

<form method="post" name="commands"
      action="admin/notification/destinationWizard">
  <%=Util.makeHiddenTags(request)%>

  <input type="hidden" name="sourcePage" value="chooseCommands.jsp"/>

  <br/>

  <%=buildCommands(newPath, WebSecurityUtils.safeParseInt(request.getParameter("targetIndex")))%>

  <div class="spacer"><!-- --></div>

  <br/>

  <input type="reset"/>

  <br/>

  <a href="javascript:next()">下一步 &#155;&#155;&#155;</a>
</form>

<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
    public String buildCommands(Path path, int index)
      throws ServletException
    {
        StringBuffer buffer = new StringBuffer();
        buffer.append("<table cellspacing=\"2\" cellpadding=\"2\" border=\"0\">");
        
        Target targets[] = null;
        
        try {
          targets = DestinationPathFactory.getInstance().getTargetList(index, path);
        
        for (int i = 0; i < targets.length; i++)
        {
            buffer.append("<tr><td>").append(targets[i].getName()).append("</td>");
            // don't let user pick commands for email addresses
            if (targets[i].getName().indexOf("@")==-1)
            {
                buffer.append("<td>").append(buildCommandSelect(path, index, targets[i].getName())).append("</td>");
            }
            else
            {
                buffer.append("<td>").append("email adddress").append("</td>");
            }
            buffer.append("<td>").append(buildAutoNotifySelect(targets[i].getName(), targets[i].getAutoNotify())).append("<td>");
            buffer.append("</tr>");
        }
        } catch (Throwable e)
        {
            throw new ServletException("couldn't get list of targets for path " + path.getName(), e);
        }
        
        buffer.append("</table>");
        return buffer.toString();
    }
    
    public String buildCommandSelect(Path path, int index, String name)
      throws ServletException
    {
        StringBuffer buffer = new StringBuffer("<select multiple size=\"3\" NAME=\"" + name + "Commands\">");
        
        TreeMap<String, Command> commands = null;
        Collection<String> selectedOptions = null;
        
        try {
          selectedOptions = DestinationPathFactory.getInstance().getTargetCommands(path, index, name);
          commands = new TreeMap<String, Command>(NotificationCommandFactory.getInstance().getCommands());
        
        if (selectedOptions==null || selectedOptions.size()==0)
        {
            selectedOptions = new ArrayList<String>();
            selectedOptions.add("javaEmail");
        }

        for(String curCommand : commands.keySet()) {
            if (selectedOptions.contains(curCommand))
            {
                buffer.append("<option selected VALUE=\"" + curCommand + "\">").append(curCommand).append("</option>");
            }
            else
            {
                buffer.append("<option VALUE=\"" + curCommand + "\">").append(curCommand).append("</option>");
            }
        }
        } catch (Throwable e)
        {
            throw new ServletException("couldn't get list of commands for path/target " + path.getName()+"/"+name, e);
        }
        
        buffer.append("</select>");
        
        return buffer.toString();
    }

    public String buildAutoNotifySelect(String name, String currValue)
    {
          String values[] = {"off", "auto", "on"};
          StringBuffer buffer = new StringBuffer("<select size=\"3\" NAME=\"" + name  + "AutoNotify\">");
          String defaultOption = "on";
 
          if(currValue == null || currValue.equals("")) {
              currValue = defaultOption;
          }
          for (int i = 0; i < values.length; i++)
          {
             if (values[i].equalsIgnoreCase(currValue))
             {
                 buffer.append("<option selected VALUE=\"" + values[i] + "\">").append(values[i]).append("</option>");
             }
             else
             {
                  buffer.append("<option VALUE=\"" + values[i] + "\">").append(values[i]).append("</option>");
             }
          }
          buffer.append("</select>");
          
          return buffer.toString();
    }
%>
