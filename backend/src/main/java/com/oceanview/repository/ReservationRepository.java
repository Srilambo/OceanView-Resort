package com.oceanview.repository;

import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
import com.oceanview.model.Room;
import com.oceanview.db.DatabaseHelper;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class ReservationRepository {

    public Reservation save(Reservation reservation) throws SQLException {
        String sql = "INSERT INTO reservations (reservation_id, reservation_number, guest_id, room_id, " +
                "check_in_date, check_out_date, number_of_nights, total_cost, status, special_requests) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservation.getReservationId());
            pstmt.setString(2, reservation.getReservationNumber());
            pstmt.setString(3, reservation.getGuest().getGuestId());
            pstmt.setString(4, reservation.getRoom().getRoomId());
            pstmt.setString(5, reservation.getCheckInDate().toString());
            pstmt.setString(6, reservation.getCheckOutDate().toString());
            pstmt.setInt(7, reservation.getNumberOfNights());
            pstmt.setBigDecimal(8, reservation.getTotalCost());
            pstmt.setString(9, reservation.getStatus());
            pstmt.setString(10, reservation.getSpecialRequests());

            pstmt.executeUpdate();
            System.out.println("✅ Reservation saved: " + reservation.getReservationNumber());
            return reservation;
        }
    }

    public Reservation findById(String reservationId) throws SQLException {
        String sql = "SELECT r.*, g.name as guest_name, g.email, " +
                "rm.room_number, rm.room_type, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE r.reservation_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservationId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
        }
        return null;
    }

    public Reservation findByReservationNumber(String reservationNumber) throws SQLException {
        String sql = "SELECT r.*, g.name as guest_name, g.email, g.contact_number, " +
                "rm.room_number, rm.room_type, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE r.reservation_number = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservationNumber);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToReservation(rs);
            }
        }
        return null;
    }

    public List<Reservation> findByGuestId(String guestId) throws SQLException {
        String sql = "SELECT r.*, g.name as guest_name, g.email, " +
                "rm.room_number, rm.room_type, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE r.guest_id = ? ORDER BY r.created_at DESC";

        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, guestId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        }
        return reservations;
    }

    public List<Reservation> findOverlappingReservations(String roomId, LocalDate checkIn, LocalDate checkOut)
            throws SQLException {

        String sql = "SELECT r.*, g.name as guest_name, g.email, " +
                "rm.room_number, rm.room_type, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE r.room_id = ? " +
                "AND r.status != 'CANCELLED' " +
                "AND r.check_out_date > ? " +
                "AND r.check_in_date < ?";

        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, roomId);
            pstmt.setString(2, checkIn.toString());
            pstmt.setString(3, checkOut.toString());

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        }
        return reservations;
    }

    public List<Reservation> findAll() throws SQLException {
        String sql = "SELECT r.*, g.name as guest_name, g.email, " +
                "rm.room_number, rm.room_type, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id";

        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        }
        return reservations;
    }

    public Reservation update(Reservation reservation) throws SQLException {
        String sql = "UPDATE reservations SET status = ?, special_requests = ?, " +
                "updated_at = CURRENT_TIMESTAMP WHERE reservation_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservation.getStatus());
            pstmt.setString(2, reservation.getSpecialRequests());
            pstmt.setString(3, reservation.getReservationId());

            pstmt.executeUpdate();
            System.out.println("✅ Reservation updated: " + reservation.getReservationNumber());
            return reservation;
        }
    }

    public boolean delete(String reservationId) throws SQLException {
        String sql = "DELETE FROM reservations WHERE reservation_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservationId);
            int result = pstmt.executeUpdate();
            return result > 0;
        }
    }

    private Reservation mapResultSetToReservation(ResultSet rs) throws SQLException {
        Guest guest = new Guest();
        guest.setGuestId(rs.getString("guest_id"));
        guest.setName(rs.getString("guest_name"));
        guest.setEmail(rs.getString("email"));

        Room room = new Room();
        room.setRoomId(rs.getString("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(rs.getString("room_type"));
        room.setPricePerNight(rs.getBigDecimal("price_per_night"));

        Reservation res = new Reservation();
        res.setReservationId(rs.getString("reservation_id"));
        res.setReservationNumber(rs.getString("reservation_number"));
        res.setGuest(guest);
        res.setRoom(room);
        res.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        res.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        res.setNumberOfNights(rs.getInt("number_of_nights"));
        res.setTotalCost(rs.getBigDecimal("total_cost"));
        res.setStatus(rs.getString("status"));
        res.setSpecialRequests(rs.getString("special_requests"));

        return res;
    }
}
