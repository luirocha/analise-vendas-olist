// Fato_Itens | origem: Fato_Itens.csv (olist.vw_pbi_fato_itens)
// preco e frete usam Currency.Type (decimal fixo) para evitar erro de ponto flutuante nas somas.
// Atenção: o argumento "en-US" garante que ponto seja separador decimal.
// Sem ele, um Power BI em português interpretaria 12.50 de forma errada.
let
    Origem = Csv.Document(
        File.Contents(pPastaCSV & "\Fato_Itens.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Cabecalhos = Table.PromoteHeaders(Origem, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(
        Cabecalhos,
        {
            {"order_id", type text},
            {"item_id", Int64.Type},
            {"product_id", type text},
            {"seller_id", type text},
            {"preco", Currency.Type},
            {"frete", Currency.Type}
        },
        "en-US"
    )
in
    Tipos
