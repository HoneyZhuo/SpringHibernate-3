<%@ page contentType="text/html;charset=UTF-8" language="java"
         isELIgnored="false" %>
<html>
<head>
    <title>Title</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" type="text/css" rel="stylesheet">
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

            margin-top: -200px;
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
            padding-top: 5px;
        }

        .login-content {
            height: 350px;
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

        .legent {
            color: purple;
        }

        .label-color {
            color: #ad6704;
        }

        .p-color {
            color: #bd362f;
        }

    </style>
</head>
<script src="${pageContext.request.contextPath}/static/js/jquery-2.2.3.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
<script type="text/javascript">


    $(function () {
        $(":input[name='account']").focus(function () {
            $("#account-p").text("6~12个字符,字母数字结合").css("color", "#bd362f");
            var nameValue = $(this).val();
            if ($.trim(nameValue) == "") {
                this.value = this.defaultValue;
            }
        }).blur(function () {
            var nameValue = $(this).val();
            nameValue = $.trim(nameValue);
            if (nameValue == "") {
                $("#account-p").text("请输入账号").css("color", "red");
                this.value = this.defaultValue;//此处 this 是 DOM 对象
            } else {
                //验证账号
                //必须以字母开头&&包含数字&&长度为6~12
                var regBeginWithLetter = /^[a-zA-Z][A-Za-z0-9]{5,11}$/;
                //必须以字母开头&&包含数字&&长度为1~5
                var regBeginWithLetterShort = /^[a-zA-Z][A-Za-z0-9]{0,4}$/;
                //必须以字母开头&&包含数字&&长度为大于12
                var regBeginWithLetterLong = /^[a-zA-Z][A-Za-z0-9]{12,}$/;
                //只包含字母
                var regOnlyLetter = /^[A-Za-z]{1,}$/;
                var regSpecial = /^[a-zA-Z][A-Za-z0-9~!！@#$%^&*()`?/<>.,|、_+=]{5,17}$/;

                if (regBeginWithLetterShort.test($(this).val())) {
                    $("#account-p").text("请输入6~12位账号,并且以字母开头").css("color", "red");
                    this.value = this.defaultValue;
                    return;
                } else if (regBeginWithLetterLong.test($(this).val())) {
                    $("#account-p").text("账号长度不能超过12位").css("color", "red");
                    this.value = this.defaultValue;
                    return;
                } else if (!regBeginWithLetter.test($(this).val()) && !regBeginWithLetterShort.test($(this).val()) && !regBeginWithLetterLong.test($(this).val())) {
                    $("#account-p").text("账号必须以字母开头").css("color", "red");
                    this.value = this.defaultValue;
                    return;
                } else {
                    $.ajax({
                        url : "${pageContext.request.contextPath}/user/verifyAccount",
                        data: {account: nameValue},
                        async : false,
                        method :"GET",
                        success: function (data) {
                            var success = eval("(" + data + ")");
                            var stat = success.stat;
                            var msg = success.msg;
                            if (data !== undefined){
                                if (stat == true) {
                                    $("#account-p").text(msg).css("color", "#f8b9b7");
                                    this.value = nameValue;
                                } else if(stat == false){
                                    $("#account-p").text(msg).css("color", "red");
                                }
                            }
                        }
                    }).error(function () {
                        alert("连接服务器失败，请重试");
                    });
                }
            }
        });
        $(":input[name='password']").focus(function () {
            $("#password-p").text("8~16个字符，必须包含字母，数字和特殊字符，区分大小写").css("color", "#bd362f");
            var passwordValue = $(this).val();
            if (passwordValue == this.defaultValue) {
                this.value = this.defaultValue;
            }
        }).blur(function () {
            var passwordValue = $(":input[name='password']").val();
            passwordValue = $.trim(passwordValue);
            if (passwordValue == "") {
                $("#password-p").text("请输入密码").css("color", "red");
                this.value = this.defaultValue;
            } else {
                //验证密码

                //必须以字母开头&&包含数字&&包含特殊字符&&长度为6~18
                var regBeginWithLetter = /^[a-zA-Z][A-Za-z0-9~!！@#$%^&*()`?/<>.,|、_+=]{5,17}$/;

                //必须以字母开头&&包含数字&&包含特殊字符&&长度为1~5
                var regBeginWithLetterShort = /^[a-zA-Z][A-Za-z0-9~!！@#$%^&*()`?/<>.,|、_+=]{0,4}$/;

                //必须以字母开头&&包含数字&&包含特殊字符&&长度为1~55
                var regBeginWithLetterLong = /^[a-zA-Z][A-Za-z0-9~!！@#$%^&*()`?/<>.,|、_+=]{18,}$/;

                //同时包含字母和特殊字符，但不包含数字，并且长度在6~18
                var regNoNum = /^[A-Za-z~!！@#$%^&*()`?/<>.,|、_+=]{6,18}$/;

                //只包含字母
                var regOnlyLetter = /^[A-Za-z]{1,}$/;

                //同时包含字母和数字，但不包含特殊字符，并且长度在6~18
                var regNoSpecial = /^[A-Za-z0-9]{6,18}$/;

                if (regBeginWithLetterShort.test($(this).val())) {
                    $("#password-p").text("密码长度至少6位,并且以字母开头").css("color", "red");
                    this.value = this.defaultValue;
                    return;
                } else if (regBeginWithLetterLong.test($(this).val())) {
                    $("#password-p").text("密码长度不能超过18位").css("color", "red");
                    this.value = this.defaultValue;
                    return;
                } else if (!regBeginWithLetter.test($(this).val()) && !regBeginWithLetterShort.test($(this).val()) && !regBeginWithLetterLong.test($(this).val())) {
                    $("#password-p").text("密码必须字母开头").css("color", "red");
                    this.value = this.defaultValue;
                    return;
                } else if (regNoNum.test($(this).val())) {
                    if (regOnlyLetter.test($(this).val())) {
                        $("#password-p").text("必须包含至少一个特殊字符和一个数字").css("color", "red");
                        this.value = this.defaultValue;
                        return;
                    } else {
                        $("#password-p").text("必须包含至少一个数字").css("color", "red");
                        this.value = this.defaultValue;
                        return;
                    }
                } else if (regNoSpecial.test($(this).val())) {
                    if (regOnlyLetter.test($(this).val())) {
                        $("#password-p").text("必须包含至少一个特殊字符和一个数字").css("color", "red");
                        return;
                    } else {
                        $("#password-p").text("必须包含至少一个特殊字符").css("color", "red");
                        return;
                    }
                } else if (regBeginWithLetter.test($(this).val())) {
                    $("#password-p").text("密码可用").css("color", "#f8b9b7");
                    this.value = passwordValue;
                }
            }
        });
        $(":input[name='passwordAgin']").focus(function () {
            $("#passwordAgin-p").text("请再次填写密码").css("color", "#bd362f");
            var passwordAginValue = $(this).val();
            if (passwordAginValue == this.defaultValue) {
                this.value = this.defaultValue;
            }
        }).blur(function () {
            var passwordAginValue = $(":input[name='passwordAgin']").val();
            passwordAginValue = $.trim(passwordAginValue);
            if (passwordAginValue == "") {
                $("#passwordAgin-p").text("请确认密码").css("color", "red");
                this.value = this.defaultValue;
            } else {
                var passwordValue = $(":input[name='password']").val();
                if (passwordValue == passwordAginValue) {
                    $("#passwordAgin-p").text("核对成功").css("color", "#f8b9b7");
                    this.value = passwordAginValue;
                } else {
                    $(this).val("");
                    $("#passwordAgin-p").text("两次输入的密码不一致请从新输入").css("color", "red");
                }
            }
        });
        $(":input[name='telephone']").blur(function () {
            var teleNo = $(this).val();
            if(teleNo == ""){
                this.value = this.defaultValue;
                $("#telephone-p").text("*可选");
            }else {
                //验证手机号码
                var verifyTele = /^1[3|4|5|7|8][0-9]\d{8}$/;
                if (verifyTele.test(teleNo)){
                    this.value = teleNo;
                    $("#telephone-p").text("可以使用");
                }else {
                    $("#telephone-p").text("格式不正确");
                    this.focus();
                    return;
                }
            }
        });
        $(":input[name='email']").blur(function () {
            var email = $(this).val();
            if (email == ""){
                this.value = this.defaultValue;
                $("#email-p").text("*可选");
            }else{
                //验证邮箱
                var verifyEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                if (verifyEmail.test(email)){
                    this.value = email;
                    $("#email-p").text("可以使用");
                }else {
                    $("#email-p").text("格式不正确");
                    this.focus();
                    return;
                }
            }
        });
        $(":input[name='userName']").blur(function () {
            var userName = $(this).val();
            if (userName == ""){
                $("#userName-p").text("请输入昵称");
                this.value = this.defaultValue;
            }else{
                var verifyUserName = /[A-Za-z0-9]{0,9}/;
                if(verifyUserName.test(userName)){
                    $("#userName-p").text("恭喜，昵称可用");
                }else{
                    $("#userName-p").text("昵称格式不合法，不能包含特殊字符且不能大于10位");
                }
            }
        });
    });

    function register() {
        if ($("#account-p").text() == "" || $("#account-p").text() == "用户名已存在") {
            $("#account-p").text() == "用户名已存在"
            $(":input[name='account']").focus();
                return false;
        }else if ($(":input[name='account']").val() == "" ||
              $(":input[name='password']").val() == "" ||
              $(":input[name='passwordAgin']").val() == "" ||
              $(":input[name='userName']").val() == "") {

            alert("账号，密码和昵称为必填项，不能为空");
            $(":input[name='account']").focus();
            return false;
        }
    }
</script>
<body class="box">
<div class="container form">
    <form class="form-group" action="${pageContext.request.contextPath}/user/register" method="post" onsubmit="return register()">
        <input type="text" name="userId" hidden="hidden"/>
        <legend class="legent">注册账号  ||带*号选填，其他必填</legend>
        <div class="form-group col-xs-10">
            <label class="form-group label-color" for="account">账号</label>
            <input type="text" class="input-sm col-xs-12" id="account" name="account"/>
            <p id="account-p" class="help-block col-xs-10 p-color">6~12个字符,字母数字结合</p>
        </div>
        <div class="form-group col-xs-10">
            <label class="form-group label-color" for="userName">昵称</label>
            <input type="text" class="input-sm col-xs-12" id="userName" name="userName"/>
            <p id="userName-p" class="help-block col-xs-10 p-color">可以有汉字,字母,数字,长度不超过6位</p>
        </div>
        <div class="form-group col-xs-10">
            <label class="form-group label-color" for="password">请输入密码</label>
            <input type="password" class="input-sm col-xs-12" id="password" name="password"/>
            <p id="password-p" class="help-block col-xs-10 p-color">8~16个字符，必须包含字母，数字和特殊字符，区分大小写</p>
        </div>
        <div class="form-group col-xs-10">
            <label class="form-group label-color" for="passwordAgin">请再次输入密码</label>
            <input type="password" class="input-sm col-xs-12" id="passwordAgin" name="passwordAgin"/>
            <p id="passwordAgin-p" class="help-block col-xs-10 p-color">请再次填写密码</p>
        </div>
        <div class="form-group col-xs-10">
            <label class="form-group label-color" for="telephone">联系方式</label>
            <input type="text" class="input-sm col-xs-12" id="telephone" name="telephone"/>
            <p id="telephone-p" class="help-block col-xs-10 p-color">*仅限手机号，可选</p>
        </div>
        <div class="form-group col-xs-10">
            <label class="form-group label-color" for="email">邮箱</label>
            <input type="text" class="input-sm col-xs-12" id="email" name="email"/>
            <p id="email-p" class="help-block col-xs-10 p-color">*可选</p>
        </div>
        <div class="form-group form-actions">
            <div class="col-xs-8 col-xs-offset-3">
                <button class="btn btn-sm btn-info" id="submit" type="submit">注册</button>
            </div>
        </div>
    </form>
</div>
</body>
</html>
