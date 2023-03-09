begin;

--A
explain
select *
from item_transportation
where item_transportation.transportation_event_seq_number >= 6
  and item_transportation.shipped_item_item_num between 50 and 2000;

explain (analyse, buffers)
select *
from item_transportation
where item_transportation.transportation_event_seq_number >= 6
  and item_transportation.shipped_item_item_num between 50 and 2000;

--B
explain
WITH si_cte AS (SELECT item_num, weight
                FROM shipped_item_part_10
                WHERE weight >= 900
                  AND destination = 'vocabulary')
SELECT it.transportation_event_seq_number, si_cte.weight
FROM item_transportation it
         JOIN si_cte ON it.shipped_item_item_num = si_cte.item_num;

explain (analyse, buffers)
WITH si_cte AS (SELECT item_num, weight
                FROM shipped_item_part_10
                WHERE weight >= 900
                  AND destination = 'vocabulary')
SELECT it.transportation_event_seq_number, si_cte.weight
FROM item_transportation it
         JOIN si_cte ON it.shipped_item_item_num = si_cte.item_num;

select *
from pg_indexes
where tablename not like 'pg%';

SET plan_cache_mode = force_generic_plan;

drop index if exists shipped_item_item_num_index, item_num_index, transportation_event_seq_number_index, weight_destination_index;
drop index if exists weight_destination_index, weight_index, destination_index;

create index destination_index on shipped_item (destination, weight);
create index destination_index_10 on shipped_item_part_10 (destination, weight);
create index destination_index_101 on shipped_item_part_10 (destination);

SHOW work_mem;
SET work_mem = '1GB';

ALTER TABLE shipped_item
    ALTER COLUMN weight TYPE real
        USING weight::real;

drop table if exists shipped_item_partitioned;
CREATE TABLE shipped_item_partitioned
(
    item_num         serial NOT NULL,
    retail_center_id int,
    weight           real,
    dimension        numeric,
    insurance_amt    numeric,
    destination      varchar(255),
    PRIMARY KEY (item_num, weight)
) PARTITION BY RANGE (weight);


-- Define the partitions based on the weight range
CREATE TABLE shipped_item_part_1 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (0) TO (100);
CREATE TABLE shipped_item_part_2 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (100) TO (200);
CREATE TABLE shipped_item_part_3 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (200) TO (300);
CREATE TABLE shipped_item_part_4 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (300) TO (400);
CREATE TABLE shipped_item_part_5 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (400) TO (500);
CREATE TABLE shipped_item_part_6 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (500) TO (600);
CREATE TABLE shipped_item_part_7 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (600) TO (700);
CREATE TABLE shipped_item_part_8 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (700) TO (800);
CREATE TABLE shipped_item_part_9 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (800) TO (900);
CREATE TABLE shipped_item_part_10 PARTITION OF shipped_item_partitioned
    FOR VALUES FROM (900) TO (1000);



truncate  shipped_item_partitioned;
-- Insert the data from the original table into the partitioned table
INSERT INTO shipped_item_partitioned (item_num, retail_center_id, weight, dimension, insurance_amt, destination)
SELECT item_num,
       retail_center_id,
       weight,
       dimension,
       insurance_amt,
       destination
FROM shipped_item;

create index destination_index on shipped_item_part_10 (destination, weight);

-- Rename the partitioned table to the original table name
ALTER TABLE shipped_item_partitioned
    RENAME TO shipped_item;

rollback;