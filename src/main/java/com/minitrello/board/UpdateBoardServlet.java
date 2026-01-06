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

@WebServlet(name = "UpdateBoardServlet", urlPatterns = {"/boards/update"})
public class UpdateBoardServlet extends HttpServlet {
    private final BoardDAO boardDAO = new BoardDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please+sign+in");
            return;
        }

        User user = (User) session.getAttribute("user");
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");

        if (idStr == null || name == null || name.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/boards?error=Invalid+input");
            return;
        }

        try {
            Long boardId = Long.parseLong(idStr);
            Board board = boardDAO.getBoardById(boardId);

            if (board == null) {
                resp.sendRedirect(req.getContextPath() + "/boards?error=Board+not+found");
                return;
            }

            if (!board.getOwnerId().equals(user.getId())) {
                resp.sendRedirect(req.getContextPath() + "/boards?error=Unauthorized+action");
                return;
            }

            if (boardDAO.updateBoard(boardId, name)) {
                resp.sendRedirect(req.getContextPath() + "/boards?success=Board+updated");
            } else {
                resp.sendRedirect(req.getContextPath() + "/boards?error=Update+failed");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/boards?error=Invalid+board+ID");
        }
    }
}
