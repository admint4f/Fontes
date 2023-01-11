#include "totvs.ch"
#include "topconn.ch"
#Include "tbiconn.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "Fisa022.ch"

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13) )
#ENDIF

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
//	{Protheus.doc} 			 												//	
//																			//
// 	Programa ...: T4F02CANC                            Modulo : SIGAFAT     //
//                                                                          //
//  Função responsável por cancelar a venda de Ingressos e Taxas da INTI	//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Felipe Sakaguti - CRM Services							//
//                                                                          //
//	@since......: 	01/07/2021												//	
//                                                                          //
//	@database...: 	Oracle													//
/*////////////////////////////////////////////////////////////////////////////


User function T4F02CANC(aParamEmp,dDataIni,dDataFim,oSay,cLocalizador,cIdVenda,oGrid,cEmp,cFil)

	Local cQuery         := ""
	Local cALias         := ""
	Local lRet           := .F.
	Local cDoc           := ""
	Local cSerie         := ""
	Local nQtdNF         := 0
	Local nQtdCanc       := 0
	Local cItType        := ""
	Local nDif           := 0
	Local lTemSC5        := .F.
	Local lTemSC6        := .F.
	Local nX
	Local aDados		 := {}
	Local lExec			 :=.F.
	Private cAliasWallet := ""

	If !(FWIsInCallStack('U_T4FCANC') .Or. FWIsInCallStack('U_T4F03M'))

		If (aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U") .And. Len(aParamEmp) > 0

			cEmp := aParamEmp[1]
			cFil := aParamEmp[2]

			PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4","ZAD","SF2"

		ElseIf !Empty(cEmp)

			PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4","ZAD","SF2"

		EndIf

	EndIf

	If Empty(dDataIni)
		dDataIni  	:= FirstDate(dDataBase)
		dDataFim	:= LastDate(dDataBase)
	EndIf

	cDtBlqINT	:= GetMv("MV_DTBLINT")

	dDtBkp 		:= dDataBase

	If STOD(cDtBlqINT) >= dDataIni .Or. Month(dDataIni) <> Month(dDtBkp)
		If FWIsInCallStack('U_T4FCANC') .Or. FWIsInCallStack('U_T4F03M')

			msg := "ATENCAO!"+CHR(13)+CHR(10)
			msg +=  CHR(13)+CHR(10)
			msg += "O periodo escolhido está bloqueado para reprocessamento ou mês de cancelamento."
			msg +=  CHR(13)+CHR(10)

			FWAlertWarning(msg, "Cancelamento")

			Return
		Else

			cMsgLog := "Periodo bloqueado para processamento." + CRLF
			cMsgLog += "Data Bloqueio: " + DTOC(STOD(cDtBlqINT)) + CRLF

			u_T4F01LOG(cMsgLog)

			Return
		EndIf
	EndIf

	If (TIME() > '05:00:00' .AND. TIME() < '16:10:00') .OR. ;
			(FWIsInCallStack('U_T4FCANC') .Or. FWIsInCallStack('U_T4F03M'))
		lExec:=.T.
	EndIf

	If LockByName("T4F02CANC",.T.,.T.) .Or. lExec

		cMsg :=  Alltrim(Time())+" - Inicio do processo T4F02CANC"
		u_T4F01LOG(cMsg)

		//CANCELAMENTO DE TAXAS
		cQuery := QryTP2_St1(dDataIni,dDataFim,cLocalizador,cIdVenda,oSay,oGrid)

		TcQuery cQuery New Alias (cAlias:=GetNextAlias())
		dbSelectArea(cAlias)

		(cAlias)->(dbGoTop())

		If FWIsInCallStack('u_T4F03M') .Or. FWIsInCallStack('u_T4FCANC')

			cMsg := "Selecionando registros [ "+dtos(dDataIni)+" ]
			FWLogMsg("INFO", "", "", "T4F02CANC", "", "","INICIO PROCESSO T4F02CANC "+cMsg, 0, 0)
			If !Empty(dtos(dDataIni))
				oGrid:SetIncMeter(1,cMsg)
			Else
				FWLogMsg("INFO", "", "", "T4F02CANC.PRW", "", "",cMsg, 0, 0)
			EndIf
		EndIf

		dbSelectArea("SC6")
		dbSetOrder(4)

		dbSelectArea("SF2")
		dbSetOrder(1)

		dbSelectArea("SC5")
		dbSetOrder(1)

		dDtBkp := dDataBase

		If (cAlias)->(!EOF())
			cEpep		:= (cAlias)->EPEP
			While (cAlias)->(!EOF())

				If FWIsInCallStack('u_T4F03M') .Or. FWIsInCallStack('u_T4FCANC')
					cMsg := "Processando Nota Fiscal | Serie [ "+Alltrim((cAlias)->NFTOTV)+"|"+Alltrim((cAlias)->SETOTV)+" ]
					FWLogMsg("INFO", "", "", "T4F02CANC.PRW", "", "","INICIO PROCESSO CANCELAMENTO "+cMsg, 0, 0)
					If !Empty((cAlias)->NFTOTV)
						oGrid:SetIncMeter(1,cMsg)
					Else
						FWLogMsg("INFO", "", "", "T4F02CANC.PRW", "", "",cMsg, 0, 0)
					EndIf
				EndIf

				If (Month(STOD((cAlias)->ZAD_DTCANC)) <> Month(STOD((cAlias)->ZAD_DTVEND)) .And. (Alltrim((cAlias)->SETOTV) =='S' .Or. Alltrim((cAlias)->SETOTV) =='INT') )
					(cAlias)->(dbSkip())
					Loop
				Else

					SF2->(dbSetOrder(1))
					If !(SF2->(MsSeek(xFilial("SF2") +(cAlias)->NFTOTV+(cAlias)->SETOTV)))
						ZADUpd1CancelaIngressoTotal((cAlias)->NFTOTV,(cAlias)->SETOTV,(cAlias)->ITTYPE,(cAlias)->SLUID,'',.F.)
						(cAlias)->(dbSkip())
						Loop
					End If

					cQryWallet := QryWallet((cAlias)->SLUID,cLocalizador)

					TcQuery cQryWallet New Alias (cAliasWallet:=GetNextAlias())
					dbSelectArea(cAliasWallet)

					(cAliasWallet)->(dbGoTop())

					If (cAliasWallet)->ZAF_TIPO == 'Cancelamento por Est' .And. cEmpAnt =='33' //SOMENTE NA EMPRESA INTI

						cDoc		:= (cAlias)->NFTOTV
						cSerie		:= (cAlias)->SETOTV
						nQtdNF		:= (cAlias)->QTD_ITEMNF
						nQtdCanc	:= (cAlias)->QTD_ITEM
						cItType		:= (cAlias)->ITTYPE

						SC6->(dbSetOrder(4))
						If SC6->(MsSeek(xFilial("SC6") +(cAlias)->NFTOTV+(cAlias)->SETOTV))
							SC5->(dbSetOrder(1))
							If SC5->(MsSeek(xFilial("SC5")+SC6->C6_NUM))

								dDataBase	:= STOD((cAlias)->ZAD_DTCANC)

								If AllTrim((cAlias)->SETOTV) == 'S' .OR. AllTrim((cAlias)->SETOTV) == 'INT'	//Taxas

									If nQtdCanc == nQtdNF		//Cancelamento Total

										lRet := CSrvTot(cDoc,cSerie,cItType,dDtBkp)

									ElseIf	nQtdCanc < nQtdNF //Cancelamento Parcial

										nDif := nQtdNF - nQtdCanc

										lRet := CSrvParc(cDoc,cSerie,cItType,nDif,dDtBkp)

									Else
										// Erro Estranho -> Há mais cancelamento do que foi vendido
										lRet := .F.
									EndIf

								EndIf

								If Select(cAliasWallet) > 0
									(cAliasWallet)->( DbCloseArea() )
								EndIf
							Else
								lTemSC5	:= .F.
							EndIf
						Else
							lTemSC6 := .F.
						EndIf
					Else
						SC6->(dbSetOrder(4))
						If SC6->(MsSeek(xFilial("SC6") +(cAlias)->NFTOTV+(cAlias)->SETOTV))
							SC5->(dbSetOrder(1))
							If SC5->(MsSeek(xFilial("SC5") +SC6->C6_NUM))

								cDoc		:= (cAlias)->NFTOTV
								cSerie		:= (cAlias)->SETOTV
								nQtdNF		:= (cAlias)->QTD_ITEMNF
								nQtdCanc	:= (cAlias)->QTD_ITEM
								cItType		:= (cAlias)->ITTYPE

								dDataBase	:= STOD((cAlias)->ZAD_DTCANC)

								If AllTrim((cAlias)->SETOTV) == 'S' .OR. AllTrim((cAlias)->SETOTV) == 'INT'	//Taxas

									If nQtdCanc == nQtdNF		//Cancelamento Total

										lRet := CSrvTot(cDoc,cSerie,cItType,dDtBkp)

									ElseIf	nQtdCanc < nQtdNF //Cancelamento Parcial

										nDif := nQtdNF - nQtdCanc

										lRet := CSrvParc(cDoc,cSerie,cItType,nDif,dDtBkp)

									Else
										// Erro Estranho -> Há mais cancelamento do que foi vendido
										lRet := .F.
									EndIf

								EndIf

								If Select(cAliasWallet) > 0
									(cAliasWallet)->( DbCloseArea() )
								EndIf
								lTemSC5	:= .T.
							Else
								lTemSC5	:= .F.
							EndIf
							lTemSC6	:= .T.
						Else
							lTemSC6	:= .F.
						EndIf

					EndIf
				Endif

				cEpep := (cAlias)->EPEP

				(cAlias)->(dbSkip())

			EndDo
		Endif

		(cAlias)->(dbCloseArea())

		//CANCELAMENTO DE INGRESSOS
		cQuery := QryTP2_St2(dDataIni,dDataFim,cLocalizador,cIdVenda,oSay,oGrid)

		TcQuery cQuery New Alias (cAlias:=GetNextAlias())
		dbSelectArea(cAlias)

		(cAlias)->(dbGoTop())

		cEpep		:= (cAlias)->EPEP
		While (cAlias)->(!EOF())
			If FWIsInCallStack('u_T4F03M') .Or. FWIsInCallStack('u_T4FCANC')
				cMsg := "Processando EPEP [ "+Alltrim((cAlias)->EPEP)+" ]
				FWLogMsg("INFO", "", "", "T4F02CANC.PRW", "", "","INICIO PROCESSO CANCELAMENTO "+cMsg, 0, 0)
				If !Empty((cAlias)->EPEP)
					oGrid:SetIncMeter(1,cMsg)
				Else
					FWLogMsg("INFO", "", "", "T4F02CANC.PRW", "", "",cMsg, 0, 0)
				EndIf
			EndIf

			If (STOD((cAlias)->DTCANC) > LastDate(STOD((cAlias)->DTCANC)) )
				(cAlias)->(dbSkip())
				Loop
			Else

				aAdd(aDados,{(cAlias)->DTCANC,(cAlias)->EPEP,(cAlias)->PRDTKT,(cAlias)->TOTCANC,(cAlias)->VLRCANC*-1,(cAlias)->CC,(cAlias)->SLUID,(cAlias)->NFTOTV,(cAlias)->SETOTV,(cAlias)->ZAE_PRDOAC,(cAlias)->ZAD_ITTYPE})

			EndIf

			(cAlias)->(dbSkip())

		EndDo

		(cAlias)->(dbCloseArea())

		If Len(aDados) > 0

			lRet := CIngParc(aDados,oGrid)

		Endif

		dDataBase := dDtBkp

		UnLockByName("T4F02CANC",.T.,.T.)

		cMsg :=  Alltrim(Time())+" - Fim do processo T4F02CANC"
		u_T4F01LOG(cMsg)

	EndIf

	If !(FWIsInCallStack('U_T4F03M') .Or. FWIsInCallStack('u_T4FCANC'))
		RESET ENVIRONMENT
	EndIf

Return

/*
	Query que pega notas de taxas para cancelamento e verifica se é parcial ou total
*/
Static Function QryTP2_St1(dDataIni,dDataFim,cLocalizador,cIdVenda,oSay,oGrid)
	Local cQuery 	:= ""
	Local dDataCanc	:= dDataBase//CTOD('18/10/21') //data de inicio das operações no PROTHEUS
	Local cQryCanc 	:= ""
	Local cDtIni	:= ""
	Local cDtFim	:= ""

	cQuery += " SELECT                                                  	" + CRLF
	cQuery += "     COUNT(CANC.ZAD_NUMERO) AS QTD_ITEM                  	" + CRLF
	cQuery += "     ,ZADNF.QTD_ITEMNF                                   	" + CRLF
	cQuery += "     ,ZADNF.NFTOTV                                       	" + CRLF
	cQuery += "     ,ZADNF.SETOTV                                       	" + CRLF
	cQuery += "     ,ZADNF.ITTYPE                                       	" + CRLF
	cQuery += "     ,CANC.ZAD_DTCANC										" + CRLF
	cQuery += "     ,CANC.ZAD_DTVEND										" + CRLF
	cQuery += "     ,ZADNF.SLUID											" + CRLF
	cQuery += "     ,ZADNF.EPEP												" + CRLF
	cQuery += " FROM "+RetSqlName("ZAD")+" CANC  " 							  + CRLF
	cQuery += " INNER JOIN (                                           	 	" + CRLF
	cQuery += "     SELECT                                              	" + CRLF
	cQuery += "         ZAD_SEARCH                                      	" + CRLF
	cQuery += "         , ZAD_IDVEND                                    	" + CRLF
	cQuery += "         , ZAD_FILIAL                                    	" + CRLF
	cQuery += "         , ZAD_TKTID                                     	" + CRLF
	cQuery += "         , ZAD_ITTYPE                                    " + CRLF
	cQuery += "         , ZAD_SLUID										" + CRLF
	cQuery += "         , QTD_ITEMNF                                    " + CRLF
	cQuery += "         , NFTOTV                                        " + CRLF
	cQuery += "         , SETOTV                                        " + CRLF
	cQuery += "         , ITTYPE                                        " + CRLF
	cQuery += "         , SLUID											" + CRLF
	cQuery += "         ,EPEP											" + CRLF
	cQuery += "     FROM "+RetSqlName("ZAD")+" ZAD                      " + CRLF
	cQuery += "     INNER JOIN  (                                       " + CRLF
	cQuery += "     SELECT                                              " + CRLF
	cQuery += "         COUNT(NF.ZAD_NUMERO) AS QTD_ITEMNF              " + CRLF
	cQuery += "         ,NF.ZAD_NFTOTV NFTOTV                           " + CRLF
	cQuery += "         ,NF.ZAD_SETOTV SETOTV                           " + CRLF
	cQuery += "         ,NF.ZAD_ITTYPE ITTYPE                           " + CRLF
	cQuery += "         ,NF.ZAD_FILIAL FILIAL                           " + CRLF
	cQuery += "         ,NF.ZAD_SLUID SLUID								" + CRLF
	cQuery += "         ,NF.ZAD_EPEP  EPEP								" + CRLF
	cQuery += "     FROM "+RetSqlName("ZAD")+" NF " 					  + CRLF
	cQuery += "     WHERE                                               " + CRLF
	cQuery += "         1 = 1                                           " + CRLF
	cQuery += "         AND NF.ZAD_TPTRAN = '1'                         " + CRLF
	cQuery += "         AND NF.ZAD_TPITEM <> '1'						" + CRLF
	cQuery += "         AND NF.ZAD_STATUS = '3'                         " + CRLF
	cQuery += "         AND NF.D_E_L_E_T_ = ' '                         " + CRLF
	cQuery += "     GROUP BY                                            " + CRLF
	cQuery += "         NF.ZAD_NFTOTV                                   " + CRLF
	cQuery += "         ,NF.ZAD_SETOTV                                  " + CRLF
	cQuery += "         ,NF.ZAD_FILIAL		                            " + CRLF
	cQuery += "         ,NF.ZAD_ITTYPE									" + CRLF
	cQuery += "         ,NF.ZAD_SLUID									" + CRLF
	cQuery += "         ,NF.ZAD_EPEP									" + CRLF
	cQuery += "     ORDER BY                                            " + CRLF
	cQuery += "         NF.ZAD_NFTOTV                                   " + CRLF
	cQuery += "     ) ZADNF ON                                          " + CRLF
	cQuery += "         	ZADNF.FILIAL = ZAD.ZAD_FILIAL	  		    " + CRLF
	cQuery += "         AND ZADNF.NFTOTV = ZAD.ZAD_NFTOTV               " + CRLF
	cQuery += "         AND ZADNF.SETOTV = ZAD.ZAD_SETOTV               " + CRLF
	cQuery += "         AND ZADNF.ITTYPE  = ZAD.ZAD_ITTYPE				" + CRLF
	cQuery += "         AND ZADNF.SLUID = ZAD.ZAD_SLUID					" + CRLF
	cQuery += " ) ZADNF ON                                              " + CRLF
	cQuery += "     	ZADNF.ZAD_FILIAL = CANC.ZAD_FILIAL              " + CRLF
	cQuery += "     AND ZADNF.ZAD_SEARCH = CANC.ZAD_SEARCH           	" + CRLF

	If !Empty(cLocalizador)
		cQuery += "    AND 	ZADNF.ZAD_SEARCH = '"+cLocalizador+"'              " + CRLF
	EndIf

	If !Empty(cIdVenda)
		cQuery += "    AND 	ZADNF.ZAD_SLUID = '"+cIdVenda+"'              " + CRLF
	EndIf

	cQuery += "     AND ZADNF.ZAD_IDVEND = CANC.ZAD_IDVEND              " + CRLF
	cQuery += "     AND ZADNF.ZAD_TKTID = CANC.ZAD_TKTID                " + CRLF
	cQuery += "     AND ZADNF.ZAD_ITTYPE = CANC.ZAD_ITTYPE               " + CRLF
	cQuery += "     AND ZADNF.SETOTV = 'S  '" + CRLF
	cQuery += "     AND ZADNF.ZAD_SLUID = CANC.ZAD_SLUID				" + CRLF
	cQuery += " WHERE 1 = 1                                             " + CRLF
	cQuery += " 	AND CANC.ZAD_TPTRAN = '2'                           " + CRLF
	cQuery += " 	AND CANC.ZAD_STATUS IN ('1','E')                    " + CRLF

	If !Empty(dDataIni) .And. !Empty(dDataFim)
		cQuery += "     AND CANC.ZAD_DTCANC BETWEEN '" + DTOS(dDataIni) +"' AND '" + DTOS(dDataFim) +"'"+ CRLF
	Else
		cQuery += "     AND CANC.ZAD_DTCANC BETWEEN '" + cDtIni +"' AND '" + cDtFim +"'"+ CRLF
	EndIf

	If !Empty(dDataIni)
		cDtVendIni 	:= DTOS(FirstDate(dDataIni))
		cDtVendFim	:= DTOS(LastDate(dDataIni))
	ElseIf !Empty(cDtIni)
		cDtVendIni 	:= Dtos(FirstDate(cTod(cDtIni)))
		cDtVendFim	:= Dtos(LastDate(cTod(cDtIni)))
	Endif

	cQuery += "     AND CANC.ZAD_DTVEND BETWEEN '" + cDtVendIni +"' AND '" + cDtVendFim +"'"+ CRLF
	cQuery += " 	AND CANC.D_E_L_E_T_ = ' '                           " + CRLF
	cQuery += " GROUP BY                                                " + CRLF
	cQuery += "     ZADNF.QTD_ITEMNF                                    " + CRLF
	cQuery += "     ,ZADNF.NFTOTV                                       " + CRLF
	cQuery += "     ,ZADNF.SETOTV                                       " + CRLF
	cQuery += "     ,CANC.ZAD_DTCANC									" + CRLF
	cQuery += "     ,CANC.ZAD_DTVEND									" + CRLF
	cQuery += "     ,ZADNF.ITTYPE										" + CRLF
	cQuery += "     ,ZADNF.SLUID										" + CRLF
	cQuery += "     ,EPEP												" + CRLF
	cQuery += " ORDER BY CANC.ZAD_DTCANC,EPEP						    " + CRLF

