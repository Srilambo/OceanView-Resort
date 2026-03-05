CREATE DATABASE IF NOT EXISTS oceanview;
USE oceanview;

CREATE TABLE IF NOT EXISTS users (
    user_id VARCHAR(50) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_id VARCHAR(50),
    role VARCHAR(50),
    PRIMARY KEY (user_id, role),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS guests (
    guest_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contact_number VARCHAR(20),
    address TEXT,
    id_type VARCHAR(50), -- Passport, National ID, etc.
    id_number VARCHAR(50),
    nationality VARCHAR(50),
    user_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS rooms (
    room_id VARCHAR(50) PRIMARY KEY,
    room_number VARCHAR(20) UNIQUE NOT NULL,
    room_type VARCHAR(50),
    capacity INT,
    price_per_night DECIMAL(10, 2),
    description TEXT,
    image_url TEXT,
    available BOOLEAN DEFAULT TRUE,
    status VARCHAR(20) DEFAULT 'AVAILABLE'
);

CREATE TABLE IF NOT EXISTS reservations (
    reservation_id VARCHAR(50) PRIMARY KEY,
    reservation_number VARCHAR(20) UNIQUE NOT NULL,
    guest_id VARCHAR(50),
    room_id VARCHAR(50),
    check_in_date DATETIME NOT NULL,
    check_out_date DATETIME NOT NULL,
    actual_check_in DATETIME,
    actual_check_out DATETIME,
    number_of_nights INT,
    total_cost DECIMAL(10, 2),
    status VARCHAR(20) DEFAULT 'PENDING',
    special_requests TEXT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

CREATE TABLE IF NOT EXISTS staff (
    staff_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50),
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    date_of_birth DATE,
    emergency_contact VARCHAR(100),
    department VARCHAR(50) NOT NULL,
    position VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    shift VARCHAR(20) DEFAULT 'MORNING',
    hire_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- Seed data for testing
REPLACE INTO users (user_id, username, password, email) VALUES 
('admin-001', 'admin', 'admin123', 'admin@oceanview.com');

REPLACE INTO user_roles (user_id, role) VALUES 
('admin-001', 'ADMIN'),
('admin-001', 'USER');

-- Staff user accounts
REPLACE INTO users (user_id, username, password, email) VALUES 
('staff-user-001', 'john.smith', 'staff123', 'john.smith@oceanview.com'),
('staff-user-002', 'sarah.jones', 'staff123', 'sarah.jones@oceanview.com'),
('staff-user-003', 'mike.chen', 'staff123', 'mike.chen@oceanview.com');

REPLACE INTO user_roles (user_id, role) VALUES 
('staff-user-001', 'ROLE_STAFF'),
('staff-user-002', 'ROLE_STAFF'),
('staff-user-003', 'ROLE_STAFF');

INSERT INTO rooms (room_id, room_number, room_type, capacity, price_per_night, description, image_url, available, status) VALUES
('room-101', '101', 'DELUXE', 2, 150.00, 'Spacious deluxe room with breathtaking ocean views, king-size bed, marble bathroom with rain shower, mini bar, and a private balcony overlooking the turquoise waters.', 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=800&q=80', TRUE, 'AVAILABLE'),
('room-102', '102', 'STANDARD', 2, 100.00, 'Cozy standard room surrounded by lush tropical gardens, queen-size bed, modern bathroom, complimentary Wi-Fi, and a writing desk. Perfect for a relaxing getaway.', 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', TRUE, 'AVAILABLE'),
('room-201', '201', 'SUITE', 4, 300.00, 'Luxurious presidential suite featuring a separate living area, panoramic ocean views, private balcony with jacuzzi, butler service, and premium amenities throughout.', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80', TRUE, 'AVAILABLE'),
('room-103', '103', 'STANDARD', 2, 110.00, 'Bright and airy standard room with partial ocean views, queen-size bed, flat-screen TV, tea and coffee making facilities, and a cozy reading nook.', 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', TRUE, 'AVAILABLE'),
('room-104', '104', 'DELUXE', 3, 180.00, 'Premium deluxe room with stunning sunset views, king-size bed plus daybed, spa-inspired bathroom, Nespresso machine, and complimentary access to the wellness center.', 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=800&q=80', TRUE, 'AVAILABLE'),
('room-202', '202', 'SUITE', 4, 350.00, 'Elegant honeymoon suite with romantic ocean views, four-poster king bed, couples spa bath, champagne on arrival, and a private terrace with dining area.', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80', TRUE, 'AVAILABLE'),
('room-301', '301', 'VILLA', 6, 500.00, 'Exclusive beachfront villa with private pool, two bedrooms, fully equipped kitchen, outdoor shower, direct beach access, and personal concierge service.', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=800&q=80', FALSE, 'OCCUPIED'),
('room-302', '302', 'VILLA', 4, 450.00, 'Tropical garden villa with private plunge pool, spacious bedroom, outdoor living area, hammock, and surrounded by fragrant tropical flowers and palms.', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=800&q=80', TRUE, 'AVAILABLE'),
('room-401', '401', 'PENTHOUSE', 4, 800.00, 'The crown jewel of Ocean View Resort. Panoramic 360° views, rooftop infinity pool, private elevator, chef kitchen, home theater, and 24/7 butler service.', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&q=80', TRUE, 'AVAILABLE'),
('room-105', '105', 'STANDARD', 1, 85.00, 'Compact yet stylish single room ideal for solo travelers, comfortable single bed, workspace, high-speed Wi-Fi, and access to the shared lounge on the ground floor.', 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', TRUE, 'AVAILABLE')
ON DUPLICATE KEY UPDATE room_number=room_number;

-- Seed staff data
INSERT INTO staff (staff_id, user_id, full_name, email, phone, department, position, salary, status, shift) VALUES
('staff-001', 'staff-user-001', 'John Smith', 'john.smith@oceanview.com', '+94771234567', 'FRONT_DESK', 'Senior Receptionist', 45000.00, 'ACTIVE', 'MORNING'),
('staff-002', 'staff-user-002', 'Sarah Jones', 'sarah.jones@oceanview.com', '+94779876543', 'HOUSEKEEPING', 'Head Housekeeper', 38000.00, 'ACTIVE', 'MORNING'),
('staff-003', 'staff-user-003', 'Mike Chen', 'mike.chen@oceanview.com', '+94775551234', 'RESTAURANT', 'Head Chef', 55000.00, 'ACTIVE', 'AFTERNOON')
ON DUPLICATE KEY UPDATE full_name=full_name;

CREATE TABLE IF NOT EXISTS tasks (
    task_id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    assigned_to VARCHAR(50),
    status VARCHAR(20) DEFAULT 'PENDING',
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (assigned_to) REFERENCES staff(staff_id) ON DELETE SET NULL
);

-- Seed tasks
INSERT INTO tasks (task_id, title, description, assigned_to, status, priority, due_date) VALUES
('task-001', 'Clean Suite 201', 'Complete deep cleaning of presidential suite 201 before guest arrival.', 'staff-002', 'PENDING', 'HIGH', CURDATE()),
('task-002', 'Restock Mini Bar', 'Restock mini bars in all deluxe rooms on the first floor.', 'staff-002', 'IN_PROGRESS', 'MEDIUM', CURDATE()),
('task-003', 'Guest Check-in Assistance', 'Help VIP guests checking into Room 201 with luggage.', 'staff-001', 'PENDING', 'MEDIUM', CURDATE()),
('task-004', 'Dinner Prep', 'Prepare signature seafood platter for tonight''s gala event.', 'staff-003', 'PENDING', 'URGENT', CURDATE())
ON DUPLICATE KEY UPDATE title=title;

-- ========== Resort Services Table ==========
CREATE TABLE IF NOT EXISTS resort_services (
    service_id VARCHAR(50) PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) DEFAULT 0.00,
    duration VARCHAR(50),
    available BOOLEAN DEFAULT TRUE,
    icon VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== Reservation Services (Add-to-Bill) ==========
CREATE TABLE IF NOT EXISTS reservation_services (
    id VARCHAR(50) PRIMARY KEY,
    reservation_id VARCHAR(50) NOT NULL,
    service_id VARCHAR(50) NOT NULL,
    service_name VARCHAR(100) NOT NULL,
    service_price DECIMAL(10, 2) NOT NULL,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES resort_services(service_id)
);

-- ========== Reviews Table ==========
CREATE TABLE IF NOT EXISTS reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    guest_name VARCHAR(100) NOT NULL,
    room_type VARCHAR(50),
    rating INT NOT NULL,
    title VARCHAR(255),
    comment TEXT,
    stay_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========== Guest user 'sri' ==========
REPLACE INTO users (user_id, username, password, email) VALUES
('user-sri-001', 'sri', 'sri123', 'sri@oceanview.com');

REPLACE INTO user_roles (user_id, role) VALUES
('user-sri-001', 'ROLE_USER');

INSERT INTO guests (guest_id, user_id, name, email, contact_number, address, id_type, id_number, nationality) VALUES
('guest-sri-001', 'user-sri-001', 'Sri Kumar', 'sri@oceanview.com', '+94771112233', '42 Beach Road, Colombo', 'Passport', 'N1234567', 'Sri Lankan')
ON DUPLICATE KEY UPDATE name=name, user_id=VALUES(user_id);

-- ========== Demo Reservations ==========
INSERT INTO reservations (reservation_id, reservation_number, guest_id, room_id, check_in_date, check_out_date, number_of_nights, total_cost, status, special_requests) VALUES
('res-001', 'RES-20260315', 'guest-sri-001', 'room-101', '2026-03-15', '2026-03-18', 3, 450.00, 'CONFIRMED', 'Late check-in around 10 PM. Extra pillows please.'),
('res-002', 'RES-20260401', 'guest-sri-001', 'room-202', '2026-04-01', '2026-04-05', 4, 1400.00, 'PENDING', 'Anniversary trip - please arrange flowers and champagne.'),
('res-003', 'RES-20260210', 'guest-sri-001', 'room-102', '2026-02-10', '2026-02-12', 2, 200.00, 'COMPLETED', 'No special requests.'),
('res-004', 'RES-20260120', 'guest-sri-001', 'room-201', '2026-01-20', '2026-01-25', 5, 1500.00, 'COMPLETED', 'Need baby crib and high chair.'),
('res-005', 'RES-20260501', 'guest-sri-001', 'room-401', '2026-05-01', '2026-05-04', 3, 2400.00, 'PENDING', 'Penthouse stay for birthday celebration.')
ON DUPLICATE KEY UPDATE reservation_number=reservation_number;

-- ========== Demo Resort Services ==========
INSERT INTO resort_services (service_id, service_name, category, description, price, duration, available, icon) VALUES
('svc-001', 'Ocean Breeze Spa', 'SPA', 'Rejuvenate with our signature full-body massage using organic essential oils. Includes aromatherapy, hot stone therapy, and a complimentary herbal tea session.', 120.00, '90 min', TRUE, 'spa'),
('svc-002', 'Sunset Yoga Session', 'FITNESS', 'Join our certified yoga instructor for a guided session on the beachfront deck as the sun sets over the Indian Ocean. All levels welcome.', 25.00, '60 min', TRUE, 'fitness_center'),
('svc-003', 'Coral Reef Snorkeling', 'ADVENTURE', 'Explore vibrant coral reefs with professional guides. Equipment, boat ride, and underwater photography included. Suitable for beginners.', 85.00, '3 hours', TRUE, 'scuba_diving'),
('svc-004', 'The Pearl Restaurant', 'DINING', 'Fine dining experience featuring fresh seafood and international cuisine. Our award-winning chef crafts dishes from locally sourced ingredients.', 75.00, 'Per person', TRUE, 'restaurant'),
('svc-005', 'Infinity Pool & Lounge', 'RECREATION', 'Relax at our stunning infinity pool overlooking the ocean. Complimentary towels, sunbeds, and poolside drink service included for all guests.', 0.00, 'All day', TRUE, 'pool'),
('svc-006', 'Private Beach Dinner', 'DINING', 'An unforgettable candlelit dinner on the private beach. Four-course gourmet meal with champagne, personalized menu, and live acoustic music.', 250.00, '2 hours', TRUE, 'dinner_dining'),
('svc-007', 'Island Hopping Tour', 'ADVENTURE', 'Full-day excursion visiting nearby tropical islands. Includes speedboat transfers, snorkeling stops, beach barbecue lunch, and guided nature walk.', 150.00, 'Full day', TRUE, 'sailing'),
('svc-008', 'Kids Adventure Club', 'FAMILY', 'Supervised activities for children ages 4-12 including treasure hunts, sand castle building, arts and crafts, and mini water sports.', 35.00, 'Half day', TRUE, 'child_care')
ON DUPLICATE KEY UPDATE service_name=service_name;

-- ========== Demo Reviews ==========
INSERT INTO reviews (review_id, guest_name, room_type, rating, title, comment, stay_date) VALUES
('rev-001', 'Emily Watson', 'SUITE', 5, 'Absolutely Breathtaking!', 'The presidential suite exceeded all expectations. The ocean views from the balcony were stunning, the jacuzzi was amazing, and the butler service was impeccable. We celebrated our anniversary here and it was perfect in every way. The staff went above and beyond!', '2026-02-14'),
('rev-002', 'James Mitchell', 'DELUXE', 4, 'Great Stay, Minor Issues', 'The deluxe room was beautiful and well-maintained. The rain shower was a highlight! The only minor issue was the Wi-Fi being a bit slow during peak hours. The restaurant food was outstanding though. Would definitely recommend!', '2026-02-20'),
('rev-003', 'Aisha Patel', 'VILLA', 5, 'Paradise Found', 'The beachfront villa with private pool was pure luxury. Waking up to the sound of waves and having direct beach access was incredible. The personal concierge made everything seamless. Already planning our next visit!', '2026-01-28'),
('rev-004', 'Robert Chen', 'STANDARD', 4, 'Excellent Value', 'For the price, this was an incredible stay. The standard room was clean, comfortable, and had everything we needed. The garden views were lovely. The spa service was world-class. Highly recommend for couples on a budget.', '2026-02-05'),
('rev-005', 'Sofia Rodriguez', 'PENTHOUSE', 5, 'Once in a Lifetime Experience', 'The penthouse was beyond anything I have ever experienced. The 360-degree views, rooftop infinity pool, and home theater were phenomenal. The 24/7 butler service anticipated our every need. Worth every penny for a special occasion!', '2026-01-15')
ON DUPLICATE KEY UPDATE guest_name=guest_name;
