#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


// Chamado do botão TROCA colocado na FINA100
//
// Renato Takao
//
//USER Function fa100tranT4F(cAlias,nReg,nOpc)
USER Function TROCOT4F(cAlias,nReg,nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 														  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nOpcA			:=0
Local oDlg
LOCAL lGrava
LOCAL nA,cMoedaTx
LOCAL lSpbInUse	:= SpbInUse()
LOCAL aModalSPB	:=  {"1=TED","2=CIP","3=COMP"}
LOCAL oModSpb
LOCAL cModSpb 
LOCAL aTrfPms		:= {}
LOCAL lEstorno		:= .F.
LOCAL oBcoOrig
LOCAL oBcoDest
LOCAL aSimbMoeda	:= {}							//Array com os simbolos das moedas.
LOCAL nPosMoeda	:= 0							//Verifica a posicao da moeda no array aSimbMoeda		
LOCAL nX				:= 0							//Contador
LOCAL nTotMoeda	:= 0							//TotMoeda

PRIVATE cBcoOrig		:= CriaVar("E5_BANCO")
PRIVATE cBcoDest		:= CriaVar("E5_BANCO")
PRIVATE cAgenOrig	:= CriaVar("E5_AGENCIA")
PRIVATE cAgenDest	:= CriaVar("E5_AGENCIA")
PRIVATE cCtaOrig		:= CriaVar("E5_CONTA")
PRIVATE cCtaDest		:= CriaVar("E5_CONTA")
PRIVATE cNaturOri	:= CriaVar("E5_NATUREZ")
PRIVATE cNaturDes	:= CriaVar("E5_NATUREZ")
PRIVATE cDocTran		:= CriaVar("E5_NUMCHEQ")
PRIVATE cHist100		:= CriaVar("E5_HISTOR")
PRIVATE nValorTran	:=0
PRIVATE cBenef100 	:= CriaVar("E5_BENEF")
PRIVATE lA100BL01	:= ExistBlock("A100BL01")
PRIVATE lF100DOC		:= ExistBlock("F100DOC")
PRIVATE aValores		:= {}

// rotina externa nao contabiliza (o SIGALOJA usa esta rotina
// direto da rotina de venda rapida e neste caso
// o parametro ‚ sempre .T.
If Substr(Upper(FunName()),1,7) == "LOJA220"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Permissao "Sangria/Entrada de Troco" - #5 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !LjProfile(5,,,,,.T.)
		Return(NIL)
	EndIf
	lExterno := .T.
Endif

If cPaisLoc <> "BRA"
   PRIVATE aTxMoedas := {}
   /*
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
   //³A moeda 1 e tambem inclusa como um dummy, nao vai ter uso,    ³
   //³mas simplifica todas as chamadas a funcao xMoeda, ja que posso³
   //³passara a taxa usando a moeda como elemento do Array atxMoedas³
   //³Exemplo xMoeda(E1_VALOR,E1_MOEDA,1,dDataBase,,aTxMoedas[E1_MOEDA][2])
   //³Bruno - Paraguay 22/08/2000                                   ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   */

   aAdd  (aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1")})
   For nA   := 2  To MoedFin()
      cMoedaTx := Str(nA,IIf(nA <= 9,1,2))
      If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
         Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),RecMoeda(dDataBase,nA),PesqPict("SM2","M2_MOEDA"+cMoedaTx) })
      Else
         Exit
      Endif
   Next

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta a Ocorrencia "EST" no SX5 para for‡ar o usuario a uti-³
//³ lizar a OPCAO Estorno para que o saldo bancario seja tratado ³
//³ corretamente.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
If dbSeek(xFilial()+"14"+"EST")
	Reclock("SX5")
	dbDelete()
	MsUnlock()
Endif

