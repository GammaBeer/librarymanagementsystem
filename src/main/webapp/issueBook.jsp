<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Move selectedBranch definition here so it’s available globally
    String selectedBranch = request.getParameter("branch");
    if (selectedBranch == null) {
        selectedBranch = ""; // Default to an empty string if no branch selected
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
                <option value="CSE" <%= "CSE".equals(selectedBranch) ? "selected" : "" %>>CSE</option>
                <option value="EE" <%= "EE".equals(selectedBranch) ? "selected" : "" %>>EE</option>
                <option value="ECE" <%= "ECE".equals(selectedBranch) ? "selected" : "" %>>ECE</option>
                <option value="ME" <%= "ME".equals(selectedBranch) ? "selected" : "" %>>ME</option>
                <option value="AE" <%= "AE".equals(selectedBranch) ? "selected" : "" %>>AE</option>
            </select>
        </form>
    </div>

    <div class="branch-info">
        <%
            String studentEmail = "hey@hey.com";  // Example student email
            if (!selectedBranch.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "1234");

                    String query = "SELECT * FROM librarybooks WHERE section = ?";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setString(1, selectedBranch);
                    ResultSet rs = stmt.executeQuery();

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

                        // Check if the student has already issued the book
                        String checkQuery = "SELECT COUNT(*) AS issuedCount FROM issued_books WHERE book_id = ? AND student_email = ?";
                        PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                        checkStmt.setInt(1, bookId);
                        checkStmt.setString(2, studentEmail);
                        ResultSet checkRs = checkStmt.executeQuery();

                        if (checkRs.next() && checkRs.getInt("issuedCount") > 0) {
                            out.println("<td>Issued</td>");
                        } else if (quantity > 0) {
                            out.println("<td><form method='post' action='issueBook.jsp'>");
                            out.println("<input type='hidden' name='bookId' value='" + bookId + "'>");
                            out.println("<input type='hidden' name='action' value='issue'>");
                            out.println("<input type='hidden' name='branch' value='" + selectedBranch + "'>");
                            out.println("<button type='submit'>Issue</button>");
                            out.println("</form></td>");
                        } else {
                            out.println("<td>Issued</td>");
                        }

                        checkStmt.close();
                        out.println("</tr>");
                    }

                    out.println("</table>");
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("Database error: " + e.getMessage());
                }
            } else {
                out.println("<p>Please select a branch from the dropdown.</p>");
            }
        %>
    </div>

    <%
        String action = request.getParameter("action");
        String bookIdParam = request.getParameter("bookId");

        if ("issue".equals(action) && bookIdParam != null) {
            int bookId = Integer.parseInt(bookIdParam);
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library", "root", "1234");

                String updateQuery = "UPDATE librarybooks SET quantity = quantity - 1 WHERE book_id = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                updateStmt.setInt(1, bookId);
                int rowsUpdated = updateStmt.executeUpdate();

                if (rowsUpdated > 0) {
                    String bookNameQuery = "SELECT book_name FROM librarybooks WHERE book_id = ?";
                    PreparedStatement nameStmt = conn.prepareStatement(bookNameQuery);
                    nameStmt.setInt(1, bookId);
                    ResultSet nameRs = nameStmt.executeQuery();

                    if (nameRs.next()) {
                        String bookName = nameRs.getString("book_name");

                        String insertQuery = "INSERT INTO issued_books (book_id, student_email, issue_date, book_name) VALUES (?, ?, NOW(), ?)";
                        PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                        insertStmt.setInt(1, bookId);
                        insertStmt.setString(2, studentEmail);
                        insertStmt.setString(3, bookName);
                        insertStmt.executeUpdate();
                        insertStmt.close();
                    }
                    nameStmt.close();
                }

                updateStmt.close();
                conn.close();

                response.sendRedirect("issueBook.jsp?branch=" + selectedBranch);
            } catch (Exception e) {
                e.printStackTrace();
                out.println("Error issuing the book: " + e.getMessage());
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
