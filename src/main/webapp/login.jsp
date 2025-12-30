<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    com.minitrello.model.User currentUser = (com.minitrello.model.User) session.getAttribute("user");
    String error = request.getParameter("error");
    boolean registered = "1".equals(request.getParameter("registered"));
    boolean success = "1".equals(request.getParameter("success"));
    boolean loggedOut = "1".equals(request.getParameter("logged_out"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mini‑Trello — Login</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="dark">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><rect width='24' height='24' rx='5' fill='%233b82f6'/><path d='M7 6h5v12H7zM13 10h5v8h-5z' fill='white'/></svg>">
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        .banner {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.95rem;
        }
        .banner.success { background: rgba(16, 185, 129, 0.1); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.2); }
        .banner.error { background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.2); }
        .banner.info { background: rgba(59, 130, 246, 0.1); color: #3b82f6; border: 1px solid rgba(59, 130, 246, 0.2); }
        .footer { margin-top: 32px; text-align: center; color: var(--muted); font-size: 0.85rem; }
        .logo-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, var(--primary), #8b5cf6);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            box-shadow: 0 10px 25px rgba(59, 130, 246, 0.35);
        }
    </style>
    </head>
<body>
<div class="container">
    <div class="brand" style="margin-bottom: 40px; justify-content: center; text-align: center; flex-direction: column; gap: 20px;">
        <div class="logo-icon">
            <i data-lucide="layout-dashboard" style="width: 28px; height: 28px;"></i>
        </div>
        <div>
            <h1 style="font-size: 2rem; font-weight: 800; letter-spacing: -0.02em;">Mini‑Trello</h1>
            <p class="muted" style="font-size: 1.1rem;">Real‑Time Collaborative Task Board</p>
        </div>
    </div>

    <% if (registered) { %>
        <div class="banner success">
            <i data-lucide="check-circle"></i>
            Registration complete — please log in below.
        </div>
    <% } %>
    <% if (loggedOut) { %>
        <div class="banner info">
            <i data-lucide="info"></i>
            You have been logged out safely.
        </div>
    <% } %>
    <% if (error != null) { %>
        <div class="banner error">
            <i data-lucide="alert-circle"></i>
            <%= error %>
        </div>
    <% } %>

    <% if (success && currentUser != null) { %>
        <div class="card" style="margin-bottom:24px; text-align: center;">
            <div class="user-avatar" style="width: 64px; height: 64px; font-size: 1.5rem; margin: 0 auto 16px;">
                <%= currentUser.getName().substring(0, 1).toUpperCase() %>
            </div>
            <h2 style="font-size: 1.5rem;">Welcome back!</h2>
            <p class="muted">Signed in as <strong><%= currentUser.getName() %></strong></p>
            <div class="actions" style="margin-top: 24px; justify-content: center;">
                <a class="btn" href="<%= request.getContextPath() %>/boards" style="width: 100%;">
                    Go to Dashboard <i data-lucide="arrow-right" style="margin-left: 8px;"></i>
                </a>
            </div>
            <div style="margin-top: 16px;">
                <a href="<%= request.getContextPath() %>/logout" class="muted" style="font-size: 0.9rem;">Not you? Sign out</a>
            </div>
        </div>
    <% } else { %>
        <div class="card" style="padding: 32px;">
            <h2 style="font-size: 1.5rem; margin-bottom: 8px;">Sign In</h2>
            <p class="muted" style="margin-bottom: 24px;">Enter your credentials to access your boards.</p>
            
            <form class="form" method="post" action="<%= request.getContextPath() %>/login">
                <div class="field">
                    <label for="email">Email Address</label>
                    <div style="position: relative;">
                        <i data-lucide="mail" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); width: 18px; color: var(--muted);"></i>
                        <input class="input" id="email" name="email" type="email" placeholder="you@example.com" required style="padding-left: 40px;">
                    </div>
                </div>
                <div class="field">
                    <label for="password">Password</label>
                    <div style="position: relative;">
                        <i data-lucide="lock" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); width: 18px; color: var(--muted);"></i>
                        <input class="input" id="password" name="password" type="password" placeholder="••••••••" required style="padding-left: 40px;">
                    </div>
                </div>
                <div class="actions" style="margin-top: 12px; flex-direction: column; align-items: stretch; gap: 20px;">
                    <button class="btn" type="submit" style="height: 48px; font-size: 1rem;">
                        Sign In
                    </button>
                    <div style="text-align: center;">
                        <span class="muted">New here? <a href="<%= request.getContextPath() %>/register.jsp" style="color: var(--primary); font-weight: 600;">Create an account</a></span>
                    </div>
                </div>
            </form>
        </div>
    <% } %>

    <div class="footer">
        <p>Built with Java Servlets • JSP • JDBC</p>
        <p style="margin-top: 8px; opacity: 0.5;">&copy; 2025 Mini‑Trello. All rights reserved.</p>
    </div>
</div>
<script>
    lucide.createIcons();
</script>
</body>
</html>