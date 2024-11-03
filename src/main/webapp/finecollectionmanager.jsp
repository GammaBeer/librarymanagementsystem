<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.utils.DBConnection" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<html>
<head>
    <title>Fine Collection Manager</title>
    <link rel="stylesheet" type="text/css" href="finecollectionmanager.css">
</head>
<body>
    <h1>Fine Collection Manager</h1>
    <table>
        <tr>
            <th>Issue ID</th>
            <th>Book ID</th>
            <th>Book Name</th>
            <th>Student ID</th>
            <th>Student Name</th>
            <th>Issue Date</th>
            <th>Days Overdue</th>
            <th>Fine</th>
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;

            try {
                conn = DBConnection.getConnection();
                stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM admincurrentbookissue");

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
                    System.out.println(daysSinceIssue);
                    // Calculate fine if overdue
                    int fine = 0;
                    if (daysSinceIssue > 20) {
                        fine = (int) (daysSinceIssue * 5); // 5 rupees per day for days over 20
                    } else {
                        continue; // Skip if not overdue
                    }

        %>
        <tr>
            <td><%= issueId %></td>
            <td><%= bookId %></td>
            <td><%= bookName %></td>
            <td><%= studentId %></td>
            <td><%= studentName %></td>
            <td><%= issueDate %></td>
            <td><%= daysSinceIssue %></td>
            <td><%= fine %></td>
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
