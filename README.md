# 🏨 Ocean View Resort - 100% Pure Stack

![Project Banner](https://img.shields.io/badge/Frontend-Flutter%20%26%20Dart-blue?style=for-the-badge&logo=flutter)
![Project Banner](https://img.shields.io/badge/Backend-Pure%20Java%2011-orange?style=for-the-badge&logo=java)
![Database](https://img.shields.io/badge/Database-MariaDB%20%2F%20SQL-003545?style=for-the-badge&logo=mariadb)

A premium, high-performance resort booking management system built with absolute precision using a minimal and clean technology stack. **No JavaScript. No bloat. Just pure engineering.**

---

## 🚀 Technology Stack

### 📱 Frontend: Flutter & Dart
- **Framework:** Flutter (Built for high performance)
- **Language:** Dart 2.19+
- **Styling:** Custom Luxury UI with Material 3
- **State Management:** Provider pattern
- **Architecture:** Clean UI/Service separation

### ⚙️ Backend: Pure Java
- **Language:** Java 11 (Strictly typed, robust)
- **Engine:** Custom-built High-Performance HTTP Server (No heavy frameworks)
- **Protocol:** RESTful API with GSON for high-speed serialization
- **Database Access:** Pure JDBC (Direct connection for maximum speed)

### 🗄️ Database
- **Engine:** MariaDB 10.x
- **Schema:** Optimized relational structure with Foreign Key integrity

---

## 🛠️ Project Structure

```text
OceanView-Resort/
├── frontend/               # 📱 Flutter Mobile/Web Application
│   ├── lib/                # Dart Code
│   │   ├── models/         # Data structures
│   │   ├── screens/        # UI Views
│   │   └── services/       # API Integration
│   └── pubspec.yaml        # Flutter Config
├── backend/                # ⚙️ Java Backend Service
│   ├── src/main/java/      # Pure Java Code
│   │   ├── db/             # JDBC Helpers
│   │   ├── model/          # POJOs
│   │   ├── repository/     # Data Access Objects
│   │   └── webservice/     # HTTP Handlers
│   ├── resources/          # SQL Schema & Seed Data
│   └── pom.xml             # Maven Config
└── README.md               # Project Hub
```

---

## 🏁 Getting Started

### 1. Database Setup
1. Ensure **MariaDB** is running on your machine.
2. Run the schema located at `backend/resources/schema.sql` to initialize the database and seed data.

### 2. Launch Backend
```bash
cd backend
mvn clean compile
mvn exec:java
```
_Terminal should confirm:_ `🏨 Ocean View Resort Backend Started`

### 3. Launch Frontend
```bash
cd frontend
flutter run -d chrome
```

---

## ✨ Features
- **Real-time Room Availability:** Instant check for room status.
- **Automated Billing:** Dynamic price calculation per night.
- **Reservation Management:** Full CRUD operations for bookings.
- **Luxury UX:** Beautifully crafted icons and fonts for a premium resort feel.

---
> [!IMPORTANT]
> This project is strictly restricted to **Flutter (Dart)** for the interface and **Pure Java** for the logic. High performance is achieved by avoiding unnecessary dependencies and JavaScript bloat.
