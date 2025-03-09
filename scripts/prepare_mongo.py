import os
import warnings

import pandas as pd

warnings.filterwarnings("ignore")

CLEANED_DATA_PATH = "./data/cleaned"
MONGO_DATA_PATH = "./data/mongo"


def load_df(name: str) -> pd.DataFrame:
    return pd.read_csv(os.path.join(CLEANED_DATA_PATH, f"{name}.csv"))


def save_df_json(name: str, dataset: pd.DataFrame):
    if not os.path.exists(MONGO_DATA_PATH):
        os.makedirs(MONGO_DATA_PATH)

    dataset.to_json(
        os.path.join(MONGO_DATA_PATH, f"{name}.json"),
        index=False,
        orient="records",
        lines=True,
    )


def generate_mongo():
    campaigns_df = load_df("campaigns")
    client_purchase_df = load_df("client_first_purchase_date")
    events_df = load_df("events")
    friends_df = load_df("friends")
    messages_df = load_df("messages")

    # Campaign
    print("Preparing campaigns...")
    campaigns_df["campaign_id"] = campaigns_df["id"].astype(str)
    campaigns_df.drop(columns=["id"], inplace=True)
    save_df_json("campaigns", campaigns_df)

    # Clients
    print("Preparing clients...")
    clients_to_str_columns = ["client_id", "user_id"]
    client_purchase_df[clients_to_str_columns] = client_purchase_df[
        clients_to_str_columns
    ].astype(str)
    save_df_json("client_first_purchase_date", client_purchase_df)

    # Events
    print("Preparing events...")
    events_to_str_columns = ["product_id", "category_id", "user_id"]
    events_df[events_to_str_columns] = events_df[events_to_str_columns].astype(str)
    save_df_json("events", events_df)

    # Friends
    print("Preparing friends...")
    friends_to_str_columns = ["friend1", "friend2"]
    friends_df[friends_to_str_columns] = friends_df[friends_to_str_columns].astype(str)
    save_df_json("friends", friends_df)

    # Messages
    print("Preparing messages...")
    messages_to_str_columns = ["client_id", "campaign_id", "user_id"]
    messages_df[messages_to_str_columns] = messages_df[messages_to_str_columns].astype(
        str
    )
    save_df_json("messages", messages_df)


if __name__ == "__main__":
    generate_mongo()
