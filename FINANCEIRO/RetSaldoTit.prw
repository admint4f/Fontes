#include "protheus.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �RETSALDOTIT�Autor  �Gilberto            � Data �  10/06/11   ���
��������������������������������������������������������������������������͹��
���Desc.     �Retorna o saldo do titulo descontado o abatimento para formar���
���          �o valor que sera enviado ao banco - utilizado o arq. config. ���
���          �CITINOV2.CPE                                                 ���
��������������������������������������������������������������������������͹��
���Uso       � AP                                                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function RetSaldoTit()
Local aArea:= GetArea()
Local aSE2Area:= SE2->( GetArea() )
Local nSaldo:= 0

If SuperGetMv("T4F_SALABAT",,"S") == "S"
	nSaldo:= StrZero( Val(STR((SE2->E2_SALDO-SE2->E2_SDDECRE-CalcAbat(se2->e2_prefixo,se2->e2_num,se2->e2_parcela,se2->e2_moeda,"P"))*100)) ,15) 
Else
	nSaldo:= StrZero( Val(STR((SE2->E2_SALDO-SE2->E2_SDDECRE)*100)) ,15)  // original
EndIf 	

SE2->( RestArea(aSE2Area) )
SE2->( RestArea(aArea) )
Return( nSaldo )

// StrZero( Val(STR((SE2->E2_SALDO-SE2->E2_SDDECRE)*100)) ,15)  // original