Return cQuery


/*
	Query que pega notas para cancelamento e verifica se é parcial ou total
*/
Static Function QryTP2_St2(dDataIni,dDataFim,cLocalizador,cIdVenda,oSay,oGrid)
	Local cQuery 	:= ""
	Local dDataCanc	:= dDataBase//CTOD('18/10/21') //data de inicio das operações no PROTHEUS
	Local cQryCanc 	:= ""
	Local cDtIni	:= ""
	Local cDtFim	:= ""

	If FWIsInCallStack('u_T4F03M') .Or. FWIsInCallStack('u_T4FCANC')
		cMsg := "Consultando banco de dados [......]
		FWLogMsg("INFO", "", "", "T4F02CANC.PRW", "", "","INICIO PROCESSO CANCELAMENTO "+cMsg, 0, 0)
		If !Empty(DTOS(dDataIni))
			oGrid:SetIncMeter(1,cMsg)
		Else
			FWLogMsg("INFO", "", "", "T4F02CANC.PRW", "", "",cMsg, 0, 0)
		EndIf
	EndIf

	cQuery += "  SELECT ZADCANC.ZAD_DTCANC DTCANC,ZADCANC.ZAD_ITTYPE, ZADCANC.ZAD_EPEP EPEP ,ZADCANC.ZAD_SLUID SLUID, ZAE.ZAE_PRDTKT PRDTKT,ZAE.ZAE_PRDOAC, COUNT(*) TOTCANC, " + CRLF
	cQuery += "  SUM(ZADCANC.ZAD_VLRTKT+ZADCANC.ZAD_VLRSOC) VLRCANC, ZAE.ZAE_CC CC, ZADVEND.ZAD_NFTOTV NFTOTV, ZADVEND.ZAD_SETOTV SETOTV	" + CRLF
	cQuery += "  FROM "+RetSqlName('ZAD') + ' ZADCANC,' +RetSqlName('ZAD') + ' ZADVEND,' + RetSqlName('ZAE') +' ZAE'   + CRLF
	cQuery += "  WHERE ZADVEND.ZAD_FILIAL 	= ZADCANC.ZAD_FILIAL 																			" + CRLF

	If !Empty(dDataIni) .And. !Empty(dDataFim)
		cQuery += "     AND ZADCANC.ZAD_DTCANC BETWEEN '" + DTOS(dDataIni) +"' AND '" + DTOS(dDataFim) +"'"+ CRLF
	Else
		cQuery += "     AND ZADCANC.ZAD_DTCANC BETWEEN '" + cDtIni +"' AND '" + cDtFim +"'"+ CRLF
	EndIf

	cQuery += "  	AND ZADVEND.ZAD_DTVEND 		= ZADCANC.ZAD_DTVEND																		" + CRLF
	cQuery += "  	AND ZADVEND.ZAD_ITEMID		= ZADCANC.ZAD_ITEMID																		" + CRLF
	cQuery += "  	AND ZADVEND.ZAD_EPEP		= ZADCANC.ZAD_EPEP																			" + CRLF
	cQuery += "  	AND ZADVEND.ZAD_TKTID 		= ZADCANC.ZAD_TKTID																			" + CRLF
	cQuery += "  	AND ZADVEND.ZAD_CPF			= ZADCANC.ZAD_CPF																			" + CRLF

	If !Empty(cIdVenda)
		cQuery += "    AND 	ZADCANC.ZAD_SLUID = '"+cIdVenda+"'              																" + CRLF
	EndIf

	cQuery += "  	AND ZADVEND.ZAD_SLUID 		= ZADCANC.ZAD_SLUID																			" + CRLF
	cQuery += "  	AND ZADVEND.ZAD_ITTYPE		= ZADCANC.ZAD_ITTYPE																		" + CRLF
	cQuery += "  	AND ZADVEND.ZAD_TPTRAN 		='1'																						" + CRLF
	cQuery += "     AND ZADVEND.ZAD_TPITEM IN ('1','8','6')" 																				  + CRLF

	If !Empty(cLocalizador)
		cQuery += "    AND 	ZADCANC.ZAD_SEARCH = '"+cLocalizador+"'              															" + CRLF
	EndIf

	cQuery += "  	AND ZADVEND.ZAD_SEARCH 		= ZADCANC.ZAD_SEARCH																		" + CRLF
	cQuery += "  	AND ZADVEND.ZAD_STATUS 		='3'																						" + CRLF
	cQuery += "  	AND ZADCANC.ZAD_TPTRAN 		='2'																						" + CRLF
	cQuery += "  	AND ZADCANC.ZAD_STATUS 		IN ('1','E')																						" + CRLF
	cQuery += "  	AND ZADCANC.ZAD_EPEP 		= ZAE_EPEP																					" + CRLF

	If cEmpAnt =='33'
		cQuery += "  AND EXISTS 															" + CRLF
		cQuery += "  		(SELECT NULL FROM " + RetSqlname('ZAF')+ ' ZAF'					  + CRLF
		cQuery += "  			WHERE ZADCANC.ZAD_FILIAL 	= ZAF.ZAF_FILIAL 				" + CRLF
		cQuery += "  			AND ZADCANC.ZAD_SLUID 		= ZAF.ZAF_SLUID					" + CRLF
		cQuery += "  			AND ZADCANC.ZAD_SEARCH 		= ZAF.ZAF_SEARCH				" + CRLF
		cQuery += "  			AND ZADCANC.ZAD_EPEP 		= ZAF.ZAF_EPEP					" + CRLF
		cQuery +=  " 			AND ZAF_TPPGTO <> 'Bonificado          '					" + CRLF
		cQuery +=  " 			AND ZAF_TPRECB = 'Indireto' 								" + CRLF
		cQuery += "  			AND ZAF_DTCANC <> ' '										" + CRLF
		cQuery += "  			AND ZAF_TIPO LIKE '%Cancelamento por Est%' 					" + CRLF
		cQuery += "  			AND ZAF.D_E_L_E_T_		=' '			)					" + CRLF
	EndIf

	cQuery += "  	AND ZAE_MSBLQL 				<> '1' 																						" + CRLF
//	cQuery += "  	AND ZADCANC.ZAD_DTCANC BETWEEN '20220504' AND '20220504'																" + CRLF //REMOVER
	cQuery += "  	AND ZADCANC.D_E_L_E_T_		=' '																						" + CRLF
	cQuery += "  	AND ZADVEND.D_E_L_E_T_		=' '																						" + CRLF
	cQuery += "  	AND ZAE.D_E_L_E_T_			=' '																						" + CRLF
	cQuery += "  GROUP BY ZADCANC.ZAD_DTCANC,ZADCANC.ZAD_EPEP,ZADCANC.ZAD_SLUID,ZAE.ZAE_PRDTKT,ZAE.ZAE_PRDOAC								" + CRLF
	cQuery += "   ,ZAE_CC,ZADVEND.ZAD_NFTOTV, ZADVEND.ZAD_SETOTV,ZADCANC.ZAD_ITTYPE																	" + CRLF
	cQuery += "  ORDER BY ZADVEND.ZAD_NFTOTV																								" + CRLF
Return cQuery


