package com.oceanview.webservice;

import com.oceanview.service.RoomService;
import com.oceanview.model.Room;
import com.google.gson.Gson;
import java.util.List;

public class RoomWebService {
    private RoomService roomService;
    private Gson gson;

    public RoomWebService() {
        this.roomService = new RoomService();
        this.gson = new Gson();
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
                    "\r\n{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
        }
    }
}
