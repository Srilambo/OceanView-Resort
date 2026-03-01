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
    private String passportNumber;
    private LocalDateTime createdAt;

    public Guest() {}

    public Guest(String guestId, String name, String email, String contactNumber,
                 String address, String passportNumber) {
        this.guestId = guestId;
        this.name = name;
        this.email = email;
        this.contactNumber = contactNumber;
        this.address = address;
        this.passportNumber = passportNumber;
        this.createdAt = LocalDateTime.now();
    }

    public String getGuestId() { return guestId; }
    public void setGuestId(String guestId) { this.guestId = guestId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPassportNumber() { return passportNumber; }
    public void setPassportNumber(String passportNumber) { this.passportNumber = passportNumber; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Guest{" + "guestId='" + guestId + '\'' + ", name='" + name + '\'' +
               ", email='" + email + '\'' + '}';
    }
}
