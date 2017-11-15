<%--
  Created by IntelliJ IDEA.
  User: AngusYu
  Date: 2017/10/30
  Time: 17:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Category Management</title>
    <%@include file="../public/head.jspf" %>
    <script type="text/javascript">
        // datagrid
        // function cellStyler(value,row,index){
        //  if (value < 30){
        //      return 'background-color:#ffee00;color:red;';
        //  }
        // };

        function dbClickToEdit(index, row) {
            loadECFormFromRow(row);
            $("#edit_category_wd").window('open');
        }

        // datagrid toolbar
        function addCategory() {
            $('#add_category_form').form('reset');
            $('#add_category_form').form('resetValidation');
            $('#add_category_wd').window('open');
        };

        function editCategory() {
            var rows = $('#category_dg').datagrid('getSelections');
            var errMsg = '';
            if (rows.length == 1) {
                var row = $("#category_dg").datagrid('getSelected');
                loadECFormFromRow(row);
                $("#edit_category_wd").window("open");
            } else {
                if (rows.length == 0) {
                    errMsg = 'Please select one row to proceed!';
                } else {
                    errMsg = 'Please select ONLY one row to proceed!';
                }
                $.messager.show({
                    title: 'Operation Error',
                    msg: errMsg,
                    timeout: 2500,
                    showType: 'slide',
                    height: 120,
                });
            }
        };

        function deleteCategory() {
            var rows = $('#category_dg').datagrid('getSelections');
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
                $.messager.confirm('Delete Prompt Dialog', confirmMsg, function (r) {
                    if (r) {
                        var idsData = "";
                        for (var i = 0; i < rows.length; i++) {
                            idsData += rows[i].id + ",";
                        }
                        idsData = idsData.substr(0, idsData.lastIndexOf(","));
                        $.post("backend/management/merchandise/category/delete", {ids: idsData}, function (result) {
                            var status = parseInt(result);
                            if (status > 0) {
                                var deleteMsg = "";
                                if (status == 1) {
                                    deleteMsg = "1 category has deleted!";
                                } else {
                                    deleteMsg = status + " categories have deleted!";
                                }
                                $.messager.show({
                                    title: 'Delete Category',
                                    msg: deleteMsg,
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                                $("#category_dg").datagrid("reload");
                            } else if (status == 0) {
                                $.messager.show({
                                    title: 'Delete Category',
                                    msg: 'Delete failed!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                            } else if (status == -1) {
                                $.messager.show({
                                    title: 'Delete Category',
                                    msg: 'Wrong parameter!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                            } else {
                                alert(result);
                            }
                            $("#category_dg").datagrid("uncheckAll");
                        });
                    }
                });
            }
        };

        function categorySearch(value) {
            $("#category_dg").datagrid('load', {
                fuzzyParam: value,
            });
        };
        function reloadForm() {
            var t=$('#ss').searchbox('getValue');
            if(t==""){
                $('#category_dg').datagrid('load',{
                    fuzzyParam:"",
                });
            }else {
                $('#category_dg').datagrid('load');
            }
        };

        // add_category_wd
        function onChangeACIHSwcBtn(checked) {
            if (checked) {
                $("#ac_hot_value").val("true");

            } else {
                $("#ac_hot_value").val("false");
            }
            //alert($("#ac_hot").val());
        };

        function addCategoryFormSubmit() {
            if ($("#add_category_form").form("validate")) {
                $("#add_category_form").form("submit", {
                    url: 'backend/management/merchandise/category/add',
                    success: function (result) {
                        var status = parseInt(result);
                        if (status == 1) {
                            $.messager.show({
                                title: 'Add Category',
                                msg: 'Add success!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                            $("#add_category_wd").window("close");
                        } else if (status == 0) {
                            $.messager.show({
                                title: 'Add Category',
                                msg: 'Add failed!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else if (status == -1) {
                            $.messager.show({
                                title: 'Add Category',
                                msg: 'Wrong parameter!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else {
                            alert(result);
                        }
                        $("#category_dg").datagrid("reload");
                    }
                });
            }
        };

        // edit_category_wd
        function onChangeECIHSwcBtn(checked) {
            if (checked) {
                $("#ec_hot_value").val("true");
            } else {
                $("#ec_hot_value").val("false");
            }
        };

        function editCategoryFormSubmit() {
            if ($("#edit_category_form").form("validate")) {
                $("#edit_category_form").form("submit", {
                    url: 'backend/management/merchandise/category/update',
                    success: function (result) {
                        var status = parseInt(result);
                        if (status == 1) {
                            $.messager.show({
                                title: 'Edit Category',
                                msg: 'Update success!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                            $("#edit_category_wd").window("close");
                        } else if (status == 0) {
                            $.messager.show({
                                title: 'Edit Category',
                                msg: 'Update failed!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else if (status == -1) {
                            $.messager.show({
                                title: 'Edit Category',
                                msg: 'Wrong parameter!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else {
                            alert(result);
                        }
                        $("#category_dg").datagrid("reload");
                    }
                });
            }
        };

        function editCategoryReloadNew() {
            var categoryId = $("#ec_id").textbox('getValue');
            var rowIndex = $("#category_dg").datagrid('getRowIndex', categoryId);
            var row = $("#category_dg").datagrid('getData').rows[rowIndex];
            loadECFormFromRow(row);
        };

        function loadECFormFromRow(row) {
            $("#s_name").textbox('setValue', row.name);
            $("#edit_category_form").form('load', {
                id: row.id,
                name: row.name,
            });
            if (row.hot) {
                $("#ec_hot").switchbutton('check');
            } else {
                $("#ec_hot").switchbutton('uncheck');
            }
        };

        // global
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

        function formatBoolToCheckbox(val, row) {
            if (val) {
                return '<input type="checkbox" checked="checked" disabled="true">';
            } else {
                return '<input type="checkbox" disabled="true">';
            }
        };
        $.extend($.fn.validatebox.defaults.rules, {
            ajaxCheckCategoryName: {
                validator: function (value, param) {
                    var sendData = {};
                    sendData['name'] = value;
                    if (param) {
                        var t = $(param[0]).val();
                        if (t && t == value) {
                            return true;
                        }
                    }
                    var response = $.ajax({
                        url: 'backend/management/merchandise/category/check',
                        dataType: "json",
                        data: sendData,
                        async: false,
                        cache: false,
                        type: "POST"
                    }).responseText;
                    return response == 'true';
                },
                message: "Category name is already exists!"
            },
        });
    </script>
</head>
<body>
<!-- datagrid -->
<table id="category_dg" class="easyui-datagrid" title="Category Management" style="height: 550px;" rownumbers="true"
       fit="true" singleSelect="false" fitColumns="true" iconCls="icon-save" pagination="true" pageSize="15" pageList="[10,15,20,25]" idField="id" striped="true"
       url="backend/management/merchandise/category/list" toolbar="#category_dg_tb" data-options="onDblClickRow:dbClickToEdit">
    <thead frozen="true">
    <tr>
        <th field="ck" checkbox="true"></th>
        <th field="id" width="90" halign="center" align="right">Category ID</th>
        <th field="hot" width="90" align="center" data-options="formatter:formatBoolToCheckbox">Hot Sale</th>
    </tr>
    </thead>
    <thead>
    <tr>
        <th field="name" width="100" halign="center" align="right">Name</th>
        <th field="productAmount" width="100" halign="center" align="right">Product Amount</th>
    </tr>
    </thead>
</table>
<!-- toolbar -->
<div id="category_dg_tb">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" data-options="" onclick="addCategory()">Add
        Category</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="editCategory()">Edit
        Category</a>
    <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteCategory()">Delete
        Category</a>
    <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
    <input id="ss" class="easyui-searchbox" style="width:150px"
           data-options="searcher:categorySearch,prompt:'Search category'">
    <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-clear"
       onclick="$('#category_dg').datagrid('clearSelections');">Clear Selections</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload"
       onclick="reloadForm();">Reload Form</a>
</div>
<!-- add_category_wd -->
<div id="add_category_wd" class="easyui-window" title="Add Category Window"
     data-options="modal:true,closed:true,iconCls:'icon-add',collapsible:false,minimizable:false,maximizable:false"
     style="width:300px;height:200px;padding:5px;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center',border:false" style="padding:10px;">
            <form id="add_category_form" method="post">
                <div>
                    <div class="input-group-center">
                        <label for="ac_name" class="label-top" style="height: 0px;"> </label>
                        <input name="name" id="ac_name" class="easyui-textbox" prompt="Category name"
                               validateOnCreate="false" validateOnBlur="true"
                               data-options="required:true,validType:['length[1,20]','ajaxCheckCategoryName'],delay:750,width:220,"
                               label="Category Name:" labelPosition="top">
                        <br>
                        <div>
                            <label for="ac_hot" class="label-left">Hot Sale:</label>
                            <span style="float:right;">
                                <input name="hot" id="ac_hot_value" value="false" style="display: none;">
                                <input id="ac_hot" class="easyui-switchbutton"
                                       data-options="onText:'Yes',offText:'No',onChange:onChangeACIHSwcBtn,">
                            </span>
                        </div>
                        <br>
                    </div>
                </div>
            </form>
        </div>
        <div data-options="region:'south',border:false" style="text-align:right;padding:5px;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" href="javascript:void(0)"
               onclick="addCategoryFormSubmit()">Add Category</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
               onclick="$('#add_category_wd').window('close')">Cancel</a>
        </div>
    </div>
</div>
<!-- edit_category_wd -->
<div id="edit_category_wd" class="easyui-window" title="Edit Category Window" collapsible="false" minimizable="false"
     maximizable="false" data-options="modal:true,closed:true,iconCls:'icon-edit'"
     style="width:400px;height:300px;padding:5px;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center',border:false" style="padding:10px;">
            <form id="edit_category_form" method="post">
                <div>
                    <div class="input-group-center" style="margin-left: 75px;">
                        <label for="ec_id">Category ID: </label>
                        <input name="id" id="ec_id" class="easyui-textbox" style="text-align: right;width: 100px"
                               editable="false">
                        <div>
                            <input id="s_name" class="easyui-textbox" label="Source Category Name:" labelPosition="top"
                                   disabled="true" data-options="width:200,">
                            <input name="name" class="easyui-textbox" id="ec_name" prompt="New category name"
                                   validateOnCreate="false" validateOnBlur="true"
                                   data-options="required:true,validType:['length[1,20]','ajaxCheckCategoryName[\'#s_name\']'],delay:750,width:200,"
                                   label="New Category Name:" labelPosition="top">
                        </div>
                        <br>
                        <div>
                            <label for="ec_hot" class="label-left">Hot Sale:</label>
                            <span style="float:right;">
                                <input name="hot" id="ec_hot_value" value="false" style="display: none;">
                                <input id="ec_hot" class="easyui-switchbutton" data-options="onText:'Yes',offText:'No',onChange:onChangeECIHSwcBtn,">
                            </span>
                        </div>
                        <br>
                    </div>
                </div>
            </form>
        </div>
        <div data-options="region:'south',border:false" style="text-align:right;padding:5px;">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0)"
               onclick="editCategoryFormSubmit()">Update Category</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-reload'" href="javascript:void(0)"
               onclick="editCategoryReloadNew()">Reload New*</a>
            <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)"
               onclick="$('#edit_category_wd').window('close')">Cancel</a>
        </div>
    </div>
</div>
</body>
</html>
