<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html lang="zh-CN">
<head>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">

    <title>用户</title>
    <script type="application/javascript">
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
                            row.find("#roleName").text(users[i].tRole.roleName).attr("class","col-lg-1");
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

            var roleKey = $buttParent.siblings("#roleKey").text();
            if (roleKey == "SUPER"){
                $("option[name='SUPER']").attr("selected", true);
                $("option[name='SUPERCopy']").attr("selected", true);
            }else if(roleKey == "ADMIN"){
                $("option[name='ADMIN']").attr("selected", true);
                $("option[name='ADMINCopy']").attr("selected", true);
            }else if(roleKey == "SIMPLE"){
                $("option[name='SIMPLE']").attr("selected", true);
                $("option[name='SIMPLECopy']").attr("selected", true);
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

            var roleKey = $(subForm).find("#selector").val();
            var roleKeyCopy = $(subForm).find("#selectorCopy").val();
            if (userName == userNameCopy && email == emailCopy && telephone == telephoneCopy && roleKey == roleKeyCopy){
                if(confirm("没有数据被修改，是否放弃编辑")){
                    $("#editUser").modal('hide');
                }
                return false;
            }else{
                if(confirm("确定要修改吗?")){
                    $("#editUser").modal('hide');
                    $.post("${pageContext.request.contextPath}/material/editUser",{userId : userId, userName : userName, email : email, telephone : telephone, roleKey : roleKey}, function (data) {
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
                            <select class="form-control" id="selector" name="roleKey">
                                <option name="SUPER">SUPER</option>
                                <option name="ADMIN">ADMIN</option>
                                <option name="SIMPLE">SIMPLE</option>
                            </select>
                            <select class="form-control" id="selectorCopy">
                                <option name="SUPERCopy">SUPER</option>
                                <option name="ADMINCopy">ADMIN</option>
                                <option name="SIMPLECopy">SIMPLE</option>
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
</body>
</html>
