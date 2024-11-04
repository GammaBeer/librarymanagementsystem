<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management System</title>
    <link rel="stylesheet" type="text/css" href="index.css"> <!-- Link to the external CSS -->
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
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh; /* Full viewport height */
            background-color: #fff; /* White background */
            color: #000; /* Black text */
            text-align: center; /* Centered text */
        }

        h2 {
            font-size: 36px; /* Heading size */
            margin-bottom: 20px; /* Space below heading */
        }

        a {
            color: #fff; /* Black text for links */
            font-size: 20px; /* Font size for links */
            text-decoration: none; /* Remove underline */
            padding: 10px 20px; /* Padding around links */
            border: 2px solid #000; /* Black border */
            border-radius: 5px; /* Rounded corners */
            margin: 10px; /* Space around links */
            background : #000 ;
            transition: transform 0.3s; /* Transition for hover effect */
        }

        a:hover {
            background-color: #000; /* Black background on hover */
            color: #fff; /* White text on hover */
            transform: scale(1.05); /* Slight pop effect on hover */
        }
    </style>
</head>
<body>
    <h2>Welcome to Student Management System!</h2>
    <a href="login.jsp">Admin Login</a>
    <a href="studentlogin.jsp">Student Login</a>
</body>
</html>