/*/{Protheus.doc} CIngTot

	Cancelamento Total do Ingresso

	@type function
	@author Felipe Sakaguti - CRM Services
	@since 01/07/2021
	@database Oracle

	@see 

/*/
Static Function CIngTot(cDoc,cSerie,cItType,cSluid,cLocalizador)
	Local lRet 			:= .T.
	Local lMostraCtb	:= .F.
	Local lAglCtb		:= .F.
	Local lContab 		:= .T.
	Local lCarteira		:= .F.
	Local aRegSD2	 	:= {}
	Local aRegSE1	 	:= {}
	Local aRegSE2	 	:= {}
	Local lNfExcl		:= .F.

	dbSelectArea("SF2")
	dbSetOrder(1)
	If dbSeek( xFilial("SF2") + cDoc + cSerie )
		If SF2->F2_EMISSAO >= CTOD('20211201')

			Begin Transaction
				aRegSD2 := {}
				aRegSE1 := {}
				aRegSE2 := {}

				If MaCanDelF2("SF2",SF2->(recno()),@aRegSD2,@aRegSE1,@aRegSE2) .AND. MA521VerSC6(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

					lContab		:=	.T. // CONTABILIZAR ONLINE
					//lMostraCtb	:=	.T.

					Pergunte("MTA521",.F.)
					MV_PAR03 := 1 // força contabilização on line
					SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))

					If !ZADUpd1CancelaIngressoTotal(cDoc,cSerie,cItType,cSluid,cLocalizador,.T.)
						lRet := .F.
						DisarmTransaction()
						//Erro na atualização da ZAD
					EndIf

				EndIf

			End Transaction
		Else
			lRet:=.F.
		EndIf
	Else
		lNfExcl	:= NFEXCLUIDA(cDoc,cSerie)
		If lNfExcl
			ZADUpd1CancelaIngressoTotal(cDoc,cSerie,cItType,cSluid,cLocalizador,.T.)
		EndIf
	EndIf

	If lNfExcl .Or. lRet
		ExclSC6SC9(cDoc,cSerie)
	Else //Tratamento erro
		ZADUpd1ErroCancelaIngressoTotal(cDoc,cSerie,lNfExcl)
	EndIf

Return lRet

Static Function ZADUpd1CancelaIngressoTotal(cDoc,cSerie,cItType,cSluid,cLocalizador,lAchou)
	Local lRet		:= .T.
	Local cQry		:= ""

	cQry := ""

	If lAchou

		cQry += " UPDATE " + RetSqlName("ZAD") + " SET  			" + CRLF
		cQry += " 			ZAD_STATUS 	= '5'						" + CRLF
		cQry += " WHERE 											" + CRLF
		cQry += "		ZAD_SLUID	= '" + cSluid +"'				" + CRLF
		cQry += "		AND ZAD_EPEP	> ' '		  				" + CRLF
		cQry += "		AND ZAD_ITTYPE	= '" + cItType +"'			" + CRLF
		cQry += "		AND ZAD_TPTRAN 	= '1'						" + CRLF

		If !Empty(cLocalizador)
			cQry += "		AND ZAD_SEARCH	= '" + cLocalizador +"'		" + CRLF
		EndIf

		cQry += " 		AND	ZAD_NFTOTV 	= '" + cDoc + "'			" + CRLF
		cQry += "		AND ZAD_SETOTV	= '" + cSerie +"'			" + CRLF
		cQry += "		AND ZAD_STATUS	= '3'						" + CRLF

		cQry += "		AND D_E_L_E_T_ 	= ' '						" + CRLF

		If TCSQLExec(cQry) < 0
			cErro := TCSQLError()
			u_T4F01LOG(cErro)

		EndIf

		cQry := ""

		cQry += " UPDATE " + RetSqlName("ZAD")  				   + CRLF
		cQry += " SET 												" + CRLF
		cQry += " 	ZAD_STATUS = '5'								" + CRLF
		cQry += " WHERE EXISTS  (									" + CRLF
		cQry += "     SELECT NULL									" + CRLF
		cQry += "     FROM " + RetSqlName("ZAD") + " NF				" + CRLF
		cQry += "     WHERE 1 = 1									" + CRLF
		cQry += "		AND NF.ZAD_FILIAL = ZAD_FILIAL			" + CRLF
		cQry += " 		AND NF.ZAD_TKTID  = ZAD_TKTID				" + CRLF
		cQry += " 		AND NF.ZAD_ITTYPE = ZAD_ITTYPE			" + CRLF
		cQry += " 		AND NF.ZAD_TPTRAN = '1'						" + CRLF
		cQry += " 		AND NF.ZAD_STATUS = '5'						" + CRLF
		cQry += " 		AND NF.ZAD_NFTOTV = '"+cDoc+"'				" + CRLF
		cQry += " 		AND NF.ZAD_SETOTV = '"+cSerie+"'			" + CRLF
		cQry += " 		AND NF.ZAD_SEARCH = ZAD_SEARCH			" + CRLF
		cQry += " 		AND NF.ZAD_IDVEND = ZAD_IDVEND				" + CRLF
		cQry += " 		AND NF.ZAD_TPITEM = ZAD_TPITEM				" + CRLF
		cQry += " 		AND NF.D_E_L_E_T_ = ' '						" + CRLF
		cQry += " )														" + CRLF
		cQry += "		AND ZAD_ITTYPE	= '" + cItType +"'			" + CRLF
		cQry += "		AND ZAD_SLUID	= '" + cSluid +"'			" + CRLF

		If !Empty(cLocalizador)
			cQry += "		AND ZAD_SEARCH	= '" + cLocalizador +"'		" + CRLF
		EndIf

		cQry += " 		AND ZAD_TPTRAN = '2'							" + CRLF
		cQry += " 		AND ZAD_STATUS IN ('1','E')							" + CRLF
		cQry += " 		AND D_E_L_E_T_ = ' '							" + CRLF

	Else

		cQry += " UPDATE " + RetSqlName("ZAD") + " SET  			" + CRLF
		cQry += " 			ZAD_OBS 	= 'NOTA NÃO ENCONTRADA OU JA CANCELADA'		" + CRLF
		cQry += " 			,ZAD_STATUS = '5'		" + CRLF
		cQry += " WHERE 											" + CRLF
		cQry += " 			ZAD_NFTOTV 	= '" + cDoc + "'			" + CRLF
		cQry += "		AND ZAD_SETOTV	= '" + cSerie +"'			" + CRLF
		cQry += "		AND ZAD_TPTRAN 	= '1'						" + CRLF
		cQry += "		AND ZAD_STATUS	= '3'						" + CRLF
		cQry += "		AND ZAD_ITTYPE	= '" + cItType +"'			" + CRLF
		cQry += "		AND ZAD_SLUID	= '" + cSluid +"'			" + CRLF

		If !Empty(cLocalizador)
			cQry += "		AND ZAD_SEARCH	= '" + cLocalizador +"'		" + CRLF
		EndIf

		cQry += "		AND D_E_L_E_T_ 	= ' '						" + CRLF

		If TCSQLExec(cQry) < 0
			cErro := TCSQLError()
			u_T4F01LOG(cErro)
		EndIf

		cQry := ""

		cQry += " UPDATE " + RetSqlName("ZAD")  				   + CRLF
		cQry += " SET 												" + CRLF
		cQry += " 	ZAD_OBS 	= 'NOTA NÃO ENCONTRADA OU JÁ CANCELADA'				" + CRLF
		cQry += " 	,ZAD_STATUS = '5'			    				" + CRLF
		cQry += " WHERE EXISTS  (									" + CRLF
		cQry += "     SELECT NULL									" + CRLF
		cQry += "     FROM " + RetSqlName("ZAD") + " NF				" + CRLF
		cQry += "     WHERE 1 = 1									" + CRLF
		cQry += "		AND NF.ZAD_FILIAL = ZAD_FILIAL			" + CRLF
		cQry += " 		AND NF.ZAD_TKTID  = ZAD_TKTID				" + CRLF
		cQry += " 		AND NF.ZAD_TPITEM = ZAD_TPITEM				" + CRLF
		cQry += " 		AND NF.ZAD_SEARCH = ZAD_SEARCH			" + CRLF
		cQry += " 		AND NF.ZAD_ITTYPE = ZAD_ITTYPE			" + CRLF
		cQry += " 		AND NF.ZAD_IDVEND = ZAD_IDVEND				" + CRLF
		cQry += " 		AND NF.ZAD_TPTRAN = '1'						" + CRLF
		cQry += " 		AND NF.ZAD_NFTOTV = '"+cDoc+"'				" + CRLF
		cQry += " 		AND NF.ZAD_SETOTV = '"+cSerie+"'			" + CRLF
		cQry += " 		AND NF.D_E_L_E_T_ = ' '						" + CRLF
		cQry += " )														" + CRLF
		cQry += "		AND ZAD_ITTYPE	= '" + cItType +"'			" + CRLF
		cQry += "		AND ZAD_SLUID	= '" + cSluid +"'			" + CRLF

		If !Empty(cLocalizador)
			cQry += "		AND ZAD_SEARCH	= '" + cLocalizador +"'		" + CRLF
		EndIf

		cQry += " 		AND ZAD_TPTRAN = '2'							" + CRLF
		cQry += " 		AND ZAD_STATUS IN ('1','E')							" + CRLF
		cQry += " 		AND D_E_L_E_T_ = ' '							" + CRLF

		If TCSQLExec(cQry) < 0
			cErro := TCSQLError()
			u_T4F01LOG(cErro)
		EndIf

	EndIf


Return lRet


Static Function ZADUpd1ErroCancelaIngressoTotal(cDoc,cSerie,cItType,lNfExcl)
	Local lRet		:= .T.
	Local cQry		:= ""

	cQry := ""

	cQry += " UPDATE " + RetSqlName("ZAD") + " ZAD					" + CRLF
	cQry += " SET 													" + CRLF

	If lNfExcl
		cQry += " 	ZAD.ZAD_STATUS = '5'								" + CRLF
		cQry += " 	,ZAD_OBS = 'CANCELAMENTO PROCESSADO : "+cDoc+		"'" + CRLF
	Else
		cQry += " 	ZAD.ZAD_STATUS = 'E'								" + CRLF
		cQry += " 	,ZAD_OBS = 'ERRO NO CANCELAMENTO NF : "+cDOC+       "'" + CRLF
	EndIf

	cQry += " WHERE EXISTS  (										" + CRLF
	cQry += "     SELECT NULL										" + CRLF
	cQry += "     FROM " + RetSqlName("ZAD") + " NF					" + CRLF
	cQry += "     WHERE 1 = 1										" + CRLF
	cQry += " 		AND NF.ZAD_TPTRAN = '1'							" + CRLF
	cQry += " 		AND NF.ZAD_STATUS = '3'							" + CRLF
	cQry += " 		AND NF.ZAD_NFTOTV = '"+cDoc+"'					" + CRLF
	cQry += " 		AND NF.ZAD_SETOTV = '"+cSerie+"'				" + CRLF
	cQry += " 		AND NF.ZAD_IDTYPE = '"+cItType+"'				" + CRLF
	cQry += " 		AND NF.D_E_L_E_T_ = ' '							" + CRLF
	cQry += "		AND NF.ZAD_FILIAL = ZAD.ZAD_FILIAL				" + CRLF
	cQry += " 		AND NF.ZAD_SEARCH = ZAD.ZAD_SEARCH				" + CRLF
	cQry += " 		AND NF.ZAD_ITTYPE = ZAD.ZAD_ITTYPE				" + CRLF
	cQry += " 		AND NF.ZAD_IDVEND = ZAD.ZAD_IDVEND				" + CRLF
	cQry += " 		AND NF.ZAD_TKTID  = ZAD.ZAD_TKTID				" + CRLF
	cQry += " 		AND NF.ZAD_TPITEM = ZAD.ZAD_TPITEM				" + CRLF
	cQry += " )														" + CRLF
	cQry += " 	AND ZAD.ZAD_TPTRAN = '2'							" + CRLF
	cQry += " 	AND ZAD.ZAD_STATUS IN ('1','E')							" + CRLF
	cQry += " 	AND ZAD.D_E_L_E_T_ = ' '							" + CRLF

	If TCSQLExec(cQry) < 0
		cErro := TCSQLError()
		u_T4F01LOG(cErro)
	EndIf

Return lRet

/*/{Protheus.doc} CIngParc

	Cancelamento Parcial do Ingresso

	@type function
	@author Felipe Sakaguti - CRM Services
	@since 01/07/2021
	@database Oracle

	@see 

/*/

