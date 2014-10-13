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
%>


<jsp:include page="/includes/header.jsp" flush="false" >
  <jsp:param name="title" value="配置SNMP参数每个轮询IP" />
  <jsp:param name="headTitle" value="SNMP配置" />
  <jsp:param name="headTitle" value="管理" />
  <jsp:param name="location" value="admin" />
  <jsp:param name="breadcrumb" value="<a href='admin/index.jsp'>管理</a>" />
  <jsp:param name="breadcrumb" value="配置SNMP通过IP" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/ipv6.js'></script>" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/lib/jsbn.js'></script>" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/lib/jsbn2.js'></script>" />
  <jsp:param name="script" value="<script type='text/javascript' src='js/ipv6/lib/sprintf.js'></script>" />
</jsp:include>

<script type="text/javascript">
        function verifySnmpConfig()
        {
                var errorMsg = new String("");
                var ipValue = new String("");

                ipValue = new String(document.snmpConfigForm.firstIPAddress.value);

                if (!isValidIPAddress(ipValue)) {
                    errorMsg = ipValue + " 不是一个有效的IP地址！";
                }
                if (errorMsg == ""){
                        ipValue = new String(document.snmpConfigForm.lastIPAddress.value);
                        if (ipValue != ""){
                            if (!isValidIPAddress(ipValue)) {
                                errorMsg = ipValue + " 不是一个有效的IP地址！";
                            }
                        }
                }

                if (errorMsg == ""){
                        var communityStringValue = new String(document.snmpConfigForm.communityString.value);
                        if (communityStringValue == "") {
                                errorMsg = "团体名是必需的";
                        }
                }

                if (errorMsg != ""){
                        alert (errorMsg);
                        return false;
                }
                else{
                        document.snmpConfigForm.action="admin/snmpConfig";
                        return true;
                }
        }
    
        function cancel()
        {
                document.snmpConfigForm.action="admin/index.jsp";
                document.snmpConfigForm.submit();
        }
</script>

<form method="post" name="snmpConfigForm" onsubmit="return verifySnmpConfig();">

  <div class="TwoColLAdmin">

      <h3>请在下面输入IP或IP范围和读团体名</h3>
  	
      <table>
         <tr>
            <td width="25%">
               第一个IP地址:
            </td>
            <td width="50%">
               <input size=15 name="firstIPAddress">
            </td>
         </tr>

         <tr>
            <td width="25%">
               最后一个IP地址:
            </td>
            <td width="50%">
               <input size=15 name="lastIPAddress"> (可选)
            </td>
          </tr>

          <tr>
             <td width="25%">
                团体名:
             </td>
             <td width="50%">
                <input size=30 name="communityString">
             </td>
          </tr>

         <tr>
            <td width="25%">
               超时:
            </td>
            <td width="50%">
               <input size=15 name="timeout"> (可选)
            </td>
          </tr>

         <tr>
            <td width="25%">
               版本:
            </td>
            <td width="50%">
               <select name="version">
               <option>v1</option>
               <option selected="true">v2c</option>
               <option>v3</option>
               </select>
                (可选)
            </td>
          </tr>

         <tr>
            <td width="25%">
               重试:
            </td>
            <td width="50%">
               <input size=15 name="retryCount"> (可选)
            </td>
          </tr>

         <tr>
            <td width="25%">
               端口:
            </td>
            <td width="50%">
               <input size=15 name="port"> (可选)
            </td>
          </tr>

          <tr>
             <td>
                <input type="submit" value="提交">
             </td>
             <td>
                <input type="button" value="取消" onclick="cancel()">
             </td>
          </tr>
       </table>
  </div>

  <div class="TwoColRAdmin">
      <h3>更新SNMP团体名</h3>

      <p>在左边的框中，输入一个IP地址和团体名，或者一个IP地址范围和一个团体名，和其它SNMP参数。
      </p>

      <p>OpenNMS会优化这个列表，所以输入的第一个是最通用的(即最大范围)并且最后一个是特定的IP地址，因为如果添加一个范围，其中包括一个特定的IP地址，特定地址团体名将改为范围内的。
      </p>

      <p>如果设备上的SNMP团体名已经改变，则系统会产生一个SNMP数据采集失败的事件。这时你需要在节点页面通过 "更新SNMP"按钮来使新的团体名信息生效。
      </p>
  </div>

</form>

<jsp:include page="/includes/footer.jsp" flush="false" />
