#INCLUDE "Protheus.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SF2460I  �Autor  �Bruno Daniel Borges � Data �  10/01/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada apos geracao da NF de Saida para atualiza- ���
���          �cao do numero da NF no contrato                             ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SF2460I()
Local aAreaBKP := GetArea()
Local aAreaSC6 := SC6->(GetArea())

dbSelectArea("SC6")
SC6->(dbSetOrder(4))
SC6->(dbSeek(xFilial("SC6")+SF2->F2_DOC+SF2->F2_SERIE))
While SC6->(!Eof()) .And. SC6->(C6_FILIAL+C6_NOTA+C6_SERIE) == xFilial("SC6")+SF2->F2_DOC+SF2->F2_SERIE
     
	If SC6->C6__CONTRA > 0
		dbSelectArea("ZZ2")
		ZZ2->(dbGoTo(SC6->C6__CONTRA))
		If ZZ2->ZZ2_PEDIDO == SC6->C6_NUM
			ZZ2->(RecLock("ZZ2",.F.))
				ZZ2->ZZ2_SERNF	:= SF2->F2_SERIE
				ZZ2->ZZ2_NUMNF	:= SF2->F2_DOC
			ZZ2->(MsUnlock())	
		EndIf
	EndIf
	
	SC6->(dbSkip())
EndDo

RestArea(aAreaSC6)
RestArea(aAreaBKP)

//ALERT("PASSEI")

Return(Nil)