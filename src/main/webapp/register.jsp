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
</head>
<body>
<div class="container">
    <div class="brand">
        <div class="logo"></div>
        <div>
            <h1>Create Your Account</h1>
            <p class="muted">Join Mini‑Trello and start collaborating.</p>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="banner error"><%= error %></div>
    <% } %>

    <div class="card">
        <h2>Register</h2>
        <form class="form" method="post" action="<%= request.getContextPath() %>/register">
            <div class="field">
                <label for="name">Full Name</label>
                <input class="input" id="name" name="name" type="text" placeholder="Your Name" required>
            </div>
            <div class="field">
                <label for="email">Email</label>
                <input class="input" id="email" name="email" type="email" placeholder="you@example.com" required>
            </div>
            <div class="field">
                <label for="password">Password</label>
                <input class="input" id="password" name="password" type="password" required>
            </div>
            <div class="field">
                <label for="confirm">Confirm Password</label>
                <input class="input" id="confirm" name="confirm" type="password" required>
            </div>
            <div class="actions">
                <button class="btn" type="submit">Create account</button>
                <span class="muted">Already have an account? <a href="<%= request.getContextPath() %>/login.jsp">Sign in</a></span>
            </div>
        </form>
    </div>

    <div class="footer">Java Servlets + JSP + JDBC.</div>
</div>
</body>
</html>