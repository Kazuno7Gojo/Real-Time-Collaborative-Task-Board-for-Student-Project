package com.minitrello.task;

import com.minitrello.dao.TaskDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "UpdateTaskStatusServlet", urlPatterns = {"/tasks/update-status"})
public class UpdateTaskStatusServlet extends HttpServlet {
    private final TaskDAO taskDAO = new TaskDAO();

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