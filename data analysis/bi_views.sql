--Q4 2011
CREATE OR REPLACE VIEW BI_all_views_2011_12_1st AS
SELECT
    date_time,
    t.lcl_id,
    t.std_or_tou,
    t.acorn,
    t.acorn_group,
    t.holiday,
    t.kwhperhr as hourly_mean_reading,
    COALESCE(t.tariff, 'Flat') AS tariff,  -- Replace NULL with 'Flat
    t.Reading_ID,
    CASE
        WHEN t.temperature <= 0  THEN 'Freezing'
        WHEN t.temperature <= 8  THEN 'Cold'
        WHEN t.temperature <= 12 THEN 'Chilly'
        WHEN t.temperature <= 16 THEN 'Cool'
        WHEN t.temperature <= 20 THEN 'Mild'
        WHEN t.temperature <= 25 THEN 'Warm'
        WHEN t.temperature <= 30 THEN 'Hot'
        WHEN t.temperature > 30 THEN 'Heatwave'
    END AS weather
FROM (
    SELECT * from Wide_Feature_2011_q4_MV
    UNION ALL
    SELECT * from Wide_Feature_2012_q1_MV
) AS t;





-- all other years
CREATE OR REPLACE VIEW BI_all_views_2012_14_2nd AS
SELECT
    date_time,
    t.lcl_id,
    t.std_or_tou,
    t.acorn,
    t.acorn_group,
    t.holiday,
    t.kwhperhr as hourly_mean_reading,
    COALESCE(t.tariff, 'Flat') AS tariff,  -- Replace NULL with 'Flat
    t.Reading_ID,
    CASE
        WHEN t.temperature <= 0  THEN 'Freezing'
        WHEN t.temperature <= 8  THEN 'Cold'
        WHEN t.temperature <= 12 THEN 'Chilly'
        WHEN t.temperature <= 16 THEN 'Cool'
        WHEN t.temperature <= 20 THEN 'Mild'
        WHEN t.temperature <= 25 THEN 'Warm'
        WHEN t.temperature <= 30 THEN 'Hot'
        WHEN t.temperature > 30 THEN 'Heatwave'
    END AS weather
FROM (
    SELECT * from Wide_Feature_2012_q2_MV
    UNION ALL
    SELECT * from Wide_Feature_2012_q3_MV
    UNION ALL
    SELECT * from Wide_Feature_2012_q4_MV
    UNION ALL
    SELECT * from Wide_Feature_2013_q1_MV
    UNION ALL
    SELECT * from Wide_Feature_2013_q2_MV
    UNION ALL
    SELECT * from Wide_Feature_2013_q3_MV
    UNION ALL
    SELECT * from Wide_Feature_2013_q4_MV
    UNION ALL
    SELECT * from Wide_Feature_2014_q1_MV
) AS t;





-- machine-learning daily fix
CREATE OR REPLACE VIEW DAILY_SCORING AS
SELECT 
    c.Date_Time, 
    c.LCL_ID,
    -- One-Hot Encoding for acorn_group
    CASE WHEN c.std_or_tou = 'Std' THEN 0 ELSE 1 END AS std_or_tou,
    CASE WHEN h.acorn_group = 'Established Affluence'   THEN 1 ELSE 0 END AS acorn_group_affluence,
    CASE WHEN h.acorn_group = 'Steadfast Communities'  THEN 1 ELSE 0 END AS acorn_group_steadfast,
    CASE WHEN h.acorn_group = 'Thriving Neighbourhoods' THEN 1 ELSE 0 END AS acorn_group_thriving,
    CASE WHEN h.acorn_group = 'Stretched Society'       THEN 1 ELSE 0 END AS acorn_group_stretched,
    -- dropped Low Income Living as dummy trap
    CASE WHEN h.acorn_group = 'Luxury Lifestyles'    THEN 1 ELSE 0 END AS acorn_group_low_luxury,
    -- One-Hot for holiday
    CASE WHEN d.holiday = 'New Year Day'             THEN 1 ELSE 0 END AS holiday_new_year,
    CASE WHEN d.holiday = 'Good Friday'              THEN 1 ELSE 0 END AS holiday_good_friday,
    CASE WHEN d.holiday = 'Easter Monday'            THEN 1 ELSE 0 END AS holiday_easter_monday,
    CASE WHEN d.holiday = 'Christmas Day'            THEN 1 ELSE 0 END AS holiday_christmas,
    CASE WHEN d.holiday = 'Boxing Day'               THEN 1 ELSE 0 END AS holiday_boxing,
    CASE WHEN d.holiday in ('Early May bank holiday', 'Spring bank holiday', 'Queen Diamond Jubilee', 'Summer bank holiday')   THEN 1 ELSE 0 END AS holiday_bank,
     -- Raw reading
    CAST(ROUND(c.KWHperHR, 4) AS double precision) 
      AS hourly_mean_reading,
    -- Log transformed
    LN(c.KWHperHR + 1e-3) AS hourly_mean_reading_log,
    c.Reading_ID,
	CASE
        WHEN w.temperature <= 0  THEN '1'
        WHEN w.temperature <= 8  THEN '2'
        WHEN w.temperature <= 12 THEN '3'
        WHEN w.temperature <= 16 THEN '4'
        WHEN w.temperature <= 20 THEN '5'
        WHEN w.temperature <= 25 THEN '6'
        WHEN w.temperature <= 30 THEN '7'
        WHEN w.temperature > 30 THEN '8'
    END AS weather,
    -- Cyclical time features
    CAST(SIN(2 * PI() * EXTRACT(HOUR FROM c.date_time)  / 24) AS double precision) AS hour_sin,
    CAST(COS(2 * PI() * EXTRACT(HOUR FROM c.date_time)  / 24) AS double precision) AS hour_cos,
    CAST(SIN(2 * PI() * EXTRACT(DOW  FROM c.date_time)  / 7) AS double precision) AS day_sin,
    CAST(COS(2 * PI() * EXTRACT(DOW  FROM c.date_time)  / 7) AS double precision) AS day_cos,
    CAST(SIN(2 * PI() * EXTRACT(MONTH FROM c.date_time) / 12) AS double precision) AS month_sin,
    CAST(COS(2 * PI() * EXTRACT(MONTH FROM c.date_time) / 12) AS double precision) AS month_cos

	
