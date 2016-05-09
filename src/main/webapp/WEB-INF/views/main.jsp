<%@ page contentType="text/html;charset=UTF-8" language="java"
         isELIgnored="false" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/static/js/jquery-2.2.3.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
    <style type="text/css">
        .box {
           /* filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#6699FF', endColorstr='#6699FF'); !*  IE *!
            background-image: linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -o-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -moz-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -webkit-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);
            background-image: -ms-linear-gradient(bottom, #6699FF 0%, #6699FF 100%);*/
            background-image: url("/static/image/456.jpg");
            margin: 0 auto;
            position: relative;
            width: 100%;
            height: 100%;
        }
        td{text-align: center}
        th{text-align: center}
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
            var pageNo = 1;
            search(pageNo);
            $("#prev").click(function () {
                if (pageNo > 1){
                    pageNo --;
                    search(pageNo);
                    $("#currentPageNo").text(pageNo);
                }else{
                    $(this).attr("class","disabled");
                }
            });
            $("#next").click(function () {
                pageNo ++;
                search(pageNo);
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
        });
        function search(p) {
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
                            row.find("#rowNo").text(i+1).attr("class","col-lg-1");
                            row.find("#userName").text(users[i].userName).attr("class","col-lg-1");
                            row.find("#account").text(users[i].account).attr("class","col-lg-1");
                            row.find("#roleName").text(users[i].tRole.roleName).attr("class","col-lg-1");
                            row.find("#email").text(users[i].email).attr("class","col-lg-2");
                            row.find("#telePhone").text(users[i].telephone).attr("class","col-lg-2");
                            row.find("#regDate").text(users[i].regDate).attr("class","col-lg-2");
                            row.find("#button").append("<button class='btn btn-info' value='"+ users[i].userId +"' onclick='editUser(this)'>编辑</button><button class='btn btn-danger' value='"+ users[i].userId +"' onclick='deleteUser(this)'>删除</button>").attr("class","col-lg-2");
                            row.appendTo($("tbody"));
                            row.show();
                        }
                    }
                }
            }).error(function () {
                alert("访问服务器失败,请稍后重试");
            });
        }
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
                        }else if(eval("(" + data + ")").stat == true){
                            alert(eval("(" + data + ")").msg);
                            location.reload(false);
                        }
                    }).error(function () {
                        alert("访问服务器失败，请重新操作");
                    });
                }
            }
            return false;
        }
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
    </script>
</head>
<body>
<div class="modal fade" id="editUser" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
                <h4 class="modal-title">修改用户资料</h4>
            </div>
            <form id="fileForm" action="${pageContext.request.contextPath}/material/editUser" onsubmit="return changeUser(this)">
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
<div class="container box">
    <div class="row">
        <div class="col-md-2">

        </div>
        <div class="col-md-10" style="padding-left: 2px">
            <nav class="navbar navbar-default">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                                data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="#">Brand</a>
                    </div>

                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                            <li class="active"><a href="#">Link <span class="sr-only">(current)</span></a></li>
                            <li><a href="#">Link</a></li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                                   aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
                                <ul class="dropdown-menu">
                                    <li><a href="#">Action</a></li>
                                    <li><a href="#">Another action</a></li>
                                    <li><a href="#">Something else here</a></li>
                                    <li role="separator" class="divider"></li>
                                    <li><a href="#">Separated link</a></li>
                                    <li role="separator" class="divider"></li>
                                    <li><a href="#">One more separated link</a></li>
                                </ul>
                            </li>
                        </ul>
                        <form class="navbar-form navbar-left" role="search">
                            <div class="form-group">
                                <input type="text" class="form-control" placeholder="Search">
                            </div>
                            <button type="submit" class="btn btn-default">Submit</button>
                        </form>
                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="#">Link</a></li>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                                   aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
                                <ul class="dropdown-menu">
                                    <li><a href="#">Action</a></li>
                                    <li><a href="#">Another action</a></li>
                                    <li><a href="#">Something else here</a></li>
                                    <li role="separator" class="divider"></li>
                                    <li><a href="#">Separated link</a></li>
                                </ul>
                            </li>
                        </ul>
                    </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav>
        </div>
    </div>
    <div class="row">
        <div class="col-md-2 btn-group-vertical" role="group" aria-label="...">
            <button type="button" class="btn btn-success" style="width: 200px">1</button>
            <button type="button" class="btn btn-success" style="width: 200px">2</button>

            <div class="btn-group" role="group" style="width: 200px">
                <button type="button" class="btn btn-danger dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Dropdown
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" style="width: 200px">
                    <li><a href="#">Dropdown link</a></li>
                    <li><a href="#">Dropdown link</a></li>
                </ul>
            </div>
        </div>
        <div class="col-md-10" style="padding-left: 2px">
            <table class="table table-responsive table-hover" style="border-collapse: separate" contenteditable="true">
                <thead>
                <tr class="label-warning">
                    <th hidden="hidden"></th>
                    <th class="col-lg-1"><span >#</span></th>
                    <th class="col-lg-1"><span >昵称</span></th>
                    <th class="col-lg-1"><span >账号</span></th>
                    <th class="col-lg-1"><span >角色</span></th>
                    <th class="col-lg-2"><span >邮箱</span></th>
                    <th class="col-lg-2"><span >联系方式</span></th>
                    <th class="col-lg-2"><span >注册时间</span></th>
                    <th class="col-lg-2"><span >操作</span></th>
                </tr>
                </thead>
                <tbody>
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
        </div>
    </div>
    <div class="btn-group col-md-offset-10">
        <button class="btn bg-warning" onclick="logout()">Logout</button>
    </div>
    <div class="row">
        <div class="col-md-offset-5">
            <nav>
                <ul class="pagination pageLocation" id="page">
                    <li>
                        <a href="javascript:void(0)" aria-label="Previous" id="prev">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <li><a href="#" id="currentPageNo">1</a></li>
                    <%--<li><a href="#">2</a></li>
                    <li><a href="#">3</a></li>
                    <li><a href="#">4</a></li>
                    <li><a href="#">5</a></li>--%>
                    <li>
                        <a href="javascript:void(0)" aria-label="Next" id="next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
