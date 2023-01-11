#INCLUDE "Protheus.ch"

/*
____________________________________________________________________________
Programa: Ret_PRE			Autor: Bruno D. Borges			Data: 03/01/2008
Descricao: Funcao que retorna a conta PRE-OPERATIVA nos LPs
____________________________________________________________________________
*/
User Function Ret_PRE(cConta,cTipoConta,cForcaPre,cCodLP,cSeqLP)
	//U_Ret_PRE("5310010001","C",SD1->D1_PREOPER,"650","014")
	Local aAreaBKP 	:= GetArea()
	Local aAreaCT5	:= CT5->(GetArea())
	Local aAreaCTD	:= CTD->(GetArea())
	Local aAreaCT1	:= CT1->(GetArea())
	Local aAreaSC5	:= SC5->(GetArea())
	Local aAreaSD2	:= SD2->(GetArea())
	Local cRetorno	:= cConta
	Local cElemPep	:= ""
	/////////////////////////////////////////////////////////////
	// Altera��o solicitada T4F - Pr�-Operativo
	// Autor| Denis Dias
	// Data | 25/08/2015
	/////////////////////////////////////////////////////////////
	Local __mv_CTD  := GetNewPar("MV_XOPER1","OGGGF159999/1109010004;")
	Local nY 		:= 0
	Local nX		:= 0
	Local __elemenP := {}
	Local __elemenP1:= {}
	Local __elemenP2:= {}

	//Forca posicionar no CT5
	dbSelectArea("CT5")
	CT5->(dbSetOrder(1))
	CT5->(dbSeek(xFilial("CT5")+cCodLP+cSeqLP))

	Default cForcaPre	:= "R"

	If AllTrim(Upper(cTipoConta)) == "D"
		cElemPep := AllTrim(&(CT5->CT5_ITEMD))
	ElseIf AllTrim(Upper(cTipoConta)) == "C"
		cElemPep := AllTrim(&(CT5->CT5_ITEMC))
	EndIf

	__elemenP := StrTokArr(__mv_CTD,";")
	For nY := 1 to len(__elemenP)
		__elemenP1 := StrTokArr(__elemenP[nY],"/")
		For nX := 1 to len(__elemenP1)
			If( len(__elemenP1) = 2 )
				aAdd( __elemenP2, { __elemenP1[1],__elemenP1[2] } )
				__elemenP1 := {}
				exit
			EndIf
		Next nX
	Next nY

	If !Empty(cElemPep)
		dbSelectArea("CTD")
		CTD->(dbSetOrder(1))
		If CTD->(dbSeek(xFilial("CTD")+cElemPep))
			//������������������������������������������������������������������������������������?
			//?Adicionado o tratamento:                                                           ?
			//? e o lancamento for realizado em uma data menor do que a data do evento            ?
			//? o mes for menor do que a data do evento o lacamento dever?cair no pr?operativo    ?
			//������������������������������������������������������������������������������������?
			If cForcaPre == "R"  //Regra Data
				If DToS(dDataBase) < DToS(CTD->CTD_DTEVEN)
					//tratamento para pre-operativo longo prazo,
					//para lancamentos realizados com mais de um ano de antecedencia ao evento
					if dDataBase <= CTD->CTD_DTEVEN - 365
						cRetorno := getNewPar("MV_PREOPLP", "1204010001")
					elseif substr(dtos(dDataBase), 1, 6) < substr(dtos(CTD->CTD_DTEVEN), 1, 6)
						cRetorno := Posicione("CT1",1,xFilial("CT1")+AllTrim(cConta),"CT1->CT1_CTAPRE")
					
					endif
				EndIf
			ElseIf cForcaPre == "F" //Forca Pre-Operativo
				cRetorno := Posicione("CT1",1,xFilial("CT1")+AllTrim(cConta),"CT1->CT1_CTAPRE")
			EndIf
		EndIf
	EndIf

	/////////////////////////////////////////////////////////////
	// Altera��o solicitada T4F - Pr�-Operativo
	// Autor| Denis Dias
	// Data | 25/08/2015
	/////////////////////////////////////////////////////////////
	If( len(__elemenP2) > 0 )
		For nY := 1 to len(__elemenP2)
			If( len(__elemenP2[nY]) = 2 .And. At(alltrim(CTD->CTD_ITEM),__elemenP2[nY,1]) > 0 )  //Posi��o referente ao Item Cont�abil
				cRetorno := alltrim(__elemenP2[nY,2]) //Posicao referente a Conta Cont�bil conforme parametro
				exit
			EndIf
		Next nY
	EndIf

	If Empty(cRetorno) .and. SD2->D2_TES$'625*631' .AND. cCodLP+cSeqLP='610022'  // Condi��o solicitada pelo departamento Fiscal pois na partida dobrada n�o mostrava a conta a d�bito da Vicar
		cRetorno := '2105060001'
	EndIf

	If SD2->D2_TES$'625' .AND. cCodLP+cSeqLP='610021'  // Condi��o solicitada pelo departamento Fiscal em 10/09/2020 para buscar a conta cr�dito do campo B1_CONTA
		cRetorno := SB1->B1_CONTA
	EndIf

	// Condi��o para reter PIS e Cofins nas entradas nas contas corretas
	if "99"$cElemPep
		IF trim(cConta) <> "5310010001"
			cElemPep := " "
		endif
		cDtEpep := "20200101"
	Else
		//	cDtEpep := "20"+substr(cElemPep,6,6) Altera��o Efetuada por Lucas Valins para ler a data do evento ao inv�s do c�digo.
		cDtEpep := Dtos(CTD_DTEVEN)
	endif
	//Altera�ao solicitada Mar�o 2020 - alterado por LE
	if  !empty(cElemPep) .and. (firstday(dDataBase) >= firstday(stod(cDtEpep)) .and. (ALLTRIM(SD1->D1_PREOPER)="R")) .or. (ALLTRIM(SD1->D1_COD)<>"170603332" .and. ALLTRIM(SD1->D1_COD)<>"201202840") .or. substring(cElemPep,8,3)="999" // Se n�o for EPEP futuro retirada a regra para todos pr� operativos, somente produtos espec�ficos.
		If cTipoConta="C" .and. (cCodLP+cSeqLP='650014' .or. cCodLP+cSeqLP='650015' .or. cCodLP+cSeqLP='650027' .or. cCodLP+cSeqLP='650028' .or. cCodLP+cSeqLP='651005' .or. cCodLP+cSeqLP='651006')
			if cSeqLP $ '014*027' .or. cCodLP+cSeqLP='651005'  // PIS
				cRetorno := left(sb1->b1_ctacust,6)+'9998'
			endif
			if cSeqLP $ '015*028' .or. cCodLP+cSeqLP='651006'  //Cofins
				cRetorno := left(sb1->b1_ctacust,6)+'9997'
			endif
		ElseIf cTipoConta="D" .and. (cCodLP+cSeqLP='655014' .or. cCodLP+cSeqLP='655015' .or. cCodLP+cSeqLP='655027' .or. cCodLP+cSeqLP='655028')
			if cSeqLP $ '014*027'
				cRetorno := left(sb1->b1_ctacust,6)+'9998'
			endif
			if cSeqLP $ '015*028' .or. cCodLP+cSeqLP='651006'  //Cofins
				cRetorno := left(sb1->b1_ctacust,6)+'9997'
			endif
		EndIf
	Endif

	If Empty(cRetorno)
		cRetorno := cConta
	EndIf

	RestArea(aAreaSD2)
	RestArea(aAreaCT5)
	RestArea(aAreaCTD)
	RestArea(aAreaCT1)
	RestArea(aAreaBKP)
	RestArea(aAreaSC5)

Return(cRetorno)
!Empty
