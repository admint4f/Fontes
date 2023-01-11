#INCLUDE "PROTHEUS.CH"


User Function MT120GET()
      
Local _aPosObj := PARAMIXB[1]
Local _nOpcx   := PARAMIXB[2]

_aPosObj[1,3] := 142
_aPosObj[2,1] := 145

Return(_aPosObj)