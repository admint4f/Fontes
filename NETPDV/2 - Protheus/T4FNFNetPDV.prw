#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "LOJXFUNC.CH"
#INCLUDE "CRDDEF.CH"
#INCLUDE "FWADAPTEREAI.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"

#DEFINE ENTER Chr(13)+Chr(10)

Static cEmpUse     := "20"
Static cFilUse     := "01"

User Function JBNFNETPDV()

	Local aSM0          := {}
	Local i             := 0
	Local nOrcExec      := 0
	Local nJobSimult    := 1

	PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "LOJA"
	aSM0 := {}
	aadd(aSM0,{"20","01"})      //Empresa 20 - Filial 01
	RESET ENVIRONMENT


	For i:=1 to len(aSM0)
		nOrcExec := 0
		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA aSM0[i][1] FILIAL aSM0[i][2] MODULO "LOJA"
		cQuery := " SELECT L1_NUM "
		cQuery += " FROM "
		cQuery += "		"+RetSQLName( "SL1" )+" SL1 "
		cQuery += " WHERE "
		cQuery += "		SL1.D_E_L_E_T_ <> '*' "
		cQuery += "		AND SL1.L1_SITUA = 'RX' "
		cQuery += "		AND SL1.L1_FILIAL = '"+aSM0[i][2]+"' "
		cQuery += "		AND SL1.L1_SERIE = '2  ' "
		cQuery += " ORDER BY L1_NUM "
		TCQuery cQuery New Alias "SL1NET"

		SL1NET->(DbGoTop())
		Count To nOrcExec
		SL1NET->(DbGoTop())

		nJobSimult	:= SuperGetMV("MV_JBLJSMT",.F.,10)

		if nOrcExec > 0
			StartJob("u_T4FNFNetPDV",GetEnvServer(),.F.,aSM0[i][1],aSM0[i][2],cvaltochar(nJobSimult))
		EndIf

		SL1NET->(dbCloseArea())

		RESET ENVIRONMENT
	Next i

Return (.T.)

/*----------------------------------------------------------------------*
 | Func:  U_T4FLjGrvNetPDV()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  JOB de validação de Vendas. Responsável por gerar Documentos 	|
 |        de saída, financeiro, fiscal e contabil. Rotina baseada no 	|
 |        JOB LJGRVBATCH.											 	|
 *----------------------------------------------------------------------*/

User Function T4FNFNetPDV( cEmp, cFilTrab , nJobSimult , cIntervalo, cMinReproc, cJobNFCe,cOrcZZX )
Local nHandle						   			   				// Indica se o arquivo foi criado
Local aFiles		:= {}						   				// Arquivos
Local nIntervalo 	:= 0			   			   				// Intervalo para o Loop
Local nTimes	 	:= 0			   							// Numero de loop antes de entrar no while
Local lRetValue  	:= .F.             			   				// Retorno da função
Local aFiliais   	:= {}              			   				// Filiais
Local aBadRecno  	:= {}			   			   				// Recnos
Local cFileName		:= ""			   			   				// Nome do arquivo
Local nCount 		:= 1						   				// Contador
Local cTemp			:= ""			   			   				// Temporario
Local lTemReserva	:= .F.						   				// Verifica se existe algum item com reserva
Local lProcessou	:= .F.			   			   				// Verifica se processou as vendas na Retaguarda.
Local bOldError  								   				// Bloco de tratamento de erro
Local lLJ7051		:= ExistBlock("LJ7051")	   					// Verifica se a funcao LJ7051 esta compilada
Local lExProc 		:= .T.			   			   				// Controla o while do Killapp
Local lMultFil 		:= .F.			   			   				// Verifica se e' passado mais de uma filial no parametro
Local lCriouAmb		:= .F.			   			   				// Verifica se o PREPARE ENVIRONMENT foi executado
Local nSleep		:= 0			   			   				// Utilizado para atribuicao na variavel nIntervalo
Local aAreaSL1		:= {}			   			   				// Guarda a Area do SL1
Local nRecSL1		:= 0			   			   				// Guarda o Recno do SL1
Local lGerInt 		:= .F.             			   				// Verifica se a integracao esta habilitada
Local aRecFail		:= {}			   			   				// Registros que nao conseguiram ser travados
Local oLJCLocker 	:= Nil
Local lLj7064       := ExistBlock("LJ7064") 	   				// Verifica se existe o ponto de entrada LJ7064
Local nOpcProc		:= 0			   			   				// Opcao de processamento
Local lLstPresAt	:= .F.              		   				// Lista de presente ativa?
Local lMvLjGrvBt	:= .F. 						   				// Parametro que define se utilizara o indice "14" para priorizar a integracao dos orcamentos com reserva.
Local lFtvdVer12	:= FindFunction("LjFTvd") .AND. LjFTVD() 	// Verifica se é Release 11.7 e o FunName é FATA701 - Compatibilização Venda Direta x Venda Assisitida
Local cNomeProg		:= Iif(lFtvdVer12,"FATA701","LOJA701") 		// Nome da Rotina
Local lTPLOtica 	:= .F.
Local lMvLjOffLn 	:= .F.
Local lUsaInd14 	:= .F. 										// Indica se usa o indice 14 da tabela SL1 para priorizar os orcamentos com pedido.
Local cMvLJILJLO 	:= ""
Local cCliPad		:= ""										// Cliente Padrao
Local cLojaPad		:= ""										// Loja Padrao
Local nMinReproc	:= 0										// Utilizado para atribuicao na variavel cMinReproc
Local nMinFalha		:= 0										// Tempo da ultima falha de processamento
Local lReproc		:= .T.										// Sinaliza se deve marcar como registro ja reprocessado, somente quando utiliza cMinReproc
Local lLj7082		:= ExistBlock("LJ7082")						// Indica se o PE LJ7082 esta compilado
Local lRetLj7082	:= .F.										// Retorno do PE LJ7082
Local lTryAgain		:= .F.										// Criada a variavel para tentar novamente caso o cliente esteja alocado ou nao exista
Local lLj7095		:= ExistBlock("LJ7095")						// Utilizado para liberacao da gravacao da venda com SA1 lock(para evitar erro de lock na MatxAtu(A040DupRec), deve trabalhar com o PE: F040TRVSA1)
Local lRetLj7095	:= .F.										// Retorno do PE LJ7082 - Se .T., libera gravacao da venda com registro Lock
Local lRestartGB 	:= .F.										// Variavel de controle para reinicar o ljGrvBatch
Local nPosCanNfc    := 0 
Local cErro         := ""

