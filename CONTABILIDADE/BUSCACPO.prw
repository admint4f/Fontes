#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BUSCACPO º Autor ³Antonio Perinazzo Jrº Data ³  25/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para buscar a natureza correta do titulo          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BUSCACPO(_Carteira,_ChaveTit,_Documen,_TipoTit,_Campo,_Devolver,_ADTFORCLI)
	Local aArea      := GetArea()
	Local _aAreaSE1  := SE1->(GetArea())
	Local _aAreaSE2  := SE2->(GetArea())
	Local _Retorno   := ""
	Local _tamanho   := 0

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
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
		Case _Carteira == "R" .AND. Trim(_TipoTit) $ "RA/NCC" .and. !(TRIM(_Devolver) $ "RA/NCC") 
		// Estou posicionado no RA ou NCC e é para devolver os dados da NF,ETC.

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_Documen,1,_Tamanho))

		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))

		Case _Carteira == "R" .AND. Trim(_TipoTit) $ "RA/NCC" .and. TRIM(_Devolver) $ "RA/NCC"
		// Estou posicionado no RA ou NCC e é para devolver os dados da RA/NCC.

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_ChaveTit,3,_Tamanho))
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))

		Case _Carteira == "R" .AND. !(Trim(_TipoTit) $ "RA/NCC") .and. !TRIM(_Devolver) $ "RA/NCC"
		// Estou posicionado nos titulos de NF,etc. e é para devolver os dados da NF,etc.

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_ChaveTit,3,_Tamanho))
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))

		Case _Carteira == "R" .AND. !(Trim(_TipoTit) $ "RA/NCC") .and. (TRIM(_Devolver) $ "RA/NCC")
		// Estou posicionado nos titulos de NF,etc. e é para devolver os dados da RA/NCC.

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_Documen,1,_Tamanho))

		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))

		Case _Carteira == "P" .AND. Trim(_TipoTit) $ "PA/NDF" .and. !(TRIM(_Devolver) $ "PA/NDF") 
		// Estou posicionado no RA ou NCC e é para devolver os dados da NF,ETC.

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SUBSTR(_Documen,1,_Tamanho)+_ADTFORCLI)

		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))

		Case _Carteira == "P" .AND. Trim(_TipoTit) $ "PA/NDF" .and. (TRIM(_Devolver) $ "PA/NDF") 
		// Estou posicionado no PA ou NDF e é para devolver os dados da PA/NDF.

		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))

		Case _Carteira == "P" .AND. !(Trim(_TipoTit) $ "PA/NDF") .and. !(TRIM(_Devolver) $ "PA/NDF") 
		// Estou posicionado nos titulos de NF,etc. e é para devolver os dados da NF,etc.

		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))

		Case _Carteira == "P" .AND. !(Trim(_TipoTit) $ "PA/NDF") .and. (TRIM(_Devolver) $ "PA/NDF")
		// Estou posicionado nos titulos de NF,etc. e é para devolver os dados da RA/NCC.

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SUBSTR(_Documen,1,_Tamanho)+_ADTFORCLI)

		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))

		OtherWise
		_Retorno := "Ver conta"
	EndCase

	RestArea(_aAreaSE1)
	RestArea(_aAreaSE2)
	RestArea(aArea)

Return(_Retorno)
