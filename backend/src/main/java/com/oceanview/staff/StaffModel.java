package com.oceanview.staff;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class StaffModel implements Serializable {
    private static final long serialVersionUID = 1L;

    private String staffId;
    private String userId; // Links to users table
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private LocalDate dateOfBirth;
    private String emergencyContact;
    private String department; // FRONT_DESK, HOUSEKEEPING, MAINTENANCE, RESTAURANT, SECURITY, MANAGEMENT
    private String position; // e.g., Receptionist, Housekeeper, Chef, Manager
    private double salary;
    private String status; // ACTIVE, ON_LEAVE, TERMINATED
    private String shift; // MORNING, AFTERNOON, NIGHT
    private LocalDateTime hireDate;
    private LocalDateTime createdAt;

    public StaffModel() {
        this.status = "ACTIVE";
        this.createdAt = LocalDateTime.now();
    }

    public StaffModel(String staffId, String fullName, String email, String phone,
            String department, String position, double salary, String shift) {
        this();
        this.staffId = staffId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.department = department;
        this.position = position;
        this.salary = salary;
        this.shift = shift;
        this.hireDate = LocalDateTime.now();
    }

    // Getters and Setters
    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public double getSalary() {
        return salary;
    }

    public void setSalary(double salary) {
        this.salary = salary;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getShift() {
        return shift;
    }

    public void setShift(String shift) {
        this.shift = shift;
    }

    public LocalDateTime getHireDate() {
        return hireDate;
    }

    public void setHireDate(LocalDateTime hireDate) {
        this.hireDate = hireDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getEmergencyContact() {
        return emergencyContact;
    }

    public void setEmergencyContact(String emergencyContact) {
        this.emergencyContact = emergencyContact;
    }
}
