package com.oceanview.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Review implements Serializable {
    private static final long serialVersionUID = 1L;

    private String reviewId;
    private String guestName;
    private String roomType;
    private int rating;
    private String title;
    private String comment;
    private LocalDate stayDate;
    private LocalDateTime createdAt;

    public Review() {
    }

    public Review(String reviewId, String guestName, String roomType, int rating,
            String title, String comment, LocalDate stayDate) {
        this.reviewId = reviewId;
        this.guestName = guestName;
        this.roomType = roomType;
        this.rating = rating;
        this.title = title;
        this.comment = comment;
        this.stayDate = stayDate;
        this.createdAt = LocalDateTime.now();
    }

    public String getReviewId() {
        return reviewId;
    }

    public void setReviewId(String reviewId) {
        this.reviewId = reviewId;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDate getStayDate() {
        return stayDate;
    }

    public void setStayDate(LocalDate stayDate) {
        this.stayDate = stayDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
