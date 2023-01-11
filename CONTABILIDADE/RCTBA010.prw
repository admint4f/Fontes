#INCLUDE "Protheus.ch"
#INCLUDE "MSMGADD.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGAWIN.CH"
#INCLUDE "MsOle.ch"

#DEFINE BASE_ICMS			1
#DEFINE ALIQUOTA_ICMS		2
#DEFINE VALOR_ICMS		3
#DEFINE BASE_IPI			4
#DEFINE ALIQUOTA_IPI		5
#DEFINE VALOR_IPI			6
#DEFINE BASE_ISS			7
#DEFINE ALIQUOTA_ISS		8
#DEFINE VALOR_ISS			9
#DEFINE BASE_IR			7
#DEFINE ALIQUOTA_IR		8
#DEFINE VALOR_IR			9
#DEFINE BASE_INSS			10
#DEFINE ALIQUOTA_INSS		11
#DEFINE VALOR_INSS		12
#DEFINE BASE_COFINS		13
#DEFINE ALIQUOTA_COFINS	      14
#DEFINE VALOR_COFINS		15
#DEFINE BASE_CSLL			16
#DEFINE ALIQUOTA_CSLL		17
#DEFINE VALOR_CSLL		18
#DEFINE BASE_PIS			19
#DEFINE ALIQUOTA_PIS		20
#DEFINE VALOR_PIS			21

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTBA010 บAutor  ณBruno Daniel Borges บ Data ณ  07/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCadastro de contratos de clientes x metodos de apropriacao eบฑฑ
ฑฑบ          ณfaturamento/financeiro                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTBA010()

Local cQueryBrow 	:= ""
Local cFiltroWhere  := ""
Local nContVend		:= 1

Local aCores :=	{	{"ZZ0_DATA2 < dDataBase "	, "BR_PRETO" 		},; // Contrato Fora de Vig๊ncia(Preto).
				{"ZZ0_STATUS == '1'"		, "BR_AMARELO"	  	},; // 1= Contrato Aguardando Aprova็ใo Gestor (Amarelo) ;
				{"ZZ0_STATUS == '2'"		, "BR_VERMELHO"	  	},; // 2= Contrato Rejeitado pelo Gestor(Vermelho);
				{"ZZ0_STATUS == '3'"		, "BR_AZUL"		  	},; // 3= Contrato Aguardando Cadastro Financeiro/Contแbil (Azul);
				{"ZZ0_STATUS == '4'"		, "BR_VERDE"  	  	},; // 4= Contrato Em Andamento(Verde).
				{"ZZ0_STATUS == '5'"		, "BR_CINZA"      	}}  // 5= Contrato Cancelado

Private cCodAprov 	:= "" 
Private cCadastro 	:= "Contratos de Clientes"
Private aRotina := {	{ "Pesquisar" 	,"AxPesqui"			, 0 , 1},; 
				{ "Visualizar" 	,"U_RCTB10_A"		, 0 , 2},; 
				{ "Alterar" 	,"U_RCTB10_A(,,4)"	, 0 , 4},;
				{ "Novo Item"	,"U_RCTB10_A(,,7)"	, 0 , 7},; 
				{ "Cancelar" 	,"U_RCTB10_E"		, 0 , 5},;
				{ "Reajuste" 	,"U_RCTB10_F"		, 0 , 5},;
				{ "Legenda" 	,"U_RCTB10_B"		, 0 , 2},;
				{ "Relat๓rios" 	,"U_RCTPOPUP"	      , 0 , 8}} 
				//{ "Incluir" 	,"U_RCTB10_A"		, 0 , 3},; RETIRADA POR SOLICITAวรO ERICA, ESTAMOS IMPLANTANDO MODULO DE CONTRATOS

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFiltro para os Aprovadores que tiverem relacionados ณ
//ณaos respectivos Vendedores.                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Select("TRB") <> 0 
	TRB->(DBCLOSEAREA())
EndIf

cCodAprov := Posicione("SA3",7, xFilial("SA3")+__cUserID, "A3_COD")

If !Empty(cCodAprov) // Achou o Codigo do Vendedor, busco no cadastro de Vendedores se ele eh ou nao Aprovador.
                                                             
	cQueryBrow +=  "	SELECT  " + CRLF
	cQueryBrow +=  "	        SA3.A3_COD AS CODVEND, SA3.A3_GEREN "  + CRLF
	cQueryBrow +=  "	FROM " + RETSQLNAME("SA3") + " SA3 "  + CRLF
	cQueryBrow +=  "	WHERE  " + CRLF
	cQueryBrow +=  "	       SA3.A3_FILIAL  = '" + xFilial("SA3") + "' "  + CRLF
	cQueryBrow +=  "	   AND SA3.A3_GEREN  = '" + cCodAprov + "' "  + CRLF
	cQueryBrow +=  "	   AND SA3.D_E_L_E_T_  = ' ' " + CRLF
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,, cQueryBrow ), "TRB", .F., .T.)

	dbSelectArea("TRB")
	TRB->(DBGOTOP())
	While !TRB->(EOF())
		If nContVend == 1
		 	cFiltroWhere +="'" + TRB->CODVEND + "'"
		Else 
			cFiltroWhere += "," + "'" + TRB->CODVEND + "'" 
		EndIf
		TRB->(DBSKIP())	
		nContVend ++
	EndDo
	TRB->(DBCLOSEAREA())
EndIf

DBSELECTAREA("ZZ0")
If !Empty(cFiltroWhere)    
	// Um Aprovador para Vแrios Vendedores.
	Aadd(aRotina, { "Aprova็ใo", "U_RCTB10_J", 0, 5} )	
	mBrowse( 6,1,22,75,"ZZ0",,,,,,aCores,,,,,,,, "ZZ0_VEND IN(" + cFiltroWhere + ")" )
Else
	If !Empty(cCodAprov)
		// Pr๓prio Vendedor
		mBrowse( 6,1,22,75,"ZZ0",,,,,,aCores,,,,,,,, "ZZ0_VEND =  '" + cCodAprov + "'" )
	Else 
		// Usuario Administrativo. 
		//Aadd(aRotina,{ "Alterar" 	,"U_RCTB10_A(,,4)"	, 0 , 4} )
		mBrowse( 6,1,22,75,"ZZ0",,,,,,aCores)
	EndIf	
EndIf

Return(Nil)     
           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB10_A บAutor  ณBruno Daniel Borges บ Data ณ  07/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de manutencao no cadastro de contratos               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB10_A(_x,_y,nOpcBrowse)
Local oDlgMain		:= Nil
Local oEnchoice		:= Nil
Local oFolders		:= Nil    
Local oBotao1		:= Nil
Local oBotao2		:= Nil
Local oBotao3		:= Nil
Local oBotao4		:= Nil
Local aCoordenadas	:= MsAdvSize(.T.)
Local aCols1		:= {}
Local aCols2		:= {}
Local aCols3		:= {}
Local aCols4		:= {}
Local nOpcClick		:= 0
Local nPosContab	      := 0
Local nPosNF		:= 0  
Local nPosData		:= 0
Local nOpcGetD		:= 0 //Iif(nOpcBrowse <> 2 .Or. nOpcBrowse <> 5,GD_INSERT+GD_DELETE+GD_UPDATE,0)
Local cItem			:= "" 
Local cVetor            := ""
Local i			:= 0 
Local j 			:= 0
Local lAltContrato      := .F.
Local aButtons 		:=  { 	{ "PMSPESQ"	, {|| Iif( nOpcBrowse == 3, Nil , RejeitaContrato(.T.) ) }, "Motivo da Rejei็ใo pelo Gerente de Vendas", "Motivo" } ,;
						{ "EDIT"	, {|| Iif( nOpcBrowse == 3 .Or. nOpcBrowse == 4, RetMensagem() , Nil ) }, "Selecionar mensagem padrao para os campos ", "Mensagem" } } 

Local aTabelas 		:= {"ZZ1", "ZZ2", "ZZR","ZZQ"}
Local nTabelas		:= 1
Local lGrava            := .f.

Private aHeadZZ1	:= {}
Private aHeadZZ2	:= {} 
Private aHeadZZR 	:= {}
Private aHeadZZQ 	:= {}

Private oGetDad1	:= Nil
Private oGetDad2	:= Nil 
Private oGetDad3	:= Nil
Private oGetDad4	:= Nil

If nOpcBrowse = 2 
   nOpcGetD		:= 0
ElseIf nOpcBrowse = 5 
   nOpcGetD		:= 0
Else
   nOpcGetD		:= GD_INSERT+GD_DELETE+GD_UPDATE
EndIf


If (nOpcBrowse == 4 .Or. nOpcBrowse == 5 .Or. nOpcBrowse == 7) .And. ZZ0->ZZ0_STATUS $ "5|2"
	MsgAlert("Aten็ใo, esse contrato esta CANCELADO ou REJEITADO. Nใo serแ possํvel alterแ-lo, exclui-lo e/ou copiแ-lo.")
	Return(Nil)
EndIf

dbSelectArea("ZZ0")
RegToMemory("ZZ0",nOpcBrowse == 3 .Or. nOpcBrowse == 7)

