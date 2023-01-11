#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT102CARR �Autor  �Gilberto Amancio    � Data �  24/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pto de Entrada para igualar o historico de estorno ao his-  ���
���          �torico do lancamento original.                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Ct102Carr

//aParam[1] = nOpc
//aParam[2] = dDataLanc
//aParam[3] = cLote
//aParam[4] = cSubLote
//aParam[5] = cDoc

Local aParam:= PARAMIXB
Local nOpc:= aParam[1]
Local lExe:= SuperGetMv("T4F_ESTHIS",.F.,.T.)

If lExe .And. nOpc == 6 // Estorno de Lan�amentos
	TMP->CT2_HIST	:= Substr(CT2->CT2_HIST,1,36)+"-EST"
Endif

Return