Local lCancNFCE		:= FindFunction("LjCancNFCe")				// Indica se a função de cancelamento de NFC-e esta compilada no RPO
Local aJobs			:= {}										// vetor com os jobs configurado no appserver.ini
Local nJobNFCe		:= 1										// indica se o job de cancelamento da NFC-e deve ser iniciado, caso ele nao esteja configurado no appserver.ini (espelho da variavel cJobNFCe)
Local lIntegDef		:= .F. 										// Integracao via Mensagem Unica
Local lLj140StIn	:= ExistFunc("Lj140StInD")
//Local aAreaZZV  := ZZV->( GetArea() )

Local lRunJob 		:= .F.
Local nArq			:= 1

cIntervalo  := "N"									// Conteudo do terceiro parametro (Parm3 do mp8srv.ini)
cMinReproc	:= "N"										// Conteudo do quarto parametro, para tentar processar novamente o registro quando ocorre falha por Lock(SA1)
cJobNFCe	:= '1'										// se 1, verifica se o job de cancelamento da NFC-e esta configurado no appserver.ini, se não estiver, o job sera iniciado com os mesmos parametros do LjGrvBatch

Default cOrcZZX:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel Private para que caso seja execultada a funcao      ³
//³ via JOB, atribua o valor padrao a nMoedaCor.				 ³
//³ Rotina Utilizada para o Padrao, Lista de Presentes e Localiza³
//³ cao Chile/Colombia.                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nMoedaCor 	:= 1
Private cMsgErro    := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento caso o terceiro parametro seja passado ou nao.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType(cIntervalo) <> "N"
	nSleep := Val(cIntervalo)
Else
	nSleep := cIntervalo
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento caso o quarto parametro seja passado ou nao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType(cMinReproc) <> "N"
	nMinReproc := Val(cMinReproc)
Else
	nMinReproc := cMinReproc
Endif
//
// Tratamento para o quinto parametro
//
If ValType(cJobNFCe) <> "N"
	nJobNFCe := Val(cJobNFCe)
Else
	nJobNFCe := cJobNFCe
Endif

While nCount <= Len( cFilTrab )

	cTemp := ""
	While SubStr( cFilTrab, nCount, 1 ) <> "," .AND. nCount <= Len( cFilTrab )
		cTemp += SubStr( cFilTrab, nCount, 1 )
		nCount++
	End
	AADD( aFiliais, { cTemp } )
	nCount++

