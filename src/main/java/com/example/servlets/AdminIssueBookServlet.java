package com.example.servlets;

import com.example.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;

public class AdminIssueBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("In adminIssueBookServlet");
        String bookId = request.getParameter("bookId");
        String bookName = request.getParameter("bookName");
        String studentId = request.getParameter("studentId");
        String studentName = request.getParameter("studentName");

        LocalDate issueDate = LocalDate.now();
        LocalDate dueDate = issueDate.plusDays(20); // 20-day loan period
        int daysRemaining = 20; // Initially, all days are remaining

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO admincurrentbookissue (book_id, book_name, student_id, student_name, issue_date, days_remaining, fine, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 0, 'Pending')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, bookId);
            stmt.setString(2, bookName);
            stmt.setString(3, studentId);
            stmt.setString(4, studentName);
            stmt.setDate(5, java.sql.Date.valueOf(issueDate));
            stmt.setInt(6, daysRemaining); // Set days remaining

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("adminissuebooklist.jsp?message=Book issued successfully");
            } else {
                response.sendRedirect("adminissuebook.jsp?error=Failed to issue book");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminissuebook.jsp?error=Database error");
        }
    }
}
