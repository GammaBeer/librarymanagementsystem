<%@ page import="com.example.utils.DBConnection" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Books Issued by Student</title>
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


        /* Heading Styling */
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
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

        .no-books-message {
            text-align: center;
            color: #555;
            font-size: 1.1em;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="studentwelcome.jsp" class="nav-link">Home</a>
        <a href="issueBook.jsp" class="nav-link">Issue Book</a>
        <a href="booksIssuedByAStudent.jsp" class="nav-link">Books Issued by You</a>
    </div>

    <h1>Books Issued by You</h1>

    <%
        String studentEmail = (session != null) ? (String) session.getAttribute("studentEmail") : null;
        String studentId = null;

        if (studentEmail != null) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement idStmt = conn.prepareStatement("SELECT student_id FROM studentslogin WHERE email = ?")) {

                idStmt.setString(1, studentEmail);
                try (ResultSet idRs = idStmt.executeQuery()) {
                    if (idRs.next()) {
                        studentId = idRs.getString("student_id");
                    }
                }

                if (studentId != null) {
                    PreparedStatement bookStmt = conn.prepareStatement("SELECT book_id, book_name, issue_date FROM admincurrentbookissue WHERE student_id = ?");
                    bookStmt.setString(1, studentId);
                    try (ResultSet rs = bookStmt.executeQuery()) {
                        out.println("<table class='book-grid'>");
                        out.println("<tr><th>Book ID</th><th>Book Name</th><th>Issue Date</th></tr>");

                        boolean hasIssuedBooks = false;
                        while (rs.next()) {
                            hasIssuedBooks = true;
                            int bookId = rs.getInt("book_id");
                            String bookName = rs.getString("book_name");
                            String issueDate = rs.getString("issue_date");

                            out.println("<tr>");
                            out.println("<td>" + bookId + "</td>");
                            out.println("<td>" + bookName + "</td>");
                            out.println("<td>" + issueDate + "</td>");
                            out.println("</tr>");
                        }

                        out.println("</table>");

                        if (!hasIssuedBooks) {
                            out.println("<p class='no-books-message'>No books have been issued by you.</p>");
                        }
                    }
                } else {
                    out.println("<p class='no-books-message'>No student ID found for this email.</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p>Please log in to view your issued books.</p>");
        }
    %>
</body>
</html>
