package com.minitrello.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            Object w = session.getAttribute("userWorker");
            if (w instanceof com.minitrello.concurrent.UserWorker) {
                ((com.minitrello.concurrent.UserWorker) w).stop();
            }
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/login.jsp?logged_out=1");
    }
}