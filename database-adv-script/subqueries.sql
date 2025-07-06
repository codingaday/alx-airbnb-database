-- Find Properties with Average Rating > 4.0 (Using a Subquery)
SELECT
    P.property_id,
    P.name,
    P.location,
    P.pricepernight
FROM Property AS P
WHERE
    (
        SELECT AVG(R.rating)
        FROM Review AS R
        WHERE R.property_id = P.property_id
    ) > 4.0;


    -- Find Users with More Than 3 Bookings (Using a Correlated Subquery)

    SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    U.email
FROM User AS U
WHERE
    (
        SELECT COUNT(*)
        FROM Booking AS B
        WHERE B.user_id = U.user_id
    ) > 3;