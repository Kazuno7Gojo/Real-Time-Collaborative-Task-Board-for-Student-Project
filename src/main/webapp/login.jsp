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
    </head>
<body>
<div class="container">
    <div class="brand">
        <div class="logo"></div>
        <div>
            <h1>Mini‑Trello</h1>
            <p class="muted">Real‑Time Collaborative Task Board — Auth</p>
        </div>
    </div>

    <% if (registered) { %>
        <div class="banner success">Registration complete — please log in below.</div>
    <% } %>
    <% if (loggedOut) { %>
        <div class="banner info">You have been logged out safely.</div>
    <% } %>
    <% if (error != null) { %>
        <div class="banner error"><%= error %></div>
    <% } %>

    <% if (success && currentUser != null) { %>
        <div class="card" style="margin-bottom:16px;">
            <h2>Welcome</h2>
            <p>Signed in as <strong><%= currentUser.getName() %></strong> (<%= currentUser.getEmail() %>).</p>
            <div class="actions">
                <a class="btn" href="<%= request.getContextPath() %>/boards">Go to Boards</a>
                <a class="btn" href="<%= request.getContextPath() %>/logout">Log out</a>
            </div>
        </div>
    <% } %>

    <div class="card">
        <h2>Log In</h2>
        <form class="form" method="post" action="<%= request.getContextPath() %>/login">
            <div class="field">
                <label for="email">Email</label>
                <input class="input" id="email" name="email" type="email" placeholder="you@example.com" required>
            </div>
            <div class="field">
                <label for="password">Password</label>
                <input class="input" id="password" name="password" type="password" placeholder="••••••••" required>
            </div>
            <div class="actions">
                <button class="btn" type="submit">Sign in</button>
                <span class="muted">New here? <a href="<%= request.getContextPath() %>/register.jsp">Create an account</a></span>
            </div>
        </form>
    </div>

    <div class="footer">Built with Java Servlets + JSP + JDBC.</div>
</div>
</body>
</html>
