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

    public User findById(String userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setRoles(getUserRoles(user.getUserId()));
                return user;
            }
        }
        return null;
    }

    public boolean save(User user, Set<String> roles) throws SQLException {
        String sql = "INSERT INTO users (user_id, username, password, email, enabled) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUserId());
            pstmt.setString(2, user.getUsername());
            pstmt.setString(3, user.getPassword()); // In production, hash this
            pstmt.setString(4, user.getEmail());
            pstmt.setBoolean(5, true);

            int rowsAffected = pstmt.executeUpdate();

            // Custom roles or default
            if (roles == null || roles.isEmpty()) {
                addUserRole(user.getUserId(), "ROLE_USER");
            } else {
                for (String role : roles) {
                    addUserRole(user.getUserId(), role);
                }
            }

            return rowsAffected > 0;
        }
    }

    public boolean save(User user) throws SQLException {
        return save(user, null);
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

    public List<User> findAll() throws SQLException {
        String sql = "SELECT * FROM users";
        List<User> users = new ArrayList<>();
        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setRoles(getUserRoles(user.getUserId()));
                users.add(user);
            }
        }
        return users;
    }

    public List<User> findByRole(String role) throws SQLException {
        String sql = "SELECT u.* FROM users u JOIN user_roles ur ON u.user_id = ur.user_id WHERE ur.role = ?";
        List<User> users = new ArrayList<>();
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, role);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                user.setRoles(getUserRoles(user.getUserId()));
                users.add(user);
            }
        }
        return users;
    }

    public boolean deleteById(String userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean update(User user) throws SQLException {
        String sql = "UPDATE users SET username = ?, email = ?, enabled = ? WHERE user_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setBoolean(3, user.isEnabled());
            pstmt.setString(4, user.getUserId());

            int affected = pstmt.executeUpdate();

            // Update roles if they have changed
            if (user.getRoles() != null && !user.getRoles().isEmpty()) {
                removeAllRoles(user.getUserId());
                for (String role : user.getRoles()) {
                    addUserRole(user.getUserId(), role);
                }
            }

            return affected > 0;
        }
    }

    private void removeAllRoles(String userId) throws SQLException {
        String sql = "DELETE FROM user_roles WHERE user_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.executeUpdate();
        }
    }
}
