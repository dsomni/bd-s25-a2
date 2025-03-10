import os
import warnings
from pathlib import Path

import pandas as pd

warnings.filterwarnings("ignore")


def from_current_file(path: str) -> Path:
    dirname = os.path.dirname(__file__)
    return Path(os.path.join(dirname, path))


CLEANED_DATA_PATH = from_current_file("../../data/cleaned")
OPTIMAL_DATA_PATH = from_current_file("../../data/optimal")


def load_df(name: str) -> pd.DataFrame:
    return pd.read_csv(os.path.join(CLEANED_DATA_PATH, f"{name}.csv"))


def save_df(name: str, dataset: pd.DataFrame):
    if not os.path.exists(OPTIMAL_DATA_PATH):
        os.makedirs(OPTIMAL_DATA_PATH)

    dataset.to_csv(os.path.join(OPTIMAL_DATA_PATH, f"{name}.csv"), index=False)


def save_df_json(name: str, dataset: pd.DataFrame):
    if not os.path.exists(OPTIMAL_DATA_PATH):
        os.makedirs(OPTIMAL_DATA_PATH)

    dataset.to_json(
        os.path.join(OPTIMAL_DATA_PATH, f"{name}.json"),
        index=False,
        orient="records",
        lines=True,
    )


def generate_hybrid():
    campaigns_df = load_df("campaigns")
    client_purchase_df = load_df("client_first_purchase_date")
    events_df = load_df("events")
    friends_df = load_df("friends")
    messages_df = load_df("messages")

    events_df["event_id"] = events_df.index
    events_df["event_id"] = events_df["event_id"].astype(str)

    # Postgres
    # --------------------------------------------------
    # Products
    print("Building 'products_postgres'...")
    products_df = (
        events_df[["product_id", "category_id", "category_code", "brand", "price"]]
        .drop_duplicates()
        .groupby(["product_id"], as_index=False)
        .agg(
            {
                "brand": "first",
                "price": "first",
                "category_id": "first",
                "category_code": "first",
            }
        )
    )
    save_df(
        "products_postgres",
        products_df,
    )

    # Clients
    print("Building 'clients_postgres'...")
    clients_df = (
        pd.merge(
            client_purchase_df,
            messages_df[
                ["client_id", "user_id", "user_device_id", "email_provider"]
            ].drop_duplicates(),
            on=["client_id", "user_id", "user_device_id"],
            how="outer",
        )
        .groupby(["client_id", "user_id", "user_device_id"], as_index=False)
        .agg({"first_purchase_date": "first", "email_provider": "first"})
    )
    save_df(
        "clients_postgres",
        clients_df,
    )

    # Campaign
    print("Building 'campaigns_postgres'...")
    save_df(
        "campaigns_postgres",
        campaigns_df.rename(columns={"id": "campaign_id"})[
            [
                "campaign_id",
                "campaign_type",
                "channel",
                "topic",
                "started_at",
                "finished_at",
                "total_count",
            ]
        ].astype(
            {
                "total_count": pd.Int64Dtype(),
                "campaign_id": str,
            }
        ),
    )

    # Messages
    print("Building 'messages_postgres'...")
    save_df(
        "messages_postgres",
        messages_df[
            [
                "message_id",
                "campaign_id",
                "message_type",
                "client_id",
                "channel",
                "category",
                "date",
                "sent_at",
            ]
        ].astype(
            {
                "campaign_id": str,
            }
        ),
    )

    # --------------------------------------------------

    # MongoDB
    # --------------------------------------------------

    # Campaign
    print("Preparing 'campaigns_mongo'...")
    campaigns_df["campaign_id"] = campaigns_df["id"].astype(str)
    campaigns_df.drop(
        columns=[
            "id",
            "channel",
            "topic",
            "started_at",
            "finished_at",
            "total_count",
        ],
        inplace=True,
    )
    save_df_json("campaigns_mongo", campaigns_df)

    # Events
    print("Preparing 'events_mongo'...")
    save_df_json(
        "events_mongo",
        events_df[["event_id", "event_time", "event_type", "price"]],
    )

    # Messages
    print("Preparing 'messages_mongo'...")
    messages_to_str_columns = ["client_id", "campaign_id", "user_id"]
    messages_df[messages_to_str_columns] = messages_df[messages_to_str_columns].astype(
        str
    )
    save_df_json(
        "messages_mongo",
        messages_df.drop(
            columns=[
                "campaign_id",
                "client_id",
                "channel",
                "category",
                "date",
                "sent_at",
            ]
        ),
    )

    # --------------------------------------------------

    # Neo4j
    # --------------------------------------------------

    # NODES

    # Products
    print("Building 'products_neo4j'...")
    save_df("products_neo4j", products_df[["product_id"]])

    # Clients
    print("Building 'clients_neo4j'...")

    save_df("clients_neo4j", clients_df[["client_id"]])

    # Users
    print("Building 'users_neo4j'...")
    users_df = pd.DataFrame(
        {
            "user_id": pd.concat(
                [
                    client_purchase_df["user_id"],
                    events_df["user_id"],
                    messages_df["user_id"],
                    friends_df["friend1"],
                    friends_df["friend2"],
                ],
                ignore_index=True,
            ).drop_duplicates(ignore_index=True)
        }
    )
    save_df(
        "users_neo4j",
        users_df,
    )

    # RELATIONS

    # FRIENDS_WITH
    print("Building 'friends_neo4j'...")
    save_df("friends_neo4j", friends_df)

    # BELONGS_TO
    print("Building 'belongs_to_neo4j'...")
    save_df(
        "belongs_to_neo4j",
        client_purchase_df[
            [
                "client_id",
                "user_id",
            ]
        ],
    )

    # Events
    for event_type in [
        "view",
        "cart",
        "purchase",
    ]:
        print(f"Building '{event_type}_neo4j'...")
        type_df = events_df[["user_id", "product_id", "event_type", "event_id"]][
            events_df["event_type"] == event_type
        ].drop(columns=["event_type"])
        save_df(
            f"{event_type}_neo4j",
            type_df,
        )


if __name__ == "__main__":
    generate_hybrid()
