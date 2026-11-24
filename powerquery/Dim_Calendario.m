// Dim_Calendario | gerada no Power Query a partir do intervalo de datas de Fato_Pedidos.
// Cobre anos fechados (1 de janeiro do primeiro ano a 31 de dezembro do último),
// requisito para as funções de inteligência de tempo do DAX.
// Nomes de mês e dia são fixos em português para não depender do idioma do Power BI.
let
    InicioDados = List.Min(Fato_Pedidos[data_compra]),
    FimDados = List.Max(Fato_Pedidos[data_compra]),
    Inicio = #date(Date.Year(InicioDados), 1, 1),
    Fim = #date(Date.Year(FimDados), 12, 31),
    QtdDias = Duration.Days(Fim - Inicio) + 1,
    Datas = List.Dates(Inicio, QtdDias, #duration(1, 0, 0, 0)),
    Tabela = Table.FromList(Datas, Splitter.SplitByNothing(), {"Data"}, null, ExtraValues.Error),
    TipoData = Table.TransformColumnTypes(Tabela, {{"Data", type date}}),
    MesesAbrev = {"Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"},
    DiasSemana = {"Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"},
    ColAno = Table.AddColumn(TipoData, "Ano", each Date.Year([Data]), Int64.Type),
    ColTrimestre = Table.AddColumn(ColAno, "Trimestre", each "T" & Text.From(Date.QuarterOfYear([Data])), type text),
    ColMesNum = Table.AddColumn(ColTrimestre, "Mês Nº", each Date.Month([Data]), Int64.Type),
    ColMes = Table.AddColumn(ColMesNum, "Mês", each MesesAbrev{Date.Month([Data]) - 1}, type text),
    ColMesAno = Table.AddColumn(ColMes, "Mês/Ano", each [Mês] & "/" & Text.End(Text.From(Date.Year([Data])), 2), type text),
    ColMesAnoOrdem = Table.AddColumn(ColMesAno, "Mês/Ano Ordem", each Date.Year([Data]) * 100 + Date.Month([Data]), Int64.Type),
    ColDiaSemanaNum = Table.AddColumn(ColMesAnoOrdem, "Dia da Semana Nº", each Date.DayOfWeek([Data], Day.Monday) + 1, Int64.Type),
    ColDiaSemana = Table.AddColumn(ColDiaSemanaNum, "Dia da Semana", each DiasSemana{Date.DayOfWeek([Data], Day.Monday)}, type text),
    ColPeriodo = Table.AddColumn(
        ColDiaSemana,
        "No Período de Análise",
        each if [Data] >= pInicioAnalise and [Data] <= pFimAnalise then "Sim" else "Não",
        type text
    )
in
    ColPeriodo
