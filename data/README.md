# Dados — Brazilian E-Commerce Olist

Os arquivos de dados não estão no repositório (arquivos grandes).

## Como baixar
1. Acesse kaggle.com/datasets/olistbr/brazilian-ecommerce
2. Clique em 'Download' (conta Kaggle necessária — gratuita)
3. Descompacte o arquivo .zip
4. Coloque os 9 CSVs nesta pasta (data/)

## Importar no PostgreSQL via DBeaver
1. Conecte ao PostgreSQL local no DBeaver
2. Crie o schema: clique com botão direito em 'postgres' → Criar → Schema → nome: olist
3. Dentro do schema olist: botão direito → Importar dados → selecione cada CSV
4. Nome da tabela = nome do arquivo sem 'dataset' e sem '.csv'
   Exemplo: olist_orders_dataset.csv → tabela: olist_orders

**Observação:** o arquivo `olist_order_reviews_dataset.csv` apresentou erro
de importação pelo wizard do DBeaver (provável conflito de encoding/aspas
nos campos de texto). Nesse caso, a tabela foi criada manualmente e os
dados importados via comando COPY nativo do PostgreSQL:

    CREATE TABLE olist.olist_order_reviews (
        review_id               TEXT,
        order_id                TEXT,
        review_score            INTEGER,
        review_comment_title    TEXT,
        review_comment_message  TEXT,
        review_creation_date    VARCHAR(50),
        review_answer_timestamp VARCHAR(50)
    );

    COPY olist.olist_order_reviews
    FROM '<seu_caminho>/olist_order_reviews_dataset.csv'
    DELIMITER ','
    CSV HEADER
    QUOTE '"';

## Tabelas (9 no total)
olist_customers · olist_geolocation · olist_order_items
olist_order_payments · olist_order_reviews · olist_orders
olist_products · olist_sellers · product_category_name_translation

## Arquivos esperados nesta pasta

Estes cinco arquivos são gerados pelas views do schema `olist` (scripts em `sql/`) e lidos pelo Power Query:

| Arquivo            | View de origem              | Grão                        |
| ------------------ | --------------------------- | --------------------------- |
| `Dim_Cliente.csv`  | `olist.vw_pbi_dim_cliente`  | 1 linha por `customer_id`   |
| `Dim_Vendedor.csv` | `olist.vw_pbi_dim_vendedor` | 1 linha por `seller_id`     |
| `Dim_Produto.csv`  | `olist.vw_pbi_dim_produto`  | 1 linha por `product_id`    |
| `Fato_Pedidos.csv` | `olist.vw_pbi_fato_pedidos` | 1 linha por pedido entregue |
| `Fato_Itens.csv`   | `olist.vw_pbi_fato_itens`   | 1 linha por item entregue   |

O nome do arquivo precisa ser exatamente este (inclusive maiúsculas), porque o Power Query monta o caminho com `pPastaCSV & "\Nome.csv"`.
Clique com o botão direito na view > Exportar dados > CSV.
