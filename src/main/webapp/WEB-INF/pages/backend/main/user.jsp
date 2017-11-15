<%--
  Created by IntelliJ IDEA.
  User: AngusYu
  Date: 2017/11/6
  Time: 22:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>User Management</title>
    <%@include file="../public/head.jspf" %>
    <script type="text/javascript">
        // datagrid
            // function cellStyler(value,row,index){
            //  if (value < 30){
            //      return 'background-color:#ffee00;color:red;';
            //  }
            // };
            function dbClickToEdit(index,row) {
            loadECFormFromRow(row);
            $("#edit_user_wd").window('open');
        }
        // datagrid toolbar
            function addUser() {
                $("#add_user_form").form('reset');
                $("#add_user_form").form('resetValidation');
                $('#add_user_wd').window('open');
            };
            function editUser() {
                var rows = $('#user_dg').datagrid('getSelections');
                var errMsg = '';
                if (rows.length == 1) {
                    var row = $("#user_dg").datagrid('getSelected');
                    loadECFormFromRow(row);
                    $("#edit_user_wd").window("open");
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
            function deleteUser() {
                var rows = $('#user_dg').datagrid('getSelections');
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
                            $.post("backend/management/account/user/delete", {ids: idsData}, function (result) {
                                var status = parseInt(result);
                                if (status > 0) {
                                    var deleteMsg = "";
                                    if (status == 1) {
                                        deleteMsg = "1 user has deleted!";
                                    } else {
                                        deleteMsg = status + " users have deleted!";
                                    }
                                    $.messager.show({
                                        title: 'Delete User',
                                        msg: deleteMsg,
                                        timeout: 2500,
                                        showType: 'slide',
                                        height: 120,
                                    });
                                    $("#user_dg").datagrid("reload");
                                } else if (status == 0) {
                                    $.messager.show({
                                        title: 'Delete User',
                                        msg: 'Delete failed!',
                                        timeout: 2500,
                                        showType: 'slide',
                                        height: 120,
                                    });
                                } else if (status == -1) {
                                    $.messager.show({
                                        title: 'Delete User',
                                        msg: 'Wrong parameter!',
                                        timeout: 2500,
                                        showType: 'slide',
                                        height: 120,
                                    });
                                } else {
                                    alert(result);
                                }
                                $("#user_dg").datagrid("uncheckAll");
                            });
                        }
                    });
                }
            };
            function userSearch(value) {
                $("#user_dg").datagrid('load',{
                    fuzzyParam:value,
                });
            };
            function reloadForm() {
                var t=$('#ss').searchbox('getValue');
                if(t==""){
                    $('#user_dg').datagrid('load',{
                        fuzzyParam:"",
                    });
                }else {
                    $('#user_dg').datagrid('load');
                }
            };
        // add_user_wd
            function onChangeAUSexSwcBtn(checked) {
                if (checked) {
                    $("#au_sex_value").val("false");
                } else {
                    $("#au_sex_value").val("true");
                }
                // alert($("#au_sex").val());
            };
            function addUserFormSubmit() {
                if ($("#add_user_form").form("validate")) {
                    $("#add_user_form").form("submit", {
                        url: 'backend/management/account/user/add',
                        success: function (result) {
                            var status = parseInt(result);
                            if (status == 1) {
                                $.messager.show({
                                    title: 'Add User',
                                    msg: 'Add success!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                                $("#add_user_wd").window("close");
                            } else if (status == 0) {
                                $.messager.show({
                                    title: 'Add User',
                                    msg: 'Add failed!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                            } else if (status == -1) {
                                $.messager.show({
                                    title: 'Add User',
                                    msg: 'Wrong parameter!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                            } else {
                                alert(result);
                            }
                            $("#user_dg").datagrid("reload");
                        }
                    });
                }
            };
        // edit_user_wd
            function onChangeEUSexSwcBtn(checked) {
                if (checked) {
                    $("#eu_sex_value").val("false");
                } else {
                    $("#eu_sex_value").val("true");
                }
                // alert($('#eu_sex').val());
            };
            function onChangeEUEditPassSwcBtn(checked) {
                if (checked) {
                    enableEUPswbox();
                    resetEUPswbox();
                } else {
                    setEUPswbox($('#s_password').passwordbox('getValue'));
                    disableEUPswbox();
                }
            };
        // edit_user_wd edit_user_form passwordbox
            function enableEUPswbox() {
                $("#eu_password").passwordbox("enable");
                $("#eu_confirm_password").passwordbox("enable");
            };
            function disableEUPswbox() {
                $("#eu_password").passwordbox("disable");
                $("#eu_confirm_password").passwordbox("disable");
            };
            function resetEUPswbox() {
                $("#eu_password").passwordbox("reset");
                $("#eu_confirm_password").passwordbox("reset");
                $("#eu_password").passwordbox("resetValidation");
                $("#eu_confirm_password").passwordbox("resetValidation");
            };
            function setEUPswbox(value) {
                $("#eu_password").passwordbox('setValue',value);
                $("#eu_confirm_password").passwordbox('setValue',value);
            };
            function editUserFormSubmit() {
                if ($("#edit_user_form").form("validate")) {
                    $("#edit_user_form").form("submit", {
                        url: 'backend/management/account/user/update',
                    success: function (result) {
                        var status = parseInt(result);
                        if (status == 1) {
                            $.messager.show({
                                title: 'Edit User',
                                msg: 'Update success!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                            $("#edit_user_wd").window("close");
                        } else if (status == 0) {
                            $.messager.show({
                                title: 'Edit User',
                                msg: 'Update failed!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else if (status == -1) {
                            $.messager.show({
                                title: 'Edit User',
                                msg: 'Wrong parameter!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else {
                            alert(result);
                        }
                        $("#user_dg").datagrid("reload");
                    }
                    });
                }
            };
            function editUserReloadNew() {
                var userId = $("#eu_id").textbox('getValue');
                var rowIndex = $("#user_dg").datagrid('getRowIndex', userId);
                var row = $("#user_dg").datagrid('getData').rows[rowIndex];
                loadECFormFromRow(row);
            };
            function editUserClearNew() {
                $("#eu_edit_new_password").switchbutton("check");
                $("#edit_user_form").form('load', {
                    loginName: '',
                    userName: '',
                    phone: '',
                    email: '',
                    address: ''
                });
                $("#edit_user_form").form('resetValidation');
            }
            function loadECFormFromRow(row) {
                $("#s_login_name").textbox('setValue', row.loginName);
                $("#s_password").passwordbox('setValue',row.password);
                $("#s_user_name").textbox('setValue', row.userName);
                tglSwcBtnByBool('#eu_sex',row.sex);
                $("#s_phone").textbox('setValue', row.phone);
                $("#s_email").textbox('setValue', row.email);
                $("#s_address").textbox('setValue', row.address);
                $("#edit_user_form").form('load', {
                    id: row.id,
                    loginName: row.loginName,
                    userName: row.userName,
                    phone: row.phone,
                    email: row.email,
                    address: row.address
                });
                setEUPswbox(row.password);
                $("#eu_edit_new_password").switchbutton('uncheck');
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
            function tglSwcBtnByBool(targetId,bool) {
                if (bool) {$(targetId).switchbutton('uncheck');}else{$(targetId).switchbutton('check');}
            };
            function formatBoolToSex(val, row) {
                if (val) { return '<span>Male</span>'; } else { return '<span>Female</span>'; }
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
                        url: 'backend/management/account/user/check',
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
                phone:{
                    validator:function (value) {
                        return /^1[34578]\d{9}$/i.test(value);;
                    },
                    message:'Invalid Phone!'
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
<table id="user_dg" class="easyui-datagrid" title="User Management" style="height: 550px;" rownumbers="true" singleSelect="false" fitColumns="false" iconCls="icon-save" pagination="true" fit="true" pageSize="15" pageList="[10,15,20,25]" idField="id" striped="true" url="backend/management/account/user/list" toolbar="#user_dg_tb" data-options="onDblClickRow:dbClickToEdit,nowarp:true,">
    <thead frozen="true">
    <tr>
        <th field="ck" checkbox="true"></th>
        <th field="id" width="60" halign="center" align="right">User ID</th>
        <th field="loginName" width="150" halign="center" align="right">Login Name</th>
        <th field="password" width="150" halign="center" align="right" data-options="formatter:formatPassword,">Password</th>
        <th field="userName" width="150" halign="center" align="right">Nick Name</th>
    </tr>
    </thead>
    <thead>
    <tr>
        <th field="sex" width="60" halign="center" align="right" data-options="formatter:formatBoolToSex,">Sex</th>
        <th field="phone" width="150" halign="center" align="right">Phone</th>
        <th field="email" width="200" halign="center" align="right">Email</th>
        <th field="address" width="250" halign="center" align="right">Address</th>
    </tr>
    </thead>
</table>
<!-- toolbar -->
<div id="user_dg_tb">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" data-options="" onclick="addUser()">Add User</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="editUser()">Edit User</a>
    <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteUser()">Delete User</a>
    <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
    <input id="ss" class="easyui-searchbox" style="width:150px" data-options="searcher:userSearch,prompt:'Search user'"></input>
    <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-clear" onclick="$('#user_dg').datagrid('clearSelections');">Clear Selections</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload"
       onclick="reloadForm();">Reload Form</a>
</div>
<!-- add_user_wd -->
<div id="add_user_wd" class="easyui-window" title="Add User Window" data-options="modal:true,closed:true,iconCls:'icon-add',collapsible:false,minimizable:false,maximizable:false" style="width:530px;height:380px;padding:5px;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center',border:false" style="padding:10px;">
            <form id="add_user_form" method="post">
                <div>
                    <div class="input-group-left">
                        <input name="loginName" class="easyui-textbox" prompt="Login name" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['loginName','ajaxCheckLoginName'],delay:750,width:220," label="Login Name:" labelPosition="top">
                        <div>
                            <input name="password" id="au_password" class="easyui-passwordbox" prompt="Password" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['password'],delay:500,width:220,iconWidth:28," label="Password:" labelPosition="top">
                            <input prompt="Confirm your password" class="easyui-passwordbox" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['confirmPass[\'#au_password\']'],delay:500,width:220,iconWidth:28," label="Comfirm Password:" labelPosition="top">
                        </div>
                        <div>
                            <input name="userName" class="easyui-textbox" prompt="Nick name" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['password'],delay:750,width:220," label="User Name:" labelPosition="top">
                        </div>
                        <br>
                        <div>
                            <label for="au_sex" class="label-left">Sex: </label>
                            <span style="float:right;">
                                <input name="sex" id="au_sex_value" value="true" style="display: none;">
                                <input id="au_sex" class="easyui-switchbutton" data-options="onText:'♀',offText:'♂',onChange:onChangeAUSexSwcBtn," >
                            </span>
                        </div>
                    </div>
                    <div class="input-group-right">
                        <div>
                            <input name="phone" class="easyui-textbox" prompt="eg: 13512345678" validateOnCreate="false" validateOnBlur="true" data-options="validType:['phone'],delay:750,width:220," label="Phone:" labelPosition="top">
                        </div>
                        <div>
                            <input name="email" class="easyui-textbox" prompt="eg: a@b.c" validateOnCreate="false" validateOnBlur="true" data-options="validType:['email','length[5,50]'],delay:750,width:220,height:60,multiline:true," label="Email:" labelPosition="top">
                        </div>
                        <div>
                            <input name="address" class="easyui-textbox" prompt="Under 255 character." validateOnCreate="false" validateOnBlur="true" data-options="validType:['length[0,255]'],width:220,height:140,multiline:true," label="Address:" labelPosition="top">
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <div data-options="region:'south',border:false" style="text-align:right;padding:5px;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" href="javascript:void(0)" onclick="addUserFormSubmit()">Add User</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="$('#add_user_wd').window('close')">Cancel</a>
        </div>
    </div>
</div>
<!-- edit_user_wd -->
<div id="edit_user_wd" class="easyui-window" title="Edit User Window" collapsible="false" minimizable="false" maximizable="false" data-options="modal:true,closed:true,iconCls:'icon-edit'" style="width:760px;height:430px;padding:5px;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center',border:false" style="padding:10px;">
            <form id="edit_user_form" method="post">
                <div>
                    <div class="input-group-left">
                        <label for="eu_id">User ID: </label>
                        <input name="id" id="eu_id" class="easyui-textbox" style="text-align: right;width: 120px" editable="false">
                        <div>
                            <input id="s_login_name" class="easyui-textbox" label="Source Login Name:" labelPosition="top" disabled="true" data-options="width:220,">
                            <input name="loginName" id="eu_login_name" class="easyui-textbox" prompt="New login name" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['loginName','ajaxCheckLoginName[\'#s_login_name\']'],delay:750,width:220," label="New Login Name:" labelPosition="top">
                        </div>
                        <div>
                            <input id="s_password" class="easyui-passwordbox" data-options="width:220,iconWidth:28,editable:false,revealed:false," label="Source Password:" labelPosition="top">
                        </div>
                        <div>
                            <label for="eu_edit_new_password">Edit New Password?: </label>
                            <input id="eu_edit_new_password" class="easyui-switchbutton" data-options="onText:'Yes',offText:'No',onChange:onChangeEUEditPassSwcBtn," >
                        </div>
                        <div>
                            <input name="password" id="eu_password" class="easyui-passwordbox" prompt="New password" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['password'],delay:500,width:220,iconWidth:28,revealed:false," label="New Password:" labelPosition="top" disabled="true">
                            <input prompt="Confirm your new password" id="eu_confirm_password" class="easyui-passwordbox" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['confirmPass[\'#eu_password\']'],delay:750,width:220,iconWidth:28,revealed:false," label="Comfirm New Password:" labelPosition="top" disabled="true">
                        </div>
                    </div>
                    <div class="input-group-center">
                        <input id="s_user_name" class="easyui-textbox"  data-options="width:220," label="Source User Name:" labelPosition="top" disabled="true">
                        <input name="userName" class="easyui-textbox" prompt="New nick name" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['password'],delay:500,width:220," label="New User Name:" labelPosition="top">
                        <div>
                            <br>
                            <label for="eu_sex" class="label-left">Sex: </label>
                            <span style="float:right;">
                                <input name="sex" id="eu_sex_value" value="true" style="display: none;">
                                <input id="eu_sex" class="easyui-switchbutton" data-options="onText:'♀',offText:'♂',onChange:onChangeEUSexSwcBtn,">
                            </span>
                        </div>
                        <br>
                        <div>
                            <input id="s_phone" class="easyui-textbox" data-options="width:220," label="Source Phone:" labelPosition="top" disabled="true">
                            <input name="phone" class="easyui-textbox" prompt="eg: 13512345678" validateOnCreate="false" validateOnBlur="true" data-options="validType:['phone'],delay:750,width:220," label="New Phone:" labelPosition="top">
                        </div>
                        <div>
                            <input id="s_email" disabled="true" class="easyui-textbox" data-options="width:220,height:60,multiline:true," label="Source Email:" labelPosition="top">
                        </div>
                    </div>
                    <div class="input-group-right" >
                        <input name="email" class="easyui-textbox" prompt="eg: a@b.c" validateOnCreate="false" validateOnBlur="true" data-options="validType:['email','length[5,50]'],delay:750,width:220,height:60,multiline:true," label="New Email:" labelPosition="top">
                        <div>
                            <input id="s_address" class="easyui-textbox" data-options="width:220,height:125,multiline:true," label="Source Address:" labelPosition="top" disabled="true">
                            <input name="address" class="easyui-textbox" prompt="Under 255 character." validateOnCreate="false" validateOnBlur="true" data-options="validType:['length[0,255]'],width:220,height:125,multiline:true," label="New Address:" labelPosition="top">
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <div data-options="region:'south',border:false" style="text-align:right;padding:5px;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0)" onclick="editUserFormSubmit()">Update User</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-reload'" href="javascript:void(0)" onclick="editUserReloadNew()">Reload New*</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-clear'" href="javascript:void(0)" onclick="editUserClearNew()">Clear New*</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="$('#edit_user_wd').window('close')">Cancel</a>
        </div>
    </div>
</div>
</body>
</html>
