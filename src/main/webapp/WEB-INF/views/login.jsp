<%@ page contentType="text/html;charset=UTF-8" language="java"
         isELIgnored="false" %>
<html lang="zh-CN">
<head>
    <title>Title</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        html, body {
            height: 100%;
        }

        .box {
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#6699FF', endColorstr='#6699FF'); /*  IE */
            background-image: linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -o-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -moz-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -webkit-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -ms-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);

            margin: 0 auto;
            position: relative;
            width: 100%;
            height: 100%;
        }

        .login-box {
            width: 100%;
            max-width: 500px;
            height: 400px;
            position: absolute;
            top: 50%;

            margin-top: -255px;
            /*设置负值，为要定位子盒子的一半高度*/

        }

        @media screen and (min-width: 500px) {
            .login-box {
                left: 50%;
                /*设置负值，为要定位子盒子的一半宽度*/
                margin-left: -250px;
            }
        }

        .form {
            width: 100%;
            max-width: 500px;
            height: 275px;
            margin: 25px auto 0px auto;
            padding-top: 25px;
        }

        .login-content {
            height: 400px;
            width: 100%;
            max-width: 500px;
            background-color: rgba(255, 250, 2550, .6);
            float: left;
        }

        .input-group {
            margin: 0px 0px 30px 0px !important;
        }

        .form-control,
        .input-group {
            height: 40px;
        }

        .form-group {
            margin-bottom: 0px !important;
        }

        .login-title {
            padding: 20px 10px;
            background-color: rgba(0, 0, 0, .6);
        }

        .login-title h1 {
            margin-top: 10px !important;
        }

        .login-title small {
            color: #fff;
        }

        .link p {
            line-height: 20px;
            margin-top: 30px;
        }

        .btn-sm {
            padding: 8px 24px !important;
            font-size: 16px !important;
        }

        .bj_error {
            color: red;
        }
    </style>
</head>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-2.2.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script type="text/javascript">

    $(function () {
        $(":input[name='account']").focus(function () {
            $(":input[name='account']").val("");
            $(":input[name='account']").css("color","gray");
        }).blur(function () {
            var account = $(this).val();
            account = $.trim(account);
            if (account == "") {
                $(":input[name='account']").val("请输入账号").css("color","red");
            }
        });
        $(":input[name='password']").focus(function () {
            $(":input[name='password']").val("");
            $(":input[name='password']").attr("type","password");
            $(":input[name='password']").css("color","gray");
        }).blur(function () {
            var password = $(this).val();
            password = $.trim(password);
            if (password == "") {
                $(":input[name='password']").attr("type","text");
                $(":input[name='password']").val("请输入密码");
            }
        });
        $(":input[name='code']").focus(function () {
            $(":input[name='code']").val("");
            $(":input[name='code']").css("color","gray");
        }).blur(function () {
            var code = $(this).val();
            code = $.trim(code);
            if (code == "") {
                $(":input[name='code']").val("请输入验证码").css("color","red");
            }
        });
    });

    function bj_submit() {
        var account = $(":input[name='account']").val();
        account = $.trim(account);
        var password = $(":input[name='password']").val();
        password = $.trim(password);
        var code = $(":input[name='code']").val();
        code = $.trim(code);
        if (account == "" ||account == "请输入账号" || password == "" ||password == "请输入密码"|| code == ""||code == "请输入验证码") {
            if (account == "" && password == "" && code == "") {
                $(":input[name='account']").focus();
                $(":input[name='account']").val("请输入账号").css("color","red");
                $(":input[name='password']").val("请输入密码").css("color","red");
                $(":input[name='code']").val("请输入验证码").css("color","red");
            }
            if (account == "" && password !== "" && code !== "") {
                $(":input[name='account']").focus();
                $(":input[name='account']").val("请输入账号").css("color","red");
            }
            if (account !== "" && password == "" && code !== "") {
                $(":input[name='password']").focus();
                $(":input[name='password']").val("请输入密码").css("color","red");
            }
            if (account !== "" && password !== "" && code == "") {
                $(":input[name='code']").focus();
                $(":input[name='code']").val("请输入验证码").css("color","red");
            }
            return false;
        }
        if ($("#rememberMe").is(':checked')){
            $(":input[name='rememberMe']").val("true");
        }
    }
    function register() {
        window.location.href = "${pageContext.request.contextPath}/register.jsp";
    }
    function changeImg(obj) {
        obj.src = "${pageContext.request.contextPath}/code/image?data="+new Date();

    }
</script>
<body>
<div class="box">
    <div class="row login-box">
        <div class="login-title text-center">
            <h1>
                <small>登录</small>
            </h1>
        </div>
        <div class="login-content">
            <div class="form">
                <form id="bj-form" onsubmit="return bj_submit()"
                      action="${pageContext.request.contextPath}/material/toLogin" method="post">
                    <div class="form-group">
                        <div class="col-xs-12  ">
                            <div class="input-group">
                                <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
                                <input type="text" id="account" name="account" class="form-control" value="${account}" placeholder="用户名">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-12">
                            <div class="input-group">
                                <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
                                <input type="password" id="password" name="password" class="form-control" placeholder="密码">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-12">
                            <div class="input-group">
                                <span class="input-group-addon"><span class="glyphicon glyphicon-heart"></span></span>
                                </span><input type="text" id="code" name="code" class="form-control" placeholder="验证码：(看不清？点击图片更换)" style="width: 330px;height: 40px;">
                                <img class="img-responsive" src="${pageContext.request.contextPath}/code/image"
                                     style="width: 100px;height: 40px;"
                                     onclick="changeImg(this)"/>
                            </div>
                        </div>
                    </div>
                    <div class="form-group form-actions">
                        <div class="col-xs-4 col-xs-offset-4 ">
                            <div class="bj_error">
                                <span>${error}</span>
                            </div>
                            <button type="submit" class="btn btn-sm btn-info" id="submit"><span
                                    class="glyphicon glyphicon-off"></span> 登录
                            </button>
                            <div><input id="rememberMe" type="checkbox"/>&nbsp;记住我
                            <input name="rememberMe" hidden="hidden"/></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-6 link">
                            <p class="text-center remove-margin">
                                <small>忘记密码？</small>
                                <a href="javascript:void(0)" onclick="petrievePassword()">
                                    <small>找回</small>
                                </a>
                            </p>
                        </div>
                        <div class="col-xs-6 link">
                            <p class="text-center remove-margin">
                                <small>还没注册?</small>
                                <a href="javascript:void(0)" onclick="register()">
                                    <small>注册</small>
                                </a>
                            </p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
