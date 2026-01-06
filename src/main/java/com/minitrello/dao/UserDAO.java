package com.minitrello.dao;

import com.minitrello.db.DBConnection;
import com.minitrello.model.User;
import com.minitrello.security.PasswordUtil;

import java.sql.*;

public class UserDAO {

    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("emailExists failed", e);
        }
    }

    public boolean createUser(String name, String email, String rawPassword) {
        String sql = "INSERT INTO users(name, email, password_hash) VALUES(?, ?, ?)";
        String hash = PasswordUtil.hash(rawPassword);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            ps.setString(2, email.toLowerCase().trim());
            ps.setString(3, hash);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            if (isUniqueViolation(e)) {
                return false;
            }
            throw new RuntimeException("createUser failed", e);
        }
    }

    public User authenticate(String email, String rawPassword) {
        String sql = "SELECT id, name, email, password_hash FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.toLowerCase().trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String stored = rs.getString("password_hash");
                    String provided = PasswordUtil.hash(rawPassword);
                    if (stored.equals(provided)) {
                        return new User(
                            rs.getLong("id"),
                            rs.getString("name"),
                            rs.getString("email"),
                            stored
                        );
                    }
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("authenticate failed", e);
        }
    }

    public User getById(Long id) {
        String sql = "SELECT id, name, email, password_hash FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getLong("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password_hash")
                    );
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("getById failed", e);
        }
    }

    public User getByEmail(String email) {
        String sql = "SELECT id, name, email, password_hash FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.toLowerCase().trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getLong("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password_hash")
                    );
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("getByEmail failed", e);
        }
    }

    private boolean isUniqueViolation(SQLException e) {
        String state = e.getSQLState();
        int code = e.getErrorCode();
        if ("23505".equals(state)) return true;
        if ("23000".equals(state) && code == 1062) return true;
        String msg = e.getMessage();
        return msg != null && msg.toLowerCase().contains("duplicate");
    }
}