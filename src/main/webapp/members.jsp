<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    java.util.List<com.minitrello.model.User> members = (java.util.List<com.minitrello.model.User>) request.getAttribute("members");
    Long boardId = (Long) request.getAttribute("boardId");
    Long ownerId = (Long) request.getAttribute("ownerId");
    String error = request.getParameter("error");
    com.minitrello.model.User currentUser = (com.minitrello.model.User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please+sign+in");
        return;
    }
    if (boardId == null) {
        String boardIdStr = request.getParameter("boardId");
        if (boardIdStr != null) {
            boardId = Long.valueOf(boardIdStr);
        }
    }
    if (boardId == null) {
        response.sendRedirect(request.getContextPath() + "/boards?error=Board+not+found");
        return;
    }
    com.minitrello.dao.BoardDAO bdao = new com.minitrello.dao.BoardDAO();
    if (!bdao.isMember(boardId, currentUser.getId())) {
        response.sendRedirect(request.getContextPath() + "/boards?error=Access+denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Members</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="dark">
</head>
<body>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<main class="content">
<div class="container">
    <div class="card" style="margin-bottom:16px;">
        <h2>Board Members</h2>
        <p class="muted">Manage collaborators for board #<%= boardId %></p>
    </div>

    <% if (error != null) { %>
        <div class="banner error"><%= error %></div>
    <% } %>

    <div class="card">
        <h2>Add Member</h2>
        <form class="form" method="post" action="<%= request.getContextPath() %>/members/add">
            <input type="hidden" name="boardId" value="<%= boardId %>">
            <div class="field">
                <label for="email">User Email</label>
                <input class="input" id="email" name="email" type="email" placeholder="user@example.com" required>
            </div>
            <div class="actions">
                <button class="btn primary" type="submit">Add</button>
                <a href="<%= request.getContextPath() %>/board?id=<%= boardId %>">Back to board</a>
            </div>
        </form>
    </div>

    <div class="card" style="margin-top:12px;">
        <h2>Current Members</h2>
        <% if (members == null || members.isEmpty()) { %>
            <p class="muted">No members yet.</p>
        <% } else { %>
            <ul>
                <% for (com.minitrello.model.User u : members) { %>
                    <li>
                        <span><%= u.getName() %> (<%= u.getEmail() %>)</span>
                        <% if (ownerId == null || !u.getId().equals(ownerId)) { %>
                            <form method="post" action="<%= request.getContextPath() %>/members/remove" style="display:inline;margin-left:8px;">
                                <input type="hidden" name="boardId" value="<%= boardId %>">
                                <input type="hidden" name="userId" value="<%= u.getId() %>">
                                <button class="btn outline" type="submit">Remove</button>
                            </form>
                        <% } else { %>
                            <span class="pill" style="margin-left:8px;">Owner</span>
                        <% } %>
                    </li>
                <% } %>
            </ul>
        <% } %>
    </div>
 </div>
</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>