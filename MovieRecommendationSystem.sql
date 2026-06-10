-- ============================================================
-- Movie Recommendation and Rating Management System
-- Database Systems Project | Spring 2026
-- University of Lahore, Department of CS & IT
-- Members: Saeed Ahmad, Muhammad Ali, Muhammad Ismail Rafique
-- ============================================================

CREATE DATABASE IF NOT EXISTS MovieRecommendationSystem;
USE MovieRecommendationSystem;

-- ============================================================
-- DDL: CREATE TABLES
-- ============================================================

-- 1. USERS TABLE
CREATE TABLE USERS (
    user_id   INT AUTO_INCREMENT PRIMARY KEY,
    username  VARCHAR(50)  NOT NULL,
    email     VARCHAR(100) UNIQUE NOT NULL,
    password  VARCHAR(100) NOT NULL,
    country   VARCHAR(50),
    join_date DATE
);

-- 2. DIRECTORS TABLE
CREATE TABLE DIRECTORS (
    director_id   INT AUTO_INCREMENT PRIMARY KEY,
    director_name VARCHAR(100) NOT NULL,
    nationality   VARCHAR(50),
    birth_date    DATE
);

-- 3. ACTORS TABLE
CREATE TABLE ACTORS (
    actor_id    INT AUTO_INCREMENT PRIMARY KEY,
    actor_name  VARCHAR(100) NOT NULL,
    gender      VARCHAR(10),
    birth_date  DATE,
    nationality VARCHAR(50)
);

-- 4. GENRES TABLE
CREATE TABLE GENRES (
    genre_id   INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(50) UNIQUE NOT NULL
);

