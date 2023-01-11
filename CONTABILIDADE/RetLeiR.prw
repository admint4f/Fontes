#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RETLEIR   ºAutor  ³Gilberto            º Data ³  10/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para contabilizacao dos gastos com a Lei Rouanet            º±±
±±º          ³Lancamentos Padroes de Entrada (650,651,etc..)              º±±
±±º          ³Configurado juntamente com Anderson e Reginaldo.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para T4F                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RetLeiR()

Local aArea:= GetArea()
Local cElemPepe:= '' 
Local cCtaLeiRouanet:= ''
Local cCtaEscape:= SuperGetMv("T4F_CTAESC",,"217021004")
// 
cElemPepe:=SD1->D1_ITEMCTA   
If Empty(cElemPepe)
	cCtaLeiRouanet:=cCtaEscape
Else	
	cCtaLeiRouanet:= Posicione("CTD",1,xFilial("CTD")+cElemPepe,"CTD_T4LROU")
	If Empty(cCtaLeiRouanet)                 
	   // Atencao:
	   // A conta abaixo eh a conta de "escape" definida pelo usuario chave Anderson.
	   // Caso nao encontre a conta da Lei Rouanet entao utiliza a conta abaixo.
		cCtaLeiRouanet:=cCtaEscape
	EndIf
EndIf
//Restaura area anterior.
RestArea( aArea )
Return( cCtaLeiRouanet )  