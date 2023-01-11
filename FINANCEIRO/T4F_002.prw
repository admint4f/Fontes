#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณT4F_002   บ Autor ณ AP6 IDE            บ Data ณ  21/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function T4F_002

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "Relatorio de Eficiencia de Contas a Pagar e Receber"
Local cPict			:= ""
Local titulo		:= "Relatorio de Eficiencia de Contas a Pagar e Receber"
Local nLin			:= 80
Local Cabec1		:= ""
Local Cabec2		:= ""
Local imprime		:= .T.
Local aOrd			:= {}
Private lEnd		:= .F.
Private lAbortPrint	:= .F.
Private CbTxt		:= ""
Private limite		:= 132
Private tamanho		:= "M"
Private nomeprog	:= "T4F_002" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo		:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey	:= 0
Private cPerg		:= "T4F002"
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "T4F002" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString		:= "SE5"

validperg(cPerg)
if !pergunte(cPerg,.t.)
	return .f.
endif
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
nTipo := If(aReturn[4]==1,15,18)     
Processa( {|| GeraDados() } )
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณGERADADOS บ Autor ณ Claudio            บ Data ณ  21/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Gera dados para impressao do relatorio                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function GeraDados()

Local cArq, cArqInd, cIndice             
Local cQueryPag := space(01)
Local cQueryRec := space(01)
Local aStru		:= {}
Private nRegPag	:= 0
Private nRegRec	:= 0		// para detectar o total de registros retornados pela query

// 1a. query: contas a pagar
if select("TRBPAG") > 0
	TRBPAG->(dbclosearea())
endif

// 2a. query: contas a receber
if select("TRBREC") > 0
	TRBREC->(dbclosearea())
endif

// arquivo temporario para impressao
if select("TRBREL") > 0
	TRBREL->(dbclosearea())
endif

cQueryPag := "SELECT SE2.E2_PREFIXO PREFIXO, SE2.E2_NUM NUMERO, SE2.E2_PARCELA PARCELA, SE2.E2_TIPO TIPO, "
cQueryPag += "SE2.E2_FORNECE FORNECE, SE2.E2_LOJA LOJA, SE2.E2_VENCREA VENCIM, SE2.E2_VLCRUZ VALOR FROM "
cQueryPag += retsqlname("SE2")+" SE2 WHERE "
cQueryPag += "SE2.E2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND "
cQueryPag += "SE2.E2_VENCREA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' AND "
cQueryPag += "SE2.E2_CCUSTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
cQueryPag += "SE2.D_E_L_E_T_ <> '*' ORDER BY SE2.E2_VENCREA"
cQueryPag := ChangeQuery(cQueryPag)
DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQueryPag),"TRBPAG",.F.,.T.)

cQueryRec := "SELECT SC5.C5_NOTA NOTA, SC5.C5_SERIE SERIE, SC5.C5_CLIENTE CLIENTE, SC5.C5_LOJACLI LOJA, "
cQueryRec += "SE1.E1_PREFIXO PREFIXO, SE1.E1_NUM NUMERO, "
cQueryRec += "SE1.E1_PARCELA PARCELA, SE1.E1_TIPO TIPO, SE1.E1_VENCREA VENCIM, SE1.E1_VLCRUZ VALOR FROM "+retsqlname("SC5")+" SC5, "+retsqlname("SE1")+" SE1 WHERE "
cQueryRec += "SE1.E1_SERIE = SC5.C5_SERIE AND "
cQueryRec += "SE1.E1_NUM = SC5.C5_NOTA AND "                                     
cQueryRec += "SE1.E1_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND "
cQueryRec += "SE1.E1_EMISSAO = SC5.C5_EMISSAO AND "
cQueryRec += "SE1.E1_VENCREA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"' AND "
cQueryRec += "SE1.E1_CCUSTO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
cQueryRec += "SE1.D_E_L_E_T_ <> '*' AND "
cQueryRec += "SC5.D_E_L_E_T_ <> '*' "
cQueryRec += "ORDER BY SE1.E1_VENCREA"
cQueryRec := ChangeQuery(cQueryRec)
DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQueryRec),"TRBREC",.F.,.T.)

