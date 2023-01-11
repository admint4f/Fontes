#include "rwmake.ch"
#include "topconn.ch"
#include "prtopdef.ch"
#include "protheus.ch"
#include "tbiconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FCT003  ºAutor  ³Microsiga           º Data ³  05/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar planilha de lançamentos para Consolidação            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function T4FCT003()   
	//U_T4FCT003() 

	Processa({|| PrcCT003() },"Lançamentos InterCompany...")

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrcCT003  ºAutor  ³Microsiga           º Data ³  06/15/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função para processar os lançamentos InterCompany         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrcCT003()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	Local oExcelApp
	Local nHandle
	Local nX
	Local cDirDocs 	:= MsDocPath()
	Local aStru	   	:= {}
	Local cArquivo 	:= CriaTrab(,.F.)
	Local cPath	   	:= AllTrim(GetTempPath())
	Local cCrLf    	:= Chr(13) + Chr(10)
	Local aTables := {"CT1","CT2","CT3","CT4","CT5","CTF","CTE"}
	Local nStart, nElapsed
	Private cPerg      := 'T4FCT1'

	nStart = SECONDS()

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	//AjustaSX1()
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	
	
	If .Not. Pergunte(cPerg,.T.)
		Return()
	EndIf

	//Estrutura do cabeçalho da planilha
	Aadd(aStru, {"EMPRESA"})
	Aadd(aStru, {"CT2_DATA"})
	Aadd(aStru, {"CT2_DOC"})
	Aadd(aStru, {"CT2_LOTE"})
	Aadd(aStru, {"CT2_VALOR"})
	Aadd(aStru, {"CT2_DEBITO"})
	Aadd(aStru, {"DESC_DEB"})
	Aadd(aStru, {"CT2_CREDIT"})
	Aadd(aStru, {"DESC_CRED"})
	Aadd(aStru, {"CT2_HIST"})
	Aadd(aStru, {"CT2_ITEMD"})
	Aadd(aStru, {"CT2_ITEMC"})

	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

	If nHandle == 0
		MsgAlert( "Erro na criacão do arquivo!!!" )
		Return
	Endif

	dbSelectArea("SM0")
	dbSetOrder(1)
	SM0->(dbGoTop())

	fWrite(nHandle, "Lançamentos para Consolidação" + ";") // Título
	fWrite(nHandle, cCrLf ) // Pula linha
	aEval(aStru, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aStru), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha

	While SM0->(!Eof())

		If !(SM0->M0_CODIGO $ ("08|09|15|16|20|25") .AND. SM0->M0_CODFIL $ ('01'))
			SM0->(DbSkip())
		Else
			//PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cCodFil
			//seta o ambiente para a empresa do SIGAMAT, módulo CTB
			cNome	:= IIf(SM0->M0_CODIGO == '20', 'AEB', SM0->M0_NOME )
			//MsgALert("Código: " + SM0->M0_CODIGO + " => " + cNome)

			cQuery := " SELECT DISTINCT EMPRESA, CT2_DATA, CT2_DOC, CT2_LOTE, CT2_VALOR, CT2_DEBITO, DESC_DEB, CT2_CREDIT, DESC_CRED, CT2_HIST, CT2_ITEMD, CT2_ITEMC FROM ("       
			cQuery += " SELECT DISTINCT '" + cNome + "' EMPRESA,"
			cQuery += " CT2A.CT2_DATA,"
			cQuery += " CT2A.CT2_DOC,"
			cQuery += " CT2A.CT2_LOTE,"
			cQuery += " CT2A.CT2_VALOR,"
			cQuery += " CT2A.CT2_DEBITO,"
			cQuery += " (SELECT CT1A.CT1_DESC01"
			cQuery += "  FROM CT1080 CT1A"
			//cQuery += " 	 FROM " + RetSqlName("CT1") + " CT1A"
			cQuery += "  WHERE CT1A.D_E_L_E_T_ = ' '"
			cQuery += "  AND CT1A.CT1_CONTA = CT2A.CT2_DEBITO) DESC_DEB,"
			cQuery += "  CT2A.CT2_CREDIT,"
			cQuery += " (SELECT CT1AA.CT1_DESC01"
			cQuery += "  FROM CT1080 CT1AA"
			//cQuery += " 	 FROM " + RetSqlName("CT1") + " CT1AA"
			cQuery += "  WHERE CT1AA.D_E_L_E_T_ = ' '"
			cQuery += "  AND CT1AA.CT1_CONTA = CT2A.CT2_CREDIT) DESC_CRED,"
			cQuery += " CT2A.CT2_HIST,"
			cQuery += " CT2A.CT2_ITEMD,"
			cQuery += " CT2A.CT2_ITEMC" 
			//		cQuery += " FROM " + RetSqlName("CT2") + " CT2A"
			cQuery += " FROM CT2" + AllTrim(SM0->M0_CODIGO) + "0 CT2A"
			cQuery += " WHERE CT2A.CT2_DATA >= '" + DtoS(mv_par01) + "' AND CT2A.CT2_DATA <= '" + DtoS(mv_par02) + "'"
			cQuery += " AND (CT2A.CT2_DEBITO IN ('121031001','121031002','1203010001','1203010002','1203010003','1203010004','1203010005','1203010006','1203010007','1203010010','1203010011','1203010012',"
			cQuery += "							 '218011001','218011002','2108010001','2108010002','2108010003','2108010004','2108010005','2108010006','2108010007','2108010008','2108010009','2108010010')"
			cQuery += " OR CT2A.CT2_CREDIT IN ('121031001','121031002','1203010001','1203010002','1203010003','1203010004','1203010005','1203010006','1203010007','1203010010','1203010011','1203010012',"
			cQuery += "						   '218011001','218011002','2108010001','2108010002','2108010003','2108010004','2108010005','2108010006','2108010007','2108010008','2108010009','2108010010') )"
			cQuery += " AND CT2A.D_E_L_E_T_ = ' '"
			cQuery += " UNION ALL"
			cQuery += " SELECT DISTINCT '" + cNome + "' EMPRESA,"
			cQuery += " CT2B.CT2_DATA,"
			cQuery += " CT2B.CT2_DOC,"
			cQuery += " CT2B.CT2_LOTE,"
			cQuery += " CT2B.CT2_VALOR,"
			cQuery += " CT2B.CT2_DEBITO,"
			cQuery += " (SELECT CT1B.CT1_DESC01"
			//cQuery += " 	 FROM " + RetSqlName("CT1") + " CT1B"
			cQuery += "  FROM CT1080 CT1B"
			cQuery += "  WHERE CT1B.D_E_L_E_T_ = ' '"
			cQuery += "  AND CT1B.CT1_CONTA = CT2B.CT2_DEBITO) DESC_DEB,"
			cQuery += " CT2B.CT2_CREDIT,"
			cQuery += "	(SELECT CT1BB.CT1_DESC01
			//cQuery += "		 FROM " + RetSqlName("CT1") + " CT1BB"
			cQuery += "  FROM CT1080 CT1BB"
			cQuery += "	 WHERE CT1BB.D_E_L_E_T_ = ' '"
			cQuery += "	 AND CT1BB.CT1_CONTA = CT2B.CT2_CREDIT) DESC_CRED,"
			cQuery += " CT2B.CT2_HIST,"
			cQuery += " CT2B.CT2_ITEMD,"
			cQuery += " CT2B.CT2_ITEMC"
			cQuery += " FROM CT2" + AllTrim(SM0->M0_CODIGO) + "0 CT2B"
			cQuery += " WHERE CT2B.CT2_DATA >= '" + DtoS(mv_par01) + "' AND CT2B.CT2_DATA <= '" + DtoS(mv_par02) + "'"
			cQuery += " AND ( (CT2B.CT2_DEBITO BETWEEN '3' AND '5' ) OR (CT2B.CT2_CREDIT BETWEEN '3' AND '5') )"
			cQuery += " AND CT2B.D_E_L_E_T_ = ' '"
			cQuery += " AND CT2B.CT2_HIST IN (SELECT DISTINCT CT2C.CT2_HIST"
			cQuery += "		  				  FROM CT2" + AllTrim(SM0->M0_CODIGO) + "0 CT2C"
			cQuery += "						  WHERE CT2C.CT2_DATA >= '" + DtoS(mv_par01) + "' AND CT2C.CT2_DATA <= '" + DtoS(mv_par02) + "'"
			cQuery += " AND (CT2C.CT2_DEBITO IN (	'121031001','121031002','1203010001','1203010002','1203010003','1203010004','1203010005','1203010006','1203010007','1203010010','1203010011','1203010012',"
			cQuery += " 				      							'218011001','218011002','2108010001','2108010002','2108010003','2108010004','2108010005','2108010006','2108010007','2108010008','2108010009','2108010010')"
			cQuery += " OR CT2C.CT2_CREDIT IN ('121031001','121031002','1203010001','1203010002','1203010003','1203010004','1203010005','1203010006','1203010007','1203010010','1203010011','1203010012',"
			cQuery += "						  						 '218011001','218011002','2108010001','2108010002','2108010003','2108010004','2108010005','2108010006','2108010007','2108010008','2108010009','2108010010') )"
			cQuery += "	AND CT2B.D_E_L_E_T_ = ' ' )"
			//////) QUERY"


			cQuery  := ChangeQuery(cQuery)
			dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMPSQL",.F.,.T.)

			// Grava o cabecalho do arquivo

			DbSelectArea("TMPSQL")
			cArqInd := CriaTrab(,.F.)
			Indregua( "TMPSQL", cArqInd, "EMPRESA + CT2_DATA",,, "Gerando arquivo de integração com Excel..." )

			TMPSQL->(dbGoTop())

			ProcRegua(FCOUNT())

			While !TMPSQL->(Eof())

				IncProc("Gerando lançamentos para a Emprea " + cNome )

				fWrite(nHandle, TMPSQL->EMPRESA						+ ";" )
				fWrite(nHandle, Substr(TMPSQL->CT2_DATA, 7,2) 		+ "/" + Substr(TMPSQL->CT2_DATA, 5,2) + "/" + Substr(TMPSQL->CT2_DATA, 1,4) + ";" )
				fWrite(nHandle, AllTrim(TMPSQL->CT2_DOC)			+ ";" )
				fWrite(nHandle, TMPSQL->CT2_LOTE					+ ";" )
				fWrite(nHandle, Transform(TMPSQL->CT2_VALOR, "@E 999,999,999,999.99")	+ ";" )
				fWrite(nHandle, TMPSQL->CT2_DEBITO					+ ";" )
				fWrite(nHandle, TMPSQL->DESC_DEB					+ ";" )
				fWrite(nHandle, TMPSQL->CT2_CREDIT					+ ";" )
				fWrite(nHandle, AllTrim(TMPSQL->DESC_CRED)			+ ";" )
				fWrite(nHandle, TMPSQL->CT2_HIST					+ ";" )
				fWrite(nHandle, TMPSQL->CT2_ITEMD					+ ";" )
				fWrite(nHandle, TMPSQL->CT2_ITEMC					+ ";" )
				fWrite(nHandle, cCrLf ) // Pula linha

				TMPSQL->(dbSkip())

			End

			fErase( cArqInd + OrdBagExt() ) //Deletando arquivo de trabalho  

			DbcloseArea("TMPSQL")

			//cQuery1  := ChangeQuery(cQuery1)
			//dBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery1),"TMPSQL1",.F.,.T.)

			//// Grava o cabecalho do arquivo


			//DbSelectArea("TMPSQL1")
			//cArqInd1 := CriaTrab(,.F.)
			//Indregua( "TMPSQL1", cArqInd1, "EMPRESA + CT2_DATA",,, "Gerando arquivo de integração com Excel..." )

			//TMPSQL1->(dbGoTop())

			//ProcRegua(FCOUNT())

			//While !TMPSQL1->(Eof())

			//	IncProc("Gerando lançamentos para a Emprea " + cNome )

			//	fWrite(nHandle, TMPSQL1->EMPRESA						+ ";" )
			// 	fWrite(nHandle, Substr(TMPSQL1->CT2_DATA, 7,2) + "/" + Substr(TMPSQL1->CT2_DATA, 5,2) + "/" + Substr(TMPSQL1->CT2_DATA, 1,4) + ";" )
			//	fWrite(nHandle, AllTrim(TMPSQL1->CT2_DOC)	+ ";" )
			//	fWrite(nHandle, TMPSQL1->CT2_LOTE			+ ";" )
			//	fWrite(nHandle, Transform(TMPSQL1->CT2_VALOR, "@E 999,999,999,999.99")	+ ";" )
			//	fWrite(nHandle, TMPSQL1->CT2_DEBITO			+ ";" )
			//	fWrite(nHandle, TMPSQL1->DESC_DEB					+ ";" )
			//	fWrite(nHandle, TMPSQL1->CT2_CREDIT			+ ";" )
			//	fWrite(nHandle, AllTrim(TMPSQL1->DESC_CRED)			+ ";" )
			//	fWrite(nHandle, TMPSQL1->CT2_HIST					+ ";" )
			//	fWrite(nHandle, chr(9) + TMPSQL1->CT2_ITEMD			+ ";" )
			//	fWrite(nHandle, chr(9) + TMPSQL1->CT2_ITEMC			+ ";" )
			//	fWrite(nHandle, cCrLf ) // Pula linha

			//	TMPSQL1->(dbSkip())

			//End

			//fErase( cArqInd1 + OrdBagExt() ) //Deletando arquivo de trabalho  

			//DbcloseArea("TMPSQL1")

			SM0->(dbSkip())
		EndIf 

		//RESET ENVIRONMENT //Limpa o ambiente, liberando a licença e fechando as conexões

	End

	nElapsed = SECONDS() - nStart
	fWrite(nHandle, "Decorridos: " + LTRIM(STR(nElapsed)) + " segundos" )
	fClose(nHandle)

	CpyS2T( cDirDocs + "\" + cArquivo + ".CSV" , cPath, .T. )

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	MsgAlert("Exportação Finalizada!", "Consolidação")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçào    ³AjustaSX1 ³ Autor ³ Ricardo Tomasi        ³ Data ³ 09/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descriçào ³ Ajusta dicionario de perguntas.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AGRR257                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
	Local sAlias    := Alias()
	Local cPergunta := PadR(cPerg,6)
	Local aRegs     :={}
	Local i, j

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	Local nTamSX1   := Len(SX1->X1_GRUPO)
	dbSelectArea('SX1')
	dbSetOrder(1)

	Aadd( aRegs,{ cPergunta, '01',OemToAnsi(PadR('Data De',19)+'?')    	,'','','mv_ch1','D',08,0,0,'G',''                          ,'mv_par01','','','','','','','','','','','','','','','','','','','','','','','','',''   ,''})
	Aadd( aRegs,{ cPergunta, '02',OemToAnsi(PadR('Data Ate',19)+'?')   	,'','','mv_ch2','D',08,0,0,'G',''                          ,'mv_par02','','','','','','','','','','','','','','','','','','','','','','','','',''   ,''})

	For i:=1 to Len(aRegs)
		If !dbSeek(PADR(cPerg,nTamSX1)+aRegs[i,2])
			RecLock('SX1',.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	dbSelectArea(sAlias)

Return()
