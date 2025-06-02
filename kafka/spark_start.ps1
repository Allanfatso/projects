python -c "
import pyspark
print('PySpark version:', pyspark.__version__)
from pyspark.sql import SparkSession
spark = SparkSession.builder \
                     .appName('Test') \
                     .master('local[*]') \
                     .getOrCreate()
print('SparkSession created successfully!')
spark.stop()
"