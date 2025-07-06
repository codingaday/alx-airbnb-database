# 🏡 Airbnb Clone – SQL Server Edition

This project is a simplified database schema for an **Airbnb-clone booking platform**, using **Microsoft SQL Server**. It models core features such as user management, property listings, bookings, payments, reviews, and messaging.

## 📦 Features

- Normalized schema with clear relationships
- Covers essential entities: Users, Properties, Bookings, Payments, Reviews, and Messages
- Includes data integrity constraints, foreign keys, and indexes
- Sample data provided for testing

## 🗃️ Tables & Relationships

- **User**: Guests, Hosts, Admins
- **Property**: Listings created by Hosts
- **Booking**: Reservations made by Users for Properties
- **Payment**: Payments tied to Bookings
- **Review**: Feedback left by Users for Properties
- **Message**: Communication between Users

## ⚙️ Setup

1. Open SQL Server Management Studio (SSMS)
2. Run `schema.sql` to create all tables and constraints
3. Run `sample_data.sql` to insert mock data
4. Use provided queries to explore and test the schema

## 🧪 Sample Queries

-- Get all bookings and the users who made them:

```sql
SELECT * FROM [User] U
INNER JOIN [Booking] B ON U.user_id = B.user_id;


-- Get all properties and their reviews (even if no reviews):
``sql
SELECT * FROM [Property] P
LEFT JOIN [Review] R ON P.property_id = R.property_id;


-- Get all users and bookings (even unmatched ones):
``sql
SELECT * FROM [User] U
FULL OUTER JOIN [Booking] B ON U.user_id = B.user_id;
```
