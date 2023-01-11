#include "fileio.ch"
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFINA010 ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reconcilia‡ao Bancaria Automatica                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fina470()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   

User Function RFINA010()

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	F470AjustSX1()
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	pergunte("AFI470",.F.)

	PRIVATE aRotina:= {	{ "Parƒmetros" 		,"u_fA470Par" 	, 0 , 1},;  
						{ "Visualizar" 		,"AxVisual" 	, 0 , 2},;  
						{ "Reconcilia‡„o" 	,"U_f70Gera"	, 0 , 4}}  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define o cabecalho da tela de baixas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE cCadastro :=  "Reconcilia‡„o Banc ria Autom tica"   //
	Private aIndices		:=	{} //Array necessario para a funcao FilBrowse
	Private bFilBrw := {|| }
	Private lFiltBrw:= ExistBlock("F470FBRW")
	Private cFiltro:=""   

	// Variaveis para contabilizacao

	If lFiltBrw
		cFiltro:= ExecBlock( "F470FBRW",.F.,.F.)
		bFilBrw	:=	{|| FilBrowse("SE5",@aIndices,@cFiltro)}
		Eval( bFilBrw )
	EndIf

	mBrowse( 6, 1,22,75,"SE5")
	If lFiltBrw
		EndFilBrw("SE5",@aIndices)
	EndIf

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fA470Ger ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reconcilia‡„o Banc ria Autom tica                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fA470Ger()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA470                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function f70gera(cAlias)

	Private nHdlPrv 	:= 0
	Private lDigita   	:= Iif(mv_par07 ==1,.T.,.F.)
	Private lAglutina 	:= Iif(mv_par06 ==1,.T.,.F.)
	Private lGeraLanc	:= Iif(mv_par08 ==1,.T.,.F.)
	Private cArquivo
	Private  nTotal := 0
	Private cLote :=""

	If lFiltBrw
		EndFilBrw("SE5",@aIndices)
	EndIf
	Processa({|lEnd| fa470Ger(cAlias)})  // Chamada com regua

	// Contabilizacao
	If nHdlPrv > 0 .And. nTotal > 0
		RodaProva(nHdlPrv,nTotal)
		cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglutina)
	EndIf

	If lFiltBrw
		Eval(bFilBrw)
	EndIf
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fA470Gera³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reconciliacao Bancaria Automatica                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fA470Ger()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA470                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fA470Ger(cAlias)
	Local cPosNum,cPosData,cPosValor,cPosOcor,cPosDescr,cPosDif
	Local cColorAnt
	Local lPosNum  :=.F.,lPosData  :=.F.,lPosValor :=.F.
	Local lPosOcor :=.F.,lPosDescr :=.F.,lPosDif   :=.F.
	Local lPosBco  :=.F.,lPosAge   :=.F.,lPosCta   :=.f.
	Local nLidos,nLenNum,nLenData,nLenValor,nLenDescr,nLenOcor,nLenDif
	Local nLenBco,nLenAge,nLenCta
	Local cArqConf,cArqEnt,xBuffer, cRecTRB
	Local dDtaCred := CRIAVAR("E5_DTDISPO")
	Local cData, cDebCred
	Local nSavRecno:= Recno()
	Local nPos
	Local aTabela 	:= {}
	Local cIndex	:= " "					
	Local cMotSist	:= Space(3)				// motivo da ocorrencia no sistema
	Local cMotBan	:= Space(3)				// motivo da ocorrencia no banco
	Local nSeq		:= 0						// controle sequencial de lancto do Banco
	Local lSaida	:= .F.
	Local nValBco
	Local nOpca := 0
	Local aTam:=TamSX3("E5_CONTA")
	Local nTamConta := aTam[1]  			// Tamanho do campo de C.Corrente no sistema
	Local aCores 	:= {}
	Local nCont, li
	Local nHdlBco := 0
	Local cBanco := 	Space(TamSX3("E5_BANCO")[1])
	Local cAgencia := 	Space(TamSX3("E5_AGENCIA")[1]) 
	Local cConta := 	Space(TamSX3("E5_CONTA")[1])
	Local cDifer
	Local lReconc := .F.
	Local oOk	:= LoadBitmap( GetResources(), "BR_VERDE" )
	Local oNo	:= LoadBitmap( GetResources(), "DISABLE" )
	Local oParc	:= LoadBitmap( GetResources(), "BR_AMARELO" )
	LOCAL oJaRec	:= LoadBitmap( GetResources(), "BR_CINZA" )
	LOCAL cVarQ   	:= "  "
	LOCAL oTitulo, oBtn
	LOCAL oDlg
	Local lPosVSI	:=.F.,lPosDSI :=.F.,lPosDCI :=.F.
	Local nLenVSI,nLenDSI,nLenDCI
	Local cPosVSI,cPosDSI,cPosDCI
	Local lFa470Cta := ExistBlock("FA470CTA")
	Local aConta, dDtIniA, dDtFinA
	Local lFebraban := .F.
	Local dOldDispo := Ctod("//")
	Local aCtas470  := {}
	Local nT := 0
	Local lGrava := .T.
	Local lF470Grv := ExistBlock("F470GRV")
	Local lAtSalRec1 := .F.
	Local lAtSalRec2 := .F.
	Local nReconc := 0
	Local cReconAnt := ""
	Local nTipoDat := 1
	Local lF470DAT := ExistBlock("F470DAT")
	Local lF470AtuDt := ExistBlock("F470ATUDT")
	Local lAtuDtDisp := .T.
	Local lQuery	:= .F.
	Local cQuery
	Local cAliasTrb
	Local cCampos
	Local nX
	Local aAreaAtu:={}
	Local lIndice13:=.F.
	Local _cCheques	:= IiF( Type("MVCHEQUES") == "C", MVCHEQUES, MVCHEQUE )

	Aadd(aCores,oOk)
	Aadd(aCores,oNo)
	Aadd(aCores,oParc)
	Aadd(aCores,oJaRec)

	Private cArqRec1, cArqRec2, cArqRec3, cArqRec4 := ""
	Private lMarca    := 1
	Private dDtIni	:= CTOD("01/01/2099","ddmmyy")
	Private dDtFin	:= CTOD("01/01/1980","ddmmyy")

	Private	dDataInic:= dDataBase
	Private	dDataFim:= dDataBase

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no Banco indicado                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEE")
	dbSetOrder(1)    
	If dbSeek(xFilial("SEE")+mv_par03)
		lFebraban := IIF(SEE->EE_BYTESXT > 200 , .t., .f.)
		nTamDet	 := IIF(SEE->EE_BYTESXT > 0, SEE->EE_BYTESXT + 2, 202 )
	Else
		Help(" ",1,"PAR150")
		Return .F.
	Endif                            

	nTipoDat := IIF(nTamDet > 202, 4,1)		//1 = ddmmaa		4= ddmmaaaa

	If lF470DAT
		nTipoDat := ExecBlock("F470DAT",.F.,.F.)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo de configuracao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqConf:=mv_par02

	IF !FILE(cArqConf)
		Help(" ",1,"A470NOPAR")
		Return .F.
	Else
		nHdlConf:=FOPEN(cArqConf,0+64)
	EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ arquivo de configuracao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLidos:=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)

	While nLidos <= nTamArq

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o tipo de qual registro foi lido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)
		IF SubStr(xBuffer,1,1) == CHR(1)  // Header
			nLidos+=85
			Loop
		EndIF

		IF SubStr(xBuffer,1,1) == CHR(4) // Saldo Final
			nLidos+=85
			Loop
		EndIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dados do Saldo Inicial (Bco/Ag/Cta)       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF !lPosBco  //Nro do Banco
			cPosBco:=Substr(xBuffer,17,10)
			nLenBco:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosBco:=.T.
			nLidos+=85
			Loop
		EndIF
		IF !lPosAge  //Agencia
			cPosAge :=Substr(xBuffer,17,10)
			nLenAge :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosAge :=.T.
			nLidos+=85
			Loop
		EndIF
		IF !lPosCta  //Nro Cta Corrente
			cPosCta=Substr(xBuffer,17,10)
			nLenCta=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosCta=.T.
			nLidos+=85
			Loop
		Endif
		IF !lPosDif   // Diferencial de Lancamento
			cPosDif  :=Substr(xBuffer,17,10)
			nLenDif  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDif  :=.t.
			nLidos+=85
			Loop
		EndIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Os dados abaixo nÆo sÆo utilizados na reconcilia‡Æo. ³
		//³ EstÆo ai apenas p/leitura do arquivo de configura‡Æo.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF !lPosVSI   // Valor Saldo Inicial
			cPosVSI  :=Substr(xBuffer,17,10)
			nLenVSI  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosVSI  :=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDSI   // Data Saldo Inicial
			cPosDSI  :=Substr(xBuffer,17,10)
			nLenDSI  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDSI  :=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDCI   // Identificador Deb/Cred do Saldo Inicial
			cPosDCI  :=Substr(xBuffer,17,10)
			nLenDCI  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDCI  :=.t.
			nLidos+=85
			Loop
		EndIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dados dos Movimentos                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF !lPosNum  // Nro do Lancamento no Extrato
			cPosNum:=Substr(xBuffer,17,10)
			nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNum:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosData  // Data da Movimentacao
			cPosData:=Substr(xBuffer,17,10)
			nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosData:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosValor  // Valor Movimentado
			cPosValor=Substr(xBuffer,17,10)
			nLenValor=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosValor=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosOcor // Ocorrencia do Banco
			cPosOcor	:=Substr(xBuffer,17,10)
			nLenOcor :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOcor	:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDescr  // Descricao do Lancamento
			cPosDescr:=Substr(xBuffer,17,10)
			nLenDescr:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDescr:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDif   // Diferencial de Lancamento
			cPosDif  :=Substr(xBuffer,17,10)
			nLenDif  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDif  :=.t.
			nLidos+=85
			Loop
		EndIF
		Exit
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ fecha arquivo de configuracao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Fclose(nHdlConf)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se constam dados banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cPosBco) .or. Empty(cPosAge)   .or. Empty(cPosCta)  .or.;
	Empty(cPosDif) .or. Empty(cPosValor) .or. Empty(cPosOcor) .or.;
	Empty(cPosData) 
		Help(" ",1,"A470NOCFG")
		Return .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo enviado pelo banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqEnt:=mv_par01
	IF !FILE(cArqEnt)
		Help(" ",1,"A470NOBCO")
		Return .F.
	Else
		nHdlBco:=FOPEN(cArqEnt,0+64)
	EndIF

	//Verifica se o arquivo de retorno bancafio ja foi processado
	If !(Chk470File())
		If nHdlBco > 0
			FClose(nHdlBco)
		Endif
		Return .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo de trabalho                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	F470CRIARQ()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ arquivo enviado pelo banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desenha o cursor e o salva para poder moviment -lo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcRegua( nTamArq / nTamDet , 24 )
	nLidos := 0
	While nLidos <= nTamArq
		IncProc()
		nValor  :=0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tipo qual registro foi lido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xBuffer:=Space(nTamDet)
		FREAD(nHdlBco,@xBuffer,nTamDet)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o diferencial do registro de Lancamento 		³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lFebraban  // 200 posicoes
			cDifer :=Substr(xBuffer,Int(Val(Substr(cPosDif, 1,3))),nLenDif )
		Else
			cDifer := "xx"  // 240 posicoes
		Endif

		// Header do arquivo
		IF (SubStr(xBuffer,1,1) == "0" .and. !lFebraban).or. ; // 200 posicoes
		(Substr(xBuffer,8,1) == "0" .and. lFebraban)			// 240 posicoes
			nLidos+=nTamDet
			Loop
		EndIF

		//Trailer do arquivo
		IF (SubStr(xBuffer,1,1) == "9" .and. !lFebraban) .or. ; //200 posicoes
		(Substr(xBuffer,8,1) == "9" .and. lFebraban)			 //240 posicoes
			nLidos+=nTamDet
			dbSelectArea("TRB")
			dbGoTop()
			IF BOF() .and. EOF()
				lSaida := .T.
			Endif
			Exit
		EndIF

		// Saldo Inicial
		IF (SubStr(xBuffer,1,1) == "1" .and. cDifer == "0" .and. !lFebraban) .or. ;
		(SubStr(xBuffer,8,1) == "1" .and. lFebraban)
			cBanco   :=Substr(xBuffer,Int(Val(Substr(cPosBco, 1,3))),nLenBco )
			cAgencia :=Substr(xBuffer,Int(Val(Substr(cPosAge, 1,3))),nLenAge )
			cConta   :=Substr(xBuffer,Int(Val(Substr(cPosCta, 1,3))),nLenCta )
			If lFa470Cta
				aConta   := ExecBlock("FA470CTA", .F., .F., {cBanco, cAgencia, cConta} )
				cBanco   := aConta[1]
				cAgencia := aConta[2]
				cConta   := aConta[3]
			Endif
			If AllTrim(cBanco)!= AllTrim(mv_par03)
				Help(" ",1,"FA470CONTA")
				lSaida := .T.
				Exit
			Endif
			//Monto array com as contas contidas no arquivo de retorno, 
			//para posterior validacao dos movimentos contidos no SE5
			If nT := ascan(aCtas470,{|x| x = cAgencia+cConta }) == 0
				Aadd(aCtas470,cAgencia+cConta)
			Endif

			nLidos+=nTamDet
			Loop
		EndIF

		// Saldo Final
		IF (SubStr(xBuffer,1,1) == "1" .and. cDifer == "2" .and. !lFebraban) .or. ;
		(Substr(xBuffer,8,1) == "5" .and. lFebraban)
			nLidos+=nTamDet
			Loop
		EndIF

		// Lancamentos
		IF (SubStr(xBuffer,1,1) == "1" .and. cDifer == "1" .and. !lFebraban) .or. ;
		(Substr(xBuffer,8,1) == "3" .and. lFebraban)

			cNumMov 	:=Substr(xBuffer,Int(Val(Substr(cPosNum,1,3))),nLenNum)
			cDataBco :=Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
			cDataBco :=ChangDate(cDataBco,nTipoDat)
			dDataMov	:=Ctod(Substr(cDataBco,1,2)+"/"+Substr(cDataBco,3,2)+"/"+Substr(cDataBco,5,2),"ddmmyy")
			cDataMov	:=dToc(dDataMov)
			dDtIni 	:=MIN(dDtIni,dDataMov)
			dDtFin 	:=MAX(dDtFin,dDataMov)
			cValorMov:=Transform(Round(Val(Substr(xBuffer,Int(Val(Substr(cPosValor,1,3))),nLenValor))/100,2),"@E 999,999,999,999.99")
			cCodMov	:=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
			cDescrMov:=Substr(xBuffer,Int(Val(Substr(cPosDescr,1,3))),nLenDescr)

			dbSelectArea("SEJ") 
			If dbSeek(xFilial("SEJ")+cBanco+cCodMov)
				cTipoMov := SEJ->EJ_OCORSIS
				cDescMov := SEJ->EJ_DESCR
				cDebCred := SEJ->EJ_DEBCRE
			Else
				Help(" ",1,"FA470OCOR")
				lSaida := .T.
				Exit
			Endif

			lGrava := .T.
			If lF470GRV
				lGrava := ExecBlock("F470GRV",.F.,.F.,xBuffer)
			Endif

			If lGrava	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Grava dados no arquivo de trabalho³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("TRB")
				DbAppend()
				cRecTRB := STR(TRB->(Recno()))
				TRB->SEQMOV 	:= SUBSTR(cRecTRB,-4)
				TRB->DATAMOV  	:= cDataMov
				TRB->NUMMOV   	:= cNumMov
				TRB->VALORMOV 	:= cValorMov
				TRB->TIPOMOV	:= cTipoMov
				TRB->DESCMOV	:= cDescMov
				TRB->DEBCRED	:= cDebCred
				TRB->DESCRMOV	:= cDescrMov
				TRB->AGEMOV		:= cAgencia
				TRB->CTAMOV		:= cConta
				TRB->OK     	:= 2		// N„O RECONCILIADO
				TRB->OCORBCO    := cCodMov
			Endif
		Endif
		nLidos += nTamDet
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha arquivo do Banco        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Fclose(nHdlBco)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa dados, caso tudo Ok      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRB")
	dbGoTop()
	If BOf() .and. EOF() .and. !lSaida
		Help(" ",1,"ERROCONF")
		lSaida := .T.
	Endif

	dDtIniA := dDtIni           	// Armazeno data inicial e final contido no arquivo
	dDtFinA := dDtFin
	dDtIni  := dDtIni - mv_par05	// Acrescento/diminuo das variaveis para abrir periodo
	dDtFin  := dDtFin + mv_par04	// E5_DTDISPO



	If !lSaida

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abre o SE5 com outro alias para ser filtrado porque a funcao³	
		//³ TemBxCanc() utilizara o SE5 sem filtro.							 ³	
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		dDataInic:= Min(dDtIni,Iif(Empty(mv_par09),dDtIni,mv_par09) )
		dDataFim:= Max(dDtFin,Iif(Empty(mv_par10),dDtFin,mv_par10))
		If ( ChkFile("SE5",.F.,"NEWSE5") )
			#IFDEF TOP
			If TcSrvType() == "AS/400"
				lQuery := .F.
			Else
				lQuery := .T.
			Endif
			#ENDIF	
			cChave  := "E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+DTOS(E5_DTDISPO)"
			If lQuery
				cTipoCH:=IF(Type("MVCHEQUES")=="C",MVCHEQUES,MVCHEQUE)

				cAliasTrb := GetNextAlias()
				aStru  := SE5->(dbStruct())
				cCampos := ""
				aEval(aStru,{|x| cCampos += ","+AllTrim(x[1])})
				cQuery := "SELECT "+SubStr(cCampos,2) + ", R_E_C_N_O_ RECNOSE5 "
				cQuery += "FROM " + RetSqlName("SE5") + " SE5 "
				cQuery += "WHERE E5_FILIAL = '" + xFilial("SE5")+"' AND "
				cQuery += 		 "E5_DTDISPO >= '" + DTOS(dDataInic) + "' AND "
				cQuery += 		 "E5_DTDISPO <= '" + DTOS(dDataFim) + "' AND "
				cQuery += 		 "E5_BANCO = '" + mv_par03 + "' AND "
				cQuery += 		 "E5_SITUACA <> 'C' AND "
				cQuery += 		 "E5_TIPODOC NOT IN " + FormatIn("BA/DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL","/") + " AND "
				cQuery += 		 "E5_VALOR > 0 AND "
				cQuery += 		 "(E5_MOEDA NOT IN " + FormatIn("C1/C2/C3/C4/C5/CH","/") + " OR (E5_MOEDA IN " + FormatIn("C1/C2/C3/C4/C5/CH","/") + " AND E5_NUMCHEQ <> ' ')) AND "
				cQuery += 		 "(E5_NUMCHEQ <> '*' OR (E5_NUMCHEQ = '*' AND E5_RECPAG <> 'P')) AND "  
				cQuery += 		 "((E5_TIPODOC  IN "+ FormatIn(cTipoCH,"|") + "AND  E5_DTDISPO BETWEEN  '" + DTOS(mv_par09)+ "' AND '"  + DTOS(mv_par10) +"' ) OR "  
				cQuery += 		 "(E5_TIPODOC   NOT IN "+ FormatIn(cTipoCH,"|") + "AND  E5_DTDISPO BETWEEN  '" + DTOS(dDtIni)+ "' AND '"  + DTOS(dDtFin) +"' )) AND "  
				cQuery += 		 "(E5_NUMCHEQ <> '*' OR (E5_NUMCHEQ = '*' AND E5_RECPAG <> 'P')) AND "  
				cQuery += 		 "D_E_L_E_T_ = ' ' "
				cQuery += 		 "ORDER BY " + SqlOrder(cChave)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTrb,.T.,.T.)
				For nX :=  1 To Len(aStru)
					If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0
						TcSetField(cAliasTrb,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
					EndIf
				Next nX
			Else

				aAreaAtu := GetArea()
				dbSelectArea("SIX")
				lIndice13:= dbSeek("SE5"+"D")    
				RestArea(aAreaAtu)

				If lIndice13 
					cAliasTrb:="SE5"
					DbSelectArea(cAliasTrb)
					DbSetOrder(13)
					DbSeek(xFilial("SE5")+mv_par03+Dtos(dDataInic),.T.)

				Else
					cAliasTrb := "NEWSE5"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra o SE5 por Banco/Ag./Cta                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("NEWSE5")
					cIndex	:= CriaTrab(nil,.f.)
					IndRegua("NEWSE5",cIndex,cChave,,Fa470ChecF(), "Selecionando Registros...")  //
					DbSelectArea("NEWSE5")
					dbSetIndex(cIndex+OrdBagExt())
					dbGoTop()
				EndIf

			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicia a leitura do arquivo   ³
			//³ de movimentacao do SE5        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			While (cAliasTrb)->(!(Eof())) .And. Iif(!lIndice13,.T.,(cAliasTrb)->(E5_BANCO)==mv_par03 .And. (cAliasTrb)->(E5_DTDISPO)<= dDataFim)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ registros a serem ignorados   ³
				//³ pela movimentacao do SE5      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF (cAliasTrb)->E5_TIPODOC $ "BA/DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL"  //Valores de Baixas
					(cAliasTrb)->( dbSkip())
					Loop
				EndIF

				IF (cAliasTrb)->(E5_BANCO)!=mv_par03
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF

				//----------------------------------------------------------------------------------------------------------------------------------------
				// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
				//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
				//IF (cAliasTrb)->(E5_TIPODOC) $ IIF(Type("MVCHEQUES")=="C",MVCHEQUES,MVCHEQUE) .And.  (cAliasTrb)->(E5_DTDISPO)> MV_PAR10 .And. (cAliasTrb)->(E5_DTDISPO)< MV_PAR09

				IF (cAliasTrb)->(E5_TIPODOC) $ _cCheques .And.  (cAliasTrb)->(E5_DTDISPO)> MV_PAR10 .And. (cAliasTrb)->(E5_DTDISPO)< MV_PAR09
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF

				//IF !((cAliasTrb)->(E5_TIPODOC) $ IIF(Type("MVCHEQUES")=="C",MVCHEQUES,MVCHEQUE)) .And.  (cAliasTrb)->(E5_DTDISPO)> dDtFin .And. (cAliasTrb)->(E5_DTDISPO)< dDtIni 
				IF !((cAliasTrb)->(E5_TIPODOC) $ _cCheques) .And.  (cAliasTrb)->(E5_DTDISPO)> dDtFin .And. (cAliasTrb)->(E5_DTDISPO)< dDtIni
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF

				//{ Fim }---------------------------------------------------------------------------------------------------------------------------------

				//Movimentos do banco mas de contas que nao constem do arquivo de retorno
				//dever ser desprezadas.
				If nT := Ascan(aCtas470,{|x| x == ALLTRIM((cAliasTrb)->E5_AGENCIA)+ALLTRIM((cAliasTrb)->E5_CONTA)}) == 0
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF

				IF (cAliasTrb)->E5_SITUACA = "C"    //Cancelado
					(cAliasTrb)->( dbSkip())
					Loop
				EndIF

				IF (cAliasTrb)->E5_VALOR = 0
					(cAliasTrb)->(dbSkip())
					LOOP
				EndIF

				IF (cAliasTrb)->E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty((cAliasTrb)->E5_NUMCHEQ)
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF

				If SubStr((cAliasTrb)->E5_NUMCHEQ,1,1)=="*"  .AND. (cAliasTrb)->E5_RECPAG=="P"    //cheque para juntar (PA)
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF

				If !Empty( (cAliasTrb)->E5_MOTBX ) .and. !MovBcoBx((cAliasTrb)->E5_MOTBX)
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe estorno para esta baixa                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !lQuery
					If !lIndice13
						SE5->(MsGoto(NEWSE5->(RECNO())))
					EndIf
				Else
					SE5->(MsGoto((cAliasTrb)->RECNOSE5))
				Endif	
				If TemBxCanc((cAliasTrb)->E5_PREFIXO+(cAliasTrb)->E5_NUMERO+(cAliasTrb)->E5_PARCELA+(cAliasTrb)->E5_TIPO+(cAliasTrb)->E5_CLIFOR+(cAliasTrb)->E5_LOJA+(cAliasTrb)->E5_SEQ)
					(cAliasTrb)->( dbskip())
					loop
				EndIf

				IF (cAliasTrb)->E5_TIPODOC = "CH"    //Emiss„o de Cheque
					If SEF->(dbSeek(xFilial("SEF")+(cAliasTrb)->E5_BANCO+(cAliasTrb)->E5_AGENCIA+(cAliasTrb)->E5_CONTA+(cAliasTrb)->E5_NUMCHEQ))
						If SEF->EF_IMPRESS = "C"
							(cAliasTrb)->(dbSkip())
							Loop
						EndIF
					EndIF
				EndIF
				DbSelectArea("TRB")
				DbAppend()
				cRecTRB := STR(TRB->(Recno()))
				TRB->SEQMOV 	:= SUBSTR(cRecTRB,-4)
				TRB->DATAMOV	:= DTOC((cAliasTrb)->E5_DTDISPO)
				TRB->NUMSE5		:= (cAliasTrb)->E5_NUMCHEQ
				TRB->VALORSE5	:= Transform((cAliasTrb)->E5_VALOR,"@E 999,999,999,999.99")
				TRB->DEBCRED	:= IIF((cAliasTrb)->E5_RECPAG == "R", "C","D")
				TRB->RECSE5		:= If(lQuery,(cAliasTrb)->RECNOSE5,(cAliasTrb)->(Recno()))
				TRB->RECONSE5	:= (cAliasTrb)->E5_RECONC
				TRB->AGESE5		:= (cAliasTrb)->E5_AGENCIA
				TRB->CTASE5		:= (cAliasTrb)->E5_CONTA
				TRB->OK			:= IIF (!Empty(TRB->RECONSE5),4,2)  // 2 = N„o Reconciliado
				// 4 = Reconciado anteriormente (SE5)
				TRB->OCORBCO    := "ZZZ"


				cDataMov  := TRB->DATAMOV
				cNumMov   := TRB->NUMSE5
				cValorMov := TRB->VALORSE5
				nRecSe5   := TRB->RECSE5
				cSeqSe5   := TRB->SEQMOV
				cDebCred  := TRB->DEBCRED
				cCtaMov	 := TRB->CTASE5
				cAgeMov	 := TRB->AGESE5
				lReconc   := IIF(!EMPTY(TRB->RECONSE5),.T.,.F.)
				nRecTrb   := TRB->(Recno()) 
				DbSelectArea("TRB")
				DbSetOrder(2)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tento pre-reconciliacao dentro da 					  					  ³
				//³ Data + Agencia + Conta + Numero + Valor + Tipo					     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nRecno := Recno()
				If DbSeek(cAgeMov + cCtaMov + cNumMov + cDataMov +  cValorMov + cDebCred)
					nRecno := Recno()

					DbGoTo(nRecTrb)
					dbDelete()
					dbGoto(nRecno)
					TRB->VALORSE5 	:= cValorMov
					TRB->NUMSE5	  	:= cNumMov
					TRB->RECSE5		:= nRecSE5
					TRB->CTASE5		:= cCtaMov
					TRB->AGESE5		:= cAgeMov
					TRB->SEQRECON	:= cSeqSE5
					TRB->OK			:= IIf (lReconc,4,1)  	// 1 => Reconc. totalmente
					// 4 => Reconc. Anteriomente no SE5
				Else
					dbGoto(nRecno)
				Endif
				DbSetOrder(1)

				If (mv_par04 # 0 .Or. mv_par05 # 0) .And. !Str(TRB->OK,1) $ "1#3#4"
					DbSelectArea("TRB")
					DbSetOrder(4)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Tento pre-reconcilizacao por numero + valor + tipo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If DbSeek( cAgeMov + cCtaMov +cNumMov + cValorMov + cDebCred) .And. !Str(TRB->OK,1) $ "1#3#4"
						nRecno := Recno()

						DbGoTo(nRecTrb)
						dbDelete()
						dbGoto(nRecno)
						TRB->VALORSE5 	:= cValorMov
						TRB->NUMSE5	  	:= cNumMov
						TRB->RECSE5		:= nRecSE5	
						TRB->SEQRECON	:= cSeqSE5 	
						TRB->CTASE5		:= cCtaMov
						TRB->AGESE5		:= cAgeMov
						TRB->OK			:= IIf (lReconc,4,3)  	// 3 => Reconc. Chave parcial
						// 4 => Reconc. Anteriomente no SE5
					Else
						dbGoto(nRecno)
					Endif
					DbSetOrder(1)
				Endif				

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tento pre-reconcilizacao dentro da data + valor + tipo ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("TRB")
				DbSetOrder(3)
				If !Str(TRB->OK,1) $ "1#3#4"
					If DbSeek(cAgeMov + cCtaMov + cDataMov +  cValorMov + cDebCred) .And. !Str(TRB->OK,1) $ "1#3#4"
						nRecno := Recno()

						DbGoTo(nRecTrb)
						dbDelete()
						dbGoto(nRecno)
						TRB->VALORSE5 	:= cValorMov
						TRB->NUMSE5	  	:= cNumMov
						TRB->RECSE5		:= nRecSE5
						TRB->SEQRECON	:= cSeqSE5
						TRB->CTASE5		:= cCtaMov
						TRB->AGESE5		:= cAgeMov
						TRB->OK			:= IIf (lReconc,4,3)  	// 3 => Reconc. Chave parcial
						// 4 => Reconc. Anteriomente no SE5
					Else
						dbGoto(nRecno)
					Endif
				Endif
				DbSetOrder(1)

				dbSelectArea(cAliasTrb)
				dbSkip()
			Enddo	
			If lQuery
				(cAliasTrb)->(DbCloseArea())
			Endif

			dbSelectArea("TRB")
			dbGoTop()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz o calculo automatico de dimensoes de objetos     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSize := MSADVSIZE()

			DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
			oDlg:lMaximized := .T.

			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,30,30,.T.,.T. )
			DEFINE SBUTTON FROM 10,250 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oPanel
			DEFINE SBUTTON FROM 10,280 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oPanel
			DEFINE SBUTTON oBtn FROM 10,310 TYPE 4 ACTION (FA470EFET(oTitulo)) ENABLE PIXEL OF oPanel
			oBtn:cToolTip := "Efetiva Lancto." //
			oBtn:cCaption := Substr("Efetiva Lancto.",1,7) //
			DEFINE SBUTTON oBtn FROM 10,340 TYPE 11 ACTION (FA470LEG()) ENABLE PIXEL OF oPanel
			oBtn:cToolTip := "Legenda"  //
			oBtn:cCaption := "Legenda"  //
			DEFINE SBUTTON oBtn FROM 10,370 TYPE 11 ACTION (Ret_SE5_Conc(@oTitulo)) ENABLE PIXEL OF oPanel
			oBtn:cToolTip := "Efetivação em Lote"  //
			oBtn:cCaption := "Efet. Lote"  //

			oPanel:Align := CONTROL_ALIGN_BOTTOM

			@ 01.0,.5 	LISTBOX oTitulo VAR cVarQ FIELDS ;
			HEADER "", 	"Seq.",;  //
			"Data",;  //
			"Agenc.Bco",;	//
			"Conta Bco",; 	//
			"Docto.Bco.",;  //
			"Valor Extrato",;  //
			"Tipo",;  //
			"Descrição",;  //
			"D/C",;  //
			"Agenc.SE5",;  //
			"Conta SE5",;	//
			"Docto.SE5",;  //
			"Valor SE5",;   //
			"Historico Extrato" ;	//
			COLSIZES 12,GetTextWidth(0,"BBB"),;
			GetTextWidth(0,"BBBB"),;
			GetTextWidth(0,"BBB"),;
			GetTextWidth(0,"BBBB"),;
			GetTextWidth(0,"BBBBB"),;
			GetTextWidth(0,"BBBBBB"),;
			GetTextWidth(0,"BB"),;
			GetTextWidth(0,"BBBBBBBBBBB"),;
			GetTextWidth(0,"B"),;
			GetTextWidth(0,"BBBB"),;
			GetTextWidth(0,"BBBB"),;
			GetTextWidth(0,"BBBBB"),;
			GetTextWidth(0,"BBBBBB"),;
			GetTextWidth(0,"BBBBBBBBBBBBBBBBBB");
			SIZE 345,400 ON DBLCLICK	(FA470marca(oTitulo),oTitulo:Refresh()) NOSCROLL 

			oTitulo:bLine := { || {aCores[TRB->OK],;
			TRB->SEQMOV 	,;
			TRB->DATAMOV	,;
			TRB->AGEMOV		,;
			TRB->CTAMOV		,;
			TRB->NUMMOV		,;
			PADR(TRB->VALORMOV,18)	,;
			TRB->TIPOMOV	,;
			TRB->DESCMOV	,;
			PADC(TRB->DEBCRED,3),;
			TRB->AGESE5		,;
			TRB->CTASE5		,;
			TRB->NUMSE5		,;
			PADR(TRB->VALORSE5,18),;
			TRB->DESCRMOV }}
			oTitulo:Align := CONTROL_ALIGN_ALLCLIENT

			ACTIVATE MSDIALOG oDlg

			If nOpca == 1
				dbSelectArea("TRB")
				dbGoTop()
				While !(TRB->(Eof()))
					nRecSE5 := TRB->RECSE5
					If nRecSe5 > 0
						dbSelectArea("NEWSE5")
						dbGoto(nRecSE5)
						RecLock("NEWSE5")
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Caso j  tenha sido reconciliado no SE5, e tenha sido optado  ³
						//³ por se desreconciliar, grava branco no SE5->E5_RECONC        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If TRB->OK == 2 .and. !Empty(NEWSE5->E5_RECONC)
							Replace NEWSE5->E5_RECONC  With " "
						Endif

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava as reconciliacoes totais ou por chave parcial no SE5.    ³
						//³ e caso por chave parcial gravo a possivel nova data E5_DTDISPO ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If STR(TRB->OK,1) $ "1#3"
							cReconAnt := NEWSE5->E5_RECONC 	
							Replace NEWSE5->E5_RECONC  With "x"

							//Verifico atualizacao do saldo conciliado
							DO CASE
								CASE Empty(cReconAnt) .and. !Empty(NEWSE5->E5_RECONC)
								nReconc := 1 	//Se foi reconciliado agora 			
								CASE !Empty(cReconAnt) .and. Empty(NEWSE5->E5_RECONC)
								nReconc := 2 	//Se foi desconciliado agora
								CASE !Empty(cReconAnt) .and. !Empty(NEWSE5->E5_RECONC)
								nReconc := 3	//Nao foi alterada a situacao anterior, mas ja estava conciliado
								CASE Empty(cReconAnt) .and. Empty(NEWSE5->E5_RECONC)		
								nReconc := 3	//Nao foi alterada a situacao anterior, mas nao estava conciliado
							END CASE				
							//Atualiza saldo conciliado na data antiga
							lAtSalRec1 := IIF(nReconc == 2 .or. nReconc == 3, .T., .F.)
							//Atualiza saldo conciliado na data nova
							lAtSalRec2 := IIF(nReconc != 4, .T., .F.)

							//Ponto de entrada para que não se atulize a data de disponibilidade
							//do movimento bancario no sistema.
							If lF470AtuDt
								lAtuDtDisp := ExecBlock("F470ATUDT",.F.,.F.)
							Endif

							If (Ctod(TRB->DATAMOV) # NEWSE5->E5_DTDISPO) .and. lAtuDtDisp
								dOldDispo := NEWSE5->E5_DTDISPO
								Replace NEWSE5->E5_DTDISPO With Ctod(TRB->DATAMOV)
								If NEWSE5->E5_RECPAG == "P"
									AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,dOldDispo,NEWSE5->E5_VALOR,"+",lAtSalRec1)
									AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DTDISPO,NEWSE5->E5_VALOR,"-",lAtSalRec2)
								Else
									AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,dOldDispo,NEWSE5->E5_VALOR,"-",lAtSalRec1)
									AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DTDISPO,NEWSE5->E5_VALOR,"+",lAtSalRec2)
								Endif
							Else
								//Atualiza apenas o saldo reconciliado
								If nReconc == 2	//Desconciliou
									AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DTDISPO,NEWSE5->E5_VALOR,IIF(NEWSE5->E5_RECPAG == "P","+","-"),.T.,.F.)			
								Endif
								If nReconc == 1	//Conciliou
									AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DTDISPO,NEWSE5->E5_VALOR,IIF(NEWSE5->E5_RECPAG == "P","-","+"),.T.,.F.)			
								Endif
							Endif
						Endif
						MsUnlock()
					EndIf	
					dbSelectArea("TRB")
					dbSkip()
					Loop
				Enddo
			EndIf
		Endif
	Endif

	dbSelectArea("TRB")
	Set Filter To
	dbCloseArea()
	Ferase(cArqRec1+ GetDBExtension())
	Ferase(cArqRec1+OrdBagExt())
	Ferase(cArqRec2+OrdBagExt())
	Ferase(cArqRec3+OrdBagExt())
	Ferase(cArqRec4+OrdBagExt())
	IF SELECT("NEWSE5") != 0
		dbSelectArea( "NEWSE5" )
		dbCloseArea()
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
	ENDIF	
	dbSelectArea("SE5")
	dbSetOrder(1)
