#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4COMR01  ºAutor  ³ Totvs              º Data ³  10/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Pedidos de Compras específico                 º±±
±±º          ³ PL PLCOM07                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION T4COMR01()                  
	Private TITULO		:= "Status dos Pedidos de Compras"
	Private nomeprog	:= "T4COMR01"
	Private oReport		:= Nil
	Private nPag		:= 0
	oReport := ReportDef()

	If Valtype( oReport ) == 'O'
		oReport:PrintDialog()      
	Endif

	oReport := Nil
RETURN
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Totvs         		³ Data ³ 30/09/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ T4F                                        				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
	local aArea	   		:= GetArea()   
	Local CREPORT		:= "T4COMR01"
	Local CDESC			:= OemToAnsi("Este programa ira imprimir o Relatorio para Conferencia")
	Local cPerg	   		:= "T4COMR01" 
	Local CTITULO		:= "Status Aprov. Pedido"

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*

	CriaSx1(cPerg)
	*/
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
		
	If !Pergunte(cPerg,.T.)
		Return
	EndIf 

	oReport	:= TReport():New( cReport,Capital(CTITULO),CPERG, { |oReport| Pergunte(cPerg , .F. ), If(! ReportPrint( oReport ), oReport:CancelPrint(), .T. ) }, CDESC ) 
	oReport:SetEdit(.F.)

	oSection1  := TRSection():New( oReport, "Pedidos de Compras", {"cArqTmp"},, .F., .F. )
	TRCell():New( oSection1, "FILIAL"	,,"Filial"/*Titulo*/	,/*Picture*/, 02 /*Tamanho*/, /*lPixel*/, {|| ALLTRIM(cArqTmp->FILIAL)}/*CodeBlock*/,"LEFT",,"LEFT"  )
	TRCell():New( oSection1, "CODSOLI"	,,"Cod.Sol."/*Titulo*/	,/*Picture*/, 10 /*Tamanho*/, /*lPixel*/, {|| ALLTRIM(cArqTmp->USERSC)}/*CodeBlock*/,"LEFT",,"LEFT"  )
	TRCell():New( oSection1, "NOMESOLI"	,,"Nome "/*Titulo*/	,/*Picture*/, 30 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "LEFT",,"LEFT")
	TRCell():New( oSection1, "CCUSTO"	,,"Centro Custo"/*Titulo*/	,/*Picture*/, 20 /*Tamanho*/, /*lPixel*/, {|| ALLTRIM(cArqTmp->CCUSTO)}/*CodeBlock*/ ,"LEFT",,"LEFT"  )
	TRCell():New( oSection1, "EMISC"	,,"Dt.Emiss.SC"/*Titulo*/	,/*Picture*/, 15 /*Tamanho*/, /*lPixel*/, {|| cArqTmp->DTEMISC}/*CodeBlock*/ ,"LEFT",,"LEFT"  )
	TRCell():New( oSection1, "NUMSC"	,,"Numero SC"/*Titulo*/	,/*Picture*/, 10 /*Tamanho*/, /*lPixel*/, {|| ALLTRIM(cArqTmp->NUMSC)}/*CodeBlock*/ ,"LEFT",,"LEFT"  )
	TRCell():New( oSection1, "EMIPED"	,,"Dt.Emiss.PC"/*Titulo*/	,/*Picture*/, 15 /*Tamanho*/, /*lPixel*/, {|| cArqTmp->DTEMIPC}/*CodeBlock*/ ,"LEFT",,"LEFT"  )
	TRCell():New( oSection1, "NUMPC"	,,"Num.Pedido"/*Titulo*/	,/*Picture*/, 10 /*Tamanho*/, /*lPixel*/, {|| ALLTRIM(cArqTmp->NUMPC)}/*CodeBlock*/ ,"LEFT",,"LEFT"  )
	TRCell():New( oSection1, "VLTOT"	,,"Valor Total"/*Titulo*/	,/*Picture*/, 20 /*Tamanho*/, /*lPixel*/, {|| TRANSFORM(cArqTmp->TOTPC,"@E 99,999,999.99")}/*CodeBlock*/ ,"RIGHT",,"RIGHT"  )
	TRCell():New( oSection1, "STATUS"	,,"Status"/*Titulo*/	,/*Picture*/, 30 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "LEFT",,"LEFT")
	TRCell():New( oSection1, "DTSTATUS"	,,"Dt.Status"/*Titulo*/	,/*Picture*/, 15 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "LEFT",,"LEFT")
	TRCell():New( oSection1, "OBSTATUS"	,,"Obs.Status"/*Titulo*/	,/*Picture*/, 40 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "LEFT",,"LEFT")

	oSection1:SetTotalInLine(.F.)          