//Monta os aHeaders
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("ZZ1"))
While SX3->(!Eof()) .And. ALLTRIM(SX3->X3_ARQUIVO) >= "ZZ1" .And. ALLTRIM(SX3->X3_ARQUIVO) <= "ZZR"
	If X3Uso(SX3->X3_USADO) .And. SX3->X3_ARQUIVO $ "ZZ1|ZZ2|ZZR|ZZQ"
		cVetor := "aHead"+SX3->X3_ARQUIVO 
		Aadd( &(cVetor),;
						{Trim(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE,; 
						SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID,;
						SX3->X3_USADO, SX3->X3_TIPO,;
						SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX, , SX3->X3_WHEN,;
						SX3->X3_VISUAL, SX3->X3_VLDUSER, SX3->X3_PICTVAR, SX3->X3_OBRIGAT })
	EndIf
	SX3->(dbSkip())
EndDo

//Monta os aCols
If nOpcBrowse == 3 .Or. nOpcBrowse == 7
	AAdd(aCols1,Array(Len(aHeadZZ1)+1))
	For i := 1 To Len(aHeadZZ1)
		aCols1[1,i] := CriaVar(aHeadZZ1[i,2])
	Next i
	aCols1[1,Len(aHeadZZ1)+1] := .F.

	AAdd(aCols2,Array(Len(aHeadZZ2)+1))
	For i := 1 To Len(aHeadZZ2)
		aCols2[1,i] := CriaVar(aHeadZZ2[i,2])
	Next i
	aCols2[1,Len(aHeadZZ2)+1] := .F.
	
	AAdd(aCols3,Array(Len(aHeadZZR)+1))
	For i := 1 To Len(aHeadZZR)
		If aHeadZZR[i,2] <> "ZZR_IDITEM"
			aCols3[1,i] := CriaVar(aHeadZZR[i,2])
		Else	
			aCols3[1,i] := "001"
		EndIf	
	Next i
	aCols3[1,Len(aHeadZZR)+1] := .F.

	AAdd(aCols4,Array(Len(aHeadZZQ)+1))
	For i := 1 To Len(aHeadZZQ)         
	
		If aHeadZZQ[i,2] <> "ZZQ_IDITEM"
			aCols4[1,i] := CriaVar(aHeadZZQ[i,2])
		Else	
			aCols4[1,i] := "001"
		EndIf		
	Next i
	aCols4[1,Len(aHeadZZQ)+1] := .F.
	
	cItem := Iif(nOpcBrowse == 3,"001","")
	M->ZZ0_ITEM	:= cItem

Else

	dbSelectArea("ZZ1")
	ZZ1->(dbSetOrder(2))
	ZZ1->(dbSeek(xFilial("ZZ1")+"C"+M->ZZ0_CONTRA))
	While ZZ1->(!Eof()) .And. ZZ1->ZZ1_FILIAL + ZZ1->ZZ1_TPCONT + ZZ1->ZZ1_CONTRA == xFilial("ZZ1")+"C"+M->ZZ0_CONTRA
		If ZZ1->ZZ1_ITEM <> M->ZZ0_ITEM
			ZZ1->(dbSkip())
			Loop
		EndIf
		
		AAdd(aCols1,Array(Len(aHeadZZ1)+1))
		For i := 1 To Len(aHeadZZ1)
			aCols1[Len(aCols1),i] := ZZ1->&(aHeadZZ1[i,2])
		Next i
		aCols1[Len(aCols1),Len(aHeadZZ1)+1] := .F.
		ZZ1->(dbSkip())
	EndDo

	dbSelectArea("ZZ2")
	ZZ2->(dbSetOrder(2))
	ZZ2->(dbSeek(xFilial("ZZ2")+"C"+M->ZZ0_CONTRA))
	While ZZ2->(!Eof()) .And. ZZ2->ZZ2_FILIAL + ZZ2->ZZ2_TPCONT + ZZ2->ZZ2_CONTRA == xFilial("ZZ2")+"C"+M->ZZ0_CONTRA
		If ZZ2->ZZ2_ITEM <> M->ZZ0_ITEM
			ZZ2->(dbSkip())
			Loop
		EndIf
		
		AAdd(aCols2,Array(Len(aHeadZZ2)+1))
		For i := 1 To Len(aHeadZZ2)
			aCols2[Len(aCols2),i] := ZZ2->&(aHeadZZ2[i,2])
		Next i
		aCols2[Len(aCols2),Len(aHeadZZ2)+1] := .F.
		ZZ2->(dbSkip())
	EndDo

    // Incluido Por - Fernando 06/2008 - Carrega aCols para as Informa็๕es Adicionais
	dbSelectArea("ZZR")
	ZZR->(dbSetOrder(1))
	ZZR->(dbSeek(xFilial("ZZR")+M->ZZ0_CONTRA+M->ZZ0_ITEM))
	While ZZR->(!Eof()) .And. ZZR->ZZR_FILIAL + ZZR->ZZR_CONTRA+ZZR->ZZR_ITEM == xFilial("ZZR")+M->ZZ0_CONTRA+M->ZZ0_ITEM
		
		AAdd(aCols3, Array(Len(aHeadZZR)+1))
		For i := 1 To Len(aHeadZZR)

		    If aHeadZZR[i,10] <> "V"
				aCols3[Len(aCols3),i] := ZZR->&(aHeadZZR[i,2])
			Else
				aCols3[Len(aCols3),i] := Criavar(aHeadZZR[i,2])
			EndIf	
 		
		Next i
		aCols3[Len(aCols3), Len(aHeadZZR)+1] := .F.
		ZZR->(dbSkip())
	EndDo

    // Incluido Por - Fernando 06/2008 - Carrega aCols das Formas de Pagto.
	dbSelectArea("ZZQ")
	ZZQ->(dbSetOrder(1))
	ZZQ->(dbSeek(xFilial("ZZQ")+M->ZZ0_CONTRA+M->ZZ0_ITEM))
	While ZZQ->(!Eof()) .And. ZZQ->ZZQ_FILIAL + ZZQ->ZZQ_CONTRA+ZZQ->ZZQ_ITEM == xFilial("ZZQ")+M->ZZ0_CONTRA+M->ZZ0_ITEM
		AAdd(aCols4, Array(Len(aHeadZZQ)+1))
		For i := 1 To Len(aHeadZZQ)  
		    If aHeadZZQ[i,10] <> "V"
				aCols4[Len(aCols4),i] := ZZQ->&(aHeadZZQ[i,2])
			Else
				aCols4[Len(aCols4),i] := Criavar(aHeadZZQ[i,2])
			EndIf
	    Next i
		aCols4[Len(aCols4), Len(aHeadZZQ)+1] := .F.
		ZZQ->(dbSkip())
	EndDo	
EndIf

//Tela de manutencao no cadastro 
oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5],OemToAnsi("Contrato de Clientes"),,,,,,,,oMainWnd,.T.)
//MOISES 1011 oEnchoice := MsMGet():New("ZZ0",ZZ0->(RecNo()),Iif(nOpcBrowse == 4 .Or. nOpcBrowse == 3 .Or. nOpcBrowse == 7 ,3,nOpcBrowse),,,,,{014,003,oDlgMain:nClientHeight/6.5,oDlgMain:nClientWidth/2-5},,3,,,,,,.T.)
oEnchoice := MsMGet():New("ZZ0",ZZ0->(RecNo()),Iif(nOpcBrowse == 4 .Or. nOpcBrowse == 3 .Or. nOpcBrowse == 7 ,3,nOpcBrowse),,,,,{034,003,oDlgMain:nClientHeight/6.5,oDlgMain:nClientWidth/2-5},,3,,,,,,.T.)

//No caso de copia, replica os dados principais do contrato
If nOpcBrowse == 7                      

	For i := 1 To Len(oEnchoice:aGets)        
		dbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		If SX3->(dbSeek(AllTrim(SubStr(oEnchoice:aGets[i],9,10)))) .And. SX3->X3_CONTEXT <> "V"
			 &("M->"+SubStr(oEnchoice:aGets[i],9,10)) :=  ZZ0->&(SubStr(oEnchoice:aGets[i],9,10))
		EndIf
	Next i

	ZZ0->(dbSetOrder(1))
	ZZ0->(dbSeek(xFilial("ZZ0")+M->ZZ0_CONTRA))
	While ZZ0->(!Eof()) .And. ZZ0->ZZ0_FILIAL + ZZ0->ZZ0_CONTRA == xFilial("ZZ0")+M->ZZ0_CONTRA
		cItem := ZZ0->ZZ0_ITEM	     
		ZZ0->(dbSkip())
	EndDo
	cItem := StrZero(Val(cItem)+1,3)
	M->ZZ0_ITEM		:= cItem                         
	
	nOpcBrowse := 3
      INCLUI     := .T.
      ALTERA     := .F.

