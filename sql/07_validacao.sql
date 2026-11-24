-- PROJETO: Dashboard de Vendas Olist (modelo dimensional para o Power BI)
-- Validação: rode antes de exportar e depois compare com os cartões do Power BI.
-- Autor: Luí Rocha

-- 1. Chaves duplicadas nas dimensões e em Fato_Pedidos (esperado: nenhuma linha)
SELECT 'dim_cliente' AS tabela, customer_id AS chave, COUNT(*) AS qtd
FROM olist.vw_pbi_dim_cliente GROUP BY customer_id HAVING COUNT(*) > 1
UNION ALL
SELECT 'dim_vendedor', seller_id, COUNT(*)
FROM olist.vw_pbi_dim_vendedor GROUP BY seller_id HAVING COUNT(*) > 1
UNION ALL
SELECT 'dim_produto', product_id, COUNT(*)
FROM olist.vw_pbi_dim_produto GROUP BY product_id HAVING COUNT(*) > 1
UNION ALL
SELECT 'fato_pedidos', order_id, COUNT(*)
FROM olist.vw_pbi_fato_pedidos GROUP BY order_id HAVING COUNT(*) > 1;

-- 2. Grão de Fato_Itens: (order_id, item_id) deve ser único (esperado: nenhuma linha)
SELECT order_id, item_id, COUNT(*) AS qtd
FROM olist.vw_pbi_fato_itens
GROUP BY order_id, item_id
HAVING COUNT(*) > 1;

-- 3. Chaves órfãs (esperado: tudo zero; se não for, investigue antes de seguir)
SELECT
    (SELECT COUNT(*) FROM olist.vw_pbi_fato_itens i
       LEFT JOIN olist.vw_pbi_fato_pedidos p ON p.order_id = i.order_id
      WHERE p.order_id IS NULL)                                   AS itens_sem_pedido,
    (SELECT COUNT(*) FROM olist.vw_pbi_fato_itens i
       LEFT JOIN olist.vw_pbi_dim_produto d ON d.product_id = i.product_id
      WHERE d.product_id IS NULL)                                 AS itens_sem_produto,
    (SELECT COUNT(*) FROM olist.vw_pbi_fato_itens i
       LEFT JOIN olist.vw_pbi_dim_vendedor d ON d.seller_id = i.seller_id
      WHERE d.seller_id IS NULL)                                  AS itens_sem_vendedor,
    (SELECT COUNT(*) FROM olist.vw_pbi_fato_pedidos p
       LEFT JOIN olist.vw_pbi_dim_cliente d ON d.customer_id = p.customer_id
      WHERE d.customer_id IS NULL)                                AS pedidos_sem_cliente,
    (SELECT COUNT(*) FROM olist.vw_pbi_fato_pedidos p
       LEFT JOIN olist.vw_pbi_fato_itens i ON i.order_id = p.order_id
      WHERE i.order_id IS NULL)                                   AS pedidos_sem_itens;

-- 4. Totais gerais (período inteiro). Compare com os cartões SEM o filtro de período.
SELECT
    (SELECT COUNT(*) FROM olist.vw_pbi_fato_pedidos)                    AS pedidos,
    (SELECT COUNT(*) FROM olist.vw_pbi_fato_itens)                      AS itens,
    (SELECT SUM(preco) FROM olist.vw_pbi_fato_itens)                    AS receita,
    (SELECT SUM(frete) FROM olist.vw_pbi_fato_itens)                    AS frete_total,
    (SELECT ROUND(100.0 * SUM(entregue_no_prazo) / COUNT(entregue_no_prazo), 2)
       FROM olist.vw_pbi_fato_pedidos)                                  AS pct_no_prazo,
    (SELECT ROUND(AVG(dias_entrega), 2) FROM olist.vw_pbi_fato_pedidos) AS dias_entrega_medio,
    (SELECT ROUND(AVG(nota_avaliacao), 2) FROM olist.vw_pbi_fato_pedidos) AS nota_media;

-- 5. Totais do período de análise do dashboard (01/01/2017 a 31/08/2018).
--    Compare com os cartões COM o filtro "No Período de Análise = Sim".
SELECT
    COUNT(DISTINCT p.order_id) AS pedidos,
    COUNT(*)                   AS itens,
    SUM(i.preco)               AS receita,
    SUM(i.frete)               AS frete_total
FROM olist.vw_pbi_fato_itens   AS i
JOIN olist.vw_pbi_fato_pedidos AS p ON p.order_id = i.order_id
WHERE p.data_compra BETWEEN DATE '2017-01-01' AND DATE '2018-08-31';

-- 6. Volume por mês: confirme visualmente os meses com pouco dado nas pontas.
SELECT
    DATE_TRUNC('month', p.data_compra)::date AS mes,
    COUNT(DISTINCT p.order_id)               AS pedidos,
    SUM(i.preco)                             AS receita
FROM olist.vw_pbi_fato_pedidos AS p
JOIN olist.vw_pbi_fato_itens   AS i ON i.order_id = p.order_id
GROUP BY 1
ORDER BY 1;

-- 7. Pedidos entregues sem data de entrega (entram no modelo, mas sem métricas de prazo)
SELECT COUNT(*) AS entregues_sem_data_entrega
FROM olist.vw_pbi_fato_pedidos
WHERE data_entrega IS NULL;

-- 8. Pedidos sem avaliação (nota nula): normal, não é erro
SELECT COUNT(*) AS pedidos_sem_nota
FROM olist.vw_pbi_fato_pedidos
WHERE nota_avaliacao IS NULL;