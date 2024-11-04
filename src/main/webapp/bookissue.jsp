<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Book Issue</title>
    <link rel="stylesheet" type="text/css" href="bookissue.css">
    <style>
        /* Basic Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        /* Body Styling */
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            background: #f8f8f8;
            color: #333;
            padding: 40px;
        }

        /* Heading Styling */
        h1 {
            font-size: 36px;
            margin-bottom: 20px;
            color: #333;
        }

        /* Link Container Styling */
        .link-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            width: 100%;
            max-width: 400px;
        }

        /* Link Styling */
        .link-container a {
            display: block;
            padding: 15px;
            background:#000;
            text-align: center;
            text-decoration: none;
            color: #fff;
            font-weight: bold;
            border: 2px solid #333;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        /* Hover Effect */
        .link-container a:hover {
            background-color: #fff;
            color: #000;
        }

        /* Authentication Script */
        .link-container a:active {
            transform: scale(0.98);
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
    </script>
</head>
<body>
    <h1>Book Issue</h1>
    <div class="link-container">
        <a href="adminissuebook.jsp">Issue Book</a>
        <a href="adminissuebooklist.jsp">See Issued Books List</a>
        <a href="adminissuehistory.jsp">History</a>
    </div>
</body>
</html>