#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103LDV � Autor �Antonio Perinazzo Jr� Data �  11/07/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para alimentar conta, cc., item  contabil ���
�������������������������������������������������������������������������͹��
���Uso       � T4f                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT103LDV
Local aArea      := GetArea()
Local _Retorno   := {}
Local _Linha     := Paramixb[1]
Local _AliasSD2  := Paramixb[2]


AAdd( _Linha, { "D1_CONTA"   , (_AliasSD2)->D2_CONTA   , Nil } )
AaDd( _Linha, { "D1_CC"      , (_AliasSD2)->D2_CCUSTO  , Nil } )
AaDd( _Linha, { "D1_ITEMCTA" , (_AliasSD2)->D2_ITEMCC  , Nil } )

_Retorno  := _Linha

RestArea(aArea)

Return(_Retorno)
