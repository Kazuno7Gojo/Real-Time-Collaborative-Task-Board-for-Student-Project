Mini-Trello (Java Servlet/JSP + JDBC)
====================================

Project Description
-------------------
Mini-Trello is a simple task-board web application built with:
- Java 11
- Jakarta Servlets (Servlet API 6)
- JSP pages (server-side rendered)
- JDBC with MySQL/MariaDB
- Maven (WAR packaging)

Main Features
-------------
- User registration and login (session-based)
- Create boards and list your boards
- View a board with its tasks
- Add/remove board members
- Create tasks and update task status (TODO / IN_PROGRESS / DONE)


Requirements
------------
1) JDK 11 (or newer)
2) Maven 3+
3) MySQL or MariaDB (XAMPP is OK)
4) One of these to run the web app:
   - Maven Jetty plugin (included in this project), or
   - Tomcat 10.1+ (Jakarta namespace)


Database Setup (MySQL / MariaDB)
-------------------------------
This project expects a MySQL database named: java_user

1) Start MySQL/MariaDB server (XAMPP -> Start MySQL)
2) Import the database schema:
   - Using phpMyAdmin:
     - Open phpMyAdmin
     - Go to "Import"
     - Select file: database.sql
     - Click "Go"
   - Using MySQL CLI:
     - mysql -u root -p < database.sql

The schema file is in the project root:
  database.sql


Configure Database Connection
-----------------------------
Edit this file:
  src\main\java\com\minitrello\db\DBConnection.java

Update these constants if your DB settings are different:
  JDBC_URL      (database name, host, port)
  JDBC_USER     (default is root)
  JDBC_PASSWORD (default is empty string)

Current default configuration:
  jdbc:mysql://localhost:3306/java_user
  user: root
  password: (empty)


Run the Project (Recommended: Jetty via Maven)
----------------------------------------------
From the project folder, run:
  mvn clean package
  mvn jetty:run

Then open in browser:
  http://localhost:8080/

The welcome page is:
  login.jsp


Run the Project (Alternative: Deploy WAR to Tomcat)
---------------------------------------------------
1) Build the WAR:
   mvn clean package

2) Find the WAR in:
   target\mini-trello-0.1.0.war

3) Copy the WAR to Tomcat:
   <TOMCAT_HOME>\webapps\

4) Start Tomcat and open (example):
   http://localhost:8080/mini-trello-0.1.0/

Important:
- Because this project uses Jakarta Servlet API 6, use Tomcat 10.1+ (not Tomcat 9).


How to Use (Quick Start)
------------------------
1) Open the app in your browser
2) Create an account:
   /register.jsp  (form posts to /register)
3) Login:
   /login.jsp     (form posts to /login)
4) Go to boards:
   /boards
5) Create a board:
   /boards/create
6) Open a board:
   /board?id=<boardId>
7) Manage members:
   /members?boardId=<boardId>
8) Create tasks and update status from the board pages


Main URLs / Routes
------------------
- GET/POST  /login
- GET/POST  /register
- GET       /logout
- GET       /boards
- GET/POST  /boards/create
- GET       /board?id=...
- GET       /members?boardId=...
- POST      /members/add
- POST      /members/remove
- POST      /tasks/create
- POST      /tasks/update-status

JSP pages (UI):
- /login.jsp
- /register.jsp
- /boards.jsp
- /createBoard.jsp
- /board.jsp
- /members.jsp
- /tasks.jsp


Troubleshooting
---------------
1) "Access denied for user"
   - Update DBConnection.java username/password to match your MySQL user.

2) "Communications link failure" / cannot connect
   - Make sure MySQL is running
   - Check host/port in JDBC_URL (default 3306)

3) Blank pages or 404 routes after deploying to Tomcat
   - Ensure you are using Tomcat 10.1+ (Jakarta)
   - Check the app context path (WAR name)

