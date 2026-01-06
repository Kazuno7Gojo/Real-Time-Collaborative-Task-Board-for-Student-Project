package com.minitrello.auth;

import java.io.IOException;

import com.minitrello.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        if (isBlank(name) || isBlank(email) || isBlank(password)) {
            resp.sendRedirect(req.getContextPath() + "/register.jsp?error=Please+fill+all+fields");
            return;
        }
        if (!password.equals(confirm)) {
            resp.sendRedirect(req.getContextPath() + "/register.jsp?error=Passwords+do+not+match");
            return;
        }
        if (userDao.emailExists(email)) {
            resp.sendRedirect(req.getContextPath() + "/register.jsp?error=Email+already+registered");
            return;
        }
        boolean ok = userDao.createUser(name, email, password);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?registered=1");
        } else {
            resp.sendRedirect(req.getContextPath() + "/register.jsp?error=Registration+failed");
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}