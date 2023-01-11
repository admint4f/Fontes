#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RETLEIR   ºAutor  ³Gilberto A.Oliveira º Data ³  10/05/10   º±±
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

User Function LeiRouanet()
Local aSC1Area:= SC1->(GetArea())
Local aSC7Area:= SC6->(GetArea())
Local aArea:= GetArea()
Local cNumSc:= '' 
Local cLeiRouanet:= ''
Local lReturn:= .f.

// Observacao: Essa rotina foi desenvolvida partindo da premissa de que solicitacoes referente a Lei Rouanet contem apenas itens 
// da lei rouanet, assim como os pedidos contem apenas solicitacoes da lei rouanet e o mesmo com as Notas Fiscais de Entrada.
// Essa definicao foi passada pelo usuario chave Anderson e confirmada pelo usuario responsavel Reginaldo (contabilidade).
cNumSc := Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO,"C7_NUMSC")

// Quando nao encontrar o pedido na Filial corrente, procura na filial de entrega.
If Empty(cNumsc)      
	// C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM
	cNumSc:= Posicione("SC7",6,xFilial("SC7")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_PEDIDO,"C7_NUMSC")
EndIf

cLeiRouanet:= Posicione("SC1",1,xFilial("SC1")+cNumSc,"C1_T4FLROU")

If cLeiRouanet == "1"
   lReturn:= .t.
EndIf               

// Restaura area.
RestArea( aSC1Area )
RestArea( aSC7Area )
RestArea( aArea )
Return( lReturn )  
