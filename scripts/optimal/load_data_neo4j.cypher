// NODES
LOAD CSV WITH HEADERS FROM 'file:///products_neo4j.csv' AS row
CALL (row) {
CREATE (product:Product {
	product_id: toInteger(row.product_id),
})
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///clients_neo4j.csv" AS row
CALL (row) {
CREATE
(client:Client {
	client_id: toInteger(row.client_id),
})
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///users_neo4j.csv" AS row
CALL (row) {
CREATE
(user:User {
	user_id: toInteger(row.user_id)
})
} IN TRANSACTIONS OF 10000 ROWS;


CREATE CONSTRAINT IF NOT EXISTS FOR (user:User) REQUIRE user.user_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (client:Client) REQUIRE client.client_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (product:Product) REQUIRE product.product_id IS UNIQUE;

// RELATIONS

LOAD CSV WITH HEADERS FROM "file:///friends_neo4j.csv" AS row
CALL (row) {
MATCH (u1:User {user_id: toInteger(row.friend1)}), (u2:User {user_id: toInteger(row.friend2)})
MERGE (u1)-[:FRIENDS_WITH {}]->(u2)-[:FRIENDS_WITH {}]->(u1)
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///belongs_to_neo4j.csv" AS row
CALL (row) {
MATCH (c: Client {client_id: toInteger(row.client_id)}), (u: User {user_id: toInteger(row.user_id)})
MERGE (c)-[:BELONGS_TO {}]->(u)
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///view_neo4j.csv" AS row
CALL (row) {
MATCH (p: Product {product_id: toInteger(row.product_id)}), (u: User {user_id: toInteger(row.user_id)})
MERGE (u)-[:VIEWED  {
	event_id: row.event_id
}]->(p)
} IN TRANSACTIONS OF 10000 ROWS;


LOAD CSV WITH HEADERS FROM "file:///cart_neo4j.csv" AS row
CALL (row) {
MATCH (p: Product {product_id: toInteger(row.product_id)}), (u: User {user_id: toInteger(row.user_id)})
MERGE (u)-[:ADDED_TO_CART  {
	event_id: row.event_id

}]->(p)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM "file:///purchase_neo4j.csv" AS row
CALL (row) {
MATCH (p: Product {product_id: toInteger(row.product_id)}), (u: User {user_id: toInteger(row.user_id)})
MERGE (u)-[:PURCHASED  {
	event_id: row.event_id

}]->(p)
} IN TRANSACTIONS OF 10000 ROWS;

