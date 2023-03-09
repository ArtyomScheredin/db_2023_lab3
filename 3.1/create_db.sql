begin;
create table if not exists retail_center
(
    id      serial primary key,
    type    varchar(255),
    address varchar(255)
);

create table if not exists shipped_item
(
    item_num         serial primary key,
    retail_center_id int references retail_center,
    weight           numeric,
    dimension        numeric,
    insurance_amt    numeric,
    destination      varchar(255)
);

create table if not exists transportation_event
(
    seq_number    serial primary key,
    type          varchar(255),
    delivery_rout varchar(255)
);

create table if not exists item_transportation
(
    transportation_event_seq_number int references retail_center,
    shipped_item_item_num           int references shipped_item,
    primary key (transportation_event_seq_number, shipped_item_item_num)
);
end;
