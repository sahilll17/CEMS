# College Event Management System (CEMS)

> **MCA 1st Semester Mini Project**  
> **Institution:** Chandigarh University, Gharuan, Mohali, Punjab  
> **Department:** University Institute of Computing (UIC)  
> **Course:** Master of Computer Applications (MCA - AI/ML)  
> **Subject Code:** 26CAH-614  
> **Submitted By:** Sahil Sharma (UID: 26MCI10257, Section: MAM-4B)  
> **Faculty Guide:** Ms. Shruti Sharma, Assistant Professor  

---

## 📌 Project Overview

The **College Event Management System (CEMS)** is a simple, database-driven web application developed as a 1st Semester MCA mini-project. The objective of this project is to implement core concepts of Java web programming (Servlets, JSP, JDBC/Hibernate, MVC pattern) and relational databases (MySQL) to solve common campus event management tasks:

- Replacing scattered notice boards with a central online portal for university events.
- Allowing students to view upcoming workshops, technical contests, sports tournaments, and fests.
- Providing easy online student event registration with seat capacity tracking.
- Generating a printable registration pass / admission receipt for students.
- Providing faculty and administrators with tools to add events, check venue availability, and track student attendance.

---

## 🛠️ Technology Stack

| Component | Technology |
|---|---|
| **Programming Language** | Java (JDK 17 / 21) |
| **Web Tier** | Jakarta Servlet, JavaServer Pages (JSP), JSTL |
| **Design Pattern** | MVC (Model - View - Controller) |
| **Database** | MySQL 8.0+ / Relational DB |
| **Persistence Layer** | Hibernate ORM / JPA & JDBC |
| **Server** | Apache Tomcat 11 (Embedded / NetBeans IDE) |
| **Styling** | Clean Academic CSS (Light Theme, Responsive, FontAwesome Icons) |

---

## 🌟 Key Modules & Features

### 1. Student Module
- **Strict Registration & Validation:** Real-time client-side checks and secure server-side regex validations for UID, Name, Email, Phone, Department, Semester, and Password. Rejects invalid data with clear alerts and preserves entered data.
- **Browse & Filter Events:** Search events by keyword, filter by categories (*Technical, Cultural, Sports, Workshops, Hackathons, Seminars*), and date range.
- **Individual & Team Registration:** Register as an individual or create a team by adding member details up to the event's max team limit.
- **Event Admission Pass:** Generates a printable admission pass with unique ticket ID, venue details, student info, and team information.
- **My Registrations & History:** View active event passes, track approval status, and view past event participation records.
- **Digital Certificates:** Automated download and print of official Chandigarh University participation or merit certificates once attendance and scores are finalized.

### 2. Event Coordinator & Admin Module
- **Admin Dashboard:** Displays real database metrics (Total Events, Total Registrations, Registered Students, Active Campus Venues) without dummy data.
- **Event Proposal & Creation:** Add events with category, registration deadline, venue, max seats, max team size, and detailed rules & guidelines.
- **Venue Availability & Clash Prevention:** Verifies venue and date availability to prevent duplicate auditorium/hall bookings.
- **Attendee Tracking & Scoring:** View registered individual and team participants, mark attendance (Attended / Absent), and enter scores.
- **Winner Declaration:** Select competition rank (Winner, 1st Runner-Up, 2nd Runner-Up) and automatically notify students.
- **User Management:** View registered students and organizers with account statuses.

---

## 🔑 Demo Credentials for Evaluation

For quick testing during viva and evaluation, demo login credentials can be filled with one click on the login page:

| Role | Email | Password | Details |
|---|---|---|---|
| **Admin** | `admin@cems.edu` | `admin123` | UID: `ADMIN001`, Campus Administration |
| **Faculty Coordinator** | `organizer@cems.edu` | `organizer123` | UID: `ORG001`, Dr. Shruti Sharma (UIC) |
| **Student** | `26MCI10257@cuchd.in` | `Sahil@123` | UID: `26MCI10257`, Sahil Sharma (MCA) |

---

## 🗄️ Database Configuration

1. In MySQL, create the database:
   ```sql
   CREATE DATABASE IF NOT EXISTS cems_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
2. Configure your MySQL credentials in:
   `src/main/resources/db.properties`
   ```properties
   db.url=jdbc:mysql://localhost:3306/cems_db?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
   db.username=root
   db.password=YOUR_MYSQL_PASSWORD
   ```
3. When the application starts, `DatabaseInitializer` automatically creates the tables, updates columns (`team_name`, `team_members`, `score`, `merit_rank`, `rules`, `registration_deadline`, etc.), and populates sample seed events and attended records for instant evaluation.

---

## 🚀 How to Run the Project in NetBeans

1. Open **NetBeans IDE**.
2. Go to **File -> Open Project...** and select the `CEMS` directory.
3. Right-click the **CEMS** project in the Projects panel and select **Run** (or press **F6**).
4. NetBeans will build the application and deploy it to **Tomcat 11**.
5. The browser will open:
   `http://localhost:8080/CEMS/` (or `http://localhost:8080/CEMS-1.0/`)

---

## 📂 Project Directory Structure

```
CEMS/
├── pom.xml                               # Maven project dependencies
├── src/main/
│   ├── java/com/cems/
│   │   ├── model/                       # Entity classes (User, Event, Venue, Registration)
│   │   ├── dao/                         # Data Access Objects (UserDao, EventDao, VenueDao, RegistrationDao)
│   │   ├── util/                        # HibernateUtil, PasswordUtil, DatabaseInitializer
│   │   └── web/                         # Controllers (AuthServlet, StudentServlet, AdminServlet)
│   ├── resources/
│   │   ├── hibernate.cfg.xml            # Hibernate configuration
│   │   ├── db.properties                # Database credentials
│   │   └── cems_schema.sql              # SQL Schema backup
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml                  # Web deployment descriptor
│       │   ├── includes/                # Common components (header.jsp, navbar.jsp, footer.jsp, alerts.jsp)
│       │   └── views/
│       │       ├── student/             # Student views (dashboard, events, event-details, my-tickets, ticket-view, certificate)
│       │       └── admin/               # Admin views (dashboard, events, event-form, venues, attendees, proposals, users)
│       ├── assets/
│       │   ├── css/style.css            # Clean academic light theme styling
│       │   └── js/main.js               # Simple UI helper scripts
│       ├── index.jsp                    # Home page
│       ├── login.jsp                    # Login page
│       └── register.jsp                 # Student registration page with live validation
```
