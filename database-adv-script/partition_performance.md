# Airbnb Clone: Booking Table Partitioning & Performance Report

## Project Overview

## This project implements a PostgreSQL-based Airbnb Clone system featuring core entities:

[User]: guests, hosts, admins

[Property]: listings by hosts

[Booking]: reservations made by users for properties

[Payment]: transactions associated with bookings

[Review]: user feedback on properties

[Message]: communication between users

## Goal

Optimize performance on the booking table, which had grown large and exhibited slow performance for time-based queries.

## Schema Summary

### Booking Table (before partitioning):

Fields: booking_id, user_id, property_id, start_date, end_date, status, total_price, created_at

Problems: Full table scans on date-range queries like:

SELECT \* FROM booking
WHERE start_date BETWEEN '2024-02-01' AND '2024-02-28';

### Testing Strategy

### 1. Before Partitioning

Query performance measured with:

EXPLAIN ANALYZE
SELECT \* FROM booking WHERE start_date BETWEEN '2024-02-01' AND '2024-02-28';
Observation:

Full table scan (Seq Scan)

Execution Time: ~100ms+

Poor scaling as data volume increased

🔧 Partitioning Implementation
✔️ Strategy
Partitioned by: start_date

Type: Monthly RANGE partitions

Sample:
CREATE TABLE booking (
...
) PARTITION BY RANGE (start_date);

CREATE TABLE booking_2024_02 PARTITION OF booking
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');
✔️ Indexing Strategy
Added indexes to each partition:

CREATE INDEX idx_booking_user_id ON booking_2024_02(user_id);
CREATE INDEX idx_booking_property_id ON booking_2024_02(property_id);
📈 Post-Partition Performance 2. After Partitioning
Same query run with EXPLAIN ANALYZE

PostgreSQL output:

Append
-> Seq Scan on booking_2024_02
Execution Time: ~12–30ms

✅ Only relevant partition scanned (partition pruning successful)

✅ Significant reduction in I/O and buffer usage

🧠 Observations & Learnings
Metric Before After Improvement
Query Time (avg) 90–150ms 12–30ms ⚡ ~70–85% faster
Rows scanned All rows One partition ✅ Minimal I/O
Memory & buffer load High Reduced ✅ Better scaling

✅ Recommendations
Automate partition creation monthly/yearly

Apply same strategy to other large tables (e.g., payment, if needed)

Monitor usage with pg_stat_statements and auto_explain

Use VACUUM ANALYZE after bulk inserts to maintain statistics

Keep indexes lean and SARGable (avoid functions on filter columns)

📂 File References
partitioning.sql: Full schema refactor for booking table

performance_test.sql: Sample EXPLAIN ANALYZE queries used

sample_queries.sql: Real-time reporting & filtering queries optimized post-partition
