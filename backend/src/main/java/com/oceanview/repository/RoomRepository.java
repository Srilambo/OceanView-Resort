package com.oceanview.repository;

import com.oceanview.model.Room;
import com.oceanview.db.DatabaseHelper;
import java.sql.*;
import java.util.*;

public class RoomRepository {

    public Room save(Room room) throws SQLException {
        String sql = "INSERT INTO rooms (room_id, room_number, room_type, capacity, " +
                "price_per_night, description, image_url, available, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, room.getRoomId());
            pstmt.setString(2, room.getRoomNumber());
            pstmt.setString(3, room.getRoomType());
            pstmt.setInt(4, room.getCapacity());
            pstmt.setBigDecimal(5, room.getPricePerNight());
            pstmt.setString(6, room.getDescription());
            pstmt.setString(7, room.getImageUrl());
            pstmt.setBoolean(8, room.isAvailable());
            pstmt.setString(9, room.getStatus());

            pstmt.executeUpdate();
            return room;
        }
    }

    public Room findById(String roomId) throws SQLException {
        String sql = "SELECT * FROM rooms WHERE room_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, roomId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRoom(rs);
            }
        }
        return null;
    }

    public Room findByRoomNumber(String roomNumber) throws SQLException {
        String sql = "SELECT * FROM rooms WHERE room_number = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, roomNumber);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToRoom(rs);
            }
        }
        return null;
    }

    public List<Room> findByAvailable(boolean available) throws SQLException {
        String sql = "SELECT * FROM rooms WHERE available = ?";
        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setBoolean(1, available);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        }
        return rooms;
    }

    public List<Room> findByRoomType(String roomType) throws SQLException {
        String sql = "SELECT * FROM rooms WHERE room_type = ?";
        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, roomType);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        }
        return rooms;
    }

    public List<Room> findAll() throws SQLException {
        String sql = "SELECT * FROM rooms";
        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        }
        return rooms;
    }

    public Room update(Room room) throws SQLException {
        String sql = "UPDATE rooms SET room_number = ?, room_type = ?, capacity = ?, " +
                "price_per_night = ?, description = ?, image_url = ?, available = ?, status = ? WHERE room_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, room.getRoomNumber());
            pstmt.setString(2, room.getRoomType());
            pstmt.setInt(3, room.getCapacity());
            pstmt.setBigDecimal(4, room.getPricePerNight());
            pstmt.setString(5, room.getDescription());
            pstmt.setString(6, room.getImageUrl());
            pstmt.setBoolean(7, room.isAvailable());
            pstmt.setString(8, room.getStatus());
            pstmt.setString(9, room.getRoomId());

            pstmt.executeUpdate();
            return room;
        }
    }

    public boolean delete(String roomId) throws SQLException {
        String sql = "DELETE FROM rooms WHERE room_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, roomId);
            int result = pstmt.executeUpdate();
            return result > 0;
        }
    }

    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        return new Room(
                rs.getString("room_id"),
                rs.getString("room_number"),
                rs.getString("room_type"),
                rs.getInt("capacity"),
                rs.getBigDecimal("price_per_night"),
                rs.getString("description"),
                rs.getString("image_url"),
                rs.getBoolean("available"),
                rs.getString("status"));
    }
}
