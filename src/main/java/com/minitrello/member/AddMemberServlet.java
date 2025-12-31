package com.minitrello.member;

import java.io.IOException;

import com.minitrello.dao.BoardDAO;
import com.minitrello.dao.UserDAO;
import com.minitrello.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet(name = "AddMemberServlet", urlPatterns = {"/members/add"})
public class AddMemberServlet extends HttpServlet {
    private final BoardDAO boardDAO = new BoardDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!ensureLoggedIn(req, resp)) return;
        String boardIdStr = req.getParameter("boardId");
        String email = req.getParameter("email");
        if (boardIdStr == null || email == null || email.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/members?error=Missing+parameters&boardId=" + (boardIdStr == null ? "" : boardIdStr));
            return;
            
        }
        Long boardId = Long.valueOf(boardIdStr);
        User currentUser = (User) req.getSession(false).getAttribute("user");
        com.minitrello.model.Board b = boardDAO.getBoardById(boardId);

        if (b == null || !b.getOwnerId().equals(currentUser.getId())) {
            resp.sendRedirect(req.getContextPath() + "/members?boardId=" + boardId + "&error=Only+the+owner+can+invite+members");
            return;
        }

        User u = userDAO.getByEmail(email);
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/members?error=User+not+found&boardId=" + boardId);
            return;
        }
        if (boardDAO.isMember(boardId, u.getId())) {
            resp.sendRedirect(req.getContextPath() + "/members?error=User+is+already+a+member&boardId=" + boardId);
            return;
        }
        boolean ok = boardDAO.addMember(boardId, u.getId(), "MEMBER");
        resp.sendRedirect(req.getContextPath() + "/members?boardId=" + boardId + (ok ? "" : "&error=Already+member"));
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
