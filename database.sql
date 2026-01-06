-- Create database and tables for Mini‑Trello (XAMPP MySQL)

CREATE DATABASE IF NOT EXISTS `java_user` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `java_user`;

-- Users
CREATE TABLE IF NOT EXISTS `users` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password_hash` VARCHAR(256) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Boards
CREATE TABLE IF NOT EXISTS `boards` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(200) NOT NULL,
  `owner_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_boards_owner` FOREIGN KEY (`owner_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Board members
CREATE TABLE IF NOT EXISTS `board_members` (
  `board_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `role` VARCHAR(20) NOT NULL DEFAULT 'MEMBER',
  PRIMARY KEY (`board_id`, `user_id`),
  CONSTRAINT `fk_members_board` FOREIGN KEY (`board_id`) REFERENCES `boards`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_members_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE
);

-- Tasks
CREATE TABLE IF NOT EXISTS `tasks` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `board_id` BIGINT NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `description` VARCHAR(1000) NOT NULL DEFAULT '',
  `status` VARCHAR(20) NOT NULL DEFAULT 'TODO',
  `assignee_id` BIGINT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  CONSTRAINT `fk_tasks_board` FOREIGN KEY (`board_id`) REFERENCES `boards`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_tasks_assignee` FOREIGN KEY (`assignee_id`) REFERENCES `users`(`id`) ON DELETE SET NULL
);

-- Helpful indexes
CREATE INDEX IF NOT EXISTS `idx_tasks_board` ON `tasks` (`board_id`);
CREATE INDEX IF NOT EXISTS `idx_members_board` ON `board_members` (`board_id`);