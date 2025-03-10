import os
import warnings
from pathlib import Path

import pandas as pd

warnings.filterwarnings("ignore")


def from_current_file(path: str) -> Path:
    dirname = os.path.dirname(__file__)
    return Path(os.path.join(dirname, path))


CLEANED_DATA_PATH = from_current_file("../../data/cleaned")
POSTGRES_DATA_PATH = from_current_file("../../data/postgres")


def load_df(name: str) -> pd.DataFrame:
    return pd.read_csv(os.path.join(CLEANED_DATA_PATH, f"{name}.csv"))


def save_df(name: str, dataset: pd.DataFrame):
    if not os.path.exists(POSTGRES_DATA_PATH):
        os.makedirs(POSTGRES_DATA_PATH)

    dataset.to_csv(os.path.join(POSTGRES_DATA_PATH, f"{name}.csv"), index=False)


def generate_postgres():
    campaigns_df = load_df("campaigns")
    client_purchase_df = load_df("client_first_purchase_date")
    events_df = load_df("events")
    friends_df = load_df("friends")
    messages_df = load_df("messages")

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

    # Friends
    print("Building 'friends'...")
    save_df("friends", friends_df)

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

    # Events
    print("Building 'events'...")
    save_df(
        "events",
        events_df.drop(columns=["category_id", "category_code", "brand"]),
    )

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
        messages_df.drop(columns=["id", "email_provider", "user_id", "user_device_id"]),
    )


if __name__ == "__main__":
    generate_postgres()
