package com.oceanview.staff;

import com.oceanview.db.DatabaseHelper;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

public class StaffRepository {

    public boolean save(StaffModel staff) throws SQLException {
        String sql = "INSERT INTO staff (staff_id, user_id, full_name, email, phone, address, date_of_birth, emergency_contact, department, position, salary, status, shift, hire_date) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, staff.getStaffId());
            pstmt.setString(2, staff.getUserId());
            pstmt.setString(3, staff.getFullName());
            pstmt.setString(4, staff.getEmail());
            pstmt.setString(5, staff.getPhone());
            pstmt.setString(6, staff.getAddress());
            pstmt.setDate(7, staff.getDateOfBirth() != null ? java.sql.Date.valueOf(staff.getDateOfBirth()) : null);
            pstmt.setString(8, staff.getEmergencyContact());
            pstmt.setString(9, staff.getDepartment());
            pstmt.setString(10, staff.getPosition());
            pstmt.setDouble(11, staff.getSalary());
            pstmt.setString(12, staff.getStatus());
            pstmt.setString(13, staff.getShift());
            pstmt.setTimestamp(14, staff.getHireDate() != null ? Timestamp.valueOf(staff.getHireDate())
                    : Timestamp.valueOf(LocalDateTime.now()));

            return pstmt.executeUpdate() > 0;
        }
    }

    public List<StaffModel> findAll() throws SQLException {
        String sql = "SELECT * FROM staff ORDER BY created_at DESC";
        List<StaffModel> staffList = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                staffList.add(mapResultSetToStaff(rs));
            }
        }
        return staffList;
    }

    public StaffModel findById(String staffId) throws SQLException {
        String sql = "SELECT * FROM staff WHERE staff_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, staffId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToStaff(rs);
            }
        }
        return null;
    }

    public List<StaffModel> findByDepartment(String department) throws SQLException {
        String sql = "SELECT * FROM staff WHERE department = ? ORDER BY full_name";
        List<StaffModel> staffList = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, department);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                staffList.add(mapResultSetToStaff(rs));
            }
        }
        return staffList;
    }

    public List<StaffModel> findByStatus(String status) throws SQLException {
        String sql = "SELECT * FROM staff WHERE status = ? ORDER BY full_name";
        List<StaffModel> staffList = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                staffList.add(mapResultSetToStaff(rs));
            }
        }
        return staffList;
    }

    public boolean update(StaffModel staff) throws SQLException {
        String sql = "UPDATE staff SET full_name = ?, email = ?, phone = ?, address = ?, " +
                "date_of_birth = ?, emergency_contact = ?, department = ?, " +
                "position = ?, salary = ?, status = ?, shift = ? WHERE staff_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, staff.getFullName());
            pstmt.setString(2, staff.getEmail());
            pstmt.setString(3, staff.getPhone());
            pstmt.setString(4, staff.getAddress());
            pstmt.setDate(5, staff.getDateOfBirth() != null ? java.sql.Date.valueOf(staff.getDateOfBirth()) : null);
            pstmt.setString(6, staff.getEmergencyContact());
            pstmt.setString(7, staff.getDepartment());
            pstmt.setString(8, staff.getPosition());
            pstmt.setDouble(9, staff.getSalary());
            pstmt.setString(10, staff.getStatus());
            pstmt.setString(11, staff.getShift());
            pstmt.setString(12, staff.getStaffId());

            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(String staffId) throws SQLException {
        String sql = "DELETE FROM staff WHERE staff_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, staffId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public int getStaffCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM staff WHERE status = 'ACTIVE'";
        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getStaffCountByDepartment(String department) throws SQLException {
        String sql = "SELECT COUNT(*) FROM staff WHERE department = ? AND status = 'ACTIVE'";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, department);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM staff WHERE email = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    private StaffModel mapResultSetToStaff(ResultSet rs) throws SQLException {
        StaffModel staff = new StaffModel();
        staff.setStaffId(rs.getString("staff_id"));
        staff.setUserId(rs.getString("user_id"));
        staff.setFullName(rs.getString("full_name"));
        staff.setEmail(rs.getString("email"));
        staff.setPhone(rs.getString("phone"));
        staff.setAddress(rs.getString("address"));

        java.sql.Date dob = rs.getDate("date_of_birth");
        if (dob != null) {
            staff.setDateOfBirth(dob.toLocalDate());
        }

        staff.setEmergencyContact(rs.getString("emergency_contact"));
        staff.setDepartment(rs.getString("department"));
        staff.setPosition(rs.getString("position"));
        staff.setSalary(rs.getDouble("salary"));
        staff.setStatus(rs.getString("status"));
        staff.setShift(rs.getString("shift"));

        Timestamp hireDate = rs.getTimestamp("hire_date");
        if (hireDate != null) {
            staff.setHireDate(hireDate.toLocalDateTime());
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            staff.setCreatedAt(createdAt.toLocalDateTime());
        }

        return staff;
    }
}
