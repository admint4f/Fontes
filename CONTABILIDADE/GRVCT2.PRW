#include "rwmake.ch"

User Function GRVCT2()

Msgalert("Verifique a data base do sistema!")

MSAGUARDE( {||PrcGRVCT2()})

Return()


Static Function PrcGRVCT2()
  
Local _linha := 0
Local _doc   := "1"
Private cPerg   := "RSE2"

Pergunte(cPerg,.T.)

DbSelectarea("SZL")
DbSetorder(4)
Dbgotop()

DbSeek(xFilial("SZL")+dtos(mv_par01),.T.)
While !eof() .AND. dtos(SZL->ZL_DATAINI) <= dtos(mv_par02)

if ZL_CONTAIM == "S"
   dbskip()
   loop
endif

_VENDASCC   := SZL->ZL_VENDACC
_VENDASR    := SZL->ZL_VENDASR
//_CISS       := SZL->ZL_CISS
//_CECAD      := SZL->ZL_CECAD
//_CPIS       := SZL->ZL_CPIS
_TOTCAR =(_VENDASCC*SZL->ZL_txcc)/100
_CALUIMO    := SZL->ZL_CALUIMO
_ANALISE    := SZL->ZL_CHAVE1

IF SZL->ZL_CISS == 0
   _CISS = (_VENDASR * SZL->ZL_TXISS)/100
ELSE
   _CISS = SZL->ZL_CISS
ENDIF
IF SZL->ZL_CECAD == 0
   _CECAD = (_VENDASR * SZL->ZL_TXECAD)/100
ELSE
   _CECAD = SZL->ZL_CECAD
ENDIF

IF SZL->ZL_CPIS == 0
   _CPIS = ((_VENDASR -(_VENDASR*(SZL->ZL_PORCART/100)))*(SZL->ZL_TXPIS/100)) 
ELSE
   _CPIS = SZL->ZL_CPIS   
ENDIF   



IF _CALUIMO == 0
   _CALUIMO := ((_VENDASR-_CISS-_CECAD-_CPIS-_TOTCAR)*(SZL->ZL_TXALIMO/100)) 
ENDIF

_valor	 	:= _CALUIMO
_conta 		:= "40108011001"
_contad 	:= "50108011001"
_elempep    := ALLTRIM(SZL->ZL_ELEMPEP)
_divic      := "BINM"
_divid      := "BSHO"
_histori    := "LOC.IMOVEIS ENTRE AREAS -" + SUBSTR(SZL->ZL_ARTISTA,1,15)
_data       := ddatabase

MSPROCTXT("HISTORICO "+ _histori)

DbSelectarea("CT2")
    
    _LINHA := _LINHA + 1
    
	Reclock("CT2",.T.)
	CT2->CT2_FILIAL     := "  "
	CT2->CT2_DATA 		:= _data
	CT2->CT2_LOTE		:= "LANALU"
	CT2->CT2_SBLOTE  	:= "001"
	if _linha < 999
	CT2->CT2_DOC		:= "00000" + _DOC
	else
	_LINHA := 1
	_DOC := "2"
	CT2->CT2_DOC		:= "00000" + _DOC
	endif
	
	if _linha < 10
	CT2->CT2_LINHA		:= "00" + STR(_LINHA,1)
	endif
	if _linha > 9
	CT2->CT2_LINHA		:= "0" + STR(_LINHA,2)
	endif
	if _linha > 99
	CT2->CT2_LINHA		:= STR(_LINHA,3)
	endif
	
	CT2->CT2_MOEDLC    := "01"
	CT2->CT2_DC			:= "3"
	CT2->CT2_DEBITO     := _contad
	CT2->CT2_CREDIT     := _conta
	CT2->CT2_VALOR		:= _valor 
	CT2->CT2_HIST		:= _histori
	CT2->CT2_ITEMD		:= _elempep
	CT2->CT2_ITEMC      := _elempep
	CT2->CT2_CLVLDB     := _divid
	CT2->CT2_CLVLCR     := _divic
	CT2->CT2_EMPORI     := "01"
	CT2->CT2_FILORI     := "01"
	CT2->CT2_TPSALD     := "9"
	CT2->CT2_MANUAL		:= "2"
	CT2->CT2_ROTINA		:= "CTBA500"
	CT2->CT2_AGLUT		:= "2"
	CT2->CT2_SEQHIS		:= "001"
	if _linha < 10
	CT2->CT2_SEQLAN		:= "00" + STR(_LINHA,1)
	endif
	if _linha > 9
	CT2->CT2_SEQLAN		:= "0" + STR(_LINHA,2)
	endif
	if _linha > 99
	CT2->CT2_SEQLAN		:= STR(_LINHA,3)
	endif
	
	CT2->CT2_SLBASE		:= "S"
	CT2->CT2_CRCONV		:= "1"
	CT2->CT2_ORIGEM     := "LANALU " + SUBSTR(CUSUARIO,7,15) + _ANALISE
	Msunlock()

	DbSelectarea("SZL")
	DbSetorder(4)
	
	Reclock("SZL",.F.)
	SZL->ZL_CONTAIM := "S"
	Msunlock()
	
	dbSkip()
	
Enddo

return

	
