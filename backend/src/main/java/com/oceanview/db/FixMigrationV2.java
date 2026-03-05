package com.oceanview.db;

import java.sql.*;

public class FixMigrationV2 {
    public static void main(String[] args) {
        try (Connection conn = DatabaseHelper.getConnection()) {
            System.out.println("🔄 Starting Migration V2...");

            Statement stmt = conn.createStatement();

            // 1. Ensure guests table has user_id
            try {
                stmt.execute("ALTER TABLE guests ADD COLUMN user_id VARCHAR(50)");
                System.out.println("➕ Added user_id column");
            } catch (SQLException e) {
                System.out.println("ℹ️ user_id column already exists");
            }

            // 2. Fix 'passport_number' to 'id_number' if it exists
            try {
                stmt.execute("ALTER TABLE guests CHANGE passport_number id_number VARCHAR(50)");
                System.out.println("📝 Renamed passport_number to id_number");
            } catch (SQLException e) {
                System.out.println("ℹ️ id_number already handled or passport_number does not exist");
            }

            // 3. Fix IDs to be consistent
            System.out.println("🆔 Fixing ID consistency...");
            stmt.execute("SET FOREIGN_KEY_CHECKS = 0;");

            // Fix User 'sri' ID
            stmt.execute("UPDATE users SET user_id = 'user-002' WHERE username = 'sri'");
            stmt.execute(
                    "UPDATE user_roles SET user_id = 'user-002' WHERE user_id = 'user-sri-001' OR user_id = 'user-002'");

            // Fix Guest 'sri' ID and User ID link
            stmt.execute(
                    "UPDATE guests SET guest_id = 'guest-002', user_id = 'user-002' WHERE email = 'sri@oceanview.com'");

            // Update Reservation links
            stmt.execute("UPDATE reservations SET guest_id = 'guest-002' WHERE guest_id = 'guest-sri-001'");

            // Update any missing user_id links in guests table
            stmt.execute(
                    "UPDATE guests g JOIN users u ON g.email = u.email SET g.user_id = u.user_id WHERE g.user_id IS NULL");

            stmt.execute("SET FOREIGN_KEY_CHECKS = 1;");
            System.out.println("✅ Migration complete!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
