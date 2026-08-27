-- ================================================================
-- ANÁLISE DE VENDAS OLIST
-- Exploração inicial usando CTEs e window functions
-- Autor: Luí Rocha
-- ================================================================

-- Visão consolidada para uso no Power BI
-- Esta query exportada como CSV alimenta o Power BI via Power Query

WITH orders_fix AS (
    SELECT
        *,
        NULLIF(order_purchase_timestamp, '')::timestamp 	 AS purchase_ts,
        NULLIF(order_delivered_customer_date, '')::timestamp AS delivered_ts
    FROM olist.olist_orders
)
SELECT
    o.order_id,
    o.purchase_ts AS order_purchase_timestamp,
    DATE_TRUNC('month', o.purchase_ts)::date AS mes_referencia,
    c.customer_state      AS estado_cliente,
    c.customer_city       AS cidade_cliente,
    p.payment_type        AS forma_pagamento,
    p.payment_value       AS valor_pagamento,
    oi.price              AS preco_produto,
    oi.freight_value      AS frete,
    pt.product_category_name AS categoria,
    s.seller_state        AS estado_vendedor,
    r.review_score        AS nota_cliente,
    EXTRACT(DAY FROM o.delivered_ts - o.purchase_ts) AS dias_entrega
FROM orders_fix                           o
INNER JOIN olist.olist_customers          c  ON o.customer_id  = c.customer_id
INNER JOIN olist.olist_order_payments     p  ON o.order_id     = p.order_id
INNER JOIN olist.olist_order_items        oi ON o.order_id     = oi.order_id
INNER JOIN olist.olist_products           pt ON oi.product_id  = pt.product_id
INNER JOIN olist.olist_sellers            s  ON oi.seller_id   = s.seller_id
LEFT  JOIN olist.olist_order_reviews      r  ON o.order_id     = r.order_id
WHERE o.order_status = 'delivered'
  AND pt.product_category_name IS NOT NULL
ORDER BY o.purchase_ts;
