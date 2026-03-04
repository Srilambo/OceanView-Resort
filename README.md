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
- **Architecture:** Feature-based Clean Architecture
- **State Management:** Provider & Service patterns
- **Styling:** Custom Luxury UI with Glassmorphism and Material 3

### ⚙️ Backend: Pure Java
- **Language:** Java 11 (Strictly typed, robust)
- **Engine:** Custom-built High-Performance HTTP Server (No Spring Boot, No heavy frameworks)
- **Protocol:** RESTful API with GSON for high-speed serialization
- **Database Access:** Pure JDBC (Direct connection for maximum performance)

### 🗄️ Database
- **Engine:** MariaDB 10.x
- **Schema:** Optimized relational structure with Foreign Key integrity and stored logic

---

## 🛠️ Project Structure

```text
OceanView-Resort/
├── frontend/               # 📱 Flutter Mobile/Web Application
│   ├── lib/
│   │   ├── features/       # 🧩 Modular Business Features
│   │   │   ├── main/       # Dashboards & Core Views
│   │   │   ├── user/       # Profile & Management
│   │   │   └── auth/       # Authentication Logic
│   │   ├── models/         # Domain Entities
│   │   ├── services/       # API Integration Layer
│   │   ├── shared/         # Reusable Components
│   │   └── theme/          # Luxury Design System
│   └── pubspec.yaml        # Project Configuration
├── backend/                # ⚙️ Java Backend Service
│   ├── src/main/java/com/oceanview/
│   │   ├── webservice/     # HTTP Handlers (REST Controllers)
│   │   ├── service/        # Business Logic Layer
│   │   ├── repository/     # Data Access (JDBC)
│   │   ├── model/          # POJOs (Entities)
│   │   └── db/             # Connection Management
│   ├── resources/          # SQL Schema & Configuration
│   └── pom.xml             # Maven Project Build
└── README.md               # Project Hub
```

---

## ✨ Key Features

### 🏢 Admin Management Portal
- **Dashboard:** Real-time statistics and resort overview.
- **Staff Management:** Complete CRUD for employee and admin accounts.
- **Room Management:** Dynamic inventory control (types, prices, status).
- **Reservation Control:** Unified view of all resort bookings.

### 🛎️ Guest Services
- **Luxury Landing Screen:** High-end introduction to the resort.
- **Secure Authentication:** Multi-role login (Admin, Manager, Staff, User).
- **Real-time Availability:** Smart room search and booking.
- **Automated Billing:** Precision-calculated stays and invoice generation.

### 🛡️ System Engineering
- **Pure Java Stack:** Zero-dependency backend for ultra-low latency.
- **Glassmorphism UI:** Premium aesthetic with smooth animations.
- **Relational Integrity:** Strict MySQL/MariaDB schema enforcement.

---

## 🏁 Getting Started

### 1. Database Setup
1. Ensure **MariaDB** is installed and running.
2. Initialize the database using:
   ```bash
   mariadb -u root -p < backend/resources/schema.sql
   ```

### 2. Launch Backend
```bash
cd backend
mvn clean compile
mvn exec:java
```

### 3. Launch Frontend (Web)
```bash
cd frontend
flutter run -d chrome
```

---

> [!TIP]
> **Performance First:** This project avoids JavaScript entirely in the core logic path. The backend uses a custom socket-based HTTP handler to minimize overhead.

> [!IMPORTANT]
> **Architecture Rule:** UI must remain decoupled from data logic. Use the `api_service.dart` in the frontend and `Service` layers in the backend for all business operations.

---

---

## 📡 API Documentation

The backend exposes a lightweight REST API. All endpoints return JSON and require `Content-Type: application/json`.

### 🔐 Authentication
| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/auth/login` | Authenticate user & get role |
| POST | `/api/auth/register` | Register a new guest account |

### 👥 User Management
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/users` | List all system users |
| GET | `/api/users/role/{ROLE}` | Filter users by role (ADMIN, MANAGER, etc) |
| POST | `/api/admin/users` | Admin-only user creation |
| PUT | `/api/users` | Update user details |
| DELETE | `/api/users/{id}` | Remove a user account |

### 🛌 Room Management
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/rooms?available=true` | List rooms (optional filtering) |
| POST | `/api/rooms` | Create a new room entry |
| PUT | `/api/rooms` | Update room data |
| DELETE | `/api/rooms/{id}` | Remove a room from inventory |

### 📅 Reservations
| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/reservations` | List all bookings |
| GET | `/api/reservations/{id}` | Get specific booking details |
| GET | `/api/reservations/number/{num}` | Search by reservation number |
| GET | `/api/reservations/guest/{id}` | List reservations for a guest |
| GET | `/api/reservations/{id}/bill` | Generate billing information |
| POST | `/api/reservations` | Create a new booking |
| PUT | `/api/reservations/{id}` | Update booking status/dates |
| DELETE | `/api/reservations/{id}` | Cancel a reservation |

