#INCLUDE "PROTHEUS.CH"


User Function MT110GET()
      
Local _aPosObj := PARAMIXB[1]
Local _nOpcx   := PARAMIXB[2]

_aPosObj[1,3] := 100
_aPosObj[2,1] := 101

Return(_aPosObj)
