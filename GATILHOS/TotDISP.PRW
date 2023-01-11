/**************************************************************************************
.Programa  : TotBil
.Autor     : Marcos Justo
.Data      : 19/04/04
.Descricao : Gatilho disparo total bilheteria                           
.                                                                                 
**************************************************************************************/
User Function TotDisp()

Public _TOT1,_TOT2,_TOT3,_TOT4,_TOT5,_TOT6,_TOT7,_TOT8,_TOT9,_TOT10,_TOT11,_TOT12

_TOT1 :=  (M->ZL_QUANT1-M->ZL_PAT1-M->ZL_RADIO1-M->ZL_ART1-M->ZL_CASA1)
IF _TOT1 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT2 :=  (M->ZL_QUANT2-M->ZL_PAT2-M->ZL_RADIO2-M->ZL_ART2-M->ZL_CASA2)
IF _TOT2 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT3 :=  (M->ZL_QUANT3-M->ZL_PAT3-M->ZL_RADIO3-M->ZL_ART3-M->ZL_CASA3)
IF _TOT3 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT4 :=  (M->ZL_QUANT4-M->ZL_PAT4-M->ZL_RADIO4-M->ZL_ART4-M->ZL_CASA4)
IF _TOT4 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT5 :=  (M->ZL_QUANT5-M->ZL_PAT5-M->ZL_RADIO5-M->ZL_ART5-M->ZL_CASA5)
IF _TOT5 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT6 :=  (M->ZL_QUANT6-M->ZL_PAT6-M->ZL_RADIO6-M->ZL_ART6-M->ZL_CASA6)
IF _TOT6 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT7 :=  (M->ZL_QUANT7-M->ZL_PAT7-M->ZL_RADIO7-M->ZL_ART7-M->ZL_CASA7)
IF _TOT7 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT8 :=  (M->ZL_QUANT8-M->ZL_PAT8-M->ZL_RADIO8-M->ZL_ART8-M->ZL_CASA8)
IF _TOT8 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT9 :=  (M->ZL_QUANT9-M->ZL_PAT9-M->ZL_RADIO9-M->ZL_ART9-M->ZL_CASA9)
IF _TOT9 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT10 := (M->ZL_QUANT10-M->ZL_PAT10-M->ZL_RADIO10-M->ZL_ART10-M->ZL_CASA10)
IF _TOT10 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT11 := (M->ZL_QUANT11-M->ZL_PAT11-M->ZL_RADIO11-M->ZL_ART11-M->ZL_CASA11)
IF _TOT11 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF
_TOT12 := (M->ZL_QUANT12-M->ZL_PAT12-M->ZL_RADIO12-M->ZL_ART12-M->ZL_CASA12)
IF _TOT12 < 0 
   MSGALERT("Quantidade total no setor ficará negativa, verifique !!")
ENDIF

_TOTDIS := _TOT1+_TOT2+_TOT3+_TOT4+_TOT5+_TOT6+_TOT7+_TOT8+_TOT9+_TOT10+_TOT11+_TOT12

Return(_TOTDIS)

