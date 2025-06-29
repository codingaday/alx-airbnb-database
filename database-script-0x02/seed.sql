
---

## ✅ `seed.sql`


-- ================================================================
-- Booking Platform - Seed Data Script
-- PostgreSQL
-- ================================================================

-- Enable UUID extension if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================================================
-- 1. Users
-- ================================================================

INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
    (uuid_generate_v4(), 'Alice', 'Smith', 'alice@example.com', 'hashed_password_1', '1234567890', 'guest'),
    (uuid_generate_v4(), 'Bob', 'Johnson', 'bob@example.com', 'hashed_password_2', '0987654321', 'host'),
    (uuid_generate_v4(), 'Admin', 'User', 'admin@example.com', 'hashed_password_3', NULL, 'admin');

-- Fetch user IDs for reference
-- SELECT user_id, first_name FROM "User";

-- For demonstration, using hardcoded UUIDs for clarity
-- Replace these with your actual UUIDs if needed

-- Assume:
--  Guest: '11111111-1111-1111-1111-111111111111'
--  Host:  '22222222-2222-2222-2222-222222222222'

-- ================================================================
-- 2. Properties
-- ================================================================

INSERT INTO "Property" (property_id, host_id, name, description, location, pricepernight)
VALUES
    (
        uuid_generate_v4(),
        (SELECT user_id FROM "User" WHERE email = 'bob@example.com'),
        'Cozy Cottage',
        'A cozy cottage in the countryside.',
        'Countryside, USA',
        120.00
    ),
    (
        uuid_generate_v4(),
        (SELECT user_id FROM "User" WHERE email = 'bob@example.com'),
        'Downtown Apartment',
        'Modern apartment in the heart of the city.',
        'City Center, USA',
        200.00
    );

-- SELECT property_id, name FROM "Property";

-- ================================================================
-- 3. Bookings
-- ================================================================

INSERT INTO "Booking" (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
    (
        uuid_generate_v4(),
        (SELECT property_id FROM "Property" WHERE name = 'Cozy Cottage'),
        (SELECT user_id FROM "User" WHERE email = 'alice@example.com'),
        '2025-07-01',
        '2025-07-05',
        480.00,
        'confirmed'
    ),
    (
        uuid_generate_v4(),
        (SELECT property_id FROM "Property" WHERE name = 'Downtown Apartment'),
        (SELECT user_id FROM "User" WHERE email = 'alice@example.com'),
        '2025-07-10',
        '2025-07-12',
        400.00,
        'pending'
    );

-- ================================================================
-- 4. Payments
-- ================================================================

INSERT INTO "Payment" (payment_id, booking_id, amount, payment_method)
VALUES
    (
        uuid_generate_v4(),
        (SELECT booking_id FROM "Booking" WHERE total_price = 480.00),
        480.00,
        'credit_card'
    ),
    (
        uuid_generate_v4(),
        (SELECT booking_id FROM "Booking" WHERE total_price = 400.00),
        400.00,
        'paypal'
    );

-- ================================================================
-- 5. Reviews
-- ================================================================

INSERT INTO "Review" (review_id, property_id, user_id, rating, comment)
VALUES
    (
        uuid_generate_v4(),
        (SELECT property_id FROM "Property" WHERE name = 'Cozy Cottage'),
        (SELECT user_id FROM "User" WHERE email = 'alice@example.com'),
        5,
        'Amazing stay! Highly recommend.'
    ),
    (
        uuid_generate_v4(),
        (SELECT property_id FROM "Property" WHERE name = 'Downtown Apartment'),
        (SELECT user_id FROM "User" WHERE email = 'alice@example.com'),
        4,
        'Great location but a bit noisy at night.'
    );

-- ================================================================
-- 6. Messages
-- ================================================================

INSERT INTO "Message" (message_id, sender_id, recipient_id, message_body)
VALUES
    (
        uuid_generate_v4(),
        (SELECT user_id FROM "User" WHERE email = 'alice@example.com'),
        (SELECT user_id FROM "User" WHERE email = 'bob@example.com'),
        'Hi Bob, is the Cozy Cottage available for early check-in?'
    ),
    (
        uuid_generate_v4(),
        (SELECT user_id FROM "User" WHERE email = 'bob@example.com'),
        (SELECT user_id FROM "User" WHERE email = 'alice@example.com'),
        'Hi Alice, yes you can check in early at 12 PM!'
    );

-- ================================================================
-- End of Seed Script
-- ================================================================
