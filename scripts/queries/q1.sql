WITH campaign_stats AS (
    SELECT
        c.subject_with_personalization,
        COUNT(CASE WHEN m.is_purchased = TRUE THEN 1 END) AS purchased_count,
        COUNT(*) AS total_messages
    FROM campaigns c
    JOIN messages m ON c.campaign_id = m.campaign_id AND c.campaign_type= m.message_type
    GROUP BY c.subject_with_personalization
),
probabilities AS (
    SELECT
        subject_with_personalization,
        purchased_count,
        total_messages,
        CAST(purchased_count AS FLOAT) / NULLIF(total_messages, 0) AS purchase_rate
    FROM campaign_stats
)
SELECT
    MAX(CASE WHEN subject_with_personalization = TRUE THEN purchase_rate END) /
    NULLIF(MAX(CASE WHEN subject_with_personalization = FALSE THEN purchase_rate END), 0) AS purchase_ratio
FROM probabilities;