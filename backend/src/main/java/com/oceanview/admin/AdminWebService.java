package com.oceanview.admin;

import com.oceanview.model.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.oceanview.util.LocalDateAdapter;
import com.oceanview.util.LocalDateTimeAdapter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

public class AdminWebService {
    private AdminService adminService;
    private Gson gson;

    public AdminWebService() {
        this.adminService = new AdminService();
        this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
    }

    private String buildJsonResponse(int statusCode, String body) {
        String statusText = (statusCode == 200) ? "OK" : (statusCode == 400 ? "Bad Request" : "Internal Server Error");
        return "HTTP/1.1 " + statusCode + " " + statusText + "\r\n" +
                "Content-Type: application/json\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + body.length() + "\r\n" +
                "\r\n" + body;
    }

    public String adminCreateUser(String jsonBody) {
        try {
            User user = gson.fromJson(jsonBody, User.class);
            User registeredUser = adminService.createUserWithRoles(user, user.getRoles());
            return buildJsonResponse(200, gson.toJson(registeredUser));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String getDashboardStats() {
        try {
            Map<String, Object> stats = adminService.getAdminStats();
            return buildJsonResponse(200, gson.toJson(stats));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
