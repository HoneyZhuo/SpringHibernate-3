<%@ page contentType="text/html;charset=UTF-8" language="java"
    isELIgnored="false" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/static/js/jquery-2.2.3.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
    <script type="application/javascript">
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
</html>
