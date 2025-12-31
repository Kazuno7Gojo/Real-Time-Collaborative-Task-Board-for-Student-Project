package com.minitrello.board;

import com.minitrello.dao.BoardDAO;
import com.minitrello.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "CreateBoardServlet", urlPatterns = {"/boards/create"})
public class CreateBoardServlet extends HttpServlet {
    private final BoardDAO boardDAO = new BoardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!ensureLoggedIn(req, resp)) return;
        req.getRequestDispatcher("/createBoard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!ensureLoggedIn(req, resp)) return;
        String name = req.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/createBoard.jsp?error=Board+name+required");
            return;
        }
        User user = (User) req.getSession(false).getAttribute("user");
        boolean ok = boardDAO.createBoard(name, user.getId());
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/boards");
        } else {
            resp.sendRedirect(req.getContextPath() + "/createBoard.jsp?error=Failed+to+create+board");
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