Static Function CIngParc(aDados,oGrid) //cDtCanc,cEpep,cPrdTkt,nTOTCANC,nVLRCANC,cCC,cSluid
	Local lRet			:= .T.
	Local cTesDev	:= ""
	Local cCf		:= ""
	Local cItem		:= '0001'
	Local aLinha 	:= {}
	Local aItens	:= {}
	Local aCabec	:= {}
	Local cArqLog	:= ""
	Local cMsgLog	:= ""
	Local cDocDev	:= ""
	Local cSerieTot	:= ""
	Local cItemNF	:= ""
	Local nx		:= 0
	Local cItemOri	:= ''
	Local cNumSeq	:= ''

	Default cDoc	:= ""
	Default cSerie	:= ""
	Default nQtdNF	:= 0

	Private cAliasNFCanc 	:= " " //GetNextAlias()
	Private lMsErroAuto := .F.

	cDtCanc := aDados[1][1]

	dDtBkp	:= dDataBase

	cItemNF := "01"

	dbSelectArea("SF4")
	dbSetOrder(1)

	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))

	cSerieTot	:=	"DEV"
	cDocDev 	:=	NxtSx5Nota(cSerieTot, .T., GetNewPar("MV_TPNRNFS","3"))

	For nx:= 1 To Len(aDados)

		dDataBase := STOD(cDtCanc)

		If cDtCanc == aDados[nx][1]

			If len(aCabec) == 0

				aadd(aCabec, {"F1_DOC" 		, cDocDev					,Nil 	})
				aadd(aCabec, {"F1_SERIE" 	, cSerieTot					,Nil 	})
				aadd(aCabec, {"F1_FORNECE" 	, 'W05285'					,Nil 	})
				aadd(aCabec, {"F1_LOJA" 	, '01'						,Nil 	})
				aadd(aCabec, {"F1_EMISSAO" 	, STOD(aDados[nx][1])		,Nil 	})
				aadd(aCabec, {"F1_DTDIGIT" 	, STOD(aDados[nx][1])		,Nil 	})
				AADD(aCabec, {"F1_EST"		, 'SP' 						,Nil 	})
				aadd(aCabec, {"F1_COND"		, "001"						,Nil	})
				Aadd(aCabec, {"F1_RECBMTO" 	, STOD(aDados[nx][1])	    ,Nil 	})
				Aadd(aCabec, {"F1_CHVNFE"  	, ''			       		,Nil 	})
				aadd(aCabec, {"F1_TIPO" 	, "N"						,Nil 	})
				aadd(aCabec, {"F1_FORMUL" 	, "S"						,Nil	})
				aadd(aCabec, {"F1_ESPECIE"	, "NFE" 					,Nil	})
				AAdd(aCabec, {"F1_TPFRETE" 	, "C"				 		,Nil	})
				Aadd(aCabec, {"F1_NATUREZ" 	, "101700"    		 		,Nil 	})

			EndIf

			If FWIsInCallStack('u_T4F03M') .Or. FWIsInCallStack('u_T4FCANC')
				cMsg := "Incluindo item ["+aDados[nx][2]+"]
				FWLogMsg("INFO", "", "", "T4F02CANC.PRW", "", "","INICIO PROCESSO CANCELAMENTO "+cMsg, 0, 0)
				If !Empty(aDados[nx][2])
					oGrid:SetIncMeter(1,cMsg)
				Else
					FWLogMsg("INFO", "", "", "T4F02CANC.PRW", "", "",cMsg, 0, 0)
				EndIf
			EndIf

			If SB1->(MsSeek(xFilial("SB1") + Alltrim(aDados[nx][3])))
				cF4TES := SB1->B1_TS
				cConta := SB1->B1_CONTA
				cUm    := SB1->B1_UM
			End If

			If SF4->(MSSeek(xFilial("SF4")+cF4TES))
				cTesDev	:=	SF4->F4_TESDV
			EndIf

			If SF4->(MSSeek(xFilial("SF4")+cTesDev))
				cCf		:=	SF4->F4_CF
			EndIf

			If SD2->(MsSeek(xFilial("SD2") + aDados[nx][8] + aDados[nx][9] + "SEMCPF" + "01" + Alltrim(aDados[nx][3]))) //DEVOLUÇÃO PRODUTOS INGRESSOS

				If SD2->D2_QUANT >= SD2->D2_QTDEDEV .And. (aDados[nx][5]/aDados[nx][4] ) > 0

					cItemOri	:= SD2->D2_ITEM
					cNumSeq		:= SD2->D2_NUMSEQ

					aAdd(aLinha,	{"D1_ITEM" 		,	cItem 						,Nil	})
					aAdd(aLinha,	{"D1_EMISSAO"	,	Stod(aDados[nx][1])			,Nil	})
					aadd(aLinha,	{"D1_COD" 		,	Alltrim(aDados[nx][3]) 		,Nil	})
					Aadd(aLinha, 	{"D1_UM"      	, 	cUm              			,Nil	})
					aadd(aLinha,	{"D1_QUANT" 	,	aDados[nx][4] 				,Nil	})
					aadd(aLinha,	{"D1_VUNIT" 	,	aDados[nx][5]/aDados[nx][4]	,Nil	})
					aadd(aLinha,	{"D1_TOTAL" 	,	aDados[nx][5]				,Nil	})
					aadd(aLinha,	{"D1_TES" 		,	cTesDev						,Nil	})//TES DEVOLUÇÃO
					aadd(aLinha,	{"D1_CF" 		,	cCf							,Nil	})//TES DEVOLUÇÃO
					aadd(aLinha,	{"D1_NFORI" 	,	aDados[nx][8]			 	,Nil	}) // nota de origem
					aadd(aLinha,	{"D1_SERIORI"	,	aDados[nx][9] 				,Nil	})
					aadd(aLinha,	{"D1_ITEMORI"	,	cItemOri					,Nil	})
					AAdd(aLinha,	{"D1_IDENTB6"	,	cNumSeq						,Nil	})
					aAdd(aLinha,	{"D1_ITEMCTA"   ,	aDados[nx][2]				,Nil	}) // *
					aAdd(aLinha,	{"D1_CC" 		,	aDados[nx][6]      			,Nil	}) // *
					aAdd(aLinha,	{"D1_CONTA" 	,	cConta		 				,Nil	}) //
					aadd(aLinha,	{"AUTDELETA" 	,	"N" 						,Nil	})

					aAdd(aItens,aLinha)

					aLinha	:=	{}
					cItem	:=	Soma1(cItem)

					cDtCanc := aDados[nx][1]

					RecLock('SD2',.F.)

					SD2->D2_QTDEDEV := SD2->D2_QTDEDEV + aDados[nx][4]

					SD2->(MsUnlock())

				End If

			ElseIf SD2->(MsSeek(xFilial("SD2") + aDados[nx][8] + aDados[nx][9] + "SEMCPF" + "01" + Alltrim(aDados[nx][10]))) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

				If SD2->D2_QUANT >= SD2->D2_QTDEDEV .And. (aDados[nx][5]/aDados[nx][4]) > 0

					cItemOri	:= SD2->D2_ITEM
					cNumSeq		:= SD2->D2_NUMSEQ

						aAdd(aLinha,	{"D1_ITEM" 		,	cItem 						,Nil	})
						aAdd(aLinha,	{"D1_EMISSAO"	,	Stod(aDados[nx][1])			,Nil	})
						aadd(aLinha,	{"D1_COD" 		,	Alltrim(aDados[nx][10]) 		,Nil	})
						Aadd(aLinha, 	{"D1_UM"      	, 	cUm              			,Nil	})
						aadd(aLinha,	{"D1_QUANT" 	,	aDados[nx][4] 				,Nil	})
						aadd(aLinha,	{"D1_VUNIT" 	,	aDados[nx][5]/aDados[nx][4]	,Nil	})
						aadd(aLinha,	{"D1_TOTAL" 	,	aDados[nx][5]				,Nil	})
						aadd(aLinha,	{"D1_TES" 		,	cTesDev						,Nil	})//TES DEVOLUÇÃO
						aadd(aLinha,	{"D1_CF" 		,	cCf							,Nil	})//TES DEVOLUÇÃO
						aadd(aLinha,	{"D1_NFORI" 	,	aDados[nx][8]			 	,Nil	}) // nota de origem
						aadd(aLinha,	{"D1_SERIORI"	,	aDados[nx][9] 				,Nil	})
						aadd(aLinha,	{"D1_ITEMORI"	,	cItemOri					,Nil	})
						AAdd(aLinha,	{"D1_IDENTB6"	,	cNumSeq						,Nil	})
						aAdd(aLinha,	{"D1_ITEMCTA"   ,	aDados[nx][2]				,Nil	}) // *
						aAdd(aLinha,	{"D1_CC" 		,	aDados[nx][6]      			,Nil	}) // *
						aAdd(aLinha,	{"D1_CONTA" 	,	cConta		 				,Nil	}) //
						aadd(aLinha,	{"AUTDELETA" 	,	"N" 						,Nil	})

						aAdd(aItens,aLinha)

						aLinha	:=	{}
						cItem	:=	Soma1(cItem)

						cDtCanc := aDados[nx][1]
					
					RecLock('SD2',.F.)

					SD2->D2_QTDEDEV := SD2->D2_QTDEDEV + aDados[nx][4]

					SD2->(MsUnlock())
				EndIf

			End If
		Else
			If Len(aCabec) > 0 .And. Len(aItens) > 0
				Begin Transaction
					ddatabase := aCabec[5][2]

					MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCabec,aItens,3)

					aCabec	:=	{}
					aItens 	:=	{}

				End Transaction

				If !lMsErroAuto

					ZADUpd2CancelaIngressoParcial(aDados,cDocDev,cSerieTot)

					cDocDev :=	NxtSx5Nota(cSerieTot, .T., GetNewPar("MV_TPNRNFS","3"))

				Else
					lRet := .F.

					cArqLog := SubStr( Time(),1,5 ) + ".log"

					cMsgLog := MostraErro("\log_INTI", cArqLog) + CRLF

					u_T4F01LOG(cMsgLog)

					cMsgLog :=	"DEV INTERROMPIDA LER ARQUIVO "+"\log_INTI\"+cArqLog

					If !lRet	//Tratamento ZAD para Erro
						ZADUpd2ErroCancelaIngressoParcial(aDados,cMsgLog)
					EndIf

				EndIf

			EndIf
		Endif

		cDtCanc := aDados[nx][1]

	Next nx

	If Len(aCabec) > 0 .And. Len(aItens) > 0
		Begin Transaction
			ddatabase := aCabec[5][2]

			//MSExecAuto({|x,y,z| mata103(x,y,z)},aCabec,aItens,3)
			MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCabec,aItens,3)

			aCabec	:=	{}
			aItens 	:=	{}
		End Transaction

		If !lMsErroAuto

			ZADUpd2CancelaIngressoParcial(aDados,cDocDev,cSerieTot)

		Else
			lRet := .F.

			cArqLog := SubStr( Time(),1,5 ) + ".log"

			cMsgLog := MostraErro("\log_INTI", cArqLog) + CRLF

			u_T4F01LOG(cMsgLog)

			If !Empty(dDataIni)
				Alert(cMsgLog)
			EndIf

			DisarmTransaction()
		EndIf

	EndIf

	dDataBase := dDtBkp

Return lRet

Static Function GetB1Dados(cB1Cod,nValor,cTesDev,cCf)
	Local cF4TES	:= ""

	Default cB1Cod	:= ""
	Default nValor	:= ""
	Default cTesDev	:= ""
	Default cCf		:= ""

	If (cAliasNFCanc)->ZAD_VLRTKT <> 0

		cB1Cod  :=  (cAliasNFCanc)->ZAE_PRDTKT
		nValor	:=	Abs((cAliasNFCanc)->ZAD_VLRTKT)

	ElseIf (cAliasNFCanc)->ZAD_VLRXCA <> 0

		cB1Cod  :=  (cAliasNFCanc)->ZAE_PDTXCA
		nValor	:=	Abs((cAliasNFCanc)->ZAD_VLRXCA)

	ElseIf (cAliasNFCanc)->ZAD_VLRTXO <> 0

		cB1Cod  :=  (cAliasNFCanc)->ZAE_PRDTXO
		nValor	:=	Abs((cAliasNFCanc)->ZAD_VLRTXO)

	ElseIf (cAliasNFCanc)->ZAD_VLRTXS <> 0

		cB1Cod  :=  (cAliasNFCanc)->ZAE_PRDTXS
		nValor	:=	Abs((cAliasNFCanc)->ZAD_VLRTXS)

	ElseIf (cAliasNFCanc)->ZAD_VLRTXC <> 0

		cB1Cod  :=  (cAliasNFCanc)->ZAE_PRDTXC
		nValor	:=	Abs((cAliasNFCanc)->ZAD_VLRTXC)

	ElseIf (cAliasNFCanc)->ZAD_VLRTXI <> 0

		cB1Cod  :=  (cAliasNFCanc)->ZAE_PRDTXI
		nValor	:=	Abs((cAliasNFCanc)->ZAD_VLRTXI)

	ElseIf (cAliasNFCanc)->ZAD_VLRSOC <> 0

		cB1Cod  :=  (cAliasNFCanc)->ZAE_PRDSOC
		nValor	:=	Abs((cAliasNFCanc)->ZAD_VLRSOC)

	EndIf


	If SB1->(MsSeek(xFilial("SB1") + Alltrim(cB1Cod)))
		cF4TES := SB1->B1_TS
	End If

	dbSelectArea("SF4")
	dbSetOrder(1)
	If SF4->(MSSeek(xFilial("SF4")+cF4TES))
		cTesDev	:=	SF4->F4_TESDV
		cCf		:=	SF4->F4_CF
	EndIf

Return

Static Function GetA1Dados(cCli, cLoja, cCliEst)
	Default cCli		:= ""
	Default cLoja		:= ""
	Default cCliEst		:= ""

	If !Empty((cAliasNFCanc)->ZAD_CPF)

		dbSelectArea("SA1")
		dbSetOrder(3)
		If SA1->(DbSeek( xFilial("SA1") + Alltrim((cAliasNFCanc)->ZAD_CPF) ) )
			cCli	:= SA1->A1_COD
			cLoja	:= SA1->A1_LOJA
			cCliEst	:= SA1->A1_EST
		EndIf
	EndIf

	If Empty(AllTrim(cCli))
		cCli	:=	"SEMCPF"
		cLoja	:=	"01"
	EndIf

Return

