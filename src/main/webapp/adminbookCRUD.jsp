<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.ArrayList ,java.util.HashMap" %>
<%@ page import="com.example.utils.DBConnection" %>
<jsp:setProperty name="book" property="*" />
<html>
<head>
    <title>Library Books</title>
    <link rel="stylesheet" type="text/css" href="adminbookCRUD.css"> <!-- External CSS -->
</head>
<body>
    <h2>Library Books</h2>

    <!-- Book Grid Display -->
    <table class="book-grid">
        <tr>
            <th>Book ID</th>
            <th>Book Name</th>
            <th>Author</th>
            <th>Quantity</th>
            <th>Section</th>
        </tr>
        <%
            ArrayList<HashMap<String, Object>> books = (ArrayList<HashMap<String, Object>>) request.getAttribute("books");
            if (books != null && !books.isEmpty()) {
                for (HashMap<String, Object> bookData : books) {
        %>
        <tr>
            <td><%= bookData.get("book_id") %></td>
            <td><%= bookData.get("book_name") %></td>
            <td><%= bookData.get("author") %></td>
            <td><%= bookData.get("quantity") %></td>
            <td><%= bookData.get("section") %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="5">No books available</td>
        </tr>
        <%
            }
        %>
    </table>

    <!-- Add Book Form -->
    <h3>Add a New Book</h3>
    <form action="BookServlet" method="post">
        <input type="hidden" name="action" value="add">
        <label>Book Name:</label><input type="text" name="bookName" required><br>
        <label>Author:</label><input type="text" name="author" required><br>
        <label>Quantity:</label><input type="number" name="quantity" required><br>
        <label>Section:</label><input type="text" name="section" required><br>
        <button type="submit">Add Book</button>
    </form>

    <!-- Update Book Form -->
    <h3>Update Book</h3>
    <form action="BookServlet" method="post">
        <input type="hidden" name="action" value="update">
        <label>Book Name:</label><input type="text" name="searchBookName" required><br>
        <label>New Quantity:</label><input type="number" name="quantity"><br>
        <button type="submit">Update Book</button>
    </form>

    <!-- Delete Book Form -->
    <h3>Delete Book</h3>
    <form action="BookServlet" method="post">
        <input type="hidden" name="action" value="delete">
        <label>Book Name:</label><input type="text" name="searchBookName" required><br>
        <button type="submit">Delete Book</button>
    </form>
</body>
</html>
