package com.oceanview.repository;

import com.oceanview.model.Reservation;
import com.oceanview.util.FileHandler;
import java.time.LocalDate;
import java.util.*;

public class ReservationRepository {
    private static final String RESERVATIONS_FILE = "resources/data/reservations.dat";
    private List<Reservation> reservations;

    public ReservationRepository() {
        this.reservations = FileHandler.loadReservations(RESERVATIONS_FILE);
    }

    public Reservation save(Reservation reservation) {
        if (reservation.getReservationId() == null) {
            reservation.setReservationId(UUID.randomUUID().toString());
        }
        reservations.add(reservation);
        FileHandler.saveReservations(RESERVATIONS_FILE, reservations);
        return reservation;
    }

    public Reservation findById(String reservationId) {
        return reservations.stream()
            .filter(r -> r.getReservationId().equals(reservationId))
            .findFirst()
            .orElse(null);
    }

    public Reservation findByReservationNumber(String reservationNumber) {
        return reservations.stream()
            .filter(r -> r.getReservationNumber().equals(reservationNumber))
            .findFirst()
            .orElse(null);
    }

    public List<Reservation> findByGuestId(String guestId) {
        List<Reservation> result = new ArrayList<>();
        for (Reservation r : reservations) {
            if (r.getGuest() != null && r.getGuest().getGuestId().equals(guestId)) {
                result.add(r);
            }
        }
        return result;
    }

    public List<Reservation> findOverlappingReservations(String roomId, LocalDate checkIn, LocalDate checkOut) {
        List<Reservation> overlapping = new ArrayList<>();
        for (Reservation r : reservations) {
            if (r.getRoom() != null && r.getRoom().getRoomId().equals(roomId) && !r.getStatus().equals("CANCELLED")) {
                if (!(checkOut.isBefore(r.getCheckInDate()) || checkIn.isAfter(r.getCheckOutDate()))) {
                    overlapping.add(r);
                }
            }
        }
        return overlapping;
    }

    public List<Reservation> findAll() {
        return new ArrayList<>(reservations);
    }

    public Reservation update(Reservation reservation) {
        Reservation existing = findById(reservation.getReservationId());
        if (existing != null) {
            reservations.remove(existing);
            reservations.add(reservation);
            FileHandler.saveReservations(RESERVATIONS_FILE, reservations);
        }
        return reservation;
    }

    public boolean delete(String reservationId) {
        boolean removed = reservations.removeIf(r -> r.getReservationId().equals(reservationId));
        if (removed) {
            FileHandler.saveReservations(RESERVATIONS_FILE, reservations);
        }
        return removed;
    }
}
