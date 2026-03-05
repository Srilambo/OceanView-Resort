package com.oceanview.webservice;

import com.oceanview.admin.AdminWebService;
import com.oceanview.staff.StaffWebService;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class HttpServer {
    private int port;
    private ServerSocket serverSocket;
    private boolean running;

    private ReservationWebService reservationService;
    private UserWebService userService;
    private RoomWebService roomService;
    private AdminWebService adminService;
    private StaffWebService staffService;
    private com.oceanview.staff.TaskWebService taskService;
    private ResortServiceWebService resortServiceWebService;
    private ReviewWebService reviewWebService;

    public HttpServer(int port) {
        this.port = port;
        this.reservationService = new ReservationWebService();
        this.userService = new UserWebService();
        this.roomService = new RoomWebService();
        this.adminService = new AdminWebService();
        this.staffService = new StaffWebService();
        this.taskService = new com.oceanview.staff.TaskWebService();
        this.resortServiceWebService = new ResortServiceWebService();
        this.reviewWebService = new ReviewWebService();
    }

    public void start() {
        try {
            serverSocket = new ServerSocket(port);
            running = true;
            System.out.println("Ocean View Resort Backend Started");
            System.out.println("API: http://localhost:" + port + "/api");

            while (running) {
                Socket clientSocket = serverSocket.accept();
                new ClientHandler(clientSocket, this).start();
            }
        } catch (IOException e) {
            System.err.println("Server error: " + e.getMessage());
        }
    }

    public void stop() {
        running = false;
        try {
            if (serverSocket != null)
                serverSocket.close();
        } catch (IOException e) {
            System.err.println("Error stopping server: " + e.getMessage());
        }
    }

    public String handleRequest(String method, String path, String body) {
        System.out.println("📩 " + method + " " + path);

        // Handle CORS preflight requests for all endpoints
        if ("OPTIONS".equalsIgnoreCase(method)) {
            return buildPreflightResponse();
        }

        String rawPath = path;
        boolean onlyAvailable = path.contains("available=true");
        path = path.split("\\?")[0];

        try {
            // Auth
            if (path.equals("/api/auth/login") && method.equals("POST")) {
                return userService.login(body);
            }

            if (path.equals("/api/auth/register") && method.equals("POST")) {
                return userService.register(body);
            }

            // Users
            if (path.equals("/api/users") && method.equals("GET")) {
                return userService.getAllUsers();
            }

            if (path.matches("/api/users/role/[A-Z_]+") && method.equals("GET")) {
                String role = path.substring("/api/users/role/".length());
                return userService.getUsersByRole(role);
            }

            if (path.matches("/api/users/[a-zA-Z0-9-]+") && method.equals("DELETE")) {
                String userId = path.substring("/api/users/".length());
                return userService.deleteUser(userId);
            }

            if (path.equals("/api/users") && method.equals("PUT")) {
                return userService.updateUser(body);
            }

            if (path.equals("/api/admin/users") && method.equals("POST")) {
                return adminService.adminCreateUser(body);
            }

            if (path.equals("/api/admin/dashboard/stats") && method.equals("GET")) {
                return adminService.getDashboardStats();
            }

            // ========== Staff Endpoints ==========
            if (path.equals("/api/staff") && method.equals("GET")) {
                return staffService.getAllStaff();
            }

            if (path.equals("/api/staff") && method.equals("POST")) {
                return staffService.createStaff(body);
            }

            if (path.equals("/api/staff") && method.equals("PUT")) {
                return staffService.updateStaff(body);
            }

            if (path.equals("/api/staff/stats") && method.equals("GET")) {
                return staffService.getStaffStats();
            }

            if (path.matches("/api/staff/department/[A-Z_]+") && method.equals("GET")) {
                String department = path.substring("/api/staff/department/".length());
                return staffService.getStaffByDepartment(department);
            }

            if (path.matches("/api/staff/status/[A-Z_]+") && method.equals("GET")) {
                String status = path.substring("/api/staff/status/".length());
                return staffService.getStaffByStatus(status);
            }

            if (path.matches("/api/staff/[a-zA-Z0-9-]+") && method.equals("GET")) {
                String staffId = path.substring("/api/staff/".length());
                return staffService.getStaffById(staffId);
            }

            if (path.matches("/api/staff/[a-zA-Z0-9-]+") && method.equals("DELETE")) {
                String staffId = path.substring("/api/staff/".length());
                return staffService.deleteStaff(staffId);
            }

            // ========== Task Endpoints ==========
            if (path.equals("/api/tasks") && method.equals("GET")) {
                return taskService.getAllTasks();
            }

            if (path.equals("/api/tasks") && method.equals("POST")) {
                return taskService.createTask(body);
            }

            if (path.equals("/api/tasks") && method.equals("PUT")) {
                return taskService.updateTask(body);
            }

            if (path.matches("/api/tasks/staff/[a-zA-Z0-9-]+") && method.equals("GET")) {
                String staffId = path.substring("/api/tasks/staff/".length());
                return taskService.getTasksByStaff(staffId);
            }

            if (path.matches("/api/tasks/[a-zA-Z0-9-]+/status/[A-Z_]+") && method.equals("PATCH")) {
                String[] parts = path.split("/");
                String taskId = parts[3];
                String status = parts[5];
                return taskService.updateTaskStatus(taskId, status);
            }

            if (path.matches("/api/tasks/[a-zA-Z0-9-]+") && method.equals("DELETE")) {
                String taskId = path.substring("/api/tasks/".length());
                return taskService.deleteTask(taskId);
            }

            // Rooms
            if (path.equals("/api/rooms") && method.equals("GET")) {
                return roomService.getAllRooms(onlyAvailable);
            }

            if (path.equals("/api/rooms") && method.equals("POST")) {
                return roomService.createRoom(body);
            }

            if (path.equals("/api/rooms") && method.equals("PUT")) {
                return roomService.updateRoom(body);
            }

            if (path.matches("/api/rooms/[a-zA-Z0-9-]+") && method.equals("DELETE")) {
                String id = path.substring("/api/rooms/".length());
                return roomService.deleteRoom(id);
            }

            // Reservations
            if (path.equals("/api/reservations") && method.equals("GET")) {
                return reservationService.getAllReservations();
            }
            if (path.equals("/api/reservations") && method.equals("POST")) {
                return reservationService.createReservation(body);
            }

            if (path.matches("/api/reservations/[a-zA-Z0-9-]+") && method.equals("GET")) {
                String id = path.substring("/api/reservations/".length());
                return reservationService.getReservation(id);
            }

            if (path.matches("/api/reservations/number/[A-Z0-9-]+") && method.equals("GET")) {
                String number = path.substring("/api/reservations/number/".length());
                return reservationService.getReservationByNumber(number);
            }

            if (path.matches("/api/reservations/guest/[a-zA-Z0-9-]+") && method.equals("GET")) {
                String guestId = path.substring("/api/reservations/guest/".length());
                return reservationService.getGuestReservations(guestId);
            }

            if (path.matches("/api/reservations/[a-zA-Z0-9-]+/bill") && method.equals("GET")) {
                String id = path.substring("/api/reservations/".length(), path.indexOf("/bill"));
                return reservationService.getBill(id);
            }

            if (path.matches("/api/reservations/[a-zA-Z0-9-]+") && method.equals("DELETE")) {
                String id = path.substring("/api/reservations/".length());
                return reservationService.cancelReservation(id);
            }

            if (path.matches("/api/reservations/[a-zA-Z0-9-]+") && method.equals("PUT")) {
                String id = path.substring("/api/reservations/".length());
                return reservationService.updateReservation(id, body);
            }

            if (path.matches("/api/reservations/[a-zA-Z0-9-]+/check-in") && method.equals("POST")) {
                String id = path.substring("/api/reservations/".length(), path.indexOf("/check-in"));
                return reservationService.checkIn(id);
            }

            if (path.matches("/api/reservations/[a-zA-Z0-9-]+/check-out") && method.equals("POST")) {
                String id = path.substring("/api/reservations/".length(), path.indexOf("/check-out"));
                return reservationService.checkOut(id);
            }

            // ========== Resort Services Endpoints ==========
            if (path.equals("/api/services") && method.equals("GET")) {
                return resortServiceWebService.getAllServices();
            }

            if (path.matches("/api/services/category/[A-Z_]+") && method.equals("GET")) {
                String category = path.substring("/api/services/category/".length());
                return resortServiceWebService.getServicesByCategory(category);
            }

            if (path.matches("/api/services/[a-zA-Z0-9-]+") && method.equals("GET")) {
                String id = path.substring("/api/services/".length());
                return resortServiceWebService.getServiceById(id);
            }

            // ========== Reviews Endpoints ==========
            if (path.equals("/api/reviews") && method.equals("GET")) {
                return reviewWebService.getAllReviews();
            }

            if (path.equals("/api/reviews") && method.equals("POST")) {
                return reviewWebService.createReview(body);
            }

            return buildJsonResponse(404, "{\"error\": \"Endpoint not found: " + method + " " + rawPath + "\"}");

        } catch (Exception e) {
            System.err.println("❌ Error handling " + method + " " + path + ": " + e.getMessage());
            e.printStackTrace();
            String message = e.getMessage() != null ? e.getMessage() : "Unknown server error";
            return buildJsonResponse(500, "{\"error\": \"" + message.replace("\"", "\\\"") + "\"}");
        }
    }

    private String buildPreflightResponse() {
        return "HTTP/1.1 204 No Content\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS, PATCH\r\n" +
                "Access-Control-Allow-Headers: Content-Type, Authorization\r\n" +
                "Access-Control-Max-Age: 86400\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n";
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
            case 401:
                statusText = "Unauthorized";
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
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS, PATCH\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + bodyBytes.length + "\r\n" +
                "\r\n" + body;
    }
}
