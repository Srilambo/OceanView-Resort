package com.oceanview.service;

import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
import com.oceanview.model.Room;
import com.oceanview.repository.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.sql.SQLException;

public class ReservationService {
    private ReservationRepository reservationRepository;
    private GuestRepository guestRepository;
    private RoomRepository roomRepository;

    public ReservationService() {
        this.reservationRepository = new ReservationRepository();
        this.guestRepository = new GuestRepository();
        this.roomRepository = new RoomRepository();
    }

    public Reservation createReservation(Reservation reservation) throws Exception {
        try {
            if (reservation.getGuest() == null || reservation.getGuest().getGuestId() == null) {
                throw new Exception("Guest information is required");
            }

            Guest guest = guestRepository.findById(reservation.getGuest().getGuestId());
            if (guest == null) {
                throw new Exception("Guest not found");
            }
            reservation.setGuest(guest);

            if (reservation.getRoom() == null || reservation.getRoom().getRoomId() == null) {
                throw new Exception("Room information is required");
            }

            Room room = roomRepository.findById(reservation.getRoom().getRoomId());
            if (room == null) {
                throw new Exception("Room not found");
            }
            if (!room.isAvailable()) {
                throw new Exception("Room is not available");
            }
            reservation.setRoom(room);

            if (reservation.getCheckInDate().isBefore(LocalDate.now())) {
                throw new Exception("Check-in date cannot be in the past");
            }

            if (reservation.getCheckOutDate().isBefore(reservation.getCheckInDate())) {
                throw new Exception("Check-out date must be after check-in date");
            }

            List<Reservation> overlapping = reservationRepository.findOverlappingReservations(
                    room.getRoomId(),
                    reservation.getCheckInDate(),
                    reservation.getCheckOutDate());

            if (!overlapping.isEmpty()) {
                throw new Exception("Room is not available for selected dates");
            }

            long nights = ChronoUnit.DAYS.between(
                    reservation.getCheckInDate(),
                    reservation.getCheckOutDate());

            reservation.setNumberOfNights((int) nights);
            reservation.setTotalCost(room.getPricePerNight().multiply(BigDecimal.valueOf(nights)));
            reservation.setReservationId(UUID.randomUUID().toString());
            reservation.setReservationNumber("RES-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            reservation.setStatus("PENDING");
            reservation.setCreatedAt(LocalDateTime.now());
            reservation.setUpdatedAt(LocalDateTime.now());

            return reservationRepository.save(reservation);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Reservation getReservationById(String id) throws Exception {
        try {
            Reservation reservation = reservationRepository.findById(id);
            if (reservation == null) {
                throw new Exception("Reservation not found");
            }
            return reservation;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Reservation getReservationByNumber(String reservationNumber) throws Exception {
        try {
            Reservation reservation = reservationRepository.findByReservationNumber(reservationNumber);
            if (reservation == null) {
                throw new Exception("Reservation not found");
            }
            return reservation;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public List<Reservation> getGuestReservations(String guestId) throws Exception {
        try {
            return reservationRepository.findByGuestId(guestId);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Reservation updateReservation(String id, String newStatus) throws Exception {
        try {
            Reservation reservation = getReservationById(id);
            reservation.setStatus(newStatus);
            reservation.setUpdatedAt(LocalDateTime.now());
            return reservationRepository.update(reservation);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Map<String, Object> calculateBill(String reservationId) throws Exception {
        try {
            Reservation reservation = getReservationById(reservationId);

            Map<String, Object> bill = new LinkedHashMap<>();
            bill.put("reservationNumber", reservation.getReservationNumber());
            bill.put("guestName", reservation.getGuest().getName());
            bill.put("roomNumber", reservation.getRoom().getRoomNumber());
            bill.put("checkInDate", reservation.getCheckInDate());
            bill.put("checkOutDate", reservation.getCheckOutDate());
            bill.put("numberOfNights", reservation.getNumberOfNights());
            bill.put("pricePerNight", reservation.getRoom().getPricePerNight());
            bill.put("totalCost", reservation.getTotalCost());
            bill.put("generatedAt", LocalDateTime.now());

            return bill;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Reservation cancelReservation(String id) throws Exception {
        try {
            Reservation reservation = getReservationById(id);
            reservation.setStatus("CANCELLED");
            reservation.setUpdatedAt(LocalDateTime.now());
            return reservationRepository.update(reservation);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public List<Reservation> getAllReservations() throws Exception {
        try {
            return reservationRepository.findAll();
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }
}
