
-- Implement Indexes for Optimization 

-- Indexes for User Table

-- Index to speed up login and lookup by email
CREATE INDEX idx_user_email ON User(email);

-- Index for filtering by role (guest, host, admin)
CREATE INDEX idx_user_role ON User(role);

-- Index for queries ordered or filtered by creation date
CREATE INDEX idx_user_created_at ON User(created_at);




-- Indexes for Booking Table

-- Index to quickly get bookings by user
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index to get all bookings for a property
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Composite index for common JOIN or analytics queries
CREATE INDEX idx_booking_user_property ON Booking(user_id, property_id);

-- Index for filtering bookings by status
CREATE INDEX idx_booking_status ON Booking(status);

-- Index for ordering or filtering by creation date
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- Index for date-based queries (e.g., availability search)
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);




-- Indexes for Property Table

-- Index to quickly find all properties owned by a specific host
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index to enable location-based search
CREATE INDEX idx_property_location ON Property(location);

-- Index to support price range filters and sorting
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Index to support recent listing queries
CREATE INDEX idx_property_created_at ON Property(created_at);





--Step-by-Step: Measure Query Performance Using EXPLAIN ANALYZE (PostgreSQL)

-- Let's say you want to analyze this query:


SELECT 
    b.booking_id,
    u.first_name,
    u.last_name,
    b.status
FROM 
    booking b
JOIN 
    "user" u ON b.user_id = u.user_id
WHERE 
    b.status = 'confirmed';

 -- 1. Run It with EXPLAIN ANALYZE (Before Index)

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.first_name,
    u.last_name,
    b.status
FROM 
    booking b
JOIN 
    "user" u ON b.user_id = u.user_id
WHERE 
    b.status = 'confirmed';



-- 2. Interpret the Output
--It'll look something like this:

Nested Loop  (cost=0.56..420.89 rows=10 width=64)
  -> Index Scan using user_pkey on "user" u  (cost=0.28..8.29 ...)
  -> Seq Scan on booking b  (cost=0.28..420.89 ...)
     Filter: (status = 'confirmed')
...
Planning Time: 0.300 ms
Execution Time: 12.551 ms




-- 3. Add Index (if needed)
CREATE INDEX idx_booking_status ON booking(status);
CREATE INDEX idx_booking_user_id ON booking(user_id);



-- 4. Rerun the Same Query With EXPLAIN ANALYZE

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.first_name,
    u.last_name,
    b.status
FROM 
    booking b
JOIN 
    "user" u ON b.user_id = u.user_id
WHERE 
    b.status = 'confirmed';
Now you'll likely see something like this:


Nested Loop  (cost=0.56..120.22 rows=10 width=64)
  -> Index Scan using idx_booking_status on booking b  (cost=0.28..20.22 ...)
     Index Cond: (status = 'confirmed')
  -> Index Scan using user_pkey on "user" u ...
...
Execution Time: 3.228 ms




-- 5. Performance Comparison

| Metric         | Before Index | After Index |
| -------------- | ------------ | ----------- |
| Scan type      | Seq Scan     | Index Scan  |
| Execution Time | 12.551 ms    | 3.228 ms    |
| Planning Time  | 0.3 ms       | 0.2 ms      |
| Logical Reads  | High         | Low         |