Return .F.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fA470Par  ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Aciona parametros do Programa                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fA470Par()
	Pergunte( "AFI470" )
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470ChecF³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna Expresao para Indice Condicional						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fa470ChecF() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470ChecF()
	Local cFiltro := ""
	cFiltro := 'NEWSE5->E5_FILIAL=="'+xFilial("SE5")+'" .And. '
	cFiltro += '((DTOS(E5_DTDISPO)>="' + DTOS(dDtIni)       + '".And. '
	cFiltro += 'DTOS(E5_DTDISPO)<="' + DTOS(dDtFin)       + '") .OR. '
	cFiltro += '(DTOS(E5_DTDISPO)<="' + DTOS(dDtIniCh)       + '".And. '
	cFiltro += 'DTOS(E5_DTDISPO)<="' + DTOS(dDtFinCh)       + '" .And. '
	cFiltro += 'E5_TIPODOC $ IIF(Type("MVCHEQUES")=="C",MVCHEQUES,MVCHEQUE))) .And. '

	cFiltro += 'E5_BANCO =="' + mv_par03+'".And. '
	cFiltro += '!E5_TIPODOC $ "BA/DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL" .And.'
	cFiltro += 'E5_SITUACA <> "C" .And. '                                 
	cFiltro += 'E5_VALOR <> 0 .And. ' 
	cFiltro += '(!E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .OR. (E5_MOEDA $ "C1/C2/C3/C4/C5/CH"  .AND. E5_NUMCHEQ <> " ")) .And. '
	cFiltro += '(E5_NUMCHEQ <> "*" .OR. (E5_NUMCHEQ = "*" .AND. E5_RECPAG <> "P"))
