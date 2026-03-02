package com.oceanview.webservice;

import com.oceanview.service.UserService;
import com.oceanview.model.User;
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
            Map<String, String> credentials = gson.fromJson(jsonBody, Map.class);
            String username = credentials.get("username");
            String password = credentials.get("password");

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
            return "HTTP/1.1 401 Unauthorized\r\n" +
                    "Content-Type: application/json\r\n" +
                    "Access-Control-Allow-Origin: *\r\n" +
                    "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                    "Access-Control-Allow-Headers: Content-Type\r\n" +
                    "\r\n{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
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
        String statusText = (statusCode == 200) ? "OK" : (statusCode == 400 ? "Bad Request" : "Unauthorized");
        return "HTTP/1.1 " + statusCode + " " + statusText + "\r\n" +
                "Content-Type: application/json\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + body.length() + "\r\n" +
                "\r\n" + body;
    }
}
