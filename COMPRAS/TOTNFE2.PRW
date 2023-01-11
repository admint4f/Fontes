/**************************************************************************************
.Programa  : TotNFE
.Autor     : Jose Carlos S. Veloso Junior
.Data      : 07/01/03
.Descricao : Gatilho disparo apos digitacao do nr. da nora de entrada.
.            Solicita ao usuario informar o total da nota antes de sua digitacao.
**************************************************************************************/
User Function TotNFE2()


backup1 := mv_par01 
backup2 := mv_par02
cCodprod  := aCols[ n, aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_COD" })]
_Ret      := aCols[ n,1   ]

If cTipo == "N"
	Public _CIENFETOT := 0
	Public _CIENFEHIS := 0

	ValidPerg()
	Pergunte('TOTNFE',.T.)
	
	_CIENFETOT := mv_par01
	_CIENFEHIS := mv_par02
	mv_par01 := backup1
	mv_par02 := backup2
EndIf

Return(_ret)

/**************************************************************************************
.Programa  : ValidPerg
.Autor     : Jose Carlos S. Veloso Junior
.Data      : 31/08/01
.Descricao : Verifica perguntas no SX1. Se elas nao existirem serao criadas
**************************************************************************************/
Static Function ValidPerg()

Local i:= 0,j:=0
Local aArea      := GetArea()
Local aRegistros := {}

AADD(aRegistros,{padr('TOTNFE',len(X1_GRUPO)),'01','Total da Nota','Total da Nota','Total da Nota','mv_ch1','N',14,2,1,'G',""                                                    ,'mv_par01','','','','','','','','','','','','','','','','','','','','','','','','',''  ,''})
AADD(aRegistros,{padr('TOTNFE',len(X1_GRUPO)),'02','Forma Pgto. ?','Forma Pgto. ?','Date ?'       ,'mv_ch2','C',3, 0,1,'G',"!empty(mv_par02) .and. existcpo('SX5','ZA'+mv_par02)",'mv_par02','','','','','','','','','','','','','','','','','','','','','','','','','ZA',''})

dbSelectArea("SX1")

For i:=1 to Len(aRegistros)
	
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next j
		
		MsUnlock()
		
	EndIf
	
Next i

RestArea(aArea)

Return(NIL)