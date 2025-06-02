import psycopg2

"""
Identifies and deletes rows in weather_staging table whose date_time does not match any row in dates_and_holidays.
Exports those "bad" rows to fk_violations.csv for logging purposes.
"""

db_params = {
    "dbname": "postgres",
    "user": "postgres",
    "password": "password",
    "host": "localhost",
    "port": "5432"
}

fk_violation_csv = r"C:/jupyter/weather/fk_violations.csv"

try:
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    violation_query = """
        SELECT s.*
        FROM weather_staging s
        LEFT JOIN dates_and_holidays d
               ON s.date_time = d.date_time
        WHERE d.date_time IS NULL
    """


    with open(fk_violation_csv, 'w', encoding='utf-8', newline='') as out_csv:
        cur.copy_expert(f"COPY ({violation_query}) TO STDOUT WITH CSV HEADER DELIMITER ','", out_csv)
    print(f"FK-violating rows written to {fk_violation_csv}")


    delete_query = """
        DELETE FROM weather_staging
        WHERE date_time IN (
            SELECT s.date_time
            FROM weather_staging s
            LEFT JOIN dates_and_holidays d
                   ON s.date_time = d.date_time
            WHERE d.date_time IS NULL
        )
    """
    cur.execute(delete_query)
    print("FK-violating rows deleted from weather_staging.")

    conn.commit()

except Exception as e:
    print(f"Error: {e}")

finally:
    if cur:
        cur.close()
    if conn:
        conn.close()