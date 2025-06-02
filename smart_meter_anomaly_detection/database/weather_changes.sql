INSERT INTO Dates_and_Holidays(date_time, holiday)
SELECT dh.date_time + INTERVAL '30 minutes' AS half_past_time,
       dh.holiday
FROM Dates_and_Holidays dh
WHERE EXTRACT(MINUTE FROM dh.date_time) = 0  -- top-of-hour rows
  AND dh.date_time + INTERVAL '30 minutes' < '2015-01-01'   -- or whatever end limit
  AND NOT EXISTS (
      SELECT 1
      FROM Dates_and_Holidays dh2
      WHERE dh2.date_time = dh.date_time + INTERVAL '30 minutes'
  );


-- Insertion of values

INSERT INTO Weather (
    visibility,
    windBearing,
    temperature,
    date_time,
    dewPoint,
    pressure,
    apparentTemperature,
    windSpeed,
    precipType,
    icon,
    humidity,
    summary
)
SELECT
    w.visibility,
    w.windBearing,
    w.temperature,  -- same as xx:00
    (w.date_time + INTERVAL '30 minutes') AS half_past_time,
    w.dewPoint,
    w.pressure,
    w.apparentTemperature,
    w.windSpeed,
    w.precipType,
    w.icon,
    w.humidity,
    w.summary
FROM Weather w
WHERE
    EXTRACT(MINUTE FROM w.date_time) = 0          -- only xx:00 rows
    AND (w.date_time + INTERVAL '30 minutes') < '2015-02-15' -- or whichever date range
    AND NOT EXISTS (
        SELECT 1
        FROM Weather w2
        WHERE w2.date_time = w.date_time + INTERVAL '30 minutes'
    );
