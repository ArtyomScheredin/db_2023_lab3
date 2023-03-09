
begin;
create extension if not exists plpython3u;
select extname
from pg_extension;

create or replace procedure fill_retail_center() as
$$
    import decimal
    import numpy as np
    def gen_random_decimal(i,d):
     return decimal.Decimal('%d.%d' % (np.random.randint(0,i), np.random.randint(0,d)))
    vocab = ['some','senseless','words','that','I','have','just','come','up','with']
    plan = plpy.prepare('insert into retail_center(type, address) values ($1, $2)', ['varchar(255)', 'varchar(255)'])
    for i in range(1,100):
     plpy.execute(plan, [vocab[np.random.randint(0, len(vocab)-1)], vocab[np.random.randint(0,len(vocab)-1)]])
    return $$ language plpython3u;

call fill_retail_center();
select * from retail_center;

create or replace procedure fill_shipped_item()
as $$
    import decimal
    import numpy as np
    def gen_random_decimal(i,d):
        return decimal.Decimal('%d.%d' % (np.random.randint(0,i), np.random.randint(0,d)))
    vocab = ['some','senseless','words','that','I','have','just','come','up','with']
    plan = plpy.prepare('insert into shipped_item (retail_center_id, weight, dimension, insurance_amt, destination) values ($1,$2,$3,$4,$5)',
    ['int','numeric','numeric','numeric','varchar(255)'])
    for i in range(1,1000000):
        plpy.execute(plan, [np.random.randint(1,100), gen_random_decimal(999,999),
    gen_random_decimal(999,999), gen_random_decimal(999,999), vocab[np.random.randint(0, len(vocab)-1)]])
    $$ language plpython3u;


call fill_shipped_item();
select * from shipped_item;
create or replace procedure fill_transportation_event()
as $$
    import numpy as np
    plan = plpy.prepare('insert into item_transportation (transportation_event_seq_number, shipped_item_item_num) values ($1,$2)',['int','int'])
    for i in range(1,10000000):
        try:
            plpy.execute(plan, [np.random.randint(1,100), np.random.randint(1,1000000)])
        except plpy.SPIError:
            continue
    $$ language plpython3u;

call fill_transportation_event();
SELECT * FROM item_transportation limit 100;

end;