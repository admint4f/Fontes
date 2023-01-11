#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA110BUT  บAutor  ณDenis D Almeida     บ Data ณ  08/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Menu Protheus com vแrias opcoes customizadas               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Menus - Protheus Solicita็ใo de Compras                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function MA110BUT()

Local aRetorno 		:= {}
Local aRetArea		:= Getarea()
Local aRetSZ2		:= SZ2->(Getarea())
Local aRetSC1		:= SC1->(Getarea())
Local aRetZZ4		:= ZZ4->(Getarea())
Local aRetZZ5		:= ZZ5->(Getarea())
Local aRetZZ6		:= ZZ6->(Getarea())
Local aRetCTD		:= CTD->(Getarea())
Local aRetZZU		:= ZZU->(Getarea())
Local aRetAKJ		:= AKJ->(Getarea())
Local aRetAL4		:= AL4->(Getarea())
Local lPrjCni 		:= FindFunction("ValidaCNI") .And. ValidaCNI()
Local lDbm 			:= aliasIndic("DBM")
Local cSolic 		:= SC1->C1_SOLICIT

Static cNumSC1		:= ""
Static aRateioCC	:= {}
Static aColsAux   	:= {}
Static lBlqPCO    	:= .F.
Static lPCO   		:= .F.

lBlqPCO      := .F.
lPCO   		 := .F.

cNumSC1 := cA110Num

If IntePms()		// Se usa PMS integrado com o ERP
	aRetorno := {{'PROJETPMS',{||Eval(bPmsDlgSC)},"PMS" + " - <F10>" ,'PMS'}}
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Botao para consultar Historico do Produto               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aadd(aRetorno,{"S4WB005N",{|| A110ComView() },"Hist.Produtos","Historico de Produtos" })

If !AtIsRotina("A110TRACK")
	AAdd(aRetorno  ,{ "bmpord1", {|| A110Track() }, OemToAnsi("Tracker"), OemToAnsi("System Tracker") } )  //
EndIf

If FindFunction("RemoteType") .And. RemoteType() == 1
	aAdd(aRetorno ,{PmsBExcel()[1],{|| DlgToExcel({{"CABECALHO","",{RetTitle("C1_NUM") ,RetTitle("C1_SOLICIT"),RetTitle("C1_EMISSAO"),RetTitle("C1_FILENT")},{cA110Num,cSolic ,dA110Data,cFilEnt}},{"GETDADOS","",aHeader,aCols}})},PmsBExcel()[2],PmsBExcel()[3]})
EndIf

if lPrjCni
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Insere o botao de rateio financeiro na tela de visualiza็ใo         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Aadd(aRetorno,{'DESTINOS',{|| F641AltRat("MATA110",2) },"Visualizar Rateio Financeiro","Rat.Financ."})
EndIf

If SuperGetMv("MV_APRSCEC",.F.,.F.) .AND.  lDbm
	Aadd(aRetorno,{"S4WB005N",{|| a120Posic(cAlias,nReg,nOpcX,"SC")},OemToAnsi("Pos.Pedidos"), OemToAnsi("Posi็ใo de Pedidos")})
Endif


Aadd(aRetorno,{"CLIPS"		,{|| u_Anexa_Documento(cNumSC1)	}	,"Anexar documentos na solicita็ใo de compras","Anexo" })
Aadd(aRetorno,{"EDITABLE"	,{|| Justificativa() 	}			,"Justificativa da necessidade dos produtos dessa solicita็ใo de compras.","Motivo" })
Aadd(aRetorno,{"S4WB013N"	,{|| U_Rateio_CC() 		}			,"Rateio entre vแrios centros de custo dessa solicita็ใo.","Rateio" })
Aadd(aRetorno,{"CHECKED"	,{|| IIF(INCLUI,Nil,U_T4FRATGER())}	,"Consulta do historico de aprova็ใo","Aprov." })

aRateioCC := {}

//Busca o rateio da S.C.
dbSelectArea("SZ2")
SZ2->(dbSetOrder(2))
SZ2->(dbSeek(xFilial("SZ2")+cA110Num))
While SZ2->(!Eof()) .And. SZ2->Z2_FILIAL + SZ2->Z2__SC1 == xFilial("SZ2")+cA110Num
	If Alltrim(SZ2->Z2_TIPO) == "S"
		AAdd(aRateioCC,{	SZ2->Z2_ITEM,;
		SZ2->Z2_PERC,;
		SZ2->Z2_CONTA,;
		SZ2->Z2_ITEMCTA,;
		SZ2->Z2_CLVL,;
		SZ2->Z2_CC ,;
		SZ2->Z2_VALOR,;
		SZ2->Z2_ITEMSC })
	Endif
	SZ2->(dbSkip())
EndDo


//Botoes especificos de aprovadores
If Upper(AllTrim(FunName())) <> "MATA110"
	Aadd(aRetorno,{"BUDGETY"	,{||  U_RCOMA60A() },"Aprova็ใo ou Rejei็ใo da Solicita็ใo de Compras","Aprovar" })
EndIf

