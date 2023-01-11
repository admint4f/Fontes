#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "prtopdef.ch"


User Function T4FAFR01()

	Local oCheckBo1
	Local lCheckBo1 := .F.
	Local oCheckBo2
	Local lCheckBo2 := .F.
	Local oCheckBo3
	Local lCheckBo3 := .F.
	Local oCheckBo4
	Local lCheckBo4 := .F.
	Local oCheckBo5
	Local lCheckBo5 := .F.
	Local oGroup1
	Local oSay1
	Local oSButton1
	Local oSButton2
	Local _aEmpresas:= {"08", "09", "15", "16", "20"}
	Local aCheck:= {.t.,.t.,.t.,.t.,.t.,.t.,.t.}
	Local lOk:= .f.
	Local oDlg
	Private lBaixa := '0'

	DEFINE MSDIALOG oDlg TITLE "Seleção de Empresas" FROM 000, 000  TO 235, 320 COLORS 0, 16777215 PIXEL

	@ 030, 004 GROUP oGroup1 TO 109, 132 OF oDlg COLOR 0, 16777215 PIXEL
	@ 036, 014 CHECKBOX oCheckBo1 VAR aCheck[1] PROMPT "Empresa 08 - T4F" SIZE 091, 011 OF oDlg COLORS 0, 16777215 PIXEL
	@ 050, 014 CHECKBOX oCheckBo2 VAR aCheck[2] PROMPT "Empresa 09 - Metropolitan" SIZE 101, 012 OF oDlg COLORS 0, 16777215 PIXEL
	@ 064, 014 CHECKBOX oCheckBo3 VAR aCheck[3] PROMPT "Empresa 15 - AuroLights" SIZE 101, 012 OF oDlg COLORS 0, 16777215 PIXEL
	@ 078, 014 CHECKBOX oCheckBo4 VAR aCheck[4] PROMPT "Empresa 16 - Vicar" SIZE 101, 012 OF oDlg COLORS 0, 16777215 PIXEL
	@ 092, 014 CHECKBOX oCheckBo5 VAR aCheck[5] PROMPT "Empresa 20 - AeB" SIZE 101, 012 OF oDlg COLORS 0, 16777215 PIXEL
	@ 036, 090 CHECKBOX oCheckBo6 VAR aCheck[6] PROMPT "Baixados" SIZE 091, 011 OF oDlg COLORS 0, 16777215 PIXEL
	@ 050, 090 CHECKBOX oCheckBo7 VAR aCheck[7] PROMPT "Não Baixados" SIZE 101, 012 OF oDlg COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON oSButton1 FROM 077, 135 TYPE 01 OF oDlg ENABLE ACTION Eval( {|| lOk:= .t., oDlg:End()} )
	DEFINE SBUTTON oSButton2 FROM 095, 135 TYPE 02 OF oDlg ENABLE ACTION Eval( {|| lOk:= .f., oDlg:End()} )
	DEFINE SBUTTON oSButton3 FROM 059, 135 TYPE 05 OF oDlg ENABLE ACTION Eval( {|| AjustaSx1(), } )

	@ 016, 005 SAY oSay1 PROMPT "Seleção de empresas / Sit. Baixa" SIZE 111, 014 OF oDlg COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	_aEmpresas:= {}
	If lOk

		If aCheck[1]
			aAdd(_aEmpresas,"08")
		EndIf
		If aCheck[2]
			aAdd(_aEmpresas,"09")
		EndIf
		If aCheck[3]
			aAdd(_aEmpresas,"15")
		EndIf
		If aCheck[4]
			aAdd(_aEmpresas,"16")
		EndIf
		If aCheck[5]
			aAdd(_aEmpresas,"20")
		EndIf
		If aCheck[6] .And. !aCheck[7]
			lBaixa:= '1'
		ElseIf !aCheck[6] .And. aCheck[7]
			lBaixa:= '2'
		EndIf

		MsgRun("Gerando arquivo...", "Relatório Ativo Analítico" ,{|| PrcAFR01(_aEmpresas) })

	EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FAFR01  ºAutor  ³Microsiga           º Data ³  30/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrcAFR01(_aEmpresas)

	Local _nTotReg:= 0
	Local cDirDocs 	:= MsDocPath()
	Local cArquivo 	:= CriaTrab(,.F.)
	Local cPath	   	:= AllTrim(GetTempPath())
	Local cCrLf:= Chr(13) + Chr(10)
	Local __cEmpresa := cEmpAnt
	Local __cFilial := cFilAnt
	Local nStart := SECONDS()
	Local nElapsed


	If Len(_aEmpresas) = 0
		MsgStop("Não há empresas selecionadas!!!")
		Return
	Else
		nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
		If nHandle == 0
			MsgAlert( "Erro na criacão do arquivo!!!" )
			Return
		Endif

		For x:= 1 to Len(_aEmpresas)
			cEmp := _aEmpresas[x]

			RpcClearEnv()
			RpcSetType(3)
			If RpcSetEnv(cEmp)
				_cNome	:= IIf(SM0->M0_CODIGO == '20', 'AEB', SM0->M0_NOME )

				_cQuery   := ""
				/*
				_cQuery   := " SELECT '" + _cNome  + "' EMPRESA,"
				_cQuery   += " N3_FILIAL, N3_CBASE, N3_ITEM, N3_TIPO, N1_DESCRIC, N2_HISTOR, N1_AQUISIC, N1_BAIXA, N3_DINDEPR, N1_X_DTNF, N1_FORNEC, N1_LOJA, ' ' A2_NOME, N1_PENHORA,"
				_cQuery   += " N1_NFISCAL, N1_QUANTD, N1_X_MARCA, N1_X_MODEL, N1_X_SERIE, N1_X_ANDAR, N1_X_PLTA, ZZJ_X_CODL, ZZJ_X_DESC,"
				_cQuery   += " N1_X_DIMEN, N1_X_CAPAC, N1_X_BEANT, N3_CCONTAB, CT1_DESC01, N3_CCDEPR, ' ' DESC01, N3_CDEPREC, ' ' DESC02,"
				_cQuery   += " N3_CCUSTO, CTT_DESC01, N1_X_CCFIS, ' ' DESC03, N3_DINDEPR, N3_VORIG1, N3_TXDEPR1, N3_VRDACM1, (N3_VORIG1 - N3_VRDACM1) RESIDUAL"
				_cQuery   += " FROM " + RetSqlName("SN3") + " SN3"
				_cQuery   += " LEFT JOIN " + RetSqlName("SN1") + " SN1  ON N3_FILIAL  = N1_FILIAL AND N3_CBASE = N1_CBASE AND N3_ITEM = N1_ITEM"
				_cQuery   += " LEFT JOIN " + RetSqlName("SN2") + " SN2  ON N3_FILIAL  = N2_FILIAL AND N3_CBASE = N2_CBASE AND N3_ITEM = N2_ITEM  AND N3_TIPO = N2_TIPO"
				_cQuery   += " LEFT JOIN " + RetSqlName("ZZJ") + " ZZJ  ON N1_LOCAL   = ZZJ_X_CODL"
				_cQuery   += " LEFT JOIN " + RetSqlName("CT1") + " CT1  ON N3_CCONTAB = CT1_CONTA"
				_cQuery   += " LEFT JOIN " + RetSqlName("CTT") + " CTT  ON N3_CCUSTO = CTT_CUSTO"
				_cQuery   += " WHERE SN3.D_E_L_E_T_ = ' '"
				_cQuery   += " AND SN1.D_E_L_E_T_ = ' '"
				_cQuery   += " AND SN2.D_E_L_E_T_ = ' '"
				_cQuery   += " AND ZZJ.D_E_L_E_T_ = ' '"
				_cQuery   += " AND CT1.D_E_L_E_T_ = ' '"
				_cQuery   += " AND CTT.D_E_L_E_T_ = ' '"
				If lBaixa = '1'
				_cQuery += " AND SN1.N1_BAIXA <> ' '"
				ElseIf lBaixa = '2'
				_cQuery += " AND SN1.N1_BAIXA = ' '"
				EndIf
				_cQuery	  += " AND SN1.N1_FORNEC  = ' '"
				*/
				//_cQUery	  += " UNION "
				_cQuery   := " SELECT '" + _cNome  + "' EMPRESA,"
				_cQuery   += " N3_FILIAL, N3_CBASE, N3_ITEM, N3_TIPO, N1_DESCRIC, ' ' N2_HISTOR, N1_AQUISIC, N1_BAIXA, N3_DINDEPR, N1_X_DTNF, N1_FORNEC, LPAD(TRIM(N1_LOJA), 2, '0') N1_LOJA, ' ' A2_NOME, N1_PENHORA,"
				_cQuery   += " N1_NFISCAL, N1_QUANTD, N1_X_MARCA, N1_X_MODEL, N1_X_SERIE, N1_X_ANDAR, N1_X_PLTA, N1_LOCAL, ' ' ZZJ_X_DESC," //ZZJ_X_CODL,
				_cQuery   += " N1_X_DIMEN, N1_X_CAPAC, N1_X_BEANT, N3_CCONTAB, CT1_DESC01, N3_CCDEPR, ' ' DESC01, N3_CDEPREC, ' ' DESC02,"
				_cQuery   += " N3_CCUSTO, CTT_DESC01, N1_X_CCFIS, ' ' DESC03, N3_DINDEPR, N3_VORIG1, N3_TXDEPR1, N3_VRDACM1, (N3_VORIG1 - N3_VRDACM1) RESIDUAL"
				_cQuery   += " FROM " + RetSqlName("SN3") + " SN3"
				_cQuery   += " LEFT JOIN " + RetSqlName("SN1") + " SN1  ON N3_FILIAL  = N1_FILIAL AND N3_CBASE = N1_CBASE AND N3_ITEM = N1_ITEM"
				//_cQuery   += " LEFT JOIN " + RetSqlName("SN2") + " SN2  ON N3_FILIAL  = N2_FILIAL AND N3_CBASE = N2_CBASE AND N3_ITEM = N2_ITEM  AND N3_TIPO = N2_TIPO"
				//_cQuery   += " LEFT JOIN " + RetSqlName("ZZJ") + " ZZJ  ON N1_LOCAL   = ZZJ_X_CODL"
				//_cQuery   += " LEFT JOIN " + RetSqlName("SA2") + " SA2  ON TRIM(N1_FORNEC) = TRIM(A2_COD) AND A2_LOJA = LPAD(TRIM(N1_LOJA), 2, '0')"
				_cQuery   += " LEFT JOIN " + RetSqlName("CT1") + " CT1  ON N3_CCONTAB = CT1_CONTA"
				_cQuery   += " LEFT JOIN " + RetSqlName("CTT") + " CTT  ON N3_CCUSTO = CTT_CUSTO"
				_cQuery   += " WHERE SN3.D_E_L_E_T_ = ' '"
				_cQuery   += " AND SN1.D_E_L_E_T_ = ' '"
				//_cQuery   += " AND SN2.D_E_L_E_T_ = ' '"
				//_cQuery   += " AND ZZJ.D_E_L_E_T_ = ' '"
				//_cQuery   += " AND SA2.D_E_L_E_T_ = ' '"
				_cQuery   += " AND CT1.D_E_L_E_T_ = ' '"
				_cQuery   += " AND CTT.D_E_L_E_T_ = ' '"
				If lBaixa = '1'
					_cQuery   += " AND SN1.N1_BAIXA <> ' '"
				ElseIf lBaixa = '2'
					_cQuery   += " AND SN1.N1_BAIXA = ' '"
				EndIf
				If !Empty(MV_PAR01)
					_cQuery   += " AND SN1.N1_AQUISIC >= '" + DtoS(MV_PAR01) + "'"
				EndIf
				If !Empty(MV_PAR02)
					_cQuery   += " AND SN1.N1_AQUISIC <= '" + DtoS(MV_PAR02) + "'"
				EndIf
				_cQUery	  += " UNION "
				_cQuery   += " SELECT '" + _cNome  + "' EMPRESA,"
				_cQuery   += " N3_FILIAL, N3_CBASE, N3_ITEM, N3_TIPO, N1_DESCRIC, ' ' N2_HISTOR, N1_AQUISIC, N1_BAIXA, N3_DINDEPR, N1_X_DTNF, N1_FORNEC, LPAD(TRIM(N1_LOJA), 2, '0') N1_LOJA, ' ' A2_NOME, N1_PENHORA,"
				_cQuery   += " N1_NFISCAL, N1_QUANTD, N1_X_MARCA, N1_X_MODEL, N1_X_SERIE, N1_X_ANDAR, N1_X_PLTA, N1_LOCAL, ' ' ZZJ_X_DESC," //ZZJ_X_CODL, 
				_cQuery   += " N1_X_DIMEN, N1_X_CAPAC, N1_X_BEANT, N3_CCONTAB, CT1_DESC01, N3_CCDEPR, ' ' DESC01, N3_CDEPREC, ' ' DESC02,"
				_cQuery   += " N3_CCUSTO, ' ' CTT_DESC01, N1_X_CCFIS, ' ' DESC03, N3_DINDEPR, N3_VORIG1, N3_TXDEPR1, N3_VRDACM1, (N3_VORIG1 - N3_VRDACM1) RESIDUAL"
				_cQuery   += " FROM " + RetSqlName("SN3") + " SN3"
				_cQuery   += " LEFT JOIN " + RetSqlName("SN1") + " SN1  ON N3_FILIAL  = N1_FILIAL AND N3_CBASE = N1_CBASE AND N3_ITEM = N1_ITEM"
				//_cQuery   += " LEFT JOIN " + RetSqlName("SN2") + " SN2  ON N3_FILIAL  = N2_FILIAL AND N3_CBASE = N2_CBASE AND N3_ITEM = N2_ITEM  AND N3_TIPO = N2_TIPO"
				//_cQuery   += " LEFT JOIN " + RetSqlName("ZZJ") + " ZZJ  ON N1_LOCAL   = ZZJ_X_CODL"
				_cQuery   += " LEFT JOIN " + RetSqlName("SA2") + " SA2  ON TRIM(N1_FORNEC) = TRIM(A2_COD) AND A2_LOJA = LPAD(TRIM(N1_LOJA), 2, '0')"
				_cQuery   += " LEFT JOIN " + RetSqlName("CT1") + " CT1  ON N3_CCONTAB = CT1_CONTA"
				_cQuery   += " WHERE SN3.D_E_L_E_T_ = ' '"
				_cQuery   += " AND SN1.D_E_L_E_T_ = ' '"
				//_cQuery   += " AND SN2.D_E_L_E_T_ = ' '"
				//_cQuery   += " AND ZZJ.D_E_L_E_T_ = ' '"
				//_cQuery   += " AND SA2.D_E_L_E_T_ = ' '"
				_cQuery   += " AND CT1.D_E_L_E_T_ = ' '"
				If lBaixa = '1'
					_cQuery   += " AND SN1.N1_BAIXA <> ' '"
				ElseIf lBaixa = '2'
					_cQuery   += " AND SN1.N1_BAIXA = ' '"
				EndIf
				If !Empty(MV_PAR01)
					_cQuery   += " AND SN1.N1_AQUISIC >= '" + DtoS(MV_PAR01) + "'"
				EndIf
				If !Empty(MV_PAR02)
					_cQuery   += " AND SN1.N1_AQUISIC <= '" + DtoS(MV_PAR02) + "'"
				EndIf
				_cQUery	  += " AND N3_CCUSTO = ' '"
				_cQuery   += " ORDER BY EMPRESA,"
				_cQuery   += " N3_FILIAL, N3_CBASE, N3_ITEM"

				// Alias para abrir no SQL.
				_cTabAlias := GetNextAlias()

				// Verifica se o Alias esta aberto.
				If Select(_cTabAlias) > 0
					(_cTabAlias)->(dbCloseArea())
				EndIf

				// Abre a tabela.
				dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),_cTabAlias,.F.,.T.)
				_aStruTRB := ( _cTabAlias )->(dbStruct())

				If x == 1
					fWrite(nHandle, "Ativo Analítico" + ";") // Título
					fWrite(nHandle, cCrLf ) // Pula linha
					For nX := 1 To Len(_aStruTRB)
						fWrite(nHandle, _aStruTRB[nX][1] + IIf( nX < Len(_aStruTRB), ";", "" )) // Gerar Cabe;alho
					Next nX
					fWrite(nHandle, cCrLf ) // Pula linha
				EndIf
				DbSelectArea(_cTabAlias )
				(_cTabAlias)->(DbGotop())
				While (_cTabAlias )->(!Eof ())
					fWrite(nHandle, (_cTabAlias)->EMPRESA		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N3_FILIAL		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N3_CBASE		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N3_ITEM		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N3_TIPO		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_DESCRIC	+ ";" )
					fWrite(nHandle, AFR01((_cTabAlias)->N3_FILIAL, (_ctabAlias)->N3_CBASE, "SN2", (_cTabAlias)->N3_ITEM) + ";")
					//fWrite(nHandle, (_cTabAlias)->N2_HISTOR		+ ";" )
					fWrite(nHandle, DtoC(StoD((_cTabAlias)->N1_AQUISIC))	+ ";" )
					fWrite(nHandle, DtoC(StoD((_cTabAlias)->N1_BAIXA))		+ ";" )
					fWrite(nHandle, DtoC(StoD((_cTabAlias)->N3_DINDEPR))	+ ";" )
					fWrite(nHandle, DtoC(StoD((_cTabAlias)->N1_X_DTNF)) 	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_FORNEC		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_LOJA		+ ";" )
					fWrite(nHandle, AFR01((_cTabAlias)->N3_FILIAL, (_ctabAlias)->N1_FORNEC, "SA2", (_cTabAlias)->N1_LOJA) + ";")   //fWrite(nHandle, (_cTabAlias)->A2_NOME		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_PENHORA	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_NFISCAL	+ ";" )
					fWrite(nHandle, Transform((_cTabAlias)->N1_QUANTD,  "@E 999,999,999,999.99")	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_X_MARCA	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_X_MODEL 	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_X_SERIE	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_X_ANDAR	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_X_PLTA		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_LOCAL		+ ";" )
					fWrite(nHandle, AFR01(xFilial("ZZJ"), (_cTabAlias)->N1_LOCAL, "ZZJ", " ")	+ ";" )
					//fWrite(nHandle, (_cTabAlias)->ZZJ_X_DESC	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_X_DIMEN 	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_X_CAPAC 	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_X_BEANT 	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N3_CCONTAB 	+ ";" )
					fWrite(nHandle, (_cTabAlias)->CT1_DESC01	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N3_CCDEPR		+ ";" )
					fWrite(nHandle, AFR01(xFilial("CT1"), (_cTabAlias)->N3_CCDEPR, "CT1", " ")	+ ";" )
					//fWrite(nHandle, (_cTabAlias)->DESC01		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N3_CDEPREC	+ ";" )
					fWrite(nHandle, AFR01(xFilial("CTT"), (_cTabAlias)->N3_CDEPREC, "CT1", " ")	+ ";" )
					//				fWrite(nHandle, (_cTabAlias)->DESC02		+ ";" )
					fWrite(nHandle, (_cTabAlias)->N3_CCUSTO		+ ";" )
					fWrite(nHandle, (_cTabAlias)->CTT_DESC01	+ ";" )
					fWrite(nHandle, (_cTabAlias)->N1_X_CCFIS	+ ";" )
					fWrite(nHandle, AFR01(xFilial("CTT"), (_cTabAlias)->N1_X_CCFIS, "CTT", " ")	+ ";" )
					//				fWrite(nHandle, (_cTabAlias)->DESC03		+ ";" )
					fWrite(nHandle, Transform((_cTabAlias)->N3_VORIG1,  "@E 999,999,999,999.99") 	+ ";" )
					fWrite(nHandle, Transform((_cTabAlias)->N3_TXDEPR1, "@E 999,999,999,999.99") 	+ ";" )
					fWrite(nHandle, Transform((_cTabAlias)->N3_VRDACM1, "@E 999,999,999,999.99")	+ ";" )
					fWrite(nHandle, Transform((_cTabAlias)->RESIDUAL  , "@E 999,999,999,999.99") 	+ ";" )
					fWrite(nHandle, cCrLf ) // Pula linha
					(_cTabAlias)->(dbSkip())
				EndDo

				(_cTabAlias)->( dbCloseArea())
			Else
				MsgStop("Não foi possível abrir a empresa " + cEmp)
				Loop
			EndIf
		Next

	EndIf

	nElapsed = SECONDS() - nStart
	fWrite(nHandle, "Decorridos: " + LTRIM(STR(nElapsed)) + " segundos" )
	fWrite(nHandle, cCrLf ) // Pula linha

	fClose(nHandle)

	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	RpcSetType(3)
	RpcSetEnv(__cEmpresa, __cFilial)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFR01		ºAutor  ³Microsiga           º Data ³  05/22/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para retornar a descrição da conta contábil ou centroº±±
