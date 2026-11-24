// Dim_Vendedor | origem: Dim_Vendedor.csv (olist.vw_pbi_dim_vendedor)
let
    Origem = Csv.Document(
        File.Contents(pPastaCSV & "\Dim_Vendedor.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Cabecalhos = Table.PromoteHeaders(Origem, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(
        Cabecalhos,
        {
            {"seller_id", type text},
            {"vendedor_codigo", type text},
            {"cidade", type text},
            {"uf", type text},
            {"regiao", type text}
        },
        "en-US"
    ),
    Renomeadas = Table.RenameColumns(
        Tipos,
        {{"vendedor_codigo", "Vendedor"}, {"cidade", "Cidade"}, {"uf", "UF"}, {"regiao", "Região"}}
    )
in
    Renomeadas