FROM consumption_data c
LEFT JOIN Household_details h       ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d      ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w                ON c.Date_Time = w.Date_Time
WHERE acorn_group <> 'GROUP-UNKNOWN'
order by date_time desc limit 408744






-- machine-learning daily fix
CREATE OR REPLACE VIEW daily_data AS
SELECT 
    c.Date_Time, 
    c.LCL_ID,
    -- One-Hot Encoding for acorn_group
    c.std_or_tou,
    CASE WHEN h.acorn_group = 'Established Affluence'   THEN 1 ELSE 0 END AS acorn_group_affluence,
    CASE WHEN h.acorn_group = 'Steadfast Communities'  THEN 1 ELSE 0 END AS acorn_group_steadfast,
    CASE WHEN h.acorn_group = 'Thriving Neighbourhoods' THEN 1 ELSE 0 END AS acorn_group_thriving,
    CASE WHEN h.acorn_group = 'Stretched Society'       THEN 1 ELSE 0 END AS acorn_group_stretched,
    -- dropped Low Income Living as dummy trap
    CASE WHEN h.acorn_group = 'Luxury Lifestyles'    THEN 1 ELSE 0 END AS acorn_group_low_luxury,
    -- One-Hot for holiday
    CASE WHEN d.holiday = 'New Year Day'             THEN 1 ELSE 0 END AS holiday_new_year,
    CASE WHEN d.holiday = 'Good Friday'              THEN 1 ELSE 0 END AS holiday_good_friday,
    CASE WHEN d.holiday = 'Easter Monday'            THEN 1 ELSE 0 END AS holiday_easter_monday,
    CASE WHEN d.holiday = 'Christmas Day'            THEN 1 ELSE 0 END AS holiday_christmas,
    CASE WHEN d.holiday = 'Boxing Day'               THEN 1 ELSE 0 END AS holiday_boxing,
    CASE WHEN d.holiday in ('Early May bank holiday', 'Spring bank holiday', 'Queen Diamond Jubilee', 'Summer bank holiday')   THEN 1 ELSE 0 END AS holiday_bank,
     -- Raw reading
    CAST(ROUND(c.KWHperHR, 4) AS double precision) 
      AS hourly_mean_reading,
    -- Log transformed
    LN(c.KWHperHR + 1e-3) AS hourly_mean_reading_log,
    c.Reading_ID,
	CASE
        WHEN w.temperature <= 0  THEN '1'
        WHEN w.temperature <= 8  THEN '2'
        WHEN w.temperature <= 12 THEN '3'
        WHEN w.temperature <= 16 THEN '4'
        WHEN w.temperature <= 20 THEN '5'
        WHEN w.temperature <= 25 THEN '6'
        WHEN w.temperature <= 30 THEN '7'
        WHEN w.temperature > 30 THEN '8'
    END AS weather,
    -- Cyclical time features
    CAST(SIN(2 * PI() * EXTRACT(HOUR FROM c.date_time)  / 24) AS double precision) AS hour_sin,
    CAST(COS(2 * PI() * EXTRACT(HOUR FROM c.date_time)  / 24) AS double precision) AS hour_cos,
    CAST(SIN(2 * PI() * EXTRACT(DOW  FROM c.date_time)  / 7) AS double precision) AS day_sin,
    CAST(COS(2 * PI() * EXTRACT(DOW  FROM c.date_time)  / 7) AS double precision) AS day_cos,
    CAST(SIN(2 * PI() * EXTRACT(MONTH FROM c.date_time) / 12) AS double precision) AS month_sin,
    CAST(COS(2 * PI() * EXTRACT(MONTH FROM c.date_time) / 12) AS double precision) AS month_cos

	
FROM consumption_data c
LEFT JOIN Household_details h       ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d      ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w                ON c.Date_Time = w.Date_Time
WHERE acorn_group <> 'GROUP-UNKNOWN'
order by date_time desc limit 408744

