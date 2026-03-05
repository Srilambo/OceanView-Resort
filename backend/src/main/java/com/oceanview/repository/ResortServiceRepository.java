package com.oceanview.repository;

import com.oceanview.model.ResortService;
import com.oceanview.db.DatabaseHelper;
import java.sql.*;
import java.util.*;

public class ResortServiceRepository {

    public List<ResortService> findAll() throws SQLException {
        String sql = "SELECT * FROM resort_services ORDER BY category, service_name";
        List<ResortService> services = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                services.add(mapResultSet(rs));
            }
        }
        return services;
    }

    public List<ResortService> findByCategory(String category) throws SQLException {
        String sql = "SELECT * FROM resort_services WHERE category = ? ORDER BY service_name";
        List<ResortService> services = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                services.add(mapResultSet(rs));
            }
        }
        return services;
    }

    public ResortService findById(String serviceId) throws SQLException {
        String sql = "SELECT * FROM resort_services WHERE service_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, serviceId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSet(rs);
            }
        }
        return null;
    }

    private ResortService mapResultSet(ResultSet rs) throws SQLException {
        return new ResortService(
                rs.getString("service_id"),
                rs.getString("service_name"),
                rs.getString("category"),
                rs.getString("description"),
                rs.getBigDecimal("price"),
                rs.getString("duration"),
                rs.getBoolean("available"),
                rs.getString("icon"));
    }
}
