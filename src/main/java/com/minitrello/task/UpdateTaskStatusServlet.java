package com.minitrello.task;

import java.io.IOException;

import com.minitrello.dao.BoardDAO;
import com.minitrello.dao.TaskDAO;
import com.minitrello.model.Board;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UpdateTaskStatusServlet", urlPatterns = {"/tasks/update-status"})
public class UpdateTaskStatusServlet extends HttpServlet {
    private final TaskDAO taskDAO = new TaskDAO();
    private final BoardDAO boardDAO = new BoardDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!ensureLoggedIn(req, resp)) return;
        String taskIdStr = req.getParameter("taskId");
        String status = req.getParameter("status");
        String boardIdStr = req.getParameter("boardId");

        if (taskIdStr == null || status == null || boardIdStr == null) {
            resp.sendRedirect(req.getContextPath() + "/tasks.jsp?error=Missing+parameters&boardId=" + (boardIdStr == null ? "" : boardIdStr));
            return;
        }
        Long taskId = Long.valueOf(taskIdStr);
        Long boardId = Long.valueOf(boardIdStr);
        
        com.minitrello.model.Task task = taskDAO.getTaskById(taskId);
        Board board = boardDAO.getBoardById(boardId);
        com.minitrello.model.User currentUser = (com.minitrello.model.User) req.getSession(false).getAttribute("user");

        if (task == null || board == null) {
            resp.sendRedirect(req.getContextPath() + "/tasks.jsp?boardId=" + boardIdStr + "&error=Task+or+Board+not+found");
            return;
        }

        boolean isAssignee = task.getAssigneeId() != null && task.getAssigneeId().equals(currentUser.getId());
        boolean isOwner = board.getOwnerId().equals(currentUser.getId());

        if (!isAssignee && !isOwner) {
            resp.sendRedirect(req.getContextPath() + "/tasks.jsp?boardId=" + boardIdStr + "&error=Only+the+assignee+or+owner+can+update+task+status");
            return;
        }

        boolean ok = taskDAO.updateStatus(taskId, status);
        resp.sendRedirect(req.getContextPath() + "/tasks.jsp?boardId=" + boardIdStr + (ok ? "" : "&error=Failed+to+update"));
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