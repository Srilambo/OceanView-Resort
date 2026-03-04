package com.oceanview.admin;

import com.oceanview.model.User;
import com.oceanview.service.UserService;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;

public class AdminService {
    private AdminRepository adminRepository;
    private UserService userService;

    public AdminService() {
        this.adminRepository = new AdminRepository();
        this.userService = new UserService();
    }

    public User createUserWithRoles(User user, Set<String> roles) throws Exception {
        return userService.registerWithRoles(user, roles);
    }

    public Map<String, Object> getAdminStats() throws Exception {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers", userService.getAllUsers().size());
        stats.put("totalReservations", adminRepository.getTotalReservationsCount());
        stats.put("totalRevenue", adminRepository.getTotalRevenue());
        stats.put("availableRoomsCount", adminRepository.getAvailableRoomsCount());
        return stats;
    }
}