Return cFiltro

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³F470CriArq³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 04/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cria Estrutura do arquivo de trabalho   						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³F470CriArq() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function F470CriArq()
	
	Local aDbStru	:= aTamSX3 := {}
	Local oTMPTable
	
	//Arquivo de reconciliacao
	aadd(aDbStru,{"SEQMOV    ","C",04,0})
	aadd(aDbStru,{"SEQRECON  ","C",04,0})
	aadd(aDbStru,{"DATAMOV   ","C",10,0})
	aadd(aDbStru,{"AGEMOV    ","C",TamSX3("A6_AGENCIA")[1],0})
	aadd(aDbStru,{"CTAMOV    ","C",TamSX3("A6_NUMCON")[1],0})
	aadd(aDbStru,{"NUMMOV    ","C",15,0})
	aadd(aDbStru,{"VALORMOV  ","C",18,0})
	aadd(aDbStru,{"TIPOMOV   ","C",03,0})
	aadd(aDbStru,{"DESCMOV   ","C",LEN(SEJ->EJ_DESCR),0})
	aadd(aDbStru,{"DEBCRED   ","C",01,0})
	aadd(aDbStru,{"DESCRMOV  ","C",40,0})
	aadd(aDbStru,{"AGESE5    ","C",TamSX3("A6_AGENCIA")[1],0})
	aadd(aDbStru,{"CTASE5    ","C",TamSX3("A6_NUMCON")[1],0})
	aadd(aDbStru,{"NUMSE5    ","C",15,0})
	aadd(aDbStru,{"VALORSE5  ","C",18,0})
	aadd(aDbStru,{"RECSE5    ","N",09,0})
	aadd(aDbStru,{"OK        ","N",01,0})
	aadd(aDbStru,{"RECONSE5  ","C",01,0})
	aadd(aDbStru,{"OCORBCO   ","C",10,0})
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	cArqRec1 := CriaTrab(aDbStru, .T. )
	cArqRec2 := Left(CriaTrab(Nil, .F. ),7)+"A"
	cArqRec3 := Left(CriaTrab(Nil, .F. ),7)+"B"
	cArqRec4 := Left(CriaTrab(Nil, .F. ),7)+"C"
	dbUseArea(.T.,,cArqRec1,"TRB",.F.,.F.)
	IndRegua("TRB",cArqRec1,"SEQMOV+DATAMOV",,,"Selecionando Registros...")  //
	IndRegua("TRB",cArqRec2,"AGEMOV+CTAMOV+NUMMOV+DATAMOV+VALORMOV+DEBCRED",,,"Selecionando Registros...")  //
	IndRegua("TRB",cArqRec3,"AGEMOV+CTAMOV+DATAMOV+VALORMOV+DEBCRED",,,"Selecionando Registros...")  //
	*/
	oTMPTable:= FWTemporaryTable():New("TRB")
	oTMPTable:SetFields( aDbStru )
	oTMPTable:AddIndex("1", {"SEQMOV+DATAMOV"} )
	oTMPTable:AddIndex("2", {"AGEMOV+CTAMOV+NUMMOV+DATAMOV+VALORMOV+DEBCRED"} )
	oTMPTable:AddIndex("3", {"AGEMOV+CTAMOV+DATAMOV+VALORMOV+DEBCRED"} )
	oTMPTable:Create()	
	
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	If mv_par04 # 0 .Or. mv_par05 # 0
		IndRegua("TRB",cArqRec4,"AGEMOV+CTAMOV+NUMMOV+VALORMOV+DEBCRED",,,"Selecionando Registros...")  //
		DbClearIndex()
		DbSetIndex(cArqRec1 + OrdBagExt())
		DbSetIndex(cArqRec2 + OrdBagExt())
		DbSetIndex(cArqRec3 + OrdBagExt())
		DbSetIndex(cArqRec4 + OrdBagExt())
	Else
		DbClearIndex()
		DbSetIndex(cArqRec1 + OrdBagExt())
		DbSetIndex(cArqRec2 + OrdBagExt())
		DbSetIndex(cArqRec3 + OrdBagExt())
	Endif

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470Marca³ Autor ³ Mauricio Pequim Jr	  ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Troca o flag para marcado ou nao,aceitando valor.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa470Marca																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470Marca(oTitulo)
	Local oDlg1
	Local nOpca1 	:= 0
	Local lRet		:= .T.
	LOCAL nReconc	:= TRB->OK
	LOCAL nSequen 	:= 0
	LOCAL lIsBanco := .F.
	LOCAL cDataRec,cValRec
	LOCAL lEfetiva := .F.
	LOCAL cRecTRB	
	LOCAL lReconc := .F.
	LOCAL nTamCta := TAMSX3("A6_NUMCON")[1]
	LOCAL nTamAge := TAMSX3("A6_AGENCIA")[1]

	If nReconc == 2   // Se n„o reconciliado

		DEFINE MSDIALOG oDlg1 FROM  69,70 TO 160,331 TITLE "Reconciliacao bancaria Automatica" PIXEL   //

		@ 0, 2 TO 22, 165 OF oDlg1 PIXEL
		@ 7, 98 MSGET nSequen Picture "9999" VALID (nSequen <= TRB->(RecCount())) .and. (nSequen > 0) SIZE 20, 10 OF oDlg1 PIXEL
		@ 8, 08 SAY  "Sequˆncia a Reconciliar"  SIZE 90, 7 OF oDlg1 PIXEL  //
		DEFINE SBUTTON FROM 29, 71 TYPE 1 ENABLE ACTION (nOpca1:=1,If((nSequen <= TRB->(RecCount())) .and. (nSequen > 0),oDLg1:End(),nOpca1:=0)) OF oDlg1
		DEFINE SBUTTON FROM 29, 99 TYPE 2 ENABLE ACTION (oDlg1:End()) OF oDlg1

		ACTIVATE MSDIALOG oDlg1 CENTERED

		IF	nOpca1 == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a linha clicada ‚ Mov. Banco ou Sistema			  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nRecOrig := Val(TRB->SEQMOV)
			cDCRec	:= TRB->DEBCRED
			cValRec	:= IIF(!Empty(TRB->VALORMOV), TRB->VALORMOV , TRB->VALORSE5)
			cDataRec := TRB->DATAMOV
			cNumRec	:= IIF(!Empty(TRB->VALORMOV), TRB->NUMMOV , TRB->NUMSE5)
			cAgeRet	:= IIF(!Empty(TRB->VALORMOV), TRB->AGEMOV , TRB->AGESE5)
			cCtaRet	:= IIF(!Empty(TRB->VALORMOV), TRB->CTAMOV , TRB->CTASE5)
			nRecSE5	:= TRB->RECSE5
			cSeqSE5	:= TRB->SEQRECON
			lReconc	:= IIF (!Empty(TRB->RECONSE5),.T.,.F.)
			If !Empty(TRB->VALORMOV)
				lIsBanco := .T.
			Endif		
			dbSelectArea("TRB")
			dbGoto(nSequen)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica tentativa de reconciliar Banco x Banco ou SE5 x SE5 ³
			//³ ou Lancamento de Credito x Lancamento D‚bito ou vice-versa   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( 	(!Empty(TRB->VALORMOV) .and. Empty(TRB->VALORSE5) .and. lIsBanco) .or. ;
			(Empty(TRB->VALORMOV) .and. !Empty(TRB->VALORSE5) .and. !lIsBanco) .or. ;
			TRB->DEBCRED != cDCRec )
				Help(" ",1,"NORECONC")
				dbGoto(nRecOrig)
				oTitulo:Refresh()
				Return .F.
			Endif
			If (IIf(lIsBanco , TRB->VALORSE5 != cValRec , TRB->VALORMOV != cValRec))
				Help(" ",1,"NORECONC")
				oTitulo:Refresh()
				Return .F.
			Endif

			If !Empty(TRB->VALORMOV) .and. Empty(TRB->VALORSE5) .and. !lIsBanco
				DbSelectArea("TRB")
				TRB->VALORSE5 	:= cValRec
				TRB->NUMSE5		:= cNumRec
				TRB->RECSE5		:= nRecSE5
				TRB->SEQRECON	:= cSeqSE5
				TRB->CTASE5		:= cCtaRec
				TRB->AGESE5		:= cAgeRec
				TRB->OK			:= IIF (lReconc,4,1)
				dbGoTo(nRecOrig)
				dbDelete()
				oTitulo:Refresh()
			Endif
			If Empty(TRB->VALORMOV) .and. !Empty(TRB->VALORSE5) .and. lIsBanco
				cValRec := 	TRB->VALORSE5
				nRecSE5 :=  TRB->RECSE5
				cDBSE5  :=	TRB->DEBCRED
				cSeqSE5 :=	TRB->SEQMOV
				cDocSE5 :=	TRB->NUMSE5
				cAgeSE5 :=  TRB->AGESE5
				cCtaSE5 :=  TRB->CTASE5
				DbSelectArea("TRB")
				dbDelete()
				dbGoTo(nRecOrig)
				TRB->VALORSE5 	:= cValRec
				TRB->RECSE5		:= nRecSE5
				TRB->OK			:= IIF (lReconc,4,1)
				TRB->SEQRECON	:= cSeqSE5
				TRB->NUMSE5		:= cDocSE5
				TRB->CTASE5		:= cCtaSE5
				TRB->AGESE5		:= cAgeSE5
				oTitulo:Refresh()
			Endif
			dbGoTo(nRecOrig)
		Endif
	Else
		lEfetiva := .F.
		DEFINE MSDIALOG oDlg1 FROM  69,70 TO 160,331 TITLE  "Reconcilia‡„o Banc ria Autom tica" PIXEL  //
		@  0, 2 TO 22, 128 OF oDlg1	PIXEL
		@  7.5,  9 SAY  "Esta movimenta‡„o j  se encontra reconciliada"  SIZE 115, 7 OF oDlg1 PIXEL  //
		@ 14  ,  9 SAY  "             Deseja cancelar ?               "  SIZE 100, 7 OF oDlg1 PIXEL  //
		DEFINE SBUTTON FROM 29, 71 TYPE 1 ENABLE ACTION (nOpca1:=1,oDlg1:End()) OF oDlg1
		DEFINE SBUTTON FROM 29, 99 TYPE 2 ENABLE ACTION (oDlg1:End()) OF oDlg1

		ACTIVATE MSDIALOG oDlg1 CENTERED

		IF	nOpca1 == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cancela reconcilia‡Æo                               			  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nRecOrig := VAL(TRB->SEQMOV)
			nSeqSE5	:= VAL(TRB->SEQRECON)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso a reconcilia‡„o tenha sido feita via Efetivacao de mo-  ³
			//³ vimentacao, deve ser criado no TRB o registro com os dados   ³
			//³ da movimentacao no SE5.                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("TRB")
			If Empty(TRB->SEQRECON)
				cValRec := 	TRB->VALORSE5
				nRecSE5 :=  TRB->RECSE5
				cDBSE5  :=	TRB->DEBCRED
				cDocSE5 :=	TRB->NUMSE5
				cDataRec := TRB->DATAMOV
				cAgeSE5	:= TRB->AGESE5
				cCtaSE5	:= TRB->CTASE5
				lEfetiva:=  .T.
			Endif
			TRB->VALORSE5 	:= Space(19)
			TRB->NUMSE5		:= Space(6)
			TRB->RECSE5		:= 0
			TRB->AGESE5		:= Space(nTamAge)
			TRB->CTASE5		:= Space(nTamCta)	
			TRB->SEQRECON	:= Space(4)
			TRB->OK			:= 2
			SET DELETED OFF
			If !lEfetiva
				dbGoTo(nSeqSE5)
				dbRecall()
				TRB->OK := 2
			Else
				DbSelectArea("TRB")
				DbAppend()
				cRecTRB 			:= STR(TRB->(Recno()))
				TRB->SEQMOV 	:= SUBSTR(cRecTRB,-4)
				TRB->DATAMOV	:= cDataRec
				TRB->VALORSE5 	:= cValRec
				TRB->RECSE5		:= nRecSE5
				TRB->NUMSE5		:= cDocSE5						
				TRB->DEBCRED 	:= cDBSE5
				TRB->AGESE5		:= cAgeSE5						
				TRB->CTASE5		:= cCtaSE5						
				TRB->OK			:= 2
			Endif
			SET DELETED ON
			dbGoto(nRecOrig)
		Endif
	Endif
	oTitulo:Refresh()
Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470Leg	³ Autor ³ Mauricio Pequim Jr	  ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra Legenda da Reconcilia‡Æo                   			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa470Leg 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470Leg()
	Local oDlg2
	Local nOpca2 	:= 0
	Local lRet		:= .T.
	DEFINE MSDIALOG oDlg2 FROM  69,70 TO 165,331 TITLE  "Legenda - Reconcilia‡„o Autom tica" PIXEL  //
	@ 05 , 5 BITMAP NAME "BR_VERDE" 		SIZE 8,8 of Odlg2 PIXEL
	@ 15 , 5 BITMAP NAME "BR_AMARELO" 	SIZE 8,8 of Odlg2 PIXEL
	@ 25 , 5 BITMAP NAME "BR_CINZA" 		SIZE 8,8 of Odlg2 PIXEL
	@ 35 , 5 BITMAP NAME "DISABLE" 		SIZE 8,8 of Odlg2 PIXEL
	@ 05 , 19 SAY  "  Reconciliado"  	SIZE 115, 7 OF oDlg2 PIXEL  //
	@ 15 , 19 SAY  "  Reconciliado Parcial"  	SIZE 100, 7 OF oDlg2 PIXEL  //
	@ 25 , 19 SAY  "  Reconciliado Anteriormente"  	SIZE 100, 7 OF oDlg2 PIXEL  //
	@ 35 , 19 SAY  "  N„o Reconciliado"  	SIZE 100, 7 OF oDlg2 PIXEL  //
	DEFINE SBUTTON FROM 20, 100 TYPE 1 ENABLE ACTION (oDlg2:End()) OF oDlg2
	ACTIVATE MSDIALOG oDlg2 CENTERED
