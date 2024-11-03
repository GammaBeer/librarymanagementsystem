<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <style>
        /* Reset styling */
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
            background-color: #f4f6f9;
        }

        /* Container for form */
        .login-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
        }

        /* Form title */
        .login-container h2 {
            margin-bottom: 20px;
            color: #333;
            font-size: 24px;
        }

        /* Labels and input styling */
        .login-container label {
            display: block;
            text-align: left;
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
        }

        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        .login-container input[type="text"]:focus,
        .login-container input[type="password"]:focus {
            border-color: #007bff;
            outline: none;
        }

        /* Login button styling */
        .login-container button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .login-container button:hover {
            background-color: #0056b3;
        }

        /* Error message styling */
        .error-message {
            color: red;
            margin-top: 10px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Admin Login Page</h2>
        <form id="loginForm" action="login" method="post" onsubmit="storeEmail()">
            <label for="username">Username:</label>
            <input type="text" name="username" id="username" placeholder="Enter your username" required>

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
    <script>
        function storeEmail() {
            // Get the email or username field value
            const username = document.getElementById("username").value;
            // Store it in localStorage
            localStorage.setItem("admintoken", username);
        }
    </script>
</body>
</html>