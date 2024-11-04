<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.utils.DBConnection" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<html>
<head>
    <title>Current Book Issues</title>
    <link rel="stylesheet" type="text/css" href="adminissuebooklist.css">
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
    <h1>Current Book Issues</h1>
    <table>
        <tr>
            <th>Issue ID</th>
            <th>Book ID</th>
            <th>Book Name</th>
            <th>Student ID</th>
            <th>Student Name</th>
            <th>Issue Date</th>
            <th>Days Remaining</th>
            <th>Fine</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;
            try {
                conn = DBConnection.getConnection();
                stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM admincurrentbookissue");
                System.out.println("in printing statement");

                // Get the current date
                Calendar cal = Calendar.getInstance();
                Date currentDate = cal.getTime();

                while (rs.next()) {
                    int issueId = rs.getInt("issue_id");
                    int bookId = rs.getInt("book_id");
                    String bookName = rs.getString("book_name");
                    String studentId = rs.getString("student_id");
                    String studentName = rs.getString("student_name");
                    Date issueDate = rs.getDate("issue_date");

                    // Calculate days since issue
                    long differenceInMillis = currentDate.getTime() - issueDate.getTime();
                    long daysSinceIssue = differenceInMillis / (1000 * 60 * 60 * 24); // Convert millis to days

                    // Calculate fine
                    int fine = 0;
                    if (daysSinceIssue > 20) {
                        fine = (int) (daysSinceIssue * 5); // 5 rupees per day for days over 20
                    }

                    // Calculate days remaining
                    int daysRemaining = (int) Math.max(20 - daysSinceIssue, 0); // Days remaining

                    String status = rs.getString("status");
        %>
        <tr>
            <td><%= issueId %></td>
            <td><%= bookId %></td>
            <td><%= bookName %></td>
            <td><%= studentId %></td>
            <td><%= studentName %></td>
            <td><%= issueDate %></td>
            <td><%= daysRemaining %></td>
            <td><%= fine %></td>
            <td><%= status %></td>
            <td>
                <form action="AdminBookIssueServlet" method="post">
                    <input type="hidden" name="action" value="returnBook">
                    <input type="hidden" name="issueId" value="<%= issueId %>">
                    <button type="submit">Return</button>
                </form>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</body>
</html>
