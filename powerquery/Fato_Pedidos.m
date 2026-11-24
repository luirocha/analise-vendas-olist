// Fato_Pedidos | origem: Fato_Pedidos.csv (olist.vw_pbi_fato_pedidos)
// Atenção: o argumento "en-US" garante que ponto seja separador decimal.
// Sem ele, um Power BI em português interpretaria 12.50 de forma errada.
let
    Origem = Csv.Document(
        File.Contents(pPastaCSV & "\Fato_Pedidos.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Cabecalhos = Table.PromoteHeaders(Origem, [PromoteAllScalars = true]),
    Tipos = Table.TransformColumnTypes(
        Cabecalhos,
        {
            {"order_id", type text},
            {"customer_id", type text},
            {"customer_unique_id", type text},
            {"data_compra", type date},
            {"data_entrega", type date},
            {"data_entrega_estimada", type date},
            {"dias_entrega", type number},
            {"dias_prazo_estimado", Int64.Type},
            {"dias_diferenca_prazo", Int64.Type},
            {"entregue_no_prazo", Int64.Type},
            {"faixa_atraso", type text},
            {"valor_pagamento_total", Currency.Type},
            {"parcelas_max", Int64.Type},
            {"faixa_parcelas", type text},
            {"tipo_pagamento_principal", type text},
            {"nota_avaliacao", Int64.Type}
        },
        "en-US"
    ),
    Renomeadas = Table.RenameColumns(
        Tipos,
        {
            {"faixa_atraso", "Faixa de Atraso"},
            {"faixa_parcelas", "Faixa de Parcelas"},
            {"tipo_pagamento_principal", "Tipo de Pagamento"},
            {"nota_avaliacao", "Nota"}
        }
    )
in
    Renomeadas
