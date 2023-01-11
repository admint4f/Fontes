#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
/*/{Protheus.doc} RELFISPC
Relatório Fiscal p/ cc
@type function
@version 1.00
@author Lucas Valins
@since 21/03/2021
@return return_type, return_description
/*/

User Function RELFISPC()
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := "RELFISPC"

	Pergunte(cPerg,.T.)

	ReportDef()
	oReport:PrintDialog()
Return

Static Function ReportDef()
	oReport := TReport():New("SD1","Relatório por cc - SD1",cPerg,{|oReport| PrintReport(oReport)},"Relatorio - SD1")
	oReport:SetLandscape(.T.)
	oReport:SetTotalInLine(.F.)
	oSecCab := TRSection():New( oReport,"SD1", {"SQL"} )
	TRCell():New( oSecCab, "D1_FILIAL" ,"SD1", "Filial")
	TRCell():New( oSecCab, "D1_DOC"	   ,"SD1", "Documento")
	TRCell():New( oSecCab, "D1_PEDIDO" ,"SD1", "Pedido")
	TRCell():New( oSecCab, "D1_FORNECE","SD1", "Cod.Fornecedor")
	TRCell():New( oSecCab, "D1_LOJA"   ,"SD1", "Loja")
	TRCell():New( oSecCab, "A2_NOME"   ,"SA2", "Nome")
	TRCell():New( oSecCab, "D1_COD"    ,"SD1", "Produto")
	TRCell():New( oSecCab, "B1_DESC"   ,"SB1", "Descrição")
	TRCell():New( oSecCab, "D1_DTDIGIT","SD1", "Entrada")
	TRCell():New( oSecCab, "E2_VENCREA","SE2", "Vencimento")
	TRCell():New( oSecCab, "E2_BAIXA"  ,"SE2", "DT.Baixa")
	TRCell():New( oSecCab, "D1_TOTAL"  ,"SD1", "Val.Prod Total")
	TRCell():New( oSecCab, "DE_PERC"   ,"SDE", "%")
	TRCell():New( oSecCab, "RATEADO"   ,"SD1", "Valor Rateado")
	TRCell():New( oSecCab, "CC"        ,"SD1", "CC")
	TRCell():New( oSecCab, "CTT_DESC01","CTT", "Descr.CC")
	TRCell():New( oSecCab, "ITEMCONT"  ,"SD1", "EPEP")
	TRCell():New( oSecCab, "CTD_DESC01","CTD", "Descr.EPEP")
	TRCell():New( oSecCab, "D1_RATEIO" ,"SD1", "Rateio?")

	TRFunction():New(oSecCab:Cell("D1_TOTAL"),,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("RATEADO"),,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	oSecCab:PrintLine()
Return

Static Function PrintReport(oReport)
	Local cAlias := GetNextAlias()
	oSecCab:BeginQuery()
	BeginSql Alias cAlias
		SELECT  
		D1_FILIAL, 
		D1_DOC,
		D1_PEDIDO, 
		D1_FORNECE, 
		D1_LOJA, 
		A2_NOME, 
		D1_COD, 
		B1_DESC, 
		D1_DTDIGIT, 
		E2_VENCREA,
        E2_BAIXA, 
		D1_TOTAL, 
		DE_PERC,
		(DE_PERC/100*D1_TOTAL) AS RATEADO, 
		(CASE WHEN D1_RATEIO ='2' THEN D1.D1_XCCAPR	WHEN D1_RATEIO ='1' THEN DE.DE_CC END ) AS CC, 
		CTT_DESC01, 
		(CASE WHEN D1_RATEIO ='2' THEN D1.D1_ITEMCTA WHEN D1_RATEIO ='1' THEN DE.DE_ITEMCTA END ) AS ITEMCONT, 
		CTD_DESC01,
		D1_RATEIO
		FROM %table:SD1% D1
		LEFT JOIN %table:SDE% DE ON D1.D1_DOC = DE.DE_DOC AND D1.D1_FORNECE = DE.DE_FORNECE AND 
								D1.D1_LOJA = DE.DE_LOJA AND D1.D1_SERIE = DE.DE_SERIE AND DE.DE_ITEMNF = D1.D1_ITEM AND 
								D1.D1_FILIAL = DE.DE_FILIAL AND	DE.D_E_L_E_T_ = D1.D_E_L_E_T_
        LEFT JOIN %table:SB1% B1 ON D1.D1_COD = B1.B1_COD 
        LEFT JOIN %table:SA2% A2 ON D1.D1_FORNECE = A2.A2_COD AND D1.D1_LOJA = A2.A2_LOJA
        LEFT JOIN %table:SE2% E2 ON E2.E2_NUM = D1.D1_DOC AND E2.E2_FORNECE = D1.D1_FORNECE AND E2.E2_LOJA = D1.D1_LOJA
        LEFT JOIN %table:CTT% TT ON (CASE 
									WHEN D1.D1_RATEIO = '1' AND TT.CTT_CUSTO = DE.DE_CC THEN 1 
									WHEN D1.D1_RATEIO = '2' AND TT.CTT_CUSTO = D1.D1_XCCAPR THEN 1 
									ELSE 0 END = 1) AND
		 							TT.D_E_L_E_T_ = D1.D_E_L_E_T_
        LEFT JOIN %table:CTD% TD ON (CASE 
									WHEN D1.D1_RATEIO = '1' AND TD.CTD_ITEM = DE.DE_ITEMCTA THEN 1 
									WHEN D1.D1_RATEIO = '2' AND TD.CTD_ITEM = D1.D1_ITEMCTA THEN 1
									ELSE 0 END = 1)  AND
									 TD.D_E_L_E_T_ = D1.D_E_L_E_T_
		WHERE
			D1.%notDel% AND
			B1.%notDel% AND
            A2.%notDel% AND
            E2.%notDel% AND
			D1.D1_DTDIGIT BETWEEN %exp:(dtos(MV_PAR01))% AND %exp:(dtos(MV_PAR02))% AND
			E2.E2_BAIXA BETWEEN %exp:(dtos(MV_PAR03))% AND %exp:(dtos(MV_PAR04))% AND
			E2.E2_VENCREA BETWEEN %exp:(dtos(MV_PAR05))% AND %exp:(dtos(MV_PAR06))% AND
			TT.CTT_CUSTO BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08% AND
			A2.A2_COD BETWEEN %exp:MV_PAR09% AND %exp:MV_PAR10%
	EndSql
	oSecCab:EndQuery()
	oSecCab:Print()
	(cAlias)->(DbCloseArea())
Return
