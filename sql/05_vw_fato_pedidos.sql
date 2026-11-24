-- PROJETO: Dashboard de Vendas Olist (modelo dimensional para o Power BI)
-- Fato_Pedidos: uma linha por pedido ENTREGUE (order_status = 'delivered').
-- Regra única de negócio: só pedidos entregues entram no modelo, aqui e em
-- Fato_Itens, para receita, entrega e satisfação falarem do mesmo universo.
-- Pagamentos (várias linhas por pedido) e avaliações (alguns pedidos têm mais de uma)
-- são reduzidos a uma linha por pedido para não duplicar valores no modelo.
--   valor_pagamento_total    : soma de payment_value
--   parcelas_max             : maior número de parcelas entre os pagamentos do pedido
--   tipo_pagamento_principal : tipo com maior valor no pedido
--   nota_avaliacao           : nota da avaliação mais recente (nulo se não avaliou)
-- Autor: Luí Rocha

CREATE OR REPLACE VIEW olist.vw_pbi_fato_pedidos AS
WITH base AS (
    SELECT
        o.order_id,
        o.customer_id,
        NULLIF(o.order_purchase_timestamp, '')::timestamp       AS dt_compra,
        NULLIF(o.order_delivered_customer_date, '')::timestamp  AS dt_entrega,
        NULLIF(o.order_estimated_delivery_date, '')::timestamp  AS dt_estimada
    FROM olist.olist_orders AS o
    WHERE o.order_status = 'delivered'
),
pagamentos AS (
    SELECT
        order_id,
        SUM(payment_value::numeric)    AS valor_pagamento_total,
        MAX(payment_installments::int) AS parcelas_max
    FROM olist.olist_order_payments
    GROUP BY order_id
),
pagamento_principal AS (
    SELECT DISTINCT ON (order_id)
        order_id,
        payment_type
    FROM olist.olist_order_payments
    ORDER BY order_id, payment_value::numeric DESC, payment_sequential::int
),
avaliacao AS (
    SELECT DISTINCT ON (order_id)
        order_id,
        review_score::int AS nota
    FROM olist.olist_order_reviews
    ORDER BY order_id, review_answer_timestamp::timestamp DESC NULLS LAST, review_id
),
calculo AS (
    SELECT
        b.order_id,
        b.customer_id,
        c.customer_unique_id,
        b.dt_compra::date   AS data_compra,
        b.dt_entrega::date  AS data_entrega,
        b.dt_estimada::date AS data_entrega_estimada,
        ROUND((EXTRACT(EPOCH FROM (b.dt_entrega - b.dt_compra)) / 86400.0)::numeric, 2) AS dias_entrega,
        (b.dt_estimada::date - b.dt_compra::date)   AS dias_prazo_estimado,
        (b.dt_entrega::date  - b.dt_estimada::date) AS dias_diferenca_prazo
    FROM base AS b
    LEFT JOIN olist.olist_customers AS c
           ON c.customer_id = b.customer_id
)
SELECT
    k.order_id,
    k.customer_id,
    k.customer_unique_id,
    k.data_compra,
    k.data_entrega,
    k.data_entrega_estimada,
    k.dias_entrega,
    k.dias_prazo_estimado,
    k.dias_diferenca_prazo,
    CASE
        WHEN k.dias_diferenca_prazo IS NULL THEN NULL
        WHEN k.dias_diferenca_prazo <= 0 THEN 1
        ELSE 0
    END AS entregue_no_prazo,
    CASE
        WHEN k.dias_diferenca_prazo IS NULL THEN NULL
        WHEN k.dias_diferenca_prazo <= 0 THEN '1. No prazo'
        WHEN k.dias_diferenca_prazo <= 3 THEN '2. Atraso de 1 a 3 dias'
        WHEN k.dias_diferenca_prazo <= 7 THEN '3. Atraso de 4 a 7 dias'
        ELSE '4. Atraso de mais de 7 dias'
    END AS faixa_atraso,
    p.valor_pagamento_total,
    p.parcelas_max,
    CASE
        WHEN p.parcelas_max IS NULL THEN NULL
        WHEN p.parcelas_max <= 1  THEN '1. 1x'
        WHEN p.parcelas_max <= 3  THEN '2. 2 a 3x'
        WHEN p.parcelas_max <= 6  THEN '3. 4 a 6x'
        WHEN p.parcelas_max <= 10 THEN '4. 7 a 10x'
        ELSE '5. Mais de 10x'
    END AS faixa_parcelas,
    CASE pp.payment_type
        WHEN 'credit_card' THEN 'Cartão de crédito'
        WHEN 'boleto'      THEN 'Boleto'
        WHEN 'debit_card'  THEN 'Cartão de débito'
        WHEN 'voucher'     THEN 'Voucher'
        ELSE 'Não definido'
    END AS tipo_pagamento_principal,
    a.nota AS nota_avaliacao
FROM calculo AS k
LEFT JOIN pagamentos          AS p  ON p.order_id  = k.order_id
LEFT JOIN pagamento_principal AS pp ON pp.order_id = k.order_id
LEFT JOIN avaliacao           AS a  ON a.order_id  = k.order_id;

SELECT * FROM olist.vw_pbi_fato_pedidos;