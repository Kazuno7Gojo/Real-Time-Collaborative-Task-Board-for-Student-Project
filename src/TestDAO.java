import dao.UserDAO;
import dao.BoardDAO;
import dao.TaskDAO;

public class TestDAO {
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        BoardDAO boardDAO = new BoardDAO();
        TaskDAO taskDAO = new TaskDAO();

        // Create a user
        userDAO.createUser("alice", "1234");

        // Create a board for user with id 1
        boardDAO.createBoard("Project Board", 1);

        // Create a task for board with id 1
        taskDAO.createTask("Finish setup", 1);

        System.out.println("✅ DAO methods tested");
    }
}
