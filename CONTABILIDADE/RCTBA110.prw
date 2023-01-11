#INCLUDE "Protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTBA110 บAutor  ณBruno Daniel Borges บ Data ณ  01/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de cadastro dos percentuais de apropriacao por ele-  บฑฑ
ฑฑบ          ณmento PEP e periodo                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function RCTBA110()
	
	Local aCores := {	{ "CTD_BLOQ == '1'" , "BR_VERMELHO"	},; 
						{ "CTD_BLOQ == '2' .AND. ( ( Empty( CTD_DTEXIS ) .Or. CTD_DTEXIS <= dDatabase ) .AND. ( Empty( CTD_DTEXSF ) .Or. CTD_DTEXSF >= dDatabase ) )" , "BR_VERDE"   	},; 
						{ "CTD_BLOQ == '2' .AND. ( ! Empty( CTD_DTEXIS ) .AND. CTD_DTEXIS >= dDatabase )" , "BR_AMARELO"	},; 
						{ "CTD_BLOQ == '2' .AND. ( ! Empty( CTD_DTEXSF ) .AND. CTD_DTEXSF <= dDatabase )" , "BR_CINZA"		} } 

	Private aRotina := {	{ OemToAnsi("Pesquisar")		,"AxPesqui"  ,0 , 1},;  
							{ OemToAnsi("Visualizar")		,"AxVisual"  ,0 , 2},;  
							{ OemToAnsi("Percentuais")		,"U_CTBA110A",0 , 4},;  
							{ OemToAnsi("Legenda")			,"U_CTBA110B",0 , 6} }

	Private cCadastro := CtbSayApro("CTD")  //"Cadastro Itens Contabeis"

	mBrowse( 6, 1,22,75,"CTD",,,,,,aCores)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBA110  บAutor  ณBruno Daniel Borges บ Data ณ  01/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de manutencao no cadastro                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RCTBA110                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBA110A(x,y,nOpcBrw)
	Local oDlgMain      := Nil
	Local aCoordenadas  := MsAdvSize(.T.)
	Local aHeader       := {}
	Local aCols         := {} 
	Local nOpcClick     := 0    
	Local nPosPeriodo   := 0
	Local lAltera       := .F.  
	Local i,j 

	Private oGetDados	:= Nil

	//Carrega os arrays da NewGetDados
	dbSelectArea("ZZZ")
	ZZZ->(dbSetOrder(1))
	lAltera := ZZZ->(dbSeek(xFilial("ZZZ")+AllTrim(CTD->CTD_ITEM),.F. ))
	aHeader := Ret_Head_Cols("ZZZ",Iif(lAltera,4,3),1,xFilial("ZZZ")+AllTrim(CTD->CTD_ITEM),"ZZZ->ZZZ_FILIAL+AllTrim(ZZZ->ZZZ_ELEPEP)")[1]
	aCols   := Ret_Head_Cols("ZZZ",Iif(lAltera,4,3),1,xFilial("ZZZ")+AllTrim(CTD->CTD_ITEM),"ZZZ->ZZZ_FILIAL+AllTrim(ZZZ->ZZZ_ELEPEP)")[2]

	If lAltera

	EndIf

	oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6]/1.5,aCoordenadas[5]/1.5,OemToAnsi("% Apropria็ใo Pr้-Operativo"),,,,,,,,oMainWnd,.T.)
	oGetDados := MsNewGetDados():New(014,001,oDlgMain:nClientHeight/2-35,oDlgMain:nClientWidth/2-3,GD_INSERT+GD_DELETE+GD_UPDATE,,,"",,,9999,,,,oDlgMain,aHeader,aCols)		
	oGetDados:bLinhaOk := {|| CTBA110D(1) }
	oGetDados:bTudoOk  := {|| CTBA110D(2) }

	EnchoiceBar(oDlgMain,{|| IIf(oGetDados:TudoOk(),nOpcClick := 1,nOpcClick := 0), Iif(nOpcClick == 1,oDlgMain:End(),Nil) },{|| oDlgMain:End()},,)
	oDlgMain:Activate(,,,.T.)  

	//Gravacao dos Dados
	If nOpcClick == 1
		dbSelectArea("ZZZ")
		ZZZ->(dbSetOrder(1))
		nPosPeriodo := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZZ_MESANO"  })

		For i := 1 To Len(oGetDados:aCols)
			If ZZZ->(dbSeek(xFilial("ZZZ")+AllTrim(CTD->CTD_ITEM)+Space(20-Len(AllTrim(CTD->CTD_ITEM)))+oGetDados:aCols[i][nPosPeriodo]  )) 
				ZZZ->(RecLock("ZZZ",.F.))
				If oGetDados:aCols[i][Len(oGetDados:aHeader)+1]
					ZZZ->(dbDelete())
					ZZZ->(MsUnlock())
					Loop
				EndIf
			ElseIf !ZZZ->(dbSeek(xFilial("ZZZ")+AllTrim(CTD->CTD_ITEM)+Space(20-Len(AllTrim(CTD->CTD_ITEM)))+oGetDados:aCols[i][nPosPeriodo]  )) .And. !oGetDados:aCols[i][Len(oGetDados:aHeader)+1]
				ZZZ->(RecLock("ZZZ",.T.))
			Else
				Loop
			EndIf

			ZZZ->ZZZ_FILIAL := xFilial("ZZZ")
			ZZZ->ZZZ_ELEPEP := CTD->CTD_ITEM

			For j := 1 To Len(oGetDados:aHeader)
				ZZZ->&(oGetDados:aHeader[j,2]) := oGetDados:aCols[i,j]
			Next j

			ZZZ->(MsUnlock())
		Next i
	EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRet_Head_ColsบAutor  ณBruno Daniel Borges บ Data ณ  09/06/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que monta um aHeader e aCols de um determinado ALIAS    บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ret_Head_Cols(cAlias,nOpcBrowse,nIndice,cExpressao,cCondicao)
	Local aAreaBKP		:= GetArea()  
	Local aHeader		:= {}
	Local aCols			:= {}
	Local _aCMP			:= {"ZZZ_FILIAL","ZZZ_ELEPEP","ZZZ_MESANO","ZZZ_PERC","ZZZ_ACUMUL","ZZZ_STATUS"} 
	Local i, nI
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	//Monta o aHeader
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(cAlias))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			Aadd(aHeader,	{	Trim(X3Titulo())				,;
								SX3->X3_CAMPO					,;
								SX3->X3_PICTURE					,; 
								SX3->X3_TAMANHO					,;
								SX3->X3_DECIMAL					,;
								SX3->X3_VALID					,;
								SX3->X3_USADO					,;
								SX3->X3_TIPO					,;
								SX3->X3_F3						,;
								SX3->X3_CONTEXT					,;
								SX3->X3_CBOX					,;
																,;
								SX3->X3_WHEN					,;
								SX3->X3_VISUAL					,;
								SX3->X3_VLDUSER					,;
								SX3->X3_PICTVAR					,;
								SX3->X3_OBRIGAT					})	     
		EndIf

		SX3->(dbSkip())
	EndDo    
	*/
	//Monta o aHeader
	For nI := 1 to Len(_aCMP)

		If X3Uso(GetSX3Cache(aCmp[nI],"X3_USADO")) .And. cNivel >= GetSX3Cache(aCmp[nI],"X3_NIVEL")

			Aadd(aHeadNfs,{ Trim( X3Titulo() )						,;
							GetSX3Cache(aCmp[nI],"X3_CAMPO"		)	,;
							GetSX3Cache(aCmp[nI],"X3_PICTURE"	)	,;
							GetSX3Cache(aCmp[nI],"X3_TAMANHO"	)	,;
							GetSX3Cache(aCmp[nI],"X3_DECIMAL"	)	,;
							GetSX3Cache(aCmp[nI],"X3_VALID"		)	,;
							GetSX3Cache(aCmp[nI],"X3_USADO"		)	,;
							GetSX3Cache(aCmp[nI],"X3_TIPO"		)	,;
							GetSX3Cache(aCmp[nI],"X3_F3"		)	,;
							GetSX3Cache(aCmp[nI],"X3_CONTEXT" 	)	,;
							GetSX3Cache(aCmp[nI],"X3_CBOX"		)	,;
																	,;
							GetSX3Cache(aCmp[nI],"X3_WHEN"		)	,;
							GetSX3Cache(aCmp[nI],"X3_VISUAL"	)	,;
							GetSX3Cache(aCmp[nI],"X3_VLDUSER"	)	,;
							GetSX3Cache(aCmp[nI],"X3_PICTVAR"	)	,;
							GetSX3Cache(aCmp[nI],"X3_OBRIGAT"	)	})	     
		EndIf

	Next nI
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	//Monta o aCols    
	If nOpcBrowse == 3
		AAdd(aCols,Array(Len(aHeader)+1))
		For i := 1 To Len(aHeader)
			aCols[Len(aCols)][i] := CriaVar(aHeader[i,2])
		Next i
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
	Else 
		dbSelectArea(cAlias)
		(cAlias)->(dbSetOrder(nIndice))
		(cAlias)->(dbSeek(cExpressao))
		While (cAlias)->(!Eof()) .And. &(cCondicao) == cExpressao
			AAdd(aCols,Array(Len(aHeader)+1))
			For i := 1 To Len(aHeader)
				If aHeader[i,10] <> "V"
					aCols[Len(aCols)][i] := &(aHeader[i,2])
				Else
					aCols[Len(aCols)][i] := CriaVar(aHeader[i,2])
				EndIf
			Next i
			aCols[Len(aCols)][Len(aHeader)+1] := .F.

			(cAlias)->(dbSkip())
		EndDo
	EndIf

	RestArea(aAreaBKP)

