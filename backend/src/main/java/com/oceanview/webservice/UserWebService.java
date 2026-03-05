package com.oceanview.webservice;

import com.oceanview.service.UserService;
import com.oceanview.model.User;
import com.oceanview.model.Guest;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.oceanview.util.LocalDateAdapter;
import com.oceanview.util.LocalDateTimeAdapter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

public class UserWebService {
    private UserService userService;
    private Gson gson;

    public UserWebService() {
        this.userService = new UserService();
        this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
    }

    public String login(String jsonBody) {
        try {
            Map<String, Object> credentials = gson.fromJson(jsonBody, Map.class);
            String username = (String) credentials.get("username");
            String password = (String) credentials.get("password");

            User user = userService.authenticate(username, password);

            Map<String, Object> response = Map.of(
                    "userId", user.getUserId(),
                    "username", user.getUsername(),
                    "email", user.getEmail(),
                    "roles", user.getRoles(),
                    "authenticated", true);

            return "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: application/json\r\n" +
                    "Access-Control-Allow-Origin: *\r\n" +
                    "\r\n" + gson.toJson(response);
        } catch (Exception e) {
            String errBody = "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
            byte[] errBytes = errBody.getBytes(java.nio.charset.StandardCharsets.UTF_8);
            return "HTTP/1.1 401 Unauthorized\r\n" +
                    "Content-Type: application/json; charset=UTF-8\r\n" +
                    "Access-Control-Allow-Origin: *\r\n" +
                    "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                    "Access-Control-Allow-Headers: Content-Type\r\n" +
                    "Content-Length: " + errBytes.length + "\r\n" +
                    "\r\n" + errBody;
        }
    }

    public String register(String jsonBody) {
        try {
            User user = gson.fromJson(jsonBody, User.class);
            User registeredUser = userService.register(user);

            Map<String, Object> responseData = Map.of(
                    "userId", registeredUser.getUserId(),
                    "username", registeredUser.getUsername(),
                    "email", registeredUser.getEmail(),
                    "roles", java.util.List.of("ROLE_USER"),
                    "authenticated", true);

            return buildJsonResponse(200, gson.toJson(responseData));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    private String buildJsonResponse(int statusCode, String body) {
        String statusText;
        switch (statusCode) {
            case 200:
                statusText = "OK";
                break;
            case 400:
                statusText = "Bad Request";
                break;
            case 401:
                statusText = "Unauthorized";
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

    public String getAllUsers() {
        try {
            java.util.List<User> users = userService.getAllUsers();
            return buildJsonResponse(200, gson.toJson(users));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String getUsersByRole(String role) {
        try {
            java.util.List<User> users = userService.getUsersByRole(role);
            return buildJsonResponse(200, gson.toJson(users));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String deleteUser(String userId) {
        try {
            userService.deleteUser(userId);
            return buildJsonResponse(200, "{\"message\": \"User deleted successfully\"}");
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String updateUser(String jsonBody) {
        try {
            User user = gson.fromJson(jsonBody, User.class);
            userService.updateUser(user);
            return buildJsonResponse(200, "{\"message\": \"User updated successfully\"}");
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // ========== Guest Profiling (Merged here) ==========

    public String getGuestByUserId(String userId) {
        try {
            Guest guest = userService.getGuestByUserId(userId);
            if (guest == null) {
                return buildJsonResponse(404, "{\"error\": \"Guest not found for user ID: " + userId + "\"}");
            }
            return buildJsonResponse(200, gson.toJson(guest));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String updateGuest(String jsonBody) {
        try {
            Guest guest = gson.fromJson(jsonBody, Guest.class);
            Guest updated = userService.updateGuest(guest);
            return buildJsonResponse(200, gson.toJson(updated));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
