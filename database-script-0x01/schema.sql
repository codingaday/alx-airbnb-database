-- ================================================================
-- DATABASE SCHEMA DEFINITION (DDL) FOR MS SQL SERVER
-- Project: Airbnb Clone
-- Author: Abebe Duguma
-- Date: 06/07/2025
-- Objective: Avoid multiple cascade paths and enforce data integrity
-- ================================================================

-- ================================================================
-- 1. User Table
-- ================================================================

CREATE TABLE [User] (
    user_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

ALTER TABLE [User]
ADD CONSTRAINT chk_user_role CHECK (role IN ('guest', 'host', 'admin'));

CREATE INDEX idx_user_email ON [User](email);

-- ================================================================
-- 2. Property Table
-- ================================================================

CREATE TABLE [Property] (
    property_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    host_id UNIQUEIDENTIFIER NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_property_host
        FOREIGN KEY (host_id) REFERENCES [User](user_id)
        ON DELETE CASCADE
);

CREATE INDEX idx_property_host_id ON [Property](host_id);
CREATE INDEX idx_property_location ON [Property](location);

-- ================================================================
-- 3. Booking Table
-- ================================================================

CREATE TABLE [Booking] (
    booking_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    property_id UNIQUEIDENTIFIER NOT NULL,
    user_id UNIQUEIDENTIFIER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_booking_property
        FOREIGN KEY (property_id) REFERENCES [Property](property_id)
        ON DELETE CASCADE,

    -- Avoid cascade here to prevent multiple cascade paths
    CONSTRAINT fk_booking_user
        FOREIGN KEY (user_id) REFERENCES [User](user_id)
        ON DELETE NO ACTION
);

ALTER TABLE [Booking]
ADD CONSTRAINT chk_booking_status CHECK (status IN ('pending', 'confirmed', 'canceled'));

CREATE INDEX idx_booking_property_id ON [Booking](property_id);
CREATE INDEX idx_booking_user_id ON [Booking](user_id);
CREATE INDEX idx_booking_status ON [Booking](status);

-- ================================================================
-- 4. Payment Table
-- ================================================================

CREATE TABLE [Payment] (
    payment_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    booking_id UNIQUEIDENTIFIER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_method VARCHAR(20) NOT NULL,

    CONSTRAINT fk_payment_booking
        FOREIGN KEY (booking_id) REFERENCES [Booking](booking_id)
        ON DELETE CASCADE
);

ALTER TABLE [Payment]
ADD CONSTRAINT chk_payment_method CHECK (payment_method IN ('credit_card', 'paypal', 'stripe'));

CREATE INDEX idx_payment_booking_id ON [Payment](booking_id);

-- ================================================================
-- 5. Review Table
-- ================================================================

CREATE TABLE [Review] (
    review_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    property_id UNIQUEIDENTIFIER NOT NULL,
    user_id UNIQUEIDENTIFIER NOT NULL,
    rating INT NOT NULL,
    comment TEXT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_review_property
        FOREIGN KEY (property_id) REFERENCES [Property](property_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id) REFERENCES [User](user_id)
        ON DELETE NO ACTION  -- To prevent multiple cascade paths
);

ALTER TABLE [Review]
ADD CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5);

CREATE INDEX idx_review_property_id ON [Review](property_id);
CREATE INDEX idx_review_user_id ON [Review](user_id);

-- ================================================================
-- 6. Message Table
-- ================================================================

CREATE TABLE [Message] (
    message_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    sender_id UNIQUEIDENTIFIER NOT NULL,
    recipient_id UNIQUEIDENTIFIER NOT NULL,
    message_body TEXT NOT NULL,
    sent_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_message_sender
        FOREIGN KEY (sender_id) REFERENCES [User](user_id)
        ON DELETE NO ACTION, -- Avoid cascade

    CONSTRAINT fk_message_recipient
        FOREIGN KEY (recipient_id) REFERENCES [User](user_id)
        ON DELETE NO ACTION
);

CREATE INDEX idx_message_sender_id ON [Message](sender_id);
CREATE INDEX idx_message_recipient_id ON [Message](recipient_id);

-- ================================================================
-- END OF SCHEMA
-- ================================================================
