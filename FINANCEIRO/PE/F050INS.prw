#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �FA050INS  �Autor  �Antonio Perinazzo Jr� Data �  18/08/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Para preencher informa�oes adcionais ao titulos  de impostos���
���          �gerados.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F050INS()
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
	
	RecLock("SE2",.F.)
	SE2->E2_CCONTAB := SED->ED_CONTA
	SE2->E2_HIST    := "INSS retido "+DTOC(dDataBase)
	MsUnlock()
	
EndIf

RestArea(_aAreaSE2)
RestArea(_aArea)
RETURN
