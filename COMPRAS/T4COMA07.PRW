#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4COMA07 	ºAutor  ³Microsiga           º Data ³  28/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação de solicitação de compras pelo  Excel           º±±
±±º          ³ geração dos pedidos de compras                  		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function T4COMA07(cArqE,cOrigemE,nLinTitE,lTela)

	Local bOk        := {||lOk:=.T.,oDlg:End()}
	Local bCancel    := {||lOk:=.F.,oDlg:End()}
	Local lOk        := .F.
	Local nLin       := 20
	Local nCol1      := 15
	Local nCol2      := nCol1+30
	Local cMsg       := ""
	Local oDlg
	Local oArq
	Local oOrigem
	Local oMacro
	Local aButtons := {}
	Local _aStru	:= {}
	Local _oTMPTable

	Default lTela := .T.

	Private cArq       	:= ""//If(ValType(cArqE)=="C",cArqE,"")
	Private cArqMacro  	:= "XLS2DBF.XLA"
	Private cTemp   	:= GetTempPath() //pega caminho do temp do client
	Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))//Pega o caminho do sistema
	Private cOrigem    := If(ValType(cOrigemE)=="C",cOrigemE,"")
	Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
	Private aArquivos  := {}
	Private aRet       := {}
	Private lUsr	   	:= .f.
	Private _cTemp
	Public  _cTpCpr		:= "D"
	Public  _oTpCpr
	Public  _cGeraPA
	Public  _lOk
	Public _oTpCpr
	Public _oGeraPA
	Public _oValPA
	Public _oVencPA
	Public _nValPA
	Public _dVencPA
	Public _oObsAprov
	Public _cObsAprov
	Public _cObsForn
	Public _oObsForn
	Public _oMailForn
	Public _eMailForn

	Static lSair := .t.
	Static _nRegistro := 0

	IF SELECT("TMP") # 0
		//TMP->(DBCLOSEAREA( ))
		_oTMPTable:FWTemporaryTable():Delete()		
	ENDIF

	// Escolha do Arquivo formato CSV a ser importado pelo Excel
	// O Arquivo deverá ter o seguinte cabeçalho :
	// C1_PRODUTO	C1_VUNIT	C1_QUANT	C1_DATPRF	    C1_CONDPAG	C1_OBS	C1_FORNECE	C1_LOJA	   C1_CC
	// Codigo Item  Valor Unit  Quantidade  Necess.Entrega  Cond.Pagto  Obs     cod.Forn    Loja Forn  Centro de Custos


	cArq       += Space(20-(Len(cArq)))
	cOrigem    += Space(99-(Len(cOrigem)))

	aAdd(aButtons,{"SOLICITACAO DE COMPRAS",{|| 	U_fXGetArq() },"Arquivos"})

	If lTela .Or. Empty(AllTrim(cArq)) .Or. Empty(AllTrim(cOrigem))

		if !lSair
			Return
		endif

		Define MsDialog oDlg Title 'Integração de Excel' From 7,10 To 20,50 OF oMainWnd


		nLin -= 12
		@ nLin,nCol1  Say      'Estrutura excel deve ter colunas conforme acordado entre os departamentos'  Of oDlg Pixel
		nLin += 12

		@ nLin,nCol1  Say      'Arquivo :'                                Of oDlg Pixel
		@ nLin,nCol2  MsGet    oArq   Var cArq            Size 60,09 Of oDlg Pixel

		nLin += 15

		@ nLin,nCol1  Say      'Caminho do arquivo :'                     Of oDlg Pixel
		nLin += 10
		@ nLin,nCol1  MsGet    oOrigem Var cOrigem            Size 130,09 Of oDlg Pixel

		nLin += 15

		Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel,.F.,aButtons) Centered

	Else
		lOk := .T.
	EndIf

	If lOk
		cMsg := validaCpos()
		aAdd(aArquivos, cArq)
		If	Empty(cMsg)
			LjMsgRun(OemToAnsi("importando Excel. Por favor aguarde!"),,{||fIntArq()} ) // Função para importar planilha do Excel
		Else
			MsgStop(cMSg)
			Return
		EndIf
	EndIf


	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	// Gravação dos dados da Planilha na tabela temporária TMP
	IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
	ENDIF

	if file(_cTemp+".dtc")
	dbUseArea(.T.,__LocalDriver,_cTemp,"TMP",.F.)  // Reabre arquivo temporário
	else
	Return
	endif
	*/
	IF Len("TMP") > 0
		_oTMPTable:FWTemporaryTable():Delete()
	ENDIF

	If ! File ("TMP")
		Return
	endif

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	Processa( {|| aRet:= GravaSC() } ,"Aguarde, gravando registros ... ")
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	//ConOut("Terminou gravação do arquivo SC1 -"+Time())	

	FWLogMsg("INFO", "", "", "T4COMA07", "", "", "Terminou gravação do arquivo SC1 - " + Time(), 0, 0)

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	Return

	*-------------------------*
