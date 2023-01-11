#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "APWIZARD.CH"

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4F01INT                            Modulo : SIGAFAT      //
//                                                                          //
//  Função que realiza a alteração da conexão com o DbAccess para conectar  //
//a outro banco de dados 													//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	2.00													//
//                                                                          //
//	@author.....:	Rogério Costa											//
//                                                                          //
//	@since......: 	28/09/2020												//	
//                                                                          //
//	@param......:	aParamEmp, array, dados da empresa e filial para 		//
//					processamento											//
/*///////////////////////////////////////////////////////////////////////////

/*/{Protheus.doc} T4F01INT
	Função que realiza a alteração da conexão com o DbAccess para conectar a 
	outro banco de dados
	@type.......:	function												
	@version....:	1.00													
	@author.....:	Rogério Costa											
	@since......: 	28/09/2020												
	@param......:	aParamEmp, array, dados da empresa e filial para 		
					processamento											
/*/

User Function T4F01INT(aParamEmp,cEmp,cFil,cDataIni,oSay,oGrid) //T4F01INT(aParamEmp,cEmp,cFil,cDataIni,oSay)

	Local nHndERP   := 0
	Local nHwnd     := -1
	Local cDBNew    := ""
	Local nPort  	:= 7896 	     // alterar para o ip do DbAccess
	Local cErro     := ""
	Local n
	Local cSrvDbAccess:=''
	Local cDtBlqINT	:= ""
	Local msg		:=""
	Local cAliasT	:= GetNextAlias()
	Local lIntegra	:=.F.
	Local nI		:= 0
	Local nQtdAtiva := 0
	Local lProcessou:= .F.

	Private cDataIni
	Private lAuto 	:= .T.
	Private cMarca 	:= ""
	Private cEmp
	Private cFil

If !(FWIsInCallStack('U_T4F01M'))

		If Empty(cEmp)
			If VALTYPE(aParamEmp) <> "U" .OR. VALTYPE(aParamEmp) <> "C"
				cEmp := aParamEmp[1]
				cFil := aParamEmp[2]
			EndIf
		EndIf

		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4", "ZAD", "ZAF","ZAE"

		cDataIni := SuperGetMV("MV_DTINTI")

		cDtBlqINT := SuperGetMv("MV_DTBLINT")

		aUserInfo	:= 	GetUserInfoArray()
		cEmpFil		:=	cEmp + "/" + cFil

		For nI:=1 To Len(aUserInfo)
			If ("U_T4F01INT" $ aUserInfo[nI][11] .And. cEmpFil $ aUserInfo[nI][11])
				nQtdAtiva := nQtdAtiva + 1
			EndIf
		Next nI

		If (cDataIni == '20220630') .Or. STOD(cDtBlqINT) >= STOD(cDataIni) .Or. stod(cdataini) >= dDataBase

			If SuperGetMV("MV_DTINTI") > DTOS(ddatabase)
				PutMV("MV_DTINTI", dtos(ddatabase-1))
			EndIf

			RESET ENVIRONMENT
			Return
		EndIf

	Else
		cDtBlqINT := SuperGetMV("MV_DTBLINT")

		If STOD(cDtBlqINT) >= STOD(cDataIni)
			If FWIsInCallStack('U_T4F01M')

				msg := "ATENCAO!"+CHR(13)+CHR(10)
				msg +=  CHR(13)+CHR(10)
				msg += "O periodo escolhido está bloqueado para processamento."
				msg +=  CHR(13)+CHR(10)

				FWAlertWarning(msg, "Cancelamento")
				Return
			EndIf
		EndIf

	EndIf

	If cEmpAnt == '33'
		lHrIni := (TIME() > '04:00:00' .AND. TIME() < '11:00:00')
	ElseIf cEmpAnt == '08'
		lHrIni := (TIME() > '02:30:00' .AND. TIME() < '11:30:00')
	EndIf

	If (FWIsInCallStack('U_T4F01M'))
		lHrIni := .T.
	EndIf

	
	If LockByName("T4F01INT_"+cEmpAnt,.T.,.T.) .And. lHrIni

		U_T4F01LOG(TIME() + " - T4F01INT - INICIO DA ROTINA..")

		cData	:=	SUBSTR(cdataini,1,4)+'-'+SUBSTR(cdataini,5,2)+'-'+SUBSTR(cdataini,7,2)

		If cEmp =='08'

			cDBNew    	:= "MYSQL/t4fmaster"
			cSrvDbAccess:= "10.200.182.7"

		ElseIf cEmp =='33' //INTI

			cDBNew    	:= "MYSQL/intimaster"
			cSrvDbAccess:= "10.200.182.7"

		EndIf

		aAreaSa1  :=  SA1->(GetArea())

		For n:=1 To 2

			If FWIsInCallStack('U_T4F01M')

				cMsg := "Conectanto banco de dados INTI " + cDBNew

				oGrid:SetIncMeter(1,cMsg)

			EndIf

			If n == 1

				//------------------------------------
				// Armazena conexão com banco atual
				//------------------------------------

				nHndERP := AdvConnection()

				//------------------------------------
				// Cria uma conexão com um outro banco, outro DBAcces
				//------------------------------------

				nHwnd := TCLink(cDBNew, cSrvDbAccess, nPort)

				if nHwnd >= 0

					If FWIsInCallStack('U_T4F01M')

						//	oSay:SetText("PROCESSANDO CONSULTA FISCAL INTI DIA: "+ DTOC(STOD(cdataini)) +"..") // ALTERA O TEXTO CORRETO
						//	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT
					EndIf

					T4FQRYFIS(nHndERP,nHwnd,cdata,oSay,oGrid,cdataini)

				Else

					If FWIsInCallStack('U_T4F01M')

						msg := "ATENCAO!"+CHR(13)+CHR(10)
						msg +=  CHR(13)+CHR(10)
						msg += Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - Falha na conexao com o banco de dados INT."+ 'Empresa '+cEmp
						msg +=  CHR(13)+CHR(10)
						msg += " Contate o departamento de TI."

						Alert(msg)
						Return
					Else

						cErro :=  REPLICATE("*", 5)+ CRLF
						cErro +=  " Falha na conexao com o banco de dados externo." + ' Empresa '+cEmp +'-' + ' Dia' + Alltrim(DTOC(STOD(cdataini)))+"-"+Alltrim(Time())

						cTO	:= "mario@byinti.com; holiveira@t4f.com.br; gcalazans@t4f.com.br;william@byinti.com;tax@t4f.com.br;contabil@t4f.com.br "
						cCc	:= ""
						cBcc:= ""
						cTxtemail:= REPLICATE("*", 5)+"FALHA DE CONEXAO COM BANCO DE DADOS - EMPRESA: " + cEmp + REPLICATE("*", 5)

						//U_T4COMMAIL(cTO, cCc, cTxtemail, cErro,{},'')

						//u_T4F01LOG(cErro)
					End If
				End If
			Else
				//------------------------------------
				// Armazena conexão com banco atual
				//------------------------------------

				nHndERP := AdvConnection()

				//------------------------------------
				// Cria uma conexão com um outro banco, outro DBAcces
				//------------------------------------

				nHwnd := TCLink(cDBNew,cSrvDbAccess, nPort)

				if nHwnd >= 0

					If FWIsInCallStack('U_T4F01M')
					/*
					oSay:SetText("PROCESSANDO CONSULTA FINANCEIRA INTI DATA: "+ DTOC(STOD(cdataini))+"...")
					ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT
					*/
					EndIf

					lProcessou := T4FQRYFIN(nHndERP,nHwnd,cdata,oSay,oGrid,cdataini)
				Else
					cErro :=  REPLICATE("*", 5)+ CRLF
					cErro +=  " Falha na conexao com o banco de dados externo." + ' Empresa '+cEmp +'-' + ' Dia' + Alltrim(DTOC(STOD(cdataini)))+"-"+Alltrim(Time())

					cTO	:= "mario@byinti.com; holiveira@t4f.com.br; william@byinti.com;tax@t4f.com.br;contabil@t4f.com.br "
					cCc	:= ""
					cBcc:= ""
					cTxtemail:= REPLICATE("*", 5)+"FALHA DE CONEXAO COM BANCO DE DADOS - EMPRESA: " + cEmp + REPLICATE("*", 5)

					//U_T4COMMAIL(cTO, cCc, cTxtemail, cErro,{},'')

					//u_T4F01LOG(cErro)
				End If
			EndIf

		Next n

		RestArea(aAreaSa1)

		If Select(cAliasT) > 0
			(cAliasT)->( DbCloseArea() )
		EndIf

		UnlockByName("T4F01INT_"+cEmp,.T.,.T.)

		U_T4F01LOG(TIME() + " - T4F01INT - FIM DA ROTINA..")

	EndIf

	Sleep(200)

	If lProcessou
		U_T4FPEDAUT({},'',cEmpAnt,cFilAnt,cdataini)
	EndIf

	If Isblind()
		RESET ENVIRONMENT
	End If

