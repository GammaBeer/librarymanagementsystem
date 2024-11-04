<%@ page import="com.example.utils.DBConnection" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // Use the implicit session object directly
    String studentEmail = (session != null) ? (String) session.getAttribute("studentEmail") : null;

    if (studentEmail == null) {
        response.sendRedirect("studentlogin.jsp");
        return; // Ensures that code below is not executed if redirected
    }

    String selectedBranch = request.getParameter("branch");
    if (selectedBranch == null) {
        selectedBranch = "";
    }

    // Fetch distinct branches from the librarybooks table
    List<String> sections = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        String sectionQuery = "SELECT DISTINCT section FROM librarybooks";
        try (PreparedStatement sectionStmt = conn.prepareStatement(sectionQuery);
             ResultSet sectionRs = sectionStmt.executeQuery()) {
            while (sectionRs.next()) {
                sections.add(sectionRs.getString("section"));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p class='error-message'>Error fetching sections: " + e.getMessage() + "</p>");
    }
%>

<html>
<head>
    <title>Issue a Book</title>
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
            background: #f8f8f8;
            color: #333;
            padding: 20px;
        }

/* Navbar Styling */
.navbar {
    display: flex;
    justify-content: center;
    gap: 30px; /* Increased spacing between links */
    padding: 15px 20px;
    background-color: #222; /* Dark background */
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);
    position: sticky;
    top: 0;
    z-index: 100;
    margin-bottom: 20px; /* Margin at the bottom */
    border-radius: 8px; /* Rounded corners */
}

/* Navbar Link Styling */
.nav-link {
    color: #eee;
    font-size: 16px;
    text-decoration: none;
    font-weight: bold;
    padding: 12px 20px; /* Increased padding for a more button-like feel */
    border-radius: 5px;
    transition: background-color 0.3s, color 0.3s, transform 0.2s; /* Added transform for scaling effect */
}

/* Navbar Link Hover Effect */
.nav-link:hover {
    background-color: rgba(255, 255, 255, 0.1); /* Slightly lighter background on hover */
    color: #fff;
    transform: scale(1.05); /* Scale up effect on hover */
    box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.4); /* Subtle shadow on hover */
}

        /* Dropdown Container */
        .dropdown-container {
            margin: 20px auto;
            text-align: center;
        }

        /* Book Grid Styling */
        .book-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .book-grid th, .book-grid td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }

        .book-grid th {
            background-color: #333;
            color: white;
        }

        .book-grid tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .book-grid tr:hover {
            background-color: #e0e0e0;
        }

        .branch-info {
            margin-top: 20px;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-top: 20px;
        }
    </style>
    <script>
        function branchSelected() {
            document.getElementById("branchForm").submit();
        }
    </script>
