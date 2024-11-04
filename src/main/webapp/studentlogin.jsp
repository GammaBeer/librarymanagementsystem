<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <style>
        /* Basic Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        /* Center the form on the page */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: #f5f5f5;
        }

        /* Container for the form */
        .login-container {
            background-color: #fff;
            padding: 40px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
        }

        /* Form header */
        .login-container h2 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #333;
        }

        /* Form labels and inputs */
        .login-container label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #555;
            text-align: left;
        }

        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background: #f9f9f9;
            font-size: 16px;
        }

        .login-container input[type="text"]:focus,
        .login-container input[type="password"]:focus {
            border-color: #007bff;
            outline: none;
            background: #fff;
        }

        /* Login button */
        .login-container button {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background-color: #000;
            color: #fff;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s ease;
            border : 1px solid black ;
        }

        .login-container button:hover {
            background-color: #fff;
            color : #000 ;
        }

        /* Error message styling */
        .error-message {
            color: red;
            margin-top: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Student Login Page</h2>
        <form id="loginForm" action="studentlogin" method="post" onsubmit="storeEmail()">
            <label for="email">Email:</label>
            <input type="text" name="email" id="email" placeholder="Enter your email" required>

            <label for="password">Password:</label>
            <input type="password" name="password" id="password" placeholder="Enter your password" required>

            <button type="submit">Login</button>
        </form>

        <%-- Display error message if login fails --%>
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <p class="error-message"><%= error %></p>
        <% } %>
    </div>

</body>
</html>