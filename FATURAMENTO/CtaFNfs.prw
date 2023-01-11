#include "Protheus.CH"
#include "TopConn.Ch"
#include "RwMake.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtaCNfs  º Autor ³Antonio Perinazzo Jrº Data ³  16/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para buscar a conta do Cliente NF Saida           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4f                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CtaFNfs(_CondPag,_ContaPadrao)
Local aArea      := GetArea()
Local aAreaSF2   := SF2->(GetArea())
Local aAreaSE4   := SE4->(GetArea())
Local aAreaSED   := SED->(GetArea())
Local aAreaSE2   := SE2->(GetArea())
Local aAreaSE1   := SE1->(GetArea())
Local _Retorno   := "VERIFICAR"
Local _Permuta   := .f.
Local _Rotina    := FunName()
Local _Prefixo   := SF2->F2_PREFIXO
Local _Numero    := SF2->F2_DUPL
Local _Tipo      := SF2->F2_TIPO
Local _Cliente   := SF2->F2_CLIENTE
Local _Loja      := SF2->F2_LOJA
Local _Natureza  := "" 

DbSelectArea("SF2")

If !Empty(_CondPag)
	_Permuta := .f.
	DbSelectArea("SE4")
	DbSetOrder(1)
	DbSeek(xFilial("SE4")+_CondPag)
	If !Eof()
		_Permuta := Iif(SE4->E4_PERMUTA=="S",.T.,.F.)
	EndIf
	
	If _Permuta
		_cFilial := "  "//xFilial("SE2")
		_Chave := _cFilial+_Cliente+_Loja+sd2->d2_filial+left(sd2->d2_serie,1)+sd2->d2_doc//_Prefixo+_Numero
		If _Tipo $ "DB" // SE FOR NOTA DE ENTRADA COM FORNECEDOR
			DbSelectArea("SE2")
			DbSetOrder(6)
			DbSeek(_Chave)
			If !Eof()
				_Natureza := SE2->E2_NATUREZ
			EndIf
			
		Else
			// SE FOR NOTA FISCAL DE ENTRADA COM CLIENTE
//			_Chave := xFilial("SE1")+_Cliente+_Loja+_Prefixo+_Numero
			DbSelectArea("SE1")
			DbSetOrder(2)
			DbSeek(_Chave)
			If !Eof()
				_Natureza := SE1->E1_NATUREZ      
			Else
				_Natureza := "500100    "//"VERIFICAR"  // Substituído por Luiz Eduardo em 17/10/2019 pois o título ainda não está gerado nesse momento
			EndIf
		EndIf
		DbSelectArea("SED")
		DbSetOrder(1)
		DbSeek(xFilial("SED")+_Natureza)
		If !Eof()
			_Retorno := SED->ED_DEBITO
		Else
			_Natureza := "500100    "//"VERIFICAR"
//			_Retorno := "VERIFICAR"
		EndIF
	
	Else
		_Retorno := _ContaPadrao
	EndIF
EndIf

RestArea(aAreaSED)
RestArea(aAreaSE4)
RestArea(aAreaSF2)
RestArea(aAreaSE1)
RestArea(aAreaSE2)
RestArea(aArea)

Return(_Retorno)
