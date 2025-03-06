var db_name = "bd-a2";
db = connect(`mongodb://localhost/${db_name}`);

db.dropDatabase(); // TODO Remove this!

db.createCollection("campaigns", {
  capped: false,
  validator: {
    $jsonSchema: {
      bsonType: "object",
      title: "campaigns",
      properties: {
        _id: {
          bsonType: "objectId",
        },
        campaign_id: {
          bsonType: "number",
        },
        campaign_type: {
          bsonType: "string",
        },
        channel: {
          bsonType: "string",
        },
        topic: {
          bsonType: "string",
        },
        started_at: {
          bsonType: "date",
        },
        finished_at: {
          bsonType: "date",
        },
        total_count: {
          bsonType: "number",
        },
        ab_test: {
          bsonType: "bool",
        },
        warmup_mode: {
          bsonType: "bool",
        },
        hour_limit: {
          bsonType: "number",
        },
        subject: {
          bsonType: "object",
          properties: {
            length: {
              bsonType: "number",
            },
            with_personalization: {
              bsonType: "bool",
            },
            with_deadline: {
              bsonType: "bool",
            },
            with_emoji: {
              bsonType: "bool",
            },
            with_bonuses: {
              bsonType: "bool",
            },
            with_discount: {
              bsonType: "bool",
            },
            with_saleout: {
              bsonType: "bool",
            },
          },
          additionalProperties: false,
        },
        is_test: {
          bsonType: "bool",
        },
        position: {
          bsonType: "number",
        },
      },
      additionalProperties: false,
    },
  },
  validationLevel: "off",
  validationAction: "warn",
});

db.campaigns.createIndex(
  {
    campaign_id: 1,
    campaign_type: 1,
  },
  {
    name: "id_typeunique_",
    unique: true,
  }
);

db.createCollection("messages", {
  capped: false,
  validator: {
    $jsonSchema: {
      bsonType: "object",
      title: "messages",
      properties: {
        _id: {
          bsonType: "objectId",
        },
        message_id: {
          bsonType: "string",
        },
        campaign_id: {
          bsonType: "number",
        },
        client_id: {
          bsonType: "number",
        },
        message_type: {
          bsonType: "string",
        },
        channel: {
          bsonType: "string",
        },
        category: {
          bsonType: "string",
        },
        device: {
          bsonType: "object",
          properties: {
            platform: {
              bsonType: "string",
            },
            stream: {
              bsonType: "string",
            },
          },
          additionalProperties: false,
        },
        date: {
          bsonType: "date",
        },
        sent_at: {
          bsonType: "date",
        },
        is_opened: {
          bsonType: "bool",
        },
        opened_first_time_at: {
          bsonType: "date",
        },
        opened_last_time_at: {
          bsonType: "date",
        },
        is_clicked: {
          bsonType: "bool",
        },
        clicked_first_time_at: {
          bsonType: "date",
        },
        clicked_last_time_at: {
          bsonType: "date",
        },
        is_unsubscribe: {
          bsonType: "bool",
        },
        unsubscribed_at: {
          bsonType: "date",
        },
        is_hard_bounced: {
          bsonType: "bool",
        },
        hard_bounced_at: {
          bsonType: "date",
        },
        is_soft_bounced: {
          bsonType: "bool",
        },
        soft_bounced_at: {
          bsonType: "date",
        },
        is_complained: {
          bsonType: "bool",
        },
        is_blocked: {
          bsonType: "bool",
        },
        blocked_at: {
          bsonType: "date",
        },
        is_purchased: {
          bsonType: "bool",
        },
        purchased_at: {
          bsonType: "date",
        },
        created_at: {
          bsonType: "date",
        },
        updated_at: {
          bsonType: "date",
        },
      },
      additionalProperties: false,
    },
  },
  validationLevel: "off",
  validationAction: "warn",
});

db.messages.createIndex(
  {
    message_id: 1,
  },
  {
    name: "unique_message_id",
    unique: true,
  }
);

db.createCollection("users", {
  capped: false,
  validator: {
    $jsonSchema: {
      bsonType: "object",
      title: "users",
      properties: {
        _id: {
          bsonType: "objectId",
        },
        user_id: {
          bsonType: "number",
        },
        friends: {
          bsonType: "array",
          additionalItems: true,
          items: {
            bsonType: "number",
          },
        },
        events: {
          bsonType: "array",
          additionalItems: true,
          items: {
            bsonType: "object",
            properties: {
              event_time: {
                bsonType: "date",
              },
              event_type: {
                bsonType: "string",
              },
              product_id: {
                bsonType: "number",
              },
              price: {
                bsonType: "number",
              },
              user_session: {
                bsonType: "string",
              },
            },
            additionalProperties: false,
          },
        },
      },
      additionalProperties: false,
    },
  },
  validationLevel: "off",
  validationAction: "warn",
});