Static Function QryIngParc(cDoc,cSerie,cItType,cSluid,cLocalizador,lTemId)
	Local cQuery := ""

	Default cDoc	:= ""
	Default cSerie	:= ""

	cQuery += " SELECT 	                            	        " + CRLF
	cQuery += "  	SUM(ZAD.ZAD_VLRTKT) ZAD_VLRTKT, " + CRLF
	cQuery += "  	ZAE.ZAE_PDTXCA, " + CRLF
	cQuery += "  	SUM(ZAD.ZAD_VLRXCA) ZAD_VLRXCA, " + CRLF
	cQuery += "  	ZAE.ZAE_PRDTXO, " + CRLF
	cQuery += "  	SUM(ZAD.ZAD_VLRTXO) ZAD_VLRTXO, " + CRLF
	cQuery += "  	SUM(ZAD.ZAD_VLRTXS) ZAD_VLRTXS, " + CRLF
	cQuery += "  	ZAE.ZAE_PRDTXS, " + CRLF
	cQuery += "  	SUM(ZAD.ZAD_VLRTXC) ZAD_VLRTXC, " + CRLF
	cQuery += "  	ZAE.ZAE_PRDTXC, " + CRLF
	cQuery += "  	SUM(ZAD.ZAD_VLRTXI) ZAD_VLRTXI, " + CRLF
	cQuery += "  	ZAE.ZAE_PRDTXI, " + CRLF
	cQuery += "  	SUM(ZAD.ZAD_VLRSOC) ZAD_VLRSOC, " + CRLF
	cQuery += "     ZAE.ZAE_PRDTKT,                             " + CRLF
	cQuery += "     ZAE.ZAE_PRTKT2,                             " + CRLF
	cQuery += "     ZAE.ZAE_PRDSOC,                             " + CRLF
	cQuery += "     ZAD.ZAD_CPF   ,                             " + CRLF
	cQuery += "     ZAD.ZAD_SEARCH,                             " + CRLF

	If lTemId
		cQuery += "     ZAD.ZAD_ITEMID,                             " + CRLF
	EndIf

	cQuery += "     SUM(ZAD.ZAD_VLRTKT) ZAD_VLRTKT              " + CRLF
	cQuery += " FROM "+RetSqlName("ZAD")+" ZAD                  " + CRLF
	cQuery += " INNER JOIN "+RetSqlName("ZAE")+" ZAE ON         " + CRLF
	cQuery += "     ZAD.ZAD_EPEP		= ZAE_EPEP              " + CRLF
	cQuery += "     AND ZAE_MSBLQL <> '1'						" + CRLF
	cQuery += "     AND ZAE.D_E_L_E_T_ = ' '                    " + CRLF
	cQuery += " WHERE ZAD.ZAD_SLUID   = '"+cSluid+      "'"       + CRLF

	If !Empty(cLocalizador)
		cQuery += " AND ZAD.ZAD_SEARCH	= '"+cLocalizador+"'"      + CRLF
	EndIf

	cQuery += "     AND ZAD.ZAD_TPITEM	= '1'"            + CRLF
	cQuery += "     AND ZAD.ZAD_STATUS IN ('1','E')                   " + CRLF
	cQuery += "     AND ZAD.ZAD_TPTRAN = '2'                   " + CRLF
	cQuery += "     AND ZAD.D_E_L_E_T_ = ' '                   " + CRLF
	cQuery += " GROUP BY	                           	        " + CRLF
	cQuery += "     ZAE.ZAE_PRDTKT,                             " + CRLF

	If lTemId
		cQuery += "     ZAD.ZAD_ITEMID,                             " + CRLF
	EndIf

	cQuery += "     ZAE.ZAE_PRTKT2,                             " + CRLF
	cQuery += "     ZAE.ZAE_PRDSOC,                             " + CRLF
	cQuery += "     ZAD.ZAD_SEARCH,                             " + CRLF
	cQuery += "     ZAD.ZAD_CPF,                              	" + CRLF
	cQuery += "  	ZAE.ZAE_PDTXCA, 							" + CRLF
	cQuery += "  	ZAE.ZAE_PRDTXO, 							" + CRLF
	cQuery += "  	ZAE.ZAE_PRDTXS, 							" + CRLF
	cQuery += "  	ZAE.ZAE_PRDTXC, 							" + CRLF
	cQuery += "  	ZAE.ZAE_PRDTXI 								" + CRLF

Return cQuery

Static Function ZADUpd2CancelaIngressoParcial(aDados,cDocDev,cSerieTot)
	Local lRet		:= .T.
	Local cQry		:= ""
	Local cErro		:= ""
	Local nRet		:= .T.
	Local nx		:= 0

	Default cDocDev := ""

	//(cAlias)->DTCANC,(cAlias)->EPEP,(cAlias)->PRDTKT,(cAlias)->TOTCANC,(cAlias)->VLRCANC*-1,(cAlias)->CC,(cAlias)->SLUID

	For nx:=1 To Len(aDados)

		// ATUALIZA REGISTROS DA VENDA
		cQry := ""
		cQry += " UPDATE " + RetSqlName("ZAD") + " ZAD					" + CRLF
		cQry += " SET 													" + CRLF
		cQry += " 	ZAD.ZAD_STATUS = '5' 								" + CRLF
		cQry += " 	,ZAD_OBS = 'Doc Devolução:"+cDocDev+"/"+cSerieTot+"'" + CRLF
		cQry += " WHERE ZAD.ZAD_STATUS = '3'							" + CRLF
		cQry += " 	AND ZAD.ZAD_TPTRAN = '1'							" + CRLF
		cQry += " 	AND ZAD.D_E_L_E_T_ = ' '							" + CRLF
		cQry += " 	AND ZAD.ZAD_EPEP = '"+aDados[nx][2]+"'				" + CRLF
		cQry += " 	AND ZAD.ZAD_SLUID = '"+aDados[nx][7]+"'				" + CRLF
		cQry += " 	AND ZAD.ZAD_NFTOTV = '"+aDados[nx][8]+"'			" + CRLF
		cQry += " 	AND ZAD.ZAD_SETOTV = '"+aDados[nx][9]+"'			" + CRLF
		cQry += " 	AND ZAD.ZAD_ITTYPE = '"+aDados[nx][11]+"'			" + CRLF

		nRet := TCSQLExec(cQry)
		If nRet < 0
			cErro := TCSQLError()
			u_T4F01LOG(cErro)
			lRet := .F.
		EndIf

		// ATUALIZA REGISTROS DA DEVOLUÇÃO/CANCELAMENTO
		cQry := ""

		cQry += " UPDATE " + RetSqlName("ZAD") + " ZAD					" + CRLF
		cQry += " SET 													" + CRLF
		cQry += " 	ZAD.ZAD_STATUS = '5'								" + CRLF
		cQry += " 	,ZAD.ZAD_NFTOTV = '"+cDocDev+"'						" + CRLF
		cQry += " 	,ZAD.ZAD_SETOTV = '"+cSerieTot+"'					" + CRLF
		cQry += " 	,ZAD_OBS = 'Doc Original: "+aDados[nx][8]+"/"+aDados[nx][9] + "'"+CRLF
		cQry += " WHERE ZAD.ZAD_TPTRAN = '2'							" + CRLF
		cQry += " 	AND ZAD.ZAD_STATUS IN ('1','E')							" + CRLF
		cQry += " 	AND ZAD.ZAD_EPEP = '"+aDados[nx][2]+"'				" + CRLF
		cQry += " 	AND ZAD.ZAD_SLUID = '"+aDados[nx][7]+"'				" + CRLF
		cQry += " 	AND ZAD.ZAD_ITTYPE = '"+aDados[nx][11]+"'			" + CRLF
		cQry += " 	AND ZAD.D_E_L_E_T_ = ' '							" + CRLF

		nRet := TCSQLExec(cQry)
		If nRet < 0
			cErro := TCSQLError()
			u_T4F01LOG(cErro)
			lRet := .F.
		EndIf

	Next nx

Return lRet

Static Function ZADUpd2ErroCancelaIngressoParcial(aDados,cMsgLog)
	Local lRet		:= .T.
	Local cQry		:= ""
	Local cErro		:= ""
	Local nRet		:= .T.
	Local nx		:= 0
	Default cDocDev := ""

	cMsgLog	:= SUBSTR(cMsgLog,1,40)

	For nx:=1 To Len(aDados)

		cQry := ""

		cQry += " UPDATE " + RetSqlName("ZAD") + " ZAD					" + CRLF
		cQry += " SET 													" + CRLF
		cQry += " 	ZAD.ZAD_STATUS = 'E'								" + CRLF
		cQry += " 	,ZAD_OBS = 'Err Dev: "+cMsgLog+"' 				    " + CRLF
		cQry += " WHERE ZAD.ZAD_TPTRAN = '2'							" + CRLF
		cQry += " 	AND ZAD.ZAD_STATUS = '1'							" + CRLF
		cQry += " 	AND ZAD.ZAD_EPEP = '"+aDados[nx][2]+"'				" + CRLF
		cQry += " 	AND ZAD.ZAD_SLUID = '"+aDados[nx][7]+"'				" + CRLF
		cQry += " 	AND ZAD.D_E_L_E_T_ = ' '							" + CRLF


		nRet := TCSQLExec(cQry)
		If nRet < 0
			cErro := TCSQLError()
			u_T4F01LOG(cErro)
			lRet := .F.
			//Erro na execução SQL
		EndIf

	Next nx

Return lRet
/*/{Protheus.doc} CSrvTot

	Cancelamento Total das Taxas (NFS)

	@type function
	@author Felipe Sakaguti - CRM Services
	@since 04/07/2021
	@database Oracle

	@see 

/*/
Static Function CSrvTot(cDoc,cSerie,cItType,dDtBkp)
	Local lRet 			:= .F.
	Local cAlias    	:= 'SF2'
	Local cCodMun 		:= SM0->M0_CODMUN
	Local cNotasOk 		:= ''
	Local cDest			:= ''
	Local lAuto			:= .T.
	Local cGravaDest	:= ''
	Local lUsaColab		:= .F.
	Local lSF3Canc		:= .F.
	Local cRetMsg		:= ""

	Local aParam		:= {}
	Local aRetNotas		:= {}
	Local nX			:= 0

	Local lMostraCtb	:= .F.
	Local lAglCtb		:= .F.
	Local lContab 		:= .T.
	Local lCarteira := .F.
	Local aRegSD2	 	:= {}
	Local aRegSE1	 	:= {}
	Local aRegSE2	 	:= {}

	Local lNfExcl		:=.F.

	Begin Transaction

		dbSelectArea("SF2")
		dbSetOrder(1)
		If dbSeek( xFilial("SF2") + cDoc + cSerie ) .And. SF2->F2_EMISSAO >= CTOD('20211201')

			dbSelectArea("SC6")
			dbSetOrder(4)
			If dbSeek( xFilial("SC6") + cDoc + cSerie )

				aRegSD2 := {}
				aRegSE1 := {}
				aRegSE2 := {}

				If MaCanDelF2("SF2",SF2->(recno()),@aRegSD2,@aRegSE1,@aRegSE2) .AND. MA521VerSC6(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

					lContab	:=	.T.
					Pergunte("MTA521",.F.)
					MV_PAR03 := 1
					SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))

					If FWIsInCallStack('U_T4F02CANC')

						If SF2->F2_SERIE == 'S  '

							cQrySF3:= " "
							cQrySF3+= " SELECT F3_NFISCAL, F3_SERIE, F3_NFELETR, F3_CODNFE,F3_CODRET FROM "+RetSqlName("SF3")
							cQrySF3+= " WHERE F3_NFISCAL = '"+SF2->F2_DOC +"'"
							cQrySF3+= " AND F3_SERIE = '"+ SF2->F2_SERIE +"'"
							cQrySF3+= " AND F3_DTCANC <> ' '
							cQrySF3+= " AND F3_CODNFE <> ' '
							cQrySF3+= " AND D_E_L_E_T_ =' '

							cQrySF3 := ChangeQuery(cQrySF3)

							cAliasSF3  := MPSysOpenQuery(cQrySF3)

							(cAliasSF3)->(DbGotop())

							If !Empty((cAliasSF3)->F3_NFISCAL)

								cCodMun 	:= SM0->M0_CODMUN
								cUsaColab	:= GetNewPar("MV_SPEDCOL","N")
								cURL       	:= Padr(GetNewPar("MV_SPEDURL",""),250)
								cInscMun   	:= Alltrim(SM0->M0_INSCM)
								cVerTSS    	:= ""
								cTypeaXML  	:= ""
								cEntSai		:= "1"
								cIdent		:= U_GetIdEnt()
								cNotasOk	:= ""
								cDest		:= ''
								lAuto		:= .T.
								cGravaDest	:= ''
								lUsaColab	:= .F.
								lSF3Canc	:= .F.

								FisaCanc(cCodMun,cAlias,@cNotasOk,cSerie,cDoc,cDoc,cDest,lAuto,cGravaDest,lUsaColab,lSF3Canc)
								lRet := EnvCanNFSe(.T., {cSerie,cDoc,cDoc})

							Else
								lRet := .T.
							EndIf
						Else
							lRet := .T.
						EndIf

					Else
						lRet := .T.
					EndIf

				Else
					lRet := .F.
				EndIf

			Else

				cTexto := cDoc+'-'+ cSerie +'-NAO ACHOU SC6' +CHR(13)+CHR(10)
				nHandle := fopen('\log_INTI\errocancelada.txt' , FO_READWRITE + FO_SHARED )
				If !(nHandle == -1)
					FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
					FWrite(nHandle, cTexto, 30) // Insere texto no arquivo
					fclose(nHandle)                   // Fecha arquivo

				Endif

			EndIf

		Else
			lNfExcl	:= NFEXCLUIDA(cDoc,cSerie)
			lRet	:= .T.

			cTexto := cDoc+'-'+ cSerie +'-NAO ACHOU SF2' +CHR(13)+CHR(10)
			nHandle := fopen('\log_INTI\errocancelada.txt' , FO_READWRITE + FO_SHARED )
			If !(nHandle == -1)
				FSeek(nHandle, 0, FS_END)         // Posiciona no fim do arquivo
				FWrite(nHandle, cTexto, 30) // Insere texto no arquivo
				fclose(nHandle)                   // Fecha arquivo

			Endif

		EndIf

		If !lRet
			DisarmTransaction()
		Else
			If !Empty(cItType)
				ZADUpd3CancelaServicoTotal(cDoc,cSerie,cItType)
			EndIf
		EndIf

	End Transaction

	If lRet
		ExclSC6SC9(cDoc,cSerie)
	Else
		If !Empty(cItType)
			ZADUpd3ErroCancTot(cDoc,cSerie,cItType,lNfExcl)
		EndIf
	EndIf

Return lRet

