/**************************************************************************************
.Programa  : TotTerr			
.Autor     : Marcos Justo
.Data      : 22/04/04
.Descricao : Gatilho disparo total Transporte Terrestre
.                                                                                 
**************************************************************************************/
User Function TotTerr() 


_QCARRO    := M->ZL_QCARRO
_NUMCARR   := M->ZL_NUMCARR
_VALCARR   := M->ZL_VALCARR
_TOTCARRO  := (M->ZL_QCARRO*M->ZL_NUMCARR*M->ZL_VALCARR)
_QVAN      := M->ZL_QVAN
_NUMVAN    := M->ZL_NUMVAN
_VALVAN    := M->ZL_VALVAN
_TOTVAN    := (M->ZL_QVAN*M->ZL_NUMVAN*M->ZL_VALVAN)
_QOUTROS   := M->ZL_QOUTROS
_NUMOUT    := M->ZL_NUMOUT
_VALOUTR   := M->ZL_VALOUTR
_TOTOUT    := (M->ZL_QOUTROS*M->ZL_NUMOUT*M->ZL_VALOUTR)
_TOTTERR   := _TOTCARRO+_TOTVAN+_TOTOUT
                           

Return(_TOTTERR)

