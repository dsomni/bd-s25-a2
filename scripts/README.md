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
