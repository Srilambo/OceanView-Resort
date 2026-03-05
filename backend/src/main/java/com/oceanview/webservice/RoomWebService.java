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
            return buildJsonResponse(200, gson.toJson(rooms));
        } catch (Exception e) {
            System.err.println("❌ Failed to fetch rooms: " + e.getMessage());
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String createRoom(String jsonBody) {
        try {
            Room room = gson.fromJson(jsonBody, Room.class);
            Room createdRoom = roomService.createRoom(room);
            return buildJsonResponse(201, gson.toJson(createdRoom));
        } catch (Exception e) {
            System.err.println("❌ Failed to create room: " + e.getMessage());
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String updateRoom(String jsonBody) {
        try {
            Room room = gson.fromJson(jsonBody, Room.class);
            Room updatedRoom = roomService.updateRoom(room);
            return buildJsonResponse(200, gson.toJson(updatedRoom));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String deleteRoom(String id) {
        try {
            roomService.deleteRoom(id);
            return buildJsonResponse(200, "{\"message\": \"Room deleted successfully\"}");
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    private String buildJsonResponse(int statusCode, String body) {
        String statusText;
        switch (statusCode) {
            case 200:
                statusText = "OK";
                break;
            case 201:
                statusText = "Created";
                break;
            case 400:
                statusText = "Bad Request";
                break;
            case 404:
                statusText = "Not Found";
                break;
            default:
                statusText = "Internal Server Error";
                break;
        }

        byte[] bodyBytes = body.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        return "HTTP/1.1 " + statusCode + " " + statusText + "\r\n" +
                "Content-Type: application/json; charset=UTF-8\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + bodyBytes.length + "\r\n" +
                "\r\n" + body;
    }
}