±±º          ³de custo        											  º±±
±±º          ³  _cCta = Entidade para busca (Conta Contábil ou CCusto     º±±
±±º          ³  _cTabela = (CT1 - Plano de Contas CTT - CCusto)		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AFR01(_cFil, _cCta, _cTabela, _cItem)

	Local _cdesc01 := ' '
	dbSelectArea(_cTabela)
	dbSetOrder(1)

	If dbSeek(xFilial(_cTabela) + _cCta + _cItem)
		If _cTabela == "SA2"
			_cdesc01 := AllTrim(&((_cTabela)->("A2_NOME")))
		ElseIf _cTabela =="SN2"
			_cdesc01 := AllTrim(&((_cTabela)->("N2_HISTOR")))
		ElseIf _cTabela =="ZZJ"
			_cdesc01 := AllTrim(&((_cTabela)->("ZZJ_X_DESC")))
		Else
			_cdesc01 := AllTrim(&((_cTabela)->((_cTabela) + "_DESC01")))  		
		EndIf
	EndIf

Return(_cdesc01)

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

	Local sAlias    := GetNextAlias()
	Local cPergunta := "TAFR01"
	Local aRegs     :={}
	Local i
	Local j
	//---------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
	//----------------------------------------------------------------- { Inicio }
	/*
	Local nTamSX1   := Len(SX1->X1_GRUPO)

	dbSelectArea('SX1')
	SX1->(dbSetOrder(1))

	Aadd( aRegs,{ cPergunta, '01',OemToAnsi(PadR('Data Aquisição De',19)+'?')    		,'','','mv_ch1','D',08,0,0,'G','' ,'mv_par01','','','','','','','','','','','','','','','','','','','','','','','','','',''})
	Aadd( aRegs,{ cPergunta, '02',OemToAnsi(PadR('Data Aquisição Ate',19)+'?')   		,'','','mv_ch2','D',08,0,0,'G','' ,'mv_par02','','','','','','','','','','','','','','','','','','','','','','','','','',''})


	//Aadd( aRegs,{ cPergunta, '03',OemToAnsi(PadR('Centro de Custo De',19)+'')     		,'','','mv_ch3','C',16,2,0,'G','' ,'mv_par03','','','','','','','','','','','','','','','','','','','','','','','','',"CTT",''})
	//Aadd( aRegs,{ cPergunta, '04',OemToAnsi(PadR('Centro de Custo Ate',19)+'')    		,'','','mv_ch4','C',16,2,0,'G','' ,'mv_par04','','','','','','','','','','','','','','','','','','','','','','','','',"CTT",''})


	If SX1->(dbSeek(cPergunta)) .And. FCount() # Len(aRegs)
		While alltrim(SX1->X1_GRUPO) == cPergunta
			RecLock('SX1',.F.)
			SX1->(dbDelete())
			SX1->(msUnlock())
			SX1->(dbSkip())
		EndDo
	EndIf

	For i:=1 to Len(aRegs)

		If !dbSeek(PADR(cPergunta,nTamSX1)+aRegs[i,2])
			RecLock('SX1',.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif

	Next
	dbSelectArea(sAlias)
	*/
	// { Fim } -------------------------------------------------------------------

	Pergunte(cPergunta, .T.)

Return()
