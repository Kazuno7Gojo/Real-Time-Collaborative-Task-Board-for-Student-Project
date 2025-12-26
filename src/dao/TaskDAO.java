package dao;

import util.DBConnection;
import java.sql.*;
public class TaskDAO {

    public boolean createTask(String title, int boardId) {
        String sql =
          "INSERT INTO tasks(title, status, board_id) VALUES (?, 'TODO', ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setInt(2, boardId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
