# 📚 AirBnb Clone Project

## ✅ Overview

This project defines the database schema for a booking platform that connects **guests**, **hosts**, and **properties**. It ensures data integrity, eliminates redundancy, and supports essential features such as bookings, payments, reviews, and messaging.

The database is normalized to **Third Normal Form (3NF)** to remove data redundancy and maintain consistency.

---

## 📌 Files Included

| File               | Description                                                        |
| ------------------ | ------------------------------------------------------------------ |
| `NORMALIZATION.md` | Explanation of normalization steps and how 3NF is achieved.        |
| `schema.sql`       | SQL `CREATE TABLE` statements with keys, constraints, and indexes. |
| `README.md`        | Project overview and setup instructions.                           |

---

## 🗄️ Entities & Relationships

**Entities:**

- **User:** Basic user information and roles.
- **Property:** Listings linked to a host.
- **Booking:** Reservations made by guests.
- **Payment:** Payments for bookings.
- **Review:** User reviews for properties.
- **Message:** Communication between users.

**Relationships:**

- Users (hosts) list properties.
- Users (guests) book properties.
- Bookings have payments.
- Guests can review properties.
- Users can message each other.

---

## ⚙️ Schema Highlights

✅ **UUID Primary Keys** (uses `uuid-ossp` extension)  
✅ **Foreign Keys with `ON DELETE CASCADE`**  
✅ **CHECK constraints for roles, statuses, payment methods**  
✅ **Indexes** on frequently queried columns for performance.
