#include "protheus.ch"

User Function TestaSaldo()
Local nSaldo


DbSelectArea("SE1")
DbSetOrder(1)
DbGoto(18453)

nSaldo	:= SE1->E1_SALDO
nSaldo	-= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
nSaldo	-= SE1->E1_DECRESC
nSaldo	+= SE1->E1_ACRESC

ApMsgStop("Valor: "+transform(nsaldo, "@e 999,999,999.99") )
Return(Nil)

