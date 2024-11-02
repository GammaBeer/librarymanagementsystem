package com.example.servlets;

import com.example.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class BookServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<HashMap<String, Object>> books = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM LIBRARYBOOKS";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                HashMap<String, Object> bookData = new HashMap<>();
                bookData.put("book_id", rs.getInt("book_id"));
                bookData.put("book_name", rs.getString("book_name"));
                bookData.put("author", rs.getString("author"));
                bookData.put("quantity", rs.getInt("quantity"));
                bookData.put("section", rs.getString("section"));
                books.add(bookData);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        request.setAttribute("books", books);
        // Forward to the JSP directly without additional redirects
        request.getRequestDispatcher("adminbookCRUD.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("add".equals(action)) {
                String bookName = request.getParameter("bookName");
                String author = request.getParameter("author");
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String section = request.getParameter("section");

                String sql = "INSERT INTO LIBRARYBOOKS (book_name, author, quantity, section) VALUES (?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, bookName);
                stmt.setString(2, author);
                stmt.setInt(3, quantity);
                stmt.setString(4, section);
                stmt.executeUpdate();
            } else if ("update".equals(action)) {
                String searchBookName = request.getParameter("searchBookName");
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                String sql = "UPDATE LIBRARYBOOKS SET quantity = ? WHERE book_name = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, quantity);
                stmt.setString(2, searchBookName);
                stmt.executeUpdate();
            } else if ("delete".equals(action)) {
                String searchBookName = request.getParameter("searchBookName");

                String sql = "DELETE FROM LIBRARYBOOKS WHERE book_name = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, searchBookName);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("BookServlet");
    }
}
