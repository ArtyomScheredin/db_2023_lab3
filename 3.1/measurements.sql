--Получить размер индексов для всех таблиц
SELECT
    relname AS table_name,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_catalog.pg_index
         JOIN pg_catalog.pg_class ON pg_class.oid = pg_index.indrelid
WHERE pg_class.relkind = 'r';