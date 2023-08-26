-- Create a new table to store the results
CREATE TABLE Total_rides_count (
    member_casual VARCHAR(10),
    ride_count INT
);

-- Insert the results into the new table
INSERT INTO Total_rides_count (member_casual, ride_count)
SELECT
    member_casual,
    COUNT(ride_id) AS ride_count
FROM tripdata
GROUP BY member_casual;

SELECT
    member_casual,
    MAX(TIMESTAMPDIFF(MINUTE, CONCAT(started_Date, ' ', Started_Time), CONCAT(ending_date, ' ', Ending_Time))) AS max_ride_duration_minutes
FROM capst_1.tripdata
GROUP BY member_casual;




-- Calculate the average ride duration for annual members and casual riders
SELECT
    member_casual,
    AVG(TIME_TO_SEC(TIMEDIFF(CONCAT(ending_date, ' ', Ending_Time), CONCAT(started_Date, ' ', Started_Time)))) / 60.0 AS avg_ride_duration_minutes
FROM capst_1.tripdata
GROUP BY member_casual;




-- Find the most common start stations for both members
CREATE TABLE startstations (
    start_station_name VARCHAR(255),
    ride_count INT,
    user_type VARCHAR(10)
);

-- Insert the top 5 results of the first query into the new table
INSERT INTO startstations (start_station_name, ride_count, user_type)
SELECT
    start_station_name,
    COUNT(*) AS ride_count,
    'member' AS user_type
FROM capst_1.tripdata
WHERE member_casual = 'member'
GROUP BY start_station_name
ORDER BY ride_count DESC
LIMIT 5;

-- Insert the top 5 results of the second query into the new table
INSERT INTO startstations(start_station_name, ride_count, user_type)
SELECT
    start_station_name,
    COUNT(*) AS ride_count,
    'casual' AS user_type
FROM capst_1.tripdata
WHERE member_casual = 'casual'
GROUP BY start_station_name
ORDER BY ride_count DESC
LIMIT 5;



-- Find the most common end stations for both members
CREATE TABLE endstations (
    end_station_name VARCHAR(255),
    ride_count INT,
    user_type VARCHAR(10)
);

-- Insert the top 5 results of the first query into the new table
INSERT INTO endstations (end_station_name, ride_count, user_type)
SELECT
    end_station_name,
    COUNT(*) AS ride_count,
    'member' AS user_type
FROM capst_1.tripdata
WHERE member_casual = 'member'
GROUP BY end_station_name
ORDER BY ride_count DESC
LIMIT 5;

-- Insert the top 5 results of the second query into the new table
INSERT INTO endstations(end_station_name, ride_count, user_type)
SELECT
    end_station_name,
    COUNT(*) AS ride_count,
    'casual' AS user_type
FROM capst_1.tripdata
WHERE member_casual = 'casual'
GROUP BY end_station_name
ORDER BY ride_count DESC
LIMIT 5;



-- Total Ride Counts each day
CREATE TABLE ride_counts_by_day (
    day_name VARCHAR(20),
    member_casual VARCHAR(10),
    ride_count INT
);

-- Insert the results for member rides into the new table
INSERT INTO ride_counts_by_day (day_name, member_casual, ride_count)
SELECT
    DAYNAME(started_Date) AS day_name,
    member_casual,
    COUNT(*) AS ride_count
FROM capst_1.tripdata
WHERE member_casual = 'member' AND WEEKDAY(started_Date) BETWEEN 0 AND 6
GROUP BY day_name, member_casual;

-- Insert the results for casual rides into the new table
INSERT INTO ride_counts_by_day (day_name, member_casual, ride_count)
SELECT
    DAYNAME(started_Date) AS day_name,
    member_casual,
    COUNT(*) AS ride_count
FROM capst_1.tripdata
WHERE member_casual = 'casual' AND WEEKDAY(started_Date) BETWEEN 0 AND 6
GROUP BY day_name, member_casual;






-- Create a new table to store the combined results on weekdays
CREATE TABLE Weekdays_peak (
    user_type VARCHAR(10),
    hours VARCHAR(2),
    ride_count INT
);

-- Insert the results for annual members into the new table
INSERT INTO Weekdays_peak (user_type, hours, ride_count)
SELECT
    'member' AS user_type,
    DATE_FORMAT(CONCAT(started_Date, ' ', Started_Time), '%H') AS hours,
    COUNT(*) AS ride_count
FROM capst_1.tripdata
WHERE member_casual = 'member' AND WEEKDAY(started_Date) BETWEEN 0 AND 4
GROUP BY user_type, hours
ORDER BY user_type, ride_count DESC, hours
LIMIT 5;

-- Insert the results for casual users into the new table
INSERT INTO Weekdays_peak (user_type, hours, ride_count)
SELECT
    'casual' AS user_type,
    DATE_FORMAT(CONCAT(started_Date, ' ', Started_Time), '%H') AS hours,
    COUNT(*) AS ride_count
FROM capst_1.tripdata
WHERE member_casual = 'casual' AND WEEKDAY(started_Date) BETWEEN 0 AND 4
GROUP BY user_type, hours
ORDER BY user_type, ride_count DESC, hours
LIMIT 5;




-- Create a new table to store the combined results on weekend
CREATE TABLE Weekend_peak (
    user_type VARCHAR(10),
    hours VARCHAR(2),
    ride_count INT
);

-- Insert the results for annual members into the new table
INSERT INTO Weekend_peak (user_type, hours, ride_count)
SELECT
    'member' AS user_type,
    DATE_FORMAT(CONCAT(started_Date, ' ', Started_Time), '%H') AS hours,
    COUNT(*) AS ride_count
FROM capst_1.tripdata
WHERE member_casual = 'member' AND WEEKDAY(started_Date) BETWEEN 5 AND 6
GROUP BY user_type, hours
ORDER BY user_type, ride_count DESC, hours
LIMIT 5;

-- Insert the results for casual users into the new table
INSERT INTO Weekend_peak (user_type, hours, ride_count)
SELECT
    'casual' AS user_type,
    DATE_FORMAT(CONCAT(started_Date, ' ', Started_Time), '%H') AS hours,
    COUNT(*) AS ride_count
FROM capst_1.tripdata
WHERE member_casual = 'casual' AND WEEKDAY(started_Date) BETWEEN 5 AND 6
GROUP BY user_type, hours
ORDER BY user_type, ride_count DESC, hours
LIMIT 5;


