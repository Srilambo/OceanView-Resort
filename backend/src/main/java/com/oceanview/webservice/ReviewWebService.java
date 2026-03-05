package com.oceanview.webservice;

import com.oceanview.service.ReviewService;
import com.oceanview.model.Review;
import com.oceanview.util.LocalDateAdapter;
import com.oceanview.util.LocalDateTimeAdapter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class ReviewWebService {
    private ReviewService reviewService;
    private Gson gson;

    public ReviewWebService() {
        this.reviewService = new ReviewService();
        this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
    }

    public String getAllReviews() {
        try {
            List<Review> reviews = reviewService.getAllReviews();
            return buildJsonResponse(200, gson.toJson(reviews));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String createReview(String jsonBody) {
        try {
            Review review = gson.fromJson(jsonBody, Review.class);
            Review created = reviewService.createReview(review);
            return buildJsonResponse(201, gson.toJson(created));
        } catch (Exception e) {
            return buildJsonResponse(400, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    private String buildJsonResponse(int statusCode, String body) {
        String statusText = (statusCode == 200) ? "OK"
                : (statusCode == 201 ? "Created"
                        : (statusCode == 400 ? "Bad Request" : "Internal Server Error"));
        return "HTTP/1.1 " + statusCode + " " + statusText + "\r\n" +
                "Content-Type: application/json\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + body.length() + "\r\n" +
                "\r\n" + body;
    }
}
