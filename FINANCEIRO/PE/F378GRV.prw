#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ F378GRV  ºAutor  ³Antonio Perinazzo Jrº Data ³  18/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para preencher informaçoes adcionais ao titulos  de impostosº±±
±±º          ³gerados.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F378GRV()
Local _aArea    := GetArea()
Local _aAreaSE2 := SE2->(GetArea())
Local _nREcno   := 0
//Local _NatPCC   := GetNewPar("MV_NATPCC","302305")

// Salva Recno anterior SE2
dbSelectArea("SE2")
_nRecno := Recno()

DbSelectArea("SED")
DbSetOrder(1)
//If SE2->E2_CODRET == "5952"
//	DbSeek(xFilial("SED")+_NatPCC)
//Else
DbSeek(xFilial("SED")+SE2->E2_NATUREZ)
//EndIf
If !Eof()

	If SE2->E2_CODRET == "5952"
	
		RecLock("SE2",.F.)
		SE2->E2_CCONTAB := SED->ED_DEBITO
		SE2->E2_HIST    := "TITULO AGLUTINADO "+DTOC(dDataBase)
		MsUnlock()
	Else
		
		RecLock("SE2",.F.)
		SE2->E2_CCONTAB := SED->ED_CONTA
		SE2->E2_HIST    := "TITULO AGLUTINADO "+DTOC(dDataBase)
		MsUnlock()
	EndIf
EndIf

RestArea(_aAreaSE2)
RestArea(_aArea)
RETURN
