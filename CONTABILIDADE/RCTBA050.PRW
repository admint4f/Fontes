#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTBA050 บAutor  ณBruno Daniel Borges บ Data ณ  18/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de relacionamento entre codigos dos sistemas de      บฑฑ
ฑฑบ          ณbilheteria (Clave no caso da Ticketmaster) com Cad. Elementoบฑฑ
ฑฑบ          ณPEP                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function RCTBA050()
	Local aCores := {	{ "CTD_BLOQ == '1'" , "BR_VERMELHO"	},; // Conta Bloqueada
						{ "CTD_BLOQ == '2' .AND. ( ( Empty( CTD_DTEXIS ) .Or. CTD_DTEXIS <= dDatabase ) .AND. ( Empty( CTD_DTEXSF ) .Or. CTD_DTEXSF >= dDatabase ) )" , "BR_VERDE"   	},; // Sem Restri็ใo
						{ "CTD_BLOQ == '2' .AND. ( ! Empty( CTD_DTEXIS ) .AND. CTD_DTEXIS >= dDatabase )" , "BR_AMARELO"	},; // Exercicio Nใo Iniciado
						{ "CTD_BLOQ == '2' .AND. ( ! Empty( CTD_DTEXSF ) .AND. CTD_DTEXSF <= dDatabase )" , "BR_CINZA"		} } // Exercicio Finalizado

	PRIVATE aRotina := {	{ OemToAnsi("Pesquisar")		,"AxPesqui"  ,0 , 1},;
	{ OemToAnsi("Visualizar")		,"AxVisual"  ,0 , 2},;
	{ OemToAnsi("Claves Bilhet.")	,"U_RCTBA50A",0 , 4},;
	{ OemToAnsi("Legenda")			,"Ctba040leg",0 , 6},;
	{ OemToAnsi("Imp. Claves")		,"U_IMPCLAVES",0 , 8}}


	PRIVATE cCadastro := "Elemento PEP x Codigos dos Sistemas de Bilheteria"

	mBrowse( 6, 1,22,75,"CTD",,,,,,aCores)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTBA50A บAutor  ณBruno Daniel Borges บ Data ณ  18/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de manutencao no cadastro                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTBA50A()
	Local oDlgMain		:= Nil           
	Local oFolder		:= Nil           
	Local oGetDados		:= Nil    
	Local cElePep		:= CTD->CTD_ITEM
	Local cDescElePep	:= CTD->CTD_DESC01
	Local aCoordenadas	:= MsAdvSize(.T.)
	Local aHeader		:= {}
	Local aCols			:= {}
	Local nOpcClick		:= 0
	Local i,j			:= 0   
	Local nPosItem		:= 0
	Local lSeek			:= .F.
	Local aCmpZZ7		:= U__fRetCpos("ZZ7")
	Local nI	

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	//Monta o aHeader e o aCols
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("ZZ7"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "ZZ7"
	If X3Uso(SX3->X3_USADO)
	Aadd(aHeader,	{	Trim(X3Titulo())		,;
	SX3->X3_CAMPO			,;
	SX3->X3_PICTURE			,; 
	SX3->X3_TAMANHO			,;
	SX3->X3_DECIMAL			,;
	SX3->X3_VALID			,;
	SX3->X3_USADO			,;
	SX3->X3_TIPO			,;
	SX3->X3_F3				,;
	SX3->X3_CONTEXT			,;
	SX3->X3_CBOX			,;
	,;
	SX3->X3_WHEN			,;
	SX3->X3_VISUAL			,;
	SX3->X3_VLDUSER			,;
	SX3->X3_PICTVAR			,;
	SX3->X3_OBRIGAT			})	     
	EndIf

	SX3->(dbSkip())
	EndDo
	*/
	For nI := 1 to Len(aCmpZZ7)
		If X3Uso(GetSX3Cache(aCmpZZ7[nI],"X3_USADO"))
			Aadd(aHeadNfs,{ Trim( X3Titulo() )							,;
							GetSX3Cache(aCmpZZ7[nI],"X3_CAMPO"		)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_PICTURE"	)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_TAMANHO"	)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_DECIMAL"	)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_VALID"		)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_USADO"		)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_TIPO"		)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_F3"			)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_CONTEXT" 	)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_CBOX"		)	,;
							,;
							GetSX3Cache(aCmpZZ7[nI],"X3_WHEN"		)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_VISUAL"		)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_VLDUSER"	)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_PICTVAR"	)	,;
							GetSX3Cache(aCmpZZ7[nI],"X3_OBRIGAT"	)	})	     

		EndIf
	Next nI

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	dbSelectArea("ZZ7")
	ZZ7->(dbSetOrder(1))
	ZZ7->(dbSeek(xFilial("ZZ7")+CTD->CTD_ITEM))
	While ZZ7->(!Eof()) .And. ZZ7->ZZ7_FILIAL + AllTrim(ZZ7->ZZ7_ELEPE) == xFilial("ZZ7")+AllTrim(CTD->CTD_ITEM)
		AAdd(aCols,Array(Len(aHeader)+1))
		For i := 1 To Len(aHeader)
			aCols[Len(aCols),i] := ZZ7->&(aHeader[i,2])
		Next i
		aCols[Len(aCols),Len(aHeader)+1] := .F.

		ZZ7->(dbSkip())
	EndDo

	If Len(aCols) <= 0
		AAdd(aCols,Array(Len(aHeader)+1))
		For i := 1 To Len(aHeader)       
			If AllTrim(aHeader[i,2]) == "ZZ7_ITEM"
				aCols[1,i] := "001"
			Else
				aCols[1,i] := CriaVar(aHeader[i,2])
			EndIf
		Next i
		aCols[1,Len(aHeader)+1] := .F.
	EndIf

	//Desenha a tela de manutencao no cadastro
	oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5],OemToAnsi("Contrato de Clientes"),,,,,,,,oMainWnd,.T.)
	TSay():New(014,003,{|| OemToAnsi("Elemento PEP")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)                     
	@ 025,003 MsGet cElePep Picture "@!" Size 050,8 When .F. Of oDlgMain Pixel

	TSay():New(014,060,{|| OemToAnsi("Descri็ใo")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)                     
	@ 025,060 MsGet cDescElePep Picture "@!" Size oDlgMain:nWidth/2-065,8 When .F. Of oDlgMain Pixel

	oFolder := TFolder():New(040,003,{"Claves Bilheteria"},,oDlgMain,,,,.T.,.F.,oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-75)
	oGetDados := MsNewGetDados():New(001,001,oFolder:aDialogs[1]:nClientHeight/2-3,oFolder:aDialogs[1]:nClientWidth/2-3,15,,,"+ZZ7_ITEM",,,9999,,,,oFolder:aDialogs[1],aHeader,aCols)

	EnchoiceBar(oDlgMain,{|| nOpcClick := 1, oDlgMain:End() },{|| nOpcClick := 0, oDlgMain:End()})
	oDlgMain:Activate(,,,.T.)  

	If nOpcClick == 1
		dbSelectArea("ZZ7")
		ZZ7->(dbSetOrder(1))
		nPosItem := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ7_ITEM" })
		For i := 1 To Len(oGetDados:aCols)
			lSeek := ZZ7->(dbSeek(xFilial("ZZ7")+CTD->CTD_ITEM+oGetDados:aCols[i,nPosItem]))

			If lSeek .And. oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
				ZZ7->(RecLock("ZZ7",.F.))
				ZZ7->(dbDelete())
				ZZ7->(MsUnlock())
			ElseIf !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
				ZZ7->(RecLock("ZZ7",!lSeek))
				ZZ7->ZZ7_FILIAL	:= xFilial("ZZ7")
				ZZ7->ZZ7_ELEPE	:= CTD->CTD_ITEM
				For j := 1 To Len(oGetDados:aHeader)
					ZZ7->&(oGetDados:aHeader[j,2]) := oGetDados:aCols[i,j]
				Next j
				ZZ7->(MsUnlock())		
			EndIf
		Next i
	EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTBA50B บAutor  ณBruno Daniel Borges บ Data ณ  18/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de formatacao do arquivo CSV p/ posterior importa-   บฑฑ
ฑฑบ          ณcao na base contabil da T4F                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTBA50B()
	Local cFileImp	:= cGetFile("TXT|*.TXT",OemToAnsi("Arquivos Sistemas Bilheteria"))

	If Empty(cFileImp)
		MsgAlert("Aten็ใo, informe um nome de arquivo vแlido para continuar.")
		Return(Nil)
	EndIf      

	LJMsgRun("Formantando Arquivo de Importa็ใo","Aguarde...",{|| RTCBA50B_1(cFileImp)})

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRTCBA50B_1บAutor  ณBruno Daniel Borges บ Data ณ  18/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de processamento do arquivo de importacao            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RTCBA50B_1(cFileImp)
	Local cLinha		:= ""  
	Local cMenLOG		:= ""
	Local cMesAnoVenda	:= ""
	Local aLinhas		:= {}
	Local aTotElePep	:= {}
	Local aLOG			:= {}  
	Local aLOG2			:= {}
	Local aMeses		:= {"JAN","FEV","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"}
	Local lCabec		:= .F.
	Local i				:= 0  
	Local nPosElePep	:= 0 
	Local nHdlCSV		:= 0
	Local nHdlLOG		:= 0

	//Abre o arquivo e inicia a formatacao
	FT_FUSE(cFileImp)
	FT_FGoTop()

	While !FT_FEof()
		cLinha 	:= FT_FReadLn()     

		//Teste se e linha de cabecalho
		If "MOPREP S^E- FOR" $ cLinha 
			cMesAnoVenda := StrTran(cLinha,Chr(13),"")
			cMesAnoVenda := StrZero(AScan(aMeses,{|x| x == SubStr(cMesAnoVenda,20,3)}),3)+"/"+SubStr(cMesAnoVenda,24,2)
			FT_FSkip()
			Loop	
		ElseIf !lCabec .And. "NTQTY" $ cLinha .And. "NDOLLARS" $ cLinha .And. "SCHGDOL" $ cLinha .And. "OPTDOL" $ cLinha .And. "GRANDTOT" $ cLinha
			lCabec := .T.
			FT_FSkip()
			Loop
		ElseIf !lCabec .And. !("NTQTY" $ cLinha .And. "NDOLLARS" $ cLinha .And. "SCHGDOL" $ cLinha .And. "OPTDOL" $ cLinha .And. "GRANDTOT" $ cLinha)
			FT_FSkip()
			Loop  
		ElseIf "GRAND TOTALS" $ cLinha
			Exit 
		EndIf

		//Testa se linha e valida
		If Len(cLinha) >= 110 .And. lCabec .And. Val(SubStr(cLinha,127,13)) <> 0
			AAdd(aLinhas,{	SubStr(cLinha,1,9),;			//Clave
			SubStr(cLinha,10,60),;     		//Historico
			Val(SubStr(cLinha,80,8)),;		//NTQTY
			Val(SubStr(cLinha,88,13)),;	//NDOLLARS
			Val(SubStr(cLinha,101,13)),;	//SCHGDOL
			Val(SubStr(cLinha,114,13)),;	//OPTDOL
			Val(SubStr(cLinha,127,13))})	//GRANDTOT
		EndIf	

		FT_FSkip()
	EndDo

	//Monta um novo array com os totais por Elemento PEP
	If Len(aLinhas) > 0
		dbSelectArea("ZZ7")
		ZZ7->(dbSetOrder(2))

		For i := 1 To Len(aLinhas)

			dbSelectArea("ZZ7")
			ZZ7->(dbSetOrder(2))
			If !dbSeek(xFilial("ZZ7")+AllTrim(aLinhas[i,1]) )
				If AScan(aLOG,{|x| AllTrim(x) == AllTrim(aLinhas[i,1]) }) <= 0                                                                              
					Aadd(aLOG,AllTrim(aLinhas[i,1]))
				EndIf			
				Loop
			Else                                                                        
				_reg:= 0
				while !eof() .and. ALLTRIM(ZZ7->ZZ7_CHAVE) = AllTrim(aLinhas[i,1])  
					If substring(DTOC(ZZ7->ZZ7_DATA),7,2) >= substring(cMesAnoVenda,5,2)                         
						_reg:= recno()
					endif            
					ZZ7->(dbSkip())
				End
			Endif

			If _reg = 0 
				Aadd(aLOG,AllTrim(aLinhas[i,1]+" - Nao cadastrado "))
				Loop
			Endif      

			dbSelectArea("ZZ7")
			dbgoto(_Reg)

			dbSelectArea("CTD")
			CTD->(dbSetOrder(1))
			If !CTD->(dbSeek(xFilial("CTD")+AllTrim(ZZ7->ZZ7_ELEPE)))         
				If AScan(aLOG2,{|x| AllTrim(x) == AllTrim(ZZ7->ZZ7_ELEPE) }) <= 0
					AAdd(aLOG2,AllTrim(ZZ7->ZZ7_ELEPE) )
				EndIf
				Loop
			EndIf

			nPosElePep := AScan(aTotElePep,{|x| x[1]+x[2] == ZZ7->ZZ7_ELEPE+Iif(Empty(CTD->CTD__TIPO),"",AllTrim(CTD->CTD__TIPO)+"-")+AllTrim(aLinhas[i,1])+"-"+SubStr(AllTrim(IIF(AllTrim(CTD->CTD__TIPO) == "TM",ZZ7->ZZ7_DESC,CTD->CTD_DESC01)),1,20)+"-"+SubStr(StrTran(cMesAnoVenda,"/",""),2,5)+"-"+SUBSTR(DTOC(ZZ7->ZZ7_DATA),4,5) })
			If nPosElePep <= 0
				AAdd(aTotElePep,{ZZ7->ZZ7_ELEPE,"",0,0,0,0,""}) 
				nPosElePep := Len(aTotElePep)
			EndIf			                          

			If Empty(aTotElePep[nPosElePep,2])
				If Len(Iif(Empty(CTD->CTD__TIPO),"",AllTrim(CTD->CTD__TIPO)+"-")+AllTrim(aLinhas[i,1])+"-"+AllTrim(SubStr(AllTrim(IIF(AllTrim(CTD->CTD__TIPO) == "TM",ZZ7->ZZ7_DESC,CTD->CTD_DESC01)),1,20))+"-"+SubStr(StrTran(cMesAnoVenda,"/",""),2,5)+"-"+SUBSTR(DTOC(ZZ7->ZZ7_DATA),4,5)) > 40
					aTotElePep[nPosElePep,2] := Iif(Empty(CTD->CTD__TIPO),"",AllTrim(CTD->CTD__TIPO)+"-")+AllTrim(aLinhas[i,1])+"-"+AllTrim(SubStr(AllTrim(IIF(AllTrim(CTD->CTD__TIPO) == "TM",ZZ7->ZZ7_DESC,CTD->CTD_DESC01)),1,15))+"-"+SubStr(StrTran(cMesAnoVenda,"/",""),2,5)+"-"+SUBSTR(DTOC(ZZ7->ZZ7_DATA),4,5)				
				Else
					aTotElePep[nPosElePep,2] := Iif(Empty(CTD->CTD__TIPO),"",AllTrim(CTD->CTD__TIPO)+"-")+AllTrim(aLinhas[i,1])+"-"+AllTrim(SubStr(AllTrim(IIF(AllTrim(CTD->CTD__TIPO) == "TM",ZZ7->ZZ7_DESC,CTD->CTD_DESC01)),1,20))+"-"+SubStr(StrTran(cMesAnoVenda,"/",""),2,5)+"-"+SUBSTR(DTOC(ZZ7->ZZ7_DATA),4,5)
				EndIf
			EndIf
			aTotElePep[nPosElePep,3] += aLinhas[i,4]
			aTotElePep[nPosElePep,4] += aLinhas[i,5]
			aTotElePep[nPosElePep,5] += aLinhas[i,6]
			aTotElePep[nPosElePep,6] += aLinhas[i,7]
			aTotElePep[nPosElePep,7] := CTD->CTD__CC
		Next i

		//Inicia a gravacao do arquivo CSV
		nHdlCSV := FCreate("C:\IMP_BILHETERIA.CSV")
		FWrite(nHdlCSV,"HISTORICO;NDOLLARS;SCHGDOL;OPTDOL;GRANDTOT;E. PEP;CC"+Chr(13)+Chr(10))
		For i := 1 To Len(aTotElePep)
			FWrite(nHdlCSV,	StrTran(aTotElePep[i,2],'"',"")+";"+;
			Str(aTotElePep[i,3])+";"+;
			Str(aTotElePep[i,4])+";"+;
			Str(aTotElePep[i,5])+";"+;
			Str(aTotElePep[i,6])+";"+;
			aTotElePep[i,1]+";"+;
			aTotElePep[i,7]+Chr(13)+Chr(10))
		Next i
		FClose(nHdlCSV)

		MsgAlert("Aten็ใo, foi gerado o arquivo C:\IMP_BILHETERIA.CSV para ser importado pelo programa de contabiliza็ใo.")

		If Len(aLOG) > 0 .oR. Len(aLOG2) > 0
			nHdlLOG := FCreate("C:\LOG_BILHETERIA.LOG")   
			If Len(aLOG) > 0
				FWrite(nHdlLOG,"O(s) registro(s) abaixo foi(ram) desconsiderados por nใo haver cadastro de clave associada ao elemento PEP: " + Chr(13)+Chr(10))
				AEval(aLOG,{|x| cMenLog += " - " + x + Chr(13)+Chr(10)})
				FWrite(nHdlLOG,cMenLOG)                                  
			EndIf

			If Len(aLOG2) > 0 
				cMenLog := ""
				FWrite(nHdlLOG,"O(s) registro(s) abaixo foi(ram) desconsiderados por nใo haver cadastro dos Elementos PEP descritos abaixo: " + Chr(13)+Chr(10))
				AEval(aLOG2,{|x| cMenLog += " - " + x + Chr(13)+Chr(10)})
				FWrite(nHdlLOG,cMenLOG)                                  
			EndIf


			FClose(nHdlLOG)

			MsgAlert("Gerado o arquivo de LOG: " + Chr(13)+Chr(10)+"C:\LOG_BILHETERIA.LOG")
		EndIf
	EndIf

Return(Nil)