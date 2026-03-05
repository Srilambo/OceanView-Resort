package com.oceanview.service;

import com.oceanview.model.User;
import com.oceanview.model.Guest;
import com.oceanview.repository.GuestRepository;
import com.oceanview.repository.UserRepository;
import java.sql.SQLException;
import java.util.List;

public class UserService {
    private UserRepository userRepository;
    private GuestRepository guestRepository;

    public UserService() {
        this.userRepository = new UserRepository();
        this.guestRepository = new GuestRepository();
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
        return registerWithRoles(user, null);
    }

    public User registerWithRoles(User user, java.util.Set<String> roles) throws Exception {
        try {
            if (userRepository.existsByUsername(user.getUsername())) {
                throw new Exception("Username already exists");
            }
            if (user.getUserId() == null || user.getUserId().isEmpty() || user.getUserId().length() == 36) {
                String prefix = "user";
                if (roles != null) {
                    if (roles.contains("ROLE_ADMIN"))
                        prefix = "admin";
                    else if (roles.contains("ROLE_STAFF") || roles.contains("ROLE_MANAGER"))
                        prefix = "staff-user";
                }
                user.setUserId(com.oceanview.db.DatabaseHelper.generateId("users", "user_id", prefix));
            }
            userRepository.save(user, roles);

            // Only create a guest profile for ROLE_USER accounts
            boolean isGuestRole = (roles == null) || roles.contains("ROLE_USER");
            if (isGuestRole) {
                try {
                    // Only create if one doesn't already exist for this email
                    Guest existing = guestRepository.findByEmail(user.getEmail());
                    if (existing == null) {
                        Guest guest = new Guest();
                        guest.setUserId(user.getUserId());
                        guest.setName(user.getUsername());
                        guest.setEmail(user.getEmail());
                        guest.setGuestId(com.oceanview.db.DatabaseHelper.generateId("guests", "guest_id", "guest"));
                        guestRepository.save(guest);
                        System.out.println("✅ Guest profile created for: " + user.getUsername());
                    } else {
                        // Link existing guest to the new user if not linked yet
                        if (existing.getUserId() == null || existing.getUserId().isEmpty()) {
                            existing.setUserId(user.getUserId());
                            guestRepository.update(existing);
                            System.out.println("🔗 Existing guest linked to user: " + user.getUsername());
                        }
                    }
                } catch (SQLException guestEx) {
                    // Log but don't fail the registration if guest creation fails
                    System.err.println("⚠️ Could not create guest profile for " + user.getUsername() + ": "
                            + guestEx.getMessage());
                }
            }

            return user;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public void deleteUser(String userId) throws Exception {
        try {
            userRepository.deleteById(userId);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public void updateUser(User user) throws Exception {
        try {
            userRepository.update(user);
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

    public List<User> getAllUsers() throws Exception {
        try {
            return userRepository.findAll();
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public List<User> getUsersByRole(String role) throws Exception {
        try {
            return userRepository.findByRole(role);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    // ========== Guest Related (Merged here) ==========

    public Guest getGuestByUserId(String userId) throws Exception {
        try {
            return guestRepository.findByUserId(userId);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Guest updateGuest(Guest guest) throws Exception {
        try {
            return guestRepository.update(guest);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }
}