PRIVATE nTotal := 0
PRIVATE cTipoTran := Space(3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !DtMovFin()
	If cPaisLoc <> "BRA" .And. Type("bFiltraBrw") == "B"
		Eval( bFiltraBrw )
	Endif	
	Return
Endif

While .T.

	dbSelectArea("SE5")

	cBcoOrig	:= CriaVar("E5_BANCO")
	cBcoDest	:= CriaVar("E5_BANCO")
	cAgenOrig:= CriaVar("E5_AGENCIA")
	cAgenDest:= CriaVar("E5_AGENCIA")
	cCtaOrig	:= CriaVar("E5_CONTA")
	cCtaDest	:= CriaVar("E5_CONTA")
	cNaturOri:= CriaVar("E5_NATUREZ")
	cNaturDes:= CriaVar("E5_NATUREZ")
	cDocTran := CriaVar("E5_NUMCHEQ")
	cHist100 := CriaVar("E5_HISTOR")
	nValorTran:=0
	nValTROCO:=0
	cBenef100:= CriaVar("E5_BENEF")
	cTipoTran := CriaVar("E5_MOEDA")
	If lSpbInUse
		cModSpb := "1"
	Endif
	nOpcA := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebe dados a serem digitados 										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lSpbInUse
		DEFINE MSDIALOG oDlg FROM  32, 113 TO 416,530 TITLE OemToAnsi("STR0009") PIXEL	// "Movimenta‡„o Banc ria"
	Else                                  
		DEFINE MSDIALOG oDlg FROM  32, 113 TO 356,530 TITLE OemToAnsi("STR0009") PIXEL	// "Movimenta‡„o Banc ria"
	Endif
	@ 06, 4 TO 036, 172 OF oDlg	PIXEL
	@ 44, 4 TO 074, 172 OF oDlg	PIXEL
	@ 85, 4 TO 159, 172 OF oDlg	PIXEL

	@ 01, 04 SAY OemToAnsi("Origem") 		 SIZE 25, 7 OF oDlg PIXEL	// "Origem"
	@ 13, 08 SAY OemToAnsi("Banco") 		 SIZE 19, 7 OF oDlg PIXEL	// "Banco"
	@ 13, 42 SAY OemToAnsi("Agencia") 		 SIZE 25, 7 OF oDlg PIXEL	// "Agˆncia"
	@ 13,122 SAY OemToAnsi("Natureza")		 SIZE 28, 7 OF oDlg PIXEL	// "Natureza"
	@ 13, 72 SAY OemToAnsi("Conta") 		 SIZE 20, 7 OF oDlg PIXEL	// "Conta"
	@ 40, 04 SAY OemToAnsi("Destino") 		 SIZE 25, 7 OF oDlg PIXEL	// "Destino"
	@ 52, 08 SAY OemToAnsi("Banco") 		 SIZE 23, 7 OF oDlg PIXEL	// "Banco"
	@ 52, 42 SAY OemToAnsi("Agencia") 		 SIZE 27, 7 OF oDlg PIXEL	// "Agˆncia"
	@ 52, 72 SAY OemToAnsi("Conta") 		 SIZE 18, 7 OF oDlg PIXEL	// "Conta"
	@ 52,122 SAY OemToAnsi("Natureza")		 SIZE 28, 7 OF oDlg PIXEL	// "Natureza"
	@ 79, 04 SAY OemToAnsi("Identificação") 		 SIZE 41, 7 OF oDlg PIXEL	// "Identifica‡„o"
	@ 93, 08 SAY OemToAnsi("Tipo Mov.") 		 SIZE 31, 7 OF oDlg PIXEL	// "Tipo Mov."
	@ 93, 42 SAY OemToAnsi("Numero Doc.") 		 SIZE 43, 7 OF oDlg PIXEL	// "N£mero Doc."
	@ 93, 99 SAY OemToAnsi("Valor") 		 SIZE 17, 7 OF oDlg PIXEL	// "Valor"
	@ 115,09 SAY OemToAnsi("Historico") 		 SIZE 28, 7 OF oDlg PIXEL	// "Hist¢rico"
	@ 136,09 SAY OemToAnsi("Beneficiário") 		 SIZE 40, 7 OF oDlg PIXEL	// "Benefici rio"

	@ 22, 09 MSGET oBcoOrig VAR cBcoOrig	F3 "SA6"	Picture "@S3"  Valid CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.)	SIZE 10, 10 OF oDlg PIXEL hasbutton
	@ 22, 42 MSGET cAgenOrig  								Picture "@S5"	Valid CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.)	SIZE 20, 10 OF oDlg PIXEL
	@ 22, 72 MSGET cCtaOrig									Picture "@S10"	Valid If(CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,.T.),.T.,oBcoOrig:SetFocus()) SIZE 45, 10 OF oDlg PIXEL
	@ 22,122 MSGET cNaturOri					F3 "SED"  					Valid ExistCpo("SED",@cNaturOri) SIZE 47, 10 OF oDlg PIXEL hasbutton

	@ 60, 09 MSGET oBcoDest VAR cBcoDest	F3 "SA6" Picture "@S3"	Valid CarregaSa6(@cBcoDest,@cAgenDest,@cCtaDest,.F.) SIZE 10, 10 OF oDlg PIXEL hasbutton
	@ 60, 42 MSGET cAgenDest								Picture "@S5"	Valid CarregaSa6(@cBcoDest,@cAgenDest,@cCtaDest,.F.) SIZE 20, 10 OF oDlg PIXEL
	@ 60, 72 MSGET cCtaDest									Picture "@S10" Valid IF(CarregaSa6(@cBcoDest,@cAgenDest,@cCtaDest,.F.,@cBenef100,.T.) .and. ;
																						( cBcoDest != cBcoOrig .or. cAgenDest != cAgenOrig .or.	cCtaDest != cCtaOrig),.T.,oBcoDest:SetFocus())	SIZE 45, 10 OF oDlg PIXEL
	@ 60,122 MSGET cNaturDes					F3 "SED"						Valid ExistCpo("SED",@cNaturDes) SIZE 47, 10 OF oDlg PIXEL hasbutton


	@ 102,09 MSGET cTipoTran					F3 "14"	Picture "!!!"	Valid (!Empty(cTipoTran) .And. ExistCpo("SX5","14"+cTipoTran)) .and. ; 
																						Iif(cTipoTran="CH",fa050Cheque(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran),.T.) .And. ;
																						Iif(cTipoTran="CH" .or. cTipoTran="TB",fa100DocTran(cBcoOrig,cAgenOrig,cCtaOrig,cTipoTran,@cDocTran),.T.) SIZE  15, 10 OF oDlg PIXEL hasbutton
	@ 102,42 MSGET cDocTran		Picture PesqPict("SE5", "E5_NUMCHEQ")	Valid !Empty(cDocTran).and.U_t4ffa100doc(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran) SIZE	47, 10 OF oDlg PIXEL
	@ 102,99 MSGET nValorTran	PicTure PesqPict("SE5","E5_VALOR",15)	Valid (nValorTran > 0 .AND. nValTROCO==nValorTran)     SIZE  66, 10 OF oDlg PIXEL hasbutton

	@ 123, 9 MSGET cHist100		Picture "@S22"      							Valid !Empty(cHist100)        SIZE 155, 10 OF oDlg PIXEL

	@ 144, 9 MSGET cBenef100	Picture "@S21"      							Valid !Empty(cBenef100)       SIZE 155, 10 OF oDlg PIXEL

	If lSpbInUse
		@ 162, 4 TO 188, 172 OF oDlg	PIXEL
		@ 165,09 SAY "Modalidade SPB" SIZE 60, 07 OF oDlg PIXEL  //"Modalidade SPB"
		@ 173,09 MSCOMBOBOX oModSPB VAR cModSpb ITEMS aModalSpb SIZE 56, 47 OF oDlg PIXEL ;
						VALID SpbTipo("SE5",cModSpb,cTipoTran,"TR") 
	Endif

	DEFINE SBUTTON FROM 10, 180 TYPE 1 ENABLE ACTION (nOpca:=1,oDLg:End()) OF oDlg
	DEFINE SBUTTON FROM 23, 180 TYPE 2 ENABLE ACTION (nOpca:=0,oDlg:End()) OF oDlg
	If IntePms()
		aTrfPms := {CriaVar("E5_PROJPMS"),CriaVar("E5_TASKPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_EDTPMS"),CriaVar("E5_TASKPMS")}
		@ 36,180 BUTTON "Projetos..." SIZE 29 ,14   ACTION {||F100PmsTrf(aTrfPms)	} OF oDlg PIXEL 
	EndIf

   If cPaisLoc <> "BRA"
	   @ 140, 180 BUTTON OemToAnsi("STR0035") SIZE 30,15 ACTION (Fa100SetMo()) OF oDlg PIXEL   //  "&Tasas"
	Endif
	ACTIVATE MSDIALOG oDlg CENTERED VALID  (iif(nOpca==1 , ;
		CarregaSa6(cBcoOrig,cAgenOrig,cCtaOrig,.T.,,.T.) .and. ;
		ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig).and.;
		IIF(lSpbInUse,SpbTipo("SE5",cModSpb,cTipoTran,"TR"),.T.),.T.) )

	IF nOpcA == 1
		Begin Transaction
		   lGrava := .T.
			If ExistBlock("FA100TRF")
				lGrava := ExecBlock("FA100TRF", .F., .F., { cBcoOrig, cAgenOrig, cCtaOrig,;
															   cBcoDest, cAgenDest, cCtaDest,;
															   cTipoTran, cDocTran, nValorTran,;
															   cHist100, cBenef100,cNaturOri,;
															   cNaturDes , cModSpb, lEstorno})

			Endif

			If lF100DOC
				cDocTran := ExecBlock("F100DOC",.F.,.F.,{	cBcoOrig	, cAgenOrig	, cCtaOrig		,;
														   	cBcoDest	, cAgenDest	, cCtaDest		,;
														   	cTipoTran	, cDocTran	, nValorTran	,;
														   	cHist100	, cBenef100	, cNaturOri		,;
														   	cNaturDes 	, cModSpb	, lEstorno})
			EndIf

			IF lGrava                        
			
				//Preenche o array aSimbMoeda     
				nTotMoeda := MoedFin() 
				For nX := 1 To nTotMoeda              
					If( !(Empty(SuperGetMV("MV_MOEDA"+STR(nX,1)))) )	    
						AAdd( aSimbMoeda,SuperGetMV("MV_SIMB"+Ltrim(Str(nX))) ) 	
					  EndIf
				Next nX
				
			    //Verifica e transacao em dinheiro e deixa fazer a transferencia entre bancos
			    nPosMoeda := Ascan(aSimbMoeda,{|x| Trim(x) == Trim(cTipoTran)}) 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Realiza a transferencia entre caixa  ³
				//³somente se for dinheiro - Bops 127959³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If IsCaixaLoja(cBcoOrig) .AND. !(IsCaixaLoja(cBcoDest)) .AND. nPosMoeda == 0
					MsgInfo("STR0065")
				Else
				   fa100grava( 	cBcoOrig	,	cAgenOrig	,	cCtaOrig	,	cNaturOri	,	;
								cBcoDest	,	cAgenDest	,	cCtaDest	,	cNaturDes	,	;
								cTipoTran	,	cDocTran	,	nValorTran	,	cHist100	,	;
								cBenef100	,	NIL			,	cModSpb		,	aTrfPms		)
  				EndIf
			ENDIF		
		End Transaction
		If lA100BL01
			aValores := {cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,cBcoDest,cAgenDest,;
				cCtaDest,cNaturDes,cTipoTran,nValorTran,cDocTran,cBenef100,cHist100,cModSpb}
			ExecBlock("A100BL01",.F.,.F.,aValores)
		EndIf                                                     
	Else
		Exit
	Endif
