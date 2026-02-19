SELECT * FROM `bikers-487700.rides.rides` LIMIT 1000

SELECT * FROM `bikers-487700.rides.stations` LIMIT 1000

SELECT * FROM `bikers-487700.rides.users` LIMIT 1000

--- get count of rows per table
SELECT
  (SELECT COUNT(*) FROM bikers-487700.rides.rides) AS total_rides,
  (SELECT COUNT(*) FROM bikers-487700.rides.stations) AS total_stations,
  (SELECT COUNT(*) FROM bikers-487700.rides.users) AS total_users

-- missing values
SELECT
  COUNTIF(ride_id IS NULL) AS null_ride_ids,
  COUNTIF(user_id IS NULL) AS null_user_ids,
  COUNTIF(start_time IS NULL) AS null_start_time,
  COUNTIF(end_time IS NULL) AS null_end_time
FROM bikers-487700.rides.rides;

-- Summary statistics for the rides table
SELECT
  MIN(distance_km) AS min_dist,
  MAX(distance_km) AS max_dist,
  AVG(distance_km) AS avg_dist,
  MIN(TIMESTAMP_DIFF(end_time,start_time,MINUTE)) AS min_duration_mins,
  MAX(TIMESTAMP_DIFF(end_time,start_time,MINUTE)) AS max_duration_mins,
  AVG(TIMESTAMP_DIFF(end_time,start_time,MINUTE)) AS avg_duration_mins
FROM bikers-487700.rides.rides;

-- Checking for false starts for the rides
SELECT
  COUNTIF(TIMESTAMP_DIFF(end_time,start_time,MINUTE)<2) AS short_duration_trips,
  COUNTIF(distance_km=0) AS zero_distance_trips

FROM bikers-487700.rides.rides;

-- Different memberships
SELECT
  u.membership_level,
  COUNT(r.ride_id) AS total_rides,
  AVG(r.distance_km) AS avergae_distance_km,
  AVG(TIMESTAMP_DIFF(r.end_time,r.start_time,MINUTE)) AS avg_duration_mins
FROM bikers-487700.rides.rides AS r
JOIN `bikers-487700.rides.users` AS u
  ON r.user_id=u.user_id
GROUP BY u.membership_level
ORDER BY total_rides DESC

-- Peak Hours
SELECT 

  EXTRACT(HOUR FROM start_time) AS hour_of_day,
  COUNT(*) AS ride_count
FROM bikers-487700.rides.rides AS r
GROUP BY hour_of_day
ORDER BY 1

-- Check for popular stations
SELECT
  s.station_name,
  COUNT(r.ride_id) AS total_starts

FROM bikers-487700.rides.rides AS r
JOIN `bikers-487700.rides.stations` AS s
  ON r.start_station_id=s.station_id
GROUP BY s.station_name
ORDER BY total_starts DESC
LIMIT 10;

-- Categorizing rides into Short, Medium, Long
SELECT
    CASE
      WHEN TIMESTAMP_DIFF(end_time,start_time,MINUTE) <=10 THEN 'Short(<10m)'
      WHEN TIMESTAMP_DIFF(end_time,start_time,MINUTE) BETWEEN 11 AND 30 THEN 'Medium(11-30m)'
      ELSE 'Long(>30m)'
    END AS ride_category,
    COUNT(*) AS count_of_rides
FROM bikers-487700.rides.rides
GROUP BY ride_category
ORDER BY count_of_rides DESC;

-- Net flow of bikes for each station

WITH departures AS (

  SELECT start_station_id, COUNT(*) AS total_departures
  FROM bikers-487700.rides.rides
  GROUP BY 1
),

arrivals AS (

  SELECT end_station_id, COUNT(*) AS total_arrivals
  FROM bikers-487700.rides.rides
  GROUP BY 1
)

SELECT
    s.station_name,
    d.total_departures,
    a.total_arrivals,
    (a.total_arrivals - d.total_departures) AS net_flow

FROM bikers-487700.rides.stations AS s
JOIN departures d  ON
s.station_id=d.start_station_id
JOIN arrivals a  ON
s.station_id=a.end_station_id
ORDER BY net_flow ASC;

-- User Retention


WITH monthly_signups AS (

SELECT 
  DATE_TRUNC(created_at, MONTH) AS signup_month,
  COUNT(user_id) AS new_user_count
FROM `bikers-487700.rides.users`
GROUP BY signup_month
)

SELECT 
  signup_month,
  new_user_count,
  LAG(new_user_count) OVER(ORDER BY signup_month) AS previous_month_count,

  (new_user_count -LAG(new_user_count)OVER (ORDER BY signup_month))/
  NULLIF(LAG(new_user_count) OVER (ORDER BY signup_month),0)*100 AS mom_growth
FROM monthly_signups
ORDER BY signup_month;
