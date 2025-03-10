MATCH (m:Message)-[:SENT_FROM]->(c:Campaign)
WHERE c.campaign_type = m.message_type
WITH c.subject_with_personalization AS subject_with_personalization,
     COUNT(m) AS total_messages,
     SUM(CASE WHEN m.is_purchased THEN 1 ELSE 0 END) AS purchased_count

WITH subject_with_personalization,
     purchased_count * 1.0 / total_messages AS purchase_rate

WITH COLLECT({
    subject_with_personalization: subject_with_personalization,
    purchase_rate: purchase_rate
}) AS rates

WITH
    REDUCE(s = {personalization_true: 0.0, personalization_false: 0.0}, r IN rates |
        CASE
            WHEN r.subject_with_personalization = true THEN
                {personalization_true: r.purchase_rate, personalization_false: s.personalization_false}
            ELSE
                {personalization_true: s.personalization_true, personalization_false: r.purchase_rate}
        END
    ) AS rates_map

RETURN
    rates_map.personalization_true /
    CASE
        WHEN rates_map.personalization_false = 0 THEN 1
        ELSE rates_map.personalization_false
    END AS purchase_ratio;
