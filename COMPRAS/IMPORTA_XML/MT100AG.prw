#INCLUDE "PROTHEUS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} MT100AG
PONTO DE ENTRADA NO FINAL DA ROTINA DE DOC DE ENTRADA 

@author		TOTALIT Solutions - Andre R. Esteves
@since		16/07/2015
@version	P11
@obs		PE IMPORT XML
/*/      
//-------------------------------------------------------------------
User Function MT100AG()

Local _aArea  := GetArea()                          

U__xFunMT100AG() 

RestArea(_aArea)
Return