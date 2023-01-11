#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#Include "PROTHEUS.CH"
#Define	 GETF_LOCALHARD		16
#Define	 GETF_RETDIRECTORY	128


/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
//	{Protheus.doc} 			 												//	
//																			//
// 	Programa ...: T4FR02CT2                            Modulo : SIGAFAT     //
//                                                                          //
//  Relatório de lançamentos contábeis										//
//  Após contabilização das vendas INTI, o relatório padrão ficou 			//  
//  muito lento                                                             //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	23/02/2022												//	
//                                                                          //
/*////////////////////////////////////////////////////////////////////////////

User Function T4FR02CT2()

	Local cTit	:= "Relatório CT2-Lançamentos Contabeis"
	Local aSay	:= {}
	Local aBut	:= {}
	Local cPerg	:= "T4FR02CT2"
	Local nOpc	:= 0

	// Cria as perguntas do relatório
	Pergunte(cPerg,.T.)

	// monta tela de interacao com usuario
	aAdd(aSay, "Este programa gera o relatório de lançamentos contábeis em Excel,")
	aAdd(aSay, "conforme parâmetros informados pelo usuário.")

	// cria botoes
	aAdd(aBut, {5, .T., {|| Pergunte(cPerg, .T.)} })
	aAdd(aBut, {1, .T., {|| nOpc := 1, FechaBatch()} })
	aAdd(aBut, {2, .T., {|| FechaBatch()} })

	// tela
	FormBatch(cTit, aSay, aBut)

	If nOpc == 1
		Processa({|lFim| GrCSVCT2(@lFim) }, NIL, NIL, .T.)
	EndIf

Return

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
//	{Protheus.doc} 			 												//	
//																			//
// 	Função......: GrCSVCT2                         Modulo : SIGACTB         //
//                                                                          //
//  Funcao chamada pelo programa, indica cancelamento do processamento		//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	24/02/2022												//	
//                                                                          //
/*////////////////////////////////////////////////////////////////////////////

Static Function GrCSVCT2(lFim)
	Local cQuery	:= ""
	Local cEOL		:= Chr(13) + Chr(10)
	Local cNomLoc	:= ""
	Local cDirDoc	:= msDocPath()
	Local cArq		:= "CT2"+Alltrim(cEmpAnt)+".csv"//CriaTrab(NIL, .F.) + ".csv"
	Local nHdl		:= 0
	Local cTxt		:= ""
	Local cAlias	:= GetNextAlias()

	ProcRegua(0)

// verifica se o Excel existe
	If !apOleClient("MsExcel")
		msgStop("Excel não instalado.", "t4fr02ct2.PRW - " + StrZero(ProcLine(0), 5))
		Return
	EndIf

// cria arquivo csv
	nHdl	:= fCreate(cDirDoc + "\" + cArq)

	If nHdl < 0
		msgStop("Não foi possível criar o arquivo de saída.", "t4fr02ct2.PRW - " + StrZero(ProcLine(0), 5))
		Return
	EndIf


// grava cabecalho
	cTxt	:= "Data;"
	cTxt	+= "Conta Contabil;"
	cTxt	+= "Valor;"
	cTxt	+= "Histórico;"
	cTxt	+= "Centro de Custo;"
	cTxt	+= "Elemento PEP;"
	cTxt	+= "Fornecedor;"
	cTxt	+= "Ped.Compra" + cEOL


	fWrite(nHdl, cTxt, Len(cTxt))

	// cria consulta
	cQuery := "	 SELECT CT2_DATA, TRIM(CT2_DEBITO) CONTA, CT2_VALOR, 		" 		+ CRLF
	cQuery += " 	 TRIM(CT2_HIST) CT2_HIST, CT2_CCD, 		" 		+ CRLF
	cQuery += " 	 CT2_ITEMD CT2_ITEMD, CT2_CODFOR, CT2_XPEDCO 		" 		+ CRLF
	cQuery += " 	 FROM "+RetSqlName('CT2') + " CT2 						"		+ CRLF
	cQuery += " 	 WHERE CT2_FILIAL = '"+xFilial("CT2")+"'				" 		+ CRLF
	cQuery += " 	 AND CT2_DATA BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"'" 	+ CRLF

	If !Empty(MV_PAR03)
		cQuery += " AND CT2_LOTE = '"+ MV_PAR03 +"'" 						        + CRLF
	EndIf

	cQuery += " 	 AND CT2_DEBITO BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"'" 	+ CRLF
	cQuery += " 	 AND CT2_TPSALD ='1' 									" 		+ CRLF
	cQuery += " 	 AND D_E_L_E_T_ = ' ' 									" 		+ CRLF
	cQuery += " 	UNION 													" 		+ CRLF
	cQuery += " 	 SELECT CT2_DATA, TRIM(CT2_CREDIT) CONTA,  				" 		+ CRLF
	cQuery += " 	 (CT2_VALOR*-1),										" 		+ CRLF
	cQuery += " 	 TRIM(CT2_HIST) CT2_HIST, CT2_CCD CT2_CCD, 		" 		+ CRLF
	cQuery += " 	 CT2_ITEMD CT2_ITEMD,CT2_CODFOR, CT2_XPEDCO 		" 		+ CRLF
	cQuery += " 	 FROM "+RetSqlName('CT2') + " CT2						" 		+ CRLF
	cQuery += " 	 WHERE CT2_FILIAL = '"+xFilial("CT2")+"'				" 		+ CRLF
	cQuery += " 	 AND CT2_DATA BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"'" 	+ CRLF

	If !Empty(MV_PAR03)
		cQuery += " AND CT2_LOTE = '"+ MV_PAR03 +"'" 						        + CRLF
	EndIf

	cQuery += " 	 AND CT2_CREDIT BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"'" 	+ CRLF
	cQuery += " 	 AND CT2_TPSALD ='1' 									" 		+ CRLF
	cQuery += " 	 AND D_E_L_E_T_ = ' ' 									" 		+ CRLF

	cQuery += " ORDER BY CT2_DATA " 										+ CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cAlias,.T.,.T.)

	dbSelectArea(cAlias)

	(cAlias)->(dbGoTop())

	//Irei percorrer todos os meus registros
	If !Empty((cAlias)->CT2_DATA)

		While !(cAlias)->(Eof())

			IncProc("Imprimindo...")

			If lFim
				Exit
			EndIf

			// grava informacoes
			cTxt := DTOC(STOD((cAlias)->CT2_DATA)) + ";"
			cTxt += (cAlias)->CONTA + ";"
			cTxt += Alltrim(Transform((cAlias)->CT2_VALOR,"@E 999,999,999,999.99")) + ";"
			cTxt += (cAlias)->CT2_HIST+ ";"
			cTxt += (cAlias)->CT2_CCD+ ";"
			cTxt += (cAlias)->CT2_ITEMD+ ";"
			cTxt += (cAlias)->CT2_CODFOR+ ";"
			cTxt += (cAlias)->CT2_XPEDCO+ ";"

			cTxt	+= cEOL
	
			fWrite(nHdl, cTxt, Len(cTxt))

			(cAlias)->(DbSkip())
		End

	EndIf
	(cAlias)->(dbCloseArea())

// fecha arquivo
	fClose(nHdl)

	If !lFim
		// pergunta onde gravar o arquivo no cliente
		cNomLoc	:= MV_PAR04//cGetFile("Arquivos csv (*.csv)|*.csv", "Salvar arquivo", 1, "\", .F., nOr(GETF_LOCALHARD,GETF_RETDIRECTORY), .F., .F.)

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



