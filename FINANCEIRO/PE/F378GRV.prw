#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  � F378GRV  �Autor  �Antonio Perinazzo Jr� Data �  18/08/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Para preencher informa�oes adcionais ao titulos  de impostos���
���          �gerados.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
