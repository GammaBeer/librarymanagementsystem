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
    <!-- Link to trigger BookServlet when clicking "manage books" -->
    <a href="BookServlet">Manage Books</a>
    <a href="bookissue.jsp">Book Issue</a>
    <a href="finecollectionmanager.jsp">Fine collection Manager</a>
</body>
</html>
