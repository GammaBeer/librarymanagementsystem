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
    <a class="back" href="welcome.jsp">back</a>
    <h1>Book Issue</h1>
    <div class="link-container">
        <a href="adminissuebook.jsp">Issue Book</a>
        <a href="adminissuebooklist.jsp">See Issued Books List</a>
        <a href="adminissuehistory.jsp">History</a>
    </div>
</body>
</html>