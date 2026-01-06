package com.minitrello.auth;

import java.io.IOException;

import com.minitrello.dao.UserDAO;
import com.minitrello.model.User;
import com.minitrello.concurrent.UserWorker;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private final UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (isBlank(email) || isBlank(password)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please+enter+email+and+password");
            return;
        }

        User user = userDao.authenticate(email, password);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+credentials");
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);
        // Start a dedicated per-user worker thread and keep it in the session
        UserWorker worker = new UserWorker(user);
        worker.start();
        session.setAttribute("userWorker", worker);
        resp.sendRedirect(req.getContextPath() + "/boards");
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}