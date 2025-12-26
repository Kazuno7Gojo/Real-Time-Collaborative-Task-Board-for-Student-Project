package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
        private static final String URL =
    "jdbc:mysql://localhost:3306/mini_trello?useSSL=false&allowPublicKeyRetrieval=true";
;
    private static final String USER = "root";
    private static final String PASSWORD = "Fiker4620!";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
