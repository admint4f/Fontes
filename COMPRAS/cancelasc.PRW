#DEFINE oSSaldo    LoadBitmap( GetResources(), "BR_VERMELHO" )//Item SC Atendido
#DEFINE oCSaldo    LoadBitmap( GetResources(), "BR_VERDE"    )//Item SC nao Atendido
#DEFINE oPSaldo    LoadBitmap( GetResources(), "BR_AZUL"     )//Item SC parciamente Atendido
#DEFINE oESaldo    LoadBitmap( GetResources(), "BR_PRETO"    )//Item SC cancelado
#DEFINE oChecked   LoadBitmap( GetResources(), "CHECKED"     )//Item selecionado
#DEFINE oUnChecked LoadBitmap( GetResources(), "UNCHECKED"   )//Item nใo selecionado

#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "ap5mail.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCancelaSC บAutor  ณSergio Celestino    บ Data ณ  18/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para cancelamento das solicitacoes de compras          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณGilberto 26/10/10 : Funcao ExcluiAprovacao() Mudanca no     บฑฑ
ฑฑบ          ณmetodo de exclusao da aprovacao.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณTela para cancelamento das solicitacoes de compras          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CancelaSC(cNumSC)

Local oFolder	:= Nil
Local oFont
Local aCoorden	:= MsAdvSize(.T.)
Local nLin      := 0
Local cOpcao	:= ""
Local nOpc1 	:= 0,aVetor //Alterado por Perez em 26/3

Private lDelTudo := .F.
Private lDelParc := .F.
Private aListExp := {}
Private lFirst   := .T.
Private oDlgMain := Nil
Private oListExp := Nil

DbSelectArea("SC1")
DbSetOrder(1)
DbGotop()
DbSeek( xFilial("SC1") + cNumSC )


While !Eof() .And. SC1->C1_NUM == cNumSC
	
	IF SC1->C1_QUJE == 0 .And. Empty(C1_RESIDUO)
		lDelTudo := .T.
	Else
		lDelTudo := .F.
		lDelParc := .T.
	Endif
	
	
	aAdd(aListExp, {  IIF( SC1->C1_QUANT == SC1->C1_QUJE .And.  Empty(C1_RESIDUO), oSSaldo , ;
	IIF( SC1->C1_QUJE  < SC1->C1_QUANT .And.  SC1->C1_QUJE > 0 , oPSaldo , ;
	IIF( !Empty(C1_RESIDUO)                                     , oESaldo , oCSaldo ) ) ) ,;
	IIF(lDelTudo,lDelTudo,.F.)       ,;
	SC1->C1_NUM                      ,;
	SC1->C1_ITEM                     ,;
	SC1->C1_PRODUTO                  ,;
	SC1->C1_DESCRI                   ,;
	SC1->C1_QUANT                    ,;
	SC1->C1_VUNIT                    ,;
	SC1->C1_QUANT*SC1->C1_VUNIT      ,;
	SC1->C1_FORNECE+"-"+SC1->C1_LOJA ,;
	SC1->C1_DATPRF                   ,;
	SC1->(Recno())        })
	DbSelectArea("SC1")
	DbSkip()
End

If Len(aListExp) == 0
	aAdd(aListExp ,{" ",.F.," "," "," "," "," "," "," "," "," ",0} )
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define a fonte da consulta.                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFont NAME "ARIAL" SIZE 0,-12 BOLD

nLin := 15
//Desenha a interface
oDlgMain := TDialog():New(aCoorden[7]/2,000,aCoorden[6]/2+30,aCoorden[5]/2,OemToAnsi("Cancelamento de Solicita็ใo de Compras"),,,,,,,,oMainWnd,.T.)

@ 001+nLin,005 To 090+nLin,500 Of oDlgMain Pixel

@ 010+nLin,015 Say OemToAnsi("Informe os itens a cancelar") Size 080,008 Of oDlgMain Pixel  COLOR CLR_HRED FONT oFont


oFolder1 := TFolder():New(010,001,{"Informe os Itens a Cancelar"},,oDlgMain,,,,.T.,.T.,oDlgMain:nClientWidth/2+5,oDlgMain:nClientHeight/3.5)
@ 001,001 ListBox oListExp VAR cOpcao Fields ;
Header " "," ","Nr. SC","Item","Produto","Descricao","Qtde","Vlr. Unit","Vlr. Total","Fornec/Loja","Dt.Entrega" Size oFolder1:aDialogs[1]:nClientWidth/2-2,oFolder1:aDialogs[1]:nClientHeight/2-5 PIXEL OF oFolder1:aDialogs[1] ;
On dblClick ( CheckFirst(.F.) ,  oListExp:Refresh() )

