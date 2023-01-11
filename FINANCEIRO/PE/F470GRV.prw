#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F470GRV   � Autor �Antonio Perinazzo Jr� Data �  17/10/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para alimentar o campo numero de documento���
���          � no registro de movimento bancario.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function F470GRV()

Local aArea      := GetArea()
Local _Paramtro  := PARAMIXB
Local _Retorno   := .t.

//Public ddtinich  := MV_PAR09
//Public ddtfinch  := MV_PAR10
//cDescrMov := SubStr(cDescrMov,5,Len(cDescrMov))
Do Case
Case Trim(cDescrMov) == "VENDA CARTAO DE CREDITO"
	cDescrMov := "C.CREDITO"
Case Trim(cDescrMov) == "CARTAO VISA ELECTRON"
	cDescrMov := "VISA ELECT."
Case Trim(cDescrMov) == "OCT-ORDEM CRED.-DINHEIRO"
	cDescrMov := "OCT.DIN." 
EndCase

//ddTinich := MV_PAR09
//DDTFINCH := MV_PAR10

cDescrMov := Trim(cDescrMov)+ Iif(len(trim(cNumMov))> 0," " + cNumMov,"" )

RestArea(aArea)

Return(_Retorno)