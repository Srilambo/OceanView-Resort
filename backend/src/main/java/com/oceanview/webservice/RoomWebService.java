package com.oceanview.webservice;

import com.oceanview.service.RoomService;
import com.oceanview.model.Room;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.oceanview.util.LocalDateAdapter;
import com.oceanview.util.LocalDateTimeAdapter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class RoomWebService {
    private RoomService roomService;
    private Gson gson;

    public RoomWebService() {
        this.roomService = new RoomService();
        this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
    }

    public String getAllRooms(boolean onlyAvailable) {
        try {
            List<Room> rooms;
            if (onlyAvailable) {
                rooms = roomService.getAvailableRooms();
            } else {
                rooms = roomService.getAllRooms();
            }
            return "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: application/json\r\n" +
                    "Access-Control-Allow-Origin: *\r\n" +
                    "\r\n" + gson.toJson(rooms);
        } catch (Exception e) {
            return "HTTP/1.1 500 Internal Server Error\r\n" +
                    "Content-Type: application/json\r\n" +
                    "Access-Control-Allow-Origin: *\r\n" +
                    "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                    "Access-Control-Allow-Headers: Content-Type\r\n" +
                    "\r\n{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
        }
    }
}
