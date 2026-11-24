-- PROJETO: Dashboard de Vendas Olist (modelo dimensional para o Power BI)
-- Tabela de apoio: UF e região geográfica (IBGE), usada por clientes e vendedores.
-- Autor: Luí Rocha

CREATE OR REPLACE VIEW olist.vw_pbi_uf_regiao AS
SELECT uf, regiao
FROM (VALUES
    ('AC', 'Norte'),
    ('AP', 'Norte'),
    ('AM', 'Norte'),
    ('PA', 'Norte'),
    ('RO', 'Norte'),
    ('RR', 'Norte'),
    ('TO', 'Norte'),
    ('AL', 'Nordeste'),
    ('BA', 'Nordeste'),
    ('CE', 'Nordeste'),
    ('MA', 'Nordeste'),
    ('PB', 'Nordeste'),
    ('PE', 'Nordeste'),
    ('PI', 'Nordeste'),
    ('RN', 'Nordeste'),
    ('SE', 'Nordeste'),
    ('DF', 'Centro-Oeste'),
    ('GO', 'Centro-Oeste'),
    ('MT', 'Centro-Oeste'),
    ('MS', 'Centro-Oeste'),
    ('ES', 'Sudeste'),
    ('MG', 'Sudeste'),
    ('RJ', 'Sudeste'),
    ('SP', 'Sudeste'),
    ('PR', 'Sul'),
    ('RS', 'Sul'),
    ('SC', 'Sul')
) AS t (uf, regiao);

SELECT * FROM olist.vw_pbi_uf_regiao;