</head>
<body>
    <div class="navbar">
        <a href="studentwelcome.jsp" class="nav-link">Home</a>
        <a href="issueBook.jsp" class="nav-link">Issue Book</a>
        <a href="booksIssuedByAStudent.jsp" class="nav-link">Books Issued by You</a>
    </div>

    <div class="dropdown-container">
        <form method="post" action="issueBook.jsp" id="branchForm">
            <label for="branch-select">Select Branch:</label>
            <select id="branch-select" name="branch" onchange="branchSelected()">
                <option value="">Choose a branch...</option>
                <%
                    for (String section : sections) {
                %>
                <option value="<%= section %>" <%= section.equals(selectedBranch) ? "selected" : "" %>><%= section %></option>
                <%
                    }
                %>
            </select>
        </form>
    </div>

    <div class="branch-info">
        <%
            String studentId = "";
            String studentName = "";

            // Fetch student's ID and name based on email
            try (Connection conn = DBConnection.getConnection()) {
                String studentQuery = "SELECT student_id, student_name FROM studentslogin WHERE email = ?";
                try (PreparedStatement stmt = conn.prepareStatement(studentQuery)) {
                    stmt.setString(1, studentEmail);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            studentId = rs.getString("student_id");
                            studentName = rs.getString("student_name");
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p class='error-message'>Error fetching student information: " + e.getMessage() + "</p>");
            }

            if (!selectedBranch.isEmpty()) {
                try (Connection conn = DBConnection.getConnection()) {
                    String query = "SELECT * FROM librarybooks WHERE section = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(query)) {
                        stmt.setString(1, selectedBranch);
                        try (ResultSet rs = stmt.executeQuery()) {
                            out.println("<table class='book-grid'>");
                            out.println("<caption>Books in " + selectedBranch + " Section</caption>");
                            out.println("<tr><th>Book ID</th><th>Book Name</th><th>Author</th><th>Quantity</th><th>Section</th><th>Action</th></tr>");

                            while (rs.next()) {
                                int bookId = rs.getInt("book_id");
                                String bookName = rs.getString("book_name");
                                String author = rs.getString("author");
                                int quantity = rs.getInt("quantity");

                                out.println("<tr>");
                                out.println("<td>" + bookId + "</td>");
                                out.println("<td>" + bookName + "</td>");
                                out.println("<td>" + author + "</td>");
                                out.println("<td>" + quantity + "</td>");
                                out.println("<td>" + rs.getString("section") + "</td>");

                                // Check if the book is already issued by the user
                                String checkQuery = "SELECT COUNT(*) AS issuedCount FROM admincurrentbookissue WHERE book_id = ? AND student_id = ?";
                                try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                                    checkStmt.setInt(1, bookId);
                                    checkStmt.setString(2, studentId);

                                    try (ResultSet checkRs = checkStmt.executeQuery()) {
                                        if (checkRs.next() && checkRs.getInt("issuedCount") > 0) {
                                            // Book is already issued
                                            out.println("<td>Issued</td>");
                                        } else if (quantity > 0) {
                                            // Book is available to issue
                                            out.println("<td><form method='post' action='issueBook.jsp'>");
                                            out.println("<input type='hidden' name='bookId' value='" + bookId + "'>");
                                            out.println("<input type='hidden' name='bookName' value='" + bookName + "'>");
                                            out.println("<input type='hidden' name='action' value='issue'>");
                                            out.println("<input type='hidden' name='branch' value='" + selectedBranch + "'>");
                                            out.println("<button type='submit'>Issue</button>");
                                            out.println("</form></td>");
                                        } else {
                                            // Book is out of stock
                                            out.println("<td>Out of Stock</td>");
                                        }
                                    }
                                }
                                out.println("</tr>");
                            }
                            out.println("</table>");
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p class='error-message'>Database error: " + e.getMessage() + "</p>");
                }
            } else {
                out.println("<p>Please select a branch from the dropdown.</p>");
            }
        %>
    </div>

    <%
        String action = request.getParameter("action");
        String bookIdParam = request.getParameter("bookId");
        String bookNameParam = request.getParameter("bookName");

        if ("issue".equals(action) && bookIdParam != null) {
            int bookId = Integer.parseInt(bookIdParam);
            try (Connection conn = DBConnection.getConnection()) {
                // Update book quantity
                String updateQuery = "UPDATE librarybooks SET quantity = quantity - 1 WHERE book_id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                    updateStmt.setInt(1, bookId);
                    int rowsUpdated = updateStmt.executeUpdate();

                    if (rowsUpdated > 0) {
                        // Insert issue record into admincurrentbookissue
                        String insertQuery = "INSERT INTO admincurrentbookissue (book_id, book_name, student_id, student_name, issue_date, days_remaining, fine, status) VALUES (?, ?, ?, ?, NOW(), ?, 0, 'Pending')";
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                            insertStmt.setInt(1, bookId);
                            insertStmt.setString(2, bookNameParam);
                            insertStmt.setString(3, studentId);
                            insertStmt.setString(4, studentName);
                            insertStmt.setInt(5, 20); // days_remaining is initially 20
                            insertStmt.executeUpdate();
                        }
                        response.sendRedirect("issueBook.jsp?branch=" + selectedBranch);
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p class='error-message'>Error issuing the book: " + e.getMessage() + "</p>");
                }
            }
        }
    %>
</body>
</html>