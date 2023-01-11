#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtaFNfe  º Autor ³Antonio Perinazzo Jrº Data ³  16/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para buscar a conta do fornecedor  NF Entrada     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4f                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CtaFNfe(_CondPag,_ContaPadrao)
Local aArea      := GetArea()
Local aAreaSF1   := SF1->(GetArea())
Local aAreaSE4   := SE4->(GetArea())
Local aAreaSED   := SED->(GetArea())
Local _Retorno   := "VERIFICAR"
Local _Permuta   := .f.
Local _Rotina    := FunName()
Local _Prefixo   := SF1->F1_PREFIXO
Local _Numero    := SF1->F1_DUPL
Local _Tipo      := SF1->F1_TIPO
Local _Fornece   := SF1->F1_FORNECE
Local _Loja      := SF1->F1_LOJA
Local _Natureza  := "" 

DbSelectArea("SF1")

If !Empty(_CondPag)
	_Permuta := .f.
	DbSelectArea("SE4")
	DbSetOrder(1)
	DbSeek(xFilial("SE4")+_CondPag)
	If !Eof()
		_Permuta := Iif(SE4->E4_PERMUTA=="S",.T.,.F.)
	EndIf
	
	If _Permuta
		If !(_Tipo $ "DB") // SE FOR NOTA DE ENTRADA COM FORNECEDOR
			_Chave := xFilial("SE2")+_Fornece+_Loja+_Prefixo+_Numero
			DbSelectArea("SE2")
			DbSetOrder(6)
			DbSeek(_Chave)
			If !Eof()
				_Natureza := SE2->E2_NATUREZ
			EndIf
			
		Else
			// SE FOR NOTA FISCAL DE ENTRADA COM CLIENTE
			_Chave := xFilial("SE1")+_Fornece+_Loja+_Prefixo+_Numero
			DbSelectArea("SE1")
			DbSetOrder(2)
			DbSeek(_Chave)
			If !Eof()
				_Natureza := SE1->E1_NATUREZ
			EndIf
		EndIf
		DbSelectArea("SED")
		DbSetOrder(1)
		DbSeek(xFilial("SED")+_Natureza)
		If !Eof()
			_Retorno := SED->ED_DEBITO
		Else
			_Retorno := "VERIFICAR"
		EndIF
	
	Else
		_Retorno := _ContaPadrao
	EndIF
EndIf

RestArea(aAreaSED)
RestArea(aAreaSE4)
RestArea(aAreaSF1)
RestArea(aArea)

Return(_Retorno)
