package com.minitrello.task;

import java.io.IOException;

import com.minitrello.dao.BoardDAO;
import com.minitrello.dao.TaskDAO;
import com.minitrello.dao.UserDAO;
import com.minitrello.model.Board;
import com.minitrello.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CreateTaskServlet", urlPatterns = {"/tasks/create"})
public class CreateTaskServlet extends HttpServlet {
    private final TaskDAO taskDAO = new TaskDAO();
    private final UserDAO userDAO = new UserDAO();
    private final BoardDAO boardDAO = new BoardDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!ensureLoggedIn(req, resp)) return;
        String boardIdStr = req.getParameter("boardId");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String assigneeEmail = req.getParameter("assigneeEmail");

        if (boardIdStr == null || title == null || title.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/tasks.jsp?error=Missing+boardId+or+title&boardId=" + boardIdStr);
            return;
        }
        Long boardId = Long.valueOf(boardIdStr);
        Board board = boardDAO.getBoardById(boardId);
        User currentUser = (User) req.getSession(false).getAttribute("user");

        if (board == null) {
            resp.sendRedirect(req.getContextPath() + "/boards?error=Board+not+found");
            return;
        }

        Long assigneeId = null;
        // Only board owner can assign tasks to someone (including themselves)
        if (board.getOwnerId().equals(currentUser.getId())) {
            if (assigneeEmail != null && !assigneeEmail.trim().isEmpty()) {
                User assignee = userDAO.getByEmail(assigneeEmail);
                assigneeId = assignee == null ? null : assignee.getId();
            }
        } else {
            // If not owner, assignee is always null (or could be themselves, but prompt says "they can only assign task in there own boards")
            assigneeId = null;
        }

        boolean ok = taskDAO.createTask(boardId, title, description, assigneeId);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/tasks.jsp?boardId=" + boardId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/tasks.jsp?error=Failed+to+create+task&boardId=" + boardId);
        }
    }

    private boolean ensureLoggedIn(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please+sign+in");
            return false;
        }
        return true;
    }
}