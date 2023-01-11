#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOMA020 ºAutor  ³Bruno Daniel Borges º Data ³  14/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de contabilizacao das apropriacoes de contratos de   º±±
±±º          ³parceria                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCOMA020()
	Local aBotoes	:= {}
	Local aSays		:= {}
	Local aPergunt	:= {}
	Local nOpcao	:= 0 

	//Parametros da rotina
	Aadd(aPergunt,{"RCOM20","01","Data Inicial"	   		,"mv_ch1"	,"D",08,00,"G","","mv_par01","","","","","","",""})
	Aadd(aPergunt,{"RCOM20","02","Data Final"	   		,"mv_ch2"	,"D",08,00,"G","","mv_par02","","","","","","",""})
	Aadd(aPergunt,{"RCOM20","03","Do Fornecedor"		,"mv_ch3"	,"C",06,00,"G","","mv_par03","","","","","","SA2",""})
	Aadd(aPergunt,{"RCOM20","04","Ate o Fornecedor"		,"mv_ch4"	,"C",06,00,"G","","mv_par04","","","","","","SA2",""})
	Aadd(aPergunt,{"RCOM20","05","Exibe Lancamentos"	,"mv_ch5"	,"N",01,00,"C","","mv_par05","Sim","Nao","","","","",""})
	Aadd(aPergunt,{"RCOM20","06","Do Contrato"	   		,"mv_ch6"	,"C",06,00,"G","","mv_par06","","","","","","SC3",""})
	Aadd(aPergunt,{"RCOM20","07","Ate o Contrato"  		,"mv_ch7"	,"C",06,00,"G","","mv_par07","","","","","","SC3",""})
	Aadd(aPergunt,{"RCOM20","08","Data Lancamento"		,"mv_ch8"	,"D",08,00,"G","","mv_par08","","","","","","",""}) 

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 16/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	ValidSX1(aPergunt)
 	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	Pergunte("RCOM20",.F.)

	//Tela de aviso e acesso aos parametros
	AAdd(aSays,"[GERAÇÃO DE LANÇAMENTOS CONTÁBEIS DE APROPRIAÇÃO - CONTRATOS PARCERIA]")
	AAdd(aSays,"Esse programa irá listar os contratos conforme parametros informados")
	AAdd(aSays,"e irá gerar os lançamentos contábeis de apropriação")

	AAdd(aBotoes,{ 5,.T.,{|| Pergunte("RCOM20",.T. ) } } )
	AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
	AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )        
	FormBatch( "[Contrato Parceria] - Apropriação de Parcelas", aSays, aBotoes )

	If nOpcao == 1
		Processa({|| RCOMA020_Prc()})
	EndIf

Return(Nil)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMA020_PrcºAutor  ³Bruno Daniel Borges º Data ³  14/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de processamento dos lancamentos contabeis             º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RCOMA020_Prc() 
	Local lPadrao	:= VerPadrao("014")
	Local dDataBkp	:= dDataBase
	Local bQuery	:= {|| Iif(Select("TRB") > 0,TRB->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbEval({|| nTotReg++ })), TRB->(dbGoTop()) }
	Local nTotReg	:= 0   
	Local nTotal	:= 0
	Local nHeadProv	:= 0
	Local cArqCTB	:= ""  
	Local cLote		:= GetMv("MV_XLOTECT",,"008850")

	//Query do programa
	cQuery := " SELECT DISTINCT A.R_E_C_N_O_ AS REGNOZZ3, C3_NUM "
	cQuery += " FROM " + RetSQLName("ZZ3") + " A, " + RetSQLName("SC3") + " B "
	cQuery += " WHERE ZZ3_FILIAL = '" + xFilial("ZZ3") + "' AND ZZ3_DATA BETWEEN '" + DToS(mv_par01) + "' AND '" + DToS(mv_par02) + "' AND A.D_E_L_E_T_ = ' ' AND ZZ3_LA <> 'S' AND "
	cQuery += "       ZZ3_CONTRA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
	cQuery += "       C3_FILIAL = '" + xFilial("SC3") + "' AND C3_NUM = ZZ3_CONTRA AND B.D_E_L_E_T_ = ' ' " 
	LJMsgRun("Buscando Contratos de Parceria","Aguarde",bQuery)

	If nTotReg <= 0
		MsgAlert("Atenção, não há contratos com parcelas pendentes de apropriação com os parâmetros informados.")
		Return(Nil)
	EndIf

	ProcRegua(nTotReg) 

	//Geracao dos lancamentos contabeis
	dDataBase := mv_par08
	nHeadProv := HeadProva(cLote,"RCOMA020",Substr(cUsuario,7,6),@cArqCTB)

	While TRB->(!Eof())
		IncProc()

		//Posiciona nas tabelas de contratos e clientes para lancamento padrao
		dbSelectArea("ZZ3")
		ZZ3->(dbGoTo(TRB->REGNOZZ3))

		dbSelectArea("SC3")
		SC3->(dbSetOrder(1))
		SC3->(dbSeek(xFilial("SC3")+TRB->C3_NUM))

		nTotal += DetProva(nHeadProv,"014","RCTBA020",cLote)

		TRB->(dbSkip())
	EndDo

	//Gera Lancamentos Contabeis				
	If nTotal > 0
		RodaProva(nHeadProv,nTotal)
		cA100Incl(cArqCTB,nHeadProv,3,cLote,mv_par05 == 1,.F.)

		//Flega os registros como APROPRIADOS
		TRB->(dbGoTop())                             
		While TRB->(!Eof())       
			dbSelectArea("ZZ3")
			ZZ3->(dbGoTo(TRB->REGNOZZ3))

			dbSelectArea("ZZ3")
			ZZ3->(dbGoTo(TRB->REGNOZZ3))
			ZZ3->(RecLock("ZZ3",.F.))
			ZZ3->ZZ3_LA 	:= "S"
			ZZ3->(MsUnlock())
			TRB->(dbSkip())
		EndDo  
	Else
		MsgAlert("Atenção, não há dados para serem contabilizados.")
	EndIf

Return(Nil)

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
/*
Static Function ValidSX1(aPergunt)
	Local aAreaBKP := GetArea()
	Local cGrpPerg := ""
	Local lTipLocl := .T.
	Local i

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

	RestArea(aAreaBKP)

Return(Nil)
*/