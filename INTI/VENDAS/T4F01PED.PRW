#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "APWIZARD.CH"

#DEFINE CRLF (chr(13)+chr(10))

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4F01PED                            Modulo : SIGAFAT      //
//                                                                          //
//  Realiza a inclusão de pedidos de vendas referente a vendas da 			//
//	plataforma INTI.														//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          // 
//	@author.....:	Rogério Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	02/10/2020												//	
//                                                                          //
//	@param......:	aParamEmp, array, dados da empresa e filial para 		//
//					processamento											//
/*////////////////////////////////////////////////////////////////////////////

/*/{Protheus.doc} 
Realiza a inclusão de pedidos de vendas referente a vendas da plataforma INTI.
@type Function
@param cEmp,charactere,empresa
@param cFil,charactere,filial
@version 1.00
@author Rogério Costa
@since 02/10/2020
/*/

User Function T4F01PED(aParams,oSay,cEmp,cFil,oGridPv,cdataini)

	//Local cNumPed    := ""		// Número do Pedido de Vendas
	Local cA1Cod     := ""  	// Código do Cliente
	Local cA1Cpf   	 := ""
	Local cLocalizador	:= ""
	Local cIdVenda		:= ""
	Local cSearch		:= ""
	Local cA1Loja    := "" 		// Loja do Cliente
	Local cB1Cod     := "" 		// Código do Produto
	Local cB1Doac    := "" 		// Código do Produto doacao
	Local cF4TES     := ""  	// Código do TES
	Local cE4Codigo  := "117"	// Código da Condição de Pagamento
	Local cMsgLog    := ""
	Local cFilSA1    := ""
	Local cFilSB1    := ""
	Local cFilSE4    := ""
	Local cFilSF4    := ""
	Local nOpcX      := 0
	Local aCabec     := {}
	Local aItens     := {}
	Local aDadosZAD	 := {}
	Local aLinha     := {}
	Local cQuery2    := ''
	Local cQuery3    := ''
	Local cAliasZad  := ' '
	Local cSemCPF  	 := GetNextAlias()
	Local cAliasWallet  := GetNextAlias()
	Local cItem      := '01'
	Local nI         := 0
	Local cEpep		 :=''
	Local nValTkt	 := 0
	Local nValDoacao := 0
	Local nValWallet := 0
	Local cTPRECB	 :=" "
	Local cMensNota	 :=""
	Local cMarca	 := ''
	Local lFatura	:=.F.
	Local dbkpDataBase
	Local lTemWallet	:= .F.
	Local nVlrTotal 	:= 	0
	Local nVlrTotalWallet 	:= 	0
	Local aUserInfo		:= {}
	Local nQtdAtiva 	:= 0
	Local nQtdItem		:= 0
	Local nQtdItDoacao 	:= 0
	Local nVlrTotDoacao := 0
	Local aArea
	Local cTipo 		:=  'X'
	Local cEst 			:=  'SP'
	Local cHrIni		:=	.F.
	Local nQtd 			:= 0
	Local nValTotTkt	:= 0

	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .F.

	//****************************************************************
	//* Abertura do ambiente
	//****************************************************************
	If FWIsInCallStack('U_T4FPEDAUT')

		//cDataIni:='20220525'

		If Empty(cEmp)
			If TYPE('cEmpAnt') == 'U'
				cEmp	:= aParams[1]
				cFil	:= aParams[2]
			Else
				cEmp	:= cEmpAnt
				cFil	:= cFilAnt
			EndIf
		EndIf

		//RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SB6","SED","SF4","ZAD","ZAF"

		ZAE->(DbSetFilter( { || ZAE->ZAE_MSBLQL <> '1' }, 'ZAE->ZAE_MSBLQL <> "1"' ) )

		If TYPE('cDataIni') == 'U'
			cDataIni :=  GetMV("MV_DTPED") //DTOS(ddatabase - 1)
		EndIf

		cDataFim := cDataIni

		cDtBlqINT := GetMv("MV_DTBLINT")

		If STOD(cDtBlqINT) >= STOD(cDataIni)

			cMsgLog := "Periodo bloqueado para processamento." + CRLF
			cMsgLog += "Data Bloqueio: " + DTOC(STOD(cDtBlqINT)) + CRLF

			u_T4F01LOG(cMsgLog)
			Return
		EndIf

		aUserInfo	:= 	GetUserInfoArray()
		cEmpFil		:=	cEmp + "/" + cFil

		For nI:=1 To Len(aUserInfo)

			If (aUserInfo[nI][5] == 'U_T4FPEDAUT') .And. cEmpFil $ aUserInfo[nI][11]
				nQtdAtiva := nQtdAtiva + 1
			EndIf

		Next nI

		If nQtdAtiva > 3
			Return
		EndIf

		If cDataIni == '20220630'
			Return
		EndIf

		cMarca 	 := GetMark()

	ElseIf FWIsInCallStack('U_T4FPEDMAN')

		CursorArrow()

		ZAE->(DbSetFilter( { || ZAE->ZAE_MSBLQL <> '1'  }, 'ZAE->ZAE_MSBLQL <> "1"' ) )

		cDataIni := aParams[1]
		cDataFim := aParams[2]
		cMarca 	 := aParams[3]
		cEmp	 := aParams[4]
		cFil 	 := aParams[5]
		cSearch  := aParams[6]
		cIdVenda := aParams[7]

		If TYPE('cDataIni') == 'U'
			cDataIni := DTOS(ddatabase - 1)
		EndIf

		cMarca 	 := GetMark()

		cDtBlqINT := GetMv("MV_DTBLINT")

		If STOD(cDtBlqINT) >= STOD(cDataIni)
			msg := "ATENCAO!"+CHR(13)+CHR(10)
			msg +=  CHR(13)+CHR(10)
			msg += "O periodo escolhido está bloqueado para reprocessamento."
			msg +=  CHR(13)+CHR(10)

			FWAlertWarning(msg, "Periodo Bloqueado")

			Return
		EndIf

		If cDataIni == GetMv("MV_DTPED")

			msg := "ATENCAO!"+CHR(13)+CHR(10)
			msg +=  CHR(13)+CHR(10)
			msg += "O dia inicial do periodo escolhido esta sendo processado pela aplicacao automatica."
			msg +=  CHR(13)+CHR(10)

			FWAlertWarning(msg, "Data em processamento")

			Return
		EndIf

	EndIf

	dbkpDataBase	:= DDATABASE

	If Empty(cMarca)
		cMarca 	 := GetMark()
	EndIf

	aArea			:= Lj7GetArea({"SC5","SC6","SA1","SA2","SB1","SB2","SB6","SED","SF4","ZAD","ZAF","SC9"})

	dbSelectArea("SF4")
	SF4->(dbSetOrder(1))

	DBSelectArea("SC6")
	SC6->(DBSetOrder(1))

	DBSelectArea("SC9")
	SC9->(DBSetOrder(1))

	DBSelectArea("SC5")
	SC5->(DBSetOrder(1))

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))

	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))

	SA1->(dbSetOrder(3)) //cnpj
	SE4->(dbSetOrder(1))

	ZAE->(dbSetOrder(1))
	ZAD->(dbSetOrder(1))
	ZAF->(dbSetOrder(2))
	CTD->(dbSetOrder(1))

	cFilAGG := xFilial("AGG")
	cFilSA1 := xFilial("SA1")
	cFilSB1 := xFilial("SB1")
	cFilSE4 := xFilial("SE4")
	cFilSF4 := xFilial("SF4")
	cFilZAE := xFilial("ZAE")
	cFilCTD := xFilial("CTD")

	If cEmpAnt == '33'
		cHrIni := TIME() > '01:30:00'
	ElseIf cEmpAnt == '08'
		cHrIni := TIME() > '03:30:00'
	EndIf

	If FWIsInCallStack('U_T4FPEDMAN')
		cHrIni := .T.
	EndIf

	If cHrIni

		// VERIFICAÇÃO SE EXISTE REGISTRO PARA PROCESSAR
		If !(FWIsInCallStack('U_T4FPEDMAN')) .Or. IsBlind()

			cQry:= "  " + CRLF
			cQry+= "   SELECT COUNT(*) QTD FROM  " + CRLF
			cQry+= "   (SELECT ZAD_FILIAL FROM "+RetSqlName("ZAD") + CRLF
			cQry+= "    WHERE ZAD_FILIAL='01' " + CRLF
			cQry+= "    AND ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"'" + CRLF
			cQry+= "    AND ZAD_ITEMID 	> ' ' " + CRLF
			cQry+= "    AND ZAD_EPEP 	> ' ' " + CRLF
			cQry+= "    AND ZAD_TKTID 	> ' ' " + CRLF
			cQry+= "    AND ZAD_TPTRAN = '1' " + CRLF
			cQry+= "    AND ZAD_TPITEM IN ('1','2','3','4','6','7','8') " + CRLF
			cQry+= "    AND ZAD_STATUS NOT IN ('3','4','5') " + CRLF
			cQry+= "    AND ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"'" + CRLF
			cQry+= "    AND ZAD_SLUID IN " 						+ CRLF
			cQry+= "     (SELECT ZAF_SLUID	" 					+ CRLF
			cQry+= "    	FROM "+RetSqlName("ZAF") + " ZAF " 	+ CRLF
			cQry+= "     	WHERE ZAF_FILIAL 	= '01' " 		+ CRLF
			cQry+= "      	AND ZAF_NUMERO 		> ' ' " 		+ CRLF
			cQry+= "	  	AND ZAF_SLUID 		> ' ' " 		+ CRLF
			cQry+= "     	AND ZAF_TIPO 		= 'Venda' " 	+ CRLF
			cQry+= "        AND ZAF_EPEP 		> ' ' " 		+ CRLF

			If cEmpAnt == '33'
				cQry+= "    AND ZAF_TPRECB 	= 'Indireto' "		+ CRLF
				cQry+= "    AND ZAF_TPPGTO <> 'Bonificado          '" + CRLF
				cQry+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    		" + CRLF
				cQry+= "    AND ZAF_TPPGTO <> ' '    		" + CRLF

			EndIf

			cQry+= "     	AND ZAF_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"'" + CRLF
			cQry+= "     	AND ZAF.D_E_L_E_T_ = ' '	" + CRLF
			cQry+= "     	GROUP BY ZAF_SLUID)			" + CRLF
			cQry+= "    	AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 ) " + CRLF
			cQry+= "    	AND D_E_L_E_T_ = ' ')" + CRLF

			TcQuery cQry New Alias (cAliasT:=GetNextAlias())
			dbSelectArea(cAliasT)

			(cAliasT)->(DbGotop())

			If Select(cAliasT) > 1

				nQtd := (cAliasT)->QTD

				(cAliasT)->(dbCloseArea())
			EndIf

		End If

		If LockByName("T4F01PED_INGRESSOS"+cDataIni,.T.,.F.) .And. nQtd > 0

			cMsg :=  Alltrim(Time())+" - Inicio do processo T4F01PED_INGRESSOS"
			u_T4F01LOG(cMsg)

			// LIBERA REGISTROS NAO PROCESSADOS
			cQryLibera	:= "UPDATE "+ RetSqlName('ZAD') 	+ CRLF
			cQryLibera	+= " SET ZAD_MARK =' '" 			+ CRLF
			cQryLibera	+= " WHERE ZAD_FILIAL = '01'"		+ CRLF
			cQryLibera	+= " AND  ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
			cQryLibera	+= " AND  ZAD_ITEMID 	> ' '" 		+ CRLF
			cQryLibera	+= " AND  ZAD_EPEP 		> ' '" 		+ CRLF
			cQryLibera	+= " AND  ZAD_ITTYPE 	> ' '" 		+ CRLF
			cQryLibera	+= " AND  ZAD_PEDIDO 	= ' '  "		+ CRLF

			If !Empty(cSearch)
				cQryLibera+= " AND ZAD_SEARCH = '"+cSearch+"' " + CRLF
			EndIf

			cQryLibera	+= " AND  ZAD_MARK 		> ' ' " 		+ CRLF
			cQryLibera	+= " AND  ZAD_STATUS 	= '1' "		+ CRLF
			cQryLibera	+= " AND  ZAD_TPTRAN 	= '1' "		+ CRLF
			cQryLibera	+= " AND ZAD_TPITEM IN ('1','8','6','7')" + CRLF
			cQryLibera	+= " AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 )   " + CRLF
			cQryLibera	+= " AND D_E_L_E_T_ =' ' "			+ CRLF

			nStatus := TcSqlExec(cQryLibera)

			If (nStatus < 0)

				cErro :=  REPLICATE("*", 5)+ CRLF
				cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
				u_T4F01LOG(cErro)

			EndIf

			//If GetSX8Num("SC5","C5_NUM") >=  cNumPed
			cNumPed:= GetSX8Num("SC5","C5_NUM")
			//EndIf


			//***************************************//
			//MARCA REGISTROS SEM CPF PARA PROCESSAR //
			//***************************************//
			cQryUPD	:= " UPDATE " +RetSqlName("ZAD") + CRLF
			cQryUPD	+= " SET ZAD_MARK =  '" + cMarca +"'" + CRLF
			cQryUPD	+= " WHERE ZAD_FILIAL='01' " + CRLF
			cQryUPD	+= " AND ZAD_DTVEND BETWEEN '" + cDataIni +"' AND " + "'"+cDataFim +"'" + CRLF
			cQryUPD	+= " AND ZAD_ITEMID > ' ' "+ CRLF
			cQryUPD	+= " AND ZAD_EPEP > ' ' "+ CRLF
			cQryUPD	+= " AND ZAD_TKTID > ' ' "+ CRLF
			cQryUPD += " AND ZAD_CPF = ' ' " + CRLF
			cQryUPD	+= " AND ZAD_TPTRAN = '1' " + CRLF
			cQryUPD	+= " AND ZAD_PEDIDO = ' ' " + CRLF
			cQryUPD	+= " AND ZAD_TPITEM IN ('1','2','3','4','6','7','8') " + CRLF

			If FWIsInCallStack('U_T4FPEDMAN')
				cQryUPD += " AND ZAD_STATUS = '1' " + CRLF

				If !Empty(cIdVenda)
					cQryUPD+= " AND ZAD_SLUID = '"+cIdVenda+"' " + CRLF
				EndIf

				If !Empty(cSearch)
					cQryUPD+= " AND ZAD_SEARCH = '"+cSearch+"' " + CRLF
				EndIf
			Else
				cQryUPD += " AND ZAD_STATUS = '1' " + CRLF
				cQryUPD += " AND ZAD_MARK = ' '   " + CRLF
			EndIf

			cQryUPD	+= " AND EXISTS " + CRLF
			cQryUPD	+= " 	(SELECT ZAF_SLUID	" + CRLF
			cQryUPD	+= " 	FROM " +RetSqlName("ZAF")+" ZAF	" + CRLF
			cQryUPD	+= " 		WHERE ZAF_FILIAL = ZAD_FILIAL  " + CRLF
			cQryUPD	+= " 			AND ZAF_NUMERO > ' ' " + CRLF
			cQryUPD	+= " 		  	AND ZAF_SLUID = ZAD_SLUID " + CRLF
			cQryUPD	+= "			AND ZAF_TIPO = 'Venda' " + CRLF
			cQryUPD	+= " 		  	AND ZAF_EPEP = ZAD_EPEP " + CRLF

			If cEmp == '33' // INTI NÃO CONTABILIZA ESSES MOVIMENTOS
				//cQryUPD	+= " 	AND  ZAF_TPRECB = 'Indireto' " + CRLF
				cQryUPD	+= " 	AND ZAF_TPPGTO <> 'Bonificado          '		" + CRLF
				cQryUPD	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    " + CRLF
				cQryUPD	+= "    AND ZAF_TPPGTO <> ' '    " + CRLF
			EndIf

			cQryUPD	+= " 		AND ZAF_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " + CRLF
			cQryUPD	+= " 		AND ZAF.D_E_L_E_T_ = ' '	" + CRLF
			cQryUPD	+= " 		GROUP BY ZAF_SLUID)			" + CRLF
			cQryUPD	+= " 	AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 ) " + CRLF
			cQryUPD	+= " 	AND D_E_L_E_T_ = ' ' " + CRLF

			nStatus := TcSqlExec(cQryUPD)

			If (nStatus < 0)

				cErro :=  REPLICATE("*", 5)+ CRLF
				cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
				u_T4F01LOG(cErro)

			EndIf

			//*****************************************************//
			//MARCA REGISTROS DE VENDA DE INGRESSOS PARA PROCESSAR //
			//*****************************************************//
			cQryUPD	:= " UPDATE " +RetSqlName("ZAD") + CRLF
			cQryUPD	+= " SET ZAD_MARK =  '" + cMarca +"'" + CRLF
			cQryUPD	+= " WHERE ZAD_FILIAL='01' " + CRLF
			cQryUPD	+= " AND ZAD_DTVEND BETWEEN '" + cDataIni +"' AND " + "'"+cDataFim +"'" + CRLF
			cQryUPD	+= " AND ZAD_ITEMID > ' ' "+ CRLF
			cQryUPD	+= " AND ZAD_EPEP > ' ' "+ CRLF
			cQryUPD	+= " AND ZAD_TKTID > ' ' "+ CRLF
			cQryUPD	+= " AND ZAD_TPTRAN = '1' " + CRLF
			cQryUPD	+= " AND ZAD_PEDIDO = ' ' " + CRLF
			cQryUPD	+= " AND ZAD_TPITEM IN ('1','8','6','7')" + CRLF

			If FWIsInCallStack('U_T4FPEDMAN')
				cQryUPD += " AND ZAD_STATUS = '1' " + CRLF

				If !Empty(cIdVenda)
					cQryUPD+= " AND ZAD_SLUID = '"+cIdVenda+"' " + CRLF
				EndIf

				If !Empty(cSearch)
					cQryUPD+= " AND ZAD_SEARCH = '"+cSearch+"' " + CRLF
				EndIf
			Else
				cQryUPD += " AND ZAD_STATUS = '1' " + CRLF
				cQryUPD += " AND ZAD_MARK = ' '   " + CRLF
			EndIf

			cQryUPD	+= " AND EXISTS " + CRLF
			cQryUPD	+= " 	(SELECT ZAF_SLUID	" + CRLF
			cQryUPD	+= " 	FROM " +RetSqlName("ZAF")+" ZAF	" + CRLF
			cQryUPD	+= " 		WHERE ZAF_FILIAL = ZAD_FILIAL  " + CRLF
			cQryUPD	+= " 			AND ZAF_NUMERO > ' ' " + CRLF
			cQryUPD	+= " 		  	AND ZAF_SLUID = ZAD_SLUID " + CRLF
			cQryUPD	+= "			AND ZAF_TIPO = 'Venda' " + CRLF
			cQryUPD	+= " 		  	AND ZAF_EPEP = ZAD_EPEP " + CRLF

			If cEmp == '33' // INTI NÃO CONTABILIZA ESSES MOVIMENTOS

				cQryUPD	+= " 	AND ZAF_TPPGTO <> 'Bonificado          '" + CRLF
				//cQryUPD	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'" 	+ CRLF
				cQryUPD	+= "    AND ZAF_TPPGTO <> ' '" 				+ CRLF
			EndIf

			cQryUPD	+= " 		AND ZAF_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " + CRLF
			cQryUPD	+= " 		AND ZAF.D_E_L_E_T_ = ' '	" + CRLF
			cQryUPD	+= " 		GROUP BY ZAF_SLUID)			" + CRLF
			cQryUPD	+= " 	AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 ) " + CRLF
			cQryUPD	+= " 	AND D_E_L_E_T_ = ' ' " + CRLF

			nStatus := TcSqlExec(cQryUPD)

			If (nStatus < 0)

				cErro :=  REPLICATE("*", 5)+ CRLF
				cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
				u_T4F01LOG(cErro)

			EndIf

			//*******************************//
			//PROCESSA OS REGISTROS SEM CPF //
			//******************************//
			cQuery3:= "SELECT ZAD_SEARCH,ZAD_SLUID, ZAD_IDVEND, ZAD_CPF,ZAD_DTVEND, ZAD_ITEMID, ZAD_EMP ZAD_EMP, ZAD_EVENTO, ZAD_FILIAL ZAD_FILIAL, ZAD_TPITEM, ZAD_TKTID, ZAD_ITTYPE, ZAD_NFINTI, COUNT(*) QTD, ZAD_TPAGTO, ZAD_EPEP ZAD_EPEP, SUM(ZAD_VLRTKT) ZAD_VLRTKT, SUM(ZAD_VLRTXO) ZAD_VLRTXO, SUM(ZAD_VLRTXS) ZAD_VLRTXS," + CRLF
			cQuery3+= " SUM(ZAD_VLRTXC) ZAD_VLRTXC,SUM(ZAD_VLRTXI) ZAD_VLRTXI,SUM(ZAD_VLRXCA) ZAD_VLRXCA, SUM(ZAD_VLRSOC) ZAD_VLRSOC,SUM(ZAD_VLENTR) ZAD_VLENTR"+ CRLF
			cQuery3+= " FROM " +RetSqlName("ZAD") + CRLF
			cQuery3+= " WHERE ZAD_FILIAL='01' " + CRLF
			cQuery3+= " AND ZAD_DTVEND BETWEEN '" + cDataIni +"' AND " + "'"+cDataFim +"'" + CRLF
			cQuery3+= " AND ZAD_ITEMID 	> ' ' " + CRLF
			cQuery3+= " AND ZAD_EPEP 	> ' ' " + CRLF
			cQuery3+= " AND ZAD_TKTID 	> ' ' " + CRLF
			cQuery3+= " AND ZAD_CPF 	= ' ' " + CRLF

			If FWIsInCallStack('U_T4FPEDMAN')
				If !Empty(cSearch)
					cQuery3+= " AND ZAD_SEARCH = '"+cSearch+"' " + CRLF
				EndIf

				If !Empty(cIdVenda)
					cQuery3+= " AND ZAD_SLUID = '"+cIdVenda+"' " + CRLF
				EndIf
			EndIf

			cQuery3+= " AND ZAD_TPTRAN = '1' " + CRLF
			cQuery3+= " AND ZAD_TPITEM IN ('1','2','3','4','6','7','8') " + CRLF  //1=Ingresso;2=Tx.Conv.;3=Tx.Serviço;4=Tx.Entrega;5=Cortesia; 6= Sócios; 7=Subscript,8=Doacao
			cQuery3+= " AND ZAD_MARK = '"+cMarca+ "' " + CRLF
			cQuery3+= " AND ZAD_PEDIDO = ' ' " + CRLF
			cQuery3+= " AND ZAD_STATUS = '1' " + CRLF
			cQuery3+= " AND D_E_L_E_T_ = ' ' " + CRLF
			cQuery3+= " GROUP BY ZAD_SEARCH, ZAD_EVENTO, ZAD_IDVEND, ZAD_SLUID,ZAD_ITTYPE, ZAD_ITEMID, ZAD_TKTID, ZAD_CPF, ZAD_DTVEND, ZAD_EMP, ZAD_FILIAL,ZAD_NFINTI, ZAD_TPITEM, ZAD_EPEP,ZAD_TPAGTO " + CRLF
			cQuery3+= " HAVING SUM(ZAD_VLRTKT+ZAD_VLRTXO+ZAD_VLRTXS+ZAD_VLRTXC+ZAD_VLRTXI+ZAD_VLRXCA+ZAD_VLRSOC+ZAD_VLENTR) > 0 "+ CRLF

			cQuery3+= " UNION ALL" + CRLF
			//****************************************************//
			//PROCESSA OS REGISTROS DE VENDA DE INGRESSOS COM CPF //
			//****************************************************//
			cQuery3+= "SELECT ZAD_SEARCH,ZAD_SLUID, ZAD_IDVEND, ZAD_CPF,ZAD_DTVEND, ZAD_ITEMID, ZAD_EMP ZAD_EMP, ZAD_EVENTO, ZAD_FILIAL ZAD_FILIAL, ZAD_TPITEM, ZAD_TKTID, ZAD_ITTYPE, ZAD_NFINTI, COUNT(*) QTD, ZAD_TPAGTO, ZAD_EPEP ZAD_EPEP, SUM(ZAD_VLRTKT) ZAD_VLRTKT, SUM(ZAD_VLRTXO) ZAD_VLRTXO, SUM(ZAD_VLRTXS) ZAD_VLRTXS," + CRLF
			cQuery3+= " SUM(ZAD_VLRTXC) ZAD_VLRTXC,SUM(ZAD_VLRTXI) ZAD_VLRTXI,SUM(ZAD_VLRXCA) ZAD_VLRXCA, SUM(ZAD_VLRSOC) ZAD_VLRSOC,SUM(ZAD_VLENTR) ZAD_VLENTR"+ CRLF
			cQuery3+= " FROM " +RetSqlName("ZAD") + CRLF
			cQuery3+= " WHERE ZAD_FILIAL='01' " + CRLF
			cQuery3+= " AND ZAD_DTVEND BETWEEN '" + cDataIni +"' AND " + "'"+cDataFim +"'" + CRLF
			cQuery3+= " AND ZAD_ITEMID 	> ' ' " + CRLF
			cQuery3+= " AND ZAD_EPEP 	> ' ' " + CRLF
			cQuery3+= " AND ZAD_TKTID 	> ' ' " + CRLF
			cQuery3+= " AND ZAD_CPF 	> ' ' " + CRLF

			If FWIsInCallStack('U_T4FPEDMAN')
				If !Empty(cSearch)
					cQuery3+= " AND ZAD_SEARCH = '"+cSearch+"' " + CRLF
				EndIf
				If !Empty(cIdVenda)
					cQuery3+= " AND ZAD_SLUID = '"+cIdVenda+"' " + CRLF
				EndIf
			EndIf

			cQuery3+= " AND ZAD_TPTRAN = '1' " + CRLF
			cQuery3+= " AND ZAD_TPITEM IN ('1','8','6','7') " + CRLF  //1=Ingresso;2=Tx.Conv.;3=Tx.Serviço;4=Tx.Entrega;5=Cortesia; 6= Sócios; 7=Subscript,8=Doacao
			cQuery3+= " AND ZAD_MARK = '"+cMarca+ "' " + CRLF
			cQuery3+= " AND ZAD_PEDIDO = ' ' " + CRLF
			cQuery3+= " AND ZAD_STATUS = '1' " + CRLF
			cQuery3+= " AND D_E_L_E_T_ = ' ' " + CRLF
			cQuery3+= " GROUP BY ZAD_SEARCH, ZAD_EVENTO, ZAD_IDVEND, ZAD_SLUID,ZAD_ITTYPE, ZAD_ITEMID, ZAD_TKTID, ZAD_CPF, ZAD_DTVEND, ZAD_EMP, ZAD_FILIAL,ZAD_NFINTI, ZAD_TPITEM, ZAD_EPEP,ZAD_TPAGTO " + CRLF
			cQuery3+= " HAVING SUM(ZAD_VLRTKT+ZAD_VLRTXO+ZAD_VLRTXS+ZAD_VLRTXC+ZAD_VLRTXI+ZAD_VLRXCA+ZAD_VLRSOC+ZAD_VLENTR) > 0 "+ CRLF
			cQuery3+= " ORDER BY ZAD_TPITEM,ZAD_EPEP, ZAD_SEARCH,ZAD_IDVEND, ZAD_SLUID " + CRLF

			TcQuery cQuery3 New Alias (cSemCPF:=GetNextAlias())
			dbSelectArea(cSemCPF)

			(cSemCPF)->(DbGotop())

			cLocaliz := (cSemCPF)->ZAD_SEARCH

			cIDVend := (cSemCPF)->ZAD_IDVEND

			If !Empty((cSemCPF)->ZAD_FILIAL)

				DDATABASE	:=	STOD((cSemCPF)->ZAD_DTVEND)

				cEpep:=(cSemCPF)->ZAD_EPEP

				While (cSemCPF)->(!Eof())

					nValTkt := 0

					If FWIsInCallStack('U_T4FPEDMAN')
						cMsg := "Processando Localizador|Id Venda: [ "+Alltrim((cSemCPF)->ZAD_SEARCH)+Alltrim((cSemCPF)->ZAD_SLUID)+" ]

						oGridPv:SetIncMeter(1,cMsg)

					EndIf

					nPos:=AT( "/",(cSemCPF)->ZAD_EPEP)

					//GERAÇÃO DE PEDIDO UNICO PARA INGRESSOS
					If ((cSemCPF)->ZAD_TPITEM == '1' .Or. (cSemCPF)->ZAD_TPITEM == '6' .Or. (cSemCPF)->ZAD_TPITEM == '8' .Or. (cSemCPF)->ZAD_TPITEM == '7') .And. cEpep	==	(cSemCPF)->ZAD_EPEP

						If (cSemCPF)->ZAD_TPITEM == '1' .Or. (cSemCPF)->ZAD_TPITEM == '6' .Or. (cSemCPF)->ZAD_TPITEM == '7'
							cItem:='01'
						ElseIf (cSemCPF)->ZAD_TPITEM == '8'
							cItem:='02'
						EndIf

						//VERIFICA SE TEM PAGAMENTO COM WALLET
						If cEmp == '33' .And. (cSemCPF)->ZAD_VLRTKT > 0

							If Select(cAliasWallet) > 0
								(cAliasWallet)->( DbCloseArea() )
							EndIf

							lTemWallet	:= .F.

							cQryWallet := " SELECT ZAF_TPRECB,ZAF_SLUID ,SUM(ZAF_FINCRE) ZAF_FINCRE,SUM(ZAF_VLRTRA) ZAF_VLRTRA " + CRLF
							cQryWallet += " FROM " +RetSqlName("ZAF") 							+ CRLF
							cQryWallet += " WHERE ZAF_FILIAL 	= '01' "						+ CRLF
							cQryWallet += " AND ZAF_NUMERO 		> ' ' " 						+ CRLF
							cQryWallet += " AND ZAF_SLUID 		= '" + (cSemCPF)->ZAD_SLUID + "'"+ CRLF
							cQryWallet += " AND ZAF_TIPO 		='Venda' " 						+ CRLF
							cQryWallet += " AND ZAF_EPEP 		= '"+(cSemCPF)->ZAD_EPEP + "'" 	+ CRLF
							cQryWallet += " AND ZAF_SEARCH 		='"+(cSemCPF)->ZAD_SEARCH + "' "+ CRLF
							cQryWallet += " AND ZAF_TPRECB 		='Indireto' " 					+ CRLF
							cQryWallet += " AND ZAF_TPPGTO 		= 'INTI Wallet' " 				+ CRLF
							cQryWallet += " AND ZAF_DTVEND 		= '"+(cSemCPF)->ZAD_DTVEND +"'"	+ CRLF
							cQryWallet += " AND D_E_L_E_T_ 		=' ' " 							+ CRLF
							cQryWallet += " GROUP BY ZAF_SLUID,ZAF_TPRECB " 					+ CRLF

							TcQuery cQryWallet New Alias (cAliasWallet:=GetNextAlias())
							dbSelectArea(cAliasWallet)

							(cAliasWallet)->( DbGotop() )

							If (cAliasWallet)->ZAF_FINCRE > 0
								lTemWallet	:= .T.
							EndIf

							cQryZaf := " SELECT ZAF_SLUID, ZAF_SEARCH ,SUM(ZAF_FINCRE) ZAF_FINCRE,SUM(ZAF_VLRTRA) ZAF_VLRTRA,ZAF_TPRECB " + CRLF
							cQryZaf += " FROM " +RetSqlName("ZAF") 						 + CRLF
							cQryZaf += " WHERE ZAF_FILIAL = '01' "						 + CRLF
							cQryZaf += " AND ZAF_NUMERO > ' ' " 						 + CRLF
							cQryZaf += " AND ZAF_SLUID 	= '" + (cSemCPF)->ZAD_SLUID + "'" + CRLF
							cQryZaf += " AND ZAF_TIPO 	='Venda' " 						 + CRLF
							cQryZaf += " AND ZAF_EPEP 	= '"+(cSemCPF)->ZAD_EPEP + "'" 	 + CRLF
							cQryZaf += " AND ZAF_SEARCH ='"+(cSemCPF)->ZAD_SEARCH + "' " + CRLF
							cQryZaf += " AND ZAF_TPRECB = 'Indireto' 					"+ CRLF
							cQryZaf += " AND ZAF_DTVEND = '"+(cSemCPF)->ZAD_DTVEND+"'"   + CRLF
							cQryZaf += " AND ZAF_TPPGTO <> 'Bonificado          '		"+ CRLF
							cQryZaf += " AND ZAF_TPPGTO <> 'INTI Wallet'    			"+ CRLF
							cQryZaf += " AND ZAF_TPPGTO <> ' '"							 + CRLF
							//cQryZaf += " AND ZAF_STATUS = ' '"							 + CRLF
							cQryZaf += " AND D_E_L_E_T_ =' ' "							 + CRLF
							cQryZaf += " GROUP BY ZAF_SLUID,ZAF_TPRECB,ZAF_SEARCH "		 + CRLF

							TcQuery cQryZaf New Alias (cAliasZ:=GetNextAlias())
							dbSelectArea(cAliasZ)

							(cAliasZ)->( DbGotop() )

							cTPRECB		:= 	(cAliasZ)->ZAF_TPRECB
							nVLRTRA		:= 	(cAliasZ)->ZAF_VLRTRA
							nVLRFINCRE	:= 	(cAliasZ)->ZAF_FINCRE
							cZAF_SLUID	:= 	(cAliasZ)->ZAF_SLUID
							cZAF_SEARCH	:=	(cAliasZ)->ZAF_SEARCH
							

							If Select(cAliasZ) > 0
								(cAliasZ)->( DbCloseArea() )
							Else
								cTPRECB		:= ''
								nVLRTRA		:= 0
								nVLRFINCRE	:= 0
							EndIf

						Else

							cTPRECB		:= 	''//ZAF->ZAF_TPRECB
							nVLRTRA		:= 	0//ZAF->ZAF_VLRTRA
							nVLRFINCRE	:=	0// ZAF->ZAF_FINCRE

						EndIf

						If cEmp == '33' .And. Alltrim(cTPRECB) == 'Indireto' //.or. Alltrim((cAliasWallet)->ZAF_TPRECB) == 'Indireto') )

							If lTemWallet

								nValTkt := nVLRFINCRE

								cQryUpdZaf := " UPDATE " +RetSqlName("ZAF") 				 + CRLF
								cQryUpdZaf += " SET ZAF_STATUS = 'X'"
								cQryUpdZaf += " WHERE ZAF_FILIAL = '01' "						 + CRLF
								cQryUpdZaf += " AND ZAF_NUMERO > ' ' " 						 + CRLF
								cQryUpdZaf += " AND ZAF_SLUID 	= '" + (cSemCPF)->ZAD_SLUID + "'" + CRLF
								cQryUpdZaf += " AND ZAF_TIPO 	='Venda' " 						 + CRLF
								cQryUpdZaf += " AND ZAF_EPEP 	= '"+(cSemCPF)->ZAD_EPEP + "'" 	 + CRLF
								cQryUpdZaf += " AND ZAF_SEARCH ='"+(cSemCPF)->ZAD_SEARCH + "' " + CRLF
								cQryUpdZaf += " AND ZAF_TPRECB = 'Indireto' 					"+ CRLF
								cQryUpdZaf += " AND ZAF_DTVEND = '"+(cSemCPF)->ZAD_DTVEND+"'"   + CRLF
								cQryUpdZaf += " AND ZAF_TPPGTO <> 'Bonificado          '		"+ CRLF
								cQryUpdZaf += " AND ZAF_TPPGTO <> 'INTI Wallet'    			"+ CRLF
								cQryUpdZaf += " AND ZAF_TPPGTO <> ' '"							 + CRLF
								cQryUpdZaf += " AND D_E_L_E_T_ =' ' "							 + CRLF

								nStatus := TcSqlExec(cQryUpdZaf)

								If (nStatus < 0)

									cErro :=  REPLICATE("*", 5)+ CRLF
									cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
									u_T4F01LOG(cErro)

								EndIf

								cQryUpdZad := " UPDATE " +RetSqlName("ZAD") 				 + CRLF
								cQryUpdZad += " SET ZAD_STATUS = '3'"
								cQryUpdZad += " WHERE ZAD_FILIAL = '01' "						 + CRLF
								cQryUpdZad += " AND ZAD_NUMERO > ' ' " 						 + CRLF
								cQryUpdZad += " AND ZAD_SLUID 	= '" + (cSemCPF)->ZAD_SLUID + "'" + CRLF
								cQryUpdZad += " AND ZAD_TPTRAN 	='1' " 						 + CRLF
								cQryUpdZad += " AND ZAD_EPEP 	= '"+(cSemCPF)->ZAD_EPEP + "'" 	 + CRLF
								cQryUpdZad += " AND ZAD_SEARCH ='"+(cSemCPF)->ZAD_SEARCH + "' " + CRLF
								cQryUpdZad += " AND ZAD_DTVEND = '"+(cSemCPF)->ZAD_DTVEND+"'"   + CRLF
								cQryUpdZad += " AND ZAD_STATUS = '1' " 						 + CRLF
								cQryUpdZad += " AND D_E_L_E_T_ =' ' "							 + CRLF

								nStatus := TcSqlExec(cQryUpdZaf)

								If (nStatus < 0)

									cErro :=  REPLICATE("*", 5)+ CRLF
									cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
									u_T4F01LOG(cErro)

								EndIf

								lTemWallet := .F.
							Else

								nValTkt 	:= 	(cSemCPF)->ZAD_VLRTKT

							EndIf

						ElseIf cEmp == '08'
							nValTkt 	:= 	(cSemCPF)->ZAD_VLRTKT
							nValWallet	:=	0
						EndIf

						If nPos > 0
							cEpep:=substr((cSemCPF)->ZAD_EPEP,1,nPos-1)
						Else
							cEpep:=(cSemCPF)->ZAD_EPEP
						EndIf

						If ZAE->(MsSeek(cFilZAE + cEpep)) .And. ZAE->ZAE_MSBLQL <> '1'

							cB1Cod  :=  ZAE->ZAE_PRDTKT
							cB1Doac	:=  ZAE->ZAE_PRDOAC

							If (((cSemCPF)->ZAD_VLRTKT > 0 .OR. nValTkt > 0 .OR.  (cSemCPF)->ZAD_VLRSOC > 0 .Or. (cSemCPF)->ZAD_VLRTXS > 0) .AND. !Empty((cSemCPF)->ZAD_EPEP))

								//****************************************************************
								//* Inclusao - INICIO
								//****************************************************************
								SA1->(dbSetOrder(1))
								If SA1->(!MsSeek(cFilSA1 + 'SEMCPF'))
									cMsgLog +=  REPLICATE("*", 5)+ CRLF
									cMsgLog += "Não existe o cadastro para cliente sem CPF SEMCPF: " + CRLF
								Else
									cA1Cod  :=  SA1->A1_COD
									cA1Loja :=  SA1->A1_LOJA
									cBlqCli :=  SA1->A1_MSBLQL
									cTipo 	:=  SA1->A1_TIPO
									cEst 	:=  SA1->A1_EST
								End If

								If (cBlqCli=="2") .OR. (cBlqCli==" ")

									If (cEmp == '33' .And. Alltrim(cTPRECB) == 'Indireto' .And. nVLRFINCRE > 0)

										If nValTkt == 0
											nValTkt 		:= (cSemCPF)->ZAD_VLRTKT
										EndIf

									ElseIf (cEmp == '33' .And. Alltrim(cTPRECB) == 'Direto' .And. (cSemCPF)->ZAD_VLRTXC > 0)

										nValTkt := 0

									ElseIf cEmp == '08' .And. (cSemCPF)->ZAD_TPITEM == '1'
										nValTkt 	:= 	(cSemCPF)->ZAD_VLRTKT
										nValWallet	:=	0

									ElseIf cEmp == '08' .And. (cSemCPF)->ZAD_TPITEM == '8'
										nValDoacao 	:= 	(cSemCPF)->ZAD_VLRTKT + (cSemCPF)->ZAD_VLRTXS
										nValWallet	:=	0
									EndIf

									//****************************************************************
									//- Informando os dados do item do Pedido de Venda
									//****************************************************************

									If nValWallet > 0

										cB1Cod:=ZAE->ZAE_PRDWAL

										If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
											cF4TES := SB1->B1_TS
											cDescri	:= SB1->B1_DESC
											cUnMed	:= SB1->B1_UM
											cConta	:= SB1->B1_CONTA
										End If

										aLinha := {}
										aadd(aLinha,cItem)
										aadd(aLinha,cB1Cod)
										aadd(aLinha,(cSemCPF)->QTD)
										aadd(aLinha,nValWallet / (cSemCPF)->QTD)
										aadd(aLinha,nValWallet / (cSemCPF)->QTD)
										aadd(aLinha,nValWallet)
										aadd(aLinha,cF4TES)
										aadd(aLinha,cEpep)
										aadd(aLinha,(cSemCPF)->ZAD_SEARCH)
										aadd(aLinha, Alltrim((cSemCPF)->ZAD_SLUID) +'-'+ Alltrim((cSemCPF)->ZAD_SEARCH))
										aadd(aLinha,(cSemCPF)->ZAD_TPITEM)
										aadd(aLinha,(cSemCPF)->ZAD_TKTID)

										cMensNota := "Referente evento: " + CRLF + Alltrim((cSemCPF)->ZAD_EVENTO) + CRLF +"Id.Venda: "+ Alltrim((cSemCPF)->ZAD_SLUID)+ CRLF +"Localizador: "+ Alltrim((cSemCPF)->ZAD_SEARCH)

										aadd(aLinha,cMensNota)
										aadd(aLinha, Alltrim((cSemCPF)->ZAD_SLUID))

										aadd(aItens, aLinha)

									EndIf

									If (nValTkt+(cSemCPF)->ZAD_VLRSOC) > 0 .And. ((cSemCPF)->ZAD_TPITEM == '1' .Or. (cSemCPF)->ZAD_TPITEM == '6' .Or. (cSemCPF)->ZAD_TPITEM == '7')

										If cEmp == '33' .And. lTemWallet

											If nVLRFINCRE >= (nVlrTotalWallet	+	nValTkt	+	(cSemCPF)->ZAD_VLRSOC) .And. cZAF_SLUID == (cSemCPF)->ZAD_SLUID .And. cZAF_SEARCH == (cSemCPF)->ZAD_SEARCH

												nQtdItem 		:= nQtdItem + 1
												nVlrTotal 		:= nVlrTotal + nValTkt + (cSemCPF)->ZAD_VLRSOC
												nVlrTotalWallet	:=	nValTkt + nVlrTotalWallet	

												aAdd(aDadosZAD,{cEpep,(cSemCPF)->ZAD_SEARCH,Alltrim((cSemCPF)->ZAD_SLUID),(cSemCPF)->ZAD_TPITEM,(cSemCPF)->ZAD_TKTID,cItem})
											Else

												nVlrTotalWallet	:=	0

											EndIf
										Else
											nQtdItem 	:= nQtdItem + 1
											nVlrTotal 	:= nVlrTotal	+	nValTkt + (cSemCPF)->ZAD_VLRSOC

											aAdd(aDadosZAD,{cEpep,(cSemCPF)->ZAD_SEARCH,Alltrim((cSemCPF)->ZAD_SLUID),(cSemCPF)->ZAD_TPITEM,(cSemCPF)->ZAD_TKTID,cItem})
										EndIf

									ElseIf nValDoacao > 0 .And. (cSemCPF)->ZAD_TPITEM == '8'
										nQtdItDoacao 	:= nQtdItDoacao  + 1
										nVlrTotDoacao 	:= nVlrTotDoacao + nValDoacao

										aAdd(aDadosZAD,{cEpep,(cSemCPF)->ZAD_SEARCH,Alltrim((cSemCPF)->ZAD_SLUID),(cSemCPF)->ZAD_TPITEM,(cSemCPF)->ZAD_TKTID,cItem})

									EndIf

								Else

									cMsgLog+=  REPLICATE("*", 5)+ CRLF
									cMsgLog+=  Alltrim(DTOC(DDATABASE)) + "-" + Alltrim(Time())+'- Cliente bloqueado para uso:' + cA1Cod+'-'+cA1Loja +'Empresa:' + cEmp

								EndIf
							Else
								cMsgLog	+=  REPLICATE("*", 5)+ CRLF
								cMsgLog +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - Item sem valor " + Alltrim((cSemCPF)->ZAD_EPEP) +'Empresa:' + cEmp

								cItem := Soma1(cItem)

							EndIf

						Else
							cMsgLog	+=  REPLICATE("*", 5)+ CRLF
							cMsgLog +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - EPEP não cadastrado na tabela ZAE ou CTD:" + Alltrim((cSemCPF)->ZAD_EPEP) +'Empresa:' + cEmp

							cItem := Soma1(cItem)

						EndIf

					Else

						If Len(aCabec) == 0 .And. (nVlrTotal > 0 .Or. nVlrTotDoacao > 0)

							aadd(aCabec,''				 ) 	//1
							aadd(aCabec,"N"	   				 )	//2
							aadd(aCabec,cA1Cod				 )	//3
							aadd(aCabec,cA1Loja	 			 )	//4
							aadd(aCabec,cA1Loja	 			 )	//5
							aadd(aCabec,cE4Codigo			 )	//6
							aadd(aCabec,"500302"			 )	//7
							aadd(aCabec,(cSemCPF)->ZAD_TPAGTO)	//8
							aadd(aCabec,DDATABASE			 )	//9
							aadd(aCabec,'SEM CPF'			 )	//10
							aadd(aCabec,''					 )	//11
							aadd(aCabec,cTipo				 )	//12
							aadd(aCabec,cEst				 )	//12

							cItem:='01'
						EndIf

						//Ingressos
						If nVlrTotal > 0
							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
								cF4TES := SB1->B1_TS
							End If

							aLinha := {}
							aadd(aLinha,cItem)
							aadd(aLinha,cB1Cod)
							aadd(aLinha,nQtdItem)
							aadd(aLinha,nVlrTotal/nQtdItem)
							aadd(aLinha,nVlrTotal/nQtdItem)
							aadd(aLinha,nVlrTotal)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,"INGRESSO")
							aadd(aLinha,"INGRESSO")
							aadd(aLinha,"INGRESSO")
							aadd(aLinha,"INGRESSO")

							cMensNota := "Referente evento: " + CRLF + Alltrim((cSemCPF)->ZAD_EVENTO) + CRLF

							aadd(aLinha,cMensNota)
							aadd(aLinha, "INGRESSO")

							aadd(aItens, aLinha)

							nQtdItem 	:= 0
							nVlrTotal 	:= 0
						EndIf

						//Doações
						If nVlrTotDoacao > 0

							cItem:=Soma1(cItem)

							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Doac)))
								cF4TES := SB1->B1_TS
							End If

							aLinha := {}
							aadd(aLinha,cItem)
							aadd(aLinha,cB1Doac)
							aadd(aLinha,nQtdItDoacao)
							aadd(aLinha,nVlrTotDoacao/nQtdItDoacao)
							aadd(aLinha,nVlrTotDoacao/nQtdItDoacao)
							aadd(aLinha,nVlrTotDoacao)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,"DOACAO")
							aadd(aLinha,"DOACAO")
							aadd(aLinha,"DOACAO")
							aadd(aLinha,"DOACAO")

							cMensNota := "Referente evento: " + CRLF + Alltrim((cSemCPF)->ZAD_EVENTO) + CRLF

							aadd(aLinha,cMensNota)
							aadd(aLinha, "DOACAO")

							aadd(aItens, aLinha)

							nQtdItDoacao 	:= 0
							nVlrTotDoacao 	:= 0
						EndIf
						cItem 	:= '01'

						If Len(aItens) > 0
							nOpcX := 3

							aItensNf:=	aItens

							lRet	:=	T4FGRVPED(aCabec,aItens,oSay,oGridPv,dbkpDataBase,aDadosZAD)

							If lRet

								If FWIsInCallStack('U_T4FPEDMAN')
									cMsg := "ENVIANDO PEDIDO PARA FATURAMENTO: "+aCabec[1]
									oGridPv:SetIncMeter(1,cMsg)
								EndIf

								U_T4F01NF(aCabec[9],aCabec[1],oSay,oGridPv,aDadosZAD,aItensNf)

								//cNumPed:= GetSX8Num("SC5","C5_NUM")

								aItens		:= {}
								aCabec		:= {}
								aDadosZAD 	:= {}

							Else

								RollBackSx8()

								cArqLog := SubStr( Time(),1,5 ) + ".log"

								cMsgLog   += MostraErro("\log_INTI", cArqLog) + CRLF

								u_T4F01LOG(cMsgLog)

							EndIf

							cLocaliz 	:= 	(cSemCPF)->ZAD_SEARCH
							cIDVend 	:= 	(cSemCPF)->ZAD_IDVEND
							aCabec		:=	{}
							aItens		:=	{}
							aDadosZAD 	:= 	{}

							cEpep	:=	(cSemCPF)->ZAD_EPEP

							Loop


						EndIf

					EndIf

					cEpep	:=	(cSemCPF)->ZAD_EPEP

					(cSemCPF)->(dbSkip())

				EndDo

				If Len(aCabec) == 0 .And. (nVlrTotal > 0 .Or. nVlrTotDoacao > 0)

					aadd(aCabec,' '					 ) 	//1
					aadd(aCabec,"N"	   				 )	//2
					aadd(aCabec,cA1Cod				 )	//3
					aadd(aCabec,cA1Loja	 			 )	//4
					aadd(aCabec,cA1Loja	 			 )	//5
					aadd(aCabec,cE4Codigo			 )	//6
					aadd(aCabec,"500302"			 )	//7
					aadd(aCabec,(cSemCPF)->ZAD_TPAGTO)	//8
					aadd(aCabec,DDATABASE			 )	//9
					aadd(aCabec,'SEM CPF'			 )	//10
					aadd(aCabec,''					 )	//11
					aadd(aCabec,cTipo				 )	//12
					aadd(aCabec,cEst				 )	//13

					cItem:='01'
				EndIf

				//Ingressos
				If nVlrTotal > 0
					If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
						cF4TES := SB1->B1_TS
					End If

					aLinha := {}
					aadd(aLinha,cItem)
					aadd(aLinha,cB1Cod)
					aadd(aLinha,nQtdItem)
					aadd(aLinha,nVlrTotal/nQtdItem)
					aadd(aLinha,nVlrTotal/nQtdItem)
					aadd(aLinha,nVlrTotal)
					aadd(aLinha,cF4TES)
					aadd(aLinha,cEpep)
					aadd(aLinha,"INGRESSO")
					aadd(aLinha,"INGRESSO")
					aadd(aLinha,"INGRESSO")
					aadd(aLinha,"INGRESSO")

					cMensNota := "Referente evento: " + CRLF + Alltrim((cSemCPF)->ZAD_EVENTO) + CRLF

					aadd(aLinha,cMensNota)
					aadd(aLinha, "INGRESSO")

					aadd(aItens, aLinha)

					nQtdItem 	:= 0
					nVlrTotal 	:= 0
				EndIf

				//Doações
				If nVlrTotDoacao > 0
					If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Doac)))
						cF4TES := SB1->B1_TS
					End If

					aLinha := {}
					aadd(aLinha,Soma1(cItem))
					aadd(aLinha,cB1Doac)
					aadd(aLinha,nQtdItDoacao)
					aadd(aLinha,nVlrTotDoacao/nQtdItDoacao)
					aadd(aLinha,nVlrTotDoacao/nQtdItDoacao)
					aadd(aLinha,nVlrTotDoacao)
					aadd(aLinha,cF4TES)
					aadd(aLinha,cEpep)
					aadd(aLinha,"DOACAO")
					aadd(aLinha,"DOACAO")
					aadd(aLinha,"DOACAO")
					aadd(aLinha,"DOACAO")

					cMensNota := "Referente evento: " + CRLF + Alltrim((cSemCPF)->ZAD_EVENTO) + CRLF

					aadd(aLinha,cMensNota)
					aadd(aLinha, "DOACAO")

					aadd(aItens, aLinha)

					nQtdItDoacao 	:= 0
					nVlrTotDoacao 	:= 0
				EndIf
				cItem 	:= '01'

				If Len(aItens) > 0
					nOpcX := 3

					aItensNf:=	aItens

					lRet	:=	T4FGRVPED(aCabec,aItens,oSay,oGridPv,dbkpDataBase,aDadosZAD)

					If lRet

						If FWIsInCallStack('U_T4FPEDMAN')
							cMsg := "Faturando pedido : [ "+aCabec[1]+" ]

							oGridPv:SetIncMeter(1,cMsg)
						EndIf

						U_T4F01NF(aCabec[9],aCabec[1],oSay,oGridPv,aDadosZAD,aItensNf)

						//cNumPed:= GetSX8Num("SC5","C5_NUM")

						aItens		:={}
						aCabec   	:= {}
						aDadosZAD 	:= {}

					Else

						cArqLog := SubStr( Time(),1,5 ) + ".log"

						cMsgLog   += MostraErro("\log_INTI", cArqLog) + CRLF

						u_T4F01LOG(cMsgLog)

					EndIf
				End If

				//****************************************************************
				//* Inclusao - FIM
				//****************************************************************
			Else

				cMsg :=  Alltrim(Time())+" - Não há dados para processar T4F01PED_INGRESSOS cSemCPF " + cEmp
				u_T4F01LOG(cMsg)

				//Reprocessa pedidos que não foram faturados
				cQuery3:= " SELECT ZAD_SEARCH, ZAD_PEDIDO,ZAD_DTVEND " + CRLF
				cQuery3+= " FROM " +RetSqlName("ZAD") + CRLF
				cQuery3+= " WHERE ZAD_DTVEND BETWEEN '" + cDataIni +"' AND " + "'"+cDataFim +"'" + CRLF
				cQuery3+= " 	AND ZAD_ITEMID 	> ' ' " + CRLF
				cQuery3+= " 	AND ZAD_EPEP 	> ' ' " + CRLF
				cQuery3+= " 	AND ZAD_TKTID 	> ' ' " + CRLF
				cQuery3+= " 	AND ZAD_STATUS = '2' " + CRLF
				cQuery3+= " 	AND ZAD_CPF = ' ' " + CRLF

				If !Empty(cSearch)
					cQuery3+= " AND ZAD_SEARCH = '"+cSearch+"' " + CRLF
				EndIf

				If !Empty(cIdVenda)
					cQuery3+= " AND ZAD_SLUID = '"+cIdVenda+"' " + CRLF
				EndIf

				cQuery3+= "  GROUP BY ZAD_SEARCH, ZAD_PEDIDO,ZAD_DTVEND " + CRLF

				TcQuery cQuery3 New Alias (cSemCPF2:=GetNextAlias())
				dbSelectArea(cSemCPF2)

				(cSemCPF2)->( DbGotop() )


				lFatura:=.F.

				While !(cSemCPF2)->(Eof())

					If SC6->(MsSeek(xFilial("SC6") + (cSemCPF2)->ZAD_PEDIDO)) .And. SC5->(MsSeek(xFilial("SC5") + (cSemCPF2)->ZAD_PEDIDO))

						While SC6->(!EOF()) .And. SC6->C6_NUM == (cSemCPF2)->ZAD_PEDIDO
							If FWIsInCallStack('U_T4FPEDMAN')
								cMsg := "Processando Localizador|Id Venda: [ "+Alltrim((cSemCPF2)->ZAD_PEDIDO)+" ]
								oGridPv:SetIncMeter(1,cMsg)
							EndIf

							If !(SC9->(MsSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)))
								MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,,,.T.,.T.,.F.,.F.)
							EndIf

							SC6->(dBSkip())

						EndDo

						U_T4F01NF((cSemCPF2)->ZAD_DTVEND,(cSemCPF2)->ZAD_PEDIDO,oSay,oGridPv,aDadosZAD,{})
						aDadosZAD:={}

					EndIf

					(cSemCPF2)->(DbSkip())
				EndDo

				If Select(cSemCPF2) > 0
					(cSemCPF2)->( DbCloseArea() )
				EndIf
			EndIf

			If Select(cSemCPF) > 0
				(cSemCPF)->( DbCloseArea() )
			EndIf

			UnLockByName("T4F01PED_INGRESSOS"+cDataIni,.T.,.F.)
			cMsg :=  Alltrim(Time())+" - Fim do Processo T4F01PED_INGRESSOS"
			u_T4F01LOG(cMsg)

		Else
			cMsg :=  Alltrim(Time())+" - A rotina já esta em execução-T4F01PED_INGRESSOS"
			//ConOut("A rotina já esta em execução-T4F01PED_INGRESSOS-"+Time())
			u_T4F01LOG(cMsg)
		EndIf

		If LockByName("T4F01PED_TAXAS"+cDataIni,.T.,.F.) .And. nQtd > 0

			// LIBERA REGISTROS NAO PROCESSADOS
			cQryLibera	:= "UPDATE "+ RetSqlName('ZAD') 	+ CRLF
			cQryLibera	+= " SET ZAD_MARK =' '" 			+ CRLF
			cQryLibera	+= " WHERE ZAD_FILIAL = '01'"		+ CRLF
			cQryLibera	+= " AND  ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
			cQryLibera	+= " AND  ZAD_ITEMID 	> ' '" 		+ CRLF
			cQryLibera	+= " AND  ZAD_EPEP 		> ' '" 		+ CRLF
			cQryLibera	+= " AND  ZAD_ITTYPE 	> ' '" 		+ CRLF
			cQryLibera	+= " AND  ZAD_PEDIDO 	= ' '  "		+ CRLF
			cQryLibera	+= " AND  ZAD_MARK 		> ' ' " 		+ CRLF
			cQryLibera	+= " AND  ZAD_STATUS 	= '1' "		+ CRLF
			cQryLibera	+= " AND  ZAD_TPTRAN 	= '1' "		+ CRLF
			cQryLibera	+= " AND ZAD_TPITEM IN ('2','3','4','7','8')	 " + CRLF
			cQryLibera	+= " AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 )   " + CRLF
			cQryLibera	+= " AND D_E_L_E_T_ =' ' "			+ CRLF

			nStatus := TcSqlExec(cQryLibera)

			If (nStatus < 0)

				cErro :=  REPLICATE("*", 5)+ CRLF
				cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
				u_T4F01LOG(cErro)

			EndIf

			nValTkt := 0

			//ConOut("T4F01PED_TAXAS-"+Time())

			cMsg :=  Alltrim(Time())+" - Incio do Processo T4F01PED_TAXAS"
			u_T4F01LOG(cMsg)

			//****************************************//
			//MARCA REGISTROS DE TAXAS  PARA PROCESSAR//
			//****************************************//
			cQryUPD	:= " UPDATE " +RetSqlName("ZAD") + CRLF
			cQryUPD	+= " SET ZAD_MARK =  '" + cMarca +"'" + CRLF
			cQryUPD	+= " WHERE ZAD_FILIAL ='01'  " + CRLF
			cQryUPD	+= " 	AND ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
			cQryUPD	+= " 	AND ZAD_ITEMID > ' ' " + CRLF
			cQryUPD	+= " 	AND ZAD_EPEP > ' ' " + CRLF
			cQryUPD	+= " 	AND ZAD_TKTID > ' ' " + CRLF
			cQryUPD	+= "    AND ZAD_STATUS = '1' " + CRLF
			cQryUPD	+= "    AND ZAD_MARK = ' '		  " + CRLF
			cQryUPD	+= " 	AND ZAD_PEDIDO = ' '		  " + CRLF
			cQryUPD	+= " 	AND EXISTS " + CRLF
			cQryUPD	+= " (SELECT ZAD_CPF FROM
			cQryUPD	+= " 	(SELECT ZAD_CPF " + CRLF
			cQryUPD	+= " 		FROM " +RetSqlName("ZAD")+" ZAD2, "+ RetSqlName("ZAF") +" ZAF " + CRLF
			cQryUPD	+= " 		WHERE ZAD_FILIAL ='01' " + CRLF
			cQryUPD	+= " 		AND ZAD2.ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
			cQryUPD	+= " 		AND ZAD2.ZAD_ITEMID = ZAD_ITEMID  " + CRLF
			cQryUPD	+= " 		AND ZAD2.ZAD_EPEP 	= ZAD_EPEP  " + CRLF
			cQryUPD	+= " 		AND ZAD2.ZAD_TKTID 	= ZAD_TKTID  " + CRLF
			cQryUPD	+= " 		AND ZAD2.ZAD_CPF    = ZAD_CPF  " + CRLF
			cQryUPD	+= " 		AND ZAD_SLUID = ZAF_SLUID " + CRLF
			cQryUPD	+= " 		AND ZAD_TPTRAN = '1' " + CRLF
			cQryUPD	+= " 		AND ZAD_STATUS = '1' " + CRLF
			cQryUPD	+= " 		AND ZAD_MARK = ' '		  " + CRLF
			cQryUPD	+= " 		AND ZAD_TPITEM IN ('2','3','4','7','8')	 " + CRLF
			cQryUPD	+= " 		AND ZAD_PEDIDO = ' '		  " + CRLF
			cQryUPD	+= " 		AND ZAF_TIPO = 'Venda'  " + CRLF
			cQryUPD	+= " 		AND ZAF_TPPGTO <> 'Bonificado          ' " + CRLF

			If cEmp == '33'
				cQryUPD	+= " 	AND  ZAF_TPRECB = 'Indireto' " + CRLF
				cQryUPD	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    " + CRLF
			EndIf

			cQryUPD	+= " 		AND ZAD2.D_E_L_E_T_ = ' ' " + CRLF
			cQryUPD	+= " 		AND ZAF.D_E_L_E_T_ = ' ' " + CRLF
			cQryUPD	+= "		AND ROWNUM < 300		" + CRLF
			cQryUPD	+= " 	GROUP BY ZAD_CPF
			cQryUPD	+= " 	ORDER BY ZAD_CPF) " + CRLF
			cQryUPD	+= "WHERE ZAD_FILIAL <> ' ') "+ CRLF
			cQryUPD	+= " 	AND ZAD_PEDIDO 	= ' '		  " + CRLF
			cQryUPD	+= " 	AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 ) " + CRLF
			cQryUPD	+= " 	AND D_E_L_E_T_ = ' ' " + CRLF

			nStatus := TcSqlExec(cQryUPD)

			If (nStatus < 0)

				cErro :=  REPLICATE("*", 5)+ CRLF
				cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
				u_T4F01LOG(cErro)

			EndIf

			//*******************************************//
			//PROCESSA OS REGISTROS DE TAXAS			 //
			//*******************************************//
			cQuery2:= "SELECT ZAD_NOME , ZAD_CPF ,ZAD_DTEVEN ,ZAD_ITEMID ,ZAD_DTVEND,ZAD_IDVEND, ZAD_EVENTO,ZAD_ITTYPE, ZAD_EMP , ZAD_TKTID, ZAD_FILIAL ZAD_FILIAL, ZAD_NFINTI, ZAD_TPITEM , " + CRLF
			cQuery2+= " COUNT(*) QTD, ZAD_TPAGTO, ZAD_EPEP , SUM(ZAD_VLRTKT) ZAD_VLRTKT, SUM(ZAD_VLRTXO) ZAD_VLRTXO, SUM(ZAD_VLRTXS) ZAD_VLRTXS, SUM(ZAD_VLRSOC) ZAD_VLRSOC," + CRLF
			cQuery2+= " SUM(ZAD_VLRTXC) ZAD_VLRTXC,SUM(ZAD_VLRTXI) ZAD_VLRTXI,SUM(ZAD_VLRXCA) ZAD_VLRXCA,SUM(ZAD_VLENTR) ZAD_VLENTR, ZAD_SEARCH, ZAD_SLUID "+ CRLF
			cQuery2+= "	FROM " +RetSqlName("ZAD") +" ZAD"+ CRLF
			cQuery2+= " WHERE ZAD_FILIAL='01' " + CRLF
			cQuery2+= " 	AND ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " + CRLF
			cQuery2+= " 	AND ZAD_ITEMID 	> ' ' " + CRLF
			cQuery2+= " 	AND ZAD_EPEP 	> ' ' " + CRLF
			cQuery2+= " 	AND ZAD_TKTID 	> ' ' " + CRLF
			cQuery2+= " 	AND ZAD_TPTRAN = '1' " + CRLF
			cQuery2+= " 	AND ZAD_MARK = '"+cMarca+ "' " + CRLF
			cQuery2	+= " 	AND ZAD_TPITEM IN ('2','3','4','6','7','8')	 " + CRLF
			cQuery2+= " 	AND ZAD_PEDIDO = ' ' " + CRLF

			If FWIsInCallStack('U_T4FPEDMAN') .Or. !IsBlind()

				cQuery2+= " 	AND ZAD_STATUS = '1' " + CRLF

				If !Empty(cSearch)
					cQuery2+= " AND ZAD_SEARCH = '"+cSearch+"' " + CRLF
				EndIf

				If !Empty(cIdVenda)
					cQuery2+= " AND ZAD_SLUID = '"+cIdVenda+"' " + CRLF
				EndIf
			Else
				cQuery2+= " 	AND ZAD_STATUS = '1'" + CRLF
			EndIf

			cQuery2+= "  		AND D_E_L_E_T_=' '" + CRLF
			cQuery2+= " GROUP BY ZAD_NOME,ZAD_CPF,ZAD_EVENTO,ZAD_DTEVEN, ZAD_ITEMID, " + CRLF
			cQuery2+= " 		 ZAD_TKTID, ZAD_DTVEND,ZAD_EMP, ZAD_IDVEND, ZAD_TPAGTO," + CRLF
			cQuery2+= " 		 ZAD_FILIAL,ZAD_NFINTI,ZAD_TPITEM,ZAD_ITTYPE,  " + CRLF
			cQuery2+= " 		 ZAD_EPEP,ZAD_SEARCH, ZAD_SLUID  " + CRLF
			cQuery2+= "  ORDER BY ZAD_CPF,ZAD_DTVEND,ZAD_SEARCH, ZAD_SLUID, ZAD_IDVEND,ZAD_TPITEM  " + CRLF

			TcQuery cQuery2 New Alias (cAliasZad:=GetNextAlias())
			dbSelectArea(cAliasZad)

			(cAliasZad)->( DbGotop() )

			If !Empty((cAliasZad)->ZAD_FILIAL)

				//cNumPed			:= GetSX8Num("SC5","C5_NUM")
				cA1Cpf    		:= (cAliasZad)->ZAD_CPF
				cLocalizador    := (cAliasZad)->ZAD_SEARCH
				cSluId    		:= (cAliasZad)->ZAD_SLUID

				cItem:='01'

				cTEMPZAF	:=	GetNextAlias()

				While (cAliasZad)->(!Eof())

					DDATABASE := STOD((cAliasZad)->ZAD_DTVEND)

					If !Empty((cAliasZad)->ZAD_SLUID) .And. (cAliasZad)->ZAD_TPITEM <> '1'

						If (cA1Cpf == (cAliasZad)->ZAD_CPF .And. cLocalizador == (cAliasZad)->ZAD_SEARCH .And. (cAliasZad)->ZAD_SLUID == cSluId)

							nPos:=AT( "/",(cAliasZad)->ZAD_EPEP)

							If nPos > 0
								cEpep:=substr((cAliasZad)->ZAD_EPEP,1,nPos-1)
							Else
								cEpep:=(cAliasZad)->ZAD_EPEP
							EndIf

							If ZAE->(MsSeek(cFilZAE + cEpep)) .AND. ZAE->ZAE_MSBLQL <> '1' //VERIFICAR POSICIONE

								If (((cAliasZad)->ZAD_VLRTKT > 0 .OR. (cAliasZad)->ZAD_VLRTXO > 0 .OR. (cAliasZad)->ZAD_VLRTXS > 0 .OR. (cAliasZad)->ZAD_VLRTXC > 0 .OR. (cAliasZad)->ZAD_VLRTXI > 0 .OR. (cAliasZad)->ZAD_VLRSOC > 0 .OR. (cAliasZad)->ZAD_VLENTR > 0);
										.AND. !Empty((cAliasZad)->ZAD_EPEP))

									//****************************************************************
									//* Inclusao - INÍCIO
									//****************************************************************
									SA1->(dbSetOrder(3))
									If Empty((cAliasZad)->ZAD_CPF)
										cA1Cod  :=  'SEMCPF'
										cA1Loja :=  '01'
										cTipo 	:=  'X'
										cEst 	:=  'SP'

									ElseIf SA1->(MsSeek(cFilSA1 + (cAliasZad)->ZAD_CPF)) //VERIFICAR POSICIONE
										cA1Cod  :=  SA1->A1_COD
										cA1Loja :=  SA1->A1_LOJA
										cBlqCli :=  SA1->A1_MSBLQL
										cTipo 	:=  SA1->A1_TIPO
										cEst 	:=  SA1->A1_EST
									Else
										cA1Cod  :=  'SEMCPF'
										cA1Loja :=  '01'
										cTipo 	:=  'X'
										cEst 	:=  'SP'
									EndIF

									nValTkt 	:= 	(cAliasZad)->ZAD_VLRTKT
									nValWallet	:=	0

									If Len(aCabec) == 0
										aadd(aCabec,' '				 )
										aadd(aCabec,"N"	   				 )
										aadd(aCabec,cA1Cod				 )
										aadd(aCabec,cA1Loja	 			 )
										aadd(aCabec,cA1Loja	 			 )
										aadd(aCabec,cE4Codigo			 )
										aadd(aCabec,"500302"			 )
										aadd(aCabec,(cAliasZad)->ZAD_TPAGTO)
										aadd(aCabec,DDATABASE			 )
										aadd(aCabec,(cAliasZad)->ZAD_SEARCH)
										aadd(aCabec,Alltrim((cAliasZad)->ZAD_SLUID))
										aadd(aCabec,cTipo)
										aadd(aCabec,cEst				 )	//12

										cItem:='01'
									EndIf

									//****************************************************************
									//- Informando os dados do item do Pedido de Venda
									//****************************************************************
									If (cAliasZad)->ZAD_VLRTXO > 0

										cB1Cod:=ZAE->ZAE_PRDTXO

										If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
											cF4TES := SB1->B1_TS
											cDescri	:= SB1->B1_DESC
											cUnMed	:= SB1->B1_UM
											cConta	:= SB1->B1_CONTA
										End If

										aLinha := {}
										aadd(aLinha,cItem)
										aadd(aLinha,cB1Cod)
										aadd(aLinha,(cAliasZad)->QTD)
										aadd(aLinha,(cAliasZad)->(ZAD_VLRTXO/QTD))
										aadd(aLinha,(cAliasZad)->(ZAD_VLRTXO/QTD))
										aadd(aLinha,(cAliasZad)->ZAD_VLRTXO)
										aadd(aLinha,cF4TES)
										aadd(aLinha,cEpep)
										aadd(aLinha,(cAliasZad)->ZAD_SEARCH)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID) +'-'+ Alltrim((cAliasZad)->ZAD_SEARCH))
										aadd(aLinha,(cAliasZad)->ZAD_TPITEM)
										aadd(aLinha,(cAliasZad)->ZAD_TKTID)

										cMensNota := "Ref.: Taxa de Operação evento: " + CRLF + Alltrim((cAliasZad)->ZAD_EVENTO) + CRLF +;
											"Dt Evento: " + DTOC(fwDateTimeToLocal(Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),1,11))[1]) + CRLF +;
											"Hr: "+ Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),12,05)

										aadd(aLinha,cMensNota)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID))

										aadd(aItens, aLinha)

									ElseIf (cAliasZad)->ZAD_VLRTXS > 0

										cB1Cod:=ZAE->ZAE_PRDTXS

										If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
											cF4TES := SB1->B1_TS
											cDescri	:= SB1->B1_DESC
											cUnMed	:= SB1->B1_UM
											cConta	:= SB1->B1_CONTA
										End If

										aLinha := {}
										aadd(aLinha,cItem)
										aadd(aLinha,cB1Cod)
										aadd(aLinha,(cAliasZad)->QTD)
										aadd(aLinha,(cAliasZad)->(ZAD_VLRTXS/QTD))
										aadd(aLinha,(cAliasZad)->(ZAD_VLRTXS/QTD))
										aadd(aLinha,(cAliasZad)->ZAD_VLRTXS)
										aadd(aLinha,cF4TES)
										aadd(aLinha,cEpep)
										aadd(aLinha,(cAliasZad)->ZAD_SEARCH)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID) +'-'+ Alltrim((cAliasZad)->ZAD_SEARCH))
										aadd(aLinha,(cAliasZad)->ZAD_TPITEM)
										aadd(aLinha,(cAliasZad)->ZAD_TKTID)

										cMensNota := "Ref.: Taxa de Serviço evento: " + CRLF + Alltrim((cAliasZad)->ZAD_EVENTO) + CRLF + ;
											"Dt Evento: " + DTOC(fwDateTimeToLocal(Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),1,11))[1]) + CRLF + ;
											"Hr: "+ Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),12,05)

										aadd(aLinha,cMensNota)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID))

										aadd(aItens, aLinha)

									ElseIf (cAliasZad)->ZAD_VLRTXC > 0

										cB1Cod:=ZAE->ZAE_PRDTXC

										If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
											cF4TES := SB1->B1_TS
											cDescri	:= SB1->B1_DESC
											cUnMed	:= SB1->B1_UM
											cConta	:= SB1->B1_CONTA
										End If

										aLinha := {}
										aadd(aLinha,cItem)
										aadd(aLinha,cB1Cod)
										aadd(aLinha,(cAliasZad)->QTD)
										aadd(aLinha,(cAliasZad)->(ZAD_VLRTXC/QTD))
										aadd(aLinha,(cAliasZad)->(ZAD_VLRTXC/QTD))
										aadd(aLinha,(cAliasZad)->ZAD_VLRTXC)
										aadd(aLinha,cF4TES)
										aadd(aLinha,cEpep)
										aadd(aLinha,(cAliasZad)->ZAD_SEARCH)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID) +'-'+ Alltrim((cAliasZad)->ZAD_SEARCH))
										aadd(aLinha,(cAliasZad)->ZAD_TPITEM)
										aadd(aLinha,(cAliasZad)->ZAD_TKTID)

										cMensNota := "Ref.: Taxa de Conveniencia evento: " + CRLF + Alltrim((cAliasZad)->ZAD_EVENTO) + CRLF + ;
											"Dt Evento: " + DTOC(fwDateTimeToLocal(Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),1,11))[1]) + CRLF + ;
											"Hr: "+ Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),12,05)

										aadd(aLinha,cMensNota)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID))

										aadd(aItens, aLinha)

									ElseIf (cAliasZad)->ZAD_VLRTXI > 0

										cB1Cod:=If(Empty(ZAE->ZAE_PRDTXI),ZAE->ZAE_PRDTKT,ZAE->ZAE_PRDTXI)

										If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
											cF4TES := SB1->B1_TS
											cDescri	:= SB1->B1_DESC
											cUnMed	:= SB1->B1_UM
											cConta	:= SB1->B1_CONTA
										End If

										aLinha := {}
										aadd(aLinha,cItem)
										aadd(aLinha,cB1Cod)
										aadd(aLinha,(cAliasZad)->QTD)
										aadd(aLinha,(cAliasZad)->(ZAD_VLRTXI/QTD))
										aadd(aLinha,(cAliasZad)->(ZAD_VLRTXI/QTD))
										aadd(aLinha,(cAliasZad)->ZAD_VLRTXI)
										aadd(aLinha,cF4TES)
										aadd(aLinha,cEpep)
										aadd(aLinha,(cAliasZad)->ZAD_SEARCH)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID) +'-'+ Alltrim((cAliasZad)->ZAD_SEARCH))
										aadd(aLinha,(cAliasZad)->ZAD_TPITEM)
										aadd(aLinha,(cAliasZad)->ZAD_TKTID)

										cMensNota := "Ref.: Taxa de Impressao evento: " + CRLF + Alltrim((cAliasZad)->ZAD_EVENTO) + CRLF + ;
											"Dt Evento: " + DTOC(fwDateTimeToLocal(Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),1,11))[1]) + CRLF + ;
											"Hr: "+ Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),12,05)

										aadd(aLinha,cMensNota)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID))

										aadd(aItens, aLinha)

									ELseIf (cAliasZad)->ZAD_VLRXCA > 0

										cB1Cod:=ZAE->ZAE_PDTXCA

										If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
											cF4TES := SB1->B1_TS
											cDescri	:= SB1->B1_DESC
											cUnMed	:= SB1->B1_UM
											cConta	:= SB1->B1_CONTA
										End If

										aLinha := {}
										aadd(aLinha,cItem)
										aadd(aLinha,cB1Cod)
										aadd(aLinha,(cAliasZad)->QTD)
										aadd(aLinha,(cAliasZad)->(ZAD_VLRXCA/QTD))
										aadd(aLinha,(cAliasZad)->(ZAD_VLRXCA/QTD))
										aadd(aLinha,(cAliasZad)->ZAD_VLRXCA)
										aadd(aLinha,cF4TES)
										aadd(aLinha,cEpep)
										aadd(aLinha,(cAliasZad)->ZAD_SEARCH)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID) +'-'+ Alltrim((cAliasZad)->ZAD_SEARCH))
										aadd(aLinha,(cAliasZad)->ZAD_TPITEM)
										aadd(aLinha,(cAliasZad)->ZAD_TKTID)

										cMensNota := "Ref.: Taxa Captacao evento: " + CRLF + Alltrim((cAliasZad)->ZAD_EVENTO) + CRLF + ;
											"Dt Evento: " + DTOC(fwDateTimeToLocal(Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),1,11))[1]) + CRLF + ;
											"Hr: "+ Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),12,05)

										aadd(aLinha,cMensNota)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID))

										aadd(aItens, aLinha)

									ELseIf (cAliasZad)->ZAD_VLRSOC > 0

										cB1Cod:=ZAE->ZAE_PRDSOC

										If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
											cF4TES := SB1->B1_TS
											cDescri	:= SB1->B1_DESC
											cUnMed	:= SB1->B1_UM
											cConta	:= SB1->B1_CONTA
										End If

										aLinha := {}
										aadd(aLinha,cItem)
										aadd(aLinha,cB1Cod)
										aadd(aLinha,(cAliasZad)->QTD)
										aadd(aLinha,(cAliasZad)->(ZAD_VLRSOC/QTD))
										aadd(aLinha,(cAliasZad)->(ZAD_VLRSOC/QTD))
										aadd(aLinha,(cAliasZad)->ZAD_VLRSOC)
										aadd(aLinha,cF4TES)
										aadd(aLinha,cEpep)
										aadd(aLinha,(cAliasZad)->ZAD_SEARCH)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID) +'-'+ Alltrim((cAliasZad)->ZAD_SEARCH))
										aadd(aLinha,(cAliasZad)->ZAD_TPITEM)
										aadd(aLinha,(cAliasZad)->ZAD_TKTID)

										cMensNota := "Ref.: Taxa Socios evento: " + CRLF + Alltrim((cAliasZad)->ZAD_EVENTO) + CRLF + ;
											"Dt Evento: " + DTOC(fwDateTimeToLocal(Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),1,11))[1]) + CRLF + ;
											"Hr: "+ Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),12,05)

										aadd(aLinha,cMensNota)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID))

										aadd(aItens, aLinha)
									ELseIf (cAliasZad)->ZAD_VLENTR > 0

										cB1Cod:=ZAE->ZAE_PRDENT

										If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
											cF4TES := SB1->B1_TS
											cDescri	:= SB1->B1_DESC
											cUnMed	:= SB1->B1_UM
											cConta	:= SB1->B1_CONTA
										End If

										aLinha := {}
										aadd(aLinha,cItem)
										aadd(aLinha,cB1Cod)
										aadd(aLinha,(cAliasZad)->QTD)
										aadd(aLinha,(cAliasZad)->(ZAD_VLENTR/QTD))
										aadd(aLinha,(cAliasZad)->(ZAD_VLENTR/QTD))
										aadd(aLinha,(cAliasZad)->ZAD_VLENTR)
										aadd(aLinha,cF4TES)
										aadd(aLinha,cEpep)
										aadd(aLinha,(cAliasZad)->ZAD_SEARCH)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID) +'-'+ Alltrim((cAliasZad)->ZAD_SEARCH))
										aadd(aLinha,(cAliasZad)->ZAD_TPITEM)
										aadd(aLinha,(cAliasZad)->ZAD_TKTID)

										cMensNota := "Ref.: Taxa de Entrega evento: " + CRLF + Alltrim((cAliasZad)->ZAD_EVENTO) + CRLF + ;
											"Dt Evento: " + DTOC(fwDateTimeToLocal(Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),1,11))[1]) + CRLF + ;
											"Hr: "+ Substr(Alltrim((cAliasZad)->ZAD_DTEVEN),12,05)

										aadd(aLinha,cMensNota)
										aadd(aLinha, Alltrim((cAliasZad)->ZAD_SLUID))

										aadd(aItens, aLinha)


									EndIf

									cItem 	:= Soma1(cItem)

								Else
									cMsgLog	+=  REPLICATE("*", 5)+ CRLF
									cMsgLog +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - Item sem valor " + Alltrim((cAliasZad)->ZAD_NOME)

								End If
							Else
								cMsgLog	+=  REPLICATE("*", 5)+ CRLF
								cMsgLog +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - EPEP não cadastrado na tabela ZAE " + Alltrim((cAliasZad)->ZAD_NOME)
							EndIf

							cLocalizador:= 	(cAliasZad)->ZAD_SEARCH
							cSluId		:=	(cAliasZad)->ZAD_SLUID
							cA1Cpf		:=	(cAliasZad)->ZAD_CPF

						Else

							If Len(aItens) > 0
								nOpcX := 3

								aItensNf:=	aItens

								lRet	:=	T4FGRVPED(aCabec,aItens,oSay,oGridPv,dbkpDataBase,{})

								If lRet

									If FWIsInCallStack('U_T4FPEDMAN')
										cMsg := "ENVIANDO PEDIDO PARA FATURAMENTO: "+aCabec[1]
										oGridPv:SetIncMeter(1,cMsg)
									EndIf

									U_T4F01NF(aCabec[9],aCabec[1],oSay,oGridPv,aDadosZAD,aItensNf)

									aItens	:=	{}
									aCabec	:=	{}
									aDadosZAD:={}

								Else

									cArqLog := SubStr( Time(),1,5 ) + ".log"

									cMsgLog   += MostraErro("\log_INTI", cArqLog)
									cMsgLog   += REPLICATE("*", 5)+ CRLF

								EndIf

							EndIf

							cItem 			:= '01'
							cLocalizador:= 	(cAliasZad)->ZAD_SEARCH
							cSluId		:=	(cAliasZad)->ZAD_SLUID
							cA1Cpf		:=	(cAliasZad)->ZAD_CPF
							aItens			:= {}
							aCabec 			:= {}

							Loop

						End If
					EndIf

					(cAliasZad)->(dbSkip())

				EndDo

				If Len(aItens) > 0
					nOpcX := 3

					aItensNf:=	aItens

					lRet	:=	T4FGRVPED(aCabec,aItens,oSay,oGridPv,dbkpDataBase,{})

					If lRet

						If FWIsInCallStack('U_T4FPEDMAN')
							cMsg := "ENVIANDO PEDIDO PARA FATURAMENTO: "+aCabec[1]
							oGridPv:SetIncMeter(1,cMsg)
						EndIf

						U_T4F01NF(aCabec[9],aCabec[1],oSay,oGridPv,aDadosZAD,aItensNf)

						//cNumPed:= GetSX8Num("SC5","C5_NUM")
						aDadosZAD:={}

					Else

						cArqLog := SubStr( Time(),1,5 ) + ".log"

						cMsgLog   += MostraErro("\log_INTI", cArqLog)
						cMsgLog   += REPLICATE("*", 5)+ CRLF

					EndIf

					aItens	:=	{}
					aCabec	:=	{}


					//****************************************************************
					//* Inclusao - FIM
					//****************************************************************
				Else
					cMsgLog:=  REPLICATE("*", 5)+ CRLF
					cMsgLog+=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+"-"
					cMsgLog+= ' **Query COM CPF** - A consulta não retornou dados habilitados para processar, verifique tabela ZAD, status = 1 - Empresa ' + cEmp
					u_T4F01LOG(cMsgLog)

				EndIf

				If Select(cTEMPZAF) > 0
					(cTEMPZAF)->( DbCloseArea() )
				EndIf

			Else
				cMsg :=  Alltrim(Time())+" - Não há dados para processar T4F01PED_TAXAS cTEMPZAF " + cEmp
				u_T4F01LOG(cMsg)
			EndIf
			//Reprocessa pedidos que não foram faturados
			cQuery3:= " SELECT ZAD_SEARCH, ZAD_PEDIDO,ZAD_DTVEND " + CRLF
			cQuery3+= " FROM " +RetSqlName("ZAD") + CRLF
			cQuery3+= " WHERE ZAD_DTVEND BETWEEN '" + cDataIni +"' AND " + "'"+cDataFim +"'" + CRLF
			cQuery3+= " 	AND ZAD_ITEMID 	> ' ' " + CRLF
			cQuery3+= " 	AND ZAD_EPEP 	> ' ' " + CRLF
			cQuery3+= " 	AND ZAD_TKTID 	> ' ' " + CRLF
			cQuery3+= " 	AND ZAD_CPF 	> ' ' " + CRLF
			cQuery3+= " 	AND ZAD_STATUS = '2'  "	+ CRLF

			If !Empty(cSearch)
				cQuery3+= " AND ZAD_SEARCH = '"+cSearch+"' " + CRLF
			EndIf

			If !Empty(cIdVenda)
				cQuery3+= " AND ZAD_IDVEND = '"+cIdVenda+"' " + CRLF
			EndIf

			//cQuery3+= "		AND ZAD_EPEP IN ('020100015','020100013') "+ CRLF // VOLTAR COMENTADO

			cQuery3+= "  GROUP BY ZAD_SEARCH, ZAD_PEDIDO,ZAD_DTVEND " + CRLF

			TcQuery cQuery3 New Alias (cAliasZad2:=GetNextAlias())
			dbSelectArea(cAliasZad2)

			(cAliasZad2)->(DbGotop())

			lFatura:=.F.

			While !(cAliasZad2)->(Eof()) .And. !Empty((cAliasZad2)->ZAD_PEDIDO)

				If SC6->(MsSeek(xFilial("SC6") + (cAliasZad2)->ZAD_PEDIDO)) .And. SC5->(MsSeek(xFilial("SC5") + (cAliasZad2)->ZAD_PEDIDO))

					While SC6->(!EOF()) .And. SC6->C6_NUM == (cAliasZad2)->ZAD_PEDIDO
						If FWIsInCallStack('U_T4FPEDMAN')
							cMsg := "LIBERANDO PEDIDO PARA FATURAMENTO PEDIDO : "+(cAliasZad2)->ZAD_PEDIDO + " ITEM: "+ SC6->C6_ITEM
							oGridPv:SetIncMeter(1,cMsg)
						EndIf

						If !(SC9->(MsSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)))
							MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,,,.T.,.T.,.F.,.F.)
						EndIf

						SC6->(dBSkip())

					EndDo
					If FWIsInCallStack('U_T4FPEDMAN')
						cMsg := "ENVIANDO PEDIDO PARA FATURAMENTO: "+(cAliasZad2)->ZAD_PEDIDO
						oGridPv:SetIncMeter(1,cMsg)
					EndIf

					U_T4F01NF(STOD((cAliasZad2)->ZAD_DTVEND),(cAliasZad2)->ZAD_PEDIDO,oSay,oGridPv,aDadosZAD,{})
					aDadosZAD:={}
					lFatura:=.T.

				EndIf

				(cAliasZad2)->(DbSkip())
			EndDo

			If Select(cAliasZad2) > 0
				(cAliasZad2)->( DbCloseArea() )
			EndIf

			/*
			// VERIFICAÇÃO SE EXISTE REGISTRO PARA PROCESSAR
			If !(FWIsInCallStack('U_T4FPEDMAN')) .Or. IsBlind()

				cQry:= "  " + CRLF
				cQry+= "   SELECT COUNT(*) QTD FROM  " + CRLF
				cQry+= "   (SELECT ZAD_FILIAL FROM "+RetSqlName("ZAD") + CRLF
				cQry+= "    WHERE ZAD_FILIAL='01' " + CRLF
				cQry+= "    AND ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"'" + CRLF
				cQry+= "    AND ZAD_ITEMID 	> ' ' " + CRLF
				cQry+= "    AND ZAD_EPEP 	> ' ' " + CRLF
				cQry+= "    AND ZAD_TKTID 	> ' ' " + CRLF
				cQry+= "    AND ZAD_TPTRAN = '1' " + CRLF
				cQry+= "    AND ZAD_TPITEM IN ('1','2','3','4','6','7','8') " + CRLF
				cQry+= "    AND ZAD_STATUS NOT IN ('3','4') " + CRLF
				cQry+= "    AND ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"'" + CRLF
				cQry+= "    AND ZAD_SLUID IN " 						+ CRLF
				cQry+= "     (SELECT ZAF_SLUID	" 					+ CRLF
				cQry+= "    	FROM "+RetSqlName("ZAF") + " ZAF " 	+ CRLF
				cQry+= "     	WHERE ZAF_FILIAL 	= '01' " 		+ CRLF
				cQry+= "      	AND ZAF_NUMERO 		> ' ' " 		+ CRLF
				cQry+= "	  	AND ZAF_SLUID 		> ' ' " 		+ CRLF
				cQry+= "     	AND ZAF_TIPO 		= 'Venda' " 	+ CRLF
				cQry+= "        AND ZAF_EPEP 		> ' ' " 		+ CRLF

				If cEmpAnt == '33'
					cQry+= "    AND ZAF_TPRECB 	= 'Indireto' "		+ CRLF
					cQry+= "    AND ZAF_TPPGTO <> 'Bonificado          '" + CRLF
					cQry+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    		" + CRLF
				EndIf

				cQry+= "     	AND ZAF_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"'" + CRLF
				cQry+= "     	AND ZAF.D_E_L_E_T_ = ' '	" + CRLF
				cQry+= "     	GROUP BY ZAF_SLUID)			" + CRLF
				cQry+= "    	AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 ) " + CRLF
				cQry+= "    	AND D_E_L_E_T_ = ' ')" + CRLF

				TcQuery cQry New Alias (cAliasT:=GetNextAlias())
				dbSelectArea(cAliasT)

				(cAliasT)->(DbGotop())

				If (cAliasT)->QTD <= 10
					PutMV("MV_DTFIXA", 'N')
				EndIf

				If GetMV("MV_DTFIXA") == 'N' .And. FWIsInCallStack('U_T4FPEDAUT')

					If Stod(GetMV("MV_DTPED")) > dbkpDataBase
						PutMV("MV_DTPED", Dtos(FirstDate(dbkpDataBase-1)))
					Else
						PutMV("MV_DTPED", dtos(stod(GetMV("MV_DTPED"))+1))
					EndIf

				EndIf

				If Select(cAliasT) > 0
					(cAliasT)->( DbCloseArea() )
				EndIf

			End If
		*/

			If Select(cAliasZad) > 0
				(cAliasZad)->( DbCloseArea() )
			EndIf
			UnLockByName("T4F01PED_TAXAS"+cDataIni,.T.,.F.)

			cMsg :=  Alltrim(Time())+" - Fim do Processo T4F01PED_TAXAS "
			u_T4F01LOG(cMsg)

		Else
			cMsg :=  Alltrim(Time())+" - A rotina já esta em execução-T4F01PED_TAXAS "
			//ConOut("A rotina já esta em execução-T4F01PED_TAXAS-"+Time())
			u_T4F01LOG(cMsg)
		EndIf

	EndIf

	If nQtd <= 60
		PutMV("MV_DTFIXA", 'N')
	Else
		PutMV("MV_DTFIXA", 'S')
	Endif

	If GetMV("MV_DTFIXA") == 'N' .And. FWIsInCallStack('U_T4FPEDAUT')

		If Stod(GetMV("MV_DTPED")) > dbkpDataBase
			PutMV("MV_DTPED", Dtos(FirstDate(dbkpDataBase-1)))
		Else
			PutMV("MV_DTPED", dtos(stod(GetMV("MV_DTPED"))+1))
		EndIf

	EndIf

	cDtIni := Dtos(FirstDate(Stod(cDataIni)))
	cDtFim := Dtos(LastDate(Stod(cDataIni)))

	U_T4FQTDINTEGRADA(cDtIni,cDtFim)

	Lj7RestArea(aArea)

