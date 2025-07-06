# Performance Improvements Made

1. Only one LEFT JOIN
   [Payment] is joined with LEFT JOIN because some bookings may not be paid yet.
   All others are INNER JOIN — this is faster and more precise.

2. Avoid SELECT \*
   Explicitly selecting only the needed fields improves execution plan quality and memory usage.

3. Avoid unnecessary operations
   No DISTINCT, no GROUP BY, no subqueries — all of which slow things down if not needed.

4. Ordering
   Ensure you only use ORDER BY when needed for front-end pagination or reports. Otherwise, remove it.
