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
