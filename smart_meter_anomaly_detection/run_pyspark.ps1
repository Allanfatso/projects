
# installation
docker build -t pyspark-container . --no-cache

# run docker container with mounted volume

docker run -d --name jupyter_spark \
    -v parquet-data:/home/jovyan/data \
    -p 8888:8888 -p 4040:4040 \
    pyspark-fixed:latest \
    start-notebook.sh --NotebookApp.token='' --NotebookApp.password=''
