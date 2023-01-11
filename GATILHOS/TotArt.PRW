/**************************************************************************************
.Programa  : TotArt
.Autor     : Marcos Justo
.Data      : 19/04/04
.Descricao : Gatilho disparo total participação do artista                           
.                                                                                 
**************************************************************************************/
User Function TotArt()
_TOTA := 0
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
_NEGART := M->ZL_ONEGOCI

_BILESTI := (_TOTBIL*_NUMAPRE)*(_TXOCUPA/100)
_TOTECAD := (_BILESTI*(_TXECAD/100))
_TOTISS  := (_BILESTI*(_TXISS/100))
_TOTPIS  := (_BILESTI*(1-(_PORCART/100))*(_TXPIS/100)) 
_TOTCC   := ((_BILESTI*(_PORCCC/100))*(_TXCC/100))

IF _PARTCOD == "01"
   _TOTA := ((_BILESTI*(_PORCART/100)))-_NEGART
ENDIF

IF _PARTCOD == "02"
   _TOTA := ((_BILESTI-_TOTECAD-_TOTISS)*(_PORCART/100))-_NEGART
ENDIF

IF _PARTCOD == "03"
   _TOTA := ((_BILESTI-_TOTCC)*(_PORCART/100))-_NEGART
ENDIF

IF _PARTCOD == "04"
   _TOTA := ((_BILESTI-_TOTCC-_TOTECAD-_TOTISS)*(_PORCART/100))-_NEGART
ENDIF

IF _PARTCOD == "05" 
   IF _SOM > 0 .OR. _LUZ > 0
   _TOTA := ((_BILESTI-_TOTECAD-_TOTISS-(_SOM*_NUMAPRE)-(_LUZ*_NUMAPRE))*(_PORCART/100))-_NEGART
   ELSE
   MSGALERT("Para esta opção - Informe o valor do Som ou da Luz")
   _TOTA := 0
   ENDIF
ENDIF    
                            
IF _PARTCOD == "06"
   IF _SOM > 0 .OR. _LUZ > 0
   _TOTA := ((_BILESTI-_TOTECAD-_TOTISS-_TOTCC-(_SOM*_NUMAPRE)-(_LUZ*_NUMAPRE))*(_PORCART/100))-_NEGART
   ELSE
   MSGALERT("Para esta opção - Informe o valor do Som ou da Luz")
   _TOTA := 0
   ENDIF
   
ENDIF

IF _PARTCOD == "07"
   _TOTA := M->ZL_PARTART - _NEGART
ENDIF

Return(_TOTA)