Return

/*////////////////////////////////////////////////////////////////////////////
//																			//
// 	Programa ...: T4FQRYFIS                           Modulo : SIGAFAT      //
//                                                                          //
//  Função que realiza consulta ao banco de dados externo para obter as 	//
//  vendas e incluir no sistema PROTHEUS.  									//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa | CRM SERVICES							//
//                                                                          //
//	@since......: 	28/09/2020												//	
//                                                                          //
//	@param......:	aParamEmp, array, dados da empresa e filial para 		//
//					processamento											//
////////////////////////////////////////////////////////////////////////////*/

/*/{Protheus.doc} T4FQRYFIS
	Função que gera consulta ao banco de dados externo para obter as transações 
	financeiras das vendas e incluir no sistema PROTHEUS. **
	@type function
	@version 1.00
	@author Rogério Costa | CRM SERVICES
	@since	28/09/2020												
/*/

Static Function T4FQRYFIS(nHndERP,nHwnd,cdata,oSay,oGrid,cdataini)

	Local cQuery  	:= ''
	Local cAlias  	:= GetNextAlias()
	Local cQryZAD  	:= ''
	Local cAliasTMP	:= GetNextAlias()
	Local cErro   	:= ''
	Local aZAD    	:= {}
	Local i       	:= 0
	Local cCpf   	:=""
	Local cCnpjEmpr :=''
	Local cEmpresa	:=''
	Local NfRps		:=''
	Local NfID		:=''
	Local NfRegist	:=''
	Local NfVerify	:=''
	Local aParam	:={}
	Local nVAlItem	:=0
	Local cItemName	:=""
	Local cEndereco	:=""

	/*
	# Consultas VIEWE - protheusFiscal - Criada por Mário - INTI
	# Obs.: Sem filtro de data, retorna o dia anterior. 
	select protheusFiscal.* from protheusFiscal; 

	# Com filtro de data 
	# Obs.:Filtro de data é uma variável de sessão, ou seja, uma vez definida o filtro de data o mesmo ficará ativo durante a sessão toda 
	select protheusFiscal.* from (SELECT @protheusDateFilter:='2020-03-01') t, protheusFiscal;
	*/

	//MAX_EXECUTION_TIME (in milliseconds)

	If FWIsInCallStack('U_T4F01M')
		cMsg := "Consultando tabela fiscal"

		oGrid:SetIncMeter(1,cMsg)

	EndIf

	cQuery:=""
	cQuery+=" select /*+ MAX_EXECUTION_TIME(5000000) */ company,module,corpCode,corpSName,corpCNPJ,prodName,prodSName,prodCNPJ,cName,cEmail, " + CRLF
	cQuery+=" cCPF,cAddress,cAddress2,cDistrict,cAddressN,cCity,cState,cCountry,cZipcode,slUID,itemStatus, " + CRLF
	cQuery+=" slID,slSearcher,slDate,itmCanDate,eventName,eventECode,eventEPEP,eventDate,itemType,itemName ," + CRLF
	cQuery+=" ticketId,itemId,itemAmount,itemDiscount,itemTotal,fiscalID,NfRps,NfID,NfRegist,NfVerify " + CRLF
	cQuery+="  From (select @protheusDateFilter:='"+cdata+"') t, " + CRLF
	cQuery+="  protheusFiscal " + CRLF
	cQuery+="  ORDER BY module, cCPF, cName, ticketId  " + CRLF

	TCQUERY (cQuery) NEW ALIAS (cAlias)

	(cAlias)->(DbGotop())

	If Empty((cAlias)->module)
		cErro :=  REPLICATE("*", 5)+"SEM DADOS CONSULTA FISCAL INTI" + REPLICATE("*", 5) + CRLF
		cErro += ' **Query protheusFiscal** - A consulta não retornou dados habilitados para processar, verifique a query destino : ***' + CRLF
		cErro += ' ********************************************************************************************************************' + CRLF
		cErro +=  cQuery + CRLF
		cErro += ' ********************************************************************************************************************' + CRLF
		cErro += ' *** Empresa '+ cEmpAnt

		cTO	:= "mario@byinti.com; holiveira@t4f.com.br; mguandelini@t4f.com.br;tax@t4f.com.br;contabil@t4f.com.br "
		cCc	:= ""
		cBcc:= ""
		cTxtemail:= REPLICATE("*", 5)+"SEM DADOS CONSULTA FISCAL INTI" + REPLICATE("*", 5)

		//U_T4COMMAIL(cTO, cCc, cTxtemail, cErro,{},'')

		//U_T4F01LOG(cErro)
	Else
		While (cAlias)->(!Eof())

			If "AVENIDA" $ Alltrim(UPPER((cAlias)->cAddress))

				cEndereco := Alltrim(StrTran( UPPER((cAlias)->cAddress),"AVENIDA","AV."))

			ElseIf "RUA" $ Alltrim(UPPER((cAlias)->cAddress))

				cEndereco	:= Alltrim(StrTran( UPPER((cAlias)->cAddress),"RUA","R."))

			EndIf

			aAdd(aZAD,{alltrim(cEmpresa)								,; 	//	1	EMPRESA
			alltrim((cAlias)->cName)									,;  //	2	NOME
			alltrim((cAlias)->cEmail)									,;  //	3	EMAIL
			alltrim((cAlias)->cCPF)										,;  //	4	CPF
			alltrim(cEndereco)+','+alltrim((cAlias)->cAddressN),;  //	5	END + NUMERO
			alltrim((cAlias)->cAddress2)								,;	//	6	COMPLEMENTO
			alltrim((cAlias)->cDistrict)								,;	//	7	BAIRRO
			alltrim((cAlias)->cCity)									,;	//	8	CIDADE
			alltrim((cAlias)->cState)									,;  //	9	ESTADO
			alltrim((cAlias)->cZipcode)									,;  //	10	CEP
			(cAlias)->slId												,;  //	11	ID VENDA
			(cAlias)->slDate											,;	//	12	DATA VENDA
			(cAlias)->itmCanDate 										,; 	//	13	DATA CANCELAMENTO
			alltrim((cAlias)->eventName)								,;  //	14	NOME EVENTO
			IIf(cEmpAnt=='33','990300002',Upper(alltrim((cAlias)->eventEPEP))) ,; 	//	15	COD EVENTO
			(cAlias)->eventDate											,;  //	16	DATA EVENTO
			alltrim((cAlias)->itemType)									,;  //	17	TIPO PRODUTO
			alltrim((cAlias)->itemName)									,;	//alltrim((cAlias)->itemName)		,;   //	18	NOME PRODUTO
			Alltrim((cAlias)->itemId)   								,;	//	19	ID PRODUTO
			(cAlias)->itemAmount										,;	//	20	TOTAL PRODUTO
			(cAlias)->itemDiscount										,;	//	21	DESCONTO
			(cAlias)->itemTotal											,;	//	22	TOTAL VENDA
			alltrim((cAlias)->NfRps)									,;	//	23	RPS
			alltrim((cAlias)->NfID)	  									,;	//	24	NOTA SERVICO
			'',;//alltrim((cAlias)->NfRegist)									,;	//	25	NCM
			'',;//alltrim((cAlias)->NfVerify)									,;	//	26	CHAVE
			alltrim((cAlias)->corpCNPJ)									,;	//	27	CNPJEMP
			(cAlias)->fiscalID											,;	//	28	NUM INGRESSO
			Alltrim(str((cAlias)->ticketId))									,; 	//	29	ID TICKET
			(cAlias)->slSearcher										,;	//	30	LOCALIZADOR VENDA
			(cAlias)->corpCNPJ											,;	//	31  CNPJ EMPRESA CLIENTE
			(cAlias)->corpSName											,;	//	32  NOME EMPRESA CLIENTE
			(cAlias)->slUID											    ,;	//	33  SLUID
			(cAlias)->itemStatus										})	//	34  itemStatus

			(cAlias)->(DbSkip())
		EndDo
	EndIf

	If Select(cAlias) > 0
		(cAlias)->( DbCloseArea() )
	EndIf

	// Volta para conexão ERP
	TCSetConn(nHndERP)

	//------------------------------------
	// Fecha a conexão com o outro banco
	//------------------------------------
	TCUnlink(nHwnd)

	//------------------------------------
	// GRAVA DADOS DA CONSULTA FISCAL
	//------------------------------------
	dbSelectArea("ZAE")
	ZAE->(dbSetOrder(1))

	dbSelectArea("CTD")
	CTD->(dbSetOrder(1))

	dbSelectArea("ZAD")
	ZAD->(dbSetOrder(1))

	cQuery:=" "
	cQuery+=" SELECT count(*) TOT "+ CRLF
	cQuery+=" FROM "+RetSqlName('ZAD') + CRLF
	cQuery+=" WHERE D_E_L_E_T_ = ' ' "+ CRLF
	cQuery+=" AND ZAD_DTVEND = '"+cDataIni+ "'" + CRLF

	TCQUERY (cQuery) NEW ALIAS (cAliasT:=GetNextAlias())

	(cAliasT)->(DbGotop())

	If len(aZAD) > (cAliasT)->TOT
		For i:=1 To len(aZAD)

			If FWIsInCallStack('U_T4F01M')

				cMsg := "Gravando tabela Fiscal dia : [ "+"DIA "+DTOC(aZAD[i][12])+" ITEM : "+ Alltrim(Str(i)) + " de " + Alltrim(Str(len(aZAD)))+" ]

				oGrid:SetIncMeter(1,cMsg)
			EndIf

			cCpf := Alltrim(StrTran( aZAD[i][4],".",""))
			cCpf := Alltrim(StrTran( cCpf, "/", "" ))
			cCpf := Alltrim(StrTran( cCpf, "-", "" ))

			cDtVend := DTOS(aZAD[i][12])
			cItemId	:= PADR(aZAD[I][19]					,GetSX3Cache('ZAD_ITEMID','X3_TAMANHO'))
			cEpe	:= PADR(aZAD[I][15]					,GetSX3Cache('ZAD_EPEP','X3_TAMANHO'))
			cTktId	:= Alltrim(aZAD[I][29])
			cCpf	:= PADR(FWNoAccent(cCpf)			,GetSX3Cache('ZAD_CPF','X3_TAMANHO'))
			cSluId	:= PADR(aZAD[I][33]					,GetSX3Cache('ZAD_SLUID','X3_TAMANHO'))
			cItemTp	:= PADR(aZAD[I][17]					,GetSX3Cache('ZAD_ITTYPE','X3_TAMANHO'))


			If Empty(aZAD[i][13])
				cTpTran	:= '1'
			Else
				cTpTran	:= '2'
			EndIf

			cTpTran	:= PADR(cTpTran		,GetSX3Cache('ZAD_TPTRAN','X3_TAMANHO'))

			cQryZAD	:=""
			cQryZAD	+=" SELECT * FROM "		+ RetSqlName("ZAD")+' ZAD' + CRLF
			cQryZAD	+=" WHERE ZAD_FILIAL = '01'"+ CRLF
			cQryZAD	+=" AND ZAD_DTVEND = '" 	+ cDtVend 			+"'"+ CRLF
			cQryZAD	+=" AND ZAD_ITEMID = '"	+ cItemId 			+"'"+ CRLF
			cQryZAD	+=" AND ZAD_EPEP = '"		+ cEpe 				+"'"+ CRLF
			cQryZAD	+=" AND ZAD_TKTID = '"	+ cTktId 			+"'"+ CRLF
			cQryZAD	+=" AND ZAD_CPF = '"		+ cCpf 				+"'"+ CRLF
			cQryZAD	+=" AND ZAD_SLUID = '"	+ cSluId 			+"'"+ CRLF
			cQryZAD	+=" AND ZAD_ITTYPE = '"	+ cItemTp 			+"'"+ CRLF
			cQryZAD	+=" AND ZAD_TPTRAN = '"	+ cTpTran 			+"'"+ CRLF
			cQryZAD	+=" AND D_E_L_E_T_ =' ' "						+ CRLF

			If Select(cAliasTMP) > 0
				(cAliasTMP)->( DbCloseArea() )
			EndIf

			TCQUERY (cQryZAD) NEW ALIAS (cAliasTMP)

			(cAliasTMP)->(DbGotop())

			If Empty((cAliasTMP)->ZAD_FILIAL)

				cCNPJCli := Alltrim(StrTran( aZAD[i][31],".",""))
				cCNPJCli := Alltrim(StrTran( cCNPJCli, "/", "" ))
				cCNPJCli := Alltrim(StrTran( cCNPJCli, "-", "" ))

				cCnpjEmpr := Alltrim(StrTran( aZAD[i][27], ".", ""))
				cCnpjEmpr := Alltrim(StrTran( cCnpjEmpr, "/", "" ))
				cCnpjEmpr := Alltrim(StrTran( cCnpjEmpr, "-", "" ))

				cEmpresa:=If(cCnpjEmpr== "02860694000162",'1','2')//1=T4F;2=INTI

				NfRps	:=If(Valtype(Alltrim(aZAD[i][23]))	=='null'	,'',Alltrim(aZAD[i][23]))

				NfID	:=If(Valtype(Alltrim(aZAD[i][24]))	=='null'	,'',Alltrim(aZAD[i][24]))

				NfRegist:=If(Valtype(Alltrim(aZAD[i][25]))	=='null'		,'',Alltrim(aZAD[i][25]))

				NfVerify:=If(Valtype(Alltrim(aZAD[i][26]))	=='null'    	,'',Alltrim(aZAD[i][26]))

				cAddress	:=NoAcento(Alltrim(aZAD[i][5]))
				cAddress2	:=Strtran( NoAcento(Alltrim(aZAD[i][6])),'#',' ')
				cAddress2	:=Strtran(NoAcento(cAddress2),'N','N')

				cItemName	:=NoAcento(alltrim(aZAD[i][18]))

				cDistrict	:=NoAcento(Alltrim(aZAD[i][7]))

				cCity	 	:=NoAcento(Alltrim(aZAD[i][8]))

				cName		:=NoAcento(Alltrim(aZAD[i][2]))

				cItemType	:=NoAcento(Alltrim(aZAD[i][17]))

				RecLock("ZAD",.T.)

				ZAD->ZAD_FILIAL :='01'
				ZAD->ZAD_NUMERO := GetSXENum("ZAD","ZAD_NUMERO")
				ZAD->ZAD_NFINTI := NfRps //If(Valtype(aZAD[i][28])=='N',ALLTRIM(STR(aZAD[i][28])),aZAD[i][28])
				ZAD->ZAD_DTIMP  := DDATABASE
				ZAD->ZAD_DTVEND	:= aZAD[i][12]
				ZAD->ZAD_DTEVEN	:= If(Empty(aZAD[i][16]),'1900-01-01',aZAD[i][16])
				ZAD->ZAD_DTCANC	:= fwDateTimeToLocal(aZAD[i][13])[1] //converte data ISO-8601 para uma data __/__/__
				ZAD->ZAD_NOME   := UPPER(Alltrim(aZAD[i][2]))
				ZAD->ZAD_CPF    := cCpf
				ZAD->ZAD_END    := UPPER(cAddress)
				ZAD->ZAD_COMPLE	:= UPPER(cAddress2)
				ZAD->ZAD_BAIRRO := UPPER(cDistrict)
				ZAD->ZAD_CIDADE := UPPER(cCity)
				ZAD->ZAD_EST    := UPPER(Alltrim(aZAD[i][9]))
				ZAD->ZAD_CEP    := STRTRAN(Alltrim(aZAD[i][10]),'-','')
				ZAD->ZAD_TPAGTO	:='BYINTI'
				ZAD->ZAD_SEARCH	:= aZAD[i][30]
				ZAD->ZAD_CNPJCL	:= cCNPJCli
				ZAD->ZAD_NOMECL	:= aZAD[i][32]
				ZAD->ZAD_OBS	:= "Hr.Import:"+Alltrim(Time())+"|"

				nVAlItem	:=	If (Valtype(aZAD[i][22])=='C',Val(aZAD[i][22]),aZAD[i][22])

				Do Case

				Case cItemType=='Ingresso' .And. cItemName <> 'Doacao'
					ZAD->ZAD_TPITEM := '1' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript,8=Doacao
					ZAD->ZAD_VLRTKT := nVAlItem

				Case cItemType=='Valor Extra' //VALORES COBRADOS A MAIS CONSIDERADOS COMO INGRESSOS
					ZAD->ZAD_TPITEM := '1' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript
					ZAD->ZAD_VLRTKT := nVAlItem
				
				Case (cItemType == 'Subscript' .Or. cItemType == 'Assinatura'                    )
					ZAD->ZAD_TPITEM := '7' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript,8=Doacao
					ZAD->ZAD_VLRTKT := nVAlItem

				Case cItemType=='Valor Extra' .And. cItemName == 'Doacao'
					ZAD->ZAD_VLRTKT := nVAlItem
					ZAD->ZAD_TPITEM := '8' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript; 8=Doacao

				Case cItemType=='Tx Conveniencia'
					ZAD->ZAD_VLRTXC := nVAlItem
					ZAD->ZAD_TPITEM := '2' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

				Case cItemType=='Tx Entrega'
					ZAD->ZAD_VLENTR := nVAlItem
					ZAD->ZAD_TPITEM := '4' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

				Case cItemType== 'Ass: Tx Entrega'
					ZAD->ZAD_VLENTR := nVAlItem
					ZAD->ZAD_TPITEM := '4' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

			/*
			Case cItemType=='Valor Extra'
				ZAD->ZAD_VLRTXS := nVAlItem
				ZAD->ZAD_TPITEM := '3' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript
			*/

				Case cItemType=='Cortesia'
					ZAD->ZAD_VLRTXI := nVAlItem
					ZAD->ZAD_TPITEM := '5' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

				Case cItemType=='Socio'
					ZAD->ZAD_VLRSOC := nVAlItem
					ZAD->ZAD_TPITEM := '6' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

				End Case

				If (nVAlItem == 0)
					ZAD->ZAD_STATUS := "4"
					ZAD->ZAD_OBS	+= ZAD->ZAD_OBS +"-Valor Zerado|"
				Else
					ZAD->ZAD_STATUS := "1"
				EndIf

				ZAD->ZAD_TPTRAN	:= cTpTran

			/*
			If Empty(aZAD[i][13])
				ZAD->ZAD_TPTRAN:='1'
			Else
				ZAD->ZAD_TPTRAN:='2'
			EndIf
			*/

				ZAD->ZAD_EPEP   := Alltrim(aZAD[i][15])

				If !(ZAE->(MsSeek(xFilial("ZAE") + ZAD->ZAD_EPEP)) .AND. CTD->(MsSeek(xFilial("CTD") + ZAD->ZAD_EPEP)))
					ZAD->ZAD_STATUS := "4"
					ZAD->ZAD_OBS	:= Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - EPEP no cadastrado na tabela ZAE ou CTD:" + Alltrim(ZAD->ZAD_EPEP)
				EndIf

				ZAD->ZAD_EMP    := cEmpresa
				ZAD->ZAD_EVENTO := Alltrim(aZAD[i][14])
				ZAD->ZAD_IDVEND := aZAD[i][11]
				ZAD->ZAD_ITEMID	:= aZAD[i][19]
				ZAD->ZAD_ITNAME	:= cItemName
				ZAD->ZAD_TKTID	:= Alltrim(aZAD[i][29])
				ZAD->ZAD_ITTYPE := aZAD[i][17]
				ZAD->ZAD_SLUID 	:= aZAD[i][33]

				ZAD->(MsUnlock())

				//****************************************************************
				//* Realiza o cadastro do cliente caso não exista no Protheus
				//****************************************************************

				dbSelectArea("SA1")
				SA1->(dbSetOrder(3))
				If SA1->(!MsSeek(xFilial("SA1") + cCpf))
					Begin Transaction
						aParam := u_T4F01CLI(UPPER(Alltrim(aZAD[i][2])),;
							cCpf,;
							UPPER(cAddress),;
							UPPER(cDistrict),;
							UPPER(cCity),;
							UPPER(Alltrim(aZAD[i][9])),;
							STRTRAN(Alltrim(aZAD[i][10]),'-',''),;
							'N',;
							UPPER(cAddress2))

					End Transaction
				Else
					Begin Transaction
						aParam := u_T4F01CLI(UPPER(Alltrim(aZAD[i][2])),;
							cCpf,;
							UPPER(cAddress),;
							UPPER(cDistrict),;
							UPPER(cCity),;
							UPPER(Alltrim(aZAD[i][9])),;
							STRTRAN(Alltrim(aZAD[i][10]),'-',''),;
							'S',;
							UPPER(cAddress2))
					End Transaction

				EndIf

			EndIf

		Next i
	EndIf

