<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.ArrayList ,java.util.HashMap" %>
<%@ page import="com.example.utils.DBConnection" %>
<html>
<head>
    <title>Library Books</title>
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
    <style>
            /* Basic reset */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                background-color: white; /* Dark background for the body */
                color: #black; /* Light text color */
                font-family: Arial, sans-serif; /* Modern font */
            }
            h3 {
                text-align: center;
                margin-bottom: 8px;
            }
            /* Content styling */
            .content {
                margin: 20px 0; /* Space around sections */
                width: 100%; /* Ensure content takes full width */
            }

            /* Table styling */
            .book-grid {
                width: 100%; /* Full width */
                border-collapse: collapse; /* Merge borders */
                margin-top: 20px; /* Space above the table */
            }

            .book-grid th, .book-grid td {
                border: 1px solid #696969; /* Darker border for cells */
                padding: 12px; /* Cell padding */
                text-align: center; /* Center-align text in table */
            }

            .book-grid th {
                background-color: #978b8b; /* Header background color */
                color: #f5f5f5; /* Light text color */
                font-weight: bold; /* Bold header text */
            }

            .book-grid tr:hover {
                background-color: #696969; /* Highlight row on hover */
            }

            /* Form styling */
            form {
                margin: 20px 0;
                display: flex;
                flex-direction: column;
                align-items: center;
                background-color: #f5f5f5; /* Light background for form */
                padding: 20px;
                border-radius: 10px; /* Rounded corners */
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Subtle shadow */
                max-width: 400px; /* Limit the width */
                margin: 0 auto; /* Center the form */
            }

            label {
                display: block;
                margin-bottom: 10px;
                font-weight: bold;
            }

            input[type="text"], input[type="number"] {
                width: 100%;
                padding: 10px;
                margin-bottom: 20px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            button {
                padding: 10px 20px;
                background-color: #1c1c1c; /* Dark background for button */
                color: #f5f5f5; /* Light text color */
                border: none;
                border-radius: 5px;
                cursor: pointer; /* Pointer cursor for buttons */
                transition: background-color 0.3s; /* Smooth transition for button */
            }

            button:hover {
                background-color: #333; /* Darker background on hover */
            }

            /* Navbar styling */
            .navbar {
                background-color: #1c1c1c; /* Background color for navbar */
                padding: 10px; /* Padding around navbar */
            }

            .navbar ul {
                list-style-type: none; /* Remove bullet points */
                padding: 0; /* Remove padding */
                display: flex; /* Display items in a row */
                justify-content: center; /* Center the items horizontally */
            }

            .navbar li {
                margin: 0 15px; /* Space between navbar items */
            }

            .navbar a {
                color: #f5f5f5; /* Light text color for links */
                text-decoration: none; /* Remove underline */
                font-size: 18px; /* Font size for navbar links */
                padding: 10px 15px; /* Padding for clickable area */
                transition: background-color 0.3s; /* Smooth transition on hover */
            }

            .navbar a:hover {
                background-color: #333; /* Darker background on hover */
                border-radius: 5px; /* Rounded corners for hover effect */
            }
        </style>
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
            <!-- Field to search for the book by ID -->
            <label>Book ID:</label><input type="number" name="bookId" required><br>

            <!-- Fields to update book details -->
            <label>New Book Name:</label><input type="text" name="newBookName"><br>
            <label>New Author:</label><input type="text" name="newAuthor"><br>
            <label>New Quantity:</label><input type="number" name="newQuantity"><br>
            <label>New Section:</label><input type="text" name="newSection"><br>

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
