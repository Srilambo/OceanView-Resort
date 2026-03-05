package com.oceanview.repository;

import com.oceanview.db.DatabaseHelper;
import java.sql.*;
import java.util.*;

public class ReservationServiceRepository {

    /**
     * Adds a service to a reservation bill.
     */
    public void addServiceToReservation(String reservationId, String serviceId,
            String serviceName, double servicePrice, int quantity) throws SQLException {
        String sql = "INSERT INTO reservation_services (id, reservation_id, service_id, service_name, service_price, quantity) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, UUID.randomUUID().toString());
            pstmt.setString(2, reservationId);
            pstmt.setString(3, serviceId);
            pstmt.setString(4, serviceName);
            pstmt.setDouble(5, servicePrice);
            pstmt.setInt(6, quantity);
            pstmt.executeUpdate();
        }
    }

    /**
     * Fetches all service line items for a given reservation.
     */
    public List<Map<String, Object>> getServicesForReservation(String reservationId) throws SQLException {
        String sql = "SELECT id, service_id, service_name, service_price, quantity, added_at "
                + "FROM reservation_services WHERE reservation_id = ? ORDER BY added_at ASC";
        List<Map<String, Object>> items = new ArrayList<>();
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, reservationId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("id", rs.getString("id"));
                item.put("serviceId", rs.getString("service_id"));
                item.put("serviceName", rs.getString("service_name"));
                item.put("servicePrice", rs.getDouble("service_price"));
                item.put("quantity", rs.getInt("quantity"));
                item.put("lineTotal", rs.getDouble("service_price") * rs.getInt("quantity"));
                item.put("addedAt", rs.getTimestamp("added_at").toString());
                items.add(item);
            }
        }
        return items;
    }

    /**
     * Calculates the total of all services added to the reservation.
     */
    public double getTotalServicesAmount(String reservationId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(service_price * quantity), 0) AS total "
                + "FROM reservation_services WHERE reservation_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, reservationId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        }
        return 0.0;
    }

    /**
     * Updates the payment info (method + status) for a reservation at checkout.
     */
    public void updatePaymentOnCheckout(String reservationId, String paymentMethod) throws SQLException {
        String sql = "UPDATE reservations SET payment_method = ?, payment_status = 'PAID', "
                + "actual_check_out = ?, status = 'COMPLETED', updated_at = CURRENT_TIMESTAMP "
                + "WHERE reservation_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, paymentMethod);
            pstmt.setTimestamp(2, Timestamp.valueOf(java.time.LocalDateTime.now()));
            pstmt.setString(3, reservationId);
            pstmt.executeUpdate();
        }
    }
}
