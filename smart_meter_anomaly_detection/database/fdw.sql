CREATE ROLE fdw_user WITH LOGIN PASSWORD 'smartreaders';
GRANT USAGE ON SCHEMA public TO fdw_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO fdw_user;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO fdw_user;


-- views
GRANT SELECT ON BI_2011_q4_hourly TO fdw_user;
GRANT SELECT ON BI_2012_q1_hourly TO fdw_user;
GRANT SELECT ON BI_2012_q2_hourly TO fdw_user;
GRANT SELECT ON BI_2012_q3_hourly TO fdw_user;
GRANT SELECT ON BI_2012_q4_hourly TO fdw_user;
GRANT SELECT ON BI_2013_q1_hourly TO fdw_user;
GRANT SELECT ON BI_2013_q2_hourly TO fdw_user;
GRANT SELECT ON BI_2013_q3_hourly TO fdw_user;
GRANT SELECT ON BI_2013_q4_hourly TO fdw_user;
GRANT SELECT ON BI_2014_q1_hourly TO fdw_user;
GRANT SELECT ON BI_all_years_machine_learning TO fdw_user;


-- Prediction values
CREATE TABLE training_results (
    model_id SERIAL PRIMARY KEY,
    training_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reading_id INT,
    date_time TIMESTAMP,
    lcl_id VARCHAR(50),
    predicted_kwhperhr DECIMAL(10, 6),
    FOREIGN KEY (reading_id, date_time) REFERENCES Consumption_data (reading_id, date_time)
);
GRANT INSERT, SELECT ON training_results TO fdw_user;