Static Function GravaSC()  
	// ExecAuto para gravar a solicitação de compras 
	// Utiliza funções, pontos de entrada e gatilhos 
	// do sistema gerando Pedidos de Compras e Alçadas
	*-------------------------*

	Local _dData

	TMP->(dbGoTop())
	cC1_XOBSAPR := tmp->C1_XOBSAPR
	cC1_ITEMCTA := tmp->C1_ITEMCTA
	ProcRegua(reccount())
	nX:=0
	_nRegistro++

	If TMP->(!EOF())
		cDoc := GetSXENum("SC1","C1_NUM")
		SC1->(dbSetOrder(1))
		While SC1->(dbSeek(xFilial("SC1")+cDoc))
			ConfirmSX8()
			cDoc := GetSXENum("SC1","C1_NUM")
		EndDo

		aItens := {}
		aCabecalho := {}

		While TMP->(!EOF())
			IncProc("Gravando registros "+AllTrim(str(recno(),6))+" de "+AllTrim(Str(reccount(),6)))
			nX++
			Select SB1
			seek xFilial()+tmp->c1_Produto
			Select TMP

			_dData		:= dDatabase
			aCabecalho :=	{ 													 ;
							{ "C1_NUM" 		, cDoc 						, NIL}	,;
							{ "C1_FILIAL"	, xFilial("SC1") 			, NIL}	,;
							{ "C1_EMISSAO" 	, _dData	 				, NIL	}}
							
							//----------------------------------------------------------------
							// Comentado devido ao campo possuir inicializador padrão
							//----------------------------------------------------- { Inicio }
							
							//{ "C1_SOLICIT" 	, UsrRetName(RetCodUsr())	, NIL}	,;
							
							//{ Fim } --------------------------------------------------------
							
							//{ "C1_UNIDREQ" , "  " , NIL},;
							//{ "C1_CODCOMP" , aSC[01,11] , NIL};
							//   }

			nVUnit := val(tmp->C1_VUNIT) + val(substr(tmp->C1_VUNIT,(at(',',tmp->C1_VUNIT)+1),2))/100

			aAdd(aItens, { 	{"C1_ITEM"   	,StrZero(nX,Len(SC1->C1_ITEM))		, Nil},; //  13-Item da SC
							{"C1_PRODUTO" 	, tmp->C1_PRODUTO					, NIL},; // 03-Produto
							{"C1_LOCAL" 	, sb1->B1_LOCPAD					, NIL},; // 10-Local
							{"C1_CC" 		, tmp->C1_cc						, NIL},; //tmp->C1_CC , NIL},; // 09-Centro de Custo
							{"C1_DESCRI" 	, sb1->B1_DESC						, NIL},; // 04-Descricao
							{"C1_QUANT" 	, val(tmp->C1_QUANT)				, NIL},; // 05-Quantidade
							{"C1_VUNIT" 	, nVUnit							, NIL},; // 05-Valor Unitário
							{"C1_T4FTOT" 	, val(tmp->C1_QUANT)*nVUnit			, NIL},; // Valor Total
							{"C1_CODCOMP" 	, "1" 								, NIL},; // 11-Cod. Comprad
							{"C1_CONDPAG" 	, TRIM(TMP->C1_CONDPAG) 			, NIL},; // Cond. Pagamento
							{"C1_OBS" 		, TMP->C1_OBS 						, NIL},; // Observação
							{"C1_FORNECE" 	, TMP->C1_fornece 					, NIL},; // Fornecedor
							{"C1_LOJA" 		, strzero(val(TMP->C1_LOJA),2) 		, NIL},; // Loja Fornecedor
							{"C1_XOBSAPR" 	, tmp->C1_XOBSAPR					, NIL},; // Observação Aprovador
							{"C1_DATPRF"	, dDataBase+1						, NIL}}) // 06-Data Prevista de Entrega (assumir data da digitação + 1 dia)
			//		{"C1_UNIDREQ" 	, "  " 								, NIL},; // 12-Unid. Requis
			Select TMP
			skip
		EndDo
		lMsErroAuto := .f.
		MSExecAuto({|X,Y,Z| Mata110(X,Y,Z)}, aCabecalho, aItens)//, 3) //insere a SC no novo numero

		If lMsErroAuto
			SC1->(RollBackSXE())
			MostraErro()
		Else
			_lOk	:= .T.
		Endif
		Select SC1
		cNum := SC1->C1_NUM
		cDoc := SC1->C1_PEDIDO


		//----------------------------------------------------------------------------------------------------------------------------------------
		// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
		//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
		/*
		IF SELECT("TMP") # 0
		TMP->(DBCLOSEAREA( ))
		ENDIF

		dbUseArea(.T.,__LocalDriver,_cTemp,"TMP",.F.)
		*/

		IF SELECT("TMP") # 0
			_oTMPTable:FWTemporaryTable():Delete()
		ENDIF

		_oTMPTable:= FWTemporaryTable():New("TMP")

		//{ Fim } --------------------------------------------------------------------------------------------------------------------------------		

		_nRegistro++
		dbgoto(_nRegistro)
		if reccount()<_nRegistro
			//			exit
		endif
		//	EndDo

		If _lOk
			cObs1 :=""
		EndIf
	EndIf
	If _lOk
		Aviso(	"Solicitação de Compras importada com sucesso",+ ;
		"Número da SC : " + cNum + CRLF + "Número do Pedido : " + cDoc + CRLF,{"OK"})
	Endif

	Select SC1
	dbSetOrder(1)
	seek xFilial()+cNum
	do while !eof() .and. c1_Num = cNum
		RecLock("SC1",.f.)
		sc1->C1_XOBSAPR := cC1_XOBSAPR
		sc1->C1_ITEMCTA := cC1_ITEMCTA
		MsUnLock()
		skip
	Enddo

	Select SC7
	dbSetOrder(1)
	seek xFilial()+cDoc
	do while !eof() .and. c7_Num = cDoc
		RecLock("SC7",.f.)
		sc7->C7_XOBSAPR := cC1_XOBSAPR
		sc7->C7_ITEMCTA := cC1_ITEMCTA
		MsUnLock()
		skip
	Enddo


	lSair := .f.
	cArq := "Sair"

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fIntArq   ºAutor  ³Luiz Eduardo        º Data ³ 02/03/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa das rotinas referentes a integração                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 					                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fIntArq()
	Local lConv     := .F.
	Local lCabcOK	:= .F.
	local cCliAnt	:= ""
	local aCabec	:= {}
	Local aItens	:= {}
	local aLinha	:= {}
	Local nItem		:= 0
	local lErrPrd	:= .F.
	Local lPrim		:= .T.
	Local cAntPedC	:= ""
	Private cDescErr:= ""
	Private lErro	:= .F.
	Private lMsErroAuto	:= .F.
	Private lDescErr:= .F.
	Private cBrwMsg	:= ""
	Private nProc	:= 0


	// Cria e Abre arquivo temporário
	_aStru := {}
	//aadd( _aStru , {'C1_FILIAL', 'C' , 20 , 00 } )
	//aadd( _aStru , {'C1_ITEM', 'C' , 20 , 00 } )
	aadd( _aStru , {'C1_PRODUTO', 'C' , 20 , 00 } )
	//aadd( _aStru , {'C1_DESCRI', 'C' , 20 , 00 } )
	aadd( _aStru , {'C1_VUNIT', 'C' , 20 , 00 } )
	aadd( _aStru , {'C1_QUANT', 'C' , 20 , 00 } )
	//aadd( _aStru , {'C1_T4FTOT', 'C' , 20 , 00 } )
	aadd( _aStru , {'C1_DATPRF', 'C' , 20 , 00 } )
	//aadd( _aStru , {'C1_EMISSAO', 'C' , 20 , 00 } )
	aadd( _aStru , {'C1_CONDPAG', 'C' , 20 , 00 } )
	aadd( _aStru , {'C1_OBS', 'C' , 60 , 00 } )
	aadd( _aStru , {'C1_FORNECE', 'C' , 20 , 00 } )
	aadd( _aStru , {'C1_LOJA', 'C' , 20 , 00 } )
	//aadd( _aStru , {'C1_SEGUM', 'C' , 20 , 00 } )
	aadd( _aStru , {'C1_CC', 'C' , 20 , 00 } )
	//aadd( _aStru , {'C1_SOLICIT', 'C' , 20 , 00 } )
	//aadd( _aStru , {'C1_CONTA', 'C' , 20 , 00 } )
	aadd( _aStru , {'C1_XOBSAPR', 'C' , 120 , 00 } )
	aadd( _aStru , {'C1_ITEMCTA', 'C' , 20 , 00 } )

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	_cTemp := CriaTrab(_aStru, .T.)
	dbUseArea(.T.,__LocalDriver,_cTemp,"TMP",.F.)
	*/
	_oTMPTable:= FwTemporaryTable():New("TMP" )
	_oTMPTable:SetFields( aStru )
	_oTMPTable:Create()	

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	//converte arquivos xls para csv copiando para a pasta temp
	//MsAguarde( {|| ConOut("Começou conversão do arquivo "+cArq+ " - "+Time()),;
	//lConv := fXconvArqs(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )
	If lConv .or. 1=1
		//carrega do xls no array

		//----------------------------------------------------------------------------------------------------------------------------------------
		// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
		//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
		//ConOut("Terminou conversão do arquivo "+cArq+ " - "+Time())
		FWLogMsg("INFO", "", "", "T4COMA07", "", "", "Terminou conversão do arquivo "+cArq+ " - "+Time(), 0, 0)


		//ConOut("Começou carregamento do arquivo "+cArq+ " - "+Time())
		FWLogMsg("INFO", "", "", "T4COMA07", "", "", "Começou carregamento do arquivo "+cArq+ " - "+Time(), 0, 0)		

		Processa( {|| aRet:= XCargaArray(AllTrim(cArq)) } ,"Aguarde, carregando planilha... Pode demorar" )

		//ConOut("Terminou carregamento do arquivo "+cArq+ " - "+Time())
		FWLogMsg("INFO", "", "", "T4COMA07", "", "", "Terminou carregamento do arquivo "+cArq+ " - "+Time(), 0, 0)

		//{ Fim } --------------------------------------------------------------------------------------------------------------------------------		

		//	cC1_FILIAL:= ASCAN(aRet[2,1],'C1_FILIAL')
		//	cC1_ITEM:= ASCAN(aRet[2,1],'C1_ITEM')
		cC1_PRODUTO:= ASCAN(aRet[2,1],'C1_PRODUTO')
		//	cC1_DESCRI:= ASCAN(aRet[2,1],'C1_DESCRI')
		cC1_VUNIT:= ASCAN(aRet[2,1],'C1_VUNIT')
		cC1_QUANT:= ASCAN(aRet[2,1],'C1_QUANT')
		//	cC1_T4FTOT:= ASCAN(aRet[2,1],'C1_T4FTOT')
		cC1_DATPRF:= ASCAN(aRet[2,1],'C1_DATPRF')
		//	cC1_EMISSAO:= ASCAN(aRet[2,1],'C1_EMISSAO')
		cC1_CONDPAG:= ASCAN(aRet[2,1],'C1_CONDPAG')
		cC1_OBS:= ASCAN(aRet[2,1],'C1_OBS')
		cC1_FORNECE:= ASCAN(aRet[2,1],'C1_FORNECE')
		cC1_LOJA:= ASCAN(aRet[2,1],'C1_LOJA')
		//	cC1_SEGUM:= ASCAN(aRet[2,1],'C1_SEGUM')
		cC1_CC:= ASCAN(aRet[2,1],'C1_CC')
		//	cC1_SOLICIT:= ASCAN(aRet[2,1],'C1_SOLICIT')
		//	cC1_CONTA:= ASCAN(aRet[2,1],'C1_CONTA')
		cC1_XOBSAPR:= ASCAN(aRet[2,1],'C1_XOBSAPR')
		cC1_ITEMCTA:= ASCAN(aRet[2,1],'C1_ITEMCTA')

		dbSelectArea("TMP")
		For _nR:= 1 to len(aRet[1])
			RecLock("TMP",.T.)
			//		tmp->C1_FILIAL	:= aRet[1,_nR,cC1_FILIAL]
			//		tmp->C1_ITEM	:= aRet[1,_nR,cC1_ITEM]
			tmp->C1_PRODUTO	:= aRet[1,_nR,cC1_PRODUTO]
			//		tmp->C1_DESCRI	:= aRet[1,_nR,cC1_DESCRI]
			tmp->C1_VUNIT	:= aRet[1,_nR,cC1_VUNIT]
			tmp->C1_QUANT	:= aRet[1,_nR,cC1_QUANT]
			//		tmp->C1_T4FTOT	:= aRet[1,_nR,cC1_T4FTOT]
			//tmp->C1_DATPRF	:= aRet[1,_nR,cC1_DATPRF]
			//		tmp->C1_EMISSAO	:= aRet[1,_nR,cC1_EMISSAO]
			tmp->C1_CONDPAG	:= aRet[1,_nR,cC1_CONDPAG]
			tmp->C1_OBS		:= aRet[1,_nR,cC1_OBS]
			tmp->C1_FORNECE	:= aRet[1,_nR,cC1_FORNECE]
			tmp->C1_LOJA	:= aRet[1,_nR,cC1_LOJA]
			//		tmp->C1_SEGUM	:= aRet[1,_nR,cC1_SEGUM]
			tmp->C1_CC		:= aRet[1,_nR,cC1_CC]
			tmp->C1_XOBSAPR := aRet[1,_nR,cC1_XOBSAPR]
			tmp->C1_ITEMCTA := aRet[1,_nR,cC1_ITEMCTA]
			//		tmp->C1_SOLICIT	:= aRet[1,_nR,cC1_SOLICIT]
			//		tmp->C1_CONTA	:= aRet[1,_nR,cC1_CONTA]
			MsUnLock()
		Next _nR


	EndIf
	Select Tmp              

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fconvArqs ºAutor  ³Luiz Eduardo       º Data ³ 06/03/2017   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa que converte os arquivos .xls para .csv            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 					                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fXconvArqs(aArqs)

	Local oExcelApp
	Local cNomeXLS  := ""
	Local cFile     := ""
	Local cExtensao := ""
	Local i         := 1
	Local j         := 1
	Local aExtensao := {}

	private cPar:= "savechanges:=False"

	cOrigem := AllTrim(cOrigem)

	//Verifica se o caminho termina com "\"
	If !Right(cOrigem,1) $ "\"
		cOrigem := AllTrim(cOrigem)+"\"
	EndIf


	//loop em todos arquivos que serão convertidos
	For i := 1 To Len(aArqs)

		If !"." $ AllTrim(aArqs[i])
			//passa por aqui para verifica se a extensão do arquivo é .xls ou .xlsx
			aExtensao := Directory(cOrigem+AllTrim(aArqs[i])+".*")
			For j := 1 To Len(aExtensao)
				If "XLS" $ Upper(aExtensao[j][1])
					cExtensao := SubStr(aExtensao[j][1],Rat(".",aExtensao[j][1]),Len(aExtensao[j][1])+1-Rat(".",aExtensao[j][1]))
					Exit
				EndIf
			Next j
		EndIf
		//recebe o nome do arquivo corrente
		cNomeXLS := AllTrim(aArqs[i])
		//	cFile    := cOrigem+cNomeXLS+cExtensao
		cFile    := cOrigem+cNomeXLS+".csv"
		If !File(cFile)
			MsgInfo("O arquivo "+cFile+" não foi encontrado!" ,"Arquivo")
			Return .F.
		EndIf

		//verifica se existe o arquivo na pasta temporaria e apaga
		If File(cTemp+cNomeXLS+cExtensao)
			fErase(cTemp+cNomeXLS+cExtensao)
		EndIf

		//Copia o arquivo XLS para o Temporario para ser executado
		If !AvCpyFile(cFile,cTemp+cNomeXLS+cExtensao,.F.)
			MsgInfo("Problemas na copia do arquivo "+cFile+" para "+cTemp+cNomeXLS+cExtensao ,"AvCpyFile()")
			Return .F.
		EndIf

		//apaga macro da pasta temporária se existir
		If File(cTemp+cArqMacro)
			fErase(cTemp+cArqMacro)
		EndIf

		//Copia o arquivo XLA para o Temporario para ser executado
		If !AvCpyFile(cSystem+cArqMacro,cTemp+cArqMacro,.F.)
			MsgInfo("Problemas na copia do arquivo "+cSystem+cArqMacro+"para"+cTemp+cArqMacro ,"AvCpyFile()")
			Return .F.
		EndIf

		//Exclui o arquivo antigo (se existir)
		If File(cTemp+cNomeXLS+".csv")
			fErase(cTemp+cNomeXLS+".csv")
		EndIf

		//Inicializa o objeto para executar a macro
		oExcelApp := MsExcel():New()
		//define qual o caminho da macro a ser executada
		oExcelApp:WorkBooks:Open(cTemp+cArqMacro)
		//executa a macro passando como parametro da macro o caminho e o nome do excel corrente
		oExcelApp:Run(cArqMacro+'!XLS2DBF',cTemp,cNomeXLS)
		//fecha a macro sem salvar
		//cPar:= "savechanges:=False"
		oExcelApp:WorkBooks:Close()
		//sai do arquivo e destrói o objeto
		oExcelApp:Quit()
		oExcelApp:Destroy()

		//Exclui o Arquivo excel da temp
		fErase(cTemp+cNomeXLS+cExtensao)
		fErase(cTemp+cArqMacro) //Exclui a Macro no diretorio temporario
		//
	Next i
	//
	Return .T.

	/*
	Funcao      : CargaDados
	Objetivos   : carrega dados do csv no array pra retorno
	Parâmetros  : cArq - nome do arquivo que será usado
	Autor       : Kanaãm L. R. Rodrigues
	Data/Hora   : 24/05/2012
	*/
	*-------------------------*
