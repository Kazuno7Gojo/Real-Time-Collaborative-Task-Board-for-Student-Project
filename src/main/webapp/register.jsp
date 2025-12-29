<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mini‑Trello — Register</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="dark">
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
        .banner.error { background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.2); }
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
            <i data-lucide="user-plus" style="width: 28px; height: 28px;"></i>
        </div>
        <div>
            <h1 style="font-size: 2rem; font-weight: 800; letter-spacing: -0.02em;">Create Account</h1>
            <p class="muted" style="font-size: 1.1rem;">Join the Mini‑Trello community today.</p>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="banner error">
            <i data-lucide="alert-circle"></i>
            <%= error %>
        </div>
    <% } %>

    <div class="card" style="padding: 32px;">
        <h2 style="font-size: 1.5rem; margin-bottom: 8px;">Register</h2>
        <p class="muted" style="margin-bottom: 24px;">Sign up to start creating and sharing boards.</p>
        
        <form class="form" method="post" action="<%= request.getContextPath() %>/register">
            <div class="field">
                <label for="name">Full Name</label>
                <div style="position: relative;">
                    <i data-lucide="user" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); width: 18px; color: var(--muted);"></i>
                    <input class="input" id="name" name="name" type="text" placeholder="John Doe" required style="padding-left: 40px;" autofocus>
                </div>
            </div>
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
            <div class="field">
                <label for="confirm">Confirm Password</label>
                <div style="position: relative;">
                    <i data-lucide="shield-check" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); width: 18px; color: var(--muted);"></i>
                    <input class="input" id="confirm" name="confirm" type="password" placeholder="••••••••" required style="padding-left: 40px;">
                </div>
            </div>
            <div class="actions" style="margin-top: 12px; flex-direction: column; align-items: stretch; gap: 20px;">
                <button class="btn" type="submit" style="height: 48px; font-size: 1rem;">
                    Create Account
                </button>
                <div style="text-align: center;">
                    <span class="muted">Already have an account? <a href="<%= request.getContextPath() %>/login.jsp" style="color: var(--primary); font-weight: 600;">Sign in</a></span>
                </div>
            </div>
        </form>
    </div>

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