// Dim_Cliente | origem: Dim_Cliente.csv (olist.vw_pbi_dim_cliente)
let
    Origem = Csv.Document(
        File.Contents(pPastaCSV & "\Dim_Cliente.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Cabecalhos = Table.PromoteHeaders(Origem, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(
        Cabecalhos,
        {
            {"customer_id", type text},
            {"customer_unique_id", type text},
            {"cidade", type text},
            {"uf", type text},
            {"regiao", type text}
        },
        "en-US"
    ),
    Renomeadas = Table.RenameColumns(
        Tipos,
        {{"cidade", "Cidade"}, {"uf", "UF"}, {"regiao", "Região"}}
    )
in
    Renomeadas
