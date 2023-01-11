/**************************************************************************************
.Programa  : TotBil
.Autor     : Marcos Justo
.Data      : 19/04/04
.Descricao : Gatilho disparo total bilheteria                           
.                                                                                 
**************************************************************************************/
User Function TotBIL()

Public _TOT1,_TOT2,_TOT3,_TOT4,_TOT5,_TOT6,_TOT7,_TOT8,_TOT9,_TOT10,_TOT11,_TOT12

_TOT1 :=  (M->ZL_QUANT1-M->ZL_PAT1-M->ZL_RADIO1-M->ZL_ART1-M->ZL_CASA1)
_TOT2 :=  (M->ZL_QUANT2-M->ZL_PAT2-M->ZL_RADIO2-M->ZL_ART2-M->ZL_CASA2)
_TOT3 :=  (M->ZL_QUANT3-M->ZL_PAT3-M->ZL_RADIO3-M->ZL_ART3-M->ZL_CASA3)
_TOT4 :=  (M->ZL_QUANT4-M->ZL_PAT4-M->ZL_RADIO4-M->ZL_ART4-M->ZL_CASA4)
_TOT5 :=  (M->ZL_QUANT5-M->ZL_PAT5-M->ZL_RADIO5-M->ZL_ART5-M->ZL_CASA5)
_TOT6 :=  (M->ZL_QUANT6-M->ZL_PAT6-M->ZL_RADIO6-M->ZL_ART6-M->ZL_CASA6)
_TOT7 :=  (M->ZL_QUANT7-M->ZL_PAT7-M->ZL_RADIO7-M->ZL_ART7-M->ZL_CASA7)
_TOT8 :=  (M->ZL_QUANT8-M->ZL_PAT8-M->ZL_RADIO8-M->ZL_ART8-M->ZL_CASA8)
_TOT9 :=  (M->ZL_QUANT9-M->ZL_PAT9-M->ZL_RADIO9-M->ZL_ART9-M->ZL_CASA9)
_TOT10 := (M->ZL_QUANT10-M->ZL_PAT10-M->ZL_RADIO10-M->ZL_ART10-M->ZL_CASA10)
_TOT11 := (M->ZL_QUANT11-M->ZL_PAT11-M->ZL_RADIO11-M->ZL_ART11-M->ZL_CASA11)
_TOT12 := (M->ZL_QUANT12-M->ZL_PAT12-M->ZL_RADIO12-M->ZL_ART12-M->ZL_CASA12)


_TTOT1 := (M->ZL_VALOR1*_TOT1)  * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT2 := (M->ZL_VALOR2*_TOT2)  * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT3 := (M->ZL_VALOR3*_TOT3)  * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT4 := (M->ZL_VALOR4*_TOT4)  * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT5 := (M->ZL_VALOR5*_TOT5)  * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT6 := (M->ZL_VALOR6*_TOT6)  * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT7 := (M->ZL_VALOR7*_TOT7)  * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT8 := (M->ZL_VALOR8*_TOT8)  * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT9 := (M->ZL_VALOR9*_TOT9)  * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT10 := (M->ZL_VALOR10*_TOT10) * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT11 := (M->ZL_VALOR11*_TOT11) * (1-((M->ZL_TXESTUD/100)*.5))
_TTOT12 := (M->ZL_VALOR12*_TOT12) * (1-((M->ZL_TXESTUD/100)*.5))




_TOTAL := _TTOT1+_TTOT2+_TTOT3+_TTOT4+_TTOT5+_TTOT6+_TTOT7+_TTOT8+_TTOT9+_TTOT10+_TTOT11+_TTOT12

Return(_TOTAL)

