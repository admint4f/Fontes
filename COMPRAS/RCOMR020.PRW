#include "rwmake.ch"
#include "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOMR020 º Autor ³Luiz Eduardo        º Data ³  29/03/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Pedidos de compras X Notas Fiscais de Entrada º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RCOMR020()
	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "Pedidos de Compras X Notas de Entrada"
	Local cPict        := ""
	Local titulo       := "Pedidos de Compras X Notas de Entrada"
	Local nLin         := 80
	Local imprime      := .T.
	Local aOrd 		   := {}
	Local aPergs	   := {}

	//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//0         10        20        30        40        50        60        70        80        90        100       110       120       130
	//Solicitacao  Data Emissao  Solicitante              Valor Total  Centro Custo                              Nivel de Aprovacao
	//999999       99/99/99      XXXXXXXXXXXXXXXXXXXX  999,999,999.99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99 - XXXXXXXXXXXXXXX
	//999999       99/99/99      XXXXXXXXXXXXXXXXXXXX  999,999,999.99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99 - XXXXXXXXXXXXXXX
	//999999       99/99/99      XXXXXXXXXXXXXXXXXXXX  999,999,999.99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99 - XXXXXXXXXXXXXXX
	//999999       99/99/99      XXXXXXXXXXXXXXXXXXXX  999,999,999.99  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99 - XXXXXXXXXXXXXXX
	Local Cabec1       := "Solicitacao  Data Emissao  Solicitante              Valor Total  Centro Custo                              Nivel de Aprovacao"
	Local Cabec2       := ""

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 132
	Private tamanho      := "M"
	Private nomeprog     := "RCOMR020"
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg        := "RCOMR1"
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RCOMR010"

	Private nHdl		:= 0
	Private i			:= 0
	Private cFile		:= ""
	Private oExcel	:= Nil  
	Private aAreaSM0	:= SM0->(GetArea())
	Private aCabec	:= {} 
	Private cLinhaCSV	:= ""

	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))

	//Grupo de Perguntas do relatorio
	Aadd(aPergs,{"RCOMR1","01","Da Emissao"			,"mv_ch1"	,"D",08,00,"G","","mv_par01","","","","","","",""})
	Aadd(aPergs,{"RCOMR1","02","Ate a Emissao"		,"mv_ch2"	,"D",08,00,"G","","mv_par02","","","","","","",""})

	ValidSX1(aPergs)
	Pergunte("RCOMR1",.F.)

	wnrel := SetPrint("SC7",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,"SC7")

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³Bruno Daniel Borges º Data ³  11/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Impressao do relatorio                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	
	Local cQuery	:= ""
	Local nTotReg	:= 0  
	Local aAlcada  := {}
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	//Query do Programa
	/*
	cQuery := " SELECT C7.C7_EMISSAO, D1.D1_PEDIDO, C7.C7_USUARIO, D1.D1_DOC, D1.D1_FORNECE "+_EOL
	cQuery += " FROM " + RetSQLName("SD1") + " D1,"+RetSQLName("SC7")+ " C7 "+_EOL
	cQuery += " WHERE C7.C7_EMISSAO BETWEEN '" + DToS(mv_par01) + "' AND '" + DToS(mv_par02) + "' "+_EOL
	cQuery += " AND D1.D1_PEDIDO=C7.C7_NUM AND D1.D1_FORNECE=C7.C7_FORNECE "+_EOL
	cQuery += " AND C7.D_E_L_E_T_ = ' ' AND D1.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY C7.C7_EMISSAO, D1.D1_PEDIDO, C7.C7_USUARIO, D1.D1_DOC, D1.D1_FORNECE "+_EOL
	cQuery += " ORDER BY C7.C7_EMISSAO "

	If Select("trb") > 0
	DbSelectArea("TRB")
	DbCloseArea()
	Endif
	TCQUERY cQuery NEW ALIAS "TRB"
	DbSelectArea("TRB")
	nTotReg := reccount()
	DBGOTOP()
	_cArqTrb:= CriaTrab(nil,.f.)
	Copy To &(_cArqTrb)

	DbCloseArea()

	aCampos := {}
	AADD(aCampos,{ "C7_EMISSAO"	, "C",10,0})
	AADD(aCampos,{ "D1_PEDIDO" 	, "C",10,0})
	AADD(aCampos,{ "C7_USUARIO"	, "C",20,0})
	AADD(aCampos,{ "D1_DOC"   	, "C",10,0})
	AADD(aCampos,{ "D1_FORNECE"	, "C",09,0})

	cTemp2 := CriaTrab(nil,.f.)
	dbCreate(cTemp2,aCampos)
	dbUseArea( .T.,,cTemp2, "TRB", Nil, .F. )

	APPEND FROM &(_cArqTrb)
	*/
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif
	
	BeginSQL Alias "TRB"

		COLUMN C7_EMISSAO AS DATE

		SELECT	C7.C7_EMISSAO, 
				D1.D1_PEDIDO, 
				C7.C7_USUARIO, 
				D1.D1_DOC, 
				D1.D1_FORNECE 
		FROM   	%TABLE:SD1% D1, 
				%TABLE:SC7% C7 
		WHERE  	C7.C7_EMISSAO BETWEEN %EXP:MV_PAR01% AND %EXP:MV_PAR02% 
		AND    	D1.D1_PEDIDO  = C7.C7_NUM 
		AND   	D1.D1_FORNECE = C7.C7_FORNECE 
		AND   	C7.%NOTDEL% 
		AND  	D1.%NOTDEL% 
		GROUP BY 
				C7.C7_EMISSAO, 
				D1.D1_PEDIDO, 
				C7.C7_USUARIO, 
				D1.D1_DOC, 
				D1.D1_FORNECE 
		ORDER BY 
				C7.C7_EMISSAO	

	EndSQL

	nTotReg := reccount()
	DBGOTOP()

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	dbGotop()
	Do while !eof()
		if rlock()
			trb->C7_EMISSAO  := DTOC(stod(C7_EMISSAO))
		endif
		skip
	Enddo
	dbgotop()


	//Cria o arquivo CSV
	cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
	cFile 	+= "\ped_comp_x_Notas_Entrada_" + DtoS(dDataBase) + "_" + StrTran(Time(),":") + ".CSV"
	nHdl	:= FCreate(cFile)

	If nHdl <= 0
		MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
		Return(Nil)
	EndIf

	//Monta o cabecalho
	aCabec := {}
	AAdd(aCabec,{'Emissao','C','C7_EMISSAO'})
	AAdd(aCabec,{'Pedido','C','D1_PEDIDO'})
	AAdd(aCabec,{'Usuario','C','C7_USUARIO'})
	AAdd(aCabec,{'Nota Fiscal','C','D1_DOC'})
	AAdd(aCabec,{'Fornecedor','C','D1_FORNECE'})

	For i := 1 To Len(aCabec)
		cLinhaCSV += aCabec[i,1] + ";"
	Next i                            
	FWrite(nHdl,cLinhaCSV+ CHR(13)+ CHR(10))

	ProcRegua(nTotReg)

	//Geracao do arquivo CSV
	While TRB->(!Eof())  
		IncProc()
		cLinhaCSV := ""

		For i := 1 To Len(aCabec)
			If aCabec[i,2] == "C"
				cLinhaCSV += TRB->&(aCabec[i,3])+";"
			ElseIf aCabec[i,2] == "D"
				cLinhaCSV += DToC(SToD(TRB->&(aCabec[i,3])))+";"
			ElseIf aCabec[i,2] == "N"
				cLinhaCSV += Transform(TRB->&(aCabec[i,3]),"@E 999,999,999.99")+";"
			EndIf
		Next i

		FWrite(nHdl,cLinhaCSV+CHR(13)+CHR(10))
		TRB->(dbSkip())
	EndDo   

	FClose(nHdl)
	oExcel := MSExcel():New()
	oExcel:WorkBooks:Open(cFile)
	oExcel:SetVisible(.T.)   

	dbSelectArea("TRB")
	DBCLOSEAREA()

	RestArea(aAreaSM0)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidSX1 ºAutor  ³Bruno Daniel Borges º Data ³  22/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que valida as perguntas do SX1 e cria os novos regis-º±±
