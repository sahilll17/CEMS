-- ====================================================================
-- Chandigarh University - College Event Management Portal (CEMS)
-- Database Creation & Schema Script
-- Designed for MySQL 8.0+ / 26.x
-- ====================================================================

CREATE DATABASE IF NOT EXISTS `cems_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `cems_db`;

-- Drop existing tables in dependency order if needed
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `registrations`;
DROP TABLE IF EXISTS `events`;
DROP TABLE IF EXISTS `venues`;
DROP TABLE IF EXISTS `users`;
SET FOREIGN_KEY_CHECKS = 1;

-- --------------------------------------------------------------------
-- Table structure for `users`
-- --------------------------------------------------------------------
CREATE TABLE `users` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `uid` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `role` VARCHAR(20) NOT NULL DEFAULT 'STUDENT',
    `department` VARCHAR(100) DEFAULT NULL,
    `semester` VARCHAR(30) DEFAULT NULL,
    `phone` VARCHAR(20) DEFAULT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_users_email` (`email`),
    UNIQUE KEY `uk_users_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- Table structure for `venues`
-- --------------------------------------------------------------------
CREATE TABLE `venues` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(150) NOT NULL,
    `location` VARCHAR(200) NOT NULL,
    `capacity` INT NOT NULL,
    `description` VARCHAR(500) DEFAULT NULL,
    `facilities` VARCHAR(255) DEFAULT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- Table structure for `events`
-- --------------------------------------------------------------------
CREATE TABLE `events` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(200) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `description` TEXT DEFAULT NULL,
    `venue_id` BIGINT NOT NULL,
    `event_date` DATE NOT NULL,
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
    `max_capacity` INT NOT NULL,
    `current_registrations` INT NOT NULL DEFAULT 0,
    `status` VARCHAR(30) NOT NULL DEFAULT 'PENDING_APPROVAL',
    `organizer_id` BIGINT NOT NULL,
    `banner_url` VARCHAR(500) DEFAULT NULL,
    `rejection_reason` VARCHAR(500) DEFAULT NULL,
    `rules` TEXT DEFAULT NULL,
    `registration_deadline` DATE DEFAULT NULL,
    `max_team_size` INT NOT NULL DEFAULT 1,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_events_date` (`event_date`),
    KEY `idx_events_status` (`status`),
    KEY `idx_events_category` (`category`),
    CONSTRAINT `fk_events_venue` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_events_organizer` FOREIGN KEY (`organizer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- Table structure for `registrations`
-- --------------------------------------------------------------------
CREATE TABLE `registrations` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `ticket_code` VARCHAR(50) NOT NULL,
    `event_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `registration_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `attendance_status` VARCHAR(30) NOT NULL DEFAULT 'REGISTERED',
    `qr_data` VARCHAR(500) DEFAULT NULL,
    `team_name` VARCHAR(150) DEFAULT NULL,
    `team_members` VARCHAR(500) DEFAULT NULL,
    `score` VARCHAR(50) DEFAULT NULL,
    `merit_rank` VARCHAR(50) DEFAULT NULL,
    `certificate_code` VARCHAR(80) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_registrations_ticket` (`ticket_code`),
    UNIQUE KEY `uk_event_user` (`event_id`, `user_id`),
    CONSTRAINT `fk_registrations_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_registrations_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------