EndIf

	      //Folders com os metodos de apropriacao e faturamento/cobranca
	      oFolders := TFolder():New(oDlgMain:nClientHeight/6.5+3,003,{"M้todo de Apropria็ใo","M้todo de Faturamento/Cobran็a", "Inf. Adicionais", "Forma Pagto"},,oDlgMain,,,,.T.,.F.,oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-(oDlgMain:nClientHeight/6.5 + 35))
		oBotao1 := TButton():New(001,001,OemToAnsi("Gerar Parcelas de &Apropria็ใo"),oFolders:aDialogs[1],{|| RCTB10_C(@oGetDad1,1) },100,010,,,,.T.,,,,{|| })   		
		oGetDad1 := MsNewGetDados():New(012,001,oFolders:aDialogs[1]:nClientHeight/2-3,oFolders:aDialogs[1]:nClientWidth/2-3,nOpcGetD,,,"",,,9999,,,,oFolders:aDialogs[1],aHeadZZ1,aCols1)
		nPosContab := AScan(aHeadZZ1,{|x| AllTrim(x[2]) == "ZZ1_LA" })
		oGetDad1:bDelOk := {|| Iif(oGetDad1:aCols[oGetDad1:nAt,nPosContab] == "S",(Alert("Apropria็ใo jแ contabilizada, nใo serแ possํvel excluir a parcela."),.F.),.T.) }
		//Iif(nOpcBrowse <> 3,oBotao1:Disable(),Nil) 
		If !Empty(cCodAprov)
			oFolders:aDialogs[1]:Disable()
		EndIf
		
		oBotao2 := TButton():New(001,001,OemToAnsi("Gerar Parcelas de &Faturamento"),oFolders:aDialogs[2],{|| RCTB10_C(@oGetDad2,2) },100,010,,,,.T.,,,,{|| })   		
		oGetDad2 := MsNewGetDados():New(012,001,oFolders:aDialogs[2]:nClientHeight/2-3,oFolders:aDialogs[2]:nClientWidth/2-3,nOpcGetD,,,"",,,9999,,,,oFolders:aDialogs[2],aHeadZZ2,aCols2)
		nPosNF := AScan(aHeadZZ2,{|x| AllTrim(x[2]) == "ZZ2_NUMNF" })
		oGetDad2:bDelOk := {|| Iif(!Empty(oGetDad2:aCols[oGetDad2:nAt,nPosNF]),(Alert("Parcela jแ faturada, nใo serแ possํvel exclui-la."),.F.),.T.) }
		//Iif(nOpcBrowse <> 3,oBotao2:Disable(),Nil)
		If !Empty(cCodAprov)
			oFolders:aDialogs[2]:Disable()
		EndIf

		oGetDad3 := MsNewGetDados():New(001,001,oFolders:aDialogs[3]:nClientHeight/2-3,oFolders:aDialogs[3]:nClientWidth/2-3,nOpcGetD,,,"+ZZR_IDITEM", ,,9999,,,,oFolders:aDialogs[3],aHeadZZR,aCols3)

		oGetDad4 := MsNewGetDados():New(001,001,oFolders:aDialogs[4]:nClientHeight/2-3,oFolders:aDialogs[4]:nClientWidth/2-3,nOpcGetD,,,"+ZZQ_IDITEM", ,,9999,,,,oFolders:aDialogs[4],aHeadZZQ,aCols4)
		EnchoiceBar(oDlgMain, {|| Iif( lAltContrato := RCTB10_D(nOpcBrowse, oEnchoice, oGetDad1, oGetDad2, oFolders ),nOpcClick := 1,nOpcClick := 0), Iif(nOpcClick == 1,oDlgMain:End(),Nil)}, {|| nOpcClick := 0, oDlgMain:End()}, ,aButtons )

            oDlgMain:Activate(,,,.T.)  
     
//Gravacao dos Dados
If nOpcBrowse <> 2 .And. nOpcClick == 1	
	dbSelectArea("ZZ0")
	ZZ0->(dbSetOrder(1))
	If ZZ0->(dbSeek(xFilial("ZZ0")+M->ZZ0_CONTRA+M->ZZ0_ITEM))
		ZZ0->(RecLock("ZZ0",.F.))
	Else
		ZZ0->(RecLock("ZZ0",.T.))
		ConfirmSX8()
	EndIf                         
	
	If nOpcBrowse == 5
		ZZ0->(dbDelete())
	Else      
		ZZ0->ZZ0_FILIAL	:= xFilial("ZZ0")
		ZZ0->ZZ0_STATUS	:= "3"
		For i := 1 To Len(oEnchoice:aGets)        
			dbSelectArea("SX3")
			SX3->(dbSetOrder(2))
			If SX3->(dbSeek(AllTrim(SubStr(oEnchoice:aGets[i],9,10)))) .And. SX3->X3_CONTEXT <> "V"
				ZZ0->&(SubStr(oEnchoice:aGets[i],9,10)) :=  &("M->"+SubStr(oEnchoice:aGets[i],9,10))
			EndIf
		Next i   
	EndIf

      // Campos Memo.                                                                                        
      MSMM( ZZ0->ZZ0_CODOBS, TamSX3("ZZ0_OBS")[1]   ,, M->ZZ0_OBS   , 1,,, "ZZ0", "ZZ0_CODOBS" ) // Observacao.
      MSMM( ZZ0->ZZ0_CODOBJ, TamSX3("ZZ0_OBJETO")[1],, M->ZZ0_OBJETO, 1,,, "ZZ0", "ZZ0_CODOBJ" ) // Objeto.
      MSMM( ZZ0->ZZ0_CODREJ, TamSX3("ZZ0_MEMREJ")[1],, M->ZZ0_MEMREJ, 1,,, "ZZ0", "ZZ0_CODREJ" ) // Rejeicao.
      MSMM( ZZ0->ZZ0_CODOUT, TamSX3("ZZ0_OUTCUS")[1],, M->ZZ0_OUTCUS, 1,,, "ZZ0", "ZZ0_CODOUT" ) // Outros Custos.
      MSMM( ZZ0->ZZ0_CODINF, TamSX3("ZZ0_INFGER")[1],, M->ZZ0_INFGER, 1,,, "ZZ0", "ZZ0_CODINF" ) // Inf. Gerais.
      MSMM( ZZ0->ZZ0_CODMER, TamSX3("ZZ0_MERCHA")[1],, M->ZZ0_MERCHA, 1,,, "ZZ0", "ZZ0_CODMER" ) // Merchandising.
        
	ZZ0->(MsUnlock())

	//Avalia se contrato esta com preco do produto menor do que tabela de precos se estiver altera status para AGUARDANDO APROVACAO DO GESTOR DA AREA
	//If !Empty(ZZ0->ZZ0_TABPRC) .And. Posicione("DA1",1,xFilial("DA1")+ZZ0->ZZ0_TABPRC+AllTrim(ZZ0->ZZ0_PRODUT),"DA1->DA1_PRCVEN" ) > ZZ0->ZZ0_VALOR
	//	ZZ0->(RecLock("ZZ0",.F.))
	//	 ZZ0->ZZ0_STATUS := "1"
	//	ZZ0->(MsUnlock())
	//EndIf 
	
	//Gravacao das parcelas de apropriacao
	If Len(oGetDad1:aCols) > 0 .And. oGetDad1:aCols[1,1] > 0
		dbSelectArea("ZZ1")
		ZZ1->(dbSetOrder(2))
		nPosData := AScan(aHeadZZ1,{|x| AllTrim(x[2]) == "ZZ1_DATA" })
		
		For i := 1 To Len(oGetDad1:aCols)
			lGrava := .f.
			If ZZ1->(dbSeek(xFilial("ZZ1")+"C"+M->ZZ0_CONTRA+DToS(oGetDad1:aCols[i,nPosData])+M->ZZ0_ITEM ))
				ZZ1->(RecLock("ZZ1",.F.))
			      lGrava := .t.
				If oGetDad1:aCols[i,Len(oGetDad1:aHeader)+1]
					ZZ1->(dbDelete())
					ZZ1->(MsUnlock())  
					Loop
				EndIf
			ElseIf !oGetDad1:aCols[i,Len(oGetDad1:aHeader)+1]
				ZZ1->(RecLock("ZZ1",.T.))
			      lGrava := .t.
			EndIf
			If lGrava                
			  ZZ1->ZZ1_FILIAL	:= xFilial("ZZ1")   
			  ZZ1->ZZ1_CONTRA	:= M->ZZ0_CONTRA 
			  ZZ1->ZZ1_TPCONT	:= "C" 
			  ZZ1->ZZ1_ITEM	:= M->ZZ0_ITEM
			  For j := 1 To Len(oGetDad1:aHeader)
				If oGetDad1:aHeader[j,10] <> "V"
					ZZ1->&(oGetDad1:aHeader[j,2]) := oGetDad1:aCols[i,j]
				EndIf
			  Next j
			  ZZ1->(MsUnlock())
                  EndIf
		Next i
	EndIf

	//Gravacao das parcelas de faturamento
	If Len(oGetDad2:aCols) > 0 .And. oGetDad2:aCols[1,1] > 0
		dbSelectArea("ZZ2")
		ZZ2->(dbSetOrder(2))
		nPosData := AScan(aHeadZZ2,{|x| AllTrim(x[2]) == "ZZ2_VENCTO" })
		For i := 1 To Len(oGetDad2:aCols)
                  lGrava := .f.
			If ZZ2->(dbSeek(xFilial("ZZ2")+"C"+M->ZZ0_CONTRA+DToS(oGetDad2:aCols[i,nPosData])+M->ZZ0_ITEM ))
				ZZ2->(RecLock("ZZ2",.F.))
                        lGrava := .t.
				If oGetDad2:aCols[i,Len(oGetDad2:aHeader)+1]
					ZZ2->(dbDelete())
					ZZ2->(MsUnlock())  
					Loop
				EndIf
			ElseIf !oGetDad2:aCols[i,Len(oGetDad2:aHeader)+1]
				ZZ2->(RecLock("ZZ2",.T.))
                        lGrava := .t.
			EndIf
	            If lGrava 		                
			  ZZ2->ZZ2_FILIAL	:= xFilial("ZZ2")   
			  ZZ2->ZZ2_CONTRA	:= M->ZZ0_CONTRA 
			  ZZ2->ZZ2_TPCONT	:= "C"           
			  ZZ2->ZZ2_ITEM	:= M->ZZ0_ITEM
			  For j := 1 To Len(oGetDad2:aHeader)
				If oGetDad2:aHeader[j,10] <> "V"
					ZZ2->&(oGetDad2:aHeader[j,2]) := oGetDad2:aCols[i,j]
				EndIf
			  Next j
			  ZZ2->(MsUnlock())
                  EndIf
		Next i
	EndIf  
	
	// Gravacao Informacoes Adicionais
	If Len(oGetDad3:aCols) > 0
		dbSelectArea("ZZR")
		ZZR->(dbSetOrder(1))
		For i := 1 To Len(oGetDad3:aCols)
			If ZZR->( dbSeek(xFilial("ZZR")+M->ZZ0_CONTRA+M->ZZ0_ITEM+oGetDad3:aCols[i,1]))
				ZZR->(RecLock("ZZR",.F.))
				If oGetDad3:aCols[i,Len(oGetDad3:aHeader)+1]
					ZZR->(dbDelete())
					ZZR->(MsUnlock())
					Loop
				EndIf

			ElseIf !oGetDad3:aCols[i,Len(oGetDad3:aHeader)+1]
				ZZR->(RecLock("ZZR",.T.))
			EndIf
			                
			ZZR->ZZR_FILIAL	:= xFilial("ZZR")   
			ZZR->ZZR_CONTRA	:= M->ZZ0_CONTRA 
			ZZR->ZZR_ITEM	:= M->ZZ0_ITEM

			For j := 1 To Len(oGetDad3:aHeader)
				If oGetDad3:aHeader[j,10] <> "V"
					ZZR->&(oGetDad3:aHeader[j,2]) := oGetDad3:aCols[i,j]
				EndIf
			Next j

			// Campos Memo
	        MSMM( ZZR->ZZR_CODOBS, TamSX3("ZZR_OBSERV")[1],, oGetDad3:aCols[i, aScan(oGetDad3:aHeader,{|x| x[2] == "ZZR_OBSERV"})], 1,,, "ZZ0", "ZZR_CODOBS" ) // Observacao.

			ZZR->(MsUnlock())
		Next i
	EndIf  	

	If Len(oGetDad4:aCols) > 0
		dbSelectArea("ZZQ")
		ZZQ->(dbSetOrder(1))
		For i := 1 To Len(oGetDad4:aCols)
			If ZZQ->(dbSeek(xFilial("ZZQ")+M->ZZ0_CONTRA+M->ZZ0_ITEM+oGetDad4:aCols[i,1] ))
				ZZQ->(RecLock("ZZQ",.F.))
				If oGetDad4:aCols[i,Len(oGetDad4:aHeader)+1]
					ZZQ->(dbDelete())
					ZZQ->(MsUnlock())  
					Loop
				EndIf
			ElseIf !oGetDad4:aCols[i,Len(oGetDad4:aHeader)+1]
				ZZR->(RecLock("ZZQ",.T.))
			EndIf
			                
			ZZQ->ZZQ_FILIAL	:= xFilial("ZZQ")
			ZZQ->ZZQ_CONTRA	:= M->ZZ0_CONTRA 
			ZZQ->ZZQ_ITEM	:= M->ZZ0_ITEM 
			
			For j := 1 To Len(oGetDad4:aHeader)
				If oGetDad4:aHeader[j,10] <> "V"
					ZZQ->&(oGetDad4:aHeader[j,2]) := oGetDad4:aCols[i,j]
				EndIf
			Next j
			
			// Campos Memo
			MSMM( ZZQ->ZZQ_CODOBS, TamSX3("ZZQ_OBSERV")[1],, oGetDad4:aCols[i, aScan(oGetDad4:aHeader,{|x| x[2] == "ZZQ_OBSERV"})] , 1,,, "ZZQ", "ZZQ_CODOBS" )
						
			ZZQ->(MsUnlock())
		Next i
	EndIf  		
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAltera o Status do Contrato para 4= Contrato Em Andamento, somente existir uma Apropria็ใo ou Faturamento jแ gerado para o Contrato.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lAltContrato	.And. ZZ0->ZZ0_STATUS == "3" .And. Empty(cCodAprov)
		ZZ0->(RecLock("ZZ0",.F.))
			ZZ0->ZZ0_STATUS := "4"
		ZZ0->(MsUnLock())
	EndIf

