#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#Include	"PROTHEUS.CH"
#Define		GETF_LOCALHARD		16
#Define		GETF_RETDIRECTORY	128


/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
//	{Protheus.doc} 			 												//	
//																			//
// 	Programa ...: T4FR002                            Modulo : SIGAFAT       //
//                                                                          //
//  Relat�rio de notas fiscais com localizador INTI para concilia��o CTB    //
//a outro banco de dados **													//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rog�rio Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	27/01/2022												//	
//                                                                          //
/*////////////////////////////////////////////////////////////////////////////

User Function T4FR002()

	Local cTit	:= "Relat�rio de notas fiscais de saida"
	Local aSay	:= {}
	Local aBut	:= {}
	Local cPerg	:= "T4FR002"
	Local nOpc	:= 0

	// Cria as perguntas do relat�rio
	Pergunte(cPerg,.T.)

	// monta tela de interacao com usuario
	aAdd(aSay, "Este programa gera o relat�rio de notas fiscais em Excel,")
	aAdd(aSay, "conforme par�metros informados pelo usu�rio.")

	// cria botoes
	aAdd(aBut, {5, .T., {|| Pergunte(cPerg, .T.)} })
	aAdd(aBut, {1, .T., {|| nOpc := 1, FechaBatch()} })
	aAdd(aBut, {2, .T., {|| FechaBatch()} })

	// tela
	FormBatch(cTit, aSay, aBut)

	If nOpc == 1
		Processa({|lFim| GeraCSV(@lFim) }, NIL, NIL, .T.)
	EndIf

Return

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
//	{Protheus.doc} 			 												//	
//																			//
// 	Fun��o......: GERACSV                            Modulo : SIGAFAT       //
//                                                                          //
//  Funcao chamada pelo programa, indica cancelamento do processamento		//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rog�rio Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	27/01/2022												//	
//                                                                          //
/*////////////////////////////////////////////////////////////////////////////

Static Function GeraCSV(lFim)
	Local cQuery		:= ""
	Local cEOL		:= Chr(13) + Chr(10)
	Local cNomLoc	:= ""
	Local cDirDoc	:= msDocPath()
	Local cArq		:= CriaTrab(NIL, .F.) + ".csv"
	Local nHdl		:= 0
	Local cTxt		:= ""
	Local cAlias	:= GetNextAlias()

	ProcRegua(0)

// verifica se o Excel existe
	If !apOleClient("MsExcel")
		msgStop("Excel n�o instalado.", "t4fr002.PRW - " + StrZero(ProcLine(0), 5))
		Return
	EndIf