oListExp:bHeaderClick	:= {|| CheckFirst(.T.)   , oListExp:Refresh() }
oListExp:lHScroll 	:= .T.
oListExp:lNoHScroll	:= .T.
oListExp:SetArray(aListExp)
oListExp:bLine := {||{    aListExp[oListExp:nAt][1],;   //Semaforo
IIf(aListExp[oListExp:nAt][02], oChecked  ,oUnChecked ),;
aListExp[oListExp:nAt][3],;  //Nr. da Solicitacao de compras
aListExp[oListExp:nAt][4],;  //Item
Alltrim( aListExp[oListExp:nAt][5]),; //Codigo do produto
Alltrim( aListExp[oListExp:nAt][6]),; //Descricao
aListExp[oListExp:nAt][7],;  //Qdte
aListExp[oListExp:nAt][8],;  //Valor Unitario
aListExp[oListExp:nAt][9],;  //Valor Total
aListExp[oListExp:nAt][10],; //Fornecedor+Loja
aListExp[oListExp:nAt][11]}} //Data de Entrega


@ oDlgMain:nClientWidth/6+4,005 BITMAP RESOURCE "BR_VERMELHO_OCEAN" NO BORDER SIZE 08,08 ADJUST OF oDlgMain PIXEL
@ oDlgMain:nClientWidth/6+4,015 SAY "Atendido"          OF oDlgMain PIXEL

@ oDlgMain:nClientWidth/6+4,080 BITMAP RESOURCE "BR_VERDE_OCEAN"    NO BORDER SIZE 08,08 ADJUST OF oDlgMain PIXEL
@ oDlgMain:nClientWidth/6+4,090 SAY "Nใo Atendido"       OF oDlgMain PIXEL

@ oDlgMain:nClientWidth/6+4,160 BITMAP RESOURCE "BR_AZUL_OCEAN"    NO BORDER SIZE 08,08 ADJUST OF oDlgMain PIXEL
@ oDlgMain:nClientWidth/6+4,170 SAY "Parcialmente Atendido"       OF oDlgMain PIXEL

@ oDlgMain:nClientWidth/6+4,240 BITMAP RESOURCE "BR_PRETO_OCEAN"    NO BORDER SIZE 08,08 ADJUST OF oDlgMain PIXEL
@ oDlgMain:nClientWidth/6+4,250 SAY "Cancelado"          OF oDlgMain PIXEL
//Alterado por Perez em 26/3
oDlgMain:Activate(EnchoiceBar(oDlgMain,{|| (nOpc1 := 1,aVetor := aClone(oListExp:aArray), oDlgMain:End()) },{|| oDlgMain:End() }),,,.T.)

If nOpc1 = 1
	CancSC1(aVetor,cNumSC)
EndIf
//Fim
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCheckFirstบAutor  ณSergio Celestino    บ Data ณ  18/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para marcar e desmarcar itens da SC para            บฑฑ
ฑฑบ          ณcancelamento                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CheckFirst(lClicker)

Local lRet := .T.

Do Case
	Case aListExp[oListExp:nAt][1]:CNAME == "BR_VERMELHO"
		lRet := .F.
		MsgInfo("Este item da SC ja se encontra atendido e nใo podera ser cancelado!")
		Return lRet
	Case aListExp[oListExp:nAt][1]:CNAME == "BR_AZUL"
		lRet := .F.
		MsgInfo("Este item da SC ja se encontra parcialmente atendido e nใo podera ser cancelado!")
		Return lRet
	Case aListExp[oListExp:nAt][1]:CNAME == "BR_PRETO"
		lRet := .F.
		MsgInfo("Este item da SC ja se encontra cancelado!")
		Return lRet
	Case !lDelParc
		lRet := .F.
		MsgInfo("Esta Solicita็ใo s๓ podera ser cancelada totalmente!")
		Return lRet
EndCase


If lRet .And. !lClicker
	aListExp[oListExp:nAt][2] := !aListExp[oListExp:nAt][2]  ; oListExp:Refresh()
Elseif lRet .And. lClicker
	AEval(aListExp,{|x| x[2] := IF(!x[1]:CNAME $ "BR_AZUL/BR_VERMELHO" ,!x[2],x[2])  } ) ; oListExp:Refresh()
