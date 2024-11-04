<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<html>
<head>
    <title>Welcome</title>
    <style>
        /* Basic Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        /* Background Gradient */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            color: #333;
        }

        /* Container */
        .welcome-container {
            background: linear-gradient(135deg, #ffffff, #f3f4f6);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            text-align: center;
            max-width: 500px;
            width: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .welcome-container:hover {
            transform: scale(1.02);
            box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
        }

        /* Welcome Title */
        .welcome-container h2 {
            font-size: 28px;
            color: #007bff;
            margin-bottom: 20px;
            text-shadow: 1px 1px rgba(0, 0, 0, 0.1);
        }

        /* Navigation Links */
        .welcome-container ul {
            list-style-type: none;
            padding: 0;
            margin-top: 20px;
        }

        .welcome-container ul li {
            margin: 15px 0;
        }

        .welcome-container ul li a {
            text-decoration: none;
            color: #2575fc;
            font-size: 18px;
            font-weight: bold;
            transition: color 0.3s, transform 0.3s;
        }

        .welcome-container ul li a:hover {
            color: #6a11cb;
            transform: translateX(5px);
        }

        /* Logout Button */
        .logout-button {
            margin-top: 30px;
            padding: 12px 25px;
            font-size: 16px;
            font-weight: bold;
            color: #fff;
            background: linear-gradient(135deg, #ff416c, #ff4b2b);
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.3s ease;
        }

        .logout-button:hover {
            background: linear-gradient(135deg, #ff4b2b, #ff416c);
            transform: translateY(-3px);
        }
    </style>
    <script>
        window.onload = function() {
            // Retrieve the token from localStorage
            const token = localStorage.getItem("studenttoken");

            // Check if token is available
            if (!token) {
                // Redirect to login if no token is found
                window.location.href = "login.jsp";
            } else {
                // Set the email in the session for display purposes
                document.getElementById("emailDisplay").innerText = token;
            }
        };

        function clearToken() {
            // Clear token on logout
            localStorage.removeItem("studenttoken");
            window.location.href = "login.jsp";
        }
    </script>
</head>
<body>
    <div class="welcome-container">
        <%
            // Use the implicit session object directly
            String studentEmail = (String) session.getAttribute("studentEmail");

            if (studentEmail == null) {
                response.sendRedirect("studentlogin.jsp");
                return; // Ensure the rest of the code isn't executed if redirected
            }
        %>
        <h2>Welcome, <%= studentEmail %>!</h2>
        <ul>
            <li><a href="issueBook.jsp">Issue a Book</a></li>
            <li><a href="booksIssuedByAStudent.jsp">Books Issued by You</a></li>
        </ul>
        <form action="logout.jsp" method="post">
            <button type="submit" class="logout-button">Logout</button>
        </form>
    </div>
</body>
</html>