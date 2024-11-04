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
    <link rel="stylesheet" href="issueBook.css">
</head>
<body>
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

    <script>
        function branchSelected() {
            document.getElementById("branchForm").submit();
        }
    </script>
</body>
</html>