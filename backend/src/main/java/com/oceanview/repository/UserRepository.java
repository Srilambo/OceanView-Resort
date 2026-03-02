package com.oceanview.repository;

import com.oceanview.model.User;
import com.oceanview.db.DatabaseHelper;
import java.sql.*;
import java.util.*;

public class UserRepository {

    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setRoles(getUserRoles(user.getUserId()));
                return user;
            }
        }
        return null;
    }

    public boolean save(User user) throws SQLException {
        String sql = "INSERT INTO users (user_id, username, password, email, enabled) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUserId());
            pstmt.setString(2, user.getUsername());
            pstmt.setString(3, user.getPassword()); // In production, hash this
            pstmt.setString(4, user.getEmail());
            pstmt.setBoolean(5, true);

            int rowsAffected = pstmt.executeUpdate();

            // Default role
            addUserRole(user.getUserId(), "ROLE_USER");

            return rowsAffected > 0;
        }
    }

    private void addUserRole(String userId, String roleName) {
        String sql = "INSERT INTO user_roles (user_id, role) VALUES (?, ?)";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, roleName);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Warning: Could not add user role: " + e.getMessage());
        }
    }

    public boolean existsByUsername(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public Set<String> getUserRoles(String userId) {
        String sql = "SELECT role FROM user_roles WHERE user_id = ?";
        Set<String> roles = new HashSet<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                roles.add(rs.getString("role"));
            }
        } catch (SQLException e) {
            // Table may not exist yet - return default role
            System.err.println("Warning: Could not fetch user roles: " + e.getMessage());
            roles.add("ROLE_USER");
        }
        return roles;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getString("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setEnabled(rs.getBoolean("enabled"));
        return user;
    }
}
