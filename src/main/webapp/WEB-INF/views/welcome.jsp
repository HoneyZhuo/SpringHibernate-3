<%@ page contentType="text/html;charset=UTF-8" language="java"
         isELIgnored="false" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<html>
<head>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <title>Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/static/js/jquery-2.2.3.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
    <style type="text/css">
        .box {
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#6699FF', endColorstr='#6699FF'); /*  IE */
            background-image: linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -o-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -moz-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -webkit-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -ms-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            /*background-image: url("/static/image/456.jpg");*/
            margin: 0 auto;
            position: relative;
            width: 100%;
            height: 100%;
        }

        td {
            text-align: center
        }

        th {
            text-align: center
        }

        li {
            text-align: center
        }

        body {
            padding-top: 55px;
        }

        .mb_form {
            text-align: center;
        }

        .mb_btn {
            width: 200px;
        }

        .container {
            padding-right: 0px;
            padding-left: 0px;
        }

        .pageLocation {
            padding: 100px;
            padding-bottom: 20px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            /* 用户管理 */
            $("#userManage").click(function () {
                var type = "user";
                showByPage(pageNo, type);
            });
            /* 角色管理 */
            $("#roleManage").click(function () {
                var type = "role";
                showByPage(pageNo,type);
            });
            /* 初始化弹出框 */
            $('[data-toggle="popover"]').popover();
        });
        /* 获取选中的记录,并返回所有被选中记录的value集合 */
        function checkItem(Item) {
            var checkItem = $(":input[name='"+ Item +"']:checked");
            var len = checkItem.length;
            var checkedVals = new Array();
            for (var i = 0; i < len; i++) {
                var checkedVal = checkItem.eq(i).val();
                checkedVals[i] = checkedVal;
            }
            return checkedVals;
        }
        function searchCount(type) {
            $.ajax({
                url:"${pageContext.request.contextPath}/material/search"+type+"Count",
                method:"POST",
                async:false,
                success:function (data) {
                    if (data == undefined){
                       alert("访问服务器失败,请稍后再试");
                    }else{
                        var count = eval("("+data+")").msg;
                        return count;
                    }
                }
            }).error(function () {
                alert("访问服务器失败,请稍后再试")
            });
        }
        function searchResource(pageNo, type) {
            $.ajax({
                url : "${pageContext.request.contextPath}/material/get"+ type+"ByPage",
                data : {pageNo : pageNo},
                async : false,
                method : "POST",
                success : function (data) {
                    if (data == undefined){
                        alert("访问服务器失败,请稍后重试");
                    }else if (eval("(" + data + ")").msg == null){
                        $("#show_"+type).hide();
                    }else{
                        $("#show_user").nextAll().remove();//移除所有的值
                        data = eval("(" + data + ")");
                        var users = data.msg;
                        for (var i = 0; i < users.length; i++){
                            var row = $("#show_user").clone();
                            if (i % 2 == 0){
                                row.attr("class","success");
                            }else{
                                row.attr("class","warning");
                            }
                            row.find("#userId").text(users[i].userId).attr("hidden","hidden");
                            row.find("#rowNo").append("<div class='row'><input name='checkedItem' type='checkbox' value='"+ users[i].userId +"' class='col-lg-6'/><span class='col-lg-6'>"+ (i+1) +"</span></div>");
                            row.find("#userName").text(users[i].userName).attr("class","col-lg-1");
                            row.find("#account").text(users[i].account).attr("class","col-lg-1");
                            row.find("#roleName").text(users[i].tRole.roleName).attr("class","col-lg-1");
                            row.find("#email").text(users[i].email).attr("class","col-lg-2");
                            row.find("#telePhone").text(users[i].telephone).attr("class","col-lg-2");
                            row.find("#regDate").text(users[i].regDate).attr("class","col-lg-1");
                            row.find("#button").append("<shiro:hasPermission name='user:update'><button class='btn btn-info' value='"+ users[i].userId +"' onclick='editUser(this)'>编辑</button></shiro:hasPermission><shiro:hasPermission name='user:delete'><button class='btn btn-danger' value='"+ users[i].userId +"' onclick='deleteUser(this)'>删除</button></shiro:hasPermission>").attr("class","col-lg-2");
                            row.appendTo($("#MyTbody"));
                            row.show();
                        }
                    }
                }
            }).error(function () {
                alert("访问服务器失败,请稍后重试");
            });
        }
    </script>
</head>
<body>
<div class="container box">
    <div class="row" style="width: 1363px">
        <div class="col-md-12">
            <nav class="navbar navbar-default label-info navbar-fixed-top">
                <div class="container-fluid">
                    <div class="navbar-header col-lg-8">
                        <a class="navbar-brand" href="#">Brand</a>
                    </div>
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <form class="navbar-form navbar-left" role="search">
                            <div class="form-group">
                                <input type="text" class="form-control" placeholder="账号">
                            </div>
                            <button type="submit" class="btn btn-info">查询</button>
                        </form>
                        <ul class="nav navbar-nav navbar-right">
                            <li class="dropdown" style="width: 160px">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                                   aria-haspopup="true" aria-expanded="false"><img
                                        src="${pageContext.request.contextPath}/static/image/MyLove.jpeg"
                                        style="width: 25px; height: 25px" class="img-circle">${account}<span
                                        class="caret"></span></a>
                                <ul class="dropdown-menu">
                                    <li><a href="#">Settings</a></li>
                                    <li><a href="#">密码修改</a></li>
                                    <li role="separator" class="divider"></li>
                                    <li><a href="#" onclick="logout()">Logout</a></li>
                                </ul>
                            </li>
                        </ul>
                    </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav>
        </div>
    </div>
    <div class="row" style="margin: -1px">
        <div class="col-md-2 label-info accordion" role="group" style="padding: 0px;padding-top:20px;padding-left:12px;height: 100%">
            <div class="accordion-group">
                <div class="accordion-heading">
                    <button type="button" class="btn btn-warning mb_btn accordion-toggle" data-toggle="collapse" data-parent="#accordion-772345" href="#sysBasic" contenteditable="true">系统基础管理</button>
                </div>
                <div id="sysBasic" class="accordion-body collapse" style="height: 0px;">
                    <button type="button" class="btn btn-primary accordion-inner mb_btn" contenteditable="true" id="userManage">用户管理</button>
                    <button type="button" class="btn btn-primary accordion-inner mb_btn" contenteditable="true" id="roleManage">角色管理</button>
                </div>
            </div>
        </div>
        <%-- 用户管理 --%>
        <jsp:include page="user.jsp"/>
        <%-- 角色管理 --%>
        <jsp:include page="role.jsp"/>
    </div>
</div>
</body>
</html>