Return lRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470EFET	³ Autor ³ Mauricio Pequim Jr	  ³ Data ³ 07/10/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetiva lancamento do extrato no SE5              			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa470Efet																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470Efet(oTitulo,cOrigem)
	Local cRecPagE5
	Local oDlg3, oDlg4
	Local nOpcaE := 0
	Local nOpcaN := 0
	Local lAchou := .F.
	Local cValorSE5
	Local cNaturEfet := CRIAVAR("ED_CODIGO")
	Local cCCD		:= CRIAVAR("E5_CCD")	// Centro Custo Debito
	Local cCCC		:= CRIAVAR("E5_CCC") // Centro Custo Credito
	Local cItemD	:= CRIAVAR("E5_ITEMD")  //Item contabil Debito
	Local cItemC	:= CRIAVAR("E5_ITEMC")  //Item contabil Credito
	Local cClVlDb	:= CRIAVAR("E5_CLVLDB")  //Classe de Valor Debito
	Local cClVlCr	:= CRIAVAR("E5_CLVLCR")  //Classe de Valor Credito
	Local cCDeb		:= CRIAVAR("E5_DEBITO")	// Conta Contábil Debito
	Local cCCrd		:= CRIAVAR("E5_CREDITO") // Conta Contábil Credito
	Local cHistor  := TRB->DESCRMOV // Historico do movimento
	Local lIsCTB	:= IIF(CtbInUse(),.T.,.F.)
	Local lConsulta := IIF(CtbInUse(),"CTT","SI3")
	Local lConsult2 := IIF(CtbInUse(),"CT1","SI1")
	Local oBtn := Nil

	Private bPMSDlgMB	:= {||PmsDlgMB(3, NEWSE5->E5_PROJPMS, NEWSE5->E5_HISTOR, NEWSE5->E5_RECPAG)}
	Private aRatAJE   := {}

	If IntePMS()
		_SetOwnerPrvt("E5_VALOR", Val(StrTran(StrTran(TRB->VALORMOV, ",", ""), ".", "")) / 100)
	EndIf

	If !(STR(TRB->OK,1) $ "1#3#4") .and. !Empty(TRB->VALORMOV)
		dbSelectArea("NEWSE5")
		IF	dbSeek (xFilial("SE5")+DTOS(CTOD(TRB->DATAMOV,"ddmmyy")))
			While !EOF() .and. DTOS(NEWSE5->E5_DTDISPO) == DTOS(CTOD(TRB->DATAMOV,"ddmmyy"))
				cRecPagE5 := IIF(NEWSE5->E5_RECPAG == "R", "C","D")
				IF !Empty(TRB->NUMMOV) .and. NEWSE5->E5_NUMCHEQ == TRB->NUMMOV .and. cRecPagE5 == TRB->DEBCRED
					Help(" ",1,"A470EXIST")
					lAchou := .T.
					Exit
				Endif
				cValorSE5 := Transform(NEWSE5->E5_VALOR,"@E 999,999,999,999.99")
				If cValorSE5 == TRB->VALORMOV .and. ;
				Empty(NEWSE5->E5_NUMCHEQ) .and. cRecPagE5 == TRB->DEBCRED

					DEFINE MSDIALOG oDlg3 FROM  69,90 TO 220,400 TITLE  "Efetiva‡„o de Lan‡amento no SE5"			 PIXEL  //
					@ 00 , 03 TO 55, 152 OF oDlg4 PIXEL
					@ 10 , 10 SAY  "Existe lan‡amento semelhante em Data, Valor e Carteira."  SIZE 140, 7 OF oDlg3 PIXEL  //
					@ 20 , 10 SAY  "no seu arquivo de movimentos banc rios.	Em caso de     "  SIZE 140, 7 OF oDlg3 PIXEL  //
					@ 30 , 10 SAY  "d£vida, n„o efetive o lan‡amento, pois poder  gerar    "  SIZE 140, 7 OF oDlg3 PIXEL  //
					@ 40 , 10 SAY  "duplicidade. Deseja efetivar este lan‡amento ?			"  SIZE 140, 7 OF oDlg3 PIXEL  //
					DEFINE SBUTTON FROM 60, 50 TYPE 1 ENABLE ACTION (nOpcaE:=1,oDlg3:End()) OF oDlg3
					DEFINE SBUTTON FROM 60, 80 TYPE 2 ENABLE ACTION (nOpcaE:=2,oDlg3:End()) OF oDlg3

					ACTIVATE MSDIALOG oDlg3 CENTERED

					If nOpcaE == 1
						lAchou := .F.
					Else
						lAchou := .T.
					Endif
					Exit
				Endif
				NEWSE5->(dbSkip())
			Enddo
		Endif
		If !lAchou
			nOpcaN := 0
			If mv_par11 == 1  //Mostra tela da efetivação do movimento bancário
				If lIsCtb
					DEFINE MSDIALOG oDlg4 FROM  69,70 TO 372,400 TITLE "Reconcilia‡„o Banc ria Autom tica" PIXEL	//
					@ 0, 2 TO 150, 133 OF oDlg4 PIXEL
				Else
					DEFINE MSDIALOG oDlg4 FROM  69,70 TO 267,400 TITLE "Reconcilia‡„o Banc ria Autom tica" PIXEL	//
					@ 0, 2 TO 97, 133 OF oDlg4 PIXEL
				Endif

				If lIsCtb
					@ 07, 80 MSGET cNaturEfet  F3 "SED" VALID (!Empty(cNaturEfet) .and. ExistCpo("SED",cNaturEfet) .AND. FA470NATUR(cNaturEfet, @cCDeb,@cCCrd,@cCCD,@cCCC, lIsCtb, @cItemD,@cItemC,@cClVlDb,@cClVlCr)) SIZE 50, 10 OF oDlg4 PIXEL 
				Else
					@ 07, 80 MSGET cNaturEfet  F3 "SED" VALID (!Empty(cNaturEfet) .and. ExistCpo("SED",cNaturEfet) .AND. FA470NATUR(cNaturEfet, @cCDeb,@cCCrd,@cCCD,@cCCC, lIsCtb, @cItemD,@cItemC,@cClVlDb,@cClVlCr)) SIZE 50, 10 OF oDlg4 PIXEL 
				EndIf
				@ 08, 08 SAY  "Natureza do Lan‡amento"  SIZE 80, 7 OF oDlg4 PIXEL  //

				@ 28, 08 MSGET cHistor SIZE 122, 10 OF oDlg4 PIXEL
				@ 19, 08 SAY "Historico" SIZE 80, 7 OF oDlg4 PIXEL  //

				@ 41, 80 MSGET cCDeb  F3 lConsult2 VALID (Empty(cCDeb) .or.CTB105CTA(cCDeb)) SIZE 50, 10 OF oDlg4 PIXEL
				@ 42, 08 SAY  "Conta Debito"  SIZE 80, 7 OF oDlg4 PIXEL  //
				@ 54, 80 MSGET cCCrd  F3 lConsult2 VALID (Empty(cCCrd) .or.CTB105CTA(cCCrd)) SIZE 50, 10 OF oDlg4 PIXEL
				@ 55, 08 SAY  "Conta Credito"  SIZE 80, 7 OF oDlg4 PIXEL  //

				@ 67, 80 MSGET cCCD  F3 lConsulta VALID (Empty(cCCD) .or. CTB105CC(cCCD)) SIZE 50, 10 OF oDlg4 PIXEL
				@ 68, 08 SAY  "Centro Custo Debito"  SIZE 80, 7 OF oDlg4 PIXEL  //
				@ 80, 80 MSGET cCCC  F3 lConsulta VALID (Empty(cCCC) .or. CTB105CC(cCCC)) SIZE 50, 10 OF oDlg4 PIXEL
				@ 81, 08 SAY  "Centro Custo Credito"  SIZE 80, 7 OF oDlg4 PIXEL  //

				If lIsCtb
					@ 93, 80 MSGET cItemD  F3 "CTD" VALID (Empty(cItemD) .or. CTB105ITEM(cItemD)) SIZE 50, 10 OF oDlg4 PIXEL
					@ 94, 08 SAY  "Item Contabil Debito"  SIZE 80, 7 OF oDlg4 PIXEL  //
					@107, 80 MSGET cItemC  F3 "CTD" VALID (Empty(cItemC) .or. CTB105ITEM(cItemC)) SIZE 50, 10 OF oDlg4 PIXEL
					@108, 08 SAY  "Item Contabil Credito"  SIZE 80, 7 OF oDlg4 PIXEL  //

					@120, 80 MSGET cClVlDb F3 "CTH" VALID (Empty(cClVlDb) .or. CTB105CLVL(cClVlDb)) SIZE 50, 10 OF oDlg4 PIXEL
					@121, 08 SAY  "Classe Valor Debito"  SIZE 80, 7 OF oDlg4 PIXEL  //
					@133, 80 MSGET cClVlCr F3 "CTH" VALID (Empty(cClVlCr) .or. CTB105CLVL(cClVlCr)) SIZE 50, 10 OF oDlg4 PIXEL
					@134, 08 SAY  "Classe Valor Credito"  SIZE 80, 7 OF oDlg4 PIXEL  //
				Endif
				DEFINE SBUTTON FROM 07, 135 TYPE 1 ENABLE ACTION (nOpcaN:=1,If((!Empty(cNaturEfet) .and. ExistCpo("SED",cNaturEfet)),oDlg4:End(),nOpcaN:=0)) OF oDlg4
				DEFINE SBUTTON FROM 20, 135 TYPE 2 ENABLE ACTION (nOpcaN:=2,oDlg4:End()) OF oDlg4

				If IntePMS()
					@ 033, 135 Button oBtn Prompt "PMS" Size 30, 11 FONT oDlg4:oFont Action Eval(bPmsDlgMB) Of oDlg4 Pixel
					oBtn:SetFocus()
				EndIf

				ACTIVATE MSDIALOG oDlg4 CENTERED
			Else
				//Nao mostra a tela de dados para o movimento bancario
				nOpcaN := 1		
			Endif

			If nOpcaN == 1 .And. FA470OK()
				FA470GrvEf(cNaturEfet,cCCC,cCCD,cItemD,cItemC,cClVlDb,cClVlCr,cCCrd,cCDeb,cHistor)
				If IntePMS()
					PmsWriteMB(1, "SE5")							
				EndIf
				oTitulo:Refresh()
			Endif
		Endif
	Else
		Help(" ",1,"A470JA_REC")
	Endif		
Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470GrvEf³ Autor ³ Mauricio Pequim Jr	  ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava Efetivacao                                  			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa470GrvEf()															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470GrvEf(cNaturEfet,cCCC,cCCD,cItemD,cItemC,cClVlDb,cClVlCr,cCCrd,cCDeb,cHistor)
	Local cValorMov
	Local aAreaSE5:={}
	local lContab	:= .F.
	Local nRecno	:=0
	Local aArea		:={}
	#IFDEF TOP
	If TcSrvType() == "AS/400"
		lTQuery := .F.
	Else
		lTQuery := .T.
	Endif
	#ENDIF	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Transforma TRB->VALORMOV (em formato europeu) para formato Americano  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cValorMov := ConValor(TRB->VALORMOV,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava Movimentacao da efetivacao no SE5.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("NEWSE5",.T.)
	NEWSE5->E5_FILIAL 	:= xFilial("SE5")
	NEWSE5->E5_BANCO		:= mv_par03
	NEWSE5->E5_AGENCIA	:= TRB->AGEMOV
	NEWSE5->E5_CONTA		:= TRB->CTAMOV
	NEWSE5->E5_DATA		:= CTOD(TRB->DATAMOV,"ddmmyy")
	NEWSE5->E5_DTDISPO	:= CTOD(TRB->DATAMOV,"ddmmyy")
	NEWSE5->E5_VENCTO		:= CTOD(TRB->DATAMOV,"ddmmyy")
	NEWSE5->E5_DTDIGIT	:= CTOD(TRB->DATAMOV,"ddmmyy")
	NEWSE5->E5_HISTOR 	:= IIF(Empty(cHistor),TRB->DESCRMOV,cHistor)
	NEWSE5->E5_VALOR		:= Val(cValorMov)
	NEWSE5->E5_NATUREZ	:= cNaturEfet
	NEWSE5->E5_MOEDA  	:= IIF(TRB->TIPOMOV=="CHQ","C1","M1")
	NEWSE5->E5_RECPAG 	:= IIF(TRB->DEBCRED=="D","P","R")
	NEWSE5->E5_CCC			:= cCCC
	NEWSE5->E5_CCD			:= cCCD
	NEWSE5->E5_CREDITO	:= cCCrd
	NEWSE5->E5_DEBITO		:= cCDeb
	If CtbInUse()
		NEWSE5->E5_ITEMD	:= cItemD
		NEWSE5->E5_ITEMC	:= cItemC
		NEWSE5->E5_CLVLDB	:= cClVlDb
		NEWSE5->E5_CLVLCR	:= cClVlCr
	Endif
	nRecno:=NEWSE5->(Recno()) 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o movimento ‚ referente a um cheque e grava nro do cheque.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF TRB->TIPOMOV $ "CHQ"  
		NEWSE5->E5_NUMCHEQ	:= TRB->NUMMOV
	Endif
	MsUnlock()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza saldo bancario quando da efetivação de movimento             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AtuSalBco(mv_par03,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DATA,NEWSE5->E5_VALOR,iif(NEWSE5->E5_RECPAG == "R","+","-"))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava dados da Reconciliacao no TRB											  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("TRB")
	Replace TRB->RECSE5		With NEWSE5->(RECNO())
	Replace TRB->OK 			With 1
	Replace TRB->VALORSE5	With Transform(NEWSE5->E5_VALOR,"@E 999,999,999,999.99")
	Replace TRB->NUMSE5		With NEWSE5->E5_NUMCHEQ
	Replace TRB->AGESE5		With NEWSE5->E5_AGENCIA
	Replace TRB->CTASE5		With NEWSE5->E5_CONTA

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se gera lancamento na contabilidade.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If NEWSE5->E5_RECPAG =="R"
		cPadrao:= "563"
		If VerPadrao(cPadrao)
			lContab:=.T.
		EndIf
	Else 
		cPadrao:= "562"
		If VerPadrao(cPadrao)
			lContab:=.T.
		EndIf
	EndIf

	If lContab .and. lGeraLanc
		aAreaSE5:=SE5->(GetArea())
		aArea:=GetArea()
		DbSelectArea("SE5")
		DbGoTo(nRecno)
		If nHdlPrv <= 0 
			nHdlPrv :=HeadProva(cLote,"FINA550",Subs(cUsuario,7,6),@cArquivo)
			LoteCont("FIN")
		Endif 
		If nHdlPrv > 0 
			nTotal	+=	DetProva(nHdlPrv,cPadrao,"FINA470",cLote)
		Endif
		SE5->(RestArea(aAreaSE5))
		RestArea(aArea)
		RecLock("NEWSE5",.F.)      
		NEWSE5->E5_LA		:= "S"
		MsUnlock()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada apos gravacao do TRB e do SE5      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ExistBlock("F470GRVEF")
		ExecBlock("F470GRVEF",.f.,.f.,{"NEWSE5"})
	Endif

Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470OK	³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 13/10/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Confirma ou nao a efetivacao.                    			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa470OK																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470OK()
Return (MsgYesNo( "Confirma Efetiva‡„o ?", "Aten‡„o"))  //###



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Chk470File³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 24/11/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Checa se arquivo de TB j  foi processado anteriormente		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Chk470File()  															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Fina470																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Chk470File()
	LOCAL cFile := "CB"+cNumEmp+".VRF"
	LOCAL lRet	:= .F.
	LOCAL aFiles:= {}
	LOCAL cString
	LOCAL nTam
	LOCAL nHdlFile

	If !FILE(cFile)
		nHdlFile := fCreate(cFile)
	ELSE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tenta abrir o arquivo em modo exclusivo e Leitura/Gravacao ³	
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While (nHdlFile := fOpen(cFile,FO_READWRITE+FO_EXCLUSIVE))==-1 .AND. ;
		MsgYesNo( "Empresa "+cNumEmp+"..", "Aten‡„o" )
		End
	Endif

	If nHdlFile > 0

		nTam := TamSx1("AFI470","01")[1] // Tamanho do parametro
		xBuffer := SPACE(nTam)
		// Le o arquivo e adiciona na matriz
		While fReadLn(nHdlFile,@xBuffer,nTam) 
			Aadd(aFiles, Trim(xBuffer))
		Enddo	

		If ASCAN(aFiles,Trim(MV_PAR01)) > 0
			lRet := MSGYESNO("Arquivo de Conciliação já processado anteriormente. Deseja proseguir ?","Atenção")		//###
		Else
			fSeek(nHdlFile,0,2) // Posiciona no final do arquivo
			cString := Alltrim(mv_par01)+Chr(13)+Chr(10)
			fWrite(nHdlFile,cString)	// Grava nome do arquivo a ser processado
			lRet := .T.
		endif	
		fClose (nHdlFile)
	Else
		Help(" ", 1, "CHK200ERRO") // Erro na leitura do arquivo de entrada
	EndIf	
