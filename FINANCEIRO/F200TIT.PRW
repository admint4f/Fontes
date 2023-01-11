#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FINA01  ºAutor  ³Bruna Zechetti      º Data ³  20/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para geração de pagamentos antecipados                ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F200TIT()

//MsgBox(se5->e5_banco+" "+"F200TIT","ERROR")  
cQuery := "SELECT A6_AGCNAB,A6_CTCNAB,A6_DGCCNAB FROM "+ RetSqlName("SA6")+" "
cQuery += " WHERE A6_AGCNAB >='0000' " 
cQuery += " AND " + "D_E_L_E_T_ <>'*' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPD", .F., .T.)
cAg := A6_AGCNAB
cCta := A6_CTCNAB
cDg := A6_DGCCNAB

use

Select SE5

if cBanco='341' .and. (cConta = cCta .or. se5->E5_conta=cCta) //(cConta = '36279' .or. se5->E5_conta='36279')
	cAgencia := FI0->FI0_AGE //SA6->A6_AGENCIA
	cConta	 := FI0->FI0_CTA //SA6->A6_NUMCON
	Select SA6
	seek xFilial()+FI0->FI0_BCO+(cAgencia+cConta)
	Select SE5
	reclock("SE5",.f.)
	se5->E5_Agencia := cAgencia
	se5->E5_conta 	:= cConta
	MsUnLock()
endif
Return

/*
FA200REJ

F200DB1

F200DB2

F200OCR