Return

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4FQRYFIN                           Modulo : SIGAFAT      //
//                                                                          //
//  Função que gera consulta ao banco de dados externo para obter as 		//
//transações financeiras das vendas e incluir no sistema PROTHEUS. 			//
//a outro banco de dados 													//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa											//
//                                                                          //
//	@since......: 	28/09/2020												//	
//                                                                          //
//	@param......:	aParamEmp, array, dados da empresa e filial para 		//
//					processamento											//
/*////////////////////////////////////////////////////////////////////////////

/*/{Protheus.doc} T4FQRYFIN
Função que gera consulta ao banco de dados externo para obter as transações financeiras das vendas e incluir no sistema PROTHEUS. **
@type function
@version 1.00
@author Rogério Costa
/*/
Static Function T4FQRYFIN(nHndERP,nHwnd,cdata,oSay,oGrid,cdataini)

	Local cQueryFin	:= ''
	Local cAliasFIN := GetNextAlias()
	Local cErro   	:= ''
	Local aZAF    	:= {}
	Local i       	:= 0
	Local cCpf   	:=""
	Local cCnpjEmpr :=''
	Local cEmpresa	:=''
	Local NfRps		:=''
	Local NfID		:=''
	Local NfRegist	:=''
	Local NfVerify	:=''
	Local aParam	:={}
	Local nVAlItem	:=0
	Local cItemName	:=""
	Local J
	Local lProcessou	:=.F.

	/*
	# Consultas VIEWE - protheusFiscal - Criada por Mário - INTI
	# Sem filtro de data, retorna o dia anterior. 
	select protheusFiscal.* from protheusFiscal; 

	# Com filtro de data 
	# Obs.:Filtro de data é uma variável de sessão, ou seja, uma vez definida o filtro de data o mesmo ficará ativo durante a sessão toda 
	select protheusFiscal.* from (SELECT @protheusDateFilter:='2020-03-01') t, protheusFiscal;
	*/

	If FWIsInCallStack('U_T4F01M')

		cMsg := "Consultando tabela financeira "

		oGrid:SetIncMeter(1,cMsg)
	EndIf

	cQueryFin	:=""
	cQueryFin	+=" select /*+ MAX_EXECUTION_TIME(5000000) */ protheusFinanceiro.* " + CRLF
	cQueryFin	+=" from (SELECT @protheusDateFilter:='"+cdata+"') t, protheusFinanceiro" + CRLF
	cQueryFin	+="  ORDER BY slUID, slSearcher  " + CRLF

	TCQUERY (cQueryFin) NEW ALIAS (cAliasFIN)

	(cAliasFIN)->(DbGotop())


	If Empty((cAliasFIN)->module)

		cErro :=  REPLICATE("*", 5)+"SEM DADOS CONSULTA FINANCEIRA INTI" + REPLICATE("*", 5) + CRLF
		cErro += ' **Query protheusFinanceira** - A consulta não retornou dados habilitados para processar, verifique a query destino : ***' + CRLF
		cErro += ' ***************************************************************************' + CRLF
		cErro +=  cQueryFin + CRLF
		cErro += ' ***************************************************************************' + CRLF
		cErro += ' *** Empresa '+ cEmpAnt

		cTO	:= "mario@byinti.com; holiveira@t4f.com.br; mguandelini@t4f.com.br;tax@t4f.com.br;contabil@t4f.com.br"
		cCc	:= ""
		cBcc:= ""
		cTxtemail:= REPLICATE("*", 5)+"SEM DADOS NA CONSULTA FINANCEIRO INTI" + REPLICATE("*", 5)

		//U_T4COMMAIL(cTO, cCc, cTxtemail, cErro,{},'')

		//u_T4F01LOG(cErro)

	Else
		While (cAliasFIN)->(!Eof())

			aAdd(aZAF,{alltrim(cEmpresa)										,; 	//	1	EMPRESA
			alltrim((cAliasFIN)->module)										,;  //	2	MODULO
			alltrim((cAliasFIN)->type)											,;  //	3	TIPO
			alltrim((cAliasFIN)->prodType)										,;  //	4	prodType
			alltrim((cAliasFIN)->finReceive)									,;  //	5	finReceive
			alltrim((cAliasFIN)->corpCode)										,;	//	6	corpCode
			alltrim((cAliasFIN)->corpSName)										,;	//	7	corpSName
			alltrim((cAliasFIN)->corpCNPJ)										,;	//	8	corpCNPJ
			alltrim((cAliasFIN)->slUID)											,;  //	9	slUID
			alltrim((cAliasFIN)->slID)											,;  //	10	slID
			(cAliasFIN)->slSearcher												,;  //	11	slSearcher
			(cAliasFIN)->slDate													,;	//	12	slDate
			(cAliasFIN)->slCancDate 											,; 	//	13	slCancDate
			alltrim((cAliasFIN)->eventName)										,;  //	14	NOME EVENTO
			IIf(cEmpAnt=='33','990300002',Upper(alltrim((cAliasFIN)->eventEPEP))),; 	//	15	COD EVENTO
			(cAliasFIN)->eventDate												,;  //	16	DATA EVENTO
			alltrim((cAliasFIN)->prodName)										,;	// 	17	NOME PRODUTO
			alltrim((cAliasFIN)->prodSName)										,;  //	18	TIPO PRODUTO
			Alltrim((cAliasFIN)->tranPayment)   								,;	//	19	ID PRODUTO
			(cAliasFIN)->tranRelease											,;	//	20	tranRelease
			(cAliasFIN)->transAmout												,;	//	21	transAmout
			(cAliasFIN)->transNSU												,;	//	22	transNSU
			""																	,;	//	23	finRefCha
			(cAliasFIN)->finCredit	  											,;	//	24	finCredit
			(cAliasFIN)->finTaxOp												,;	//	25	finTaxOp
			(cAliasFIN)->finTaxServ												,;	//	26	finTaxServ
			(cAliasFIN)->transId												,;	//	27	Id transação
			(cAliasFIN)->finId												})	//	28	FINID

			(cAliasFIN)->(DbSkip())
		EndDo

	EndIf

	(cAliasFIN)->(DbCloseArea())

	// Volta para conexão ERP
	TCSetConn(nHndERP)

	//------------------------------------
	// Fecha a conexão com o outro banco
	//------------------------------------
	TCUnlink(nHwnd)

	//------------------------------------
	// GRAVA DADOS DA CONSULTA FINANCEIRA
	//------------------------------------
	ChkFile("ZAF",.F.)

	dbSelectArea("ZAF")
	ZAF->(dbSetOrder(1))

	cQuery:=" "
	cQuery+=" SELECT count(*) TOT "+ CRLF
	cQuery+=" FROM "+RetSqlName('ZAF') + CRLF
	cQuery+=" WHERE D_E_L_E_T_ = ' ' "+ CRLF
	cQuery+=" AND ZAF_DTVEND = '"+cDataIni+ "'" + CRLF

	TCQUERY (cQuery) NEW ALIAS (cAliasZAF:=GetNextAlias())

	If len(aZAF) > (cAliasZAF)->TOT
		For J:=1 To len(aZAF)

			If FWIsInCallStack('U_T4F01M')

				cMsg := "Gravando tabela financeira dia "+DTOC(aZAF[J][12])+"  ITEM : "+ Alltrim(Str(J)) + " de " + Alltrim(Str(len(aZAF)))

				oGrid:SetIncMeter(1,cMsg)

			EndIf

			cTransId:= PADR(Alltrim(Str(aZAF[j][27]))	,GetSX3Cache('ZAF_NUMERO','X3_TAMANHO'))
			cSlU	:= PADR(aZAF[J][09]					,GetSX3Cache('ZAF_SLUID' ,'X3_TAMANHO'))
			cTpZAF	:= PADR(Alltrim(aZAF[j][03])		,GetSX3Cache('ZAF_TIPO' ,'X3_TAMANHO'))
			cEpepZAF:= PADR(Alltrim(aZAF[j][15])		,GetSX3Cache('ZAF_EPEP' ,'X3_TAMANHO'))
			cFinId	:= PADR(Alltrim(STR(aZAF[j][28]))	,GetSX3Cache('ZAF_FINID' ,'X3_TAMANHO'))

			If !(ZAF->(MsSeek(xFilial("ZAF")+cTransId+cSlU+cTpZAF+cEpepZAF+cFinId)))

				corpCNPJ := Alltrim(StrTran( aZAF[j][8],".",""))
				corpCNPJ := Alltrim(StrTran( corpCNPJ, "/", "" ))
				corpCNPJ := Alltrim(StrTran( corpCNPJ, "-", "" ))

				corpSName	:=	NoAcento(Alltrim(aZAF[j][7]))

				eventName	:=	NoAcento(alltrim(aZAF[j][14]))

				prodSName	:=	NoAcento(Alltrim(aZAF[j][17]))

				tranPayment	:=	NoAcento(Alltrim(aZAF[j][19]))

				RecLock("ZAF",.T.)

				ZAF->ZAF_FILIAL	:=	"01"
				ZAF->ZAF_NUMERO	:= 	If(Valtype(aZAF[J][27])=='N',ALLTRIM(STR(aZAF[J][27])),aZAF[J][27]) //GetSXENum("ZAF","ZAF_NUMERO")
				ZAF->ZAF_MODULO	:=	Alltrim(aZAF[j][02])
				ZAF->ZAF_TIPO	:=	Alltrim(aZAF[j][03])
				ZAF->ZAF_PRODTP	:=	Alltrim(aZAF[j][04])
				ZAF->ZAF_TPRECB	:=	aZAF[j][05]
				ZAF->ZAF_CORPCD	:=	Alltrim(aZAF[j][06])
				ZAF->ZAF_CORPNA	:=	Alltrim(corpSName)
				ZAF->ZAF_CORPCN	:=	corpCNPJ
				ZAF->ZAF_SLUID	:=	Alltrim(aZAF[j][09])
				ZAF->ZAF_SEARCH	:=	Alltrim(aZAF[j][11])
				ZAF->ZAF_DTVEND	:=	aZAF[j][12]
				ZAF->ZAF_DTCANC	:=	aZAF[j][13]
				ZAF->ZAF_EVENTO	:=	eventName
				ZAF->ZAF_EPEP	:=	Alltrim(aZAF[j][15])
				ZAF->ZAF_ITNAME	:=	Alltrim(aZAF[j][17])
				ZAF->ZAF_PROMOT	:=	Alltrim(aZAF[j][18])
				ZAF->ZAF_TPPGTO	:=	tranPayment
				ZAF->ZAF_TRRELE	:=	aZAF[j][20]
				ZAF->ZAF_VLRTRA	:=	aZAF[j][21]
				ZAF->ZAF_NSU	:=	Alltrim(aZAF[j][22])
				ZAF->ZAF_FINREF	:=	Alltrim(aZAF[j][23])
				ZAF->ZAF_FINCRE	:=	aZAF[j][24]
				ZAF->ZAF_FINTXO	:=	aZAF[j][25]
				ZAF->ZAF_FINTXS	:=	aZAF[j][26]
				ZAF->ZAF_FINID	:= 	cFinId
				ZAF->ZAF_OBS	:= "Hr.Import:"+Alltrim(Time())+"|"

				ZAF->(MsUnlock())

			EndIf

			lProcessou	:=	.T.

		Next J
	EndIf

	If lProcessou
		PutMV("MV_DTINTI", dtos(stod(SuperGetMV("MV_DTINTI"))+1))
	EndIf

