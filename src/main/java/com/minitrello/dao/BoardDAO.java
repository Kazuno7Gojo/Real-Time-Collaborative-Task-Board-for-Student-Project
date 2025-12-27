package com.minitrello.dao;

import com.minitrello.db.DBConnection;
import com.minitrello.model.Board;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {

    public boolean createBoard(String name, Long ownerId) {
        String sqlBoard = "INSERT INTO boards(name, owner_id) VALUES(?, ?)";
        String sqlMember = "INSERT INTO board_members(board_id, user_id, role) VALUES(?, ?, 'OWNER')";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sqlBoard, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, name.trim());
                ps.setLong(2, ownerId);
                if (ps.executeUpdate() != 1) {
                    conn.rollback();
                    return false;
                }
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        long boardId = keys.getLong(1);
                        try (PreparedStatement pm = conn.prepareStatement(sqlMember)) {
                            pm.setLong(1, boardId);
                            pm.setLong(2, ownerId);
                            pm.executeUpdate();
                        }
                    }
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new RuntimeException("createBoard failed", e);
        }
    }

    public List<Board> listBoardsForUser(Long userId) {
        String sql = "SELECT b.id, b.name, b.owner_id, b.created_at " +
                "FROM boards b " +
                "JOIN board_members bm ON bm.board_id = b.id " +
                "WHERE bm.user_id = ? ORDER BY b.created_at DESC";
        List<Board> boards = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    boards.add(new Board(
                        rs.getLong("id"),
                        rs.getString("name"),
                        rs.getLong("owner_id"),
                        rs.getTimestamp("created_at")
                    ));
                }
            }
            return boards;
        } catch (SQLException e) {
            throw new RuntimeException("listBoardsForUser failed", e);
        }
    }

    public Board getBoardById(Long id) {
        String sql = "SELECT id, name, owner_id, created_at FROM boards WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Board(
                        rs.getLong("id"),
                        rs.getString("name"),
                        rs.getLong("owner_id"),
                        rs.getTimestamp("created_at")
                    );
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("getBoardById failed", e);
        }
    }

    public boolean addMember(Long boardId, Long userId, String role) {
        String sql = "INSERT INTO board_members(board_id, user_id, role) VALUES(?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, boardId);
            ps.setLong(2, userId);
            ps.setString(3, role);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            if (isDuplicate(e)) return false;
            throw new RuntimeException("addMember failed", e);
        }
    }

    public boolean removeMember(Long boardId, Long userId) {
        String sql = "DELETE FROM board_members WHERE board_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, boardId);
            ps.setLong(2, userId);
            int affected = ps.executeUpdate();
            return affected == 1;
        } catch (SQLException e) {
            throw new RuntimeException("removeMember failed", e);
        }
    }

    public List<Long> listMemberIds(Long boardId) {
        String sql = "SELECT user_id FROM board_members WHERE board_id = ?";
        List<Long> ids = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, boardId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getLong("user_id"));
                }
            }
            return ids;
        } catch (SQLException e) {
            throw new RuntimeException("listMemberIds failed", e);
        }
    }

    public boolean isMember(Long boardId, Long userId) {
        String sql = "SELECT 1 FROM board_members WHERE board_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, boardId);
            ps.setLong(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("isMember failed", e);
        }
    }

    private boolean isDuplicate(SQLException e) {
        String state = e.getSQLState();
        int code = e.getErrorCode();
        if ("23000".equals(state) && code == 1062) return true;
        String msg = e.getMessage();
        return msg != null && msg.toLowerCase().contains("duplicate");
    }
}