End

nCount := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o numero de filiais que esta sendo passado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aFiliais) > 1
	lMultFil := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variavel lExProc inicializada como True³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


While !KillApp() .AND. lExProc
	//cFileName := cEmp + aFiliais[ nCount ][1]
	lRunJob := .F.
	for nArq := 1 to val(nJobSimult)
		cFileName := cValToChar(nArq+10)
		If (!lMultFil .AND. lCriouAmb) .OR. ( nHandle := MSFCreate("LJGR"+cFileName+".WRK") ) >= 0
			lRunJob := .T.
			Exit
		EndIf
	next nArq

	If lRunJob
		// (!lMultFil .AND. lCriouAmb) .OR. ( nHandle := MSFCreate("LJGR"+cFileName+".WRK") ) >= 0
		If lMultFil .OR. !lCriouAmb
			//ALE ConOut("LJGrvBatch: "+STR0075 + cEmp + STR0076 + aFiliais[ nCount ][1])  // "Empresa:" ### " Filial:"
			//ALE ConOut("            "+STR0021)  //"Iniciando processo de gravacao batch..."

			RPCSetType(3)  // Nao comer licensa

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Retirado PREPARE ENVARIMEND porque em alguns casos trava o JOB³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RPCSETENV(cEmp, aFiliais[ nCount ][1],,,"LOJ")
			lCriouAmb := .T.
			lIntegDef := FWHasEAI("LOJA701",, .T., .T.)

			//Quando executado via Job, verifica se origem Loja
			//Seta nModulo para 12 para garantir execucao via Loja
			If cNomeProg == "LOJA701"
				nModulo := 12
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Objeto para envio de mensagem pelo EventViewer ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Type("oEvent") <> "O"
				oEvent := LjcEventIntegracao():New()
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz a inicializacao de variaveis de PARAMETROS que serao utilizadas no Loop da SL1.                        ³
			//³Faz esta inicializacao aqui para executar apenas uma vez, ao inves de executar varias vezes no Loop da SL1.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCliPad		:= SuperGetMV("MV_CLIPAD")				// Cliente Padrao
			cLojaPad	:= SuperGetMV("MV_LOJAPAD")				// Loja Padrao
			lGerInt 	:= SuperGetMv("MV_LJGRINT",.F.,.F.) 	// Verifica se a integracao esta habilitada
			lLstPresAt	:= SuperGetMV("MV_LJLSPRE",.F.,.F.) .AND. LjUpd78Ok()
			lMvLjGrvBt 	:= SuperGetMv("MV_LJGRVBT",.F.,.F.) 	// Se o parametro for .F. nao utiliza o indice "14" da SL1
			lUsaInd14 	:= lMvLjGrvBt .AND. AllTrim(SL1->(IndexKey(14))) = "L1_FILIAL+L1_SITUA+L1_STATUS" //Indica se usa o indice 14 da tabela SL1 para priorizar os orcamentos com pedido.
			lTPLOtica 	:= HasTemplate("OTC") 					// Verifica se eh Template Otica
			lMvLjOffLn  := SuperGetMv("MV_LJOFFLN", Nil, .F.) 	// Identifica se o ambiente esta operando em offlinpe
			cMvLJILJLO  := SuperGetMV( "MV_LJILJLO",,"2" )    	// Se utilizará sistema de travas nos Jobs FRTA020, LOJA1115 e LJGrvBatch. (0=Não, 1=Sim)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Integração Varejo envio do status de Erro do processamento da venda³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÄÄÄÄ
		If FWHasEAI("LOJXFUNC",.T.,, .T.) //Integração Varejo envio do status ou Erro do processamento da venda
			LojEaiErr()//Funcão para chamada da Integração do EAI para o envio de processamento com erro.
		EndIf
		
		//----------------------------------------------------------------------------------//
		//	JOB de Cancelamento da NFC-e													//
		//	Caso o job de cancelamento da NFC-e não esteja configurado no appserver.ini,	//
		//	iniciamos ele em uma nova thread usando os mesmos parametros do LjGrvBatch,		//
		//	com exceção do intervalo de execução, que sera de 3 minutos						//
		//----------------------------------------------------------------------------------//
			
		//Armazeno as Thred's abertas na variavel aJobMonitor (o mesmo listado no Monitor.exe)
		aJobMonitor := GetUserInfoArray()
		nPosCanNfc  := Ascan( aJobMonitor,{|x| AllTrim( Upper(x[5]) ) == "LJCANCNFCE"})
			
		//Caso o job LJCANCNFCE estiver contido no array aJobMonitor na posição 5 indica que o Job esta iniciado
		If nJobNFCe == 1 .AND. nPosCanNfc == 0 .AND. lCancNFCE .AND. !Empty( SuperGetMV("MV_NFCEURL",,"") )
				
			aJobs := JobInfo()

			//verificamos se o Job da NFC-e está configurado no appsever.ini
			nPos := aScan( aJobs, {|x| x[1] == "LJCANCNFCE"} )

			If nPos == 0
				//ALE  Conout( "LjCancNFCe: Iniciando o JOB de Cancelamento da NFC-e" )
				//ALE  LjGrvLog('GravaBatch', "LjCancNFCe: Iniciando o JOB de Cancelamento da NFC-e")

				StartJob( "LJCANCNFCE", GetEnvServer(), .F., cEmp, cFilTrab, '180' )

				//ALE  Conout( "LjCancNFCe: JOB de Cancelamento da NFC-e iniciado" )
				LjGrvLog('GravaBatch', "LjCancNFCe: JOB de Cancelamento da NFC-e iniciado")
			EndIf
		Else

			If nPosCanNfc > 0
				LjGrvLog("GravaBatch", "Job LjCancNFCe em execução")
			EndIf
		EndIf

		If lCriouAmb
			If cMvLJILJLO == "1"
				oLJCLocker := LJCGlobalLocker():New()
				If !oLJCLocker:GetLock( "LOJXFUNCILLock" )
					return
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Todos os arquivos devem ser abertos antes de entrar no Begin Transaction.    ³
		//³Caso exista customizacao, os arquivos devem ser abertos neste PE.            ³
		//³OBS: O ADSSERVER nao permite uso da ChkFile() dentro de um Begin Transaction.³
		//³Em outros ambientes, este problema nao ocorre.                               ³
		//³Retornar um array, por exemplo {"SZ1", "SZ2"}                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lFtvdVer12
			If ExistBlock("LJGRVOPEN")
				aFiles := ExecBlock("LJGRVOPEN", .F., .F.)
				RPCOpenTables(aFiles)
			EndIf
		ElseIf lFtvdVer12
			If ExistBlock("FTVDGRVOPEN")
				aFiles := ExecBlock("FTVDGRVOPEN", .F., .F.)
				RPCOpenTables(aFiles)
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processar a transferencia de caixa automatica, se necessario. ³
		//³Esse processamento deve chamar independente se existe SL1 para³
		//|explorir ou nao, no entanto foi incluido fora do Loop da SL1. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If GetNewPar("MV_LJTRANS",.F.)
			If FindFunction("LjVerTrans")
				LjVerTrans()
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Utiliza o indice L1_FILIAL+L1_SITUA+L1_STATUS para priorizar os orcamentos com pedido. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lUsaInd14
			SL1->(DbSetOrder(14)) //L1_FILIAL+L1_SITUA+L1_STATUS
			If !SL1->(DbSeek(xFilial("SL1")+"RX"+"F"))
				SL1->(DbSetOrder(9))
				SL1->(DbSeek(xFilial("SL1")+"RX"))
			EndIf
		Else
			IF !EMPTY(cOrcZZX)
				SL1->(DBSetFilter( {||SL1->L1_SERIE = "2  " .AND. SL1->L1_NUM = cOrcZZX}, 'SL1->L1_SERIE = "2  " .AND. SL1->L1_NUM = "'+cOrcZZX+'"' ))
			ELSE
				SL1->(DBSetFilter( {||SL1->L1_SERIE = "2  "}, 'SL1->L1_SERIE = "2  "' ))
			ENDIF
			SL1->(DbSetOrder(9))
			SL1->(DBGOTOP())
			SL1->(DbSeek(xFilial("SL1")+"RX"))
		EndIf

		// xFilial("SL1") ==  SL1->L1_FILIAL .AND. ( SL1->L1_SITUA == "RX" .OR.  SL1->L1_SITUA == "X2" ) //alterado 04/04 Alessandra
		If xFilial("SL1") ==  SL1->L1_FILIAL .AND. ( SL1->L1_SITUA == "RX" .OR.  SL1->L1_SITUA == "X2" ) .AND. ALLTRIM(SL1->L1_SERIE) == "2"
			If SL1->(!RLock())
				SL1->( DbSkip() )
				Loop
			endIf
		EndIf

		If SL1->(Eof())
			Exit
		EndIf
													
		//While xFilial("SL1") ==  SL1->L1_FILIAL .AND. SL1->L1_SITUA == "RX"  //alterado  04/04 Alessandra
		While xFilial("SL1") ==  SL1->L1_FILIAL .AND. SL1->L1_SITUA == "RX" .AND. ALLTRIM(SL1->L1_SERIE) == "2"
			//ALE LjGrvLog('GravaBatch', "ID_INICIO")
			//ALE LjGrvLog(SL1->L1_NUM,"Inicio do Processamento da Venda NETPDV"+time())
				
			//Varifico se a variavel dDatabase esta atualizada com a data atual
			if dDataBase <> Date()
				LjGrvLog(SL1->L1_NUM,"Diferença entre dDataBase e Date(), o ljGrvBatch sera reiniciado.")
				LjGrvLog(SL1->L1_NUM,"Função Date() = " + dToc(Date()) + " Variavel dDataBase = " + dToc(dDataBase))
					
				//Gravo o arquivo .Fim para iniciar a reinicialização do ljGrvBatch
				LjGrvEnd()
				lRestartGB := .T.
				Exit
			Endif 

			If !LjVldBatch(.F.)		//realiza validacoes se a venda pode ser processada. Exemplo: SA1,SL1 alocado
				
				//Se retornou que a venda nao pode ser processada, verifica se deve pular a venda para tentar novamente em outro momento
				//Em geral, a venda nao pode ser processada por Lock de registro, por esse motivo tenta em outro momento
				//Caso ja tenha tentado em outro momento algumas vezes, forca o processamento para que siga o fluxo padrao e se o impedimento for mantido, a venda ficara com ER
				If LjTryAgain(@aRecFail,nMinReproc)
					LjGrvLog(SL1->L1_NUM,"Venda nao sera processada nesse momento")
					LjGrvLog('GravaBatch', "ID_ALERT")
					SL1->( DbSkip() )
					Loop
				EndIf 			
									
			EndIf
					
			//Valida consistencia dos dados do orçamento
			If !LjVldBatch(.T.)
				LjGravaErr("")
			EndIf 
											
			If ( nPos := ASCAN( aBadRecno, SL1->( Recno() ) ) ) > 0
				//While SL1->L1_FILIAL == xFilial("SL1") .AND. SL1->L1_SITUA == "RX" .AND. ; //alterado 04/04 Alessandra
				While SL1->L1_FILIAL == xFilial("SL1") .AND. SL1->L1_SITUA == "RX" .AND. ALLTRIM(SL1->L1_SERIE == "2") .AND. ;
					( ASCAN( aBadRecno, SL1->( Recno() ) ) > 0 )
					SL1->( DbSkip() )
				End
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Executa o PE, que verifica se a venda sera processada ou nao pelo LjGrvBatch.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lLj7082
				lRetLj7082 := ExecBlock("LJ7082",.F.,.F.)
				If !lRetLj7082
					SL1->( DbSkip() )
					Loop
				EndIf
			EndIf

			// Protecao para nao permitir venda que nao tenha numeracao
			If Empty(SL1->L1_DOC) .AND. Empty(SL1->L1_DOCPED) .And. Empty(SL1->L1_DOCRPS)
				//ALE  ConOut(Chr(13)+Chr(10)+"LJGrvBatch: "+TIME()+" "+STR0079+aFiliais[nCount][1]+ " ORC:"+SL1->L1_NUM +" Com o L1_DOC, DOCPED e DOCRPS em branco")
				LjGrvLog(SL1->L1_NUM,Chr(13)+Chr(10)+"LJGrvBatch: "+TIME()+" "+STR0079+aFiliais[nCount][1]+ " ORC:"+SL1->L1_NUM +" Com o L1_DOC, DOCPED e DOCRPS em branco" )
				LjGravaErr("L1_DOC, DOCPED e DOCRPS em branco")
				SL1->( DbSkip() )
				Loop
			EndIf

			/* Verifica se o cliente esta alocado para outro usuario , caso esteja coloca
			esse registro na fila novamente,apos cinco tentativas grava o mesmo como ER */
			lTryAgain := .F.
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			If SA1->(MsSeek(xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA))
				If AllTrim(cCliPad+cLojaPad) <> AllTrim(SA1->A1_COD+SA1->A1_LOJA)
					If SA1->(Rlock())		// Funcao que tenta alocar sem chamar tela
						SA1->(MsUnlock())
					Else
						lTryAgain := .T.  	// Cliente alocado por outro usuario
					EndIf
				EndIf
			Else
				lTryAgain := .T. 			// Cliente ainda nao existe na base
			EndIf

			// Tratamento para pular esse registro e ir para o proximo pelo menos 5 vezes

			If lTryAgain
				nPos := aScan( aRecFail,{|x| x[1] ==  SL1->(Recno())})
				If nPos == 0
					aAdd(aRecFail,{ SL1->(Recno()) , 1, TIME() } )
				Else
					//ALE Conout(Chr(13) + Chr(10)+"LJGrvBatch: " + TIME() + " " + STR0079 + aFiliais[ nCount ][1] + "."+STR0146+; // "Filial " #"Registro alocado,Cliente:"
					//ALE SL1->L1_CLIENTE + STR0147 + SL1->L1_LOJA ) // " Loja:"#"
					If aRecFail[nPos][2] > 5
						//PE: Liberacao da gravacao da venda com SA1 lock(para evitar erro de lock na MatxAtu(A040DupRec), deve trabalhar com o PE: F040TRVSA1) - Nao foi realizado bloqueio se o cliente existe na base, documentacao do PE possui esse alerta
						If lLj7095
							//ALE ( NIL, "Antes da execução do PE LJ7095")
							lRetLj7095 := ExecBlock("LJ7095",.F.,.F.)
							//ALE LjGrvLog( NIL, "Depois da execução do PE LJ7095",lRetLj7095)
							If lRetLj7095
								//ALE ConOut( Chr(13) + Chr(10)+"LJGrvBatch: " + TIME() + " " + STR0079 + aFiliais[ nCount ][1] + "."+STR0146+;		// "Filial " #"Registro alocado ou inexistente,Cliente:"
								//ALE SL1->L1_CLIENTE+ STR0147 +SL1->L1_LOJA + STR0179) // #" Loja:"# " a gravacao da venda foi liberada via PELJ7095"
								lTryAgain := .F.
							EndIf
						EndIf

						If lTryAgain
							LjGravaErr()
							//ALE ConOut( Chr(13) + Chr(10)+"LJGrvBatch: " + TIME() + " " + STR0079 + aFiliais[ nCount ][1] + ". ORC:"+SL1->L1_NUM+" "+STR0146+;		// "Filial " #"Registro alocado ou inexistente,Cliente:"
							//ALE 	SL1->L1_CLIENTE+ STR0147 +SL1->L1_LOJA + STR0148) // #" Loja:"# " a venda sera gravada como 'ER'."
							If SL1->(ColumnPos("L1_ERGRVBT")) > 0
								RecLock("SL1",.F.)
								SL1->L1_ERGRVBT := "LJGrvBatch: " + TIME() + " " + STR0079 + aFiliais[ nCount ][1] + "."+STR0146+;		// "Filial " #"Registro alocado,Cliente:"
								SL1->L1_CLIENTE+ STR0147 +SL1->L1_LOJA + STR0148
								SL1->(MsUnLock())
							EndIf
						EndIf
					Else
						//Verifica se ultima validacao eh inferior ao tempo de reprocessamento
						If nMinReproc > 0
							nMinFalha 	:= Val(SubStr( ELAPTIME( aRecFail[nPos][3], TIME() ),4,2))
							lReproc 	:= IIF(nMinFalha < nMinReproc,.F.,.T.)
						Else
							lReproc := .T.
						EndIf

						If lReproc
							aRecFail[nPos][2]++
							aRecFail[nPos][3] := TIME() //Atualiza Ult verificacao
							//ALE Conout(Chr(13) + Chr(10)+"LJGrvBatch: " + TIME() + STR0079 + aFiliais[ nCount ][1] + "."+STR0146+; // "Filial " #"Registro alocado,Cliente:"
							//ALE 	SL1->L1_CLIENTE + STR0147 + SL1->L1_LOJA + STR0149) // " Loja:"#" tentara depois processar novamente."
						EndIf
					EndIf
				EndIf

				//Quando libera gravacao via PE LJ7095, nao deve ir para o próxim
				If lTryAgain
					SL1->(DbSkip())
					Loop
				EndIf
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Protejo situação de todos os orcamentos "RX" estarem em aBadRecno, neste    ³
			//³ caso não devo processar o proximo (que eh eof), mas sim abandonar o Loop    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SL1->(Eof()) .OR. SL1->L1_SITUA <> 'RX'
				Exit
			EndIf

			nOpcProc := 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento de lista de presentes  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lLstPresAt
				nOpcProc := Lj843GrvMv(SL1->L1_NUM)
				//Caso a rotina tenha identificado que existem itens de entrega, alterar a variavel identificadora de reserva
				If nOpcProc == 1
					lTemReserva := .T.
				Endif
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se os itens foram gravados corretamente³
			//³Não grava como reserva, quando Template Otica   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nOpcProc == 0
				lTemReserva := .F.
				SL2->( DbSetOrder( 1 ) )
				If SL2->( DbSeek( xFilial( "SL2" ) + SL1->L1_NUM ) ) .AND. !lTPLOtica
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se existe item com Reserva na venda ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					While SL2->L2_FILIAL + SL2->L2_NUM == xFilial( "SL2" ) + SL1->L1_NUM
						If !Empty(SL2->L2_RESERVA) .AND. SL2->L2_ENTREGA <> "2"	//RETIRA
							lTemReserva := .T.
							nOpcProc := 1	//LJ7PEDIDO
							Exit
						Endif
						SL2->(DbSkip())
					EndDo
				Endif
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Quando orçamento(filho) possui outro orçamento com reserva,     ³
			//³Limpa L1_Status para salvar como venda e não gerar nova reserva.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lTemReserva .AND. !Empty(SL1->L1_ORCRES)
				lTemReserva := .F.
				If nOpcProc == 1
					nOpcProc := 2
				Endif
				RecLock("SL1", .F.)
					REPLACE SL1->L1_STATUS WITH ""
				MsUnlock()
			EndIf

			cEstacao  := SL1->L1_ESTACAO
			aAreaSL1  := SL1->(GetArea())
			nRecSL1	  := SL1->(Recno())
			

			//Caso nao seja processamento de pedido (entrega) e lista de presentes do tipo credito, processar o LjGrvTudo
			If nOpcProc == 0
				nOpcProc := 2
			Endif
					
			RecLock("SL1",.F.)
				SL1->L1_TPORC := "E"
			SL1->(MsUnlock())

			//ALE Conout("LJGrvBatch: antes LjGrvTudo "+ time())
			lProcessou := LjGrvTudo(.F.,.F.)
			//ALE Conout("LJGrvBatch: depois LjGrvTudo "+ time())
			IF (ALLTRIM(SL1->L1_SERIE) == "2") //SERIE NETPDV
				dDataNF	 := " "			
				IF lProcessou
					cMsgErro := U_T4FNFCeNetPDV(SL1->L1_FILIAL, SL1->L1_NUM, SL1->L1_DOC, SL1->L1_SERIE, SL1->L1_PDV) //alterado em 04/04 Alessandra
					//ALE Conout("LJGrvBatch: depois NFCE "+ time())
					IF EMPTY(cMsgErro)
						cStatus  := "6" //transmitiu NFCE
						cMessage := "NFCE Autorizada"
						dDataNF	 := DTOS(SL1->L1_EMISNF)
					ELSE
						cStatus  := "5" //Gerou Documento Saida
						cMessage := cMsgErro
					ENDIF
					lRetValue:= .T.
					FRTProcSZ()

					If ( nTimes > 30 ) .OR. ( nIntervalo == nSleep )

						If File("LJGR"+cFileName+".FIM")
							//ALE ConOut("            "+STR0023) 	//"Solicitacao para finalizar gravacao batch atendida..."
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Somente apaga o arquivo quando existir³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							FErase("LJGR"+cFileName+".FIM")
							lExProc := .F.
							//Exit
						EndIf
						nTimes := 0
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Somente apaga o arquivo de orcamentos quando existir³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					LjxCDelArq( SL1->L1_NUM )

					nIntervalo := 0
					nTimes++
									
				ELSE
					cStatus  := "4"
					cMessage := "Erro na Geracao DOC SAIDA"
					lRetValue:= .F.
					
					LjGravaErr()
					//ALE ConOut("LJGrvBatch: "+ STR0079 + aFiliais[ nCount ][1] + ". "+STR0022) // "Filial " ### ". " "Ocorreu algum erro no processo de gravacao batch..."
					AADD(aBadRecno, SL1->(Recno()) )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Envia msg pelo EventViewer ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oEvent:SetMsg("Erro", STR0079 + aFiliais[ nCount ][1] + ". " + STR0022) // "Filial " ### ". " "Ocorreu algum erro no processo de gravacao batch..."
					oEvent:Enviar()
					
					//Exit

				ENDIF
				lRet:= lProcessou
				//cStatus,cRecnos,cOrcamento,cNumero,cMsg,cHist,lExc)
				U_grvStZZX(cStatus,,SL1->L1_NUM,SL1->L1_DOC,cMessage,"ROTINA NF e TRANSMISSAO",,dDataNF) //processamento zzx

			ENDIF
			
			RestArea(aAreaSL1)

			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Utiliza o indice L1_FILIAL+L1_SITUA+L1_STATUS para priorizar os orcamentos com pedido. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lUsaInd14
				SL1->(DbSetOrder(14)) //L1_FILIAL+L1_SITUA+L1_STATUS
				If !SL1->(DbSeek(xFilial("SL1")+"RX"+"F"))
					SL1->(DbSetOrder(9))
					SL1->(DbSeek(xFilial("SL1")+"RX"))
				EndIf
			Else
				SL1->(DbSetOrder(9))
				SL1->(DbSeek(xFilial("SL1")+"RX"))
			EndIf
					
			//ALE LjGrvLog('GravaBatch', "ID_FIM")
			//ALE LjGrvLog(SL1->L1_NUM,"Fim do Processamento da Venda")
					
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄa¿
		//³Checa se a tabela MBZ e função de gravacao de estorno existem na base                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄaÙ
		Lj601GrPDV()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄa¿
		//³Checa se o arquivo existe fora so while do SL1 para apagar quando não existir RX no SL1 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄaÙ
		If ( nTimes > 30 ) .OR. ( nIntervalo == nSleep ) .OR. lRestartGB
			If File("LJGR"+cFileName+".FIM")
				//ALE ConOut("            "+STR0023) //"Solicitacao para finalizar gravacao batch atendida..."
				FErase("LJGR"+cFileName+".FIM")
				return
			EndIf
			nTimes := 0
		EndIf

		nIntervalo := 0
		nTimes++
		aBadRecno  := {}

		If( cMvLJILJLO == "1", oLJCLocker:ReleaseLock( "LOJXFUNCILLock" ),NIL)
				
			nIntervalo := nSleep
			If ( nIntervalo > 0 )
				Sleep(nIntervalo)
			EndIf

			If lMultFil
				FClose(nHandle)
				FErase("LJGR"+cFileName+".WRK")
				//ALE ConOut("            "+STR0075 + cEmp + STR0076 + aFiliais[ nCount ][1]+" - "+STR0024) //""Empresa:" ### " Filial: - Processo de gravacao batch finalizado..."
			Endif

			If nCount < LEN( aFiliais )
				nCount := nCount + 1
			Else
				nCount := 1
			EndIf
		/*Else
			lRetValue := .F.
			return*/
		EndIf

