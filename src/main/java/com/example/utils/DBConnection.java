package com.example.utils;

import java.sql.*;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/library";
    private static final String USER = "root"; // replace with your DB username
    private static final String PASSWORD = "1234"; // replace with your DB password
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("MySQL Driver not found");
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);

    }

}
