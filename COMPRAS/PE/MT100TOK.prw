/**************************************************************************************
.Programa  : MT100TOK
.Autor     : Jose Carlos S. Veloso Junior
.Data      : 07/01/03
.Descricao : Ponto de entrada para verificar se o total da nota bate com o informado pelo usuario
**************************************************************************************/
User Function MT100TOK()

Local lRet:= .t.
//Local _Rotina := FunName()
//Local _x      := 0
//Local _Valida := .F.
//Local _TES    := ""
/*
	If Trim(Upper(_Rotina)) $ "MATA103/MATA100/CALL103" .and. sa2->a2_tipo="F"
		If lRet .And. Len(aCols) > 0
			For _x := 1 To Len(aCols)
			// Verifica se a linha esta deletada
			// Verifica tambem se os campos D1_TES e D1_NATUREZ existem.
				If !GdDeleted(_x) .And. GdFieldPos("D1_TES",aCols) > 0 .And. GdFieldPos("D1_NATUREZ",aCols) > 0
				_TES    := aCols[ _x , AScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES" }) ]
				// Luiz Tapaj๓s 18.07.2019 - Bloquear inclusao se informacoes da TES incompatํveis com Pessoa Fisica
				_Regra := Posicione("SF4",1,xFilial("SF4")+_TES,"F4_REGRA")
					If _Regra<>"08" .and. sa2->a2_tipo="F" //Empty(cA100For) .Or. Empty(cLoja)
						MsgAlert("Fornecedor "+SA2->A2_COD+" Pessoa fํsica , a TES informada nใo poderแ ser utilizada","Mensagem de aviso")
					lRet := .F.
					EndIf
				EndIf
			Next _x
		EndIf
	EndIf
	IF !lRet
		Return lRet
	Endif
*/
// Gsabino 29.08.2018 - Bloquear inclusao se informacoes de Cod Retencao e do Municipio do ISS nao forem preenchidos
// Verifica se nใo estแ sendo feito pelo V360
	If  (MaFisRet(,"NF_BASEDUP") > 0 .AND. (Type("_lv360call") == 'U' .OR. _lv360call == .F.))   //.And. !Empty(MaFisRet(,"NF_NATUREZA"))
		IF Empty(MaFisRet(,"NF_NATUREZA"))
			ALERT("Natureza nao foi informado !")
			lRet := .F.
		ENDIF

		IF MaFisRet(,"NF_VALIRR") > 0 .AND. Empty(cCodRet)
			ALERT("TEM IR e nao foi informado a reten็ใo !")
			lRet := .F.
		ENDIF

		IF MaFisRet(,"NF_VALISS") > 0 .and. EMPTY(cFornIss)
			IF MaFisRet(,"NF_RECISS") = "2"
				ALERT("TEM ISS e nao foi informado a Prefeitura para Pagamento do ISS !")
				lRet := .F.
			ENDIF
		ENDIF
	EndIf
	IF !lRet
		Return lRet
	Endif
	
