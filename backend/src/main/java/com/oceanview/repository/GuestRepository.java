package com.oceanview.repository;

import com.oceanview.model.Guest;
import com.oceanview.db.DatabaseHelper;
import java.sql.*;
import java.util.*;

public class GuestRepository {

    public Guest save(Guest guest) throws SQLException {
        String sql = "INSERT INTO guests (guest_id, name, email, contact_number, address, passport_number) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, guest.getGuestId());
            pstmt.setString(2, guest.getName());
            pstmt.setString(3, guest.getEmail());
            pstmt.setString(4, guest.getContactNumber());
            pstmt.setString(5, guest.getAddress());
            pstmt.setString(6, guest.getPassportNumber());

            pstmt.executeUpdate();
            System.out.println("✅ Guest saved: " + guest.getGuestId());
            return guest;
        }
    }

    public Guest findById(String guestId) throws SQLException {
        String sql = "SELECT * FROM guests WHERE guest_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, guestId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToGuest(rs);
            }
        }
        return null;
    }

    public Guest findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM guests WHERE email = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToGuest(rs);
            }
        }
        return null;
    }

    public List<Guest> findAll() throws SQLException {
        String sql = "SELECT * FROM guests";
        List<Guest> guests = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                guests.add(mapResultSetToGuest(rs));
            }
        }
        return guests;
    }

    public Guest update(Guest guest) throws SQLException {
        String sql = "UPDATE guests SET name = ?, email = ?, contact_number = ?, " +
                "address = ?, passport_number = ? WHERE guest_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, guest.getName());
            pstmt.setString(2, guest.getEmail());
            pstmt.setString(3, guest.getContactNumber());
            pstmt.setString(4, guest.getAddress());
            pstmt.setString(5, guest.getPassportNumber());
            pstmt.setString(6, guest.getGuestId());

            pstmt.executeUpdate();
            System.out.println("✅ Guest updated: " + guest.getGuestId());
            return guest;
        }
    }

    public boolean delete(String guestId) throws SQLException {
        String sql = "DELETE FROM guests WHERE guest_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, guestId);
            int result = pstmt.executeUpdate();
            return result > 0;
        }
    }

    private Guest mapResultSetToGuest(ResultSet rs) throws SQLException {
        return new Guest(
                rs.getString("guest_id"),
                rs.getString("name"),
                rs.getString("email"),
                rs.getString("contact_number"),
                rs.getString("address"),
                rs.getString("passport_number"));
    }
}
