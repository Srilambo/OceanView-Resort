package com.oceanview.staff;

import com.oceanview.model.User;
import com.oceanview.service.UserService;
import java.sql.SQLException;
import java.util.*;

public class StaffService {
    private StaffRepository staffRepository;
    private UserService userService;

    public StaffService() {
        this.staffRepository = new StaffRepository();
        this.userService = new UserService();
    }

    public StaffModel createStaff(StaffModel staff) throws Exception {
        try {
            // Validate required fields
            if (staff.getFullName() == null || staff.getFullName().isEmpty()) {
                throw new Exception("Full name is required");
            }
            if (staff.getEmail() == null || staff.getEmail().isEmpty()) {
                throw new Exception("Email is required");
            }
            if (staff.getDepartment() == null || staff.getDepartment().isEmpty()) {
                throw new Exception("Department is required");
            }
            if (staff.getPosition() == null || staff.getPosition().isEmpty()) {
                throw new Exception("Position is required");
            }

            // Check if email already exists
            if (staffRepository.existsByEmail(staff.getEmail())) {
                throw new Exception("A staff member with this email already exists");
            }

            // Generate staff ID if not provided
            if (staff.getStaffId() == null || staff.getStaffId().isEmpty()) {
                staff.setStaffId(UUID.randomUUID().toString());
            }

            // Set defaults if not provided
            if (staff.getStatus() == null || staff.getStatus().isEmpty()) {
                staff.setStatus("ACTIVE");
            }
            if (staff.getShift() == null || staff.getShift().isEmpty()) {
                staff.setShift("MORNING");
            }

            // Also create a user account with ROLE_STAFF
            User user = new User(UUID.randomUUID().toString(),
                    staff.getEmail().split("@")[0], // username from email
                    "staff123", // default password
                    staff.getEmail());
            try {
                User registeredUser = userService.registerWithRoles(user,
                        new HashSet<>(Arrays.asList("ROLE_STAFF")));
                staff.setUserId(registeredUser.getUserId());
            } catch (Exception e) {
                // User might already exist - that's okay, continue
                System.out.println("Note: User account creation skipped - " + e.getMessage());
            }

            staffRepository.save(staff);
            return staff;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public List<StaffModel> getAllStaff() throws Exception {
        try {
            return staffRepository.findAll();
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public StaffModel getStaffById(String staffId) throws Exception {
        try {
            StaffModel staff = staffRepository.findById(staffId);
            if (staff == null) {
                throw new Exception("Staff member not found");
            }
            return staff;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public List<StaffModel> getStaffByDepartment(String department) throws Exception {
        try {
            return staffRepository.findByDepartment(department);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public List<StaffModel> getStaffByStatus(String status) throws Exception {
        try {
            return staffRepository.findByStatus(status);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public StaffModel updateStaff(StaffModel staff) throws Exception {
        try {
            if (staff.getStaffId() == null || staff.getStaffId().isEmpty()) {
                throw new Exception("Staff ID is required for update");
            }

            StaffModel existing = staffRepository.findById(staff.getStaffId());
            if (existing == null) {
                throw new Exception("Staff member not found");
            }

            staffRepository.update(staff);
            return staffRepository.findById(staff.getStaffId());
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public void deleteStaff(String staffId) throws Exception {
        try {
            StaffModel existing = staffRepository.findById(staffId);
            if (existing == null) {
                throw new Exception("Staff member not found");
            }
            staffRepository.deleteById(staffId);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public Map<String, Object> getStaffStats() throws Exception {
        try {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalActiveStaff", staffRepository.getStaffCount());
            stats.put("frontDesk", staffRepository.getStaffCountByDepartment("FRONT_DESK"));
            stats.put("housekeeping", staffRepository.getStaffCountByDepartment("HOUSEKEEPING"));
            stats.put("maintenance", staffRepository.getStaffCountByDepartment("MAINTENANCE"));
            stats.put("restaurant", staffRepository.getStaffCountByDepartment("RESTAURANT"));
            stats.put("security", staffRepository.getStaffCountByDepartment("SECURITY"));
            stats.put("management", staffRepository.getStaffCountByDepartment("MANAGEMENT"));
            return stats;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }
}
