#INCLUDE "Protheus.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SF2520E  �Autor  �Luiz Eduardo Tapaj�s� Data �  12/12/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na exclus�o da NF de Saida para atualiza-  ���
���          �cao do campo F2_DTLANC quando n�o estiver preenchido        ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SF2520E()

if EMPTY(SF2->F2_DTLANC)
//	Alert("Data de lan�amento em branco"+sf2->f2_doc)
	RecLock("SF2",.f.)
	SF2->F2_DTLANC := SF2->F2_emissao
	msUnLock()
endif

Return()