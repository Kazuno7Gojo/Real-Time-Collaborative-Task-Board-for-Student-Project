<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    com.minitrello.model.User currentUser = (com.minitrello.model.User) session.getAttribute("user");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Board</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="dark">
</head>
<body>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<main class="content">
<div class="container" style="max-width: 600px;">
    <div style="margin-bottom:32px; text-align: center;">
        <h1 style="font-size: 2.5rem; font-weight: 800; margin-bottom: 8px; letter-spacing: -0.02em;">Create New Board</h1>
        <p class="muted" style="font-size: 1.1rem;">Set up a new space for your team to collaborate.</p>
    </div>

    <% if (error != null) { %>
        <div class="banner error" style="margin-bottom: 24px;">
            <i data-lucide="alert-circle"></i>
            <%= error %>
        </div>
    <% } %>

    <div class="card" style="padding: 32px;">
        <form class="form" method="post" action="<%= request.getContextPath() %>/boards/create">
            <div class="field">
                <label for="name">Board Name</label>
                <input class="input" id="name" name="name" type="text" placeholder="e.g. Marketing Campaign, App Development..." required autofocus>
            </div>
            <div class="actions" style="margin-top: 24px; flex-direction: column; gap: 16px;">
                <button class="btn primary" type="submit" style="width: 100%; height: 48px; font-size: 1rem;">
                    <i data-lucide="plus"></i> Create Board
                </button>
                <a href="<%= request.getContextPath() %>/boards" class="btn outline" style="width: 100%; height: 48px;">
                    Cancel
                </a>
            </div>
        </form>
    </div>
 </div>
</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>