#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCTBR010 º Autor ³Bruno Daniel Borges º Data ³  04/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de movimentos e saldo final de elementos PEP     º±±
±±º          ³ com opcao de apenas PRE-OPERATIVOS                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RCTBR010()
	
	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Relatorio Elementos PEP / Pré-Operativo"
	Local cPict         := ""
	Local titulo        := "Relatorio Elementos PEP / Pré-Operativo"
	Local nLin          := 80
	Local imprime       := .T.
	Local aOrd 			:= {}
	Local aPergunt		:= {}

	//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//0         10        20        30        40        50        60        70        80        90        100       110       120       130
	//Elemento PEP  Descricao                                 Conta            Descricao                                 Data               Valor  Dados Lancamento
	//XXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99  999,999,999.99  999999-999-999999-999
	//XXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99  999,999,999.99  999999-999-999999-999
	//XXXXXXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99  999,999,999.99  999999-999-999999-999
	Local Cabec1        := "Elemento PEP  Descricao                                 Conta            Descricao                                 Data               Valor  Dados Lancamento"
	Local Cabec2        := ""

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RCTBR010"
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg        := "RCTB01"
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RCTBR010"

	dbSelectArea("CT2")
	CT2->(dbSetOrder(1))

	Aadd(aPergunt,{"RCTB01","01","Da Dt. Movim."			,"mv_ch1"	,"D",08,00,"G","","mv_par01","","","","","","",""})
	Aadd(aPergunt,{"RCTB01","02","Ate a Dt. Movim."		,"mv_ch2"	,"D",08,00,"G","","mv_par02","","","","","","",""})
	Aadd(aPergunt,{"RCTB01","03","Do Elem. PEP"			,"mv_ch3"	,"C",15,00,"G","","mv_par03","","","","","","CTD",""})
	Aadd(aPergunt,{"RCTB01","04","Ate o Elem. PEP"		,"mv_ch4"	,"C",15,00,"G","","mv_par04","","","","","","CTD",""})
	Aadd(aPergunt,{"RCTB01","05","Da Dt. Evento"			,"mv_ch5"	,"D",08,00,"G","","mv_par05","","","","","","",""})
	Aadd(aPergunt,{"RCTB01","06","Ate a Dt.Evento"		,"mv_ch6"	,"D",08,00,"G","","mv_par06","","","","","","",""})
	Aadd(aPergunt,{"RCTB01","07","Contas Pre-Oper."		,"mv_ch7"	,"C",50,00,"G","","mv_par07","","","","","","",""})
	Aadd(aPergunt,{"RCTB01","08","Gera Contabilizacao"	,"mv_ch8"	,"N",01,00,"C","","mv_par08","Nao","Sim","","","","",""})
	Aadd(aPergunt,{"RCTB01","09","Apenas nao Baixados"	,"mv_ch9"	,"N",01,00,"C","","mv_par09","Sim","Nao","","","","",""})
	Aadd(aPergunt,{"RCTB01","10","Contas Redutoras"		,"mv_chA"	,"C",50,00,"G","","mv_par10","","","","","","",""})
	
	//----------------------------------------------------------------------------------------------
	// Adequacao Fontes Codeanalisys CES 20/08/2019
	//------------------------------------------------------------------------------------ { Inicio}
	//ValidSX1(aPergunt)

	//{ Fim }---------------------------------------------------------------------------------------
	
	Pergunte(cPerg,.F.)

	wnrel := SetPrint("CT2",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,"CT2")

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
±±ºFun‡„o    ³RUNREPORT º Autor ³Bruno Daniel Borges º Data ³  04/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Processamento do relatorio                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local cQuery	:= ""
	Local cElemPep	:= ""
	Local cContas	:= ""
	Local cLote		:= ""
	Local cArqCTB	:= ""
	Local nCredito	:= 0
	Local nDebito	:= 0
	Local nTotReg	:= 0
	Local nTotPep	:= 0
	Local nHeadProv	:= 0
	Local nTotal	:= 0
	Local nTotGeral	:= 0
	Local bQuery	:= {|| Iif(Select("TRB") > 0,TRB->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbEval({|| nTotReg++ })), TRB->(dbGoTop()) }
	Local lPadrao	:= VerPadrao("009")
	Local aRecnos	:= {}

	//Formata as contas de Pre-Operativo
	cContas := "'" + StrTran(AllTrim(mv_par07),",","','") + "'"

	//cQuery := " SELECT CT2_VALOR AS VALOR, 'D' AS TIPO, CTD_ITEM, CTD_DESC01, CT2_ATIVDE AS CONTA, CT1_DESC01, CT2_HIST, CT2_KEY, CT2_LOTE, A.R_E_C_N_O_ AS REGNO "
	cQuery := " SELECT CT2_VALOR AS VALOR, 'D' AS TIPO, CTD_ITEM, CTD_DESC01, CT2_ATIVDE AS CONTA, CT2_HIST, CT2_KEY, CT2_LOTE, A.R_E_C_N_O_ AS REGNO "
	cQuery += " FROM " + RetSQLName("CT2") + " A, " + RetSQLName("CTD") + " B " //+ RetSQLName("CT1") + " C "
	cQuery += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "' AND "
	cQuery += "       CT2_DATA BETWEEN '" + DToS(mv_par01) + "' AND '" + DToS(mv_par02) + "' AND "
	cQuery += "       CT2_ITEMD BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
	cQuery += "       CT2_DC IN ('1','3') AND "
	cQuery += "       CTD_FILIAL = '  ' AND CTD_ITEM = CT2_ITEMD AND B.D_E_L_E_T_ = ' ' AND "
	cQuery += "       CTD_DTEVEN BETWEEN '" + DToS(mv_par05) + "' AND '" + DToS(mv_par06) + "' "//AND "
	cQuery += "       AND CT2_CCD <> '03041000' AND CT2_CCD <> '03042200' AND CT2_CCD <> '03042300' AND "
	cQuery += "       CT2_CCD <> '03042400' AND CT2_CCD <> '03042500' AND CT2_CCD <> '03043100' AND "
	cQuery += "       CT2_CCD <> '03043200' AND CT2_CCD <> '03043300' AND CT2_CCD <> '03048000'  "
	//cQuery += "       CT2_ATIVDE <> CT2_DEBITO AND CT2_ATIVDE <> ' ' AND "
	//cQuery += "       CT1_FILIAL = '" + xFilial("CT1") + "' AND CT1_CONTA = CT2_ATIVDE AND C.D_E_L_E_T_ = ' ' "
	cQuery += "       AND CT2_DEBITO IN (" + cContas + ") " 
	cQuery += "       AND CT2_DTLP = '  ' " 
	cQuery += "       AND A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' "
	//cQuery += " GROUP BY CTD_ITEM, CTD_DESC01, CT2_ATIVDE, CT1_DESC01, CT2_HIST "

	cQuery += " UNION "

	//cQuery += " SELECT CT2_VALOR AS VALOR, 'C' AS TIPO, CTD_ITEM, CTD_DESC01, CT2_ATIVCR AS CONTA, CT1_DESC01, CT2_HIST, CT2_KEY, CT2_LOTE, A.R_E_C_N_O_ AS REGNO "
	cQuery += " SELECT CT2_VALOR AS VALOR, 'C' AS TIPO, CTD_ITEM, CTD_DESC01, CT2_ATIVCR AS CONTA, CT2_HIST, CT2_KEY, CT2_LOTE, A.R_E_C_N_O_ AS REGNO "
	cQuery += " FROM " + RetSQLName("CT2") + " A, " + RetSQLName("CTD") + " B " //+ RetSQLName("CT1") + " C "
	cQuery += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "' AND "
	cQuery += "       CT2_DATA BETWEEN '" + DToS(mv_par01) + "' AND '" + DToS(mv_par02) + "' AND "
	cQuery += "       CT2_ITEMC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
	cQuery += "       CT2_DC IN ('2','3') AND "
	cQuery += "       CTD_FILIAL = '  ' AND CTD_ITEM = CT2_ITEMC AND B.D_E_L_E_T_ = ' ' AND "
	cQuery += "       CTD_DTEVEN BETWEEN '" + DToS(mv_par05) + "' AND '" + DToS(mv_par06) + "' "//AND ""' AND "
	cQuery += "       AND CT2_CCC <> '03041000' AND CT2_CCC <> '03042200' AND CT2_CCC <> '03042300' AND "
	cQuery += "       CT2_CCC <> '03042400' AND CT2_CCC <> '03042500' AND CT2_CCC <> '03043100' AND "
	cQuery += "       CT2_CCC <> '03043200' AND CT2_CCC <> '03043300' AND CT2_CCC <> '03048000' "
	//cQuery += "       CT2_ATIVCR <> CT2_CREDIT AND CT2_ATIVCR <> ' ' AND "
	//cQuery += "       CT1_FILIAL = '" + xFilial("CT1") + "' AND CT1_CONTA = CT2_ATIVCR AND C.D_E_L_E_T_ = ' ' "
	cQuery += "       AND CT2_CREDIT IN (" + cContas + ") "          
	cQuery += "       AND CT2_DTLP = '  ' " 
	cQuery += "       AND A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' 
	//cQuery += " GROUP BY CTD_ITEM, CTD_DESC01, CT2_ATIVCR, CT1_DESC01, CT2_HIST "

	cQuery += " ORDER BY CTD_ITEM "

	memowrite("c:\rctbr010.sql",cQuery)
	LJMsgRun("Buscando Movimentos","Aguarde",bQuery)

	SetRegua(nTotReg)

	//Elemento PEP    Descricao Elemento PEP                    Conta            Descricao                                          Valor   Lançamento
	//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//0         10        20        30        40        50        60        70        80        90        100       110       120       130
	Cabec1 := "Elemento PEP    Descricao Elemento PEP                    Conta            Descricao                                          Valor  Lançamento"
	Cabec2 := ""

	Select Trb
	dbgotop()
	//copy to \x
	dbgotop()

	While TRB->(!Eof())
		cElemPep := TRB->CTD_ITEM
		nTotPep	 := 0

		If lAbortPrint
			@ nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		@ nLin,000 PSay TRB->CTD_ITEM
		@ nLin,016 PSay SubStr(TRB->CTD_DESC01,1,35)

		While TRB->(!Eof()) .And. TRB->CTD_ITEM == cElemPep
			//If mv_par10 == 1 //Nao Baixados apenas
			If mv_par09 == 1 //Nao Baixados apenas
				If Len(AllTrim(TRB->CT2_KEY)) == 8
					TRB->(dbSkip())
					Loop
				EndIf
			EndIf

			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif

			@ nLin,058 PSay SubStr(TRB->CONTA,1,15)
			//		@ nLin,075 PSay SubStr(TRB->CT1_DESC01,1,40)
			@ nLin,117 PSay Transform(Iif(TRB->TIPO == "D",TRB->VALOR,TRB->VALOR*(-1)),"@E 999,999,999.99")
			@ nLin,134 PSay SubStr(AllTrim(TRB->CT2_HIST),1,90)
			nLin++

			nTotPep += Iif(TRB->TIPO == "D",TRB->VALOR,TRB->VALOR*(-1))
			nTotGeral += Iif(TRB->TIPO == "D",TRB->VALOR,TRB->VALOR*(-1)) //nTotPep

			TRB->(dbSkip())
		EndDo

		@ nLin,075 PSay "Total"
		@ nLin,117 PSay Transform(nTotPep,"@E 999,999,999.99")

		nLin++
		@ nLin,000 PSay __PrtThinLine()
		nLin++
	EndDo

	If nTotGeral > 0
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		@ nLin,075 PSay "Total Geral"
		@ nLin,117 PSay Transform(nTotGeral,"@E 999,999,999.99")
	EndIf


	Set Device To Screen

	If aReturn[5]==1
		dbCommitAll()
		Set Printer To
		OurSpool(wnrel)
	Endif

	MS_Flush()

	//Gera lancamentos contabeis de BAIXA do Pre-Operativo
	//If mv_par09 == 2
	If mv_par08 == 2
		If !lPadrao
			MsgAlert("Lançamento padrão 009 não esta configurado, não será possível montar a contabilizacao.")
		Else
			lContabiliza := .F.
			dbSelectArea("TRB")
			TRB->(dbGoTop())
			TRB->(dbEval({|| Iif(Len(AllTrim(TRB->CT2_KEY)) <> 8,lContabiliza := .T.,lContabiliza := .F.) }))
			TRB->(dbGoTop())

			//Gera lancamentos de contabilizacao
			If lContabiliza
				nHeadProv 	:= HeadProva(TRB->CT2_LOTE,"RCTBR010",Substr(cUsuario,7,6),@cArqCTB)
				nTotal		:= 0
				cLote		:= TRB->CT2_LOTE
				While TRB->(!Eof())
					//If mv_par10 == 1 //Nao Baixados apenas
					If mv_par09 == 1 //Nao Baixados apenas
						If Len(AllTrim(TRB->CT2_KEY)) == 8
							TRB->(dbSkip())
							Loop
						EndIf
					EndIf

					dbSelectArea("CT2")
					CT2->(dbGoTo(TRB->REGNO))

					AAdd(aRecnos,TRB->REGNO)

					nTotal += DetProva(nHeadProv,"009","RCTBR010",cLote)
					TRB->(dbSkip())
				EndDo

				//Gera Lancamentos Contabeis
				If nTotal > 0
					RodaProva(nHeadProv,nTotal)
					cA100Incl(cArqCTB,nHeadProv,3,cLote,.T.,.F.)

					//Flega os lancamentos como contabilizados
					TRB->(dbGoTop())
					While TRB->(!Eof())
						If AScan(aRecnos,{|x| x == TRB->REGNO }) > 0
							CT2->(dbGoTo(TRB->REGNO))
							CT2->(RecLock("CT2",.F.))
							CT2->CT2_KEY := DToS(dDataBase)
							CT2->(MsUnlock())
						EndIf

						TRB->(dbSkip())
					EndDo
				EndIf
			EndIf
		EndIf

	EndIf

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
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidSX1(aPergunt)
	Local aAreaBKP := GetArea()
	Local cGrpPerg := ""
	Local lTipLocl := .T.
	Local i
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
	//cGrpPerg := PadR(aPergunt[1,1],10)
	cGrpPerg := PadR(aPergunt[1,1],Len(SX1->X1_GRUPO))
	For i := 1 To Len(aPergunt)
		lTipLocl := !SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))
		SX1->(RecLock("SX1",lTipLocl))
		SX1->X1_GRUPO		:= PadR(cGrpPerg,Len(SX1->X1_GRUPO))
		SX1->X1_ORDEM		:= aPergunt[i,2]
		SX1->X1_PERGUNT	:= aPergunt[i,3]
		SX1->X1_PERSPA		:= aPergunt[i,3]
		SX1->X1_PERENG		:= aPergunt[i,3]
		SX1->X1_VARIAVL	:= aPergunt[i,4]
		SX1->X1_TIPO		:= aPergunt[i,5]
		SX1->X1_TAMANHO	:= aPergunt[i,6]
		SX1->X1_DECIMAL	:= aPergunt[i,7]
		SX1->X1_GSC			:= aPergunt[i,8]
		SX1->X1_VALID		:= aPergunt[i,09]
		SX1->X1_VAR01		:= aPergunt[i,10]
		SX1->X1_DEF01		:= aPergunt[i,11]
		SX1->X1_DEF02		:= aPergunt[i,12]
		SX1->X1_DEF03		:= aPergunt[i,13]
		SX1->X1_DEF04		:= aPergunt[i,14]
		SX1->X1_DEF05		:= aPergunt[i,15]
		SX1->X1_F3			:= aPergunt[i,16]
		SX1->X1_PICTURE	:= aPergunt[i,17]
		SX1->(MsUnlock())
	Next i

	RestArea(aAreaBKP)
	*/
Return(Nil)
