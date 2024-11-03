<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Issue Book</title>
    <link rel="stylesheet" type="text/css" href="adminbookissue.css">
</head>
<body>
    <h1>Issue a Book</h1>
    <form action="AdminIssueBookServlet" method="post">
        <label for="bookId">Book ID:</label>
        <input type="text" id="bookId" name="bookId" required>
        <br><br>

        <label for="bookName">Book Name:</label>
        <input type="text" id="bookName" name="bookName" required>
        <br><br>

        <label for="studentId">Student ID:</label>
        <input type="text" id="studentId" name="studentId" required>
        <br><br>

        <label for="studentName">Student Name:</label>
        <input type="text" id="studentName" name="studentName" required>
        <br><br>

        <button type="submit">Issue Book</button>
    </form>
</body>
</html>
