package com.oceanview.repository;

import com.oceanview.model.Guest;
import com.oceanview.db.DatabaseHelper;
import java.sql.*;
import java.util.*;

public class GuestRepository {

    public Guest save(Guest guest) throws SQLException {
        String sql = "INSERT INTO guests (guest_id, user_id, name, email, contact_number, address, id_type, id_number, nationality) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, guest.getGuestId());
            pstmt.setString(2, guest.getUserId());
            pstmt.setString(3, guest.getName());
            pstmt.setString(4, guest.getEmail());
            pstmt.setString(5, guest.getContactNumber());
            pstmt.setString(6, guest.getAddress());
            pstmt.setString(7, guest.getIdType());
            pstmt.setString(8, guest.getIdNumber());
            pstmt.setString(9, guest.getNationality());

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

    public Guest findByUserId(String userId) throws SQLException {
        String sql = "SELECT * FROM guests WHERE user_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);
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
                "address = ?, id_type = ?, id_number = ?, nationality = ?, user_id = ? WHERE guest_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, guest.getName());
            pstmt.setString(2, guest.getEmail());
            pstmt.setString(3, guest.getContactNumber());
            pstmt.setString(4, guest.getAddress());
            pstmt.setString(5, guest.getIdType());
            pstmt.setString(6, guest.getIdNumber());
            pstmt.setString(7, guest.getNationality());
            pstmt.setString(8, guest.getUserId());
            pstmt.setString(9, guest.getGuestId());

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
        Guest guest = new Guest();
        guest.setGuestId(rs.getString("guest_id"));
        guest.setUserId(rs.getString("user_id"));
        guest.setName(rs.getString("name"));
        guest.setEmail(rs.getString("email"));
        guest.setContactNumber(rs.getString("contact_number"));
        guest.setAddress(rs.getString("address"));
        guest.setIdType(rs.getString("id_type"));
        guest.setIdNumber(rs.getString("id_number"));
        guest.setNationality(rs.getString("nationality"));
        return guest;
    }
}