Enddo
If cPaisLoc <> "BRA" .And. Type("bFiltraBrw") == "B"
	Eval( bFiltraBrw )
Endif	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fa100DocTran³ Autor ³ Wagner Xavier         ³ Data ³ 14/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ponto de entrada para manipular variavel cDocTran             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa100DocTran(cBcoOrig,cAgenOrig,cCtaOrig,cTipoTran,cDocTran)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fa100DocTran(cBcoOrig,cAgenOrig,cCtaOrig,cTipoTran,cDocTran)

If ExistBlock("FA100DOC")
	cDocTran := ExecBlock("FA100DOC", .F., .F., {cBcoOrig, cAgenOrig,cCtaOrig,cTipoTran,cDocTran})
EndIf

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fa100grava³ Autor ³ Wagner Xavier         ³ Data ³ 08/09/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Faz as atualizacoes para transferencia.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa100grava()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function fa100grava(cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,;
									cBcoDest,cAgenDest,cCtaDest,cNaturDes,;
									cTipoTran,cDocTran,nValorTran,cHist100,;
									cBenef100,lEstorno,cModSpb,aTrfPms,nVlrEstOrig)

LOCAL lPadrao1:=.F.
LOCAL lPadrao2:=.F.
LOCAL cPadrao:="560"
LOCAL lMostra,lAglutina
LOCAL lA100TR01	:= ExistBlock("A100TR01")
LOCAL lA100TR02	:= ExistBlock("A100TR02")
LOCAL lA100TR03	:= ExistBlock("A100TR03")
LOCAL lA100TRA	:= ExistBlock("A100TRA")
LOCAL lA100TRB	:= ExistBlock("A100TRB")
LOCAL lA100TRC	:= ExistBlock("A100TRC")
LOCAL nRegSEF := 0
LOCAL nMoedOrig   := 1
LOCAL nMoedTran	:=	1
LOCAL lSpbInUse	:= SpbInUse()

