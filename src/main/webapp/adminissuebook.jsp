<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Issue Book</title>
    <link rel="stylesheet" type="text/css" href="adminbookissue.css">
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

        /* Form Styling */
        form {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        /* Label Styling */
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }

        /* Input Styling */
        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #333;
            border-radius: 5px;
            font-size: 16px;
            color: #333;
            background: #f8f8f8;
            transition: background 0.3s, border-color 0.3s;
        }

        input[type="text"]:focus {
            border-color: #000;
            background: #fff;
            outline: none;
        }

        /* Button Styling */
        button {
            width: 100%;
            padding: 10px;
            margin-top : 8px ;
            border-radius: 5px;
            background-color: #000;
            color: #fff;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
            border : 1px solid black ;
        }

        button:hover {
            background-color: #fff;
            color:#000 ;

        }

        button:active {
            transform: scale(0.98);
        }
        .back {
            display: flex;
            flex-direction: row;
            justify-content: flex-start;
            position: absolute;
            top: 20px; /* Position it at the top */
            left: 20px; /* Position it to the left */
            color: white; /* Button text color */
            background-color: black; /* Button background color */
            padding: 10px 15px; /* Padding for a better look */
            text-decoration: none; /* Remove underline */
            border-radius: 5px; /* Slightly rounded corners */
            font-weight: bold;
            transition: background-color 0.3s, transform 0.2s;
            border: 2px solid black;
        }

        .back:hover {
            background-color: #fff;
            color: #000;
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
    <a class="back" href="bookissue.jsp">back</a>
    <h1>Issue a Book</h1>
    <form action="AdminIssueBookServlet" method="post">
        <label for="bookId">Book ID:</label>
        <input type="text" id="bookId" name="bookId" required>

        <label for="bookName">Book Name:</label>
        <input type="text" id="bookName" name="bookName" required>

        <label for="studentId">Student ID:</label>
        <input type="text" id="studentId" name="studentId" required>

        <label for="studentName">Student Name:</label>
        <input type="text" id="studentName" name="studentName" required>

        <button type="submit">Issue Book</button>
    </form>
</body>
</html>