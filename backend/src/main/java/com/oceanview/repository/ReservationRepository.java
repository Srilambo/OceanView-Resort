package com.oceanview.repository;

import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
import com.oceanview.model.Room;
import com.oceanview.db.DatabaseHelper;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class ReservationRepository {

    public Reservation save(Reservation reservation) throws SQLException {
        String sql = "INSERT INTO reservations (reservation_id, reservation_number, guest_id, room_id, " +
                "check_in_date, check_out_date, actual_check_in, actual_check_out, number_of_nights, total_cost, status, special_requests, payment_method, payment_status) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservation.getReservationId());
            pstmt.setString(2, reservation.getReservationNumber());
            pstmt.setString(3, reservation.getGuest().getGuestId());
            pstmt.setString(4, reservation.getRoom().getRoomId());
            pstmt.setTimestamp(5, Timestamp.valueOf(reservation.getCheckInDate()));
            pstmt.setTimestamp(6, Timestamp.valueOf(reservation.getCheckOutDate()));
            pstmt.setTimestamp(7,
                    reservation.getActualCheckIn() != null ? Timestamp.valueOf(reservation.getActualCheckIn()) : null);
            pstmt.setTimestamp(8,
                    reservation.getActualCheckOut() != null ? Timestamp.valueOf(reservation.getActualCheckOut())
                            : null);
            pstmt.setInt(9, reservation.getNumberOfNights());
            pstmt.setBigDecimal(10, reservation.getTotalCost());
            pstmt.setString(11, reservation.getStatus());
            pstmt.setString(12, reservation.getSpecialRequests());
            pstmt.setString(13, reservation.getPaymentMethod());
            pstmt.setString(14, reservation.getPaymentStatus());

            pstmt.executeUpdate();
            System.out.println("✅ Reservation saved: " + reservation.getReservationNumber());
            return reservation;
        }
    }

    public Reservation findById(String reservationId) throws SQLException {
        String sql = "SELECT r.*, g.name as guest_name, g.email, g.contact_number, g.address, g.id_type, g.id_number, g.nationality, "
                +
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
        String sql = "SELECT r.*, g.name as guest_name, g.email, g.contact_number, g.address, g.id_type, g.id_number, g.nationality, "
                +
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
        String sql = "SELECT r.*, g.name as guest_name, g.email, g.contact_number, g.address, g.id_type, g.id_number, g.nationality, "
                +
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

    public List<Reservation> findOverlappingReservations(String roomId, LocalDateTime checkIn, LocalDateTime checkOut)
            throws SQLException {

        String sql = "SELECT r.*, g.name as guest_name, g.email, g.contact_number, g.address, g.id_type, g.id_number, g.nationality, "
                +
                "rm.room_number, rm.room_type, rm.price_per_night " +
                "FROM reservations r " +
                "JOIN guests g ON r.guest_id = g.guest_id " +
                "JOIN rooms rm ON r.room_id = rm.room_id " +
                "WHERE r.room_id = ? " +
                "AND r.status NOT IN ('CANCELLED', 'COMPLETED') " +
                "AND r.check_out_date > ? " +
                "AND r.check_in_date < ?";

        List<Reservation> reservations = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, roomId);
            pstmt.setTimestamp(2, Timestamp.valueOf(checkIn));
            pstmt.setTimestamp(3, Timestamp.valueOf(checkOut));

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                reservations.add(mapResultSetToReservation(rs));
            }
        }
        return reservations;
    }

    public List<Reservation> findAll() throws SQLException {
        String sql = "SELECT r.*, g.name as guest_name, g.email, g.contact_number, g.address, g.id_type, g.id_number, g.nationality, "
                +
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
                "actual_check_in = ?, actual_check_out = ?, " +
                "updated_at = CURRENT_TIMESTAMP WHERE reservation_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservation.getStatus());
            pstmt.setString(2, reservation.getSpecialRequests());
            pstmt.setTimestamp(3,
                    reservation.getActualCheckIn() != null ? Timestamp.valueOf(reservation.getActualCheckIn()) : null);
            pstmt.setTimestamp(4,
                    reservation.getActualCheckOut() != null ? Timestamp.valueOf(reservation.getActualCheckOut())
                            : null);
            pstmt.setString(5, reservation.getReservationId());

            pstmt.executeUpdate();
            System.out.println("✅ Reservation updated: " + reservation.getReservationNumber());
            return reservation;
        }
    }

    public void updateCheckIn(String reservationId, LocalDateTime checkInTime) throws SQLException {
        String sql = "UPDATE reservations SET actual_check_in = ?, status = 'CHECKED_IN', updated_at = CURRENT_TIMESTAMP WHERE reservation_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setTimestamp(1, Timestamp.valueOf(checkInTime));
            pstmt.setString(2, reservationId);
            pstmt.executeUpdate();
        }
    }

    public void updateCheckOut(String reservationId, LocalDateTime checkOutTime) throws SQLException {
        String sql = "UPDATE reservations SET actual_check_out = ?, status = 'COMPLETED', updated_at = CURRENT_TIMESTAMP WHERE reservation_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setTimestamp(1, Timestamp.valueOf(checkOutTime));
            pstmt.setString(2, reservationId);
            pstmt.executeUpdate();
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
        guest.setContactNumber(rs.getString("contact_number"));
        guest.setAddress(rs.getString("address"));
        guest.setIdType(rs.getString("id_type"));
        guest.setIdNumber(rs.getString("id_number"));
        guest.setNationality(rs.getString("nationality"));

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
        res.setCheckInDate(rs.getTimestamp("check_in_date").toLocalDateTime());
        res.setCheckOutDate(rs.getTimestamp("check_out_date").toLocalDateTime());
        res.setNumberOfNights(rs.getInt("number_of_nights"));
        res.setTotalCost(rs.getBigDecimal("total_cost"));
        res.setStatus(rs.getString("status"));
        res.setSpecialRequests(rs.getString("special_requests"));
        res.setPaymentMethod(rs.getString("payment_method"));
        res.setPaymentStatus(rs.getString("payment_status"));

        Timestamp actualCheckIn = rs.getTimestamp("actual_check_in");
        if (actualCheckIn != null)
            res.setActualCheckIn(actualCheckIn.toLocalDateTime());

        Timestamp actualCheckOut = rs.getTimestamp("actual_check_out");
        if (actualCheckOut != null)
            res.setActualCheckOut(actualCheckOut.toLocalDateTime());

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null)
            res.setCreatedAt(createdAt.toLocalDateTime());

        return res;
    }
}
