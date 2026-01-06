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
    com.minitrello.model.Board board = bdao.getBoardById(boardId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Members - <%= board != null ? board.getName() : "" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/app.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="dark">
</head>
<body>
<%@ include file="/WEB-INF/jspf/header.jspf" %>
<main class="content">
<div class="container animate-fade-up">
    <div style="margin-bottom:48px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 24px;">
        <div>
            <h1 style="font-size: 3rem; font-weight: 800; margin-bottom: 8px; letter-spacing: -0.04em; background: linear-gradient(to right, #fff, var(--muted)); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Collaborators</h1>
            <p class="muted" style="font-size: 1.25rem;">Building with team for <strong><%= board != null ? board.getName() : "Board #" + boardId %></strong></p>
        </div>
        <div class="actions">
            <a class="btn outline" href="<%= request.getContextPath() %>/board?id=<%= boardId %>" style="padding: 12px 24px; border-radius: 12px;">
                <i data-lucide="arrow-left-circle"></i> Back to Workspace
            </a>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="banner error animate-fade-up" style="margin-bottom: 32px; border-radius: 16px;">
            <i data-lucide="alert-triangle"></i>
            <%= error %>
        </div>
    <% } %>
    <% if (request.getParameter("success") != null) { %>
        <div class="banner success animate-fade-up" style="margin-bottom: 32px; border-radius: 16px;">
            <i data-lucide="party-popper"></i>
            <%= request.getParameter("success") %>
        </div>
    <% } %>

    <div class="grid grid-2">
      <% if (currentUser.getId().equals(ownerId)) { %>
      <div class="board-section-card animate-fade-up" style="animation-delay: 0.1s; padding: 32px;">
        <div class="board-section-header" style="border-bottom: none; margin-bottom: 16px;">
            <h3><i data-lucide="user-plus-2" style="color:var(--primary); width: 28px; height: 28px;"></i> Invite Member</h3>
        </div>
        <p class="muted" style="margin-bottom: 32px; font-size: 1.1rem;">Grow your team by inviting collaborators to this workspace via their email address.</p>
        <form class="form" method="post" action="<%= request.getContextPath() %>/members/add">
            <input type="hidden" name="boardId" value="<%= boardId %>">
            <div class="field">
                <label for="email" style="font-weight: 600; color: var(--text); margin-bottom: 8px;">Collaborator's Email</label>
                <div style="position: relative;">
                    <i data-lucide="mail-search" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); width: 20px; color: var(--primary); opacity: 0.6;"></i>
                    <input class="input" id="email" name="email" type="email" placeholder="teammate@example.com" required style="padding: 16px 16px 16px 52px; background: rgba(0,0,0,0.2); border-radius: 14px; width: 100%; border-color: rgba(255,255,255,0.05);">
                </div>
            </div>
            <div class="actions" style="margin-top: 24px;">
                <button class="btn primary" type="submit" style="width: 100%; height: 56px; border-radius: 14px; font-size: 1.1rem; box-shadow: 0 10px 20px -5px rgba(99, 102, 241, 0.4);">
                    <i data-lucide="user-plus"></i> Add to Workspace
                </button>
            </div>
        </form>
      </div>
      <% } else { %>
      <div class="board-section-card animate-fade-up" style="animation-delay: 0.1s; padding: 32px;">
        <div class="board-section-header" style="border-bottom: none; margin-bottom: 16px;">
            <h3><i data-lucide="shield-check" style="color:var(--primary); width: 28px; height: 28px;"></i> Workspace Access</h3>
        </div>
        <div style="background: rgba(99, 102, 241, 0.05); padding: 24px; border-radius: 20px; border: 1px solid rgba(99, 102, 241, 0.1);">
            <p class="muted" style="font-size: 1.1rem; line-height: 1.6; margin: 0;">You are currently viewing the team directory. Please note that only the <strong>Workspace Owner</strong> has the authority to manage memberships and invitations.</p>
        </div>
      </div>
      <% } %>

      <div class="board-section-card animate-fade-up" style="animation-delay: 0.2s; padding: 32px;">
        <div class="board-section-header">
            <h3><i data-lucide="users-2" style="color:var(--primary); width: 28px; height: 28px;"></i> Team Directory</h3>
            <span class="count-badge"><%= members != null ? members.size() : 0 %> Members</span>
        </div>
        <div class="item-list" style="gap: 16px;">
            <% if (members != null) {
                int mIdx = 0;
                for (com.minitrello.model.User m : members) {
                    mIdx++;
            %>
                <div class="item animate-slide-right" style="padding: 16px; border-radius: 16px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.05); animation-delay: <%= 0.2 + (mIdx * 0.05) %>s;">
                    <div style="display:flex; align-items:center; gap:16px;">
                        <div class="user-avatar" style="width: 44px; height: 44px; font-size: 1.1rem; background: linear-gradient(135deg, var(--primary), #818cf8);">
                            <%= m.getName().substring(0, 1).toUpperCase() %>
                        </div>
                        <div>
                            <div class="item-title" style="font-size: 1.1rem; margin-bottom: 2px;"><%= m.getName() %></div>
                            <div class="muted" style="font-size: 0.9rem; display: flex; align-items: center; gap: 6px;">
                                <i data-lucide="mail" style="width: 14px; height: 14px;"></i>
                                <%= m.getEmail() %>
                            </div>
                        </div>
                    </div>
                    <div>
                        <% if (m.getId().equals(ownerId)) { %>
                            <span class="pill" style="background: rgba(16, 185, 129, 0.1); color: #10b981; border-color: rgba(16, 185, 129, 0.2); font-size: 0.75rem;">Owner</span>
                        <% } else { %>
                            <span class="pill" style="font-size: 0.75rem;">Member</span>
                        <% } %>
                        
                        <% if (currentUser.getId().equals(ownerId) && !m.getId().equals(ownerId)) { %>
                            <form method="post" action="<%= request.getContextPath() %>/members/remove" style="display:inline; margin-left: 12px;">
                                <input type="hidden" name="boardId" value="<%= boardId %>">
                                <input type="hidden" name="userId" value="<%= m.getId() %>">
                                <button class="action-btn delete" type="submit" title="Remove from Team" onclick="return confirm('Remove this member?')">
                                    <i data-lucide="user-minus" style="width: 16px;"></i>
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
            <% } } %>
        </div>
      </div>
    </div>
 </div>
</main>
<%@ include file="/WEB-INF/jspf/footer.jspf" %>
</body>
</html>