---

# 📐 Android Gravity & Flutter Layout Guide
> *Resource for maintaining layout consistency across the Ocean View Resort UI.*

---

## 📐 LAYOUT WIDGETS & GRAVITY

### 1. COLUMN (Vertical Layout)
```dart
// Similar to Android LinearLayout(vertical)

Column(
  mainAxisAlignment: MainAxisAlignment.center,    // Gravity vertical
  crossAxisAlignment: CrossAxisAlignment.center,  // Gravity horizontal
  children: [
    Text('Top'),
    SizedBox(height: 20),
    Text('Middle'),
    SizedBox(height: 20),
    Text('Bottom'),
  ],
)
```

**MainAxisAlignment Options:**
- `.start` - Top (gravity="top")
- `.center` - Center vertical (gravity="center_vertical")
- `.end` - Bottom (gravity="bottom")
- `.spaceAround` - Equal space around
- `.spaceBetween` - Equal space between
- `.spaceEvenly` - Equal space everywhere

**CrossAxisAlignment Options:**
- `.start` - Left (gravity="left")
- `.center` - Center horizontal (gravity="center_horizontal")
- `.end` - Right (gravity="right")
- `.stretch` - Fill width

---

### 2. ROW (Horizontal Layout)
```dart
// Similar to Android LinearLayout(horizontal)

Row(
  mainAxisAlignment: MainAxisAlignment.center,    // Gravity horizontal
  crossAxisAlignment: CrossAxisAlignment.center,  // Gravity vertical
  children: [
    Text('Left'),
    SizedBox(width: 20),
    Text('Center'),
    SizedBox(width: 20),
    Text('Right'),
  ],
)
```

---

### 3. CENTER WIDGET
```dart
// Simple center - equivalent to gravity="center"

Center(
  child: Text('Centered Text'),
)

// Same as:
Container(
  alignment: Alignment.center,
  child: Text('Centered Text'),
)
```

---

### 4. ALIGN WIDGET
```dart
// Precise alignment control

Align(
  alignment: Alignment.topCenter,  // gravity="top|centerHorizontal"
  child: Text('Top Center'),
)

Align(
  alignment: Alignment.bottomRight,  // gravity="bottom|right"
  child: Text('Bottom Right'),
)

Align(
  alignment: Alignment.centerLeft,  // gravity="left|centerVertical"
  child: Text('Center Left'),
)
```

---

### 5. STACK (Overlay Layout)
```dart
// Similar to Android FrameLayout with positioning

Stack(
  alignment: Alignment.center,  // Default gravity for all children
  children: [
    Container(
      width: 200,
      height: 200,
      color: Colors.blue,
    ),
    Positioned(
      top: 10,
      right: 10,
      child: Text('Top Right'),  // gravity="top|right"
    ),
    Positioned(
      bottom: 10,
      left: 10,
      child: Text('Bottom Left'),  // gravity="bottom|left"
    ),
  ],
)
```

---

## 🎨 COMPLETE EXAMPLE - OCEAN VIEW RESORT LAYOUT

### Header with Gravity

```dart
class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withOpacity(0.4),
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      // gravity="center_vertical"
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Spread items
        crossAxisAlignment: CrossAxisAlignment.center,       // Center vertical
        children: [
          // Left - Logo (gravity="left|centerVertical")
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('🌊', style: TextStyle(fontSize: 28)),
              SizedBox(width: 12),
              Text('Ocean View', style: TextStyle(fontSize: 24)),
            ],
          ),
          
          // Center - Navigation (gravity="center")
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavLink(label: 'Rooms'),
              NavLink(label: 'Amenities'),
              NavLink(label: 'Contact'),
            ],
          ),
          
          // Right - Icons (gravity="right|centerVertical")
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SearchBox(),
              SizedBox(width: 12),
              NotificationIcon(),
            ],
          ),
        ],
      ),
    );
  }
}
```

### Hero Section with Gravity

