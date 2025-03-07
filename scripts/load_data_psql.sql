START TRANSACTION;

DROP TABLE IF EXISTS friends;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS clients;

CREATE TABLE IF NOT EXISTS friends (
	friend1 integer NOT NULL,
	friend2 integer NOT NULL,
	CONSTRAINT pk PRIMARY KEY (friend1, friend2)
);

CREATE TABLE IF NOT EXISTS campaigns (
	campaign_id integer NOT NULL,
	campaign_type varchar(32) NOT NULL,
	channel varchar(16),
	topic varchar(64),
	started_at timestamp WITHOUT TIME ZONE,
	finished_at timestamp WITHOUT TIME ZONE,
	total_count integer,
	ab_test boolean,
	warmup_mode boolean,
	hour_limit integer,
	subject_length integer,
	subject_with_personalization boolean,
	subject_with_deadline boolean,
	subject_with_emoji boolean,
	subject_with_bonuses boolean,
	subject_with_discount boolean,
	subject_with_saleout boolean,
	is_test boolean,
	position integer,
	PRIMARY KEY (campaign_id, campaign_type)
);

CREATE TABLE IF NOT EXISTS products (
	product_id integer NOT NULL,
	brand varchar(32),
	price real,
	category_id bigint,
	category_code text,
	CONSTRAINT unique_product PRIMARY KEY (product_id)
);

CREATE TABLE IF NOT EXISTS events (
	event_time timestamp WITH TIME ZONE,
	event_type varchar(16),
	product_id integer,
	price real,
	user_id integer,
	user_session varchar(36),
	CONSTRAINT fk_products_events FOREIGN KEY (product_id) REFERENCES products (product_id)
);

CREATE TABLE IF NOT EXISTS messages (
	message_id varchar(36) NOT NULL,
	campaign_id integer,
	message_type varchar(32),
	client_id bigint,
	channel varchar(16),
	category varchar(16),
	platform varchar(16),
	stream varchar(16),
	date date,
	sent_at timestamp WITHOUT TIME ZONE,
	is_opened boolean,
	opened_first_time_at timestamp WITHOUT TIME ZONE,
	opened_last_time_at timestamp WITHOUT TIME ZONE,
	is_clicked boolean,
	clicked_first_time_at timestamp WITHOUT TIME ZONE,
	clicked_last_time_at timestamp WITHOUT TIME ZONE,
	is_unsubscribed boolean,
	unsubscribed_at timestamp WITHOUT TIME ZONE,
	is_hard_bounced boolean,
	hard_bounced_at timestamp WITHOUT TIME ZONE,
	is_soft_bounced boolean,
	soft_bounced_at timestamp WITHOUT TIME ZONE,
	is_complained boolean,
	complained_at timestamp WITHOUT TIME ZONE,
	is_blocked boolean,
	blocked_at timestamp WITHOUT TIME ZONE,
	is_purchased boolean,
	purchased_at timestamp WITHOUT TIME ZONE,
	created_at timestamp WITHOUT TIME ZONE,
	updated_at timestamp WITHOUT TIME ZONE,
	CONSTRAINT unique_message PRIMARY KEY (message_id),
	CONSTRAINT fk_campaigns_messages FOREIGN KEY (campaign_id, message_type) REFERENCES campaigns (campaign_id, campaign_type)
);

CREATE TABLE IF NOT EXISTS clients (
	client_id bigint PRIMARY KEY,
	user_id integer,
	user_device_id smallint,
	first_purchase_date date,
	email_provider varchar(64)
);

\COPY products from './data/postgres/products.csv' delimiter ',' CSV header null as '';
\COPY clients from './data/postgres/clients.csv' delimiter ',' CSV header null as '';
\COPY campaigns from './data/postgres/campaigns.csv' delimiter ',' CSV header null as '';
\COPY messages from './data/postgres/messages.csv' delimiter ',' CSV header null as '';
\COPY events from './data/postgres/events.csv' delimiter ',' CSV header null as '';
\COPY friends from './data/postgres/friends.csv' delimiter ',' CSV header null as '';

commit;