// cria arquivo csv
	nHdl	:= fCreate(cDirDoc + "\" + cArq)

	If nHdl < 0
		msgStop("N�o foi poss�vel criar o arquivo de sa�da.", "t4fr002.PRW - " + StrZero(ProcLine(0), 5))
		Return
	EndIf


// grava cabecalho
	cTxt	:= "Data Emissao;"
	cTxt	+= "Quantidade;"
	cTxt	+= "Vlr.Unitario;"
	cTxt	+= "Vlr.Total;"
	cTxt	+= "EPEP;"
	cTxt	+= "Desc.Epep;"
	cTxt	+= "Cod.Produto;"
	cTxt	+= "Descricao;"
	cTxt	+= "Conta Ctb.;"
	cTxt	+= "Desc.Conta;"
	cTxt	+= "Nota Fiscal;"
	cTxt	+= "Serie;"
	cTxt	+= "Localizador;""
	cTxt	+= "Transmitido;"
	cTxt	+= "Data Contab." + cEOL


	fWrite(nHdl, cTxt, Len(cTxt))

// cria consulta
	cQuery := " SELECT DISTINCT D2_ITEM, D2_EMISSAO DT, D2_QUANT QTD, D2_PRCVEN VLR_UNIT, D2_TOTAL VLR_TOT, "+CRLF
	cQuery += " D2_ITEMCC EPEP, CTD_DESC01 DESC_EPEP, D2_COD PRODUTO, B1_DESC DESC_PROD, B1_CONTA CONTA, CT1_DESC01 DESC_CONTA, "+CRLF
	cQuery += " D2_DOC NOTA, D2_SERIE SERIE, ZAD_SEARCH LOCALIZADOR, F3_NFELETR TRANSMITIDO, F3_CODNFE CODNFE, F2_DTLANC DTLANC "+CRLF
	cQuery += " FROM " + RETSQLNAME("ZAD") + " ZAD, " + RETSQLNAME("SB1") + " SB1, " +RETSQLNAME("CT1") + " CT1," + RETSQLNAME("CTD") + " CTD, " + RETSQLNAME("SF2")+ " SF2, " + RETSQLNAME("SD2") + " SD2 LEFT JOIN "+RETSQLNAME("SF3") + " SF3 "+CRLF
	cQuery += " ON D2_DOC = F3_NFISCAL "+CRLF
	cQuery += " AND D2_SERIE = F3_SERIE "+CRLF
	cQuery += " AND SF3.D_E_L_E_T_ =' ' "+CRLF
	cQuery += " WHERE D2_FILIAL = ZAD_FILIAL "+CRLF
	cQuery += " AND D2_LOCAL <> ' ' "+CRLF
	cQuery += " AND D2_COD = B1_COD "+CRLF
	cQuery += " AND D2_SERIE IN ('I  ','S  ') "+CRLF
	cQuery += " AND D2_SERIE = ZAD_SETOTV  "+CRLF
	cQuery += " AND D2_SERIE = F2_SERIE  "+CRLF
	cQuery += " AND D2_DOC = ZAD_NFTOTV  "+CRLF
	cQuery += " AND D2_DOC = F2_DOC "+CRLF
	cQuery += " AND D2_CLIENTE = F2_CLIENTE "+CRLF
	cQuery += " AND D2_LOJA =F2_LOJA "+CRLF
	
	cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "+CRLF
	
	If !Empty(MV_PAR03)
		cQuery += " AND ZAD_EPEP = '"+MV_PAR03 +"'" +CRLF
	EndIf

	If !Empty(MV_PAR04)
		cQuery += " AND ZAD_SEARCH = '"+MV_PAR04 +"'" +CRLF
	EndIf

	cQuery += " AND ZAD_EPEP = CTD_ITEM "+CRLF
	cQuery += " AND B1_CONTA = CT1_CONTA "+CRLF
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND SF2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND ZAD.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND CT1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND CTD.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " ORDER BY D2_EMISSAO, D2_SERIE, D2_DOC "+CRLF

	//dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "(cAlias)", .T., .T.)
	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cAlias,.T.,.T.)

	dbSelectArea(cAlias)

	(cAlias)->(dbGoTop())

	//Irei percorrer todos os meus registros
	While !(cAlias)->(Eof())

		IncProc("Imprimindo...")

		If lFim
			Exit
		EndIf

		// grava informacoes
		cTxt := DTOC(STOD((cAlias)->DT)) + ";"
		cTxt += STR((cAlias)->QTD) + ";"
		cTxt += Alltrim(Transform((cAlias)->VLR_UNIT,"@E 999,999.99")) + ";"
		cTxt += Alltrim(Transform((cAlias)->VLR_TOT,"@E 999,999.99")) + ";"
		cTxt += (cAlias)->EPEP+ ";"
		cTxt += (cAlias)->DESC_EPEP+ ";"
		cTxt += (cAlias)->PRODUTO+ ";"
		cTxt += (cAlias)->DESC_PROD+ ";"
		cTxt += (cAlias)->CONTA+ ";"
		cTxt += (cAlias)->DESC_CONTA+ ";"
		cTxt += (cAlias)->NOTA+ ";"
		cTxt += (cAlias)->SERIE+ ";"
		cTxt += (cAlias)->LOCALIZADOR+ ";"

		If Empty((cAlias)->TRANSMITIDO)
			cStatus := 'N'
		Else
			cStatus := 'S'
		EndIf

		cTxt += cStatus+ ";"

		cTxt += DTOC(STOD((cAlias)->DTLANC))+ ";"

		cTxt	+= cEOL

		fWrite(nHdl, cTxt, Len(cTxt))

		(cAlias)->(DbSkip())
	End

	(cAlias)->(dbCloseArea())

// fecha arquivo
	fClose(nHdl)

	If !lFim
		// pergunta onde gravar o arquivo no cliente
		cNomLoc	:= MV_PAR05//cGetFile("Arquivos csv (*.csv)|*.csv", "Salvar arquivo", 1, "\", .F., nOr(GETF_LOCALHARD,GETF_RETDIRECTORY), .F., .F.)

		If !Empty(cNomLoc)
			If Right(cNomLoc, 1) <> "\"
				nPos	:= rAt("\", cNomLoc)

				If nPos > 0
					cNomLoc	:= Left(cNomLoc, nPos)
				EndIf
			EndIf

			// copia csv para o cliente
			CpyS2T(cDirDoc + "\" + cArq, cNomLoc)

			// abre Excel
			oExcApp	:= msExcel():New()
			oExcApp:WorkBooks:Open(cNomLoc + "\" + cArq)
			oExcApp:SetVisible(.T.)
		EndIf
	EndIf

// apaga arquivo no servidor
	If File(cDirDoc + "\" + cArq)
		fErase(cDirDoc + "\" + cArq)
	EndIf

Return



