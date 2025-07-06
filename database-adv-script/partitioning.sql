-- ===============================
-- Description: Partitioning the Booking table by start_date (monthly partitions)
-- Assumes PostgreSQL 11+ for declarative partitioning
-- ===============================

-- 1. Rename the original table (if it exists)
ALTER TABLE booking RENAME TO booking_old;

-- 2. Create new partitioned parent table
CREATE TABLE booking (
    booking_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    property_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'canceled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (start_date);

-- 3. Create monthly partitions for 2024 (example: you can automate this)
CREATE TABLE booking_2024_01 PARTITION OF booking
    FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE booking_2024_02 PARTITION OF booking
    FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE booking_2024_03 PARTITION OF booking
    FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

-- Add more as needed...

-- 4. (Optional) Add foreign keys and indexes to child partitions
-- Note: PostgreSQL does not support FK constraints on partitioned tables directly,
-- so you must handle integrity through triggers or application logic.

-- Example: Add index on user_id for one partition
CREATE INDEX idx_booking_2024_01_user_id ON booking_2024_01(user_id);
CREATE INDEX idx_booking_2024_02_user_id ON booking_2024_02(user_id);
CREATE INDEX idx_booking_2024_03_user_id ON booking_2024_03(user_id);


-- Step-by-Step: Performance Testing on Partitioned Table


-- 1. Query to Test (e.g., Get February 2024 Bookings)

EXPLAIN ANALYZE
SELECT *
FROM booking
WHERE start_date BETWEEN '2024-02-01' AND '2024-02-28';


-- 2. What You're Looking for in the Output
-- good output:

Append  (cost=0.00..10.50 rows=50 width=...)
  -> Seq Scan on booking_2024_02 ...
Planning Time: 0.123 ms
Execution Time: 1.523 ms


--Only booking_2024_02 is scanned (partition pruning works).

-- Bad output:

Seq Scan on booking_2024_01 ...
Seq Scan on booking_2024_02 ...
Seq Scan on booking_2024_03 ...


 -- 3. Insert Data & Re-test
--If you don't yet have a big dataset, try inserting test data:

-- Insert into partition
INSERT INTO booking (
    booking_id, user_id, property_id, start_date, end_date, total_price, status
)
SELECT 
    gen_random_uuid(),
    gen_random_uuid(),
    gen_random_uuid(),
    d::date,
    d::date + interval '3 days',
    500.00,
    'confirmed'
FROM generate_series('2024-01-01'::date, '2024-03-31'::date, '1 day') d;

-- Then rerun the test query to compare performance for:

-- Full table scan (SELECT * FROM booking)

-- Range-based filter (WHERE start_date BETWEEN ...)


-- 4. Compare Execution Times
| Query Type                        | Execution Time (Pre-Partition) | Execution Time (Post-Partition)  |
| --------------------------------- | ------------------------------ | -------------------------------- |
| Full scan (no WHERE)              | High                           | Still high (touches all parts)   |
| Filtered by start\_date (1 month) | Moderate/Slow                  | ⚡️ Fast (only one partition hit) |
| Filtered by status only           | No benefit from partitioning   | Still full scan unless indexed   |
