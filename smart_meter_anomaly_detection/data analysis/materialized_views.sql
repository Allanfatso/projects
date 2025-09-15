-- 2011 Q4 
CREATE MATERIALIZED VIEW Wide_Feature_2011_q4_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP, c.Tariff_ID,
    t.Tariff,
    d.Holiday,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2011_q4 c
LEFT JOIN Household_details h       ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d      ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w                ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

-- Unique index for concurrent refresh
CREATE UNIQUE INDEX idx_wide_feature_2011_q4_pk
ON Wide_Feature_2011_q4_MV (Reading_ID, Date_Time);

-- 2012 q1
CREATE MATERIALIZED VIEW Wide_Feature_2012_q1_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    c.Tariff_ID,
    t.Tariff,
    d.Holiday,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2012_q1 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;


CREATE UNIQUE INDEX idx_wide_feature_2012_q1_pk
ON Wide_Feature_2012_q1_MV (Reading_ID, Date_Time);

-- q2
CREATE MATERIALIZED VIEW Wide_Feature_2012_q2_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2012_q2 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2012_q2_pk
ON Wide_Feature_2012_q2_MV (Reading_ID, Date_Time);

-- q3
CREATE MATERIALIZED VIEW Wide_Feature_2012_q3_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2012_q3 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2012_q3_pk
ON Wide_Feature_2012_q3_MV (Reading_ID, Date_Time);

--q4
CREATE MATERIALIZED VIEW Wide_Feature_2012_q4_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2012_q4 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2012_q4_pk
ON Wide_Feature_2012_q4_MV (Reading_ID, Date_Time);

-- 2013 q1
CREATE MATERIALIZED VIEW Wide_Feature_2013_q1_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2013_q1 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2013_q1_pk
ON Wide_Feature_2013_q1_MV (Reading_ID, Date_Time);

-- q2
CREATE MATERIALIZED VIEW Wide_Feature_2013_q2_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2013_q2 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2013_q2_pk
ON Wide_Feature_2013_q2_MV (Reading_ID, Date_Time);

--q3
CREATE MATERIALIZED VIEW Wide_Feature_2013_q3_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2013_q3 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2013_q3_pk
ON Wide_Feature_2013_q3_MV (Reading_ID, Date_Time);

-- q4
CREATE MATERIALIZED VIEW Wide_Feature_2013_q4_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2013_q4 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2013_q4_pk
ON Wide_Feature_2013_q4_MV (Reading_ID, Date_Time);

-- 2014 q1
CREATE MATERIALIZED VIEW Wide_Feature_2014_q1_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2014_q1 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2014_q1_pk
ON Wide_Feature_2014_q1_MV (Reading_ID, Date_Time);

-- q2
CREATE MATERIALIZED VIEW Wide_Feature_2014_q2_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2014_q2 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2014_q2_pk
ON Wide_Feature_2014_q2_MV (Reading_ID, Date_Time);

-- q3
CREATE MATERIALIZED VIEW Wide_Feature_2014_q3_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2014_q3 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2014_q3_pk
ON Wide_Feature_2014_q3_MV (Reading_ID, Date_Time);

-- q4
CREATE MATERIALIZED VIEW Wide_Feature_2014_q4_MV AS
SELECT 
    c.Reading_ID, c.LCL_ID, c.Date_Time, c.KWHperHR, c.STD_OR_TOU,
    h.ACORN, h.ACORN_GROUP,
    d.Holiday,
    c.Tariff_ID,
    t.Tariff,
    w.visibility, w.windBearing, w.temperature, w.dewPoint, w.pressure,
    w.apparentTemperature, w.windSpeed, w.precipType, w.icon, w.humidity,
    w.summary
FROM consumption_data_2014_q4 c
LEFT JOIN Household_details h ON c.LCL_ID = h.LCL_ID
LEFT JOIN Dates_and_Holidays d ON c.Date_Time = d.Date_Time
LEFT JOIN Weather w ON c.Date_Time = w.Date_Time
LEFT JOIN Tariffs t                 ON t.Tariff_ID = c.Tariff_ID;

CREATE UNIQUE INDEX idx_wide_feature_2014_q4_pk
ON Wide_Feature_2014_q4_MV (Reading_ID, Date_Time);
