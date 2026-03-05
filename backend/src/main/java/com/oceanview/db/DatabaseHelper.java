package com.oceanview.db;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.*;
import java.util.stream.Collectors;

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
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Database connection failed!");
            System.err.println("Make sure MariaDB is running and database 'oceanview' exists");
            throw e;
        }
    }

    public static void runSqlScript(String filePath) {
        System.out.println("📜 Running SQL script: " + filePath);
        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement();
                BufferedReader reader = new BufferedReader(new FileReader(filePath))) {

            String script = reader.lines().collect(Collectors.joining("\n"));
            String[] commands = script.split(";");

            for (String command : commands) {
                String cmd = command.trim();
                if (!cmd.isEmpty()) {
                    try {
                        stmt.execute(cmd);
                    } catch (SQLException e) {
                        System.err.println("⚠️ Error executing command: " + cmd);
                        System.err.println("❌ Error message: " + e.getMessage());
                    }
                }
            }
            System.out.println("✅ SQL script executed successfully!");

        } catch (Exception e) {
            System.err.println("❌ Failed to run SQL script: " + e.getMessage());
        }
    }

    // Test connection
    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Database connection successful!");

            // Automatically try to run schema if tables might be missing
            String schemaPath = "resources/schema.sql";
            // If running from backend root, this path should work.
            // Check if staff and tasks tables exists
            DatabaseMetaData dbm = conn.getMetaData();
            ResultSet staffTable = dbm.getTables(null, null, "staff", null);
            ResultSet tasksTable = dbm.getTables(null, null, "tasks", null);

            if (!staffTable.next() || !tasksTable.next()) {
                System.out.println("🔸 'staff' or 'tasks' table not found. Attempting to initialize database...");
                runSqlScript(schemaPath);
            } else {
                System.out.println("✅ 'staff' and 'tasks' tables exist.");
            }

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

    public static String generateId(String table, String idColumn, String prefix) throws SQLException {
        String sql = "SELECT " + idColumn + " FROM " + table + " WHERE " + idColumn + " LIKE '" + prefix
                + "-%' ORDER BY LENGTH(" + idColumn + ") DESC, " + idColumn + " DESC LIMIT 1";
        try (Connection conn = getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                String maxId = rs.getString(idColumn);
                try {
                    int num = Integer.parseInt(maxId.substring(prefix.length() + 1));
                    return prefix + "-" + String.format("%03d", num + 1);
                } catch (Exception e) {
                }
            }
        }
        return prefix + "-001";
    }
}
