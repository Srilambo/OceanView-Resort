package com.oceanview.db;

import java.sql.*;

public class DatabaseHelper {

    // MariaDB/MySQL Connection Details
    private static final String DB_URL = "jdbc:mariadb://localhost:3306/oceanview";
    private static final String DB_USER = "root"; // Change if different
    private static final String DB_PASSWORD = ""; // Add password if set

    static {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            System.out.println("✅ MariaDB Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MariaDB Driver not found!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("✅ Connected to MariaDB");
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Database connection failed!");
            System.err.println("Make sure MariaDB is running and database 'oceanview' exists");
            throw e;
        }
    }

    // Test connection
    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Database connection successful!");

            // Test with a simple query
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM rooms");
            if (rs.next()) {
                System.out.println("✅ Total rooms: " + rs.getInt(1));
            }
        } catch (SQLException e) {
            System.err.println("❌ Connection test failed: " + e.getMessage());
        }
    }
}