Return({aHeader,aCols})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CTBA110B บAutor  ณBruno Daniel Borges บ Data ณ  01/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de LEGENDA do Browse                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RCTBA110                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBA110B()

	BrwLegenda("Legenda","Elemento PEP",{	{ "BR_VERDE"    , "Sem Restri็ใo"},;  
	{ "BR_VERMELHO" , "Bloqueado"},;  
	{ "BR_AMARELO"	, "Exercicio Nใo Inciado"},;  
	{ "BR_CINZA"	, "Exercicio Finalizado"}})  

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CTBA110C บAutor  ณBruno Daniel Borges บ Data ณ  01/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de gatilho do percentual acumulado                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RCTBA110                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBA110C()
	Local i           := 0
	Local nPosPeriodo := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZZ_MESANO" }) 
	Local nPosAcumulad:= AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZZ_ACUMUL" })
	Local cPeriodo    := SubStr(oGetDados:aCols[oGetDados:nAt][nPosPeriodo],3,4)+SubStr(oGetDados:aCols[oGetDados:nAt][nPosPeriodo],1,2)
	Local cPerAnterior:=""
	Local nAcumulado  := 0
	Local nRetorno    := 0

	For i := 1 To Len(oGetDados:aCols)
		If i >= oGetDados:nAt
			Exit
		EndIf                   

		If SubStr(oGetDados:aCols[i][nPosPeriodo],3,4)+SubStr(oGetDados:aCols[i][nPosPeriodo],1,2) < cPeriodo .And. cPeriodo > cPerAnterior
			cPerAnterior := SubStr(oGetDados:aCols[i][nPosPeriodo],3,4)+SubStr(oGetDados:aCols[i][nPosPeriodo],1,2)
			nAcumulado   := oGetDados:aCols[i][nPosAcumulad]
		EndIf
	Next i   

	nRetorno := nAcumulado + M->ZZZ_PERC

