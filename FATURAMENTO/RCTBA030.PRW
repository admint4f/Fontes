#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCTBA030 ºAutor  ³Bruno Daniel Borges º Data ³  10/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa de geracao dos pedidos de venda de contratos T4F   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³ 09.06.08 - Fernando Fonseca                                º±±
±±º          ³ Alterada a Query para Filtrar somente os Contratos         º±±
±±º          ³ Cujo Status seja 4=Contrato Em Andamento.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³ 16.09.11 - Gilberto Oliveira                               º±±
±±º          ³ Utilizacao de nova funcao para codificacao sequencial dos  º±±
±±º          ³ Pedidos de Venda.                                          º±±
±±ºAlteracao ³ 16.09.11 - Gilberto Oliveira                               º±±
±±º          ³ Gravacao do campo C6_CODISS com base no cadastro de produ- º±±
±±º          ³ tos. Motivo: Estava sendo levado o codigo errado.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RCTBA030()
	
	Local aBotoes	:= {}
	Local aSays		:= {}
	Local aPergunt	:= {}
	Local nOpcao	:= 0 
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	//Parametros da rotina
	Aadd(aPergunt,{"RCTB30","01","Data Inicial"	   		,"mv_ch1"	,"D",08,00,"G","","mv_par01","","","","","","",""})
	Aadd(aPergunt,{"RCTB30","02","Data Final"	   		,"mv_ch2"	,"D",08,00,"G","","mv_par02","","","","","","",""})
	Aadd(aPergunt,{"RCTB30","03","Do Cliente"	   		,"mv_ch3"	,"C",06,00,"G","","mv_par03","","","","","","SA1",""})
	Aadd(aPergunt,{"RCTB30","04","Ate o Cliente"   		,"mv_ch4"	,"C",06,00,"G","","mv_par04","","","","","","SA1",""})
	Aadd(aPergunt,{"RCTB30","05","Do Contrato"	   		,"mv_ch5"	,"C",06,00,"G","","mv_par05","","","","","","",""})
	Aadd(aPergunt,{"RCTB30","06","Ate o Contrato"  		,"mv_ch6"	,"C",06,00,"G","","mv_par06","","","","","","",""})
	Aadd(aPergunt,{"RCTB30","07","Tipo Contrato"  		,"mv_ch6"	,"N",01,00,"C","","mv_par07","Eventos","Comercial","Permulta","Todos","","",""})
	ValidSX1(aPergunt)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	Pergunte("RCTB30",.F.)

	//Tela de aviso e acesso aos parametros
	AAdd(aSays,"[GERAÇÃO DE PEDIDOS DE VENDAS DE CONTRATOS]")
	AAdd(aSays,"Esse programa irá listar os contratos conforme parametros informados")
	AAdd(aSays,"e irá gerar os pedidos de venda para geração das NFs de Saida")

	AAdd(aBotoes,{ 5,.T.,{|| Pergunte("RCTB30",.T. ) } } )
	AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
	AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )        
	FormBatch( "Geração de Pedidos de Venda", aSays, aBotoes )

	If nOpcao == 1
		Processa({|| RCTBA030_Prc()})
	EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBA030_PrcºAutor  ³Bruno Daniel Borges º Data ³  10/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento do programa                                     º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RCTBA030_Prc() 
	Local cQuery	:= ""    
	Local cCondPad	:= GetMv("MV_XCONDPG",,"001") //Sempre condicao a vista, pois titulo a receber e alterado
	Local cNumPed	:= ""
	Local nTotReg	:= 0
	Local bQuery	:= {|| Iif(Select("TRB") > 0,TRB->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbEval({|| nTotReg++ })), TRB->(dbGoTop()) }
	Local aCabecPv	:= {}
	Local aItemPV	:= {}
	Local aItem		:= {}

	Private lMsErroAuto	:= .F.

	//Query do programa
	cQuery := " SELECT A.R_E_C_N_O_ AS REGNOZZ2, B.R_E_C_N_O_ AS REGNOZZ0 , ZZ0_TABPRC AS TABPRECO  "
	cQuery += " FROM " + RetSQLName("ZZ2") + " A, " + RetSQLName("ZZ0") + " B "
	cQuery += " WHERE ZZ2_FILIAL = '" + xFilial("ZZ2") + "' AND ZZ2_VENCTO BETWEEN '" + DToS(mv_par01) + "' AND '" + DToS(mv_par02) + "' AND ZZ2_PEDIDO = '      ' AND "
	cQuery += "       A.D_E_L_E_T_ = ' ' AND "
	cQuery += "       ZZ0_FILIAL = '" + xFilial("ZZ0") + "' AND ZZ0_CONTRA = ZZ2_CONTRA AND B.D_E_L_E_T_ = ' ' AND ZZ0_STATUS = '4' AND "
	cQuery += "       ZZ2_CONTRA BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND ZZ2_TPCONT = 'C' AND "
	cQuery += "       ZZ0_CLIENT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND ZZ2_ITEM = ZZ0_ITEM "

	If mv_par07 == 1 //Apenas BRIEFING
		cQuery += "       AND ZZ0_TPCONT = '2' "
	ElseIf mv_par07 == 2 //Apenas CONTRATO
		cQuery += "       AND ZZ0_TPCONT = '1' "
	ElseIf mv_par07 == 3 //Apenas PERMULTA
		cQuery += "       AND ZZ0_TPCONT = '3' "
	EndIf
	LJMsgRun("Buscando Contratos","Aguarde",bQuery)

	If nTotReg <= 0
		MsgAlert("Atenção, nenhuma parcela de contratos com status de não faturada foi localizada com os parâmetros informados.")
		Return(Nil)
	EndIf

	ProcRegua(nTotReg)

	//Gera lancamentos contabeis
	While TRB->(!Eof()) 
		IncProc("Gerando Pedidos Venda")

		dbSelectArea("ZZ2")
		ZZ2->(dbGoTo(TRB->REGNOZZ2))

		dbSelectarea("ZZ0")
		ZZ0->(dbGoTo(TRB->REGNOZZ0))

		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+ZZ0->ZZ0_CLIENT+ZZ0->ZZ0_LOJA))

		//cNumPed := GetSXENum("SC5","C5_NUM")
		//ConfirmSX8()
		cNumPed :=  U_SC5COD(DDATABASE) // Nova codificacao SEQUENCIAL dos pedidos.


		cCondPad := Iif(ZZ0->ZZ0_TPCONT == "3","PM",cCondPad)

		aCabecPv := {	{"C5_NUM"    ,cNumPed				    			,Nil},; // Numero do pedido
		{"C5_TIPO"   ,"N"         							,Nil},; // Tipo de pedido
		{"C5_CLIENTE",SA1->A1_COD    						,Nil},; // Codigo do cliente
		{"C5_LOJACLI",SA1->A1_LOJA        					,Nil},; // Loja do cliente
		{"C5_EMISSAO",dDatabase   							,Nil},; // Data de emissao
		{"C5_TIPOCLI","F"         							,Nil},; // Tipo de cliente
		{"C5_CONDPAG",ZZ2->ZZ2_CONDPG				       	,Nil},; // Codigo da condicao de pagamanto*
		{"C5_DESC1"  ,0           							,Nil},; // Percentual de Desconto
		{"C5_INCISS" ,"N"         							,Nil},; // ISS Incluso
		{"C5_TIPLIB" ,"1"         							,Nil},; // Tipo de Liberacao
		{"C5_MOEDA"  ,1           							,Nil},; // Moeda
		{"C5_NATUREZ",Iif(!Empty(ZZ0->ZZ0_NATURE),ZZ0->ZZ0_NATURE,"")	,Nil},; // Natureza
		{"C5_INCISS" ,"S"									,Nil},;	 // ISS
		{"C5_PARC1"  ,100									,Nil},; // 100% da Parcela
		{"C5_DATA1"  ,ZZ2->ZZ2_VENCTI						,Nil},; // Vencimento do titulo
		{"C5_PAGTO"	 ,ZZ2->ZZ2_MODPAG						,Nil}}  // Tipo de Pagamento

		//			 		{"C5_MENNOTA",Msmm(ZZ0->ZZ0_CODOBJ)					,Nil},;	 // Mensagem para NF


		aItemPV:={	 {"C6_NUM"    ,cNumPed  	      																,Nil},; // Numero do Pedido
		{"C6_ITEM"   ,"01"		   																		,Nil},; // Numero do Item no Pedido
		{"C6_PRODUTO",ZZ0->ZZ0_PRODUT				 													,Nil},; // Codigo do Produto
		{"C6_QTDVEN" ,1							  													,Nil},; // Quantidade Vendida
		{"C6_PRUNIT" ,ZZ2->ZZ2_VALOR*IIF(ZZ0->ZZ0_INDCOR > 0,ZZ0->ZZ0_INDCOR,1)						,Nil},; // Preco Unitario
		{"C6_PRCVEN" ,ZZ2->ZZ2_VALOR*IIF(ZZ0->ZZ0_INDCOR > 0,ZZ0->ZZ0_INDCOR,1)						,Nil},; // Preco Unitario Liquido
		{"C6_VALOR"  ,ZZ2->ZZ2_VALOR*IIF(ZZ0->ZZ0_INDCOR > 0,ZZ0->ZZ0_INDCOR,1)						,Nil},; // Valor Total do Item
		{"C6_ENTREG" ,dDataBase         																,Nil},; // Data da Entrega
		{"C6_UM"     ,Posicione("SB1",1,xFilial("SB1")+ZZ0->ZZ0_PRODUT,"SB1->B1_UM")					,Nil},; // Unidade de Medida Primar.
		{"C6_TES"    ,ZZ0->ZZ0_TES																		,Nil},; // Tipo de Entrada/Saida do Item
		{"C6_LOCAL"  ,Posicione("SB1",1,xFilial("SB1")+ZZ0->ZZ0_PRODUT,"SB1->B1_LOCPAD")				,Nil},; // Almoxarifado
		{"C6_DESCONT",0                 																,Nil},; // Percentual de Desconto
		{"C6_COMIS1" ,0                 																,Nil},; // Comissao Vendedor
		{"C6_CLI"    ,SA1->A1_COD       																,Nil},; // Cliente
		{"C6_LOJA"   ,SA1->A1_LOJA              														,Nil},; // Loja do Cliente
		{"C6_QTDLIB" ,0						                 										,Nil},; // Quantidade Liberada 
		{"C6_ITEMCC" ,ZZ0->ZZ0_ELEPEP																	,Nil},; // Elemento PEP
		{"C6_CCUSTO" ,ZZ0->ZZ0_CC																		,Nil},; // Centro de Custo
		{"C6_QTDLIB" ,1																				,Nil},; // Qtd. Liberada
		{"C6_CONTA"  ,Posicione("SB1",1,xFilial("SB1")+ZZ0->ZZ0_PRODUT,"SB1->B1_CONTA")				,Nil},;	// Conta Contabil (receita)
		{"C6_CODISS" ,Posicione("SB1",1,xFilial("SB1")+ZZ0->ZZ0_PRODUT,"SB1->B1_CODISS")				,Nil}}	// Codigo Servico do ISS  (Gilberto)

		//Gera o Pedido de Venda Via ExecAuto
		lMsErroAuto := .F.	
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabecPv,{aItemPV},3)

		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))

		If !SC5->(dbSeek(xFilial("SC5")+cNumPed))
			MostraErro() 
		Else
			RecLock("SC5",.F.)
			sc5->C5_MENNOTA := Msmm(ZZ0->ZZ0_CODOBJ)
			MsUnLock()

			ZZ2->(RecLock("ZZ2",.F.))
			ZZ2->ZZ2_PEDIDO := cNumPed
			ZZ2->(MsUnlock())

			SC5->(RecLock("SC5",.F.))
			SC5->C5_INCISS := "S"
			SC5->C5_TABELA := TRB->TABPRECO
			SC5->(MsUnlock())		

			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			SC6->(dbSeek(xFilial("SC6")+cNumPed))
			While SC6->(!Eof()) .And. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6")+cNumPed
				SC6->(RecLock("SC6",.F.))
				SC6->C6__CONTRA := TRB->REGNOZZ2
				SC6->(MsUnlock())
				SC6->(dbSkip())
			EndDo
		EndIf    

		TRB->(dbSkip())
	EndDo

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
		lTipLocl := !SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))	
		SX1->(RecLock("SX1",lTipLocl))
		SX1->X1_GRUPO		:= padr(cGrpPerg,len(X1_GRUPO))
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
	
	If Len(aPergunt) <= 0
		Return(Nil)
	EndIf
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
		
	RestArea(aAreaBKP)

Return(Nil)