<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.ArrayList ,java.util.HashMap" %>
<%@ page import="com.example.utils.DBConnection" %>
<html>
<head>
    <title>Library Books</title>
    <link rel="stylesheet" type="text/css" href="adminbookCRUD.css"> <!-- External CSS -->
    <link rel="stylesheet" type="text/css" href="navbar.css"> <!-- New Navbar CSS -->
    <script>
        // Check if the user is authenticated
        window.onload = function() {
            const token = localStorage.getItem("admintoken");
            if (!token) {
                // Redirect to login page if token is missing
                window.location.href = "login.jsp";
            }
        };

        // Function to show the desired section
        function showSection(sectionId) {
            const sections = document.querySelectorAll('.content');
            sections.forEach(section => {
                section.style.display = 'none'; // Hide all sections
            });
            document.getElementById(sectionId).style.display = 'block'; // Show the selected section
        }
    </script>
</head>
<body>
    <h2>Library Management</h2>

    <!-- Navbar -->
    <nav class="navbar">
        <ul>
            <li><a href="javascript:void(0);" onclick="showSection('viewBooks')">View All Books</a></li>
            <li><a href="javascript:void(0);" onclick="showSection('addBook')">Add a New Book</a></li>
            <li><a href="javascript:void(0);" onclick="showSection('updateBook')">Update Book</a></li>
            <li><a href="javascript:void(0);" onclick="showSection('deleteBook')">Delete Book</a></li>
        </ul>
    </nav>

    <!-- View All Books Section -->
    <div id="viewBooks" class="content" style="display: block;">
        <h3>Library Books</h3>
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
    </div>

    <!-- Add Book Section -->
    <div id="addBook" class="content" style="display: none;">
        <h3>Add a New Book</h3>
        <form action="BookServlet" method="post">
            <input type="hidden" name="action" value="add">
            <label>Book Name:</label><input type="text" name="bookName" required><br>
            <label>Author:</label><input type="text" name="author" required><br>
            <label>Quantity:</label><input type="number" name="quantity" required><br>
            <label>Section:</label><input type="text" name="section" required><br>
            <button type="submit">Add Book</button>
        </form>
    </div>

    <!-- Update Book Section -->
    <div id="updateBook" class="content" style="display: none;">
        <h3>Update Book</h3>
        <form action="BookServlet" method="post">
            <input type="hidden" name="action" value="update">
            <label>Book Name:</label><input type="text" name="searchBookName" required><br>
            <label>New Quantity:</label><input type="number" name="quantity"><br>
            <button type="submit">Update Book</button>
        </form>
    </div>

    <!-- Delete Book Section -->
    <div id="deleteBook" class="content" style="display: none;">
        <h3>Delete Book</h3>
        <form action="BookServlet" method="post">
            <input type="hidden" name="action" value="delete">
            <label>Book Name:</label><input type="text" name="searchBookName" required><br>
            <button type="submit">Delete Book</button>
        </form>
    </div>
</body>
</html>
