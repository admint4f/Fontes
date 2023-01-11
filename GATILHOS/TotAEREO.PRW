/**************************************************************************************
.Programa  : TotAereo			
.Autor     : Marcos Justo
.Data      : 22/04/04
.Descricao : Gatilho disparo total Passagens Aereas
.                                                                                 
**************************************************************************************/
User Function TotAereo() 

                           
_QAEREO1   := M->ZL_QAEREO1
_VAEREO1   := M->ZL_VAEREO1
_QAEREO2   := M->ZL_QAEREO2
_VAEREO2   := M->ZL_VAEREO2
_QAEREO3   := M->ZL_QAEREO3
_VAEREO3   := M->ZL_VAEREO3
_QAEREO4   := M->ZL_QAEREO4
_VAEREO4   := M->ZL_VAEREO4
_TOTAERE   := (_QAEREO1*_VAEREO1)+(_QAEREO2*_VAEREO2)+(_QAEREO3*_VAEREO3)+(_QAEREO4*_VAEREO4)

Return(_TOTAERE)