End

If !lMultFil .OR. !lExProc
	RESET ENVIRONMENT
Endif

FClose(nHandle)
FErase("LJGR"+cFileName+".WRK")

DBCloseAll()

Return ( lRetValue )



//----------------------------------------------------------------
/*/{Protheus.doc} LJCANCNFCE
Funcao que devera ser executada em Job.
Faz o monitoramento das NFC-e que estao com cancelamento pendente,
sendo que se o cancelamento for autorizado, ela fará a exclusão da nota no ERP. 
@param	 cEmp - Grupo de Empresa
@param	 cFiliais - Filiais (se for mais de uma, deve-se separar por ;
@param	 cSleep - intervalo entre cada execução
@author  Varejo
@version P11.8
@since   08/09/2015
/*/
//----------------------------------------------------------------
/*
User Function T4FLJCanc(cEmp,cFil)

default cEmp  := ""

	If !Empty(cEmp)
		RPCSetEnv(cEmp, cFil, Nil, Nil, "LOJA")
	EndIf

	lLxIteracao := SLX->(ColumnPos("LX_ITERACA") ) > 0 .And. SLX->(ColumnPos("LX_DULTPRC") ) > 0 .And. SLX->(ColumnPos("LX_HULTPRC") ) > 0

	//----------------------------------------------------
	// Faz o cancelamento da NFC-e com base na tabela SL1
	//----------------------------------------------------
	LjCanComL1()

	//-----------------------------------------------------------------
	// Faz o cancelamento/Inutilizacao da NFC-e com base na tabela SLX
	//-----------------------------------------------------------------
	LjCanComLX()
	
	If !Empty(cEmp)
		RESET ENVIRONMENT

		dbCloseAll()
	EndIf

Return Nil
Return ( cMsgErro )
*/
