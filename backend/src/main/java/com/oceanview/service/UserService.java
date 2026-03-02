package com.oceanview.service;

import com.oceanview.model.User;
import com.oceanview.repository.UserRepository;
import java.sql.SQLException;

public class UserService {
    private UserRepository userRepository;

    public UserService() {
        this.userRepository = new UserRepository();
    }

    public User authenticate(String username, String password) throws Exception {
        try {
            User user = userRepository.findByUsername(username);

            if (user != null && user.getPassword().equals(password)) {
                if (!user.isEnabled()) {
                    throw new Exception("Account is disabled");
                }
                return user;
            }
            throw new Exception("Invalid username or password");
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public User register(User user) throws Exception {
        try {
            if (userRepository.existsByUsername(user.getUsername())) {
                throw new Exception("Username already exists");
            }
            if (user.getUserId() == null || user.getUserId().isEmpty()) {
                user.setUserId(java.util.UUID.randomUUID().toString());
            }
            userRepository.save(user);
            return user;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public User getUserByUsername(String username) throws Exception {
        try {
            return userRepository.findByUsername(username);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }
}
