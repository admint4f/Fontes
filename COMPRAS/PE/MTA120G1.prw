#include "protheus.ch"

// Ponto de Entrada no inicio da funcao de manutencao do pedido de compra.
// Utilizado aqui com objetivo de guardar os dados de codigo e loja do fornecedor e recuperar depois
// na user function MT120F
User Function MTA120G1

Local aArea:= GetArea()
Local aSc7Area:= SC7->(GetArea())
Local cNumSc7:= SC7->C7_NUM
Public __xSolic:= {}

DbSelectArea("SC7")
SC7->( DbSetOrder(1) )
If SC7->( DbSeek(xfilial("SC7")+ cNumSc7 ) )
	While SC7->( !Eof() ) .And. ( SC7->C7_NUM == cNumSc7 )
		If !Empty(SC7->C7_NUMSC)
			aAdd( __xSolic , { SC7->C7_NUM,SC7->C7_ITEM,SC7->C7_NUMSC, SC7->C7_ITEMSC, SC7->C7_FORNECE, SC7->C7_LOJA } )
		EndIf
		SC7->( !DbSkip() )
	End-While
EndIf

RestArea(aSc7Area)
RestArea(aArea)
Return(Nil)