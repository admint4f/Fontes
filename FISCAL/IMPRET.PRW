#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} IMPRET
Relatório de conferencia contábil e fiscal
@type function
@version 1.00
@author Lucas Valins
@since 27/08/2020
@return return_type, return_description
/*/

User Function IMPRET()

	Private oReport  := Nil 
	Private oSecCab	 := Nil
	Private cPerg 	 := "IMPRET"

Pergunte(cPerg,.T.)

ReportDef()

oReport:PrintDialog() 

Return 


Static Function ReportDef()

oReport := TReport():New("SD1","Relatorio - SD1",cPerg,{|oReport| PrintReport(oReport)},"Relatorio - SD1")

oReport:SetLandscape(.T.)
oReport:SetTotalInLine(.F.)

oSecCab := TRSection():New( oReport , "SD1", {"SQL"} )

	TRCell():New( oSecCab, "D1_FILIAL"	  ,"SD1", "Filial") 
	TRCell():New( oSecCab, "D1_DTDIGIT"	  ,"SD1", "Entrada") 
	TRCell():New( oSecCab, "F1_DTLANC"	  ,"SD1", "Contabilizacao") 
	TRCell():New( oSecCab, "E2_BAIXA"	  ,"SE2", "Baixa") 
	TRCell():New( oSecCab, "D1_COD"       ,"SD1", "Codigo")
	TRCell():New( oSecCab, "D1_TP"        ,"SD1", "Tipo")
	TRCell():New( oSecCab, "B1_CODISS"    ,"SD1", "Cod.Serv")
	TRCell():New( oSecCab, "B1_POSIPI"    ,"SB1", "NCM") 
	TRCell():New( oSecCab, "B1_DESC"      ,"SB1", "Descricao") 
	TRCell():New( oSecCab, "D1_DOC"       ,"SD1", "NF")
	TRCell():New( oSecCab, "D1_SERIE"     ,"SD1", "Serie")
	TRCell():New( oSecCab, "F1_ESPECIE"   ,"SF1", "Especie")
	TRCell():New( oSecCab, "D1_FORNECE"   ,"SD1", "Cod.Forn")
	TRCell():New( oSecCab, "D1_LOJA"      ,"SD1", "Loja")
	TRCell():New( oSeccab, "A2_NOME"      ,"SA2", "Fornecedor")
	TRCell():New( oSeccab, "A2_CGC"       ,"SA2", "Cnpj")
	TRCell():New( oSeccab, "A2_SIMPNAC"   ,"SA2", "Simples?")
	TRCell():New( oSeccab, "FT_RECISS"    ,"SFT", "Recolhe ISS?")
	TRCell():New( oSeccab, "F4_CODIGO"    ,"SF4", "TES")
	TRCell():New( oSeccab, "D1_CF"        ,"SD1", "CFOP")
	TRCell():New( oSecCab, "D1_QUANT"     ,"SD1", "Quantidade")
	TRCell():New( oSecCab, "D1_VUNIT"     ,"SD1", "Unitario")
	TRCell():New( oSeccab, "D1_TOTAL"     ,"SD1", "Valor total")
	TRCell():New( oSeccab, "D1_BASEICM"   ,"SD1", "Base ICMS")
	TRCell():New( oSeccab, "D1_PICM"      ,"SD1", "Alq. ICMS")
	TRCell():New( oSeccab, "D1_VALICM"    ,"SD1", "ICMS")
	TRCell():New( oSeccab, "D1_VALIMP6"   ,"SD1", "Cred. Pis")
	TRCell():New( oSeccab, "D1_VALIMP5"   ,"SD1", "Cred. Cofins")
	TRCell():New( oSeccab, "D1_VALIRR"    ,"SD1", "IRRF")
	TRCell():New( oSeccab, "D1_VALPIS"    ,"SD1", "PIS")
	TRCell():New( oSeccab, "D1_VALCOF"    ,"SD1", "COFINS")
	TRCell():New( oSeccab, "D1_VALCSL"    ,"SD1", "CSLL")
	TRCell():New( oSeccab, "D1_VALISS"    ,"SD1", "ISS")
	TRCell():New( oSeccab, "D1_VALINS"    ,"SD1", "INSS")

	TRFunction():New(oSecCab:Cell("D1_TOTAL")    ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_BASEICM")  ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_VALICM")   ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_VALIMP6")  ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_VALIMP5")  ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_VALIRR")   ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_VALPIS")   ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_VALCOF")   ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_VALCSL")   ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_VALISS")   ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)
	TRFunction():New(oSecCab:Cell("D1_VALINS")   ,,"SUM"  ,,,,,.F.,.T.,.T.,oSecCab)

oSecCab:PrintLine()

Return 

Static Function PrintReport(oReport)
Local cAlias := GetNextAlias()

oSecCab:BeginQuery() 
	BeginSql Alias cAlias

		SELECT  D1_FILIAL, D1_DTDIGIT, F1_DTLANC, E2_BAIXA, D1_COD, D1_TP, B1_CODISS, B1_POSIPI, B1_DESC, D1_DOC , D1_SERIE, F1_ESPECIE, D1_FORNECE, D1_LOJA, A2_NOME, 
			  	A2_CGC, A2_SIMPNAC, FT_RECISS, F4_CODIGO, D1_CF, D1_QUANT, D1_VUNIT, D1_TOTAL, D1_BASEICM, D1_PICM , D1_VALICM, D1_VALIMP6, D1_VALIMP5,  D1_VALIRR, 
				D1_VALPIS, D1_VALCOF, D1_VALCSL, D1_VALISS, D1_VALINS
		
		FROM %table:SD1% SD1
		
		LEFT JOIN %table:SA2% SA2 ON SA2.A2_COD     = SD1.D1_FORNECE AND SD1.D1_LOJA    = SA2.A2_LOJA
		LEFT JOIN %table:SB1% SB1 ON SB1.B1_COD     = SD1.D1_COD
		LEFT JOIN %table:SF1% SF1 ON SF1.F1_DOC     = SD1.D1_DOC     AND SF1.F1_SERIE   = SD1.D1_SERIE   AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA
		LEFT JOIN %table:SF4% SF4 ON SF4.F4_CODIGO  = SD1.D1_TES
		LEFT JOIN %table:SE2% SE2 ON SE2.E2_NUM     = SD1.D1_DOC     AND SE2.E2_FORNECE = SD1.D1_FORNECE AND SE2.E2_LOJA    = SD1.D1_LOJA
		LEFT JOIN %table:SFT% SFT ON SFT.FT_NFISCAL = SD1.D1_DOC     AND SFT.FT_SERIE   = SD1.D1_SERIE   AND SFT.FT_CLIEFOR = SD1.D1_FORNECE AND SFT.FT_LOJA = SD1.D1_LOJA AND SFT.FT_PRODUTO = SD1.D1_COD AND SFT.FT_ITEM = SD1.D1_ITEM
		
		WHERE 
			SD1.%notDel% AND
			SF1.%notDel% AND
			SB1.%notDel% AND
			SA2.%notDel% AND
			SF4.%notDel% AND
			SE2.%notDel% AND
			SFT.%notDel% AND
			SD1.D1_DTDIGIT BETWEEN %exp:(dtos(MV_PAR01))% AND %exp:(dtos(MV_PAR02))% AND
			SF1.F1_DTLANC BETWEEN %exp:(dtos(MV_PAR03))% AND %exp:(dtos(MV_PAR04))% AND
			SE2.E2_BAIXA BETWEEN %exp:(dtos(MV_PAR05))% AND %exp:(dtos(MV_PAR06))% 

	EndSql

oSecCab:EndQuery()
oSecCab:Print()

(cAlias)->(DbCloseArea())

Return 
