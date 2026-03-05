package com.oceanview.service;

import com.oceanview.model.Review;
import com.oceanview.repository.ReviewRepository;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class ReviewService {
    private ReviewRepository repository;

    public ReviewService() {
        this.repository = new ReviewRepository();
    }

    public List<Review> getAllReviews() throws Exception {
        try {
            return repository.findAll();
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Review createReview(Review review) throws Exception {
        try {
            if (review.getReviewId() == null || review.getReviewId().isEmpty()) {
                review.setReviewId(UUID.randomUUID().toString());
            }
            return repository.save(review);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }
}
