-- ================================================================
-- ANÁLISE DE VENDAS OLIST
-- Exploração inicial usando CTEs e window functions
-- Autor: Luí Rocha
-- ================================================================

-- Visão consolidada para uso no Power BI
-- Granularidade: 1 linha por item de pedido (order_id + item), apenas pedidos entregues
-- Esta query exportada como CSV alimenta o Power BI via Power Query

DROP VIEW IF EXISTS olist.vw_fato_itens;

CREATE OR REPLACE VIEW olist.vw_fato_itens AS
WITH orders_fix AS (
    SELECT
        *,
        NULLIF(order_purchase_timestamp::text, '')::timestamp       AS purchase_ts,
        NULLIF(order_delivered_customer_date::text, '')::timestamp  AS delivered_ts,
        NULLIF(order_estimated_delivery_date::text, '')::timestamp  AS estimated_ts
    FROM olist.olist_orders
),
pagamento_pedido AS (
    SELECT order_id, SUM(payment_value::numeric) AS valor_total_pedido
    FROM olist.olist_order_payments
    GROUP BY order_id
),
forma_pagamento_principal AS (
    SELECT order_id, payment_type
    FROM (
        SELECT
            order_id,
            payment_type,
            ROW_NUMBER() OVER (
                PARTITION BY order_id
                ORDER BY payment_value::numeric DESC, payment_sequential
            ) AS rn
        FROM olist.olist_order_payments
    ) t
    WHERE rn = 1
),
avaliacao_pedido AS (
    SELECT order_id, review_score
    FROM (
        SELECT
            order_id,
            review_score,
            ROW_NUMBER() OVER (
                PARTITION BY order_id
                ORDER BY review_answer_timestamp::text DESC, review_id
            ) AS rn
        FROM olist.olist_order_reviews
    ) t
    WHERE rn = 1
)
SELECT
    -- chaves
    o.order_id,
    oi.order_item_id                                       AS item,
    o.customer_id                                          AS id_cliente,
    oi.product_id                                          AS id_produto,
    s.seller_id                                            AS id_vendedor,
    CASE WHEN ROW_NUMBER() OVER (
             PARTITION BY o.order_id ORDER BY oi.order_item_id
         ) = 1 THEN 1 ELSE 0 END                           AS flag_primeiro_item,

    -- tempo
    o.purchase_ts::date                                    AS data_pedido,
    DATE_TRUNC('month', o.purchase_ts)::date               AS mes_referencia,
    TO_CHAR(o.purchase_ts, 'YYYY-"T"Q')                    AS trimestre,

    -- descritivos
    c.customer_state                                       AS estado_cliente,
    c.customer_city                                        AS cidade_cliente,
    s.seller_state                                         AS estado_vendedor,
    COALESCE(NULLIF(TRIM(pt.product_category_name), ''),
             'sem_categoria')                              AS categoria,
    COALESCE(NULLIF(fp.payment_type, 'not_defined'),
             'sem_registro')                               AS forma_pagamento,

    -- medidas
    oi.price::numeric                                      AS preco_produto,
    oi.freight_value::numeric                              AS frete,
    ROUND(pp.valor_total_pedido
          * (oi.price::numeric + oi.freight_value::numeric)
          / NULLIF(SUM(oi.price::numeric + oi.freight_value::numeric)
                       OVER (PARTITION BY o.order_id), 0), 2) AS valor_pago_rateado,
    ar.review_score::int                                   AS nota_cliente,
    EXTRACT(DAY FROM o.delivered_ts - o.purchase_ts)::int  AS dias_entrega,
    EXTRACT(DAY FROM o.delivered_ts - o.estimated_ts)::int AS dias_atraso
FROM orders_fix                           o
INNER JOIN olist.olist_customers          c  ON o.customer_id  = c.customer_id
INNER JOIN olist.olist_order_items        oi ON o.order_id     = oi.order_id
INNER JOIN olist.olist_products           pt ON oi.product_id  = pt.product_id
INNER JOIN olist.olist_sellers            s  ON oi.seller_id   = s.seller_id
LEFT JOIN pagamento_pedido                pp ON o.order_id     = pp.order_id
LEFT JOIN forma_pagamento_principal       fp ON o.order_id     = fp.order_id
LEFT JOIN avaliacao_pedido                ar ON o.order_id     = ar.order_id
WHERE o.order_status = 'delivered';

SELECT * FROM olist.vw_fato_itens
ORDER BY data_pedido, order_id, item;
