import psycopg2

"""
Selects all rows in consumption_data_staging table whose date_time does not match any row in dates_and_holidays.
Exports those “bad” rows to fk_violations.csv.

"""
db_params = {
    "dbname": "postgres",
    "user": "postgres",
    "password": "password", 
    "host": "localhost",
    "port": "5432"
}

fk_violation_csv = r"C:/Users/racon/Downloads/Small_LCL_Data/fk_violations.csv"

try:
    conn = psycopg2.connect(**db_params)
    cur = conn.cursor()

    # 1) Identify staging rows not present in dates_and_holidays
    violation_query = """
        COPY (
            SELECT s.*
            FROM consumption_data_staging s
            LEFT JOIN dates_and_holidays d
                   ON s.date_time = d.date_time
            WHERE d.date_time IS NULL
        )
        TO STDOUT
        WITH CSV HEADER DELIMITER ','
    """

    with open(fk_violation_csv, 'w', encoding='utf-8', newline='') as out_csv:
        cur.copy_expert(violation_query, out_csv)
    print(f"FK-violating rows written to {fk_violation_csv}")

    conn.commit()

except Exception as e:
    print(f"Error: {e}")

finally:
    if cur:
        cur.close()
    if conn:
        conn.close()
