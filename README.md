# 🏨 Ocean View Resort - Integrated Management System

![Resort Banner](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)
![Security](https://img.shields.io/badge/Security-Multi--Role-blue?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-Clean--Modular-orange?style=for-the-badge)

## 🌟 Project Vision & Deep Overview

The **Ocean View Resort Management System** is a premium, high-performance software ecosystem designed to handle every facet of a luxury hospitality business. Unlike typical management software that relies on heavy third-party frameworks, this project is built on a **"Pure Engineering"** philosophy. Every component—from the custom HTTP server to the glassmorphism UI—is crafted to provide maximum control, ultra-low latency, and a state-of-the-art user experience.

The application serves two primary audiences:
1.  **The Luxury Guest:** Providing a seamless, visually stunning interface to explore rooms, book stays, and manage their personal resort experiences.
2.  **The Professional Staff:** Offering a robust administrative powerhouse to manage inventory, oversee staff, track reservations, and analyze resort performance.

---

## 🏗️ Technology Architecture (The Pure Stack)

The system is built using three distinct, high-performance pillars that work in perfect harmony without the bloat of traditional enterprise frameworks.

### 📱 Frontend: Stunning High-Performance UI
The user interface is powered by **Flutter & Dart**. 
- **Artistic Design:** Uses advanced UI techniques like Glassmorphism, custom gradients, and smooth micro-animations to reflect the luxury of the resort.
- **Unified Logic:** A single Dart codebase provides a consistent experience across Web, Mobile, and Desktop platforms.
- **State Sovereignty:** Uses the Provider pattern to ensure data flows predictably from the backend to the UI without unnecessary refreshes.

### ⚙️ Backend: The Pure Java Engine
The "brain" of the application is written in **Pure Java 11**.
- **Custom-Built Server:** Instead of using heavy containers like Spring Boot, we use a custom-engineered socket-based HTTP server. This results in an incredibly small footprint and blazing-fast response times.
- **Direct Data Access:** Utilizes the Java Database Connectivity (JDBC) API to speak directly to the database, eliminating the performance overhead of traditional ORM frameworks.
- **Modular Services:** Business logic is isolated into specific services (Rooms, Reservations, Users, etc.), making the system highly maintainable.

### 🗄️ Database: Relational Integrity
The foundation is built on **MariaDB (or MySQL)**.
- **Optimized Schema:** A relational structure designed for data integrity, ensuring that a room can never be double-booked and staff records are always linked to valid user accounts.
- **Industrial Strength:** Uses Foreign Key constraints and specialized SQL scripts to handle complex resort operations like billing and occupancy tracking.

---

## 🎭 User Roles & Permissions

The system manages access through a strict hierarchy of roles, ensuring security and operational clarity.

-   **Admin (System & Operational Root):** The highest authority. Admins manage the entire resort ecosystem, including system infrastructure, user accounts, staff assignments, and room inventory. They oversee all bookings and resort statistics.
-   **Staff (Guest Service):** The frontline users. Staff members manage daily tasks like cleaning, guest check-ins, and update reservation statuses in real-time.
-   **Guest (End User):** The focus of the luxury experience. Guests can view available rooms, make reservations, track their stay history, and leave reviews for the resort.

---

## 🔄 Application Workflow (How it Works)

### 1. The Guest Journey
A Guest starts at the luxury landing page. After a secure registration, they can browse available rooms with high-resolution images and detailed descriptions. When a booking is made, the system automatically marks the room as "Reserved" in the backend, calculates the total price based on date ranges, and generates a unique reservation number.

### 2. The Staff Workflow
As soon as a guest books, the Admin dashboard updates. Admins can assign tasks to specific staff members (e.g., "Prepare Room 201"). Staff members log into their interface to see their assigned tasks and mark them as complete.

### 3. The Admin Cycle
Admins use the "Accounts Management" section to oversee the entire workforce. They can verify which staff are active and which rooms need maintenance, all while viewing real-time billing data and guest feedback.

---

## 🚀 Execution & Operational Guide

To bring the Ocean View Resort system to life, follow these three stages of activation.

### Phase 1: Database Initialization
The foundation must be established first. The SQL scripts in the resources folder are executed against a MariaDB/MySQL instance. These scripts create the tables for users, rooms, and reservations, and seed the system with essential data like the primary Admin account and initial luxury room inventory.

### Phase 2: Backend Engine Activation
The Java server is launched using the Maven build system. Once active, the server starts listening for incoming requests on Port 8080. It establishes a pool of connections to the database and is ready to process everything from logins to complex booking calculations.

### Phase 3: Client Application Launch
The Flutter application is launched (typically in a browser for the web version). Upon startup, the client communicates with the backend to verify the connection and load the initial resort state. The UI dynamically adapts based on the role of the person logging in.

---

## 🌐 Language & Engineering Details

-   **Flutter (Dart):** Chosen for its ability to render 60FPS animations and its powerful layout system that makes "Glassmorphism" possible.
-   **Java:** Chosen for its strict typing and multi-threading capabilities, allowing the custom server to handle multiple guest requests simultaneously without slowing down.
-   **SQL:** Chosen for its industry-standard reliability in maintaining complex relationships between guests, payments, and room inventory.

---

> [!NOTE]
> **A Note on Design:** Every button, card, and transition in this application is designed to feel "Premium." The focus is not just on functionality, but on providing an experience that matches the quality of a 5-star resort.
