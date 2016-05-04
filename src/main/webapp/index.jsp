<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html lang="zh-CN">
<head>
    <title>Title</title>
</head>
<body>
    <form action="${pageContext.request.contextPath}/user/logout" method="get">
        <input type="text" name="account"/>
        <br>
        <input type="password" name="password"/>
        <br>
        <input type="text" name="userName"/>
        <br>
        <input type="submit" value="提交"/>
    </form>
</body>
</html>
