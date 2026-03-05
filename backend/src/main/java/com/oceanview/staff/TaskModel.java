package com.oceanview.staff;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class TaskModel implements Serializable {
    private static final long serialVersionUID = 1L;

    private String taskId;
    private String title;
    private String description;
    private String assignedTo; // Staff ID
    private String status; // PENDING, IN_PROGRESS, COMPLETED, CANCELLED
    private String priority; // LOW, MEDIUM, HIGH, URGENT
    private LocalDate dueDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public TaskModel() {
        this.status = "PENDING";
        this.priority = "MEDIUM";
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public TaskModel(String taskId, String title, String description, String assignedTo,
            String status, String priority, LocalDate dueDate) {
        this();
        this.taskId = taskId;
        this.title = title;
        this.description = description;
        this.assignedTo = assignedTo;
        if (status != null)
            this.status = status;
        if (priority != null)
            this.priority = priority;
        this.dueDate = dueDate;
    }

    // Getters and Setters
    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(String assignedTo) {
        this.assignedTo = assignedTo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
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
}
