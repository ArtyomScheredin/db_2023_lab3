--Актеры, имеющие более 1000 ролей
SELECT *
FROM actors
WHERE jsonb_array_length(actors.rolesname -> 'roles') > 1000;

--актеры с наименьшим числом ролей
SELECT * FROM actors
ORDER BY jsonb_array_length(actors.rolesname->'roles') LIMIT 5;

--5 записей, уходящих в toast (самый большой размер поля rolesname)
SELECT id, pg_column_size(rolesname)
FROM actors
WHERE pg_column_size(rolesname) > 2048
ORDER BY pg_column_size(rolesname) DESC
LIMIT 5;

--есть камео
SELECT DISTINCT id, first_name, last_name, role
FROM (SELECT id,
             actors.rolesname ->> 'first_name'          as first_name,
             actors.rolesname ->> 'last_name'           as last_name,
             jsonb_array_elements(rolesname -> 'roles') as role
      FROM actors) AS a
WHERE a.role ->> 'role' = 'Himself'
   OR a.role ->> 'role' = 'Themselves'
   OR a.role - >>'role' = 'Herself';

--всех актеров, которые снимались в одном фильме/сериале --title "1000 Ways to Die"
SELECT DISTINCT id, first_name, last_name
FROM (SELECT id,
             actors.rolesname ->> 'first_name'          as first_name,
             actors.rolesname ->> 'last_name'           as last_name,
             jsonb_array_elements(rolesname -> 'roles') as role
      FROM actors) AS a
WHERE a.role ->> 'title' = '1000 Ways to Die';

--снимались как минимум в одном сериале
SELECT DISTINCT id, first_name, last_name
FROM (SELECT id,
             actors.rolesname ->> 'first_name'          as first_name,
             actors.rolesname ->> 'last_name'           as last_name,
             jsonb_array_elements(rolesname -> 'roles') as role
      FROM actors
      LIMIT 1000) AS a
WHERE a.role ?| array ['ep_num', 'ep_name', 'ep_season'];

--актер и дата начала его карьеры
SELECT DISTINCT id, a.first_name, a.last_name, MIN((a.role ->> 'year')::int)
FROM (SELECT id,
             actors.rolesname ->> 'first_name'          as first_name,
             actors.rolesname ->> 'last_name'           as last_name,
             jsonb_array_elements(rolesname -> 'roles') as role
      FROM actors) AS a
GROUP BY id, a.first_name, a.last_name;