```dart
class HeroSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      // gravity="center" (both vertical and horizontal)
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // gravity="center_vertical"
          crossAxisAlignment: CrossAxisAlignment.center, // gravity="center_horizontal"
          children: [
            // Title - gravity="center_horizontal"
            Text(
              'Experience',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 10),
            
            // Subtitle with gradient
            ShaderMask(
              shaderCallback: (bounds) => AppColors.goldGradient.createShader(bounds),
              child: Text(
                'Nature in Luxury',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 56, color: Colors.white),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Description text - gravity="center_horizontal"
            Text(
              'Discover the perfect beachside escape at Ocean View Resort.\nPremium accommodations with breathtaking views.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Booking Card with Gravity

```dart
class BookingCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(  // gravity="center_horizontal"
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.glassLight,
          border: Border.all(color: AppColors.glassBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        // Inner layout with gravity
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,  // gravity="top"
          crossAxisAlignment: CrossAxisAlignment.stretch, // gravity="fill_horizontal"
          children: [
            // Tabs - gravity="left"
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,  // gravity="left"
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BookingTab(label: 'Rooms'),
                  BookingTab(label: 'Amenities'),
                  BookingTab(label: 'Experiences'),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Form fields - gravity="fill_horizontal|center_vertical"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: DatePickerField(label: 'Check In'),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DatePickerField(label: 'Check Out'),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: GuestDropdown(),
                ),
                SizedBox(width: 20),
                // Button - gravity="right|centerVertical"
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Check Availability'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Features Grid with Gravity

```dart
class FeaturesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        // Main layout gravity
        mainAxisAlignment: MainAxisAlignment.start,  // gravity="top"
        crossAxisAlignment: CrossAxisAlignment.center, // gravity="center_horizontal"
        children: [
          // Header - gravity="center"
          Text(
            'Why Choose Ocean View',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          
          SizedBox(height: 48),
          
          // Grid layout
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return FeatureCard(
                icon: '🏨',
                title: 'Spacious Rooms',
                description: 'Elegantly designed rooms with ocean views',
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### Feature Card with Gravity

```dart
class FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.glassLight,
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      // Content layout - gravity="top|left"
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,  // gravity="top"
        crossAxisAlignment: CrossAxisAlignment.start, // gravity="left"
        children: [
          // Icon - gravity="top|left"
          Text(
            icon,
            style: TextStyle(fontSize: 40),
          ),
          
          SizedBox(height: 16),
          
          // Title - gravity="top|left"
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          
          SizedBox(height: 12),
          
          // Description - gravity="top|left" with fill_horizontal
          Text(
            description,
            style: TextStyle(color: AppColors.textLight, height: 1.6),
          ),
        ],
      ),
    );
  }
}
```

### CTA Section with Gravity

```dart
class CtaSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(  // gravity="center_horizontal"
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.glassLight,
          border: Border.all(color: AppColors.glassBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        // Content - gravity="center"
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // gravity="center_vertical"
          crossAxisAlignment: CrossAxisAlignment.center, // gravity="center_horizontal"
          children: [
            // Title - gravity="center"
            Text(
              'Ready for Your Dream Escape?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 20),
            
            // Description - gravity="center"
            Text(
              'Join hundreds of satisfied guests...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textLight),
            ),
            
            SizedBox(height: 32),
            
            // Button - gravity="center"
            ElevatedButton(
              onPressed: () {},
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Footer with Gravity

```dart
class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.darkBg.withOpacity(0.6),
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      // Content - gravity="center_horizontal"
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,  // gravity="center_vertical"
        crossAxisAlignment: CrossAxisAlignment.center, // gravity="center_horizontal"
        children: [
          // Main text - gravity="center"
          Text(
            'Ocean View Resort | Galle, Sri Lanka',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          
          SizedBox(height: 8),
          
          // Contact info - gravity="center"
          Text(
            'Email: reservations@oceanviewresort.lk | Phone: +94 91 224 4000',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted),
          ),
          
          SizedBox(height: 16),
          
          // Copyright - gravity="center"
          Text(
            '© 2025 Ocean View Resort. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎯 GRAVITY QUICK REFERENCE TABLE

### Column (Vertical Container)

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,    // Vertical gravity
  crossAxisAlignment: CrossAxisAlignment.center,  // Horizontal gravity
)
```

| Android | Flutter mainAxisAlignment | Flutter crossAxisAlignment |
|---------|--------------------------|--------------------------|
| gravity="top" | `.start` | N/A |
| gravity="bottom" | `.end` | N/A |
| gravity="center_vertical" | `.center` | N/A |
| gravity="left" | N/A | `.start` |
| gravity="right" | N/A | `.end` |
| gravity="center_horizontal" | N/A | `.center` |
| gravity="center" | `.center` | `.center` |
| gravity="top\|center_horizontal" | `.start` | `.center` |
| gravity="bottom\|right" | `.end` | `.end` |

### Row (Horizontal Container)

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,    // Horizontal gravity
  crossAxisAlignment: CrossAxisAlignment.center,  // Vertical gravity
)
```

---

## 📍 POSITIONING WIDGETS

### Positioned Widget (for Stack)

```dart
// gravity="top|left"
Positioned(
  top: 0,
  left: 0,
  child: Widget(),
)

// gravity="top|right"
Positioned(
  top: 0,
  right: 0,
  child: Widget(),
)

// gravity="bottom|center_horizontal"
Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  child: Widget(),
)

// gravity="center"
Positioned(
  top: 0,
  left: 0,
  bottom: 0,
  right: 0,
  child: Center(child: Widget()),
)
```

---

## 🔧 LAYOUT TRICKS

### Fill Width (gravity="fill_horizontal")
```dart
SizedBox(
  width: double.infinity,  // Fill parent width
  child: Widget(),
)

// Or use Expanded in Row
Row(
  children: [
    Expanded(
      child: Widget(),  // Fills available width
    ),
  ],
)
```

### Fill Height (gravity="fill_vertical")
```dart
SizedBox(
  height: double.infinity,  // Fill parent height
  child: Widget(),
)

// Or use Expanded in Column
Column(
  children: [
    Expanded(
      child: Widget(),  // Fills available height
    ),
  ],
)
```

### Center Everything
```dart
// Method 1: Center widget
Center(child: Widget())

// Method 2: Container with alignment
Container(
  alignment: Alignment.center,
  child: Widget(),
)

// Method 3: Column + Row
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Widget()],
    ),
  ],
)
```

---

## 📱 RESPONSIVE LAYOUT WITH GRAVITY

```dart
Widget buildResponsiveLayout(BuildContext context) {
  final isMobile = MediaQuery.of(context).size.width < 600;
  
  if (isMobile) {
    // Mobile layout - Column (vertical)
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,  // gravity="top"
      crossAxisAlignment: CrossAxisAlignment.center, // gravity="center_horizontal"
      children: [
        // Stacked vertically
      ],
    );
  } else {
    // Desktop layout - Row (horizontal)
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,  // gravity="space_around"
      crossAxisAlignment: CrossAxisAlignment.center,      // gravity="center_vertical"
      children: [
        // Side by side
      ],
    );
  }
}
```

---

## 🎨 COMPLETE GRAVITY CHEATSHEET

```dart
// CENTER
Center(child: Widget())
Container(alignment: Alignment.center, child: Widget())