Return(nRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CTBA110D บAutor  ณBruno Daniel Borges บ Data ณ  01/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do LINHAOK e TUDOOK                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RCTBA110                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTBA110D(nTipoVld)

	Local nPosPeriodo := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZZ_MESANO" })
	Local nPosPerc    := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZZ_PERC" })
	Local nPosAcumul  := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZZ_ACUMUL" })  
	Local nTotal      := 0
	Local i 

	//Linha OK
	If nTipoVld == 1
		If Empty(oGetDados:aCols[oGetDados:nAt][nPosPeriodo]) .Or. oGetDados:aCols[oGetDados:nAt][nPosPerc] <= 0 .Or. oGetDados:aCols[oGetDados:nAt][nPosAcumul] > 100
			MsgAlert("Aten็ใo, existem incoformidades com essa linha. Verifique o conteudo dos campos.")
			Return(.F.)                                                                                
		EndIf

		//Tudo OK
	Else
		For i := 1 To Len(oGetDados:aCols)
			If !oGetDados:aCols[i][Len(oGetDados:aHeader)+1]
				nTotal += oGetDados:aCols[i][nPosPerc]
			EndIf
		Next i

		If nTotal <> 100
			MsgAlert("Aten็ใo, a soma dos percentuais entre os periodos nใo totaliza 100%. Verifique antes da gravacao.")
			Return(.F.)
		EndIf
	EndIf

Return(.T.)                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CTBA110E บAutor  ณBruno Daniel Borges บ Data ณ  01/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBaixa do Pre-Operativo por Periodo (Mes/Ano)                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RCTBA110                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBA110E()
	Local aPerguntas := {}    
	Local aBotoes    := {}
	Local aSays	     := {}
	Local nOpcao     := 0 

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	//Parametros da rotina
	Aadd(aPerguntas,{"RCTBA1","01","Periodo A Considerar (Mes/Ano)"	,"mv_ch1"	,"C",06,00,"G","","mv_par01","","","","","","","@R 99/9999"})
	Aadd(aPerguntas,{"RCTBA1","02","Do Elemento PEP"	   	  			,"mv_ch2"	,"C",20,00,"G","","mv_par02","","","","","","CTD",""})
	Aadd(aPerguntas,{"RCTBA1","03","Ate o Elemento PEP"	   	  		,"mv_ch3"	,"C",20,00,"G","","mv_par03","","","","","","CTD",""})
	Aadd(aPerguntas,{"RCTBA1","04","Contra Pr้-Operativo"	   	  		,"mv_ch4"	,"C",20,00,"G","","mv_par04","","","","","","CT1",""})
	Aadd(aPerguntas,{"RCTBA1","05","Contra Redutora"	   	  		    ,"mv_ch5"	,"C",20,00,"G","","mv_par05","","","","","","CT1",""})
	ValidSX1(aPerguntas)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	
	Pergunte("RCTBA1",.F.)

	//Tela de aviso e acesso aos parametros
	AAdd(aSays,"[APROPRIAวรO DE PRษ-OPERATIVO]")
	AAdd(aSays,"Esse programa irแ gerar os lan็amentos contแbeis de apropria็ใo")
	AAdd(aSays,"das despesas Pr้-Operativas conforme % de apropria็ใo definido")
	AAdd(aSays,"em cadastro pr้vio por Elemento PEP.")

	AAdd(aBotoes,{ 5,.T.,{|| Pergunte("RCTBA1",.T. ) } } )
	AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
	AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )        
	FormBatch( "Apropria็ใo Pr้-Operativo", aSays, aBotoes )

	If nOpcao == 1
		Processa({|| CTBA110E_Prc()})
	EndIf

