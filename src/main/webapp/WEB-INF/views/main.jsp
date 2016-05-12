<%@ page contentType="text/html;charset=UTF-8" language="java"
         isELIgnored="false" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<html>
<head>
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
        td{text-align: center}
        th{text-align: center}
        li{text-align: center}
        body{padding-top: 55px}
        .mb_btn{
            width: 200px;
        }
        .container{
            padding-right: 0px;
            padding-left: 0px;
        }
        .pageLocation{
            padding: 100px;
            padding-top: 5px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            /* 用户管理 */
            $("#userManage").click(function () {
                showUsers();
            });
            /* 角色管理 */
            $("#roleManage").click(function () {
                showRoles();
            });
        });
        /**
         *  @Author 白景川【baijc1234@126.com】
         *  @Date 2016/5/12 12:19
         *  @TODO 用户管理
         */
        /* 获取用户信息，并分页 */
        function searchUser(p) {
            $.ajax({
                url : "${pageContext.request.contextPath}/material/getUserByPage",
                data : {pageNo : p},
                async : false,
                method : "POST",
                success : function (data) {
                    if (data == undefined){
                        alert("访问服务器失败,请稍后重试");
                    }else if (eval("(" + data + ")").msg == null){
                        $("#show_user").hide();
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
                            row.find("#rowNo").append("<div class='row'><input name='checkItem' type='checkbox' value='"+ users[i].userId +"' class='col-lg-6'/><span class='col-lg-6'>"+ (i+1) +"</span></div>");
                            row.find("#userName").text(users[i].userName).attr("class","col-lg-1");
                            row.find("#account").text(users[i].account).attr("class","col-lg-1");
                            row.find("#roleName").text("管理员"/*users[i].tRoles[0].roleName*/).attr("class","col-lg-1");
                            row.find("#email").text(users[i].email).attr("class","col-lg-2");
                            row.find("#telePhone").text(users[i].telephone).attr("class","col-lg-2");
                            row.find("#regDate").text(users[i].regDate).attr("class","col-lg-1");
                            row.find("#button").append("<button class='btn btn-info' value='"+ users[i].userId +"' onclick='editUser(this)'>编辑</button><button class='btn btn-danger' value='"+ users[i].userId +"' onclick='deleteUser(this)'>删除</button>").attr("class","col-lg-2");
                            row.appendTo($("#MyTbody"));
                            row.show();
                        }
                    }
                }
            }).error(function () {
                alert("访问服务器失败,请稍后重试");
            });
        }
        /* 显示用户信息列表 */
        function showUsers() {
            var pageNo = 1;
            searchUser(pageNo);
            $("#prev").click(function () {
                if (pageNo > 1){
                    $("#checkAll").prop("checked",false);
                    pageNo --;
                    searchUser(pageNo);
                    $("#currentPageNo").text(pageNo);
                }else{
                    $(this).attr("class","disabled");
                }
            });
            $("#next").click(function () {
                $("#checkAll").prop("checked",false);
                pageNo ++;
                searchUser(pageNo);
                var a = $("tbody").children("tr");
                if (a.size() < 6 && a.size() > 1){
                    $(this).attr("onclick","disabled");
                }
                if (a.size() == 1){
                    pageNo --;
                    alert("已经是最后一页");
                    return false;
                }
                $("#currentPageNo").text(pageNo);
            });
            $("#showUserTable").show();
            $("#showRoleTable").hide();
            $("#checkAll").click(function () {
                if ($(this).is(':checked')){
                    $(":input[name='checkItem']:checkbox").prop("checked",true);
                }else{
                    $(":input[name='checkItem']:checkbox").prop("checked",false);
                    $(":input[name='checkItem']:checkbox").prop("checked","");
                }
            });
        }
        /* 通过为每一条数据赋予删除按钮,删除一条用户信息 */
        function deleteUser(deleButton) {
            var userId = $(deleButton).val(); //onclick="deleteUser(this)"
            if (confirm("是否要删除这条数据")){
                $.post("${pageContext.request.contextPath}/material/deleteUser",{userId:userId},function (data) {
                    if (data == undefined || data == null){
                        alert("访问服务器失败，请重试");
                    }else if(eval("("+ data +")").stat == true){
                        alert(eval("("+ data +")").msg);
                        location.reload(false);
                    }else if(eval("("+ data +")").stat == false){
                        alert(eval("("+ data +")").msg);
                        location.reload(false);
                    }
                }).error(function () {
                    alert("访问服务器失败，请重试");
                });
            }
        }
        /* 为模态框赋值 */
        function editUser(editButton) {
            var $buttParent = $(editButton).parent("td");

            var userId = $buttParent.siblings("#userId").text();
            $(":input[name='userId']").val(userId);

            var account = $buttParent.siblings("#account").text();
            $(":input[name='account']").val(account).attr("disabled","disabled");

            var userName = $buttParent.siblings("#userName").text();
            $("#newName").val(userName);
            $(":input[name='nameCopy']").val(userName);

            var email = $buttParent.siblings("#email").text();
            $("#newEmail").val(email);
            $(":input[name='emailCopy']").val(email);

            var telephone = $buttParent.siblings("#telePhone").text();
            $("#newTele").val(telephone);
            $(":input[name='telephoneCopy']").val(telephone);

            var roleName = $buttParent.siblings("#roleName").text();
            if (roleName == "student"){
                $("option[name='student']").attr("selected", true);
                $("option[name='studentCopy']").attr("selected", true);
            }else if(roleName == "teacher"){
                $("option[name='teacher']").attr("selected", true);
                $("option[name='teacherCopy']").attr("selected", true);
            }else if(roleName == "admin"){
                $("option[name='admin']").attr("selected", true);
                $("option[name='adminCopy']").attr("selected", true);
            }
            $("#editUser").find(":input[name='userId']").hide();
            $("#editUser").find(":input[name='nameCopy']").hide();
            $("#editUser").find(":input[name='emailCopy']").hide();
            $("#editUser").find(":input[name='telephoneCopy']").hide();
            $("#editUser").find("#selectorCopy").hide();;
            $("#editUser").modal('show');
        }
        /* 通过为每一条数据赋予编辑按钮,调用editUser(editButton)函数,修改一条用户信息*/
        function changeUser(subForm) {
            var userId = $(subForm).find(":input[name='userId']").val();

            var userName = $(subForm).find(":input[name='userName']").val();
            var userNameCopy = $(subForm).find(":input[name='nameCopy']").val();

            var email = $(subForm).find(":input[name='email']").val();
            var emailCopy = $(subForm).find(":input[name='emailCopy']").val();

            var telephone = $(subForm).find(":input[name='telephone']").val();
            var telephoneCopy = $(subForm).find(":input[name='telephoneCopy']").val();

            var roleName = $(subForm).find("#selector").val();
            var roleNameCopy = $(subForm).find("#selectorCopy").val();
            if (userName == userNameCopy && email == emailCopy && telephone == telephoneCopy && roleName == roleNameCopy){
                if(confirm("没有数据被修改，是否放弃编辑")){
                    $("#editUser").modal('hide');
                }
                return false;
            }else{
                if(confirm("确定要修改吗?")){
                    $("#editUser").modal('hide');
                    $.post("${pageContext.request.contextPath}/material/editUser",{userId : userId, userName : userName, email : email, telephone : telephone, roleName : roleName}, function (data) {
                        if (data == undefined){
                            alert("访问服务器失败，请重新操作");
                            location.reload(false);
                        }else if(eval("(" + data + ")").stat == true){
                            alert(eval("(" + data + ")").msg);
                            location.reload(false);
                        }
                    }).error(function () {
                        alert("访问服务器失败，请重新操作");
                        location.reload(false);
                    });
                }
            }
            return false;
        }
        /* 退出登录 */
        function logout() {
            if (confirm("确定要退出吗？")){
                $.get("${pageContext.request.contextPath}/user/logout",function (data) {
                    if (data !== undefined){
                        data = eval("("+ data +")");
                        alert(data.msg);
                        window.location.href="${pageContext.request.contextPath}/test/toLogin";
                    }else{
                        alert("访问服务器失败，请重试");
                    }
                }).error(function () {
                    alert("访问服务器失败，请重试");
                });
            }
        }
        /* 获取选中的记录,并返回所有被选中记录的集合 */
        function checkItem() {
            var checkItem = $(":input[name='checkItem']:checked");
            var len = checkItem.length;
            var userIds = new Array();
            for (var i = 0;i < len; i++){
                var userId = checkItem.eq(i).val();
                userIds[i]=userId;
            }
            return userIds;
        }
        /* 通过导航栏编辑按钮修改一条数据,一次仅限修改一条 */
        function rootEditUser() {
            alert(checkItem()[0]);
            return false;
        }
        /* 通过导航栏删除按钮删除选中的数据,可以删除一条或多条数据 */
        function rootDeleUser(){

        }
        /* 通过导航栏新增按钮,增加一条数据 */
        function rootAddUser() {

        }
        /* 为选中的记录分配角色,一次仅限选中一条 */
        function rootAssignRole() {

        }
        /**
         *  @Author 白景川【baijc1234@126.com】
         *  @Date 2016/5/12 12:20
         *  @TODO 角色管理
         */
        /* 获取角色信息，并分页 */
        function searchRole(p) {
            $.ajax({
                url : "${pageContext.request.contextPath}/material/getRoleByPage",
                data : {pageNo : p},
                async : false,
                method : "POST",
                success : function (data) {
                    if (data == undefined){
                        alert("访问服务器失败,请稍后重试");
                    }else if (eval("(" + data + ")").msg == null){
                        $("#show_role").hide();
                    }else{
                        $("#show_role").nextAll().remove();//移除所有的值
                        data = eval("(" + data + ")");
                        var roles = data.msg;
                        for (var i = 0; i < roles.length; i++){
                            var row = $("#show_role").clone();
                            if (i % 2 == 0){
                                row.attr("class","success");
                            }else{
                                row.attr("class","warning");
                            }
                            row.find("#roleId").text(roles[i].roleId).attr("hidden","hidden");
                            row.find("#rowNum").append("<div class='row'><input name='checkItem' type='checkbox' value='"+ roles[i].roleId +"' class='col-lg-6'/><span class='col-lg-6'>"+ (i+1) +"</span></div>");
                            row.find("#roleName_role").text(roles[i].roleName).attr("class","col-lg-1");
                            row.find("#state").text(1).attr("class","col-lg-1");
                            row.find("#roleKey").text(roles[i].roleKey).attr("class","col-lg-1");
                            row.find("#description").text(roles[i].description).attr("class","col-lg-2");
                            row.appendTo($("#myTbody_role"));
                            row.show();
                        }
                    }
                }
            }).error(function () {
                alert("访问服务器失败,请稍后重试");
            });
        }
        /* 显示角色信息列表 */
        function showRoles() {
            var pageNo = 1;
            searchRole(pageNo);
            $("#prev_role").click(function () {
                if (pageNo > 1){
                    $("#checkAll").prop("checked",false);
                    pageNo --;
                    searchRole(pageNo);
                    $("#currentPageNo_role").text(pageNo);
                }else{
                    $(this).attr("class","disabled");
                }
            });
            $("#next_role").click(function () {
                $("#checkAll").prop("checked",false);
                pageNo ++;
                searchRole(pageNo);
                var a = $("tbody").children("tr");
                if (a.size() < 6 && a.size() > 1){
                    $(this).attr("onclick","disabled");
                }
                if (a.size() == 1){
                    pageNo --;
                    alert("已经是最后一页");
                    return false;
                }
                $("#currentPageNo_role").text(pageNo);
            });
            $("#showRoleTable").show();
            $("#showUserTable").hide();
            $("#check_all_role").click(function () {
                if ($(this).is(':checked')){
                    $(":input[name='checkItem']:checkbox").prop("checked",true);
                }else{
                    $(":input[name='checkItem']:checkbox").prop("checked",false);
                    $(":input[name='checkItem']:checkbox").prop("checked","");
                }
            });
            $("#rootAddRole").click(function () {
                $("#addRoleModal").modal('show');
            });
        }
        function addRole(tRole) {
            var roleName = $(tRole).find(":input[name='roleName']").val();
            var roleKey = $(tRole).find(":input[name='roleKey']").val();
            var description = $(tRole).find(":input[name='description']").val();
            var flag = true;
            var permissions = null;
            $("#addRole_btn").attr("disabled","disabled");
            $.ajax({
                url : "${pageContext.request.contextPath}/material/addRole",
                data : {roleName : roleName, roleKey : roleKey,description :description,permissions:permissions,flag:flag},
                async : false,
                method : "POST",
                success : function (data) {
                    if (data == undefined){
                        alert("访问服务器失败，请稍后再试");
                    }else{
                        var role = eval("(" +data+ ")").msg;
                        alert("新增角色" + role.roleName +"成功");
                    }
                }
            }).error(function () {
                alert("访问服务器失败，请稍后再试");
            });
        }
    </script>
