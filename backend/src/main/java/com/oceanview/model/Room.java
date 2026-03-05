package com.oceanview.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Room implements Serializable {
    private static final long serialVersionUID = 1L;

    private String roomId;
    private String roomNumber;
    private String roomType;
    private int capacity;
    private BigDecimal pricePerNight;
    private String description;
    private String imageUrl;
    private boolean available;
    private String status;

    public Room() {
    }

    public Room(String roomId, String roomNumber, String roomType, int capacity,
            BigDecimal pricePerNight, String description, String imageUrl, boolean available, String status) {
        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.roomType = roomType;
        this.capacity = capacity;
        this.pricePerNight = pricePerNight;
        this.description = description;
        this.imageUrl = imageUrl;
        this.available = available;
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public BigDecimal getPricePerNight() {
        return pricePerNight;
    }

    public void setPricePerNight(BigDecimal pricePerNight) {
        this.pricePerNight = pricePerNight;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Room{" + "roomNumber='" + roomNumber + '\'' + ", roomType='" + roomType +
                '\'' + ", available=" + available + ", status='" + status + '\'' + '}';
    }
}