// TOP
Container(alignment: Alignment.topCenter, child: Widget())
Column(mainAxisAlignment: MainAxisAlignment.start)

// BOTTOM
Container(alignment: Alignment.bottomCenter, child: Widget())
Column(mainAxisAlignment: MainAxisAlignment.end)

// LEFT
Container(alignment: Alignment.centerLeft, child: Widget())
Row(mainAxisAlignment: MainAxisAlignment.start)

// RIGHT
Container(alignment: Alignment.centerRight, child: Widget())
Row(mainAxisAlignment: MainAxisAlignment.end)

// SPACE BETWEEN
Row(mainAxisAlignment: MainAxisAlignment.spaceBetween)
Column(mainAxisAlignment: MainAxisAlignment.spaceBetween)

// SPACE AROUND
Row(mainAxisAlignment: MainAxisAlignment.spaceAround)
Column(mainAxisAlignment: MainAxisAlignment.spaceAround)

// SPACE EVENLY
Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly)
Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly)

// FILL
Row(mainAxisAlignment: MainAxisAlignment.start, children: [
  Expanded(child: Widget())  // Fills width
])

// STRETCH
Column(crossAxisAlignment: CrossAxisAlignment.stretch)  // Fills width
```

---

## ✅ SUMMARY

| Concept | Android | Flutter |
|---------|---------|---------|
| Center | gravity="center" | `Alignment.center` or `Center()` |
| Vertical | gravity="center_vertical" | `mainAxisAlignment: .center` |
| Horizontal | gravity="center_horizontal" | `crossAxisAlignment: .center` |
| Top-Left | gravity="top\|left" | `Alignment.topLeft` |
| Bottom-Right | gravity="bottom\|right" | `Alignment.bottomRight` |
| Fill Width | gravity="fill_horizontal" | `crossAxisAlignment: .stretch` |
| Fill Height | gravity="fill_vertical" | `mainAxisAlignment: .stretch` |
| Space Around | gravity="space_around" | `mainAxisAlignment: .spaceAround` |
| Space Between | gravity="space_between" | `mainAxisAlignment: .spaceBetween` |

This guide covers all Android gravity concepts mapped to Flutter widgets for the Ocean View Resort landing screen!

