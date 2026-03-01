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

    public Set<String> getUserRoles(String userId) throws SQLException {
        String sql = "SELECT role_name FROM user_roles WHERE user_id = ?";
        Set<String> roles = new HashSet<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                roles.add(rs.getString("role_name"));
            }
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
