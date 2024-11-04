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

        /* Background */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: #f0f2f5;
            color: #333;
        }

        /* Container Styling */
        .welcome-container {
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .welcome-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }

        /* Welcome Title */
        .welcome-container h2 {
            font-size: 28px;
            color: #444;
            margin-bottom: 20px;
            font-weight: 600;
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
            color: #555;
            font-size: 18px;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 8px;
            transition: color 0.2s, background-color 0.2s;
        }

        .welcome-container ul li a:hover {
            background-color: #ebeff5;
            color: #333;
        }

        /* Logout Button */
        .logout-button {
            margin-top: 30px;
            padding: 12px 25px;
            font-size: 16px;
            font-weight: 600;
            color: #fff;
            background: #444;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.3s ease;
        }

        .logout-button:hover {
            background: #555;
            transform: translateY(-2px);
        }
    </style>
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