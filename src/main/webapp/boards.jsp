<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    java.util.List<com.minitrello.model.Board> boards = (java.util.List<com.minitrello.model.Board>) request.getAttribute("boards");
    String error = request.getParameter("error");
    com.minitrello.model.User currentUser = (com.minitrello.model.User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please+sign+in");
        return;
    }
    if (boards == null) {
        com.minitrello.dao.BoardDAO bdao = new com.minitrello.dao.BoardDAO();
        boards = bdao.listBoardsForUser(currentUser.getId());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Boards</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="dark">
    
</head>
<body>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<section class="hero">
    <div class="hero-content container">
        <h1 class="hero-title">Mini&#8209;Trello<br/>Real&#8209;Time Collaborative Task Board</h1>
        <p class="hero-subtitle">Plan, track, and collaborate in real time.</p>
    </div>
</section>
<main class="content page">
<div class="container">
    <div class="card" style="margin-bottom:16px;">
        <h2>Your Boards</h2>
        <p class="muted">Select a board to manage tasks.</p>
    </div>

    <%
        int totalBoards = (boards != null) ? boards.size() : 0;
        int ownedBoards = 0;
        if (boards != null) {
            for (com.minitrello.model.Board bb : boards) {
                if (bb.getOwnerId() != null && bb.getOwnerId().equals(currentUser.getId())) {
                    ownedBoards++;
                }
            }
        }
        int sharedBoards = totalBoards - ownedBoards;
        double ownedPct = totalBoards > 0 ? (ownedBoards * 100.0) / totalBoards : 0.0;
        double sharedPct = totalBoards > 0 ? (sharedBoards * 100.0) / totalBoards : 0.0;
    %>

    <div class="card" style="margin-bottom:16px;">
        <h2>Analytics</h2>
        <div class="stat-grid">
            <div class="stat">
                <div class="value"><%= totalBoards %></div>
                <div class="label">Boards you’re a member of</div>
            </div>
            <div class="stat">
                <div class="value"><%= ownedBoards %></div>
                <div class="label">Boards you own</div>
            </div>
            <div class="stat">
                <div class="value"><%= sharedBoards %></div>
                <div class="label">Shared boards</div>
            </div>
        </div>
        <div class="progress" style="margin-top:10px;">
            <div class="seg owned" style="width:<%= ownedPct %>%"></div>
            <div class="seg shared" style="width:<%= sharedPct %>%"></div>
        </div>
        <div class="legend">
            <span class="key"><span class="swatch owned"></span> Owned</span>
            <span class="key"><span class="swatch shared"></span> Shared</span>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="banner error"><%= error %></div>
    <% } %>

    <div class="card">
        <div class="actions" style="margin-bottom:12px;">
            <a class="btn primary" href="<%= request.getContextPath() %>/boards/create"> New Board</a>
        </div>
        <% if (boards == null || boards.isEmpty()) { %>
            <p class="muted">No boards yet. Create one above.</p>
        <% } else { %>
            <div class="board-grid">
                <% for (com.minitrello.model.Board b : boards) { %>
                    <a class="board-card" href="<%= request.getContextPath() %>/board?id=<%= b.getId() %>">
                        <div class="board-name"><%= b.getName() %></div>
                        <div class="board-meta">Open board →</div>
                    </a>
                <% } %>
            </div>
        <% } %>
    </div>

 </div>
</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
<script>
// Smooth page transitions (fade in/out)
(function() {
  var body = document.body;
  // Enter animation
  requestAnimationFrame(function(){ body.classList.add('page-enter'); });

  function isInternal(href){
    try {
      var u = new URL(href, window.location.origin);
      return u.origin === window.location.origin; // same origin
    } catch(e) { return false; }
  }

  function handleClick(e){
    // Only intercept left-clicks without modifiers and without target=_blank
    if (e.defaultPrevented || e.button !== 0 || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
    var a = e.currentTarget;
    var href = a.getAttribute('href');
    if (!href || !isInternal(href)) return;
    var target = a.getAttribute('target');
    if (target === '_blank') return;
    e.preventDefault();
    body.classList.add('page-exit');
    setTimeout(function(){ window.location.href = href; }, 220);
  }

  // Attach to common internal links on this page
  var links = document.querySelectorAll('.nav a, .brand-link, .board-card, .btn.primary, .btn.outline');
  links.forEach(function(a){ a.addEventListener('click', handleClick); });
})();
</script>
</body>
</html>