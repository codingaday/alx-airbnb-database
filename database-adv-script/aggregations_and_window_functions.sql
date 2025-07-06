-- Total Number of Bookings Per User (Using COUNT + GROUP BY)

SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    COUNT(B.booking_id) AS total_bookings
FROM User AS U
LEFT JOIN Booking AS B ON U.user_id = B.user_id
GROUP BY
    U.user_id, U.first_name, U.last_name
ORDER BY
    total_bookings DESC;

  -- Full Query with RANK() and ROW_NUMBER()

  SELECT
    P.property_id,
    P.name AS property_name,
    COUNT(B.booking_id) AS total_bookings,

    RANK() OVER (
        ORDER BY COUNT(B.booking_id) DESC
    ) AS booking_rank,

    ROW_NUMBER() OVER (
        ORDER BY COUNT(B.booking_id) DESC
    ) AS booking_row_number

FROM
    Property AS P
LEFT JOIN
    Booking AS B ON P.property_id = B.property_id
GROUP BY
    P.property_id, P.name
ORDER BY
    booking_rank;
