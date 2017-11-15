<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<%@include file="../public/head.jspf" %>
    <script type="text/javascript">
            $(document).keyup(function(event){
                if(event.keyCode ==13){
                    verifyLogin();
                }
            });
            function verifyLogin() {
                if ($("#backend_login_form").form("validate")) {
                    $("#backend_login_form").form("submit", {
                        url: 'backend/login/verify',
                        success: function (result) {
                            $("#login_error_message").removeAttr("hidden");
                            var status = parseInt(result);
                            if (status==1) {
                                $("#login_error_message").css("color","green");
                                $("#login_error_message").text("Login Success");
                                $(location).prop('href', 'backend/index');
                            }else if (status==0) {
                                $("#login_error_message").text("Wrong Password!");
                            }else if (status==-1){
                                $("#login_error_message").text("Login Name Not Exist!");
                            }else {
                                alert(result);
                            }
                        }
                    });
                }
            };
        //	global
            $.extend($.fn.validatebox.defaults.rules, {
                loginName:{
                    validator:function (value) {
                        return /^[a-zA-Z]\w{4,19}$/i.test(value);
                    },
                    message:'Invalid login name! (RegEx:^[a-zA-Z]\\w{4,19}$.)'
                },
                password:{
                    validator:function (value) {
                        return /^\w{5,20}$/i.test(value);
                    },
                    message:'Invalid password! (RegEx:^\\w{5,20}$.)'
                },
            });
    </script>
    <style type="text/css">
        #backend_login_form div{
            text-align: center;
            margin-top:20px;
        }
        #backend_login_form div input{
            width:280px;padding:10px;
        }
    </style>
</head>
<body>
<div id="w" class="easyui-window" title="Login to Mall CMS" data-options="modal:true,closed:false,iconCls:'icon-lock',collapsible:false,minimizable:false,maximizable:false,closable:false" style="width:400px;height:320px;padding:10px;">
    <div class="easyui-layout" data-options="fit:true">
        <div data-options="region:'center',border:false" style="padding:10px;">
            <form id="backend_login_form" method="post">
                <div>
                    <input name="loginName" class="easyui-textbox" prompt="Login Name" iconWidth="28" data-options="required:true,validType:['loginName'],delay:1250,iconCls:'icon-man',validateOnCreate:false,validateOnBlur:true">
                </div>
                <div>
                    <input name="password" class="easyui-passwordbox" prompt="Password" iconWidth="28" data-options="required:true,validType:['password'],delay:1250,validateOnCreate:false,validateOnBlur:true">
                </div>
                <div>
                </div>
                <div>
                    <span id="login_error_message" style="color:#CC2222;" hidden >Login Error Message.</span>
                </div>
            </form>
        </div>
        <div data-options="region:'south',border:false" style="text-align:right;padding:5px;">
            <div style="margin-bottom:20px;text-align: center;">
                <a href="javascript:void(0);" id="login_in_btn" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" style="width:180px;height:34px;padding: 10px;" onclick="verifyLogin();">Login In</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>