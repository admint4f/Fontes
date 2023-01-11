#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120LOK  ºAutor  ³Microsiga           º Data ³  03/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validações na inclusão/alteração PC                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120LOK()
Local lRet		:= .T.
Local aArea		:= GetArea()
Local nPosCC	:= aScan(aHeader,{|x| Alltrim(x[2])=="C7_CC"})
Local nPosCCAp	:= aScan(aHeader,{|x| Alltrim(x[2])=="C7_XCCAPR"})
Local nPosRat	:= aScan(aHeader,{|x| Alltrim(x[2])=="C7_RATEIO"})
Local cCC		:= ""

//Checa se é linha deletada
If aCols[n][ len(aCols[n]) ]
	Return lRet
EndIf

If Empty(aCols[n][nPosCC])
	If aCols[n][nPosRat] == "1"
		If Empty(aCols[n][nPosCCAp])
			MsgAlert("O item possui rateio, e campo C.Custo Aprov. está em branco. Verifique.")
			lRet	:= .F.
		EndIf
	Else
		MsgAlert("O campo C.Custo é obrigatorio. Verifique.")
		lRet	:= .F.
	EndIf
EndIf
//Validação para verificar se é PA eestão preenchidos campos Valor e Data de Vencimento

If  _cGeraPA == "2"
	If Empty(_nValPA)
		MsgAlert("Foi informado que será gerado Sol.PA porém campo de Valor PA está em branco. Verifique")
		lRet := .F.
	EndIf
	
	If Empty(_dVencPA)
		MsgAlert("Foi informado que será gerado Sol.PA porém campo de Vencto. PA está em branco. Verifique")
		lRet := .F.
	EndIf
endif

//Validações de campos que nao podem ser diferentes nas linhas   - C.Custo
If n == 1
	If Len(aCols) > 1
		If !( aCols[1][nPosCCAp] == aCols[2][nPosCCAp] )
			MsgAlert("O campo C.Custo Aprov. não pode ser diferente nos itens.")
			lRet	:= .F.
		EndIf
	EndIf
Else
	If !( aCols[1][nPosCCAp] == aCols[n][nPosCCAp] )
		MsgAlert("O campo C.Custo Aprov. não pode ser diferente nos itens.")
		lRet	:= .F.
	EndIf
EndIf

Return lRet