Endif


Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCANCELASC บAutor  ณSergio Celestino    บ Data ณ  18/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza o cancelamento dos itens marcados                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CancSC1(aVetor,cNumSC)

Local _cSUBJECT:="[T4F-Suprimentos] Cancelamento de Solicita็ใo de compras "+cNumSC
Local lDel  := .F.
Local lCanc := .F.
Private __cSolicit

For nY := 1 To Len(aVetor)
	If aVetor[nY][2]
		lCanc:=.T.
	Endif
Next

If !lCanc
	Alert("Nใo Existem Itens a serem cancelados para esta Solicita็ใo de Compras.Verifique!!!")
	Return .F.
Else
	If MsgYesNo("Aten็ใo, voc๊ confirma o cancelamento dos itens selecionados da solicita็ใo de compras " + cNumSC + " ?")
		For nY := 1 To Len(aVetor)
			If aVetor[nY][2]
				
				PcoIniLan("000051")
				
				DbSelectArea("SC1")
				DbGoto(aVetor[nY][12])
				__cSolicit := SC1->C1_USER
				RecLock("SC1",.F.)
				SC1->C1_QUJE 	:= SC1->C1_QUANT
				SC1->C1_APROV	:= " "
				SC1->C1_RESIDUO	:= "S"
				MsUnlock()
				
				PcoDetLan("000051","01","RCOMA090",.t.)  // incluido por Rodney 08/09/08
				PcoFinLan("000051")
				lDel := .T.
			Endif
		Next

	
		If lDel

			// Gilberto - 26/10/2010
			ExcApr(cNumSC) // Exclui aprovacao.		
			
			PswOrder(1)
			IF PswSeek(__cSolicit, .T. )
				If PSWRET(1)[1][17]  //Caso o Usuario esteja bloqueado
					cDestEmail := GetMv("MV_XMAILRE",,"microsiga01@t4f.com.br")
				Else
					cDestEmail := PSWRET(1)[1][14]
				Endif
			Endif
				
			// Envia email informando ao solicitante que a solicitacao de compras foi cancelada.
			U_CRIAEMAIL(cDestEmail,_cSUBJECT,aVetor)
		Endif
		
	Endif
	
Endif


Return                
/**/
Static Function ExcApr(cNumSC)

Local aGetArea:= GetArea()
Local aGetSC1:= SC1->( GetArea() )
Local lDelAprov:= .t.

DbSelectArea("SC1")
SC1->( DbSetOrder(1) )
SC1->( DbSeek( xFilial("SC1") + cNumSC ) )

While SC1->( !Eof() ) .And. ( SC1->C1_NUM == cNumSC )
	If SC1->C1_QUJE == 0 .And. Empty(SC1->C1_RESIDUO)
	   lDelAprov:= .f.		
	EndIF
	SC1->( dbSkip() )
End-While

If ( lDelAprov )
	
	//Exclui a alcada gerada
	dbSelectArea("ZZ6")
	ZZ6->(dbSetOrder(1))
	ZZ6->(dbSeek(xFilial("ZZ6")+cNumSC))
	While ZZ6->(!Eof()) .And. ZZ6->ZZ6_FILIAL + ZZ6->ZZ6_SC == xFilial("ZZ6")+cNumSC
		ZZ6->(RecLock("ZZ6",.F.))
		ZZ6->(dbDelete())
		ZZ6->(MsUnlock())
		ZZ6->(dbSkip())
	EndDo
	
	MsgAlert("Solicita็ใo de compras cancelada. Todo o processo de aprova็ใo foi excluํdo.")
	
Endif

