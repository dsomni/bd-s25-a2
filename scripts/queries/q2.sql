WITH user_interactions AS (
    SELECT
        e.product_id,
        COUNT(*) AS interaction_count
    FROM
        events e
    WHERE
        e.user_id = 563016948
        AND e.event_type IN ('view', 'cart')
    GROUP BY
        e.product_id
),
popular_products AS (
    SELECT
        p.product_id,
        p.brand,
        p.price,
        p.category_id,
        p.category_code,
        COUNT(e.event_time) AS popularity
    FROM
        products p
    JOIN events e ON p.product_id = e.product_id
    WHERE
        e.event_type IN ('view', 'cart', 'purchase')
    GROUP BY
        p.product_id
    ORDER BY
        popularity DESC
)
SELECT
    pp.product_id,
    pp.brand,
    pp.price,
    pp.category_id,
    pp.category_code,
    COALESCE(ui.interaction_count, 0) AS user_interaction_score,
    pp.popularity
FROM
    popular_products pp
LEFT JOIN user_interactions ui ON pp.product_id = ui.product_id
ORDER BY
    user_interaction_score DESC,
    pp.popularity DESC
LIMIT 10;