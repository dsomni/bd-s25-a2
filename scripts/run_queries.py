import json
import os
import warnings
from pathlib import Path
from typing import Literal

import psycopg2
from neo4j import GraphDatabase
from pymongo import MongoClient

warnings.filterwarnings("ignore")


def from_current_file(path: str) -> Path:
    dirname = os.path.dirname(__file__)
    return Path(os.path.join(dirname, path))


QUERY_PATH = from_current_file("./queries")


def load_query(name: str) -> str:
    with open(os.path.join(QUERY_PATH, name), "r") as file:
        return file.read()


def execute_postgres(query_name: str):
    with psycopg2.connect(
        dbname="ecommerce",
        user="postgres",
    ) as conn:
        with conn.cursor() as cursor:
            query = load_query(f"{query_name}.sql")
            cursor.execute(query)
            return cursor.fetchall()


def execute_mongo(
    query_name: str,
    collection_name: str,
    action: Literal["find", "aggregate"] = "aggregate",
):
    with MongoClient("mongodb://localhost:27017/") as client:
        collection = client["bd-a2"][collection_name]
        query = json.loads(load_query(f"{query_name}.json"))
        if action == "aggregate":
            return list(collection.aggregate(query))
        if action == "find":
            return collection.find(query)


def execute_neo4j(query_name: str):
    with GraphDatabase.driver(
        "bolt://localhost:7687/neo4j", auth=("neo4j", "11111111")
    ) as driver:
        with driver.session() as session:
            query = load_query(f"{query_name}.cypher")
            results = session.run(query)  # type: ignore
            return list(results)


def execute_q1() -> float:
    postgres_res = execute_postgres("q1")
    mongo_res = execute_mongo("q1", "campaigns")
    neo4j_res = execute_neo4j("q1")

    postgres_res_float = postgres_res[0][0]
    mongo_res_float = mongo_res[0]["purchase_ratio"]
    neo4j_res_float = neo4j_res[0]["purchase_ratio"]

    assert postgres_res_float == mongo_res_float == neo4j_res_float

    return postgres_res_float


# For user 563016948
def execute_q2() -> list[int]:
    postgres_res = execute_postgres("q2")
    mongo_res = execute_mongo("q2", "users")
    neo4j_res = execute_neo4j("q2")

    postgres_res_list = [x[0] for x in postgres_res]
    mongo_res_list = [int(x["_id"]) for x in mongo_res]
    neo4j_res_list = [x["p.product_id"] for x in neo4j_res]

    assert postgres_res_list == mongo_res_list == neo4j_res_list

    return postgres_res_list


if __name__ == "__main__":
    print("Running Q1...")
    purchase_personalization_ratio = execute_q1()
    print(f"{purchase_personalization_ratio=}")

    print("\nRunning Q2...")
    popular_products = execute_q2()
    print(f"{popular_products=}")
