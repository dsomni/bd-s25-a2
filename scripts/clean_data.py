import os
import warnings

import numpy as np
import pandas as pd

warnings.filterwarnings("ignore")

INITIAL_DATA_PATH = "./data/initial"
CLEANED_DATA_PATH = "./data/cleaned"


def load_df(name: str) -> pd.DataFrame:
    return pd.read_csv(os.path.join(INITIAL_DATA_PATH, f"{name}.csv"))


def save_df(name: str, dataset: pd.DataFrame):
    if not os.path.exists(CLEANED_DATA_PATH):
        os.makedirs(CLEANED_DATA_PATH)

    dataset.to_csv(os.path.join(CLEANED_DATA_PATH, f"{name}.csv"), index=False)


def clean_campaigns():
    campaigns_df = load_df("campaigns")

    # Convert int columns to int type
    campaigns_int_columns = [
        "total_count",
        "position",
        "hour_limit",
        "subject_length",
    ]

    campaigns_df[campaigns_int_columns] = campaigns_df[campaigns_int_columns].astype(
        pd.Int64Dtype()
    )

    # Convert boolean columns to boolean type
    campaigns_boolean_columns = [
        "ab_test",
        "warmup_mode",
        "subject_with_personalization",
        "subject_with_deadline",
        "subject_with_emoji",
        "subject_with_bonuses",
        "subject_with_discount",
        "subject_with_saleout",
        "is_test",
    ]

    campaigns_df[campaigns_boolean_columns] = campaigns_df[
        campaigns_boolean_columns
    ].astype(bool)

    save_df("campaigns", campaigns_df)


def clean_events():
    events_df = load_df("events")

    # Take as brand the most-common not null brand for each product_id
    events_df["brand"] = events_df.groupby("product_id")["brand"].transform(
        lambda x: x.fillna(
            x.mode(dropna=True)[0] if not x.mode(dropna=True).empty else np.nan
        )
    )

    save_df("events", events_df)


def clean_friends():
    friends_df = load_df("friends")

    # Ensure each pair (friend1, friend2) is unique
    friends_df = pd.DataFrame(
        {
            "friend1": friends_df[["friend1", "friend2"]].min(axis=1),
            "friend2": friends_df[["friend1", "friend2"]].max(axis=1),
        }
    )

    friends_df.drop_duplicates(inplace=True)
    friends_df.reset_index(drop=True, inplace=True)

    save_df("friends", friends_df)


def clean_messages():
    messages_df = load_df("messages")

    # Convert boolean columns to boolean type
    messages_boolean_columns = [
        "is_opened",
        "is_clicked",
        "is_unsubscribed",
        "is_hard_bounced",
        "is_soft_bounced",
        "is_complained",
        "is_blocked",
        "is_purchased",
    ]

    messages_df[messages_boolean_columns] = messages_df[messages_boolean_columns].replace(
        {"t": True, "f": False}
    )

    save_df("messages", messages_df)


def clean_datasets():
    print("Cleaning campaigns...")
    clean_campaigns()
    print("Cleaning events...")
    clean_events()
    print("Cleaning friends...")
    clean_friends()
    print("Cleaning messages...")
    clean_messages()
    print("Done!")


if __name__ == "__main__":
    clean_datasets()
