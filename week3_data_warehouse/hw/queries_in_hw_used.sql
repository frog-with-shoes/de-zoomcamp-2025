
-- Q3
-- SELECT COUNT(1) 
-- FROM (SELECT DISTINCT PULocationID FROM `'project_id'.de_zoomcamp.yellow_tripdata_2024_til_may`)

-- SELECT PULocationID, DOLocationID FROM `'project_id'.de_zoomcamp.yellow_tripdata_2024_til_may_non_partitioned`;

-- Q4
-- SELECT COUNT(1) FROM `'project_id'.de_zoomcamp.yellow_tripdata_2024_til_may_non_partitioned`
-- WHERE fare_amount=0;

-- Q5
-- Creating a partition and cluster table
-- CREATE OR REPLACE TABLE 'project_id'.de_zoomcamp.yellow_tripdata_2024_til_may_partitioned_n_clustered
-- PARTITION BY DATE(tpep_dropoff_datetime)
-- CLUSTER BY VendorID AS
-- SELECT * FROM 'project_id'.de_zoomcamp.yellow_tripdata_2024_til_may;

-- Q6 - materialized
-- SELECT DISTINCT VendorID FROM `'project_id'.de_zoomcamp.yellow_tripdata_2024_til_may_non_partitioned`
-- WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Partitioned and clustered
-- SELECT DISTINCT VendorID FROM `'project_id'.de_zoomcamp.yellow_tripdata_2024_til_may_partitioned_n_clustered`
-- WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Q9
SELECT COUNT(*) FROM `'project_id'.de_zoomcamp.yellow_tripdata_2024_til_may_non_partitioned`
WHERE fare_amount=0;
