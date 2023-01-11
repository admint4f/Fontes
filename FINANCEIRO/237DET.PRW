#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Geraldo Sabino      º Data ³  17/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Dados do imposto para detalhamento no CNAB - GPS          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function 237Det()                         

IF !EMPTY(SE2->E2_RETINS)   // GPS - 135 - 140
_cTexto := SUBSTR(DTOS(SE2->E2_DTAPUR),5,2)+SUBSTR(DTOS(SE2->E2_DTAPUR),1,4)
//_cTexto += STRZERO(INT(SE2->E2_SALDO*100),15)
_cTexto += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC)*100,15)
_cTexto += STRZERO(INT(0*100),15)
_cTexto += STRZERO(INT(0*100),15)
_cTexto += SPAC(45)             
Else                       // DARF 135 - 142
_cTexto := SUBSTR(DTOS(SE2->E2_DTAPUR),7,2)+SUBSTR(DTOS(SE2->E2_DTAPUR),5,2)+SUBSTR(DTOS(SE2->E2_DTAPUR),1,4)
_cTexto += STRZERO(VAL(SE2->E2_NROREF),17)                          
_cTexto += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC)*100,15)
_cTexto += STRZERO(INT(0*100),15)
_cTexto += STRZERO(INT(0*100),15)
_cTexto += SUBSTR(DTOS(SE2->E2_VENCREA),7,2)+SUBSTR(DTOS(SE2->E2_VENCREA),5,2)+SUBSTR(DTOS(SE2->E2_VENCREA),1,4)
_cTexto += SPAC(18)             
Endif

Return _cTexto                     


