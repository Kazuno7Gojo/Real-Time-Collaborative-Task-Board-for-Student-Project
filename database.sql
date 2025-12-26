-- 1️⃣ Create the database
CREATE DATABASE IF NOT EXISTS mini_trello;
USE mini_trello;

-- 2️⃣ Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

-- 3️⃣ Boards table
CREATE TABLE IF NOT EXISTS boards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    owner_id INT NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4️⃣ Tasks table
CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'TODO',
    board_id INT NOT NULL,
    FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE
);

-- 5️⃣ Optional: Sample data for testing
INSERT INTO users(username, password) VALUES ('testuser', 'testpass');
INSERT INTO boards(name, owner_id) VALUES ('Sample Board', 1);
INSERT INTO tasks(title, board_id) VALUES ('Sample Task', 1);