Static Function ZADUpd3CancelaServicoTotal(cDoc,cSerie,cItType)
	Local lRet		:= .T.
	Local cQry		:= ""

	cQry += " UPDATE "+RetSqlName("ZAD") + " SET  				" + CRLF
	cQry += " 			ZAD_STATUS 	= '5'						" + CRLF
	cQry += " WHERE 											" + CRLF
	cQry += " 			ZAD_NFTOTV 	= '" + cDoc + "'			" + CRLF
	cQry += "		AND ZAD_SETOTV	= '" + cSerie +"'			" + CRLF
	cQry += "		AND ZAD_ITTYPE	= '" + cItType +"'			" + CRLF
	//cQry += "		AND ZAD_FILIAL	= '" + xFilial("ZAD") +"'	" + CRLF
	cQry += "		AND ZAD_TPTRAN 	= '1'						" + CRLF
	cQry += "		AND ZAD_STATUS	= '3'						" + CRLF
	cQry += "		AND D_E_L_E_T_ 	= ' '						" + CRLF

	If TCSQLExec(cQry) < 0
		cErro := TCSQLError()
		u_T4F01LOG(cErro)
	EndIf

	cQry := ""

	cQry += " UPDATE " + RetSqlName("ZAD") + " ZAD					" + CRLF
	cQry += " SET 													" + CRLF
	cQry += " 	ZAD.ZAD_STATUS = '5'								" + CRLF
	cQry += " WHERE EXISTS  (										" + CRLF
	cQry += "     SELECT NULL										" + CRLF
	cQry += "     FROM " + RetSqlName("ZAD") + " NF					" + CRLF
	cQry += "     WHERE 1 = 1										" + CRLF
	cQry += " 		AND NF.ZAD_TPTRAN = '1'							" + CRLF
	cQry += " 		AND NF.ZAD_STATUS = '5'							" + CRLF
	cQry += " 		AND NF.ZAD_NFTOTV = '"+cDoc+"'					" + CRLF
	cQry += " 		AND NF.ZAD_SETOTV = '"+cSerie+"'				" + CRLF
	cQry += " 		AND NF.ZAD_ITTYPE = '"+cItType+"'				" + CRLF
	cQry += " 		AND NF.D_E_L_E_T_ = ' '							" + CRLF
	cQry += "		AND NF.ZAD_FILIAL = ZAD.ZAD_FILIAL				" + CRLF
	cQry += " 		AND NF.ZAD_SEARCH = ZAD.ZAD_SEARCH				" + CRLF
	cQry += " 		AND NF.ZAD_ITTYPE = ZAD.ZAD_ITTYPE				" + CRLF
	cQry += " 		AND NF.ZAD_IDVEND = ZAD.ZAD_IDVEND				" + CRLF
	cQry += " 		AND NF.ZAD_TKTID  = ZAD.ZAD_TKTID				" + CRLF
	cQry += " 		AND NF.ZAD_TPITEM = ZAD.ZAD_TPITEM				" + CRLF
	cQry += " )														" + CRLF
	cQry += " 	AND ZAD.ZAD_TPTRAN = '2'							" + CRLF
	cQry += " 	AND ZAD.ZAD_STATUS IN ('1','E')							" + CRLF
	cQry += " 	AND ZAD.D_E_L_E_T_ = ' '							" + CRLF


	If TCSQLExec(cQry) < 0
		cErro := TCSQLError()
		u_T4F01LOG(cErro)
		//Erro na execução SQL
	EndIf

Return lRet

Static Function ZADUpd3ErroCancTot(cDoc,cSerie,cItType,lNfExcl)
	Local lRet		:= .T.
	Local cQry		:= ""
	Local nStatus	:= 0

	cQry += " UPDATE " + RetSqlName("ZAD") + " ZAD					" + CRLF
	cQry += " SET 													" + CRLF

	If lNfExcl
		cQry += " 	ZAD.ZAD_STATUS = '5'								" + CRLF
		cQry += " 	,ZAD_OBS = 'CANCELAMENTO PROCESSADO : "+cDoc+		"'" + CRLF
	Else
		cQry += " 	ZAD.ZAD_STATUS = 'E'								" + CRLF
		cQry += " 	,ZAD_OBS = 'Erro Canc NFE Dt: '" +	DTOC(dDataBase) +	"'" + CRLF
	EndIf

	cQry += " WHERE EXISTS  (										" + CRLF
	cQry += "     SELECT NULL										" + CRLF
	cQry += "     FROM " + RetSqlName("ZAD") + " NF					" + CRLF
	cQry += "     WHERE 1 = 1										" + CRLF
	cQry += " 		AND NF.ZAD_TPTRAN = '1'							" + CRLF
	cQry += " 		AND NF.ZAD_STATUS = '3'							" + CRLF
	cQry += " 		AND NF.ZAD_NFTOTV = '"+cDoc+"'					" + CRLF
	cQry += " 		AND NF.ZAD_SETOTV = '"+cSerie+"'				" + CRLF
	cQry += " 		AND NF.ZAD_ITTYPE = '"+cItType+"'				" + CRLF
	cQry += " 		AND NF.D_E_L_E_T_ = ' '							" + CRLF
	cQry += "		AND NF.ZAD_FILIAL = ZAD.ZAD_FILIAL				" + CRLF
	cQry += " 		AND NF.ZAD_SEARCH = ZAD.ZAD_SEARCH				" + CRLF
	cQry += " 		AND NF.ZAD_ITTYPE = ZAD.ZAD_ITTYPE				" + CRLF
	cQry += " 		AND NF.ZAD_IDVEND = ZAD.ZAD_IDVEND				" + CRLF
	cQry += " 		AND NF.ZAD_TKTID  = ZAD.ZAD_TKTID				" + CRLF
	cQry += " 		AND NF.ZAD_TPITEM = ZAD.ZAD_TPITEM				" + CRLF
	cQry += " )														" + CRLF
	cQry += " 	AND ZAD.ZAD_TPTRAN = '2'							" + CRLF
	cQry += " 	AND ZAD.ZAD_STATUS <> '5'							" + CRLF

	cQry += " 	AND ZAD.D_E_L_E_T_ = ' '							" + CRLF

	nStatus := TcSqlExec(cQry)
	DBCommit()

	If (nStatus < 0)

		cErro :=  REPLICATE("*", 5)+ CRLF
		cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
		u_T4F01LOG(cErro)
	EndIf

Return lRet

/*/{Protheus.doc} CSrvTot

	Cancelamento Total das Taxas (NFS)

	@type function
	@author Felipe Sakaguti - CRM Services
	@since 04/07/2021
	@database Oracle

	@see 

/*/
Static Function CSrvParc(cDoc,cSerie,cItType,nDif,dDtBkp)
	Local lRet 			:= .F.
	Local cAlias    	:= 'SF2'
	Local cCodMun 		:= SM0->M0_CODMUN
	Local cNotasOk 		:= ''
	Local cDest			:= ''
	Local lAuto			:= .T.
	Local cGravaDest	:= ''
	Local lUsaColab		:= .F.
	Local lSF3Canc		:= .F.
	Local cRetMsg		:= ""

	Local aParam		:= {}
	Local aRetNotas		:= {}
	Local nX			:= 0

	Local lMostraCtb	:= .F.
	Local lAglCtb		:= .F.
	Local lContab 		:= .T.
	Local lCarteira		:= .F.
	Local aRegSD2	 	:= {}
	Local aRegSE1	 	:= {}
	Local aRegSE2	 	:= {}

	Begin Transaction

		dbSelectArea("SF2")
		dbSetOrder(1)
		If dbSeek( xFilial("SF2") + cDoc + cSerie ) .And. SF2->F2_EMISSAO >= CTOD('20211201')

			If Month(SF2->F2_EMISSAO) <> Month(dDtBkp)

				Return(lRet)
			EndIf

			aRegSD2 := {}
			aRegSE1 := {}
			aRegSE2 := {}

			If MaCanDelF2("SF2",SF2->(recno()),@aRegSD2,@aRegSE1,@aRegSE2) .AND. MA521VerSC6(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

				lContab	:=	.T.
				Pergunte("MTA521",.F.)
				MV_PAR03 := 1
				SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))

				cQrySF3:= " "
				cQrySF3+= " SELECT F3_NFISCAL, F3_SERIE, F3_NFELETR, F3_CODNFE,F3_CODRET FROM "+RetSqlName("SF3")
				cQrySF3+= " WHERE F3_NFISCAL = '"+SF2->F2_DOC +"'"
				cQrySF3+= " AND F3_SERIE = '"+ SF2->F2_SERIE +"'"
				cQrySF3+= " AND F3_DTCANC = ' '
				cQrySF3+= " AND F3_CODNFE <> ' '
				cQrySF3+= " AND F3_CODRET = '111'
				cQrySF3+= " AND D_E_L_E_T_ =' '

				cQrySF3 := ChangeQuery(cQrySF3)

				cAliasSF3  := MPSysOpenQuery(cQrySF3)

				(cAliasSF3)->(DbGotop())

				//aRetNotas	:=	MonitNFSe(aParam)
				//EndIf

				If !Empty((cAliasSF3)->F3_NFISCAL)

					If !Empty(aRetNotas)

						cCodMun 	:= SM0->M0_CODMUN
						cUsaColab	:= GetNewPar("MV_SPEDCOL","N")
						cURL       	:= Padr(GetNewPar("MV_SPEDURL",""),250)
						cInscMun   	:= Alltrim(SM0->M0_INSCM)
						cVerTSS    	:= ""
						cTypeaXML  	:= ""
						cEntSai		:= "1"
						cIdent		:= 	U_GetIdEnt()
						cNotasOk	:= ""
						cDest		:= ''
						lAuto		:= .T.
						cGravaDest	:= ''
						lUsaColab	:= .F.
						lSF3Canc	:= .F.

						FisaCanc(cCodMun,cAlias,@cNotasOk,cSerie,cDoc,cDoc,cDest,lAuto,cGravaDest,lUsaColab,lSF3Canc)
						lRet := EnvCanNFSe(.T., {cSerie,cDoc,cDoc})

						/*
						aParam 		:= {cSerie,cDoc,cDoc}
						aRetNotas	:=	MonitNFSe(aParam)

						cRetMsg		:=	""

						For nX := 1 To Len(aRetNotas)

							cRetMsg += dtoc(MsDate()) +"-"+ ALLTRIM(TIME()) + " - Nota fiscal - "	+	Alltrim(aRetNotas[nX ][2]) + "-" + Alltrim(aRetNotas[nX ][6]) + CRLF

						Next nX

						If !Empty(cRetMsg)
							lRet := .F.
						Else
							lRet := .T.
						EndIf
						*/

					Else
						lRet := .T.
					EndIf

				Else
					lRet := .F.
				EndIf
			EndIf

			If !lRet
				DisarmTransaction()
			EndIf
		EndIf

	End Transaction

	If lRet
		ZADUpd4CancelaServicoParcial(cDoc,cSerie,cItType)

		ExclSC6SC9(cDoc,cSerie)

		dbSelectArea("SF2")
		dbSetOrder(1)

		If !SF2->(DbSeek(xFilial("SF2")+cDoc+cSerie))

			ZADRep4GeraZADNovaNFS(cDoc,cSerie,cItType,nDif)

			//U_T4F01PED({DTOS(ddatabase),'',cEmpAnt,cFilAnt}) // FATURA DIFERENÇA

			StartJob( 'U_T4F01PED', GetEnvServer(), .F., {DTOS(ddatabase),'',cEmpAnt,cFilAnt} )
		EndIf

	Else
		ZADUpd4ErroCancTot(cDoc,cSerie,cItType)
	EndIf

Return lRet

Static Function ZADUpd4CancelaServicoParcial(cDoc,cSerie,cItType)
	Local lRet		:= .T.
	Local cQry		:= ""

	cQry += " UPDATE "+RetSqlName("ZAD") + " SET  				" + CRLF
	cQry += " 			ZAD_STATUS 	= '5'						" + CRLF
	cQry += " WHERE 											" + CRLF
	cQry += " 			ZAD_NFTOTV 	= '" + cDoc + "'			" + CRLF
	cQry += "		AND ZAD_SETOTV	= '" + cSerie +"'			" + CRLF
	cQry += "		AND ZAD_ITTYPE	= '" + cItType +"'			" + CRLF
//	cQry += "		AND ZAD_FILIAL	= '" + xFilial("ZAD") +"'	" + CRLF
	cQry += "		AND ZAD_TPTRAN 	= '1'						" + CRLF
	cQry += "		AND ZAD_STATUS	= '3'						" + CRLF
	cQry += "		AND D_E_L_E_T_ 	= ' '						" + CRLF

	If TCSQLExec(cQry) < 0
		cErro := TCSQLError()
		u_T4F01LOG(cErro)
	EndIf

	cQry := ""

	cQry += " UPDATE " + RetSqlName("ZAD") + " ZAD					" + CRLF
	cQry += " SET 													" + CRLF
	cQry += " 	ZAD.ZAD_STATUS = '5'								" + CRLF
	cQry += " WHERE EXISTS  (										" + CRLF
	cQry += "     SELECT NULL										" + CRLF
	cQry += "     FROM " + RetSqlName("ZAD") + " NF					" + CRLF
	cQry += "     WHERE 1 = 1										" + CRLF
	cQry += " 		AND NF.ZAD_TPTRAN = '1'							" + CRLF
	cQry += " 		AND NF.ZAD_STATUS = '5'							" + CRLF
	cQry += " 		AND NF.ZAD_NFTOTV = '"+cDoc+"'					" + CRLF
	cQry += " 		AND NF.ZAD_SETOTV = '"+cSerie+"'				" + CRLF
	cQry += " 		AND NF.ZAD_ITTYPE = '"+cItType+"'				" + CRLF
	cQry += " 		AND NF.D_E_L_E_T_ = ' '							" + CRLF
	cQry += "		AND NF.ZAD_FILIAL = ZAD.ZAD_FILIAL				" + CRLF
	cQry += " 		AND NF.ZAD_SEARCH = ZAD.ZAD_SEARCH				" + CRLF
	cQry += " 		AND NF.ZAD_ITTYPE = ZAD.ZAD_ITTYPE				" + CRLF
	cQry += " 		AND NF.ZAD_IDVEND = ZAD.ZAD_IDVEND				" + CRLF
	cQry += " 		AND NF.ZAD_TKTID  = ZAD.ZAD_TKTID				" + CRLF
	cQry += " 		AND NF.ZAD_TPITEM = ZAD.ZAD_TPITEM				" + CRLF
	cQry += " )														" + CRLF
	cQry += " 	AND ZAD.ZAD_TPTRAN = '2'							" + CRLF
	cQry += " 	AND ZAD.ZAD_STATUS IN ('1','E')							" + CRLF
	cQry += " 	AND ZAD.D_E_L_E_T_ = ' '							" + CRLF
