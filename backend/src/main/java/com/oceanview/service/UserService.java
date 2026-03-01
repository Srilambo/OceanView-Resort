package com.oceanview.service;

import com.oceanview.model.User;
import java.util.*;

public class UserService {
    private List<User> users;

    public UserService() {
        initializeDefaultUsers();
    }

    private void initializeDefaultUsers() {
        users = new ArrayList<>();

        User admin = new User("1", "admin", "admin123", "admin@oceanview.com");
        admin.addRole("ADMIN");
        users.add(admin);

        User staff = new User("2", "staff", "staff123", "staff@oceanview.com");
        staff.addRole("STAFF");
        users.add(staff);
    }

    public User authenticate(String username, String password) throws Exception {
        for (User user : users) {
            if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
                if (user.isEnabled()) {
                    return user;
                } else {
                    throw new Exception("User account is disabled");
                }
            }
        }
        throw new Exception("Invalid username or password");
    }

    public User createUser(User user) throws Exception {
        if (findByUsername(user.getUsername()) != null) {
            throw new Exception("Username already exists");
        }
        user.setUserId(UUID.randomUUID().toString());
        users.add(user);
        return user;
    }

    public User findByUsername(String username) {
        return users.stream()
            .filter(u -> u.getUsername().equals(username))
            .findFirst()
            .orElse(null);
    }

    public User findById(String userId) {
        return users.stream()
            .filter(u -> u.getUserId().equals(userId))
            .findFirst()
            .orElse(null);
    }
}
