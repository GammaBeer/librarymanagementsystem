<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.utils.DBConnection" %>
<html>
<head>
    <title>Book Issue History</title>
    <link rel="stylesheet" type="text/css" href="adminissuehistory.css">
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
    <h1>Book Issue History</h1>
    <table>
        <tr>
            <th>History ID</th>
            <th>Book ID</th>
            <th>Book Name</th>
            <th>Student ID</th>
            <th>Student Name</th>
            <th>Issue Date</th>
            <th>Return Date</th>
            <th>Fine</th>
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
                conn = DBConnection.getConnection();
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM adminhistory");

                while (rs.next()) {
                    int historyId = rs.getInt("history_id");
                    int bookId = rs.getInt("book_id");
                    String bookName = rs.getString("book_name");
                    String studentId = rs.getString("student_id");
                    String studentName = rs.getString("student_name");
                    Date issueDate = rs.getDate("issue_date");
                    Date returnDate = rs.getDate("return_date");
                    int fine = rs.getInt("fine");
        %>
        <tr>
            <td><%= historyId %></td>
            <td><%= bookId %></td>
            <td><%= bookName %></td>
            <td><%= studentId %></td>
            <td><%= studentName %></td>
            <td><%= issueDate %></td>
            <td><%= returnDate %></td>
            <td><%= fine %></td>
        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Ensure resources are closed
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</body>
</html>
