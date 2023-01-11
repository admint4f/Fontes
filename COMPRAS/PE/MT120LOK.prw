#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120LOK  �Autor  �Microsiga           � Data �  03/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��es na inclus�o/altera��o PC                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT120LOK()
Local lRet		:= .T.
Local aArea		:= GetArea()
Local nPosCC	:= aScan(aHeader,{|x| Alltrim(x[2])=="C7_CC"})
Local nPosCCAp	:= aScan(aHeader,{|x| Alltrim(x[2])=="C7_XCCAPR"})
Local nPosRat	:= aScan(aHeader,{|x| Alltrim(x[2])=="C7_RATEIO"})
Local cCC		:= ""

//Checa se � linha deletada
If aCols[n][ len(aCols[n]) ]
	Return lRet
EndIf

If Empty(aCols[n][nPosCC])
	If aCols[n][nPosRat] == "1"
		If Empty(aCols[n][nPosCCAp])
			MsgAlert("O item possui rateio, e campo C.Custo Aprov. est� em branco. Verifique.")
			lRet	:= .F.
		EndIf
	Else
		MsgAlert("O campo C.Custo � obrigatorio. Verifique.")
		lRet	:= .F.
	EndIf
EndIf
//Valida��o para verificar se � PA eest�o preenchidos campos Valor e Data de Vencimento

If  _cGeraPA == "2"
	If Empty(_nValPA)
		MsgAlert("Foi informado que ser� gerado Sol.PA por�m campo de Valor PA est� em branco. Verifique")
		lRet := .F.
	EndIf
	
	If Empty(_dVencPA)
		MsgAlert("Foi informado que ser� gerado Sol.PA por�m campo de Vencto. PA est� em branco. Verifique")
		lRet := .F.
	EndIf
endif

//Valida��es de campos que nao podem ser diferentes nas linhas   - C.Custo
If n == 1
	If Len(aCols) > 1
		If !( aCols[1][nPosCCAp] == aCols[2][nPosCCAp] )
			MsgAlert("O campo C.Custo Aprov. n�o pode ser diferente nos itens.")
			lRet	:= .F.
		EndIf
	EndIf
Else
	If !( aCols[1][nPosCCAp] == aCols[n][nPosCCAp] )
		MsgAlert("O campo C.Custo Aprov. n�o pode ser diferente nos itens.")
		lRet	:= .F.
	EndIf
EndIf

Return lRet
