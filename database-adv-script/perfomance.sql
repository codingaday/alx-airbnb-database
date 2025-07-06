
-- Initial query that retrieves all bookings along with the user details, property details, and payment details
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    b.total_price AS booking_total,

    u.user_id,
    u.first_name,
    u.last_name,
    u.email,

    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,

    pay.payment_id,
    pay.amount,
    pay.payment_method,
    pay.payment_date

FROM booking b
JOIN "user" u ON b.user_id = u.user_id
JOIN property p ON b.property_id = p.property_id
LEFT JOIN payment pay ON b.booking_id = pay.booking_id

WHERE b.status = 'confirmed'
    AND p.location = 'Addis Ababa'

ORDER BY b.start_date DESC;




-- Step 2: Analyze Key Sections of the Output
--Sample Output Breakdown:
--You might get something like:


Sort  (cost=10500.00..10501.00 rows=500 width=200) 
  Sort Key: b.start_date DESC
  -> Hash Left Join
     Hash Cond: (b.booking_id = pay.booking_id)
     -> Hash Join
        Hash Cond: (b.property_id = p.property_id)
        -> Hash Join
           Hash Cond: (b.user_id = u.user_id)
           -> Seq Scan on booking b
           -> Seq Scan on "user" u
        -> Seq Scan on property p
     -> Seq Scan on payment pay
...
Execution Time: 85.257 ms



--Identifying Inefficiencies
--🚨 1. Seq Scan on large tables (bad sign)
--If the plan shows:


-- -> Seq Scan on booking b
--That means PostgreSQL is scanning the entire table.

--Why it happens: There's no usable index on user_id, property_id, or booking_id.

✅ Fix it:


CREATE INDEX idx_booking_user_id ON booking(user_id);
CREATE INDEX idx_booking_property_id ON booking(property_id);
CREATE INDEX idx_booking_id ON booking(booking_id); -- For LEFT JOIN
Also:


CREATE INDEX idx_payment_booking_id ON payment(booking_id);



--  2. Sort step taking time

Sort  (cost=... rows=... width=...) 
Sort Key: b.start_date DESC
If Sort is expensive, add an index:


CREATE INDEX idx_booking_start_date_desc ON booking(start_date DESC);
This helps PostgreSQL avoid expensive in-memory sorts for large datasets.

--  3. Hash Join vs Nested Loop vs Merge Join
Hash Join is good for large sets, but if data is small and joins are predictable, a Nested Loop might be faster.

-- Make sure you're analyzing cardinality:

-- Does estimated rows match actual rows?

-- If not, your planner stats might be out of date → ANALYZE booking;




| Symptom                   | Fix                              |
| ------------------------- | -------------------------------- |
| Seq Scan on joined tables | Add indexes on joined columns    |
| Expensive Sort            | Index the ORDER BY column(s)     |
| High Execution Time       | Update planner stats (`ANALYZE`) |
| Poor row estimates        | Run `VACUUM ANALYZE` regularly   |



-- Refactored SQL Server Query for Performance

SELECT 
    B.booking_id,
    B.start_date,
    B.end_date,
    B.status,
    B.total_price AS booking_total,

    U.user_id,
    U.first_name,
    U.last_name,
    U.email,

    P.property_id,
    P.name AS property_name,
    P.location,
    P.pricepernight,

    PAY.payment_id,
    PAY.amount,
    PAY.payment_method,
    PAY.payment_date

FROM 
    Booking AS B

-- INNER JOINs (essential relationships)
INNER JOIN 
    User AS U ON B.user_id = U.user_id

INNER JOIN 
    Property AS P ON B.property_id = P.property_id

-- LEFT JOIN (optional; booking might not have a payment yet)
LEFT JOIN 
    Payment AS PAY ON B.booking_id = PAY.booking_id

-- Optional: Filter to reduce rows processed
-- WHERE B.status = 'confirmed'

ORDER BY 
    B.start_date DESC;



--Essential Indexes (SQL Server Version)
--Make sure the following indexes exist for peak performance:

-- Booking Table
CREATE NONCLUSTERED INDEX idx_booking_user_id ON [Booking](user_id);
CREATE NONCLUSTERED INDEX idx_booking_property_id ON [Booking](property_id);
CREATE NONCLUSTERED INDEX idx_booking_start_date_desc ON [Booking](start_date DESC);

-- User Table
CREATE NONCLUSTERED INDEX idx_user_id ON [User](user_id);

-- Property Table
CREATE NONCLUSTERED INDEX idx_property_id ON [Property](property_id);

-- Payment Table
CREATE NONCLUSTERED INDEX idx_payment_booking_id ON [Payment](booking_id);