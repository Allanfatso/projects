CREATE INDEX ON Tariffs (Date_Time);
--to make the update run faster for the tarrif_foreign key.




---Staging for the processed data for fact table
CREATE TABLE consumption_data_staging_processed (
    lcl_id     VARCHAR(50),
    std_or_tou VARCHAR(5),
    date_time  TIMESTAMP,
    kwhperhr   DECIMAL(10, 6),
    CONSTRAINT composite_key PRIMARY KEY(lcl_id, date_time)
    -- 
)

---Staging for Weather
-- Table: Weather
CREATE TABLE Weather_staging (
	visibility DECIMAL(10, 2) NOT NULL,
	windBearing INT NOT NULL,
	temperature DECIMAL(5, 2) NOT NULL,
	Date_Time TIMESTAMP NOT NULL,   
    dewPoint DECIMAL(5, 2) NOT NULL,
    pressure DECIMAL(7, 2),
    apparentTemperature DECIMAL(5, 2) NOT NULL,
    windSpeed DECIMAL(5, 2) NOT NULL,
    precipType VARCHAR(50),
    icon VARCHAR(50),
    humidity DECIMAL(3, 2)  NOT NULL,
    summary VARCHAR(255)
);

-- Staging deletion after cleaning. As these dates have no smart meter data.
 DELETE FROM weather_staging
        WHERE date_time IN (
            SELECT s.date_time
            FROM weather_staging s
            LEFT JOIN dates_and_holidays d
                   ON s.date_time = d.date_time
            WHERE d.date_time IS NULL
        );
-- Insertion into the main table
INSERT INTO weather (visibility, windBearing, temperature, date_time, dewPoint, pressure, apparentTemperature, windSpeed, precipType, icon, humidity, summary)
        SELECT s.visibility, s.windBearing, s.temperature, s.date_time, s.dewPoint, s.pressure, s.apparentTemperature, s.windSpeed, s.precipType, s.icon, s.humidity, s.summary
        FROM weather_staging s;


--to be used for the fk violating rows so they can be saved for later re-insertion into both tables
SELECT s.*
FROM consumption_data_staging AS s
LEFT JOIN dates_and_holidays AS d
       ON s.date_time = d.date_time
WHERE d.date_time IS NULL;

--used after staging is complete.
INSERT INTO consumption_data (lcl_id, std_or_tou, date_time, kwhperhr)
        SELECT s.lcl_id, s.std_or_tou, s.date_time, s.kwhperhr
        FROM consumption_data_staging s;

--For the tariff_id mapping. Will ammend to ensure occurence for new updates.
UPDATE consumption_data c
SET tariff_id = t.tariff_id
FROM tariffs t
WHERE c.date_time = t.date_time;


CREATE TABLE staging_Consumption_data (
    LCL_ID       VARCHAR(50) NOT NULL,
    STD_OR_TOU   VARCHAR(5)  NOT NULL,
    Date_Time    TIMESTAMP   NOT NULL,
    KWHperHR     DECIMAL(10, 6),
    Reading_ID   SERIAL,
    Tariff_ID    INT,
    FOREIGN KEY (LCL_ID) REFERENCES Staging_Household_details(LCL_ID),
    FOREIGN KEY (Tariff_ID) REFERENCES Staging_Tariffs(Tariff_ID),
    FOREIGN KEY (Date_Time) REFERENCES Staging_Dates_and_Holidays(Date_Time),
    CONSTRAINT datetime_format CHECK (
      to_char(Date_Time, 'DD/MM/YYYY HH24:MI:SS') = to_char(Date_Time, 'DD/MM/YYYY HH24:MI:SS')
    ),
    CONSTRAINT consumption_data_pk PRIMARY KEY (Reading_ID, Date_Time)
);
