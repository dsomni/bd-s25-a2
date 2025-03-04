START TRANSACTION;

CREATE TABLE IF NOT EXISTS friends (
	friend1 integer NOT NULL,
	friend2 integer NOT NULL,
	CONSTRAINT pk PRIMARY KEY (friend1, friend2)
);

CREATE TABLE IF NOT EXISTS campaigns (
	id integer NOT NULL,
	campaign_type varchar(16) NOT NULL,
	channel varchar(12),
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
	PRIMARY KEY (id, campaign_type)
);

CREATE TABLE IF NOT EXISTS events (
	event_time timestamp WITH TIME ZONE,
	event_type varchar(8),
	product_id integer,
	category_id bigint,
	category_code varchar(40),
	brand varchar(30),
	price real,
	user_id integer,
	user_session varchar(36)
);

CREATE TABLE IF NOT EXISTS client_first_purchase_date (
	client_id bigint PRIMARY KEY,
	first_purchase_date date,
	user_id integer,
	user_device_id smallint
);

CREATE TABLE IF NOT EXISTS messages (
	id bigint PRIMARY KEY,
	message_id varchar(36),
	campaign_id integer,
	message_type varchar(16),
	client_id bigint,
	channel varchar(12),
	category varchar(16),
	platform varchar(10),
	email_provider varchar(32),
	stream varchar(7),
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
	user_device_id smallint,
	user_id integer,
	CONSTRAINT fk_campaigns_to_messages FOREIGN KEY (campaign_id, message_type) REFERENCES campaigns (id, campaign_type)
);

\COPY campaigns from './data/cleaned/campaigns.csv' delimiter ',' CSV header null as '';
\COPY client_first_purchase_date from './data/cleaned/client_first_purchase_date.csv' delimiter ',' CSV header null as '';
\COPY events from './data/cleaned/events.csv' delimiter ',' CSV header null as '';
\COPY friends from './data/cleaned/friends.csv' delimiter ',' CSV header null as '';
\COPY messages from './data/cleaned/messages.csv' delimiter ',' CSV header null as '';

commit;