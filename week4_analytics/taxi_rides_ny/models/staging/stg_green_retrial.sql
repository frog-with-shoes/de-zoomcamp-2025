{{ config(materialized='view') }}
 
with tripdata as 
(
  select *,
    row_number() over(partition by vendor_id, pickup_datetime) as rn
  from {{ source('staging','green_tripdata') }}
  where vendor_id is not null 
)
select
   -- identifiers
    {{ dbt_utils.generate_surrogate_key(['vendor_id', 'pickup_datetime']) }} as tripid,    
    {{ dbt.safe_cast("vendor_id", api.Column.translate_type("integer")) }} as vendor_id,
    {{ dbt.safe_cast("rate_code", api.Column.translate_type("integer")) }} as rate_code,
    {{ dbt.safe_cast("pickup_location_id", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("dropoff_location_id", api.Column.translate_type("integer")) }} as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,
    cast(EXTRACT(YEAR FROM CAST(dropoff_datetime as DATE)) as INTEGER) as year,
    cast(format_date('%Q', dropoff_datetime) as INTEGER) as quarter,
    CONCAT(CAST(EXTRACT(YEAR FROM CAST(dropoff_datetime as DATE)) as STRING), '/Q', cast(format_date('%Q', dropoff_datetime) as INTEGER)) as year_quarter,
    cast(EXTRACT(MONTH FROM CAST(dropoff_datetime as DATE)) as INTEGER) as month,
    
    -- trip info
    store_and_fwd_flag,
    {{ dbt.safe_cast("passenger_count", api.Column.translate_type("integer")) }} as passenger_count,
    cast(trip_distance as numeric) as trip_distance,
    {{ dbt.safe_cast("trip_type", api.Column.translate_type("integer")) }} as trip_type,
    
    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(0 as numeric) as ehail_fee,
    cast(imp_surcharge as numeric) as improvement_surcharge,
    cast(total_amount as numeric) as total_amount,
    cast(cast (payment_type as FLOAT64) as integer) as payment_type 


from tripdata
where rn = 1

-- dbt build --select <model.sql> --vars '{'is_test_run: false}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}