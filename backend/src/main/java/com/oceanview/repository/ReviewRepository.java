package com.oceanview.repository;

import com.oceanview.model.Review;
import com.oceanview.db.DatabaseHelper;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.*;

public class ReviewRepository {

    public List<Review> findAll() throws SQLException {
        String sql = "SELECT * FROM reviews ORDER BY created_at DESC";
        List<Review> reviews = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                reviews.add(mapResultSet(rs));
            }
        }
        return reviews;
    }

    public Review save(Review review) throws SQLException {
        String sql = "INSERT INTO reviews (review_id, guest_name, room_type, rating, title, comment, stay_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, review.getReviewId());
            pstmt.setString(2, review.getGuestName());
            pstmt.setString(3, review.getRoomType());
            pstmt.setInt(4, review.getRating());
            pstmt.setString(5, review.getTitle());
            pstmt.setString(6, review.getComment());
            pstmt.setDate(7, review.getStayDate() != null ? Date.valueOf(review.getStayDate()) : null);

            pstmt.executeUpdate();
            return review;
        }
    }

    private Review mapResultSet(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getString("review_id"));
        review.setGuestName(rs.getString("guest_name"));
        review.setRoomType(rs.getString("room_type"));
        review.setRating(rs.getInt("rating"));
        review.setTitle(rs.getString("title"));
        review.setComment(rs.getString("comment"));
        Date stayDate = rs.getDate("stay_date");
        if (stayDate != null) {
            review.setStayDate(stayDate.toLocalDate());
        }
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            review.setCreatedAt(createdAt.toLocalDateTime());
        }
        return review;
    }
}
