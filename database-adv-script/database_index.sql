
-- Implement Indexes for Optimization 

-- Indexes for User Table

-- Index to speed up login and lookup by email
CREATE NONCLUSTERED INDEX idx_user_email ON User(email);

-- Index for filtering by role (guest, host, admin)
CREATE NONCLUSTERED INDEX idx_user_role ON User(role);

-- Index for queries ordered or filtered by creation date
CREATE NONCLUSTERED INDEX idx_user_created_at ON User(created_at);




-- Indexes for Booking Table

-- Index to quickly get bookings by user
CREATE NONCLUSTERED INDEX idx_booking_user_id ON Booking(user_id);

-- Index to get all bookings for a property
CREATE NONCLUSTERED INDEX idx_booking_property_id ON Booking(property_id);

-- Composite index for common JOIN or analytics queries
CREATE NONCLUSTERED INDEX idx_booking_user_property ON Booking(user_id, property_id);

-- Index for filtering bookings by status
CREATE NONCLUSTERED INDEX idx_booking_status ON Booking(status);

-- Index for ordering or filtering by creation date
CREATE NONCLUSTERED INDEX idx_booking_created_at ON Booking(created_at);

-- Index for date-based queries (e.g., availability search)
CREATE NONCLUSTERED INDEX idx_booking_dates ON Booking(start_date, end_date);




-- Indexes for Property Table

-- Index to quickly find all properties owned by a specific host
CREATE NONCLUSTERED INDEX idx_property_host_id ON Property(host_id);

-- Index to enable location-based search
CREATE NONCLUSTERED INDEX idx_property_location ON Property(location);

-- Index to support price range filters and sorting
CREATE NONCLUSTERED INDEX idx_property_price ON Property(pricepernight);

-- Index to support recent listing queries
CREATE NONCLUSTERED INDEX idx_property_created_at ON Property(created_at);