package com.minitrello.board;

import com.minitrello.dao.BoardDAO;
import com.minitrello.dao.TaskDAO;
import com.minitrello.model.Board;
import com.minitrello.model.Task;
import com.minitrello.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewBoardServlet", urlPatterns = {"/board"})
public class ViewBoardServlet extends HttpServlet {
    private final BoardDAO boardDAO = new BoardDAO();
    private final TaskDAO taskDAO = new TaskDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!ensureLoggedIn(req, resp)) return;
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/boards?error=Missing+board+id");
            return;
        }
        Long id = Long.valueOf(idStr);
        Board board = boardDAO.getBoardById(id);
        if (board == null) {
            resp.sendRedirect(req.getContextPath() + "/boards?error=Board+not+found");
            return;
        }
        User current = (User) req.getSession(false).getAttribute("user");
        if (!boardDAO.isMember(id, current.getId())) {
            resp.sendRedirect(req.getContextPath() + "/boards?error=Access+denied");
            return;
        }
        List<Task> tasks = taskDAO.listByBoard(id);
        req.setAttribute("board", board);
        req.setAttribute("tasks", tasks);
        req.getRequestDispatcher("/board.jsp").forward(req, resp);
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