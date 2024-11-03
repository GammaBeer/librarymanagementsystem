<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome</title>
    <script>
        // Check if the user is authenticated
        window.onload = function() {
            const token = localStorage.getItem("studenttoken");
            if (!token) {
                // Redirect to login page if token is missing
                window.location.href = "studentlogin.jsp"; // Fixed typo here
            }
        };
    </script>
</head>
<body>
    <h2>Welcome, <%= request.getSession().getAttribute("email") %>!</h2> <!-- Removed syntax error -->
    <a href="logout.jsp">Logout</a>
</body>
</html>