EndIf

Return(Nil)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB10_B บAutor  ณBruno Daniel Borges บ Data ณ  07/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLegenda do Browse                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB10_B()

Local aCores :=	{	{ "BR_AMARELO" , "Aguardando Aprova็ใo Gestor"		  },; 
				{ "BR_VERMELHO", "Rejeitado pelo Gestor"			  },; 
				{ "BR_AZUL"	   , "Aguardando Cad. Financeiro/Contแbil"  },;
				{ "BR_VERDE"   , "Em Andamento"				  },;
 				{ "BR_PRETO"   , "Fora de Vig๊ncia"				  },;
 				{ "BR_CINZA"   , "Contrato Cancelado"			  }}

BrwLegenda("Status de Contratos","Legenda",aCores)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB10_C บAutor  ณBruno Daniel Borges บ Data ณ  08/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de parametrizacao das parcelas de apropriacao e/ou   บฑฑ
ฑฑบ          ณfaturamento                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RCTB10_C(oGetDados,nTipo)
Local oDlgParcelas	:= Nil
Local nQtdParcelas	:= 0 
Local nDiasIntervalo:= 0
Local nMesesEntre	:= 1  
Local nMesAtual		:= 0
Local i,j       
Local nOpc 			:=0

If M->ZZ0_VALOR <= 0
	MsgAlert("Aten็ใo, informe o valor total do contrato antes de incluir as formas de apropria็ใo e faturamento.")
	Return(Nil)
EndIf 

//Tenta calcular o total de parcelas LINEARES com base nos campos Data Inicio e Data Fim de Vigencia
If !Empty(M->ZZ0_DATA1) .And. !Empty(M->ZZ0_DATA2)
	nMesAtual := Month(M->ZZ0_DATA1)
	For i := 1 To (M->ZZ0_DATA2 - M->ZZ0_DATA1)
		If Month(M->ZZ0_DATA1+i) <> nMesAtual 
			nMesesEntre++	
			nMesAtual := Month(M->ZZ0_DATA1+i)
		EndIf
	Next i  
	
	If nMesesEntre > 0
		nQtdParcelas := nMesesEntre
	EndIf
EndIf

oDlgParcelas := TDialog():New(000,000,120,150,OemToAnsi("Forma de "+IIf(nTipo == 1,"Apropria็ใo","Faturamento")),,,,,,,,oMainWnd,.T.)
	TSay():New(001,001,{|| OemToAnsi("Quantidade Parcelas")},oDlgParcelas,,,,,,.T.,,,oDlgParcelas:nWidth/2-5,10)                     
	@ 011,001 MsGet nQtdParcelas Picture "@E 999,999.99" Size oDlgParcelas:nWidth/2-5,8 Valid(nQtdParcelas >= 1) Of oDlgParcelas Pixel

	TSay():New(025,001,{|| OemToAnsi("Dias de Intervalo")},oDlgParcelas,,,,,,.T.,,,oDlgParcelas:nWidth/2-5,10)
	@ 035,001 MsGet nDiasIntervalo Picture "@E 999,999.99" Size oDlgParcelas:nWidth/2-5,8 Valid(nDiasIntervalo >= 1) Of oDlgParcelas Pixel

	TButton():New(050,001,OemToAnsi("Gerar Parcelas"),oDlgParcelas,{|| nOpc := 1 , oDlgParcelas:End()  },060,010,,,,.T.,,,,{|| })   			
oDlgParcelas:Activate(,,,.T.)                                          
 
 If nOpc <> 1 
 	Return(Nil)
 EndIf
 
 If Len(oGetDados:aCols) > 0 .And. oGetDados:aCols[1,1] > 0
	If !MsgYesNo("Confirma o recแlculo da forma de " + IIf(nTipo == 1,"Apropria็ใo","Faturamento") + " ? As informa็๕es jแ digitadas serใo perdidas.")
		Return(Nil)
	EndIf
EndIf

