#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    MT094FIL   บ Autor ณ Luiz Eduardo       บ Data ณ  24/08/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descrio ณ Filtrar para nใo aparecer podidos com tipo ZZ			  บฑฑ
ฑฑบ           ณ                                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*----------------------------------------*
User Function MT094end()
*----------------------------------------* 
//USER FUNCTION MT094FIL() 

    LOCAL cRet := ""
    cRet :=  "  CR_TIPO  <> 'ZZ' "
	DbSelectArea("ZZE")
	DbSetOrder(2)
	ZZE->( DbSeek(xFilial("ZZE")+sc7->c7_num) )
	DbSelectArea("SC7")
	DbSetOrder(1)
	SC7->( DbSeek(xFilial("SC7")+trim(scr->cr_num)) )
	
	If (SC7->C7_XSOLPA = '2' .And. SC7->C7_XVALPA > 0 .And. !(Empty(SC7->C7_XVENPA)) ) .and. ZZE->ZZE_PEDIDO<>sc7->c7_num
		U_T4COMC01(SC7->C7_XVALPA,SC7->C7_XVENPA) //Chama a fun็ใo de gera็ใo da solicita็ใo de PA (ZZE).
	EndIf

RETURN (cRet)

