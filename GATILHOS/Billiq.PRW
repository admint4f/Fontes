/**************************************************************************************
.Programa  : TotArt
.Autor     : Marcos Justo
.Data      : 19/04/04
.Descricao : Gatilho disparo total participação do artista                           
.                                                                                 
**************************************************************************************/
User Function Billiq()

_TOTBIL := M->ZL_TOTBIL
_PORCART := M->ZL_PORCART
_PARTCOD := M->ZL_PARTCOD

_TXECAD := M->ZL_TXECAD
_TXISS  := M->ZL_TXISS
_TXPIS  := M->ZL_TXPIS
_TXCC   := M->ZL_TXCC
_PORCCC := M->ZL_PORCCC
_SOM    := M->ZL_SOM
_LUZ    := M->ZL_LUZ
_NUMAPRE:= M->ZL_NUMAPRE
_TXOCUPA:= M->ZL_TXOCUPA

_BILESTI := (_TOTBIL*_NUMAPRE)*(_TXOCUPA/100)
_TOTECAD := (_BILESTI*(_TXECAD/100))
_TOTISS  := (_BILESTI*(_TXISS/100))
_TOTPIS  := (_BILESTI*(1-(_PORCART/100))*(_TXPIS/100)) 
_TOTCC   := ((_BILESTI*(_PORCCC/100))*(_TXCC/100))

_TOTBI := (_BILESTI-_TOTECAD-_TOTISS-_TOTPIS-_TOTCC-M->ZL_ONEGOCI)

Return(_TOTBI)

