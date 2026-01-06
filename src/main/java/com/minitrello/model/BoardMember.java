package com.minitrello.model;

public class BoardMember {
    private Long boardId;
    private Long userId;
    private String role; // OWNER, MEMBER

    public BoardMember() {}

    public BoardMember(Long boardId, Long userId, String role) {
        this.boardId = boardId;
        this.userId = userId;
        this.role = role;
    }

    public Long getBoardId() { return boardId; }
    public void setBoardId(Long boardId) { this.boardId = boardId; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}