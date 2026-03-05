package com.oceanview.staff;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.oceanview.util.LocalDateAdapter;
import com.oceanview.util.LocalDateTimeAdapter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class TaskWebService {
    private TaskService taskService;
    private Gson gson;

    public TaskWebService() {
        this.taskService = new TaskService();
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
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS, PATCH\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + body.length() + "\r\n" +
                "\r\n" + body;
    }

    // POST /api/tasks
    public String createTask(String jsonBody) {
        try {
            TaskModel task = gson.fromJson(jsonBody, TaskModel.class);
            TaskModel created = taskService.createTask(task);
            return buildJsonResponse(201, gson.toJson(created));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // GET /api/tasks
    public String getAllTasks() {
        try {
            List<TaskModel> tasks = taskService.getAllTasks();
            return buildJsonResponse(200, gson.toJson(tasks));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // GET /api/tasks/staff/{staffId}
    public String getTasksByStaff(String staffId) {
        try {
            List<TaskModel> tasks = taskService.getTasksByStaff(staffId);
            return buildJsonResponse(200, gson.toJson(tasks));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // PUT /api/tasks
    public String updateTask(String jsonBody) {
        try {
            TaskModel task = gson.fromJson(jsonBody, TaskModel.class);
            TaskModel updated = taskService.updateTask(task);
            return buildJsonResponse(200, gson.toJson(updated));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // PATCH /api/tasks/{id}/status/{status}
    public String updateTaskStatus(String taskId, String status) {
        try {
            boolean updated = taskService.updateTaskStatus(taskId, status);
            return buildJsonResponse(200, "{\"success\": " + updated + "}");
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    // DELETE /api/tasks/{id}
    public String deleteTask(String taskId) {
        try {
            boolean deleted = taskService.deleteTask(taskId);
            return buildJsonResponse(200, "{\"success\": " + deleted + "}");
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }
}
