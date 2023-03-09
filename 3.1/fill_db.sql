CREATE OR REPLACE PROCEDURE fill_retail_center()
AS $$
     import decimal
     import numpy as np
     def gen_random_decimal(i,d):
           return decimal.Decimal('%d.%d' % (np.random.randint(0,i),
np.random.randint(0,d)))
     vocab = ['some', 'words', 'in', 'vocabulary', 'that', 'do',
'not', 'make', 'sense']
     plan = plpy.prepare('INSERT INTO retail_center(type, address) VALUES ($1, $2)', ['varchar(255)', 'varchar(255)'])
     for i in range(1, 100):
           plpy.execute(plan, [vocab[np.random.randint(0, len(vocab)-
1)], vocab[np.random.randint(0, len(vocab)-1)]])
$$ LANGUAGE plpython3u;
CALL fill_retail_center();
SELECT * FROM retail_center;
CREATE OR REPLACE PROCEDURE fill_shipped_item()
AS $$
     import decimal
     import numpy as np
     def gen_random_decimal(i,d):
           return decimal.Decimal('%d.%d' % (np.random.randint(0,i),
np.random.randint(0,d)))
     vocab = ['some', 'words', 'in', 'vocabulary', 'that', 'do',
'not', 'make', 'sense']
     plan = plpy.prepare('INSERT INTO shipped_item (retail_center_id, weight, dimension, insurance_amt, destination) VALUES ($1, $2, $3, $4, $5)', ['int', 'numeric', 'numeric',
'numeric', 'varchar(255)'])
     for i in range(1000000, 10000000):
           plpy.execute(plan, [np.random.randint(1, 100),
gen_random_decimal(999, 999), gen_random_decimal(999, 999),
gen_random_decimal(999, 999), vocab[np.random.randint(0, len(vocab)-
1)]])
$$ LANGUAGE plpython3u;
CALL fill_shipped_item();
SELECT count(*) FROM shipped_item;

CREATE OR REPLACE PROCEDURE fill_transportation_event()
AS $$
     import decimal
     import numpy as np
     def gen_random_decimal(i,d):
           return decimal.Decimal('%d.%d' % (np.random.randint(0,i),
np.random.randint(0,d)))
     vocab = ['some', 'words', 'in', 'vocabulary', 'that', 'do',
'not', 'make', 'sense']
     plan = plpy.prepare('INSERT INTO transportation_event (type,delivery_rout) VALUES ($1, $2)', ['varchar(255)','varchar(255)'])
     for i in range(1, 10):
           plpy.execute(plan, [vocab[np.random.randint(0, len(vocab)-1)], vocab[np.random.randint(0, len(vocab)-1)]])
$$ LANGUAGE plpython3u;
CALL fill_transportation_event();

SELECT count(*) FROM transportation_event;
CREATE OR REPLACE PROCEDURE fill_item_transportation()
AS $$
     import numpy as np
     plan = plpy.prepare('INSERT INTO item_transportation (transportation_event_seq_number, shipped_item_item_num) VALUES ($1,$2)', ['int','int'])
     for i in range(1, 1000000):
           try:
                plpy.execute(plan, [np.random.randint(1, 10),
np.random.randint(1, 1000000)])
           except plpy.SPIError:
                continue
$$ LANGUAGE plpython3u;
CALL fill_item_transportation();
SELECT count(*) FROM item_transportation;