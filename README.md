# Análise de Vendas — Olist E-Commerce

## Por que esta análise existe

**Contexto:** Marketplaces brasileiros enfrentam o desafio de equilibrar
crescimento de volume com qualidade de experiência do cliente.

**Necessidade:** Gestores de negócio precisam de visibilidade sobre
quais estados, categorias e vendedores impulsionam ou comprometem
a performance do marketplace.

**Visão:** Um pipeline SQL → Power BI com modelo dimensional completo,
permitindo drill-down por região, categoria e período.

**Resultado esperado:** Um gestor consegue identificar as 3 alavancas
principais de crescimento e os 2 maiores riscos operacionais
com base em dados de 100 mil pedidos reais.

## Perguntas Analíticas
1. Quais estados concentram faturamento e ticket médio mais alto?
2. Quais categorias crescem mais rápido e quais estão em declínio?
3. Existe relação entre tempo de entrega e satisfação do cliente?
4. Quais características definem os vendedores com melhor equilíbrio entre volume e qualidade?

## Stack Técnica
SQL (PostgreSQL) · Power BI Desktop + DAX · Power Query · PBI Service

## Dados
Brazilian E-Commerce Public Dataset by Olist — Kaggle
kaggle.com/datasets/olistbr/brazilian-ecommerce
9 tabelas | ~100 mil pedidos | 2016–2018

## Como reproduzir
1. Baixe os 9 CSVs do Kaggle
2. Importe no PostgreSQL no schema 'olist' via DBeaver
3. Execute sql/01_exploracao_inicial.sql para verificar os dados
4. Abra powerbi/dashboard_olist.pbix (Power BI Desktop necessário)

## Dashboard
[Link do Power BI Service] — *será adicionado futuramente*