lEstorno := IIF (lEstorno == NIL , .F., lEstorno)

DEFAULT aTrfPms	:= {}
DEFAULT lExterno  := .F.
DEFAULT nVlrEstOrig :=0

STRLCTPAD := " "

If !(Empty(cBcoOrig+cAgenOrig+cCtaOrig))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atencao!, neste programa sera' utilizado 2 lan‡amentos padroni³
	//³ zados, pois o mesmo gera 2 registros na movimentacao bancaria³
	//³ O 1. registro para a saida  (Banco Origem ) ->Padrao "560"   ³
	//³ O 2. registro para a entrada(Banco Destino) ->Padrao "561"   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc	# "BRA"
		dbSelectArea( "SA6" )
		dbSeek( xFilial("SA6") + cBcoDest + cAgenDest + cCtaDest )
		nMoedTran	:=	MAX(SA6->A6_MOEDA,1)
	Endif
	dbSelectArea( "SA6" )
	dbSeek(  xFilial("SA6") + cBcoOrig + cAgenOrig + cCtaOrig )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza movimentacao bancaria c/referencia a saida			  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Reclock("SE5",.T.)
	SE5->E5_FILIAL		:= xFilial()
	SE5->E5_DATA		:= dDataBase
	SE5->E5_BANCO		:= cBcoOrig
	SE5->E5_AGENCIA	:= cAgenOrig
	SE5->E5_CONTA		:= cCtaOrig
	SE5->E5_RECPAG		:= "P"
	SE5->E5_NUMCHEQ	:= cDocTran
	SE5->E5_HISTOR		:= cHist100
	SE5->E5_TIPODOC	:= "TR"
	SE5->E5_MOEDA		:= cTipoTran
	If cPaisLoc == "BRA"
		SE5->E5_VALOR	:= nValorTran
	Else
		nMoedOrig		:= MAX(SA6->A6_MOEDA,1)
      	SE5->E5_VALOR	:= IIf(lEstorno,Iif(nVlrEstOrig<>0,nVlrEstOrig ,Round(xMoeda(nValorTran,nMoedTran,nMoedOrig,dDataBase,MsDecimais(nMoedOrig)+1,nTxEstR,nTxEstP),MsDecimais(nMoedOrig))),nValorTran)
		//Gravo o valor na moeda 1 para nao ter problemas na hora da conversao por casas
		//decimais perdidas na contabilidade... Bruno.
      SE5->E5_VLMOED2:= IIf(lEstorno,xMoeda(nValorTran,nMoedTran,1,,,nTxEstR),xMoeda(nValorTran,nMoedOrig,1,,,aTxMoedas[nMoedOrig][2]))
	Endif
	SE5->E5_DTDIGIT	:= dDataBase
	SE5->E5_BENEF		:= cBenef100
	SE5->E5_DTDISPO	:= SE5->E5_DATA
	SE5->E5_NATUREZ	:= cNaturOri
	SE5->E5_FILORIG	:= cFilAnt
	If (SE5->(FieldPos('E5_TXMOEDA')) > 0) .And. (cPaisLoc <> "BRA")
		E5_TXMOEDA		:= If( lEstorno, nTxEstR, aTxMoedas[nMoedOrig][2] )
	Endif
	If lSpbInUse
		SE5->E5_MODSPB	:= cModSpb
	Endif
	MsUnLock()	
	If !Empty(aTrfPms) .And. !Empty(aTrfPms[1])
		nRecNo	:= SE5->(RecNo())
		cID		:= STRZERO(SE5->(RecNo()),10)
		cStart	:= "AA"
 		dbSelectArea("SE5")
		dbSetOrder(9)
		While dbSeek(xFilial()+cID)
			cID := STRZERO(nRecNo,8)+cStart
 			cStart := SomaIt(cStart)
 		End
		SE5->(dbGoto(nRecNo))
		RecLock('SE5',.F.)
		SE5->E5_PROJPMS	:= cId
		MsUnlock()
		RecLock("AJE",.T.)
		AJE->AJE_FILIAL	:= xFilial("AJE")
		AJE->AJE_VALOR 	:= SE5->E5_VALOR
		AJE->AJE_DATA		:= SE5->E5_DATA
		AJE->AJE_HISTOR	:= SE5->E5_HISTOR
		AJE->AJE_PROJET	:= aTrfPms[1]
		AJE->AJE_REVISA	:= PmsAF8Ver(aTrfPms[1])
		AJE->AJE_TAREFA	:= aTrfPms[2]
		AJE->AJE_ID			:= cID
		MsUnlock()
	EndIf
	If (Alltrim(cTipoTran) == "TB" .or. ;
			(Alltrim(cTipoTran) == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. !lEstorno
		nRegSEF := Fa100Cheq("FINA100TRF")
	Endif

	If nModulo == 72
		KEXF030(lEstorno)
	EndIf

	If lA100TR01
		if reclock("SE5",.F.)
			SE5->E5_NUMPA := cDocTran  // $$$$$$$$$$$$$$ Customizado
			msunlock()
		endif
	EndIf
	If lA100TRA
		ExecBlock("A100TRA",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
									  cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ So atualiza do saldo se for R$,DO,TB,TC ou se for CH e o ban-³
	//³ co origem n„o for um caixa do loja, pois este foi gerado no  ³
	//³ SE1 e somente sera atualizado na baixa do titulo.            ³
   //³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
   //³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
   //³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If ((Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC"+IIf(cPaisLoc=="BRA","","/$ ")) .or. ;
			(SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. ;
			!(SUBSTR(SE5->E5_NUMCHEQ,1,1) == "*")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza saldo bancario.												  ³
		//³ Paso o E5_VALOR pois fora do Brasil a conta pode ser em moeda³
		//³ diferente da moea Oficial.                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AtuSalBco(cBcoOrig,cAgenOrig,cCtaOrig,dDataBase,SE5->E5_VALOR,"-")
	Endif

	If !lExterno
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³Lan‡amento Contabil - 1. registro do SE5									³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lPadrao1:=VerPadrao(cPadrao)
		STRLCTPAD := cBcoDest+"/"+cAgenDest+"/"+cCtaDest
		IF lPadrao1 .and. mv_par04 == 1
			nHdlPrv:=HeadProva(cLote,"FINA100",Substr(cUsuario,7,6),@cArquivo)
		Endif

		IF lPadrao1 .and. mv_par04 == 1
			nTotal+=DetProva(nHdlPrv,cPadrao,"FINA100",cLote)
		Endif

		IF lPadrao1 .and. mv_par04 == 1  // On Line
			Reclock("SE5")
			Replace E5_LA With "S"
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
      //³ Conforme situação do parâmetro abaixo, integra com o SIGAGSP ³
      //³             MV_SIGAGSP - 0-Não / 1-Integra                   ³
      //³ e-mail de Fernando Mazzarolo de 08/11/2004                   ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
      If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
         GSPF380(3) 
      EndIf
	Endif
Endif

If !(Empty(cBcoDest+cAgenDest+cCtaDest))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza movimentacao bancaria c/referencia a entrada		  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SA6" )
	dbSeek( xfilial("SA6")+ cBcoDest + cAgenDest + cCtaDest )
	Reclock("SE5",.T.)
	SE5->E5_FILIAL		:= xFilial()
	SE5->E5_DATA		:= dDataBase
	SE5->E5_BANCO		:= cBcoDest
	SE5->E5_AGENCIA	:= cAgenDest
	SE5->E5_CONTA		:= cCtaDest
	SE5->E5_RECPAG		:= "R"
	SE5->E5_DOCUMEN	:= cDocTran
	SE5->E5_HISTOR		:= cHist100
	SE5->E5_TIPODOC	:= "TR"
	SE5->E5_MOEDA		:= cTipoTran     

	If cPaisLoc == "BRA"
	   SE5->E5_VALOR	:= nValorTran
	Else
       SE5->E5_VALOR	:= IIf(lEstorno,nValorTran,Round(xMoeda(nValorTran,nMoedOrig,Max(SA6->A6_MOEDA,1),dDataBase,MsDecimais(Max(SA6->A6_MOEDA,1))+1,aTxMoedas[nMoedOrig][2],aTxMoedas[Max(SA6->A6_MOEDA,1)][2]),MsDecimais(Max(SA6->A6_MOEDA,1))))
		//Gravo o valor na moeda 1 para nao ter problemas na hora da conversao por casas
		//decimais perdidas na contabilidade... Bruno.
       SE5->E5_VLMOED2:= IIf(lEstorno,xMoeda(nValorTran,Max(SA6->A6_MOEDA,1),1,,,nTxEstR),xMoeda(nValorTran,nMoedOrig,1,,,aTxMoedas[nMoedOrig][2]))
	Endif
	SE5->E5_DTDIGIT	:= dDataBase
	SE5->E5_BENEF		:= cBenef100
	SE5->E5_DTDISPO	:= SE5->E5_DATA
	SE5->E5_NATUREZ	:= cNaturDes
	SE5->E5_FILORIG	:= cFilAnt
	If (SE5->(FieldPos('E5_TXMOEDA')) > 0) .And. (cPaisLoc <> "BRA")
		E5_TXMOEDA		:= If( lEstorno, nTxEstR, aTxMoedas[nMoedTran][2] )
	Endif
	If lSpbInUse
		SE5->E5_MODSPB	:= cModSpb
	Endif
	If !Empty(aTrfPms) .And. !Empty(aTrfPms[3])
		nRecNo	:= SE5->(RecNo())
 		cID		:= STRZERO(SE5->(RecNo()),10)
 		cStart	:= "AA"
		dbSelectArea("SE5")
 		dbSetOrder(9)
 		While dbSeek(xFilial()+cID)
			cID := STRZERO(nRecNo,8)+cStart
 			cStart := SomaIt(cStart)
 		EndDO
		SE5->(dbGoto(nRecNo))
		RecLock('SE5',.F.)
		SE5->E5_PROJPMS	:= cId
		MsUnlock()
		RecLock("AJE",.T.)
		AJE->AJE_FILIAL	:= xFilial("AJE")
		AJE->AJE_VALOR 	:= SE5->E5_VALOR
		AJE->AJE_DATA		:= SE5->E5_DATA
		AJE->AJE_HISTOR	:= SE5->E5_HISTOR
		AJE->AJE_PROJET	:= aTrfPms[3]
		AJE->AJE_REVISA	:= PmsAF8Ver(aTrfPms[3])
		AJE->AJE_EDT		:= aTrfPms[4]
		AJE->AJE_TAREFA	:= aTrfPms[5]
		AJE->AJE_ID			:= cID
		MsUnlock()
	EndIf
	MsUnLock()

	If nModulo == 72
		KEXF040(lEstorno)
	EndIf

	If lA100TR02
		if reclock("SE5",.F.)
			SE5->E5_NUMPA := cDocTran  // $$$$$$$$$$$$$$ Customizado troco
			msunlock()
		endif
		if reclock("ZZE",.F.)
			ZZE->ZZE_TRANSF ++  // $$$$$$$$$$$$$$ Customizado troco
			msunlock()
		endif           
	EndIf                                       
	If lA100TRB
		ExecBlock("A100TRB",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
									  cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ So atualiza do saldo se for R$,DO,TB,TC ou se for CH e o ban-³
	//³ co origem n„o for um caixa do loja, pois este foi gerado no  ³
	//³ SE1 e somente sera atualizado na baixa do titulo.            ³
	//³ O teste do caixa ‚ exatamente para o banco origem Mesmo.     ³
   //³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
   //³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
   //³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If ((Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC"+IIf(cPaisLoc=="BRA","","/$ ") ) .or. ;
			(SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. ;
			!(SUBSTR(SE5->E5_NUMCHEQ,1,1) == "*")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza saldo bancario.												  ³
		//³ Paso o E5_VALOR pois fora do Brasil a conta pode ser em moeda³
		//³ diferente da moea Oficial.                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		AtuSalBco(cBcoDest,cAgenDest,cCtaDest,dDataBase,SE5->E5_VALOR,"+")
	Endif

	If !lExterno
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³Lan‡amento Contabil - 2. registro do SE5									³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cPadrao :="561"
		lPadrao2:=VerPadrao(cPadrao)
		STRLCTPAD := cBcoOrig+"/"+cAgenOrig+"/"+cCtaOrig
		IF lPadrao2 .and. !lPadrao1 .and. mv_par04 == 1
			nHdlPrv:=HeadProva(cLote,"FINA100",Substr(cUsuario,7,6),@cArquivo)
		Endif

		IF lPadrao2 .and. mv_par04 == 1
			nTotal+=DetProva(nHdlPrv,cPadrao,"FINA100",cLote)
		Endif

		IF ( lPadrao1 .or. lPadrao2) .and. mv_par04 == 1
			RodaProva(nHdlPrv,nTotal)
			lAglutina:=Iif(mv_par01==1,.T.,.F.)
			lMostra	:=Iif(mv_par02==1,.T.,.F.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lancamento Contabil							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lMostra,lAglutina)
			If lPadrao1 .and. nRegSEF > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se contabilizou a Saida, e Foi uma TB  / CH, ent„o  ³
				//³ marca no cheque que j  foi contabilizado.           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SEF")
				DbGoto(nRegSEF)
				Reclock("SEF")
				SEF->EF_LA := "S"
				MsUnlock()
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
      //³ Conforme situação do parâmetro abaixo, integra com o SIGAGSP ³
      //³             MV_SIGAGSP - 0-Não / 1-Integra                   ³
      //³ e-mail de Fernando Mazzarolo de 08/11/2004                   ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
      If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
         GSPF380(4)
      EndIf
	Endif
Endif

If lA100TR03
	ExecBlock("A100TR03",.F.,.F.,lEstorno)
EndIf
If lA100TRC
	ExecBlock("A100TRC",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
											  cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
EndIf

IF !lExterno .and. lPadrao2 .and. mv_par04 == 1  // On Line
	Reclock("SE5")
	Replace E5_LA With "S"
EndIf

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA100Doc	³ Autor ³ Alessandro B. Freire  ³		³ 02/07/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida o documento digitado 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fa100Doc()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ FINA100  ³ 																			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function T4Ffa100Doc(cBanco,cAgencia,cConta,cDocumento)

LOCAL lRet:=.T.
LOCAL aAmb,cSeek
LOCAL nTamTit	:= 0
LOCAL aTam := {}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//
//
//
cDocumento:=U_DOCTROCO()
cDOCTRAN:=cDocumento
//
//
//////////////////////////////////////////////////
//////////////////////////////////////////////////

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o tamanho dos campos que compoem parte da chave ³
//³de busca atendendo a LOCALiza‡äes								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam := TamSx3("E5_PREFIXO")
nTamTit := aTam[1]
aTam := TamSx3("E5_NUMERO")
nTamTit += aTam[1]
aTam := TamSx3("E5_PARCELA")
nTamTit += aTam[1]
aTam := TamSx3("E5_TIPO")
nTamTit += aTam[1]

If (Alltrim(cTipoTran) != "TB" .And. Alltrim(cTipoTran) != "CH") .And.;
		Substr(cDocumento,1,1) == "*"
	lRet := .F.
EndIf

//Verifico se nas transferencias em cheque, ja exista cheque com mesma numeracao
dbSelectArea("SEF")
If lRet .and. AllTrim(cTipoTran) $ "TB#CH" .and. ;
	dbSeek(xFilial("SEF")+cBanco+cAgencia+cConta+Substr(cDocumento,1,15))
	
	Help(" ",1,"100DOCEXIS")
	lRet := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Procura se j  n„o houve movimentacao com este numero    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	aAmb:={Recno(),Alias(),SE5->(IndexOrd()),SE5->(recno())}
	dbSelectArea("SE5")
	dbSetOrder(2)
	cSeek := xFilial("SE5")+"TR"+Space(nTamTit)+DTOS(dDataBase)
	dbSeek( cSeek,.T. )
	
	While ! Eof() .and. cSeek == xFilial("SE5")+"TR"+Space(nTamTit)+DTOS(SE5->E5_DATA)
		If SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA) == cBanco+cAgencia+cConta .and. ;
				Alltrim(SE5->E5_NUMCHEQ)	== Alltrim(cDocumento) .And. ;
				SE5->E5_RECPAG 	== "P" 	     .And. ;
				SE5->E5_DATA		== dDataBase	.and. ;
				SE5->E5_MOEDA		== cTipoTran
	
			HELP( " ",1,"100DOCEXIS" )
			lRet := .F.
			Exit
		EndIf
		DbSkip(1)
	EndDo
	
	DbSelectArea("SE5")
	DbGoto(aAmb[4])
	DbSetORder(aAmb[3])
	DbSelectArea(aAmb[2])
	DbGoto(aAmb[1])
Endif

Return lRet


Static Function Fa100SetMo()
LOCAL oDlg, nLenMoedas	:= Len(aTxMoedas)
LOCAL lConfirmo	:=	.F.
LOCAL aTxTmp   := aClone(aTxMoedas)

If nLenMoedas > 1
	Define MSDIALOG oDlg From 200,0 TO 362,230 TITLE OemToAnsi("STR0036") PIXEL   //   "Tasas"
   @ 005,005  To 062,110 OF oDlg PIXEL
   @ 012,010 SAY  aTxMoedas[2][1]  Of oDlg PIXEL
   @ 010,060 MSGET aTxMoedas[2][2] PICTURE aTxMoedas[1][3] Of oDlg PIXEL
   If nLenMoedas > 2
      @ 024,010 SAY  aTxMoedas[3][1]  Of oDlg PIXEL
      @ 022,060 MSGET aTxMoedas[3][2] PICTURE aTxMoedas[2][3] Of oDlg PIXEL
      If nLenMoedas > 3
         @ 036,010 SAY  aTxMoedas[4][1]  Of oDlg PIXEL
         @ 034,060 MSGET aTxMoedas[4][2] PICTURE aTxMoedas[3][3] Of oDlg PIXEL
         If nLenMoedas > 4
            @ 048,010 SAY  aTxMoedas[5][1]  Of oDlg PIXEL
            @ 046,060 MSGET aTxMoedas[5][2] PICTURE aTxMoedas[4][3] Of oDlg PIXEL
         Endif
      Endif
   Endif
   DEFINE  SButton FROM 064,80 TYPE 1 Action (lConfirmo := .T. , oDlg:End() ) ENABLE OF oDlg  PIXEL
   Activate MSDialog oDlg CENTERED
   If !lConfirmo
      aTxMoedas   := aClone(aTxTmp)
   Endif

Else
	Help("",1,"NoMoneda")
Endif

Return

User Function DOCTROCO()

// PEGOU OS DADOS EM FA100DOC
// VALIDOU EM FA100TRF
// GRAVOU EM A100TR03

Private aAreaAnt:= getarea()

_cNumero:= space(06)

_cForteO:=posicione("SA6",1,xfilial("SA6")+cBcoOrig+cAgenOrig+cCtaOrig,"A6_CFORTE")
_cForteD:=posicione("SA6",1,xfilial("SA6")+cBcoDest+cAgenDest+cCtaDest,"A6_CFORTE")
If !(_cForteO="1" .OR. _cForteD="1")
	RESTAREA(aAreaAnt)
	return(_cNumero)
Endif

@ 015,015 TO 145,340 DIALOG oDlg TITLE "Informe o nr. da solicitação de troco"
@ 015,015 Say "Nr da solicitação de troco:"
@ 014,115 GET _cNumero PICTURE "@!" F3 "ZZE" 
@ 035,040 BUTTON "Ok" SIZE 40,15 ACTION iif(VALTRANSF(_cNumero),close(oDlg),NIL)
@ 035,090 BUTTON "Cancelar" SIZE 40,15 ACTION oDlg:End() //close(oDlg)	//sai_transf()

ACTIVATE DIALOG oDlg CENTERED

RESTAREA(aAreaAnt)

return(_cNumero)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALTRANSF º Autor ³ AP6 IDE            º Data ³  07/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Abandona a digitação do nr. de PA                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VALTRANSF()

dbselectarea("ZZE")
dbsetorder(1)
if !dbseek(xFilial("ZZE")+_cNumero)
	msgbox("A solicitação informada não foi encontrada, verifique e informe novamente","Atencao","ERROR")
	return .f.
endif

if ZZE->ZZE_TIPO <> 4
	msgbox("A solicitação informada não é tipo Troco. Informe uma solicitação válida.","Atencao","ERROR")
	return .f.
endif

if ZZE->ZZE_STATUS <> "L"
	msgbox("A solicitação informada não está liberada. Informe uma solicitação válida.","Atencao","ERROR")
	return .f.
endif
	
if ZZE->ZZE_TRANSF = 2
	msgbox("A solicitação nr. "+alltrim(ZZE->ZZE_NUMERO)+" ja foi utilizada duas vezes.",;
			"Essa solicitação nao pode mais ser utilizada","ERROR")
	return .f.
endif

nValTROCO:=ZZE->ZZE_VALOR

return(.t.)