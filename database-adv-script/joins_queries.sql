-- INNER JOIN Booking with User.

SELECT
    B.booking_id,
    B.property_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status,
    B.created_at AS booking_created_at,
    
    U.user_id,
    U.first_name,
    U.last_name,
    U.email,
    U.phone_number,
    U.role,
    U.created_at AS user_created_at
FROM Booking AS B
INNER JOIN
    User AS U ON B.user_id = U.user_id;

-- Query: All Properties and Their Reviews (Even If None)


SELECT
    P.property_id,
    P.name AS property_name,
    P.description,
    P.location,
    P.pricepernight,
    P.created_at AS property_created_at,

    R.review_id,
    R.user_id AS reviewer_id,
    R.rating,
    R.comment,
    R.created_at AS review_created_at
FROM Property AS P
LEFT JOIN Review AS R ON P.property_id = R.property_id
ORDER BY
    P.name, R.created_at;
  
-- SQL Server Query: All Users + All Bookings (Fully Joined)

SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    U.email,
    U.role,
    U.created_at AS user_created_at,

    B.booking_id,
    B.property_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status,
    B.created_at AS booking_created_at
FROM User AS U
FULL OUTER JOIN Booking AS B ON U.user_id = B.user_id
ORDER BY
    U.user_id, B.booking_id;
