{{
    config(
        materialized='table'
    )
}}
with fact_trips_table as (
    select  *
    from {{ref('fact_trips')}}
    where fare_amount > 0 and trip_distance > 0 and payment_type_description in ('Cash', 'Credit card')
)

select 
service_type, 
year, 
month, 
fare_amount,
PERCENTILE_CONT(fare_amount, 0.97) over(partition by service_type, year, month) as percentile_97_fare_amount,
PERCENTILE_CONT(fare_amount, 0.95) over(partition by service_type, year, month) as percentile_95_fare_amount,
PERCENTILE_CONT(fare_amount, 0.90) over(partition by service_type, year, month) as percentile_90_fare_amount,
from fact_trips_table