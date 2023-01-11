#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ rBol745  ³ Impressão do boleto bancário em formato gráfico.             º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 17.01.07 ³ CIE				                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 21.01.07 ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99.99.99 - Consultor - Descrição da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function rBol745(cPrefixo,cNumero,cParcela,cCliente,cLoja,cBanco,cAgencia,cConta)  //u_rBol745()

	Local aRegs			:= {}
	//Local aLst			:= {}
	Local aTamSX3		:= {}
	Local lEnd			:= .F.
	Local lAuto			:= .F.
	Local nLastKey		:= 0
	Local Tamanho		:= "P"
	Local cDesc1		:= "Este programa tem como objetivo efetuar a impressão do"
	Local cDesc2		:= "Boleto de Cobrança com código de barras, conforme os"
	Local cDesc3		:= "parâmetros definidos pelo usuário."
	Local cString		:= "SE1"
	Local wnrel			:= "rBol745"
	Local cPerg			:= PadR("FINR99",10)
	//Local cPerg			:= PadR("FINR99",10)

	Private Titulo		:= "Boleto de Cobrança com Código de Barras"
	Private aReturn		:= {"Banco", 1,"Financeiro", 2, 2, 1, "",1 }
	Private aLst		:= {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a chamada foi feita por outro programa ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(cPrefixo) 	== "C" .Or.;
	ValType(cNumero) 	== "C" .Or.;
	ValType(cParcela) 	== "C" .Or.;
	ValType(cCliente)	== "C" .Or.;
	ValType(cLoja) 		== "C" .Or.;
	ValType(cBanco) 	== "C" .Or.;
	ValType(cAgencia) 	== "C" .Or.;
	ValType(cConta) 	== "C"
		lAuto	:= .T.
	EndIf

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria array com as perguntas da rotina ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTamSX3	:= TAMSX3("E1_PREFIXO")
	aAdd(aRegs,{cPerg,"01","Do Prefixo"				,""		,""		,"mv_ch1",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR01","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"","",""})
	aAdd(aRegs,{cPerg,"02","Ate Prefixo"			,""		,""		,"mv_ch2",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR02","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"","",""})

	aTamSX3	:= TAMSX3("E1_NUM")
	aAdd(aRegs,{cPerg,"03","Do Numero"				,""		,""		,"mv_ch3",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR03","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"","",""})
	aAdd(aRegs,{cPerg,"04","Ate Numero"				,""		,""		,"mv_ch4",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR04","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"","",""})

	aTamSX3	:= TAMSX3("E1_PARCELA")
	aAdd(aRegs,{cPerg,"05","Da Parcela"				,""		,""		,"mv_ch5",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR05","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","011",	"","",""})
	aAdd(aRegs,{cPerg,"06","Ate Parcela"			,""		,""		,"mv_ch6",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR06","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","011",	"","",""})

	aTamSX3	:= TAMSX3("E1_CLIENTE")
	aAdd(aRegs,{cPerg,"07","Do Cliente"				,""		,""		,"mv_ch7",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR07","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","SA1",	"","001",	"","",""})
	aAdd(aRegs,{cPerg,"08","Ate Cliente"			,""		,""		,"mv_ch8",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR08","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","SA1",	"","001",	"","",""})

	aTamSX3	:= TAMSX3("E1_LOJA")
	aAdd(aRegs,{cPerg,"09","Da Loja"				,""		,""		,"mv_ch9",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR09","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","002",	"","",""})
	aAdd(aRegs,{cPerg,"10","Ate Loja"				,""		,""		,"mv_chA",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR10","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","002",	"","",""})

	aTamSX3	:= TAMSX3("EE_CODIGO")
	aAdd(aRegs,{cPerg,"11","Banco Cobranca"			,""		,""		,"mv_chB",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR11","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","SA6",	"","007",	"","",""})

	aTamSX3	:= TAMSX3("EE_AGENCIA")
	aAdd(aRegs,{cPerg,"12","Agencia Cobranca"		,""		,""		,"mv_chC",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR12","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","008",	"","",""})

	aTamSX3	:= TAMSX3("EE_CONTA")
	aAdd(aRegs,{cPerg,"13","Conta Cobranca"			,""		,""		,"mv_chD",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR13","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","009",	"","",""})

	aTamSX3	:= TAMSX3("EE_SUBCTA")
	aAdd(aRegs,{cPerg,"14","Carteira Cobrança"		,""		,""	   ,"mv_chE",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR14","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",		"","",		"","",""})

	aAdd(aRegs,{cPerg,"15","Re-Impressao"           ,""    ,""    ,"mv_chF","N",01      ,00      ,2    ,"C",""   ,"MV_PAR15","Sim",	"Sim",	"Sim",	"",						"","Nao",	"Nao",	"Nao",	"","","","","","","","","","","","","","","","","",		"","",		"","",""})

	aAdd(aRegs,{cPerg,"16"  ,"Considera Bco Cliente",""    ,""    ,"mv_chG","N" ,01     ,00      ,2    ,"C",""   ,"MV_PAR16","Sim","Sim"  ,  "Sim",   "",   "","Nao",  "Nao",  "Nao",	"",   "",   "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",    "","",  "",    "",  "",     "",""   })
	aAdd(aRegs,{cPerg,"17"  ,"Traz Titulos Marcados",""    ,""    ,"mv_chH","N" ,01     ,00      ,2    ,"C",""   ,"MV_PAR17","Sim","Sim"  ,  "Sim",   "",   "","Nao", " Nao",  "Nao",	"",   "",   "",     "",     "",   "",   "",   "",     "",     "",   "",   "",   "",     "",     "",    "","",  "",    "",  "",     "",""   })

	aTamSX3	:= TAMSX3("E1_VENCREA")
	aAdd(aRegs,{cPerg,"18","Vencimento de"			,""		,""		,"mv_chI",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR18","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",	"","",	"","",""})
	aAdd(aRegs,{cPerg,"19","Vencimento ate"			,""		,""		,"mv_chJ",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR19","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",	"","",	"","",""})


	aTamSX3	:= TAMSX3("E1_NUMBOR")
	aAdd(aRegs,{cPerg,"20","Bordero de"		    	,""		,""		,"mv_chK",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR20","",		"",		"",		"",						"","",		"",		"",		"","","","","","","","","","","","","","","","","",	"","",	"","",""})
	aAdd(aRegs,{cPerg,"21","Bordero ate"			,""		,""		,"mv_chL",aTamSX3[3],	aTamSx3[1],	aTamSX3[2],	0,"G","","MV_PAR21","",		"",		"",		Replic('z',aTamSX3[1]),	"","",		"",		"",		"","","","","","","","","","","","","","","","","",	"","",	"","",""})

	//AADD(aRegs, {cPerg, "01", "Filial De"           ,""     ,""     ,"mv_ch1", "C", 02, 0, 0, "G"                       ,"","mv_par01","",     "",     "",     "",	                    "","",      "",	    "",     "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "","",  "","",""})

	//          GRUPO,ORDEM ,PERGUNT                ,PERSPA,PERENG,VARIAVL ,TIPO,TAMANHO,DECIMAL,PRESEL,GSC,VALID,VAR01     ,DEF01,DEFSPA1,DEFENG1,CNT01,VAR02,DEF02,DEFSPA2,DEFENG2,CNT02,VAR03,DEF03,DEFSPA3,DEFENG3,CNT03,VAR04,DEF04,DEFSPA4,DEFENG4,CNT04,VAR05,DEF05,DEFSPA5,DEFENG5,SCNT05,F3,PYME,GRPSXG,HELP,PICTURE,IDFIL

	// Nova pergunta, por Gilberto - 17/03/2010
	PutSx1(cPerg,"22","Considera Valor?" ,"Considera Valor?" ,"Considera Valor?" ,"mv_chM","N",1,0,2,"C","","","","","mv_par22","Valor Original","Valor Original","Valor Original","","Saldo do Titulo","Saldo do Titulo","Saldo do Titulo","","","","","","","","","",{},{},{})

	// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria SX1 se não existir ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_CriaSx1(cPerg,aRegs)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o SX1 se a chamada foi feita por outro programa ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAuto
		dbSelectArea("SA6")
		dbSetOrder(1)
		If !dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta,.f.)
			Aviso("Impressao de Boletos","Configuraçao de banco nao encontrada para o banco "+Alltrim(cbanco)+", agencia "+Alltrim(cAgencia)+", conta "+Alltrim(cConta)+" do cliente "+Alltrim(SA1->A1_NOME)+". Verifique o cadastro de parametros de bancos para que a rotina possa ser gerada.",{"OK"},,"Atencao:")
			DbSelectArea("QUERY")
			Return(Nil)
		EndIf
		cCarteira 	:= SEE->EE_SUBCTA
		cConvenio 	:= Alltrim(SEE->EE_CODEMP)
		
		//----------------------------------------------------------------------------------------------------------------------------------------
		// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
		//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
		/*
		dbSelectArea("SX1")
		dbSeTorder(1)
		MsSeek(cPerg)
		While !Eof() .and. SX1->X1_GRUPO == cPerg
			Reclock("SX1",.F.)
			If SX1->X1_ORDEM == "01"
				SX1->X1_CNT01	:= cPrefixo
			ElseIf SX1->X1_ORDEM == "02"
				SX1->X1_CNT01	:= cPrefixo
			ElseIf SX1->X1_ORDEM == "03"
				SX1->X1_CNT01	:= cNumero
			ElseIf SX1->X1_ORDEM == "04"
				SX1->X1_CNT01	:= cNumero
			ElseIf SX1->X1_ORDEM == "05"
				SX1->X1_CNT01	:= cParcela
			ElseIf SX1->X1_ORDEM == "06"
				SX1->X1_CNT01	:= cParcela
			ElseIf SX1->X1_ORDEM == "07"
				SX1->X1_CNT01	:= cCliente
			ElseIf SX1->X1_ORDEM == "08"
				SX1->X1_CNT01	:= cCliente
			ElseIf SX1->X1_ORDEM == "09"
				SX1->X1_CNT01	:= cLoja
			ElseIf SX1->X1_ORDEM == "10"
				SX1->X1_CNT01	:= cLoja
			ElseIf SX1->X1_ORDEM == "11"
				SX1->X1_CNT01	:= SA6->A6_BANCO
			ElseIf SX1->X1_ORDEM == "12"
				SX1->X1_CNT01	:= SA6->A6_AGENCIA
			ElseIf SX1->X1_ORDEM == "13"
				SX1->X1_CNT01	:= SA6->A6_CONTA
			ElseIf SX1->X1_ORDEM == "14"
				SX1->X1_CNT01	:= SA6->A6_SUBCTA
			ElseIf SX1->X1_ORDEM == "15"
				SX1->X1_PRESEL	:= 2
			ElseIf SX1->X1_ORDEM == "16'"
				SX1->X1_PRESEL	:= 2
			ElseIf SX1->X1_ORDEM == "17"
				SX1->X1_PRESEL	:= 1
			EndIf
			MsUnLock()
			dbSkip()
		EndDo
		*/
		//{ Fim } --------------------------------------------------------------------------------------------------------------------------------		
		
		Pergunte(cPerg,.F.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chama a pergunte para definir os parâmetros iniciais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Else
		If !Pergunte(cPerg, .T.)
			Return(Nil)
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a rotina para carregar os dados a serem processados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Processa( { |lEnd| CallLst() }, "Selecionando dados a processar", Titulo )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se há dados a serem exibidos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aLst) > 0
		Processa( { |lEnd| CallMark(aLst) }, "Selecionando dados a processar", Titulo )
	Else
		Aviso(	Titulo,;
		"Não existem dados a serem impressos. Verifique os parâmetros.",;
		{"&Continua"},,;
		"Sem Dados" )
	EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CallLst  ³ Carrega os registros a serem processados                     º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 17.01.07 ³ CIE				                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 21.01.07 ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99.99.99 - Consultor - Descrição da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CallLst()

	Local aAreaAtu	:= GetArea()
	Local aTamSX3	:= {}
	Local nCnt		:= 0
	Local cQuery	:= ""

	// Por Gilberto, 17/03/2010 - Para ajuste no calculo do valor do boleto.
	Local nValor   := 0

	If Select("TQUERY") > 0
		dbSelectArea("TQUERY")
		dbCloseArea()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a query de seleção ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQry	:= " SELECT R_E_C_N_O_ AS REGSE1,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_CLIENTE,"
	cQry	+= " SE1.E1_LOJA,SE1.E1_NOMCLI,SE1.E1_EMISSAO,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_PORTADO,"
	cQry	+= " SE1.E1_NUMBCO,SE1.E1_VENCREA,SE1.E1_NUMBOR"
	cQry	+= " FROM "+RetSqlName("SE1")+" SE1 (NOLOCK)"
	cQry	+= " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
	cQry	+= " AND SE1.E1_SALDO > 0"


	cQry	+= " AND SE1.E1_PREFIXO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"
	cQry	+= " AND SE1.E1_NUM BETWEEN     '"+mv_par03+"' AND '"+mv_par04+"'"
	cQry	+= " AND SE1.E1_PARCELA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	cQry	+= " AND SE1.E1_TIPO IN('NF ','RA ','FT ', 'BOL')"  // Incluido tipo BOL para a Vicar - Luis Dantas 20/09/12
	cQry	+= " AND SE1.E1_CLIENTE BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
	cQry	+= " AND SE1.E1_LOJA BETWEEN    '"+mv_par09+"' AND '"+mv_par10+"'"

	//cQry	+= " AND SE1.E1_NUMBOR > '      '"

	cQry    += " AND SE1.E1_VENCREA >= '"+dtos(mv_par18)+"' AND SE1.E1_VENCREA <= '"+dtos(mv_par19)+"'"
	cQry	+= " AND SE1.E1_NUMBOR  BETWEEN  '"+mv_par20+"' AND '"+mv_par21+"'"

	/*
	If mv_par15 == 1
	cQry	+= " AND SE1.E1_NUMBCO <> '"+Space(TAMSX3("E1_NUMBCO")[1])+"'"
	If SE1->(FieldPos("E1_BCOBOL")) > 0
	cQry	+= " AND SE1.E1_BCOBOL = '"+mv_par11+"'"
	Else
	cQry	+= " AND SE1.E1_PORTADO = '"+mv_par11+"'"
	EndIf
	Else
	cQry	+= " AND SE1.E1_NUMBCO = '"+Space(TAMSX3("E1_NUMBCO")[1])+"'"
	Endif
	*/
	cQry	+= " AND SE1.D_E_L_E_T_ <>'*'"
	cQry	+= " ORDER BY SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se existir o alias temporário, fecha para não dar erro ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select("rBol745A") > 0
		dbSelectArea("rBol745A")
		dbCloseArea()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a select no banco para pegar os registros a processar ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQry	:= ChangeQuery(cQry)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry), "TQUERY", .T., .F. )


	TCQUERY cQry NEW ALIAS "rBol745A"
	dbSelectArea("rBol745A")
	dbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Compatibiliza os campos com a TopField ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTamSX3	:= TAMSX3("E1_EMISSAO")
	TCSETFIELD("rBol745A", "E1_EMISSAO",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3	:= TAMSX3("E1_VENCTO")
	TCSETFIELD("rBol745A", "E1_VENCTO",		aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3	:= TAMSX3("E1_VENCREA")
	TCSETFIELD("rBol745A", "E1_VENCREA",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3	:= TAMSX3("E1_VALOR")
	TCSETFIELD("rBol745A", "E1_VALOR",		aTamSX3[3], aTamSX3[1], aTamSX3[2])

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Conta os registros a serem processados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	rBol745A->( dbEval( { || nCnt++ },,{ || !Eof() } ) )
	dbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta array com os dados a serem exibidos na tela de marcação ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("rBol745A")
	dbGoTop()
	ProcRegua( nCnt )

	While !Eof()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta regua de Impressão ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncProc( "Título: " + rBol745A->E1_PREFIXO +"/"+ rBol745A->E1_NUM +"/"+ rBol745A->E1_PARCELA )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo o valor do titulo  ³
		//³ Por Gilberto - 17/03/2010  ³
		//³ mv_par22,qdo = 1, E1_VALOR ³
		//³ mv_par22,qdo = 2, E1_SALDO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nValor:= Iif( mv_par22 == 2, U_R170ValorTit( rBol745A->REGSE1 ), rBol745A->E1_VALOR )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria o elemento no array ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aLst, {	(mv_par17 == 1),;
		rBol745A->E1_PREFIXO,;
		rBol745A->E1_NUM,;
		rBol745A->E1_PARCELA,;
		rBol745A->E1_TIPO,;
		rBol745A->E1_CLIENTE,;
		rBol745A->E1_LOJA,;
		rBol745A->E1_NOMCLI,;
		rBol745A->E1_EMISSAO,;
		rBol745A->E1_VENCTO,;
		rBol745A->E1_VENCREA,;
		nValor,;
		rBol745A->E1_PORTADO,;
		rBol745A->REGSE1 })
		dbSelectArea("rBol745A")
		dbSkip()
	EndDo



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha a área de trabalho ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("rBol745A")
	dbCloseArea()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura área original ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(aAreaAtu)
Return(Nil)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CallMark ³ Monta a tela de impressão gráfica                            º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 17.01.07 ³ CIE				                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 21.01.07 ³                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99.99.99 - Consultor - Descrição da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CallMark()

	Local oLst
	Local oDlg
	Local oOk			:= LoadBitMap(GetResources(), "LBTIK")
	Local oNo			:= LoadBitMap(GetResources(), "NADA")
	Local lExec			:= .F.
	Local lProc			:= .F.
	Local nLoop			:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta interface com usuário para efetuar a marcação dos títulos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE "Seleção de Títulos" FROM 000,000 TO 400,700 OF oDlg PIXEL
	@ 005,003	LISTBOX oLst ;
	FIELDS HEADER	" ",;
	"Prefixo",;
	"Número",;
	"Parcela",;
	"Tipo",;
	"Cliente",;
	"Loja",;
	"Nome",;
	"Emissão",;
	"Vencimento",;
	"Venc.Real",;
	"Valor",;
	"Portador" ;
	COLSIZES	GetTextWidth(0,"BB"),;
	GetTextWidth(0,"BBBB"),;
	GetTextWidth(0,"BBBBB"),;
	GetTextWidth(0,"BB"),;
	GetTextWidth(0,"BB"),;
	GetTextWidth(0,"BBBB"),;
	GetTextWidth(0,"BB"),;
	GetTextWidth(0,"BBBBBBBBBBBB"),;
	GetTextWidth(0,"BBBB"),;
	GetTextWidth(0,"BBBB"),;
	GetTextWidth(0,"BBBB"),;
	GetTextWidth(0,"BBBBBBBBB"),;
	GetTextWidth(0,"BBB") ;
	ON DBLCLICK(	aLst[oLst:nAt,1] := !aLst[oLst:nAt,1],;
	oLst:Refresh() ) ;
	SIZE 345,170 OF oDlg PIXEL

	oLst:SetArray(aLst)
	oLst:bLine := { || {	If(aLst[oLst:nAt,01], oOk, oNo),;							// Marca
	aLst[oLst:nAt,02],;											// Prefixo
	aLst[oLst:nAt,03],;											// Numero
	aLst[oLst:nAt,04],;											// parcela
	aLst[oLst:nAt,05],;											// Tipo
	aLst[oLst:nAt,06],;											// Cliente
	aLst[oLst:nAt,07],;											// Loja
	aLst[oLst:nAt,08],;											// Nome
	DToC(aLst[oLst:nAt,09]),;				   					// Emissão
	DToC(aLst[oLst:nAt,10]),;									// Vencimento
	DToC(aLst[oLst:nAt,11]),;									// Vencimento real
	Transform(aLst[oLst:nAt,12], "@E 999,999,999.99"),;		// Valor
	aLst[oLst:nAt,13] ;											// Portador
	} }

	DEFINE SBUTTON oBtnOk	FROM 180,310 TYPE 1 ACTION(lExec := .T., oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON oBtnCan	FROM 180,275 TYPE 2 ACTION(lExec := .F., ODLG:end()) ENABLE OF oDlg

	ACTIVATE DIALOG oDlg CENTERED

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se teclou no botão confirma ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExec
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se tem algum título marcado ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nLoop := 1 To Len(aLst)
			If aLst[nLoop,1]
				lProc	:= .T.
				Exit
			EndIf

		Next nLoop

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Avisa usuário que não há título marcado ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lProc
			Aviso(	Titulo,;
			"Nenhum título foi marcado. Não há dados a serem impressos.",;
			{"&Continua"},,;
			"Sem Dados" )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Chama a rotina que irá montar e imprimir o relatório ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Else
			Processa( { |lEnd| MontaRel() }, "Montando Imagem do Relatório.", Titulo )
		Endif
	EndIf


Return(Nil)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ MontaRel ³ Monta a imagem do relatório a ser impresso                   º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 17.01.07 ³  CIE					                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 21.01.07 ³                          					                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99.99.99 - Consultor - Descrição da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaRel()

	Local oPrint
	Local aDadEmp	:= {}
	Local aDadBco	:= {}
	Local aDadTit	:= {}
	Local aDadCli	:= {}
	Local aBarra	:= {}
	Local nLoop		:= 0
	Local nTpImp	:= 2      //2 = CENTIMETRO 1 = POLEGADA

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define o tipo de configuração a ser utilizado na MSBAR ³
	//³ 1 = Polegadas, 2 = Centímetros                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//nTpImp	:= Aviso(	Titulo,;
	//   		  			"Os boletos devem ser impressos com qual definição ?",;
	//					{ "Polegadas", "Centímetros" },,;
	//					"Definição de Tamanho" )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seta as configuração do objeto print ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:= TMSPrinter():New( Titulo )
	oPrint:Setup()
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:SetSize(215,297)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no Banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA6")
	dbSetOrder(1)
	If !MsSeek(xFilial("SA6")+mv_par11+mv_par12+mv_par13)
		Aviso(	Titulo,;
		"Banco/Agência/Conta: "+ AllTrim(mv_par11) +"/"+ AllTrim(mv_par12) +"/"+ AllTrim(mv_par13) +Chr(13)+Chr(10)+;
		"O registro não foi localizado no arquivo. Será desconsiderado.",;
		{"&Continua"},2,;
		"3Inválido" )
		Return(Nil)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no Parâmetro do Banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEE")
	dbSetOrder(1)
	If !MsSeek(xFilial("SEE")+mv_par11+mv_par12+mv_par13+mv_par14)//"1") //mv_par14)
		Aviso(	Titulo,;
		"Banco/Agência/Conta/Carteira: "+ AllTrim(mv_par11) +"/"+ AllTrim(mv_par12) +"/"+ AllTrim(mv_par13) +"/"+ AllTrim(mv_par14) + Chr(13) + Chr(10) +;
		"Os parâmetros do banco não foram localizados. Será desconsiderado.",;
		{"&Continua"},2,;
		"Registro Inválido" )
		Return(Nil)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama rotina que pega os dados do banco e empresa ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !U_TCDadBco(aDadEmp, aDadBco)
		Aviso(	Titulo,;
		"Banco/Agência/Conta: "+ AllTrim(mv_par11) +"/"+ AllTrim(mv_par12) +"/"+ AllTrim(mv_par13) +"/"+ Chr(13) + Chr(10) +;
		"Banco do cliente: "+ SA1->A1_BCO1 + Chr(13) + Chr(10) + ;
		"Não foi possível obter os dados do banco.",;
		{"&Continua"},2,;
		"Registro Inválido" )
		Return(Nil)
	EndIf

	ProcRegua(Len(aLst))

	For nLoop := 1 To Len(aLst)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta régua de impressão ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncProc( "Título: " + aLst[nLoop,02] +"/"+ aLst[nLoop,03] )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Só processa se estiver marcado ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aLst[nLoop,01]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no título ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE1")
			dbSetOrder(1)
			dbGoTo(aLst[nLoop,14])
			If Eof() .Or. Bof()
				Aviso(	Titulo,;
				"Título :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+;
				"O título não foi localizado no arquivo. Será desconsiderado.",;
				{"&Continua"},2,;
				"Registro Inválido" )
				Loop
			EndIf


			If Empty(SE1->E1_NUMBCO)
				// Alterado em 10/08/06 para não permitir duplicar nosso numero no SE1
				_lTemNN:=.T.
				//	_cNossoNum := StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,10)
				While _lTemNN
					IF RecLock("SEE",.F.)
						_cNossoNum := StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,10)
						//	SEE->EE_FAXATU := _cNossoNum
						MsUnlock()
						_lTemNN:= u_TemNumBco(_cNossoNum)
					Endif
				EndDo
			Endif

			u_LogNumBco()            // Grava log de geração de nosso numero


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no Cliente ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA1")
			dbSetOrder(1)
			If !MsSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				Aviso(	Titulo,;
				"Título :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+;
				"Cliente/Loja: "+ SE1->E1_CLIENTE +"/"+ SE1->E1_LOJA +Chr(13)+Chr(10)+;
				"O cliente não foi localizado no arquivo. Será desconsiderado.",;
				{"&Continua"},2,;
				"Registro Inválido" )
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o considera o banco definido no cadastro do cliente e ³
			//³ se o banco do parâmetro é o mesmo do cadastro                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par16 == 1 .And. !Empty(SA1->A1_BCO1) .And. SA1->A1_BCO1 <> mv_par11
				Aviso(	Titulo,;
				"Título :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+;
				"Banco/Agência/Conta: "+ mv_par11 +"/"+ mv_par12 +"/"+ mv_par13 +Chr(13)+Chr(10)+;
				"Banco do cliente: "+ SA1->A1_BCO1 +Chr(13)+Chr(10)+ ;
				"O Banco do cadastro é diferente do parâ,etro. Será desconsiderado.",;
				{"&Continua"},2,;
				"Registro Inválido" )
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no Título ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE1")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Chama rotina que pega os dados do título e cliente ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !U_TCDadTit(aDadTit, aDadCli, aBarra, aDadBco)
				Aviso(	Titulo,;
				"Título :"+ aLst[nLoop,02] +"/"+ aLst[nLoop,03] +"/"+ aLst[nLoop,04] +"/"+ aLst[nLoop,05] +Chr(13)+Chr(10)+;
				"Não foi possível obter os dados do título. será desconsiderado.",;
				{"&Continua"},2,;
				"Registro Inválido" )
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Chama a função de impressão do boleto ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


			U_TCImpBol(oPrint,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o título com o nosso número ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SE1")

			RecLock("SE1",.F.)
			If Empty(SE1->E1_NUMBCO)  // Gilberto 15/10/2010
				SE1->E1_NUMBCO	:= aBarra[3]
			EndIf

			If FieldPos("E1_BCOBOL") > 0
				SE1->E1_BCOBOL	:= aDadBco[1]
			Else
				SE1->E1_PORTADO	:= aDadBco[1]
				SE1->E1_AGEDEP	:= aDadBco[3]
				SE1->E1_CONTA	:= aDadBco[5]
			EndIf
			MsUnlock()

		EndIf

	Next nLoop

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama rotina para visualizar o(s) boleto(s) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oPrint:Preview()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a chamada da SetPrint ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MS_FLUSH()

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TEMNUMBCO ºAutor  ³Renato Takao        º Data ³21/08/07     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consiste se tem nosso numero na base                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TemNumBco(_cNossoNum)
	Local aGetArea:= GetArea()
	Local _lRet:=.T.
	cQuery0 := "SELECT R_E_C_N_O_ E1_NUMBCO "
	cQuery0 += " FROM "+RetSqlName("SE1")+" SE1 (NOLOCK)"
	//cQuery0 += " FROM "
	//cQuery0 += RetSQLName ("SE1") + " E1 "
	cQuery0 += "  WHERE "
	cQuery0 += "D_E_L_E_T_= ' '" + " AND "
	cQuery0 += "E1_NUMBCO = '"+(_cNossoNum)+"'"
	cQuery0 	:= ChangeQuery(cQuery0)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery0),"QRYTMP",.T.,.T.)

	DbSelectArea("QRYTMP")
	DbGoTop()

	If Eof().And.Bof()
		_lRet:=.F.
	EndIf

	DbCloseArea("QRYTMP")
	RestArea(aGetArea)
Return(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaLog  ºAutor  ³				     º Data ³  21/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava log de geração de nosso numero                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//U_GrNumBco()

User Function LogNumBco()
	Local aGetArea:= GetArea()
	Local _cNameLog, _nArqLog
	Local _cText:= ""

	_cNameLog:="GERANOSSONUM_"+cEmpAnt+cFilAnt+"_"+dtos(ddatabase)+"_"+alltrim(SE1->E1_CLIENTE)+".LOG"
	If !File(_cNameLog)
		_nArqLog := FCreate(_cNameLog)
		If _nArqLog  < 0
			Return
		Endif
		FSeek(_nArqLog,0,0)
	Else
		_nArqLog := FOpen(_cNameLog,2)
		If _nArqLog < 0
			Return
		Endif
		FSeek(_nArqLog,0,2)
	Endif

	_cText:="Em "+dtoc(ddatabase)+"-"+TIME()+" gerou nosso numero:"+SE1->E1_NUMBCO+" para o titulo "
	_cText+=SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+" do cliente "+SE1->E1_CLIENTE
	_cText+=" com vencto em "+dtoc(SE1->E1_VENCREA)+" pelo usuario "+alltrim(substr(cUsuario,7,15))+CHR(13)+CHR(10)

	FWrite(_nArqLog,_cText)

	FClose(_nArqLog)

	RestArea(aGetArea)
Return            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CriaSX1  ³ Cria no SX1 os parametros necessarios para a rotina          º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 17.01.07 ³  CIE				                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 21.01.07 ³ 					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CriaSx1( cPerg, aRegs )

//----------------------------------------------------------------------------------------------------------------------------------------
// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
/*
Local i := 0

For i := 1 To Len( aRegs )
PutSX1(aRegs[i,1],;
aRegs[i,2],;
aRegs[i,3],;
aRegs[i,4],;
aRegs[i,5],;
aRegs[i,6],;
aRegs[i,7],;
aRegs[i,8],;
aRegs[i,9],;
aRegs[i,10],;
aRegs[i,11],;
aRegs[i,12],;
aRegs[i,13],;
aRegs[i,14],;
aRegs[i,15],;
aRegs[i,16],;
aRegs[i,17],;
aRegs[i,18],;
aRegs[i,19],;
aRegs[i,20],;
aRegs[i,21],;
aRegs[i,22],;
aRegs[i,23],;
aRegs[i,24],;
aRegs[i,25],;
aRegs[i,26],;
aRegs[i,27],;
aRegs[i,28],;
aRegs[i,29],;
aRegs[i,30],;
aRegs[i,31],;
aRegs[i,32],;
aRegs[i,33],;
aRegs[i,34],;
aRegs[i,35],;
aRegs[i,36],;
aRegs[i,37],;
aRegs[i,38],;
aRegs[i,39],;
aRegs[i,40],;
aRegs[i,41],;
aRegs[i,42],;
aRegs[i,43]	)

Next i
Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³R170ValorTit ºAutor ³Marcel Borges Ferreira ºData ³   /  /      º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³Calcula valor.       						                     º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObserv.  ³Funcao transportada aqui para seguir o mesmo padro de calculo 	 º±±
±±º         ³na emissao do boleto. Por Gilberto - 17/03/2010.              	 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ 	                                                	         º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function R170ValorTit(nAliasRec)

	Local aArea1:= SE1->( GetArea() )
	Local aArea2:= GetArea()
	Local nMoeda := 1
	Local nValor := 0
	Local nAbat  := 0
	Local ndecs  := Msdecimais(nMoeda)
	Local cBusca

	// Posiciona SE1
	SE1->(dbGoto(nAliasRec))

	nValor:= xMoeda(IIF(SE1->E1_SALDO==0, SE1->E1_VALOR, SE1->E1_SALDO)+SE1->E1_SDACRES-SE1->E1_SDDECRE,SE1->E1_MOEDA,nMoeda,,ndecs+1)

	cBusca := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)
	SE1->(dbSeek(xFilial("SE1")+cBusca))
	While !Eof() .and. SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA) == cBusca
		If SE1->E1_TIPO $ MV_CRNEG+"/"+MVABATIM
			nAbat += xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,nMoeda,,ndecs+1)
		Endif
		SE1->(dbSkip())
	EndDo

	nValor := nValor-nAbat

	// Restaura areas anteriores.
	RestArea(aArea1)
	RestArea(aArea2)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

Return nValor
