CREATE DATABASE MovieRecommendationSystem;

USE MovieRecommendationSystem;



-- 1. USERS TABLE


CREATE TABLE USERS (

    user_id INT AUTO_INCREMENT PRIMARY KEY,

    username VARCHAR(50) NOT NULL,

    email VARCHAR(100) UNIQUE NOT NULL,

    password VARCHAR(100) NOT NULL,

    country VARCHAR(50),

    join_date DATE

);



-- 2. DIRECTORS TABLE



CREATE TABLE DIRECTORS (

    director_id INT AUTO_INCREMENT PRIMARY KEY,

    director_name VARCHAR(100) NOT NULL,

    nationality VARCHAR(50),

    birth_date DATE

);



-- 3. ACTORS TABLE



CREATE TABLE ACTORS (

    actor_id INT AUTO_INCREMENT PRIMARY KEY,

    actor_name VARCHAR(100) NOT NULL,

    gender VARCHAR(10),

    birth_date DATE,

    nationality VARCHAR(50)

);


-- 4. GENRES TABLE



CREATE TABLE GENRES (

    genre_id INT AUTO_INCREMENT PRIMARY KEY,

    genre_name VARCHAR(50) UNIQUE NOT NULL

);



-- 5. MOVIES TABLE


CREATE TABLE MOVIES (

    movie_id INT AUTO_INCREMENT PRIMARY KEY,

    title VARCHAR(150) NOT NULL,

    release_year YEAR,

    duration INT,

    language VARCHAR(50),

    description TEXT,

    director_id INT,

    FOREIGN KEY (director_id)

        REFERENCES DIRECTORS(director_id)

        ON DELETE SET NULL

        ON UPDATE CASCADE

);



-- 6. MOVIE_GENRE TABLE



CREATE TABLE MOVIE_GENRE (

    movie_id INT,

    genre_id INT,

    PRIMARY KEY (movie_id, genre_id),

    FOREIGN KEY (movie_id)

        REFERENCES MOVIES(movie_id)

        ON DELETE CASCADE

        ON UPDATE CASCADE,

    FOREIGN KEY (genre_id)

        REFERENCES GENRES(genre_id)

        ON DELETE CASCADE

        ON UPDATE CASCADE

);



-- 7. MOVIE_CAST TABLE



CREATE TABLE MOVIE_CAST (

    movie_id INT,

    actor_id INT,

    role_name VARCHAR(100),

    PRIMARY KEY (movie_id, actor_id),

    FOREIGN KEY (movie_id)

        REFERENCES MOVIES(movie_id)

        ON DELETE CASCADE

        ON UPDATE CASCADE,

    FOREIGN KEY (actor_id)

        REFERENCES ACTORS(actor_id)

        ON DELETE CASCADE

        ON UPDATE CASCADE

);



-- 8. RATINGS TABLE


CREATE TABLE RATINGS (

    rating_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT,

    movie_id INT,

    rating DECIMAL(2,1),

    rating_date DATE,

    FOREIGN KEY (user_id)

        REFERENCES USERS(user_id)

        ON DELETE CASCADE

        ON UPDATE CASCADE,

    FOREIGN KEY (movie_id)

        REFERENCES MOVIES(movie_id)

        ON DELETE CASCADE

        ON UPDATE CASCADE,

    CHECK (rating >= 1 AND rating <= 10)

);



-- 9. REVIEWS TABLE



CREATE TABLE REVIEWS (

    review_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT,

    movie_id INT,

    review_text TEXT,

    review_date DATE,

    FOREIGN KEY (user_id)

        REFERENCES USERS(user_id)

        ON DELETE CASCADE

        ON UPDATE CASCADE,

    FOREIGN KEY (movie_id)

        REFERENCES MOVIES(movie_id)

        ON DELETE CASCADE

        ON UPDATE CASCADE

);
