package com.oceanview.service;

import com.oceanview.model.Room;
import com.oceanview.repository.RoomRepository;
import java.sql.SQLException;
import java.util.List;

public class RoomService {
    private RoomRepository roomRepository;

    public RoomService() {
        this.roomRepository = new RoomRepository();
    }

    public List<Room> getAllRooms() throws Exception {
        try {
            return roomRepository.findAll();
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public List<Room> getAvailableRooms() throws Exception {
        try {
            return roomRepository.findByAvailable(true);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Room getRoomById(String id) throws Exception {
        try {
            Room room = roomRepository.findById(id);
            if (room == null) {
                throw new Exception("Room not found");
            }
            return room;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Room createRoom(Room room) throws Exception {
        try {
            if (room.getRoomId() == null || room.getRoomId().isEmpty()) {
                room.setRoomId(java.util.UUID.randomUUID().toString());
            }
            return roomRepository.save(room);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Room updateRoom(Room room) throws Exception {
        try {
            return roomRepository.update(room);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public void deleteRoom(String id) throws Exception {
        try {
            roomRepository.delete(id);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }
}
