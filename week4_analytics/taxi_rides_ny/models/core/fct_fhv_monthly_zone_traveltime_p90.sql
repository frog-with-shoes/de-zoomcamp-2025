{{
    config(
        materialized='table'
    )
}}

with fhv_trip_duration as (
select 
pickup_datetime,
dropoff_datetime,
year,
month,
pickup_locationid,
dropoff_locationid,
pickup_zone,
dropoff_zone,
TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) as trip_duration,
from {{ref('dim_fhv_trips')}}
)

SELECT 
pickup_datetime,
dropoff_datetime,
year,
month,
pickup_zone,
dropoff_zone,
trip_duration,
PERCENTILE_CONT(trip_duration, 0.90) over(partition by pickup_locationid, dropoff_locationid, year, month) as percentile_90_trip_duration,
FROM fhv_trip_duration