</head>
<body>
<%-- modal edit user--%>
<div class="modal fade" id="editUser" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
                <h4 class="modal-title">修改用户资料</h4>
            </div>
            <form id="editUserForm" action="${pageContext.request.contextPath}/material/editUser" onsubmit="return changeUser(this)">
                <div class="modal-body">
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon left-addon">账&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</span>
                            <input class="form-control" name="account" type="text">
                            <input class="form-control" name="userId" type="text"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon left-addon">昵&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称</span>
                            <input class="form-control" name="userName" id="newName" type="text"/>
                            <input class="form-control" id="nameCopy" name="nameCopy" type="text"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon left-addon">邮&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;箱</span>
                            <input class="form-control" name="email" id="newEmail" type="text"/>
                            <input class="form-control" id="emailCopy" name="emailCopy" type="text"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon left-addon">联系方式</span>
                            <input class="form-control" id="newTele" name="telephone" type="text"/>
                            <input class="form-control" id="telephoneCopy" name="telephoneCopy" type="text"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-addon left-addon">角&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;色</span>
                            <select class="form-control" id="selector" name="roleName">
                                <option name="admin">admin</option>
                                <option name="teacher">teacher</option>
                                <option name="student">student</option>
                            </select>
                            <select class="form-control" id="selectorCopy">
                                <option name="adminCopy">admin</option>
                                <option name="teacherCopy">teacher</option>
                                <option name="studentCopy">student</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <span id="progress1"></span>
                    <input type="submit" class="btn btn-primary" value="确定"/>
                </div>
            </form>
        </div>
    </div>
