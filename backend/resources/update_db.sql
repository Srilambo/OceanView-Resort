ALTER TABLE staff ADD COLUMN IF NOT EXISTS address TEXT;
ALTER TABLE staff ADD COLUMN IF NOT EXISTS date_of_birth DATE;
ALTER TABLE staff ADD COLUMN IF NOT EXISTS emergency_contact VARCHAR(100);

ALTER TABLE guests ADD COLUMN IF NOT EXISTS id_type VARCHAR(50);
ALTER TABLE guests ADD COLUMN IF NOT EXISTS id_number VARCHAR(50);
ALTER TABLE guests ADD COLUMN IF NOT EXISTS nationality VARCHAR(50);

ALTER TABLE reservations ADD COLUMN IF NOT EXISTS actual_check_in DATETIME;
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS actual_check_out DATETIME;
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'AVAILABLE';
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS image_url TEXT;
UPDATE rooms SET status = 'OCCUPIED' WHERE available = FALSE AND status = 'AVAILABLE';

-- Update existing room descriptions and images
UPDATE rooms SET 
  description = 'Spacious deluxe room with breathtaking ocean views, king-size bed, marble bathroom with rain shower, mini bar, and a private balcony overlooking the turquoise waters.',
  image_url = 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=800&q=80'
WHERE room_id = 'room-101';

UPDATE rooms SET 
  description = 'Cozy standard room surrounded by lush tropical gardens, queen-size bed, modern bathroom, complimentary Wi-Fi, and a writing desk. Perfect for a relaxing getaway.',
  image_url = 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80'
WHERE room_id = 'room-102';

UPDATE rooms SET 
  description = 'Luxurious presidential suite featuring a separate living area, panoramic ocean views, private balcony with jacuzzi, butler service, and premium amenities throughout.',
  image_url = 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80'
WHERE room_id = 'room-201';

-- Insert new demo rooms
INSERT INTO rooms (room_id, room_number, room_type, capacity, price_per_night, description, image_url, available) VALUES
('room-103', '103', 'STANDARD', 2, 110.00, 'Bright and airy standard room with partial ocean views, queen-size bed, flat-screen TV, tea and coffee making facilities, and a cozy reading nook.', 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', TRUE),
('room-104', '104', 'DELUXE', 3, 180.00, 'Premium deluxe room with stunning sunset views, king-size bed plus daybed, spa-inspired bathroom, Nespresso machine, and complimentary access to the wellness center.', 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=800&q=80', TRUE),
('room-202', '202', 'SUITE', 4, 350.00, 'Elegant honeymoon suite with romantic ocean views, four-poster king bed, couples spa bath, champagne on arrival, and a private terrace with dining area.', 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=800&q=80', TRUE),
('room-301', '301', 'VILLA', 6, 500.00, 'Exclusive beachfront villa with private pool, two bedrooms, fully equipped kitchen, outdoor shower, direct beach access, and personal concierge service.', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=800&q=80', FALSE),
('room-302', '302', 'VILLA', 4, 450.00, 'Tropical garden villa with private plunge pool, spacious bedroom, outdoor living area, hammock, and surrounded by fragrant tropical flowers and palms.', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=800&q=80', TRUE),
('room-401', '401', 'PENTHOUSE', 4, 800.00, 'The crown jewel of Ocean View Resort. Panoramic 360 degree views, rooftop infinity pool, private elevator, chef kitchen, home theater, and 24/7 butler service.', 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&q=80', TRUE),
('room-105', '105', 'STANDARD', 1, 85.00, 'Compact yet stylish single room ideal for solo travelers, comfortable single bed, workspace, high-speed Wi-Fi, and access to the shared lounge on the ground floor.', 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', TRUE)
ON DUPLICATE KEY UPDATE room_number=room_number;

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

INSERT INTO guests (guest_id, name, email, contact_number, address, id_type, id_number, nationality) VALUES
('guest-sri-001', 'Sri Kumar', 'sri@oceanview.com', '+94771112233', '42 Beach Road, Colombo', 'Passport', 'N1234567', 'Sri Lankan')
ON DUPLICATE KEY UPDATE name=name;

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
('svc-005', 'Infinity Pool and Lounge', 'RECREATION', 'Relax at our stunning infinity pool overlooking the ocean. Complimentary towels, sunbeds, and poolside drink service included for all guests.', 0.00, 'All day', TRUE, 'pool'),
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
UPDATE user_roles SET role = 'ROLE_ADMIN' WHERE role = 'ROLE_MANAGER';
UPDATE user_roles SET role = 'ROLE_ADMIN' WHERE role = 'ADMIN';
UPDATE user_roles SET role = 'ROLE_USER' WHERE role = 'USER';

-- Ensure the main admin user is active and has the correct role
REPLACE INTO users (user_id, username, password, email) VALUES ('admin-001', 'admin', 'admin123', 'admin@oceanview.com');
REPLACE INTO user_roles (user_id, role) VALUES ('admin-001', 'ROLE_ADMIN');
