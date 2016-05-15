<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html lang="zh-CN">
<head>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <title>角色</title>
    <script type="application/javascript">
        /**
         *  @Author 白景川【baijc1234@126.com】
         *  @Date 2016/5/12 12:20
         *  @TODO 角色管理
         */
        /* 获取角色信息，并分页 */
        function searchRole(p) {
            $.ajax({
                url: "${pageContext.request.contextPath}/material/getRoleByPage",
                data: {pageNo: p},
                async: false,
                method: "POST",
                success: function (data) {
                    if (data == undefined) {
                        alert("访问服务器失败,请稍后重试");
                    } else if (eval("(" + data + ")").msg == null) {
                        $("#show_role").hide();
                    } else {
                        $("#show_role").nextAll().remove();//移除所有的值
                        data = eval("(" + data + ")");
                        var roles = data.msg;
                        for (var i = 0; i < roles.length; i++) {
                            var row = $("#show_role").clone();
                            if (i % 2 == 0) {
                                row.attr("class", "success");
                            } else {
                                row.attr("class", "warning");
                            }
                            row.find("#roleId").text(roles[i].roleId).attr("hidden", "hidden");
                            row.find("#rowNum").append("<div class='row'><input name='checkItem' type='checkbox' value='" + roles[i].roleId + "' class='col-lg-6'/><span class='col-lg-6'>" + (i + 1) + "</span></div>");
                            row.find("#roleName_role").text(roles[i].roleName).attr("class", "col-lg-1");
                            row.find("#state").text(1).attr("class", "col-lg-1");
                            row.find("#roleKey").text(roles[i].roleKey).attr("class", "col-lg-1");
                            row.find("#description").text(roles[i].description).attr("class", "col-lg-2");
                            row.appendTo($("#myTbody_role"));
                            row.show();
                        }
                    }
                }
            }).error(function () {
                alert("访问服务器失败,请稍后重试");
            });
        }
        /* 点击角色管理时，显示角色信息列表 */
        function showRoles() {
            var pageNo = 1;
            searchRole(pageNo);
            $("#prev_role").click(function () {
                if (pageNo > 1) {
                    $("#checkAll").prop("checked", false);
                    pageNo--;
                    searchRole(pageNo);
                    $("#currentPageNo_role").text(pageNo);
                } else {
                    $(this).attr("class", "disabled");
                }
            });
            $("#next_role").click(function () {
                $("#checkAll").prop("checked", false);
                pageNo++;
                searchRole(pageNo);
                var a = $("tbody").children("tr");
                if (a.size() < 6 && a.size() > 1) {
                    $(this).attr("onclick", "disabled");
                }
                if (a.size() == 1) {
                    pageNo--;
                    alert("已经是最后一页");
                    return false;
                }
                $("#currentPageNo_role").text(pageNo);
            });
            $("#showRoleTable").show();
            $("#showUserTable").hide();
            $("#check_all_role").click(function () {
                if ($(this).is(':checked')) {
                    $(":input[name='checkItem']:checkbox").prop("checked", true);
                } else {
                    $(":input[name='checkItem']:checkbox").prop("checked", false);
                    $(":input[name='checkItem']:checkbox").prop("checked", "");
                }
            });
            $("#rootAddRole").click(function () {
                var inputVal = $("#addRoleModal input");
                inputVal.val("");
                $(":input[name='permission']").val("请新增角色后,点击右侧分配权限按钮为角色分配权限").css("color", "green")
                $("#addRoleModal").modal('show');
                $("#addRoleModal input").blur(function () {
                    if ($.trim(inputVal.val()) == "" || $.trim(inputVal.val()) == null) {
                        $("#addRoleModal :button[id='addRole_btn']").attr("disabled", "disabled");
                    } else {
                        $("#addRoleModal :button[id='addRole_btn']").attr("disabled", false);
                    }
                }).focus(function () {
                    $("#addRoleModal :button[id='addRole_btn']").attr("disabled", "disabled");
                });
            });
            $("#rootEditRole").click(function () {
                $("#addRoleModal .modal-title").text("修改角色信息");
                var Item = "checkItem";
                if (checkItem(Item).length != 1) {
                    alert("请选择一条信息");
                    return false;
                }
                $(":input[name='permission']").val("请点击右侧分配权限按钮为该角色分配权限").css("color", "green");
                var $checkedItem = $("#roleTable #roleId:contains('" + checkItem(Item) + "')");
                var roleNameVar = $checkedItem.siblings("#roleName_role").text();
                $("#addRoleModal :input[name='roleName']").val(roleNameVar);
                var roleKeyVar = $checkedItem.siblings("#roleKey").text();
                $("#addRoleModal :input[name='roleKey']").val(roleKeyVar);
                var descriptionVar = $checkedItem.siblings("#description").text();
                $("#addRoleModal :input[name='description']").val(descriptionVar);
                $("#addRoleModal form").attr("onsubmit", "return editRole(this)");
                $("#addRoleModal :button[id='addRole_btn']").attr("disabled", "disabled");
                $("#addRoleModal").modal('show');
                $("#addRoleModal input").blur(function () {
                    if ($("#addRoleModal :input[name='roleName']").val() !== roleNameVar || $("#addRoleModal :input[name='roleKey']").val() !== roleKeyVar || $("#addRoleModal :input[name='description']").val() !== descriptionVar) {
                        $("#addRoleModal :button[id='addRole_btn']").attr("disabled", false);
                    } else {
                        $("#addRoleModal :button[id='addRole_btn']").attr("disabled", "disabled");
                    }
                }).focus(function () {
                    $("#addRoleModal :button[id='addRole_btn']").attr("disabled", "disabled");
                });
            });
            $("#rootDeleRole").click(function () {
                alert("删除角色信息，请联系后台管理员");
                return false;
                var Item = "checkItem";
                if (checkItem(Item).length !== 1) {
                    alert("请选择一条数据");
                    return false;
                } else {
                    var roleIds = checkItem(Item).toString();
                    if (confirm("确定要删除选中的角色信息吗？")) {
                        $.post("${pageContext.request.contextPath}/material/deleteRole", {roleIds: roleIds}, function (data) {
                            if (data == undefined) {
                                var msg = eval("(" + data + ")").msg;
                                alert(msg);
                            } else {
                                alert("访问服务器失败，请刷新页面后重试");
                            }
                        }).error(function () {
                            alert("访问服务器失败，请刷新页面后重试");
                        });
                    }
                }
            })
            $("#rootAssignPerm").click(function () {
                var Item = "checkItem";
                if (checkItem(Item).length !== 1){
                    alert("请选择一条数据");
                    return false;
                }
                var roleId = checkItem("checkItem")[0];
                $.post("${pageContext.request.contextPath}/material/checkPerm",{roleId:roleId},function (data) {
                    if (data == undefined){
                        alert("访问服务器失败，请刷新页面重试");
                    }else if (data !== "" && data !== null){
                        var currentPerms = eval("(" + data + ")").msg;
                        var currentPermNames = new Array();
                        for (var i = 0; i < currentPerms.length; i++){
                            var currentPermName = currentPerms[i].permName;
                            currentPermNames[i] = currentPermName;
                            $(".perm-btn").find(":input[value='" + currentPermName + "']").parents("label").addClass("active");
                            var oldClassValue = $(".perm-btn").find(":input[value='" + currentPermName + "']").parents("label").attr("class");
                            $(".perm-btn").find(":input[value='" + currentPermName + "']").prop("checked","checked").next("span").attr("class","glyphicon glyphicon-ok");
                        }
                    }
                }).error(function () {
                    alert("访问服务器失败，请刷新页面重试");
                });
                $("#assignPerm").modal('show');

                $(".perm-btn").click(function () {
                    /* 对于 checkbox 的点击事件，判断它点击之前的状态*/
                    if ($(this).find("input").is(':checked')){
                        $(this).find("span").attr("class","glyphicon glyphicon-remove");
                    }else{
                        $(this).find("span").attr("class","glyphicon glyphicon-ok");
                    }
                });//
            });
        }
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
        /* 新增角色 */
        function addRole(tRole) {
            var roleName = $(tRole).find(":input[name='roleName']").val();
            var roleKey = $(tRole).find(":input[name='roleKey']").val();
            var description = $(tRole).find(":input[name='description']").val();
            var flag = true;
            if (roleName == "" || roleKey == "" || description == "" || roleName == null || roleKey == null || description == null) {
                alert("roleName、roleKey 和 description 不能为空");
                return false;
            }
            var permissions = null;
            $("#addRole_btn").attr("disabled", "disabled");
            $.ajax({
                url: "${pageContext.request.contextPath}/material/addRole",
                data: {
                    roleName: roleName,
                    roleKey: roleKey,
                    description: description,
                    permissions: permissions,
                    flag: flag
                },
                async: false,
                method: "POST",
                success: function (data) {
                    if (data == undefined) {
                        alert("访问服务器失败，请稍后再试");
                    } else {
                        var role = eval("(" + data + ")").msg;
                        alert("新增角色" + role.roleName + "成功");
                        location.reload(false);
                    }
                }
            }).error(function () {
                alert("访问服务器失败，请稍后再试");
            });
        }
        /* 编辑角色 */
        function editRole(tRole) {
            var Item = "checkItem";
            $("#addRole_btn").attr("disabled", "disabled");
            var roleName = $(tRole).find(":input[name='roleName']").val();
            var roleKey = $(tRole).find(":input[name='roleKey']").val();
            var description = $(tRole).find(":input[name='description']").val();
            var roleId = checkItem(Item)[0];
            var permissions = null;
            var flag = true;
            $.ajax({
                url: "${pageContext.request.contextPath}/material/editRole",
                data: {
                    roleName: roleName,
                    roleKey: roleKey,
                    description: description, /*permissions:permissions,*/
                    flag: flag,
                    roleId: roleId
                },
                async: false,
                method: "POST",
                success: function (data) {
                    if (data == undefined) {
                        alert("访问服务器失败，请稍后再试");
                    } else {
                        var msg = eval("(" + data + ")").msg;
                        alert(msg);
                        location.reload(false);
                    }
                }
            }).error(function () {
                alert("访问服务器失败，请稍后再试");
            });
            alert(roleNameDefalt);
            return false;
        }
        /* 分配权限 */
        function assignPerm(tPerm) {
            var Item_per = "checkItem_per";
            var permNames = checkItem(Item_per).toString();
            alert(permNames);
            var roleId = checkItem("checkItem")[0];
            var flag = true;
            $.ajax({
                url : "${pageContext.request.contextPath}/material/assignPerm",
                method : "POST",
                data : {flag : flag, permNames : permNames, roleId : roleId},
                async : false,
                success : function (data) {
                    if (data == undefined) {
                        alert("访问服务器失败，请稍后再试");
                    } else {
                        var msg = eval("(" + data + ")").msg;
                        alert(msg);
                        location.reload(false);
                    }
                }
            }).error(function () {
                alert("访问服务器失败，请稍后再试");
            });
        }

    </script>
