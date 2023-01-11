#include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'


/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4FSTATINT                            Modulo : SIGAFAT    //
//                                                                          //
// Apresenta grafico com os dados de vendas integrados                      //
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa											//
//                                                                          //
//	@since......: 	01/03/2022												//	
//                                                                          //
//	@param......:	aParamEmp, array, dados da empresa e filial para 		//
//					processamento											//
/*///////////////////////////////////////////////////////////////////////////

/*/{Protheus.doc} T4FSTATINT
Apresenta grafico com os dados de vendas integrados                      // **
	@type.......:	function												
	@version....:	1.00													
	@author.....:	Rogério Costa											
	@since......: 	01/03/2022												
	@param......:	aParamEmp, array, dados da empresa e filial para 		
					processamento											
/*/


User Function T4FSTATINT()

	Local oChart
	Local oDlg
	Local aRand := {}

	Private aParamBox	:= {}
	Private aRet		:= {}

	cEmp	:= cEmpant
	cFil	:= cFilant

	aAdd(aParamBox,{1,"Data Inicial Venda"	, DDATABASE          ,"","","   ","",80,.F.})  //01
	aAdd(aParamBox,{1,"Data Final Venda"	, DDATABASE          ,"","","   ","",80,.F.})  //01

	If !ParamBox(aParamBox, "Status Geral das Integrações Ticketeira", aRet)
		Return Nil
	Else
		cDataIni:= DTOS(aRet[1])
		cDataFim:= DTOS(aRet[2])
	End If


	//Cria a Janela
	DEFINE MSDIALOG oDlg PIXEL FROM 0,0 TO 400,600
	//Instância a classe
	oChart := FWChartBar():New()

	//Inicializa pertencendo a janela
	oChart:Init(oDlg, .T., .T. )

	//Seta o título do gráfico
	oChart:SetTitle("STATUS INTEGRAÇÃO INTI PERIODO "+DTOC(STOD(cDataIni)) +"-"+DTOC(STOD(cDataFim)), CONTROL_ALIGN_CENTER)

	FwMsgRun(,{ || RetDados(cDataIni,cDataFim,oChart) }, "Consulta de Dados", 'Selecionando registros......')

	//Define que a legenda será mostrada na esquerda
	oChart:setLegend( CONTROL_ALIGN_LEFT )

	//Seta a máscara mostrada na régua
	oChart:cPicture := "@E 999,999,999"

	//Define as cores que serão utilizadas no gráfico
	aAdd(aRand, {"084,120,164", "007,013,017"})
	aAdd(aRand, {"207,136,077", "020,020,006"})
	aAdd(aRand, {"166,085,082", "017,007,007"})
	aAdd(aRand, {"130,130,130", "008,008,008"})
	aAdd(aRand, {"171,225,108", "017,019,010"})

	//Seta as cores utilizadas
	oChart:oFWChartColor:aRandom := aRand
	oChart:oFWChartColor:SetColor("Random")

	//Constrói o gráfico
	oChart:Build()
	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function RetDados(cDataIni,cDataFim,oChart)

	Local cQryZAD
	Local cQryFat
	Local cQryDev
	Local cQryFin
	Local cQryCTB
	Local cAliasFat := GetNextAlias()
	Local cAliasZAD := GetNextAlias()
	Local cAliasDEV := GetNextAlias()
	Local cAliasFin := GetNextAlias()
	Local cAliasCTB := GetNextAlias()

	//Query com os dados do gráfico

	//--------------------------------------------------------------------------------------------------
	//Registros Integrados
	//--------------------------------------------------------------------------------------------------
	cQryZAD := "SELECT COUNT(*) TOT_ZAD FROM (SELECT ZAD_SEARCH "+ CRLF
	cQryZAD += " FROM " + RetSqlName("ZAD") + CRLF
	cQryZAD += " 	WHERE ZAD_FILIAL <> ' '"+ CRLF
	cQryZAD += " 	AND ZAD_DTVEND BETWEEN '"+ cDataIni +"' AND '"+cDataFim+"'  "+ CRLF
	cQryZAD += " 	AND	ZAD_ITEMID <> ' ' "+ CRLF
	cQryZAD += " 	AND ZAD_EPEP <> ' ' "+ CRLF
	cQryZAD += " 	AND ZAD_TPTRAN = '1'                                "+ CRLF
	cQryZAD += "  	AND ZAD_TPITEM IN (	'1'	,'2','3','4','6','7','8')   "+ CRLF
	cQryZAD += "   	AND D_E_L_E_T_ =' '                                 "+ CRLF
	cQryZAD += "  	HAVING SUM(ZAD_VLRTKT + ZAD_VLRSOC + ZAD_VLRTXC + ZAD_VLRTXI + ZAD_VLRTXO + ZAD_VLENTR + ZAD_VLRTXS + ZAD_VLRXCA)>0 "+ CRLF
	cQryZAD += "  	GROUP BY ZAD_SEARCH) "+ CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQryZAD) , cAliasZAD,.T.,.T.)

	dbSelectArea(cAliasZAD)
	(cAliasZAD)->(dbGoTop())

	//--------------------------------------------------------------------------------------------------
	//Cancelamentos/Devoluções Integradas
	//--------------------------------------------------------------------------------------------------
	cQryDev := " SELECT COUNT(*) TOT_DEV FROM (SELECT COUNT(*)  " + CRLF
	cQryDev += " FROM " + RetSqlName("ZAD")                              + CRLF
	cQryDev += " WHERE ZAD_FILIAL <> ' '"+ CRLF
	cQryDev += " AND ZAD_DTVEND <> ' ' "+ CRLF
	cQryDev += " AND ZAD_ITEMID <> ' ' "+ CRLF
	cQryDev += " AND ZAD_EPEP <> ' ' "+ CRLF
	cQryDev += " AND ZAD_DTCANC BETWEEN '"+ cDataIni +"' AND '"+cDataFim+"'  "+ CRLF
	cQryDev += " AND ZAD_TPTRAN = '2'                                   "+ CRLF
	cQryDev += " AND ZAD_TPITEM IN ('1'	,'2','3','4','6','7','8')       "+ CRLF
	cQryDev += " AND D_E_L_E_T_ =' '                                    "+ CRLF
	cQryDev += " GROUP BY ZAD_SEARCH) "+ CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQryDev) , cAliasDEV,.T.,.T.)

	dbSelectArea(cAliasDEV)
	(cAliasDEV)->(dbGoTop())

	//--------------------------------------------------------------------------------------------------
	//Movimentações Financeiras
	//--------------------------------------------------------------------------------------------------
	cQryFin := " SELECT COUNT(*) ZAF_FIN          "+ CRLF
	cQryFin += " FROM (SELECT ZAF_SEARCH          "+ CRLF
	cQryFin += "         FROM "+ RetSqlName('ZAF') + CRLF
	cQryFin += "         WHERE ZAF_FILIAL <> ' '  "+ CRLF
	cQryFin += "         AND ZAF_NUMERO <> ' '    "+ CRLF
	cQryFin += "         AND ZAF_TIPO ='Venda'    "+ CRLF

	If cEmpAnt == '33'
		cQryFin += "            AND ZAF_TPPGTO <> 'Bonificado'                  "+ CRLF
		cQryFin += "            AND ZAF_TPPGTO <> 'INTI Wallet'                 "+ CRLF
	EndIf

	cQryFin += "            AND ZAF_DTVEND BETWEEN '"+ cDataIni +"' AND '"+cDataFim+"'  "+ CRLF
	cQryFin += "            AND D_E_L_E_T_ =' '                             "+ CRLF
	cQryFin += " GROUP BY ZAF_SEARCH)                            "+ CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQryFin) , cAliasFin,.T.,.T.)

	dbSelectArea(cAliasFin)
	(cAliasFin)->(dbGoTop())

	//--------------------------------------------------------------------------------------------------
	//Faturamento
	//--------------------------------------------------------------------------------------------------
	cQryFat := " SELECT COUNT(*) TOT_FAT "+ CRLF
	cQryFat += "    FROM (SELECT ZAD_SEARCH "+ CRLF
	cQryFat += "            FROM "+RetSqlName('ZAD') + ' ZAD ' + CRLF
	cQryFat += "            WHERE ZAD_FILIAL <> ' ' "+ CRLF
	cQryFat += "            AND ZAD_NFTOTV <> ' '   "+ CRLF
	cQryFat += "            AND ZAD_STATUS ='3' "+ CRLF
	cQryFat += "            AND ZAD.D_E_L_E_T_ =' ' "+ CRLF
	cQryFat += "            AND ZAD_DTVEND BETWEEN '"+ cDataIni +"' AND '"+cDataFim+"'  "+ CRLF
	cQryFat += "            GROUP BY ZAD_SEARCH) "+ CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQryFat) , cAliasFat,.T.,.T.)

	dbSelectArea(cAliasFat)
	(cAliasFat)->(dbGoTop())

	//--------------------------------------------------------------------------------------------------
	//Contabilização
	//--------------------------------------------------------------------------------------------------
	cQryCTB:= "SELECT COUNT(*)  CTB_FAT "+ CRLF
	cQryCTB+= "    FROM (SELECT ZAD_SEARCH  "+ CRLF
	cQryCTB+= "            FROM "+ RetSqlName('ZAD') + ' ZAD, ' + RetSqlName('SF2') + ' SF2' + CRLF
	cQryCTB+= "            WHERE ZAD_FILIAL <> ' '  "+ CRLF
	cQryCTB+= "            AND ZAD_NFTOTV <> ' '    "+ CRLF
	cQryCTB+= "            AND ZAD_NFTOTV = F2_DOC "+ CRLF
	cQryCTB+= "            AND ZAD_SETOTV = F2_SERIE "+ CRLF
	cQryCTB+= "            AND F2_DTLANC <> ' ' "+ CRLF
	cQryCTB+= "            AND ZAD_STATUS ='3' "+ CRLF
	cQryCTB+= "            AND F2_EMISSAO BETWEEN '"+ cDataIni +"' AND '"+cDataFim+"' "+ CRLF
	cQryCTB+= "            AND ZAD.D_E_L_E_T_ =' ' "+ CRLF
	cQryCTB+= " 		   AND SF2.D_E_L_E_T_ =' ' "+ CRLF
	cQryCTB+= "            GROUP BY ZAD_SEARCH) "+ CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQryCTB) , cAliasCTB,.T.,.T.)

	dbSelectArea(cAliasCTB)
	(cAliasCTB)->(dbGoTop())

	oChart:addSerie('Registros Importados (ZAD)',(cAliasZAD)->TOT_ZAD)
	oChart:addSerie('Financeiras (ZAF)'         ,(cAliasFin)->ZAF_FIN)
	oChart:addSerie('Faturados'                 ,(cAliasFat)->TOT_FAT)
	oChart:addSerie('Contabilizados'            ,(cAliasCTB)->CTB_FAT)
	oChart:addSerie('Cancelamentos'             ,(cAliasDEV)->TOT_DEV)

	If Select(cAliasFat) > 0
		(cAliasFat)->( DbCloseArea() )
	EndIf

	If Select(cAliasZAD) > 0
		(cAliasZAD)->( DbCloseArea() )
	EndIf

	If Select(cAliasDEV) > 0
		(cAliasDEV)->( DbCloseArea() )
	EndIf

	If Select(cAliasFin) > 0
		(cAliasFin)->( DbCloseArea() )
	EndIf

	If Select(cAliasCTB) > 0
		(cAliasCTB)->( DbCloseArea() )
	EndIf


Return()
