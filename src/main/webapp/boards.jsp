<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    java.util.List<com.minitrello.model.Board> boards = (java.util.List<com.minitrello.model.Board>) request.getAttribute("boards");
    String error = request.getParameter("error");
    String success = request.getParameter("success");
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
<main class="content page">
    <section class="hero">
        <div class="container">
            <div class="hero-content">
                <h1 class="hero-title">Organize your work, beautifully.</h1>
                <p class="hero-subtitle">Collaborate with your team, manage projects, and reach new productivity peaks. From high-level views to the smallest details, Mini-Trello has you covered.</p>
                <div class="actions">
                    <a href="<%= request.getContextPath() %>/boards/create" class="btn primary" style="padding: 12px 24px; font-size: 1rem;">
                        <i data-lucide="plus-circle" style="margin-right: 8px;"></i> Create New Board
                    </a>
                </div>
            </div>
        </div>
    </section>

    <div class="container animate-fade-up" style="margin-top: 32px; position: relative; z-index: 10;">
        <% if (error != null) { %>
            <div class="banner error animate-fade-up" style="margin-bottom: 24px; border-radius: 16px; border: 1px solid rgba(239, 68, 68, 0.2);">
                <i data-lucide="alert-circle"></i>
                <%= error %>
            </div>
        <% } %>
        <% if (success != null) { %>
            <div class="banner success animate-fade-up" style="margin-bottom: 24px; border-radius: 16px; border: 1px solid rgba(16, 185, 129, 0.2);">
                <i data-lucide="check-circle"></i>
                <%= success %>
            </div>
        <% } %>

        <% if (boards == null || boards.isEmpty()) { %>
            <div class="card animate-fade-up" style="text-align: center; padding: 80px 40px; border-radius: 32px; background: rgba(30, 41, 59, 0.4); backdrop-filter: blur(20px);">
                <div style="background: linear-gradient(135deg, var(--primary), #34d399); width: 80px; height: 80px; border-radius: 24px; display: flex; align-items: center; justify-content: center; margin: 0 auto 32px; box-shadow: 0 20px 40px -10px rgba(99, 102, 241, 0.4);">
                    <i data-lucide="layout-template" style="width: 40px; height: 40px; color: white;"></i>
                </div>
                <h2 style="font-size: 2rem; font-weight: 800; margin-bottom: 16px;">Create your first workspace</h2>
                <p class="muted" style="margin-bottom: 40px; font-size: 1.1rem; max-width: 500px; margin-left: auto; margin-right: auto;">Welcome to Mini-Trello! Start by creating a board to organize your projects, tasks, and team collaboration.</p>
                <a class="btn primary" href="<%= request.getContextPath() %>/boards/create" style="padding: 16px 48px; font-size: 1.1rem; border-radius: 16px; font-weight: 700;">
                    <i data-lucide="plus-circle" style="margin-right: 10px;"></i> Create My First Board
                </a>
            </div>
        <% } else { 
            int ownCount = 0;
            int sharedCount = 0;
            for (com.minitrello.model.Board b : boards) {
                if (b.getOwnerId() != null && b.getOwnerId().equals(currentUser.getId())) ownCount++;
                else sharedCount++;
            }
        %>
            <div class="boards-layout-grid">
                <!-- My Boards Section -->
                <div class="board-section-card animate-fade-up" style="animation-delay: 0.1s;">
                    <div class="board-section-header">
                        <h3><i data-lucide="folder-kanban" style="color: var(--primary); width: 28px; height: 28px;"></i> My Boards</h3>
                        <span class="count-badge"><%= ownCount %> Total</span>
                    </div>
                    <div class="board-grid">
                        <% 
                            boolean hasOwn = false;
                            int i = 0;
                            for (com.minitrello.model.Board b : boards) { 
                                if (b.getOwnerId() != null && b.getOwnerId().equals(currentUser.getId())) {
                                    hasOwn = true;
                                    i++;
                        %>
                            <div class="board-card-wrapper animate-slide-right" style="position: relative; animation-delay: <%= 0.1 + (i * 0.05) %>s;">
                                <a class="board-card" href="<%= request.getContextPath() %>/board?id=<%= b.getId() %>">
                                    <div class="board-name"><%= b.getName() %></div>
                                    <div class="board-meta">
                                        <i data-lucide="calendar" style="width:16px; height:16px;"></i>
                                        Created <%= new java.text.SimpleDateFormat("MMM dd").format(b.getCreatedAt()) %>
                                    </div>
                                </a>
                                <div class="board-actions">
                                    <button class="action-btn" onclick="editBoard(<%= b.getId() %>, '<%= b.getName().replace("'", "\\'") %>')" title="Rename Board">
                                        <i data-lucide="pencil-line" style="width:18px;height:18px;"></i>
                                    </button>
                                    <button class="action-btn delete" onclick="deleteBoard(<%= b.getId() %>, '<%= b.getName().replace("'", "\\'") %>')" title="Delete Board">
                                        <i data-lucide="trash-2" style="width:18px;height:18px;"></i>
                                    </button>
                                </div>
                            </div>
                        <% 
                                }
                            } 
                            if (!hasOwn) {
                        %>
                            <div style="text-align: center; padding: 48px 24px; border: 2px dashed rgba(255, 255, 255, 0.05); border-radius: 20px;">
                                <i data-lucide="plus" style="width: 48px; height: 48px; color: var(--muted); margin-bottom: 16px; opacity: 0.3;"></i>
                                <p class="muted">No personal boards yet.</p>
                            </div>
                        <% } %>
                    </div>
                    <a href="<%= request.getContextPath() %>/boards/create" class="btn outline" style="width: 100%; margin-top: 32px; justify-content: center; border-style: dashed; padding: 14px; border-radius: 14px; background: rgba(255,255,255,0.02);">
                        <i data-lucide="plus"></i> Create New Workspace
                    </a>
                </div>

                <!-- Shared with Me Section -->
                <div class="board-section-card animate-fade-up" style="animation-delay: 0.2s;">
                    <div class="board-section-header">
                        <h3><i data-lucide="share-2" style="color: #34d399; width: 28px; height: 28px;"></i> Shared with Me</h3>
                        <span class="count-badge" style="background: rgba(52, 211, 153, 0.1); color: #34d399; border-color: rgba(52, 211, 153, 0.2);"><%= sharedCount %> Active</span>
                    </div>
                    <div class="board-grid">
                        <% 
                            boolean hasShared = false;
                            int j = 0;
                            for (com.minitrello.model.Board b : boards) { 
                                if (b.getOwnerId() == null || !b.getOwnerId().equals(currentUser.getId())) {
                                    hasShared = true;
                                    j++;
                        %>
                            <a class="board-card animate-slide-right" style="animation-delay: <%= 0.2 + (j * 0.05) %>s;" href="<%= request.getContextPath() %>/board?id=<%= b.getId() %>">
                                <div class="board-name"><%= b.getName() %></div>
                                <div class="board-meta">
                                    <i data-lucide="users" style="width:16px;height:16px;"></i>
                                    Collaborative Board
                                </div>
                                <div style="position: absolute; right: 20px; bottom: 20px; opacity: 0.2;">
                                    <i data-lucide="external-link" style="width: 20px; height: 20px;"></i>
                                </div>
                            </a>
                        <% 
                                }
                            } 
                            if (!hasShared) {
                        %>
                            <div style="text-align: center; padding: 48px 24px; border: 2px dashed rgba(255, 255, 255, 0.05); border-radius: 20px;">
                                <i data-lucide="users" style="width: 48px; height: 48px; color: var(--muted); margin-bottom: 16px; opacity: 0.3;"></i>
                                <p class="muted">No shared boards yet.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
</div>
</main>

<!-- Edit Board Modal -->
<div id="editModal" class="modal-overlay" style="display:none;">
    <div class="card">
        <h3>Edit Board Name</h3>
        <form action="<%= request.getContextPath() %>/boards/update" method="POST" class="form">
            <input type="hidden" id="editBoardId" name="id">
            <div class="field">
                <label for="editBoardName">Board Name</label>
                <input type="text" id="editBoardName" name="name" class="input" required>
            </div>
            <div class="actions" style="margin-top:16px;">
                <button type="submit" class="btn primary">Save Changes</button>
                <button type="button" class="btn outline" onclick="closeEditModal()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function editBoard(id, name) {
    document.getElementById('editBoardId').value = id;
    document.getElementById('editBoardName').value = name;
    document.getElementById('editModal').style.display = 'flex';
}

function closeEditModal() {
    document.getElementById('editModal').style.display = 'none';
}

function deleteBoard(id, name) {
    if (confirm('Are you sure you want to delete board "' + name + '"? This action cannot be undone.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '<%= request.getContextPath() %>/boards/delete';
        
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'id';
        idInput.value = id;
        
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    }
}
</script>
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

  // Re-initialize Lucide icons to ensure they render in the board list
  if (window.lucide) {
    lucide.createIcons();
  }
})();
</script>
</body>
</html>