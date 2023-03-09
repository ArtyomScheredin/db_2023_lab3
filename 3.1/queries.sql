begin;

--A
explain select *
        from item_transportation
        where item_transportation.transportation_event_seq_number >= 6
          and item_transportation.shipped_item_item_num between 50 and 2000;

explain (analyse, buffers) select *
        from item_transportation
        where item_transportation.transportation_event_seq_number >= 6
          and item_transportation.shipped_item_item_num between 50 and 2000;

--B
explain select * from item_transportation join shipped_item si
                                               on item_transportation.shipped_item_item_num = si.item_num
        where transportation_event_seq_number >= 10 and destination='have';

explain (analyse, buffers) select * from item_transportation join shipped_item si
                                                       on item_transportation.shipped_item_item_num = si.item_num
                where transportation_event_seq_number >= 10 and destination='have';

select *
from pg_indexes
where tablename not like 'pg%';

drop index if exists shipped_item_item_num_index, item_num_index, transportation_event_seq_number_index, destination_index;

create index shipped_item_item_num_index on item_transportation (shipped_item_item_num);

create index item_num_index on shipped_item (item_num);

create index transportation_event_seq_number_index on item_transportation (transportation_event_seq_number);

create index destination_index on shipped_item (destination);

rollback;