Static Function XCargaArray(cArq)
	*-------------------------*
	Local cLinha  := ""
	Local nLin    := 1
	Local nTotLin := 0
	Local aDados  := {}
	Local cFile   := cOrigem + cArq + ".csv"
	Local nHandle := 0
	Local aCabecM	:= {}


	//abre o arquivo csv gerado na temp
	nHandle := Ft_Fuse(cFile)
	If nHandle == -1
		Return aDados
	EndIf
	Ft_FGoTop()
	nLinTot := FT_FLastRec()-1
	ProcRegua(nLinTot)
	//Pula as linhas de cabeçalho
	/*
	While nLinTit > 0 .AND. !Ft_FEof()
	Ft_FSkip()
	nLinTit--
	EndDo
	*/
	cLinha := Ft_FReadLn()    //transforma as aspas duplas em aspas simples
	cLinha := StrTran(cLinha,'"',"'")
	cLinha := '{"'+cLinha+'"}'
	//adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
	cLinha := StrTran(cLinha,';','","')
	aAdd(aCabecM, &cLinha)
	For _nREG:= 1 To Len(aCabecM[1])
		aCabecM[1,_nREG]:=Alltrim(aCabecM[1,_nREG])
	Next _nREG
	Ft_FSkip()
	//percorre todas linhas do arquivo csv
	Do While !Ft_FEof()
		//exibe a linha a ser lida
		IncProc("Carregando Linha "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
		nLin++
		//le a linha
		cLinha := Ft_FReadLn()
		//verifica se a linha está em branco, se estiver pula
		If Empty(AllTrim(StrTran(cLinha,';','')))
			Ft_FSkip()
			Loop
		EndIf
		//transforma as aspas duplas em aspas simples

		cLinha := StrTran(cLinha,'"',"'")

		If substr(cLinha,1,1)==";"
			Exit
		Endif
		cLinha := '{"'+cLinha+'"}'
		//adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
		cLinha := StrTran(cLinha,';','","')
		aAdd(aDados, &cLinha)

		//passa para a próxima linha
		FT_FSkip()
		//
	EndDo

	//libera o arquivo CSV
	FT_FUse()

	//Exclui o arquivo csv
	If File(cFile)
		//	FErase(cFile)
	EndIf

	Return {aDados,aCabecM}

	*-------------------------*
Static Function validaCpos()
	*-------------------------*
	Local cMsg := ""

	If Empty(cArq)
		cMsg += "Campo Arquivo deve ser preenchido!"+ENTER
	EndIf

	If Empty(cOrigem)
		cMsg += "Campo Caminho do arquivo deve ser preenchido!"+ENTER
	EndIf

	If Empty(cArqMacro)
		cMsg += "Campo Nome da Macro deve ser preenchido!"
	EndIf


Return cMsg


static FUNCTION NoAcento(cString)
	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõÃÕ"
	Local cCecid := "çÇ"
	Local cMaior := "&lt;"
	Local cMenor := "&gt;"

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next

	If cMaior$ cString
		cString := strTran( cString, cMaior, "" )
	EndIf
	If cMenor$ cString
		cString := strTran( cString, cMenor, "" )
	EndIf

	cString := StrTran( cString, CRLF, " " )

	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|'
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX
	Return cString

Return