Return(Nil)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBA110E_Prc บAutor  ณBruno Daniel Borges บ Data ณ  01/08/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento da apropriacao de pre-operativo                  บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RCTBA110                                                      บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTBA110E_Prc()
	Local nTotReg   := 0 
	Local nTotPer   := 0
	Local nTotRed   := 0   
	Local nPercMes  := 0
	Local nPercAcum := 0  
	Local nTotal    := 0
	Local cQuery 	:= ""
	Local bQuery    := {|| IIf(Select("TRB") > 0, TRB->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbGoTop()), TRB->(dbEval({|| nTotReg++})), TRB->(dbGoTop()) }
	Local bQuery2   := {|| IIf(Select("TRB2") > 0, TRB2->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryCT2),"TRB2",.F.,.T.), dbSelectArea("TRB2"), TRB2->(dbGoTop()) }
	Local bQuery3   := {|| IIf(Select("TRB3") > 0, TRB3->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryCT2),"TRB3",.F.,.T.), dbSelectArea("TRB3"), TRB3->(dbGoTop()) }
	Local nHeadProv := 0
	Local cArqCTB   := ""
	Local cLote		:= "001CTB"

	Private nValCusto := 0
	Private nValRedut := 0

	//Query que lista os Elementos PEP que tem % de apropriacao entre os periodos informados e nao foram apropriados anteriormente
	cQuery := " SELECT ZZZ_ELEPEP, ZZZ_PERC, ZZZ_ACUMUL "
	cQuery += " FROM " + RetSQLName("ZZZ")
	cQuery += " WHERE ZZZ_FILIAL = '" + xFilial("ZZZ") + "' AND "
	cQuery += "       ZZZ_MESANO = '" + mv_par01 + "' AND "
	cQuery += "       ZZZ_ELEPEP BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "' AND "
	cQuery += "       ZZZ_STATUS <> '2' AND D_E_L_E_T_ = ' ' " 
	Eval(bQuery)

	If TRB->(Eof())
		MsgAlert("Aten็ใo, nenhum Elemento PEP com percentuais de apropria็ใo entre o perํodo informado foi localizado com staus de NมO APROPRIADO.")
		Return(Nil)   
	Else
		ProcRegua(nTotReg)
	EndIf

	//Gera a contabilizacao por ELEMENTO PEP
	dbSelectArea("TRB")

	//Inicia a integracao contabil
	If TRB->(!Eof())
		nHeadProv := HeadProva(cLote,"RCTBA110",Substr(cUsuario,7,6),@cArqCTB)
	EndIf

	While TRB->(!Eof()) 
		IncProc("Consultando Movimentos...")

		dbSelectArea("CTD")
		CTD->(dbSetOrder(1))
		CTD->(dbSeek(xFilial("CTD")+AllTrim(TRB->ZZZ_ELEPEP),.F. ))
		If CTD->CTD_DTEVEN > dDataBase
			TRB->(dbSkip())
			Loop
		EndIf

		//Totaliza os movimentos do mes do parametro
		cQueryCT2 := " SELECT CT2_VALOR AS TOTALCT2, CT2_ATIVDE AS CT2_CREDIT, CT2_HIST, CT2_CCC, CT2_CCD, CT2_ITEMC, CT2_ITEMD, '1' AS TIPO "
		cQueryCT2 += " FROM " + RetSQLName("CT2")
		cQueryCT2 += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "' AND SUBSTR(CT2_DATA,1,6) = '" + SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2) + "' AND D_E_L_E_T_ = ' ' AND "
		cQueryCT2 += "       CT2_DEBITO = '" + AllTrim(mv_par04) + "' AND CT2_ATIVDE <> '      ' AND CT2_ITEMD = '" + AllTrim(TRB->ZZZ_ELEPEP) + "' "
		cQueryCT2 += " UNION 
		cQueryCT2 += " SELECT CT2_VALOR AS TOTALCT2, CT2_ATIVDE AS CT2_CREDIT, CT2_HIST, CT2_CCC, CT2_CCD, CT2_ITEMC, CT2_ITEMD, '2' AS TIPO "
		cQueryCT2 += " FROM " + RetSQLName("CT2")
		cQueryCT2 += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "' AND SUBSTR(CT2_DATA,1,6) < '" + SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2) + "' AND D_E_L_E_T_ = ' ' AND "
		cQueryCT2 += "       CT2_DEBITO = '" + AllTrim(mv_par04) + "' AND CT2_ATIVDE <> '      ' AND CT2_ITEMD = '" + AllTrim(TRB->ZZZ_ELEPEP) + "' "
		cQueryCT2 += " ORDER BY CT2_CREDIT "	
		Eval(bQuery2)                

		//Busca os lancamentos de pre-operativos apos o inicio do elemento pep
		If TRB2->(!Eof())
			While TRB2->(!Eof())     
				nTotPer := TRB2->TOTALCT2

				//Totaliza os SALDOS da conta REDUTORA dos meses anteriores
				cQueryCT2 := " SELECT SUM(CT2_VALOR) AS VALOR "
				cQueryCT2 += " FROM " + RetSQLName("CT2")
				cQueryCT2 += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "' AND SUBSTR(CT2_DATA,1,6) <= '" + SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2) + "' AND D_E_L_E_T_ = ' ' AND "
				cQueryCT2 += "       CT2_ITEMD = '" + AllTrim(TRB->ZZZ_ELEPEP) + "' AND "             
				cQueryCT2 += "       CT2_DEBITO = '" + TRB2->CT2_CREDIT + "' AND "
				cQueryCT2 += "       (CT2_CREDIT = '" + mv_par05 + "' OR CT2_DEBITO = '" + mv_par05 + "') "
				Eval(bQuery3)	

				nTotRed := TRB3->VALOR

				If TRB2->TIPO == "2" //Periodos anteriores
					nTotPer -= nTotRed
				EndIf

				//Busca os % do mes e acumulado
				nPercMes  := TRB->ZZZ_PERC
				nPercAcum := TRB->ZZZ_ACUMUL

				//Calculo dos totais do lancamento             
				If TRB2->TIPO == "2"
					nValCusto := (nPercAcum / 100 * nTotPer)
				Else
					nValCusto := (nPercAcum / 100 * nTotPer) + (nPercAcum / 100 * nTotRed)
				EndIf
				nValRedut := TRB2->TOTALCT2 - nValCusto + nTotRed

				//Apropria o CUSTO e Lanca o Saldo Restante na REDUTORA
				nTotal += DetProva(nHeadProv,"016","RCTBA110",cLote)

				TRB2->(dbSkip())
			EndDo
		EndIf

		//Totaliza os movimentos dos meses anteriores
		cQueryCT2 := " SELECT CT2_VALOR AS TOTALCT2, CT2_CREDIT, CT2_HIST, CT2_CCC, CT2_CCD, CT2_ITEMC, CT2_ITEMD "
		cQueryCT2 += " FROM " + RetSQLName("CT2")
		cQueryCT2 += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "' AND SUBSTR(CT2_DATA,1,6) = '" + SubStr(mv_par01,3,4)+SubStr(mv_par01,1,2) + "' AND D_E_L_E_T_ = ' ' AND "
		cQueryCT2 += "       CT2_DEBITO = '" + AllTrim(mv_par04) + "' AND CT2_ATIVDE = CT2_CREDIT AND CT2_ITEMD = '" + AllTrim(TRB->ZZZ_ELEPEP) + "' "
		Eval(bQuery2)                

		TRB->(dbSkip())
	EndDo

	//Encerra o lancamento contabil                     
	If nTotal > 0
		RodaProva(nHeadProv,nTotal)
		cA100Incl(cArqCTB,nHeadProv,3,cLote,.T.,.F.)   

		MsgAlert("Baixa de Pr้-Operativo para o periodo informado concluida.")
	Else
		MsgAlert("Aten็ใo nใo foi localizado nenhum movimento de pr้-operativo com os parโmetros informados p/ sofrerem baixa.")
	EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidSX1 บAutor  ณBruno Daniel Borges บ Data ณ  22/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que valida as perguntas do SX1 e cria os novos regis-บฑฑ
