# 🏨 Ocean View Resort - Integrated Management System

![Resort Banner](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)
![Security](https://img.shields.io/badge/Security-Multi--Role-blue?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-Clean--Modular-orange?style=for-the-badge)

## 🌟 Project Vision & Deep Overview

The **Ocean View Resort Management System** is a premium, high-performance software ecosystem designed to handle every facet of a luxury hospitality business. Unlike typical management software that relies on heavy third-party frameworks, this project is built on a **"Pure Engineering"** philosophy. Every component—from the custom socket-based HTTP server to the glassmorphism UI—is crafted to provide maximum control, ultra-low latency, and a state-of-the-art user experience.

The application serves three primary objectives:
1.  **The Luxury Guest Experience:** Providing a seamless, visually stunning interface to explore rooms, book stays, order premium resort services, and manage billing.
2.  **The Professional Staff Workflow:** Offering a robust administrative powerhouse to manage tasks, oversee room statuses, and handle real-time guest check-ins/outs.
3.  **The Management Ecosystem:** A centralized billing and inventory system that ensures financial accuracy and operational efficiency.

---

## 🏗️ Technology Architecture (The Pure Stack)

The system is built using three distinct, high-performance pillars that work in perfect harmony without the bloat of traditional enterprise frameworks.

### 📱 Frontend: Stunning High-Performance UI
The user interface is powered by **Flutter & Dart**. 
- **Artistic Design:** Uses advanced UI techniques like Glassmorphism, custom gradients, and smooth micro-animations to reflect the luxury of the resort.
- **Unified Logic:** A single Dart codebase provides a consistent experience across Web, Mobile, and Desktop platforms.
- **Dynamic Invoicing:** Real-time HTML and Print-ready invoice generation for seamless guest check-out.
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

## 💎 Premium Features

-   **Interactive Services (Add-to-Bill):** Guests can browse a premium catalog of resort services (Spa, Fine Dining, Tours) and add them directly to their reservation's bill with a single tap.
-   **Automated Billing & Self-Checkout:** Integrated financial ecosystem that calculates room rates and service charges in real-time, supporting multiple payment methods and professional invoice generation.
-   **Context-Aware Guest Dashboard:** A "Smart Welcome" system that adapts the UI based on stay status—immediately showing room details, live bill totals, and checkout options for checked-in guests.
-   **Responsive Management Suite:** High-performance Admin and Staff interfaces that utilize `LayoutBuilder` architectures to provide a desktop-grade experience on any device.

---

## 📂 Project Structure

### ⚙️ Backend (Java)
The backend follows a strict **Modular Architecture**, separating concerns to ensure high maintainability and performance.

*   `com.oceanview.main`: The engine's ignition point; handles system startup and database verification.
*   `com.oceanview.webservice`: The custom-engineered HTTP server and endpoint controllers.
*   `com.oceanview.service`: The core business logic layer where all resort operations are processed.
*   `com.oceanview.repository`: The Data Access Layer (DAL) performing raw JDBC operations.
*   `com.oceanview.model`: The representation of domain entities like `Guest`, `Reservation`, and `Staff`.
*   `com.oceanview.db`: Low-level database interface and ID generation systems.
*   `com.oceanview.admin` & `com.oceanview.staff`: specialized controllers for role-specific workflows.
*   `com.oceanview.util`: JSON processing logic and common utility tools.

### 📱 Frontend (Flutter)
- `features/`: Contains role-based UI views (Admin, Staff, Guest).
- `models/`: Client-side data representations.
- `services/`: API client implementations.
- `providers/`: State management using the Provider pattern.

---

## 📂 Project Directory Structure

### ⚙️ Backend (The Pure Java Engine)
```text
backend/
├── src/main/java/com/oceanview/
│   ├── admin/          # Admin-specific business logic
│   ├── db/             # Database connection pooling & management
│   ├── main/           # Application entry point
│   ├── model/          # Domain entities (Room, Guest, Reservation, etc.)
│   ├── repository/     # SQL Data Access Layer (RAW JDBC)
│   ├── service/        # Core business rules & logic
│   ├── staff/          # Staff-specific workflow controllers
│   ├── util/           # JSON Adapters & Utility classes
│   └── webservice/     # Custom Socket-based HTTP Server & Controllers
└── resources/          # SQL scripts & initialization data
```

### 📱 Frontend (STUNNING Flutter UI)
```text
frontend/
├── lib/
│   ├── features/
│   │   ├── authentication/  # Login, Registration & Auth Providers
│   │   ├── main/            # Main Navigation Shells
│   │   │   └── screens/     # Dashboard sub-views (Admin, Staff, Guest)
│   │   └── user/            # Public & Private User features
│   │       ├── home/        # Luxury Guest Landing & Home
│   │       └── booking/     # Reservation flows & management
│   ├── models/              # Client data models & JSON parsing
│   ├── services/            # API Communication logic
│   ├── shared/              # Reusable widgets & navigation bars
│   └── theme/               # Glassmorphism & Luxury Design tokens
└── assets/
    └── images/              # High-definition resort photography
```

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

### 4. The Payment & Checkout Lifecycle
The system tracks every interaction. Once a guest is checked in, any additional services ordered are appended to their unique reservation ID. Upon departure, the guest can review their itemized bill, complete a secure payment, and the system automatically updates room availability for the next visitor.

---

## 🚀 Execution & Operational Guide

To bring the Ocean View Resort system to life, follow these three stages of activation.

### Phase 1: Database Initialization
The foundation must be established first. The SQL scripts in the `resources` folder are executed against a MariaDB/MySQL instance. These scripts create the tables for users, rooms, and reservations, and seed the system with essential data like the primary Admin account and initial luxury room inventory.

### Phase 2: Backend Engine Activation
The Java server is launched using Maven. Once active, the server starts listening for incoming requests on Port 8080.
```bash
cd backend
mvn clean compile exec:java
```

### Phase 3: Client Application Launch
The Flutter application is launched. The UI dynamically adapts based on the role of the person logging in.
```bash
cd frontend
flutter run -d chrome  # For Web
# OR
flutter run            # For Mobile/Desktop
```

---

## 🌐 Language & Engineering Details

-   **Flutter (Dart):** Chosen for its ability to render 60FPS animations and its powerful layout system that makes "Glassmorphism" possible.
-   **Java:** Chosen for its strict typing and multi-threading capabilities, allowing the custom server to handle multiple guest requests simultaneously without slowing down.
-   **SQL:** Chosen for its industry-standard reliability in maintaining complex relationships between guests, payments, and room inventory.

---

> [!NOTE]
> **A Note on Design:** Every button, card, and transition in this application is designed to feel "Premium." The focus is not just on functionality, but on providing an experience that matches the quality of a 5-star resort.
