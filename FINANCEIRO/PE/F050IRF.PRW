#include "rwmake.ch"
User Function F050IRF()

Local _aArea := GetArea()

SetPrvt("_MOEDA,_CONTAG,_CLVL,_CONTA,_NUM,_ITEM,_CCUSTO,_IRRF")

dbSelectArea("SE2")
_nOrder := IndexOrd()
_nRecno := Recno()

// REGISTRO DO TITULO ORIGINAL
dbSelectArea("SE2")
dbGoto(ParamIXB)

// Guarda em vairaveis para gravar no titulo do imposto
_CCONTAB:=	SE2->E2_CCONTAB
_CCUSTO	:=	SE2->E2_CCUSTO
_ITEM	:= 	SE2->E2_ITEM

dbselectarea("SM2")
dbSetOrder(1)
dbSeek(DTOS(SE2->E2_EMISSAO))

_MOEDA	:=	SE2->E2_MOEDA

IF SE2->E2_MOEDA == _MOEDA
	_IRRF	:=	XMOEDA(SE2->E2_IRRF,_MOEDA,1,ddatabase,2) //SE2->E2_IRRF * (SM2->M2_MOEDA2)
ENDIF

IF SE2->E2_MOEDA == 2
	_IRRF	:=	XMOEDA(SE2->E2_IRRF,2,1,ddatabase,2)
ENDIF

IF SE2->E2_MOEDA == 3
	_IRRF	:=	XMOEDA(SE2->E2_IRRF,3,1,ddatabase,2)
ENDIF

IF SE2->E2_MOEDA == 4
	_IRRF	:=	XMOEDA(SE2->E2_IRRF,4,1,ddatabase,2)
ENDIF

// Posiciona na Natureza Financeira
DbSelectArea("SED")
DbSetOrder(1)
DbSeek(xFilial("SED")+SE2->E2_NATUREZ)

// REGISTRO EM GRAVACAO NO MOMENTO (imposto)
dbSelectArea("SE2")
dbGoto(_nRecno)
RecLock("SE2",.F.)
SE2->E2_CCONTAB := SED->ED_CONTA
SE2->E2_ITEM	:= _ITEM
SE2->E2_CCUSTO	:= _CCUSTO
SE2->E2_HIST    := "IR - RETIDO "+DTOC(DDATABASE)
IF SE2->E2_MOEDA <> 1
	SE2->E2_VLCRUZ	:= _IRRF
ENDIF
MsUnlock()

RestArea(_aArea)

Return()
