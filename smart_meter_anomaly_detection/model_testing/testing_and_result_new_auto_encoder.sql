create temp table auto_old_flagged_anomalies as
select * from anomalies_auto_encoder_testing;


-- labeled as normal by Isolation forest
CREATE TEMP TABLE control_unseen AS
SELECT ml.*
FROM ml_unknown_control_sample_unseen_raw ml
LEFT JOIN auto_old_flagged_anomalies ol
  ON ml.reading_id = ol.reading_id
WHERE ol.reading_id IS NULL;


CREATE TEMP TABLE stratum_thresholds AS
SELECT
  acorn_group,
  EXTRACT(HOUR FROM date_time) AS hour_of_day,
  PERCENTILE_CONT(0.01) WITHIN GROUP (ORDER BY hourly_mean_reading) AS p01,
  PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY hourly_mean_reading) AS p99
FROM control_unseen
GROUP BY acorn_group, EXTRACT(HOUR FROM date_time);

-- synthetic anomalies
CREATE TEMP TABLE synthetic_anomalies (
  date_time          timestamp,
  acorn_group        text,
  std_or_tou            text,
  holiday            text,
  hourly_mean_reading double precision,
  weather            text,
  is_synthetic       boolean
);


-- insert 100 synthetic anomalies. Drop at 19:00
-- 3b) Extreme drops at evening peak (19:00) regardless of weather
INSERT INTO synthetic_anomalies
SELECT
  cu.date_time,
  cu.acorn_group,
  cu.std_or_tou,
  cu.holiday,
  st.p01 * 0.05 AS hourly_mean_reading,  -- basically near absolute minimum
  cu.weather,
  TRUE
FROM control_unseen cu
JOIN stratum_thresholds st
  ON cu.acorn_group = st.acorn_group
 AND EXTRACT(HOUR FROM cu.date_time) = st.hour_of_day
WHERE EXTRACT(HOUR FROM cu.date_time) = 19
ORDER BY random()
LIMIT 1000;

-- Extreme spikes per acorn + hour: 5 times 99th  percentile
INSERT INTO synthetic_anomalies
SELECT
  cu.date_time,
  cu.acorn_group,
  cu.std_or_tou,
  cu.holiday,
  st.p99 * 5.0 AS hourly_mean_reading,
  cu.weather,
  TRUE
FROM control_unseen cu
JOIN stratum_thresholds st
  ON cu.acorn_group = st.acorn_group
 AND EXTRACT(HOUR FROM cu.date_time) = st.hour_of_day
ORDER BY random()
LIMIT 1500;



-- Acorn‐group low‐usage synthetic anomalies
INSERT INTO synthetic_anomalies
SELECT
  date_time,
  acorn_group,
  std_or_tou,
  holiday,
  hourly_mean_reading * 0.05 AS hourly_mean_reading,  -- 70% drop
  weather,
  TRUE
FROM control_unseen
WHERE acorn_group IN (
    'Low Income Living',
    'Steadfast Communities'
  )
ORDER BY random()
LIMIT 1000;

-- Acorn group high usage synthetic anomalies 

INSERT INTO synthetic_anomalies
SELECT
  date_time,
  acorn_group,
  std_or_tou,
  holiday,
  hourly_mean_reading * 5.0  AS hourly_mean_reading,  -- 5X increase
  weather,
  TRUE
FROM control_unseen
WHERE acorn_group IN (
    'Luxury Lifestyles',
    'Thriving Neighbourhoods'
  )
ORDER BY random()
LIMIT 1000;


-- Summer heat spikes synthetic anomalies

INSERT INTO synthetic_anomalies
SELECT
  cu.date_time,
  cu.acorn_group,
  cu.std_or_tou,
  cu.holiday,
  st.p99 * 8.0 AS hourly_mean_reading,
  cu.weather,
  TRUE
FROM control_unseen cu
JOIN stratum_thresholds st
  ON cu.acorn_group = st.acorn_group
 AND EXTRACT(HOUR FROM cu.date_time) = st.hour_of_day
WHERE cu.weather = 'Hot'
  AND EXTRACT(MONTH FROM cu.date_time) IN (6,7,8)
ORDER BY random()
LIMIT 1500;

-- off-hours spikes synthetic anomalies

INSERT INTO synthetic_anomalies
SELECT
  date_time,
  acorn_group,
  std_or_tou,
  holiday,
  hourly_mean_reading * 8.0  AS hourly_mean_reading,  -- x8 increase
  weather,
  TRUE
FROM control_unseen
WHERE EXTRACT(HOUR FROM date_time) IN (3, 14)
ORDER BY random()
LIMIT 1300;


-- total synthetic anomalies 7300 0.054 of the full dataset.

