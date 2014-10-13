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
		org.opennms.web.api.Util,
		org.opennms.netmgt.config.*,
		org.opennms.netmgt.config.destinationPaths.*
	"
%>

<%!
    public void init() throws ServletException {
        try {
            DestinationPathFactory.init();
        }
        catch( Exception e ) {
            throw new ServletException( "Cannot load configuration file", e );
        }
    }
%>

<%
    String intervals[] = {"0s", "1s","2s","5s","10s","15s","30s","0m", "1m", "2m", "5m", "10m", "15m", "30m", "1h", "2h", "3h", "6h", "12h", "1d"};
    HttpSession user = request.getSession(true);
    Path newPath = (Path)user.getAttribute("newPath");
    List<String> targetLinks = new ArrayList<String>();
    List<String> escalateDelays = new ArrayList<String>();
    
    targetLinks.add( "Initial Targets" );
    String[] targets = new String[newPath.getEscalateCount()];
    for (int i = 0; i < targets.length; i++)
    {
        targetLinks.add("Escalation # " + (i+1));
        escalateDelays.add(newPath.getEscalate()[i].getDelay());
    }
%>

<script type="text/javascript" >

    function edit_path(index) 
    {
        document.outline.userAction.value="edit";
        document.outline.index.value=index;
        document.outline.submit();
    }
    
    function add_path(index)
    {
        document.outline.userAction.value="add";
        document.outline.index.value=index;
        document.outline.submit();
    }
    
    function remove_path(index)
    {
        message = "你确定要删除上报 #" + (index+1);
        if (confirm(message))
        {
            document.outline.userAction.value="remove";
            document.outline.index.value=index;
            document.outline.submit();
        }
    }
    
    function trimString(str) 
    {
        while (str.charAt(0)==" ")
        {
          str = str.substring(1);
        }
        while (str.charAt(str.length - 1)==" ")
        {
          str = str.substring(0, str.length - 1);
        }
        return str;
    }
    
    function finish()
    {
        trimmed = trimString(document.outline.name.value);
        if (trimmed=="")
        {
            alert("请提供此路径的名称。");
            return false;
        }
        else if (trimmed.indexOf(" ") != -1)
        {
            alert("请不要在路径名称中使用空格。");
            return false;
        }
        else if (document.outline.escalate0.options.length==0)
        {
            alert("请提供此路径的一些初始目标。");
            return false;
        }
        else
        {
            document.outline.userAction.value="finish";
            return true;
        }
    }
    
    function cancel()
    {
        document.outline.userAction.value="cancel";
        document.outline.submit();
    }

</script>

<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="路径摘要" />
  <jsp:param name="headTitle" value="路径摘要" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/index.jsp'>配置通知</a>" />
  <jsp:param name="breadcrumb" value="<a href='admin/notification/destinationPaths.jsp'>目标路径</a>" />
  <jsp:param name="breadcrumb" value="路径摘要" />
</jsp:include>

<h2><%=(newPath.getName()!=null ? "编辑路径: " + newPath.getName() + "<br/>" : "")%></h2>

<h3>从下面选择要编辑的路径。当所有的编辑完成后单击<i>完成</i>按钮。只有在点击<i>完成</i>按钮后，改变才会被保存。
  </h3>

<form method="post" name="outline" action="admin/notification/destinationWizard" onsubmit="return finish();">
  <input type="hidden" name="sourcePage" value="pathOutline.jsp"/>
  <input type="hidden" name="index"/>
  <input type="hidden" name="userAction"/>
  <input type="hidden" name="escalation" value="false"/>
  <table>
    <tr>
      <td>名称: 
      <% if (newPath.getName()==null) { %>
        <input type="text" name="name" value=""/>
      <% } else { %>
        <input type="text" name="name" value="<%=newPath.getName()%>"/>
      <% } %>
      </td>
    </tr>
    <tr>
      <td>
      初始延迟: <%=buildDelaySelect(intervals, "initialDelay", newPath.getInitialDelay())%>
      </td>
    </tr>
    <% for (int i = 0; i < targetLinks.size(); i++) { %>
     <tr>
       <td>
        <table width="15%" bgcolor="#999999" cellspacing="2" cellpadding="2" border="1">
          <tr>
            <td width="10%">
              <b>
              <% if (i==0) { %>
                <%="初始目标"%>
              <% } else { %>
                <%="上报 #" + i%>
              <% } %>
              </b>
              <br/>
              <% if (i > 0) { %>  
                延迟:
                <%=buildDelaySelect(intervals, "escalate"+(i-1)+"Delay", newPath.getEscalate(i-1).getDelay())%><br/>
              <% } %>
              <%=buildTargetList(i, newPath, "escalate"+i)%>  
            </td>
            <td width="5%" valign="top">
                <input type="button" value="编辑" onclick="edit_path(<%=i-1%>)"/>
                <br/>
                &nbsp;
                <br/>
                <%if (i > 0) { %>
                  <input type="button" value="删除" onclick="remove_path(<%=i-1%>)"/>
                <% } else { %>
                  &nbsp;
                <% } %>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>
        <input type="button" value="添加上报" onclick="add_path(<%=i%>)"/>
      </td>
    </tr>
    <% } %>
    <tr>
      <td>
        <input type="submit" value="完成"/>
        <input type="button" value="取消" onclick="cancel()"/>
      </td>
    </tr>
  </table>
</form>

<jsp:include page="/includes/footer.jsp" flush="false" />

<%!
    public String buildDelaySelect(String[] intervals, String name, String currValue)
    {
          boolean gotCurrValue = false;
          StringBuffer buffer = new StringBuffer("<select name=\"" + name  + "\">");
                    
          for (int i = 0; i < intervals.length; i++)
          {
             if (intervals[i].equals(currValue))
             {
                 buffer.append("<option selected=\"selected\" value=\"" + intervals[i] + "\">").append(intervals[i]).append("</option>");
                 gotCurrValue = true;
             }
             else
             {
                  buffer.append("<option value=\"" + intervals[i] + "\">").append(intervals[i]).append("</option>");
             }
          }
          if (!gotCurrValue)
          {
              buffer.append("<option selected=\"selected\" value=\"" + currValue + "\">").append(currValue).append("</option>");
          }
          buffer.append("</select>");
          
          return buffer.toString();
    }
    
    public String buildTargetList(int index, Path path, String name)
    {
        StringBuffer buffer = new StringBuffer("<select width=\"200\" style=\"width: 200px\" name=\""+name+"\" size=\"4\">");
        Target[] targetList = new Target[0];
        
        if (index == 0)
        {
            targetList = path.getTarget();
        }
        else
        {
            targetList = path.getEscalate()[index-1].getTarget();
        }
        
        for (int i = 0; i < targetList.length; i++)
        {
            buffer.append("<option>").append( targetList[i].getName() ).append("</option>");
        }
        buffer.append("</select>");
        
        return buffer.toString();
    }
%>
