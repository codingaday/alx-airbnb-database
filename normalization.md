# Database Normalization Report

## Objective

Ensure the database design adheres to Third Normal Form (3NF) to eliminate redundancy and maintain data integrity.

---

## 1. First Normal Form (1NF)

- All attributes contain atomic values.
- Each entity has a primary key.
- ✔️ 1NF achieved.

---

## 2. Second Normal Form (2NF)

- The schema is in 1NF.
- All non-key attributes are fully functionally dependent on the entire primary key.
- No composite keys exist, so no partial dependencies.
- ✔️ 2NF achieved.

---

## 3. Third Normal Form (3NF)

- The schema is in 2NF.
- No transitive dependencies exist; all non-key attributes depend only on the primary key.
- Optional improvements:

  - **User Roles:** Could be normalized into a `Role` table instead of ENUM.
  - **Property Location:** Could be normalized into a `Location` table for structured addresses.
  - **Booking Total Price:** Storing a derived value is acceptable for performance.

- ✔️ 3NF achieved.

---

## Final Design

| Table        | Notes                                                    |
| ------------ | -------------------------------------------------------- |
| **User**     | Satisfies 3NF. ENUM `role` acceptable for static values. |
| **Property** | Satisfies 3NF. `location` normalization optional.        |
| **Booking**  | Satisfies 3NF. `total_price` stored for performance.     |
| **Payment**  | Satisfies 3NF.                                           |
| **Review**   | Satisfies 3NF.                                           |
| **Message**  | Satisfies 3NF.                                           |

---

## Conclusion

The database schema is fully normalized to 3NF and ready for implementation.  
Optional normalizations can be applied based on scalability and reporting needs.