Return( oReport )                    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ TOTVS				³ Data ³ 30/09/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )  
	Local oSection1 	:= oReport:Section(1) 
	Local lRet			:= .T.
	Private nLinReport    := 9
	Private cNomeSol := ""
	Private cStatus  := ""
	Private dStatus  := ""
	Private cObStatus:= ""           

	oReport:SetCustomText( {|| CBT4COMR01(titulo,oReport)})

	nRecSM0 	:= SM0->(Recno())
	cEmpAntBkp 	:= cEmpAnt
	cFilAntBkp 	:= cFilAnt
	DbSelectArea("SM0")   
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())        
	SM0->(DbSeek(cEmpAnt))
	While !SM0->(EOF()) .AND. cEmpAnt == SM0->M0_CODIGO

		cEmpAnt	:= SM0->M0_CODIGO
		cFilAnt	:= SM0->M0_CODFIL

		MsAguarde( { || SELDADOS() }, "Selecionando dados. . .")  		

		nCount := 50

		oReport:SetMeter(nCount)

		If nCount > 0

			cArqTmp->(dbGoTop())  

			oSection1:Cell("NOMESOLI"):SetBlock( { || cNomeSol  } )	
			oSection1:Cell("STATUS"):SetBlock(   { || cStatus   } )
			oSection1:Cell("DTSTATUS"):SetBlock( { || DTOC(dStatus)   } )
			oSection1:Cell("OBSTATUS"):SetBlock( { || cObStatus } )

			oSection1:OnPrintLine( {|| 	OnPrint( @nLinReport) } )

			oSection1:Print()

		EndIf

		dbSelectArea("cArqTmp")
		dbCloseArea()

		SM0->(DbSkip())
	EndDo              

	SM0->(DbGoTo(nRecSM0) )
	cEmpAnt	:= cEmpAntBkp
	cFilAnt	:= cFilAntBkp

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSx1   ºAutor  ³Totvs               º Data ³  30/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria grupo de perguntas no SX1                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(cPerg)
	/*
	Local aHelpPor	:= {}
	Local aHelpSpa	:= {}
	Local aHelpEng	:= {}

	PutSx1(cPerg ,"01" ,"Solicitante de ?"  ,"","","MV_CH1" ,"C" ,6 ,0 ,0 ,"G" ,"","USR","" ,"S" ,"MV_PAR01" ,"","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg ,"02" ,"Solicitante ate?"  ,"","","MV_CH2" ,"C" ,6 ,0 ,0 ,"G" ,"","USR","" ,"S" ,"MV_PAR02" ,"","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg ,"03" ,"Centro Custos de?" ,"","","MV_CH3" ,"C" ,TAMSX3("CTT_CUSTO")[1],0 ,0 ,"G" ,"","CTT","" ,"S" ,"MV_PAR03" ,"","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg ,"04" ,"Centro Custos ate?","","","MV_CH4" ,"C" ,TAMSX3("CTT_CUSTO")[1],0 ,0 ,"G" ,"","CTT","" ,"S" ,"MV_PAR04" ,"","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg ,"05" ,"Dt.Emissão SC De?" ,"","","MV_CH5" ,"D" ,08,0 ,0 ,"G" ,"","","" ,"S" ,"MV_PAR05" ,"","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg ,"06" ,"Dt.Emissão SC Ate?","","","MV_CH6" ,"D" ,08,0 ,0 ,"G" ,"","","" ,"S" ,"MV_PAR06" ,"","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg ,"07" ,"Dt.Emissão PC De?" ,"","","MV_CH7" ,"D" ,08,0 ,0 ,"G" ,"","","" ,"S" ,"MV_PAR07" ,"","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg ,"08" ,"Dt.Emissão PC Ate?","","","MV_CH8" ,"D" ,08,0 ,0 ,"G" ,"","","" ,"S" ,"MV_PAR08" ,"","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg ,"09" ,"Status Aprovação"  ,"","","MV_CH9" ,"N" ,1 ,0 ,0 ,"C" ,"","","","S","MV_PAR09" ,"Pendente" ,"" ,"" ,"" ,"Aprovado" ,"" ,"" ,"Reprovado" ,"" ,"" ,"Todos" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"") 

	//------------------------------------------------------------------------- 
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	Aadd(aHelpPor,"Codigo do solicitante.")
	Aadd(aHelpSpa,"")
	Aadd(aHelpEng,"")

	PutSX1Help("P."+cPerg+"01.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
	//-------------------------------------------------------------------------

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	Aadd(aHelpPor,"Codigo do solicitante.")
	Aadd(aHelpSpa,"")
	Aadd(aHelpEng,"")

	PutSX1Help("P."+cPerg+"02.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
	//-------------------------------------------------------------------------

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	Aadd(aHelpPor,"Centro de custos.")
	Aadd(aHelpSpa,"")
	Aadd(aHelpEng,"")

	PutSX1Help("P."+cPerg+"03.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
	//-------------------------------------------------------------------------

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	Aadd(aHelpPor,"Centro de Custos.")
	Aadd(aHelpSpa,"")
	Aadd(aHelpEng,"")

	PutSX1Help("P."+cPerg+"04.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
	//-------------------------------------------------------------------------

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	Aadd(aHelpPor,"Data de Emissão da SC inicial.")
	Aadd(aHelpSpa,"")
	Aadd(aHelpEng,"")

	PutSX1Help("P."+cPerg+"05.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
	//-------------------------------------------------------------------------

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	Aadd(aHelpPor,"Data de Emissão da SC ate.")
	Aadd(aHelpSpa,"")
	Aadd(aHelpEng,"")

	PutSX1Help("P."+cPerg+"06.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
	//-------------------------------------------------------------------------

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	Aadd(aHelpPor,"Data de Emissão da PC inicial.")
	Aadd(aHelpSpa,"")
	Aadd(aHelpEng,"")

	PutSX1Help("P."+cPerg+"07.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
	//-------------------------------------------------------------------------

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	Aadd(aHelpPor,"Data de Emissão da PC final.")
	Aadd(aHelpSpa,"")
	Aadd(aHelpEng,"")
	PutSX1Help("P."+cPerg+"08.",aHelpPor,aHelpEng,aHelpSpa,.T.)
	//-------------------------------------------------------------------------

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	Aadd(aHelpPor,"Status: 1=Pendente;2=Aprovado")
	Aadd(aHelpPor,"        3=Reprovado;4=Todos")
	Aadd(aHelpSpa,"")
	Aadd(aHelpEng,"")
	PutSX1Help("P."+cPerg+"09.",aHelpPor,aHelpEng,aHelpSpa,.T.) 
	//-------------------------------------------------------------------------
	*/
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SELDADOS  ºAutor  ³ TOTVS              º Data ³  30/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ SELECIONADA DADOS PARA IMPRESSAO                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION SELDADOS

	IF SELECT("cArqTmp") > 0
		DBCLOSEAREA("cArqTmp")
	ENDIF



	cQ := "SELECT FILIAL, USERSC, SOLICI, CCUSTO, DTEMISC, NUMSC, DTEMIPC, NUMPC, SUM(TOTPC) TOTPC, ESTLIB"
	cQ += " FROM ("
	cQ += " SELECT C7_FILIAL FILIAL, C1_USER USERSC, C1_NUM SOLICI, C1_CC CCUSTO, C1_EMISSAO DTEMISC, C7_NUMSC NUMSC, C7_EMISSAO DTEMIPC, C7_NUM NUMPC, C7_TOTAL TOTPC, C7_CONAPRO ESTLIB"
	cQ += " FROM "+RetSqlName("SC1")+" SC1 "     
	cQ += " INNER JOIN "+RetSqlName("SC7")+" SC7  ON "
	cQ += " C7_FILIAL = '"+XFILIAL("SC7")+"'"
	cQ += " AND C7_NUMSC = SC1.C1_NUM "                             
	cQ += " AND C7_CC >= '"+mv_par03+"' AND C7_CC <= '"+mv_par04+"'"
	cQ += " AND C7_EMISSAO >= '"+DTOS(mv_par07)+"' AND C7_EMISSAO <= '"+DTOS(mv_par08)+"'"
	cQ += " AND C7_RESIDUO = ' ' "
	IF mv_par09 == 1
		cQ += " AND C7_CONAPRO = 'B' "                                                    
		cQ += " AND NOT EXISTS ("
		cQ += " SELECT DISTINCT(CR_NUM) FROM "+RetSqlName("SCR")+" SCR "
		cQ += " WHERE CR_FILIAL = '"+XFILIAL("SCR")+"'"
		cQ += " AND CR_TIPO = 'PC' "
		cQ += " AND CR_NUM = SC7.C7_NUM "	
		cQ += " AND CR_STATUS = '04' "
		cQ += " AND SCR.D_E_L_E_T_ <> '*' " 
		cQ += " ) "

	ELSEIF mv_par09 == 2	
		cQ += " AND C7_CONAPRO = 'L' "                                                    
	ELSEIF mv_par09 == 3
		cQ += " AND EXISTS ("
		cQ += "SELECT DISTINCT(CR_NUM) FROM "+RetSqlName("SCR")+" SCR "
		cQ += " WHERE CR_FILIAL = '"+XFILIAL("SCR")+"'"
		cQ += " AND CR_TIPO = 'PC' "
		cQ += " AND CR_NUM = SC7.C7_NUM "	
		cQ += " AND CR_STATUS = '04' "
		cQ += " AND SCR.D_E_L_E_T_ <> '*' " 
		cQ += " ) "
	ENDIF		
	cQ += " AND SC7.D_E_L_E_T_ <> '*'"
	cQ += " WHERE "
	cQ += " C1_FILIAL = '"+XFILIAL("SC1")+"'"
	cQ += " AND C1_USER >= '"+mv_par01+"' AND C1_USER <= '"+mv_par02+"'"
	cQ += " AND C1_CC >= '"+mv_par03+"' AND C1_CC <= '"+mv_par04+"'"
	cQ += " AND C1_EMISSAO >= '"+DTOS(mv_par05)+"' AND C1_EMISSAO <= '"+DTOS(mv_par06)+"'"
	cQ += ") X "
	cQ += " GROUP BY FILIAL, USERSC, SOLICI, CCUSTO, DTEMISC, NUMSC, DTEMIPC, NUMPC, ESTLIB "
	cQ += " ORDER BY USERSC "                              
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),"cArqTmp",.T.,.F.)

	TCSetField("cArqTmp","DTEMISC","D",TamSX3("C1_EMISSAO")[1],TamSX3("C1_EMISSAO")[2])
	TCSetField("cArqTmp","DTEMIPC", "D",TamSX3("C1_EMISSAO")[1],TamSX3("C1_EMISSAO")[2])
	TCSetField("cArqTmp","TOTPC", "N" ,TamSX3("C7_TOTAL")[1],TamSX3("C7_TOTAL")[2])

	DbSelectArea("cArqTmp")
	DbGoTop()                         

RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OnPrint       ºAutor ³ José Mauricio    º Data ³ 30/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa acoes especificadas nos parametros do relatorio,   º±±
±±º          ³ antes de imprimir cada linha.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OnPrint( nLinReport )

	Local lRet := .T.           

	nLinReport++

	If nLinReport > 55 
		oReport:EndPage()
		nLinReport := 10
	EndIf

	// Veirifca o SCR para atualizar o status          

	cNomeSol := Alltrim(UsrFullName(cArqTmp->USERSC))
	cStatus  := ""                            
	dStatus  := CTOD(SPACE(8))
	cObStatus:= " "

	IF cArqTmp->ESTLIB == "B"

		// Verifica se esta reprovado

		cQ := "SELECT DISTINCT(CR_NUM), CR_NIVEL, CR_DATALIB, CR_USERLIB FROM "+RetSqlName("SCR")+" SCR "
		cQ += " WHERE CR_FILIAL = '"+XFILIAL("SCR")+"'"
		cQ += " AND CR_TIPO = 'PC' "
		cQ += " AND CR_NUM = '"+cArqTmp->NUMPC+"'"	
		cQ += " AND CR_STATUS = '04' "
		cQ += " AND SCR.D_E_L_E_T_ <> '*' " 
		TcQuery ChangeQuery(cQ) ALIAS "QSCR" NEW    

		IF QSCR->(!EOF())	
			cStatus  := "3-Reprovado"
			dStatus  := STOD(QSCR->CR_DATALIB)
			cObStatus:= "Nivel: "+QSCR->CR_NIVEL+" - "+Alltrim(UsrFullName(QSCR->CR_USERLIB))

		ELSE	// Verifica se tem aprovação

			cStatus  := "1-Pendente"                

			cQ := "SELECT DISTINCT(SCR.CR_NUM), SCR.CR_NIVEL, SCR.CR_DATALIB, SCR.CR_USERLIB FROM "+RetSqlName("SCR")+" SCR"
			cQ += " WHERE "
			cQ += " SCR.CR_TIPO = 'PC' "
			cQ += " AND SCR.CR_NIVEL IN "
			cQ += "(SELECT MAX(CR_NIVEL) FROM "+RetSqlName("SCR")+"  SCR1 "
			cQ += " WHERE SCR1.CR_TIPO = 'PC' "
			cQ += " AND SCR1.CR_NUM = SCR.CR_NUM "
			cQ += " AND SCR1.CR_STATUS = '03' "
			cQ += " AND SCR1.D_E_L_E_T_ <> '*') "   
			cQ += " AND SCR.CR_NUM = '"+cArqTmp->NUMPC+"'"			
			cQ += " AND SCR.CR_STATUS = '03'  AND SCR.D_E_L_E_T_ <> '*' "
			TcQuery ChangeQuery(cQ) ALIAS "QSCR1" NEW    

			IF QSCR1->(!EOF())
				dStatus  := STOD(QSCR1->CR_DATALIB)
				If Empty(dStatus) 
					dStatus  := cArqTmp->DTEMIPC
				EndIf
			ENDIF	

			QSCR1->(DBCLOSEAREA())	

			// Proximo Aprovador			

			cQ := "SELECT DISTINCT(SCR.CR_NUM), SCR.CR_NIVEL, SCR.CR_DATALIB, SCR.CR_USER FROM "+RetSqlName("SCR")+" SCR"
			cQ += " WHERE "
			cQ += " SCR.CR_TIPO = 'PC' "
			cQ += " AND SCR.CR_NIVEL IN "
			cQ += "(SELECT MIN(CR_NIVEL) FROM "+RetSqlName("SCR")+"  SCR1 "
			cQ += " WHERE SCR1.CR_TIPO = 'PC' "
			cQ += " AND SCR1.CR_NUM = SCR.CR_NUM "
			cQ += " AND SCR1.CR_STATUS NOT IN('03','04') "
			cQ += " AND SCR1.D_E_L_E_T_ <> '*') "
			cQ += " AND SCR.CR_NUM = '"+cArqTmp->NUMPC+"'"			
			cQ += " AND SCR.CR_STATUS  NOT IN('03','04')  AND SCR.D_E_L_E_T_ <> '*' "
			TcQuery ChangeQuery(cQ) ALIAS "QSCR1" NEW    

			IF QSCR1->(!EOF())
				cObStatus:= "Nivel: "+QSCR1->CR_NIVEL+" - "+Alltrim(UsrFullName(QSCR1->CR_USER)) 
				dStatus  := STOD(QSCR1->CR_DATALIB)   
				If Empty(dStatus) 
					dStatus  := cArqTmp->DTEMIPC
				EndIf			
			ENDIF	
			QSCR1->(DBCLOSEAREA())	

		ENDIF

		QSCR->(DBCLOSEAREA())    


	ELSEIF cArqTmp->ESTLIB == "L"

		cStatus  := "2-Aprovado"

		cQ := "SELECT DISTINCT(SCR.CR_NUM), SCR.CR_NIVEL, SCR.CR_DATALIB, SCR.CR_USERLIB FROM "+RetSqlName("SCR")+" SCR"
		cQ += " WHERE "
		cQ += " SCR.CR_TIPO = 'PC' "
		cQ += " AND SCR.CR_NIVEL IN "
		cQ += "(SELECT MAX(CR_NIVEL) FROM "+RetSqlName("SCR")+"  SCR1 "
		cQ += " WHERE SCR1.CR_TIPO = 'PC' "
		cQ += " AND SCR1.CR_NUM = SCR.CR_NUM "
		cQ += " AND SCR1.CR_STATUS = '03' "
		cQ += " AND SCR1.D_E_L_E_T_ <> '*') "
		cQ += " AND SCR.CR_NUM = '"+cArqTmp->NUMPC+"'"			
		cQ += " AND SCR.CR_STATUS = '03'  AND SCR.D_E_L_E_T_ <> '*' "
		TcQuery ChangeQuery(cQ) ALIAS "QSCR1" NEW    
		IF QSCR1->(!EOF())
			dStatus  := STOD(QSCR1->CR_DATALIB)    
			cObStatus:= "Nivel: "+QSCR1->CR_NIVEL+" - "+Alltrim(UsrFullName(QSCR1->CR_USERLIB))
			If Empty(dStatus) 
				dStatus  := cArqTmp->DTEMIPC
			EndIf	  
		Else
			dStatus  := cArqTmp->DTEMIPC
			cObStatus:= "Aprovado sem alçadas"
		ENDIF
		QSCR1->(DBCLOSEAREA())			
	ENDIF    

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ  '
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CBT4COMR01  ºAutor  ³Totvs             º Data ³  30/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cabeçalho                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CBT4COMR01(titulo,oReport)
	Local cNmEmp   
	Local cChar			:= chr(160)  // caracter dummy para alinhamento do cabeçalho
	Local aCab 		:= {}

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	SX3->( DbSetOrder(2) )
	SX3->( MsSeek( "A1_CGC" , .t.))

	If SM0->(Eof())                                
		SM0->( MsSeek( cEmpAnt + cFilAnt , .T. ))
	Endif

	Aadd( aCab, AllTrim( SM0->M0_NOMECOM ))
	Aadd( aCab, AllTrim( titulo ) )
	Aadd( aCab, Transform( Alltrim( SM0->M0_CGC ), alltrim( SX3->X3_PICTURE )))
	*/

	If SM0->(Eof())                                
		SM0->( MsSeek( cEmpAnt + cFilAnt , .T. ))
	Endif

	Aadd( aCab, AllTrim( SM0->M0_NOMECOM ))
	Aadd( aCab, AllTrim( titulo ) )
	Aadd( aCab, Transform( Alltrim( SM0->M0_CGC ), alltrim( GetSX3Cache("A1_CGC" ,"X3_PICTURE"	) )))

	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	cNmEmp	:= AllTrim( SM0->M0_NOMECOM )

	aCabec := {	"__LOGOEMP__"; 
				, cChar + "         " + cNmEmp 					;
				, "SIGA /" + "T4COMR01" 						;
				+ "         " + cChar + AllTrim(titulo) 		;
				+ "         " + cChar							;
				, RptHora + " " + time() 						;
				+ "         " + cChar + " " + Dtoc(dDataBase) 	}

Return aCabec