RestArea(aGetSC1)
RestArea(aGetArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCRIAEMAIL บ Autor ณ AP6 IDE            บ Data ณ  18/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CRIAEMAIL(cDestEmail,_cSUBJECT,aVetor)

Local nO := 0, _aFiles:=array(1)
Local oDlg_eMail
Private cTxtEmail := space(10)
DEFAULT cDestEmail:= Space(40)
DEFAULT _cSUBJECT:= Space(40)

@ 090,042 TO 362,500 DIALOG oDlg_eMail TITLE _cSUBJECT
@ 008,070 say "Digite o texto do email a ser enviado:"
@ 018,010 get cTxtEmail SIZE 210,070 MEMO
@ 097,010 say "Email: "
@ 096,025 get cDestEmail SIZE 196,008 valid val_email(cDestEmail)
//Alterado por Perez em 26/3
@ 115,150 BMPBUTTON TYPE 1 ACTION (nO := 2 , oDlg_eMail:End())
@ 115,190 BMPBUTTON TYPE 2 ACTION (nO := 1 , oDlg_eMail:End())
ACTIVATE DIALOG oDlg_eMail CENTERED

Do Case
Case nO == 1
	If Valtype(aVetor) <> "U"
		For nY := 1 To Len(aVetor)
			If aVetor[nY][2] .And. SC1->(FieldPos("C1_EMAIL")) > 0
				DbSelectArea("SC1")
				DbGoto(aVetor[nY][12])
				Reclock("SC1",.F.)
				SC1->C1_EMAIL := "N"
				MsUnlock()
			Endif
		Next
	Endif
Case nO = 2
	U_EnvEmail(cDestEmail,_cSUBJECT,cTxtEmail,_aFiles,.F.)
EndCase
//Fim
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVAL_EMAIL บ Autor ณ AP6 IDE            บ Data ณ  30/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico T4F                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static function Val_Email(cEndEmail)

if at("@",cEndEmail) < 1
	msgbox("O endereco de email digitado nao ้ valido."+chr(13)+;
	"Verifique e informe novamente.","Atencao","ERROR")
	return .f.
else
	return .t.
endif

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณENVEMAIL  บ Autor ณ AP6 IDE            บ Data ณ  30/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico T4F                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User function EnvEmail(_cReceb,_cSUBJECT,_cMensagem,_aFiles,_lWrkFlw)

Local cServer   := GetMv('MV_RELSERV')
Local cAccount  := GetMv('MV_RELACNT')  // "protheus@t4f.com.br"
Local cEnvia    := GetMv('MV_RELACNT')  // "protheus@t4f.com.br"
Local lRelAuth  := GetMv('MV_RELAUTH')  // .T.
Local cPassword := Alltrim(GetMv('MV_RELAPSW'))	// "p10p10"				// Senho da conta de eMail
//Local cRecebe   := iif( _cReceb == NIL, 'microsiga01@t4f.com.br', _cReceb )
Local cRecebe   := iif( _cReceb == NIL, 'mgusmao@totalitsolutions.com.br', _cReceb )
Local _aFiles    := iif( _aFiles == NIL, ' ', _aFiles )
Local cMensagem := iif( _cMensagem == NIL, ' ', _cMensagem )
Local _lWrkFlw  := iif( _lWrkFlw == NIL, .f., _lWrkFlw )
Local SUBJECT   := iif( Empty(_cSUBJECT),'[T4F Suprimentos] - Mensagem',_cSUBJECT ) // Arlete 19/08/04
Local lNotAutent   := .t.
Local nI        := 1                            
                              
cAlerta:= '<FONT FACE="Arial" SIZE="1" COLOR="#FF0000">Mensagem automatica enviada pelo sistema Microsiga. Favor nใo responder.</FONT>'+chr(13)+chr(10)

cMensagem:= cAlerta + chr(13)+chr(10)+chr(13)+chr(10)+ cMensagem



CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou

If lConectou

	If lRelAuth 
		If ( lNotAutent:= !MailAuth(cAccount,cPassword) )
		   MSGINFO("Falha na Autentica็ใo do Usuแrio") 
           DISCONNECT SMTP SERVER RESULT lDisConectou
        EndIf
	EndIf	            
	
EndIf

If !_lWrkFlw .and. !lNotAutent

	SEND MAIL FROM cEnvia;
	TO cRecebe;
	SUBJECT IIF(Empty(_cSUBJECT),'[T4F Suprimentos] - mensagem',_cSUBJECT) ;
	BODY cMensagem;
	RESULT lEnviado
Else
	SEND MAIL FROM cEnvia;
	TO cRecebe;
	SUBJECT IIF(Empty(_cSUBJECT),'[T4F Suprimentos] - mensagem',_cSUBJECT) ;
	BODY cMensagem;
	RESULT lEnviado
EndIf

If !_lWrkFlw
	If !lEnviado
		cMensagem := ' '
		GET MAIL ERROR cMensagem
		APMsgInfo(cMensagem)
	Else
		APMsgInfo("Mensagem enviada.")
	Endif
Else
	If !lEnviado
		WFLog(1,cMensagem)
	EndIf
EndIf

DISCONNECT SMTP SERVER Result lDisConectou

return(lEnviado)