dbSelectArea("SE5")
dbSetOrder(7)	// E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ

aAdd(aStru,{"DATAREF","C",8,0})			// data do movimento
aAdd(aStru,{"RECPAG","C",1})			// tipo de registro - pagar ou receber
aAdd(aStru,{"PREVPAG","N",12,2})		// valor previsto a pagar
aAdd(aStru,{"REALPAG","N",12,2})		// valor realizado a pagar
aAdd(aStru,{"PREVREC","N",12,2})		// valor previsto a receber
aAdd(aStru,{"REALREC","N",12,2})		// valor realizado a receber

cArq := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArq,"TRBREL",.T.)

cArqInd := CriaTrab(NIL, .F.)
cIndice := "DATAREF"
Index on &cIndice To &cArq

TRBREC->(dbEval({|| nRegRec++ }))
TRBREC->(dbGoTop())

TRBPAG->(dbEval({|| nRegPag++ }))
TRBPAG->(dbGoTop())

// sele็ใo dos dados para impressao - 1a etapa, registros A PAGAR
procregua(nRegPag)
dbselectarea("TRBPAG")
dbgotop()
do while !eof()
	dbselectarea("SE5")
	if SE5->(dbseek(xFilial("SE5")+TRBPAG->PREFIXO+TRBPAG->NUMERO+TRBPAG->PARCELA+TRBPAG->TIPO+TRBPAG->FORNECE+TRBPAG->LOJA))
		if SE5->E5_RECPAG = "P"	// para prevenir de que haja titulo com mesmo nr/pref/parcela a receber
			dbselectarea("TRBREL")
			reclock("TRBREL",.t.)
			TRBREL->DATAREF := TRBPAG->VENCIM
			TRBREL->RECPAG	:= "P"
			TRBREL->PREVPAG := TRBPAG->VALOR
			TRBREL->REALPAG := SE5->E5_VALOR
		endif
	else	// se NAO encontrou informa็ใo no SE5
		reclock("TRBREL",.t.)
		TRBREL->DATAREF := TRBPAG->VENCIM
		TRBREL->RECPAG	:= "P"
		TRBREL->PREVPAG := TRBPAG->VALOR
		TRBREL->REALPAG := 0
	endif
	msunlock()
	dbselectarea("TRBPAG")
	dbskip()
	incproc()
enddo

// sele็ใo dos dados para impressao - 2a. etapa, registros A RECEBER
procregua(nRegRec)
dbselectarea("TRBREC")
dbgotop()
do while !eof()
	dbselectarea("SE5")
	if SE5->(dbseek(xFilial("SE5")+TRBREC->PREFIXO+TRBREC->NUMERO+TRBREC->PARCELA+TRBREC->TIPO+TRBREC->CLIENTE+TRBREC->LOJA))
		if SE5->E5_RECPAG = "R"	// para prevenir de que haja titulo com mesmo nr/pref/parcela a pagar
			dbselectarea("TRBREL")
			reclock("TRBREL",.t.)
			TRBREL->DATAREF := TRBREC->VENCIM
			TRBREL->RECPAG	:= "R"
			TRBREL->PREVREC := TRBREC->VALOR
			TRBREL->REALREC := SE5->E5_VALOR
		endif
	else
		dbselectarea("TRBREL")
		reclock("TRBREL",.t.)
		TRBREL->DATAREF := TRBREC->VENCIM
		TRBREL->RECPAG	:= "R"
		TRBREL->PREVREC := TRBREC->VALOR
		TRBREL->REALREC := 0
	endif
	msunlock()
	dbselectarea("TRBREC")
	dbskip()
	incproc()
