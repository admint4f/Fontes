#INCLUDE "PROTHEUS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} A140EXC
Ponto de entrada tem por objetivo validar a exclusão de uma pre-nota.

@author		TOTALIT Solutions - Jair Ribeiro
@since		15/01/2014
@version	P11
@obs		PE IMPORT XML
/*/      
//-------------------------------------------------------------------
User Function A140EXC()

Local aArea		:= GetArea()
Local lRet		:= .T. 

lRet := U__xFunA140EXC()

RestArea(aArea)
Return lRet