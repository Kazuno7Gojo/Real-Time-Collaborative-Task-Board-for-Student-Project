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
<div class="container">
    <div class="card" style="margin-bottom:16px;">
        <h2>Create Board</h2>
        <p class="muted">Organize tasks in a new space.</p>
    </div>

    <% if (error != null) { %>
        <div class="banner error"><%= error %></div>
    <% } %>

    <div class="card">
        <form class="form" method="post" action="<%= request.getContextPath() %>/boards/create">
            <div class="field">
                <label for="name">Board Name</label>
                <input class="input" id="name" name="name" type="text" placeholder="Project Alpha" required>
            </div>
            <div class="actions">
                <button class="btn primary" type="submit">Create</button>
                <a href="<%= request.getContextPath() %>/boards">Back to boards</a>
            </div>
        </form>
    </div>
 </div>
</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>