enddo
return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  21/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem    
Local cData		:= space(08)
Local nPrevPg	:= 0
Local nRealPg	:= 0
Local nPrevRc	:= 0
Local nRealRc	:= 0
Local nTotPrevPg:= 0
Local nTotRealPg:= 0
Local nTotPrevRc:= 0
Local nTotRealRc:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbselectarea("TRBREL")
dbGoTop()
cData := TRBREL->DATAREF
while !eof()
	if lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		exit
	endif
	if nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 6
		@ nLin,035 PSAY "PAGAR"
		@ nLin,090 PSAY "RECEBER" 
		nLin++
		@ nLin,003 PSAY "DATA REF"
		@ nLin,019 PSAY "PREVISTO"
		@ nLin,036 PSAY "REALIZADO"
		@ nLin,050 PSAY "VARIACAO (%)"
		@ nLin,077 PSAY "PREVISTO"
		@ nLin,091 PSAY "REALIZADO"
		@ nLin,106 PSAY "VARIACAO (%)"
		nLin+=	2
	endif
	do while cData = TRBREL->DATAREF
		if TRBREL->RECPAG = "P"
			nPrevPg	+= TRBREL->PREVPAG
			nRealPg	+= TRBREL->REALPAG
		else
			nPrevRc	+= TRBREL->PREVREC
			nRealRc	+= TRBREL->REALREC
		endif
		dbskip()
	enddo
	@ nLin,003 PSAY substr(cData,7,2)+"/"+substr(cData,5,2)+"/"+substr(cData,1,4) 	
    @ nLin,016 PSAY nPrevPg PICTURE "@E 999,999,999.99"
    @ nLin,033 PSAY nRealPg PICTURE "@E 999,999,999.99"
    @ nLin,052 PSAY (nRealPg / nPrevPg) * 100 PICTURE "999.99"
	@ nLin,073 PSAY nPrevRc PICTURE "@E 999,999,999.99"
    @ nLin,090 PSAY nRealRc PICTURE "@E 999,999,999.99"
    @ nLin,109 PSAY (nRealRc / nPrevRc) * 100 PICTURE "@E 999.99"
	nTotPrevPg += nPrevPg
	nTotRealPg += nRealPg
	nTotPrevRc += nPrevRc
	nTotRealRc += nRealRc
	nLin ++	
	cData	:= TRBREL->DATAREF
	nPrevPg	:= 0
	nRealPg	:= 0
	nPrevRc	:= 0
	nRealRc	:= 0
enddo
nLin ++ 
@ nLin,000 psay replicate("-",132)
nLin ++
@ nLin,003 PSAY "TOTAIS:"
@ nLin,016 PSAY nTotPrevPg PICTURE "@E 999,999,999.99"
@ nLin,033 PSAY nTotRealPg PICTURE "@E 999,999,999.99"
@ nLin,052 PSAY (nTotRealPg / nTotPrevPg) * 100 PICTURE "@E 999.99"
@ nLin,073 PSAY nTotPrevRc PICTURE "@E 999,999,999.99"
@ nLin,090 PSAY nTotRealRc PICTURE "@E 999,999,999.99"
@ nLin,109 PSAY (nTotRealRc / nTotPrevRc) * 100 PICTURE "@E 999.99"

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบFuncao    ณValidPerg  บ Autor ณ Claudio Manoel  บ Data ณ  22/09/05       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao de verificacao da existencia dos parametros a serem  บฑฑ
ฑฑบ          ณ informados                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidPerg(cPerg)

cAlias := Alias()
cPerg   := padr(cPerg,len(X1_GRUPO))
aRegs   :={}
dbSelectArea("SX1")
dbSetOrder(1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aadd(aRegs,{cPerg,"01","Emissao Inicial ?","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Emissao Final   ?","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Vencto Inicial  ?","","","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Vencto Final    ?","","","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"05","C. Custo Inicial?","","","mv_ch5","C",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","",""})
aadd(aRegs,{cPerg,"06","C. Custo Final  ?","","","mv_ch6","C",10,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","",""})
for i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnLock()
	EndIf
Next

dbSelectArea(cAlias)
Return .t.
