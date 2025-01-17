import pandas as pd
import pyarrow.parquet as pq
import sys
from sqlalchemy import create_engine

print(pd.__version__)

df = pd.read_csv('yellow_tripdata_2021-01.csv', nrows=100)
print(df)
df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)


engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')
print(engine.connect())
print(pd.io.sql.get_schema(df, name='yellow_taxi_data', con=engine))#data definition lang


df_iter = pd.read_csv('yellow_tripdata_2021-01.csv', iterator=True, chunksize=100000)

df.head(n=0).to_sql(name='yellow_taxi_data', con=engine, if_exists='replace')
from time import time
while True:
    t_start = time()
    df = next(df_iter)
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')
    t_end = time()

    print('inserted another chunk..', t_end-t_start)

# print(pq.read_metadata('yellow_tripdata_2021-01.parquet'))
# trips = pq.read_table('yellow_tripdata_2022-01.parquet')
# print('trips: ', trips.schema)

# trips = trips.to_pandas()
# print('trips: ', trips)


