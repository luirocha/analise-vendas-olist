// Dim_Produto | origem: Dim_Produto.csv (olist.vw_pbi_dim_produto)
let
    Origem = Csv.Document(
        File.Contents(pPastaCSV & "\Dim_Produto.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Cabecalhos = Table.PromoteHeaders(Origem, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(
        Cabecalhos,
        {
            {"product_id", type text},
            {"categoria", type text},
            {"categoria_en", type text},
            {"qtd_fotos", Int64.Type},
            {"peso_g", type number}
        },
        "en-US"
    ),
    Renomeadas = Table.RenameColumns(
        Tipos,
        {{"categoria", "Categoria"}, {"categoria_en", "Categoria EN"}, {"qtd_fotos", "Qtd Fotos"}, {"peso_g", "Peso (g)"}}
    )
in
    Renomeadas