Return(lProcessou)

/*/{Protheus.doc} T4F01MANUAL
** Chama função de integração das vendas da plataforma INTI **
@type function
@version 1.00
@author Rogério Costa - CRM SERVICES
@since 09/11/2021
@param aParamEmp, array, dados da empresa e filial para processamento
/*/

User Function T4F01M()

	Local oSay
	Local oGrid

	Private aParamBox		:= {}
	Private aRet			:= {}
	Private cDataIni
	Private aAreaZad	    :=  ZAD->(GetArea())

	aAdd(aParamBox,{1,"Data para Importação",DDATABASE           ,"","","   ","",80,.F.})  //01

	If !ParamBox(aParamBox, "Importação Manual Vendas", aRet)
		Return Nil
	Else
		cDataIni	:= DTOS(aRet[1])
	End If

	oGrid:=FWGridProcess():New("u_T4F01INT", "Importação de Registros INTI", "Rotina para importar a movimentação plataforma INTI", {|lEnd| u_T4F01INT({},cEmpAnt,cFilAnt,cDataIni,oSay,oGrid)},"","")

	oGrid:SetMeters(1)

	oGrid:Activate()

	If oGrid:IsFinished()
		FWAlertSuccess("Importação finalizada, será necessário reprocessar as vendas deste periodo....")
	Else
		FWAlertError("Fim com erro.")
	EndIf


