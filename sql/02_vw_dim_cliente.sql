-- PROJETO: Dashboard de Vendas Olist (modelo dimensional para o Power BI)
-- Dim_Cliente: uma linha por customer_id (o id muda a cada pedido).
-- Para contar pessoas de verdade use customer_unique_id.
-- Autor: Luí Rocha

CREATE OR REPLACE VIEW olist.vw_pbi_dim_cliente AS
SELECT
    c.customer_id,
    c.customer_unique_id,
    INITCAP(c.customer_city)            AS cidade,
    UPPER(c.customer_state)             AS uf,
    COALESCE(r.regiao, 'Não informada') AS regiao
FROM olist.olist_customers AS c
LEFT JOIN olist.vw_pbi_uf_regiao AS r
       ON r.uf = UPPER(c.customer_state);

SELECT * FROM olist.vw_pbi_dim_cliente;