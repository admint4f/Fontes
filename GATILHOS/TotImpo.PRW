/**************************************************************************************
.Programa  : TotImpo
.Autor     : Marcos Justo
.Data      : 26/04/04
.Descricao : Gatilho disparo total dos impostos
.                                                                                 
**************************************************************************************/
User Function TotImpo()

_TOTBIL := M->ZL_TOTBIL
_PORCART := M->ZL_PORCART

_TXECAD := M->ZL_TXECAD
_TXISS  := M->ZL_TXISS
_TXPIS  := M->ZL_TXPIS
_NUMAPRE:= M->ZL_NUMAPRE
_TXOCUPA:= M->ZL_TXOCUPA

_BILESTI := (_TOTBIL*_NUMAPRE)*(_TXOCUPA/100)
_TOTECAD := (_BILESTI*(_TXECAD/100))
_TOTISS  := (_BILESTI*(_TXISS/100))
_TOTPIS  := (_BILESTI*(1-(_PORCART/100))*(_TXPIS/100)) 

_TOTIMPO := _TOTECAD+_TOTISS+_TOTPIS

Return(_TOTIMPO)

