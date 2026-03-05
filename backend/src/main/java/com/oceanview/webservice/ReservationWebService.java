package com.oceanview.webservice;

import com.oceanview.service.ReservationService;
import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
import com.oceanview.model.Room;
import com.oceanview.util.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

public class ReservationWebService {
    private ReservationService reservationService;
    private Gson gson;

    public ReservationWebService() {
        this.reservationService = new ReservationService();
        this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
    }

    public String createReservation(String jsonBody) {
        try {
            Reservation reservation = gson.fromJson(jsonBody, Reservation.class);

            // Ensure child objects are at least partially present if IDs were provided
            // Reservation.class deserialization will handle it if the JSON structure
            // matched

            Reservation created = reservationService.createReservation(reservation);
            return buildJsonResponse(201, gson.toJson(created));
        } catch (Exception e) {
            e.printStackTrace(); // Log for easier debugging
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String getReservation(String reservationId) {
        try {
            Reservation reservation = reservationService.getReservationById(reservationId);
            return buildJsonResponse(200, gson.toJson(reservation));
        } catch (Exception e) {
            return buildJsonResponse(404, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String getBill(String reservationId) {
        try {
            Map<String, Object> bill = reservationService.calculateBill(reservationId);
            return buildJsonResponse(200, gson.toJson(bill));
        } catch (Exception e) {
            return buildJsonResponse(404, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String getReservationByNumber(String reservationNumber) {
        try {
            Reservation reservation = reservationService.getReservationByNumber(reservationNumber);
            return buildJsonResponse(200, gson.toJson(reservation));
        } catch (Exception e) {
            return buildJsonResponse(404, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String getGuestReservations(String guestId) {
        try {
            return buildJsonResponse(200, gson.toJson(reservationService.getGuestReservations(guestId)));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String cancelReservation(String reservationId) {
        try {
            Reservation cancelled = reservationService.cancelReservation(reservationId);
            return buildJsonResponse(200, gson.toJson(cancelled));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String updateReservation(String id, String jsonBody) {
        try {
            Map data = gson.fromJson(jsonBody, Map.class);
            String status = (String) data.get("status");
            Reservation updated = reservationService.updateReservation(id, status);
            return buildJsonResponse(200, gson.toJson(updated));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String getAllReservations() {
        try {
            java.util.List<Reservation> reservations = reservationService.getAllReservations();
            return buildJsonResponse(200, gson.toJson(reservations));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String checkIn(String id) {
        try {
            reservationService.checkIn(id);
            return buildJsonResponse(200, "{\"message\": \"Checked in successfully\"}");
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String checkOut(String id) {
        try {
            reservationService.checkOut(id);
            return buildJsonResponse(200, "{\"message\": \"Checked out successfully\"}");
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String addServiceToReservation(String id, String jsonBody) {
        try {
            Map<String, Object> data = gson.fromJson(jsonBody,
                    new com.google.gson.reflect.TypeToken<Map<String, Object>>() {
                    }.getType());
            String serviceId = (String) data.get("serviceId");
            String serviceName = (String) data.get("serviceName");
            double servicePrice = ((Number) data.get("servicePrice")).doubleValue();
            int quantity = data.containsKey("quantity") ? ((Number) data.get("quantity")).intValue() : 1;
            reservationService.addServiceToReservation(id, serviceId, serviceName, servicePrice, quantity);
            return buildJsonResponse(200,
                    "{\"message\": \"Service added to bill\", \"reservationId\": \"" + id + "\"}");
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String checkOutWithPayment(String id, String jsonBody) {
        try {
            Map<String, Object> data = gson.fromJson(jsonBody,
                    new com.google.gson.reflect.TypeToken<Map<String, Object>>() {
                    }.getType());
            String paymentMethod = data.containsKey("paymentMethod") ? (String) data.get("paymentMethod") : "CASH";
            Map<String, Object> bill = reservationService.checkOutWithPayment(id, paymentMethod);
            return buildJsonResponse(200, gson.toJson(bill));
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
            case 201:
                statusText = "Created";
                break;
            case 404:
                statusText = "Not Found";
                break;
            case 400:
                statusText = "Bad Request";
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
