package com.oceanview.service;

import com.oceanview.model.Reservation;
import com.oceanview.model.Guest;
import com.oceanview.model.Room;
import com.oceanview.repository.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.sql.SQLException;

public class ReservationService {
    private ReservationRepository reservationRepository;
    private GuestRepository guestRepository;
    private RoomRepository roomRepository;
    private ReservationServiceRepository reservationServiceRepository;

    public ReservationService() {
        this.reservationRepository = new ReservationRepository();
        this.guestRepository = new GuestRepository();
        this.roomRepository = new RoomRepository();
        this.reservationServiceRepository = new ReservationServiceRepository();
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

            if (reservation.getCheckInDate().isBefore(LocalDateTime.now().minusMinutes(30))) {
                throw new Exception("Check-in date cannot be significantly in the past");
            }

            if (reservation.getCheckOutDate().isBefore(reservation.getCheckInDate())) {
                throw new Exception("Check-out date must be after check-in date");
            }

            System.out.println("Checking availability for room: " + room.getRoomId());
            System.out.println("Dates: " + reservation.getCheckInDate() + " to " + reservation.getCheckOutDate());

            List<Reservation> overlapping = reservationRepository.findOverlappingReservations(
                    room.getRoomId(),
                    reservation.getCheckInDate(),
                    reservation.getCheckOutDate());

            System.out.println("Found " + overlapping.size() + " overlapping reservations before filtering.");

            // Filter out stale PENDING reservations (not confirmed, not paid, created > 24h
            // ago)
            overlapping = overlapping.stream()
                    .filter(r -> {
                        boolean isStale = "PENDING".equals(r.getStatus())
                                && "PENDING".equals(r.getPaymentStatus())
                                && r.getCreatedAt() != null
                                && r.getCreatedAt().isBefore(LocalDateTime.now().minusHours(24));
                        return !isStale;
                    })
                    .collect(java.util.stream.Collectors.toList());

            if (!overlapping.isEmpty()) {
                throw new Exception("Room is not available for selected dates");
            }

            long nights = ChronoUnit.DAYS.between(
                    reservation.getCheckInDate().toLocalDate(),
                    reservation.getCheckOutDate().toLocalDate());

            if (nights <= 0)
                nights = 1; // Minimum 1 night charge

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

            List<Map<String, Object>> serviceItems = reservationServiceRepository
                    .getServicesForReservation(reservationId);
            double servicesTotalAmount = reservationServiceRepository.getTotalServicesAmount(reservationId);
            double roomCost = reservation.getTotalCost() != null ? reservation.getTotalCost().doubleValue() : 0.0;
            double grandTotal = roomCost + servicesTotalAmount;

            Map<String, Object> bill = new LinkedHashMap<>();
            bill.put("reservationId", reservation.getReservationId());
            bill.put("reservationNumber", reservation.getReservationNumber());
            bill.put("guestName", reservation.getGuest().getName());
            bill.put("roomNumber", reservation.getRoom().getRoomNumber());
            bill.put("roomType", reservation.getRoom().getRoomType());
            bill.put("checkInDate", reservation.getCheckInDate());
            bill.put("checkOutDate", reservation.getCheckOutDate());
            bill.put("numberOfNights", reservation.getNumberOfNights());
            bill.put("pricePerNight", reservation.getRoom().getPricePerNight());
            bill.put("roomCost", roomCost);
            bill.put("serviceItems", serviceItems);
            bill.put("servicesTotal", servicesTotalAmount);
            bill.put("grandTotal", grandTotal);
            bill.put("paymentStatus", reservation.getPaymentStatus());
            bill.put("paymentMethod", reservation.getPaymentMethod());
            bill.put("reservationStatus", reservation.getStatus());
            bill.put("generatedAt", LocalDateTime.now());

            // Keep legacy field for backward compat
            bill.put("totalCost", roomCost);

            return bill;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public void addServiceToReservation(String reservationId, String serviceId,
            String serviceName, double servicePrice, int quantity) throws Exception {
        try {
            Reservation reservation = getReservationById(reservationId);
            if ("COMPLETED".equals(reservation.getStatus()) || "CANCELLED".equals(reservation.getStatus())) {
                throw new Exception(
                        "Cannot add services to a " + reservation.getStatus().toLowerCase() + " reservation");
            }
            reservationServiceRepository.addServiceToReservation(reservationId, serviceId, serviceName, servicePrice,
                    quantity);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Map<String, Object> checkOutWithPayment(String reservationId, String paymentMethod) throws Exception {
        try {
            reservationServiceRepository.updatePaymentOnCheckout(reservationId, paymentMethod);
            return calculateBill(reservationId);
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

    public void checkIn(String id) throws Exception {
        try {
            reservationRepository.updateCheckIn(id, LocalDateTime.now());
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public void checkOut(String id) throws Exception {
        try {
            reservationRepository.updateCheckOut(id, LocalDateTime.now());
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }
}
