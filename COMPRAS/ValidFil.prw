#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidFil  �Autor  �Sergio Celestino    � Data �  03/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validar a Filial de Entrega do Item do PC com a filial de   ���
���          �entrega da SC                                               ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ValidFil()

Local nPos_SC := AScan(aHeader, { |x| Upper(Alltrim(x[2])) == 'C7_NUMSC'  })
Local nPos_IT := AScan(aHeader, { |x| Upper(Alltrim(x[2])) == 'C7_ITEMSC' })
Local lRet    := .T.

DbSelectArea("SC1")
DbSetOrder(1)
If DbSeek(xFilial("SC1") + aCols[n][nPos_SC] + aCols[n][nPos_IT] )
   IF Alltrim(SC1->C1_FILENT) <> Alltrim(M->C7_FILENT)
      Alert("A Filial de Entrega da SC n�o confere com a informada.Verifique!!!")  
      lRet := .F.
   Endif
Elseif !Empty(aCols[n][nPos_SC])
  Alert("Solicita��o de Compras n�o encontrada!!!")
Endif

Return lRet