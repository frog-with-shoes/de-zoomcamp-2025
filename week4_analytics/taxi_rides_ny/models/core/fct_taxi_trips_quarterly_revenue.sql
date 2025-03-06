{{
    config(
        materialized='table'
    )
}}

with stg_green_tripdata_revenue as (
    select  
    SUM(total_amount) as revenue,
    year_quarter 
    from {{ref('stg_green_tripdata')}}
    group by year_quarter
    ORDER BY revenue DESC LIMIT 8
)

    select 
    revenue,
    year_quarter,
    LAG(revenue, 4) OVER (ORDER BY year_quarter) as revenue_previous_month,
    ((revenue - LAG(revenue, 4) OVER (ORDER BY year_quarter))/(LAG(revenue, 4) OVER (ORDER BY year_quarter)))*100 as year_quarter_over_quarter
    FROM stg_green_tripdata_revenue
   