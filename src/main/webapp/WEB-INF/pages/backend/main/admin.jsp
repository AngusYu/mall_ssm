<%--
  Created by IntelliJ IDEA.
  Admin: AngusYu
  Date: 2017/11/12
  Time: 23:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Management</title>
    <%@include file="../public/head.jspf" %>
    <script type="text/javascript">
        // datagrid
            // function cellStyler(value,row,index){
            //  if (value < 30){
            //      return 'background-color:#ffee00;color:red;';
            //  }
            // };
            function dbClickToEdit(index,row) {
            loadEAFormFromRow(row);
            $("#edit_admin_wd").window('open');
        }
        // datagrid toolbar
            function addAdmin() {
                $("#add_admin_form").form('reset');
                $("#add_admin_form").form('resetValidation');
                $('#add_admin_wd').window('open');
            };
            function editAdmin() {
                var rows = $('#admin_dg').datagrid('getSelections');
                var errMsg = '';
                if (rows.length == 1) {
                    var row = $("#admin_dg").datagrid('getSelected');
                    loadEAFormFromRow(row);
                    $("#edit_admin_wd").window("open");
                } else {
                    if (rows.length == 0) { errMsg = 'Please select one row to proceed!'; } else { errMsg = 'Please select ONLY one row to proceed!'; }
                    $.messager.show({
                        title: 'Operation Error',
                        msg: errMsg,
                        timeout: 2500,
                        showType: 'slide',
                        height: 120,
                    });
                }
            };
            function deleteAdmin() {
                var rows = $('#admin_dg').datagrid('getSelections');
                var confirmMsg = '';
                if (rows.length == 0) {
                    $.messager.show({
                        title: 'Operation Error',
                        msg: 'At least select one row to proceed!',
                        timeout: 2500,
                        showType: 'slide',
                        height: 120,
                    });
                } else {
                    if (rows.length == 1) {
                        confirmMsg = 'Confirm to delete 1 row?';
                    } else {
                        confirmMsg = 'Confirm to delete ' + rows.length + ' rows?'
                    }
                    $.messager.confirm('Delete Prompt Dialog', confirmMsg, function(r) {
                        if (r) {
                            var idsData = "";
                            for (var i = 0; i < rows.length; i++) {
                                idsData += rows[i].id + ",";
                            }
                            idsData = idsData.substr(0, idsData.lastIndexOf(","));
                            $.post("backend/management/account/admin/delete", {ids: idsData}, function (result) {
                                var status = parseInt(result);
                                if (status > 0) {
                                    var deleteMsg = "";
                                    if (status == 1) {
                                        deleteMsg = "1 admin has deleted!";
                                    } else {
                                        deleteMsg = status + " admins have deleted!";
                                    }
                                    $.messager.show({
                                        title: 'Delete Admin',
                                        msg: deleteMsg,
                                        timeout: 2500,
                                        showType: 'slide',
                                        height: 120,
                                    });
                                    $("#admin_dg").datagrid("reload");
                                } else if (status == 0) {
                                    $.messager.show({
                                        title: 'Delete Admin',
                                        msg: 'Delete failed!',
                                        timeout: 2500,
                                        showType: 'slide',
                                        height: 120,
                                    });
                                } else if (status == -1) {
                                    $.messager.show({
                                        title: 'Delete Admin',
                                        msg: 'Wrong parameter!',
                                        timeout: 2500,
                                        showType: 'slide',
                                        height: 120,
                                    });
                                } else {
                                    alert(result);
                                }
                                $("#admin_dg").datagrid("uncheckAll");
                            });
                        }
                    });
                }
            };
            function adminSearch(value) {
                $("#admin_dg").datagrid('load',{
                    fuzzyParam:value,
                });
            };
            function reloadForm() {
                var t=$('#ss').searchbox('getValue');
                if(t==""){
                    $('#admin_dg').datagrid('load',{
                        fuzzyParam:"",
                    });
                }else {
                    $('#admin_dg').datagrid('load');
                }
            };
        // add_admin_wd
            function addAdminFormSubmit() {
                if ($("#add_admin_form").form("validate")) {
                    $("#add_admin_form").form("submit", {
                        url: 'backend/management/account/admin/add',
                        success: function (result) {
                            var status = parseInt(result);
                            if (status == 1) {
                                $.messager.show({
                                    title: 'Add Admin',
                                    msg: 'Add success!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                                $("#add_admin_wd").window("close");
                            } else if (status == 0) {
                                $.messager.show({
                                    title: 'Add Admin',
                                    msg: 'Add failed!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                            } else if (status == -1) {
                                $.messager.show({
                                    title: 'Add Admin',
                                    msg: 'Wrong parameter!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                            } else {
                                alert(result);
                            }
                            $("#admin_dg").datagrid("reload");
                        }
                    });
                }
            };
        // edit_admin_wd
            function onChangeEAEditPassSwcBtn(checked) {
                if (checked) {
                    enableEAPswbox();
                    resetEAPswbox();
                } else {
                    setEAPswbox($('#s_password').passwordbox('getValue'));
                    disableEAPswbox();
                }
            };
        // edit_admin_wd edit_admin_form passwordbox
            function enableEAPswbox() {
                $("#ea_password").passwordbox("enable");
                $("#ea_confirm_password").passwordbox("enable");
            };
            function disableEAPswbox() {
                $("#ea_password").passwordbox("disable");
                $("#ea_confirm_password").passwordbox("disable");
            };
            function resetEAPswbox() {
                $("#ea_password").passwordbox("reset");
                $("#ea_confirm_password").passwordbox("reset");
                $("#ea_password").passwordbox("resetValidation");
                $("#ea_confirm_password").passwordbox("resetValidation");
            };
            function setEAPswbox(value) {
                $("#ea_password").passwordbox('setValue',value);
                $("#ea_confirm_password").passwordbox('setValue',value);
            };
            function editAdminFormSubmit() {
                if ($("#edit_admin_form").form("validate")) {
                    $("#edit_admin_form").form("submit", {
                        url: 'backend/management/account/admin/update',
                    success: function (result) {
                        var status = parseInt(result);
                        if (status == 1) {
                            $.messager.show({
                                title: 'Edit Admin',
                                msg: 'Update success!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                            $("#edit_admin_wd").window("close");
                        } else if (status == 0) {
                            $.messager.show({
                                title: 'Edit Admin',
                                msg: 'Update failed!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else if (status == -1) {
                            $.messager.show({
                                title: 'Edit Admin',
                                msg: 'Wrong parameter!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else {
                            alert(result);
                        }
                        $("#admin_dg").datagrid("reload");
                    }
                    });
                }
            };
            function editAdminReloadNew() {
                var adminId = $("#ea_id").textbox('getValue');
                var rowIndex = $("#admin_dg").datagrid('getRowIndex', adminId);
                var row = $("#admin_dg").datagrid('getData').rows[rowIndex];
                loadEAFormFromRow(row);
            };
            function loadEAFormFromRow(row) {
                $("#s_login_name").textbox('setValue', row.loginName);
                $("#s_password").passwordbox('setValue',row.password);
                $("#edit_admin_form").form('load', {
                    id: row.id,
                    loginName: row.loginName
                });
                setEAPswbox(row.password);
                $("#ea_edit_new_password").switchbutton('uncheck');
            };
        // grobal
            function err(target, message) {
                var t = $(target);
                if (t.hasClass('textbox-text')) {
                    t = t.parent();
                }
                var m = t.next('.error-message');
                if (!m.length) {
                    m = $('<div class="error-message" style="margin:4px;padding:0;color:red;"></div>').insertAfter(t);
                }
                m.html(message);
            };
            function formatPassword(val,row) {
                return '<span title="'+val+'">Hover to view..</span>';
            }
            $.extend($.fn.validatebox.defaults.rules, {
                loginName:{
                    validator:function (value) {
                        return /^[a-zA-Z]\w{4,19}$/i.test(value);
                    },
                    message:'Invalid login name! (length[5~20], should starts with a letter, and allow letter, number or underline.)'
                },
                ajaxCheckLoginName:{validator:function(value,param){
                    var sendData = {};
                    sendData['loginName'] = value;
                    if (param) {
                        var t = $(param[0]).val();
                        if (t && t == value) {
                            return true;
                        }
                    }
                    var response = $.ajax({
                        url: 'backend/management/account/admin/check',
                        dataType: "json",
                        data: sendData,
                        async: false,
                        cache: false,
                        type: "POST"
                    }).responseText;
                    return response == 'true';
                },
                    message:"Login Name is already exists!"
                },
                password:{
                    validator:function (value) {
                        return /^\w{5,20}$/i.test(value);
                    },
                    message:'Invalid value! (length[5~20], allow letter, number or underline.)'
                },
                confirmPass:{
                    validator:function (value,param) {
                        var pass = $(param[0]).passwordbox('getValue');
                        return value == pass;
                    },
                    message: 'Password does not match confirmation!'
                },
            });
    </script>
</head>
<body>
<!-- datagrid -->
<table id="admin_dg" class="easyui-datagrid" title="Admin Management" style="height: 550px;" rownumbers="true" singleSelect="false" fitColumns="false" iconCls="icon-save" pagination="true" fit="true" pageSize="15" pageList="[10,15,20,25]" idField="id" striped="true" url="backend/management/account/admin/list" toolbar="#admin_dg_tb" data-options="onDblClickRow:dbClickToEdit,nowarp:true,">
    <thead frozen="true">
    <tr>
        <th field="ck" checkbox="true"></th>
        <th field="id" width="60" halign="center" align="right">Admin ID</th>
        <th field="loginName" width="150" halign="center" align="right">Login Name</th>
        <th field="password" width="150" halign="center" align="right" data-options="formatter:formatPassword,">Password</th>
    </tr>
    </thead>
</table>
<!-- toolbar -->
<div id="admin_dg_tb">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" data-options="" onclick="addAdmin()">Add Admin</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="editAdmin()">Edit Admin</a>
    <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteAdmin()">Delete Admin</a>
    <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
    <input id="ss" class="easyui-searchbox" style="width:150px" data-options="searcher:adminSearch,prompt:'Search admin'"></input>
    <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-clear" onclick="$('#admin_dg').datagrid('clearSelections');">Clear Selections</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload"
       onclick="reloadForm();">Reload Form</a>
</div>
<!-- add_admin_wd -->
<div id="add_admin_wd" class="easyui-window" title="Add Admin Window" data-options="modal:true,closed:true,iconCls:'icon-add',collapsible:false,minimizable:false,maximizable:false" style="width:300px;height:280px;padding:5px;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center',border:false" style="padding:10px;">
            <form id="add_admin_form" method="post">
                <div>
                    <div class="input-group-center">
                        <input name="loginName" class="easyui-textbox" prompt="Login name" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['loginName','ajaxCheckLoginName'],delay:750,width:220," label="Login Name:" labelPosition="top">
                        <div>
                            <input name="password" id="aa_password" class="easyui-passwordbox" prompt="Password" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['password'],delay:500,width:220,iconWidth:28," label="Password:" labelPosition="top">
                            <input prompt="Confirm your password" class="easyui-passwordbox" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['confirmPass[\'#aa_password\']'],delay:500,width:220,iconWidth:28," label="Comfirm Password:" labelPosition="top">
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <div data-options="region:'south',border:false" style="text-align:right;padding:5px;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" href="javascript:void(0)" onclick="addAdminFormSubmit()">Add Admin</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="$('#add_admin_wd').window('close')">Cancel</a>
        </div>
    </div>
</div>
<!-- edit_admin_wd -->
<div id="edit_admin_wd" class="easyui-window" title="Edit Admin Window" collapsible="false" minimizable="false" maximizable="false" data-options="modal:true,closed:true,iconCls:'icon-edit'" style="width:400px;height:450px;padding:5px;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center',border:false" style="padding:10px;">
            <form id="edit_admin_form" method="post">
                <div>
                    <div class="input-group-center" style="margin-left: 75px;">
                        <label for="ea_id">Admin ID: </label>
                        <input name="id" id="ea_id" class="easyui-textbox" style="text-align: right;width: 120px" editable="false">
                        <div>
                            <input id="s_login_name" class="easyui-textbox" label="Source Login Name:" labelPosition="top" disabled="true" data-options="width:220,">
                            <input name="loginName" id="ea_login_name" class="easyui-textbox" prompt="New login name" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['loginName','ajaxCheckLoginName[\'#s_login_name\']'],delay:750,width:220," label="New Login Name:" labelPosition="top">
                        </div>
                        <div>
                            <input id="s_password" class="easyui-passwordbox" data-options="width:220,iconWidth:28,editable:false,revealed:false," label="Source Password:" labelPosition="top">
                        </div>
                        <div>
                            <label for="ea_edit_new_password">Edit New Password?: </label>
                            <input id="ea_edit_new_password" class="easyui-switchbutton" data-options="onText:'Yes',offText:'No',onChange:onChangeEAEditPassSwcBtn," >
                        </div>
                        <div>
                            <input name="password" id="ea_password" class="easyui-passwordbox" prompt="New password" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['password'],delay:500,width:220,iconWidth:28,revealed:false," label="New Password:" labelPosition="top" disabled="true">
                            <input prompt="Confirm your new password" id="ea_confirm_password" class="easyui-passwordbox" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['confirmPass[\'#ea_password\']'],delay:750,width:220,iconWidth:28,revealed:false," label="Comfirm New Password:" labelPosition="top" disabled="true">
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <div data-options="region:'south',border:false" style="text-align:right;padding:5px;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0)" onclick="editAdminFormSubmit()">Update Admin</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-reload'" href="javascript:void(0)" onclick="editAdminReloadNew()">Reload New*</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="$('#edit_admin_wd').window('close')">Cancel</a>
        </div>
    </div>
</div>
</body>
</html>
