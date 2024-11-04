<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" type="text/css" href="welcome.css">
    <style>
        /* Basic Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        /* Full Page Layout */
        body {
            display: flex;
            height: 100vh;
            background: #f0f0f0; /* Light gray background for main area */
            color: #000;
        }

        /* Sidebar Styling */
        .sidebar {
            width: 250px;
            background: #000; /* Sharp black */
            color: #fff; /* Sharp white text */
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px 0;
            border-radius: 10px 0 0 10px;
            box-shadow: 4px 0 10px rgba(0, 0, 0, 0.15);
        }

        .sidebar h2 {
            font-size: 24px;
            margin-bottom: 30px;
            color: #fff;
        }

        /* Sidebar Links Styling */
        .sidebar a {
            color: #000;
            background: #fff; /* White background for buttons */
            font-size: 18px;
            text-decoration: none;
            margin: 10px ;
            padding: 12px ;
            width: 80%;
            text-align: center;
            border: 2px solid #000;
            border-radius: 5px;
            transition: transform 0.3s, background 0.3s;
        }

        .sidebar a:hover {
            transform: scale(1.05); /* Slight pop effect */
        }

        /* Main Content Styling */
        .main-content {
            flex-grow: 1;
            padding: 40px;
        }

        .main-content h2 {
            font-size: 32px;
            color: #000;
            margin-bottom: 20px;
        }

        /* Logout Button Styling */
        .logout-btn {
            margin-top: auto;
            color: #fff;
            font-size: 16px;
            text-decoration: none;
            padding: 10px 20px;
            background: #880000; /* Dark red for logout */
            border-radius: 5px;
            transition: background 0.3s;
            width: 80%;
            text-align: center;
        }

        .logout-btn:hover {
            transform: scale(1.05); /* Slight pop effect on hover */
        }
    </style>
    <script>
        // Check if the user is authenticated
        window.onload = function() {
            const token = localStorage.getItem("admintoken");
            if (!token) {
                // Redirect to login page if token is missing
                window.location.href = "login.jsp";
            }
        };
        function clearToken() {
                    // Clear token on logout
                    localStorage.removeItem("admintoken");
                    window.location.href = "login.jsp";
                }
    </script>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>Admin Dashboard</h2>
        <a href="BookServlet">Manage Books</a>
        <a href="bookissue.jsp">Book Issue</a>
        <a href="finecollectionmanager.jsp">Fine Collection Manager</a>
        <a href="logout.jsp" class="logout-btn" onclick="clearToken()">Logout</a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <h2>Welcome, <%= request.getSession().getAttribute("username") %>!</h2>
        <p>Select an option from the sidebar to manage books, issue books, or handle fines.</p>
    </div>
</body>
</html>