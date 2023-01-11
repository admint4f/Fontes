#include "rwmake.ch"        
#include "colors.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASR0 บAutor  ณLuiz Eduardo        บ Data ณ  26/02/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para Ajustar SR0 de acordo com SR8                   บฑฑ
ฑฑบ          ณalterado para tabela SM7                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Desctoferias

Local _cChave := "!!!!!!!!!"
Local dDataIni	:= firstday(date()-40)
Local dDataFim	:= lastday(date()-40)
Local nTotReg:= 0 

Public cAliasTRB := AllTrim("SR8ABC" + xFilial("SR8"))
Public dFin1 := dIni1 := ""

if select("SR8ABC" + xFilial("SR8"))<>0
	dbCloseArea("SR8ABC" + xFilial("SR8"))
endif
if select("SR8ABD" + xFilial("SR8"))<>0
	dbCloseArea("SR8ABD" + xFilial("SR8"))
endif
if select("SR8ABC01")<>0
	dbCloseArea("SR8ABC01")
endif


@ 050,50 TO 200,300 DIALOG oDlg TITLE "Data do Beneficio"
@ 10,010 TO 45,120
@ 015,020 SAY "Data de  :"
@ 015,050 GET dDataIni SIZE 50,50  
@ 030,020 SAY "Data At้ :"
@ 030,050 GET dDataFim SIZE 50,50  

@ 50,050 BMPBUTTON TYPE 1 ACTION Close(oDlg)
@ 50,196 BMPBUTTON TYPE 2 ACTION sair()
ACTIVATE DIALOG oDlg CENTERED

dIni1 := dtos(dDataIni)
dFim1 := dtos(dDataFim)

dDataIni := dtoc(dDataIni)
dDataFim := dtoc(dDataFim)

Processa( {|| CalcFer()},"Gravando informa็๕es de f้rias para benefํcios perํodo de "+dDataIni+" a "+dDataFim )   
Return

Static Function Sair()
Close(oDlg)           
Return
                                                             
Static Function CalcFer()

//Local cNewAlias:= GetNextAlias()
//Local nTotReg:= 0 

cQuery := "Select * "
cQuery += "From " + RetSqlName("SR8") + " SR8 "
cQuery += "Where "//R8_FILIAL = '" + xFilial("SR8") + "'"
cQuery += "  (R8_DATAINI  >= '" + dIni1 + "'"
//cQuery += "  And (R8_DATAINI  >= '" + dIni1 + "'"
cQuery += "  And R8_DATAINI  <= '" + dFim1 + "')"
cQuery += "  Or  (R8_DATAFIM  >= '" + dIni1 + "'"
cQuery += "  And R8_DATAFIM  <= '" + dFim1 + "')"
cQuery += "  And D_E_L_E_T_ = ' ' "

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)

dbSelectArea(cAliasTRB)
ProcRegua(Reccount())

do while !eof()
    IncProc("Lendo registros...")
	cFil  := R8_FILIAL
	cMat  := R8_MAT
	dAtu     := r8_dataini
	dinifer  := r8_dataini
	dfinfer  := r8_datafim 
	cTipo	 := R8_TIPO
	nDiaTra	 := 30
	Select SR8
	dbSetOrder(1)
	seek cFil+cMat+dinifer+cTipo
	if eof()
		dbSelectArea(cAliasTRB)
		skip
		loop
	endif	

	Select SRA
	seek cFil+cMat
	cTnoTrab := RA_TNOTRAB
	n := 0
	dbSelectArea(cAliasTRB)
	if cMat = '003355'
		x:=1
	endif
	do while dAtu <= dFim1
		if dAtu >= dIni1 .and. dAtu <= dFim1 .and. dAtu >= dInifer .and. dAtu <= dfinfer
			Select RCG
			DbSetOrder(1)

			seek xFilial()+left(dAtu,6)+cTnoTrab
			if eof()
				cTnoTrab := "@@@"
			endif
			Select RCF
			DbSetOrder(1)
			dUteis := dtos(stod(dIni1)+65)  // Numero de dias ๚teis no m๊s a serem descontados o VT e VR
			seek xFilial()+left(dUteis,6)+cTnoTrab
			nDiaTra := RCF->RCF_DIATRA
			
			Select RCG
			DbSetOrder(2)

//                RCG_FILIAL+RCG_PROCES+RCG_PER+RCG_SEMANA+RCG_ROTEIR+RCG_TNOTRA+DTOS(RCG_DIAMES)
			seek xFilial()+"00001"+substr(dAtu,1,6)+"01   "+cTnotrab+dAtu
			if alltrim(RCG_VTRANS) = "1" 
				n++
			endif
//			cQuery := "SELECT RCG_ANO,RCG_VTRANS,RCG_DIAMES "
//			cQuery += "FROM " + RETSQLNAME("RCG") + " "
//			cQuery += "WHERE RCG_FILIAL = '" + XFILIAL("RCG") + "'"
//			cQuery += "  AND RCG_TNOTRA = '" + cTnoTrab + "'"
//			cQuery += "  AND RCG_DIAMES = '" + dAtu + "'"
//			cQuery += "  AND D_E_L_E_T_    = ' ' "
//			cQuery := ChangeQuery(cQuery)

//			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cNewAlias,.F.,.T.)
			
/*			if RCG_TIPDIA <> "1" .and. RCG_ANO = left(dAtu,4)
				n++
			else
				Select SP3
				cDataatu := stod(dAtu)
				nDSemana := dow(stod(dAtu))
				seek xFilial()+dAtu
				if cDataAtu<>P3_DATA .and. nDSemana >=2 .and. nDSemana <=6 .and. dAtu<= dFim
					n++
				endif
			ENDIF 
*/			
		endif
		dbSelectArea(cAliasTRB)
		dAtu := dtos((stod(dAtu)+1))
	enddo
	Select SM7
	//Select SR0
	if n<>0
		seek cFil+cMat
//		DO WHILE !EOF() .AND. R0_MAT==cMat
		DO WHILE !EOF() .AND. M7_MAT==cMat
//			RecLock("SR0",.F.)
//			SR0->R0_DPROPIN := nDiaTra - N
			RecLock("SM7",.F.)
			SM7->M7_DPROPIN := nDiaTra - N
			MsUnLock()
			Skip
		Enddo
	endif
	dbSelectArea(cAliasTRB)
	skip
enddo

//copy to \xTrb
return

/*/
		cQuery := "SELECT R0_FILIAL,R0_MAT,R0_DPROPIN "
		cQuery += "FROM "+ RETSQLNAME("SR0") + " WHERE R0_MAT = '"+cMat+"' AND "
		cQuery += "D_E_L_E_T_ <>'*'"
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP", .F., .T.)
		cDatPO := ""      
		dbgotop()
		Do while !eof()
			cChave := R0_FILIAL+R0_MAT
		    Select SR0
			seek cChave
			DO WHILE !EOF() .AND. R0_MAT==cMat
				RecLock("SR0",.F.)
				SR0->R0_DPROPIN := N
				MsUnLock()
				Skip
			Enddo        
			Select Tmp
			skip			
		enddo
	    use
	endif
/*/