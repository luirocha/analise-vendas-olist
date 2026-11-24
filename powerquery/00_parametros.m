// ============================================================
// PARÂMETROS (crie pela interface: Página Inicial > Gerenciar Parâmetros > Novo)
// Estes três valores são o único ponto que muda de máquina para máquina.
// ============================================================

// Nome: pPastaCSV | Tipo: Texto | Valor atual: caminho da pasta data/ do repositório clonado
// Sem barra no final.
"C:\caminho\para\dashboard-vendas-olist\data" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]

// Nome: pInicioAnalise | Tipo: Data | Valor atual: 01/01/2017
#date(2017, 1, 1) meta [IsParameterQuery = true, Type = "Date", IsParameterQueryRequired = true]

// Nome: pFimAnalise | Tipo: Data | Valor atual: 31/08/2018
#date(2018, 8, 31) meta [IsParameterQuery = true, Type = "Date", IsParameterQueryRequired = true]
