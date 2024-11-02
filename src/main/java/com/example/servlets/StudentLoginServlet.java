package com.example.servlets;

import com.example.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StudentLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        System.out.println(email);
        System.out.println(password);
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM studentslogin WHERE email = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                // Successful login
                request.getSession().setAttribute("email", email);
                response.sendRedirect("studentwelcome.jsp");
            } else {
                // Failed login
                response.sendRedirect("studentlogin.jsp?error=Invalid%20credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("studentlogin.jsp?error=Database%20error");
        }
    }
}
