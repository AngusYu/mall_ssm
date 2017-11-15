<%--
  Created by IntelliJ IDEA.
  User: AngusYu
  Date: 2017/10/30
  Time: 17:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Product Management</title>
    <%@include file="../public/head.jspf" %>
    <script type="text/javascript">
        // datagrid
            function dbClickToEdit(index, row) {
                // var a=$("#product_dg").datagrid('getRowIndex',row.id);
                loadEPFormFromRow(row);
                $("#edit_product_wd").window("open");
            };
            // function cellStyler(value,row,index){
            //  if (value < 30){
            //      return 'background-color:#ffee00;color:red;';
            //  }
            // };
            // function rowStyler(index,row){
            //                 if (row.listprice < 30){
            //                     return 'background-color:#6293BB;color:#fff;font-weight:bold;';
            //                 }
            //             };
        // datagrid toolbar
            function addProduct() {
                $("#ap_img_preview").removeAttr('src');
                $("#add_product_form").form('reset');
                $("#add_product_form").form('resetValidation');
                $('#add_product_wd').window('open');
            };
            function editProduct() {
                var rows = $('#product_dg').datagrid('getSelections');
                var errMsg = '';
                if (rows.length == 1) {
                    var row = $('#product_dg').datagrid('getSelected');
                    loadEPFormFromRow(row);
                    $("#edit_product_wd").window("open");
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
            function deleteProduct() {
                var rows = $('#product_dg').datagrid('getSelections');
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
                        $.post("backend/management/merchandise/product/delete", {ids: idsData}, function (result) {
                            var status = parseInt(result);
                            if (status > 0) {
                                var deleteMsg = "";
                                if (status == 1) {
                                    deleteMsg = "1 product has deleted!";
                                } else {
                                    deleteMsg = status + " products have deleted!";
                                }
                                $.messager.show({
                                    title: 'Delete Product',
                                    msg: deleteMsg,
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                                $("#product_dg").datagrid("reload");
                            } else if (status == 0) {
                                $.messager.show({
                                    title: 'Delete Product',
                                    msg: 'Delete failed!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                            } else if (status == -1) {
                                $.messager.show({
                                    title: 'Delete Product',
                                    msg: 'Wrong parameter!',
                                    timeout: 2500,
                                    showType: 'slide',
                                    height: 120,
                                });
                            } else {
                                alert(result);
                            }
                            $("#product_dg").datagrid("uncheckAll");
                        });
                    }
                    });
                }
            };
            function productSearch(value) {
                $("#product_dg").datagrid('load', {
	                fuzzyParam: value,
	            });
            };
            function reloadForm() {
                var t=$('#ss').searchbox('getValue');
                if(t==""){
                    $('#product_dg').datagrid('load',{
                        fuzzyParam:"",
                    });
                }else {
                    $('#product_dg').datagrid('load');
                }
            };
        // add_product_wd
            function onChangeAPImgCallPreviewImage() {
                if ($("#ap_picture").filebox('getText')) {
                    previewImage($("input[name='picture']")[0], 'ap_img_preview', 'ap_img_preview_div');
                }else{
                    // alert("after null:"+$("#ap_picture").filebox('getText'));
                    $("#ap_img_preview").prop("src","");
                }
            };
            function onChangeAPManufDate() {
                $("#ap_expiration_date").datebox('validate');
                var apManufDateString=$("#ap_production_date").datebox('getValue');
                // Only when #ap_production_date has a valid date could GPSpinner be enabled
                if (apManufDateString&&($("#ap_production_date").datebox('isValid'))) {
                    $('#ap_expiration_date').datebox('calendar').calendar({
                        validator: function(date){
                            var availableExpDate = parse4y2M2DToDate(apManufDateString);
                            return date>=availableExpDate;
                        }
                    });
                    enableAPSpn();
                    var apExpDateString=$("#ap_expiration_date").datebox('getValue')
                    if (apExpDateString&&($("#ap_expiration_date").datebox('isValid'))) {
                        var ymd=getYMDByManufDateSAndExpDateS(apManufDateString,apExpDateString);
                        // alert(ymd[0]+","+ymd[1]+","+ymd[2]);
                        setAPSpn(ymd);
                    }
                }else{
                    setDateRestrictToNormal('#ap_expiration_date');
                    disableAPSpn();
                    resetAPSpn();
                }
            };
        // add_product_wd add_product_form numberspinner
            function enableAPSpn() {
                $("#ap_years_spn").numberspinner('enable');
                $("#ap_months_spn").numberspinner('enable');
                $("#ap_days_spn").numberspinner('enable');
            };
            function disableAPSpn() {
                $("#ap_years_spn").numberspinner('disable');
                $("#ap_months_spn").numberspinner('disable');
                $("#ap_days_spn").numberspinner('disable');
            };
            function resetAPSpn() {
                $("#ap_years_spn").numberspinner('reset');
                $("#ap_months_spn").numberspinner('reset');
                $("#ap_days_spn").numberspinner('reset');
            };
            function setAPSpn(ymd){
                $("#ap_years_spn").numberspinner('setValue',ymd[0]);
                $("#ap_months_spn").numberspinner('setValue',ymd[1]);
                $("#ap_days_spn").numberspinner('setValue',ymd[2]);
            };
            function getAPSpnYMD() {
                var years=$("#ap_years_spn").numberspinner('getValue');
                var months=$("#ap_months_spn").numberspinner('getValue');
                var days=$("#ap_days_spn").numberspinner('getValue');
                return [years,months,days];
            }
            function onChangeAPExpGrtPrd() {
                var productionDate=$("#ap_production_date").datebox('getValue');
                if (productionDate&&($("#ap_production_date").datebox('isValid'))) {
                    var expDateString=getExpDateSByManufDateSAndYMD(productionDate,getAPSpnYMD());
                    $("#ap_expiration_date").datebox('setValue',expDateString);
                }
            };
            function onChangeAPExpDate() {
                $("#ap_expiration_date").datebox("validate");
                $("#ap_production_date").datebox("validate");
                var expDateString=$("#ap_expiration_date").datebox('getValue');
                if (expDateString&&($("#ap_expiration_date").datebox("isValid"))) {
                    $('#ap_production_date').datebox('calendar').calendar({
                        validator: function(date){
                            var availableExpDate = parse4y2M2DToDate(expDateString);
                            return date<=availableExpDate;
                        }
                    });
                    var manufDateString=$("#ap_production_date").datebox('getValue');
                    if (manufDateString&&($("#ap_production_date").datebox('isValid'))){
                        var ymd=getYMDByManufDateSAndExpDateS(manufDateString,expDateString);
                        setAPSpn(ymd);
                    }
                }else{
                    setDateRestrictToNormal('#ap_production_date');
                }

            };
            function onChangeAPIRSwcBtn(checked) {
                if (checked) {
                	$("#ap_recommended_value").val("true");

                }else{
                	$("#ap_recommended_value").val("false");
                }
            };
            function onChangeAPIASwcBtn(checked) {
                if (checked) {
                	$("#ap_available_value").val("true");

                }else{
                	$("#ap_available_value").val("false");
                }
                // alert($("#ap_available").val());
                // tglSwcBtnByBool('#ap_recommended',checked);
            };
            function addProductFormSubmit() {
                if ($("#add_product_form").form("validate")) {
                    $("#add_product_form").form("submit", {
                        url: 'backend/management/merchandise/product/add',
                        success: function (result) {
                        var status = parseInt(result);
                        if (status == 1) {
                            $.messager.show({
                                title: 'Add Product',
                                msg: 'Add success!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                            $("#add_product_wd").window("close");
                        } else if (status == 0) {
                            $.messager.show({
                                title: 'Add Product',
                                msg: 'Add failed!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else if (status == -1) {
                            $.messager.show({
                                title: 'Add Product',
                                msg: 'Wrong parameter!',
                                timeout: 2500,
                                showType: 'slide',
                                height: 120,
                            });
                        } else {
                            alert(result);
                        }
                        $("#product_dg").datagrid("reload");
                    }
                    });
                }
            };
        // edit_product_wd
            function loadEPFormFromRow(row) {
                $("#s_name").textbox('setValue',row.name);
                $("#s_price").textbox('setValue',row.price);
                $("#s_stock").textbox('setValue',row.stock);
                if (row.productionDate) {
                    $("#s_production_date").textbox('setValue',row.productionDate);
                    $("#ep_production_date").textbox('setValue',row.productionDate);
                    if (row.expirationDate) {
                        $("#s_expiration_date").textbox('setValue',row.expirationDate);
                        $("#ep_expiration_date").textbox('setValue',row.expirationDate);
                        var ymd=getYMDByManufDateSAndExpDateS(row.productionDate,row.expirationDate);
                        // alert(ymd[0]+""+ymd[1]+""+ymd[2]);
                        $("#s_ep_years_spn").textbox('setValue',ymd[0]);
                        $("#s_ep_months_spn").textbox('setValue',ymd[1]);
                        $("#s_ep_days_spn").textbox('setValue',ymd[2]);
                        setEPSpn(ymd);
                        enableEPSpn();
                    }
                };
                $("#s_brief_intro").textbox('setValue',row.briefIntro);
                $("#s_detail_info").textbox('setValue',row.detailInfo);
                tglSwcBtnByBool('#ep_recommended',row.recommended);
                tglSwcBtnByBool('#ep_available',row.available);
                $("#edit_product_form").form('load', {
                    id: row.id,
                    name: row.name,
                    price: row.price,
                    stock: row.stock,
                    'category.id': row.category.id,
                    briefIntro: row.briefIntro,
                    detailInfo: row.detailInfo,
                });
                $("#ep_img_preview").prop('src',"resources/img/"+row.imageSrc);
            };
            function onChangeEPImgCallPreviewImage() {
                // alert(($("#ep_picture").filebox('getValue'))+","+());
                $("#ep_img_preview_tip").text("New Picture Preview:");
                if ($("#ep_picture").filebox('getText')) {
                    previewImage($("input[name='picture']")[1], 'ep_img_preview', 'ep_img_preview_div');
                }else{
                    // alert("after null:"+$("#ep_picture").filebox('getText'));
                    $("#ep_img_preview").prop("src","");
                }
            };
            function onChangeEPManufDate() {
                $("#ep_expiration_date").datebox('validate');
                var epManufDateString=$("#ep_production_date").datebox('getValue');
                // Only when #ep_production_date has a valid date could GPSpinner be enabled
                if (epManufDateString&&($("#ep_production_date").datebox('isValid'))) {
                    $('#ep_expiration_date').datebox('calendar').calendar({
                        validator: function(date){
                            var availableExpDate = parse4y2M2DToDate(epManufDateString);
                            return date>=availableExpDate;
                        }
                    });
                    enableEPSpn();
                    var epExpDateString=$("#ep_expiration_date").datebox('getValue')
                    if (epExpDateString&&($("#ep_expiration_date").datebox('isValid'))) {
                        var ymd=getYMDByManufDateSAndExpDateS(epManufDateString,epExpDateString);
                        // alert(ymd[0]+","+ymd[1]+","+ymd[2]);
                        setEPSpn(ymd);
                    }
                }else{
                    setDateRestrictToNormal('#ep_expiration_date');
                    disableEPSpn();
                    resetEPSpn();
                }
            };
        // edit_product_wd add_product_form numberspinner
            function enableEPSpn() {
                $("#ep_years_spn").numberspinner('enable');
                $("#ep_months_spn").numberspinner('enable');
                $("#ep_days_spn").numberspinner('enable');
            };
            function disableEPSpn() {
                $("#ep_years_spn").numberspinner('disable');
                $("#ep_months_spn").numberspinner('disable');
                $("#ep_days_spn").numberspinner('disable');
            };
            function resetEPSpn() {
                $("#ep_years_spn").numberspinner('reset');
                $("#ep_months_spn").numberspinner('reset');
                $("#ep_days_spn").numberspinner('reset');
            };
            function setEPSpn(ymd){
                $("#ep_years_spn").numberspinner('setValue',ymd[0]);
                $("#ep_months_spn").numberspinner('setValue',ymd[1]);
                $("#ep_days_spn").numberspinner('setValue',ymd[2]);
            };
            function getEPSpnYMD() {
                var years=$("#ep_years_spn").numberspinner('getValue');
                var months=$("#ep_months_spn").numberspinner('getValue');
                var days=$("#ep_days_spn").numberspinner('getValue');
                return [years,months,days];
            }
            function onChangeEPExpGrtPrd() {
                var productionDate=$("#ep_production_date").datebox('getValue');
                if (productionDate&&($("#ep_production_date").datebox('isValid'))) {
                    var expDateString=getExpDateSByManufDateSAndYMD(productionDate,getEPSpnYMD());
                    $("#ep_expiration_date").datebox('setValue',expDateString);
                }
            };
            function onChangeEPExpDate() {
                $("#ep_expiration_date").datebox("validate");
                $("#ep_production_date").datebox("validate");
                var expDateString=$("#ep_expiration_date").datebox('getValue');
                if (expDateString&&($("#ep_expiration_date").datebox("isValid"))) {
                    $('#ep_production_date').datebox('calendar').calendar({
                        validator: function(date){
                            var availableExpDate = parse4y2M2DToDate(expDateString);
                            return date<=availableExpDate;
                        }
                    });
                    var manufDateString=$("#ep_production_date").datebox('getValue');
                    if (manufDateString&&($("#ep_production_date").datebox('isValid'))){
                        var ymd=getYMDByManufDateSAndExpDateS(manufDateString,expDateString);
                        setEPSpn(ymd);
                    }
                }else{
                    setDateRestrictToNormal('#ep_production_date');
                }
            };
            function onChangeEPIRSwcBtn(checked) {
                if (checked) {
                	$("#ep_recommended_value").val("true");

                }else{
                	$("#ep_recommended_value").val("false");
                }
            };
            function onChangeEPIASwcBtn(checked) {
                if (checked) {
                	$("#ep_available_value").val("true");

                }else{
                	$("#ep_available_value").val("false");
                }
                // alert($("#ep_available").val());
                // tglSwcBtnByBool('#ep_recommended',checked);
            };
            function editProductReloadNew() {
                var productId=$("#ep_id").textbox("getValue");
                var rowIndex=$("#product_dg").datagrid('getRowIndex',productId);
                var row=$("#product_dg").datagrid('getData').rows[rowIndex];
                loadEPFormFromRow(row);
                // $("#edit_product_form").form('reload');
            };
            function editProductClearNew() {
                setDateRestrictToNormal('#ep_expiration_date');
                $("#ep_expiration_date").textbox('setValue','');
                setDateRestrictToNormal('#ep_production_date');
                $("#ep_production_date").textbox('setValue','');
                resetEPSpn();
                disableEPSpn();
                tglSwcBtnByBool('#ep_recommended',false);
                tglSwcBtnByBool('#ep_available',false);
                $("#edit_product_form").form('load', {
                    name: '',
                    price: '',
                    stock: '',
                    'category.id': '',
                    briefIntro: '',
                    detailInfo: '',
                });
                $("#ep_picture").filebox('reset');
                $("#ep_img_preview").removeAttr("src");
                $("#edit_product_form").form('resetValidation');
            };
            function editProductFormSubmit() {
                if ($("#edit_product_form").form("validate")){
                    $("#edit_product_form").form("submit", {
                        url: 'backend/management/merchandise/product/update',
                        success: function (result) {
	                        var status = parseInt(result);
	                        if (status == 1) {
	                            $.messager.show({
	                                title: 'Edit Product',
	                                msg: 'Update success!',
	                                timeout: 2500,
	                                showType: 'slide',
	                                height: 120,
	                            });
	                            $("#edit_product_wd").window("close");
	                        } else if (status == 0) {
	                            $.messager.show({
	                                title: 'Edit Product',
	                                msg: 'Update failed!',
	                                timeout: 2500,
	                                showType: 'slide',
	                                height: 120,
	                            });
	                        } else if (status == -1) {
	                            $.messager.show({
	                                title: 'Edit Product',
	                                msg: 'Wrong parameter!',
	                                timeout: 2500,
	                                showType: 'slide',
	                                height: 120,
	                            });
	                        } else {
	                            alert(result);
	                        }
	                        $("#product_dg").datagrid("reload");
	                    }
                    });
                }
            };
            function tglSwcBtnByBool(targetId,bool) {
                if (bool) {$(targetId).switchbutton('check');}else{$(targetId).switchbutton('uncheck');}
            };
        // global
            $.extend($.fn.validatebox.defaults.rules, {
            	ajaxCheckProductName: {
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
	                        url: 'backend/management/merchandise/product/check',
	                        dataType: "json",
	                        data: sendData,
	                        async: false,
	                        cache: false,
	                        type: "POST"
	                    }).responseText;
	                    return response == 'true';
	                },
	                message: "Product name is already exists!"
	            },
                greaterThanDate:{
                    validator:function(value,param){
                        var d1=$(param[0]).datebox('getValue');
                        if (d1&&($(param[0]).datebox('isValid'))) {
                            var sd=parse4y2M2DToDate(d1);
                            var ed=parse4y2M2DToDate(value);
                            return ed>=sd;
                        }else{
                            return true;
                        }

                    },
                    message:'End Date need to be greater than Start Date.'
                },
                date: {
                    validator: function (value) {
                        //yyyy-MM-dd or yyyy-M-d
                        return /^(?:(?!0000)[0-9]{4}([-]?)(?:(?:0?[1-9]|1[0-2])\1(?:0?[1-9]|1[0-9]|2[0-8])|(?:0?[13-9]|1[0-2])\1(?:29|30)|(?:0?[13578]|1[02])\1(?:31))|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)([-]?)0?2\2(?:29))$/i.test(value);
                    },
                    message: 'Wrong date format, correct format[yyyy-MM-dd,yyyy-M-d].',
                },
            });
            var buttons = $.extend([], $.fn.datebox.defaults.buttons);
            buttons.splice(1, 0, {
                text: 'Clear',
                handler: function(target){
                    $("#"+ target.id+"" ).datebox('setValue', "");
                    $("#" + target.id + "").datebox('hidePanel', "");
                    if (target.id=='ap_expiration_date') {
                        resetAPSpn();
                    }else if (target.id=='ep_expiration_date') {
                        resetEPSpn();
                    }
                }
            });
            function formatDateTo4y2M2D(date) {
                var y = date.getFullYear();
                var m = date.getMonth() + 1;
                var d = date.getDate();
                return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
            };
            function parse4y2M2DToDate(s) {
                if (!s) return new Date();
                var ss = (s.split('-'));
                var y = parseInt(ss[0], 10);
                var m = parseInt(ss[1], 10);
                var d = parseInt(ss[2], 10);
                if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
                    return new Date(y, m - 1, d);
                } else {
                    return new Date();
                }
            };
            function formatBoolToCheckBox(val, row) {
                if (val) { return '<input type="checkbox" checked="checked" disabled="true">'; } else { return '<input type="checkbox" disabled="true">'; }
            };
            function formatLongText(value,row,index) {
                return '<span title="'+value+'">'+value+'</span>';
            };
            function formatImgView(value,row,index) {
                return '<img width="100" height="100" src="/resources/img/'+value+'">';
            };
            function getExpDateSByManufDateSAndYMD(date,ymd) {
                var years=parseInt(ymd[0])
                var months=parseInt(ymd[1]);
                var days=parseInt(ymd[2]);
                var result=new Date(date);
                if(days>0){result.setDate(result.getDate()+days);}
                if (months>0) {result.setMonth(result.getMonth()+months);}
                if (years>0) {result.setFullYear(result.getFullYear()+years);}
                // alert(result);
                var y = result.getFullYear();
                var m = result.getMonth() + 1;
                var d = result.getDate();
                return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
            };
            function getYMDByManufDateSAndExpDateS(manufDateString,expDateString) {
                var sDSArr = manufDateString.split("-");
                var eDSArr = expDateString.split("-");
                var sDate = new Date(sDSArr[0], sDSArr[1], sDSArr[2]);
                var eDate = new Date(eDSArr[0], eDSArr[1], eDSArr[2]);
                if (sDate < eDate) {
                    // sDate's year is always smaller than eDate's year.
                    var years = eDate.getFullYear() - sDate.getFullYear();
                    // sDate's month can greater than eDate's month.
                    var months = eDate.getMonth() - sDate.getMonth();
                    // when sDate's month greater than eDate's month, turn months to positive integer.
                    if (months < 0) { months += 12;
                        years--; }
                    var days;
                    // sDate's getDate() can greater than eDate's getDate().
                    if (sDate.getDate() <= eDate.getDate()) {
                        days = eDate.getDate() - sDate.getDate();

                    } else {// when sDate's getDate() greater than eDate's getDate(), turn days to positive integer.
                        // total days of sDate's Month.
                        var daysInMonth = parseInt((new Date(sDSArr[0], sDSArr[1], 0)).getDate());
                        days = eDate.getDate() - sDate.getDate() + daysInMonth;
                        months--;
                    }
                    // alert(years + "," + months + "," + days);
                    return [years,months,days];
                }
            };
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
            function previewImage(fileObj, imgPreviewId, divPreviewId) {
                var allowExtention = ".gif,.jpg,.jpeg,.bmp,.png"; //Allow file extention:document.getElementById("hfAllowPicSuffix").value;
                var extention = fileObj.value.substring(fileObj.value.lastIndexOf(".") + 1).toLowerCase();
                var browserVersion = window.navigator.userAgent.toUpperCase();
                if (allowExtention.indexOf(extention) > -1) {
                    if (fileObj.files) { //HTML5 Preview Support, comopatible with Chrome, Firefox 7+ etc.
                        if (window.FileReader) {
                            var reader = new FileReader();
                            reader.onload = function(e) {
                                document.getElementById(imgPreviewId).setAttribute("src", e.target.result);
                            }
                            reader.readAsDataURL(fileObj.files[0]);
                        } else if (browserVersion.indexOf("SAFARI") > -1) {
                            alert("Safari under v6.0 is not supported!");
                        }
                    } else if (browserVersion.indexOf("MSIE") > -1) {
                        if (browserVersion.indexOf("MSIE 6") > -1) { //IE6
                            document.getElementById(imgPreviewId).setAttribute("src", fileObj.value);
                        } else { //For IE[7-9]
                            fileObj.select();
                            if (browserVersion.indexOf("MSIE 9") > -1)
                                fileObj.blur(); //Access will be denied in IE9 if not adding document.selection.createRange().text
                            var newPreview = document.getElementById(divPreviewId + "New");
                            if (newPreview == null) {
                                newPreview = document.createElement("div");
                                newPreview.setAttribute("id", divPreviewId + "New");
                                newPreview.style.width = document.getElementById(imgPreviewId).width + "px";
                                newPreview.style.height = document.getElementById(imgPreviewId).height + "px";
                                newPreview.style.border = "solid 1px #d2e2e2";
                            }
                            newPreview.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='" + document.selection.createRange().text + "')";
                            var tempDivPreview = document.getElementById(divPreviewId);
                            tempDivPreview.parentNode.insertBefore(newPreview, tempDivPreview);
                            tempDivPreview.style.display = "none";
                        }
                    } else if (browserVersion.indexOf("FIREFOX") > -1) { //Firefox
                        var firefoxVersion = parseFloat(browserVersion.toLowerCase().match(/firefox\/([\d.]+)/)[1]);
                        if (firefoxVersion < 7) { //Under Firefox v7
                            document.getElementById(imgPreviewId).setAttribute("src", fileObj.files[0].getAsDataURL());
                        } else { //Firefox v7+
                            document.getElementById(imgPreviewId).setAttribute("src", window.URL.createObjectURL(fileObj.files[0]));
                        }
                    } else {
                        document.getElementById(imgPreviewId).setAttribute("src", fileObj.value);
                    }
                } else {
                    alert("Only supporting the following image extention: " + allowExtention + "!");
                    fileObj.value = "";
                    if (browserVersion.indexOf("MSIE") > -1) {
                        fileObj.select();
                        document.selection.clear();
                    }
                    fileObj.outerHTML = fileObj.outerHTML;
                }
            };
            function setDateRestrictToNormal(targetId) {
                $(targetId).datebox('calendar').calendar({
                    validator: function(date){
                        var availableExpDate = parse4y2M2DToDate('1970-01-01');
                        return date>=availableExpDate;
                    }
                });
            }
    </script>
