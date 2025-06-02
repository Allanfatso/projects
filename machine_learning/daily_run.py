#!C:/ProgramData/anaconda3/envs/anomaly_det/python.exe
# daily_run.py

import os
import glob
import joblib
import numpy as np
import pandas as pd
from sqlalchemy import create_engine
from tensorflow import keras


PG_URI    = "postgresql+psycopg2://postgres:password@localhost:5432/postgres"
PARQ_RAW  = r"C:\Users\racon\data_log_production\production_strata_auto.parquet"
engine    = create_engine(PG_URI)

df = pd.read_sql("SELECT * FROM public.daily_scoring;", engine)
df.to_parquet(PARQ_RAW, index=False)
print(f"[1/4] Exported {len(df)} rows to {PARQ_RAW}")
PARQ_SCALED = r"C:\Users\racon\data_production\production_strata_auto_scaled.parquet"
SCALER_PATH = r"C:\Users\racon\ml_models\scaler_auto_enc_columns.joblib"

CONT_COLS = [
    "hourly_mean_reading_log","weather","hour_sin","month_sin","day_sin",
    "hour_cos","month_cos","day_cos"
]
EXCLUDE  = [
    "date_time","lcl_id","year","hourly_mean_reading",
    "tariff","hour","month","day",
    "hour_angle","month_angle","day_angle"
]

scaler = joblib.load(SCALER_PATH)
df = pd.read_parquet(PARQ_RAW)

# transform continuous block
Xc = scaler.transform(df[CONT_COLS])
df_cont = pd.DataFrame(Xc, columns=CONT_COLS, index=df.index)

# drop old + excluded, re-attach scaled
df = pd.concat([df.drop(columns=CONT_COLS+EXCLUDE, errors="ignore"), df_cont], axis=1)
os.makedirs(os.path.dirname(PARQ_SCALED), exist_ok=True)
df.to_parquet(PARQ_SCALED, index=False)
print(f"[2/4] Scaled & wrote {len(df)} rows to {PARQ_SCALED}")


# ─────────────── RUN Conv-AE to flag anomalies ────────────────────
MODEL_PATH   = r"C:\Users\racon\ml_models\ae_conv_window_soft.keras"
TAU_PATH     = r"C:\Users\racon\ml_models\ae_conv_window_tau_soft.npy"
W            = 6 

# load model + threshold
autoenc = keras.models.load_model(MODEL_PATH, compile=False)
tau      = float(np.load(TAU_PATH)[0])

df = pd.read_parquet(PARQ_SCALED)
features = [c for c in df.columns if c != "reading_id"]

# build sliding windows
wins = [df[features].shift(s).values for s in range(W)]
Xw_all = np.stack(wins, axis=1)
valid  = ~np.isnan(Xw_all).any(axis=(1,2))
Xw     = Xw_all[valid]
idxs   = np.nonzero(valid)[0]

# reconstruct + compute MSE
recon   = autoenc.predict(Xw, batch_size=1024)
mse     = np.mean((Xw - recon)**2, axis=(1,2))
win_flag = mse > tau

# map back to row-level
row_flag, score = np.zeros(len(df),bool), np.zeros(len(df))
for i, m, f in zip(idxs, mse, win_flag):
    if f:
        row_flag[i]  = True
        score[i]     = max(score[i], m)

df["ae_window_anomaly"] = row_flag
df["anomaly_score"]      = score

anoms = df.loc[row_flag, ["reading_id","anomaly_score"]].copy()
anoms["anomaly_label"] = 1   # convention

print(f"[3/4] Detected {len(anoms)} anomalies via AE")

# ──────────────── WRITE anomalies back to Postgres ─────────────────
anoms.to_sql(
    "anomalies_auto_encoder_testing", engine,
    schema="public", if_exists="append", index=False
    
)
print(f"[4/4] Wrote anomalies to anomalies_auto_encoder_testing")