//	FwMsgRun(NIL,{ |oSay| u_T4F01INT({},cEmpAnt,cFilAnt,cDataIni,oSay) }, "IMPORTAÇÃO DE VENDAS INTI", 'IMPORTANDO VENDAS INTI.......')

	//MsgInfo("Importação finalizada, será necessário reprocessar as vendas deste periodo....","Reprocessamento")

	RestArea(aAreaZad)

Return


User Function T4F02M()

	Local aParamBox		:= {}
	Local aRet			:= {}
	Local cDataIni
	Local cDataFim
	Local oGridRPS 		:= Nil

	aAdd(aParamBox,{1,"Data Inicial",CTOD('')     ,"","","   ","",80,.F.}) //01
	aAdd(aParamBox,{1,"Data Final " ,CTOD('')     ,"","","   ","",80,.F.})  //02
	aAdd(aParamBox,{1,"Serie "		,'   '           ,"","","   ","",25,.F.})  //03

	If !ParamBox(aParamBox, "Transmissão de RPS para Prefeitura ", aRet)
		Return Nil
	Else
		cDataIni	:= DTOS(aRet[1])
		cDataFim	:= DTOS(aRet[2])
		cSerie		:= aRet[3]
	End If

	oGridRPS:=FWGridProcess():New("U_T4F01TRNFE","EMISSAO DE RPS ", "ENVIO DE RPS PARA PREFEITURA.", {|lEnd| U_T4F01TRNFE({},     cSerie,'',   cDataIni,cDataFim,oGridRPS)},"","")

	//FwMsgRun(NIL,{ |oSay| U_T4F01TRNFE({},cSerie,'',cDataIni,cDataFim,oSay) }, "TRANSMISSÃO DE RPS", 'TRANSMITINDO RPS PENDENTES.......')

	oGridRPS:SetMeters(1)

	oGridRPS:Activate()

	If oGridRPS:IsFinished()

		MsgInfo("Processo finalizado..")

	Else
		MsgAlert("Fim com erro.")
	EndIf



	MsgInfo("Transmissão de RPS finalizada..","Reprocessamento")

