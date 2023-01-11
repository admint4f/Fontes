#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTB020VG  �Autor  �Gilberto Oliveira   � Data �  25/07/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada validando o "OK" do cadastro de plano de  ���
���          � contas, que nao pode ser gravado sem a conta referencial.  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTB020VG()
Local lOk:= .t.
Local x
Local nCount:= 0

For x:= 1 to Len(aCols)
	If !GdDeleted(x)
   		If !Empty( GdFieldGet("CVD_CODPLA",x) )
     		nCount++
		EndIf   
	EndIf	   

Next

If nCount == 0 .and. M->CT1_CLASSE == '2'
   ApMsgStop("Aten��o: "+chr(13)+"A Conta Referencial � obrigat�ria para contas de n�vel analitico."+chr(13)+chr(10)+"Digite a conta referencial para continuar.")
   lOk:= .f.
EndIf

Return( lOk )