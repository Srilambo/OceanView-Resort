package com.oceanview.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Guest implements Serializable {
    private static final long serialVersionUID = 1L;

    private String guestId;
    private String name;
    private String email;
    private String contactNumber;
    private String address;
    private String idType;
    private String idNumber;
    private String nationality;
    private LocalDateTime createdAt;

    public Guest() {
    }

    public Guest(String guestId, String name, String email, String contactNumber,
            String address, String idType, String idNumber, String nationality) {
        this.guestId = guestId;
        this.name = name;
        this.email = email;
        this.contactNumber = contactNumber;
        this.address = address;
        this.idType = idType;
        this.idNumber = idNumber;
        this.nationality = nationality;
        this.createdAt = LocalDateTime.now();
    }

    public String getGuestId() {
        return guestId;
    }

    public void setGuestId(String guestId) {
        this.guestId = guestId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getIdType() {
        return idType;
    }

    public void setIdType(String idType) {
        this.idType = idType;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getNationality() {
        return nationality;
    }

    public void setNationality(String nationality) {
        this.nationality = nationality;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Guest{" + "guestId='" + guestId + '\'' + ", name='" + name + '\'' +
                ", email='" + email + '\'' + '}';
    }
}