±±º          ³tros                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Anhembi Morumbi                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidSX1(aPergunt)
	Local aAreaBKP := GetArea()
	Local cGrpPerg := ""
	Local lTipLocl := .T.
	Local i
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 23/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	SX1->(dbGoTop())

	If Len(aPergunt) <= 0
		Return(Nil)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida as perguntas do usuario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cGrpPerg := PadR(aPergunt[1,1],10)
	For i := 1 To Len(aPergunt)
		lTipLocl := !SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))	
		SX1->(RecLock("SX1",lTipLocl))
		SX1->X1_GRUPO		:= PadR(cGrpPerg,10)
		SX1->X1_ORDEM		:= aPergunt[i,2]
		SX1->X1_PERGUNT		:= aPergunt[i,3]
		SX1->X1_PERSPA		:= aPergunt[i,3]
		SX1->X1_PERENG		:= aPergunt[i,3] 
		SX1->X1_VARIAVL		:= aPergunt[i,4]
		SX1->X1_TIPO		:= aPergunt[i,5]
		SX1->X1_TAMANHO		:= aPergunt[i,6]
		SX1->X1_DECIMAL		:= aPergunt[i,7]
		SX1->X1_GSC			:= aPergunt[i,8]
		SX1->X1_VALID		:= aPergunt[i,09]
		SX1->X1_VAR01		:= aPergunt[i,10]
		SX1->X1_DEF01		:= aPergunt[i,11]
		SX1->X1_DEF02		:= aPergunt[i,12]
		SX1->X1_DEF03		:= aPergunt[i,13]
		SX1->X1_DEF04		:= aPergunt[i,14]
		SX1->X1_DEF05		:= aPergunt[i,15]
		SX1->X1_F3			:= aPergunt[i,16]
		SX1->X1_PICTURE		:= aPergunt[i,17]
		SX1->(MsUnlock())
	Next i
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	RestArea(aAreaBKP)

Return(Nil)