/*
-- checks the max reading id so that i can have synthetic reading_id's for the test data
select  max(reading_id) from control_unseen;
-- output
-- 640110359
*/


-- combine synthetic anomalies with real data:
CREATE TABLE test_with_synthetic_new_auto AS
SELECT
  reading_id,
  date_time,
  std_or_tou,
  acorn_group,
  holiday,
  hourly_mean_reading,
  weather,
  FALSE AS is_synthetic
FROM control_unseen

UNION ALL

SELECT
  640110359 + ROW_NUMBER() OVER (ORDER BY date_time, acorn_group) AS reading_id,
  date_time,
  std_or_tou,
  acorn_group,
  holiday,
  hourly_mean_reading,
  weather,
  TRUE
FROM synthetic_anomalies;



CREATE or replace VIEW synthetic_anomalies_unseen_raw_new_auto AS
SELECT 
    date_time,

    -- Binary encoding for std_or_tou
    CASE WHEN std_or_tou = 'Std' THEN 0 ELSE 1 END AS std_or_tou,

    -- One-Hot Encoding for acorn_group
    CASE WHEN acorn_group = 'Established Affluence'   THEN 1 ELSE 0 END AS acorn_group_affluence,
    CASE WHEN acorn_group = 'Steadfast Communities'  THEN 1 ELSE 0 END AS acorn_group_steadfast,
    CASE WHEN acorn_group = 'Thriving Neighbourhoods' THEN 1 ELSE 0 END AS acorn_group_thriving,
    CASE WHEN acorn_group = 'Stretched Society'       THEN 1 ELSE 0 END AS acorn_group_stretched,
    -- dropped Low Income Living as dummy trap
    CASE WHEN acorn_group = 'Luxury Lifestyles'       THEN 1 ELSE 0 END AS acorn_group_low_luxury,

    -- One-Hot for holiday
    CASE WHEN holiday = 'New Year Day'             THEN 1 ELSE 0 END AS holiday_new_year,
    CASE WHEN holiday = 'Good Friday'              THEN 1 ELSE 0 END AS holiday_good_friday,
    CASE WHEN holiday = 'Easter Monday'            THEN 1 ELSE 0 END AS holiday_easter_monday,
    CASE WHEN holiday = 'Christmas Day'            THEN 1 ELSE 0 END AS holiday_christmas,
    CASE WHEN holiday = 'Boxing Day'               THEN 1 ELSE 0 END AS holiday_boxing,
    CASE WHEN holiday in ('Early May bank holiday', 'Spring bank holiday', 'Queen Diamond Jubilee', 'Summer bank holiday')   THEN 1 ELSE 0 END AS holiday_bank,
  
    -- Raw reading
   
    hourly_mean_reading,

    -- *** your new log-transformed column ***
    LN(hourly_mean_reading + 1e-3) 
      AS hourly_mean_reading_log,

    -- keep your ID
    Reading_ID,

    -- Weather as ordinal
    CASE
      WHEN weather = 'Freezing' THEN 1
      WHEN weather = 'Cold'    THEN 2
      WHEN weather = 'Chilly'  THEN 3
      WHEN weather = 'Cool'    THEN 4
      WHEN weather = 'Mild'    THEN 5
      WHEN weather = 'Warm'    THEN 6
      WHEN weather = 'Hot'     THEN 7
      ELSE 8
    END AS weather,

    -- Cyclical time features
    CAST(SIN(2 * PI() * EXTRACT(HOUR FROM date_time)  / 24) AS double precision) AS hour_sin,
    CAST(COS(2 * PI() * EXTRACT(HOUR FROM date_time)  / 24) AS double precision) AS hour_cos,
    CAST(SIN(2 * PI() * EXTRACT(DOW  FROM date_time)  / 7) AS double precision) AS day_sin,
    CAST(COS(2 * PI() * EXTRACT(DOW  FROM date_time)  / 7) AS double precision) AS day_cos,
    CAST(SIN(2 * PI() * EXTRACT(MONTH FROM date_time) / 12) AS double precision) AS month_sin,
    CAST(COS(2 * PI() * EXTRACT(MONTH FROM date_time) / 12) AS double precision) AS month_cos,

    -- handy raw time parts
    EXTRACT(HOUR  FROM date_time) AS hour,
    EXTRACT(MONTH FROM date_time) AS month,
    EXTRACT(DOW   FROM date_time) AS day,
    (EXTRACT(HOUR  FROM date_time)::double precision) / 24.0    AS hour_angle,
    ((EXTRACT(MONTH FROM date_time) - 1)::double precision) / 12.0 AS month_angle,
    ((EXTRACT(DOW   FROM date_time))::double precision) / 7.0     AS day_angle,
    is_synthetic

FROM test_with_synthetic_new_auto
WHERE acorn_group <> 'GROUP-UNKNOWN';