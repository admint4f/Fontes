#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MT120ISC ³ Autor ³ TOTVS                  ³ Data ³ 28/11/06   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava campos da Solicitacao de Compras no PC                  ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120ISC()
Local nPosCta 	:= aScan( aHeader,{|x| Alltrim(x[2]) == "C7_CONTA"})
Local nPosItCta := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_ITEMCTA"})
Local nPosClVl  := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_CLVL"})
Local nPosCCus  := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_CC"}) 
Local nPosLRou  := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_T4FLROU"}) 
Local nPosMailF := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_XMAILF"}) 
Local nPosObs  	:= aScan( aHeader,{|x| Alltrim(x[2]) == "C7_OBS"}) 
Local nPosCCusA := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_XCCAPR"})
Local nPosSolic := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_SOLICIT"})
If nTipoPed == 1 // Pedido de Compra

	aCols[n][nPosCta]  := SC1->C1_CONTA
	aCols[n][nPosItCta]:= SC1->C1_ITEMCTA
	aCols[n][nPosClVl] := SC1->C1_CLVL
	aCols[n][nPosCCus] := SC1->C1_CC 
	aCols[n][nPosLRou] := SC1->C1_T4FLROU
//	aCols[n][nPosMailF]:= SC1->C1_XMAILF 
	aCols[n][nPosObs]  := SC1->C1_OBS 
	aCols[n][nPosCCusA]:= SC1->C1_CC  
	aCols[n][nPosSolic]:= SC1->C1_SOLICIT	    
	/*
	If Empty(aCols[n][nPosMailF])
		aCols[n][nPosMailF] := Posicione("SA2",1,xFilial("SA2")+ca120Forn+ca120Loj, "A2_EMAIL")
	EndIf
	
/*
	_cGeraPA  		:= SC1->C1_XSOLPA
	_nValPA			:= SC1->C1_XVALPA
	_dVencPA		:= SC1->C1_XVENPA
	_cObsAprov		:= SC1->C1_XOBSAPR
	_cObsForn   	:= SC1->C1_XOBSFO
					

falta:
"	Tabela SZ2 - Rateio Solic.Compras (Customização existente)
*/

EndIf           

Return()