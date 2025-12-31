package com.minitrello.member;

import com.minitrello.dao.BoardDAO;
import com.minitrello.model.Board;
import com.minitrello.dao.UserDAO;
import com.minitrello.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "RemoveMemberServlet", urlPatterns = {"/members/remove"})
public class RemoveMemberServlet extends HttpServlet {
    private final BoardDAO boardDAO = new BoardDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!ensureLoggedIn(req, resp)) return;
        String boardIdStr = req.getParameter("boardId");
        String userIdStr = req.getParameter("userId");
        if (boardIdStr == null || userIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/members?error=Missing+parameters&boardId=" + (boardIdStr == null ? "" : boardIdStr));
            return;
        }
        Long boardId = Long.valueOf(boardIdStr);
        Long userId = Long.valueOf(userIdStr);

        User currentUser = (User) req.getSession(false).getAttribute("user");
        Board b = boardDAO.getBoardById(boardId);

        if (b == null || !b.getOwnerId().equals(currentUser.getId())) {
            resp.sendRedirect(req.getContextPath() + "/members?boardId=" + boardId + "&error=Only+the+owner+can+remove+members");
            return;
        }

        if (b.getOwnerId().equals(userId)) {
            resp.sendRedirect(req.getContextPath() + "/members?boardId=" + boardId + "&error=Cannot+remove+board+owner");
            return;
        }

        boolean ok = boardDAO.removeMember(boardId, userId);
        resp.sendRedirect(req.getContextPath() + "/members?boardId=" + boardId + (ok ? "" : "&error=Remove+failed"));
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
