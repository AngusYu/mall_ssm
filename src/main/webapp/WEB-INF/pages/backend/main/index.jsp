<%--
  Created by IntelliJ IDEA.
  User: AngusYu
  Date: 2017/10/28
  Time: 16:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@include file="../public/head.jspf" %>
    <style type="text/css">
        #merchandise_management_menu ul,#account_management_menu ul,#advanced_menu ul {
            list-style: none;
            padding: 0px;
            margin: 0px;
        }

        #merchandise_management_menu ul li a,#account_management_menu ul li a,#advanced_menu ul li a {
            display: block;
            text-decoration: none;
        }

    </style>
    <script type="text/javascript">
            function logout() {
                $(location).prop('href', 'backend/logout');
            }
            $(function() {
                $("a[title]").click(function() {
                    var text = $(this).text();
                    var href = $(this).attr("title");

                    if ($("#tt").tabs("exists", text)) {
                        $("#tt").tabs("select", text);
                    } else {
                        $("#tt").tabs("add", {
                            title: text,
                            closable: true,
                            content: '<iframe src="/backend/' + href + '" frameborder="0" style="width:100%;height:100%;margin:0px;" />'
                        });
                    }
                });
            });
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'north',title:'Welcome to the Mall CMS.'," style="height:80px;">
        <div style="float: right;vertical-align: middle;height: 100%;">
            Admin: <span style="color: #00bbee">${admin.loginName}</span> <a class="easyui-linkbutton" onclick="logout();">Logout</a>
        </div>
    </div>
    <div data-options="region:'west',title:'Operations'," style="width:220px;">
        <div id="aa" class="easyui-accordion" data-options="multiple:true">
            <div id="merchandise_management_menu" title="Merchandise Management" data-options="iconCls:'icon-save'" style="overflow:auto;">
                <ul>
                    <li><a  title="management/merchandise/category" class="easyui-linkbutton">Category Management</a></li>
                    <li><a  title="management/merchandise/product" class="easyui-linkbutton">Product Management</a> </li>
                </ul>
            </div>
            <div id="account_management_menu" title="Account Management" data-options="iconCls:'icon-man'" style="overflow:auto;">
                <ul>
                    <li><a  title="management/account/user" class="easyui-linkbutton">User Management</a> </li>
                    <li><a  title="management/account/admin" class="easyui-linkbutton">Admin Management</a> </li>
                </ul>
            </div>
            <div id="advanced_menu" title="Advanced" data-options="iconCls:'icon-reload'">
                <ul>
                    <li><a  title="advanced/1" class="easyui-linkbutton">Advanced 1</a></li>
                    <li><a  title="advanced/2" class="easyui-linkbutton">Advanced 2</a> </li>
                </ul>
            </div>
        </div>
    </div>
    <div data-options="region:'center'," style="">
        <div id="tt" class="easyui-tabs" data-options="fit:true">
            <div title="Default Tab" style="padding: 10px;">
                Showing Operation Details Tabs here.
            </div>
        </div>
    </div>
</body>
</html>