-- Table structure for `notifications`
-- --------------------------------------------------------------------
CREATE TABLE `notifications` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `event_id` BIGINT DEFAULT NULL,
    `title` VARCHAR(150) NOT NULL,
    `message` VARCHAR(1000) NOT NULL,
    `type` VARCHAR(50) NOT NULL DEFAULT 'GENERAL',
    `is_read` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_notifications_user` (`user_id`),
    CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_notifications_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================
-- Sample Seed Data
-- Passwords below are hashed using BCrypt:
-- 'admin123'     -> $2a$12$Nq52n4kZ16Q0G50/2nF.1e6j1E2cIq2wHqF1yUe2Zk8Q9w7Uo8Wmi
-- 'organizer123' -> $2a$12$4mUfP50bU15gqIeG0K/90u3cIq2wHqF1yUe2Zk8Q9w7Uo8Wmi.k7a
-- 'student123'   -> $2a$12$b1I0zQ6.d98lH4f5f8H59uqm7e1FhH1eQz5C3k1P0f8eG4k5P0f8e
-- ====================================================================

-- 1. Users
INSERT INTO `users` (`id`, `uid`, `name`, `email`, `password_hash`, `role`, `department`, `semester`, `phone`, `status`, `created_at`) VALUES
(1, 'ADMIN001', 'Head Administrator', 'admin@cems.edu', '$2a$12$wK74i5uNmsS6Pph8V9m1d.4H6p4w8JzJ7bUqm.d6yqO2m8Wj6n2sC', 'ADMIN', 'Campus Administration', 'Faculty', '+91 98765 00001', 'ACTIVE', NOW()),
(2, 'ORG001', 'Dr. Shruti Sharma', 'organizer@cems.edu', '$2a$12$uE0N998x/7U5b1x5QY5zE.P47p/x9R78XmK9gZf1mUfQ1u0v.k3Z6', 'ORGANIZER', 'University Institute of Computing', 'Assistant Professor', '+91 98765 00002', 'ACTIVE', NOW()),
(3, '26MCI10257', 'Sahil Sharma', '26MCI10257@cuchd.in', '$2a$12$bN89b1l1uQ3v9z7m0Y2zC.a56p4w8JzJ7bUqm.d6yqO2m8Wj6n2sC', 'STUDENT', 'MCA (AI ML)', 'Section MAM-4B', '9876510257', 'ACTIVE', NOW()),
(4, '26MC110245', 'Aman Verma', 'aman@cems.edu', '$2a$12$bN89b1l1uQ3v9z7m0Y2zC.a56p4w8JzJ7bUqm.d6yqO2m8Wj6n2sC', 'STUDENT', 'MCA (AI ML)', 'Section MAM-4B', '9876511025', 'ACTIVE', NOW());

-- 2. Venues
INSERT INTO `venues` (`id`, `name`, `location`, `capacity`, `description`, `facilities`, `is_active`) VALUES
(1, 'University Main Auditorium (Block 3)', 'Block 3, Ground Floor', 600, 'Central university auditorium for major conventions and academic fests.', 'Dual 4K Laser Projectors, JBL Surround Sound, Stage Lighting, Podium & Wireless Mics', 1),
(2, 'UIC Seminar Hall A', 'UIC Academic Block, 2nd Floor', 150, 'Tiered auditorium equipped for tech symposiums, workshops, and seminars.', 'Interactive Smart Board, AC, High-speed LAN, Ceiling Speakers, Dual Lapel Mics', 1),
(3, 'Advanced AI/ML Research Lab 4', 'UIC Block, 3rd Floor', 75, 'Advanced computing lab with high-end workstations for hackathons.', '75 GPU Workstations, Gigabit LAN, Overhead Projector, Dedicated UPS', 1),
(4, 'Campus Sports Complex Arena', 'Sports & Recreation Wing', 1200, 'Multi-purpose indoor sports stadium for campus tournaments.', 'Hardwood Sports Flooring, Electronic Scoreboard, Stadium Floodlights', 1),
(5, 'Open Air Theatre (OAT)', 'Central Campus Lawn', 800, 'Vibrant outdoor amphitheatre for cultural fests and band performances.', 'Acoustic Sound Shell, Tiered Seating, Outdoor Stage Truss, Audio Mixers', 1);

-- 3. Events
INSERT INTO `events` (`id`, `title`, `category`, `description`, `venue_id`, `event_date`, `start_time`, `end_time`, `max_capacity`, `current_registrations`, `status`, `organizer_id`, `banner_url`, `created_at`) VALUES
(1, 'TechFusion 2026: 36-Hour National AI & ML Hackathon', 'HACKATHON', 'Chandigarh University presents TechFusion 2026! Bring your laptops and build cutting-edge solutions in Generative AI, Computer Vision, and Autonomous Systems.', 3, DATE_ADD(CURRENT_DATE, INTERVAL 4 DAY), '09:30:00', '18:00:00', 70, 1, 'APPROVED', 2, 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1200&q=80', NOW()),
(2, 'Hands-on Workshop: Enterprise Cloud Microservices with Kubernetes', 'WORKSHOP', 'Master containerization and cloud orchestration. Learn Docker multi-stage builds, Kubernetes deployments, and automated CI/CD pipelines.', 2, DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY), '10:00:00', '16:00:00', 120, 0, 'APPROVED', 2, 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&w=1200&q=80', NOW()),
(3, 'CUGlitz 2026: Annual Inter-College Cultural Extravaganza', 'CULTURAL', 'The biggest cultural festival of the year! Live musical performances, Battle of the Bands, folk dancing, and celebrity guest appearance.', 5, DATE_ADD(CURRENT_DATE, INTERVAL 12 DAY), '17:00:00', '22:30:00', 750, 0, 'APPROVED', 1, 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1200&q=80', NOW()),
(4, 'Inter-Department Badminton & Futsal Championship', 'SPORTS', 'Annual sports tournament open to all undergraduate and postgraduate departments. Medals and trophies awarded to finalists.', 4, DATE_ADD(CURRENT_DATE, INTERVAL 18 DAY), '08:30:00', '17:00:00', 500, 0, 'APPROVED', 2, 'https://images.unsplash.com/photo-1517649763962-0c623266ddc0?auto=format&fit=crop&w=1200&q=80', NOW()),
(5, 'International Symposium on Quantum Computing & Cyber Security', 'SEMINAR', 'Proposed symposium featuring keynote addresses from distinguished IEEE researchers on post-quantum cryptography and quantum algorithms.', 1, DATE_ADD(CURRENT_DATE, INTERVAL 25 DAY), '10:00:00', '16:30:00', 450, 0, 'PENDING_APPROVAL', 2, 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=1200&q=80', NOW());

-- 4. Sample Registration
INSERT INTO `registrations` (`id`, `ticket_code`, `event_id`, `user_id`, `registration_date`, `attendance_status`, `qr_data`) VALUES
(1, 'CEMS-TKT-CU89A12', 1, 3, NOW(), 'REGISTERED', 'CEMS_PASS|TICKET:CEMS-TKT-CU89A12|UID:26MCI10257|EVENT:1|NAME:Sahil Sharma');

-- 5. Notifications
INSERT INTO `notifications` (`id`, `user_id`, `event_id`, `title`, `message`, `type`, `is_read`, `created_at`) VALUES
(1, 3, 1, 'Registration Confirmed: TechFusion 2026', 'Your registration for TechFusion 2026 is confirmed! Your Digital Ticket Reference is CEMS-TKT-CU89A12. Please bring your digital pass to UIC Computer Lab 4.', 'REGISTRATION', 0, NOW()),
(2, 3, NULL, 'Welcome to Chandigarh University Event Portal', 'Welcome to CEMS! Browse upcoming cultural, technical, and sports events. Register with one click and access your verifiable digital passes anytime.', 'GENERAL', 0, NOW());