//	cQry += "	AND ZAD.ZAD_FILIAL = '" + xFilial("ZAD") +"'		" + CRLF

	If TCSQLExec(cQry) < 0
		cErro := TCSQLError()
		u_T4F01LOG(cErro)
		lRet  := .F.
		//Erro na execução SQL
	EndIf

Return lRet


Static Function ZADRep4GeraZADNovaNFS(cDoc,cSerie,cItType,nDif)
	Local lRet		:= 	.T.
	Local cQuery	:= 	""
	Local cAliasZAD	:= 	""
	Local n 		:=	0

	cQuery += "     SELECT                                              " + CRLF
	cQuery += "         *												" + CRLF
	cQuery += "     FROM "+RetSqlName("ZAD")+" ZAD                    	" + CRLF
	cQuery += "     WHERE 1 = 1                                         " + CRLF
	cQuery += "         AND ZAD.D_E_L_E_T_ = ' '                        " + CRLF
	cQuery += "         AND ZAD.ZAD_TPTRAN = '1'                        " + CRLF
	cQuery += "         AND ZAD.ZAD_STATUS = '5'                        " + CRLF
	cQuery += "         AND ZAD.ZAD_NFTOTV = '" + cDoc +"'     			" + CRLF
	cQuery += "         AND ZAD.ZAD_SETOTV = '" + cSerie +"'     		" + CRLF
	cQuery += "         AND ZAD.ZAD_ITTYPE = '" + cItType +"'     		" + CRLF
	cQuery += "         AND NOT EXISTS (	     						" + CRLF
	cQuery += "     SELECT                                              " + CRLF
	cQuery += "         NULL											" + CRLF
	cQuery += "     FROM "+RetSqlName("ZAD")+" CANC                 	" + CRLF
	cQuery += "     WHERE 1 = 1                                         " + CRLF
	cQuery += "         AND CANC.D_E_L_E_T_ = ' '                       " + CRLF
	cQuery += "         AND CANC.ZAD_TPTRAN = '2'                       " + CRLF
	cQuery += "         AND CANC.ZAD_STATUS = '5'                       " + CRLF
	cQuery += "         AND CANC.ZAD_FILIAL = ZAD.ZAD_FILIAL  			" + CRLF
	cQuery += "         AND CANC.ZAD_ITTYPE = ZAD.ZAD_ITTYPE     		" + CRLF
	cQuery += "         AND CANC.ZAD_SEARCH = ZAD.ZAD_SEARCH            " + CRLF
	cQuery += "         AND CANC.ZAD_IDVEND = ZAD.ZAD_IDVEND            " + CRLF
	cQuery += "         AND CANC.ZAD_TKTID  = ZAD.ZAD_TKTID             " + CRLF
	cQuery += " 		AND CANC.ZAD_TPITEM = ZAD.ZAD_TPITEM			" + CRLF
	cQuery += "     	)              									" + CRLF


	TcQuery cQuery New Alias (cAliasZAD:=GetNextAlias())
	dbSelectArea(cAliasZAD)

	(cAliasZAD)->(dbGoTop())

	n:=1

	If (cAliasZAD)->(!EOF())

		While (cAliasZAD)->(!EOF()) .And. n <= nDif

			RecLock("ZAD",.T.)
			ZAD->ZAD_STATUS		:= "1"
			ZAD->ZAD_TPTRAN		:= "1"
			ZAD->ZAD_PEDIDO		:= ''
			ZAD->ZAD_HREMIS		:= ''
			ZAD->ZAD_FILIAL		:= (cAliasZAD)->ZAD_FILIAL
			ZAD->ZAD_NUMERO		:= GetSXENum("ZAD","ZAD_NUMERO")
			ZAD->ZAD_DTIMP		:= STOD((cAliasZAD)->ZAD_DTIMP)
			ZAD->ZAD_DTVEND		:= STOD((cAliasZAD)->ZAD_DTVEND)
			ZAD->ZAD_ITEMID		:= (cAliasZAD)->ZAD_ITEMID
			ZAD->ZAD_ITNAME		:= (cAliasZAD)->ZAD_ITNAME
			ZAD->ZAD_CPF		:= (cAliasZAD)->ZAD_CPF
			ZAD->ZAD_NOME		:= (cAliasZAD)->ZAD_NOME
			ZAD->ZAD_END		:= (cAliasZAD)->ZAD_END
			ZAD->ZAD_BAIRRO		:= (cAliasZAD)->ZAD_BAIRRO
			ZAD->ZAD_CIDADE		:= (cAliasZAD)->ZAD_CIDADE
			ZAD->ZAD_EST		:= (cAliasZAD)->ZAD_EST
			ZAD->ZAD_CEP		:= (cAliasZAD)->ZAD_CEP
			ZAD->ZAD_EPEP		:= (cAliasZAD)->ZAD_EPEP
			ZAD->ZAD_VLRTKT		:= (cAliasZAD)->ZAD_VLRTKT
			ZAD->ZAD_VLRTXO		:= (cAliasZAD)->ZAD_VLRTXO
			ZAD->ZAD_VLRTXS		:= (cAliasZAD)->ZAD_VLRTXS
			ZAD->ZAD_VLRTXC		:= (cAliasZAD)->ZAD_VLRTXC
			ZAD->ZAD_VLRTXI		:= (cAliasZAD)->ZAD_VLRTXI
			ZAD->ZAD_VLRXCA		:= (cAliasZAD)->ZAD_VLRXCA
			ZAD->ZAD_EVENTO		:= (cAliasZAD)->ZAD_EVENTO
			ZAD->ZAD_TPITEM		:= (cAliasZAD)->ZAD_TPITEM
			ZAD->ZAD_IDVEND		:= (cAliasZAD)->ZAD_IDVEND
			ZAD->ZAD_OBS		:= 'DIFERENÇA DE CANCELAMENTO'
			ZAD->ZAD_TKTID		:= (cAliasZAD)->ZAD_TKTID
			ZAD->ZAD_TPAGTO		:= (cAliasZAD)->ZAD_TPAGTO
			ZAD->ZAD_PRODUT		:= (cAliasZAD)->ZAD_PRODUT
			ZAD->ZAD_CNPJCL		:= (cAliasZAD)->ZAD_CNPJCL
			ZAD->ZAD_EMP		:= (cAliasZAD)->ZAD_EMP
			ZAD->ZAD_NOMECL		:= (cAliasZAD)->ZAD_NOMECL
			ZAD->ZAD_PROMOT		:= (cAliasZAD)->ZAD_PROMOT
			ZAD->ZAD_VLENTR		:= (cAliasZAD)->ZAD_VLENTR
			ZAD->ZAD_SEARCH		:= (cAliasZAD)->ZAD_SEARCH
			ZAD->ZAD_CODNFS		:= (cAliasZAD)->ZAD_CODNFS
			ZAD->ZAD_VLRSOC		:= (cAliasZAD)->ZAD_VLRSOC
			ZAD->ZAD_ITTYPE		:= (cAliasZAD)->ZAD_ITTYPE
			ZAD->ZAD_SLUID		:= (cAliasZAD)->ZAD_SLUID
			ZAD->ZAD_TPINTE		:= (cAliasZAD)->ZAD_TPINTE
			ZAD->ZAD_TPRECB		:= (cAliasZAD)->ZAD_TPRECB
			ZAD->ZAD_DTEVEN		:= (cAliasZAD)->ZAD_DTEVEN

			ZAD->(MsUnlock())

			(cAliasZAD)->(dbSkip())

			n += n
		EndDo
	Endif

	(cAliasZAD)->(dbCloseArea())

Return lRet

Static Function ZADUpd4ErroCancTot(cDoc,cSerie,cItType)
	Local lRet		:= .T.
	Local cQry		:= ""

	cQry += " UPDATE " + RetSqlName("ZAD") + " ZAD					" + CRLF
	cQry += " SET 													" + CRLF
	cQry += " 	ZAD.ZAD_STATUS = 'E'								" + CRLF
	cQry += " 	,ZAD_OBS = 'Erro Canc. NFE Dt: '" +	DTOC(dDataBase) +	"'" + CRLF
	//cQry += " 	,ZAD_NFTOTV = '"+cDoc+"'							" + CRLF
	//cQry += " 	,ZAD_SETOTV = '"+cSerie+"'							" + CRLF
	cQry += " WHERE EXISTS  (										" + CRLF
	cQry += "     SELECT NULL										" + CRLF
	cQry += "     FROM " + RetSqlName("ZAD") + " NF					" + CRLF
	cQry += "     WHERE 1 = 1										" + CRLF
	cQry += " 		AND NF.ZAD_TPTRAN = '1'							" + CRLF
	cQry += " 		AND NF.ZAD_STATUS = '3'							" + CRLF
	cQry += " 		AND NF.ZAD_NFTOTV = '"+cDoc+"'					" + CRLF
	cQry += " 		AND NF.ZAD_SETOTV = '"+cSerie+"'				" + CRLF
	cQry += " 		AND NF.D_E_L_E_T_ = ' '							" + CRLF
	cQry += "		AND NF.ZAD_FILIAL = ZAD.ZAD_FILIAL				" + CRLF
	cQry += " 		AND NF.ZAD_SEARCH = ZAD.ZAD_SEARCH				" + CRLF
	cQry += " 		AND NF.ZAD_ITTYPE = ZAD.ZAD_ITTYPE				" + CRLF
	cQry += " 		AND NF.ZAD_IDVEND = ZAD.ZAD_IDVEND				" + CRLF
	cQry += " 		AND NF.ZAD_TKTID  = ZAD.ZAD_TKTID				" + CRLF
	cQry += " 		AND NF.ZAD_TPITEM = ZAD.ZAD_TPITEM				" + CRLF
	cQry += " )														" + CRLF
	cQry += " 	AND ZAD.ZAD_TPTRAN = '2'							" + CRLF
	cQry += " 	AND ZAD.ZAD_STATUS IN ('1','E')							" + CRLF
	cQry += " 	AND ZAD.D_E_L_E_T_ = ' '							" + CRLF
//	cQry += "	AND ZAD.ZAD_FILIAL = '" + xFilial("ZAD") +"'		" + CRLF


	If TCSQLExec(cQry) < 0
		cErro := TCSQLError()
		u_T4F01LOG(cErro)
	EndIf

Return lRet

/*/{Protheus.doc} CSrvTot

	Cancelamento Total das NFSs (Taxas)

	@type function
	@author Felipe Sakaguti - CRM Services
	@since 04/07/2021
	@database Oracle

	@see 

/*/

