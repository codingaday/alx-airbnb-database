
---

## ✅ `seed.sql`


-- ================================================================
-- Booking Platform - Seed Data Script
-- ms SQL Server

-- ================================================================
-- 1. Users
-- ================================================================

INSERT INTO [User] (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES
(NEWID(), 'John', 'Doe', 'john@example.com', 'hashed_pw_123', '1234567890', 'guest', GETDATE()),
(NEWID(), 'Alice', 'Smith', 'alice@example.com', 'hashed_pw_234', '0987654321', 'host', GETDATE()),
(NEWID(), 'Micheal', 'Brown', 'mikeb@example.com', 'hashed_pw_345', NULL, 'guest', GETDATE()),
(NEWID(), 'Sophia', 'Johnson', 'sophiaj@example.com', 'hashed_pw_456', '1112223333', 'admin', GETDATE()),
(NEWID(), 'David', 'Lee', 'davidlee@example.com', 'hashed_pw_567', '2223334444', 'host', GETDATE());


-- ================================================================
-- 2. Properties
-- ================================================================

-- Replace 'host_id' with actual host IDs from above if running this directly
INSERT INTO [Property] (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
VALUES
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'alice@example.com'), 'Cozy Cottage', 'A small cozy place in the woods.', 'Colorado', 100.00, GETDATE(), GETDATE()),
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'davidlee@example.com'), 'Modern Apartment', 'Stylish apartment downtown.', 'New York', 150.00, GETDATE(), GETDATE()),
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'davidlee@example.com'), 'Beach House', 'Right next to the ocean.', 'California', 200.00, GETDATE(), GETDATE()),
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'alice@example.com'), 'Mountain Cabin', 'Getaway in the Rockies.', 'Colorado', 120.00, GETDATE(), GETDATE()),
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'alice@example.com'), 'City Loft', 'Loft in the heart of the city.', 'Chicago', 130.00, GETDATE(), GETDATE());


-- ================================================================
-- 3. Bookings
-- ================================================================

-- Replace property_id and user_id with actual values using SELECTs
INSERT INTO [Booking] (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at)
VALUES
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'Cozy Cottage'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'john@example.com'), '2025-08-01', '2025-08-05', 400.00, 'confirmed', GETDATE()),
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'Modern Apartment'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'mikeb@example.com'), '2025-09-01', '2025-09-03', 300.00, 'pending', GETDATE()),
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'Beach House'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'john@example.com'), '2025-10-10', '2025-10-15', 1000.00, 'confirmed', GETDATE()),
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'Mountain Cabin'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'mikeb@example.com'), '2025-11-01', '2025-11-05', 480.00, 'canceled', GETDATE()),
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'City Loft'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'john@example.com'), '2025-12-20', '2025-12-25', 650.00, 'confirmed', GETDATE());


-- ================================================================
-- 4. Payments
-- ================================================================

-- Replace booking_id with actual IDs if not using SELECT
INSERT INTO [Payment] (payment_id, booking_id, amount, payment_date, payment_method)
VALUES
(NEWID(), (SELECT TOP 1 booking_id FROM [Booking] WHERE total_price = 400.00), 400.00, GETDATE(), 'credit_card'),
(NEWID(), (SELECT TOP 1 booking_id FROM [Booking] WHERE total_price = 300.00), 300.00, GETDATE(), 'paypal'),
(NEWID(), (SELECT TOP 1 booking_id FROM [Booking] WHERE total_price = 1000.00), 1000.00, GETDATE(), 'stripe'),
(NEWID(), (SELECT TOP 1 booking_id FROM [Booking] WHERE total_price = 480.00), 480.00, GETDATE(), 'credit_card'),
(NEWID(), (SELECT TOP 1 booking_id FROM [Booking] WHERE total_price = 650.00), 650.00, GETDATE(), 'paypal');


-- ================================================================
-- 5. Reviews
-- ================================================================

-- Replace user_id and property_id with actual values
INSERT INTO [Review] (review_id, property_id, user_id, rating, comment, created_at)
VALUES
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'Cozy Cottage'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'john@example.com'), 5, 'Wonderful stay!', GETDATE()),
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'Modern Apartment'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'mikeb@example.com'), 4, 'Very clean and modern.', GETDATE()),
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'Beach House'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'john@example.com'), 5, 'Amazing ocean view.', GETDATE()),
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'Mountain Cabin'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'mikeb@example.com'), 3, 'Rustic but comfy.', GETDATE()),
(NEWID(), (SELECT TOP 1 property_id FROM [Property] WHERE name = 'City Loft'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'john@example.com'), 4, 'Great location!', GETDATE());

-- ================================================================
-- 6. Messages
-- ================================================================

-- sender and recipient from User table
INSERT INTO [Message] (message_id, sender_id, recipient_id, message_body, sent_at)
VALUES
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'john@example.com'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'alice@example.com'), 'Hi Alice, is the property available?', GETDATE()),
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'alice@example.com'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'john@example.com'), 'Yes, it is available.', GETDATE()),
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'mikeb@example.com'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'davidlee@example.com'), 'Can I extend my stay?', GETDATE()),
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'davidlee@example.com'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'mikeb@example.com'), 'Sure, let me check.', GETDATE()),
(NEWID(), (SELECT TOP 1 user_id FROM [User] WHERE email = 'sophiaj@example.com'), (SELECT TOP 1 user_id FROM [User] WHERE email = 'alice@example.com'), 'Admin here. Please verify your listing.', GETDATE());

-- ================================================================
-- End of Seed Script
-- ================================================================
