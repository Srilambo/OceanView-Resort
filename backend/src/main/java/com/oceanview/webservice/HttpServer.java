package com.oceanview.webservice;

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

    public HttpServer(int port) {
        this.port = port;
        this.reservationService = new ReservationWebService();
        this.userService = new UserWebService();
        this.roomService = new RoomWebService();
    }

    public void start() {
        try {
            serverSocket = new ServerSocket(port);
            running = true;
            System.out.println("🏨 Ocean View Resort Backend Started");
            System.out.println("🔗 API: http://localhost:" + port + "/api");

            while (running) {
                Socket clientSocket = serverSocket.accept();
                new ClientHandler(clientSocket, this).start();
            }
        } catch (IOException e) {
            System.err.println("❌ Server error: " + e.getMessage());
        }
    }

    public void stop() {
        running = false;
        try {
            if (serverSocket != null)
                serverSocket.close();
        } catch (IOException e) {
            System.err.println("❌ Error stopping server: " + e.getMessage());
        }
    }

    public String handleRequest(String method, String path, String body) {
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

            // Rooms
            if (path.equals("/api/rooms") && method.equals("GET")) {
                return roomService.getAllRooms(onlyAvailable);
            }

            // Reservations
            if (path.equals("/api/reservations") && method.equals("POST")) {
                return reservationService.createReservation(body);
            }

            if (path.matches("/api/reservations/[a-fA-F0-9-]+") && method.equals("GET")) {
                String id = path.substring("/api/reservations/".length());
                return reservationService.getReservation(id);
            }

            if (path.matches("/api/reservations/number/[A-Z0-9-]+") && method.equals("GET")) {
                String number = path.substring("/api/reservations/number/".length());
                return reservationService.getReservationByNumber(number);
            }

            if (path.matches("/api/reservations/guest/[a-fA-F0-9-]+") && method.equals("GET")) {
                String guestId = path.substring("/api/reservations/guest/".length());
                return reservationService.getGuestReservations(guestId);
            }

            if (path.matches("/api/reservations/[a-fA-F0-9-]+/bill") && method.equals("GET")) {
                String id = path.substring("/api/reservations/".length(), path.indexOf("/bill"));
                return reservationService.getBill(id);
            }

            if (path.matches("/api/reservations/[a-fA-F0-9-]+") && method.equals("DELETE")) {
                String id = path.substring("/api/reservations/".length());
                return reservationService.cancelReservation(id);
            }

            return buildJsonResponse(404, "{\"error\": \"Endpoint not found: " + method + " " + rawPath + "\"}");

        } catch (Exception e) {
            String message = e.getMessage() != null ? e.getMessage() : "Unknown server error";
            return buildJsonResponse(500, "{\"error\": \"" + message.replace("\"", "\\\"") + "\"}");
        }
    }

    private String buildPreflightResponse() {
        return "HTTP/1.1 204 No Content\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n";
    }

    private String buildJsonResponse(int statusCode, String body) {
        String statusText = statusCode == 200 ? "OK" : statusCode == 404 ? "Not Found" : "Internal Server Error";
        return "HTTP/1.1 " + statusCode + " " + statusText + "\r\n" +
                "Content-Type: application/json\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + body.length() + "\r\n" +
                "\r\n" + body;
    }
}
