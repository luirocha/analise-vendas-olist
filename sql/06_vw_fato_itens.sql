-- PROJETO: Dashboard de Vendas Olist (modelo dimensional para o Power BI)
-- Fato_Itens: uma linha por item de pedido entregue. Grão: (order_id, item_id).
-- preco = valor do produto; frete = valor do frete daquele item.
-- Receita do dashboard = SUM(preco). O frete fica separado de propósito.
-- Se a sua olist.vw_fato_itens já entrega exatamente estas 6 colunas, você pode
-- apontar a exportação para ela. O importante é manter nomes e tipos do contrato.
-- Autor: Luí Rocha

CREATE OR REPLACE VIEW olist.vw_pbi_fato_itens AS
SELECT
    i.order_id,
    i.order_item_id::int            AS item_id,
    i.product_id,
    i.seller_id,
    i.price::numeric(12, 2)         AS preco,
    i.freight_value::numeric(12, 2) AS frete
FROM olist.olist_order_items AS i
JOIN olist.olist_orders      AS o
  ON o.order_id = i.order_id
WHERE o.order_status = 'delivered';

SELECT * FROM olist.vw_pbi_fato_itens;