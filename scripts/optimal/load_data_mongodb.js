var db_name = "bd-a2-opt";
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
          bsonType: "string",
        },
        campaign_type: {
          bsonType: "string",
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
        message_type: {
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

db.createCollection("events", {
  capped: false,
  validator: {
    $jsonSchema: {
      bsonType: "object",
      title: "events",
      properties: {
        _id: {
          bsonType: "objectId",
        },
        event_id: {
          bsonType: "string",
        },
        event_time: {
          bsonType: "date",
        },
        event_type: {
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

db.events.createIndex(
  {
    event_id: 1,
  },
  {
    name: "unique_event_id",
    unique: true,
  }
);

var exec = require("child_process").execSync;

exec(
  `mongoimport -d ${db_name} -c messages --file ./data/optimal/messages_mongo.json`
);
exec(
  `mongoimport -d ${db_name} -c campaigns --file ./data/optimal/campaigns_mongo.json`
);
exec(
  `mongoimport -d ${db_name} -c events --file ./data/optimal/events_mongo.json`
);

db = connect(`mongodb://localhost/${db_name}`);

console.log("Start building 'campaigns'...");
db.campaigns.updateMany(
  {},
  {
    $set: {
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
  }
);
db.campaigns.updateMany(
  {},
  {
    $unset: {
      subject_length: "",
      subject_with_personalization: "",
      subject_with_deadline: "",
      subject_with_emoji: "",
      subject_with_bonuses: "",
      subject_with_discount: "",
      subject_with_saleout: "",
    },
  }
);
console.log("Finish building 'campaigns'!");

console.log("Start building 'messages'...");
db.messages.updateMany(
  {},
  {
    $set: {
      device: {
        platform: "$platform",
        stream: "$stream",
      },
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
  }
);
db.messages.updateMany(
  {},
  {
    $unset: {
      platform: "",
      stream: "",
    },
  }
);
console.log("Finish building 'messages'!");

console.log("Start building 'events'...");
db.events.updateMany(
  {},
  {
    $set: {
      event_time: { $toDate: "$event_time" },
    },
  }
);
console.log("Finish building 'events'!");
