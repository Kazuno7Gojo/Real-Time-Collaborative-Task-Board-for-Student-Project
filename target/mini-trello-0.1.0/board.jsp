<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    com.minitrello.model.Board board = (com.minitrello.model.Board) request.getAttribute("board");
    java.util.List<com.minitrello.model.Task> tasks = (java.util.List<com.minitrello.model.Task>) request.getAttribute("tasks");
    com.minitrello.model.User currentUser = (com.minitrello.model.User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please+sign+in");
        return;
    }
    if (board == null) {
        String boardIdStr = request.getParameter("id");
        if (boardIdStr != null) {
            Long boardId = Long.valueOf(boardIdStr);
            com.minitrello.dao.BoardDAO bdao = new com.minitrello.dao.BoardDAO();
            board = bdao.getBoardById(boardId);
            if (board == null) {
                response.sendRedirect(request.getContextPath() + "/boards?error=Board+not+found");
                return;
            }
            if (!bdao.isMember(boardId, currentUser.getId())) {
                response.sendRedirect(request.getContextPath() + "/boards?error=Access+denied");
                return;
            }
            com.minitrello.dao.TaskDAO tdao = new com.minitrello.dao.TaskDAO();
            tasks = tdao.listByBoard(boardId);
        }
    }
    if (board == null) {
        response.sendRedirect(request.getContextPath() + "/boards?error=Board+not+found");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Board</title>
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
            <h1 style="font-size: 2.5rem; font-weight: 800; margin-bottom: 8px; letter-spacing: -0.02em;"><%= board != null ? board.getName() : "Board" %></h1>
            <p class="muted" style="font-size: 1.1rem;">Manage tasks, collaborate with members, and track progress.</p>
        </div>
        <div class="actions">
            <a class="btn" href="<%= request.getContextPath() %>/boards">
                <i data-lucide="chevron-left"></i> Back
            </a>
        </div>
    </div>

    <%
        int totalTasks = (tasks != null) ? tasks.size() : 0;
        int todo = 0, inprogress = 0, done = 0;
        if (tasks != null) {
            for (com.minitrello.model.Task t : tasks) {
                String s = t.getStatus();
                if ("DONE".equals(s)) done++;
                else if ("IN_PROGRESS".equals(s)) inprogress++;
                else todo++;
            }
        }
        com.minitrello.dao.BoardDAO bdaoStats = new com.minitrello.dao.BoardDAO();
        int memberCount = bdaoStats.listMemberIds(board.getId()).size();
        double todoPct = totalTasks > 0 ? (todo * 100.0) / totalTasks : 0.0;
        double inprogressPct = totalTasks > 0 ? (inprogress * 100.0) / totalTasks : 0.0;
        double donePct = totalTasks > 0 ? (done * 100.0) / totalTasks : 0.0;
    %>

    <div class="card" style="margin-bottom:24px; background: rgba(255,255,255,0.02);">
        <div style="display:flex; align-items:center; gap:10px; margin-bottom:20px;">
            <i data-lucide="bar-chart-3" style="color:var(--primary);"></i>
            <h2 style="margin:0;">Board Insights</h2>
        </div>
        <div class="stat-grid">
            <div class="stat">
                <div class="label">Total Tasks</div>
                <div class="value"><%= totalTasks %></div>
            </div>
            <div class="stat">
                <div class="label">Members</div>
                <div class="value" style="color:var(--primary);"><%= memberCount %></div>
            </div>
            <div class="stat">
                <div class="label">Completed</div>
                <div class="value" style="color:#34d399;"><%= done %></div>
            </div>
        </div>
        <div class="progress" style="margin-top:24px; height:8px; background: var(--border); border-radius:4px; overflow:hidden; display:flex;">
            <div class="seg todo" style="width:<%= todoPct %>%; background: #64748b;"></div>
            <div class="seg inprogress" style="width:<%= inprogressPct %>%; background: var(--primary);"></div>
            <div class="seg done" style="width:<%= donePct %>%; background: #34d399;"></div>
        </div>
        <div class="legend" style="margin-top:12px; display:flex; gap:16px; font-size:0.85rem; color:var(--muted);">
            <span class="key" style="display:flex; align-items:center; gap:6px;"><span class="swatch todo" style="width:10px; height:10px; border-radius:2px; background:#64748b;"></span> To Do (<%= todo %>)</span>
            <span class="key" style="display:flex; align-items:center; gap:6px;"><span class="swatch inprogress" style="width:10px; height:10px; border-radius:2px; background:var(--primary);"></span> In Progress (<%= inprogress %>)</span>
            <span class="key" style="display:flex; align-items:center; gap:6px;"><span class="swatch done" style="width:10px; height:10px; border-radius:2px; background:#34d399;"></span> Done (<%= done %>)</span>
        </div>
    </div>

    <div class="grid grid-2" style="margin-top: 32px;">
        <div class="card">
            <div style="display:flex; align-items:center; gap:10px; margin-bottom:16px;">
                <i data-lucide="check-square" style="color:var(--primary);"></i>
                <h3 style="margin:0;">Task Management</h3>
            </div>
            <p class="muted">Add, update, and track your tasks in real-time.</p>
            <a class="btn primary" href="<%= request.getContextPath() %>/tasks.jsp?boardId=<%= board.getId() %>" style="margin-top: 16px; width: 100%;">
                Go to Tasks <i data-lucide="arrow-right"></i>
            </a>
        </div>
        <div class="card">
            <div style="display:flex; align-items:center; gap:10px; margin-bottom:16px;">
                <i data-lucide="users" style="color:var(--primary);"></i>
                <h3 style="margin:0;">Team Members</h3>
            </div>
            <p class="muted">Collaborate with your team members on this board.</p>
            <a class="btn outline" href="<%= request.getContextPath() %>/members?boardId=<%= board.getId() %>" style="margin-top: 16px; width: 100%;">
                Manage Members <i data-lucide="settings"></i>
            </a>
        </div>
    </div>

    <div class="card" style="margin-top:12px;">
        <h2>Tasks</h2>
        <% if (tasks == null || tasks.isEmpty()) { %>
            <p class="muted">No tasks yet.</p>
        <% } else { %>
            <ul class="item-list">
                <% for (com.minitrello.model.Task t : tasks) { 
                       String st = t.getStatus();
                       String cls = "todo";
                       if ("IN_PROGRESS".equals(st)) cls = "inprogress";
                       else if ("DONE".equals(st)) cls = "done";
                %>
                    <li class="item">
                        <span class="item-title"><%= t.getTitle() %></span>
                        <span class="pill <%= cls %>"><%= st %></span>
                    </li>
                <% } %>
            </ul>
        <% } %>
        <div class="actions" style="margin-top:12px;">
            <a class="btn primary" href="<%= request.getContextPath() %>/tasks.jsp?boardId=<%= board.getId() %>">Manage tasks</a>
        </div>
    </div>

</div>
</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>