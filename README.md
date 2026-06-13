# Movie Recommendation & Rating Management System

A relational database management system (RDBMS) built to manage movie metadata, user profiles, ratings, text reviews, watchlists, and movie awards.

**Course:** Database Systems (Spring 2026)  
**Institution:** University of Lahore, Department of CS & IT  
**Instructor:** Ms. Ambreen Akmal  

---

## 🗺️ Database Structure
The database is normalized to **3NF** and contains **11 tables**:
* `USERS`, `MOVIES`, `DIRECTORS`, `ACTORS`, `GENRES`
* `MOVIE_GENRE`, `MOVIE_CAST` (Junction Tables)
* `RATINGS`, `REVIEWS`, `WATCHLIST`, `AWARDS`

---

## ⚡ Core Features & Automation
* **Data Constraints:** Uses `CHECK` constraints to lock movie ratings between `1.0` and `10.0`.
* **Data Integrity:** Employs `ON DELETE CASCADE` to prevent orphaned rows when records are deleted.
* **Recommendation Engine:** Uses correlated subqueries to suggest top-rated unseen movies to users based on their favorite genres.
* **Performance Trigger:** Features an `AFTER INSERT` trigger (`update_movie_stats_after_insert`) that automatically updates a movie's average score and total rating count in real time.

---

## 🔒 Access Control (Security)
* **`movie_app`**: Read/Write access (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) for application use.
* **`movie_analyst`**: Read-Only access (`SELECT`) for safe business reporting.

---

## 🚀 Quick Setup

1. Clone this repository to your local machine.
2. Run the main script file in your MySQL environment:
   ```sql
   SOURCE MovieRecommendationSystem final version.sql;
