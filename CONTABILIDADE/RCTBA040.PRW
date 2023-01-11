#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCTBA040 ºAutor  ³Bruno Daniel Borges º Data ³  31/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de importacao dos lancamentos contabeis de Bilheteriaº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCTBA040(cFileTXT)
	Default cFileTXT := ""

	//Chamada direto via MENU
	If Empty(cFileTXT)
		cFileTXT	:= cGetFile(,"Selecione o Arquivo Bilheteria", 1, 'C:\TEMP\', .F.,GETF_LOCALHARD,.T., .t.)
		//    targetDir := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar, nOpcoes, lArvore)
		//                   cGetFile( '*.txt' , 'Textos (TXT)', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

	EndIf

	If Empty(cFileTXT)
		Return(Nil)
	EndIf

	Processa({|| RCTBA040_Prc(cFileTXT)})

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBA040_PrcºAutor  ³Bruno Daniel Borges º Data ³  31/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de importacao do arquivo TEXTO                         º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RCTBA040_Prc(cFileTXT)
	//Local nHdlTXT	:= 0
	Local cLinha	:= ""
	Local nUltPos	:= 1  
	Local nQtdLin	:= 0 
	Local aColums	:= {} 
	Local cLote		:= GetMv("MV_XLOTECT",,"009000")
	Local lPadrao	:= VerPadrao("013")  
	Local nHeadProv	:= 0 
	Local cArqCTB	:= ""   
	Local cArqTMP	:= ""
	Local nTotal	:= 0  
	Local aEstrut	:= {}  
	Local i			:= 0 
	Local nQtdLctos	:= 0

	Private nValor1	:= 0
	Private nValor2	:= 0
	Private nValor3	:= 0
	Private nValor4	:= 0
	Private cElePep	:= ""
	Private cCC		:= ""
	Private oTMPTable

	If !lPadrao
		MsgAlert("Atenção, as sequeências do lançamento padrão 013 não estão cadastradas. Não será possível contabilizar o arquivo importado.")
		Return(Nil)
	EndIf   

	//Estrutura do arquivo Temporario
	Aadd(aEstrut,{"HIST"		,"C",40,00})
	Aadd(aEstrut,{"INGRESSOS"	,"N",14,02})
	Aadd(aEstrut,{"CONVENIEN"	,"N",14,02})
	Aadd(aEstrut,{"ENTREGA"		,"N",14,02})
	Aadd(aEstrut,{"TOTALLC"		,"N",14,02})
	Aadd(aEstrut,{"ELEPEP"		,"C",20,00})
	Aadd(aEstrut,{"CC"			,"C",20,00})

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	cArqTMP	:= CriaTrab(aEstrut,.T.)     
	Iif(Select("TMP_CTB") > 0, TMP_CTB->(dbCloseArea()),Nil)
	dbUseArea(.T.,, cArqTMP,"TMP_CTB",.T.)
	*/
	Iif(Select("TMP_CTB") > 0, TMP_CTB->(dbCloseArea()),Nil)
	
	oTMPTable:= FWTemporaryTable():New("TMP_CTB")
	oTMPTable:SetFields( aEstrut )
	oTMPTable:Create()	
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	
	
	dbSelectArea("TMP_CTB")

	FT_FUSE(cFileTXT)
	FT_FGoTop()

	aColums := {}

	While !FT_FEof()
		cLinha 	:= FT_FReadLn()

		nQtdLin++

		If nQtdLin <= 1
			FT_FSkip()
			Loop
		EndIf  

		Aadd(aColums,{})	
		nUltPos := 1
		//Recorta as colunas do arquivo
		For i := 1 To Len(cLinha)
			If SubStr(cLinha,i,1) == ";" .Or. i == Len(cLinha) 
				If i <> Len(cLinha) 
					AAdd(aColums[Len(aColums)],REPLACE(    SubStr(cLinha,nUltPos,i - nUltPos) , ";",""  ))
				Else
					AAdd(aColums[Len(aColums)],REPLACE(    SubStr(cLinha,nUltPos) , ";",""  ))
				EndIf
				nUltPos := i+1
			EndIf
		Next i

		FT_FSkip()
	EndDo 

	ProcRegua(Len(aColums))

	//Geracao dos lancamentos contabeis
	nHeadProv := HeadProva(cLote,"RCTBA040",Substr(cUsuario,7,6),@cArqCTB)

	//Geracao das linhas do lancamento contabeis
	For i := 1 To Len(aColums)
		dbSelectArea("TMP_CTB")
		TMP_CTB->(RecLock("TMP_CTB",.T.))
		TMP_CTB->HIST		:= AllTrim(aColums[i,1])
		TMP_CTB->INGRESSOS	:= Iif(AllTrim(aColums[i,2]) == "-",0,Val(StrTran(aColums[i,2],",",".")))
		TMP_CTB->CONVENIEN	:= Iif(AllTrim(aColums[i,3]) == "-",0,Val(StrTran(aColums[i,3],",",".")))
		TMP_CTB->ENTREGA	:= Iif(AllTrim(aColums[i,4]) == "-",0,Val(StrTran(aColums[i,4],",",".")))
		TMP_CTB->TOTALLC	:= Iif(AllTrim(aColums[i,5]) == "-",0,Val(StrTran(aColums[i,5],",",".")))
		TMP_CTB->ELEPEP		:= AllTrim(aColums[i,6])
		TMP_CTB->CC			:= AllTrim(aColums[i,7])
		TMP_CTB->(MsUnlock())

		nTotal += DetProva(nHeadProv,"013","RCTBA040",cLote)
		nQtdLctos++

		//Encerra o documento e exibe os dados na tela
		If nQtdLctos >= 220
			RodaProva(nHeadProv,nTotal)
			cA100Incl(cArqCTB,nHeadProv,3,cLote,.T.,.F.)

			//Inicia um novo documento
			cArqCTB		:= ""
			nHeadProv 	:= HeadProva(cLote,"RCTBA040",Substr(cUsuario,7,6),@cArqCTB)
			nTotal		:= 0
			nQtdLctos 	:= 0
		EndIf

	Next i

	If nTotal > 0
		RodaProva(nHeadProv,nTotal)
		cA100Incl(cArqCTB,nHeadProv,3,cLote,.T.,.F.)

		TMP_CTB->(dbCloseArea())
		FErase(cArqTMP)
	EndIF

Return(Nil)