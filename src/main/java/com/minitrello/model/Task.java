package com.minitrello.model;

import java.sql.Timestamp;

public class Task {
    private Long id;
    private Long boardId;
    private String title;
    private String description;
    private String status; // TODO, IN_PROGRESS, DONE
    private Long assigneeId; // nullable
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Task() {}

    public Task(Long id, Long boardId, String title, String description, String status,
                Long assigneeId, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.boardId = boardId;
        this.title = title;
        this.description = description;
        this.status = status;
        this.assigneeId = assigneeId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getBoardId() { return boardId; }
    public void setBoardId(Long boardId) { this.boardId = boardId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Long getAssigneeId() { return assigneeId; }
    public void setAssigneeId(Long assigneeId) { this.assigneeId = assigneeId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}