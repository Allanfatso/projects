
-- must go in staging and create tables
INSERT INTO Household_details (
    LCL_ID,
    STD_OR_TOU,
    ACORN,
    ACORN_GROUP
    
)
SELECT 
    LCL_ID,
    STD_OR_TOU,
    ACORN,
    ACORN_GROUP

FROM staging_household_details;


INSERT INTO Dates_and_Holidays (
    Date_Time,
    Holiday
)
SELECT 
    Date_Time,
    Holiday
FROM staging_dates_and_holidays;

INSERT INTO Tariffs (
    Date_Time,
    Tariff
)
SELECT
    Date_Time,
    Tariff
FROM staging_tariffs;

INSERT INTO Weather (
    visibility,
    windBearing,
    temperature,
    Date_Time,
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
    visibility,
    windBearing,
    temperature,
    Date_Time,
    dewPoint,
    pressure,
    apparentTemperature,
    windSpeed,
    precipType,
    icon,
    humidity,
    summary
FROM staging_weather;

INSERT INTO Consumption_data (
    LCL_ID,
    STD_OR_TOU,
    Date_Time,
    KWHperHR
    
)
SELECT
    LCL_ID,
    STD_OR_TOU,
    Date_Time,
    KWHperHR
   
FROM staging_consumption_data;
