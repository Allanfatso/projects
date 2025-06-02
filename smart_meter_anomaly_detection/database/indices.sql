
CREATE INDEX idx_household_acorn ON Household_details (ACORN);

CREATE INDEX idx_weather_date_time ON Weather (Date_Time);

-- Index to speed up joins/filters on LCL_ID:
CREATE INDEX idx_consumption_lcl_id ON Consumption_data (LCL_ID);

-- Index to speed up joins/filters on Tariff_ID:
CREATE INDEX idx_consumption_tariff_id ON Consumption_data (Tariff_ID);

-- Index on time
CREATE INDEX idx_consumption_date ON Consumption_data (Date_Time);

CREATE INDEX idx_dates_holidays ON dates_and_holidays (Date_Time);

-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_id ON Consumption_data (Reading_ID);




--MATERIALIZED VIEWS---
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv1 ON wide_feature_2011_q4_mv (Reading_ID);
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv2 ON wide_feature_2012_q1_mv (Reading_ID);
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv3 ON wide_feature_2012_q2_mv (Reading_ID);
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv4 ON wide_feature_2012_q3_mv (Reading_ID);
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv5 ON wide_feature_2012_q4_mv (Reading_ID);
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv6 ON wide_feature_2013_q1_mv (Reading_ID);
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv7 ON wide_feature_2013_q2_mv (Reading_ID);
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv8 ON wide_feature_2013_q3_mv (Reading_ID);
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv9 ON wide_feature_2013_q4_mv (Reading_ID);
-- index for quick "Reading_ID" lookups
CREATE INDEX idx_consumption_reading_mv10 ON wide_feature_2014_q1_mv (Reading_ID);