Return lRet

Static Function FA470NATUR(cNatureza, cCDeb, cCCrd, cCCD, cCCC, lIsCtb,cItemD, cItemC, cClVlDb, cClVlCr)

	dbSelectArea("SED")
	SED->(dbSetOrder(1))
	If SED->(dbSeek(xFilial("SED")+cNatureza))
		cCDeb	:= SED->ED_CONTA
		cCCrd	:= SED->ED_CONTA
		cCCD	:= SED->ED_CCD
		cCCC    := SED->ED_CCD
		cItemD	:= SED->ED_ITEMD
		cItemC	:= SED->ED_ITEMD
		cClVlDb	:= SED->ED_CLVLDB
		cClVlCr	:= SED->ED_CLVLDB
	EndIf

	/*
	If ExistBlock("FA470NAT")
	aContabil := ExecBlock("FA470NAT",.F.,.F.,cNatureza)
	If Len(aContabil) == 8
	cCDeb		:= aContabil[1]
	cCCrd		:= aContabil[2]
	cCCD		:= aContabil[3]
	cCCC		:= aContabil[4]
	If lIsCtb
	cItemD	:= aContabil[5]
	cItemC	:= aContabil[6]
	cClVlDb	:= aContabil[7]
	cClVlCr	:= aContabil[8]
	EndIf
	EndIf		
	EndIf
	*/
