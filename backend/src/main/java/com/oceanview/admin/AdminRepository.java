package com.oceanview.admin;

import com.oceanview.db.DatabaseHelper;
import java.sql.*;

public class AdminRepository {

    public int getTotalReservationsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations";
        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(total_cost) FROM reservations WHERE status != 'CANCELLED'";
        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public int getAvailableRoomsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE available = TRUE";
        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
