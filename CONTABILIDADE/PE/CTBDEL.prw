#include "protheus.ch"
/*User Function CTBDEL 
Local lMod:= PARAIXB
Local lRet:= .f.
      
ApMsgStop("Parada !")

Return(lRet)
*/

USER FUNCTION CTBDEL()

LOCAL nOpc 		:= PARAMIXB[1]
LOCAL cProg 	:= PARAMIXB[2]
LOCAL cFunName 	:= PARAMIXB[3]
LOCAL cMensagem := "Não é permitido a exclusão da linha (deleção)!  Por favor, estorne a exclusão!!!"

LOCAL cEOL		:= CHR(10)+CHR(13)
cMensagem := "PONTO DE ENTRADA: CTBDEL"+cEOL
cMensagem += "nOpc 		--> "+STR(nOpc)+cEOL
cMensagem += "cProg 	--> "+cProg+cEOL
cMensagem += "cFunName 	--> "+cFunName+cEOL
APMSGALERT(cMensagem)

RETURN