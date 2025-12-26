import util.DBConnection;
public class TestDB {
    public static void main(String[] args) {
        if (DBConnection.getConnection() != null) {
           System.out.println("\u2714 Connection successful!"); // ✅
        } else {
            System.out.println("\u274C Connection failed!"); 
        }
    }
}

