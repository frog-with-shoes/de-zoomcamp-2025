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