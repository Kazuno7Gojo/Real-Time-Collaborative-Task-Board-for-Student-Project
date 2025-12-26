package dao;
import util.DBConnection;
public class BoardDAO {

    public boolean createBoard(String name, int ownerId) {
        String sql = "INSERT INTO boards(name, owner_id) VALUES (?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setInt(2, ownerId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
