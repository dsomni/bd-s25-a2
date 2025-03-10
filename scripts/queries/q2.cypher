MATCH (u:User {user_id: 563016948})-[:VIEWED|ADDED_TO_CART]->(p:Product)
WITH p, COUNT(*) AS interaction_count
MATCH (p)<-[:VIEWED|ADDED_TO_CART|PURCHASED]-(other:User)
WITH p, interaction_count, COUNT(other) AS popularity
RETURN p.product_id, p.brand, p.price, p.category_id, p.category_code, interaction_count, popularity
ORDER BY interaction_count DESC, popularity DESC
LIMIT 10
