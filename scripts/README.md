# Scripts Usage & Recipes

Hereafter I assume you, as was suggested, use package manager `uv`. For more information read _Before start_ section in the main `README.md`.

The **crucial assumption** is that initial `f27` dataset already lies in `data/initial` as separate csv files.

All the commands listed below are assumed to be **executed from project root** unless otherwise stated.

## Databases Creation & Loading

To clean the initial data run
`uv run .\scripts\clean_data.py`

The cleaned files now stored in `data/cleaned`.

### MongoDB

To prepare data for import run
`uv run .\scripts\import_preparation\mongo.py`

The prepared files now stored in `data/mongo`.

Then you can load prepared data to MongoDB database `bd-a2` by running
`mongosh --file .\scripts\load_data_mongodb.js`

It will load json data and run aggregations.
**NOTE 1**: It will take some time, as json are quite large
**NOTE 2**: At first, script drops database `bd-a2`

### PostgreSQL

To prepare data for import run
`uv run .\scripts\import_preparation\postgres.py`

The prepared files now stored in `data/postgres`.

Then you can load prepared data to PostgreSQL database `ecommerce` by running
`psql -d ecommerce -U postgres -f scripts/load_data_psql.sql`

**NOTE 1**: On Windows you can run `psql \! chcp 1251` to fix codecs
**NOTE 2**: At first, script drops all related tables from database `ecommerce`

### Neo4j

To prepare data for import run
`uv run .\scripts\import_preparation\neo4j.py`

The prepared files now stored in `data/neo4j`. Now you should put prepared files to [neo4j import directory](https://neo4j.com/docs/operations-manual/current/configuration/file-locations/#neo4j-import). I also recommend to set the following in the database config file `dbms.memory.transaction.total.max=1024m`.

Then you can load prepared data to Neo4j database `neo4j` by running
`cat scripts/load_data_neo4j.cypher | cypher-shell`

Optionally, you can add authentication
`cat scripts/load_data_neo4j.cypher | cypher-shell -u neo4j -p 11111111`

### Optimal Model

To prepare data for import run
`uv run .\scripts\import_preparation\optimal.py`

The prepared files now stored in `data/optimal`. Now you should put prepared files with postfix `_neo4j` to [neo4j import directory](https://neo4j.com/docs/operations-manual/current/configuration/file-locations/#neo4j-import). I also recommend to set the following in the database config file `dbms.memory.transaction.total.max=1024m`.

Load prepared data to PostgreSQL database `ecommerce`:
`psql -d ecommerce -U postgres -f scripts/optimal/load_data_psql.sql`

Load prepared data to MongoDB database `bd-a2-opt`:
`mongosh --file .\scripts\optimal\load_data_mongodb.js`

Load prepared data to Neo4j database `neo4j`:
`cat scripts/optimal/load_data_neo4j.cypher | cypher-shell`

Optionally, you can add authentication
`cat scripts/optimal/load_data_neo4j.cypher | cypher-shell -u neo4j -p 11111111`

## Queries Running

To run queries:
`uv run scripts/run_queries.py`

## Benchmarking

I used [hyperfine](https://github.com/sharkdp/hyperfine) for benchmarking.

Specifications:

- OS: Window 11 10.0.26100
- RAM: 16 Gb
- CPU: Intel(R) Core(TM) i7-8750H @ 2.25GHz
- PSQL version: 16.0
- Neo4j version: 2025.02.0
- MongoDB version: 6.0.5
- Mongosh version: 1.8.0

### PostgreSQL Benchmarking

Use the following commands in git bash:
`hyperfine --warmup 3  --runs 5 "psql -d ecommerce -U postgres -f .\scripts\queries\q1.sql" --style basic`

`hyperfine --warmup 3  --runs 5 "psql -d ecommerce -U postgres -f .\scripts\queries\q2.sql" --style basic`

### MongoDB Benchmarking

`hyperfine --warmup 3  --runs 5 "mongosh --file .\scripts\queries\q1.js" --style basic`

`hyperfine --warmup 3  --runs 5 "mongosh --file .\scripts\queries\q2.js" --style basic`

### Neo4j Benchmarking

Use the following commands in git bash:
`hyperfine --warmup 3  --runs 5 "cat ./scripts/queries/q1.cypher | cypher-shell -u neo4j -p 11111111" --style basic`

`hyperfine --warmup 3 --runs 5 "cat ./scripts/queries/q2.cypher | cypher-shell -u neo4j -p 11111111" --style basic`
