

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA290     �Autor  �Microsiga           � Data �  12/18/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada na grava��o do titulo Fatura a pagar      ���
���          �  (FINA290)                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA290()

		RecLock( "SE2", .F. )
		SE2->E2_STATLIB := "03" 
		SE2->E2_DATALIB := DDATABASE
		SE2->E2_USUALIB := CUSERNAME 
		SE2->(Msunlock("SE2"))
	    SE2->(DbCommit())

Return