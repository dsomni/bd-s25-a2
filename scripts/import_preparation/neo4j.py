import os
import warnings
from pathlib import Path

import pandas as pd

warnings.filterwarnings("ignore")


def from_current_file(path: str) -> Path:
    dirname = os.path.dirname(__file__)
    return Path(os.path.join(dirname, path))


CLEANED_DATA_PATH = from_current_file("../../data/cleaned")
NEO4J_DATA_PATH = from_current_file("../../data/neo4j")


def load_df(name: str) -> pd.DataFrame:
    return pd.read_csv(os.path.join(CLEANED_DATA_PATH, f"{name}.csv"))


def save_df(name: str, dataset: pd.DataFrame):
    if not os.path.exists(NEO4J_DATA_PATH):
        os.makedirs(NEO4J_DATA_PATH)

    dataset.to_csv(os.path.join(NEO4J_DATA_PATH, f"{name}.csv"), index=False)


def generate_neo4j():
    campaigns_df = load_df("campaigns")
    client_purchase_df = load_df("client_first_purchase_date")
    events_df = load_df("events")
    friends_df = load_df("friends")
    messages_df = load_df("messages")

    # NODES

    # Products
    print("Building 'products'...")
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
    save_df("products", products_df)

    # Clients
    print("Building 'clients'...")
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
    save_df("clients", clients_df)

    # Campaign
    print("Building 'campaigns'...")
    save_df(
        "campaigns",
        campaigns_df.rename(columns={"id": "campaign_id"}).astype(
            {
                int_column: pd.Int64Dtype()
                for int_column in [
                    "total_count",
                    "position",
                    "hour_limit",
                    "subject_length",
                ]
            }
        ),
    )

    # Messages
    print("Building 'messages'...")
    save_df(
        "messages",
        messages_df.drop(
            columns=[
                "id",
                "email_provider",
                "user_id",
                "user_device_id",
                "campaign_id",
                "client_id",
                "sent_at",
            ]
        ),
    )

    # Users
    print("Building 'users'...")
    save_df(
        "users",
        pd.DataFrame(
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
        ),
    )

    # RELATIONS

    # FRIENDS_WITH
    print("Building 'friends'...")
    save_df("friends", friends_df)

    # RECEIVED
    print("Building 'received'...")
    save_df("received", messages_df[["message_id", "client_id"]])

    # SENT_AT
    print("Building 'sent_from'...")
    save_df(
        "sent_from",
        messages_df[["message_id", "campaign_id", "sent_at"]],
    )

    # BELONGS_TO
    print("Building 'belongs_to'...")
    save_df(
        "belongs_to",
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
        print(f"Building '{event_type}'...")
        type_df = events_df[
            ["user_id", "product_id", "event_type", "price", "user_session", "event_time"]
        ][events_df["event_type"] == event_type].drop(columns=["event_type"])
        save_df(
            event_type,
            type_df,
        )


if __name__ == "__main__":
    generate_neo4j()
