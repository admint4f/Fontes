/**************************************************************************************
.Programa  : TotHosp			
.Autor     : Marcos Justo
.Data      : 22/04/04
.Descricao : Gatilho disparo total hospedagem
.                                                                                 
**************************************************************************************/
User Function TotHosp() 

Local aAreaAnt := GetArea() 
_TOTSUITE  := (M->ZL_QSUITE*M->ZL_NDSUITE*M->ZL_VALSUIT)
_TOTSINGL  := (M->ZL_QUANSIN*M->ZL_NUMDSIN*M->ZL_VALSING)
_TOTDOUBL  := (M->ZL_QUANDOU*M->ZL_NUMDDOU*M->ZL_VALDOUB)
_TOTTRIPL  := (M->ZL_QUANTRI*M->ZL_NUMTRIP*M->ZL_VALTRIP)
_HOSP := _TOTSUITE+_TOTSINGL+_TOTDOUBL+_TOTTRIPL

_SOM       := M->ZL_SOM
_LUZ       := M->ZL_LUZ
_CAMARIM   := M->ZL_CAMARIM
_TRANEQUI  := M->ZL_TREQUIP

_MIDIA     := M->ZL_MIDIA
_PORCMIDIA := M->ZL_PORCMIDIA
_TOTMIDIA  := (_MIDIA*(_PORCMIDIA/100))

_SINDICA   := M->ZL_SINDICA
_VRCONTR   := M->ZL_VRCONTR
_TOTSINDICA := (M->ZL_SINDICA*(M->ZL_VRCONTR/100))

_VISTOENT  := M->ZL_VISTOEN
_NUMPENT   := M->ZL_NUMPENT
_TOTVISTO  := (M->ZL_VISTOEN*M->ZL_NUMPENT)

_EQUIPPR   := M->ZL_EQUIPPR
_NUMPPRO   := M->ZL_NUMPPRO    
_TOTPROD   := (M->ZL_EQUIPPR*M->ZL_NUMPPRO)

_BACKLINE  := M->ZL_BACKLINE

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
                           
_QAEREO1   := M->ZL_QAEREO1
_VAEREO1   := M->ZL_VAEREO1
_QAEREO2   := M->ZL_QAEREO2
_VAEREO2   := M->ZL_VAEREO2
_QAEREO3   := M->ZL_QAEREO3
_VAEREO3   := M->ZL_VAEREO3
_QAEREO4   := M->ZL_QAEREO4
_VAEREO4   := M->ZL_VAEREO4
_TOTAERE   := (_QAEREO1*_VAEREO1)+(_QAEREO2*_VAEREO2)+(_QAEREO3*_VAEREO3)+(_QAEREO4*_VAEREO4)

_NPESSDI   := M->ZL_NPESSDI
_NDIALI    := M->ZL_NDIAALI
_VALDALI   := M->ZL_VALDALI
_TOTALIM   := (_NPESSDI*_NDIALI*_VALDALI)

_CUSTOP :=_HOSP+(_SOM*M->ZL_NUMAPRE)+(_LUZ*M->ZL_NUMAPRE)+_TRANEQUI+_TOTSINDICA+_TOTVISTO+_TOTPROD+_BACKLINE+_TOTTERR+_TOTAERE+_TOTALIM+(_CAMARIM*M->ZL_NUMAPRE)

outcus := 0
dbSelectarea("SZS")
dbGotop()
While !eof()
	IF SZS->ZS_CHAVE1 <> M->ZL_CHAVE1
	   dbSkip()
	   Loop
	ENDIF

outcus := outcus + SZS->ZS_PREVIST

dbSkip()
Enddo
RestArea(aAreaAnt)                               
_custop := _custop + outcus

_cemcus := (_custop * 10) / 100
                               

if _totsindica > _cemcus
msgalert("Valor de outras despesas, maior que 10% do valor total dos custos")
msgalert("O valor de outras despesas será zerado")
M->ZL_SINDICA := 0
_custop := _custop - _TOTSINDICA
endif


Return(_CUSTOP)

