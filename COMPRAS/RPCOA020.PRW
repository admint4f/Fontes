#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCOA020 บAutor  ณBruno Daniel Borges บ Data ณ  21/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastro de Analises de Rentabilidade de projetos           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCOA020()
Local aCores :=	{	{"ZZF_STATUS == 'A'", "BR_VERDE"		},;
					{"ZZF_STATUS == 'R'", "BR_VERMELHO"		},;
					{"ZZF_STATUS == 'P'", "BR_AMARELO"		},;
					{"ZZF_STATUS == 'E'", "BR_CINZA"		}}
Local cAprov := GetMv("MV_XUSRAPR",,"000001")					

Private cCadastro := "Analises de Rentabilidade de Projetos (Shows, Eventos, etc)"
Private aRotina := {}

If !(__cUserID $ cAprov)
	aRotina := {	{ "Pesquisar" 		,"AxPesqui"		, 0 , 1},; 
					{ "Visualizar" 		,"U_RPCO20_A"	, 0 , 2},; 
					{ "Incluir" 		,"U_RPCO20_A"	, 0 , 3},; 
					{ "Alterar" 		,"U_RPCO20_A"	, 0 , 4},; 
					{ "Excluir" 		,"U_RPCO20_A"	, 0 , 5},; 
					{ "Legenda" 		,"U_RPCO20_B"	, 0 , 6} }
//					{ "E-Mail Aprov."	,"U_RPCO20_L"	, 0 , 6} }
Else
	aRotina := {	{ "Pesquisar" 		,"AxPesqui"		, 0 , 1},; 
					{ "Visualizar" 		,"U_RPCO20_A"	, 0 , 2},; 
					{ "Legenda" 		,"U_RPCO20_B"	, 0 , 6},;
					{ "Aprova็ใo" 		,"U_RPCO20_F"	, 0 , 6},;
					{ "Gera PCO" 		,"U_RPCO20_I"	, 0 , 6} }
EndIf
						
dbSelectArea("ZZF")
ZZF->(dbSetOrder(1))

mBrowse(6,1,22,75,"ZZF",,,,,,aCores)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_A บAutor  ณBruno Daniel Borges บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de manutencao no cadastro                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCO20_A(x,y,nOpcBrowse)
Local oDlgMain      := Nil
Local oEnchoice     := Nil   
Local oFolders      := Nil  
Local oFonteTotal   := TFont():New("Arial",,20,,.T.)
Local aCoordenadas  := MsAdvSize(.T.)
Local nOpcGetD      := Iif(nOpcBrowse <> 2 .Or. nOpcBrowse <> 5,GD_INSERT+GD_DELETE+GD_UPDATE,0)
Local aHead1        := {}
Local aCols1        := {} 
Local aHead2        := {}
Local aCols2        := {} 
Local aHead3        := {}
Local aCols3        := {}   
Local aBotoes       := {	{"PESQUISA"	,{|| Pergunte("RPCOR1",.F.), mv_par01 := M->ZZF_ANALIS, mv_par02 :=  M->ZZF_ANALIS, U_RPCOR010(.T.) },"Impressใo do relat๓rio de analise dessa rentabilidade","Relatorio",},;
							{"BTCALC"	,{|| LJMsgRun("Recalculando Bilheteria...","Aguarde...",{|| RPCO20_J() }) },"Recalculo do valor de bilheteria","Calcular", } } 
							
Local aAreaBKP      := GetArea()
Local nOpcClick     := 0  
Local nCol          := 0 
Local i             := 0
Local nPosID        := 0
Local nTotCustos    := 0  
Local nPosTotal     := 0 
Local nPosConta     := 0
Local lTipoLock     := .F.

Private oGetDad1    := Nil   
Private oGetDad2    := Nil
Private oGetDad3    := Nil
Private oSayTotal   := Nil
Private oSayBilhe   := Nil

Private aTela[0][0]
Private aGets[0]     

ZZF->(RegToMemory("ZZF",nOpcBrowse == 3))

//Carrega os arrays da NewGetDados
aHead1  := Ret_Head_Cols("ZZG",nOpcBrowse,1,xFilial("ZZG")+M->ZZF_ANALIS,"ZZG->ZZG_FILIAL+ZZG->ZZG_ANALIS")[1]
aCols1  := Ret_Head_Cols("ZZG",nOpcBrowse,1,xFilial("ZZG")+M->ZZF_ANALIS,"ZZG->ZZG_FILIAL+ZZG->ZZG_ANALIS")[2]

aHead2  := Ret_Head_Cols("ZZH",nOpcBrowse,1,xFilial("ZZH")+M->ZZF_ANALIS,"ZZH->ZZH_FILIAL+ZZH->ZZH_ANALIS")[1]
aCols2  := Ret_Head_Cols("ZZH",nOpcBrowse,1,xFilial("ZZH")+M->ZZF_ANALIS,"ZZH->ZZH_FILIAL+ZZH->ZZH_ANALIS")[2]

aHead3  := Ret_Head_Cols("ZZI",nOpcBrowse,1,xFilial("ZZI")+M->ZZF_ANALIS,"ZZI->ZZI_FILIAL+ZZI->ZZI_ANALIS")[1]
aCols3  := Ret_Head_Cols("ZZI",nOpcBrowse,1,xFilial("ZZI")+M->ZZF_ANALIS,"ZZI->ZZI_FILIAL+ZZI->ZZI_ANALIS")[2] 
                     