db.users.createIndex(
  {
    user_id: 1,
  },
  {
    name: "unique_user",
    unique: true,
  }
);

db.createCollection("products", {
  capped: false,
  validator: {
    $jsonSchema: {
      bsonType: "object",
      title: "products",
      properties: {
        _id: {
          bsonType: "objectId",
        },
        product_id: {
          bsonType: "number",
        },
        category: {
          bsonType: "object",
          properties: {
            category_id: {
              bsonType: "number",
            },
            category_code: {
              bsonType: "string",
            },
          },
          additionalProperties: false,
        },
        brand: {
          bsonType: "string",
        },
        price: {
          bsonType: "number",
        },
      },
      additionalProperties: false,
    },
  },
  validationLevel: "off",
  validationAction: "warn",
});

db.products.createIndex(
  {
    product_id: 1,
  },
  {
    name: "unique_product",
    unique: true,
  }
);

db.createCollection("clients", {
  capped: false,
  validator: {
    $jsonSchema: {
      bsonType: "object",
      title: "clients",
      properties: {
        _id: {
          bsonType: "objectId",
        },
        client_id: {
          bsonType: "number",
        },
        first_purchase_date: {
          bsonType: "date",
        },
        user_id: {
          bsonType: "number",
        },
        user_device_id: {
          bsonType: "number",
        },
        email_provider: {
          bsonType: "string",
        },
      },
      additionalProperties: false,
    },
  },
  validationLevel: "off",
  validationAction: "warn",
});

db.clients.createIndex(
  {
    client_id: 1,
  },
  {
    name: "unique_client",
    unique: true,
  }
);
var exec = require("child_process").execSync;

exec(
  `mongoimport -d ${db_name} -c campaigns_temp --file ./data/mongo/campaigns.json`
);
exec(
  `mongoimport -d ${db_name} -c client_first_purchase_date_temp --file ./data/mongo/client_first_purchase_date.json`
);
exec(
  `mongoimport -d ${db_name} -c events_temp --file ./data/mongo/events.json`
);
exec(
  `mongoimport -d ${db_name} -c friends_temp --file ./data/mongo/friends.json`
);
exec(
  `mongoimport -d ${db_name} -c messages_temp --file ./data/mongo/messages.json`
);

db.campaigns_temp.createIndex(
  {
    id: 1,
    campaign_type: 1,
  },
  {
    name: "unique_id",
    unique: true,
  }
);

db.client_first_purchase_date_temp.createIndex(
  {
    client_id: 1,
  },
  {
    name: "unique_client",
    unique: true,
  }
);

db.client_first_purchase_date_temp.createIndex(
  {
    user_id: 1,
  },
  {
    name: "user_id",
  }
);

db.events_temp.createIndex(
  {
    user_id: 1,
  },
  {
    name: "user_id",
  }
);

db.events_temp.createIndex(
  {
    product_id: 1,
  },
  {
    name: "product_id",
  }
);

db.friends_temp.createIndex(
  {
    friend1: 1,
  },
  {
    name: "friend1",
  }
);

db.friends_temp.createIndex(
  {
    friend2: 1,
  },
  {
    name: "friend2",
  }
);

db.messages_temp.createIndex(
  {
    client_id: 1,
  },
  {
    name: "client_id",
  }
);

console.log("Start building 'clients'...");
db.client_first_purchase_date_temp.aggregate([
  {
    $project: {
      _id: 0,
      client_id: 1,
      user_id: 1,
      user_device_id: 1,
      first_purchase_date: {
        $toDate: "$first_purchase_date",
      },
    },
  },

  {
    $lookup: {
      from: "messages_temp",
      localField: "client_id",
      foreignField: "client_id",
      as: "email_provider",
      pipeline: [
        {
          $project: {
            _id: 0,
            email_provider: 1,
          },
        },
      ],
    },
  },
  {
    $set: {
      email_provider: {
        $first: "$email_provider",
      },
    },
  },
  {
    $set: {
      email_provider: "$email_provider.email_provider",
    },
  },
  {
    $unionWith: {
      coll: "messages_temp",
      pipeline: [
        {
          $project: {
            _id: 0,
            client_id: 1,
            user_id: 1,
            user_device_id: 1,
            email_provider: 1,
          },
        },
      ],
    },
  },
  {
    $group: {
      _id: "$client_id",
      doc: { $first: "$$ROOT" },
    },
  },
  { $replaceRoot: { newRoot: "$doc" } },
  {
    $merge: {
      into: "clients",
    },
  },
]);
console.log("Finish building 'clients'!");

