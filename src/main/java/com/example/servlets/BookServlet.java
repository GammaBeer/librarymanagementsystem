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
                // Add functionality (remains the same)
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
                String bookIdStr = request.getParameter("bookId");

                if (bookIdStr != null && !bookIdStr.isEmpty()) {
                    int bookId = Integer.parseInt(bookIdStr);
                    String newBookName = request.getParameter("newBookName");
                    String newAuthor = request.getParameter("newAuthor");
                    String newQuantityStr = request.getParameter("newQuantity");
                    String newSection = request.getParameter("newSection");

                    // Building the SQL update dynamically
                    StringBuilder sql = new StringBuilder("UPDATE LIBRARYBOOKS SET ");
                    ArrayList<String> updates = new ArrayList<>();
                    ArrayList<Object> parameters = new ArrayList<>();

                    if (newBookName != null && !newBookName.isEmpty()) {
                        updates.add("book_name = ?");
                        parameters.add(newBookName);
                    }
                    if (newAuthor != null && !newAuthor.isEmpty()) {
                        updates.add("author = ?");
                        parameters.add(newAuthor);
                    }
                    if (newQuantityStr != null && !newQuantityStr.isEmpty()) {
                        try {
                            int newQuantity = Integer.parseInt(newQuantityStr);
                            updates.add("quantity = ?");
                            parameters.add(newQuantity);
                        } catch (NumberFormatException e) {
                            System.out.println("Invalid quantity provided: " + newQuantityStr);
                            // Log the error or handle invalid input if necessary
                        }
                    }
                    if (newSection != null && !newSection.isEmpty()) {
                        updates.add("section = ?");
                        parameters.add(newSection);
                    }

                    // Only proceed if we have fields to update
                    if (!updates.isEmpty()) {
                        sql.append(String.join(", ", updates));
                        sql.append(" WHERE book_id = ?");
                        parameters.add(bookId);

                        System.out.println("Executing SQL: " + sql.toString()); // Debugging SQL
                        System.out.println("With Parameters: " + parameters);   // Debugging Parameters

                        PreparedStatement stmt = conn.prepareStatement(sql.toString());
                        for (int i = 0; i < parameters.size(); i++) {
                            stmt.setObject(i + 1, parameters.get(i));
                        }
                        int rowsUpdated = stmt.executeUpdate();
                        System.out.println("Rows updated: " + rowsUpdated);
                    } else {
                        System.out.println("No fields to update for book_id: " + bookId);
                    }
                }

            } else if ("delete".equals(action)) {
                // Delete functionality (remains the same)
                String searchBookName = request.getParameter("searchBookName");

                String sql = "DELETE FROM LIBRARYBOOKS WHERE book_name = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, searchBookName);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Redirect back to the view page after updating
        response.sendRedirect("BookServlet");
    }

}