Return


//processa os cancelamentos
User Function T4F03M()

	Local aParamBox		:= 	{}
	Local aRet			:= 	{}
	Local oSay 			:= 	Nil
	Local oGrid			:= 	Nil
	Local cLocalizador	:=	''
	Local cIdVenda		:=	''
	Local nQtd			:=	0

	aAdd(aParamBox,{1,"Dt.Inicial Cancelamento",CTOD('')     ,"","","   ","",80,.F.}) //01
	aAdd(aParamBox,{1,"Dt.Final Cancelamento " ,CTOD('')     ,"","","   ","",80,.F.})  //02
	aAdd(aParamBox,{1,"Localizador"	,SPAC(TamSX3("ZAD_SEARCH")[1])	,"","","   ","",80,.F.}) //03
	aAdd(aParamBox,{1,"Id.Venda"	,SPAC(TamSX3("ZAD_SLUID")[1])	,"","","   ","",80,.F.}) //04

	If !ParamBox(aParamBox, "Cancelamento de vendas ", aRet)
		Return Nil
	Else
		dDataIni	:= aRet[1]
		dDataFim	:= aRet[2]
		cLocalizador:= aRet[3]
		cIdVenda	:= aRet[4]
	End If

	oGrid:=FWGridProcess():New("U_T4F02CANC",  "Cancelamento | Devoluções de Vendas", "Rotina para processar os cancelamentos e devoluções de vendas.", {|lEnd| U_T4F02CANC({},dDataIni,dDataFim,oSay,cLocalizador,cIdVenda,oGrid)},"","")

	cQuery := " "
	cQuery += " 	SELECT COUNT(*) FROM (			" + CRLF
	cQuery += " 	SELECT ZAD_SEARCH,ZAD_NFTOTV 				" + CRLF
	cQuery += " 	FROM "+RetSqlName("ZAD")		+ CRLF
	cQuery += " 	WHERE ZAD_TPTRAN ='2'							" + CRLF
	cQuery += " 	AND  ZAD_DTCANC BETWEEN '"+Dtos(dDataIni)+"' AND '"+dtos(dDataFim)+"'	" + CRLF

	If !Empty(cLocalizador)
		cQuery += " AND  ZAD_SEARCH ='"+cLocalizador +"'"+ CRLF
	EndIf

	cQuery += " 	AND ZAD_STATUS ='1'							" + CRLF
	cQuery += " 	AND D_E_L_E_T_=' '							" + CRLF
	cQuery += " 	GROUP BY ZAD_SEARCH, ZAD_NFTOTV )			" + CRLF

	cQuery := ChangeQuery(cQuery)

	cAliasQtdCanc  := MPSysOpenQuery(cQuery)

	nQtd:= Select(cAliasQtdCanc)

	oGrid:SetMeters(1)

	oGrid:Activate()

	If oGrid:IsFinished()

		MsgInfo("Processo finalizado..")

	Else
		MsgAlert("Fim com erro.")
	EndIf