Return(.T.)


Static Function F470AjustSX1()

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}



	AADD(aHelpPor,"Indica se os lançamentos devem ser ")
	AADD(aHelpPor,"aglutinados em uma única linha, caso as")
	AADD(aHelpPor,"contas, centro de  custo, item e classe ")
	AADD(aHelpPor,"de valor sejam iguais nos lançamentos efetuados.")


	AADD(aHelpSpa,"Indica si los asientos deben ser aglomerados ")
	AADD(aHelpSpa,"en una sola linea, en caso de que las cuentas, ")
	AADD(aHelpSpa,"centro de costo, item y clase de valor sean")
	AADD(aHelpSpa,"iguales en los asientos efectuados.") 


	AADD(aHelpEng,"Indicates if the entries must be grouped in")
	AADD(aHelpEng,"a single line in case the accounts, cost")
	AADD(aHelpEng,"centers, item and value class are equal")
	AADD(aHelpEng,"in the entries executed.")       


	PutSx1( "AFI470", "06","Aglut. Lancamentos ? ","¿Agrupa Asientos ? "," Group Entries ? ","mv_ch6","N",1,0,1,"C","","","","",;
	"mv_par06","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

	aHelpPor := {}
	aHelpEng := {}
	aHelpSpa := {}

	AADD(aHelpPor,"Indica se o lançamento contábil deve")
	AADD(aHelpPor,"ser exibido, quando a contabilização")
	AADD(aHelpPor,"for on-line")

	AADD(aHelpSpa,"Indica si se debe exhibir el asiento ")
	AADD(aHelpSpa,"contable, cuando la contabilizacion ")
	AADD(aHelpSpa,"sea on-line. ")

	AADD(aHelpEng,"Indicates if the accounting entry")
	AADD(aHelpEng,"must be displayed when the posting ")
	AADD(aHelpEng,"is on-line.")      

	PutSx1( "AFI470", "07","Mostra Lanc Contab. ? ","¿Muestra Asientos ? ","Display Accounting  Entry ? ","mv_ch7","N",1,0,1,"C","","","","",;
	"mv_par07","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)



	aHelpPor := {}
	aHelpEng := {}
	aHelpSpa := {}


	AADD(aHelpPor,"Indica se a contabilização será on-line,")
	AADD(aHelpPor,"ou seja, no momento da efetivação da transação")
	AADD(aHelpPor,"(inclusão de título, baixa,geração de cheque,")
	AADD(aHelpPor,"exclusão, etc.) um a um, ou se será contabilizado")
	AADD(aHelpPor,"0ff-line, onde todos os lançamentos não efetuados ")
	AADD(aHelpPor,"on-line são contabilizados em um processo em lote.")

	AADD(aHelpSpa,"Indica si la contabilizacion sera on-line, es decir,")
	AADD(aHelpSpa,"en el momento de la efectividad de la transaccion")
	AADD(aHelpSpa,"(inclusion de titulo, baja, generacion de cheque,")
	AADD(aHelpSpa,"borrado, etc.) un por un, o si sera contabilizado")
	AADD(aHelpSpa,"de modo 0ff-line, donde todos los asientos no efectuados")
	AADD(aHelpSpa,"de modo on-line son contabilizados en un proceso en lote. ")                                       


	AADD(aHelpEng,"Indicate if the posting will be on-line, that is,")
	AADD(aHelpEng,"the transactions (bills insertion, posting, checks ")
	AADD(aHelpEng,"generation, deletion, etc) will be carried out")
	AADD(aHelpEng,"individually. Or off-line, where all the entries ")
	AADD(aHelpEng,"that were not carried out on-line will be posted ")
	AADD(aHelpEng,"in a process in lot. ")  


	PutSx1( "AFI470", "08","Contabiliza On Line ?","¿Contabiliza en linea ? ","Online Accounting Entry ?","mv_ch8","N",1,0,1,"C","","","","",;
	"mv_par08","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)	

	aHelpPor := {}
	aHelpEng := {}
	aHelpSpa := {} 

	aHelpPor := {"Indique o periodo inicial para tratamento do cheque"}
	aHelpEng := {"Indique o periodo inicial para tratamento do cheque"}
	aHelpSpa := {"Indique cual o periodo inicial para el tratamiento del cheque"}

	PutSx1( "AFI470", "09","Dt. Inicial Cheques ?","Dt. Inicial Cheques ?","Dt. Inicial Cheques ?","mv_ch9","D",8,0,0,"G","","","","",;
	"mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)		

	aHelpPor := {}
	aHelpEng := {}
	aHelpSpa := {} 

	aHelpPor := {"Indique o periodo final para tratamento do cheque"}
	aHelpEng := {"Indique o periodo final para tratamento do cheque"}
	aHelpSpa := {"Indique cual o periodo final para el tratamiento del cheque"}


	PutSx1( "AFI470", "10","Dt Final Cheques ?","Dt Final Cheques ?","Dt Final Cheques ?","mv_cha","D",8,0,0,"G","","","","",;
	"mv_par10","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)		


	aHelpPor := {}
	aHelpEng := {}
	aHelpSpa := {}

	AADD(aHelpPor,"Indica se, ao efetivar-se um movimento")
	AADD(aHelpPor,"será exibida a tela para preenchimento")
	AADD(aHelpPor,"dos dados complementares do movimento ")
	AADD(aHelpPor,"bancário (natureza, Entidades contábeis")
	AADD(aHelpPor,"etc.). Caso opte por NÃO mostrar a tela ")
	AADD(aHelpPor,"acima citada, poderá ser utilizado o ")
	AADD(aHelpPor,"ponto de entrada F470GRVEF para ")
	AADD(aHelpPor,"gravação complementar dos dados.")

	AADD(aHelpSpa,"Indica si al hacerse efectivo un movimiento,")
	AADD(aHelpSpa,"se exhibirá la pantalla en la que se")
	AADD(aHelpSpa,"informarán los datos complementarios para el")
	AADD(aHelpSpa,"movimiento bancario (Modalidad, Entes Contables")
	AADD(aHelpSpa,", etc.). Si opta por NO exhibir la pantalla a")
	AADD(aHelpSpa,"la que nos referimos, se podrá utilizar el")
	AADD(aHelpSpa,"punto de entrada F470GRVEF para grabar datos")
	AADD(aHelpSpa,"complementarios")

	AADD(aHelpEng,"It indicates if, when confirming a transaction,")
	AADD(aHelpEng,"a screen will be displayed for filling in")
	AADD(aHelpEng,"complementary information of the bank transaction")      
	AADD(aHelpEng,"(Class, Accounting Entities, etc.). If you")
	AADD(aHelpEng,"choose NOT to show this screen, the point")
	AADD(aHelpEng,"of entry F470GRVEF can be used for ")      
	AADD(aHelpEng,"complementary saving of the information.")

	PutSx1( "AFI470", "11","Mostra Tela Efetivação? ","¿? ","?","mv_chb","N",1,0,1,"C","","","","",;
	"mv_par11","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ret_SE5_ConcºAutor  ³Bruno Daniel Borges º Data ³  07/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de selecao dos movimentos bancarios para serem conciliaº±±
±±º          ³dos conforme retorno bancario de mesmo tipo                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ret_SE5_Conc(oTitulo)  
	Local oDlgMain   := Nil            
	Local oList      := Nil  
	Local oDlg4      := Nil   
	Local oMarcaAll  := Nil 
	Local oSay       := Nil
	Local oFonte1    := TFont():New("Arial",,14,,.T.)
	Local aCoorden   := MsAdvSize(.T.)
	Local aList      := {}
	Local nRecno     := TRB->(RecNo()) 
	Local cChave     := TRB->OCORBCO
	Local cOpcao     := ""    
	Local nTotal     := 0
	Local nOpcClick  := 0 
	Local nOpcaN     := 0  
	Local i          := 0
	Local lMarcado   := .F.  
	Local lInverte   := .F.
	Local cNaturEfet := CRIAVAR("ED_CODIGO")
	Local cCCD       := CRIAVAR("E5_CCD")	
	Local cCCC       := CRIAVAR("E5_CCC") 
	Local cItemD     := CRIAVAR("E5_ITEMD")
	Local cItemC     := CRIAVAR("E5_ITEMC")
	Local cClVlDb    := CRIAVAR("E5_CLVLDB")
	Local cClVlCr    := CRIAVAR("E5_CLVLCR")
	Local cCDeb      := CRIAVAR("E5_DEBITO")
	Local cCCrd      := CRIAVAR("E5_CREDITO")  
	Local cHistor    := Space(50)
	Local lConsulta  := IIF(CtbInUse(),"CTT","SI3")
	Local lConsult2  := IIF(CtbInUse(),"CT1","SI1")
	Local lIsCTB	 := IIF(CtbInUse(),.T.,.F.)

	//Busca Registros que sao da mesma CHAVE de retorno bancario
	TRB->(dbGoTop())
	While TRB->(!Eof())
		If !(STR(TRB->OK,1) $ "1#3#4") .and. !Empty(TRB->VALORMOV) .And. TRB->OCORBCO == cChave
			AAdd(aList,{	.T.,;
			TRB->DATAMOV	,;
			TRB->AGEMOV		,;
			TRB->CTAMOV		,;
			TRB->NUMMOV		,;
			Val(PADR(StrTran(StrTran(TRB->VALORMOV,".",""),",","."),18))	,;
			TRB->TIPOMOV	,;
			TRB->DESCMOV	,;
			PADC(TRB->DEBCRED,3),;
			TRB->DESCRMOV,;
			TRB->(RecNo()) })
			nTotal += Val(PADR(StrTran(StrTran(TRB->VALORMOV,".",""),",","."),18))
		EndIf

		TRB->(dbSkip())
	EndDo

	If Len(aList) <= 0
		MsgAlert("Atenção, nenhum registro foi localizado no arquivo de retorno que aina NÃO foi reconciliado com a mesma 'CHAVE' do registro atual.")
		TRB->(dbGoTo(nRecno))
		Return(Nil)
	EndIf

	//Desenha a tela para selecao dos movimentos que serao reconciliados automaticamente
	oDlgMain := TDialog():New(aCoorden[7],000,aCoorden[6]/1.5,aCoorden[5]/1.5,OemToAnsi("Conciliação em Lote"),,,,,,,,oMainWnd,.T.)

	@ 014,001 ListBox oList Var cOpcao Fields Header " ","Data","Agência","Conta","Documento","Valor","Tipo","Descrição","D/C","Histórico no Extrato";
	Size oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-80 Of oDlgMain Pixel ; 
	On dblClick( aList[oList:nAt][1] := !aList[oList:nAt][1], Iif(aList[oList:nAt,1], nTotal += aList[oList:nAt,6], nTotal -= aList[oList:nAt,6]), oSay:SetText("TOTAL SELECIONADO: R$ " + AllTrim(Transform(nTotal,"@E 999,999,999.99"))) )
	oList:SetArray(aList)
	oList:bLine := {|| {		IIf(aList[oList:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
	aList[oList:nAt,2],;
	aList[oList:nAt,3],;
	aList[oList:nAt,4],;
	aList[oList:nAt,5],;
	Transform(aList[oList:nAt,6],"@E 999,999,999.99"),;
	aList[oList:nAt,7],;
	aList[oList:nAt,8],;
	aList[oList:nAt,9],;
	aList[oList:nAt,10] }}  
	TCheckBox():New(oDlgMain:nClientHeight/2-60,001,"Marcar/Desmarcar Todos",bSetGet(lInverte),oDlgMain,100,010,,{|| nLoop := 0, AEval(aList,{|x| nLoop++,aList[nLoop][1] :=  !aList[nLoop][1], Iif(aList[nLoop,1], nTotal += aList[nLoop,6], nTotal -= aList[nLoop,6])}), oList:Refresh(), oSay:SetText("TOTAL SELECIONADO: R$ " + AllTrim(Transform(nTotal,"@E 999,999,999.99"))) },,,,,.T.,.T.,"Marca/Desmarca todas as linhas",,)
	oSay := TSay():New(oDlgMain:nClientHeight/2-60,250,{||"TOTAL SELECIONADO: R$ " + AllTrim(Transform(nTotal,"@E 999,999,999.99")) },oDlgMain,,oFonte1,.F.,,,.T.,CLR_HBLUE,,oDlgMain:nClientWidth/2-20,015)
	EnchoiceBar(oDlgMain,{|| nOpcClick := 1, oDlgMain:End() },{|| oDlgMain:End()})

	oDlgMain:Activate(,,,.T.)

	//Gera a efetivacao das linhas do extrato
	AEval(aList,{|x| Iif(x[1],lMarcado := .T.,Nil)  })
	If lMarcado .And. MsgYesNo("Atenção, você confirma a efetivação do(s) registro(s) marcado(s) ?")
		DEFINE MSDIALOG oDlg4 FROM  69,70 TO 372,400 TITLE "Reconcilia‡„o Banc ria Autom tica" PIXEL	//
		@ 0, 2 TO 150, 133 OF oDlg4 PIXEL
		@ 07, 80 MSGET cNaturEfet  F3 "SED" VALID (!Empty(cNaturEfet) .and. ExistCpo("SED",cNaturEfet) .AND. FA470NATUR(cNaturEfet, @cCDeb,@cCCrd,@cCCD,@cCCC, lIsCtb, @cItemD,@cItemC,@cClVlDb,@cClVlCr))  SIZE 50, 10 OF oDlg4 PIXEL 
		@ 08, 08 SAY  "Natureza do Lan‡amento"  SIZE 80, 7 OF oDlg4 PIXEL  //
		@ 28, 08 MSGET cHistor SIZE 122, 10 OF oDlg4 PIXEL
		@ 19, 08 SAY "Historico" SIZE 80, 7 OF oDlg4 PIXEL  //
		@ 41, 80 MSGET cCDeb  F3 lConsult2 VALID (Empty(cCDeb) .or.CTB105CTA(cCDeb)) SIZE 50, 10 OF oDlg4 PIXEL
		@ 42, 08 SAY  "Conta Debito"  SIZE 80, 7 OF oDlg4 PIXEL  //
		@ 54, 80 MSGET cCCrd  F3 lConsult2 VALID (Empty(cCCrd) .or.CTB105CTA(cCCrd)) SIZE 50, 10 OF oDlg4 PIXEL
		@ 55, 08 SAY  "Conta Credito"  SIZE 80, 7 OF oDlg4 PIXEL  //
		@ 67, 80 MSGET cCCD  F3 lConsulta VALID (Empty(cCCD) .or. CTB105CC(cCCD)) SIZE 50, 10 OF oDlg4 PIXEL
		@ 68, 08 SAY  "Centro Custo Debito"  SIZE 80, 7 OF oDlg4 PIXEL  //
		@ 80, 80 MSGET cCCC  F3 lConsulta VALID (Empty(cCCC) .or. CTB105CC(cCCC)) SIZE 50, 10 OF oDlg4 PIXEL
		@ 81, 08 SAY  "Centro Custo Credito"  SIZE 80, 7 OF oDlg4 PIXEL  //

		@ 93, 80 MSGET cItemD  F3 "CTD" VALID (Empty(cItemD) .or. CTB105ITEM(cItemD)) SIZE 50, 10 OF oDlg4 PIXEL
		@ 94, 08 SAY  "Item Contabil Debito"  SIZE 80, 7 OF oDlg4 PIXEL  //
		@107, 80 MSGET cItemC  F3 "CTD" VALID (Empty(cItemC) .or. CTB105ITEM(cItemC)) SIZE 50, 10 OF oDlg4 PIXEL
		@108, 08 SAY  "Item Contabil Credito"  SIZE 80, 7 OF oDlg4 PIXEL  //

		@120, 80 MSGET cClVlDb F3 "CTH" VALID (Empty(cClVlDb) .or. CTB105CLVL(cClVlDb)) SIZE 50, 10 OF oDlg4 PIXEL
		@121, 08 SAY  "Classe Valor Debito"  SIZE 80, 7 OF oDlg4 PIXEL  //
		@133, 80 MSGET cClVlCr F3 "CTH" VALID (Empty(cClVlCr) .or. CTB105CLVL(cClVlCr)) SIZE 50, 10 OF oDlg4 PIXEL
		@134, 08 SAY  "Classe Valor Credito"  SIZE 80, 7 OF oDlg4 PIXEL  //

		DEFINE SBUTTON FROM 07, 135 TYPE 1 ENABLE ACTION (nOpcaN:=1,If((!Empty(cNaturEfet) .and. ExistCpo("SED",cNaturEfet)),oDlg4:End(),nOpcaN:=0)) OF oDlg4
		DEFINE SBUTTON FROM 20, 135 TYPE 2 ENABLE ACTION (nOpcaN:=2,oDlg4:End()) OF oDlg4

		ACTIVATE MSDIALOG oDlg4 CENTERED

		//Chama a funcao de gravacao para cada linha marcada
		If nOpcaN == 1  
			For i := 1 To Len(aList)
				If aList[i,1]
					TRB->(dbGoTo(aList[i,11]))
					FA470GrvEf(cNaturEfet,cCCC,cCCD,cItemD,cItemC,cClVlDb,cClVlCr,cCCrd,cCDeb,cHistor)
				EndIf		
			NExt i

			//Atualiza a Tela
			oTitulo:Refresh()                     
		EndIf
	EndIf

	TRB->(dbGoTo(nRecno))

Return(Nil)