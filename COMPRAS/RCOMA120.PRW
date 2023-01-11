#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ T4F00020 บ Autor ณWellington Santos   บ Data ณ 09/06/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela para cadastro de CC x Elemento PEP                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function RCOMA120()
Local aCores 		:= {}

Private cCadastro := "Centro de Custos x Elemento PEP"
Private aRotina := { 	{"Pesquisar"		,"AxPesqui"		,0,1} ,;
             			{"Visualizar"	,"U_T4F0020C"	,0,2} ,;
             			{"Incluir"		,"U_T4F0020C"	,0,3} ,;
             			{"Alterar"		,"U_T4F0020C"	,0,4} ,;
             			{"Excluir"		,"U_T4F0020C"	,0,5}  }

//dbSelectArea("SZ3")
//SZ3->( dbSetOrder(1) )
mBrowse( 6,1,22,75,"SZ3")

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ T4F0020C บAutor  ณWellington Santos   บ Data ณ 09/06/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela geral de manutencao do cadastro de CC x Elemento PEP   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function T4F0020C(cAlias,nReg,nOpc)
Local aArea 		:= GetArea()

// Variaveis da tela
Local oDlg
Local aCampos 	:= { "Z3_FILIAL","Z3_ELEMPEP", "Z3_DESCPEP" }
Local aCposFree	:= { "Z3_ELEMPEP" }
Local cNumCC	:= CriaVar("Z3_CC",.F.)
Local cDesCC 	:= CriaVar("Z3_DESCC",.F.)
Local lGrv		:= .F.

Private aCols	:= {}
Private aHeader	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o Cabecalho                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
dbSetOrder(2)
For nX := 1 To Len(aCampos)
	dbSeek(aCampos[nX])

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	If nX == 1 // Item
		cTitulo 	:= 'It'
		cValid 	:= ''
	ElseIf nX == 2 // Z3_ELEMPEP
		cTitulo 	:= AllTrim(SX3->X3_TITULO)
		cValid 	:= AllTrim(SX3->X3_VALID)
	Else
		cTitulo 	:= AllTrim(SX3->X3_TITULO)
		cValid := SX3->X3_VALID
	EndIf
	
	aAdd(aHeader,{	cTitulo		,;
					SX3->X3_CAMPO	,;
					SX3->X3_PICTURE	,;
					SX3->X3_TAMANHO	,;
					SX3->X3_DECIMAL	,;
					cValid 			,;
					SX3->X3_USADO		,;
					SX3->X3_TIPO		,;
					SX3->X3_ARQUIVO	,;
					SX3->X3_CONTEXT 	} )
	*/
	
	If nX == 1 // Item
		cTitulo	:= 'It'
		cValid 	:= ''
	ElseIf nX == 2 // Z3_ELEMPEP
		cTitulo := AllTrim(GetSX3Cache(aCampos[nX],"X3_TITULO"))
		cValid 	:= AllTrim(GetSX3Cache(aCampos[nX],"X3_VALID"))
	Else
		cTitulo := AllTrim(GetSX3Cache(aCampos[nX],"X3_TITULO"))
		cValid 	:= GetSX3Cache(aCampos[nX],"X3_VALID")
	EndIf
	
	aAdd(aHeader,{	cTitulo										,;
					GetSX3Cache(aCampos[nX],"X3_CAMPO"		)	,;
					GetSX3Cache(aCampos[nX],"X3_PICTURE"	)	,;
					GetSX3Cache(aCampos[nX],"X3_TAMANHO"	)	,;
					GetSX3Cache(aCampos[nX],"X3_DECIMAL"	)	,;
					GetSX3Cache(aCampos[nX],"X3_VALID"		)	,;
					GetSX3Cache(aCampos[nX],"X3_USADO"		)	,;
					GetSX3Cache(aCampos[nX],"X3_TIPO"		)	,;
					GetSX3Cache(aCampos[nX],"X3_F3"			)	,;
					GetSX3Cache(aCampos[nX],"X3_CONTEXT" 	)	})

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------					

Next nX

dbSelectArea('SZ3')

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Preenche o aCols                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nOpc == 3 	// Incluir
	aAdd(aCols,Array(Len(aHeader)+1))
	For nX := 1 To Len(aHeader)
		aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
	Next nX
	aCols[Len(aCols),Len(aHeader)+1] := .F.
	aCols[Len(aCols),1]	 := '01'
EndIf

If nOpc == 2 .Or. nOpc == 4 .Or. nOpc == 5 // Visualiza, Altera, Exclui
	cNumCC		:= SZ3->Z3_CC
	cDesCC		:= SZ3->Z3_DESCC
	cIt			:= '00'
	
	//--> Preenche as linhas de atividades
	SZ3->( dbSetOrder(1) )
	SZ3->( dbSeek(xFilial('SZ3')+cNumCC) )
	Do While SZ3->( !Eof() ) .and. SZ3->Z3_CC == cNumCC
		aAdd(aCols,Array(Len(aHeader)+1))
		aCols[Len(aCols),1]		:= Soma1(cIt)
		aCols[Len(aCols),2]		:= SZ3->Z3_ELEMPEP
		aCols[Len(aCols),3]		:= SZ3->Z3_DESCPEP
		aCols[Len(aCols),Len(aHeader)+1] 	:= .F.
		SZ3->( dbSkip() )
	EndDo
