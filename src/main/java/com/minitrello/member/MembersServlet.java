package com.minitrello.member;

import com.minitrello.dao.BoardDAO;
import com.minitrello.dao.UserDAO;
import com.minitrello.model.Board;
import com.minitrello.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "MembersServlet", urlPatterns = {"/members"})
public class MembersServlet extends HttpServlet {
    private final BoardDAO boardDAO = new BoardDAO();
    private final UserDAO userDAO = new UserDAO();

    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!ensureLoggedIn(req, resp)) return;
        String boardIdStr = req.getParameter("boardId");
        if (boardIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/boards?error=Missing+boardId");
            return;
        }
        Long boardId = Long.valueOf(boardIdStr);
        User current = (User) req.getSession(false).getAttribute("user");
        if (!boardDAO.isMember(boardId, current.getId())) {
            resp.sendRedirect(req.getContextPath() + "/boards?error=Access+denied");
            return;
        }
        List<Long> ids = boardDAO.listMemberIds(boardId);
        List<User> members = new ArrayList<>();
        for (Long id : ids) {
            User u = userDAO.getById(id);
            if (u != null) members.add(u);
        }
        Board b = boardDAO.getBoardById(boardId);
        if (b != null) {
            req.setAttribute("ownerId", b.getOwnerId());
        }
        req.setAttribute("members", members);
        req.setAttribute("boardId", boardId);
        req.getRequestDispatcher("/members.jsp").forward(req, resp);
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
