package com.oceanview.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FixIdsDatabase {
    public static void main(String[] args) {
        try (Connection conn = DatabaseHelper.getConnection()) {
            System.out.println("Fixing UUIDs in users table...");

            String queryUsers = "SELECT u.user_id, ur.role FROM users u " +
                    "LEFT JOIN user_roles ur ON u.user_id = ur.user_id " +
                    "WHERE CHAR_LENGTH(u.user_id) = 36";

            try (PreparedStatement pstmt = conn.prepareStatement(queryUsers);
                    ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    String oldId = rs.getString("user_id");
                    String role = rs.getString("role");

                    String prefix = "user";
                    if (role != null) {
                        if (role.equals("ROLE_ADMIN"))
                            prefix = "admin";
                        else if (role.equals("ROLE_STAFF") || role.equals("ROLE_MANAGER"))
                            prefix = "staff-user";
                    }

                    String newId = DatabaseHelper.generateId("users", "user_id", prefix);

                    System.out.println("Renaming user " + oldId + " to " + newId);

                    // Disable foreign key checks to update
                    conn.createStatement().execute("SET FOREIGN_KEY_CHECKS=0");

                    PreparedStatement updateUsers = conn
                            .prepareStatement("UPDATE users SET user_id = ? WHERE user_id = ?");
                    updateUsers.setString(1, newId);
                    updateUsers.setString(2, oldId);
                    updateUsers.executeUpdate();

                    PreparedStatement updateRoles = conn
                            .prepareStatement("UPDATE user_roles SET user_id = ? WHERE user_id = ?");
                    updateRoles.setString(1, newId);
                    updateRoles.setString(2, oldId);
                    updateRoles.executeUpdate();

                    PreparedStatement updateStaff = conn
                            .prepareStatement("UPDATE staff SET user_id = ? WHERE user_id = ?");
                    updateStaff.setString(1, newId);
                    updateStaff.setString(2, oldId);
                    updateStaff.executeUpdate();

                    conn.createStatement().execute("SET FOREIGN_KEY_CHECKS=1");
                }
            }

            System.out.println("Fixing UUIDs in staff table...");
            String queryStaff = "SELECT staff_id FROM staff WHERE CHAR_LENGTH(staff_id) = 36";
            try (PreparedStatement pstmt = conn.prepareStatement(queryStaff);
                    ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    String oldId = rs.getString("staff_id");
                    String newId = DatabaseHelper.generateId("staff", "staff_id", "staff");

                    System.out.println("Renaming staff " + oldId + " to " + newId);

                    conn.createStatement().execute("SET FOREIGN_KEY_CHECKS=0");

                    PreparedStatement updateStaff = conn
                            .prepareStatement("UPDATE staff SET staff_id = ? WHERE staff_id = ?");
                    updateStaff.setString(1, newId);
                    updateStaff.setString(2, oldId);
                    updateStaff.executeUpdate();

                    PreparedStatement updateTasks = conn
                            .prepareStatement("UPDATE tasks SET assigned_to = ? WHERE assigned_to = ?");
                    updateTasks.setString(1, newId);
                    updateTasks.setString(2, oldId);
                    updateTasks.executeUpdate();

                    conn.createStatement().execute("SET FOREIGN_KEY_CHECKS=1");
                }
            }

            System.out.println("Database IDs fixed.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
