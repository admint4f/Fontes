#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³FA050IMPOSºAutor  ³Antonio Perinazzo Jrº Data ³  20/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para preencher informaçoes adcionais ao titulos  de impostosº±±
±±º          ³gerados.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F050PIS()
Local _aArea    := GetArea()
Local _aAreaSE2 := SE2->(GetArea())
Local _nRecno   := 0
//Local _NatPCC   := GetNewPar("MV_NATPCC","302305")

// Salva Recno anterior SE2
dbSelectArea("SE2")
_nRecno := Recno()

// REGISTRO DO TITULO ORIGINAL
//dbSelectArea("SE2")
//dbGoto(ParamIXB)

// REGISTRO EM GRAVACAO NO MOMENTO
dbSelectArea("SE2")
dbGoto(_nRecno)

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
		//SE2->E2_NATUREZ := _NatPCC    // Comentado devido a não atendear a rotina FINA378
		//SE2->E2_CCONTAB := SED->ED_CONTA    // Comentado devido a não ser compativel com a rotina FINA378
		SE2->E2_CCONTAB := SED->ED_DEBITO
		SE2->E2_HIST    := "PIS do PCC "+SE2->E2_CODRET
		MsUnlock()
	Else
		
		RecLock("SE2",.F.)
		SE2->E2_CCONTAB := SED->ED_CONTA
		SE2->E2_HIST    := "PIS "+SE2->E2_CODRET
		MsUnlock()
	EndIf
EndIf

RestArea(_aAreaSE2)
RestArea(_aArea)
RETURN

