<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome</title>
</head>
<body>
    <h2>Welcome, <%= request.getSession().getAttribute("email") %>!</h2>
    <ul>
        <li><a href="issueBook.jsp">Issue a Book</a></li>
        <li><a href="logout.jsp">Logout</a></li>
    </ul>
</body>
</html>