// Altera o numero da nota fiscal, incluindo zeros เ esquerda do n๚mero
// Luiz Eduardo - 23/03/2017
cNFiscal := strzero(val(cNFiscal),9)
/*
	If Alltrim( GetMV("T4F_VLDNFE") ) == "2" // Nova
	lRet:= VldSecNFE(_Rotina)
	Else
	lRet:= VldOneNFE(_Rotina)// Antiga
	Endif
*/	If __cuserid $ '000000'
	
	lRet:= .t.
	EndIf

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT100TOK  บAutor  ณMicrosiga           บ Data ณ  03/19/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/**************************************************************************************
.Programa  : MT100TOK
.Autor     : Jose Carlos S. Veloso Junior
.Data      : 07/01/03
.Descricao : Ponto de entrada para verificar se o total da nota bate com o informado pelo usuario
**************************************************************************************/
/*
Static Function VldOneNFE(_Rotina)

Local lRet    := .T.
//Local _x      := 0
Local _Valida := .F.
//Local _TES    := ""
//Local _NATUREZ:= ""
//Local _Financ := "N"

	If Alltrim(cTipo) <> "N"
	_Valida := .T.
	Return(lRet)
	Endif

	If Trim(Upper(_Rotina)) $ "MATA103/MATA100/CALL103"
	_Valida := .t.
	EndIf

	If _Valida .And. Type("_CIENFETOT") <> "U"
		If _CIENFETOT != MAFISRET(,"NF_TOTAL")
		lRet := .f.
		MsgAlert("Total da NFE diverge com o valor informado! Valor Informado: " + AllTrim(Str(_CIENFETOT)),"Mensagem de aviso")
		Endif
	EndIf
*/
// Alterado 20/02/13 Luis Dantas - desabilitada valida็ใo de natureza por item da NF
/*
	For _x := 1 To Len(aCols)
_TES     := aCols[_x,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES" })]
_Financ  := Posicione("SF4",1,xFilial("SF4")+_TES,"F4_DUPLIC")

_Naturez := aCols[_X,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_NATUREZ" })]

		If _Financ == "S" .And. Empty(_Naturez)
MsgStop("Favor informar a Natureza financeira.")
lRet := .F.
		EndIf

	Next _x


//Return(lRet)
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT100TOK  บAutor  ณMicrosiga           บ Data ณ  03/19/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function VldSecNFE(_Rotina)

	Local lRet    := .T.
	Local _x      := 0
	Local _Valida := .F.
	Local _TES    := ""
	Local _NATUREZ:= ""
	Local _Financ := "N"

// Se a NF for diferente de Normal entao retorna daqui mesmo.
	If Alltrim(cTipo) <> "N"
		_Valida := .T.
		Return(lRet)
	Endif

	If Trim(Upper(_Rotina)) $ "MATA103/MATA100/CALL103"

		// Se a variavel publica existe, entao consiste o valor total.
		If Type("_CIENFETOT") <> "U"

			If _CIENFETOT != MAFISRET(,"NF_TOTAL")
				lRet := .f.
				MsgAlert("Total da NFE diverge com o valor informado! Valor Informado: " + AllTrim(Str(_CIENFETOT)),"Mensagem de aviso" )
			Endif

		Endif

		// Se nao parou anteriormente (lRet = .f.) entao verifica a aCols.
		If lRet .And. Len(aCols) > 0

			For _x := 1 To Len(aCols)

				// Verifica se a linha esta deletada
				// Verifica tambem se os campos D1_TES e D1_NATUREZ existem.
				If !GdDeleted(_x) .And. GdFieldPos("D1_TES",_x) > 0 .And. GdFieldPos("D1_NATUREZ",_x) > 0

					_TES    := aCols[ _x , AScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES" }) ]
					_Financ := Posicione("SF4",1,xFilial("SF4")+_TES,"F4_DUPLIC")
					_Naturez:= aCols[ _x , AScan(aHeader,{|x| AllTrim(x[2]) == "D1_NATUREZ" })]

					// Luiz Tapaj๓s 18.07.2019 - Bloquear inclusao se informacoes da TES incompatํveis com Pessoa Fisica
					dbSelectArea("SF4")
					dbSeek(xFilial()+_TES)
					If sf4->f4_regra<>"08" .and. sa2->a2_tipo="F" //Empty(cA100For) .Or. Empty(cLoja)
						MsgAlert("Fornecedor Pessoa fํsica , a TES informada nใo poderแ ser utilizada","Mensagem de aviso")
						lRet := .F.
					EndIf

					If _Financ == "S" .And. Empty(_Naturez)
						ApMsgStop("Favor informar a Natureza financeira.")
						lRet := .F.
					EndIf

				EndIf

			Next _x

		EndIf

	EndIf

Return(lRet)
*/