EndIf

Define MsDialog oDlg Title cCadastro Of oMainWnd Pixel From 0,0 To 400,800
//050 008
	@ C(022),C(010) Say "Centro Custo" 	Size C(100),C(018) COLOR CLR_BLUE 		PIXEL OF oDlg 
	@ C(020),C(060) MsGet cNumCC F3 'CTT' 	Size C(049),C(009) COLOR CLR_BLACK 	PIXEL OF oDlg 	When nOpc==3;
		Valid( If(NaoVazio(cNumCC).and.ExistCpo("CTT",cNumCC),(cDesCC:=Posicione('CTT',1,xFilial('CTT')+cNumCC,'CTT_DESC01'),.T.),.F.))
	@ C(020),C(120) MsGet cDesCC 			Size C(120),C(009) COLOR CLR_BLACK 	PIXEL OF oDlg 	When .F.

	oGetD := MSGetDados():New(35,1,200,400,nOpc,'AlwaysTrue','AlwaysTrue','+Z3_FILIAL',.T.,aCposFree,,,/*05*/,"U_VldCpo()",,,,oDlg)

	bCanc	:= {|| lGrv:=.F.,oDlg:End()}
	bOk		:= {|| lGrv:=.T.,oDlg:End()}

Activate MsDialog oDlg Center On Init EnchoiceBar(oDlg,bOk,bCanc)

If lGrv 
	If nOpc == 3 // Incluir
		For i := 1 To Len(aCols)
			If !aCols[i,Len(aHeader)+1] // Nao deletado
				RecLock('SZ3',.T.)
				SZ3->Z3_FILIAL 	:= xFilial('SZ3')
				SZ3->Z3_CC 		:= cNumCC
				SZ3->Z3_DESCC 		:= cDesCC
				SZ3->Z3_ELEMPEP 	:= aCols[i,2]
				SZ3->Z3_DESCPEP 	:= aCols[i,3]
				MSUnLock()
			EndIf
		Next i
	ElseIf nOpc == 4 // Alteracao
		SZ3->(dbSetOrder(1))
		SZ3->( dbSeek(xFilial('SZ3')+cNumCC) )
		i := 1
		Do While SZ3->( !Eof() ) .and. SZ3->Z3_CC == cNumCC .and. i <= Len(aCols)
			RecLock('SZ3',.F.)
			If !aCols[i,Len(aHeader)+1] // Nao deletado
				SZ3->Z3_ELEMPEP 	:= aCols[i,2]
				SZ3->Z3_DESCPEP 	:= aCols[i,3]
			else
				Delete
			EndIf
			SZ3->(MSUnLock())
			SZ3->( dbSkip() )
			i++
		EndDo
		If i <= Len(aCols) .and. SZ3->Z3_CC <> cNumCC
			RecLock('SZ3',.T.)
			SZ3->Z3_FILIAL 	:= xFilial('SZ3')
			SZ3->Z3_CC 		:= cNumCC
			SZ3->Z3_DESCC 		:= cDesCC
			SZ3->Z3_ELEMPEP 	:= aCols[i,2]
			SZ3->Z3_DESCPEP 	:= aCols[i,3]
			MSUnLock()
		ElseIf SZ3->( !Eof() ) .and. SZ3->Z3_CC == cNumCC
			RecLock('SZ3',.F.)
			Delete
			MSUnLock()
		EndIf
	ElseIf nOpc == 5 // Exclusao
		SZ3->(dbSetOrder(1))
		SZ3->( dbSeek(xFilial('SZ3')+cNumCC) )
		Do While SZ3->( !Eof() ) .and. SZ3->Z3_CC == cNumCC
			RecLock('SZ3',.F.)
			dbDelete()
			MSUnLock()
			SZ3->( dbSkip() )
		EndDo
	EndIf
EndIf

Return(Nil)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VLDCPO   บAutor  ณWelligton Santos    บ Data ณ 09/06/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza a descricao do Elemento PEP                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function VldCpo()
Local lRet := .T.
Local cPEP := &( ReadVar() )
Local i

IF INCLUI
	For i := 1 To Len(aCols)
		If aCols[i,Len(aHeader)+1] 	// Nao apagado
			If aCols[i,2] == cPEP .and. i <> n
				Alert('Elemento PEP: ' +cPEP+ ' jแ utilizado para este Centro de Custo - Item: '+AllTrim(Str(i)) )
				lRet := .F.
				Exit
			EndIf
		EndIf
	Next
	
	If lRet .and. !Empty(cPEP)
		aCols[n,3] := Posicione('CTD',1,xFilial('CTD')+cPEP,'CTD_DESC01')
		oGetD:Refresh()
	EndIf
ENDIF

Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDTOK  บAutor  ณWellington Santos   บ Data ณ 09/06/2009  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida os dados informados                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function ValidTOk()
Local lRet := .T.

Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ C        บAutor  ณMicrosiga           บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)                                                         

Local nHRes	:=	798 //oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento para tema "Flat"ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
Return Int(nTam)