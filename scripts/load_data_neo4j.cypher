// NODES
LOAD CSV WITH HEADERS FROM 'file:///products.csv' AS row
CALL (row) {
CREATE (product:Product {
	product_id: toInteger(row.product_id),
	brand: row.brand,
	price: toFloat(row.price),
	category_id: toInteger(row.category_id),
	category_code: row.category_code
})
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///clients.csv" AS row
CALL (row) {
CREATE
(client:Client {
	client_id: toInteger(row.client_id), // 77,
	user_id: toInteger(row.user_id), // 62,
	user_device_id: toInteger(row.user_device_id), // -24,
	first_purchase_date: date(row.first_purchase_date), // date("2014-12-03"),
	email_provider: row.email_provider // "Lorem"
})
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///campaigns.csv" AS row
CALL (row) {
CREATE
(campaign:Campaign {
	campaign_id: toInteger(row.campaign_id), // -19,
	campaign_type: row.campaign_type, // "Lorem",
	channel: row.channel, // "Lorem",
	topic: row.topic, // "Lorem",
	started_at: datetime(replace(row.started_at, " ", "T")), // datetime("2014-12-03"),
	finished_at: datetime(replace(row.finished_at, " ", "T")), // datetime("2014-12-03"),
	total_count: toInteger(row.total_count), // 7,
	ab_test: toBoolean(row.ab_test), // true,
	warmup_mode: toBoolean(row.warmup_mode), // true,
	hour_limit: toInteger(row.hour_limit), // 37,
	subject_length: toInteger(row.subject_length), // -33,
	subject_with_personalization: toBoolean(row.subject_with_personalization), // true,
	subject_with_deadline: toBoolean(row.subject_with_deadline), // true,
	subject_with_emoji: toBoolean(row.subject_with_emoji), // true,
	subject_with_bonuses: toBoolean(row.subject_with_bonuses), // true,
	subject_with_discount: toBoolean(row.subject_with_discount), // true,
	subject_with_saleout: toBoolean(row.subject_with_saleout), // true,
	is_test: toBoolean(row.is_test), // true,
	position: toInteger(row.position) // -8
})
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM "file:///messages.csv" AS row
CALL (row) {
CREATE
(message:Message {
	message_id: row.message_id, // "Lorem",
	message_type: row.message_type, // "Lorem",
	channel: row.channel, // "Lorem",
	category: row.category, // "Lorem",
	platform: row.platform, // "Lorem",
	stream: row.stream, // "Lorem",
	date: date(row.date), // date("2014-12-03"),
	is_opened: toBoolean(row.is_opened), // true,
	opened_first_time_at: datetime(replace(row.opened_first_time_at, " ", "T")), // datetime("2014-12-03"),
	opened_last_time_at: datetime(replace(row.opened_last_time_at, " ", "T")), // datetime("2014-12-03"),
	is_clicked: toBoolean(row.is_clicked), // true,
  clicked_first_time_at: datetime(replace(row.clicked_first_time_at, " ", "T")), // datetime("2014-12-03"),
	clicked_last_time_at: datetime(replace(row.clicked_last_time_at, " ", "T")), // datetime("2014-12-03"),
	is_unsubscribed: toBoolean(row.is_unsubscribed), // true,
	unsubscribed_at: datetime(replace(row.unsubscribed_at, " ", "T")), // datetime("2014-12-03"),
	is_hard_bounced: toBoolean(row.is_hard_bounced), // true,
	hard_bounced_at: datetime(replace(row.hard_bounced_at, " ", "T")), // datetime("2014-12-03"),
	is_soft_bounced: toBoolean(row.is_soft_bounced), // true,
	soft_bounced_at: datetime(replace(row.soft_bounced_at, " ", "T")), // datetime("2014-12-03"),
	is_complained: toBoolean(row.is_complained), // true,
	complained_at: datetime(replace(row.complained_at, " ", "T")), // datetime("2014-12-03"),
	is_blocked: toBoolean(row.is_blocked), // true,
	blocked_at: datetime(replace(row.blocked_at, " ", "T")), // datetime("2014-12-03"),
	is_purchased: toBoolean(row.is_purchased), // true,
	purchased_at: datetime(replace(row.purchased_at, " ", "T")), // datetime("2014-12-03"),
	created_at: datetime(replace(row.created_at, " ", "T")), // datetime("2014-12-03"),
	updated_at: datetime(replace(row.updated_at, " ", "T")) // datetime("2014-12-03")
})
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///users.csv" AS row
CALL (row) {
CREATE
(user:User {
	user_id: toInteger(row.user_id)
})
} IN TRANSACTIONS OF 10000 ROWS;


CREATE CONSTRAINT IF NOT EXISTS FOR (user:User) REQUIRE user.user_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (client:Client) REQUIRE client.client_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (product:Product) REQUIRE product.product_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (message:Message) REQUIRE message.message_id IS UNIQUE;


CREATE INDEX client IF NOT EXISTS FOR (client:Client) ON (client.user_id);
CREATE INDEX campaign_id IF NOT EXISTS FOR (campaign:Campaign) ON (campaign.campaign_id);


// RELATIONS

LOAD CSV WITH HEADERS FROM "file:///friends.csv" AS row
CALL (row) {
MATCH (u1:User {user_id: toInteger(row.friend1)}), (u2:User {user_id: toInteger(row.friend2)})
MERGE (u1)-[:FRIENDS_WITH {}]->(u2)-[:FRIENDS_WITH {}]->(u1)
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///received.csv" AS row
CALL (row) {
MATCH (c: Client {client_id: toInteger(row.client_id)}), (m: Message {message_id: row.message_id})
MERGE (c)-[:RECEIVED {}]->(m)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM "file:///sent_from.csv" AS row
CALL (row) {
MATCH (c: Campaign {campaign_id: toInteger(row.campaign_id)}), (m: Message {message_id: row.message_id})
MERGE (m)-[:SENT_FROM {
	sent_at: datetime(replace(row.sent_at, " ", "T"))
}]->(c)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM "file:///belongs_to.csv" AS row
CALL (row) {
MATCH (c: Client {client_id: toInteger(row.client_id)}), (u: User {user_id: toInteger(row.user_id)})
MERGE (c)-[:BELONGS_TO {}]->(u)
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///view.csv" AS row
CALL (row) {
MATCH (p: Product {product_id: toInteger(row.product_id)}), (u: User {user_id: toInteger(row.user_id)})
MERGE (u)-[:VIEWED  {
	time: datetime(replace(replace(row.event_time, " UTC", ""), " ", "T")),
	price: toFloat(row.price),
	user_session: row.user_session
}]->(p)
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///cart.csv" AS row
CALL (row) {
MATCH (p: Product {product_id: toInteger(row.product_id)}), (u: User {user_id: toInteger(row.user_id)})
MERGE (u)-[:ADDED_TO_CART  {
	time: datetime(replace(replace(row.event_time, " UTC", ""), " ", "T")),
	price: toFloat(row.price),
	user_session: row.user_session
}]->(p)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM "file:///purchase.csv" AS row
CALL (row) {
MATCH (p: Product {product_id: toInteger(row.product_id)}), (u: User {user_id: toInteger(row.user_id)})
MERGE (u)-[:PURCHASED  {
	time: datetime(replace(replace(row.event_time, " UTC", ""), " ", "T")),
	price: toFloat(row.price),
	user_session: row.user_session
}]->(p)
} IN TRANSACTIONS OF 10000 ROWS;

