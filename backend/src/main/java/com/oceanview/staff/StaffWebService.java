package com.oceanview.staff;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.oceanview.util.LocalDateAdapter;
import com.oceanview.util.LocalDateTimeAdapter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public class StaffWebService {
    private StaffService staffService;
    private Gson gson;

    public StaffWebService() {
        this.staffService = new StaffService();
        this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
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
        return "HTTP/1.1 " + statusCode + " " + statusText + "\r\n" +
                "Content-Type: application/json\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + body.length() + "\r\n" +
                "\r\n" + body;
    }

    // POST /api/staff - Create new staff
    public String createStaff(String jsonBody) {
        try {
            StaffModel staff = gson.fromJson(jsonBody, StaffModel.class);
            StaffModel created = staffService.createStaff(staff);
            return buildJsonResponse(201, gson.toJson(created));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // GET /api/staff - Get all staff
    public String getAllStaff() {
        try {
            List<StaffModel> staffList = staffService.getAllStaff();
            return buildJsonResponse(200, gson.toJson(staffList));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // GET /api/staff/{id} - Get staff by ID
    public String getStaffById(String staffId) {
        try {
            StaffModel staff = staffService.getStaffById(staffId);
            return buildJsonResponse(200, gson.toJson(staff));
        } catch (Exception e) {
            return buildJsonResponse(404, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // GET /api/staff/department/{department} - Get staff by department
    public String getStaffByDepartment(String department) {
        try {
            List<StaffModel> staffList = staffService.getStaffByDepartment(department);
            return buildJsonResponse(200, gson.toJson(staffList));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // GET /api/staff/status/{status} - Get staff by status
    public String getStaffByStatus(String status) {
        try {
            List<StaffModel> staffList = staffService.getStaffByStatus(status);
            return buildJsonResponse(200, gson.toJson(staffList));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // PUT /api/staff - Update staff
    public String updateStaff(String jsonBody) {
        try {
            StaffModel staff = gson.fromJson(jsonBody, StaffModel.class);
            StaffModel updated = staffService.updateStaff(staff);
            return buildJsonResponse(200, gson.toJson(updated));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // DELETE /api/staff/{id} - Delete staff
    public String deleteStaff(String staffId) {
        try {
            staffService.deleteStaff(staffId);
            return buildJsonResponse(200, "{\"message\": \"Staff member deleted successfully\"}");
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // GET /api/staff/stats - Get staff statistics
    public String getStaffStats() {
        try {
            Map<String, Object> stats = staffService.getStaffStats();
            return buildJsonResponse(200, gson.toJson(stats));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
