package com.oceanview;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestDB {
    public static void main(String[] args) throws Exception {
        Class.forName("org.mariadb.jdbc.Driver");
        try (Connection c = DriverManager.getConnection("jdbc:mariadb://localhost:3306/oceanview", "root", "");
                Statement s = c.createStatement()) {

            ResultSet rs = s.executeQuery("SELECT * FROM reservations WHERE room_id = 'room-101'");
            while (rs.next()) {
                System.out.println("ID: " + rs.getString("reservation_id") +
                        ", CheckIn: " + rs.getTimestamp("check_in_date") +
                        ", CheckOut: " + rs.getTimestamp("check_out_date") +
                        ", Status: " + rs.getString("status"));
            }

        }
    }
}
