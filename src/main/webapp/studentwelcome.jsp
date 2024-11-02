<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome</title>
</head>
<body>
    <h2>Welcome, <%= request.getSession().getAttribute("email") %>!</h2>
    <a href="stundetlogout.jsp">Logout</a>
</body>
</html>
