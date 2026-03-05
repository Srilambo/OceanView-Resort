# Ocean View Resort - Frontend

A premium resort management and booking application built with Flutter.

## ✨ Features

- **Dynamic Room Booking**: Seamless multi-step booking process with date and time selection.
- **User Authentication**: Secure login and registration with role-based access control (Admin, Staff, Guest).
- **Admin Dashboard**: Comprehensive management of rooms, bookings, users, and reports.
- **Staff Portal**: Efficient task management and check-in/check-out processing.
- **Guest Experience**: Personal booking history, resort service exploration, and reviews.
- **Premium UI**: Modern aesthetics using Google Fonts (Montserrat & Playfair Display) and a curated color palette.

## 📁 Project Structure

```text
lib/
├── features/               # Feature-based modules
│   ├── authentication/     # Login, registration, and auth providers
│   ├── main/               # Main application screens for different roles
│   │   ├── screens/        # Admin, Staff, and Guest main entry points
│   │   └── admin_views/    # Admin-specific management views
│   └── user/               # Guest-specific features (Rooms, Services, Reviews)
├── models/                 # Data models (Reservation, Room, User, etc.)
├── services/               # Core services (ApiService for backend communication)
├── shared/                 # Shared components (Theme, Navigation, UI helpers)
└── main.dart               # Application entry point
```

## 🛠️ Technology Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Font**: Google Fonts (Montserrat, Playfair Display)
- **Networking**: Http package for REST API communication
- **Date Formatting**: Intl package

## 🚀 Getting Started

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run -d chrome  # For web development
    ```

*Note: Ensure the backend server is running and accessible at the configured `baseUrl` in `lib/services/api_service.dart`.*

---

© 2026 Ocean View Resort. All rights reserved.
