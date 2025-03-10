START TRANSACTION;

DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS clients;


CREATE TABLE IF NOT EXISTS campaigns (
	campaign_id text NOT NULL,
	campaign_type varchar(32) NOT NULL,
	channel varchar(16),
	topic varchar(64),
	started_at timestamp WITHOUT TIME ZONE,
	finished_at timestamp WITHOUT TIME ZONE,
	total_count integer,
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

CREATE TABLE IF NOT EXISTS messages (
	message_id varchar(36) NOT NULL,
	campaign_id text,
	message_type varchar(32),
	client_id bigint,
	channel varchar(16),
	category varchar(16),
	date date,
	sent_at timestamp WITHOUT TIME ZONE,
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

\COPY products from './data/optimal/products_postgres.csv' delimiter ',' CSV header null as '';
\COPY clients from './data/optimal/clients_postgres.csv' delimiter ',' CSV header null as '';
\COPY campaigns from './data/optimal/campaigns_postgres.csv' delimiter ',' CSV header null as '';
\COPY messages from './data/optimal/messages_postgres.csv' delimiter ',' CSV header null as '';
commit;