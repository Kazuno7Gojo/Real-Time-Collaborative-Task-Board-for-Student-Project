package com.minitrello.board;

import com.minitrello.dao.BoardDAO;
import com.minitrello.model.Board;
import com.minitrello.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewBoardsServlet", urlPatterns = {"/boards"})
public class ViewBoardsServlet extends HttpServlet {
    private final BoardDAO boardDAO = new BoardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!ensureLoggedIn(req, resp)) return;
        User user = (User) req.getSession(false).getAttribute("user");
        List<Board> boards = boardDAO.listBoardsForUser(user.getId());
        req.setAttribute("boards", boards);
        req.getRequestDispatcher("/boards.jsp").forward(req, resp);
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