Return

//Chama função para atualizar zad
User Function T4FREFRESH()

	Local aParamBox	:= {}
	Local aRet		:= {}
	Local oSay 		:= Nil

	aAdd(aParamBox,{1,"Data Inicial",CTOD('')     					,"","","   ","",80,.F.}) //01
	aAdd(aParamBox,{1,"Data Final " ,CTOD('')     					,"","","   ","",80,.F.}) //02
	aAdd(aParamBox,{1,"Localizador"	,SPAC(TamSX3("ZAD_SEARCH")[1])	,"","","   ","",80,.F.}) //03

	If !ParamBox(aParamBox, "Atualização tabela ZAD...", aRet)
		Return Nil
	Else
		cDataIni:= DTOS(aRet[1])
		cDataFim:= DTOS(aRet[2])
		cSearch	:= aRet[3]
	End If

	FwMsgRun(NIL,{ |oSay| U_T4FUPDZAD(cDataIni,cDataFim,cSearch,oSay) }, "REFRESH ZAD", 'ATUALIZANDO STATUS ZAD.......')

Return

//Atualiza status ZAD com base nos pedidos de venda
User Function T4FUPDZAD(cDataIni,cDataFim,cSearch,oSay)

	Local cQry		:= ' '
	Local cAlias	:= GetNextAlias()
	Local aAreaZAD	:= ZAD->(GetArea())

	dbSelectArea("ZAD")

	cQry := "SELECT ZAD.R_E_C_N_O_ RECZAD, C6_SERIE, ZAD_SETOTV , C6_NOTA, ZAD_NFTOTV,C6_PEDCLI,C6_CHASSI,C6_NUM,C6_ITEMCC,ZAD_DTVEND "
	cQry += " FROM "+RetSqlName("ZAD") + " ZAD, " + RetSqlName("SC6") + ' SC6'"
	cQry += " WHERE ZAD_FILIAL ='01'
	cQry += " AND ZAD_DTVEND BETWEEN '" + cDataIni + "' AND '"+ cDataFim + "'"
	cQry += " AND ZAD_EPEP 	 = C6_ITEMCC
	cQry += " AND ZAD_TKTID  = C6_CHASSI 
	cQry += " AND ZAD_TPITEM = C6_PEDCLI   
	cQry += " AND ZAD_PEDIDO = C6_NUM   
	cQry += " AND ZAD_STATUS = '2'
	
	If !Empty(cSearch)
		cQry += " AND ZAD_SEARCH		= '" + cSearch +"'"
	EndIf

	cQry += " AND C6_NOTA 	<> ZAD_NFTOTV "
	cQry += " AND SC6.D_E_L_E_T_ = ' ' "
	cQry += " AND ZAD.D_E_L_E_T_ = ' ' "
	
	cQry += " UNION ALL "

	cQry += "SELECT ZAD.R_E_C_N_O_ RECZAD, C6_SERIE, ZAD_SETOTV , C6_NOTA, ZAD_NFTOTV,C6_PEDCLI,C6_CHASSI,C6_NUM,C6_ITEMCC,ZAD_DTVEND "
	cQry += " FROM "+RetSqlName("ZAD") + " ZAD, " + RetSqlName("SC6") + ' SC6'"
	cQry += " 	WHERE ZAD_FILIAL 	= '01'"
	cQry += " AND ZAD_DTVEND BETWEEN '" + cDataIni + "' AND '"+ cDataFim + "'"
	cQry += " AND ZAD_EPEP = C6_ITEMCC"
	cQry += " AND ZAD_ITEMID 	> ' '"
	cQry += " AND ZAD_TPITEM IN ('1','6','8')"
	cQry += " AND ZAD_ITTYPE 	> ' '"
	cQry += " AND ZAD_PEDIDO 	= C6_NUM"
	cQry += " AND ZAD_NFTOTV <> C6_NOTA 	
	cQry += " AND ZAD_STATUS 	= 	'2'"		
	
	If !Empty(cSearch)
		cQry += " AND ZAD_SEARCH		= '" + cSearch +"'"
	EndIf
	
	cQry += " AND ZAD.D_E_L_E_T_ = ' '" 
	cQry += " AND SC6.D_E_L_E_T_ = ' '"

	cQry	:= ChangeQuery(	cQry)

	TCQUERY (cQry) NEW ALIAS (cAlias)

	(cAlias)->(DbGotop())

	While !(cAlias)->(Eof())

		("ZAD")->(DbGoto((cAlias)->RECZAD))

		If Alltrim((cAlias)->C6_PEDCLI) == Alltrim(ZAD->ZAD_TPITEM) .AND. Alltrim((cAlias)->C6_CHASSI) == Alltrim(ZAD->ZAD_TKTID);
				.AND. Alltrim((cAlias)->C6_NUM) == Alltrim(ZAD->ZAD_PEDIDO)  .AND. Alltrim((cAlias)->C6_ITEMCC) == Alltrim(ZAD->ZAD_EPEP)

			oSay:SetText("ATUALIZANDO REGISTRO: "+Str((cAlias)->RECZAD)) // ALTERA O TEXTO CORRETO
			ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

			RecLock("ZAD",.F.)

			ZAD_STATUS := '3'
			ZAD_NFTOTV := (cAlias)->C6_NOTA
			ZAD_SETOTV := (cAlias)->C6_SERIE

			("ZAD")->(MsUnlock())
		ElseIf Alltrim(ZAD->ZAD_TPITEM) $ '1|6|8' .AND. Alltrim((cAlias)->C6_NUM) == Alltrim(ZAD->ZAD_PEDIDO)  .AND. Alltrim((cAlias)->C6_ITEMCC) == Alltrim(ZAD->ZAD_EPEP)

			oSay:SetText("ATUALIZANDO REGISTRO: "+Str((cAlias)->RECZAD)) // ALTERA O TEXTO CORRETO
			ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

			RecLock("ZAD",.F.)

			ZAD_STATUS := '3'
			ZAD_NFTOTV := (cAlias)->C6_NOTA
			ZAD_SETOTV := (cAlias)->C6_SERIE

			("ZAD")->(MsUnlock())

		EndIf

		(cAlias)->(dbSkip())
	End

	If Select(cAlias) > 0
		(cAlias)->( DbCloseArea() )
	EndIf

	RestArea(aAreaZAD)

