package com.oceanview.staff;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class TaskService {
    private final TaskRepository taskRepository;

    public TaskService() {
        this.taskRepository = new TaskRepository();
    }

    public List<TaskModel> getAllTasks() throws SQLException {
        return taskRepository.findAll();
    }

    public List<TaskModel> getTasksByStaff(String staffId) throws SQLException {
        return taskRepository.findByAssignedTo(staffId);
    }

    public TaskModel createTask(TaskModel task) throws SQLException {
        if (task.getTaskId() == null || task.getTaskId().isEmpty()) {
            task.setTaskId("task-" + UUID.randomUUID().toString().substring(0, 8));
        }
        boolean saved = taskRepository.save(task);
        return saved ? task : null;
    }

    public TaskModel updateTask(TaskModel task) throws SQLException {
        boolean updated = taskRepository.update(task);
        return updated ? task : null;
    }

    public boolean updateTaskStatus(String taskId, String status) throws SQLException {
        return taskRepository.updateStatus(taskId, status);
    }

    public boolean deleteTask(String taskId) throws SQLException {
        return taskRepository.deleteById(taskId);
    }
}