RESTAREA(aRetArea)
RESTAREA(aRetSZ2)
RESTAREA(aRetSC1)
RESTAREA(aRetZZ4)
RESTAREA(aRetZZ5)
RESTAREA(aRetZZ6)
RESTAREA(aRetCTD)
RESTAREA(aRetZZU)
RESTAREA(aRetAKJ)
RESTAREA(aRetAL4)
Return(aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAnexa_DocumentoบAutor  ณBruno Daniel Borges บ Data ณ  18/03/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de Downdload e Upload de arquivos ZIPs                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณAlterado a funcao Upper() por Lower() limitacao Linux - Sergio C.บฑฑ
ฑฑบ          ณAlterado Chamada da funcao de Static para User function pois     บฑฑ
ฑฑบ          ณEsta funcao foi utilizada para outros fontes desenvolvidos       บฑฑ
ฑฑบ          ณ                                                                 บฑฑ
ฑฑบ          ณ                                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Anexa_Documento(cNumSC1)
Local nTipoPrc	:= Aviso("Tipo de Opera็ใo","Clique no botใo abaixo conforme o tipo de opera็ใo a ser efetuada.",{"Anexar","Download","Cancelar"})
Local cPathZIPs	:= Lower(AllTrim(GetMv("MV_XPATHZIP",,"\anexos_scs\"))) //Para utilizar com linux deve-se utilizar a funcao Lower
Local cFileOrig	:= ""
Local cPathDest	:= ""
Local i

If FunName(0) == "MATA121" //Caso seja anexo dos pedidos de compras
	cPathZIPs := Lower(AllTrim(GetMv("MV_PATZIPPC",,"\anexos_pcs\")))
Endif

//Anexar documento
If nTipoPrc == 1 .And. (INCLUI .Or. ALTERA)
	If (File(Lower(cPathZIPs)+Lower(cNumSC1)+".zip") .And. MsgYesNo("Aten็ใo, jแ existe um anexo a essa solicita็ใo/Pedido. Deseja sobrescrev๊-lo ?")) .Or. !File(Lower(cPathZIPs)+Lower(cNumSC1)+".zip")
		MontaDir(Lower(cPathZIPs))
		cFileOrig := cGetFile( "Arquivos Compactados(*.zip)  |*.zip" , "Selecione o arquivo com o(s) anexo(s) da Solicita็ใo/Pedidos de Compras." )
	EndIf
	
	If !Empty(cFileOrig)
		Cpyt2s(Lower(AllTrim(cFileOrig)),Lower(cPathZIPs),.F.)
		For i := Len(cFileOrig) To 1 Step -1
			If SubStr(cFileOrig,i,1) == "\"
				cFileOrig := SubStr(cFileOrig,i+1)
				Exit
			EndIf
		Next i
		
		FRename(Lower(cPathZIPs+cFileOrig),Lower(cPathZIPs+cNumSC1+Right(cFileOrig,4)))
		MsgAlert("Arquivo anexado com sucesso.")
	EndIf
	
	//Download do documento
ElseIf nTipoPrc == 2
	If !File(Lower(cPathZIPs+cNumSC1)+".zip")
		MsgAlert("Aten็ใo, nใo hแ anexo(s) para essa solicita็ใo de compras.")
		Return(Nil)
	Else
		cPathDest := cGetFile("\", "Diretorio Destino",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
		If !Empty(cPathDest)
			CpyS2T(Lower(cPathZIPs+cNumSC1)+".zip",Lower(cPathDest),.F.)
			MsgAlert("O arquivo " + Lower(cPathDest)+Lower(cNumSC1)+".zip foi copiado com o(s) anexo(s) dessa solicita็ใo/Pedidos de compras.")
		EndIf
	EndIf
EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJustificativaบAutor  ณBruno Daniel Borges บ Data ณ  07/04/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para edicao e/ou consulta do movito da inclusao da SC     บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Justificativa()
Local oDlgMain		:= Nil
Local aCoordenadas	:= MsAdvSize()
Local cTexto		:= ""
Local nPosObs		:= AScan(aHeader,{|x| AllTrim(x[2]) == "C1_OBSPAD" })
Local i

If !INCLUI
	cTexto := aCols[1,nPosObs]
EndIf

//Tela com o movito da solicitacao de compra
oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6]/1.8,aCoordenadas[5]/1.9,OemToAnsi("Motivo da Solicita็ใo de Compras"),,,,,,,,oMainWnd,.T.)
If Upper(AllTrim(FunName())) == "MATA110"
	TSay():New(005,005,{|| OemToAnsi("Informe abaixo o motivo pelo qual a solicita็ใo de compras esta sendo incluํda.")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
Else
	TSay():New(005,005,{|| OemToAnsi("Abaixo as justificativas (motivo) informado pelo solicitante na inclusใo da solicita็ใo de compras.")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
EndIf
TMultiGet():New(020,005, bSETGET(cTexto),oDlgMain,oDlgMain:nClientWidth/2-15,oDlgMain:nClientHeight/2-60,,.F.,,,,.T.)
TButton():New(oDlgMain:nClientHeight/2-30,005,OemToAnsi("&Gravar"),oDlgMain,{|| oDlgMain:End()},025,010,,,,.T.,,,,{||})
oDlgMain:Activate(,,,.T.)

//Atualiza as linhas no campo OBS. CONTINUA
If (INCLUI .Or. ALTERA) .And. Upper(AllTrim(FunName())) == "MATA110"
	For i := 1 To Len(aCols)
		aCols[i,nPosObs] := cTexto
	Next i
EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Rateio_CCบAutor  ณBruno Daniel Borges บ Data ณ  22/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de rateio por multiplos centros de custo na solicita-บฑฑ
ฑฑบ          ณcao de compras e pedido de compras                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Rateio_CC(nOrigem)

Local aHeadSZ2		:= {}
Local aColsCC		:= {}
Local oDlgRateio	:= Nil
Local nOpcA			:= 0
Local nX			:= 0
Local nTotSC		:= 0
Local aButtons		:= {}
Local aAreaBKP		:= GetArea()
Local aPosCpos		:= {}
Local lSeek			:= .F.
Local i,j			:= 0
Local nPosSC1		:= 0
Local cQuerySZ2		:= ""
Local bQuerySZ2		:= {|| Iif(Select("TRB_SZ2") > 0, TRB_SZ2->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySZ2),"TRB_SZ2",.F.,.T.), dbSelectArea("TRB_SZ2"),TRB_SZ2->(dbGoTop()) }
Local nPosItem		:= 0
Local nPosPerc		:= 0
Local nPosCta		:= 0
Local nPosItCta		:= 0
Local nPosClVl		:= 0
Local nPosCC		:= 0
Local nPosVlr  		:= 0
Local lSolicita		:= IIf(Alltrim(Upper(FunName(0)))=="MATA110",.T.,.F.)
Local _nI
Local aCmpSZ2		:= {"Z2_FILIAL"	,"Z2_DOC"	,"Z2_SERIE"	,"Z2_FORNECE"	,"Z2_LOJA"	,"Z2_ITEMNF"	,;
"Z2_ITEM"	,"Z2_PERC"	,"Z2_VALOR"	,"Z2_CC"		,"Z2_CONTA"	, "Z2_ITEMCTA"	,;
"Z2_CLVL"	,"Z2__SC1"	,"Z2_NUMSC"	,"Z2_ITEMSC"	,"Z2_TIPO"					 }

Private oPercRat
Private oPercARat
Private nPercRat  	:= 0
Private nPercARat	:= 100
Private aOrigHeader	:= aClone(aHeader)
Private aOrigAcols	:= aClone(aCols)
Private nOrigN    	:= N
Private cTipo		:= "N"
Private oGetDad		:= Nil

Default nOrigem 	:= 1

Aadd(aButtons,{'AUTOM',{|| AdmRatExt(aHeadSZ2,oGetDad:aCols,{ |x,y,z,w| RateioOff(x,y,@z,w) }) },"Template",OemToAnsi('Escolha de Rateio Pre-Configurado')})

If Upper(Alltrim(FunName(0)))$"MATA110/RCOMA060/MATA121"  // GILBERTO - 01/09/2011 , Para contemplar tambem a tela de aprovacao.
	IF Empty(GdFieldGet("C1_CONTA",nOrigN))
		MsgInfo("Necessario Informar Conta Contabil antes de incluir o rateio!")
		Return .T.
	Endif
Else
	IF Empty(GdFieldGet("C3_CONTA",nOrigN))
		MsgInfo("Necessario Informar Conta Contabil antes de incluir o rateio!")
		Return .T.
	Endif
Endif

//----------------------------------------------------------------------------------------------------------------------------------------
// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
/*
//aHeader e aCols da Getdados de rateio
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZ2")
While !EOF() .And. (SX3->X3_ARQUIVO == "SZ2")
IF X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !"Z2_CUSTO"$SX3->X3_CAMPO
AADD(aHeadSZ2,{	TRIM(x3Titulo()),;
SX3->X3_CAMPO,;
SX3->X3_PICTURE,;
SX3->X3_TAMANHO,;
SX3->X3_DECIMAL,;
SX3->X3_VALID,;
SX3->X3_USADO,;
SX3->X3_TIPO,;
SX3->X3_F3,;
SX3->X3_CONTEXT } )
EndIf
dbSelectArea("SX3")
dbSkip()
EndDo
*/

//aHeader e aCols da Getdados de rateio
For _nI := 1 to Len(aCmpSZ2)
	dbSelectArea("SX3")
	dbSetOrder(2)
	dBSeek(aCmpSZ2[_nI])
	
	IF X3USO(GetSX3Cache(aCmpSZ2[_nI],"X3_USADO")) .AND. cNivel >= GetSX3Cache(aCmpSZ2[_nI],"X3_NIVEL"	)
		AADD(aHeadSZ2,{	TRIM(SX3->X3_TITULO)		,;
		GetSX3Cache(aCmpSZ2[_nI],"X3_CAMPO"		)	,;
		GetSX3Cache(aCmpSZ2[_nI],"X3_PICTURE"	)	,;
		GetSX3Cache(aCmpSZ2[_nI],"X3_TAMANHO"	)	,;
		GetSX3Cache(aCmpSZ2[_nI],"X3_DECIMAL"	)	,;
		GetSX3Cache(aCmpSZ2[_nI],"X3_VALID"		)	,;
		GetSX3Cache(aCmpSZ2[_nI],"X3_USADO"		)	,;
		GetSX3Cache(aCmpSZ2[_nI],"X3_TIPO"		)	,;
		GetSX3Cache(aCmpSZ2[_nI],"X3_F3"		)	,;
		GetSX3Cache(aCmpSZ2[_nI],"X3_CONTEXT" 	)	})
	EndIf
Next _nI

//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

nPosItem	:= AScan(aHeadSZ2,{|x| AllTrim(x[2]) == "Z2_ITEM" 		})
nPosPerc	:= AScan(aHeadSZ2,{|x| AllTrim(x[2]) == "Z2_PERC" 		})
nPosCta		:= AScan(aHeadSZ2,{|x| AllTrim(x[2]) == "Z2_CONTA" 	})
nPosItCta	:= AScan(aHeadSZ2,{|x| AllTrim(x[2]) == "Z2_ITEMCTA" 	})
nPosClVl	:= AScan(aHeadSZ2,{|x| AllTrim(x[2]) == "Z2_CLVL"	 	})
nPosCC		:= AScan(aHeadSZ2,{|x| AllTrim(x[2]) == "Z2_CC"	 	})
nPosVlr		:= AScan(aHeadSZ2,{|x| AllTrim(x[2]) == "Z2_VALOR"	 	})
nPosISc     := AScan(aHeadSZ2,{|x| AllTrim(x[2]) == "Z2_ITEMSC"   })

If nOrigem == 1 //Origem S.C.
	//Avalia se tem algum item na SC
	If INCLUI .OR. ALTERA .OR. lCopia
		For i := 1 To Len(aOrigAcols)
			If !aOrigAcols[i,Len(aOrigHeader)+1]
				//If Alltrim(Upper(FunName(0))) == 'MATA110'
				If Alltrim(Upper(FunName(0))) $ "MATA110/RCOMA060/MATA121"  // GILBERTO - 01/09/2011 , Para contemplar tambem a tela de aprovacao.
					nTotSC += aOrigAcols[i,AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_QUANT"  })]
				Else//If Alltrim(Upper(FunName(0))) == 'MATA122'
					nTotSC += aOrigAcols[i,AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_QUANT"  })]
				Endif
			EndIf
		Next i
		
		If nTotSC <= 0
			MsgAlert("Aten็ใo, antes de cadastrar o rateio de centro de custo, informe ao menos uma linha ativa de produto.")
			Return(Nil)
		EndIf
	EndIf
	
	//Busca rateio ja cadastrado
	If Alltrim(Upper(FunName(0))) $ "MATA110/RCOMA060/MATA121"
		cCampo := "C1_ITEM"
	Else
		cCampo := "C3_ITEM"
	Endif
	For i := 1 To Len(aRateioCC)
		If GdFieldGet(cCampo,nOrigN)==aRateioCC[i,8]
			Aadd(aColsCC,Array(Len(aHeadSZ2)+1))
			For nX := 1 To Len(aHeadSZ2)
				aColsCC[Len(aColsCC)][nX] := CriaVar(aHeadSZ2[nX][2])
			Next nX
			aColsCC[Len(aColsCC)][Len(aHeadSZ2)+1] := .F.
			
			//Campos Especificos
			aColsCC[Len(aColsCC)][nPosItem] 		:= aRateioCC[i,1]
			aColsCC[Len(aColsCC)][nPosPerc] 		:= aRateioCC[i,2]
			aColsCC[Len(aColsCC)][nPosCta] 		    := aRateioCC[i,3]
			aColsCC[Len(aColsCC)][nPosItCta]		:= aRateioCC[i,4]
			aColsCC[Len(aColsCC)][nPosClVl] 		:= aRateioCC[i,5]
			aColsCC[Len(aColsCC)][nPosCC]   		:= aRateioCC[i,6]
			aColsCC[Len(aColsCC)][nPosVlr]		    := aRateioCC[i,7]
			aColsCC[Len(aColsCC)][nPosISc]		    := aRateioCC[i,8]
		Endif
	Next i
	
	If Len(aColsCC) <= 0
		aColsCC := {}
		aadd(aColsCC,Array(Len(aHeadSZ2)+1))
		For nX := 1 To Len(aHeadSZ2)
			If Trim(aHeadSZ2[nX][2]) == "Z2_ITEM"
				aColsCC[1][nX] 	:= "01"
			Else
				aColsCC[1][nX] := CriaVar(aHeadSZ2[nX][2])
			EndIf
			aColsCC[1][Len(aHeadSZ2)+1] := .F.
		Next nX
	EndIf
EndIf
aColsAux:={}

//Desenha a tela de rateio
DEFINE MSDIALOG oDlgRateio FROM 100,100 TO 370,600 TITLE "Rateio por Centro de Custo" Of oMainWnd PIXEL
If nOrigem == 1 //Via Solicitacao de Compras
	If Alltrim(Upper(FunName(0))) == 'MATA110' .or. Alltrim(Upper(FunName(0))) == 'RCOMA060' .or. Alltrim(Upper(FunName(0))) == 'MATA121'
		@ 018,003 SAY "Solicita็ใo Compras: "  OF oDlgRateio PIXEL SIZE 100,09
		@ 018,060 SAY cA110Num OF oDlgRateio PIXEL SIZE 50,09
	Else
		@ 018,003 SAY "Contrato e Parceria: "  OF oDlgRateio PIXEL SIZE 100,09
		@ 018,060 SAY cA125Num OF oDlgRateio PIXEL SIZE 50,09
	Endif
EndIf
oGetDad:= MsNewGetDados():New(030,005,105,245,IIF(INCLUI .OR. ALTERA .OR. lCopia,GD_INSERT+GD_UPDATE+GD_DELETE,0),"u_VldRatok","u_Vld_Rateio","+Z2_ITEM",,,9999,,,,oDlgRateio,aHeadSZ2,aColsCC)
oGetDad:oBrowse:BDELETE:={||U_DELESZ2()}//Validar a exclusao da linha do rateio ( Sergio Celestino )
EvalTrigger()
@ 110,005 Say OemToAnsi("% Rateada: ") FONT oDlgRateio:oFont OF oDlgRateio PIXEL
@ 110,035 Say oPercRat VAR nPercRat Picture "@e 999.99" FONT oDlgRateio:oFont COLOR CLR_HBLUE OF oDlgRateio PIXEL
@ 110,184 Say OemToAnsi("% A Ratear: ") FONT oDlgRateio:oFont OF oDlgRateio PIXEL
@ 110,217 Say oPercARat VAR nPercARat Picture "@e 999.99" FONT oDlgRateio:oFont COLOR CLR_HBLUE OF oDlgRateio PIXEL
ACTIVATE MSDIALOG oDlgRateio CENTERED ON INIT EnchoiceBar(oDlgRateio,{||IIF(oGetDad:TudoOk(),(nOpcA:=1,oDlgRateio:End()),(nOpcA:=0))},{||oDlgRateio:End()},,aButtons)

If nOpcA == 1 .And. (INCLUI .Or. ALTERA .OR. lCopia)
	//aColsAux:={}
	aAdd(aColsAux,AClone(oGetDad:aCols))
	
	aColsCC := AClone(oGetDad:aCols)
	
	//Grava temporariamente na tabela de rateio da NF de Entrada
	AAdd(aPosCpos,AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_CC" 			}))
	AAdd(aPosCpos,AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_CONTA" 		}))
	AAdd(aPosCpos,AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMCTA" 	}))
	AAdd(aPosCpos,AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_CLVL" 		}))
	AAdd(aPosCpos,AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMSC" 		}))
	
	//aRateioCC := {}
	
	For i := 1 To Len(aColsAux)//Len(oGetDad:aCols)
		For nX := 1 To Len(aColsAux[nX])
			If !aColsAux[i][nX][Len(aColsAux[i][nX])]
				//If Upper(AllTrim(FunName())) == "MATA110"
				If Alltrim(Upper(FunName(0))) == 'MATA110' .or. Alltrim(Upper(FunName(0))) == 'RCOMA060' .or. Alltrim(Upper(FunName(0))) == 'MATA121'
					cVarX := Alltrim(GdFieldGet("C1_ITEM",nOrigN))
				Else
					cVarX := Alltrim(GdFieldGet("C3_ITEM",nOrigN))
				Endif
				If aColsAux[i][nX][nPosISc] == cVarX
					
					nPosA := aScan(aRateioCC,{|x| x[1]+x[8] == aColsAux[i][nX][nPosItem ] + aColsAux[i][nX][nPosISc  ] } )
					If nPosA == 0
						AAdd(aRateioCC,{	aColsAux[i][nX][nPosItem ],;
						aColsAux[i][nX][nPosPerc ],;
						aColsAux[i][nX][nPosCta  ],;
						aColsAux[i][nX][nPosItCta],;
						aColsAux[i][nX][nPosClVl ],;
						aColsAux[i][nX][nPosCC   ],;
						aColsAux[i][nX][nPosVlr  ],;
						aColsAux[i][nX][nPosISc  ] })
					Else
						aRateioCC[nPosA][1]   :=	aColsAux[i][nX][nPosItem ]
						aRateioCC[nPosA][2]   :=	aColsAux[i][nX][nPosPerc ]
						aRateioCC[nPosA][3]   :=	aColsAux[i][nX][nPosCta  ]
						aRateioCC[nPosA][4]   :=	aColsAux[i][nX][nPosItCta]
						aRateioCC[nPosA][5]   :=	aColsAux[i][nX][nPosClVl ]
						aRateioCC[nPosA][6]   :=	aColsAux[i][nX][nPosCC   ]
						aRateioCC[nPosA][7]   :=	aColsAux[i][nX][nPosVlr  ]
						aRateioCC[nPosA][8]   :=	aColsAux[i][nX][nPosISc  ]
					Endif
				Endif
			EndIf
		Next
	Next i
EndIf

//Restaura variaveis private
aHeader := AClone(aOrigHeader)
aCols	:= AClone(aOrigAcols)
N 		:= nOrigN

RestArea(aAreaBKP)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVld_RateioบAutor  ณBruno Daniel Borges บ Data ณ  13/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do rateio por valor e por %             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Vld_Rateio()
Local nTotal  := 0
Local i, n, x
Local nPosQtd := 0
Local nPosVlr := 0
Local nPosCT1 := 0
Local nPosRat := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_VALOR" 	})
Local nPosPerc:= AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_PERC" 	})
Local nPosCT2 := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_CONTA" 	})
Local nPosIte := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMSC" 	})
Local nPosCC  := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_CC" 	    })
Local nPosEpep:= AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMCTA" 	})
Local nTotPerc:= 0
Local nTotVlr := 0

//If Alltrim(Upper(FunName(0))) == 'MATA110'
If Alltrim(Upper(FunName(0))) == 'MATA110' .or. Alltrim(Upper(FunName(0))) == 'RCOMA060' .or. Alltrim(Upper(FunName(0))) == 'MATA121'
	nPosIt   := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_ITEM" 		})
	nPosQtd  := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_QUANT" 	})
	nPosVlr  := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_VUNIT"		})
	nPosCT1  := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_CONTA"		})
	nPosC1CC := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_CC"		})
Else//If Alltrim(Upper(FunName(0))) == 'MATA122'
	nPosIt   := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_ITEM" 		})
	nPosQtd  := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_QUANT" 	})
	nPosVlr  := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_PRECO"		})
	nPosCT1  := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_CONTA"		})
	nPosC1CC := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_CC"		})
Endif

For i := 1 To Len(aOrigAcols)
	If !aOrigAcols[i,Len(aOrigHeader)+1]
		If aOrigAcols[i,nPosIt] == oGetDad:aCols[1,nPosIte]
			nTotal += Round(aOrigAcols[i,nPosQtd] * aOrigAcols[i,nPosVlr],2)
		Endif
	EndIf
Next i

//Avalia os valores rateados
If nTotal > 0
	
	For i := 1 To Len(oGetDad:aCols)
		if empty(oGetDad:aCols[i][nPosEpep])
			dbSelectArea("CT1")
			cConta := oGetDad:aCols[i][nPosCt2]
			dbSeek(xFilial()+cConta)
			if CT1->CT1_ITOBRG='1'
				MsgAlert("Aten็ใo, o elemento Pep deve ser preenchido obrigatoriamente  "  + Chr(13) + Chr(10) )
				Return(.F.)
			endif
		endif

		If !oGetDad:aCols[i,Len(oGetDad:aHeader)+1]
			nTotPerc += Round(oGetDad:aCols[i,nPosPerc],2)
			nTotVlr  += Round(oGetDad:aCols[i,nPosRat ],2)
		EndIf
	Next i

	If nTotPerc <> 100
		If Abs(nTotVlr - nTotal) > 1
			MsgAlert("Aten็ใo, o total rateado nใo totaliza 100% ou a soma dos valores ้ diferente de R$ " + AllTrim(Transform(nTotal,"@E 999,999,999.99")) + Chr(13) + Chr(10) + ;
			" Total Rateio: R$ " + AllTrim(Transform(nTotVlr,"@E 999,999,999.99")) )
			Return(.F.)
		EndIf
	EndIf
	
EndIf


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M110STTS บAutor  ณBruno Daniel Borges บ Data ณ  19/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada apos a gravacao da solicitacao de compra   บฑฑ
ฑฑบ          ณutilizado na inclusao para disparar a Alcada                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณAdicionado as linhas 469 ate 477                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*User Function M110STTS()
Local cNumSC	 := ParamIXB[1]
Local aAreaBKP	 := GetArea()
Local i			 := 0
Local cDestEmail := Space(50)

Private lAlcadaNew := GetMv("MV_T4FANEW",,.F.)
//Busca Centro de Custo do usuario que fez a inclusao
SC1->(dbSetOrder(1))
SC1->(dbGoTop())
SC1->(dbSeek(xFilial("SC1")+cNumSC))


If INCLUI //--Sergio Celestino ( Gravar Campo de Identifica็ใo de anexo )
aAreaSC1 := SC1->(GetArea())
While !Eof() .And. SC1->C1_NUM == cNumSC
Reclock("SC1",.F.)
SC1->C1_ANEXO := IIF(U_VERANEXO(cNumSC),"S","N")
MsUnlock()
DbSelectArea("SC1")
DbSkip()
End
RestArea(aAreaSC1)
Endif

If !INCLUI .And. !ALTERA
cQuery  := "SELECT * FROM "+RetSqlName("SC1")+" WHERE C1_NUM = '"+cNumSC+"' "

If Select("TRB") > 0
DbSelectArea("TRB")
DbCloseArea()
Endif

dbusearea( .T. ,"TOPCONN",TCGenQry(,,CQUERY),"TRB", .F. , .T. )
__cSolicit := TRB->C1_USER

_cSUBJECT:="[T4F-Suprimentos] Exclusใo de Solicita็ใo de compras "+cNumSC

PswOrder(1)
IF PswSeek(__cSolicit, .T. )
If PSWRET(1)[1][17]  //Caso o Usuario esteja bloqueado
cDestEmail := GetMv("MV_XMAILRE",,Space(200))
Else
cDestEmail := PSWRET(1)[1][14]
Endif
Endif
//U_CRIAEMAIL(cDestEmail,_cSUBJECT)		// Envia email informando ao solicitante que a solicitacao de compras foi cancelada.

//Exluir o rateio caso exista
aAreax := GetArea()
DbSelectArea("SZ2")
SZ2->( DbSetOrder(2) )
SZ2->( DbGotop() )
If SZ2->( DbSeek( xFilial("SZ2") + cNumSC ) )
While SZ2->( !Eof() ) .And. xFilial("SZ2")+SZ2->Z2__SC1 == SZ2->Z2_FILIAL + cNumSC
If Alltrim(SZ2->Z2_TIPO) == "S"
Reclock("SZ2",.F.)
DbDelete()
MsUnlock()
Endif
DbSelectARea("SZ2")
SZ2->( DbSkip() )
End-While
Endif
RestArea(aAreax)
Endif

dbSelectArea("ZZ4")
ZZ4->(dbSetOrder(2))
If ZZ4->(dbSeek(xFilial("ZZ4")+Padr(__cUserID,20)+AllTrim(SC1->C1_CC)))

//Gera Alcada
If INCLUI .Or. ALTERA

//Apaga a alcada geraada
dbSelectArea("ZZ6")
ZZ6->(dbSetOrder(1))
ZZ6->(dbSeek(xFilial("ZZ6")+cNumSC ))
While ZZ6->(!Eof()) .And. ZZ6->ZZ6_FILIAL + ZZ6->ZZ6_SC == xFilial("ZZ6")+cNumSC
ZZ6->(RecLock("ZZ6",.F.))
ZZ6->(dbDelete())
ZZ6->(MsUnlock())

ZZ6->(dbSkip())
EndDo
LJMsgRun("Gerando Al็ada de Aprova็ใo","Aguarde",{|| U_Gera_Alcada_SC(cNumSC,SC1->C1_CC,lBlqPCO) })
//Estorna a Alcada
Else

LJMsgRun("Estornando Al็ada de Aprova็ใo","Aguarde",{|| U_Estorna_Alcada_SC(cNumSC) })

EndIf

EndIf

LJMsgRun("Gravando Rateio...","Aguarde",{|| GeraRat(cNumSC) })

RestArea(aAreaBKP)

Return(Nil)  */

User Function GeraRat(cNumSC)
Local aArea:= GetArea()
Local lRateio:= .f.

If INCLUI .Or. ALTERA
	dbSelectArea("SZ2")
	SZ2->(dbSetOrder(3))
	For i := 1 To Len(aRateioCC)
		If !DbSeek(xFilial("SZ2") + aRateioCC[i,1] + cNumSC + aRateioCC[i,8] + IIF(Alltrim(Upper(FunName(0)))=="MATA110","S","C") )
			RecLock("SZ2",.T.)
			SZ2->Z2_FILIAL	  := xFilial("SZ2")
			SZ2->Z2_ITEM	  := aRateioCC[i,1]
			SZ2->Z2_PERC	  := aRateioCC[i,2]
			SZ2->Z2_CONTA	  := aRateioCC[i,3]
			SZ2->Z2_ITEMCTA   := aRateioCC[i,4]
			SZ2->Z2_CLVL	  := aRateioCC[i,5]
			SZ2->Z2_CC		  := aRateioCC[i,6]
			SZ2->Z2_VALOR     := aRateioCC[i,7]
			SZ2->Z2_NUMSC     := cNumSC
			SZ2->Z2_ITEMSC    := aRateioCC[i,8]
			SZ2->Z2__SC1	  := cNumSC
			SZ2->Z2_TIPO      := IIF(Alltrim(Upper(FunName(0)))=="MATA110","S","C")//Caso Mata110 gravo S de Solicitacao de Compra senใo C de Contrato de Parceria
			MsUnlock()
			// Rateio OK - Gravou.
			lRateio:= .t.
		Endif
	Next i
EndIf

//
RestArea( aArea )
Return(lRateio)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณBLQEPEP() บAutor  ณGilberto Oliveira   บ Data ณ  16/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca na tabela ZY os elementos pep que precisam passar por บฑฑ
ฑฑบ          ณaprovacao mesmo que o projeto possua orcamento no PCO.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BlqEPEP()

Local aGetArea	:= GetArea()
//Local FWGetSX5	:= FWGetSX5( "ZY" )  #Willian Carvalho 20190920, corre็ใo da variแvel
Local _aSX5		:= FWGetSX5( "ZY" )
Local cString 	:= ""  //Willian Carvalho 20190920

//----------------------------------------------------------------------------------------------------------------------------------------
// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
/*
Local aSX5Area:= SX5->( GetArea() )
Local cString:= ''

SX5->( DbSetOrder(1) )
If SX5->( DbSeek(XFILIAL("SX5")+"ZY") )
While SX5->( !Eof() ) .And. Rtrim(SX5->X5_TABELA) == "ZY"
cString+= Rtrim(SX5->X5_DESCRI)+";"
SX5->( DbSkip() )
End-While
EndIf

SX5->( RestArea(aSX5Area) )
*/

For _nI := 1 to Len(_aSX5)
	
	If _aSX5[_nI][01] == FwFILIAL('SX5') .AND. _aSX5[_nI][03] == 'ZY'
		
		cString+= Rtrim(_aSX5[_nI][04])+";"
		
	Endif
Next

//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

RestArea( aGetArea )
Return(cString)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGera_Alcada_SCบAutor  ณBruno Daniel Borges บ Data ณ  19/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao das tabelas de Alcadas                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณAdicionado das linhas 594 ate 610 (Condicao para apurar saldo   บฑฑ
ฑฑบ          ณtotal em aberto por fornecedor ) - Sergio Celestino             บฑฑ
ฑฑบ          ณ                                                                บฑฑ
ฑฑบ          ณ                                                                บฑฑ
ฑฑบ          ณ                                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Gera_Alcada_SC(cNumSC,cCentroCusto,lBlqPCO)
//Local nLinha	:= 0
Local cQueryZZ5	 := ""
Local cPrimNiv	 := ""
Local nTotSC	 := 0
Local cNivel	 := ""
Local cUser		 := ""
Local lForceAlc  := .F.  // Gilberto - 01/12/2009
//Local _cPEPEforce:= GetMv("T4F_FORALC",,Space(01))// Gilberto - 01/12/2009
Local _cPEPEforce:= BlqEPEP() // Gilberto - 01/12/2009
Local cQueryVlr  := ""
Local lVlrFull   := GetMv("T4F_VLRFUL",,.F.) //Sergio Celestino - Verifica o Valor total para o fornecedor antes de entrar na alcada
Local lSolicita   := IIf(Alltrim(Upper(FunName(0)))=="MATA110",.T.,.F.)

Private lAlcadaNew := GetMv("MV_T4FANEW",,.F.)

// Gilberto
If Empty( _cPEPEForce )
	_cPEPEforce:= GetMv("T4F_FORALC",,Space(01))// Gilberto - 01/12/2009
EndIF

// Gilberto - 01/12/2009
// Forca a alcada de determinado Elemento PEPE.
If !Empty(_cPEPEforce)
	If ( Alltrim(SC1->C1_ITEMCTA) $ Alltrim(_cPEPEforce) )
		lForceAlc:= .t.
	EndIf
EndIf


//Houve bloqueio de orcamento no PCO ou nao existe elemento PEP
If lBlqPCO .Or. !lPCO .Or. lForceAlc
	
	If lVlrFull
		//Incluso por Sergio Celestino ( O total a ser verificado na alcada e referente ao fornecedor e usuario e nao so a SC
		cQueryVlr := "SELECT C1_USER,C1_FORNECE,C1_LOJA,SUM(C1_QUANT*C1_VUNIT) AS TOTAL  "
		cQueryVlr += "FROM "+RetSqlName("SC1")+" "
		cQueryVlr += "WHERE "
		cQueryVlr += "C1_FORNECE = '"+SC1->C1_FORNECE+"' AND C1_LOJA = '"+SC1->C1_LOJA+"' AND C1_USER = '"+SC1->C1_USER+"' AND C1_QUJE = 0 AND D_E_L_E_T_ = ' ' "
		cQueryVlr += "GROUP BY C1_USER,C1_FORNECE,C1_LOJA"
		
		If Select("TRA") > 0
			DbSelectArea("TRA")
			DbCloseArea()
		Endif
		
		cQueryVlr := ChangeQuery(cQueryVlr)
		dbusearea( .T. ,"TOPCONN",TCGenQry(,,CQUERYVLR),"TRA", .F. , .T. )
		
		nTotSC := TRA->TOTAL
	Else
		If lAlcadaNew
			cQry:= ""
			cQry+= "SELECT Z2_NUMSC,Z2_CC,SUM(Z2_VALOR)  AS Z2_VALOR
			cQry+= "FROM "+RetSqlName("SZ2")+ " SZ2 WHERE Z2_NUMSC = '"+cNumSC+"' AND D_E_L_E_T_ = ' ' "
			If  lSolicita
				cQry+= " AND Z2_TIPO = 'S' "
			Else
				cQry+= " AND Z2_TIPO = 'C' "
			Endif
			cQry+= "GROUP BY Z2_NUMSC,Z2_CC "
			
			cQry:=ChangeQuery(cQry)
			
			If Select("TRX") > 0
				DbSelectArea("TRX")
				DbCloseArea()
			Endif
			
			TcQuery cQry New Alias "TRX"
			
			DbSelectArea("TRX")
			DbGotop()
			
			If TRX->(Eof())
				If  lSolicita
					cQry:= ""
					cQry+= "SELECT C1_NUM AS Z2_NUMSC,C1_CC AS Z2_CC,SUM(C1_VUNIT*C1_QUANT)  AS Z2_VALOR "
					cQry+= "FROM "+RetSqlName("SC1")+ " SC1 WHERE C1_NUM = '"+cNumSC+"' AND D_E_L_E_T_ = ' '  "
					cQry+= "GROUP BY C1_NUM,C1_CC "
				Else
					cQry:= ""
					cQry+= "SELECT C3_NUM AS Z2_NUMSC,C3_CC AS Z2_CC,SUM(C3_TOTAL)  AS Z2_VALOR "
					cQry+= "FROM "+RetSqlName("SC3")+ " SC3 WHERE C3_NUM = '"+cNumSC+"' AND D_E_L_E_T_ = ' '  "
					cQry+= "GROUP BY C3_NUM"
				Endif
				
				cQry:=ChangeQuery(cQry)
				
				If Select("TRX") > 0
					DbSelectArea("TRX")
					DbCloseArea()
				Endif
				
				TcQuery cQry New Alias "TRX"
				
			Endif
		Else
			
			If  lSolicita
				cQry:= ""
				cQry+= "SELECT C1_NUM AS Z2_NUMSC,SUM(C1_VUNIT*C1_QUANT)  AS Z2_VALOR "
				cQry+= "FROM "+RetSqlName("SC1")+ " SC1 WHERE C1_NUM = '"+cNumSC+"' AND D_E_L_E_T_ = ' '  "
				cQry+= "GROUP BY C1_NUM "
			Else
				cQry:= ""
				cQry+= "SELECT C3_NUM AS Z2_NUMSC,SUM(C3_TOTAL)  AS Z2_VALOR "
				cQry+= "FROM "+RetSqlName("SC3")+ " SC3 WHERE C3_NUM = '"+cNumSC+"' AND D_E_L_E_T_ = ' '  "
				cQry+= "GROUP BY C3_NUM"
			Endif
			
			cQry:=ChangeQuery(cQry)
			
			If Select("TRX") > 0
				DbSelectArea("TRX")
				DbCloseArea()
			Endif
			
			TcQuery cQry New Alias "TRX"
		Endif
		
		While TRX->(!Eof())
			
			If lAlcadaNew
				cCentroCusto := AllTrim(TRX->Z2_CC)
			Endif
			//Busca os niveis envolvidos na alcada
			cQueryZZ5 := " SELECT ZZ5_APROV, ZZ5_NIVEL, AK_USER "
			cQueryZZ5 += " FROM " + RetSQLName("ZZ5") + " A, " + RetSQLName("SAK") + " B "
			cQueryZZ5 += " WHERE ZZ5_FILIAL = '" + xFilial("ZZ5") + "' AND ZZ5_CC = '" + IIF(lAlcadaNew,AllTrim(TRX->Z2_CC),cCentroCusto) + "' AND A.D_E_L_E_T_ = ' ' AND "
			cQueryZZ5 += "       AK_FILIAL = '" + xFilial("SAK") + "' AND AK_COD = ZZ5_APROV AND "
			cQueryZZ5 += AllTrim(Str( TRX->Z2_VALOR)) + " >= AK_LIMMIN AND " + AllTrim(Str( TRX->Z2_VALOR)) + " <= AK_LIMMAX AND B.D_E_L_E_T_ = ' ' "
			cQueryZZ5 += " ORDER BY ZZ5_NIVEL "
			
			Iif(Select("TRB_ZZ5") > 0, TRB_ZZ5->(dbCloseArea()), Nil)
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryZZ5),"TRB_ZZ5",.F.,.T.)
			dbSelectArea("TRB_ZZ5")
			TRB_ZZ5->(dbGoTop())
			
			//FLEGA o SC1 como Bloqueado
			If TRB_ZZ5->(!Eof()) //.Or. NivelSuperior(cCentroCusto)
				If  lSolicita
					SC1->(dbSetOrder(1))
					SC1->(dbGoTop())
					SC1->(dbSeek(xFilial("SC1")+cNumSC))
					While SC1->(!Eof()) .And. SC1->C1_FILIAL + SC1->C1_NUM == xFilial("SC1")+cNumSC
						SC1->(RecLock("SC1",.F.))
						SC1->C1_APROV := "B"
						SC1->(MsUnlock())
						SC1->(dbSkip())
					EndDo
				Endif
			EndIf
			
			While TRB_ZZ5->(!Eof())
				If Empty(cPrimNiv)
					cPrimNiv := TRB_ZZ5->ZZ5_NIVEL
				EndIf
				
				dbSelectArea("ZZ6")
				ZZ6->(RecLock("ZZ6",.T.))
				ZZ6->ZZ6_FILIAL	:= xFilial("ZZ6")
				ZZ6->ZZ6_SC		:= cNumSC
				ZZ6->ZZ6_APROV	:= TRB_ZZ5->ZZ5_APROV
				ZZ6->ZZ6_NIVEL	:= TRB_ZZ5->ZZ5_NIVEL
				ZZ6->ZZ6_CC     := IIF(lAlcadaNew,AllTrim(TRX->Z2_CC),cCentroCusto)
				ZZ6->ZZ6_TIPO   := IIF(Alltrim(Upper(FunName(0)))=="MATA110","S","C")//Caso Mata110 gravo S de Solicitacao de Compra senใo C de Contrato de Parceria
				ZZ6->ZZ6_STATUS	:= Iif(TRB_ZZ5->ZZ5_NIVEL > cPrimNiv,"4","1")
				If TRB_ZZ5->ZZ5_NIVEL == cPrimNiv
					ZZ6->ZZ6_HRENT		:= Time()
					ZZ6->ZZ6_DTENT		:= dDataBase
					
					//Avalia se proximo aprovador possui Workflow ativo
					If Posicione("ZZ5",2,xFilial("ZZ5")+AllTrim(ZZ6->ZZ6_APROV),"ZZ5->ZZ5_WF") == "1"
						cUser := Posicione("SAK",1,xFilial("SAK")+ZZ6->ZZ6_APROV,"SAK->AK_USER")
						U_RCOMA60D(cUser,cNumSC)
					EndIf
				EndIf
				ZZ6->(MsUnlock())
				
				TRB_ZZ5->(dbSkip())
			EndDo
			
			//Analisa se alcada foi gerada para o proprio solicitante
			dbSelectArea("ZZ6")
			ZZ6->(dbSetOrder(1))
			ZZ6->(dbGoTop())
			If ZZ6->(dbSeek(xFilial("ZZ6")+cNumSC))
				If Posicione("SAK",1,xFilial("SAK")+ZZ6->ZZ6_APROV,"SAK->AK_USER") == __cUserId
					ZZ6->(RecLock("ZZ6",.F.))
					ZZ6->ZZ6_HRSAI		:= Time()
					ZZ6->ZZ6_DTSAI		:= dDataBase
					ZZ6->ZZ6_STATUS	    := "5" //Inativa no Nivel
					ZZ6->ZZ6_CC         := IIF(lAlcadaNew,AllTrim(TRX->Z2_CC),cCentroCusto)
					ZZ6->ZZ6_TIPO       := IIF(Alltrim(Upper(FunName(0)))=="MATA110","S","C")//Caso Mata110 gravo S de Solicitacao de Compra senใo C de Contrato de Parceria
					ZZ6->(MsUnlock())
					cNivel := ZZ6->ZZ6_NIVEL
					
					//Avanca p/ proximo nivel
					ZZ6->(dbSkip())
					If ZZ6->(Eof()) .Or. ZZ6->ZZ6_SC <> cNumSC
						//Gera um registro no nivel superior da alcada
						dbSelectArea("ZZ5")
						ZZ5->(dbSetOrder(1))
						ZZ5->(dbSeek(xFilial("ZZ5")+AllTrim(cCentroCusto)))
						While ZZ5->(!Eof()) .And. ZZ5->ZZ5_FILIAL + AllTrim(ZZ5->ZZ5_CC) == xFilial("ZZ5")+Alltrim(cCentroCusto)
							If AllTrim(ZZ5->ZZ5_NIVEL) == cNivel
								ZZ5->(dbSkip())
								Loop
							ElseIf Val(ZZ5->ZZ5_NIVEL) == (Val(cNivel)+1)
								dbSelectArea("ZZ6")
								ZZ6->(RecLock("ZZ6",.T.))
								ZZ6->ZZ6_FILIAL	:= xFilial("ZZ6")
								ZZ6->ZZ6_SC		:= cNumSC
								ZZ6->ZZ6_APROV	:= ZZ5->ZZ5_APROV
								ZZ6->ZZ6_NIVEL	:= ZZ5->ZZ5_NIVEL
								ZZ6->ZZ6_STATUS	:= "1"
								ZZ6->ZZ6_HRENT	:= Time()
								ZZ6->ZZ6_DTENT	:= dDataBase
								ZZ6->ZZ6_CC     := IIF(lAlcadaNew,AllTrim(TRX->Z2_CC),cCentroCusto)
								ZZ6->ZZ6_TIPO   := IIF(Alltrim(Upper(FunName(0)))=="MATA110","S","C")//Caso Mata110 gravo S de Solicitacao de Compra senใo C de Contrato de Parceria
								ZZ6->(MsUnlock())
								Exit
							EndIf
							ZZ5->(dbSkip())
						EndDo
					Else
						ZZ6->(RecLock("ZZ6",.F.))
						ZZ6->ZZ6_HRENT	:= Time()
						ZZ6->ZZ6_DTENT	:= dDataBase
						ZZ6->ZZ6_STATUS	:= "1"
						ZZ6->ZZ6_CC     := IIF(lAlcadaNew,AllTrim(TRX->Z2_CC),cCentroCusto)
						ZZ6->ZZ6_TIPO   := IIF(Alltrim(Upper(FunName(0)))=="MATA110","S","C")//Caso Mata110 gravo S de Solicitacao de Compra senใo C de Contrato de Parceria
						ZZ6->(MsUnlock())
					EndIf
				EndIf
			Endif
			DbSelectArea("TRX")
			DbSkip()
		End
	EndIf
Else
	dbSelectArea("ZZ6")
	ZZ6->(RecLock("ZZ6",.T.))
	ZZ6->ZZ6_FILIAL	:= xFilial("ZZ6")
	ZZ6->ZZ6_SC		:= cNumSC
	ZZ6->ZZ6_APROV	:= "PCO"
	ZZ6->ZZ6_NIVEL	:= "X"
	ZZ6->ZZ6_STATUS	:= "6"
	ZZ6->ZZ6_HRENT	:= Time()
	ZZ6->ZZ6_DTENT	:= dDataBase
	ZZ6->ZZ6_HRSAI	:= Time()
	ZZ6->ZZ6_DTSAI	:= dDataBase
	ZZ6->ZZ6_CC     := cCentroCusto
	ZZ6->ZZ6_TIPO   := IIF(Alltrim(Upper(FunName(0)))=="MATA110","S","C")//Caso Mata110 gravo S de Solicitacao de Compra senใo C de Contrato de Parceria
	ZZ6->(MsUnlock())
	
	If  lSolicita
		SC1->(dbSetOrder(1))
		SC1->(dbGoTop())
		SC1->(dbSeek(xFilial("SC1")+cNumSC))
		While SC1->(!Eof()) .And. SC1->C1_FILIAL + SC1->C1_NUM == xFilial("SC1")+cNumSC
			SC1->(RecLock("SC1",.F.))
			SC1->C1_APROV := "L"
			SC1->(MsUnlock())
			SC1->(dbSkip())
		EndDo
	Endif
	
EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEstorna_Alcada_SCบAutor  ณBruno Daniel Borges บ Data ณ  03/04/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEstorno da alcada de aprovacao de solicitacoes de compras          บฑฑ
ฑฑบ          ณ                                                                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Estorna_Alcada_SC(cNumSC)
Local aAreaBKP := GetArea()

//Exclui as alcadas
dbSelectArea("ZZ6")
ZZ6->(dbSetOrder(1))
ZZ6->(dbSeek(xFilial("ZZ6")+cNumSC))
While ZZ6->(!Eof()) .And. ZZ6->ZZ6_FILIAL + AllTrim(ZZ6->ZZ6_SC) == xFilial("ZZ6")+cNumSC
	ZZ6->(RecLock("ZZ6",.F.))
	ZZ6->(dbDelete())
	ZZ6->(MsUnlock())
	ZZ6->(dbSkip())
EndDo
RestArea(aAreaBKP)

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPCOVLBLQ  บAutor  ณMicrosiga           บ Data ณ  09/21/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PcoVlBLQ()
//Local nPct       	:= GetMV("IC_PCTPCO")
//Local cControl	:= GetMV("IC_MAILCT")
//Local cGG			:= GetMV("IC_MAILGG")
Local aArea	:= GetArea()

lRet		:= .T.
__aDadosBlq :=  aClone(ParamIXB)
if valtype(__aDadosBlq[4])=="U"// estava dando erro para a usuaria Mparavane
	__aDadosBlq[4]	:= space(500)
endif
cConta 		:= ALLTRIM(SUBSTR(__aDadosBlq[4],31,12)) // ALTERAR CONFOME STRING BL0QUEIOI
cEPEP 		:= ALLTRIM(SUBSTR(__aDadosBlq[4],11,20)) // TROCAR NO TAMSX3 PARA ITEM CONTABIL

lPCO		:= .T.

CTD->(DbSeek(xFilial("CTD")+cEPEP))
cDescEPEP 	:= CTD->CTD_DESC01        // ELEMENTO PEP

If !Empty(cConta)
	dbSelectArea("ZZU")
	ZZU->(DbSeek(xFilial("ZZU")+cConta))
	cDesccta	:= ALLTRIM(ZZU->ZZU_DESCRI)
Else
	cDesccta	:= "Nใo Parametrizada"
Endif

nPct		:= 0

If __aDadosBlq[2] <= __aDadosBlq[3] + __aDadosBlq[3] * nPct / 100    .and. !empty(cConta)
	If 	__aDadosBlq[2] <= __aDadosBlq[3]  .and. !empty(cConta)
		lRet	:= .T.
		lPCO	:= .T.
		lBlqPCO := .F.
	Else
		While .T. .and.  __aDadosBlq[5]=="000051" // .and. cNat	== '1'
			nPerc := IIF(__aDadosBlq[3]<>0,__aDadosBlq[2]/__aDadosBlq[3],100)
			cTxtBlq	:=	"Os saldos atingiram o percentual de aten็ใo. "+CHR(13)+CHR(10)+; // Perํodo: "+;
			"Conta  : "+AllTrim(cConta)+" - "+AllTrim(cDesccta)+CHR(13)+CHR(10)+;
			"EPEP : "+Alltrim(cEPEP)+"-"+AllTrim(cDescEPEP)+CHR(13)+CHR(10)+;
			"Saldo Previsto : "+Str(__aDadosBlq[3],14,2)+ " Vs Saldo Realizado : " +Str(__aDadosBlq[2],14,2)+CHR(13)+CHR(10)+;
			"Percentual atingido : "+Str(nPerc*100,5,2)+"%"+CHR(13)+CHR(10)
			nDet := Aviso("Planejamento e Controle Or็amentแrio",cTxtBlq,;
			{"&Fechar", "&Detalhes"},3,"Saldo em nํvel crํtico",,;
			"PCOLOCK")
			// envia e-mail para o gestor, que e determinado pelo codigo de usuario em cgest. Enviar copia para email constante em CCONTROL, QUE EQUIVALE A ALTINEIDE
			
			If nDet < 2
				Exit
			Else
				cCodCuboPrv  := Posicione("AL4", 1, xFilial("AL4")+AKJ->AKJ_PRVCFG, "AL4_CONFIG")
				cCodCuboReal := Posicione("AL4", 1, xFilial("AL4")+AKJ->AKJ_REACFG, "AL4_CONFIG")
				PcoDetBlq(cCodCuboPrv, cCodCuboReal, __aDadosBlq[9,1], __aDadosBlq[9,2], __aDadosBlq[4], __aDadosBlq[3], __aDadosBlq[2], __aDadosBlq[10])
			EndIf
		EndDo
	Endif
	
Else
	
	While .T.
		lRet	:= !GetNewPar("MV_XATVBLQ",.F.)
		cTxtBlq	:=	"Os saldos atuais do Planejamento e Controle Or็amentแrio sใo insuficientes para completar esta opera็ใo. "+CHR(13)+CHR(10)+;
		"Cubo : "+AllTrim(__aDadosBlq[8])+CHR(13)+CHR(10)+;
		"Conta  :" +AllTrim(cConta)+" - "+AllTrim(cDesccta)+CHR(13)+CHR(10)+;
		"EPEP : "+Alltrim(cEPEP)+" - "+AllTrim(cDescEPEP)+CHR(13)+CHR(10)+;
		"Saldo Previsto : "+Str(__aDadosBlq[3],14,2)+ " Vs Saldo Realizado : " +Str(__aDadosBlq[2],14,2)+CHR(13)+CHR(10)
		nDet := Aviso("Planejamento e Controle Or็amentแrio",cTxtBlq,;
		{"&Fechar", "&Detalhes"},3,"Saldo Insuficiente",,;
		"PCOLOCK")
		
		lBlqPCO := .T.
		
		
		If nDet < 2
			Exit
		Else
			cCodCuboPrv  := Posicione("AL4", 1, xFilial("AL4")+AKJ->AKJ_PRVCFG, "AL4_CONFIG")
			cCodCuboReal := Posicione("AL4", 1, xFilial("AL4")+AKJ->AKJ_REACFG, "AL4_CONFIG")
			PcoDetBlq(cCodCuboPrv, cCodCuboReal, __aDadosBlq[9,1], __aDadosBlq[9,2], __aDadosBlq[4], __aDadosBlq[3], __aDadosBlq[2], __aDadosBlq[10])
		EndIf
	EndDo
Endif

RestArea(aArea)
Return (lRet)
//-----------------------------------------------------------------------------------------------------------------------------
User Function DELESZ2

Local nPPerc    := AScan(aHeader        ,{|x| AllTrim(x[2]) == "Z2_PERC"      })
Local nPosItem  := 0
Local nPosISc   := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMSC"    })

If Alltrim(Upper(FunName(0))) == 'MATA110'
	nPosItem  := AScan(aOrigHeader    ,{|x| AllTrim(x[2]) == "C1_ITEM"      })
ElseIf Alltrim(Upper(FunName(0))) == 'MATA125'
	nPosItem  := AScan(aOrigHeader    ,{|x| AllTrim(x[2]) == "C3_ITEM"      })
Endif

If oGetDad:aCols[oGetDad:nAt][nPosISc] == aOrigAcols[nOrigN,nPosItem]
	If oGetDad:aCols[oGetDad:nAt][Len(oGetDad:aHeader)+1]
		oGetDad:aCols[oGetDad:nAt][Len(oGetDad:aHeader)+1] := .F.
	Else
		oGetDad:aCols[oGetDad:nAt][Len(oGetDad:aHeader)+1] := .T.
	Endif
Else
	MsgInfo("Este item do rateio nใo pertence ao Item da Solicita็ใo/Contrato.Verifique!!!")
	oGetDad:aCols[oGetDad:nAt][Len(oGetDad:aHeader)+1] := .F.
Endif
oGetDad:Refresh()
Return
//----------------------------------------------------------------------------------------------------------------------------
User Function GATRATPEP

Local nPosCt  := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_CONTA"    })
Local nPosCC  := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_CC"       })
Local nPosXX  := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMCTA"  })
Local cRet    := ""

_CtaAntes := oGetDad:aCols[oGetDad:nAt][nPosCt]
_CC       := oGetDad:aCols[oGetDad:nAt][nPosCC]
_PEP      := oGetDad:aCols[oGetDad:nAt][nPosXX]

nPosProd := AScan(aOrigHeader,{|x| AllTrim(x[2]) == IIf(Alltrim(Upper(FunName(0)))=='MATA110', "C1_PRODUTO","C3_PRODUTO")	})
cProduto := aOrigAcols[nOrigN,nPosProd]

nPosTES  := AScan(aOrigHeader,{|x| AllTrim(x[2]) == IIf(Alltrim(Upper(FunName(0)))=='MATA110', "C1_TES","C3_TES")	})
cTES     := aOrigAcols[nOrigN,nPosTES]

cRet     := U_T4F00X(cProduto,cTES,"SC","N",,_CtaAntes,_CC,_PEP)

oGetDad:aCols[oGetDad:nAt][nPosCt] := cRet
oGetDad:Refresh()

Return cRet
//--------------------------------------------------------------------------------------------------------------------------
User Function T4F00X(_Produto,_TES,_Rotina,_TIPO,_LINHA,_CtaAntes,_CC,_PEP)
Local aArea      := GetArea()
Local _Retorno   := ""
Local _Conta     := ""
Local _Estoque   := "N"
Local _Campo     := ReadVar()
Local _Linha     := Iif(_Linha==Nil,n,_Linha)

_Produto := Iif(_Produto ==Nil,""            ,_Produto )
_TES     := Iif(_TES     ==Nil,""            ,_TES     )
_Tipo    := Iif(_Tipo    ==Nil,"N"           ,_Tipo    )

DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+_TES)
If !Eof()
	_Estoque := SF4->F4_ESTOQUE
EndIf
_Estoque   := Iif(Empty(_Estoque),"N",_Estoque)

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+_Produto)
If !Eof()
	_Conta := SB1->B1_CONTA
	Do Case
		Case !(_Tipo $ "DB") .AND. _Estoque == "S" .AND. !Empty(SB1->B1_CONTA)
			_Conta := SB1->B1_CONTA
		Case !(_Tipo $ "DB") .AND.  Empty(_PEP) .AND.  _Estoque == "N" .AND. !Empty(SB1->B1_CONTADP)
			_Conta := SB1->B1_CONTADP
		Case !(_Tipo $ "DB") .AND. !Empty(_PEP) .AND.  _Estoque == "N" .AND. !Empty(SB1->B1_CTACUST)
			_Conta := SB1->B1_CTACUST
		Case _Tipo $ "DB" .and. !Empty(_CtaAntes)
			_Conta := _CtaAntes
		Case _Tipo $ "DB" .AND. Empty(SB1->B1_CTACUST) .AND. Empty(SB1->B1_CONTA) .AND. !Empty(SB1->B1_CONTADP)
			_Conta := SB1->B1_CONTADP
		OtherWise
			_Conta := SB1->B1_CONTA
	EndCase
	
	_Retorno := _Conta
Endif

RestArea(aArea)

Return(_Retorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRateioOff บAutor  ณSergio Celestino    บ Data ณ  04/20/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarregar o rateio pre configrado (off-line)                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RateioOff(aCols, aHeader, cItem, lPrimeiro)

Local lCusto		:= CtbMovSaldo("CTT")
Local lItem	 		:= CtbMovSaldo("CTD")
Local lCLVL	 		:= CtbMovSaldo("CTH")
Local nPosPerc		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z2_PERC"   } )
Local nVlrRat       := aScan(aHeader,{|x| AllTrim(x[2]) == "Z2_VALOR"  } )
Local nPosItem		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z2_ITEM"   } )
Local nPosCC		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z2_CC"     } )
Local nPosConta		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z2_CONTA"  } )
Local nPosItemCta	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMCTA"} )
Local nPosCLVL		:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z2_CLVL"   } )
Local nHeader       := 0

If lPrimeiro
	//-- Se ja foi informado algum rateio, limpar o aCols
	If aCols[Len(aCols)][nPosPerc] <> 0
		aCols := {}
		Aadd(aCols, Array(Len(aHeader) + 1))
		For nHeader := 1 To Len(aHeader)
			If Trim(aHeader[nHeader][2]) <> "Z2_ALI_WT" .And. Trim(aHeader[nHeader][2]) <> "Z2_REC_WT"
				aCols[Len(aCols)][nHeader] := CriaVar(aHeader[nHeader][2])
			Endif
		Next
	EndIf
	cItem := Soma1(cItem)
	aCols[Len(aCols)][nPosItem]  := cItem
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
Else
	If aCols[Len(aCols)][nPosPerc] = 0
		nCols := Len(aCols)
		cItem := aCols[nCols][nPosItem]
	Else
		If Len(aCols) > 0
			cItem := aCols[Len(aCols)][nPosItem]
		Endif
		Aadd(aCols, Array(Len(aHeader) + 1))
		cItem := Soma1(cItem)
	EndIf
	
	For nHeader := 1 To Len(aHeader)
		If Trim(aHeader[nHeader][2]) <> "DE_ALI_WT" .And. Trim(aHeader[nHeader][2]) <> "DE_REC_WT"
			aCols[Len(aCols)][nHeader] := CriaVar(aHeader[nHeader][2])
		EndIf
	Next
	
	aCols[Len(aCols)][nPosItem] := cItem
	
	// Interpreto os campos incluida possibilidade de variaveis de memoria
	If !Empty(CTJ->CTJ_DEBITO)
		aCols[Len(aCols)][nPosConta]	:= CTJ->CTJ_DEBITO
	Else
		aCols[Len(aCols)][nPosConta]	:= CTJ->CTJ_CREDIT
	Endif
	
	
	If lCusto
		If ! Empty(CTJ->CTJ_CCD)
			aCols[Len(aCols)][nPosCc]	:= CTJ->CTJ_CCD
		Else
			aCols[Len(aCols)][nPosCc]	:= CTJ->CTJ_CCC
		Endif
	EndIf
	
	If lItem
		If ! Empty(CTJ->CTJ_ITEMD)
			aCols[Len(aCols)][nPosItemCta]	:= CTJ->CTJ_ITEMD
		Else
			aCols[Len(aCols)][nPosItemCta]	:= CTJ->CTJ_ITEMC
		Endif
	EndIf
	
	If lClVl
		If ! Empty(CTJ->CTJ_CLVLDB)
			aCols[Len(aCols)][nPosClVl]	:= CTJ->CTJ_CLVLDB
		Else
			aCols[Len(aCols)][nPosClVl]	:= CTJ->CTJ_CLVLCR
		Endif
	EndIf
	aCols[Len(aCols)][nPosPerc] := CTJ->CTJ_PERCEN
	aCols[Len(aCols)][nPosPerc]
	aCols[Len(aCols)][Len(aHeader) + 1] := .F.
	
EndIf

Return .T.