Static Function FisaCanc(cCodMun,cAlias,cNotasOk,cSerie,cNotaIni,cNotaFim,cDest,lAuto,cGravaDest,lUsaColab,lSF3Canc)

	local aArea     	:= GetArea()
	local aRemessa 		:= {}
	local cAliasSF3 	:= "SF3"
	// local cRetorno   	:= ""
	local cMotCancela	:= ""
	// local cXjust		:= ""
	local cCodCanc		:= ""
	local cRdMakeNFSe	:= ""
	local cSerieIni		:= cSerie
	local cSerieFim		:= cSerie

	// local lXjust    	:= GetNewPar("MV_INFXJUS","") == "S"
	local lHabCanc		:= GetNewPar("MV_CODCANC",.F.) //Habilita a tela de seleção dos códigos de cancelamento (#Piloto Itajaí - SC)
	local lOk			:= .T.
	local lReproc		:= .F.
	local lCanc			:= .T.
	local lMontaXML		:= .F.

	local nCount		:= 0
	local cCondQry		:= ""
	Local cEntSai 		:= "1"

	default cSerie		:= ""
	default cNotaIni	:= ""
	default cNotaFim	:= ""
	default cDest		:= ""
	default lUsaColab	:= UsaColaboracao("3")
	default lSF3Canc	:= .T. // Verdadeiro se a NFS ja foi cancelada
	default cGravaDest	:= ""

	cGravaDest	:= alltrim (cGravaDest)
	Procregua((cAliasSF3)->(reccount()))

	cCondQry:="%"

	If cEntSai == "1"

		cCondQry +="F3_CFO >= '5' "
		cCondQry += " AND SF3.F3_DTCANC <> '"+Space(8)+"' "

	ElseIF cEntSai == "0"

		cCondQry +="F3_CFO < '5' "

	EndiF

	If ( ( !Empty(cSerie) .And. !Empty(cNotaIni) .And. !Empty(cNotaFim) .And. ( cCodMun $ Fisa022Cod("101") .or. cCodMun $ Fisa022Cod("102") ) .Or. ( !cCodMun $ Fisa022Cod("201") .And. cCodMun $ GetMunNFT() .And. cEntSai == "0" )  .or. lAuto ) )

		cCondQry += " AND SF3.F3_SERIE		=  '" + cSerie		+ "'"
		cCondQry += " AND SF3.F3_NFISCAL	>= '" + cNotaIni	+ "'"
		cCondQry += " AND SF3.F3_NFISCAL	<= '" + cNotaFim	+ "'"

	else

		If lHabCanc //Codigo de Cancelamento apenas para Itajaí e Caxias do Sul

			cCodCanc:= GetCodCanc(@lOk,cCodMun)

		EndIf

		if lOk

			If (cAliasSF3)->(FieldPos("F3_OK")) > 0

				cCondQry += " AND SF3.F3_OK = '" + cMarca + "'"

			else

				lOk := .F.

			endif

		endif

	endif

	cRdMakeNFSe		:= getRDMakeNFSe(cCodMun,cEntSai)
	lMontaXML		:= lMontaXML(cCodMun,cEntSai)

	If lOk

		cAliasSF3 := GetNextAlias()

		If cCodMun $ Fisa022Cod("201") .And. (cCodMun $ GetMunNFT() .And. cEntSai == "0")
			cCondQry +="%"
			BeginSql Alias cAliasSF3
				
			COLUMN F3_ENTRADA AS DATE
			COLUMN F3_DTCANC AS DATE
									
			SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC
					FROM %Table:SF3% SF3
					WHERE
					SF3.F3_FILIAL = %xFilial:SF3% AND
					%Exp:cCondQry%
			EndSql
		Else
			If lSF3Canc
				cCondQry += " AND SF3.F3_DTCANC <> '"+Space(8)+"' "
				cCondQry += " AND SF3.F3_CODRET <> '333' "
				cCondQry += " AND SF3.F3_CODRET <> '222' "
				If !cCodMun $ "3552403-3170701" //Fisa022Cod("101")
					cCondQry += " AND SF3.F3_CODRET <> 'T' "
				EndIf
			EndIf
			cCondQry +="%"
			BeginSql Alias cAliasSF3
					
			COLUMN F3_ENTRADA AS DATE
			COLUMN F3_DTCANC AS DATE
			// #------ Query para cancelamento
			SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC
					FROM %Table:SF3% SF3
					WHERE
					SF3.F3_FILIAL = %xFilial:SF3% 
					AND %Exp:cCondQry%  				
					AND SF3.%notdel% 
			EndSql
			if lAuto
				autoNfseMsg("[Query Cancelamento  ] "+ getlastquery()[2],.F.)
			Endif
		EndIf

		cTotal := cValToChar((cAliasSF3)->(reccount()))

		While !(cAliasSF3)->(EOF()) .and. lOk

			nCount++

			IncProc("("+cValToChar(nCount)+"/"+cTotal+") "+STR0022+(cAliasSF3)->F3_NFISCAL) //"Preparando nota: "

			cMotCancela := "Cancelamento automatico de venda de ingressos."

			//-- Gerar XML atraves do RDMAKE
			aadd(aRemessa, montaRemessaNFSE(cAliasSF3,cRdMakeNFSe,lCanc,cMotCancela,cIdent,lMontaXML,/*cCodTit*/,/*cAviso*/,/*aTitIssRet*/,lUsaColab))

			(cAliasSF3)->(DbSkip())

		EndDo
		ccodcanc	:= " "

		lOk := envRemessaNFSe(cIdEnt,cUrl,aRemessa,lReproc,cEntSai,@cNotasOk,lcanc,cCodCanc,cCodMun,,,cMotCancela)
		If !lUsaColab
			If lOk
				If ( (cCodMun $ Fisa022Cod("101") .And. !cCodMun $ "3201308") .Or. (cCodMun $ Fisa022Cod("102")) .Or. (!cCodMun $ Fisa022Cod("201") .And. cCodMun $ GetMunNFT() .And. cEntSai == "0") )
					cNotasOk := ""
					//-- gera arquivo txt para os modelos 101,102 ou NFTS(São Paulo)
					geraArqNFSe(cIdEnt,cCodMun,cSerie,cNotaini,cNotaFim,cDEST,,cSerieIni,cSerieFim,,,aRemessa,@cNotasOk,,cGravaDest)
				EndIf
			Else
				cMsg :=(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
			EndIf
		EndIf
		(cAliasSF3)->(dbCloseArea())

		SF3->(DbCloseArea())

		RestArea(aArea)

	EndIf

Return lOk

Static Function NFEXCLUIDA(cDoc,cSerie)
	Local lRet		:= .F.
	Local cQry		:= ""
	Local cAlias	:= ""

	cQry := ""

	cQry += " SELECT F2_SERIE, F2_DOC FROM " + RetSqlName("SF2") + " SF2 " + CRLF
	cQry += "     WHERE  F2_DOC 	= '"+cDoc+"'						 " + CRLF
	cQry += " 		AND  F2_SERIE 	= '"+cSerie+"'						 " + CRLF
	cQry += " 		AND  SF2.D_E_L_E_T_ = '*'							 " + CRLF
	cQry += " GROUP BY  F2_SERIE, F2_DOC								 " + CRLF

	TcQuery cQry New Alias (cAlias:=GetNextAlias())
	dbSelectArea(cAlias)

	(cAlias)->(dbGoTop())

	If !Empty((cAlias)->F2_DOC)
		lRet	:=	.T.

		If Select(cAlias) > 0
			(cAlias)->( DbCloseArea() )
		EndIf

	Else
		lRet	:=	.F.
	EndIf

Return lRet

Static Function ExclSC6SC9(cDoc,cSerie)

	Local cQry		:= ""
	Local cQry2		:= ""
	Local cQry3		:= ""
	Local cQry4		:= ""
	Local cErro		:= ""
	Local nRet		:= .T.

	cQry += " SELECT D2_PEDIDO, D2_ITEMPV FROM " + RetSqlName("SD2") + " SD2	" + CRLF
	cQry += "     WHERE D2_FILIAL	= '" + xFilial("SD2") +"'		" + CRLF
	cQry += "		AND D2_DOC 	 = '"+cDoc+"'						" + CRLF
	cQry += " 		AND D2_SERIE = '"+cSerie+"'						" + CRLF
	cQry += " 		AND SD2.D_E_L_E_T_ = '*'							" + CRLF
	cQry += " 		GROUP BY D2_PEDIDO, D2_ITEMPV							" + CRLF

	TcQuery cQry New Alias (cAliasSd2:=GetNextAlias())
	dbSelectArea(cAliasSd2)

	(cAliasSd2)->(dbGoTop())

	DbSelectArea("SC5")
	DbSetOrder(1)

	While !(cAliasSd2)->(Eof())

		If SC5->(MsSeek(xFilial("SC5")+(cAliasSd2)->D2_PEDIDO))
			cQry3 :=""
			cQry3 += " UPDATE " + RetSqlName("SC6") + " SET  			" + CRLF
			cQry3 += " 			C6_NOTA 	= 'XXXXXXXXX'  		    	" + CRLF
			cQry3 += " WHERE 											" + CRLF
			cQry3 += " 		C6_NUM 	= '" + (cAliasSd2)->D2_PEDIDO + "'	" + CRLF
			cQry3 += "		AND C6_ITEM 	= '"+(cAliasSd2)->D2_ITEMPV+"'" + CRLF

			nRet := TCSQLExec(cQry3)
			If nRet < 0
				cErro := TCSQLError()
				lRet := .F.
				//Erro na execução SQL
			EndIf
			cQry4 :=" "
			cQry4 += " UPDATE " + RetSqlName("SC9") + " SET  			" + CRLF
			cQry4 += " 			D_E_L_E_T_ 	= '*' 	       		    	" + CRLF
			cQry4 += " WHERE 											" + CRLF
			cQry4 += " 		C9_PEDIDO 	= '" + (cAliasSd2)->D2_PEDIDO + "'			" + CRLF
			cQry4 += " 		AND C9_ITEM 	= '" + (cAliasSd2)->D2_ITEMPV + "'			" + CRLF
			cQry4 += "		AND C9_NFISCAL 	= ' '						" + CRLF
			cQry4 += "		AND C9_SERIENF 	= ' '						" + CRLF
			cQry4 += "		AND C9_BLEST 	= ' '						" + CRLF

			nRet := TCSQLExec(cQry4)
			If nRet < 0
				cErro := TCSQLError()
				lRet := .F.
				//Erro na execução SQL
			EndIf
		EndIf

		(cAliasSd2)->(dbSkip())

	EndDo

	(cAliasSd2)->(dbCloseArea())

Return

/* Cancelamento das notas e atualização da ZAD */
User Function T4FCANC()

	Local   nAtual		:=	0
	Local 	aLines		:= {}
	Local 	cNotas		:= ""
	Local	nValTot		:= 0
	Local 	msg			:= ""
	Local 	n			:= 0
	Local 	aNumdoc		:= {}

	Private aParamBox	:= {}
	Private aRet		:= {}
	Private cDataIni	:= ''
	Private cDataFim	:= ''
	Private cDocIni		:= ''
	Private cDocFim		:= ''
	Private cSerie		:= ''

	If !(FWIsInCallStack('U_T4F01ZAD'))

		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA '08' FILIAL '01' MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4","ZAD","SF2"

	Else

		aAdd(aParamBox,{1,"Data Inicial 	"	,CTOD('')					,"","","   ","",80,.F.})  //01
		aAdd(aParamBox,{1,"Data Final   	"	,CTOD('')					,"","","   ","",80,.F.})  //01
		aAdd(aParamBox,{6,"Selecione o Arquivo",Space(80),"","","",80,.T.,"Arquivos CSV) |*.CSV"})
		aAdd(aParamBox,{1,"Serie"		 	,SPAC(TamSX3("F2_SERIE")[1]) ,"","","   ","",25,.F.})  //01

		If !ParamBox(aParamBox, "Cancelamento de Notas", aRet)
			Return Nil
		Else
			cDataIni	:= Alltrim(DTOS(aRet[1]))
			cDataFim	:= Alltrim(DTOS(aRet[2]))
			cFileOpen	:= aRet[3]
			cSerie		:= aRet[4]

		End If

	EndIf

	oFile := FWFileReader():New(cFileOpen)

	IF (oFile:Open())
		aLines:=oFile:getAllLines()
		oFile:Close()
	ENDIF

	dbSelectArea("SF2")
	dbSetOrder(1)

	For nAtual := 1 To Len(aLines)

		cNotas	:= Alltrim(aLines[nAtual] )	//"'" + Alltrim(aLines[nAtual] ) + "',"

		If SF2->(MsSeek(xFilial("SF2")+cNotas+cSerie))
			nValTot	+=	SF2->F2_VALBRUT
		EndIf

	Next nAtual

	dDtBkp	:=	dDataBase

	msg := "ATENCAO!"+CHR(13)+CHR(10)
	msg +=  CHR(13)+CHR(10)
	msg := "Valor Total das Notas Fiscais : " + Transform(nValTot, "@E 999,999.99") +CHR(13)+CHR(10)
	msg +=  CHR(13)+CHR(10)
	msg += "Deseja continuar? "

	If nValTot > 0

		If MsgYesNo(msg, "Total das Notas Fiscais")

			For nAtual := 1 To Len(aLines)

				cNotas	:= Alltrim(aLines[nAtual] )	//"'" + Alltrim(aLines[nAtual] ) + "',"

				dbSelectArea("SF2")
				dbSetOrder(1)

				If SF2->(MsSeek(xFilial("SF2")+cNotas+cSerie))

					dDataBase	:= SF2->F2_EMISSAO
					cDoc 		:=  SF2->F2_DOC
					cSerie		:= SF2->F2_SERIE

					FwMsgRun(NIL,{ || CSrvTot(SF2->F2_DOC,SF2->F2_SERIE,' ', dDtBkp) }, "CANCELAMENTO DE NOTAS FISCAIS", "CANCELANDO NOTA FISCAL NUMERO :" + Alltrim(SF2->F2_SERIE) +"/"+ Alltrim(SF2->F2_DOC))

					lRet	:= 	NFEXCLUIDA(SF2->F2_DOC,SF2->F2_SERIE)

					If lRet .And. SF2->F2_SERIE =='S  '
						aAdd(aNumDoc,SF2->F2_DOC)
					EndIf

				Else
					lRet	:= .F.
				EndIf

				lRetMsg := .F.

				msg := "Deseja liberar todos os localizadores para reprocessamento?"
				msg +=  CHR(13)+CHR(10)

				lRetMsg := MsgYesNo(msg, "Cancelamento de Notas")


				If lRet

					If lRetMsg
						cQry := ""

						cQry += " UPDATE " + RetSqlName("ZAD") + " SET  			" + CRLF

						If lRetMsg
							cQry += " ZAD_STATUS = '1', ZAD_PEDIDO 	= ' ', ZAD_NFTOTV 	= ' ', ZAD_SETOTV 	= ' '	" + CRLF
						Else
							cQry += " ZAD_STATUS = '5'						" + CRLF
						EndIf

						cQry += " WHERE 											" + CRLF
						cQry += " 			ZAD_NFTOTV 	= '" + cDoc + "'			" + CRLF
						cQry += "		AND ZAD_SETOTV	= '" + cSerie +"'			" + CRLF
						cQry += "		AND ZAD_TPTRAN 	= '1'						" + CRLF
						cQry += "		AND ZAD_STATUS	= '3'						" + CRLF
						cQry += "		AND D_E_L_E_T_ 	= ' '						" + CRLF

						If TCSQLExec(cQry) < 0
							cErro := TCSQLError()
							u_T4F01LOG(cErro)
						EndIf

					EndIf
				EndIf

				SF2->(dbCloseArea())

			Next nAtual

		End If
	Else

		msg := "ATENCAO!"+CHR(13)+CHR(10)
		msg +=  CHR(13)+CHR(10)
		msg += "Não foram encontradas notas fiscais para cancelar" +CHR(13)+CHR(10)
		msg +=  CHR(13)+CHR(10)

		Alert(msg)

	End If

	dDataBase := dDtBkp

Return()

Static Function QryWallet(cSluId,cLocalizador)

	Local cQryWallet 	:= ""

	cQryWallet += " SELECT ZAF_TIPO" + CRLF
	cQryWallet += " FROM " +RetSqlName("ZAF") + CRLF
	cQryWallet += " WHERE ZAF_TPRECB ='Indireto' " + CRLF
	cQryWallet +=  " AND ZAF_TPPGTO <> 'Bonificado          '		" + CRLF
	cQryWallet +=  " AND  ZAF_TPRECB = 'Indireto' " + CRLF
	cQryWallet += "  AND ZAF_SLUID = '" + cSluId + "'"+ CRLF
	cQryWallet += "  AND ZAF_DTCANC <> ' '"+ CRLF
	cQryWallet += "  AND ZAF_TIPO LIKE '%Cancelamento por Est%' "+ CRLF
	cQryWallet += "  AND D_E_L_E_T_ =' ' " + CRLF

Return(cQryWallet)
