#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#DEFINE ENTER Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT100AGR ºAutor  ³Bruno Daniel Borges º Data ³  23/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos a gravacao da NF de entrada para      º±±
±±º          ³atualizar os campos centro custo, conta contabil e elemento º±±
±±º          ³pep dos titulos a pagar/receber gerados pela NF             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³Adicionados as Linhas 32 ate 35 - Sergio Celestino          º±±
±±º          ³Desenvolvido as funcoes IntegraPA() e GeraOP() - Sergio Cel.º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Alterado 31/07/08 - Takao - grava historico com descriçào produto

User Function MT100AGR()
	Local aAreaBKP  := GetArea()
	Local aAreaSF1  := SF1->( GetArea() )
	Local aAreaSd1  := SD1->( GetArea() )
	Local aAreaSE2  := SE2->( GetArea() )
	Local aAreaSE1  := SE1->( GetArea() )
	Local nUltValor := 0
	Local aDados    := {"","",""}
	Local _Hist		:=""
	Local cCtaLRou  := ''
	Local cGrvLRouanet:= SuperGetMv("T4F_GRVLRO",,"N")
	// Novas Variáveis - Luiz Eduardo - 11/10/2017
	Local cMsg       := ""
	Local oDlg
	Local oArq
	Local bOk        := {||lOk:=.T.,oDlg:End()}
	Local bCancel    := {||lOk:=.F.,oDlg:End()}
	Local lOk        := .F.
	Local nLin       := 20
	Local cArq		 := space(6)
	Local nCol1      := 15
	Local nCol2      := nCol1+30
	Local oMacro
	Local aButtons := {}


	If !IsBlind()

		If INCLUI .And. Empty(SD1->D1_PEDIDO)
			MsgRun("Consultando Pagamentos Antecipados........",,{|| CursorWait(),IntegraPA(),CursorArrow()})  //Sergio Celestino -- Informar financeiro caso exista PA para o Pedido Incluso na NFE
			MsgRun("Convertendo Unidades de Compra em Venda...",,{|| CursorWait(),GeraOP()   ,CursorArrow()}) //Gerar Ordem de Produção para alimentar estoque do item de venda quando diferente do item de compra
		Endif

		//Busca o maior item (maior valor)
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))
		SD1->(dbSeek(FwFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		While SD1->(!Eof()) .And. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == FwFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

			// Alteração Luiz Eduardo para validar tipos de nota fiscal = NFS e código de ISS em branco	- obrigar usuário a digitar - 11/10/2017
			cArq := SPACE(6)

			// Verificar se é Empresa 08 e se não está sendo feito via V360
			If (SM0->M0_CODIGO == "08" .AND. (Type("_lv360call") == 'U' .OR. _lv360call == .F.))

				do while sf1->f1_especie='NFS' .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == FwFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

					@ 196,52 TO 400,505 DIALOG oDlg TITLE "Código do Serviço"
					@ 15,010 TO 45,225

					@ 26,030 Say "Código do Serviço :"
					@ 26,100 get cArq picture "@!" SIZE 60,20 VALID F3 "60"
					@ 26,180 BUTTON "OK" SIZE 40,15  ACTION CLOSE(ODLG)
					ACTIVATE DIALOG oDlg CENTERED
					Reclock("SD1",.f.)
					sd1->d1_codiss := cArq
					MsUnLock()
					if !empty(sd1->d1_codiss)
						exit
					endif

					//		skip
				enddo
			endif
			If SD1->D1_TOTAL > nUltValor
				nUltValor	:= SD1->D1_TOTAL
				aDados[1]	:= SD1->D1_CONTA
				aDados[2]	:= SD1->D1_CC
				aDados[3]	:= SD1->D1_ITEMCTA
				_Hist		:= POSICIONE("SB1",1,fWFILIAL("SB1")+SD1->D1_COD,"B1_DESC")

				// Trabalha pensando na gravacao dos campos da Lei Rouanet (Sim ou Nao).
				If ( cGrvLRouanet == "S" )

					If Empty(cCtaLRou)

						// u_LeiRouanet()
						If (SD1->D1_T4FLROU == "1") // .Or. !Empty(cCtaLRou)
							cCtaLRou:= Posicione("CTD",1,FWFilial("CTD")+SD1->D1_ITEMCTA,"CTD_T4LROU")
							_Hist:= Posicione("CTD",1,FWFilial("CTD")+SD1->D1_ITEMCTA,"CTD_DESC01")
							_Hist:= Alltrim( Subs(_Hist,1,20) )+" *LR"
						EndIf
					EndIf

				EndIf

			EndIf

			//Atualiza as prestacoes de contas caso existam
			If !Empty(SD1->D1__DESPES)
				dbSelectArea("ZZE")
				ZZE->(dbSetOrder(1))
				If ZZE->(dbSeek(FwFilial("ZZE")+SD1->D1__DESPES))
					ZZE->(RecLock("ZZE",.F.))
					If INCLUI .Or. ALTERA 			//Alterado Luis Dantas 10/10/12 - Limpar o ZZE_TITULO quando for exclusão do documento de entrada
						ZZE->ZZE_PREF   := SD1->D1_SERIE
						ZZE->ZZE_TITULO := SD1->D1_DOC
					Else	//Alterado Luis Dantas 10/10/12 - qdo INCLUI == .F. e ALTERA ==.F. então EXCLUI == .V.
						ZZE->ZZE_PREF   := ' '
						ZZE->ZZE_TITULO := ' '
					EndIf
					ZZE->(MsUnlock())
				EndIf
			EndIf

			SD1->(dbSkip())
		EndDo

		//Busca parcelas do titulo a pagar/receber da NF
		If SF1->F1_TIPO == "D" //NFs de Devolucao
			dbSelectArea("SE1")
			SE1->(dbSetOrder(2))
			SE1->(dbSeek(FwFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC  ))
			While SE1->(!Eof()) .And. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == FwFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
				SE1->(RecLock("SE1",.F.))
				SE1->E1_CCONTAB	:= aDados[1]
				SE1->E1_CCUSTO  := aDados[2]    // Este campo esta sendo utilizado pela contabilidade
				SE1->E1_CCD		:= aDados[2]
				SE1->E1_CCC		:= aDados[2]
				SE1->E1_ITEMD	:= aDados[3]
				SE1->E1_ITEMC	:= aDados[3]
				SE1->E1_ITEM    := aDados[3]    // Este campo esta sendo utilizado pela contabilidade
				SE1->E1_HIST	:= _Hist
				SE1->(MsUnlock())
				SE1->(dbSkip())
			EndDo
		Else //NFs Normais
			dbSelectArea("SA2")
			SA2->(dbSetOrder(1))
			SA2->(dbSeek(FwFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA ))
			dbSelectArea("SE2")
			SE2->(dbSetOrder(6))
			SE2->(dbSeek(FwFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC  ))
			While SE2->(!Eof()) .And. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == FwFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
				SE2->(RecLock("SE2",.F.))
				SE2->E2_CCONTAB	:= aDados[1]
				SE2->E2_CCUSTO  := aDados[2]    // Este campo esta sendo utilizado pela contabilidade
				SE2->E2_CCD		:= aDados[2]
				SE2->E2_CCC		:= aDados[2]
				SE2->E2_ITEMD	:= aDados[3]
				SE2->E2_ITEMC	:= aDados[3]
				SE2->E2_ITEM    := aDados[3]    // Este campo esta sendo utilizado pela contabilidade
				SE2->E2_HIST	:= _Hist
				If SM0->M0_CODIGO == "08"
					SE2->E2_XPOUP	:= IIF(SA2->A2_TIPCTA=="2","1"," ")
				Endif

				// Gilberto. Para gravacao da conta da lei rouanet
				// Grava campos da Lei Rouanet.
				If ( cGrvLRouanet == "S" )

					If !Empty(cCtaLRou)
						SE2->E2_CTALROU := cCtaLRou
					EndIf

				EndIf
				SE2->(MsUnlock())
				SE2->(dbSkip())
			EndDo
		EndIf

		// CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC+CT2_SEQIDX
		// CHAVE UNICA.
		// Grava dados do usuário que lançou a nota fiscal de entrada

		// Verifica se não está sendo feito pelo V360
		If (Type("_lv360call") == 'U' .OR. _lv360call == .F.)
			_cUsuario 	:= PswRet()[1][2]
			_NomeUsr	:= Substr(cUsuario,7,15)

			SF1->(RecLock("SF1",.F.))
			SF1->F1_XUSER  :=  Alltrim(substr(_cUsuario,1,15))//+'/'+dtoc(date())
			SF1->F1_XDATA  :=  DATE()
			SF1->(Msunlock("SF1"))
			SF1->( DbCommit() )
		EndIf
	EndIf

	// Restaura area anterior.
	RestArea(aAreaSD1)
	RestArea(aAreaSF1)
	RestArea(aAreaSE2)
	RestArea(aAreaSE1)
	RestArea(aAreaBKP)


Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IntegraPA ºAutor  ³Sergio Celestino    º Data ³  26/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica a existencia de Pagamentos antecipados para os     º±±
±±º          ³pedidos de compras da nota fiscal incluida e envia email    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IntegraPA

	Local aAreaSD1   :=  SD1->( GetArea() )
	Local aColsBkp   := aClone(aCols)
	Local aHeadBkp   := aClone(aHeader)
	Local aVetorPa   := {}
	Local a2VetorPa   := {}
	Local cDestEmail := ""
	Local _cSUBJECT  := ""
	Local cTxtEmail  := "A nota fiscal de entrada "+SF1->F1_DOC+" Serie: "+SF1->F1_SERIE+" do Fornecedor: "+SF1->F1_FORNECE+" possui os seguintes pedidos de compras com PAs: " + CRLF + CRLF
	Local nPosPC     := 0
	Local _aFiles    := Array(1)
	Local oDlg

	/*
	nPosPC  := aScan(aHeadBkp,{|x| Upper(AllTrim(x[2]))=='D1_PEDIDO'})

	For nY := 1 To Len(aColsBkp)
	If !aColsBkp[nY][Len(aHeadBkp)+1]
	DbSelectArea("ZZE")
	DbSetOrder(2)
	If DbSeek(xFilial("ZZE") + Alltrim(aColsBkp[nY][nPosPC]) )
	If aScan(aVetorPa,{|x| Alltrim(x[1]) == Alltrim(aColsBkp[nY][nPosPC])}) == 0
	aAdd(aVetorPa,{ZZE_PEDIDO,ZZE_NUMERO,ZZE_TITULO,ZZE_VALOR})
	Endif
	Endif
	Endif
	Next
	*/

	// Busca Solicitacoes de Adiantamento
	SeekAdto(@aVetorPA)

	// Busca Titulos no SE2
	SeekTitulos(@a2VetorPA)

	If ( Len(aVetorPa) > 0 ) .OR. ( Len(a2VetorPA) > 0 )

		ASort(aVetorPa,,,{|x,y| x[1] < y[1] })//Ordenar Vetor pelo numero de PC
		ASort(a2VetorPa,,,{|x,y| x[1] < y[1] })//Ordenar Vetor por vencimento
		cDestEmail:= GetMv("MV_XMAILFI",,"microsiga01@t4f.com.br")

		_cSubject := "[T4F-Suprimentos] Inclusão de Nota Fiscal de Entrada "+SF1->F1_DOC+" com PA"

		cTxtEmail += " *** SOLICITAÇÃO/ADTOS *** "+CRLF
		For nY := 1 To Len(aVetorPa)
			cTxtEmail += "Pedido: "+aVetorPa[nY][1]+" Solicitação PA: "+aVetorPa[nY][2]+" Titulo PA: "+aVetorPa[nY][3]+" Valor do PA: "+Alltrim(aVetorPa[nY][4]) + CRLF
		Next

		cTxtEmail += " *** TITULOS 'PA' NO CONTAS À PAGAR *** "+CRLF

		For nX := 1 To Len(a2VetorPa)
			cTxtEmail += "Emissão: "+a2VetorPa[nX][1]+" Vencto Real: "+a2VetorPa[nX][2]+" Prefixo/Titulo/Parcela: "+a2VetorPa[nX][3]+"/"+a2VetorPa[nX][4]+"/"+a2VetorPa[nX][5]+" Titulo: "+Alltrim(+a2VetorPa[nX][6])+" Saldo: "+Alltrim(+a2VetorPa[nX][7])+CRLF
		Next

		//U_EnvEmail(cDestEmail,_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)

	Endif

	RestArea(aAreaSD1)

Return

/******************************************************************
Busca Solicitacoes de Adiantamento pendentes e liberadas.
*******************************************************************/
Static Function SeekAdto(aVetorPA)

	Local aAreaZZE  := ZZE->( GetArea() )
	Local cSqlAlias := GetNextAlias()
	Local cQuery    := ''

	cQuery+= "SELECT R_E_C_N_O_ AS REGSA FROM "+RetSqlName("ZZE") + " "+CRLF
	cQuery+= "WHERE ZZE_FORNEC = '"+SF1->F1_FORNECE+"' "+CRLF
	cQuery+= "AND ZZE_STATUS IN ('P','L') "+CRLF
	cQuery+= "AND D_E_L_E_T_ = ' '"
	If Select(cSqlAlias) > 0
		DbSelectArea(cSqlAlias)
		DbCloseArea()
	Endif
	Dbusearea( .T. ,"TOPCONN",TCGenQry(,,cQuery),cSqlAlias, .F. , .T. )
	(cSqlAlias)->( DbGotop() )
	While (cSqlAlias)->( !Eof() )
		ZZE->( DbGoto( (cSqlAlias)->REGSA ) )
		aAdd(aVetorPa,{DTOC(ZZE->ZZE_DATA),ZZE->ZZE_NUMERO,Transform(ZZE->ZZE_VALOR,"@e 999,999,999.99"),Iif( ZZE->ZZE_STATUS='P', "PENDENTE APROVACAO","LIBERADO"), ZZE->ZZE_HISTOR})
		(cSqlAlias)->( DbSkip() )
	End-While

	// Fecha o temporario
	DbSelectArea(cSqlAlias)
	DbCloseArea()
	// Restaura area do SE2
	RestArea(aAreaZZE)
Return


/******************************************************
Busca adiantamentos no SE2
*******************************************************/
Static Function SeekTitulos(a2VetorPa)

	Local aAreaSE2:= SE2->( GetArea() )
	Local cQuery:= ""

	cQuery:= "SELECT R_E_C_N_O_ AS REGPA FROM "+RetSqlName("SE2")+" "+CRLF
	cQuery+= "WHERE E2_FORNECE = '"+SF1->F1_FORNECE+"' "+CRLF
	cQuery+= "AND E2_TIPO = 'PA' "+CRLF
	cQuery+= "AND E2_SALDO > 0 "+CRLF
	cQuery+= "AND D_E_L_E_T_ = ' '"
	If Select("TRMT100") > 0
		DbSelectArea("TRMT100")
		DbCloseArea()
	Endif
	Dbusearea( .T. ,"TOPCONN",TCGenQry(,,cQuery),"TRMT100", .F. , .T. )
	TRMT100->( DbGotop() )
	While TRMT100->( !Eof() )
		SE2->( DbGoto( TRMT100->REGPA ) )
		aAdd(a2VetorPa,{DTOC(SE2->E2_EMISSAO),DTOC(SE2->E2_VENCREA),SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,Transform(SE2->E2_VALOR,"@e 999,999,999.99"),Transform(SE2->E2_SALDO,"@e 999,999,999.99")})
		TRMT100->( DbSkip() )
	End-While

	// Fecha temporario.
	DbSelectArea("TRMT100")
	DbCloseArea()
	// Restaura area do SE2
	RestArea(aAreaSE2)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraOP    ºAutor  ³Sergio Celestino    º Data ³  02/26/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para gerar saldo em estoque do produto utilizado     º±±
±±º          ³na Venda quando diferente do produto de compra (Estrutura   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraOP

	Local aMata650   	:={}
	Local aMata250   	:={}
	Local cNumOp     	:= GetNumSc2()
	Local nSequen    	:= 1
	Local aAreaSD1   	:=  SD1->( GetArea() )
	Local aAreaSB1   	:=  SB1->( GetArea() )
	Local aAreaSG1   	:=  SG1->( GetArea() )
	Local aAreaSC2   	:=  SC2->( GetArea() )
	Local aColsBkp   	:= aClone(aCols)
	Local aHeadBkp   	:= aClone(aHeader)
	Local nPosPROD   	:= 0
	Local cItem      	:= "01"
	Local _cTpMovto		:= Substr(GetMV('MV_TPMOV',,'237'),1,3)

	Private nTipo    := 1         //Variavel Declarada devido erro no MsExecAuto Mata250
	Private aPeriodos:=Array(1)   //Variavel Declarada devido erro no MsExecAuto Mata250
	Private aPergs711:=Array(30)  //Variavel Declarada devido erro no MsExecAuto Mata650
	Private lMsErroAuto := .F.

	nPosProd  := aScan(aHeadBkp,{|x| Upper(AllTrim(x[2]))=='D1_COD'})
	nPosQtd   := aScan(aHeadBkp,{|x| Upper(AllTrim(x[2]))=='D1_QUANT'})

	aPeriodos[1] := CTOD("  /  /  ")

	Pergunte("MTA712",.F.)
	For nz:=1 to 30
		aPergs711[nz]:=&("mv_par"+StrZero(nz,2))
	Next nz

	Begin Transaction

		For nY := 1 To Len(aColsBkp)

			If !aColsBkp[nY][Len(aHeadBkp)+1]

				DbSelectArea("SB1")
				SB1->( DbSetOrder(1) )
				If SB1->( DbSeek(FwFilial("SB1") + Alltrim(aColsBkp[nY][nPosProd]) ) ) .And. SB1->B1_CONVUN == "1"

					DbSelectArea("SG1")
					SG1->( DbSetOrder(2) )//FILIAL+COMPONENTE+CODIGO
					SG1->( DbSeek( FwFilial("SG1") + Alltrim(aColsBkp[nY][nPosProd]) )  )

					SB1->( DbSetOrder(1) )
					SB1->( DbSeek( FwFilial("SB1") + SG1->G1_COD )  )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Obtem numero da proxima OP                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea("SC2")
					SC2->( DbSetOrder(1) )
					While SC2->( DbSeek(FwFilial("SC2")+AllTrim(cNumOp)) ) //+cItem)
						// Incrementa numeracao da OP
						cNumOp := Soma1(cNumOp)
					End-While

					//-- Monta array para utilizacao da Rotina Automatica
					aMata650  := {}
					aMata650  := 	{ 														      ;
						{'C2_NUM'       ,cNumOp                            		,NIL},;
						{'C2_ITEM'     ,cItem                                  	,NIL},;
						{'C2_SEQUEN'   ,StrZero(nSequen,Len(SC2->C2_SEQUEN))  	,NIL},;
						{'C2_PRODUTO'  ,SB1->B1_COD                            	,NIL},;
						{'C2_LOCAL'    ,RetFldProd(SB1->B1_COD,"B1_LOCPAD")    	,NIL},;
						{'C2_QUANT'    ,(aColsBkp[nY][nPosQtd]*SB1->B1_QB)     	,NIL},;
						{'C2_UM'       ,SB1->B1_UM	                           	,NIL},;
						{'C2_CC'       ,SB1->B1_CC	                          	,NIL},;
						{'C2_DATPRI'   ,dDataBase                              	,NIL},;
						{'C2_DATPRF'   ,dDataBase                              	,NIL},;
						{'C2_REVISAO'  ,SB1->B1_REVATU                         	,NIL},;
						{'C2_TPOP'     ,"F"                                    	,NIL},;
						{'C2_EMISSAO'  ,dDataBase                              	,NIL},;
						{'C2_ROTEIRO'  ,SB1->B1_OPERPAD                        	,NIL},;
						{'C2_SEQMRP'   ,""                                     	,Nil},;
						{'MRP'         ,'N'                                    	,NIL},;
						{'AUTEXPLODE'  ,'S'                                    	,NIL}}

					//-- Chamada da rotina automatica
					msExecAuto({|x,Y| Mata650(x,Y)},aMata650,3)

					// Mostra Erro na geracao de Rotinas automaticas
					If lMsErroAuto
						RollBackSX8()
						Mostraerro()
					Else

						ConfirmSx8()
						aMata250:={}
						aAdd(aMata250,	{																		  ;
							{'D3_TM'     ,_cTpMovto                 							,Nil},;
							{'D3_COD'    ,SB1->B1_COD                                         	,Nil},;
							{'D3_UM'     ,SB1->B1_UM                                          	,Nil},;
							{'D3_QUANT'  ,(aColsBkp[nY][nPosQtd]*SB1->B1_QB)                  	,Nil},;
							{'D3_LOCAL'  ,RetFldProd(SB1->B1_COD,"B1_LOCPAD")                 	,Nil},;
							{'D3_EMISSAO',dDataBase                                            	,Nil},;
							{'D3_TIPO'   ,SB1->B1_TIPO                                         	,Nil},;
							{'D3_CF'     ,'PR0'                                               	,Nil},;
							{'D3_OP'     ,cNumOp+cItem + StrZero(nSequen,Len(SC2->C2_SEQUEN))	,Nil},;
							{'D3_DOC'    ,cNumOp                                               	,Nil},;
							{'D3_CHAVE'  ,'R0'                                                 	,Nil},;
							{'D3_PARCTOT','T'                                                  	,Nil}})

						//-----------------------------------------------------------------------------
						// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019 Incluido
						// Inicializador padrão no campo com valor -> USRRETNAME(RETCODUSR())
						//------------------------------------------------------------------ { Inicio }

						//{'D3_USUARIO',_NomeUsr 				                              	,Nil}})

						//{ Fim } ---------------------------------------------------------------------

						MSExecAuto({|x,y| mata250(x,y)},aMata250[1],3)
						If lMsErroAuto
							RollBackSX8()
							Mostraerro()
						Else
							ConfirmSx8()
						EndIf

					EndIf

				Endif

			EndIf

		Next

	End Transaction

	// Restaura area original
	aCols:= aColsBkp
	aHeader:= aHeadBkp

	RestArea(aAreaSD1)
	RestArea(aAreaSB1)
	RestArea(aAreaSG1)
	RestArea(aAreaSC2)

Return( Nil )

//admpessoal@t4f.com.br
