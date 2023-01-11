#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATUQUANT    º Autor ³ AP6 IDE            º Data ³  01/03/04 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/



User Function ATUQUANT()

                

//MSAGUARDE( {||ATUQUANT()},"Aguarde","Processando...",.F.)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Local aAmb  := GetArea()
//Private cPerg       := "SZH"
//Private oLeTxt

//Private cString := "SZH"

dbSelectArea("SZH")
dbSetOrder(1)
dbGotop()
 
Do While !eof()
	

	_EVENTO :=	SZH->ZH_EVENTO
	_QUANT  :=	VAL(SZH->ZH_QUANT)
	_VALOR  :=	VAL(SZH->ZH_VALOR)
	_CORTES :=  VAL(SZH->ZH_CORTES)
	
	dBselectarea("SZJ")
    dbSetOrder(1)
    dbGotop()
    
    IF dbSeek(xFilial("SZJ")+_EVENTO)
       _CHAVE := SZJ->ZJ_CLAVE
       _IMOVEL:= SZJ->ZJ_IMOVEL
       _QPREV := SZJ->ZJ_QPREV
       _VPREV := SZJ->ZJ_VPREV
       _DESC  := SZJ->ZJ_DESC
       _ANA   := SZJ->ZJ_ANALISE
       
     IF _QUANT > 0
		dbSelectArea("SZI")
		Reclock("SZI",.T.)
		SZI->ZI_EVENTO  := _EVENTO
		SZI->ZI_QUANT   := _QUANT
		SZI->ZI_VALOR   := _VALOR 
		SZI->ZI_CORTES  := _CORTES
		SZI->ZI_QPREV   := _QPREV
		SZI->ZI_VPREV   := _VPREV
		SZI->ZI_CLAVE   := _CHAVE
        SZI->ZI_DATA    := DATE()
        SZI->ZI_HORA    := SUBSTR(TIME(),1,5)
        SZI->ZI_DESC    := _DESC
        SZI->ZI_IMOVEL  := _IMOVEL
        SZI->ZI_ANALISE := _ANA
        SZI->(Msunlock())
	 ENDIF	
	ENDIF
	
	
//  MSPROCTXT("EVENTO "+ SZH->ZH_EVENTO)

Reclock("SZH",.F.)
dbdelete() 
SZH->(Msunlock())

	dbSkip()
	
Enddo
MSGALERT(" Processo Finalizado com Sucesso!!!")
Return
