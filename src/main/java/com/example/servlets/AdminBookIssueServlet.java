package com.example.servlets;

import com.example.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class AdminBookIssueServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("issueBook".equals(action)) {
                // Issue Book Logic
                issueBook(conn, request, response);
            } else if ("returnBook".equals(action)) {
                // Return Book Logic
                returnBook(conn, request, response);

            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    private void issueBook(Connection conn, HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        // Get parameters
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        String bookName = request.getParameter("bookName");
        String studentId = request.getParameter("student_id");
        String studentName = request.getParameter("studentName");

        LocalDate issueDate = LocalDate.now();
        int daysRemaining = 20;

        String sql = "INSERT INTO admincurrentbookissue (book_id, book_name, student_id, student_name, issue_date, days_remaining, fine, status) VALUES (?, ?, ?, ?, ?, ?, 0, 'Pending')";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            stmt.setString(2, bookName);
            stmt.setString(3, studentId);
            stmt.setString(4, studentName);
            stmt.setDate(5, Date.valueOf(issueDate));
            stmt.setInt(6, daysRemaining);
            stmt.executeUpdate();
        }

        response.sendRedirect("adminissuebooklist.jsp");
    }

    private void returnBook(Connection conn, HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int issueId = Integer.parseInt(request.getParameter("issueId"));

        // Get current details of the book issue
        String selectSql = "SELECT * FROM admincurrentbookissue WHERE issue_id = ?";
        try (PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {
            selectStmt.setInt(1, issueId);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                int bookId = rs.getInt("book_id");
                String bookName = rs.getString("book_name");
                String studentId = rs.getString("student_id");
                String studentName = rs.getString("student_name");
                LocalDate issueDate = rs.getDate("issue_date").toLocalDate();

                LocalDate returnDate = LocalDate.now();
                long daysOverdue = ChronoUnit.DAYS.between(issueDate, returnDate) - 20;
                int fine = daysOverdue > 0 ? (int) daysOverdue * 5 : 0;

                // Insert into history table
                String insertHistorySql = "INSERT INTO adminhistory (book_id, book_name, student_id, student_name, issue_date, return_date, fine) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement historyStmt = conn.prepareStatement(insertHistorySql)) {
                    historyStmt.setInt(1, bookId);
                    historyStmt.setString(2, bookName);
                    historyStmt.setString(3, studentId);
                    historyStmt.setString(4, studentName);
                    historyStmt.setDate(5, Date.valueOf(issueDate));
                    historyStmt.setDate(6, Date.valueOf(returnDate));
                    historyStmt.setInt(7, fine);
                    historyStmt.executeUpdate();
                }

                // Delete from currentbookissue table
                String deleteCurrentSql = "DELETE FROM admincurrentbookissue WHERE issue_id = ?";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteCurrentSql)) {
                    deleteStmt.setInt(1, issueId);
                    deleteStmt.executeUpdate();
                }
            }
        }

        response.sendRedirect("adminissuebooklist.jsp");
    }
}