Return

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4F01LOG                            Modulo : SIGAFAT      //
//                                                                          //
//  Função que grava arquivo de log caso ocorra erro na integração			//
//                                                                          //
//	@type.......:	Function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	28/09/2020												//	
//                                                                          //
//	@param......:	cErro 													//
//																			//
/*////////////////////////////////////////////////////////////////////////////
/*/{Protheus.doc} T4F01LOG
@description Função que grava arquivo de log caso ocorra erro na integração 
@type Static function
@version 1.00
@author Rogério Costa
@since 28/09/2020
@return Nil, Nil
/*/

User Function T4F01LOG(cErro)

	Local cLogFile 	:= "log_INTI\"+cEmpAnt+'_'+DTOS(DDATABASE)+".LOG"
	Local cLogAnt 	:= "log_INTI\"+cEmpAnt+'_'+DTOS(DDATABASE-7)+".LOG"
	Local lRet		:=.T.

	//Exclui log de uma semana
	If File(cLogAnt)
		FERASE(cLogAnt)
	End If

	//efetua o tratamento para validar se o arquivo de log já existe
	If !File(cLogFile)
		If (nHandle := MSFCreate(cLogFile,0)) <> -1
			lRet := .T.
		EndIf
	Else
		If (nHandle := FOpen(cLogFile,2)) <> -1
			FSeek(nHandle,0,2)
			lRet := .T.
		EndIf
	EndIf

	//****************************************************************
	//grava as informações de log no arquivo especificado
	//****************************************************************
	If lRet
		FWrite(nHandle,cErro+CHR(13)+CHR(10))
	EndIf

	FClose(nHandle)

Return

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4FGRVPED                            Modulo : SIGAFAT     //
//                                                                          //
//  Realiza a gravação do pedido de venda, é usado RecLock para ser mais 	//
//	rápido que execauto														//
//                                                                          //
//	@type.......:	Function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	28/09/2020												//	
//                                                                          //
//	@param......:	aCabec,aItens,oSay 										//
//																			//
/*////////////////////////////////////////////////////////////////////////////
/*/{Protheus.doc} T4FGRVPED
@description Realiza a gravação do pedido de venda, é usado RecLock para ser mais rápido que execauto
@type Static function
@version 1.00
@author Rogério Costa
@since 28/09/2020
@return Nil, Nil
/*/

