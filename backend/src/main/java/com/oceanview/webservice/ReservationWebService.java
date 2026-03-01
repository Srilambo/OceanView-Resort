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

            return "HTTP/1.1 201 Created\r\n" +
                   "Content-Type: application/json\r\n" +
                   "Access-Control-Allow-Origin: *\r\n" +
                   "\r\n" + gson.toJson(created);
        } catch (Exception e) {
            return "HTTP/1.1 400 Bad Request\r\n" +
                   "Content-Type: application/json\r\n" +
                   "\r\n{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
        }
    }

    public String getReservation(String reservationId) {
        try {
            Reservation reservation = reservationService.getReservationById(reservationId);
            return "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: application/json\r\n" +
                   "Access-Control-Allow-Origin: *\r\n" +
                   "\r\n" + gson.toJson(reservation);
        } catch (Exception e) {
            return "HTTP/1.1 404 Not Found\r\n" +
                   "Content-Type: application/json\r\n" +
                   "\r\n{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
        }
    }

    public String getBill(String reservationId) {
        try {
            Map<String, Object> bill = reservationService.calculateBill(reservationId);
            return "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: application/json\r\n" +
                   "Access-Control-Allow-Origin: *\r\n" +
                   "\r\n" + gson.toJson(bill);
        } catch (Exception e) {
            return "HTTP/1.1 404 Not Found\r\n" +
                   "Content-Type: application/json\r\n" +
                   "\r\n{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
        }
    }

    public String cancelReservation(String reservationId) {
        try {
            Reservation cancelled = reservationService.cancelReservation(reservationId);
            return "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: application/json\r\n" +
                   "Access-Control-Allow-Origin: *\r\n" +
                   "\r\n" + gson.toJson(cancelled);
        } catch (Exception e) {
            return "HTTP/1.1 400 Bad Request\r\n" +
                   "Content-Type: application/json\r\n" +
                   "\r\n{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
        }
    }
}