Return


/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
//	{Protheus.doc} 			 												//	
//																			//
// 	Programa ...: T4FBLDTINTI                            Modulo : SIGAFAT   //
//                                                                          //
//  Função responsável por preencher o parametro de data de bloqueio dos 	//
//	reprocessamentos das integrações INTI									//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa											//
//                                                                          //
//	@since......: 	01/02/2022												//	
//                                                                          //
/*////////////////////////////////////////////////////////////////////////////

User Function T4FBLDTINTI()

	Local lRetMsg := .T.

	Private dDtBlqInti	:= Ctod("  /  /  ")

	DEFINE MSDIALOG oDlg1 FROM 080,00 TO 280,200 TITLE "Bloquear Periodo para Integração" PIXEL OF oMainWnd STYLE DS_MODALFRAME STATUS

	@ 015,010 Say "Data" SIZE 100,10 OF oDlg1 PIXEL
	@ 015,050 GET dDtBlqInti Size 50,2 Of oDlg1 Pixel //Valid(VLDATE(dDtBlqInti))

	DEFINE SBUTTON FROM 050,020 TYPE 1 PIXEL ACTION oDlg1:End() ENABLE OF oDlg1
	oDlg1:LESCCLOSE := .F.

	ACTIVATE MSDIALOG oDlg1 CENTERED

	msg := "ATENCAO!"+CHR(13)+CHR(10)
	msg +=  CHR(13)+CHR(10)
	msg += "Não será possivel reprocessar registros anteriores a esta data."
	msg +=  CHR(13)+CHR(10)
	msg +=  "Deseja continuar?"

	lRetMsg := MsgYesNo(msg, "Bloqueio de Reprocessamento")
	If lRetMsg
		PUTMV("MV_DTBLINT",DTOS(dDtBlqInti))
	EndIf

Return


/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
//	{Protheus.doc} 			 												//	
//																			//
// 	Programa ...: T4FLBDTPV                            Modulo : SIGAFAT     //
//                                                                          //
//  Função responsável por preencher o parametro de data de  do         	//
//	reprocessamentos das integrações INTI									//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa											//
//                                                                          //
//	@since......: 	01/02/2022												//	
//                                                                          //
/*////////////////////////////////////////////////////////////////////////////

User Function T4FLBDTPV()

	Local lRetMsg := .T.
	Local dDtLbPV	:= Ctod("  /  /  ")
	Local cDtAtual	:= SuperGETMV("MV_DTPED")
	Local oComboBox1
	Local cComboBox1


	DEFINE MSDIALOG oDlg1 FROM 080,00 TO 240,240 TITLE "Processamento INTI" PIXEL OF oMainWnd STYLE DS_MODALFRAME STATUS

	@ 014,010 Say "Processando dia   : "
	@ 014,070 Say DTOC(STOD(cDtAtual)) SIZE 100,10 OF oDlg1 PIXEL
	@ 025,010 Say "Próx.Processamento: " SIZE 100,10 OF oDlg1 PIXEL
	@ 025,070 GET dDtLbPV Size 50,2 Of oDlg1 PIXEL

	@ 036,010 Say "Data Fixa? " SIZE 100,10 OF oDlg1 PIXEL
	@ 036,070 MSCOMBOBOX oComboBox1 VAR cComboBox1 ITEMS {"S-SIM","N-NAO"} SIZE 037, 010 OF oDlg1 COLORS 0, 16777215 PIXEL

	DEFINE SBUTTON FROM 050,020 TYPE 1 PIXEL ACTION oDlg1:End() ENABLE OF oDlg1
	DEFINE SButton From 050,060 Type 2 Enable Of oDlg1 Action (lOk := .f., oDlg1:End())

	oDlg1:LESCCLOSE := .F.

	ACTIVATE MSDIALOG oDlg1 CENTERED

	msg := "ATENCAO!"+CHR(13)+CHR(10)
	msg +=  CHR(13)+CHR(10)
	msg += "A rotina automática usará essa data para reprocessar os localizadores."
	msg +=  CHR(13)+CHR(10)
	msg +=  "Deseja continuar?"

	If !Empty(dDtLbPV)

		lRetMsg := MsgYesNo(msg, "Data para Liberação de Reprocessamento")

		If lRetMsg
			PUTMV("MV_DTPED",DTOS(dDtLbPV))
			PUTMV("MV_DTFIXA", LEFT(cComboBox1,1))
		EndIf
	EndIf

Return

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4FDTINTI                            Modulo : SIGAFAT      //
//                                                                          //
//  Função responsável por preencher o parametro de data de inicial de  	//
//	das integrações INTI													//
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	2.00													//
//                                                                          //
//	@author.....:	Rogério Costa											//
//                                                                          //
//	@since......: 	28/09/2020												//	
//                                                                          //
//	@param......:	aParamEmp, array, dados da empresa e filial para 		//
//					processamento											//
/*///////////////////////////////////////////////////////////////////////////

/*/{Protheus.doc} T4FDTINTI
Função responsável por preencher o parametro de data de inicial de  	//
//	das integrações INTI	
	@type.......:	function												
	@version....:	1.00													
	@author.....:	Rogério Costa											
	@since......: 	04/04/2022	
	@param......:	aParamEmp, array, dados da empresa e filial para 		
					processamento											
/*/

User Function T4FDTINTI()

	Local lRetMsg 	:= .T.
	Local cDtAtual	:= SuperGETMV("MV_DTINTI")
	Local dDtBlqInti:= Ctod("  /  /  ")

	DEFINE MSDIALOG oDlg1 FROM 080,00 TO 240,240 TITLE "Data Integrações INTI" PIXEL OF oMainWnd STYLE DS_MODALFRAME STATUS

	@ 014,010 Say "Integrando Dia :"
	@ 014,070 Say DTOC(STOD(cDtAtual))
	@ 025,010 Say "Próx.Integração:" SIZE 100,10 OF oDlg1 PIXEL
	@ 025,070 GET dDtBlqInti Size 50,2 Of oDlg1 Pixel //Valid(VLDATE(dDtBlqInti))

	//DEFINE SBUTTON FROM 050,020 TYPE 1 PIXEL ACTION oDlg1:End() ENABLE OF oDlg1

	Define SButton From 050,010 Type 1 Enable Of oDlg1 Action (lOk := .t., oDlg1:End())
	Define SButton From 050,060 Type 2 Enable Of oDlg1 Action (lOk := .f., oDlg1:End())

	oDlg1:LESCCLOSE := .T.

	ACTIVATE MSDIALOG oDlg1 CENTERED

	msg := "ATENCAO!"+CHR(13)+CHR(10)
	msg +=  CHR(13)+CHR(10)
	msg += "Essa data será considerada para integrar as vendas deste periodo."
	msg +=  CHR(13)+CHR(10)
	msg +=  "Deseja continuar?"

	If !Empty(dDtBlqInti)

		lRetMsg := MsgYesNo(msg, "Atualiza Data de Integração INTI")

		If lRetMsg .And. !Empty(dDtBlqInti)
			PUTMV("MV_DTINTI",DTOS(dDtBlqInti))
		EndIf

	EndIf

Return
