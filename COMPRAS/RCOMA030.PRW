#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA030 บ Autor ณBruno Daniel Borges บ Data ณ  18/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de solicitantes x Centro de Custos                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RCOMA030()
	Private cCadastro := "Cadastro de Usuarios x Centro de Custos"
	Private aRotina := { 	{"Pesquisar"	,"AxPesqui",0,1} ,;
							{"Visualizar"	,"U_RCOMA30A",0,2} ,;
							{"Incluir"		,"U_RCOMA30A",0,3} ,;
							{"Alterar"		,"U_RCOMA30A",0,4} ,;
							{"Excluir"		,"U_RCOMA30A",0,5} ,;
							{"Copiar"		,"U_RCOMA30A",0,6} }

	dbSelectArea("ZZ4")
	ZZ4->(dbSetOrder(1))

	mBrowse( 6,1,22,75,"ZZ4")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA30A บAutor  ณBruno Daniel Borges บ Data ณ  18/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณManutencao no cadastro                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA30A(x,y,nOpcBrowse)
	Local oDlgMain 		:= Nil
	Local oEnchoice		:= Nil
	Local aCposGetD		:= {} 
	Local aCposEnch		:= {}
	Local aHeadGetD		:= {}
	Local aColsGetD 	:= {}   
	Local aAreaBkp		:= GetArea()
	Local aCoordenadas	:= MsAdvSize()
	Local cChaveZZ4		:= ""
	Local nOpcClick		:= 0 
	Local nRecnZZ4		:= ZZ4->(RecNo())  
	Local nOpcGetD		:= 0
	Local nPosUser		:= 0
	Local nPosCC		:= 0
	Local i,j

	Private nTipoVisual	:= 0 
	Private oGetDados	:= Nil

	If nOpcBrowse == 2 .Or. nOpcBrowse == 5
		nOpcGetD := 0                      
	Else
		nOpcGetD := 15
	EndIf

	nTipoVisual := Aviso("Tipo de Visualiza็ใo","Selecione o tipo de visualiza็ใo para o cadastro de usuแrios x centro de custos",{"CC x Usuแrios","Usuแrio x CC"})

	If nTipoVisual == 2
		aCposGetD := {"ZZ4_ITEM","ZZ4_CC","ZZ4_DESC"}
		aCposEnch := {"ZZ4_USER","ZZ4_NOME"}
	Else
		aCposGetD := {"ZZ4_ITEM","ZZ4_USER","ZZ4_NOME"}
		aCposEnch := {"ZZ4_CC","ZZ4_DESC"}
	EndIf

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 16/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefinicao de campos no SX3ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))   
	For i := 1 To Len(aCposGetD)
		SX3->(dbSeek(aCposGetD[i]))
		Aadd(aHeadGetD,	{	Trim(X3Titulo())			,;
							SX3->X3_CAMPO				,;
							SX3->X3_PICTURE				,; 
							SX3->X3_TAMANHO				,;
							SX3->X3_DECIMAL				,;
							SX3->X3_VALID				,;
							SX3->X3_USADO				,;
							SX3->X3_TIPO				,;
							SX3->X3_F3					,;
							SX3->X3_CONTEXT				,;
							SX3->X3_CBOX				,;
														,;
							SX3->X3_WHEN				,;
							SX3->X3_VISUAL				,;
							SX3->X3_VLDUSER				,;
							SX3->X3_PICTVAR				,;
							SX3->X3_OBRIGAT				})
	Next i
 	*/
	For i := 1 To Len(aCposGetD)
		Aadd(aHeadGetD,	{	Trim(X3Titulo())							,;
							GetSX3Cache(aCposGetD[i],"X3_CAMPO"		)	,;
							GetSX3Cache(aCposGetD[i],"X3_PICTURE"	)	,;
							GetSX3Cache(aCposGetD[i],"X3_TAMANHO"	)	,;
							GetSX3Cache(aCposGetD[i],"X3_DECIMAL"	)	,;
							GetSX3Cache(aCposGetD[i],"X3_VALID"		)	,;
							GetSX3Cache(aCposGetD[i],"X3_USADO"		)	,;
							GetSX3Cache(aCposGetD[i],"X3_TIPO"		)	,;
							GetSX3Cache(aCposGetD[i],"X3_F3"		)	,;
							GetSX3Cache(aCposGetD[i],"X3_CONTEXT" 	)	,;
							GetSX3Cache(aCposGetD[i],"X3_CBOX"		)	,;
																		,;
							GetSX3Cache(aCposGetD[i],"X3_WHEN"		)	,;
							GetSX3Cache(aCposGetD[i],"X3_VISUAL"	)	,;
							GetSX3Cache(aCposGetD[i],"X3_VLDUSER"	)	,;
							GetSX3Cache(aCposGetD[i],"X3_PICTVAR"	)	,;
							GetSX3Cache(aCposGetD[i],"X3_OBRIGAT"	)	})
	Next i

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	//CC x Usuarios
	If nTipoVisual == 1
		nPosUser	:= AScan(aHeadGetD,{|x| AllTrim(x[2]) == "ZZ4_USER"})
		//Usuarios x CC
	Else
		nPosCC		:= AScan(aHeadGetD,{|x| AllTrim(x[2]) == "ZZ4_CC"})
	EndIf

	RegToMemory("ZZ4",nOpcBrowse == 3) 

	If nOpcBrowse <> 3        
		//Carrega componentes da estrutura
		cChaveZZ4 := AllTrim(Iif(nTipoVisual == 1,M->ZZ4_CC, M->ZZ4_USER))
		dbSelectArea("ZZ4")
		ZZ4->(dbSetOrder(nTipoVisual))
		ZZ4->(dbGoTop())
		ZZ4->(dbSeek(xFilial("ZZ4")+AllTrim(cChaveZZ4)))
		While ZZ4->(!Eof()) .And. ZZ4->ZZ4_FILIAL + AllTrim(ZZ4->&(Iif(nTipoVisual == 1,"ZZ4_CC", "ZZ4_USER") )) == xFilial("ZZ4") + cChaveZZ4
			//Monta aCols
			Aadd(aColsGetD,Array(Len(aHeadGetD)+1))   
			For i := 1 To Len(aHeadGetD)
				If AllTrim(aHeadGetD[i][10]) == "V" //Campos Virtuais
					aColsGetD[Len(aColsGetD)][i]	:= CriaVar(AllTrim(aHeadGetD[i][2]))
				Else
					aColsGetD[Len(aColsGetD)][i]	:= ZZ4->&(AllTrim(aHeadGetD[i][2]))
				EndIf
			Next i                          

			aColsGetD[Len(aColsGetD)][Len(aHeadGetD)+1] := .F.

			ZZ4->(dbSkip())
		EndDo

	Else
		Aadd(aColsGetD,Array(Len(aHeadGetD)+1))   
		For i := 1 To Len(aHeadGetD)     
			If AllTrim(aHeadGetD[i][2]) == "ZZ4_ITEM" 
				aColsGetD[Len(aColsGetD)][i]	:= "001"
			Else
				aColsGetD[Len(aColsGetD)][i]	:= CriaVar(AllTrim(aHeadGetD[i][2]))
			EndIf
		Next i                          
		aColsGetD[Len(aColsGetD)][Len(aHeadGetD)+1] := .F.
	EndIf                                     

	//Copiar
	If nOpcBrowse == 6
		If nTipoVisual == 1
			M->ZZ4_CC 	:= Space(20)
			M->ZZ4_DESC	:= ""
		Else
			M->ZZ4_USER	:= Space(15)
			M->ZZ4_NOME	:= ""
		EndIf    

		nOpcBrowse := 3
	EndIf

	//Desenha a interface de manutencao no cadastro
	oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5],OemToAnsi("Centro de Custos x Usuแrios"),,,,,,,,oMainWnd,.T.)
	oEnchoice := MsMGet():New("ZZ4",ZZ4->(RecNo()),nOpcBrowse,,,,aCposEnch,{014,001,oDlgMain:nClientHeight/7-5,oDlgMain:nClientWidth/2-10},,3,,,,,,.T.)

	oGetDados := MsNewGetDados():New(oDlgMain:nClientHeight/7,001,oDlgMain:nClientHeight/2-10,oDlgMain:nClientWidth/2-10,nOpcGetD,,,"+ZZ4_ITEM",,,9999,,,,oDlgMain,aHeadGetD,aColsGetD)	
	//oGetDados:bTudoOk := {|| RESTA10C(oGetDados) }
	oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| Iif(oGetDados:TudoOk(), nOpcClick := 1, nOpcClick := 0), Iif(nOpcClick == 1,oDlgMain:End(),Nil)},{|| oDlgMain:End()})},,)

	If nOpcClick == 1 .And. nOpcBrowse <> 2
		For i := 1 To Len(oGetDados:aCols)
			dbSelectArea("ZZ4")
			ZZ4->(dbSetOrder(nTipoVisual))
			cChaveZZ4 := Iif(nTipoVisual == 1,M->ZZ4_CC + oGetDados:aCols[i,nPosUser], M->ZZ4_USER + oGetDados:aCols[i,nPosCC]) 

			If nOpcBrowse == 3 .And. !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
				ZZ4->(RecLock("ZZ4",.T.))
			ElseIf nOpcBrowse == 4 
				If ZZ4->(dbSeek(xFilial("ZZ4")+cChaveZZ4)) .And. !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
					ZZ4->(RecLock("ZZ4",.F.))
				ElseIf !ZZ4->(dbSeek(xFilial("ZZ4")+cChaveZZ4)) .And. !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
					ZZ4->(RecLock("ZZ4",.T.))
				ElseIf ZZ4->(dbSeek(xFilial("ZZ4")+cChaveZZ4)) .And. oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
					ZZ4->(RecLock("ZZ4",.F.))
					ZZ4->(dbDelete())
					ZZ4->(MsUnlock())  
					Loop
				Else
					Loop
				EndIf   
			ElseIf nOpcBrowse == 5
				If ZZ4->(dbSeek(xFilial("ZZ4")+cChaveZZ4))
					ZZ4->(RecLock("ZZ4",.F.))
					ZZ4->(dbDelete())
					ZZ4->(MsUnlock())  
				EndIf
				Loop		
			EndIf

			//Gravacao dos campos na Inclusao e Alteracao
			ZZ4->ZZ4_FILIAL := xFilial("ZZ4") 

			//Grava campos do cabecalho
			For j := 1 To Len(oEnchoice:aGets)
				If Posicione("SX3",2,AllTrim(SubStr(oEnchoice:aGets[j],9,10)),"SX3->X3_CONTEXT") <> "V"
					ZZ4->&(SubStr(oEnchoice:aGets[j],9,10)) := M->&(SubStr(oEnchoice:aGets[j],9,10))
				EndIf
			Next j

			//Grava campo dos itens
			For j := 1 To Len(oGetDados:aHeader)
				If oGetDados:aHeader[j,10] <> "V"
					ZZ4->&(oGetDados:aHeader[j,2]) := oGetDados:aCols[i,j]
				EndIf
			Next j

			//Grava campos do Item
			ZZ4->(MsUnlock())
		Next i
	EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA30B บAutor  ณBruno Daniel Borges บ Data ณ  18/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que retorna o nome do usuario                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA30B(cCodUsuario)
	Local cRetorno 	:= ""
	Local aUsers	:= AllUsers()
	Local i

	For i := 1 To Len(aUsers)
		If aUsers[i,1,1] == cCodUsuario
			cRetorno := IIf(!Empty(aUsers[i,1,4]),aUsers[i,1,4],aUsers[i,1,2])
			Loop
		EndIf
	Next i

