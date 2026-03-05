package com.oceanview.admin;

import com.oceanview.model.User;
import com.oceanview.service.UserService;
import com.oceanview.staff.StaffModel;
import com.oceanview.staff.StaffRepository;
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
        User createdUser = userService.registerWithRoles(user, roles);

        if (roles != null && roles.contains("ROLE_STAFF")) {
            StaffRepository staffRepo = new StaffRepository();
            if (!staffRepo.existsByEmail(user.getEmail())) {
                StaffModel staff = new StaffModel();
                staff.setStaffId(com.oceanview.db.DatabaseHelper.generateId("staff", "staff_id", "staff"));
                staff.setUserId(createdUser.getUserId());
                staff.setFullName(user.getUsername());
                staff.setEmail(user.getEmail());
                staff.setDepartment("FRONT_DESK");
                staff.setPosition("Staff Member");
                staff.setStatus("ACTIVE");
                staff.setShift("MORNING");
                staff.setSalary(0.0);
                staffRepo.save(staff);
            }
        }

        return createdUser;
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
