#include "protheus.ch"
User Function FA080BTN()
Local aButtons:= {}
Aadd(aButtons, {'CRITICA',{|| U_VARMONET()},OemToAnsi("Informe uma Nova Variacao Monetaria"),"Variacao"} )
Return(aButtons)