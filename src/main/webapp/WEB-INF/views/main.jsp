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
        td{text-align: center}
        th{text-align: center}
        li{text-align: center}
        body{padding-top: 55px;}
        .mb_form{
            text-align: center;
        }
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
            /* 初始化弹出框 */
            $('[data-toggle="popover"]').popover();
        });
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
        <div class="col-md-2 btn-group-vertical label-info" role="group" style="padding: 0px;height: 100%" aria-label="...">
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
        <jsp:include page="user.jsp"/>
        <%-- 角色管理 --%>
        <jsp:include page="role.jsp"/>
    </div>
</div>
</body>
</html>