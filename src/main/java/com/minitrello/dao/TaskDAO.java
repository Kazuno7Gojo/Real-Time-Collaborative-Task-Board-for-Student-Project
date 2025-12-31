package com.minitrello.dao;

import com.minitrello.db.DBConnection;
import com.minitrello.model.Task;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {

    public boolean createTask(Long boardId, String title, String description, Long assigneeId) {
        String sql = "INSERT INTO tasks(board_id, title, description, status, assignee_id) VALUES(?, ?, ?, 'TODO', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, boardId);
            ps.setString(2, title.trim());
            ps.setString(3, description == null ? "" : description.trim());
            if (assigneeId == null) ps.setNull(4, Types.BIGINT); else ps.setLong(4, assigneeId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("createTask failed", e);
        }
    }

    public boolean updateStatus(Long taskId, String status) {
        String sql = "UPDATE tasks SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setLong(2, taskId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("updateStatus failed", e);
        }
    }

    public Task getTaskById(Long id) {
        String sql = "SELECT id, board_id, title, description, status, assignee_id, created_at, updated_at FROM tasks WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Task(
                        rs.getLong("id"),
                        rs.getLong("board_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("status"),
                        rs.getObject("assignee_id") == null ? null : rs.getLong("assignee_id"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                    );
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("getTaskById failed", e);
        }
    }

    public List<Task> listByBoard(Long boardId) {
        String sql = "SELECT id, board_id, title, description, status, assignee_id, created_at, updated_at FROM tasks WHERE board_id = ? ORDER BY created_at DESC";
        List<Task> tasks = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, boardId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tasks.add(new Task(
                        rs.getLong("id"),
                        rs.getLong("board_id"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("status"),
                        rs.getObject("assignee_id") == null ? null : rs.getLong("assignee_id"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                    ));
                }
            }
            return tasks;
        } catch (SQLException e) {
            throw new RuntimeException("listByBoard failed", e);
        }
    }
}