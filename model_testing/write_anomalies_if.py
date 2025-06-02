import pandas as pd
from sqlalchemy import create_engine

# Database connection
DATABASE_URI = 'postgresql://postgres:passwordh@localhost:5432/postgres'

# Your anomalies parquet path
anomalies_parquet = "C:/Users/racon/output/2011_offset_0.parquet"

# Load anomalies into DataFrame
anomalies_df = pd.read_parquet(anomalies_parquet)

# Add year for reference (important for easy joining later)
anomalies_df['year'] = 2011

# Save anomalies to PostgreSQL
engine = create_engine(DATABASE_URI)

# Insert into DB efficiently
anomalies_df.to_sql('anomalies', engine, if_exists='append', index=False, method='multi')

print(f" {len(anomalies_df):,} anomalies saved to DB.")