-- 5. MOVIES TABLE
CREATE TABLE MOVIES (
    movie_id     INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(150) NOT NULL,
    release_year YEAR,
    duration     INT,
    language     VARCHAR(50),
    description  TEXT,
    director_id  INT,
    FOREIGN KEY (director_id) REFERENCES DIRECTORS(director_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 6. MOVIE_GENRE TABLE (junction: many-to-many Movies <-> Genres)
CREATE TABLE MOVIE_GENRE (
    movie_id INT,
    genre_id INT,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES MOVIES(movie_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES GENRES(genre_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. MOVIE_CAST TABLE (junction: many-to-many Movies <-> Actors)
CREATE TABLE MOVIE_CAST (
    movie_id  INT,
    actor_id  INT,
    role_name VARCHAR(100),
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES MOVIES(movie_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES ACTORS(actor_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. RATINGS TABLE
CREATE TABLE RATINGS (
    rating_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT,
    movie_id    INT,
    rating      DECIMAL(2,1),
    rating_date DATE,
    FOREIGN KEY (user_id)  REFERENCES USERS(user_id)  ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES MOVIES(movie_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (rating >= 1 AND rating <= 10)
);

-- 9. REVIEWS TABLE
CREATE TABLE REVIEWS (
    review_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT,
    movie_id    INT,
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (user_id)  REFERENCES USERS(user_id)  ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES MOVIES(movie_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- NEW TABLE 10: WATCHLIST (Feature 9)
-- Users can save movies they want to watch later
-- ============================================================
CREATE TABLE WATCHLIST (
    watchlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT NOT NULL,
    movie_id     INT NOT NULL,
    added_date   DATE,
    status       ENUM('Want to Watch', 'Watching', 'Watched') DEFAULT 'Want to Watch',
    UNIQUE KEY unique_user_movie (user_id, movie_id),
    FOREIGN KEY (user_id)  REFERENCES USERS(user_id)  ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES MOVIES(movie_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- NEW TABLE 11: AWARDS (Feature 10)
-- Track movie awards and nominations
-- ============================================================
CREATE TABLE AWARDS (
    award_id     INT AUTO_INCREMENT PRIMARY KEY,
    movie_id     INT NOT NULL,
    award_name   VARCHAR(150) NOT NULL,
    category     VARCHAR(100),
    award_year   YEAR,
    result       ENUM('Won', 'Nominated') NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES MOVIES(movie_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- DML: INSERT SAMPLE DATA
-- ============================================================

INSERT INTO USERS (username, email, password, country, join_date) VALUES
('ali_raza',     'ali@example.com',    'pass123', 'Pakistan', '2023-01-15'),
('sara_khan',    'sara@example.com',   'pass456', 'Pakistan', '2023-03-22'),
('john_doe',     'john@example.com',   'pass789', 'USA',      '2023-06-10'),
('emily_watson', 'emily@example.com',  'passabc', 'UK',       '2024-01-05'),
('carlos_m',     'carlos@example.com', 'passxyz', 'Spain',    '2024-02-18');

INSERT INTO DIRECTORS (director_name, nationality, birth_date) VALUES
('Christopher Nolan', 'British',   '1970-07-30'),
('Steven Spielberg',  'American',  '1946-12-18'),
('Quentin Tarantino', 'American',  '1963-03-27'),
('Denis Villeneuve',  'Canadian',  '1967-10-03'),
('Bong Joon-ho',      'Korean',    '1969-09-14');

INSERT INTO ACTORS (actor_name, gender, birth_date, nationality) VALUES
('Leonardo DiCaprio', 'Male',   '1974-11-11', 'American'),
('Cillian Murphy',    'Male',   '1976-05-25', 'Irish'),
('Zendaya',           'Female', '1996-09-01', 'American'),
('Margot Robbie',     'Female', '1990-07-02', 'Australian'),
('Tom Hanks',         'Male',   '1956-07-09', 'American');

INSERT INTO GENRES (genre_name) VALUES
('Action'), ('Drama'), ('Science Fiction'), ('Thriller'), ('Comedy'),
('Horror'), ('Romance'), ('Animation'), ('Documentary'), ('Crime');

INSERT INTO MOVIES (title, release_year, duration, language, description, director_id) VALUES
('Inception',        2010, 148, 'English', 'A thief who steals corporate secrets through dream-sharing technology.',        1),
('Interstellar',     2014, 169, 'English', 'Astronauts travel through a wormhole near Saturn to find a new home.',          1),
('Oppenheimer',      2023, 180, 'English', 'The story of J. Robert Oppenheimer and the Manhattan Project.',                 1),
('Schindlers List',  1993, 195, 'English', 'Businessman saves Polish Jews during the Holocaust.',                           2),
('Pulp Fiction',     1994, 154, 'English', 'Interconnected stories of crime, violence, and redemption in Los Angeles.',     3),
('Dune',             2021, 155, 'English', 'Paul Atreides leads nomadic tribes in a battle for the desert planet Arrakis.', 4),
('Parasite',         2019, 132, 'Korean',  'A poor family schemes to become employed by a wealthy family.',                 5);

INSERT INTO MOVIE_GENRE (movie_id, genre_id) VALUES
(1,3),(1,4),(1,1), -- Inception: Sci-Fi, Thriller, Action
(2,3),(2,2),       -- Interstellar: Sci-Fi, Drama
(3,2),(3,4),       -- Oppenheimer: Drama, Thriller
(4,2),             -- Schindler's List: Drama
(5,10),(5,4),      -- Pulp Fiction: Crime, Thriller
(6,3),(6,1),       -- Dune: Sci-Fi, Action
(7,2),(7,10);      -- Parasite: Drama, Crime

INSERT INTO MOVIE_CAST (movie_id, actor_id, role_name) VALUES
(1, 1, 'Dom Cobb'),
(2, 1, 'Cooper'),
(3, 2, 'J. Robert Oppenheimer'),
(6, 3, 'Chani'),
(5, 4, 'Honey Bunny'),
(4, 5, 'Oskar Schindler');

INSERT INTO RATINGS (user_id, movie_id, rating, rating_date) VALUES
(1, 1, 9.0, '2024-01-10'),
(1, 2, 8.5, '2024-01-15'),
(2, 1, 8.0, '2024-02-05'),
(2, 3, 9.5, '2024-03-01'),
(3, 5, 9.0, '2024-01-20'),
(3, 7, 9.5, '2024-02-10'),
(4, 6, 8.0, '2024-03-15'),
(5, 3, 8.5, '2024-04-01');

INSERT INTO REVIEWS (user_id, movie_id, review_text, review_date) VALUES
(1, 1, 'A mind-bending masterpiece! The concept of dreams within dreams was brilliantly executed.', '2024-01-11'),
(2, 3, 'Incredible performances and stunning visuals. Nolan at his absolute best.', '2024-03-02'),
(3, 7, 'Parasite deserves every award it received. A true cinematic experience.', '2024-02-11'),
(4, 6, 'Dune is visually spectacular. Denis Villeneuve has created an epic universe.', '2024-03-16');

-- Feature 9: Watchlist sample data
INSERT INTO WATCHLIST (user_id, movie_id, added_date, status) VALUES
(1, 5, '2024-04-01', 'Want to Watch'),
(1, 7, '2024-04-02', 'Watched'),
(2, 2, '2024-03-10', 'Watching'),
(3, 3, '2024-01-25', 'Want to Watch'),
(4, 1, '2024-02-20', 'Watched'),
(5, 6, '2024-04-05', 'Want to Watch');

-- Feature 10: Awards sample data
INSERT INTO AWARDS (movie_id, award_name, category, award_year, result) VALUES
(3, 'Academy Awards', 'Best Picture',       2024, 'Won'),
(3, 'Academy Awards', 'Best Director',      2024, 'Won'),
(3, 'Academy Awards', 'Best Actor',         2024, 'Won'),
(7, 'Academy Awards', 'Best Picture',       2020, 'Won'),
(7, 'Academy Awards', 'Best Director',      2020, 'Won'),
(4, 'Academy Awards', 'Best Picture',       1994, 'Won'),
(1, 'Academy Awards', 'Best Cinematography',2011, 'Nominated'),
(2, 'Academy Awards', 'Best Visual Effects',2015, 'Won'),
(5, 'Cannes Film Festival', 'Palme dOr',   1994, 'Won'),
(6, 'Academy Awards', 'Best Visual Effects',2022, 'Won');

-- ============================================================
-- DCL: ACCESS CONTROL
-- ============================================================

-- Create a read-only analyst role
CREATE USER IF NOT EXISTS 'movie_analyst'@'localhost' IDENTIFIED BY 'analyst_pass';
GRANT SELECT ON MovieRecommendationSystem.* TO 'movie_analyst'@'localhost';

-- Create an app user with DML access
CREATE USER IF NOT EXISTS 'movie_app'@'localhost' IDENTIFIED BY 'app_pass';
GRANT SELECT, INSERT, UPDATE, DELETE ON MovieRecommendationSystem.* TO 'movie_app'@'localhost';

FLUSH PRIVILEGES;

-- ============================================================
-- FEATURE 1: View Movie Details
-- Full details of a movie including director and genres
-- ============================================================
SELECT
    m.movie_id,
    m.title,
    m.release_year,
    m.duration,
    m.language,
    m.description,
    d.director_name,
    GROUP_CONCAT(g.genre_name ORDER BY g.genre_name SEPARATOR ', ') AS genres
FROM MOVIES m
LEFT JOIN DIRECTORS d ON m.director_id = d.director_id
LEFT JOIN MOVIE_GENRE mg ON m.movie_id = mg.movie_id
LEFT JOIN GENRES g ON mg.genre_id = g.genre_id
GROUP BY m.movie_id, m.title, m.release_year, m.duration, m.language, m.description, d.director_name;

-- ============================================================
-- FEATURE 2: Rate a Movie (INSERT + UPDATE)
-- ============================================================

-- Add a new rating
INSERT INTO RATINGS (user_id, movie_id, rating, rating_date)
VALUES (5, 1, 8.0, CURDATE());

-- Update an existing rating
UPDATE RATINGS
SET rating = 9.5, rating_date = CURDATE()
WHERE user_id = 5 AND movie_id = 1;

-- ============================================================
-- FEATURE 3: Write / Update / Delete a Review
-- ============================================================

-- Write a review
INSERT INTO REVIEWS (user_id, movie_id, review_text, review_date)
VALUES (5, 2, 'A visually stunning journey through space and time. Absolutely loved it!', CURDATE());

-- Update a review
UPDATE REVIEWS
SET review_text = 'Interstellar is a masterpiece of science fiction cinema.'
WHERE user_id = 5 AND movie_id = 2;

-- Delete a review
DELETE FROM REVIEWS
WHERE user_id = 5 AND movie_id = 2;

-- ============================================================
-- FEATURE 4: Search Movies by Genre or Director
-- ============================================================

-- Search by genre name
SELECT m.title, m.release_year, d.director_name
FROM MOVIES m
JOIN DIRECTORS d    ON m.director_id = d.director_id
JOIN MOVIE_GENRE mg ON m.movie_id = mg.movie_id
JOIN GENRES g       ON mg.genre_id = g.genre_id
WHERE g.genre_name = 'Science Fiction';

-- Search by director name
SELECT m.title, m.release_year, m.duration
FROM MOVIES m
JOIN DIRECTORS d ON m.director_id = d.director_id
WHERE d.director_name LIKE '%Nolan%';

-- ============================================================
-- FEATURE 5: View Actor Filmography
-- ============================================================
SELECT
    a.actor_name,
    m.title,
    m.release_year,
    mc.role_name
FROM ACTORS a
JOIN MOVIE_CAST mc ON a.actor_id = mc.actor_id
JOIN MOVIES m      ON mc.movie_id = m.movie_id
WHERE a.actor_name = 'Leonardo DiCaprio'
ORDER BY m.release_year;

-- ============================================================
-- FEATURE 6: Identify Top-Rated Movies
-- ============================================================
SELECT
    m.title,
    m.release_year,
    d.director_name,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.rating_id)      AS total_ratings
FROM MOVIES m
JOIN RATINGS r   ON m.movie_id = r.movie_id
JOIN DIRECTORS d ON m.director_id = d.director_id
GROUP BY m.movie_id, m.title, m.release_year, d.director_name
HAVING COUNT(r.rating_id) >= 1
ORDER BY avg_rating DESC
LIMIT 5;

-- ============================================================
-- FEATURE 7: Analyze Popular Genres
-- ============================================================
SELECT
    g.genre_name,
    COUNT(DISTINCT mg.movie_id) AS total_movies,
    ROUND(AVG(r.rating), 2)     AS avg_genre_rating
FROM GENRES g
JOIN MOVIE_GENRE mg ON g.genre_id = mg.genre_id
LEFT JOIN RATINGS r ON mg.movie_id = r.movie_id
GROUP BY g.genre_id, g.genre_name
ORDER BY avg_genre_rating DESC;

-- ============================================================
-- FEATURE 8: Generate Movie Recommendations Based on Ratings
-- Recommend movies a user has NOT rated, based on genres
-- they have rated highly (>= 8)
-- ============================================================
SELECT DISTINCT
    m.title,
    m.release_year,
    d.director_name,
    g.genre_name
FROM MOVIES m
JOIN DIRECTORS d    ON m.director_id = d.director_id
JOIN MOVIE_GENRE mg ON m.movie_id = mg.movie_id
JOIN GENRES g       ON mg.genre_id = g.genre_id
WHERE g.genre_id IN (
    -- Genres the user likes (rated >= 8)
    SELECT DISTINCT mg2.genre_id
    FROM RATINGS r2
    JOIN MOVIE_GENRE mg2 ON r2.movie_id = mg2.movie_id
    WHERE r2.user_id = 1 AND r2.rating >= 8
)
AND m.movie_id NOT IN (
    -- Movies the user has already rated
    SELECT movie_id FROM RATINGS WHERE user_id = 1
)
ORDER BY m.release_year DESC;

-- ============================================================
-- FEATURE 9: Watchlist Management
-- Add, update, and view a user's personal watchlist
-- ============================================================

-- Add a movie to watchlist
INSERT INTO WATCHLIST (user_id, movie_id, added_date, status)
VALUES (2, 5, CURDATE(), 'Want to Watch');

-- Update watchlist status (mark as watched)
UPDATE WATCHLIST
SET status = 'Watched'
WHERE user_id = 2 AND movie_id = 5;

-- View a user's full watchlist with movie details
SELECT
    w.status,
    m.title,
    m.release_year,
    d.director_name,
    w.added_date
FROM WATCHLIST w
JOIN MOVIES m    ON w.movie_id = m.movie_id
JOIN DIRECTORS d ON m.director_id = d.director_id
WHERE w.user_id = 1
ORDER BY FIELD(w.status, 'Watching', 'Want to Watch', 'Watched');

-- Remove a movie from watchlist
DELETE FROM WATCHLIST
WHERE user_id = 2 AND movie_id = 5;

-- ============================================================
-- FEATURE 10: Track Movie Awards and Nominations
-- View awards, filter by result, and find most awarded movies
-- ============================================================

-- View all awards for a specific movie
SELECT
    m.title,
    a.award_name,
    a.category,
    a.award_year,
    a.result
FROM AWARDS a
JOIN MOVIES m ON a.movie_id = m.movie_id
WHERE m.title = 'Oppenheimer'
ORDER BY a.award_year;

-- Find most awarded movies
SELECT
    m.title,
    COUNT(a.award_id)                             AS total_nominations,
    SUM(CASE WHEN a.result = 'Won' THEN 1 ELSE 0 END) AS total_wins
FROM MOVIES m
JOIN AWARDS a ON m.movie_id = a.movie_id
GROUP BY m.movie_id, m.title
ORDER BY total_wins DESC;

-- Add an award record
INSERT INTO AWARDS (movie_id, award_name, category, award_year, result)
VALUES (1, 'BAFTA', 'Best Original Screenplay', 2011, 'Nominated');

-- Delete an incorrect award entry
DELETE FROM AWARDS
WHERE movie_id = 1 AND award_name = 'BAFTA' AND category = 'Best Original Screenplay';

-- ============================================================
-- END OF SCRIPT
-- ============================================================
