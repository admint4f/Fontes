#include 'protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GP010FimPE�Autor  �Microsiga           � Data �  03/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE ao final da inclus�o/altera��o de funcion�rios no       ���
���          � Gest�o de Pessoal. Utilizado para cadastrar o funcion�rio  ���
���          � como usu�rio do portal assim que � inclu�do.               ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function GP010FimPE()

ZAB->( dbSetOrder(3) )
if ZAB->( !dbSeek( SRA->RA_MAT ) )
	reclock("ZAB",.T.)
	ZAB->ZAB_EMP	:= cEmpAnt
	ZAB->ZAB_FIL	:= SRA->RA_FILIAL
	ZAB->ZAB_REFID	:= '2'
	ZAB->ZAB_ID		:= SRA->RA_MAT
	ZAB->ZAB_LOGIN	:= SRA->RA_MAT
	ZAB->ZAB_SENHA	:= u_altMD5(alltrim(SRA->RA_CIC))
	ZAB->ZAB_MSBLQL	:= '2'
	ZAB->ZAB_ALTPRX	:= '1'
	ZAB->ZAB_PERFIL	:= '2'
	msUnlock()
endif
	
return