oGetDados:aCols := {}
For i := 1 To nQtdParcelas
	AAdd(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))
	For j := 1 To Len(oGetDados:aHeader)
		oGetDados:aCols[Len(oGetDados:aCols)][j] := CriaVar(oGetDados:aHeader[j][2])
	Next j
	oGetDados:aCols[Len(oGetDados:aCols)][Len(oGetDados:aHeader)+1] := .F.
	
	//Apropriacao
	If nTipo == 1
		oGetDados:aCols[Len(oGetDados:aCols)][AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ1_VALOR" 	})] := Round(M->ZZ0_VALOR/nQtdParcelas,2)
		oGetDados:aCols[Len(oGetDados:aCols)][AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ1_DATA" 	})] := Iif(Empty(M->ZZ0_DATA1),dDataBase,M->ZZ0_DATA1) + (i * nDiasIntervalo)
		
		//Calculo do imposto
		//LJMsgRun("Calculando Parcelas e Impostos","Aguarde",{|| RCTB10_G(M->ZZ0_TES,M->ZZ0_CLIENT,M->ZZ0_LOJA,M->ZZ0_PRODUT,Round(M->ZZ0_VALOR/nQtdParcelas,2),.F.,Len(oGetDados:aCols),1) })
		
	//Faturamento
	Else
		oGetDados:aCols[Len(oGetDados:aCols)][AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ2_VALOR" 	})] := Round(M->ZZ0_VALOR/nQtdParcelas,2)
		oGetDados:aCols[Len(oGetDados:aCols)][AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ2_VENCTO" 	})] := Iif(Empty(M->ZZ0_DATA1),dDataBase,M->ZZ0_DATA1) + (i * nDiasIntervalo)
	EndIf
Next i

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB10_D บAutor  ณBruno Daniel Borges บ Data ณ  08/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao dos campos antes da gravacao            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RCTB10_D(nOpcBrowse,oEnchoice,oGetDad1,oGetDad2, oFolders)
Local nTotSoma	:= 0  
Local nPosAprop	:= AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZ1_VALOR" })
Local nPosFat	:= AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZ2_VALOR" }) 
Local nPosFPagto  := AScan(oGetDad4:aHeader,{|x| AllTrim(x[2]) == "ZZQ_VALOR" }) 
Local i

//Valida campos obrigatorios do cabecalho
For i := 1 To Len(oEnchoice:aGets)
	If SubStr(oEnchoice:aGets[i],25,1) == "T" .And. Empty(&("M->"+SubStr(oEnchoice:aGets[i],9,10)))
		MsgAlert("Campos obrigat๓rios nใo foram informados. Nใo serแ possํvel seguir com a grava็ใo.")
		Return(.F.)
	EndIf
Next i           
                  
//Valida exclusao de contratos com parcelas ja geradas
If nOpcBrowse == 5
	For i := 1 To Len(oGetDad1:aCols)
		If oGetDad1:aCols[i,AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZ1_LA" })] == "S"
			MsgAlert("Jแ existem apropria็๕es contabilizadas para esse contrato. Utilize a op็ใo de CANCELAMENTO.")
			Return(.F.)			
		EndIf
	Next i
	
	For i := 1 To Len(oGetDad2:aCols)
		If !Empty(oGetDad2:aCols[i,AScan(oGetDad2:aHeader,{|x| AllTrim(x[2]) == "ZZ2_NUMNF" })])
			MsgAlert("Jแ existem faturamentos/cobran็a para esse contrato. Utilize a op็ใo de CANCELAMENTO.")
			Return(.F.)			
		EndIf
	Next i 

//Validacoes especificas da inclusao e alteracao
ElseIf nOpcBrowse == 3 .Or. nOpcBrowse == 4  .Or. nOpcBrowse == 7      
	AEval(oGetDad1:aCols,{|x| Iif(x[Len(oGetDad1:aHeader)+1],Nil,nTotSoma += x[nPosAprop]) })
	//If Round(nTotSoma,0) <> Round(M->ZZ0_VALOR,0) .And. Len(oGetDad1:aCols) > 0 .And. oGetDad1:aCols[1,1] > 0
	If Round(nTotSoma,2) <> Round(M->ZZ0_VALOR,2) .And. Len(oGetDad1:aCols) > 0 .And. oGetDad1:aCols[1,1] > 0
		MsgAlert(	"A soma das parcelas de apropria็ใo esta diferente do informado no contrato."+Chr(13)+Chr(10)+;
					" - Total Parcelas: " + AllTrim(Transform(nTotSoma,"@E 999,999,999.99"))+Chr(13)+Chr(10)+;
					" - Total Contrato: " + AllTrim(Transform(M->ZZ0_VALOR,"@E 999,999,999.99")))
		Return(.F.)
	EndIf

	nTotSoma := 0
	AEval(oGetDad2:aCols,{|x| Iif(x[Len(oGetDad2:aHeader)+1],Nil,nTotSoma += x[nPosFat]) })
	If Round(nTotSoma,2) <> Round(M->ZZ0_VALOR,2) .And. Len(oGetDad2:aCols) > 0 .And. oGetDad2:aCols[1,1] > 0
		MsgAlert(	"A soma das parcelas de faturamento esta diferente do informado no contrato."+Chr(13)+Chr(10)+;
					" - Total Parcelas: " + Transform(nTotSoma,"@E 999,999,999.99")+Chr(13)+Chr(10)+;
					" - Total Contrato: " + Transform(M->ZZ0_VALOR,"@E 999,999,999.99"))
		oFolders:nOption := 2					
		Return(.F.)
	EndIf

	nTotSoma := 0
	AEval(oGetDad4:aCols,{|x| Iif(x[Len(oGetDad4:aHeader)+1],Nil,nTotSoma += x[nPosFPagto]) })
	If Round(nTotSoma,2) <> Round(M->ZZ0_VALOR,2) .And. Len(oGetDad4:aCols) > 0

		MsgAlert(	"A soma das parcelas da forma de pagamento estแ diferente do Valor informado no contrato."+Chr(13)+Chr(10)+;
					" - Total Parcelas: " + Transform(nTotSoma,"@E 999,999,999.99")+Chr(13)+Chr(10)+;
					" - Total Contrato: " + Transform(M->ZZ0_VALOR,"@E 999,999,999.99"))
		oFolders:nOption := 4					
		Return(.F.)

	EndIf

EndIf

Return(.T.)           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB10_E บAutor  ณBruno Daniel Borges บ Data ณ  15/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de cancelamento de contratos                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB10_E()

If ZZ0->ZZ0_STATUS $ "5|2"
	MsgAlert("Contrato jแ consta como CANCELADO ou REJEITADO PELO GERENTE DE VENDAS.")
	Return(Nil)
EndIf

If MsgYesNo("Aten็ใo, ao cancelar as apropria็๕es e os faturamentos nใo poderใo mais ser feitos com base nesse contrato. Confirma ?")
	ZZ0->(RecLock("ZZ0",.F.))
		ZZ0->ZZ0_STATUS := "5"
	ZZ0->(MsUnlock())
EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB10_F บAutor  ณBruno Daniel Borges บ Data ณ  15/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de atualizacao da correcao de um determinado indice  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB10_F()
Local oDlgIndex	:= Nil
Local cIndex	:= Space(3)
Local cNomeInd	:= Space(30) 
Local nIndex	:= 0  
Local nOpc		:= 0

oDlgIndex := TDialog():New(000,000,120,150,OemToAnsi("Atualiza็ใo Indexador"),,,,,,,,oMainWnd,.T.)
	TSay():New(001,001,{|| OemToAnsi("Indexador")},oDlgIndex,,,,,,.T.,,,oDlgIndex:nWidth/2-5,10)
	@ 011,001 MsGet cIndex Picture "@!" F3 "ZK" Size 030,8 Valid(!Empty(cIndex), cNomeInd := Posicione("SX5",1,xFilial("SX5")+"ZK"+cIndex,"SX5->X5_DESCRI" )) Of oDlgIndex Pixel
	@ 011,035 MsGet cNomeInd Picture "@!" Size oDlgIndex:nClientWidth/2-40,8 When .F. Of oDlgIndex Pixel

	TSay():New(025,001,{|| OemToAnsi("% Atual")},oDlgIndex,,,,,,.T.,,,oDlgIndex:nWidth/2-5,10)
	@ 035,001 MsGet nIndex Picture "@E 999.9999" Size oDlgIndex:nWidth/2-5,8  Of oDlgIndex Pixel

	TButton():New(050,001,OemToAnsi("&Gravar"),oDlgIndex,{|| nOpc := 1, oDlgIndex:End()  },030,010,,,,.T.,,,,{|| })
	TButton():New(050,035,OemToAnsi("&Cancelar"),oDlgIndex,{|| nOpc := 0, oDlgIndex:End()  },030,010,,,,.T.,,,,{|| })
oDlgIndex:Activate(,,,.T.)

If nOpc == 1
	dbSelectArea("ZZ0")
	ZZ0->(dbGoTop())
	LJMsgRun("Atualizando Contratos","Aguarde",{|| ZZ0->(dbEval({|| Iif(ZZ0->ZZ0_STATUS == "1" .And. ZZ0->ZZ0_TPCORR == cIndex, (ZZ0->(RecLock("ZZ0",.F.)),ZZ0->ZZ0_INDVIG := nIndex, ZZ0->ZZ0_INDCOR := (nIndex/100+1)*IIF(ZZ0->ZZ0_INDCOR==0,1,ZZ0->ZZ0_INDCOR), ZZ0->(MsUnlock())  )  ,Nil )  })) })
	MsgAlert("Contratos indexados pelo " + AllTrim(Upper(cNomeInd)) + " foram atualizados com sucesso")
EndIf                                     

Return(Nil)    
                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB10_G บAutor  ณBruno Daniel Borges บ Data ณ  17/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que calcula os impostos de uma parcela conforme      บฑฑ
ฑฑบ          ณTES informada                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function RCTB10_G(cTES,cCliente,cLoja,cProduto,nTotal,lValid,nLinha,nTpGetD)
Local aRetorno 	:= Array(21)
Local nPosImp1	:= 0
Local nPosImp2	:= 0
Local nPosImp3	:= 0
Local nPosImp4	:= 0
Local nPosImp5	:= 0
Local nPosImp6	:= 0
Local nPosImp7	:= 0
Local nPosImp8	:= 0
Local aHeadBkp	:= AClone( &("oGetDad"+AllTrim(Str(nTpGetD))+":aHeader") ) 
Local aImpostos	:= MaFisRelImp("MT100",{"SF2","SD2"})

Default nLinha	:= 0

If Empty(cTES) .Or. Empty(cCliente) .Or. Empty(cProduto) .Or. nTotal <= 0
	MsgAlert("Aten็ใo, os campos TES, Cliente, Produto e Valor da Parcela sใo obrigat๓rios. Verifique o preenchimento desses campos.")
	Return(Nil)
EndIf                           

dbSelectArea("SA1")
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+cCliente+cLoja))

dbSelectArea("SB1")
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+cProduto))

dbSelectArea("SF4")
SF4->(dbSetOrder(1))
SF4->(dbSeek(xFilial("SF4")+cTES))
                  
//Inicializa funcoes fiscais
MaFisIni(	SA1->A1_COD,;
			SA1->A1_LOJA,;
			"C",;
			"N",;
			SA1->A1_TIPO,;
			aImpostos,;
			,;
			,;
			"SB1",;
			"MATA461")

//MaFisSave()
//MaFisEnd()

MaFisIni(SA1->A1_COD,SA1->A1_LOJA,"C","N",SA1->A1_TIPO,Nil,Nil,Nil,Nil,"MATA461")
//MaFisIni(cCliente,cLoja,"C","N",SA1->A1_TIPO,Nil,Nil,Nil,Nil,"RCTBA010","") 
//MaFisIni(SA1->A1_COD,SA1->A1_LOJA,"C","N",SA1->A1_TIPO,aImpostos,,,"SB1","MATA461")

//Total Por Item
MaFisAdd(	SB1->B1_COD,;
			cTes,;
			1,;
			nTotal,;
			0,;
			"",;
			"",;
			0,;
			0,;
			0,;
			0,;
			0,;
			nTotal,;
			0,;
			0,;
			0 )  

//MaFisAdd(SB1->B1_COD,cTES,1,nTotal,0,"","",0,0,0,0,0,nTotal,0)
//MaFisAdd(SB1->B1_COD,cTES,1,nTotal,0,"","",0,0,0,0,0,nTotal,0,SB1->(RecNo()),SF4->(RecNo()))
//MaFisAdd(SB1->B1_COD,cTes,1,nTotal,0,"","",0,0,0,0,0,nTotal,0,0,0 )

//MaFisWrite(1)

//Retorno com impostos calculados
aRetorno[BASE_ICMS]			:= MaFisRet(1,"IT_BASEICM")
aRetorno[ALIQUOTA_ICMS]		:= MaFisRet(1,"IT_ALIQICM")
aRetorno[VALOR_ICMS]		:= MaFisRet(1,"IT_VALICM")
aRetorno[BASE_IPI]			:= MaFisRet(1,"IT_BASEIPI")
aRetorno[ALIQUOTA_IPI]		:= MaFisRet(1,"IT_ALIQIPI")
aRetorno[VALOR_IPI]			:= MaFisRet(1,"IT_VALIPI")
aRetorno[BASE_ISS]			:= MaFisRet(1,"IT_BASEISS")
aRetorno[ALIQUOTA_ISS]		:= MaFisRet(1,"IT_ALIQISS")
aRetorno[VALOR_ISS]			:= MaFisRet(1,"IT_VALISS")
aRetorno[BASE_IR]			:= MaFisRet(1,"IT_BASEIRR")
aRetorno[ALIQUOTA_IR]		:= MaFisRet(1,"IT_ALIQIRR")
aRetorno[VALOR_IR]			:= MaFisRet(1,"IT_VALIRR")
aRetorno[BASE_INSS]			:= MaFisRet(1,"IT_BASEINS")
aRetorno[ALIQUOTA_INSS]		:= MaFisRet(1,"IT_ALIQINS")
aRetorno[VALOR_INSS]		:= MaFisRet(1,"IT_VALINS")
aRetorno[BASE_COFINS]		:= MaFisRet(1,"IT_BASECOF")
aRetorno[ALIQUOTA_COFINS]	:= MaFisRet(1,"IT_ALIQCOF")
aRetorno[VALOR_COFINS]		:= MaFisRet(1,"IT_VALCOF")
aRetorno[BASE_CSLL]			:= MaFisRet(1,"IT_BASECSL")
aRetorno[ALIQUOTA_CSLL]		:= MaFisRet(1,"IT_ALIQCSL")
aRetorno[VALOR_CSLL]		:= MaFisRet(1,"IT_VALCSL")
aRetorno[BASE_PIS]			:= MaFisRet(1,"IT_BASEPIS")
aRetorno[ALIQUOTA_PIS]		:= MaFisRet(1,"IT_ALIQPIS")
aRetorno[VALOR_PIS]			:= MaFisRet(1,"IT_VALPIS")
     
//Atualiza os impostos
If nLinha > 0   
	nPosImp1 := AScan(aHeadBkp,{|x| AllTrim(x[2]) == "ZZ"+AllTrim(Str(nTpGetD))+"_ICMS" 	})
	nPosImp2 := AScan(aHeadBkp,{|x| AllTrim(x[2]) == "ZZ"+AllTrim(Str(nTpGetD))+"_IPI" 	})
	nPosImp3 := AScan(aHeadBkp,{|x| AllTrim(x[2]) == "ZZ"+AllTrim(Str(nTpGetD))+"_ISS"	})
	nPosImp4 := AScan(aHeadBkp,{|x| AllTrim(x[2]) == "ZZ"+AllTrim(Str(nTpGetD))+"_IR" 	})
	nPosImp5 := AScan(aHeadBkp,{|x| AllTrim(x[2]) == "ZZ"+AllTrim(Str(nTpGetD))+"_INSS" 	})	
	nPosImp6 := AScan(aHeadBkp,{|x| AllTrim(x[2]) == "ZZ"+AllTrim(Str(nTpGetD))+"_COFINS"	})	
	nPosImp7 := AScan(aHeadBkp,{|x| AllTrim(x[2]) == "ZZ"+AllTrim(Str(nTpGetD))+"_CSLL"	})	
	nPosImp8 := AScan(aHeadBkp,{|x| AllTrim(x[2]) == "ZZ"+AllTrim(Str(nTpGetD))+"_PIS"	})	
	
	//Atualiza os Impostos no aCols
	&("oGetDad"+AllTrim(Str(nTpGetD))+":aCols["+AllTrim(Str(nLinha))+","+AllTrim(Str(nPosImp1))+"]" ) := aRetorno[VALOR_ICMS]
	&("oGetDad"+AllTrim(Str(nTpGetD))+":aCols["+AllTrim(Str(nLinha))+","+AllTrim(Str(nPosImp2))+"]" ) := aRetorno[VALOR_IPI]
	&("oGetDad"+AllTrim(Str(nTpGetD))+":aCols["+AllTrim(Str(nLinha))+","+AllTrim(Str(nPosImp3))+"]" ) := aRetorno[VALOR_ISS]
	&("oGetDad"+AllTrim(Str(nTpGetD))+":aCols["+AllTrim(Str(nLinha))+","+AllTrim(Str(nPosImp4))+"]" ) := aRetorno[VALOR_IR]
	&("oGetDad"+AllTrim(Str(nTpGetD))+":aCols["+AllTrim(Str(nLinha))+","+AllTrim(Str(nPosImp5))+"]" ) := aRetorno[VALOR_INSS]
	&("oGetDad"+AllTrim(Str(nTpGetD))+":aCols["+AllTrim(Str(nLinha))+","+AllTrim(Str(nPosImp6))+"]" ) := aRetorno[VALOR_COFINS]
	&("oGetDad"+AllTrim(Str(nTpGetD))+":aCols["+AllTrim(Str(nLinha))+","+AllTrim(Str(nPosImp7))+"]" ) := aRetorno[VALOR_CSLL]
	&("oGetDad"+AllTrim(Str(nTpGetD))+":aCols["+AllTrim(Str(nLinha))+","+AllTrim(Str(nPosImp8))+"]" ) := aRetorno[VALOR_PIS]
	&("oGetDad"+AllTrim(Str(nTpGetD))):Refresh()
EndIf

MaFisEnd()

Return(aRetorno)
*/          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB10_H บAutor  ณBruno Daniel Borges บ Data ณ  29/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do campo VALOR da parcela de apropria-  บฑฑ
ฑฑบ          ณcao para recalculo dos impostos                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB10_H()
//Local nTotal	 := M->ZZ1_VALOR

//RCTB10_G(M->ZZ0_TES,M->ZZ0_CLIENT,M->ZZ0_LOJA,M->ZZ0_PRODUT,nTotal,.F.,oGetDad1:nAt,1)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCTB10_I บAutor  ณBruno Daniel Borges บ Data ณ  29/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do campo VALOR da parcela de apropria-  บฑฑ
ฑฑบ          ณcao para recalculo dos impostos                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB10_I()

/*If M->ZZ0_DATA1 > oGetDad1:aCols[oGetDad1:nAt,AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) = "ZZ1_DATA" })] //M->ZZ1_DATA //
	MsgAlert("Aten็ใo, a data da inicio desse contrato ้ maior do que a data de apropria็ใo")
	Return(.F.)
EndIf  */

//RCTB10_G(M->ZZ0_TES,M->ZZ0_CLIENT,M->ZZ0_LOJA,M->ZZ0_PRODUT,nTotal,.F.,oGetDad1:nAt,1)

Return(.T.)           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBA010  บAutor  ณFernando Fonseca    บ Data ณ  06/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para Realizar a Aprovacao do Contrato               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTB10_J()
	Local lRet		 := .F.
	Local nOpc		 := Aviso("Aprova็ใo de Contratos","Selecione abaixo o botใo que indique a a็ใo a ser tomada com esse item do contrato", {"Aprovar", "Rejeitar", "Cancelar"})
	
	// Operacoes sobre o Contrato.
	Do Case
		Case nOpc == 1 // Aprovar
			If ZZ0->ZZ0_STATUS == "1"
    		    If MsgYesNo("Confirma Aprova็ใo do Contrato ?")             	
			    	ZZ0->(RecLock("ZZ0",.F.))
					ZZ0->ZZ0_STATUS	:= "3" 
					ZZ0->(MsUnlock())
				EndIf
			Else
				MsgAlert("Aten็ใo, Somente os Contratos com STATUS -Aguardando Aprova็ใo pelo Gestor, poderใo ser aprovados!")	
		    EndIf

		Case nOpc == 2 // Rejeitar     
	    	If ZZ0->ZZ0_STATUS == "1"
				RejeitaContrato()   
			Else
				MsgAlert( "Aten็ใo! Somente os Contratos com STATUS -Aguardando Aprova็ใo pelo Gestor, poderใo ser rejeitados!")
			EndIf	
		
		Case nOpc == 3 // Cancelar
			Return(lRet)
	EndCase

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRejeitaContratoบAutorณFernando Fonseca    บ Data ณ  09/06/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para digitacao do Motivo de rejeicao de um contrato.      บฑฑ
ฑฑบ          ณ                                                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RejeitaContrato(lVisualiza)
Local 	oDlgMain		:= Nil  
Local 	aCoordenadas	:= MsAdvSize() 
Local 	nOpc 			:= 0
Local   i  	            := 0
Local   cTexto			:= ""

Default lVisualiza 		:= .F.

If !lVisualiza
	If !MsgYesNo("Confirma Rejei็ใo?")
		Return(Nil)
	EndIf	

	oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6]/1.8,aCoordenadas[5]/1.9,OemToAnsi("Motivo da Rejei็ใo do Contrato"),,,,,,,,oMainWnd,.T.)
		TSay():New(005,005,{|| OemToAnsi("Abaixo as justificativas (motivo) informado pelo Aprovador na Rejei็ใo do Contrato.")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
		TMultiGet():New(020,005, bSETGET(cTexto),oDlgMain,oDlgMain:nClientWidth/2-15,oDlgMain:nClientHeight/2-60,,.F.,,,,.T.)
		TButton():New(oDlgMain:nClientHeight/2-30, 005, OemToAnsi("&Gravar"), oDlgMain, {|| oDlgMain:End(), nOpc := 1 }, 025, 010,,,, .T.,,,, {||} )
	oDlgMain:Activate(,,,.T.)

	If nOpc == 1
		ZZ0->(RecLock("ZZ0",.F.))
			// Altera o STATUS para - Contrato Rejeitado pelo Gestor
			ZZ0->ZZ0_STATUS	:= "2" 
			// Grava a Justificativa para Rejeicao(Campo Memo)
			MSMM( ZZ0->ZZ0_CODREJ, TamSX3("ZZ0_MEMREJ")[1],, cTexto, 1,,, "ZZ0", "ZZ0_CODREJ" )
		ZZ0->(MsUnlock())
	EndIf      
	
Else	
	// Somente desenha a Tela.
	cTexto 		:= MSMM(ZZ0->ZZ0_CODREJ,,,,3)
	oDlgMain 	:= TDialog():New(aCoordenadas[7],000,aCoordenadas[6]/1.8,aCoordenadas[5]/1.9,OemToAnsi("Motivo da Rejei็ใo do Contrato"),,,,,,,,oMainWnd,.T.)
		TSay():New(005,005,{|| OemToAnsi("Abaixo as justificativas (motivo) informado pelo Aprovador na Rejei็ใo do Contrato.")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
		TMultiGet():New(020,005, bSETGET(cTexto),oDlgMain,oDlgMain:nClientWidth/2-15,oDlgMain:nClientHeight/2-60,,.F.,,,,.T.  , ,  , {||}, , , .T. )
		TButton():New(oDlgMain:nClientHeight/2-30, 005, OemToAnsi("&Ok"), oDlgMain, {|| oDlgMain:End()}, 025, 010,,,, .T.,,,, {||} )
	oDlgMain:Activate(,,,.T.)
EndIf
Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTPOPUP  บAutor  ณFernando Fonseca    บ Data ณ  06/17/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamada de Menu PopUp                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTPOPUP()
Local nTipoCarta := 0


PutSx1("CTRCTB","01","Tipo Relatorio","Tipo Relatorio","Tipo Relatorio","mv_ch1","N",1,0,2,"C","","","","","mv_par01","Carta Acordo","Carta Acordo","Carta Acordo","","Briefing","Briefing","Briefing","","","","","","","","","",{},{},{})

If !Pergunte("CTRCTB",.T.)
	Return(Nil)
EndIf      

If mv_par01 == 1 //Carta Acordo 
	If ZZ0->ZZ0_TPCONT $ '1|3' //Comercial
		U_RCTBA070(.T.)
	ElseIf ZZ0->ZZ0_TPCONT $ '2|3' //Eventos
		//Avalia se sera impresso uma unica carta acordo por produto ou uma carta acordo para o contrato inteiro
		nTipoCarta := Aviso("Tipo de Carta Acordo","Selecione o botใo com o modelo de carta acordo a ser impresso.", {"Mod. Normal","Bebidas"})
		Processa({|| Carta_Eventos(nTipoCarta)})
	EndIf
ElseIf mv_par01 == 2 //Briefing
	U_RCTBA080()
Endif

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarta_EventosบAutor  ณBruno Daniel Borges บ Data ณ  12/08/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao das carta acordos do Comercial                       บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Carta_Eventos(nTipoCarta)
Local aAreaBKP   := GetArea()
Local nVlrTotal  := 0
Local cObjeto    := ""    
Local cServicos  := ""
Local cValores   := ""
Local cModelo1   := ""
Local aMeses     := {"Janeiro","Fevereiro","Mar็o","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Local oWord      := Nil                
Local i               

If nTipoCarta == 1
	cModelo1 := "carta_acordo_" + cEmpAnt + "_" + cFilAnt + ".dot"  
Else
	cModelo1 := "carta_acordo_bebidas_" + cEmpAnt + "_" + cFilAnt + ".dot"  
EndIf
                        
MontaDir("C:\TEMP")
CpyS2T(cModelo1,"C:\TEMP",.F.)
oWord := OLE_CreateLink("TMSOLEWORD97")
OLE_NewFile(oWord,"C:\TEMP\"+cModelo1 )
OLE_SetProperty(oWord, oleWdVisible, .T. )  
OLE_SetProperty(oWord, oleWdWindowState,"MAX" )

//Posiciona nas tabelas envolvidas
dbSelectArea("SA1")
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+ZZ0->ZZ0_CLIENT+ZZ0->ZZ0_LOJA  ))

//Campos do Cabecalho
OLE_SetDocumentVar(oWord,"cCabecalhoImp"	,AllTrim(Capital(SM0->M0_CIDCOB))+", " + AllTrim(Str(Day(dDataBase))) + " de " + aMeses[Month(dDataBase)] + " de " + SubStr(DToS(dDataBase),1,4)  )
OLE_SetDocumentVar(oWord,"cNomeCliente"		,AllTrim(Capital(SA1->A1_NOME)) )
OLE_SetDocumentVar(oWord,"cResponsavel"		,Capital(AllTrim(Iif(!Empty(ZZ0->ZZ0_RESPON),ZZ0->ZZ0_RESPON,SA1->A1_CONTATO )))  )
OLE_SetDocumentVar(oWord,"cCargo"			,AllTrim(Capital(ZZ0->ZZ0_CARGO)) )
OLE_SetDocumentVar(oWord,"cCPF"             ,Iif(!Empty(ZZ0->ZZ0_CPF),Transform(ZZ0->ZZ0_CPF,"@R 999.999.999-99"),""))
OLE_SetDocumentVar(oWord,"cTelefone"        ,AllTrim(SA1->A1_TEL))
OLE_SetDocumentVar(oWord,"cEmail"           ,AllTrim(Lower(SA1->A1_EMAIL)))

//Busca os dados dos itens do contrato
aObjeto := Ret_Objeto(ZZ0->ZZ0_CONTRA,@nVlrTotal)
For i := 1 To 3
	If Len(aObjeto) >= i .And. i <= 3
		OLE_SetDocumentVar(oWord,"cRef"+AllTrim(Str(i)),aObjeto[i,1])
		OLE_SetDocumentVar(oWord,"cObj"+AllTrim(Str(i)),aObjeto[i,2])
	Else
		OLE_SetDocumentVar(oWord,"cRef"+AllTrim(Str(i))," ")
		OLE_SetDocumentVar(oWord,"cObj"+AllTrim(Str(i))," ")
	EndIf
Next i   

//Dados das PARTES do contrato
OLE_SetDocumentVar(oWord,"cNomeEmpresa"		,Upper(AllTrim(SM0->M0_NOMECOM)))
OLE_SetDocumentVar(oWord,"cMunEmpresa"		,Capital(AllTrim(SM0->M0_CIDCOB)))
OLE_SetDocumentVar(oWord,"cEndEmpresa"		,Capital(AllTrim(SM0->M0_ENDCOB	)))
OLE_SetDocumentVar(oWord,"cCNPJEmpresa"		,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))
OLE_SetDocumentVar(oWord,"cIEEmpresa"		,AllTrim(SM0->M0_INSC))

OLE_SetDocumentVar(oWord,"cMunCliente"		,Upper(AllTrim(SA1->A1_MUN)))
OLE_SetDocumentVar(oWord,"cEndCliente"		,Capital(AllTrim(SA1->A1_END)))
OLE_SetDocumentVar(oWord,"cCNPJCliente"		,Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"))
OLE_SetDocumentVar(oWord,"cIECliente"		,AllTrim(SA1->A1_INSCR))

//Dados de Cobranca
OLE_SetDocumentVar(oWord,"cContatoCobranca"	,Capital(AllTrim(Iif(!Empty(ZZ0->ZZ0_CONTAT),ZZ0->ZZ0_CONTAT,Iif(!Empty(ZZ0->ZZ0_RESPON),ZZ0->ZZ0_RESPON,SA1->A1_CONTATO )))) )
OLE_SetDocumentVar(oWord,"cEmailCobranca"	,AllTrim(Lower(ZZ0->ZZ0_EMAIL)))
OLE_SetDocumentVar(oWord,"cTelCobranca"		,AllTrim(ZZ0->ZZ0_TEL))
OLE_SetDocumentVar(oWord,"cEndCobranca"		,Capital(AllTrim(ZZ0->ZZ0_END) + ", " + AllTrim(ZZ0->ZZ0_BAIRRO)+", " + AllTrim(ZZ0->ZZ0_MUN) + "-" + AllTrim(ZZ0->ZZ0_EST)) )

//Objeto do contrato
For i := 1 To Len(aObjeto)
	If !Empty(aObjeto[i,2])
		cObjeto += aObjeto[i,2]	 + Chr(13)
	EndIf
Next i                                           

If Empty(cObjeto)
	cObjeto := " "
EndIf             
OLE_SetDocumentVar(oWord,"cObjetoContrato"		,cObjeto)   

//Valor Total do Contrato
OLE_SetDocumentVar(oWord,"cValorTotal","R$ " + AllTrim(Transform(nVlrTotal,"@E 999,999,999.99")) + "(" + AllTrim(Capital(Extenso(nVlrTotal))) + ")")

//Carrega os servicos operacionais
dbSelectArea("ZZR")
ZZR->(dbSetOrder(1))
ZZR->(dbSeek(xFilial("ZZR")+ZZ0->ZZ0_CONTRA))
While ZZR->(!Eof()) .And. ZZR->ZZR_FILIAL + ZZR->ZZR_CONTRA == xFilial("ZZR")+ZZ0->ZZ0_CONTRA
	If !Empty(ZZR->ZZR_DESCRI)
		cServicos += AllTrim(Capital(ZZR->ZZR_DESCRI))
		If ZZR->ZZR_QUANT > 0
			cServicos += "(" + AllTrim(Str(ZZR->ZZR_QUANT)) + "),"
		EndIf
	EndIf                                              
	ZZR->(dbSkip())
EndDo
If !Empty(cServicos)
	cServicos := SubStr(cServicos,1,Len(cServicos)-1)
Else
	cServicos := " "
EndIf
OLE_SetDocumentVar(oWord,"cServicosInclusos"	,cServicos)

//Carrega os valores e suas formas de pagamento
dbSelectArea("ZZQ")
ZZQ->(dbSetOrder(1))
ZZQ->(dbSeek(xFilial("ZZQ")+ZZ0->ZZ0_CONTRA))
While ZZQ->(!Eof()) .And. ZZQ->ZZQ_FILIAL + ZZQ->ZZQ_CONTRA == xFilial("ZZQ")+ZZ0->ZZ0_CONTRA
	If !Empty(ZZQ->ZZQ_DESCRI)
		cValores += "R$ " + AllTrim(Transform(ZZQ->ZZQ_VALOR,"@E 999,999,999.99")) + "(" + AllTrim(Capital(Extenso(ZZQ->ZZQ_VALOR))) + ") " + Capital(AllTrim(ZZQ->ZZQ_DESCRI)) + Chr(13)
	EndIf                                              
	ZZQ->(dbSkip())
EndDo                                                      
OLE_SetDocumentVar(oWord,"cFormaPagto"	,cValores)

//Outros Custos
OLE_SetDocumentVar(oWord,"cOutrosCustos"	,StrTran(MSMM(ZZ0->ZZ0_CODOUT,,,,3),Chr(13)+Chr(10),Chr(3)))

OLE_UpdateFields(oWord)
OLE_SetProperty(oWord, oleWdVisible, .T.) 
OLE_SetProperty(oWord, oleWdWindowState,"MAX" )
OLE_SaveAsFile(oWord, "C:\TEMP\carta_acordo.doc",,,.F.,oleWdFormatDocument )
OLE_CloseLink(oWord,.F.)

CpyS2T(cModelo1,"C:\TEMP\",.T.)

RestArea(aAreaBKP)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRet_ObjetoบAutor  ณBruno Daniel Borges บ Data ณ  12/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o objeto dos itens do contrato                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ret_Objeto(cContrato,nVlrTotal)
Local aRetorno := {}
Local nRecnoBKP := ZZ0->(RecNo())

dbSelectArea("ZZ0")
ZZ0->(dbSetOrder(1))
ZZ0->(dbSeek(xFilial("ZZ0")+cContrato ))
While ZZ0->(!Eof()) .And. ZZ0->ZZ0_FILIAL + ZZ0->ZZ0_CONTRA == xFilial("ZZ0")+cContrato
	AAdd(aRetorno,{	Capital(AllTrim(Posicione("SB1",1,xFilial("SB1")+ZZ0->ZZ0_PRODUT,"SB1->B1_DESC"))),AllTrim(Msmm(ZZ0->ZZ0_CODOBJ)) })
	
	nVlrTotal += ZZ0->ZZ0_VALOR
	ZZ0->(dbSkip())
EndDo

ZZ0->(dbGoTo(nRecnoBKP))

Return(aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetMensagemบAutor  ณBruno Daniel Borges บ Data ณ  12/08/08   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna mensagem padrao para os campos do sistema            บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetMensagem()
Local cMensagem := ""
Local nCampo    := 0

cMensagem := ConPad1( ,,,"ZZS")

If cMensagem            
	nCampo := Aviso("Campo P/ Preechimento","Selecione o botใo que corresponda ao campo a ser preenchido com a mensagem selecionada", {"Out. Custos","Inf. Gerais","Objeto","Merchandis."})
	
	If nCampo == 1
		M->ZZ0_OUTCUS := AllTrim(ZZS->ZZS_MENSAG)
	ElseIf nCampo == 2
		M->ZZ0_INFGER := AllTrim(ZZS->ZZS_MENSAG)
	ElseIf nCampo == 3
		M->ZZ0_OBJETO := AllTrim(ZZS->ZZS_MENSAG)
	ElseIf nCampo == 4
		M->ZZ0_MERCHA := AllTrim(ZZS->ZZS_MENSAG)
	EndIf
EndIf

Return(Nil)
