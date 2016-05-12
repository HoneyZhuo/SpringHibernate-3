<%--
  Created by IntelliJ IDEA.
  User: MirBai
  Date: 2016/4/20
  Time: 23:16
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
    isELIgnored="false" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<div class="col-md-10" style="padding: 0px;" id="showRoleTable"  hidden="hidden">
    <table class="table table-hover">
        <thead>
        <tr class="label-info">
            <th hidden="hidden"></th>
            <th class="col-lg-1"><div class="row"><input type="checkbox" class="col-lg-6"/><span class="col-lg-6">#</span></div></th>
            <th class="col-lg-1"><span>昵称</span></th>
            <th class="col-lg-1"><span>账号</span></th>
            <th class="col-lg-1"><span>角色</span></th>
            <th class="col-lg-2"><span>邮箱</span></th>
            <th class="col-lg-1"><span>联系方式</span></th>
            <th class="col-lg-1"><span>注册时间</span></th>
            <th class="col-lg-2"><span>操作</span></th>
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
