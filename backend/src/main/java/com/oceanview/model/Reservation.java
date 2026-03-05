package com.oceanview.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Reservation implements Serializable {
    private static final long serialVersionUID = 1L;

    private String reservationId;
    private String reservationNumber;
    private Guest guest;
    private Room room;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private LocalDateTime actualCheckIn;
    private LocalDateTime actualCheckOut;
    private int numberOfNights;
    private BigDecimal totalCost;
    private String status;
    private String specialRequests;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Reservation() {
    }

    public Reservation(String reservationId, String reservationNumber, Guest guest,
            Room room, LocalDate checkInDate, LocalDate checkOutDate) {
        this.reservationId = reservationId;
        this.reservationNumber = reservationNumber;
        this.guest = guest;
        this.room = room;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.status = "PENDING";
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public String getReservationId() {
        return reservationId;
    }

    public void setReservationId(String reservationId) {
        this.reservationId = reservationId;
    }

    public String getReservationNumber() {
        return reservationNumber;
    }

    public void setReservationNumber(String reservationNumber) {
        this.reservationNumber = reservationNumber;
    }

    public Guest getGuest() {
        return guest;
    }

    public void setGuest(Guest guest) {
        this.guest = guest;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public LocalDate getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }

    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public int getNumberOfNights() {
        return numberOfNights;
    }

    public void setNumberOfNights(int numberOfNights) {
        this.numberOfNights = numberOfNights;
    }

    public BigDecimal getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(BigDecimal totalCost) {
        this.totalCost = totalCost;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSpecialRequests() {
        return specialRequests;
    }

    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getActualCheckIn() {
        return actualCheckIn;
    }

    public void setActualCheckIn(LocalDateTime actualCheckIn) {
        this.actualCheckIn = actualCheckIn;
    }

    public LocalDateTime getActualCheckOut() {
        return actualCheckOut;
    }

    public void setActualCheckOut(LocalDateTime actualCheckOut) {
        this.actualCheckOut = actualCheckOut;
    }

    @Override
    public String toString() {
        return "Reservation{" + "reservationNumber='" + reservationNumber + '\'' +
                ", status='" + status + '\'' + ", totalCost=" + totalCost + '}';
    }
}
