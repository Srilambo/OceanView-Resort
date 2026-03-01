package com.oceanview.repository;

import com.oceanview.model.Room;
import com.oceanview.util.FileHandler;
import java.util.*;

public class RoomRepository {
    private static final String ROOMS_FILE = "resources/data/rooms.dat";
    private List<Room> rooms;

    public RoomRepository() {
        this.rooms = FileHandler.loadRooms(ROOMS_FILE);
    }

    public Room save(Room room) {
        if (room.getRoomId() == null) {
            room.setRoomId(UUID.randomUUID().toString());
        }
        rooms.add(room);
        FileHandler.saveRooms(ROOMS_FILE, rooms);
        return room;
    }

    public Room findById(String roomId) {
        return rooms.stream()
            .filter(r -> r.getRoomId().equals(roomId))
            .findFirst()
            .orElse(null);
    }

    public Room findByRoomNumber(String roomNumber) {
        return rooms.stream()
            .filter(r -> r.getRoomNumber().equals(roomNumber))
            .findFirst()
            .orElse(null);
    }

    public List<Room> findByAvailable(boolean available) {
        List<Room> result = new ArrayList<>();
        for (Room r : rooms) {
            if (r.isAvailable() == available) {
                result.add(r);
            }
        }
        return result;
    }

    public List<Room> findByRoomType(String roomType) {
        List<Room> result = new ArrayList<>();
        for (Room r : rooms) {
            if (r.getRoomType().equalsIgnoreCase(roomType)) {
                result.add(r);
            }
        }
        return result;
    }

    public List<Room> findAll() {
        return new ArrayList<>(rooms);
    }

    public Room update(Room room) {
        Room existing = findById(room.getRoomId());
        if (existing != null) {
            rooms.remove(existing);
            rooms.add(room);
            FileHandler.saveRooms(ROOMS_FILE, rooms);
        }
        return room;
    }
}
