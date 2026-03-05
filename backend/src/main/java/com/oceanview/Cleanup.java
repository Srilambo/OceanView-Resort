package com.oceanview;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class Cleanup {
    public static void main(String[] args) throws Exception {
        Class.forName("org.mariadb.jdbc.Driver");
        try (Connection c = DriverManager.getConnection("jdbc:mariadb://localhost:3306/oceanview", "root", "");
                Statement s = c.createStatement()) {

            // Wipe ALL reservations so user can start fresh
            int rows = s.executeUpdate("DELETE FROM reservations");
            System.out.println("✅ Cleaned up " + rows + " reservations.");

            // Clean up extra rooms
            int extraRooms = s.executeUpdate(
                    "DELETE FROM rooms WHERE room_id NOT IN ('room-101', 'room-102', 'room-201', 'room-202', 'room-401')");
            System.out.println("✅ Cleaned up " + extraRooms + " extra rooms.");

            // Set all real rooms to available
            s.executeUpdate("UPDATE rooms SET available = true");
            System.out.println("✅ All real rooms reset to AVAILABLE.");
        }
    }
}
