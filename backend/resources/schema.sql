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
    passport_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS rooms (
    room_id VARCHAR(50) PRIMARY KEY,
    room_number VARCHAR(20) UNIQUE NOT NULL,
    room_type VARCHAR(50),
    capacity INT,
    price_per_night DECIMAL(10, 2),
    description TEXT,
    available BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS reservations (
    reservation_id VARCHAR(50) PRIMARY KEY,
    reservation_number VARCHAR(20) UNIQUE NOT NULL,
    guest_id VARCHAR(50),
    room_id VARCHAR(50),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_nights INT,
    total_cost DECIMAL(10, 2),
    status VARCHAR(20) DEFAULT 'PENDING',
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Seed data for testing
INSERT INTO users (user_id, username, password, email) VALUES 
('admin-001', 'admin', 'admin123', 'admin@oceanview.com')
ON DUPLICATE KEY UPDATE username=username;

INSERT INTO user_roles (user_id, role) VALUES 
('admin-001', 'ADMIN'),
('admin-001', 'USER')
ON DUPLICATE KEY UPDATE role=role;

INSERT INTO rooms (room_id, room_number, room_type, capacity, price_per_night, description, available) VALUES
('room-101', '101', 'DELUXE', 2, 150.00, 'Ocean view deluxe room', TRUE),
('room-102', '102', 'STANDARD', 2, 100.00, 'Garden view standard room', TRUE),
('room-201', '201', 'SUITE', 4, 300.00, 'Presidential suite with balcony', TRUE)
ON DUPLICATE KEY UPDATE room_number=room_number;
