CREATE MATERIALIZED VIEW BI_all_years_machine_learning_2014 AS
SELECT 
    date_time,
    lcl_id,
    -- Binary encoding for std_or_tou
    CASE
        WHEN std_or_tou = 'Std' THEN 0.2152
        ELSE 0.1987
    END AS std_or_tou,

        -- target encoded
        CASE
            WHEN acorn_group = 'Stretched Society' THEN 0.1561
            WHEN acorn_group = 'Steadfast Communities' THEN 0.2037
            WHEN acorn_group = 'Thriving Neighbourhoods' THEN 0.2090
            WHEN acorn_group = 'Established Affluence' THEN 0.2262
            WHEN acorn_group = 'Low Income Living' THEN 0.2416
            WHEN acorn_group = 'Luxury Lifestyles' THEN 0.3219
        END AS acorn_group,

    -- One-Hot Encoding for holiday
        CASE WHEN holiday = 'New Year Day' THEN 1 ELSE 0 END AS holiday_new_year,
        CASE WHEN holiday = 'Good Friday' THEN 1 ELSE 0 END AS holiday_good_friday,
        CASE WHEN holiday = 'Easter Monday' THEN 1 ELSE 0 END AS holiday_easter_monday,
        CASE WHEN holiday = 'Early May bank holiday' THEN 1 ELSE 0 END AS holiday_may_bank,
        CASE WHEN holiday = 'Spring bank holiday' THEN 1 ELSE 0 END AS holiday_spring_bank,
        CASE WHEN holiday = 'Queen Diamond Jubilee' THEN 1 ELSE 0 END AS holiday_queen_jubilee,
        CASE WHEN holiday = 'Summer bank holiday' THEN 1 ELSE 0 END AS holiday_summer_bank,
        CASE WHEN holiday = 'Christmas Day' THEN 1 ELSE 0 END AS holiday_christmas,
        CASE WHEN holiday = 'Boxing Day' THEN 1 ELSE 0 END AS holiday_boxing,
        -- Dropped as dummy variable trap. CASE WHEN t.holiday = 'normal day' THEN 1 ELSE 0 END AS holiday_normal,
    -- One-hot Encoding for tariff
     
        CASE WHEN LOWER(tariff) = 'low' THEN 1 ELSE 0 END AS tariff_low,  -- Was NULL, now lowest category
        CASE WHEN LOWER(tariff) = 'normal' THEN 1 ELSE 0 END AS tariff_normal,
        CASE WHEN LOWER(tariff) = 'high' THEN 1 ELSE 0 END AS tariff_high,
        -- dummy variable CASE WHEN LOWER(tariff) = 'flat' THEN 1 ELSE 0 END AS tariff_flat,
        CASE
            WHEN LOWER(tariff) = 'low' THEN 0.2148
            WHEN LOWER(tariff) = 'normal' THEN 0.2082
            WHEN LOWER(tariff) = 'flat' THEN 0.2129
            WHEN LOWER(tariff) = 'high' THEN 0.2512
        END AS tariff,        

    CAST(ROUND(hourly_mean_reading, 4) AS double precision) AS hourly_mean_reading,

     -- New log-transformed and standardized column
     /*
        Energy consumption data is naturally right skewed. Hence the following column will use log
        transformation to reduce the skewedness of the data.
     */

    Reading_ID,

    -- Weather ordinal encoding per temperature
    CASE
        WHEN weather = 'Freezing'  THEN 1
        WHEN weather = 'Cold'  THEN 2
        WHEN weather = 'Chilly' THEN 3
        WHEN weather = 'Cool' THEN 4
        WHEN weather = 'Mild' THEN 5
        WHEN weather = 'Warm' THEN 6
        WHEN weather = 'Hot' THEN 7
        ELSE 8
    END AS weather,
    EXTRACT(DAY FROM date_time) AS day,
    EXTRACT(MONTH FROM date_time) AS month,
    EXTRACT(YEAR FROM date_time) AS year
    
FROM all_data 
where EXTRACT(YEAR FROM date_time) = 2014