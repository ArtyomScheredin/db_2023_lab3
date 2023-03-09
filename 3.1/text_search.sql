explain analyze select destination from  shipped_item
where to_tsvector('english', destination) @@ to_tsquery('english', 'word')
order by retail_center_id
limit 30;

drop index if exists destination_index_my;
create index destination_index_my on shipped_item using  gin
    (to_tsvector('english', destination));

analyse shipped_item;