</div>
<%--modal add role--%>
<div class="modal fade" id="addRoleModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">X</button>
                <h4 class="modal-title">新增角色</h4>
            </div>
            <form id="addRoleForm" method="post" onsubmit="return addRole(this)">
                <div class="form-group">
                    <div class="input-group">
                        <span class="input-group-addon left-addon">角&nbsp;色&nbsp;名</span>
                        <input class="form-control" name="roleName" type="text">
                        <input name="flag" hidden="hidden" value="false">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <span class="input-group-addon left-addon">roleKey</span>
                        <input class="form-control" name="roleKey" type="text">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <span class="input-group-addon left-addon">权&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;限</span>
                        <input class="form-control" disabled="disabled" type="text" placeholder="默认无">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <span class="input-group-addon left-addon">描&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述</span>
                        <input class="form-control" name="description" type="text">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="submit" id="addRole_btn" class="btn btn-primary">提交</button>
                </div>
            </form>
        </div>
    </div>
</div>
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
                                   aria-haspopup="true" aria-expanded="false"><img src="${pageContext.request.contextPath}/static/image/MyLove.jpeg" style="width: 25px; height: 25px" class="img-circle">${account}<span class="caret"></span></a>
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
        <div class="col-md-2 btn-group-vertical label-info" role="group" style="padding: 0px;height: 570px" aria-label="...">
            <button type="button" class="btn btn-info mb_btn" id="userManage">用户管理</button>
            <button type="button" class="btn btn-info mb_btn" id="roleManage">角色管理</button>
            <button type="button" class="btn btn-info mb_btn" id="menuManage">菜单管理</button>
            <div class="btn-group mb_btn" role="group">
                <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Dropdown
                    <span class="caret"></span>
                </button>
                <ul class="progress-bar-info dropdown-menu" style="width: 202px">
                    <li class="mb_btn"><a href="#">Dropdown link</a></li>
                    <li class="mb_btn"><a href="#">Dropdown link</a></li>
                </ul>
            </div>
            <div class="btn-group mb_btn" role="group">
                <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Dropdown
                    <span class="caret"></span>
                </button>
                <ul class="progress-bar-info dropdown-menu" style="width: 202px">
                    <li class="mb_btn"><a href="#">Dropdown link</a></li>
                    <li class="mb_btn"><a href="#">Dropdown link</a></li>
                </ul>
            </div>
        </div>
        <%-- 用户管理 --%>
        <div class="col-md-10" style="padding: 0px" id="showUserTable"  hidden="hidden">
            <ol class="breadcrumb">
                <li><a href="#">Home</a></li>
                <li><a href="#">系统基础管理</a></li>
                <li class="active">用户管理</li>
            </ol>
            <div class="btn-group" style="padding-bottom: 5px">
                <button class="btn btn-success" onclick="return rootAddUser()">新增</button>
                <button class="btn btn-warning" onclick="return rootEditUser()">编辑</button>
                <button class="btn btn-danger" onclick="return rootDeleUser()">删除</button>
                <button class="btn btn-primary" onclick="return rootAssignRole()">分配角色</button>
            </div>
            <table class="table table-hover table-condensed">
                <thead>
                <tr class="warning">
                    <th hidden="hidden"></th>
                    <th class="col-lg-1"><div class="row"><input type="checkbox" id="checkAll" class="col-lg-6"/><span class="col-lg-6">#</span></div></th>
                    <th class="col-lg-1"><span>昵称</span></th>
                    <th class="col-lg-1"><span>账号</span></th>
                    <th class="col-lg-1"><span>角色</span></th>
                    <th class="col-lg-2"><span>邮箱</span></th>
                    <th class="col-lg-1"><span>联系方式</span></th>
                    <th class="col-lg-1"><span>注册时间</span></th>
                    <th class="col-lg-2"><span>操作</span></th>
                </tr>
                </thead>
                <tbody id="MyTbody">
                    <tr id="show_user" hidden="hidden">
                        <td id="userId"></td>
                        <td id="rowNo"></td>
                        <td id="userName"></td>
                        <td id="account"></td>
                        <td id="roleName"></td>
                        <td id="email"></td>
                        <td id="telePhone"></td>
                        <td id="regDate"></td>
                        <td id="button"></td>
                    </tr>
                </tbody>
            </table>
            <div class="col-md-offset-4">
                <nav>
                    <ul class="pagination pageLocation" id="page">
                        <li>
                            <a href="javascript:void(0)" aria-label="Previous" id="prev">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        <li>
                            <a href="#" id="currentPageNo">1</a>
                        </li>
                        <li>
                            <a href="javascript:void(0)" aria-label="Next" id="next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
        <%-- 角色管理 --%>
        <div class="col-md-10" style="padding: 0px" id="showRoleTable"  hidden="hidden">
            <ol class="breadcrumb">
                <li><a href="#">Home</a></li>
                <li><a href="#">系统基础管理</a></li>
                <li class="active">角色管理</li>
            </ol>
            <div class="btn-group" style="padding-bottom: 5px">
                <button class="btn btn-success" id="rootAddRole">新增</button>
                <button class="btn btn-warning" id="rootEditRole">编辑</button>
                <button class="btn btn-danger" id="rootDeleRole">删除</button>
                <button class="btn btn-primary" id="rootAssignPerm">分配权限</button>
            </div>
            <table class="table table-hover table-condensed">
                <thead>
                <tr class="warning">
                    <th hidden="hidden"></th>
                    <th class="col-lg-1"><div class="row"><input type="checkbox" id="check_all_role" class="col-lg-6"/><span class="col-lg-6">#</span></div></th>
                    <th class="col-lg-1"><span>角色名</span></th>
                    <th class="col-lg-1"><span>状态</span></th>
                    <th class="col-lg-1"><span>roleKey</span></th>
                    <th class="col-lg-2"><span>描述</span></th>
                </tr>
                </thead>
                <tbody id="myTbody_role">
                <tr id="show_role" hidden="hidden">
                    <td id="roleId"></td>
                    <td id="rowNum"></td>
                    <td id="roleName_role"></td>
                    <td id="state"></td>
                    <td id="roleKey"></td>
                    <td id="description"></td>
                </tr>
                </tbody>
            </table>
            <div class="col-md-offset-4">
                <nav>
                    <ul class="pagination pageLocation" id="page_role">
                        <li>
                            <a href="javascript:void(0)" aria-label="Previous" id="prev_role">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        <li>
                            <a href="#" id="currentPageNo_role">1</a>
                        </li>
                        <li>
                            <a href="javascript:void(0)" aria-label="Next" id="next_role">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>


</div>
</body>
</html>