Static Function T4FGRVPED(aCabec,aItens,oSay,oGrid,dbkpDataBase,aDadosZAD)

	Local lRet		:=	.F.
	Local n
	Local nx
	Local cQryNum

	If Len(aItens) == 0
		Return lRet
	EndIf

	cQryNum	:= "	SELECT MAX(C5_NUM) NUM "
	cQryNum	+= "	FROM " + RetSqlName("SC5")	"
	cQryNum	+= "		WHERE C5_FILIAL ='"+xFilial("SC5") + "'"

	TcQuery cQryNum New Alias (AliasNumPed:=GetNextAlias())
	dbSelectArea(AliasNumPed)

	aCabec[1] 	:= Soma1((AliasNumPed)->NUM)

	(AliasNumPed)->(dbCloseArea())

	cQryNum	:= "	SELECT MAX(R_E_C_N_O_) RECNO "
	cQryNum	+= "	FROM " + RetSqlName("SC5")	"

	TcQuery cQryNum New Alias (AliasNumRec:=GetNextAlias())
	dbSelectArea(AliasNumRec)

	nRecno 	:= (AliasNumRec)->RECNO + 1

	(AliasNumRec)->(dbCloseArea())

	BEGIN TRANSACTION

		cInsert := "INSERT INTO " + RetSqlName("SC5") "
		cInsert +="(C5_FILIAL,"
		cInsert +="C5_NUM,"
		cInsert +="C5_EMISSAO,"
		cInsert +="C5_TIPO,"
		cInsert +="C5_CLIENTE,"
		cInsert +="C5_LOJACLI,"
		cInsert +="C5_CLIENT,"
		cInsert +="C5_LOJAENT,"
		cInsert +="C5_TIPOCLI,"
		cInsert +="C5_CONDPAG,"
		cInsert +="C5_PAGTO,"
		cInsert +="C5_NATUREZ,"
		cInsert +="C5_MENNOTA,"
		cInsert +="C5_TIPLIB,"
		cInsert +="C5_TPCARGA,"
		cInsert +="C5_GERAWMS,"
		cInsert +="C5_SOLOPC,"
		cInsert +="C5_TPCOMPL,"
		cInsert +="C5_LIBEROK,"
		cInsert +="R_E_C_N_O_)"
		cInsert += " VALUES
		cInsert +="('"+xFilial("SC5")+"','"
		cInsert += aCabec[1]+"','"
		cInsert +=DTOS(aCabec[09])+"','"
		cInsert +=aCabec[2]+"','"
		cInsert +=aCabec[3]+"','"
		cInsert +=aCabec[4]+"','"
		cInsert +=aCabec[3]+"','"
		cInsert +=aCabec[4]+"','"
		cInsert +=aCabec[12]+"','"
		cInsert +=aCabec[6]+"','"
		cInsert +="BYINTI"+"','"
		cInsert += "500302"+"','"
		cInsert += " " +"','"
		cInsert +="2"+"','"
		cInsert +="2"+"','"
		cInsert +="1"+"','"
		cInsert +="1"+"','"
		cInsert +="1"+"','"
		cInsert +="S"+"',"
		cInsert += STR(nRecno) + ")"

		nResult := TcSqlExec(cInsert)

		If (nResult < 0)

			cErro :=  REPLICATE("*", 5)+ CRLF
			cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()

			u_T4F01LOG(cErro)

			lRet:= .F.
			DisarmTransaction()

		Else
			lRet:= .T.

			For n:=1 To len(aItens)

				cQryNRec := "	SELECT MAX(R_E_C_N_O_) RECNO "
				cQryNRec += "	FROM " + RetSqlName("SC6")	"

				TcQuery cQryNRec New Alias (AliasRecC6:=GetNextAlias())

				nRecnoC6 	:= (AliasRecC6)->RECNO + 1

				(AliasRecC6)->(dbCloseArea())

				SF4->(MsSeek(xFilial("SF4") + aItens[n][7]))
				cCfop		:= SF4->F4_CF
				cSitTrib	:= SF4->F4_SITTRIB

				SB1->(MsSeek(xFilial("SB1") + aItens[n][2]))

				cClasFis 	:= SB1->B1_ORIGEM + cSitTrib
				cCodIss		:= SB1->B1_CODISS
				cRetOper	:= SB1->B1_RETOPER
				cDesc		:= SB1->B1_DESC
				cUnM		:= SB1->B1_UM
				cSegUm		:= SB1->B1_SEGUM
				cConta		:= SB1->B1_CONTA

				/*
				cClasFis 	:= Posicione("SB1",1,xFilial("SB1")+aItens[n][2],"B1_ORIGEM") + cSitTrib
				cCodIss		:= Posicione("SB1",1,xFilial("SB1")+aItens[n][2],"B1_CODISS")
				cRetOper	:= Posicione("SB1",1,xFilial("SB1")+aItens[n][2],"B1_RETOPER")
				cDesc		:= Posicione("SB1",1,xFilial("SB1")+aItens[n][2],"B1_DESC")
				cUnM		:= Posicione("SB1",1,xFilial("SB1")+aItens[n][2],"B1_UM")
				cSegUm		:= Posicione("SB1",1,xFilial("SB1")+aItens[n][2],"B1_SEGUM")
				cConta		:= Posicione("SB1",1,xFilial("SB1")+aItens[n][2],"B1_CONTA")
				*/

				cCf			:= IIf(aCabec[13] == 'SP','5','6')	+	SUBSTR(cCfop,2,3)

				cInsertC6 := "INSERT INTO " + RetSqlName("SC6") + "(
				cInsertC6 += "C6_FILIAL,"
				cInsertC6 += "C6_ITEM,"
				cInsertC6 += "C6_PRODUTO,"
				cInsertC6 += "C6_DESCRI,"
				cInsertC6 += "C6_UM,"
				cInsertC6 += "C6_QTDVEN,"
				cInsertC6 += "C6_PRCVEN,"
				cInsertC6 += "C6_VALOR,"
				cInsertC6 += "C6_SEGUM,"
				cInsertC6 += "C6_TES,"
				cInsertC6 += "C6_CONTA,"
				cInsertC6 += "C6_ITEMCC,"
				cInsertC6 += "C6_PREOPER,"
				cInsertC6 += "C6_ENTREG,"
				cInsertC6 += "C6_LOCAL,"
				cInsertC6 += "C6_CF,"
				cInsertC6 += "C6_CLI,"
				cInsertC6 += "C6_LOJA,"
				cInsertC6 += "C6_PRUNIT,"
				cInsertC6 += "C6_NUM,"
				cInsertC6 += "C6_CLASFIS,"
				cInsertC6 += "C6_CODISS,"
				cInsertC6 += "C6_TPOP,"
				cInsertC6 += "C6_SUGENTR,"
				cInsertC6 += "C6_DTFIMNT,"
				cInsertC6 += "C6_RATEIO,"
				cInsertC6 += "C6_TPPROD,"
				cInsertC6 += "C6_DATCPL,"
				cInsertC6 += "C6_INTROT,"
				cInsertC6 += "C6_COMPLE1,"
				cInsertC6 += "C6_PEDCLI,"
				cInsertC6 += "C6_CHASSI,"
				cInsertC6 += "C6_MOPC,"
				cInsertC6 += "R_E_C_N_O_"
				cInsertC6 += " )"

				cInsertC6 +=  " VALUES ('"

				cInsertC6 += xFilial("SC6") +"','"
				cInsertC6 += aItens[n][1] +"','"
				cInsertC6 += Alltrim(aItens[n][2]) +"','"
				cInsertC6 += Alltrim(cDesc) +"','"
				cInsertC6 += cUnM +"',"
				cInsertC6 += ALLTRIM(STR(aItens[n][3])) +","
				cInsertC6 += ALLTRIM(STR(aItens[n][4])) +","
				cInsertC6 += ALLTRIM(STR(aItens[n][6])) +",'"
				cInsertC6 += cSegUm +"','"
				cInsertC6 += aItens[n][7] +"','"
				cInsertC6 += cConta +"','"
				cInsertC6 += aItens[n][8] +"','"
				cInsertC6 += "R" +"','"
				cInsertC6 += DTOS(aCabec[09]) +"','"
				cInsertC6 += "01" +"','"
				cInsertC6 += cCf +"','"
				cInsertC6 += aCabec[3] +"','"
				cInsertC6 += aCabec[4] +"',"
				cInsertC6 += ALLTRIM(STR(aItens[n][5])) +",'"
				cInsertC6 += aCabec[1] +"','"
				cInsertC6 += Alltrim(cClasFis) +"','"
				cInsertC6 += cCodIss +"','"
				cInsertC6 += "F" +"','"
				cInsertC6 += DTOS(aCabec[09]) +"','"
				cInsertC6 += DTOS(aCabec[09]) +"','"
				cInsertC6 += "2" +"','"
				cInsertC6 += "1" +"','"
				cInsertC6 += DTOS(aCabec[09]) +"','"
				cInsertC6 += "1" +"','"
				cInsertC6 += aItens[n][10] +"','"
				cInsertC6 += aItens[n][11] +"','"
				cInsertC6 += Alltrim(aItens[n][12]) +"',"
				cInsertC6 += "utl_raw.cast_to_raw('"+Alltrim(Strtran(FwNoAccent(aItens[n][13]),"'",''))+"'),"
				cInsertC6 += ALLTRIM(STR(nRecnoC6))
				cInsertC6 += ")"

				nResult := TCSqlExec(cInsertC6)

				If (nResult < 0)
					cErro :=  REPLICATE("*", 5)+ CRLF
					cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
					u_T4F01LOG(cErro)
					DisarmTransaction()
					lRet	:= .F.
				Else
					//Grava SC9
					RecLock("SC9",.T.)
					SC9->C9_FILIAL := xFilial("SC9")
					SC9->C9_PEDIDO := aCabec[1]
					SC9->C9_ITEM    := aItens[n][1]
					SC9->C9_SEQUEN  := '01'
					SC9->C9_PRODUTO := aItens[n][2]
					SC9->C9_CLIENTE := aCabec[3]
					SC9->C9_LOJA    := aCabec[4]
					SC9->C9_PRCVEN  := aItens[n][4]
					SC9->C9_DATALIB := aCabec[09]
					SC9->C9_QTDLIB  := aItens[n][3]
					SC9->C9_BLCRED  := ''
					SC9->C9_BLEST   := ''
					SC9->C9_BLWMS   := ''
					SC9->C9_LOCAL  := '01'
					SC9->C9_DATENT := aCabec[09]
					SC9->C9_TPOP := '1'
					SC9->C9_CODISS := cCodIss

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³O campo C9_RETOPER é considerado na quebra de Nota Fiscal.(BRASIL)      |
					//³Alguns Clientes que migraram da versao 8 para 10 estao tendo problemas  |
					//³com esta quebra pois na versao 8 esse campo nao possuia um inicializador|
					//³padrao e muitos produtos estao com esse campo em branco.                |
					//³Os campos em branco "" devem ser considerados como "2"=Nao. Assim qdo   |
					//|houver dois produtos ou mais onde alguns estao com os campos em branco e|
					//|e outros com "2" todos devem sair na mesma Nota Fiscal                  |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cPaisLoc == "BRA"
						If !Empty(SB1->B1_RETOPER)
							SC9->C9_RETOPER := cRetOper
						Else
							SC9->C9_RETOPER := "2"
						Endif
					EndIf
					SC9->(MsUnlock())

					//ATUALIZA STATUS ZAD
					If FWIsInCallStack('U_T4FPEDMAN')
						cMsg := "ATUALIZANDO STATUS ZAD PEDIDO : "+aCabec[1] + " ITEM: "+ aItens[n][1]
						oGrid:SetIncMeter(1,cMsg)
					EndIf

					If Len(aDadosZAD) == 0

						cTmp	:=	"cTmp"
						cQuery4	:=	""

						cQuery4	:= " UPDATE " +RetSqlName("ZAD") + CRLF
						cQuery4	+= " SET ZAD_PEDIDO = '" + aCabec[1] +"'" + CRLF
						cQuery4	+= ",ZAD_DTPV  = '"+ DtoS(dbkpDataBase) +"'" + CRLF
						cQuery4	+= ",ZAD_HREMIS  = '"+ TIME() +"'" + CRLF
						cQuery4	+= ",ZAD_STATUS   = '2' " + CRLF
						cQuery4	+= " WHERE ZAD_FILIAL='01' " + CRLF
						cQuery4	+= " AND ZAD_DTVEND = '"+DTOS(aCabec[09]) +"'" + CRLF
						cQuery4	+= " AND ZAD_ITEMID > ' '" + CRLF
						cQuery4	+= " AND ZAD_EPEP = '"+aItens[n][8]+"'" + CRLF
						cQuery4	+= " AND ZAD_SLUID = '"+aItens[n][14]+"'" + CRLF
						cQuery4	+= " AND ZAD_TKTID = '"+aItens[n][12]+"'" + CRLF

						If Len(alltrim(aItens[n][9])) > 3
							cQuery4	+= " AND ZAD_SEARCH = '"+aItens[n][09]+"'" + CRLF
						EndIf

						cQuery4	+= " AND ZAD_TPITEM = '"+aItens[n][11]+"'" + CRLF


						If FWIsInCallStack('U_T4FPEDMAN')
							cQuery4	+= " AND ZAD_PEDIDO = ' '" + CRLF
							cQuery4	+= " AND ZAD_STATUS = '1' " + CRLF
						Else
							cQuery4	+= " AND ZAD_STATUS = '1' " + CRLF
						EndIf

						cQuery4	+= " AND ZAD_TPTRAN = '1' " + CRLF

						nStatus := TcSqlExec(cQuery4)

						If (nStatus < 0)

							cErro :=  REPLICATE("*", 5)+ CRLF
							cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
							u_T4F01LOG(cErro)

						EndIf

					EndIf
				EndIf
			Next nx

		EndIf

		If Len(aDadosZAD) > 0 .And. lRet
			For nx:=1 To len(aDadosZAD)

				cTmp	:=	"cTmp"
				cQuery4	:=	""

				cQuery4	:= " UPDATE " +RetSqlName("ZAD") + CRLF
				cQuery4	+= " SET ZAD_PEDIDO = '" + aCabec[1] +"'" + CRLF
				cQuery4	+= ",ZAD_DTPV  = '"+ DtoS(dbkpDataBase) +"'" + CRLF
				cQuery4	+= ",ZAD_HREMIS  = '"+ TIME() +"'" + CRLF
				cQuery4	+= ",ZAD_STATUS   = '2' " + CRLF
				cQuery4	+= " WHERE ZAD_FILIAL='01' " + CRLF
				cQuery4	+= " AND ZAD_EPEP = '"+aDadosZAD[nx][1]+"'" + CRLF
				cQuery4	+= " AND ZAD_SLUID = '"+aDadosZAD[nx][3]+"'" + CRLF

				If Len(alltrim(aDadosZAD[nx][2])) > 3
					cQuery4	+= " AND ZAD_SEARCH = '"+aDadosZAD[nx][2]+"'" + CRLF
				EndIf

				cQuery4	+= " AND ZAD_TPITEM = '"+aDadosZAD[nx][4]+"'" + CRLF
				cQuery4	+= " AND ZAD_TKTID = '"+aDadosZAD[nx][5]+"'" + CRLF

				If FWIsInCallStack('U_T4FPEDMAN')
					cQuery4	+= " AND ZAD_PEDIDO = ' '" + CRLF
					cQuery4	+= " AND ZAD_STATUS = '1' " + CRLF
				Else
					cQuery4	+= " AND ZAD_STATUS = '1' " + CRLF
				EndIf

				cQuery4	+= " AND ZAD_TPTRAN = '1' " + CRLF

				nStatus := TcSqlExec(cQuery4)

				If (nStatus < 0)

					cErro :=  REPLICATE("*", 5)+ CRLF
					cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
					u_T4F01LOG(cErro)

				EndIf
			Next nx
		EndIf

	END TRANSACTION

	If lRet
		SC5->(ConfirmSX8())
		aItens:={}
		lExec		:= .F.
	Else
		RollBackSX8()
	EndIf

