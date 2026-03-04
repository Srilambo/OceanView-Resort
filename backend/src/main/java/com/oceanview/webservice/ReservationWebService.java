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

    @SuppressWarnings("unchecked")
    public String createReservation(String jsonBody) {
        try {
            Map<String, Object> data = gson.fromJson(jsonBody, Map.class);
            Reservation reservation = new Reservation();

            if (data.containsKey("guest")) {
                Map<String, Object> guestData = (Map<String, Object>) data.get("guest");
                Guest guest = new Guest();
                guest.setGuestId((String) guestData.get("guestId"));
                reservation.setGuest(guest);
            }

            if (data.containsKey("room")) {
                Map<String, Object> roomData = (Map<String, Object>) data.get("room");
                Room room = new Room();
                room.setRoomId((String) roomData.get("roomId"));
                reservation.setRoom(room);
            }

            reservation.setCheckInDate(LocalDate.parse((String) data.get("checkInDate")));
            reservation.setCheckOutDate(LocalDate.parse((String) data.get("checkOutDate")));
            if (data.containsKey("specialRequests")) {
                reservation.setSpecialRequests((String) data.get("specialRequests"));
            }

            Reservation created = reservationService.createReservation(reservation);
            return buildJsonResponse(201, gson.toJson(created));
        } catch (Exception e) {
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

    @SuppressWarnings("unchecked")
    public String updateReservation(String id, String jsonBody) {
        try {
            Map<String, String> data = gson.fromJson(jsonBody, Map.class);
            String status = data.get("status");
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

    private String buildJsonResponse(int statusCode, String body) {
        String statusText = (statusCode == 200) ? "OK"
                : (statusCode == 201 ? "Created"
                        : (statusCode == 404 ? "Not Found"
                                : (statusCode == 400 ? "Bad Request" : "Internal Server Error")));
        return "HTTP/1.1 " + statusCode + " " + statusText + "\r\n" +
                "Content-Type: application/json\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + body.length() + "\r\n" +
                "\r\n" + body;
    }
}
