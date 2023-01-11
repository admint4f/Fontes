#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COMPNAT  º Autor ³Antonio Perinazzo Jrº Data ³  19/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para buscar a natureza correta do titulo          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function COMPNAT(_Carteira,_ChaveTit,_Documen,_Ret_NAT_OU_CLI,_TipoTit,_ADTFORCLI,_Lista)
	Local aArea      := GetArea()
	Local _aAreaSE1  := SE1->(GetArea())
	Local _aAreaSE2  := SE2->(GetArea())
	Local _aAreaSED  := SED->(GetArea())
	Local _Retorno   := ""
	Local _tamanho   := 0
	Local _Mostra    := Iif(_Lista==Nil,.F.,.T.)

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	DbSelectARea("SX3")
	DbSetOrder(2)
	If DbSeek("E5_PREFIXO")
		_Tamanho += SX3->X3_TAMANHO
	EndIf

	DbSelectARea("SX3")
	DbSetOrder(2)
	If DbSeek("E5_NUMERO")
		_Tamanho += SX3->X3_TAMANHO
	EndIf

	DbSelectARea("SX3")
	DbSetOrder(2)
	If DbSeek("E5_PARCELA")
		_Tamanho += SX3->X3_TAMANHO
	EndIf

	DbSelectARea("SX3")
	DbSetOrder(2)
	iF DbSeek("E5_TIPO ")
		_Tamanho += SX3->X3_TAMANHO
	EndIf
	*/
	
	_Tamanho += GetSX3Cache("E5_PREFIXO"	,"X3_TAMANHO")
	_Tamanho += GetSX3Cache("E5_NUMERO"		,"X3_TAMANHO")
	_Tamanho += GetSX3Cache("E5_PARCELA"	,"X3_TAMANHO")
	_Tamanho += GetSX3Cache("E5_TIPO"		,"X3_TAMANHO")
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	
	Do Case
		Case _Carteira == "R" .AND. Trim(_TipoTit) $ "RA/NCC" .AND. Trim(_Ret_NAT_OU_CLI) $ "CLI"

		If _Mostra	
			MsgStop("R 1 COMPNAT-"+_tipotit+"-"+_Ret_NAT_OU_CLI)
		EndIf

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SubStr(_Documen,1,_Tamanho)+_ADTFORCLI)

		If POSICIONE("SED",1,XFILIAL("SED")+SE1->E1_NATUREZ,"ED_PERMUTA") == "S"
			_Retorno := POSICIONE("SED",1,XFILIAL("SED")+SE1->E1_NATUREZ,"ED_CONTA")
		Else
			_Retorno := POSICIONE("SA1",1,XFILIAL("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_CONTA")
		EndIf

		Case _Carteira == "R" .AND. Trim(_TipoTit) $ "RA/NCC" .AND. Trim(_Ret_NAT_OU_CLI) $ "NAT"
		If _Mostra	
			MsgStop("R 2 COMPNAT-"+_tipotit+"-"+_Ret_NAT_OU_CLI)
		EndIf

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(SubStr(_ChaveTit,1,_Tamanho+2)+_ADTFORCLI)

		_Retorno := SE1->E1_CCONTAB //POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA")

		Case _Carteira == "R" .AND. !(Trim(_TipoTit) $ "RA/NCC") .AND. Trim(_Ret_NAT_OU_CLI) $ "CLI"
		If _Mostra	
			MsgStop("R 3 COMPNAT-"+_tipotit+"-"+_Ret_NAT_OU_CLI)
		EndIf

		If POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_PERMUTA") == "S"
			_Retorno := POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA")
		Else
			_Retorno := POSICIONE("SA1",1,XFILIAL("SA1")+SE5->E5_CLIFOR+SE5->E5_LOJA,"A1_CONTA")
		EndIf

		Case _Carteira == "R" .AND. !(Trim(_TipoTit) $ "RA/NCC") .AND. Trim(_Ret_NAT_OU_CLI) $ "NAT"
		If _Mostra	
			MsgStop("R 4 COMPNAT-"+_tipotit+"-"+_Ret_NAT_OU_CLI)
		EndIf

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SubStr(_Documen,1,_Tamanho)+_ADTFORCLI)

		_Retorno := SE1->E1_CCONTAB //POSICIONE("SED",1,XFILIAL("SED")+POSICIONE("SE1",1,_Documen,"E1_NATUREZ"),"ED_CONTA")

		Case _Carteira == "P" .AND. Trim(_TipoTit) $ "PA/NDF" .AND. Trim(_Ret_NAT_OU_CLI) $ "FOR"

		If _Mostra	
			MsgStop("R 5 COMPNAT-"+_tipotit+"-"+_Ret_NAT_OU_CLI)
		EndIf

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SubStr(_Documen,1,_Tamanho)+_ADTFORCLI)
		If Eof()
			_Retorno := "verificar1"
		Else

			If POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_PERMUTA") == "S"
				_Retorno := POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTA")
			Else
				_Retorno := POSICIONE("SA2",1,XFILIAL("SA1")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CONTA")
			EndIf
		EndIf

		Case _Carteira == "P" .AND. Trim(_TipoTit) $ "PA/NDF" .AND. Trim(_Ret_NAT_OU_CLI) $ "NAT"

		If _Mostra	
			MsgStop("R 6 COMPNAT-"+_tipotit+"-"+_Ret_NAT_OU_CLI)
		EndIf

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(SubStr(_ChaveTit,1,_Tamanho+2)+SE5->E5_CLIFOR+SE5->E5_LOJA)
		If !Eof()
			_Retorno := SE2->E2_CCONTAB  //POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA")
		Else
			_Retorno := "verificar2"
		EndIf

		Case _Carteira == "P" .AND. !(Trim(_TipoTit) $ "PA/NDF") .AND. Trim(_Ret_NAT_OU_CLI) $ "FOR"
		If _Mostra	
			MsgStop("R 7 COMPNAT-"+_tipotit+"-"+_Ret_NAT_OU_CLI)
		EndIf

		If POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_PERMUTA") == "S"
			_Retorno := POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA")
		Else
			_Retorno := POSICIONE("SA2",1,XFILIAL("SA2")+SE5->E5_CLIFOR+SE5->E5_LOJA,"A2_CONTA")
		End

		Case _Carteira == "P" .AND. !(Trim(_TipoTit) $ "PA/NDF") .AND. Trim(_Ret_NAT_OU_CLI) $ "NAT"
		If _Mostra	
			MsgStop("R 8 COMPNAT-"+_tipotit+"-"+_Ret_NAT_OU_CLI)
		EndIf

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SubStr(_Documen,1,_Tamanho)+_ADTFORCLI)
		If Eof()
			_Retorno := "verificar3"
		Else

			//If POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_PERMUTA") == "S"
			//	_Retorno := POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTA")
			//Else
			//	_Retorno := POSICIONE("SA2",1,XFILIAL("SA1")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CONTA")
			//EndIf

			_Retorno := SE2->E2_CCONTAB // POSICIONE("SED",1,XFILIAL("SED")+POSICIONE("SE2",1,_Documen,"E2_NATUREZ"),"ED_CONTA")
		EndIf

		OtherWise
		_Retorno := "Ver conta"
	EndCase

	RestArea(_aAreaSE1)
	RestArea(_aAreaSE2)
	RestArea(_aAreaSED)
	RestArea(aArea)
Return(_Retorno)
