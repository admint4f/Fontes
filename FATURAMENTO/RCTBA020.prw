#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCTBA020 ºAutor  ³Bruno Daniel Borges º Data ³  10/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa de geracao dos lancamentos contabeis de apropriacaoº±±
±±º          ³de contratos T4F                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³Data: 09.06.08 - Fernando Fonseca                           º±±
±±ºDescrição ³Alterada a Query para Filtrar somente os Contratos          º±±
±±º          ³Cujo Status seja 4=Contrato Em Andamento.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RCTBA020()
	
	Local aBotoes	:= {}
	Local aSays		:= {}
	Local aPergunt	:= {}
	Local nOpcao	:= 0 

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	//Parametros da rotina
	Aadd(aPergunt,{"RCTB20","01","Data Inicial"	   		,"mv_ch1"	,"D",08,00,"G","","mv_par01","","","","","","",""})
	Aadd(aPergunt,{"RCTB20","02","Data Final"	   		,"mv_ch2"	,"D",08,00,"G","","mv_par02","","","","","","",""})
	Aadd(aPergunt,{"RCTB20","03","Do Cliente"	   		,"mv_ch3"	,"C",06,00,"G","","mv_par03","","","","","","SA1",""})
	Aadd(aPergunt,{"RCTB20","04","Ate o Cliente"   		,"mv_ch4"	,"C",06,00,"G","","mv_par04","","","","","","SA1",""})
	Aadd(aPergunt,{"RCTB20","05","Exibe Lancamentos"	,"mv_ch5"	,"N",01,00,"C","","mv_par05","Sim","Nao","","","","",""})
	Aadd(aPergunt,{"RCTB20","06","Do Contrato"	   		,"mv_ch6"	,"C",06,00,"G","","mv_par06","","","","","","ZZ0",""})
	Aadd(aPergunt,{"RCTB20","07","Ate o Contrato"  		,"mv_ch7"	,"C",06,00,"G","","mv_par07","","","","","","ZZ0",""})
	Aadd(aPergunt,{"RCTB20","08","Do Item"		   		,"mv_ch8"	,"C",03,00,"G","","mv_par08","","","","","","",""})
	Aadd(aPergunt,{"RCTB20","09","Ate o Item"	  		,"mv_ch9"	,"C",03,00,"G","","mv_par09","","","","","","",""}) 
	Aadd(aPergunt,{"RCTB20","10","Data Lancamento"		,"mv_chA"	,"D",08,00,"G","","mv_par10","","","","","","",""}) 
	ValidSX1(aPergunt)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	
	
	Pergunte("RCTB20",.F.)

	//Tela de aviso e acesso aos parametros
	AAdd(aSays,"[GERAÇÃO DE LANÇAMENTOS CONTÁBEIS DE APROPRIAÇÃO]")
	AAdd(aSays,"Esse programa irá listar os contratos conforme parametros informados")
	AAdd(aSays,"e irá gerar os lançamentos contábeis de apropriação")

	AAdd(aBotoes,{ 5,.T.,{|| Pergunte("RCTB20",.T. ) } } )
	AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
	AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )        
	FormBatch( "Apropriação de Parcelas de Contratos", aSays, aBotoes )

	If nOpcao == 1
		Processa({|| RCTBA020_Prc()})
	EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBA020_PrcºAutor  ³Bruno Daniel Borges º Data ³  10/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento do programa                                     º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RCTBA020_Prc() 
	Local cQuery	:= ""    
	Local cArqCTB	:= ""
	Local cLote		:= GetMv("MV_XLOTECT",,"008850")
	Local nTotReg	:= 0
	Local nHeadProv	:= 0  
	Local nTotal	:= 0
	Local bQuery	:= {|| Iif(Select("TRB") > 0,TRB->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbEval({|| nTotReg++ })), TRB->(dbGoTop()) }
	Local lPadrao	:= VerPadrao("011")
	Local dDataBkp	:= dDataBase

	//Query do programa
	cQuery := " SELECT A.R_E_C_N_O_ AS REGNOZZ1, B.R_E_C_N_O_ AS REGNOZZ0 "
	cQuery += " FROM " + RetSQLName("ZZ1") + " A, " + RetSQLName("ZZ0") + " B "
	cQuery += " WHERE ZZ1_FILIAL = '" + xFilial("ZZ1") + "' AND ZZ1_DATA BETWEEN '" + DToS(mv_par01) + "' AND '" + DToS(mv_par02) + "' AND A.D_E_L_E_T_ = ' ' AND ZZ1_LA <> 'S' AND "
	cQuery += "       ZZ0_FILIAL = '" + xFilial("ZZ0") + "' AND ZZ0_CONTRA = ZZ1_CONTRA AND B.D_E_L_E_T_ = ' ' AND ZZ0_ITEM = ZZ1_ITEM AND "
	cQuery += "       ZZ0_CLIENT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND ZZ0_STATUS = '4' AND "
	cQuery += "       ZZ0_CONTRA BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' AND "
	cQuery += "       ZZ0_ITEM BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' "
	LJMsgRun("Buscando Contratos","Aguarde",bQuery)

	If nTotReg <= 0
		MsgAlert("Atenção, nenhuma parcela de contratos com status de não apropriada foi localizada com os parâmetros informados.")
		Return(Nil)
	EndIf

	If !lPadrao
		MsgAlert("Atenção, o lançamento padronizado de código 011 não foi localizado.")
		Return(Nil)
	EndIf

	ProcRegua(nTotReg)         

	//Geracao dos lancamentos contabeis
	dDataBase := mv_par10
	nHeadProv := HeadProva(cLote,"RCTBA020",Substr(cUsuario,7,6),@cArqCTB)

	//Gera lancamentos contabeis
	While TRB->(!Eof()) 
		IncProc()

		//Posiciona nas tabelas de contratos e clientes para lancamento padrao
		dbSelectArea("ZZ0")
		ZZ0->(dbGoTo(TRB->REGNOZZ0))

		dbSelectArea("ZZ1")
		ZZ1->(dbGoTo(TRB->REGNOZZ1))

		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+ZZ0->ZZ0_CLIENT+ZZ0->ZZ0_LOJA))

		nTotal += DetProva(nHeadProv,"011","RCTBA020",cLote)

		TRB->(dbSkip())	
	EndDo

	//Gera Lancamentos Contabeis				
	If nTotal > 0
		RodaProva(nHeadProv,nTotal)
		cA100Incl(cArqCTB,nHeadProv,3,cLote,mv_par05 == 1,.F.)

		//Flega os registros como APROPRIADOS
		TRB->(dbGoTop())                             
		While TRB->(!Eof())       
			dbSelectArea("ZZ0")
			ZZ0->(dbGoTo(TRB->REGNOZZ0))

			dbSelectArea("ZZ1")
			ZZ1->(dbGoTo(TRB->REGNOZZ1))
			ZZ1->(RecLock("ZZ1",.F.))
			ZZ1->ZZ1_LA 	:= "S"
			ZZ1->ZZ1_CORREC	:= ZZ0->ZZ0_INDCOR
			ZZ1->(MsUnlock())

			TRB->(dbSkip())
		EndDo  
	Else
		MsgAlert("Atenção, não há dados para serem contabilizados.")
	EndIf				

	dDataBase := dDataBkp

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
Static Function ValidSX1(aPergunt)
	Local aAreaBKP := GetArea()
	Local cGrpPerg := ""
	Local lTipLocl := .T.
	Local i

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
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
	cGrpPerg := PadR(aPergunt[1,1],len(X1_GRUPO))
	For i := 1 To Len(aPergunt)
		lTipLocl :=! SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))	
					 SX1->(RecLock("SX1",lTipLocl))
					 SX1->X1_GRUPO		:= padr(cGrpPerg,len(X1_GRUPO))
					 SX1->X1_ORDEM		:= aPergunt[i,2]
					 SX1->X1_PERGUNT	:= aPergunt[i,3]
					 SX1->X1_PERSPA		:= aPergunt[i,3]
					 SX1->X1_PERENG		:= aPergunt[i,3] 
					 SX1->X1_VARIAVL	:= aPergunt[i,4]
					 SX1->X1_TIPO		:= aPergunt[i,5]
					 SX1->X1_TAMANHO	:= aPergunt[i,6]
					 SX1->X1_DECIMAL	:= aPergunt[i,7]
					 SX1->X1_GSC		:= aPergunt[i,8]
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
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

Return(Nil)