console.log("Start building 'products'...");
db.events_temp.aggregate([
  {
    $project: {
      _id: 0,
      product_id: 1,
      category: {
        category_id: "$category_id",
        category_code: "$category_code",
      },
      brand: 1,
      price: 1,
    },
  },
  {
    $group: {
      _id: "$product_id",
      doc: { $first: "$$ROOT" },
    },
  },
  { $replaceRoot: { newRoot: "$doc" } },
  {
    $merge: {
      into: "products",
    },
  },
]);
console.log("Finish building 'products'!");

console.log("Start building 'users'...");
db.clients.aggregate([
  {
    $project: {
      _id: 0,
      user_id: 1,
    },
  },
  {
    $group: {
      _id: "$user_id",
    },
  },
  {
    $project: {
      _id: 0,
      user_id: "$_id",
    },
  },
  {
    $lookup: {
      from: "events_temp",
      localField: "user_id",
      foreignField: "user_id",
      as: "events",
      pipeline: [
        {
          $project: {
            _id: 0,
            event_time: 1,
            event_type: 1,
            price: 1,
            product_id: 1,
            user_session: 1,
          },
        },
      ],
    },
  },
  {
    $lookup: {
      from: "friends_temp",
      localField: "user_id",
      foreignField: "friend1",
      as: "friends1",
      pipeline: [
        {
          $project: {
            _id: 0,
            friend2: 1,
          },
        },
      ],
    },
  },
  {
    $lookup: {
      from: "friends_temp",
      localField: "user_id",
      foreignField: "friend2",
      as: "friends2",
      pipeline: [
        {
          $project: {
            _id: 0,
            friend1: 1,
          },
        },
      ],
    },
  },
  { $set: { friends1: "$friends1.friend1" } },
  { $set: { friends2: "$friends2.friend2" } },
  {
    $set: {
      friends: {
        $concatArrays: ["$friends1", "$friends2"],
      },
    },
  },

  {
    $set: {
      friends: { $setUnion: ["$friends"] },
    },
  },
  {
    $project: {
      user_id: 1,
      events: 1,
      friends: 1,
    },
  },
  {
    $merge: {
      into: "users",
    },
  },
]);
console.log("Finish building 'users'!");

console.log("Start building 'campaigns'...");
db.campaigns_temp.aggregate([
  {
    $project: {
      campaign_id: "$id",
      campaign_type: 1,
      channel: 1,
      topic: 1,
      started_at: { $toDate: "$started_at" },
      finished_at: { $toDate: "$finished_at" },
      ab_test: 1,
      warmup_mode: 1,
      hour_limit: 1,
      is_test: 1,
      position: 1,
      subject: {
        length: "$subject_length",
        with_personalization: "$subject_with_personalization",
        with_deadline: "$subject_with_deadline",
        with_emoji: "$subject_with_emoji",
        with_bonuses: "$subject_with_bonuses",
        with_discount: "$subject_with_discount",
        with_saleout: "$subject_with_saleout",
      },
    },
  },
  {
    $merge: {
      into: "campaigns",
    },
  },
]);
console.log("Finish building 'campaigns'!");

console.log("Start building 'messages'...");
db.messages_temp.aggregate([
  {
    $set: {
      device: {
        platform: "$platform",
        stream: "$stream",
      },
    },
  },
  {
    $project: {
      id: 0,
      user_device_id: 0,
      user_id: 0,
      platform: 0,
      stream: 0,
      email_provider: 0,
    },
  },
  {
    $set: {
      date: { $toDate: "$date" },
      sent_at: { $toDate: "$sent_at" },
      opened_first_time_at: { $toDate: "$opened_first_time_at" },
      opened_last_time_at: { $toDate: "$opened_last_time_at" },
      clicked_first_time_at: { $toDate: "$clicked_first_time_at" },
      clicked_last_time_at: { $toDate: "$clicked_last_time_at" },
      unsubscribed_at: { $toDate: "$unsubscribed_at" },
      hard_bounced_at: { $toDate: "$hard_bounced_at" },
      soft_bounced_at: { $toDate: "$soft_bounced_at" },
      complained_at: { $toDate: "$complained_at" },
      blocked_at: { $toDate: "$blocked_at" },
      purchased_at: { $toDate: "$purchased_at" },
      created_at: { $toDate: "$created_at" },
      updated_at: { $toDate: "$updated_at" },
    },
  },
  {
    $merge: {
      into: "messages",
    },
  },
]);
console.log("Finish building 'messages'!");

db.campaigns_temp.drop();
db.client_first_purchase_date_temp.drop();
db.events_temp.drop();
db.friends_temp.drop();
db.messages_temp.drop();
