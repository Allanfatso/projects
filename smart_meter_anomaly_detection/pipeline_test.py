import pandas as pd


df = pd.read_csv(
    r"C:\Users\racon\Downloads\LCL-June2025v2_1.csv",
    sep=None,
    engine="python",
    dtype=str
)


df.columns = df.columns.str.strip()
print("Columns:", df.columns.tolist())
df["DateTime"] = pd.to_datetime(df["DateTime"], errors="raise")
df["DateTime"] = df["DateTime"].apply(lambda dt: dt.replace(year=2025))
df["DateTime"] = df["DateTime"].dt.strftime("%Y-%m-%d %H:%M:%S.%f")


df.to_csv(
    r"C:\Users\racon\Downloads\LCL-June2025v2_1.csv",
    sep=",",     
    index=False
)

print(" CSV overwritten with new 2025 DateTime values.")
