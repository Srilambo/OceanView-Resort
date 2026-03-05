package com.oceanview.db;

import com.oceanview.staff.StaffModel;
import com.oceanview.staff.StaffRepository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;

public class FixDatabase {
    public static void main(String[] args) {
        try (Connection conn = DatabaseHelper.getConnection()) {
            System.out.println("Checking for missing staff records...");

            String query = "SELECT u.user_id, u.username, u.email " +
                    "FROM users u " +
                    "JOIN user_roles ur ON u.user_id = ur.user_id " +
                    "WHERE ur.role = 'ROLE_STAFF' " +
                    "AND u.user_id NOT IN (SELECT user_id FROM staff WHERE user_id IS NOT NULL)";

            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            StaffRepository staffRepo = new StaffRepository();
            int count = 0;

            while (rs.next()) {
                String userId = rs.getString("user_id");
                String username = rs.getString("username");
                String email = rs.getString("email");

                System.out.println("Adding missing staff record for user: " + username);

                StaffModel staff = new StaffModel();
                staff.setStaffId(UUID.randomUUID().toString());
                staff.setUserId(userId);
                staff.setFullName(username);
                staff.setEmail(email);
                staff.setDepartment("FRONT_DESK");
                staff.setPosition("Staff Member");
                staff.setStatus("ACTIVE");
                staff.setShift("MORNING");
                staff.setSalary(0.0);
                staffRepo.save(staff);

                count++;
            }

            System.out.println("Successfully added " + count + " missing staff records.");
        } catch (Exception e) {
            System.err.println("Error fixing database: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
