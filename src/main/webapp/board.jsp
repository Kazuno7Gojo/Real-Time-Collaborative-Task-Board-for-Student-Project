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
    <div class="card" style="margin-bottom:16px;">
        <h2><%= board != null ? board.getName() : "Board" %></h2>
        <p class="muted">Manage tasks and members.</p>
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

    <div class="card" style="margin-bottom:16px;">
        <h2>Analytics</h2>
        <div class="stat-grid">
            <div class="stat">
                <div class="value"><%= totalTasks %></div>
                <div class="label">Tasks</div>
            </div>
            <div class="stat">
                <div class="value"><%= memberCount %></div>
                <div class="label">Members</div>
            </div>
            <div class="stat">
                <div class="value"><%= done %></div>
                <div class="label">Done tasks</div>
            </div>
        </div>
        <div class="progress" style="margin-top:10px;">
            <div class="seg todo" style="width:<%= todoPct %>%"></div>
            <div class="seg inprogress" style="width:<%= inprogressPct %>%"></div>
            <div class="seg done" style="width:<%= donePct %>%"></div>
        </div>
        <div class="legend">
            <span class="key"><span class="swatch todo"></span> To Do (<%= todo %>)</span>
            <span class="key"><span class="swatch inprogress"></span> In Progress (<%= inprogress %>)</span>
            <span class="key"><span class="swatch done"></span> Done (<%= done %>)</span>
        </div>
    </div>

    <div class="actions" style="margin-bottom:12px;">
        <a class="btn" href="<%= request.getContextPath() %>/boards">Back to boards</a>
        <a class="btn link" href="<%= request.getContextPath() %>/members?boardId=<%= board.getId() %>">Members</a>
        <a class="btn link" href="<%= request.getContextPath() %>/tasks.jsp?boardId=<%= board.getId() %>">Tasks</a>
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