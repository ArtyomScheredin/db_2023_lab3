drop table if exists actors;
CREATE TABLE IF NOT EXISTS actors
(
    id   SERIAL PRIMARY KEY,
    ActorName text,
    RolesName jsonb
);

truncate table actors;