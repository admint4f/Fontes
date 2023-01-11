#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RETLEIR   �Autor  �Gilberto            � Data �  10/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Para contabilizacao dos gastos com a Lei Rouanet            ���
���          �Lancamentos Padroes de Entrada (650,651,etc..)              ���
���          �Configurado juntamente com Anderson e Reginaldo.            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico para T4F                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RetLeiR()

Local aArea:= GetArea()
Local cElemPepe:= '' 
Local cCtaLeiRouanet:= ''
Local cCtaEscape:= SuperGetMv("T4F_CTAESC",,"217021004")
// 
cElemPepe:=SD1->D1_ITEMCTA   
If Empty(cElemPepe)
	cCtaLeiRouanet:=cCtaEscape
Else	
	cCtaLeiRouanet:= Posicione("CTD",1,xFilial("CTD")+cElemPepe,"CTD_T4LROU")
	If Empty(cCtaLeiRouanet)                 
	   // Atencao:
	   // A conta abaixo eh a conta de "escape" definida pelo usuario chave Anderson.
	   // Caso nao encontre a conta da Lei Rouanet entao utiliza a conta abaixo.
		cCtaLeiRouanet:=cCtaEscape
	EndIf
EndIf
//Restaura area anterior.
RestArea( aArea )
Return( cCtaLeiRouanet )  