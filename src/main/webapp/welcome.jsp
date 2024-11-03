<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome</title>
    <link rel="stylesheet" type="text/css" href="welcome.css">
    <script>
            // Check if the user is authenticated
            window.onload = function() {
                const token = localStorage.getItem("admintoken");
                if (!token) {
                    // Redirect to login page if token is missing
                    window.location.href = "login.jsp";
                }
            };
        </script>
</head>
<body>
    <h2>Welcome, <%= request.getSession().getAttribute("username") %>!</h2>
    <a href="logout.jsp">Logout</a>
    <br>
    <a href="adminbookCRUD.jsp">manage books</a>
</body>
</html>
