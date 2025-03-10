WITH category_keywords AS (
    SELECT DISTINCT unnest(string_to_array(category_code, '.')) AS keyword
    FROM products
    WHERE product_id IN (1005135,
                        28717064,
                        7004807,
                        1003317,
                        7005751,
                        1005105,
                        1004258,
                        1004839,
                        1005112,
                        7004492)
    ),
search_query AS (
    SELECT string_agg(keyword, ' | ') AS query
    FROM category_keywords
)
SELECT p.product_id, p.category_code
FROM products p
JOIN search_query sq
ON to_tsvector('simple', replace(p.category_code, '.', ' ')) @@ to_tsquery('simple', sq.query)
ORDER BY p.product_id
LIMIT 100;
