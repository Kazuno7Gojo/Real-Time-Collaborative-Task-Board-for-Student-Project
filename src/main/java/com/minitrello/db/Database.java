package com.minitrello.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class Database {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/java_user?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "";

    static {
        try {
            // ⚡ Load MySQL driver explicitly
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = getConnection()) {
                runSchemaScript(conn);
            }
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL Driver not found. Did you add the JAR to your project?", e);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize database schema", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }

    private static void runSchemaScript(Connection conn) throws SQLException {
        try (Statement st = conn.createStatement()) {
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS users (" +
                " id BIGINT AUTO_INCREMENT PRIMARY KEY," +
                " name VARCHAR(100) NOT NULL," +
                " email VARCHAR(255) NOT NULL UNIQUE," +
                " password_hash VARCHAR(256) NOT NULL," +
                " created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")"
            );
        }
    }
}
