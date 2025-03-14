{{
    config(
        materialized='table'
    )
}}
    with fhv_tripdata as (
        select * 
        from {{ref('stg_fhv_2019')}}
    ),
    dim_zones as (
        select * from {{ref('dim_zones')}}
        where borough != 'Unknown'
    )
    -- WIP
    select 
    fhv_tripdata.tripid,
    fhv_tripdata.pickup_locationid,
    fhv_tripdata.dropoff_locationid,
    fhv_tripdata.pickup_datetime,
    fhv_tripdata.dropoff_datetime,

    cast(EXTRACT(YEAR FROM CAST(fhv_tripdata.pickup_datetime as DATE)) as INTEGER) as year,
    cast(EXTRACT(MONTH FROM CAST(fhv_tripdata.pickup_datetime as DATE)) as INTEGER) as month,
    


    fhv_tripdata.sr_flag,
    fhv_tripdata.dispatching_base_number,
    fhv_tripdata.affiliated_base_number,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,
    from fhv_tripdata
    inner join dim_zones as pickup_zone
    on fhv_tripdata.pickup_locationid = pickup_zone.locationid
    inner join dim_zones as dropoff_zone
    on fhv_tripdata.dropoff_locationid = dropoff_zone.locationid