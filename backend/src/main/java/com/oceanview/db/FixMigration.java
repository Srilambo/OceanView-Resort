package com.oceanview.db;

import java.sql.*;

public class FixMigration {
    public static void main(String[] args) {
        try (Connection conn = DatabaseHelper.getConnection()) {
            System.out.println("🔄 Starting Migration...");
            Statement stmt = conn.createStatement();

            // 1. Ensure guests table has user_id
            boolean hasUserId = false;
            ResultSet rsCol = conn.getMetaData().getColumns(null, null, "guests", "user_id");
            if (rsCol.next())
                hasUserId = true;

            if (!hasUserId) {
                System.out.println("➕ Adding user_id to guests table...");
                stmt.execute("ALTER TABLE guests ADD COLUMN user_id VARCHAR(50)");
                stmt.execute(
                        "ALTER TABLE guests ADD CONSTRAINT fk_guest_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL");
            }

            // 2. Fix ID consistency for demo data
            System.out.println("🆔 Fixing ID consistency...");
            stmt.execute("SET FOREIGN_KEY_CHECKS = 0;");

            // Fix 'admin' IDs
            stmt.execute("UPDATE users SET user_id = 'admin-001' WHERE username = 'admin'");
            stmt.execute(
                    "UPDATE user_roles SET user_id = 'admin-001' WHERE user_id = 'user-admin-001' OR user_id = 'admin-001'");

            // Fix 'sri' IDs (User 002 style)
            stmt.execute("UPDATE users SET user_id = 'user-002' WHERE username = 'sri'");
            stmt.execute(
                    "UPDATE user_roles SET user_id = 'user-002' WHERE user_id = 'user-sri-001' OR user_id = 'user-002'");
            stmt.execute(
                    "UPDATE guests SET guest_id = 'guest-002', user_id = 'user-002' WHERE email = 'sri@oceanview.com'");
            stmt.execute(
                    "UPDATE reservations SET guest_id = 'guest-002' WHERE guest_id = 'guest-sri-001' OR guest_id = 'guest-002'");

            // Link any orphaned guests by email if user exists
            stmt.execute(
                    "UPDATE guests g JOIN users u ON g.email = u.email SET g.user_id = u.user_id WHERE g.user_id IS NULL");

            stmt.execute("SET FOREIGN_KEY_CHECKS = 1;");
            System.out.println("✅ Migration complete!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
