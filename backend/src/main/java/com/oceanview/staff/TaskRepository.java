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

public class TaskRepository {

    public boolean save(TaskModel task) throws SQLException {
        String sql = "INSERT INTO tasks (task_id, title, description, assigned_to, status, priority, due_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, task.getTaskId());
            pstmt.setString(2, task.getTitle());
            pstmt.setString(3, task.getDescription());
            pstmt.setString(4, task.getAssignedTo());
            pstmt.setString(5, task.getStatus());
            pstmt.setString(6, task.getPriority());
            pstmt.setDate(7, task.getDueDate() != null ? java.sql.Date.valueOf(task.getDueDate()) : null);

            return pstmt.executeUpdate() > 0;
        }
    }

    public List<TaskModel> findAll() throws SQLException {
        String sql = "SELECT * FROM tasks ORDER BY due_date ASC, created_at DESC";
        List<TaskModel> taskList = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                taskList.add(mapResultSetToTask(rs));
            }
        }
        return taskList;
    }

    public TaskModel findById(String taskId) throws SQLException {
        String sql = "SELECT * FROM tasks WHERE task_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, taskId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToTask(rs);
            }
        }
        return null;
    }

    public List<TaskModel> findByAssignedTo(String staffId) throws SQLException {
        String sql = "SELECT * FROM tasks WHERE assigned_to = ? ORDER BY due_date ASC";
        List<TaskModel> taskList = new ArrayList<>();

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, staffId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                taskList.add(mapResultSetToTask(rs));
            }
        }
        return taskList;
    }

    public boolean update(TaskModel task) throws SQLException {
        String sql = "UPDATE tasks SET title = ?, description = ?, assigned_to = ?, " +
                "status = ?, priority = ?, due_date = ? WHERE task_id = ?";

        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, task.getTitle());
            pstmt.setString(2, task.getDescription());
            pstmt.setString(3, task.getAssignedTo());
            pstmt.setString(4, task.getStatus());
            pstmt.setString(5, task.getPriority());
            pstmt.setDate(6, task.getDueDate() != null ? java.sql.Date.valueOf(task.getDueDate()) : null);
            pstmt.setString(7, task.getTaskId());

            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(String taskId, String status) throws SQLException {
        String sql = "UPDATE tasks SET status = ? WHERE task_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, taskId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteById(String taskId) throws SQLException {
        String sql = "DELETE FROM tasks WHERE task_id = ?";
        try (Connection conn = DatabaseHelper.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, taskId);
            return pstmt.executeUpdate() > 0;
        }
    }

    private TaskModel mapResultSetToTask(ResultSet rs) throws SQLException {
        TaskModel task = new TaskModel();
        task.setTaskId(rs.getString("task_id"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setAssignedTo(rs.getString("assigned_to"));
        task.setStatus(rs.getString("status"));
        task.setPriority(rs.getString("priority"));

        java.sql.Date dueDate = rs.getDate("due_date");
        if (dueDate != null) {
            task.setDueDate(dueDate.toLocalDate());
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            task.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            task.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return task;
    }
}
