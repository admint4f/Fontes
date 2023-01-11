#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103IP2  ºAutor  ³Luiz Eduardo        º Data ³  18/07/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na Validacao da TES Pessoa Física                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100LOK
/*
//Local lRet:= .t.
Local lRet := ParamIxb[1]
Local _Rotina := FunName()
Local _x      := 0
Local _TES    := ""
local _nPosTes	  := aScan(aHeader, { |x| Alltrim(x[2]) == "D1_TES"})
Local  nPosTES := GDFIELDPOS("D1_TES")

if	Trim(Upper(_Rotina)) $ "MATA103/MATA100/CALL103" .and. sa2->a2_tipo="F"
	
	If lRet .And. Len(aCols) > 0
		
		For _x := 1 To Len(aCols)
			
			// Verifica se a linha esta deletada
			// Verifica tambem se os campos D1_TES e D1_NATUREZ existem.
			_TES     := aCols[_x,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES" })]
			_ePEP    := aCols[_x,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEMCTA" })]
			
			If !GdDeleted(_x) //.And. GdFieldPos("D1_TES",_x) > 0
				
				//				_TES    := aCols[ _x , AScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES" }) ]
				// Luiz Tapajós 18.07.2019 - Bloquear inclusao se informacoes da TES incompatíveis com Pessoa Fisica
				_Regra := Posicione("SF4",1,xFilial("SF4")+_TES,"F4_REGRA")
				//				If _Regra<>"08" .and. sa2->a2_tipo="F" //Empty(cA100For) .Or. Empty(cLoja)
				If sa2->a2_tipo="F" //Empty(cA100For) .Or. Empty(cLoja)
					//Recalculo dos Impostos
					if cEspecie='RPA'
						// Para RPA o sistema deverá trazer a TES 063 para cálculo de impostos
					If _Regra<>"08" .and. _TES<>"063" .and. sa2->a2_tipo="F" //Empty(cA100For) .Or. Empty(cLoja)
						For nx := 1 To Len(aCols) //.and. _TES<>"063"
							aCols[nx][nPosTES] := '063'
						Next
					EndIf

					//	aCols[_x,_nPosTes] := "063"
					else
						//Caso tenha Elemento PEP será custo (TES 181) caso contrário será despesa (TES 182)
						If _Regra<>"08"
							if !empty(_Epep)
								aCols[_x,_nPosTes] := "181"
							else
								aCols[_x,_nPosTes] := "182"
							endif
						endif
					Endif
					//					MsgAlert("Fornecedor "+SA2->A2_COD+" Pessoa física , a TES informada não poderá ser utilizada")
					//					lRet := .F.
				EndIf
			EndIf
		Next _x
	EndIf
EndIf
IF !lRet
	Return lRet
Endif*/

Return .t.
