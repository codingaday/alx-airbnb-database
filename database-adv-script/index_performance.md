# Implement Indexes for Optimization

## High-usage Columns

✅ User Table – High-Usage Columns
user_id

- Used in JOINs with Booking, Review, Message
- Also used in WHERE clauses

email

- Used in login, searches, lookups
- Often appears in WHERE clauses

role

- Used to filter users by type (guest, host, admin)
- Appears in WHERE

first_name, last_name

- Used for display or alphabetical ordering
- May appear in ORDER BY or simple filters

created_at

- Used to sort or filter users by registration date
- Common in ORDER BY and WHERE

Recommended indexes:

Primary key on user_id

Index on email, role, and maybe created_at if filtered often

✅ Booking Table – High-Usage Columns
booking_id

- Used as primary key
- Often used in WHERE and JOIN

user_id

- Links bookings to users
- Common in WHERE and JOIN

property_id

- Links bookings to properties
- Used in JOINs and GROUP BY for analytics

start_date, end_date

- Used in availability searches
- Appear in WHERE and ORDER BY

status

- Used to filter by booking status (confirmed, pending, canceled)
- Common in WHERE

created_at

- Used to get most recent bookings
- Appears in ORDER BY or reporting filters

Recommended indexes:

Primary key on booking_id

Composite index on (user_id, property_id)

Index on status and created_at

✅ Property Table – High-Usage Columns
property_id

- Primary key
- Used in JOINs with Booking, Review

host_id

- Used to fetch properties owned by a user
- Appears in WHERE and JOIN

location

- Used in location-based filtering
- Appears in WHERE

pricepernight

- Used in range filtering or sorting
- Appears in WHERE and ORDER BY

name

- Can be used in search or alphabetical sorting
- Appears in WHERE or ORDER BY

created_at

- Used to get recent listings
- Appears in ORDER BY

Recommended indexes:

Primary key on property_id

Index on host_id, location, and optionally pricepernight