ฑฑบ          ณtros                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidSX1(aPergunt)
	Local aAreaBKP := GetArea()
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	Local cGrpPerg := ""
	Local lTipLocl := .T.
	Local i

	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	SX1->(dbGoTop())

	If Len(aPergunt) <= 0
		Return(Nil)
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValida as perguntas do usuarioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cGrpPerg := PadR(aPergunt[1,1],10)
	For i := 1 To Len(aPergunt)
		lTipLocl := !SX1->(dbSeek(Padr(cGrpPerg,10)+aPergunt[i,2]))	
		SX1->(RecLock("SX1",lTipLocl))
		SX1->X1_GRUPO		:= Padr(cGrpPerg,10)
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
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
		
	RestArea(aAreaBKP)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CTBA110F บAutor  ณBruno Daniel Borges บ Data ณ  01/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEncerramento de Elemento PEP                                บฑฑ
ฑฑบ          ณDebita REDUTORA e Credita PRE-OPERATIVO                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBA110F()
	Local aPerguntas := {}    
	Local aBotoes    := {}
	Local aSays	     := {}
	Local nOpcao     := 0 

	//Parametros da rotina
	Aadd(aPerguntas,{"RCTBAF","01","Do Elemento PEP"	   	  			,"mv_ch1"	,"C",20,00,"G","","mv_par01","","","","","","CTD",""})
	Aadd(aPerguntas,{"RCTBAF","02","Ate o Elemento PEP"	   	  			,"mv_ch2"	,"C",20,00,"G","","mv_par02","","","","","","CTD",""})
	Aadd(aPerguntas,{"RCTBAF","03","Contra Pr้-Operativo"	   	  		,"mv_ch3"	,"C",20,00,"G","","mv_par03","","","","","","CT1",""})
	Aadd(aPerguntas,{"RCTBAF","04","Contra Redutora"	   	  		    ,"mv_ch4"	,"C",20,00,"G","","mv_par04","","","","","","CT1",""})
	ValidSX1(aPerguntas)
	Pergunte("RCTBAF",.F.)

	//Tela de aviso e acesso aos parametros
	AAdd(aSays,"[ENCERRAMENTO DE ELEMENTO PEP]")
	AAdd(aSays,"Esse programa irแ gerar os lan็amentos contแbeis de enceramento")
	AAdd(aSays,"dos Elementos PEP, que ira Debitar REDUTORA PRE OPERATIVO,")
	AAdd(aSays,"e Creditar PRE-OPERATIVO")

	AAdd(aBotoes,{ 5,.T.,{|| Pergunte("RCTBAF",.T. ) } } )
	AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
	AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )        
	FormBatch( "Encerramento Elemento PEP", aSays, aBotoes )

	If nOpcao == 1
		Processa({|| CTBA110F_Prc()})
	EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBA110F_PrcบAutor  ณBruno Daniel Borges บ Data ณ  03/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento do encerramento de Pre-Operativo                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTBA110F_Prc()
	Local cQuery    := ""
	Local bQuery    := {|| IIf(Select("TRB") > 0, TRB->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbGoTop()), TRB->(dbEval({|| nTotReg++})), TRB->(dbGoTop()) }
	Local nTotReg   := 0
	Local nHeadProv := 0
	Local cArqCTB   := ""
	Local cLote		:= "001CTB"   
	Local nTotal    := 0

	//Busca os lancamentos
	cQuery := " SELECT CT2_CREDIT, CT2_DCC, CT2_VALOR, CT2_HIST, CT2_ATIVCR, CT2_ITEMC, CT2_CCC, A.R_E_C_N_O_ AS REGNO, CT2_ITEMD, CT2_CCD "
	cQuery += " FROM " + RetSQLName("CT2") + " A "
	cQuery += " WHERE CT2_FILIAL = '" + xFilial("CT2") + "' AND CT2_ITEMC BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND A.D_E_L_E_T_ = ' ' AND "
	cQuery += "       CT2_CREDIT = '" + mv_par04 + "' AND A.D_E_L_E_T_ = ' ' AND CT2_KEY <> '__XX' "
	LjMsgRun("Aguarde, buscando lancamentos...","Aguarde",bQuery)

	ProcRegua(nTotReg)

	//Inicia a integracao contabil
	If TRB->(!Eof())
		nHeadProv := HeadProva(cLote,"RCTBA110",Substr(cUsuario,7,6),@cArqCTB)
	EndIf

	While TRB->(!Eof())
		//Apropria o CUSTO e Lanca o Saldo Restante na REDUTORA
		nTotal += DetProva(nHeadProv,"017","RCTBA110",cLote)
		TRB->(dbSkip())
	EndDo

	//Encerra o lancamento contabil                     
	If nTotal > 0
		RodaProva(nHeadProv,nTotal)
		cA100Incl(cArqCTB,nHeadProv,3,cLote,.T.,.F.)   

		MsgAlert("Encerramento de Elemento PEP concluido.")
	Else
		MsgAlert("Aten็ใo nใo foi localizado nenhum movimento em redutora de pr้-operativo para os elementos PEP informados.")
	EndIf

Return(Nil)