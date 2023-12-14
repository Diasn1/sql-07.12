CREATE TABLE passengers (
    passenger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE trips (
    trip_id SERIAL PRIMARY KEY,
    passenger_id INT REFERENCES passengers(passenger_id),
    driver_id INT REFERENCES drivers(driver_id),
    start_location VARCHAR(255) NOT NULL,
    end_location VARCHAR(255) NOT NULL,
    fare DECIMAL(10, 2) NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    trip_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION create_trip(
    IN p_passenger_id INT,
    IN p_driver_id INT,
    IN p_start_location VARCHAR(255),
    IN p_end_location VARCHAR(255),
    IN p_fare DECIMAL(10, 2),
    IN p_rating INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO trips (passenger_id, driver_id, start_location, end_location, fare, rating)
    VALUES (p_passenger_id, p_driver_id, p_start_location, p_end_location, p_fare, p_rating);
END;
$$ LANGUAGE plpgsql;

SELECT
    driver_id,
    SUM(fare) AS total_earnings
FROM
    trips
WHERE
    trip_date >= CURRENT_DATE - INTERVAL '1 day' -- За день
GROUP BY
    driver_id;

SELECT
    driver_id,
    SUM(fare) AS total_earnings
FROM
    trips
WHERE
    trip_date >= CURRENT_DATE - INTERVAL '1 week' -- За неделю
GROUP BY
    driver_id;

SELECT
    driver_id,
    SUM(fare) AS total_earnings
FROM
    trips
WHERE
    EXTRACT(MONTH FROM trip_date) = EXTRACT(MONTH FROM CURRENT_DATE) -- За месяц
GROUP BY
    driver_id;

SELECT
    driver_id,
    SUM(fare) AS total_earnings
FROM
    trips -- За все время
GROUP BY
    driver_id;

SELECT
    driver_id,
    AVG(rating) AS average_rating
FROM
    trips
GROUP BY
    driver_id;
