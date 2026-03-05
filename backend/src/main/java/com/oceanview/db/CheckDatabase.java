package com.oceanview.db;

import java.sql.*;

public class CheckDatabase {
    public static void main(String[] args) {
        try (Connection conn = DatabaseHelper.getConnection()) {
            System.out.println("--- USERS ---");
            ResultSet rsUsers = conn.createStatement().executeQuery("SELECT * FROM users");
            while (rsUsers.next()) {
                System.out.println(
                        "ID: " + rsUsers.getString("user_id") + ", Username: " + rsUsers.getString("username"));
            }

            System.out.println("\n--- GUESTS ---");
            ResultSet rsGuests = conn.createStatement().executeQuery("SELECT * FROM guests");
            while (rsGuests.next()) {
                System.out.println("ID: " + rsGuests.getString("guest_id") + ", UserID: "
                        + rsGuests.getString("user_id") + ", Name: " + rsGuests.getString("name"));
            }

            System.out.println("\n--- ROLES ---");
            ResultSet rsRoles = conn.createStatement().executeQuery("SELECT * FROM user_roles");
            while (rsRoles.next()) {
                System.out.println("UserID: " + rsRoles.getString("user_id") + ", Role: " + rsRoles.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
