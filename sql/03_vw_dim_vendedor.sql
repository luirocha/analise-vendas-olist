-- PROJETO: Dashboard de Vendas Olist (modelo dimensional para o Power BI)
-- Dim_Vendedor: uma linha por seller_id.
-- vendedor_codigo é apenas um rótulo curto para os visuais; a chave continua sendo seller_id.
-- A cidade do vendedor tem sujeira na origem (siglas, CEPs digitados), por isso as análises usam UF e região.
-- Autor: Luí Rocha

CREATE OR REPLACE VIEW olist.vw_pbi_dim_vendedor AS
SELECT
    s.seller_id,
    LEFT(s.seller_id, 8)                AS vendedor_codigo,
    INITCAP(s.seller_city)              AS cidade,
    UPPER(s.seller_state)               AS uf,
    COALESCE(r.regiao, 'Não informada') AS regiao
FROM olist.olist_sellers AS s
LEFT JOIN olist.vw_pbi_uf_regiao AS r
       ON r.uf = UPPER(s.seller_state);

SELECT * FROM olist.vw_pbi_dim_vendedor;