nPosTotal := AScan(aHead2,{|x| AllTrim(x[2]) == "ZZH_TOTAL" })
AEval(aCols2,{|x| nTotCustos += x[nPosTotal] })

oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5],OemToAnsi("Analise de Rentabilidade"),,,,,,,,oMainWnd,.T.)
	oEnchoice := MsMGet():New("ZZF",ZZF->(RecNo()),Iif(nOpcBrowse == 4 .Or. nOpcBrowse == 3,3,nOpcBrowse),,,,,{014,003,oDlgMain:nClientHeight/7,oDlgMain:nClientWidth/2-5},,3,,,,,,.T.)
	
	oFolders := TFolder():New(oDlgMain:nClientHeight/7+3,003,{"&Mapa de Vendas","&Custos de Produ็ใo","&Receitas"},,oDlgMain,,,,.T.,.F.,oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-(oDlgMain:nClientHeight/7 + 35))
		oGetDad1 := MsNewGetDados():New(001,001,oFolders:aDialogs[1]:nClientHeight/2-25,oFolders:aDialogs[1]:nClientWidth/2-3,nOpcGetD,,,"+ZZG_ID",,,9999,,,,oFolders:aDialogs[1],aHead1,aCols1)
		oSayBilhe := TSay():New(oFolders:aDialogs[1]:nClientHeight/2-25,001,{|| "Total Bilheteria: R$ 0,00" + Chr(13) + Chr(10) + "Total Ingressos Disponiveis: 0" },oFolders:aDialogs[1],,oFonteTotal,.T.,,,.T.,CLR_BLUE,,oDlgMain:nWidth/2-5,20)
		
		oGetDad2 := MsNewGetDados():New(001,001,oFolders:aDialogs[2]:nClientHeight/2-30,oFolders:aDialogs[2]:nClientWidth/2-3,nOpcGetD,,,"+ZZH_ID",,,9999,,,,oFolders:aDialogs[2],aHead2,aCols2)
		ASort(oGetDad2:aCols,,,{|x,y| x[2] < y[2] })  
		
		oSayTotal := TSay():New(oFolders:aDialogs[2]:nClientHeight/2-25,001,{|| OemToAnsi("Total dos Custos de Produ็ใo: R$ " + AllTrim(Transform(nTotCustos,"@E 999,999,999.99")) )},oFolders:aDialogs[2],,oFonteTotal,.T.,,,.T.,CLR_BLUE,,oDlgMain:nWidth/2-5,20)
		oGetDad3 := MsNewGetDados():New(001,001,oFolders:aDialogs[3]:nClientHeight/2-5,oFolders:aDialogs[3]:nClientWidth/2-3,nOpcGetD,,,"+ZZI_ID",,,9999,,,,oFolders:aDialogs[3],aHead3,aCols3)
		
		If nOpcBrowse <> 3
			RPCO20_J(2)
		EndIf

	EnchoiceBar(oDlgMain,{|| IIf(Obrigatorio(aGets,aTela),nOpcClick := 1,nOpcClick := 0), Iif(nOpcClick == 1,oDlgMain:End(),Nil) },{|| oDlgMain:End()},,aBotoes)
oDlgMain:Activate(,,,.T.)  