Return lRet

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4FPEDMAN                            Modulo : SIGAFAT     //
//                                                                          //
//  Processamento das vendas via menu									 	//
//                                                                          //
//	@type.......:	Function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	15/10/2021												//	
//                                                                          //
//	@param......:	aParamEmp, array, dados da empresa e filial 			//
//	para processamento 														//
//																			//
/*////////////////////////////////////////////////////////////////////////////
/*/{Protheus.doc} T4FPEDMAN 
Processamento das vendas via menu
@type function
@version 1.00
@author Rogério Costa - CRM SERVICES
@since 15/10/2021
@param aParamEmp, array, dados da empresa e filial para processamento
/*/
User Function T4FPEDMAN()

	Local oSay := NIL
	Local cSearch
	Local lRetMsg:=.T.
	Local oGridpV := Nil

	Private aParamBox	:= {}
	Private aRet		:= {}
	Private cMarca		:= Getmark()

	cEmp	:= cEmpant
	cFil	:= cFilant

	aAdd(aParamBox,{1,"Data Inicial Venda"	,DDATABASE           ,"","","   ","",80,.F.})  //01
	aAdd(aParamBox,{1,"Data Final Venda"	,DDATABASE           ,"","","   ","",80,.F.})  //01
	aAdd(aParamBox,{1,"Localizador"			,SPAC(TamSX3("ZAD_SEARCH")[1]),"","","   ","",80,.F.})  //01
	aAdd(aParamBox,{1,"Id.Venda"			,SPAC(TamSX3("ZAD_SLUID")[1]),"","","   ","",80,.F.})  //01

	If !ParamBox(aParamBox, "Processamento Manual Vendas", aRet)
		Return Nil
	Else
		cDataIni:= DTOS(aRet[1])
		cDataFim:= DTOS(aRet[2])
		cSearch	:= aRet[3]
		cIDVenda:= aRet[4]
	End If

	If (Val(cDataFim) - Val(cDataIni)) > 1

		msg := "ATENCAO!"+CHR(13)+CHR(10)
		msg +=  CHR(13)+CHR(10)
		msg += "O periodo escolhido pode apresentar uma quantidade grande de registros para processar."
		msg +=  CHR(13)+CHR(10)
		msg +=  "Deseja continuar?"

		lRetMsg := FWAlertYesNo(msg,"Reprocessamento de Vendas") //MsgYesNo(msg, "Reprocessamento de Vendas")
	Else
		lRetMsg	:=.T.
	EndIf

	If lRetMsg

		oGridpV:=FWGridProcess():New("U_T4F01PED",  "Processamento de Vendas ", "Rotina para processar as vendas da plataforma INTI.", {|lEnd| U_T4F01PED({cDataIni,cDataFim,cMarca,cEmp,cFil,cSearch,cIdVenda},oSay,cEmp,cFil,oGridPv),CursorWait()},"","")

		oGridpV:SetMeters(1)

		oGridpV:Activate()

		If oGridpV:IsFinished()

			FWAlertSuccess("Processo finalizado..")

		Else
			FWAlertError("Fim com erro.")
		EndIf

		//FwMsgRun(NIL,{ |oSay| U_T4F01PED({cDataIni,cDataFim,cMarca,cEmp,cFil,cSearch,cIdVenda},oSay) }, "PROCESSAMENTO VENDAS INTI Data: "+DTOC(STOD(cDataIni))+" até "+DTOC(STOD(cDataFim)), 'SELECIONANDO REGISTROS, AGUARDE.......')
	EndIf

Return

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4FPEDAUT                            Modulo : SIGAFAT     //
//                                                                          //
//  Processamento das vendas automatico									 	//
//                                                                          //
//	@type.......:	Function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	15/10/2021												//	
//                                                                          //
//	@param......:	aParamEmp, array, dados da empresa e filial 			//
//	para processamento 														//
//																			//
/*////////////////////////////////////////////////////////////////////////////
/*/{Protheus.doc} T4FPEDAUT 
** Processamento das vendas automatico**
@type function
@version 1.00
@author Rogério Costa - CRM SERVICES
@since 15/10/2021
@param aParamEmp, array, dados da empresa e filial para processamento
/*/
User Function T4FPEDAUT(aParamEmp,oSay,cEmp,cFil,cdataini)

	U_T4F01PED(aParamEmp,oSay,cEmp,cFil,'',cdataini)

	//StartJob('U_T4F01PED', "ROGERIO", .F., {aParamEmp,oSay,cEmp,cFil})


Return