</head>
<body>
    <!-- datagrid -->
    <table id="product_dg" class="easyui-datagrid" title="Product Management" style="height: 550px;" rownumbers="true" singleSelect="false" fit="true" fitColumns="false" iconCls="icon-save" pagination="true" pageNumber="1" pageSize="15" nowrap="true" pageList="[10,15,20,25]" idField="id" striped="true" url="backend/management/merchandise/product/list" toolbar="#product_dg_tb" data-options="onDblClickRow:dbClickToEdit">
        <thead frozen="true">
        <tr>
            <th field="ck" checkbox="true"></th>
            <th field="id" width="100" halign="center" align="right">Product ID</th>
            <th field="available" width="70" align="center" data-options="formatter:formatBoolToCheckBox">Available</th>
            <th field="recommended" width="100" align="center" data-options="formatter:formatBoolToCheckBox">Recommended</th>
            <th field="imageSrc" width="100"  halign="center" align="right" data-options="formatter:formatImgView,">Picture</th>
            <th field="name" width="120" halign="center" align="left" data-options="">Name</th>
            <th field="price" width="80" halign="center" align="right">Price</th>
            <th field="stock" width="80" halign="center" align="right">Stock</th>
        </tr>
        </thead>
        <thead>
        <tr>
            <th field="category.name" width="100" halign="center" align="right" data-options="formatter:function(value,row,index){return row.category.name;},">Category</th>
            <th field="productionDate" width="120" align="center">Production Date</th>
            <th field="expirationDate" width="120" align="center">Expiration Date</th>
            <th field="briefIntro" width="250" height="100"  halign="center" align="left" data-options="formatter:formatLongText">Brief Introduction</th>
            <th field="detailInfo" width="350" height="100" halign="center" align="left" data-options="formatter:formatLongText">Detail Information</th>
        </tr>
        </thead>
    </table>
    <!-- toolbar -->
    <div id="product_dg_tb">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" data-options="" onclick="addProduct()">Add Product</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="editProduct()">Edit Product</a>
        <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteProduct()">Delete Product</a>
        <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
        <input id="ss" class="easyui-searchbox" style="width:150px" prompt="Search product" data-options="searcher:productSearch,"></input>
        <span class="datagrid-btn-separator" style="vertical-align: middle;display: inline-block;float: none;"></span>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-clear" onclick="$('#product_dg').datagrid('clearSelections');">Clear Selections</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-reload"
       onclick="reloadForm();">Reload Form</a>
    </div>
    <!-- add_product_wd -->
    <div id="add_product_wd" class="easyui-window" title="Add Product Window" data-options="iconCls:'icon-add',modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false" style="width:770px;height:480px;padding:5px;">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'center',border:false" style="padding:10px;">
                <form id="add_product_form" method="post" enctype="multipart/form-data">
                    <div>
                        <div class="input-group-left">
                            <input name="name" id="ap_name" class="easyui-textbox" prompt="Product name" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['length[1,100]','ajaxCheckProductName'],delay:750,width:220,height:80,multiline:true" label="Name:" labelPosition="top">
                            <div>
                                <input name="price" class="easyui-numberbox" prompt="Product price" validateOnCreate="false" validateOnBlur="true" label="Price:" labelPosition="top" data-options="max:99999999.99,precision:2,groupSeparator:',',prefix:'¥',required:true,width:220,">
                            </div>
                            <div>
                                <input name="stock" class="easyui-numberbox" prompt="Product stock" validateOnCreate="false" validateOnBlur="true" label="Stock:" labelPosition="top" data-options="max:99999999,groupSeparator:',',required:true,width:220,">
                            </div>
                            <div>
                                <label for="ap_available">Available:</label>
                                <span style="float:right;">
                                	<input name="available" id="ap_available_value" value="false" style="display: none;">
                                    <input id="ap_available" class="easyui-switchbutton" data-options="onText:'Yes',offText:'No',onChange:onChangeAPIASwcBtn,">
                                </span>
                            </div>
                            <br>
                            <div>
                                <label for="ap_recommended" class="label-left">Recommended:</label>
                                <span style="float:right;">
                                	<input name="recommended" id="ap_recommended_value" value="false" style="display: none;">
                                    <input id="ap_recommended" class="easyui-switchbutton" data-options="onText:'Yes',offText:'No',onChange:onChangeAPIRSwcBtn,">
                                </span>
                            </div>
                            <div>
                                <label for="ap_category_id" class="label-top">Category Name: </label>
                                <input name="category.id" class="easyui-combobox" prompt="Category name" id="ap_category_id" validateOnCreate="false" validateOnBlur="true" data-options="
                                        url:'backend/management/merchandise/category/list/all',
                                        method:'get',
                                        valueField:'id',
                                        textField:'name',
                                        panelHeight:'auto',
                                        required:true,
                                        width:220,
                                        ">
                            </div>
                            <div>
                                <input name="briefIntro" class="easyui-textbox" prompt="Brief introduction of product" label="Brief Introduction:" labelPosition="top" data-options="width:220,height:80">
                            </div>

                        </div>
                        <div class="input-group-center">
                            <input name="productionDate" id="ap_production_date" class="easyui-datebox" prompt="eg:2017-10-01" label="Production Date:" labelPosition="top" data-options="formatter:formatDateTo4y2M2D,parser:parse4y2M2DToDate,onSelect:onChangeAPManufDate,validType:'date',buttons:buttons,width:220,">
                            <div>
                                <label for="ap_gp_spinner" class="label-top">Guarantee Period:</label>
                                <div id="ap_gp_spinner">
                                    <input class="easyui-numberspinner" value="0" id="ap_years_spn" data-options="spinAlign:'vertical',min:0,onChange:onChangeAPExpGrtPrd,disabled:true," style="max-width:40px;text-align:center"> Year
                                    <input class="easyui-numberspinner" value="0" id="ap_months_spn" data-options="spinAlign:'vertical',min:0,onChange:onChangeAPExpGrtPrd,disabled:true," style="max-width:40px;text-align:center"> Month
                                    <input class="easyui-numberspinner" value="0" id="ap_days_spn" data-options="spinAlign:'vertical',min:0,onChange:onChangeAPExpGrtPrd,disabled:true," style="max-width:40px;text-align:center"> Day
                                </div>
                            </div>
                            <div>
                                <label for="ap_expiration_date" class="label-top">Expiration Date:</label>
                                <input name="expirationDate" id="ap_expiration_date" class="easyui-datebox" prompt="eg:2018-10-01" data-options="formatter:formatDateTo4y2M2D,parser:parse4y2M2DToDate,onSelect:onChangeAPExpDate,validType:['date','greaterThanDate[\'#ap_production_date\']'],buttons:buttons,width:220,">
                            </div>
                            <div>
                                <input name="detailInfo" class="easyui-textbox" prompt="Detail information of product" label="Detail Information:" labelPosition="top" multiline="true" data-options="width:220,height:180,">
                            </div>

                        </div>
                        <div class="input-group-right">
                            <label for="ap_picture" class="label-top">Picture:</label>
                            <input name="picture" id="ap_picture" class="easyui-filebox" prompt="Select a product picture" accept="image/*" data-options="onChange:onChangeAPImgCallPreviewImage,width:220,">
                            <div>
                                <label for="ap_img_preview_div" class="label-top">Picture Preview:</label>
                                <div id="ap_img_preview_div">
                                    <img id="ap_img_preview" width="220px" height="220px">
                                </div>
                            </div>

                        </div>
                    </div>
                </form>
            </div>
            <div data-options="region:'south',border:false" style="text-align:right;padding:5px;">
                <a class="easyui-linkbutton" data-options="iconCls:'icon-add'" href="javascript:void(0)" onclick="addProductFormSubmit()">Add Product</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="$('#add_product_wd').window('close')">Cancel</a>
            </div>
        </div>
    </div>
    <!-- edit_product_wd -->
    <div id="edit_product_wd" class="easyui-window" title="Edit Product Window" data-options="iconCls:'icon-edit',modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false" style="width:770px;height:505px;padding:5px;">
        <div class="easyui-layout" data-options="fit:true">
            <div data-options="region:'center',border:false" style="padding:10px;">
                <form id="edit_product_form" method="post" enctype="multipart/form-data">
                    <div>
                        <div class="input-group-left" >
                            <label for="ep_id" class="label-left">Product ID:</label>
                            <input name="id" id="ep_id" class="easyui-textbox" style="text-align: center;width: 100px;" editable="false">
                            <div>
                                <input id="s_name" class="easyui-textbox" label="Source Name:" labelPosition="top" disabled="true" data-options="height:100,multiline:true,width:220,">
                                <input name="name" id="ep_type" class="easyui-textbox" prompt="New product name" validateOnCreate="false" validateOnBlur="true" data-options="required:true,validType:['length[1,100]','ajaxCheckProductName[\'#s_name\']'],delay:750,height:100,multiline:true,width:220," label="New Name:" labelPosition="top">
                            </div>
                            <div>
                                <input id="s_price" class="easyui-numberbox" label="Source Price:" labelPosition="top" data-options="precision:2,groupSeparator:',',prefix:'¥',width:220," disabled="true">
                                <input name="price" class="easyui-numberbox" prompt="New product price" validateOnCreate="false" validateOnBlur="true" label="New Price:" labelPosition="top" data-options="max:99999999.99,precision:2,groupSeparator:',',prefix:'¥',required:true,width:220,">
                            </div>
                            <div>
                                <input id="s_stock" class="easyui-numberbox" label="Source Stock:" labelPosition="top" data-options="max:99999999,groupSeparator:',',width:220," disabled="true">
                                <input name="stock" class="easyui-numberbox" prompt="Product stock" validateOnCreate="false" validateOnBlur="true" label="New Stock:" labelPosition="top" data-options="max:99999999,groupSeparator:',',required:true,width:220,">
                            </div>
                            <div>
                                <label for="ep_available">Available:</label>
                                <span style="float:right;">
                                	<input name="available" id="ep_available_value" value="false" style="display: none;">
                                    <input id="ep_available" class="easyui-switchbutton" data-options="onText:'Yes',offText:'No',onChange:onChangeEPIASwcBtn,">
                                </span>
                            </div>
                            <br>
                            <div>
                                <label for="ep_recommended" class="label-left">Recommended:</label>
                                <span style="float:right;">
                                	<input name="recommended" id="ep_recommended_value" value="false" style="display: none;">
                                    <input id="ep_recommended" class="easyui-switchbutton" data-options="onText:'Yes',offText:'No',onChange:onChangeEPIRSwcBtn,">
                                </span>
                            </div>
                            <div>
                                <label for="ep_category_id" class="label-top">Category Name: </label>
                                <input name="category.id" class="easyui-combobox" prompt="Category name" id="ep_category_id" validateOnCreate="false" validateOnBlur="true" data-options="url:'backend/management/merchandise/category/list/all',method:'get',valueField:'id',textField:'name',panelHeight:'auto',required:true,width:220,">
                            </div>

                        </div>
                        <div class="input-group-center">
                            <input id="s_production_date" class="easyui-datebox" label="Source Production Date:" labelPosition="top" data-options="formatter:formatDateTo4y2M2D,parser:parse4y2M2DToDate,width:220," disabled="true">
                            <input name="productionDate" id="ep_production_date" class="easyui-datebox" prompt="eg:2017-10-01" label="New Production Date:" labelPosition="top" data-options="formatter:formatDateTo4y2M2D,parser:parse4y2M2DToDate,onChange:onChangeEPManufDate,validType:'date',buttons:buttons,width:220,">
                            <div>
                                <label for="s_gp" class="label-top">Source Guarantee Period:</label>
                                <span id="s_gp" disabled="true">
                                    <input class="easyui-numberbox" value="0" id="s_ep_years_spn" data-options="" style="max-width:40px;text-align:center" disabled="true"> Year
                                    <input class="easyui-numberbox" value="0" id="s_ep_months_spn" data-options="" style="max-width:40px;text-align:center" disabled="true"> Month
                                    <input class="easyui-numberbox" value="0" id="s_ep_days_spn" data-options="" style="max-width:40px;text-align:center" disabled="true"> Day
                                </span>
                                <label for="ep_gp_spinner" class="label-top">New Guarantee Period:</label>
                                <span id="ep_gp_spinner">
                                    <input class="easyui-numberspinner" value="0" id="ep_years_spn" data-options="spinAlign:'vertical',min:0,onChange:onChangeEPExpGrtPrd,disabled:true" style="max-width:40px;text-align:center"> Year
                                    <input class="easyui-numberspinner" value="0" id="ep_months_spn" data-options="spinAlign:'vertical',min:0,onChange:onChangeEPExpGrtPrd,disabled:true" style="max-width:40px;text-align:center"> Month
                                    <input class="easyui-numberspinner" value="0" id="ep_days_spn" data-options="spinAlign:'vertical',min:0,onChange:onChangeEPExpGrtPrd,disabled:true" style="max-width:40px;text-align:center"> Day
                                </span>
                            </div>
                            <div>
                                <label for="s_expiration_date" class="label-top">Source Expiration Date:</label>
                                <input  id="s_expiration_date" class="easyui-datebox"   data-options="formatter:formatDateTo4y2M2D,parser:parse4y2M2DToDate,width:220," disabled="true">
                                <label for="ep_expiration_date" class="label-top">New Expiration Date:</label>
                                <input name="expirationDate" id="ep_expiration_date" class="easyui-datebox" prompt="eg:2018-10-01" data-options="formatter:formatDateTo4y2M2D,parser:parse4y2M2DToDate,onChange:onChangeEPExpDate,validType:['date','greaterThanDate[\'#ep_production_date\']'],buttons:buttons,width:220,">
                            </div>
                            <div>
                                <input id="s_brief_intro" class="easyui-textbox" label="Source Brief Introduction:" labelPosition="top" disabled="true"  data-options="width:220,height:100,multiline:true,">
                                <input name="briefIntro" class="easyui-textbox" label="New Brief Introduction:" labelPosition="top" data-options="width:220,height:100,multiline:true,">
                            </div>

                        </div>
                        <div class="input-group-right">
                            <input id="s_detail_info" class="easyui-textbox" label="Source Detail Information:" labelPosition="top" multiline="true" disabled="true" data-options="width:220,height:120,">
                            <input name="detailInfo" class="easyui-textbox" label="New Detail Information:" labelPosition="top" multiline="true" data-options="width:220,height:120,">
                            <div>
                                <label for="ep_picture" class="label-top">Product Picture:</label>
                                <input name="picture" id="ep_picture" class="easyui-filebox" prompt="Select a product picture" accept="image/*" data-options="onChange:onChangeEPImgCallPreviewImage,width:220,">
                                <label for="ep_img_preview_div" id="ep_img_preview_tip" class="label-top"><span style="color: #CC2222">Source</span> Picture Preview:</label>
                                <div id="ep_img_preview_div">
                                    <img id="ep_img_preview" width="220px" height="220px">
                                </div>
                            </div>

                        </div>
                    </div>
                </form>
            </div>
            <div data-options="region:'south',border:false" style="text-align:right;padding:5px;">
                <a class="easyui-linkbutton" data-options="iconCls:'icon-save'" href="javascript:void(0)" onclick="editProductFormSubmit()">Update Product</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-reload'" href="javascript:void(0)" onclick="editProductReloadNew()">Reload New*</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-clear'" href="javascript:void(0)" onclick="editProductClearNew()">Clear New*</a>
                <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" href="javascript:void(0)" onclick="$('#edit_product_wd').window('close')">Cancel</a>
            </div>
        </div>
    </div>
</body>
</html>