Return(cRetorno)       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA30C บAutor  ณBruno Daniel Borges บ Data ณ  26/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao dos usuarios/CC na tela de inclusao     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA30C()
	Local nPosUser	:= Iif(nTipoVisual == 1,AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ4_USER" }),0)
	Local nPosCC	:= Iif(nTipoVisual == 2,AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ4_CC" }),0)
	Local i

	For i := 1 To Len(oGetDados:aCols)
		If nTipoVisual == 1 //Valida Usuario no C.C.	
			If AllTrim(oGetDados:aCols[i,nPosUser]) == AllTrim(M->ZZ4_USER) .And. i <> oGetDados:nAt .And. !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
				MsgAlert("Aten็ใo, esse usuแrio jแ foi relacionado como solicitante desse centro de custo")
				Return(.F.)			
			EndIf	
		ElseIf nTipoVisual == 2 //Valida C.C.s do Usuario
			If AllTrim(oGetDados:aCols[i,nPosCC]) == AllTrim(M->ZZ4_CC) .And. i <> oGetDados:nAt .And. !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
				MsgAlert("Aten็ใo, esse centro de custo jแ foi relacionado para esse solicitante")
				Return(.F.)			
			EndIf	
		EndIf
	Next i

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA30D บAutor  ณBruno Daniel Borges บ Data ณ  26/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que retorna os codigos de C.C. que o usuario esta    บฑฑ
ฑฑบ          ณassociado como solicitante                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA30D()
	Local cRetorno 	:= ""
	Local aAreaBKP	:= GetArea()

	dbSelectArea("ZZ4")
	ZZ4->(dbSetOrder(2))
	ZZ4->(dbSeek(xFilial("ZZ4")+__cUserId))
	While ZZ4->(!Eof()) .And. ZZ4->ZZ4_FILIAL + AllTrim(ZZ4->ZZ4_USER) == xFilial("ZZ4")+__cUserId
		cRetorno += AllTrim(ZZ4->ZZ4_CC)+"|"
		ZZ4->(dbSkip())
	EndDo 

	If !(AllTrim(M->C1_CC) $ cRetorno)
		MsgAlert("Aten็ใo, voc๊ nใo esta associado ao centro de custo informado para fazer solicita็ใo de compras.")
		Return(.F.)  
	Else
		//Valida se centro de custo e unico na S.C.
		If !RCOMA30F()
			RestArea(aAreaBKP)
			Return(.F.)
		EndIf
	EndIf

	RestArea(aAreaBKP)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA30E บAutor  ณBruno Daniel Borges บ Data ณ  26/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que preenche o campo C.C. com base em outras linhas  บฑฑ
ฑฑบ          ณS.C.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA30E()
	Local cRetorno 	:= ""
	Local nPosCC	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C1_CC" })

	If N <> 1
		aCols[N,nPosCC] := aCols[1,nPosCC]
	EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA30F บAutor  ณBruno Daniel Borges บ Data ณ  26/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do C.C. para nao permitir mais de um    บฑฑ
ฑฑบ          ณCC por solicitacao de compras                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RCOMA30F()
	Local cRetorno 	:= ""
	Local nPosCC	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C1_CC" })
	Local cCCFirst	:= ""
	Local i

	For i := 1 To Len(aCols)
		If !aCols[i,Len(aHeader)+1]
			If Empty(cCCFirst)
				cCCFirst := aCols[i,nPosCC]
				Loop
			ElseIf AllTrim(M->C1_CC) <> AllTrim(cCCFirst)
				MsgAlert("Aten็ใo, ้ permitido um Centro de Custo por solicita็ใo. Para efetuar solicita็ใo para m๚ltiplos centros de custos inclua uma solicita็ใo individual para cada.")
				Return(.F.)
			EndIf	
		EndIf
	Next i                  

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA30G บAutor  ณBruno Daniel Borges บ Data ณ  26/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao para nao permitir P.C. manual sem S.C.  บฑฑ
ฑฑบ          ณde centros de custos que estao com alcada cadastrada        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA30G()
	Local aAreaBKP	:= GetArea()   
	Local nPosSC	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC" })  
	Local cCCOut	:= GetMv("MV_XCCOUT")

	dbSelectArea("ZZ4")
	ZZ4->(dbSetOrder(1))
	If ZZ4->(dbSeek(xFilial("ZZ4")+M->C7_CC)) .And. Empty(aCols[n,nPosSC]) .And. !(AllTrim(M->C7_CC) $ cCCOut)
		MsgAlert("Aten็ใo, esse centro de custo possui al็ada de aprova็ใo por solicita็ใo de compras, nใo ้ permitido a inclusใo de pedidos de compras sem solicita็ใo de compras")
		Return(.F.)
	EndIf

	RestArea(aAreaBKP)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA30H บAutor  ณBruno Daniel Borges บ Data ณ  04/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do limite maximo de diferenca entre o   บฑฑ
ฑฑบ          ณvalor da S.C. e o valor do Pedido de Compra                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA30H()
	Local nPercLim	:= GetMv("MV_XLIMSC",,5)
	Local aAreaBKP	:= GetArea()
	Local nPosSC	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC" 		})
	Local nPosItem	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEMSC"		})
	Local cGrpsOut	:= AllTrim(GetMv("MV_XGRPCC",,"ZZZZ"))

	dbSelectArea("SC1")
	SC1->(dbSetOrder(1))
	If SC1->(dbSeek(xFilial("SC1")+aCols[N,nPosSC]+aCols[N,nPosItem] ))
		If SC1->C1_VUNIT < M->C7_PRECO .And. NoRound(100 - (SC1->C1_VUNIT * 100 / M->C7_PRECO),2) > nPercLim
			//Avalia se grupo do produto esta fora da validacao
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
			If !(SB1->B1_GRUPO $ cGrpsOut)
				MsgAlert("Aten็ใo, o valor informado pelo solicitante ้ menor do que o valor informado no Pedido de Compra. O limite mแximo para diferen็a de valores ้ de " + AllTrim(Str(nPercLim)) + "% " )
				Return(.F.)
			EndIf
		EndIf
	EndIf

	RestArea(aAreaBKP)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA30I บAutor  ณBruno Daniel Borges บ Data ณ  04/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do limite maximo de diferenca entre o   บฑฑ
ฑฑบ          ณvalor da S.C. e o valor da Cotacao de Compras               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA30I()
	Local nPercLim	:= GetMv("MV_XLIMSC",,5)
	Local aAreaBKP	:= GetArea()
	Local nPosSC	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C8_NUMSC" 		})
	Local nPosItem	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C8_ITEMSC"		})
	Local cGrpsOut	:= AllTrim(GetMv("MV_XGRPCC",,"ZZZZ"))

	dbSelectArea("SC1")
	SC1->(dbSetOrder(1))
	If SC1->(dbSeek(xFilial("SC1")+aCols[N,nPosSC]+aCols[N,nPosItem] ))
		If SC1->C1_VUNIT < M->C8_PRECO .And. NoRound(100 - (SC1->C1_VUNIT * 100 / M->C8_PRECO),2) > nPercLim
			//Avalia se grupo do produto esta fora da validacao
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
			If !(SB1->B1_GRUPO $ cGrpsOut)
				MsgAlert("Aten็ใo, o valor informado pelo solicitante ้ menor do que o valor informado nessa Cota็ใo. O limite mแximo para diferen็a de valores ้ de " + AllTrim(Str(nPercLim)) + "% " )
				Return(.F.)
			EndIf
		EndIf
	EndIf

	RestArea(aAreaBKP)

Return(.T.)