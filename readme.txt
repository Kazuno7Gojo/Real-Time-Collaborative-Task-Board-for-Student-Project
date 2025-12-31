Great project 👍
Below is a **more attractive, well-structured, and instructor-friendly version** of your description.
It keeps everything **technically correct**, but improves **clarity, academic tone, and presentation**.

---

# Mini-Trello: Real-Time Collaborative Task Board

**(Java Servlet / JSP + JDBC)**

## Group Members

| No | Name             | ID           |
| -- | ---------------- | ------------ |
| 1  | Rezan Shemsedin  | UGR/35266/16 |
| 2  | Samuel Tenkir    | UGR/35343/16 |
| 3  | Abdulbasit Ylkal | UGR/33771/16 |
| 4  | Yewengel Messele | UGR/35649/16 |
| 5  | Lamrot Gashaw    | UGR/34791/16 |

📸 **Web application screenshots** are included in the following directory:
`Real-Time-Collaborative-Task-Board-for-Student-Project/Web Screenshot/`

---

## Project Overview

**Mini-Trello** is a web-based task management system inspired by Trello.
It is designed to help students collaborate efficiently by organizing tasks into boards and tracking their progress in real time.

The project demonstrates practical use of **Java Web Technologies**, including Servlets, JSP, JDBC, and database integration, following a clean MVC-style architecture.

---

## Technologies Used

* **Java 11**
* **Jakarta Servlets (Servlet API 6)**
* **JSP (Server-Side Rendering)**
* **JDBC**
* **MySQL / MariaDB**
* **Maven (WAR packaging)**

---

## Core Features

* User registration and authentication (session-based)
* Board creation and board listing
* Viewing boards with associated tasks
* Adding and removing board members
* Task creation and task status management
  *(TODO / IN_PROGRESS / DONE)*

---

## System Requirements

* JDK 11 or newer
* Maven 3+
* MySQL or MariaDB (XAMPP supported)
* One of the following application servers:

  * **Jetty (via Maven plugin – recommended)**
  * **Apache Tomcat 10.1+ (Jakarta namespace)**

---

## Database Configuration

The application uses a MySQL/MariaDB database named:

```
java_user
```

### Database Setup Steps

1. Start MySQL/MariaDB (e.g., XAMPP → Start MySQL)
2. Import the schema file `database.sql`:

   * **phpMyAdmin**

     * Open phpMyAdmin → Import → Select `database.sql` → Go
   * **MySQL CLI**

     ```
     mysql -u root -p < database.sql
     ```

📁 The `database.sql` file is located in the project root directory.

---

## Database Connection Settings

Edit the file:


```
src/main/java/com/minitrello/db/DBConnection.java
```

Default configuration:

```
JDBC_URL      = jdbc:mysql://localhost:3306/java_user
JDBC_USER     = root
JDBC_PASSWORD = (empty)
```

Modify these values if your local database configuration differs.

---

## Running the Project

### Option 1: Run with Jetty (Recommended)

```bash
mvn clean package
mvn jetty:run
```

Open in browser:

```
http://localhost:8080/
```

Default entry page:

```
login.jsp
```

---

### Option 2: Deploy to Apache Tomcat

1. Build the WAR file:

   ```bash
   mvn clean package
   ```
2. Locate the WAR file:

   ```
   target/mini-trello-0.1.0.war
   ```
3. Copy it to:

   ```
   <TOMCAT_HOME>/webapps/
   ```
4. Start Tomcat and open:

   ```
   http://localhost:8080/mini-trello-0.1.0/
   ```

⚠ **Important:**
This project uses **Jakarta Servlet API 6**, therefore **Tomcat 10.1+ is required**.

---

## Quick Start Guide

1. Open the application in your browser
2. Register a new user account
   `/register.jsp`
3. Login
   `/login.jsp`
4. View all boards
   `/boards`
5. Create a new board
   `/boards/create`
6. Open a board
   `/board?id=<boardId>`
7. Manage board members
   `/members?boardId=<boardId>`
8. Create tasks and update their status from the board interface

---

## Main Application Routes

* `GET / POST` → `/login`
* `GET / POST` → `/register`
* `GET` → `/logout`
* `GET` → `/boards`
* `GET / POST` → `/boards/create`
* `GET` → `/board?id=...`
* `GET` → `/members?boardId=...`
* `POST` → `/members/add`
* `POST` → `/members/remove`
* `POST` → `/tasks/create`
* `POST` → `/tasks/update-status`

---

## JSP Pages (User Interface)

* `login.jsp`
* `register.jsp`
* `boards.jsp`
* `createBoard.jsp`
* `board.jsp`
* `members.jsp`
* `tasks.jsp`

---
