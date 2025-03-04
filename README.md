# Big Data IU-S25 Assignment 2

by Dmitry Beresnev / <d.beresnev@innopolis.university>

## Projects description

The company is struggling with three big data issues:

- Volume: large amounts of data per day.
- Variety: Social network data, user behavior events, and campaign messages.
- Value: Analyzing customer social networks for targeted marketing.

The primary objective of this assignment is to design a big data solution to store petabytes (the provided dataset is only a snapshot) of raw data using effective, optimal and scalable data models that can handle growth and complexity without compromising quality, efficiency, or usability. The optimal design will enable analytics and transactions for real-time and batch data processing. Your task is to find the best data model for storing the big data and obtaining valuable insights from it by following the tasks below.

## Requirements

The **main assumption** is that initial `f27` dataset already lies in `data/initial` as separate csv files.

Code was tested on Windows 11, Python 3.12

## Before start

I recommend using [uv](https://docs.astral.sh/uv/) packet manager for python.
You can start with `uv sync`.

Optionally, you can run `bash setup_precommit.sh` to setup pre-commit hook for GitHub for code formatting using [ruff](https://docs.astral.sh/ruff/).

## Repository structure

```text
├── data                # Data used in project
├───── initial          # Initial `f27` dataset data
├──────── *.csv
|
├── data_models         # Hackolade data models
|
├── notebooks           # Auxiliary jupiter notebooks for getting insights
|
├── output              # Folder to store the results of the experiments
|
├── references          # Reference papers etc.
|
├── report
├───── report.pdf       # Final report
|
├── screenshots         # Folder to store the screenshots
|
├── scripts             # Folder to store all types of scripts and queries
├───── *.sql            # SQL queries
├───── *.js             # MongoDB queries
├───── *.cypher         # Neo4J queries
|
├── README.md           # The top-level README
|
└──
```

## Scripts Run

I suggest to run scripts using `uv` from root folder, otherwise inner paths could break:

`uv run ./scripts/<script_name>.py`

## Useful commands

`psql -d ecommerce -U postgres -f scripts/load_data_psql.sql`

## Contacts

In case of any questions you can contact me via university email at the beginning
