<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome</title>
    <link rel="stylesheet" type="text/css" href="welcome.css">
</head>
<body>
    <h2>Welcome, <%= request.getSession().getAttribute("username") %>!</h2>
    <a href="logout.jsp">Logout</a>
    <br>
    <a href="BookServlet">manage books</a>
</body>
</html>