</head>
<body>
<%-- ADD and EDIT role modal --%>
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
                        <input class="form-control" disabled="disabled" name="permission" type="text" placeholder="默认无">
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
<%-- 分配权限 modal--%>
<div class="modal fade" id="assignPerm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="checkbox">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">X</button>
                <h4 class="modal-title">分配权限</h4>
            </div>
            <form id="assignPermForm" method="post" onsubmit="return assignPerm(this)">
                <div class="modal-body">
                    <table id="assignPermTable">
                        <tr style="height: 40px">
                            <td style="width: 150px">
                                <input hidden="hidden" name="flag" value="false"/>
                            </td>
                            <td style="width: 200px">

                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons" class="perm-btn">
                                    <label class="btn btn-success">
                                        <input name="checkItem_per" type="checkbox" value="user:create" autocomplete="off"> 新增 <span class="glyphicon glyphicon-remove"></span>
                                    </label>

                                </div>
                            </td>
                        </tr>
                        <tr style="height: 40px">
                            <td style="width: 150px;">

                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons">
                                    <label class="btn btn-success">
                                        <input type="checkbox" autocomplete="off"> <span class="glyphicon glyphicon-user" aria-hidden="true"></span> 用户管理
                                    </label>
                                </div>
                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons" class="perm-btn">
                                    <label class="btn btn-success">
                                        <input name="checkItem_per" type="checkbox" value="user:update" autocomplete="off"> 编辑 <span class="glyphicon glyphicon-remove"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 40px">
                            <td style="width: 150px">

                            </td>
                            <td style="width: 200px">

                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons" class="perm-btn">
                                    <label class="btn btn-success">
                                        <input name="checkItem_per" type="checkbox" value="user:delete" autocomplete="off"> 删除 <span class="glyphicon glyphicon-remove"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 40px">
                            <td style="width: 150px">

                            </td>
                            <td style="width: 200px">

                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons" class="perm-btn">
                                    <label class="btn btn-info">
                                        <input name="checkItem_per" type="checkbox" value="role:create" autocomplete="off"> 新增 <span class="glyphicon glyphicon-remove"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 40px">
                            <td style="width: 150px;">
                                <div data-toggle="buttons">
                                    <label class="btn btn-primary">
                                        <input type="checkbox" autocomplete="off"><span class="glyphicon glyphicon-home" aria-hidden="true"></span> 基础管理
                                    </label>
                                </div>
                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons">
                                    <label class="btn btn-info">
                                        <input type="checkbox" autocomplete="off"><span class="glyphicon glyphicon-piggy-bank" aria-hidden="true"></span> 角色管理
                                    </label>
                                </div>
                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons" class="perm-btn">
                                    <label class="btn btn-info">
                                        <input name="checkItem_per" type="checkbox" value="role:update" autocomplete="off"> 编辑 <span class="glyphicon glyphicon-remove"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 40px">
                            <td style="width: 150px">

                            </td>
                            <td style="width: 200px">

                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons" class="perm-btn">
                                    <label class="btn btn-info">
                                        <input name="checkItem_per" type="checkbox" value="role:delete" autocomplete="off"> 删除 <span class="glyphicon glyphicon-remove"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 40px">
                            <td style="width: 150px">

                            </td>
                            <td style="width: 200px">

                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons" class="perm-btn">
                                    <label class="btn btn-warning">
                                        <input name="checkItem_per" type="checkbox" value="menu:create" autocomplete="off"> 新增 <span class="glyphicon glyphicon-remove"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 40px">
                            <td style="width: 150px;">

                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons">
                                    <label class="btn btn-warning">
                                        <input type="checkbox" autocomplete="off"><span class="glyphicon glyphicon-folder-open" aria-hidden="true"></span> 菜单管理
                                    </label>
                                </div>
                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons" class="perm-btn">
                                    <label class="btn btn-warning">
                                        <input name="checkItem_per" type="checkbox" value="menu:update" autocomplete="off"> 编辑 <span class="glyphicon glyphicon-remove"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 40px">
                            <td style="width: 150px">

                            </td>
                            <td style="width: 200px">

                            </td>
                            <td style="width: 200px">
                                <div data-toggle="buttons" class="perm-btn">
                                    <label class="btn btn-warning">
                                        <input name="checkItem_per" type="checkbox" value="menu:delete" autocomplete="off"> 删除 <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>
                                    </label>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="submit" id="assignPerm_btn" class="btn btn-primary">提交</button>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="col-md-10" style="padding: 0px" id="showRoleTable" hidden="hidden">
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
    <table class="table table-hover table-condensed" id="roleTable">
        <thead>
        <tr class="warning">
            <th hidden="hidden"></th>
            <th class="col-lg-1">
                <div class="row"><input type="checkbox" id="check_all_role" class="col-lg-6"/><span
                        class="col-lg-6">#</span></div>
            </th>
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
</body>
</html>
