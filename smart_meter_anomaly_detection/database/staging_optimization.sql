-- Index to speed up lookups on LCL_ID and Date_Time
CREATE INDEX idx_staging_lcl_datetime ON staging_consumption_data (lcl_id, date_time);

-- Index on Date_Time for faster joins with Tariffs
CREATE INDEX idx_staging_datetime ON staging_consumption_data (date_time);
