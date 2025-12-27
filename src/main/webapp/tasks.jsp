<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String boardIdStr = request.getParameter("boardId");
    String error = request.getParameter("error");
    java.util.List<com.minitrello.model.Task> tasks = null;
    com.minitrello.dao.UserDAO userDAO = new com.minitrello.dao.UserDAO();
    com.minitrello.dao.BoardDAO boardDAO = new com.minitrello.dao.BoardDAO();
    com.minitrello.model.User currentUser = (com.minitrello.model.User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please+sign+in");
        return;
    }
    if (boardIdStr != null) {
        Long boardId = Long.valueOf(boardIdStr);
        if (!boardDAO.isMember(boardId, currentUser.getId())) {
            response.sendRedirect(request.getContextPath() + "/boards?error=Access+denied");
            return;
        }
        com.minitrello.dao.TaskDAO dao = new com.minitrello.dao.TaskDAO();
        tasks = dao.listByBoard(boardId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tasks</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="dark">
</head>
<body>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<main class="content">
<div class="container">
    <div class="card" style="margin-bottom:16px;">
        <h2>Tasks</h2>
        <p class="muted">Manage tasks for board #<%= boardIdStr %></p>
    </div>

    <% if (error != null) { %>
        <div class="banner error"><%= error %></div>
    <% } %>

    <div class="grid grid-2">
      <div class="card">
        <h2>Create Task</h2>
        <form class="form" method="post" action="<%= request.getContextPath() %>/tasks/create">
            <input type="hidden" name="boardId" value="<%= boardIdStr %>">
            <div class="field">
                <label for="title">Title</label>
                <input class="input" id="title" name="title" type="text" placeholder="Implement login" required>
            </div>
            <div class="field">
                <label for="description">Description</label>
                <input class="input" id="description" name="description" type="text" placeholder="Optional details">
            </div>
            <div class="field">
                <label for="assigneeEmail">Assign to (email)</label>
                <input class="input" id="assigneeEmail" name="assigneeEmail" type="email" placeholder="user@example.com">
            </div>
            <div class="actions">
                <button class="btn primary" type="submit">Add Task</button>
                <a class="btn link" href="<%= request.getContextPath() %>/board?id=<%= boardIdStr %>">Back to board</a>
            </div>
        </form>
      </div>

      <div class="card">
        <h2>Task List</h2>
        <% if (tasks == null || tasks.isEmpty()) { %>
            <p class="muted">No tasks yet.</p>
        <% } else { %>
            <ul>
                <% for (com.minitrello.model.Task t : tasks) { %>
                    <li>
                        <div>
                            <strong><%= t.getTitle() %></strong> — <%= t.getStatus() %>
                        </div>
                        <% if (t.getDescription() != null && !t.getDescription().isEmpty()) { %>
                            <div class="muted" style="margin-top:4px;"><%= t.getDescription() %></div>
                        <% } %>
                        <% if (t.getAssigneeId() != null) { 
                               com.minitrello.model.User au = userDAO.getById(t.getAssigneeId());
                               if (au != null) { %>
                            <div class="muted" style="margin-top:4px;">Assigned to: <%= au.getName() %> (<%= au.getEmail() %>)</div>
                        <%   } 
                           } %>
                        <form style="display:inline; margin-left:8px;" method="post" action="<%= request.getContextPath() %>/tasks/update-status">
                            <input type="hidden" name="taskId" value="<%= t.getId() %>">
                            <input type="hidden" name="boardId" value="<%= boardIdStr %>">
                            <select name="status" class="input" style="width:auto; padding:6px 8px;">
                                <option <%= "TODO".equals(t.getStatus()) ? "selected" : "" %> value="TODO">To Do</option>
                                <option <%= "IN_PROGRESS".equals(t.getStatus()) ? "selected" : "" %> value="IN_PROGRESS">In Progress</option>
                                <option <%= "DONE".equals(t.getStatus()) ? "selected" : "" %> value="DONE">Done</option>
                            </select>
                            <button class="btn outline" type="submit">Update</button>
                        </form>
                    </li>
                <% } %>
            </ul>
        <% } %>
      </div>
    </div>

 </div>
</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>