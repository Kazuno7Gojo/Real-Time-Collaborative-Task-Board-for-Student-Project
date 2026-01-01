<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String boardIdStr = request.getParameter("boardId");
    String error = request.getParameter("error");
    java.util.List<com.minitrello.model.Task> tasks = null;
    com.minitrello.model.Board board = null;
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
        board = boardDAO.getBoardById(boardId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tasks - <%= board != null ? board.getName() : "" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="dark">
</head>
<body>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<main class="content">
<div class="container">
    <div style="margin-bottom:32px; display: flex; justify-content: space-between; align-items: flex-end;">
        <div>
            <h1 style="font-size: 2.5rem; font-weight: 800; margin-bottom: 8px; letter-spacing: -0.02em;">Tasks</h1>
            <p class="muted" style="font-size: 1.1rem;">Manage and track progress for <strong><%= board != null ? board.getName() : "Board #" + boardIdStr %></strong></p>
        </div>
        <div class="actions">
            <a class="btn" href="<%= request.getContextPath() %>/board?id=<%= boardIdStr %>">
                <i data-lucide="chevron-left"></i> Back to Board
            </a>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="banner error" style="margin-bottom: 24px;">
            <i data-lucide="alert-circle"></i>
            <%= error %>
        </div>
    <% } %>
    <% if (request.getParameter("success") != null) { %>
        <div class="banner success" style="margin-bottom: 24px;">
            <i data-lucide="check-circle"></i>
            <%= request.getParameter("success") %>
        </div>
    <% } %>

    <div class="grid grid-2">
      <div class="card">
        <div style="display:flex; align-items:center; gap:10px; margin-bottom:20px;">
            <i data-lucide="plus-square" style="color:var(--primary);"></i>
            <h2 style="margin:0;">Create Task</h2>
        </div>
        <form class="form" method="post" action="<%= request.getContextPath() %>/tasks/create">
            <input type="hidden" name="boardId" value="<%= boardIdStr %>">
            <div class="field">
                <label for="title">Task Title</label>
                <input class="input" id="title" name="title" type="text" placeholder="e.g. Implement user authentication" required autofocus>
            </div>
            <div class="field">
                <label for="description">Description (Optional)</label>
                <textarea class="input" id="description" name="description" rows="3" style="resize: vertical;" placeholder="Provide more details about this task..."></textarea>
            </div>
            <% if (board != null && currentUser.getId().equals(board.getOwnerId())) { %>
            <div class="field">
                <label for="assigneeEmail">Assign to (Email)</label>
                <div style="position: relative;">
                    <i data-lucide="mail" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); width: 16px; color: var(--muted);"></i>
                    <input class="input" id="assigneeEmail" name="assigneeEmail" type="email" placeholder="user@example.com" style="padding-left: 40px;">
                </div>
            </div>
            <% } %>
            <div class="actions" style="margin-top: 16px;">
                <button class="btn primary" type="submit" style="width: 100%;">
                    <i data-lucide="plus"></i> Add Task
                </button>
            </div>
        </form>
      </div>

      <div class="card">
        <div style="display:flex; align-items:center; gap:10px; margin-bottom:20px;">
            <i data-lucide="list-todo" style="color:var(--primary);"></i>
            <h2 style="margin:0;">Task List</h2>
        </div>
        <% if (tasks == null || tasks.isEmpty()) { %>
            <div style="text-align: center; padding: 40px 20px;">
                <i data-lucide="clipboard-list" style="width: 48px; height: 48px; color: var(--border); margin-bottom: 16px;"></i>
                <p class="muted">No tasks found on this board.</p>
            </div>
        <% } else {
            %><div class="item-list">
                <% for (com.minitrello.model.Task t : tasks) { %>
                    <div class="item" style="flex-direction: column; align-items: flex-start; gap: 12px; padding: 16px;">
                        <div style="width: 100%; display: flex; justify-content: space-between; align-items: flex-start;">
                            <div style="font-weight: 700; font-size: 1.1rem;"><%= t.getTitle() %></div>
                            <span class="pill <%= t.getStatus().toLowerCase().replace("_", "") %>">
                                <%= t.getStatus().replace("_", " ") %>
                            </span>
                        </div>
                        
                        <% if (t.getDescription() != null && !t.getDescription().isEmpty()) { %>
                            <div class="muted" style="font-size: 0.9rem;"><%= t.getDescription() %></div>
                        <% } %>
                        
                        <div style="width: 100%; display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border); margin-top: 4px; padding-top: 12px;">
                            <div class="muted" style="font-size: 0.85rem; display: flex; align-items: center; gap: 6px;">
                                <% if (t.getAssigneeId() != null) { 
                                       com.minitrello.model.User au = userDAO.getById(t.getAssigneeId());
                                       if (au != null) { %>
                                    <i data-lucide="user" style="width:14px;"></i>
                                    <%= au.getName() %>
                                <%   } 
                                   } else { %>
                                    <i data-lucide="user-plus" style="width:14px;"></i>
                                    Unassigned
                                <% } %>
                            </div>
                            
                            <% 
                               boolean canUpdate = (t.getAssigneeId() != null && t.getAssigneeId().equals(currentUser.getId())) || 
                                                  (board != null && currentUser.getId().equals(board.getOwnerId()));
                               if (canUpdate) { 
                            %>
                            <form method="post" action="<%= request.getContextPath() %>/tasks/update-status" style="display: flex; gap: 6px;">
                                <input type="hidden" name="taskId" value="<%= t.getId() %>">
                                <input type="hidden" name="boardId" value="<%= boardIdStr %>">
                                <select name="status" class="input" style="padding: 4px 8px; font-size: 0.85rem; height: 32px;">
                                    <option <%= "TODO".equals(t.getStatus()) ? "selected" : "" %> value="TODO">To Do</option>
                                    <option <%= "IN_PROGRESS".equals(t.getStatus()) ? "selected" : "" %> value="IN_PROGRESS">In Progress</option>
                                    <option <%= "DONE".equals(t.getStatus()) ? "selected" : "" %> value="DONE">Done</option>
                                </select>
                                <button class="btn primary" type="submit" style="height: 32px; padding: 0 8px;" title="Update Status">
                                    <i data-lucide="check" style="width:16px;"></i>
                                </button>
                            </form>
                            <% } else { %>
                                <div class="muted" style="font-size: 0.85rem; font-style: italic;">
                                    Read-only (Owner or Assignee only)
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
      </div>
    </div>
 </div>
</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>