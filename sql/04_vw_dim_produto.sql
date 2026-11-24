-- PROJETO: Dashboard de Vendas Olist (modelo dimensional para o Power BI)
-- Dim_Produto: uma linha por product_id.
-- Produtos sem categoria viram 'Sem categoria'.
-- Os nomes de categoria da base original não têm acento; foram mantidos para
-- preservar a rastreabilidade com o dataset. categoria_en usa a tabela de tradução
-- e cai para o nome em português quando não há tradução.
-- Autor: Luí Rocha

CREATE OR REPLACE VIEW olist.vw_pbi_dim_produto AS
SELECT
    p.product_id,
    COALESCE(INITCAP(REPLACE(p.product_category_name, '_', ' ')), 'Sem categoria') AS categoria,
    COALESCE(
        INITCAP(REPLACE(t.product_category_name_english, '_', ' ')),
        INITCAP(REPLACE(p.product_category_name, '_', ' ')),
        'Sem categoria'
    ) AS categoria_en,
    p.product_photos_qty::int   AS qtd_fotos,
    p.product_weight_g::numeric AS peso_g
FROM olist.olist_products AS p
LEFT JOIN olist.product_category_name_translation AS t
       ON t.product_category_name = p.product_category_name;

SELECT * FROM olist.vw_pbi_dim_produto;