//Gravacao dos Dados
If nOpcClick == 1 .And. nOpcBrowse <> 2
	//Cabecalho
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	ZZF->(RecLock("ZZF",nOpcBrowse == 3))
		ZZF->ZZF_FILIAL := xFilial("ZZF")
		//Altera็ใo realizada 21/08/2013
		//Iif(nOpcBrowse == 3,ZZF->ZZF_STATUS := "E",Nil) 
		If nOpcBrowse == 3
			IF !Empty(ZZF->ZZF_ELEPEP)
				ZZF->ZZF_STATUS := "P"
			Else
				ZZF->ZZF_STATUS := "E"
			EndIF
		ElseIf nOpcBrowse == 4
			IF !Empty(ZZF->ZZF_ELEPEP) .And. AllTrim(ZZF->ZZF_STATUS) == "E"
				ZZF->ZZF_STATUS := "P"
			EndIF
		EndIf
		If nOpcBrowse == 5
			ZZF->(dbDelete())
		Else
			AEval(oEnchoice:aGets,{|x| IIf(SX3->(dbSeek(SubStr(x,9,10))), ZZF->&(SubStr(x,9,10)) :=  &("M->"+SubStr(x,9,10)), Nil )  })
		EndIf
	ZZF->(MsUnlock())
	ConfirmSX8()
	
	//Detalhes da Configuracao
	RPCO20_C("ZZG",1,oGetDad1,nOpcBrowse,{AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_ID"  }) },"ZZG_ANALIS",M->ZZF_ANALIS)    

	//Custos de Producao
	RPCO20_C("ZZH",1,oGetDad2,nOpcBrowse,{AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_ID"  }) },"ZZH_ANALIS",M->ZZF_ANALIS)    

	//Receitas
	RPCO20_C("ZZI",1,oGetDad3,nOpcBrowse,{AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_ID"  }) },"ZZI_ANALIS",M->ZZF_ANALIS)    

      IF nOpcBrowse == 3
        u_RPCO20_l()
      EndIf
	
ElseIf nOpcBrowse == 0 .And. nOpcClick == 3
	RollBackSX8()
EndIf   

RestArea(aAreaBKP)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_B บAutor  ณBruno Daniel Borges บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLegenda do Browse                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCO20_B()
Local aCores :=	{	{"BR_VERDE"		,"Analise Migrada PCO"	   },;
					{"BR_VERMELHO"	,"Analise Rejeitada"	   },;
					{"BR_AMARELO"	,"Aguardando Aprova็ao"	   },;
					{"BR_CINZA"		,"Aguardando Elemento PEP" } }

BrwLegenda("Status de Analises de Projetos","Legenda",aCores)

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
Local aAreaBKP	:= GetArea()  
Local aHeader	:= {}
Local aCols		:= {}
Local i         := 0

//Monta o aHeader
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek(cAlias))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		Aadd(aHeader,	{	Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,; 
							SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
							SX3->X3_USADO,SX3->X3_TIPO,	;
							SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,,SX3->X3_WHEN,	;
							SX3->X3_VISUAL,SX3->X3_VLDUSER, SX3->X3_PICTVAR,SX3->X3_OBRIGAT	})	     
	EndIf
     
	SX3->(dbSkip())
EndDo    

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
ฑฑบPrograma  ณ RPCO10_C บAutor  ณBruno Daniel Borges บ Data ณ  23/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de gravacao das GetDados                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RPCO20_C(cAliasGet,nIndice,oGetDados,nOpcBrowse,aPosSeek,cCpoKey,cContKey) 
Local aAreaBKP := GetArea()
Local i,nLoop  := 0
Local lTpLock  := .F.  
Local cExpSeek := ""

Default cContKey := ""

//Gravacao de conteudo de modelo 2
dbSelectArea(cAliasGet)     
(cAliasGet)->(dbSetOrder(nIndice))
For i := 1 To Len(oGetDados:aCols)
	If nOpcBrowse == 3 .And. oGetDados:aCols[i][Len(oGetDados:aHeader)+1] //Linhas deletadas durante a inclusao
		Loop
	EndIf
	       
	//Monta Expressao do SEEK conforme array 
	cExpSeek := ""
	AEval(aPosSeek,{|x| cExpSeek += Iif(ValType(oGetDados:aCols[i][x]) == "D", DToS(oGetDados:aCols[i][x]),oGetDados:aCols[i][x])  })
	
	lTpLock := (cAliasGet)->(dbSeek(xFilial(cAliasGet)+cContKey+cExpSeek  ))
	     
	//Inclusao
	If nOpcBrowse == 3
		(cAliasGet)->(RecLock(cAliasGet,.T.))
		
	//Alteracao
	ElseIf nOpcBrowse == 4
		(cAliasGet)->(RecLock(cAliasGet,!lTpLock))
		
		If oGetDados:aCols[i][Len(oGetDados:aHeader)+1]
			(cAliasGet)->(RecLock(cAliasGet,.F.))
				(cAliasGet)->(dbDelete())
			(cAliasGet)->(MsUnlock())
			Loop
		EndIf
	
	//Exclusao
	ElseIf nOpcBrowse == 5      
		If lTpLock
			(cAliasGet)->(RecLock(cAliasGet,.F.))
				(cAliasGet)->(dbDelete())
			(cAliasGet)->(MsUnlock())
		EndIf
		Loop
	EndIf
	          
	//Gravacao do conteudo
	(cAliasGet)->&(cAliasGet+"_FILIAL") := xFilial(cAliasGet)    
	(cAliasGet)->&(cCpoKey)             := cContKey
	nLoop := 0
	AEval(oGetDados:aHeader,{|x| nLoop++, IIf(x[10] <> "V",(cAliasGet)->&(x[2]) := oGetDados:aCols[i][nLoop],Nil)  })	
	(cAliasGet)->(MsUnlock())
Next i

RestArea(aAreaBKP)

Return(.T.)     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_D บAutor  ณBruno Daniel Borges บ Data ณ  30/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de gatilho dos itens na pasta de Custos de Producao  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCO20_D()
Local aAreaBKP := GetArea() 
Local j        := 0
Local nLoop    := 0
Local nPosCol  := 0
Local nPosMod  := 0  
Local nLinha   := 0 
Local lNovaLinha := .F.

If ZZC->ZZC_XBLQ== "1"	

MsgAlert("Aten็ใo, Modelo informado etsแ bloqueado!!")

Return(.F.)

Endif


If Len(oGetDad2:aCols) >= 1 .And. !Empty(oGetDad2:aCols[1,AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_CONTA" })])
	If !MsgYesNo("Aten็ใo, a troca do modelo de projeto irแ apagar todos os Custos de Produ็ใo jแ informados. Confirma a troca ?")
		Return(.F.)
	EndIf
EndIf

oGetDad2:aCols := {}    

nPosCol := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_CONTA" })
nPosMod := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_VRMOD" })

//Recupera modelo de configuracao
dbSelectArea("ZZD")
ZZD->(dbSetOrder(1))
If ZZD->(dbSeek(xFilial("ZZD")+M->ZZF_MODELO))
	While ZZD->(!Eof()) .And. ZZD->ZZD_FILIAL + ZZD->ZZD_COD == xFilial("ZZD")+M->ZZF_MODELO
		If AScan(oGetDad2:aCols,{|x| AllTrim(x[nPosCol]) == AllTrim(ZZD->ZZD_CONTA) }) > 0
			nLinha := AScan(oGetDad2:aCols,{|x| AllTrim(x[nPosCol]) == AllTrim(ZZD->ZZD_CONTA) })
			lNovaLinha := .F.
		Else
			AAdd(oGetDad2:aCols,Array(Len(oGetDad2:aHeader)+1))	  
			nLinha := Len(oGetDad2:aCols)
			lNovaLinha := .T.
		EndIf

		nLoop++

		For j := 1 To Len(oGetDad2:aHeader)   
			If lNovaLinha                    
				If AllTrim(oGetDad2:aHeader[j,2]) == "ZZH_CONTA"
					oGetDad2:aCols[nLinha][j] := ZZD->ZZD_CONTA
				ElseIf AllTrim(oGetDad2:aHeader[j,2]) == "ZZH_QUANT"
					oGetDad2:aCols[nLinha][j] := 1
				ElseIf AllTrim(oGetDad2:aHeader[j,2]) == "ZZH_VRUNIT"
					oGetDad2:aCols[nLinha][j] := 0 //ZZD->ZZD_VALOR
				ElseIf AllTrim(oGetDad2:aHeader[j,2]) == "ZZH_DESC"
					oGetDad2:aCols[nLinha][j] := Posicione("AK5",1,xFilial("AK5")+ZZD->ZZD_CONTA,"AK5->AK5_DESCRI")
				ElseIf AllTrim(oGetDad2:aHeader[j,2]) == "ZZH_ID"
					oGetDad2:aCols[nLinha][j] := StrZero(nLoop,3)
				ElseIf AllTrim(oGetDad2:aHeader[j,2]) == "ZZH_VRMOD"
					oGetDad2:aCols[nLinha][j] := ZZD->ZZD_VALOR
				ElseIf AllTrim(oGetDad2:aHeader[j,2]) == "ZZH_TIPO"
					oGetDad2:aCols[nLinha][j] := ZZD->ZZD_TIPO
				Else
					oGetDad2:aCols[nLinha][j] := CriaVar(oGetDad2:aHeader[j,2])
				EndIf
			ElseIf !lNovaLinha .And. AllTrim(oGetDad2:aHeader[j,2]) == "ZZH_VRMOD"
				oGetDad2:aCols[nLinha][j] := ZZD->ZZD_VALOR
			EndIf
		Next j
		oGetDad2:aCols[nLinha][Len(oGetDad2:aHeader)+1] := .F.
		ZZD->(dbSkip())
	EndDo
	
	//Ordena por Codigo de Conta Orcamentaria
	ASort(oGetDad2:aCols,,,{|x,y| x[nPosCol] < y[nPosCol] })
EndIf
RestArea(aAreaBKP)

oGetDad2:Refresh()

U_RPCO20_H()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_E บAutor  ณBruno Daniel Borges บ Data ณ  30/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de gatilho dos itens na pasta de Detalhes da Confi-  บฑฑ
ฑฑบ          ณguracao                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCO20_E()
Local aAreaBKP 	:= GetArea() 
Local i,j     	:= 0   
Local nPosQtd  	:= 0
Local nPosVlr 	:= 0                                               
Local nPosPatroc:= 0
Local nPosArtis := 0
Local nPosCasa  := 0
Local nPosRadio := 0
Local nReceita  := 0     
Local cContaRec := GetMv("MV_XCNTREC",,"020101")  
Local nPosConta := 0
Local nPosQtdRec:= 0
Local nPosTot   := 0   
Local nPosDesc  := 0  
Local nTotCort  := 0   
Local nCortesias:= 0
Local nDispVenda:= 0  
Local nTotBilhet:= 0

If Len(oGetDad1:aCols) >= 1 .And. !Empty(oGetDad1:aCols[1,AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_SETOR" })])
	If !MsgYesNo("Aten็ใo, a troca do modelo de configura็ใo irแ apagar todos os Detalhes de Configura็ใo e as possiveis Receitas inseridas manualmente. Confirma a troca ?")
		Return(.F.)
	EndIf
EndIf

oGetDad1:aCols := {} 

nPosQtd 	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QUANT" 	})
nPosVlr 	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_VALOR" 	})
nPosPatroc	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QTDPAT" 	})
nPosArtis 	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QTDART" 	})
nPosCasa  	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QTDCAS" 	})
nPosRadio 	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QTDRAD" 	}) 
nTotCort    := AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_TOTAL" 	}) 
nDispVenda	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_VENDA" 	}) 
nTotBilhet	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_BILHET" 	}) 

//Recupera modelo de configuracao
dbSelectArea("SZK")
SZK->(dbSetOrder(1))
If SZK->(dbSeek(xFilial("SZK")+M->ZZF_CONFIG))
	For i := 1 To 12
		If !Empty(SZK->&("ZK_SETOR"+AllTrim(Str(i))) )
			AAdd(oGetDad1:aCols,Array(Len(oGetDad1:aHeader)+1))	
			For j := 1 To Len(oGetDad1:aHeader)                       
				If AllTrim(oGetDad1:aHeader[j,2]) == "ZZG_SETOR"
					oGetDad1:aCols[Len(oGetDad1:aCols)][j] := SZK->&("ZK_SETOR"+AllTrim(Str(i)))
				ElseIf AllTrim(oGetDad1:aHeader[j,2]) == "ZZG_QUANT"
					oGetDad1:aCols[Len(oGetDad1:aCols)][j] := SZK->&("ZK_QUANT"+AllTrim(Str(i)))
				ElseIf AllTrim(oGetDad1:aHeader[j,2]) == "ZZG_VALOR"
					oGetDad1:aCols[Len(oGetDad1:aCols)][j] := SZK->&("ZK_VALOR"+AllTrim(Str(i)))
				ElseIf AllTrim(oGetDad1:aHeader[j,2]) == "ZZG_QTDPAT"
					oGetDad1:aCols[Len(oGetDad1:aCols)][j] := SZK->&("ZK_PAT"+AllTrim(Str(i)))   
				ElseIf AllTrim(oGetDad1:aHeader[j,2]) == "ZZG_ID"
					oGetDad1:aCols[Len(oGetDad1:aCols)][j] := StrZero(i,3)
				Else
					oGetDad1:aCols[Len(oGetDad1:aCols)][j] := CriaVar(oGetDad1:aHeader[j,2])
				EndIf
			Next j

			oGetDad1:aCols[Len(oGetDad1:aCols)][Len(oGetDad1:aHeader)+1] := .F.          
			oGetDad1:aCols[Len(oGetDad1:aCols)][nTotCort] 		:= oGetDad1:aCols[Len(oGetDad1:aCols)][nPosPatroc] + oGetDad1:aCols[Len(oGetDad1:aCols)][nPosArtis] + oGetDad1:aCols[Len(oGetDad1:aCols)][nPosCasa] + oGetDad1:aCols[Len(oGetDad1:aCols)][nPosRadio]
			oGetDad1:aCols[Len(oGetDad1:aCols)][nDispVenda] 	:= oGetDad1:aCols[Len(oGetDad1:aCols)][nPosQtd] - oGetDad1:aCols[Len(oGetDad1:aCols)][nTotCort]
			oGetDad1:aCols[Len(oGetDad1:aCols)][nTotBilhet]	:= ((1-M->ZZF_TXESTU/100)*oGetDad1:aCols[Len(oGetDad1:aCols)][nPosVlr]+(M->ZZF_TXESTU/100*oGetDad1:aCols[Len(oGetDad1:aCols)][nPosVlr]/2))*oGetDad1:aCols[Len(oGetDad1:aCols)][nDispVenda]
			
			//Totaliza a receita de bilheteria
			nReceita += oGetDad1:aCols[Len(oGetDad1:aCols)][nPosQtd] * oGetDad1:aCols[Len(oGetDad1:aCols)][nPosVlr] - (oGetDad1:aCols[Len(oGetDad1:aCols)][nPosVlr] * (oGetDad1:aCols[Len(oGetDad1:aCols)][nPosPatroc] + oGetDad1:aCols[Len(oGetDad1:aCols)][nPosArtis] + oGetDad1:aCols[Len(oGetDad1:aCols)][nPosCasa] + oGetDad1:aCols[Len(oGetDad1:aCols)][nPosRadio] ))
		EndIf	
	Next i
EndIf 

//Zera o Array de Receitas e preenche a conta de BILHETERIA
oGetDad3:aCols := {}
nPosConta := AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_CONTA"	})
nPosQtdRec:= AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_QTD" 	})
nPosTot   := AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_TOTAL" 	})	
nPosDesc  := AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_DESC" 	})	

AAdd(oGetDad3:aCols,Array(Len(oGetDad3:aHeader)+1))
oGetDad3:aCols[Len(oGetDad3:aCols)][1] 			:= "001"
oGetDad3:aCols[Len(oGetDad3:aCols)][nPosConta] 	:= cContaRec   
oGetDad3:aCols[Len(oGetDad3:aCols)][nPosDesc]		:= Posicione("AK5",1,xFilial("AK5")+cContaRec,"AK5->AK5_DESCRI")
oGetDad3:aCols[Len(oGetDad3:aCols)][nPosQtdRec] 	:= 1
oGetDad3:aCols[Len(oGetDad3:aCols)][nPosTot] 		:= nReceita
oGetDad3:aCols[Len(oGetDad3:aCols)][Len(oGetDad3:aHeader)+1] := .F.
oGetDad3:Refresh()

RestArea(aAreaBKP)

oGetDad1:Refresh()

Return(.T.)
           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_F บAutor  ณBruno Daniel Borges บ Data ณ  30/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de aprovacao/rejeicao de analises de rentabilidade   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCO20_F()
Local nOpc    := 0               
Local cElePEP := Space(20)
Local cDesc   := ""
Local oDlgMain:= Nil
Local oFolder := Nil   

If !(ZZF->ZZF_STATUS $ "P|E")
	MsgAlert("Aten็ใo, apenas anแlises pendentes de aprova็ใo podem ser aprovadas/rejeitadas.")
	Return(Nil)
EndIf

nOpc := Aviso("Aprova็ใo Anแlise de Rentabilidade","Selecione o botใo correspondente a op็ใo desejada.",{"Aprovar","Rejeitar","Voltar"})

If nOpc == 1                                                            
	If MsgYesNo("Aten็ใo, deseja confirmar a efetiva็ใo dessa anแlise ao m๓dulo PCO ?")
		//Tela de selecao do elemento PEP
		If Empty(ZZF->ZZF_ELEPEP)  
			oDlgMain := TDialog():New(000,000,80,400,OemToAnsi("Sele็ใo do Elemento PEP"),,,,,,,,oMainWnd,.T.)
				TSay():New(001,001,{|| OemToAnsi("C๓digo do Elemento PEP")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
				@ 015,001 MsGet cElePEP Picture "@!" F3 "CTD"  Valid(cDesc := Posicione("CTD",1,xFilial("CTD")+AllTrim(cElePEP),"CTD->CTD_DESC01" ))  Size 060,8 Of oDlgMain Pixel
				@ 015,070 MsGet cDesc Picture "@!" When .F. Size oDlgMain:nClientWidth/2-80,8 Of oDlgMain Pixel
				TButton():New(030,001,OemToAnsi("Confirmar"),oDlgMain,{|| nOpc := 1 , oDlgMain:End()  },040,010,,,,.T.,,,,{|| })   			
				TButton():New(030,050,OemToAnsi("Cancelar"),oDlgMain,{|| nOpc := 0 , oDlgMain:End()  },040,010,,,,.T.,,,,{|| })   			
			oDlgMain:Activate(,,,.T.)	 
			
			If nOpc == 1 .And. !Empty(cElePEP)		
				ZZF->(RecLock("ZZF",.F.))
					ZZF->ZZF_ELEPEP := cElePEP
				ZZF->(MsUnlock())
				LJMsgRun("Aguarde, gerando lan็amentos or็amentแrios","Aguarde...",{|| RPCO20_G() })
			EndIf
		Else
			LJMsgRun("Aguarde, gerando lan็amentos or็amentแrios","Aguarde...",{|| RPCO20_G() })
		EndIf
	EndIf
ElseIf nOpc == 2              
	ZZF->(RecLock("ZZF",.F.))
		ZZF->ZZF_STATUS := "R"
	ZZF->(MsUnlock())
	MsgAlert("Aten็ใo, essa anแlise de rentabilidade foi rejeitada. No caso de reavalia็ใo deverแ ser feita uma nova inclusใo.")
EndIf

Return(Nil)
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_G บAutor  ณBruno Daniel Borges บ Data ณ  30/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de geracao do orcamento no PCO na aprovacao de uma   บฑฑ
ฑฑบ          ณanalise de rentabilidade                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RPCO20_G()
Local aAreaBKP   := GetArea()
Local cCodLancto := GetMv("MV_XPCOANA",,"900001")

Begin Transaction
	PCOIniLan(cCodLancto)

	dbSelectArea("ZZH")
	ZZH->(dbSetOrder(1))
	ZZH->(dbSeek(xFilial("ZZH")+ZZF->ZZF_ANALIS))
	While ZZH->(!Eof()) .And. ZZH->ZZH_FILIAL + ZZH->ZZH_ANALIS == xFilial("ZZH")+ZZF->ZZF_ANALIS
		PCODetLan(cCodLancto,"01","RPCOA020",.F.)
		ZZH->(dbSkip())
	EndDo
	
	PCOFinLan(cCodLancto)
End Transaction

ZZF->(RecLock("ZZF",.F.))
	ZZF->ZZF_STATUS := "A"
	ZZF->ZZF_DTAPRO := dDataBase
ZZF->(MsUnlock())      

MsgAlert("Aten็ใo, essa anแlise de rentabilidade foi aprovada e o or็amento foi migrado para o controle or็amentแrio.")

RestArea(aAreaBKP)           

Return(Nil)
           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_H บAutor  ณBruno Daniel Borges บ Data ณ  26/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de calculo do total dos custos de producao e atuali- บฑฑ
ฑฑบ          ณzacao da mensagem na tela                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCO20_H()
Local i         := 0
Local nPosTotal := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_TOTAL"  })
Local nPosUnit  := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_VRUNIT" })
Local nPosFator := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_FATOR"  })
Local nPosQtd   := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_QTD"    })
Local nValTotal := 0         
Local aValores  := {0,0,0}

For i := 1 To Len(oGetDad2:aCols)           
	If !oGetDad2:aCols[i,Len(oGetDad2:aHeader)+1]
		If i == oGetDad2:nAt //Gatilho 
			If ReadVar() == "M->ZZH_QTD"  
				nValTotal += M->ZZH_QTD * IIF(oGetDad2:aCols[i,nPosFator] > 0,oGetDad2:aCols[i,nPosFator],1) * oGetDad2:aCols[i,nPosUnit]
			ElseIf ReadVar() == "M->ZZH_VRUNIT"
				nValTotal += oGetDad2:aCols[i,nPosQtd] * IIF(oGetDad2:aCols[i,nPosFator] > 0,oGetDad2:aCols[i,nPosFator],1) * M->ZZH_VRUNIT
			ElseIf ReadVar() == "M->ZZH_FATOR" 
				nValTotal += oGetDad2:aCols[i,nPosQtd] * IIF(M->ZZH_FATOR > 0,M->ZZH_FATOR,1) * oGetDad2:aCols[i,nPosUnit]
			EndIf
		Else
			nValTotal += oGetDad2:aCols[i,nPosTotal]
		EndIf
	EndIf
Next i 

oSayTotal:SetText(OemToAnsi("Total dos Custos de Produ็ใo: R$ " + AllTrim(Transform(nValTotal,"@E 999,999,999.99")) ))
oSayTotal:Refresh()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_I บAutor  ณBruno Daniel Borges บ Data ณ  28/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de efetivacao de uma analise aprovada para saldos    บฑฑ
ฑฑบ          ณno PCO                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCO20_I()

/*
If ZZF->ZZF_STATUS <> "P"
	MsgAlert("Aten็ใo, essa anแlise nใo esta com status vแlido para gera็ใo de lan็amentos no PCO.")
	Return(Nil)
EndIf

If Empty(ZZF->ZZF_ELEPEP)
	MsgAlert("Aten็ใo, essa anแlise nใo esta com o Elemento PEP informado. Nใo ้ possํvel efetivแ-la sem o elemento PEP")
	Return(Nil)
EndIf
*/

RPCO20_G()

Return(Nil)
                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_J บAutor  ณBruno Daniel Borges บ Data ณ  29/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de recalculo da bilheteria conforme mudanca nos cam- บฑฑ
ฑฑบ          ณpos de VARIAVEIS que influenciam no calculo                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RPCO20_J(nOpcAtu)
Local nReceita := 0
Local i
Local nPosQtd  	:= 0
Local nPosVlr 	:= 0                                               
Local nPosPatroc:= 0
Local nPosArtis := 0
Local nPosCasa  := 0
Local nPosRadio := 0    
Local nQtd      := 0
Local nPosConta := 0
Local nPosQtdRec:= 0
Local nPosTot   := 0
Local nPosDesc  := 0
Local cContaRec := GetMv("MV_XCNTREC",,"020101")  
Local nTotCort  := 0   
Local nDispVenda:= 0  
Local nTotBilhet:= 0     
Local nTotDispV := 0
Local cRedutCache := GetMv("MV_XREDCAC",,"010301") 
Local nPercArt  := 0
Local nRedutCache := 0 
Local nPosCusto := 0
Local nPosCache := 0
Local nTotBruto := 0

Default nOpcAtu := 0

nPosQtd 	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QUANT" 	})
nPosVlr 	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_VALOR" 	})
nPosPatroc	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QTDPAT" 	})
nPosArtis 	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QTDART" 	})
nPosCasa  	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QTDCAS" 	})
nPosRadio 	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_QTDRAD" 	})
nTotCort    := AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_TOTAL" 	}) 
nDispVenda	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_VENDA" 	}) 
nTotBilhet	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZG_BILHET" 	})
nPercArt    := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_PERC" 	})  
nPosCusto   := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_TOTAL" 	}) 
nPosCache   := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_CONTA" 	}) 

//Calcula conforme configuracao dos SHOWS
For i := 1 To Len(oGetDad1:aCols) 
	If oGetDad1:aCols[i,Len(oGetDad1:aHeader)+1]
		Loop
	EndIf
	
	nQtd += oGetDad1:aCols[i][nPosQtd]    

	oGetDad1:aCols[i][nTotCort] 	:= oGetDad1:aCols[i][nPosPatroc] + oGetDad1:aCols[i][nPosArtis] + oGetDad1:aCols[i][nPosCasa] + oGetDad1:aCols[i][nPosRadio]
	oGetDad1:aCols[i][nDispVenda]	:= oGetDad1:aCols[i][nPosQtd] - oGetDad1:aCols[i][nTotCort]
	oGetDad1:aCols[i][nTotBilhet] 	:= ((1-M->ZZF_TXESTU/100)*oGetDad1:aCols[i][nPosVlr]+(M->ZZF_TXESTU/100*oGetDad1:aCols[i][nPosVlr]/2))*oGetDad1:aCols[i][nDispVenda]
                                         
	nTotDispV += oGetDad1:aCols[i][nDispVenda]
	nReceita += oGetDad1:aCols[i][nTotBilhet]
	nTotBruto += oGetDad1:aCols[i][nTotBilhet]
Next i


//Deduz a taxa de Estudante
If M->ZZF_TXESTU > 0   
	M->ZZF_PRCMED := nReceita / nTotDispV
EndIf          

nReceita := nReceita * Iif(M->ZZF_QTDAPR > 0,M->ZZF_QTDAPR,1)

//Calcula a taxa de Ocupacao
If M->ZZF_TXOCUP > 0
	M->ZZF_PUBEST := Round(nTotDispV*(M->ZZF_TXOCUP/100),0)
	nReceita := Round(nReceita*(M->ZZF_TXOCUP/100),0)
EndIf

oGetDad3:aCols := {}
nPosConta := AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_CONTA"	})
nPosQtdRec:= AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_QTD" 	})
nPosTot   := AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_TOTAL" 	})
nPosDesc  := AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_DESC" 	})

AAdd(oGetDad3:aCols,Array(Len(oGetDad3:aHeader)+1))
oGetDad3:aCols[Len(oGetDad3:aCols)][1] 			:= "001"
oGetDad3:aCols[Len(oGetDad3:aCols)][nPosConta] 	:= cContaRec   
oGetDad3:aCols[Len(oGetDad3:aCols)][nPosDesc]		:= Posicione("AK5",1,xFilial("AK5")+cContaRec,"AK5->AK5_DESCRI")
oGetDad3:aCols[Len(oGetDad3:aCols)][nPosQtdRec] 	:= 1
oGetDad3:aCols[Len(oGetDad3:aCols)][nPosTot] 		:= nReceita //* Iif(M->ZZF_QTDAPR > 0,M->ZZF_QTDAPR,1)
oGetDad3:aCols[Len(oGetDad3:aCols)][Len(oGetDad3:aHeader)+1] := .F.
oGetDad3:Refresh()

//Atualiza os totais
oSayBilhe:SetText("Total Bilheteria: R$ " + AllTrim(Transform(nTotBruto,"@E 999,999,999.99")) + Chr(13) + Chr(10) + "Total Ingressos Disponiveis: " + AllTrim(Transform(nTotDispV,"@E 999,999,999")) )
oSayBilhe:Refresh()

//Recalculo do CACHE
If nOpcAtu <> 2
	nRedutCache := 0
	nLinCache   := 0
	For i := 1 To Len(oGetDad2:aCols)
		If oGetDad2:aCols[i][nPercArt] > 0 .And. !(oGetDad2:aCols[i][nPosCache] $ cRedutCache)
			nRedutCache += oGetDad2:aCols[i][nPosCusto]
		ElseIf (AllTrim(oGetDad2:aCols[i][nPosCache]) $ cRedutCache)
			nLinCache := i
		EndIf
	Next i 
	
	If nLinCache > 0
		nReceita -= nRedutCache                 

		If (nReceita * ( M->ZZF_TXPART / 100 )) < M->ZZF_CACHE
			oGetDad2:aCols[nLinCache][nPosCusto] := M->ZZF_CACHE
		Else
			oGetDad2:aCols[nLinCache][nPosCusto] := nReceita * ( M->ZZF_TXPART / 100 )
		EndIf
		
		oGetDad2:Refresh()   
	EndIf
EndIf
		
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPCOA020  บAutor  ณMicrosiga           บ Data ณ  08/29/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCO20_K()
Local nPosTipo  := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_TIPO"		})
Local nPosQtde  := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_QTD"		})
Local nPosFator := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_FATOR"	})
Local nPosRec   := AScan(oGetDad3:aHeader,{|x| AllTrim(x[2]) == "ZZI_TOTAL"	})
Local nPosVrUnit:= AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_VRUNIT"	})
Local nPosVrTot := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_TOTAL"	})
Local nPosconta := AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZH_CONTA"	})
Local nReceita  := 0       
Local aContRedut:= {}  
Local nValor    := 0  
Local nRedut    := 0   
Local nRetorno  := 0
Local i    
Local aAreaBKP  := GetArea()
Local cRedutCC  := GetMv("MV_XREDCNT",,"010202")  

For i := 1 To Len(oGetDad3:aCols)
	If !oGetDad3:aCols[i][Len(oGetDad3:aHeader)+1]
		nReceita += oGetDad3:aCols[i][nPosRec]
	EndIf
Next i

//Busca contas que sao redutoras do modelo quando % sobre o bruto
If oGetDad2:aCols[N][nPosTipo] == "2"
	dbSelectArea("ZZC")
	ZZC->(dbSetOrder(1))
	ZZC->(dbSeek(xFilial("ZZC")+M->ZZF_MODELO ))
	
	dbSelectArea("ZZO")
	ZZO->(dbSetOrder(1))
	ZZO->(dbSeek(xFilial("ZZO")+ZZC->ZZC_TEMPLA  ))
	While ZZO->(!Eof()) .And. ZZO->ZZO_FILIAL + ZZO->ZZO_CODIGO == xFilial("ZZO")+ZZC->ZZC_TEMPLA
		If ZZO->ZZO_REDUT == "1"
			Aadd(aContRedut,ZZO->ZZO_CONTA)
		EndIf
	     
		ZZO->(dbSkip())
	EndDo           
	
	//Soma os dedutores de base de receita
	For i := 1 To Len(oGetDad2:aCols)
		If !oGetDad2:aCols[i][Len(oGetDad2:aHeader)+1]   
			nValor := 0
			If AScan(aContRedut,{|x| AllTrim(x) == AllTrim(oGetDad2:aCols[i][nPosconta]) } ) > 0
				nValor := oGetDad2:aCols[i][nPosQtde] * IIf(oGetDad2:aCols[i][nPosFator] > 0,oGetDad2:aCols[i][nPosFator],1)
				//If oGetDad2:aCols[i][nPosTipo] $ "1|2"
				//	nValor := nValor * (oGetDad2:aCols[i][nPosVrUnit]/100 * nReceita)
				//Else
					nValor := nValor * oGetDad2:aCols[i][nPosVrTot]
				//EndIf
			EndIf 
			nRedut += nValor		
		EndIf
	Next i

	nRetorno := M->ZZH_VRUNIT / 100 * (nReceita - nRedut)

//% Sobre o Bruto
ElseIf oGetDad2:aCols[N][nPosTipo] == "1"    
	If AllTrim(oGetDad2:aCols[N][nPosconta]) $ cRedutCC
		nReceita := nReceita * (M->ZZF_CARTAO / 100)          
	EndIf
	nRetorno := M->ZZH_VRUNIT / 100 * nReceita
                                                     
//Valor Fixo
ElseIf oGetDad2:aCols[N][nPosTipo] == "3"
	nRetorno := M->ZZH_VRUNIT * oGetDad2:aCols[N][nPosQtde]
EndIf   

RestArea(aAreaBKP)

Return(nRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCO20_L บAutor  ณBruno Daniel Borges บ Data ณ  29/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de envio de email aos aprovadores de analise de ren- บฑฑ
ฑฑบ          ณtabilidade apos inclusao dos dados                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RPCO20_L()                                                               
Local cEmailAprov := GetMv("MV_XMAILREN",,"jgodoy@t4f.com.br","mramos@t4f.com.br")
//Local cEmailAprov := GetMv("MV_XMAILREN",,"microsiga01@t4f.com.br")
If !U_Mail_T4F(cEmailAprov,"Solicitacao de Elemento PEP / Efetivacao PCO: Rentabilidade " + ZZF->ZZF_ANALIS,"A analise de rentabilidade " + ZZF->ZZF_ANALIS + " foi incluida no sistema e esta aguardando o Elemento PEP e efetivacao no modulo PCO p/ inclusao de solicitacoes de compras",.F.)
	MsgAlert("Nao foi possivel enviar o email para o depto. de Planejamento p/ insercao do Elemento PEP")
Else
	MsgAlert("Email enviado com sucesso para o depto. de Planejamento p/ insercao do Elemento PEP")
EndIf	

Return(Nil)