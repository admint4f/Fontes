#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} T4F01INT 
** Função que realiza a alteração da conexão com o Top para conectar a outro banco de dados **
@type function
@version 1.00
@author Rogério Costa
@since 28/09/2020
@param aParamEmp, array, dados da empresa e filial para processamento
/*/

User Function T4F01INT(aParamEmp)

	Local nHndERP   := 0
	Local nHwnd     := -1
	Local cDBNew    := ""	//"MYSQL/ebdb"//"MYSQL/ims_staging_t4f"  (testes) // alterar o alias/dsn para o banco/conexão que está utilizando
	Local cSrvNew   := "10.200.182.17"       // alterar para o ip do DbAccess
	Local nPort  	:= 7896 // alterar para o ip do DbAccess
	Local cErro     := ""
	Local n

	Private cDataIni

	If !Empty(aParamEmp)//(aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U" .OR.
		cEmp:=aParamEmp[1]
		cFil:=aParamEmp[2]
	ELse
		cEmp:='08'
		cFil:='01'
	EndIf

	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4", "ZAD", "ZAF","ZAE"

	cDataIni := GetMV("MV_DTINTI")

	cData	:=	'2021'+"-"+SUBSTR(CDataIni,4,2)+"-"+SUBSTR(CDataIni,1,2)    //'2021-08-'+ cDia

	//PUTMV("MV_DTINTI", dToc(cTod(cDataIni)+1))

	If cEmp =='08'
		//cDBNew    := "MYSQL/byintit4f" //testes
		cDBNew    := "MYSQL/t4fmaster" //produção
	ElseIf cEmp =='33'
		cDBNew    := "MYSQL/byinti"
	EndIf

	aAreaSa1  :=  SA1->(GetArea())

	For n:=1 To 2

		If n == 1

			//------------------------------------
			// Armazena conexão com banco atual
			//------------------------------------

			nHndERP := AdvConnection()

			//------------------------------------
			// Cria uma conexão com um outro banco, outro DBAcces
			//------------------------------------

			nHwnd := TCLink(cDBNew, cSrvNew, nPort)

			if nHwnd >= 0
				T4FQRYFIS(nHndERP,nHwnd,cdata)
			Else
				cErro :=  REPLICATE("*", 5)+ CRLF
				cErro +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - Falha na conexão com o banco de dados externo."+ 'Empresa '+cEmp +'-'
				u_T4F01LOG(cErro)
			End If

		Else
			//------------------------------------
			// Armazena conexão com banco atual
			//------------------------------------

			nHndERP := AdvConnection()

			//------------------------------------
			// Cria uma conexão com um outro banco, outro DBAcces
			//------------------------------------

			nHwnd := TCLink(cDBNew, cSrvNew, nPort)

			if nHwnd >= 0
				T4FQRYFIN(nHndERP,nHwnd,cdata)
			Else
				cErro :=  REPLICATE("*", 5)+ CRLF
				cErro +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - Falha na conexão com o banco de dados externo."+ 'Empresa '+cEmp +'-'
				u_T4F01LOG(cErro)
			End If

		EndIf

	Next n

	RestArea(aAreaSa1)
	dbCloseAll()

	RESET ENVIRONMENT

	//****************************************************************
	//* Chamada da rotina para gerar os pedidos
	//****************************************************************

	RESET ENVIRONMENT
	
	U_T4F01PED()

Return

/*/{Protheus.doc} T4FQRYFIS
Função que gera consulta ao banco de dados externo para obter as vendas e incluir no sistema PROTHEUS. **
@type function
@version 1.00
@author Rogério Costa
@since 28/09/2020
/*/
Static Function T4FQRYFIS(nHndERP,nHwnd,cdata)

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

	/*
	# Consultas VIEWE - protheusFiscal - Criada por Mário - INTI
	# Sem filtro de data, retorna o dia anterior. 
	select protheusFiscal.* from protheusFiscal; 

	# Com filtro de data 
	# Obs.:Filtro de data é uma variável de sessão, ou seja, uma vez definida o filtro de data o mesmo ficará ativo durante a sessão toda 
	select protheusFiscal.* from (SELECT @protheusDateFilter:='2020-03-01') t, protheusFiscal;
	*/

	cQuery:=""
	cQuery+=" select /*+ MAX_EXECUTION_TIME(240000) */ company,module,corpCode,corpSName,corpCNPJ,prodName,prodSName,prodCNPJ,cName,cEmail, " + CRLF
	cQuery+=" cCPF,cAddress,cAddress2,cDistrict,cAddressN,cCity,cState,cCountry,cZipcode,slUID,itemStatus, " + CRLF
	cQuery+=" slID,slSearcher,slDate,itmCanDate,eventName,eventECode,eventEPEP,eventDate,itemType,itemName ," + CRLF
	cQuery+=" ticketId,itemId,itemAmount,itemDiscount,itemTotal,fiscalID,NfRps,NfID,NfRegist,NfVerify " + CRLF
	cQuery+="  From (select @protheusDateFilter:='"+cdata+"') t, " + CRLF
	cQuery+="  protheusFiscal " + CRLF
	cQuery+="  ORDER BY module, cCPF, cName, ticketId  " + CRLF

	TCQUERY (cQuery) NEW ALIAS (cAlias)

	(cAlias)->(DbGotop())

	//(cAlias)->(DbGoTop())

	If Empty((cAlias)->module)
		cErro :=  REPLICATE("*", 5)+ CRLF
		cErro += ' **Query protheusFiscal** - A consulta não retornou dados habilitados para processar, verifique a query destino ***' + cQuery + ' *** Empresa '+ cEmp

		//u_T4F01LOG(cErro) remover comentário
	Else
		While (cAlias)->(!Eof())

			aAdd(aZAD,{alltrim(cEmpresa)								,; 	//	1	EMPRESA
			alltrim((cAlias)->cName)									,;  //	2	NOME
			alltrim((cAlias)->cEmail)									,;  //	3	EMAIL
			alltrim((cAlias)->cCPF)										,;  //	4	CPF
			alltrim((cAlias)->cAddress)+' '+alltrim((cAlias)->cAddressN),;  //	5	END
			alltrim((cAlias)->cAddress2)								,;	//	6	COMPLEMENTO
			alltrim((cAlias)->cDistrict)								,;	//	7	BAIRRO
			alltrim((cAlias)->cCity)									,;	//	8	CIDADE
			alltrim((cAlias)->cState)									,;  //	9	ESTADO
			alltrim((cAlias)->cZipcode)									,;  //	10	CEP
			(cAlias)->slId												,;  //	11	ID VENDA
			(cAlias)->slDate											,;	//	12	DATA VENDA
			(cAlias)->itmCanDate 										,; 	//	13	DATA CANCELAMENTO
			alltrim((cAlias)->eventName)								,;  //	14	NOME EVENTO
			IIf(cEmp=='33','990300002',Upper(alltrim((cAlias)->eventEPEP))) ,; 	//	15	COD EVENTO
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
			(cAlias)->ticketId											,; 	//	29	ID TICKET
			(cAlias)->slSearcher										,;	//	30	LOCALIZADOR VENDA
			(cAlias)->corpCNPJ											,;	//	31  CNPJ EMPRESA CLIENTE
			(cAlias)->corpSName											,;	//	32  NOME EMPRESA CLIENTE
			(cAlias)->slUID											    })	//	33  SLUID

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

	//ChkFile("ZAD",.F.)

	dbSelectArea("ZAD")
	ZAD->(dbSetOrder(1))

	For i:=1 To len(aZAD)

		cCpf := Alltrim(StrTran( aZAD[i][4],".",""))
		cCpf := Alltrim(StrTran( cCpf, "/", "" ))
		cCpf := Alltrim(StrTran( cCpf, "-", "" ))

		cDtVend := DTOS(aZAD[i][12])
		cItemId	:= PADR(aZAD[I][19]		,GetSX3Cache('ZAD_ITEMID','X3_TAMANHO'))
		cEpe	:= PADR(aZAD[I][15]		,GetSX3Cache('ZAD_EPEP','X3_TAMANHO'))
		cTktId	:= PADR(Alltrim(Str(aZAD[I][29])),GetSX3Cache('ZAD_TKTID','X3_TAMANHO'))
		cCpf	:= PADR(cCpf			,GetSX3Cache('ZAD_CPF','X3_TAMANHO'))
		cSluId	:= PADR(aZAD[I][33]		,GetSX3Cache('ZAD_SLUID','X3_TAMANHO'))
		cItemTp	:= PADR(aZAD[I][17]		,GetSX3Cache('ZAD_ITTYPE','X3_TAMANHO'))

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
		
		//ZAD_FILIAL+DTOS(ZAD_DTVEND)+ZAD_ITEMID+ZAD_EPEP+ZAD_TKTID+ZAD_CPF+ZAD_SLUID+ZAD_ITTYPE

//		If !(ZAD->(MsSeek(xFilial("ZAD")+cDtVend+cItemId+cEpe+cTktId+cCpf+cSluId+cItemTp+cTpTran)))
		
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
			ZAD->ZAD_NFINTI := If(Valtype(aZAD[i][28])=='N',ALLTRIM(STR(aZAD[i][28])),aZAD[i][28])
			ZAD->ZAD_DTIMP  := DDATABASE
			ZAD->ZAD_DTVEND	:= aZAD[i][12]
			ZAD->ZAD_DTCANC	:= fwDateTimeToLocal(aZAD[i][13])[1] //converte data ISO-8601 para uma data __/__/__
			ZAD->ZAD_NOME   := UPPER(Alltrim(aZAD[i][2]))
			ZAD->ZAD_CPF    := cCpf
			ZAD->ZAD_END    := UPPER(cAddress+' '+cAddress2)
			ZAD->ZAD_BAIRRO := UPPER(cDistrict)
			ZAD->ZAD_CIDADE := UPPER(cCity)
			ZAD->ZAD_EST    := UPPER(Alltrim(aZAD[i][9]))
			ZAD->ZAD_CEP    := STRTRAN(Alltrim(aZAD[i][10]),'-','')
			ZAD->ZAD_TPAGTO	:='BYINTI'
			ZAD->ZAD_SEARCH	:= aZAD[i][30]
			ZAD->ZAD_CNPJCL	:= cCNPJCli
			ZAD->ZAD_NOMECL	:= aZAD[i][32]

			nVAlItem	:=	If (Valtype(aZAD[i][22])=='C',Val(aZAD[i][22]),aZAD[i][22])

			Do Case

			Case cItemType=='Ingresso'
				ZAD->ZAD_TPITEM := '1' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript,8=Doacao
				ZAD->ZAD_VLRTKT := nVAlItem

			Case (cItemType == 'Subscript' .Or. cItemType == 'Assinatura'                    )
				ZAD->ZAD_TPITEM := '7' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript,8=Doacao
				ZAD->ZAD_VLRTKT := nVAlItem

			Case cItemType=='Doacao'
				ZAD->ZAD_VLRTKT := nVAlItem
				ZAD->ZAD_TPITEM := '8' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript; 8=Doacao

			Case cItemType=='Tx Conveniencia'
				ZAD->ZAD_VLRTXC := nVAlItem
				ZAD->ZAD_TPITEM := '2' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

			Case cItemType=='Tx Entrega'
				ZAD->ZAD_VLENTR := nVAlItem
				ZAD->ZAD_TPITEM := '4' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

			Case cItemType== 'Ass: Tx Entrega'
				ZAD->ZAD_VLRTXS := nVAlItem
				ZAD->ZAD_TPITEM := '4' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

			Case cItemType=='Valor Extra'
				ZAD->ZAD_VLRTXI := nVAlItem
				ZAD->ZAD_TPITEM := '3' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

			Case cItemType=='Cortesia'
				ZAD->ZAD_VLRTXI := nVAlItem
				ZAD->ZAD_TPITEM := '5' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

			Case cItemType=='Socio'
				ZAD->ZAD_VLRSOC := nVAlItem
				ZAD->ZAD_TPITEM := '6' //1=Ingresso;2=Tx.Conv.;3=Tx.Servio;4=Tx.Entrega;5=Cortesia; 6= Scios; 7=Subscript

			End Case

			If (nVAlItem == 0)
				ZAD->ZAD_STATUS := "4"
				ZAD->ZAD_OBS	:= Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+"-"+ Alltrim(aZAD[i][17])+"-"+Alltrim(cItemName)
			Else
				ZAD->ZAD_STATUS := "1"
			EndIf

			If Empty(aZAD[i][13])
				ZAD->ZAD_TPTRAN:='1'
			Else
				ZAD->ZAD_TPTRAN:='2'
			EndIf

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
			ZAD->ZAD_TKTID	:= Alltrim(Str(aZAD[i][29]))
			ZAD->ZAD_ITTYPE := aZAD[i][17]
			ZAD->ZAD_SLUID 	:= aZAD[i][33]

			ZAD->(MsUnlock())

			//Realiza o cadastro do cliente caso no exista no Protheus
			dbSelectArea("SA1")
			SA1->(dbSetOrder(3))
			If SA1->(!MsSeek(xFilial("SA1") + cCpf))

				Begin Transaction
					aParam := u_T4F01CLI(UPPER(Alltrim(aZAD[i][2])),;
						cCpf,;
						UPPER(cAddress+' '+cAddress2),;
						UPPER(cDistrict),;
						UPPER(cCity),;
						UPPER(Alltrim(aZAD[i][9])),;
						STRTRAN(Alltrim(aZAD[i][10]),'-',''))

				End Transaction
			EndIf

		EndIf

		/*
		If Select(cAliasZ) > 0
			(cAliasZ)->( DbCloseArea() )
		EndIf
		*/

	Next i

	dbCloseAll()

Return

/*/{Protheus.doc} T4FQRYFIN
Função que gera consulta ao banco de dados externo para obter as transações financeiras das vendas e incluir no sistema PROTHEUS. **
@type function
@version 1.00
@author Rogério Costa
/*/
Static Function T4FQRYFIN(nHndERP,nHwnd,cdata)

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

	/*
	# Consultas VIEWE - protheusFiscal - Criada por Mário - INTI
	# Sem filtro de data, retorna o dia anterior. 
	select protheusFiscal.* from protheusFiscal; 

	# Com filtro de data 
	# Obs.:Filtro de data é uma variável de sessão, ou seja, uma vez definida o filtro de data o mesmo ficará ativo durante a sessão toda 
	select protheusFiscal.* from (SELECT @protheusDateFilter:='2020-03-01') t, protheusFiscal;
	*/

	cQueryFin	:=""
	cQueryFin	+=" select /*+ MAX_EXECUTION_TIME(240000) */ protheusFinanceiro.* " + CRLF
	cQueryFin	+=" from (SELECT @protheusDateFilter:='"+cdata+"') t, protheusFinanceiro" + CRLF
	cQueryFin	+="  ORDER BY slUID, slSearcher  " + CRLF

	TCQUERY (cQueryFin) NEW ALIAS (cAliasFIN)

	(cAliasFIN)->(DbGotop())

	If Empty((cAliasFIN)->module)
		cErro :=  REPLICATE("*", 5)+ CRLF
		cErro += ' **Query protheusFinanceiro** - A consulta não retornou dados habilitados para processar, verifique a query destino ***' + cQueryFin + ' *** Empresa '+ cEmp

		u_T4F01LOG(cErro)

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
			Upper(alltrim((cAliasFIN)->eventePep)) 							    ,; 	//	15	COD EVENTO
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

	For J:=1 To len(aZAF)

		cTransId:= PADR(Alltrim(Str(aZAF[j][27]))	,GetSX3Cache('ZAF_NUMERO','X3_TAMANHO'))
		cSlU	:= PADR(aZAF[J][09]					,GetSX3Cache('ZAF_SLUID' ,'X3_TAMANHO'))
		cTpZAF	:= PADR(Alltrim(aZAF[j][03])		,GetSX3Cache('ZAF_TIPO' ,'X3_TAMANHO'))
		cEpepZAF:= PADR(Alltrim(aZAF[j][15])		,GetSX3Cache('ZAF_EPEP' ,'X3_TAMANHO'))
		cFinId	:= PADR(Alltrim(STR(aZAF[j][28]))		,GetSX3Cache('ZAF_FINID' ,'X3_TAMANHO'))


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

			ZAF->(MsUnlock())

		EndIf

	Next J

	dbCloseAll()

Return


/*/{Protheus.doc} T4F01PED
Função criada para inclusão de pedidos de vendas referente a vendas da plataforma INTi. **
@type Function
@param cEmp,charactere,empresa
@param cFil,charactere,filial
@version 1.00
@author Rogério Costa
@since 02/10/2020
/*/

User Function T4F01PED()

	Local cNumPed    := ""		// Número do Pedido de Vendas
	Local cA1Cod     := ""  	// Código do Cliente
	Local cA1Cpf   	 := ""
	Local cA1Loja    := "" 		// Loja do Cliente
	Local cB1Cod     := "" 		// Código do Produto
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
	Local aLinha     := {}
	Local cQuery2    := ''
	Local cQuery3    := ''
	Local cAliasZad  := GetNextAlias()
	Local cSemCPF  	 := GetNextAlias()
	Local cAliasNPed  := GetNextAlias()
	Local cAliasWallet  := GetNextAlias()
	Local cItem      := ' '
	Local nI         := 0
	Local cEpep		 :=''
	Local nValTkt	 := 0
	Local nValWallet := 0
	Local cMarca 	 := " "
	Local cTPRECB	:=" "
	Local lAuto		:= .F.

	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .F.
	Private cDtINTI
	Private aParamBox		:= {}
	Private aRet			:= {}
	

	//****************************************************************
	//* Abertura do ambiente
	//****************************************************************
	/*
	If  TYPE("cEmpant") != "U" 
		cEmp	:= cEmpant
		cFil	:= cFilant

		aAdd(aParamBox,{1,"Data para Reprocessar",DDATABASE           ,"","","   ","",80,.F.})  //01
		
		If !ParamBox(aParamBox, "Processamento Manual Vendas", aRet)
			Return Nil
		Else
			cDtINTI	:= aRet[1]
		End If
	Else

		cEmp:='08'
		cFil:='01'
		lAuto := .T.

		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4","ZAD","ZAF"

		//nDias := GetMV("MV_DTINTI")

		cDtINTI := DTOS(CTOD(GetMV("MV_DTINTI")))

	EndIf
*/
	cEmp:='08'
	cFil:='01'
//	lAuto := .T.

		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4","ZAD","ZAF"

		//nDias := GetMV("MV_DTINTI")

	cDtINTI := DTOS(CTOD(GetMV("MV_DTINTI")))
	
	cMarca 	 := GetMark()

	SA1->(dbSetOrder(3)) //cnpj
	SB1->(dbSetOrder(1))
	SE4->(dbSetOrder(1))
	SF4->(dbSetOrder(1))
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

	cQryNumPed := " SELECT MAX(C5_NUM) NUM " + CRLF
	cQryNumPed += " FROM " +RetSqlName("SC5") + CRLF
	cQryNumPed += " WHERE D_E_L_E_T_ =' ' " + CRLF

	TCQUERY (cQryNumPed) NEW ALIAS (cAliasNPed)

	(cAliasNPed)->( DbGotop() )

	cNumPed    :=	SOMA1((cAliasNPed)->NUM)

	If Select(cAliasNPed) > 0
		(cAliasNPed)->( DbCloseArea() )
	EndIf


	//****************************************//
	//MARCA REGISTROS SEM CPF PARA PROCESSAR  //
	//****************************************//

	cQryUPD	:= " UPDATE " +RetSqlName("ZAD") + CRLF
	cQryUPD	+= " SET ZAD_MARK =  '" + cMarca +"'" + CRLF
	cQryUPD	+= " WHERE ZAD_SLUID IN " + CRLF

	cQryUPD	+= " 	(SELECT ZAF_SLUID	" + CRLF
	cQryUPD	+= " 	FROM " +RetSqlName("ZAF")+" ZAF	" + CRLF

	cQryUPD	+= " 		WHERE ZAF_TIPO = 'Venda' " + CRLF

	If cEmp == '33' // INTI NÃO CONTABILIZA ESSES MOVIMENTOS
		cQryUPD	+= " 		AND ZAF_TPPGTO <> 'Bonificado          '		" + CRLF
		cQryUPD	+= " 	AND  ZAF_TPRECB = 'Indireto' " + CRLF
		cQryUPD	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    " + CRLF
	EndIf

	cQryUPD	+= " 		AND ZAF.D_E_L_E_T_ = ' '	" + CRLF
	cQryUPD	+= " 		AND ZAF_DTVEND BETWEEN '"+cDtINTI+"' AND '"+cDtINTI+"' " + CRLF
	cQryUPD	+= " 		GROUP BY ZAF_SLUID)			" + CRLF

	cQryUPD	+= " AND ZAD_FILIAL='01' " + CRLF
	cQryUPD	+= " AND ZAD_DTVEND BETWEEN '" + cDtINTI +"' AND " + "'"+cDtINTI +"'" + CRLF
	cQryUPD	+= " AND ZAD_STATUS = '1' " + CRLF
	cQryUPD	+= " AND ZAD_TPTRAN = '1' " + CRLF
	cQryUPD	+= " AND ZAD_MARK = ' ' " + CRLF
	cQryUPD	+= " AND ZAD_CPF = ' ' " + CRLF
	cQryUPD	+= " AND ZAD_TPITEM IN ('1','2','3','4','6','7','8') " + CRLF
	cQryUPD	+= " AND ZAD_DTVEND BETWEEN '"+cDtINTI+"' AND '"+cDtINTI+"' " + CRLF
	cQryUPD	+= " AND ZAD_CPF = ' ' " + CRLF
	cQryUPD	+= " AND ZAD_MARK = ' ' " + CRLF
	cQryUPD	+= " AND D_E_L_E_T_ = ' ' " + CRLF

	nStatus := TcSqlExec(cQryUPD)
	DBCommit()

	If (nStatus < 0)

		cErro :=  REPLICATE("*", 5)+ CRLF
		cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
		u_T4F01LOG(cErro)

	EndIf

	//*******************************************//
	//PROCESSA OS REGISTROS SEM CPF				 //
	//*******************************************//
	cQuery3:= "SELECT ZAD_SEARCH,ZAD_SLUID,ZAD_CPF,ZAD_DTVEND, ZAD_EMP ZAD_EMP, ZAD_FILIAL ZAD_FILIAL, ZAD_TPITEM ZAD_TPITEM, COUNT(*) QTD, ZAD_TPAGTO, ZAD_EPEP ZAD_EPEP, SUM(ZAD_VLRTKT) ZAD_VLRTKT, SUM(ZAD_VLRTXO) ZAD_VLRTXO, SUM(ZAD_VLRTXS) ZAD_VLRTXS," + CRLF
	cQuery3+= " SUM(ZAD_VLRTXC) ZAD_VLRTXC,SUM(ZAD_VLRTXI) ZAD_VLRTXI,SUM(ZAD_VLRXCA) ZAD_VLRXCA, SUM(ZAD_VLRSOC) ZAD_VLRSOC,SUM(ZAD_VLENTR) ZAD_VLENTR"+ CRLF
	cQuery3+= " FROM " +RetSqlName("ZAD") + CRLF
	cQuery3+= " WHERE ZAD_FILIAL='01' " + CRLF
	cQuery3+= " AND ZAD_STATUS = '1' " + CRLF
	cQuery3+= " AND ZAD_TPTRAN = '1' " + CRLF
	cQuery3+= " AND ZAD_CPF = ' ' " + CRLF
	cQuery3+= " AND ZAD_TPITEM IN ('1','2','3','4','6','7','8') " + CRLF  //1=Ingresso;2=Tx.Conv.;3=Tx.Serviço;4=Tx.Entrega;5=Cortesia; 6= Sócios; 7=Subscript,8=Doacao
	cQuery3+= " AND ZAD_MARK = '"+cMarca+ "' " + CRLF
	cQuery3+= " AND D_E_L_E_T_ = ' ' " + CRLF
	cQuery3+= " GROUP BY ZAD_SEARCH, ZAD_SLUID, ZAD_CPF,ZAD_DTVEND, ZAD_EMP , ZAD_FILIAL, ZAD_TPITEM, ZAD_EPEP,ZAD_TPAGTO " + CRLF
	cQuery3+= " ORDER BY ZAD_CPF,ZAD_SLUID,ZAD_TPITEM  " + CRLF

	TCQUERY (cQuery3) NEW ALIAS (cSemCPF)

	(cSemCPF)->( DbGotop() )

	If !Empty((cSemCPF)->ZAD_FILIAL)

		DDATABASE	:=	STOD((cSemCPF)->ZAD_DTVEND)

		//	cNumPed    :=GetSXENum("SC5","C5_NUM")

		While (cSemCPF)->(!Eof())

			nPos:=AT( "/",(cSemCPF)->ZAD_EPEP)

			If ZAF->(MsSeek(xFilial("ZAF") + (cSemCPF)->ZAD_SLUID+(cSemCPF)->ZAD_SEARCH))
				cTPRECB	 := ZAF->ZAF_TPRECB
			EndIf

			If nPos > 0
				cEpep:=substr((cSemCPF)->ZAD_EPEP,1,nPos-1)
			Else
				cEpep:=(cSemCPF)->ZAD_EPEP
			EndIf

			If ZAE->(MsSeek(cFilZAE + cEpep)) .AND. CTD->(MsSeek(cFilCTD + cEpep))

				//If (((cSemCPF)->ZAD_VLRTKT > 0 .OR. (cSemCPF)->ZAD_VLRTXO > 0 .OR. (cSemCPF)->ZAD_VLRTXS > 0 .OR.(cSemCPF)->ZAD_VLRTXC > 0 .OR. (cSemCPF)->ZAD_VLRTXI > 0 .OR. (cSemCPF)->ZAD_VLRSOC > 0 );
				If (((cSemCPF)->ZAD_VLRTKT > 0 .OR. (cSemCPF)->ZAD_VLRTXO > 0 .OR. (cSemCPF)->ZAD_VLRTXS > 0 .OR.(cSemCPF)->ZAD_VLRTXC > 0 .OR. (cSemCPF)->ZAD_VLRTXI > 0 .OR. (cSemCPF)->ZAD_VLRSOC > 0 .OR. (cSemCPF)->ZAD_VLENTR > 0 );
						.AND. !Empty((cSemCPF)->ZAD_EPEP))

					//****************************************************************
					//* Inclusao - INÍCIO
					//****************************************************************
					SA1->(dbSetOrder(1))
					If SA1->(!MsSeek(cFilSA1 + 'CONSUM'))
						cMsgLog +=  REPLICATE("*", 5)+ CRLF
						cMsgLog += "Não existe o cadastro para cliente sem CPF CONSUM: " + CRLF
					Else
						cA1Cod  :=  SA1->A1_COD
						cA1Loja :=  SA1->A1_LOJA
						cBlqCli :=  SA1->A1_MSBLQL
					End If

					If (cBlqCli=="2") .OR. (cBlqCli==" ")

						If Len(aCabec) == 0

							aadd(aCabec,cNumPed				 ) 	//1
							aadd(aCabec,"N"	   				 )	//2
							aadd(aCabec,cA1Cod				 )	//3
							aadd(aCabec,cA1Loja	 			 )	//4
							aadd(aCabec,cA1Loja	 			 )	//5
							aadd(aCabec,cE4Codigo			 )	//6
							aadd(aCabec,"500302"			 )	//7
							aadd(aCabec,(cSemCPF)->ZAD_TPAGTO)	//8
							aadd(aCabec,DDATABASE			 )	//9
							aadd(aCabec,'SEM CPF'					 )	//10
							aadd(aCabec,''					 )	//11

							cItem:='01'
						EndIf

						//****************************************************************
						//- Busca pagamentos feitos com INTI Wallet
						//****************************************************************

						If Select(cAliasWallet) > 0
							(cAliasWallet)->( DbCloseArea() )
						EndIf

						cQryWallet := " SELECT ZAF_SLUID ,SUM(ZAF_VLRTRA) ZAF_VLRTRA " + CRLF
						cQryWallet += " FROM ( " + CRLF
						cQryWallet += " SELECT ZAF_SLUID, ZAF_VLRTRA  " + CRLF
						cQryWallet += " FROM " +RetSqlName("ZAF") + CRLF

						cQryWallet += " WHERE ZAF_TPRECB ='Indireto' " + CRLF

						cQryWallet += " AND ZAF_TIPO ='Venda' " + CRLF
						cQryWallet += " AND ZAF_TPPGTO <> 'Bonificado'  " + CRLF
						cQryWallet += " AND ZAF_TPPGTO = 'INTI Wallet' " + CRLF
						cQryWallet += " AND ZAF_SLUID = '" + (cSemCPF)->ZAD_SLUID + "'"+ CRLF
						cQryWallet += " AND ZAF_DTVEND BETWEEN '"+ cDtINTI + "'"+ " AND '" + cDtINTI + "'" + CRLF
						cQryWallet += " AND D_E_L_E_T_ =' ' " + CRLF
						cQryWallet += " GROUP BY ZAF_SLUID, ZAF_VLRTRA) " + CRLF
						cQryWallet += " GROUP BY ZAF_SLUID " + CRLF

						TCQUERY (cQryWallet) NEW ALIAS (cAliasWallet)

						(cAliasWallet)->( DbGotop() )

						If (cEmp == '33' .And. Alltrim(cTPRECB) == 'Indireto')

							nValTkt := (cSemCPF)->ZAD_VLRTKT - (cAliasWallet)->ZAF_VLRTRA

						ElseIf (cEmp == '33' .And. Alltrim(cTPRECB) == 'Direto')

							nValTkt := 0

						ElseIf cEmp == '08'
							nValTkt 	:= 	(cSemCPF)->ZAD_VLRTKT
							nValWallet	:=	0 //(cAliasWallet)->ZAF_VLRTRA ESTÁ DUPLICANDO NA T4F
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
							aadd(aLinha,(cSemCPF)->ZAD_SLUID)

							aadd(aItens, aLinha)

						EndIf

						If nValTkt > 0

							cB1Cod  :=  ZAE->ZAE_PRDTKT

							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
								cF4TES := SB1->B1_TS
							End If

							aLinha := {}
							aadd(aLinha,cItem)
							aadd(aLinha,cB1Cod)
							aadd(aLinha,(cSemCPF)->QTD)
							aadd(aLinha,nValTkt/(cSemCPF)->QTD)
							aadd(aLinha,nValTkt/(cSemCPF)->QTD)
							aadd(aLinha,nValTkt)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cSemCPF)->ZAD_SLUID)

							aadd(aItens, aLinha)

						ElseIf (cSemCPF)->ZAD_VLRTXO > 0

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
							aadd(aLinha,(cSemCPF)->QTD)
							aadd(aLinha,(cSemCPF)->(ZAD_VLRTXO/QTD))
							aadd(aLinha,(cSemCPF)->(ZAD_VLRTXO/QTD))
							aadd(aLinha,(cSemCPF)->ZAD_VLRTXO)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cSemCPF)->ZAD_SLUID)

							aadd(aItens, aLinha)

						ElseIf (cSemCPF)->ZAD_VLRTXS > 0

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
							aadd(aLinha,(cSemCPF)->QTD)
							aadd(aLinha,(cSemCPF)->(ZAD_VLRTXS/QTD))
							aadd(aLinha,(cSemCPF)->(ZAD_VLRTXS/QTD))
							aadd(aLinha,(cSemCPF)->ZAD_VLRTXS)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cSemCPF)->ZAD_SLUID)

							aadd(aItens, aLinha)

						ElseIf (cSemCPF)->ZAD_VLRTXC > 0

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
							aadd(aLinha,(cSemCPF)->QTD)
							aadd(aLinha,(cSemCPF)->(ZAD_VLRTXC/QTD))
							aadd(aLinha,(cSemCPF)->(ZAD_VLRTXC/QTD))
							aadd(aLinha,(cSemCPF)->ZAD_VLRTXC)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cSemCPF)->ZAD_SLUID)

							aadd(aItens, aLinha)

						ElseIf (cSemCPF)->ZAD_VLRTXI > 0

							cB1Cod:=ZAE->ZAE_PRDTXI

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
							aadd(aLinha,(cSemCPF)->(ZAD_VLRTXI/QTD))
							aadd(aLinha,(cSemCPF)->(ZAD_VLRTXI/QTD))
							aadd(aLinha,(cSemCPF)->ZAD_VLRTXI)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cSemCPF)->ZAD_SLUID)

							aadd(aItens, aLinha)

						ELseIf (cSemCPF)->ZAD_VLRXCA > 0

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
							aadd(aLinha,(cSemCPF)->QTD)
							aadd(aLinha,(cSemCPF)->(ZAD_VLRXCA/QTD))
							aadd(aLinha,(cSemCPF)->(ZAD_VLRXCA/QTD))
							aadd(aLinha,(cSemCPF)->ZAD_VLRXCA)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cSemCPF)->ZAD_SLUID)

						ELseIf (cSemCPF)->ZAD_VLRSOC > 0

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
							aadd(aLinha,(cSemCPF)->QTD)
							aadd(aLinha,(cSemCPF)->(ZAD_VLRSOC/QTD))
							aadd(aLinha,(cSemCPF)->(ZAD_VLRSOC/QTD))
							aadd(aLinha,(cSemCPF)->ZAD_VLRSOC)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cSemCPF)->ZAD_SLUID)

							aadd(aItens, aLinha)
						
						ELseIf (cSemCPF)->ZAD_VLENTR > 0

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
							aadd(aLinha,(cSemCPF)->QTD)
							aadd(aLinha,(cSemCPF)->(ZAD_VLENTR/QTD))
							aadd(aLinha,(cSemCPF)->(ZAD_VLENTR/QTD))
							aadd(aLinha,(cSemCPF)->ZAD_VLENTR)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cSemCPF)->ZAD_SLUID)

							aadd(aItens, aLinha)


						EndIf

						/*ALIMENTAÇÃO DE ARRAY PARA RODAR VIA EXECAUTO
						If Len(aCabec) == 0
									aadd(aCabec, {"C5_NUM"    ,  cNumPed                   , Nil})
									aadd(aCabec, {"C5_TIPO"   ,  "N"                    , Nil})
									aadd(aCabec, {"C5_CLIENTE", cA1Cod                  , Nil})
									aadd(aCabec, {"C5_LOJACLI", cA1Loja                 , Nil})
									aadd(aCabec, {"C5_LOJAENT", cA1Loja                 , Nil})
									aadd(aCabec, {"C5_CONDPAG", cE4Codigo               , Nil})
									aadd(aCabec, {"C5_NATUREZ", "500302"                , Nil})
									aadd(aCabec, {"C5_MENNOTA", "PV INTI"        		, Nil})
									aadd(aCabec, {"C5_PAGTO"  , (cSemCPF)->ZAD_TPAGTO 	, Nil})

									cItem:='01'
						EndIf

								//****************************************************************
								//- Informando os dados do item do Pedido de Venda
								//****************************************************************
						If (cSemCPF)->ZAD_VLRTKT > 0

									cB1Cod  :=  ZAE->ZAE_PRDTKT

							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
										cF4TES := SB1->B1_TS
							End If

									aLinha := {}
									aadd(aLinha,{"C6_ITEM"    ,  cItem			       	,Nil})
									aadd(aLinha,{"C6_PRODUTO" , cB1Cod                 	,Nil})
									aadd(aLinha,{"C6_QTDVEN"  , (cSemCPF)->QTD         	,Nil})
									aadd(aLinha,{"C6_PRCVEN"  , (cSemCPF)->(ZAD_VLRTKT/QTD)	,Nil})
									aadd(aLinha,{"C6_PRUNIT"  , (cSemCPF)->(ZAD_VLRTKT/QTD)	,Nil})
									aadd(aLinha,{"C6_VALOR"   , (cSemCPF)->ZAD_VLRTKT	,Nil})
									aadd(aLinha,{"C6_TES"     , cF4TES                 	,Nil})
									aadd(aLinha,{"C6_ITEMCC"  , cEpep				   	,Nil})

									aadd(aItens, aLinha)

						ElseIf (cSemCPF)->ZAD_VLRTXO > 0

									cB1Cod:=ZAE->ZAE_PRDTXO

							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
										cF4TES := SB1->B1_TS
							End If

									aLinha := {}
									aadd(aLinha,{"C6_ITEM"    , cItem				   	,Nil})
									aadd(aLinha,{"C6_PRODUTO" , cB1Cod                 	,Nil})
									aadd(aLinha,{"C6_QTDVEN"  , (cSemCPF)->QTD         	,Nil})
									aadd(aLinha,{"C6_PRCVEN"  , (cSemCPF)->(ZAD_VLRTXO/QTD)	,Nil})
									aadd(aLinha,{"C6_PRUNIT"  , (cSemCPF)->(ZAD_VLRTXO/QTD)	,Nil})
									aadd(aLinha,{"C6_VALOR"   , (cSemCPF)->ZAD_VLRTXO	,Nil})
									aadd(aLinha,{"C6_TES"     , cF4TES                 	,Nil})
									aadd(aLinha,{"C6_ITEMCC"  , cEpep				   	,Nil})

									aadd(aItens, aLinha)

						ElseIf (cSemCPF)->ZAD_VLRTXS > 0

									cB1Cod:=ZAE->ZAE_PRDTXS

							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
										cF4TES := SB1->B1_TS
							End If

									aLinha := {}
									aadd(aLinha,{"C6_ITEM"    , cItem			       	,Nil})
									aadd(aLinha,{"C6_PRODUTO" , cB1Cod                 	,Nil})
									aadd(aLinha,{"C6_QTDVEN"  , (cSemCPF)->QTD			,Nil})
									aadd(aLinha,{"C6_PRCVEN"  , (cSemCPF)->(ZAD_VLRTXS/QTD)	,Nil})
									aadd(aLinha,{"C6_PRUNIT"  , (cSemCPF)->(ZAD_VLRTXS/QTD)	,Nil})
									aadd(aLinha,{"C6_VALOR"   , (cSemCPF)->ZAD_VLRTXS	,Nil})
									aadd(aLinha,{"C6_TES"     , cF4TES                 	,Nil})
									aadd(aLinha,{"C6_ITEMCC"  , cEpep				   	,Nil})

									aadd(aItens, aLinha)

						ElseIf (cSemCPF)->ZAD_VLRTXC > 0

									cB1Cod:=ZAE->ZAE_PRDTXC

							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
										cF4TES := SB1->B1_TS
							End If

									aLinha := {}
									aadd(aLinha,{"C6_ITEM"    , cItem				   	,Nil})
									aadd(aLinha,{"C6_PRODUTO" , cB1Cod                 	,Nil})
									aadd(aLinha,{"C6_QTDVEN"  , (cSemCPF)->QTD                      	,Nil})
									aadd(aLinha,{"C6_PRCVEN"  , (cSemCPF)->(ZAD_VLRTXC/QTD)	,Nil})
									aadd(aLinha,{"C6_PRUNIT"  , (cSemCPF)->(ZAD_VLRTXC/QTD)	,Nil})
									aadd(aLinha,{"C6_VALOR"   , (cSemCPF)->ZAD_VLRTXC	,Nil})
									aadd(aLinha,{"C6_TES"     , cF4TES                 	,Nil})
									aadd(aLinha,{"C6_ITEMCC"  , cEpep				   	,Nil})

									aadd(aItens, aLinha)

						ElseIf (cSemCPF)->ZAD_VLRTXI > 0

									cB1Cod:=ZAE->ZAE_PRDTXI

							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
										cF4TES := SB1->B1_TS
							End If

									aLinha := {}
									aadd(aLinha,{"C6_ITEM"    , cItem       			,Nil})
									aadd(aLinha,{"C6_PRODUTO" , cB1Cod                 	,Nil})
									aadd(aLinha,{"C6_QTDVEN"  , (cSemCPF)->QTD                      	,Nil})
									aadd(aLinha,{"C6_PRCVEN"  , (cSemCPF)->(ZAD_VLRTXI/QTD)	,Nil})
									aadd(aLinha,{"C6_PRUNIT"  , (cSemCPF)->(ZAD_VLRTXI/QTD)	,Nil})
									aadd(aLinha,{"C6_VALOR"   , (cSemCPF)->ZAD_VLRTXI	,Nil})
									aadd(aLinha,{"C6_TES"     , cF4TES                 	,Nil})
									aadd(aLinha,{"C6_ITEMCC"  , cEpep				   	,Nil})

									aadd(aItens, aLinha)

						ELseIf (cSemCPF)->ZAD_VLRXCA > 0

									cB1Cod:=ZAE->ZAE_PDTXCA

							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
										cF4TES := SB1->B1_TS
							End If

									aLinha := {}
									aadd(aLinha,{"C6_ITEM"    , cItem			       	,Nil})
									aadd(aLinha,{"C6_PRODUTO" , cB1Cod                 	,Nil})
									aadd(aLinha,{"C6_QTDVEN"  , (cSemCPF)->QTD                      	,Nil})
									aadd(aLinha,{"C6_PRCVEN"  , (cSemCPF)->(ZAD_VLRXCA/QTD)	,Nil})
									aadd(aLinha,{"C6_PRUNIT"  , (cSemCPF)->(ZAD_VLRXCA/QTD)	,Nil})
									aadd(aLinha,{"C6_VALOR"   , (cSemCPF)->ZAD_VLRXCA	,Nil})
									aadd(aLinha,{"C6_TES"     , cF4TES                 	,Nil})
									aadd(aLinha,{"C6_ITEMCC"  , cEpep				   	,Nil})

									aadd(aItens, aLinha)

						EndIf
						*/

						cItem := Soma1(cItem)
						(cSemCPF)->(DbSkip())

					Else

						cMsgLog+=  REPLICATE("*", 5)+ CRLF
						cMsgLog+=  Alltrim(DTOC(DDATABASE)) + "-" + Alltrim(Time())+'- Cliente bloqueado para uso:' + cA1Cod+'-'+cA1Loja +'Empresa:' + cEmp

					EndIf
				Else
					cMsgLog	+=  REPLICATE("*", 5)+ CRLF
					cMsgLog +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - Item sem valor " + Alltrim((cSemCPF)->ZAD_EPEP) +'Empresa:' + cEmp

					cItem := Soma1(cItem)
					(cSemCPF)->(DbSkip())
				EndIf

			ELse
				cMsgLog	+=  REPLICATE("*", 5)+ CRLF
				cMsgLog +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - EPEP não cadastrado na tabela ZAE ou CTD:" + Alltrim((cSemCPF)->ZAD_EPEP) +'Empresa:' + cEmp

				cItem := Soma1(cItem)
				(cSemCPF)->(DbSkip())
			EndIf
		EndDo

		If Len(aItens) > 0
			nOpcX := 3

			Begin Transaction

				lRet	:=	T4FGRVPED(aCabec,aItens)

			End Transaction


			//MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)

			If lRet

				For nI	:=	1 To Len(aItens)
					cTmp	:=	"cTmp"

					cQuery4	:= " UPDATE " +RetSqlName("ZAD") + CRLF
					cQuery4	+= " SET ZAD_PEDIDO = '" + cNumPed +"'" + CRLF
					cQuery4	+= ",ZAD_DTPV     = '" + DTOC(DDATABASE) +"'" + CRLF
					cQuery4	+= ",ZAD_HREMIS  = '"+ TIME() +"'" + CRLF
					cQuery4	+= ",ZAD_STATUS   = '2' " + CRLF
					cQuery4	+= " WHERE ZAD_FILIAL='01' " + CRLF
					cQuery4	+= " AND ZAD_EPEP = '"+aItens[nI][8]+"'" + CRLF
					cQuery4	+= " AND ZAD_SLUID = '"+aItens[nI][9]+"'" + CRLF
					cQuery4	+= " AND ZAD_MARK = '"+cMarca+"'" + CRLF
					cQuery4	+= " AND ZAD_STATUS = '1' " + CRLF
					cQuery4	+= " AND ZAD_TPTRAN = '1' " + CRLF
					cQuery4	+= " AND ZAD_CPF = ' ' " + CRLF

					TcSqlExec(cQuery4)

					DBCommit()

				Next nI

				cNumPed    :=	SOMA1(cNumPed)

				aItens:={}
				aCabec   := {}

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
		cMsgLog:=  REPLICATE("*", 5)+ CRLF
		cMsgLog+=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+"-"
		cMsgLog+= ' **Query Sem CPF** - A consulta não retornou dados habilitados para processar, verifique tabela ZAD, status = 1 - Empresa ' + cEmp

		u_T4F01LOG(cMsgLog)
		/*
		cTO:="rogerio.costa@crmservices.com.br"
		U_EnvEmail(cTO,"Log Integração INTI "+ dtoc(MsDate()),cMsgLog,{},.F.)
		*/
	EndIf

	If Select(cSemCPF) > 0
		(cSemCPF)->( DbCloseArea() )
	EndIf


	//****************************************//
	//MARCA REGISTROS COM CPF PARA PROCESSAR  //
	//****************************************//

	cQryUPD	:= " UPDATE " +RetSqlName("ZAD") + CRLF
	cQryUPD	+= " SET ZAD_MARK =  '" + cMarca +"'" + CRLF
	cQryUPD	+= " WHERE ZAD_CPF IN " + CRLF

	cQryUPD	+= " (SELECT ZAD_CPF FROM

	cQryUPD	+= " 	(SELECT ZAD_CPF " + CRLF
	cQryUPD	+= " 		FROM " +RetSqlName("ZAD")+" ZAD, "+ RetSqlName("ZAF") +" ZAF " + CRLF
	cQryUPD	+= " 		WHERE ZAD_STATUS ='1' " + CRLF
	cQryUPD	+= " 		AND ZAD_TPTRAN = '1' " + CRLF
	cQryUPD	+= " 		AND ZAD_TPITEM IN ('1','2','3','4','6','7','8')	 " + CRLF
	cQryUPD	+= " 		AND ZAD_SLUID = ZAF_SLUID " + CRLF
	cQryUPD	+= " 		AND ZAD_CPF <> ' ' " + CRLF
	cQryUPD	+= " 		AND ZAD_MARK = ' '		  " + CRLF
	cQryUPD	+= " 		AND ZAD_DTVEND BETWEEN '"+cDtINTI+"' AND '"+cDtINTI+"' " + CRLF
	cQryUPD	+= " 		AND ZAF_TIPO = 'Venda'  " + CRLF
	cQryUPD	+= " 		AND ZAF_TPPGTO <> 'Bonificado          ' " + CRLF

	If cEmp == '33'
		cQryUPD	+= " 	AND  ZAF_TPRECB = 'Indireto' " + CRLF
		cQryUPD	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    " + CRLF
	EndIf

	cQryUPD	+= " 		AND ZAD.D_E_L_E_T_ = ' ' " + CRLF
	cQryUPD	+= " 		AND ZAF.D_E_L_E_T_ = ' ' " + CRLF
	cQryUPD	+= " 	GROUP BY ZAD_CPF) " + CRLF
	cQryUPD	+= "WHERE ZAD_CPF <> ' ')
	//cQryUPD	+= "WHERE ROWNUM <= 7500) PARA RODAR MAIS DE UMA VEZ

	cQryUPD	+= " 		AND ZAD_TPTRAN = '1' " + CRLF
	cQryUPD	+= " 		AND ZAD_TPITEM IN ('1','2','3','4','6','7','8')	 " + CRLF
	cQryUPD	+= " 		AND ZAD_CPF <> ' ' " + CRLF
	cQryUPD	+= " 		AND ZAD_MARK = ' '		  " + CRLF
	cQryUPD	+= " 		AND D_E_L_E_T_ = ' ' " + CRLF
	cQryUPD	+= " 		AND ZAD_DTVEND BETWEEN '"+cDtINTI+"' AND '"+cDtINTI+"' " + CRLF

	nStatus := TcSqlExec(cQryUPD)
	DBCommit()

	If (nStatus < 0)

		cErro :=  REPLICATE("*", 5)+ CRLF
		cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
		u_T4F01LOG(cErro)
//		DBCommit()
	EndIf

	//*******************************************//
	//PROCESSA OS REGISTROS COM CPF				 //
	//*******************************************//
	cQuery2:= "SELECT ZAD_NOME ZAD_NOME, ZAD_CPF ZAD_CPF, ZAD_DTVEND ZAD_DTVEND, ZAD_EMP ZAD_EMP, ZAD_FILIAL ZAD_FILIAL, ZAD_TPITEM ZAD_TPITEM, " + CRLF
	cQuery2+= " COUNT(*) QTD, ZAD_TPAGTO, ZAD_EPEP ZAD_EPEP, SUM(ZAD_VLRTKT) ZAD_VLRTKT, SUM(ZAD_VLRTXO) ZAD_VLRTXO, SUM(ZAD_VLRTXS) ZAD_VLRTXS, SUM(ZAD_VLRSOC) ZAD_VLRSOC," + CRLF
	cQuery2+= " SUM(ZAD_VLRTXC) ZAD_VLRTXC,SUM(ZAD_VLRTXI) ZAD_VLRTXI,SUM(ZAD_VLRXCA) ZAD_VLRXCA,SUM(ZAD_VLENTR) ZAD_VLENTR, ZAD_SEARCH, ZAD_SLUID "+ CRLF
	cQuery2+= "	FROM " +RetSqlName("ZAD") +" ZAD"+ CRLF
	cQuery2+= " WHERE ZAD_FILIAL='01' " + CRLF
	cQuery2+= " 		AND ZAD_MARK = '" + cMarca +"'" + CRLF
	cQuery2+= "  		AND ZAD_CPF <> ' '" + CRLF
	cQuery2+= " 		AND ZAD_DTVEND BETWEEN '"+cDtINTI+"' AND '"+cDtINTI+"' " + CRLF
	cQuery2+= "  		AND ZAD_SLUID IN   " + CRLF

	cQuery2+= "  		(SELECT ZAF_SLUID
	cQuery2+= "  		FROM " +RetSqlName("ZAF") +" ZAF"+ CRLF
	cQuery2+= "  		WHERE ZAF_TIPO ='Venda' "+ CRLF

	If cEmp == '33'
		cQuery2	+= " 	AND  ZAF_TPRECB = 'Indireto' " + CRLF
		cQuery2	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    " + CRLF
	EndIf

	cQuery2+= "  		AND ZAF_TPPGTO <> 'Bonificado'
	cQuery2+= " 		AND ZAF_DTVEND BETWEEN '"+cDtINTI+"' AND '"+cDtINTI+"' " + CRLF
	cQuery2+= "  		AND D_E_L_E_T_ =' '
	cQuery2+= "  		GROUP BY ZAF_SLUID)

	cQuery2+= "  		AND D_E_L_E_T_=' '" + CRLF
	cQuery2+= " GROUP BY ZAD_NOME,ZAD_CPF,ZAD_DTVEND,ZAD_EMP,ZAD_FILIAL,ZAD_TPITEM,ZAD_TPAGTO,ZAD_EPEP,ZAD_SEARCH, ZAD_SLUID  " + CRLF
	cQuery2+= "  ORDER BY ZAD_CPF,ZAD_DTVEND,ZAD_TPITEM " + CRLF

	TCQUERY (cQuery2) NEW ALIAS (cAliasZad)

	(cAliasZad)->( DbGotop() )

	If !Empty((cAliasZad)->ZAD_FILIAL)

		cNumPed    :=	SOMA1(cNumPed)

		cA1Cpf    := (cAliasZad)->ZAD_CPF

		cItem:='01'

		While (cAliasZad)->(!Eof())

			DDATABASE := STOD((cAliasZad)->ZAD_DTVEND)

			If (cA1Cpf == (cAliasZad)->ZAD_CPF)

				nPos:=AT( "/",(cAliasZad)->ZAD_EPEP)

				If nPos > 0
					cEpep:=substr((cAliasZad)->ZAD_EPEP,1,nPos-1)
				Else
					cEpep:=(cAliasZad)->ZAD_EPEP
				EndIf

				If ZAE->(MsSeek(cFilZAE + cEpep)) .AND. CTD->(MsSeek(cFilCTD + cEpep))

					If (((cAliasZad)->ZAD_VLRTKT > 0 .OR. (cAliasZad)->ZAD_VLRTXO > 0 .OR. (cAliasZad)->ZAD_VLRTXS > 0 .OR. (cAliasZad)->ZAD_VLRTXC > 0 .OR. (cAliasZad)->ZAD_VLRTXI > 0 .OR. (cAliasZad)->ZAD_VLRSOC > 0 .OR. (cAliasZad)->ZAD_VLENTR > 0);
							.AND. !Empty((cAliasZad)->ZAD_EPEP))

						//****************************************************************
						//* Inclusao - INÍCIO
						//****************************************************************
						SA1->(dbSetOrder(3))
						If SA1->(MsSeek(cFilSA1 + (cAliasZad)->ZAD_CPF))

							cA1Cod  :=  SA1->A1_COD
							cA1Loja :=  SA1->A1_LOJA
							cBlqCli :=  SA1->A1_MSBLQL
						EndIf

						If ZAF->(MsSeek(xFilial("ZAF") + (cAliasZad)->ZAD_SLUID+(cAliasZad)->ZAD_SEARCH))
							cTransId := ZAF->ZAF_NUMERO
							cTPRECB	 := ZAF->ZAF_TPRECB
						Else
							cTransId := ''
						EndIf

						If Len(aCabec) == 0

							aadd(aCabec,cNumPed				 )
							aadd(aCabec,"N"	   				 )
							aadd(aCabec,cA1Cod				 )
							aadd(aCabec,cA1Loja	 			 )
							aadd(aCabec,cA1Loja	 			 )
							aadd(aCabec,cE4Codigo			 )
							aadd(aCabec,"500302"			 )
							aadd(aCabec,(cAliasZad)->ZAD_TPAGTO)
							aadd(aCabec,DDATABASE			 )
							aadd(aCabec,(cAliasZad)->ZAD_SEARCH)
							aadd(aCabec,Alltrim(cTransId))

							cItem:='01'
						EndIf

						If Select(cAliasWallet) > 0
							(cAliasWallet)->( DbCloseArea() )
						EndIf

						cQryWallet := " SELECT ZAF_SLUID ,SUM(ZAF_VLRTRA) ZAF_VLRTRA " + CRLF
						cQryWallet += " FROM ( " + CRLF
						cQryWallet += " SELECT ZAF_SLUID, ZAF_VLRTRA  " + CRLF
						cQryWallet += " FROM " +RetSqlName("ZAF") + CRLF
						cQryWallet += " WHERE ZAF_TPRECB ='Indireto' " + CRLF
						cQryWallet += " AND ZAF_TIPO ='Venda' " + CRLF
						cQryWallet += " AND ZAF_TPPGTO <> 'Bonificado'  " + CRLF
						cQryWallet += " AND ZAF_TPPGTO = 'INTI Wallet' " + CRLF
						cQryWallet += " AND ZAF_SLUID = '" + (cAliasZad)->ZAD_SLUID + "'"+ CRLF
						cQryWallet += " AND ZAF_DTVEND BETWEEN '"+ cDtINTI + "'"+ " AND '" + cDtINTI + "'" + CRLF
						cQryWallet += " AND D_E_L_E_T_ =' ' " + CRLF
						cQryWallet += " GROUP BY ZAF_SLUID, ZAF_VLRTRA) " + CRLF
						cQryWallet += " GROUP BY ZAF_SLUID " + CRLF

						TCQUERY (cQryWallet) NEW ALIAS (cAliasWallet)

						(cAliasWallet)->( DbGotop() )

						If (cEmp == '33' .And. Alltrim(cTPRECB) == 'Indireto')

							nValTkt := (cAliasZad)->ZAD_VLRTKT - (cAliasWallet)->ZAF_VLRTRA

						ElseIf (cEmp == '33' .And. Alltrim(cTPRECB) == 'Direto')

							nValTkt := 0

						ElseIf cEmp == '08'
							nValTkt 	:= 	(cAliasZad)->ZAD_VLRTKT
							nValWallet	:=	0 //(cAliasWallet)->ZAF_VLRTRA ESTÁ DUPLICANDO NA T4F
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
							aadd(aLinha,(cAliasZad)->QTD)
							aadd(aLinha,nValWallet / (cAliasZad)->QTD)
							aadd(aLinha,nValWallet / (cAliasZad)->QTD)
							aadd(aLinha,nValWallet)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cAliasZad)->ZAD_SLUID)
							aadd(aLinha,(cAliasZad)->ZAD_SEARCH)

							aadd(aItens, aLinha)

						EndIf

						If nValTkt > 0

							cB1Cod  :=  ZAE->ZAE_PRDTKT

							If SB1->(MsSeek(cFilSB1 + Alltrim(cB1Cod)))
								cF4TES := SB1->B1_TS
							End If

							aLinha := {}
							aadd(aLinha,cItem)
							aadd(aLinha,cB1Cod)
							aadd(aLinha,(cAliasZad)->QTD)
							aadd(aLinha,nValTkt/(cAliasZad)->QTD)
							aadd(aLinha,nValTkt/(cAliasZad)->QTD)
							aadd(aLinha,nValTkt)
							aadd(aLinha,cF4TES)
							aadd(aLinha,cEpep)
							aadd(aLinha,(cAliasZad)->ZAD_SLUID)
							aadd(aLinha,(cAliasZad)->ZAD_SEARCH)

							aadd(aItens, aLinha)

						ElseIf (cAliasZad)->ZAD_VLRTXO > 0

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
							aadd(aLinha,(cAliasZad)->ZAD_SLUID)
							aadd(aLinha,(cAliasZad)->ZAD_SEARCH)

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
							aadd(aLinha,(cAliasZad)->ZAD_SLUID)
							aadd(aLinha,(cAliasZad)->ZAD_SEARCH)

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
							aadd(aLinha,(cAliasZad)->ZAD_SLUID)
							aadd(aLinha,(cAliasZad)->ZAD_SEARCH)

							aadd(aItens, aLinha)

						ElseIf (cAliasZad)->ZAD_VLRTXI > 0

							cB1Cod:=ZAE->ZAE_PRDTXI

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
							aadd(aLinha,(cAliasZad)->ZAD_SLUID)
							aadd(aLinha,(cAliasZad)->ZAD_SEARCH)

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
							aadd(aLinha,(cAliasZad)->ZAD_SLUID)
							aadd(aLinha,(cAliasZad)->ZAD_SEARCH)

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
							aadd(aLinha,(cAliasZad)->ZAD_SLUID)
							aadd(aLinha,(cAliasZad)->ZAD_SEARCH)

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
							aadd(aLinha,(cAliasZad)->ZAD_SLUID)
							aadd(aLinha,(cAliasZad)->ZAD_SEARCH)

							aadd(aItens, aLinha)


						EndIf

						cItem := Soma1(cItem)

					Else
						cMsgLog	+=  REPLICATE("*", 5)+ CRLF
						cMsgLog +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - Item sem valor " + Alltrim((cAliasZad)->ZAD_NOME)



					End If
				Else
					cMsgLog	+=  REPLICATE("*", 5)+ CRLF
					cMsgLog +=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - EPEP não cadastrado na tabela ZAE " + Alltrim((cAliasZad)->ZAD_NOME)

				EndIf

			Else

				If Len(aItens) > 0
					nOpcX := 3

					Begin Transaction

						lRet	:=	T4FGRVPED(aCabec,aItens)

					End Transaction


					If lRet

						For nI	:=	1 To Len(aItens)

							cTmp	:=	"cTmp2"

							cSearch	:=	aItens[nI][10]

							cQuery4	:= " UPDATE " +RetSqlName("ZAD") + CRLF
							cQuery4	+= " SET ZAD_PEDIDO = '" + cNumPed +"'" + CRLF
							cQuery4	+= ",ZAD_DTPV     = '" + DTOC(DDATABASE) +"'" + CRLF
							cQuery4	+= ",ZAD_HREMIS  = '"+ TIME() +"'" + CRLF
							cQuery4	+= ",ZAD_STATUS   = '2' " + CRLF
							cQuery4	+= " WHERE ZAD_FILIAL='01' " + CRLF
							cQuery4	+= " AND ZAD_EPEP = '"+aItens[nI][8]+"'" + CRLF
							cQuery4	+= " AND ZAD_SLUID = '"+aItens[nI][9]+"'" + CRLF
							cQuery4	+= " AND ZAD_SEARCH = '"+aItens[nI][10]+"'" + CRLF
							cQuery4	+= " AND ZAD_STATUS = '1' " + CRLF
							cQuery4	+= " AND ZAD_MARK = '" +cMarca+"'" +CRLF
							cQuery4	+= " AND ZAD_TPTRAN = '1' " + CRLF
							cQuery4	+= " AND ZAD_CPF ='" + Alltrim(cA1Cpf) + "'"+ CRLF

							nStatus := TcSqlExec(cQuery4)
							DBCommit()

							If (nStatus < 0)

								cErro :=  REPLICATE("*", 5)+ CRLF
								cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
								u_T4F01LOG(cErro)
							EndIf

						Next nI

						ConfirmSX8()

						cNumPed    :=	SOMA1(cNumPed)

						aItens	:=	{}
						aCabec	:=	{}

					Else

						cArqLog := SubStr( Time(),1,5 ) + ".log"

						cMsgLog   += MostraErro("\log_INTI", cArqLog)
						cMsgLog   += REPLICATE("*", 5)+ CRLF

					EndIf

				EndIf

				cItem :='01'
				cA1Cpf := (cAliasZad)->ZAD_CPF
				Loop

			End If

			cA1Cpf := (cAliasZad)->ZAD_CPF
			(cAliasZad)->(dbSkip())
		EndDo

		If Len(aItens) > 0
			nOpcX := 3

			Begin Transaction

				lRet	:=	T4FGRVPED(aCabec,aItens)

			End Transaction


			If lRet

				For nI	:=	1 To Len(aItens)

					cTmp	:=	'cTmp3'

					cQuery4	:= " UPDATE " +RetSqlName("ZAD") + CRLF
					cQuery4	+= " SET ZAD_PEDIDO = '" + cNumPed +"'" + CRLF
					cQuery4	+= ",ZAD_DTPV     = '" + DTOC(DDATABASE) +"'" + CRLF
					cQuery4	+= ",ZAD_HREMIS  = '"+ TIME() +"'" + CRLF
					cQuery4	+= ",ZAD_STATUS   = '2' " + CRLF
					cQuery4	+= " WHERE ZAD_FILIAL='01' " + CRLF
					cQuery4	+= " AND ZAD_EPEP = '"+aItens[nI][8]+"'" + CRLF
					cQuery4	+= " AND ZAD_SLUID = '"+aItens[nI][9]+"'" + CRLF
					cQuery4	+= " AND ZAD_SEARCH = '"+aItens[nI][10]+"'" + CRLF
					cQuery4	+= " AND ZAD_STATUS = '1' " + CRLF
					cQuery4	+= " AND ZAD_MARK = '" +cMarca +"'" + CRLF
					cQuery4	+= " AND ZAD_TPTRAN = '1' " + CRLF
					cQuery4	+= " AND ZAD_CPF ='" + Alltrim(cA1Cpf) + "'"+ CRLF

					nStatus := TcSqlExec(cQuery4)
					DBCommit()

					If (nStatus < 0)

						cErro :=  REPLICATE("*", 5)+ CRLF
						cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
						u_T4F01LOG(cErro)
					EndIf

				Next nI

				ConfirmSX8()

				cNumPed    :=	SOMA1(cNumPed)

				aItens	:=	{}
				aCabec	:=	{}

			Else

				cArqLog := SubStr( Time(),1,5 ) + ".log"

				cMsgLog   += MostraErro("\log_INTI", cArqLog)
				cMsgLog   += REPLICATE("*", 5)+ CRLF

			EndIf

			//****************************************************************
			//* Inclusao - FIM
			//****************************************************************
		Else
			cMsgLog:=  REPLICATE("*", 5)+ CRLF
			cMsgLog+=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+"-"
			cMsgLog+= ' **Query COM CPF** - A consulta não retornou dados habilitados para processar, verifique tabela ZAD, status = 1 - Empresa ' + cEmp
			u_T4F01LOG(cMsgLog)

		EndIf
	EndIf

	U_T4F01NF(,cDtINTI)

	cErro :=  REPLICATE("*", 5)+ CRLF
	cErro +=  Alltrim(Time())+" - Finalizado dia " + cDtINTI
	u_T4F01LOG(cErro)

	PUTMV("MV_DTINTI",DTOC(STOD(cDtINTI)+1))
	/*
	If lAuto  
		PUTMV("MV_DTINTI",DTOC(STOD(cDtINTI)+1))
	Else
		MsgInfo("Processamento de vendas finalizado...","Processamento Manual")
	EndIf
	*/

	dbCloseAll()

	RESET ENVIRONMENT

Return

/*/{Protheus.doc} T4F01LOG
@description ** Função que grava arquivo de log caso ocorra erro na integração ** 
@type Static function
@version 1.00
@author Rogério Costa
@since 28/09/2020
@return Nil, Nil
/*/


User Function T4F01LOG(cErro)

	Local cLogFile := "log_INTI\LOG_INTI_"+DTOS(DDATABASE)+".LOG"
	Local lRet:=.T.

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

//TODO: Criar relatório ou tratar campo status para itens sem valores

Static Function T4FGRVPED(aCabec,aItens)

	Local lRet		:=	.F.
	Local aAreaSc5  :=  SC5->(GetArea())
	Local aAreaSc6  :=  SC6->(GetArea())
	Local aAreaSc9  :=  SC9->(GetArea())
	Local n

	dbSelectArea("SF4")
	SF4->(dbSetOrder(1))

	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(MsSeek(xFilial("SA1") + aCabec[3]+aCabec[4]))

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))

	If SC5->(RecLock("SC5",.T.))

		SC5->C5_FILIAL	:=	xFilial("SC5")
		SC5->C5_NUM		:=	aCabec[1]
		SC5->C5_EMISSAO	:= 	aCabec[09]
		SC5->C5_TIPO	:=	aCabec[2]
		SC5->C5_CLIENTE	:=	aCabec[3]
		SC5->C5_LOJACLI	:=	aCabec[4]
		SC5->C5_CLIENT	:=	aCabec[3]
		SC5->C5_LOJAENT	:=	aCabec[4]
		SC5->C5_TIPOCLI	:= SA1->A1_TIPO
		SC5->C5_CONDPAG	:=	aCabec[6]
		SC5->C5_PAGTO	:=	'BYINTI'
		SC5->C5_NATUREZ	:=	"500302"
		SC5->C5_MENNOTA	:=	"CPF.: "+ Alltrim(SA1->A1_CGC)
		SC5->C5_TIPLIB	:=	"2"
		SC5->C5_TPCARGA	:=	"2"
		SC5->C5_GERAWMS	:=	"1"
		SC5->C5_SOLOPC	:=	"1"
		SC5->C5_TPCOMPL	:=	"1"
		SC5->C5_LIBEROK	:=	"S"

	/* RESTANTE DOS CAMPOS DA SC5 	
		SC5->C5_TRANSP 	:=''
		SC5->C5_TABELA 	:=''
		SC5->C5_PERMUTA	:=''
		SC5->C5_VEND1  	:=''
		SC5->C5_COMIS1 	:=''
		SC5->C5_VEND2  	:=''
		SC5->C5_COMIS2 	:=''
		SC5->C5_VEND3  	:=''
		SC5->C5_COMIS3 	:=''
		SC5->C5_VEND4  	:=''
		SC5->C5_COMIS4 	:=''
		SC5->C5_VEND5  	:=''
		SC5->C5_COMIS5 	:=''
		SC5->C5_DESC1  	:=''
		SC5->C5_DESC2  	:=''
		SC5->C5_DESC3  	:=''
		SC5->C5_DESC4  	:=''
		SC5->C5_BANCO  	:=''
		SC5->C5_DESCFI 	:=''
		SC5->C5_COTACAO	:=''
		SC5->C5_TPFRETE	:=''
		SC5->C5_FRETE  	:=''
		SC5->C5_SEGURO 	:=''
		SC5->C5_PESOL  	:=''
		SC5->C5_PBRUTO 	:=''
		SC5->C5_REIMP  	:=''
		SC5->C5_REDESP 	:=''
		SC5->C5_DESPESA	:=''
		SC5->C5_FRETAUT	:=''
		SC5->C5_REAJUST	:=''
		SC5->C5_VOLUME1	:=''
		SC5->C5_VOLUME2	:=''
		SC5->C5_VOLUME3	:=''
		SC5->C5_VOLUME4	:=''
		SC5->C5_ESPECI1	:=''
		SC5->C5_ESPECI2	:=''
		SC5->C5_ESPECI3	:=''
		SC5->C5_ESPECI4	:=''
		SC5->C5_ACRSFIN	:=''
		SC5->C5_NOTA   	:=''
		SC5->C5_SERIE  	:=''
		SC5->C5_MENPAD 	:=''
		SC5->C5_KITREP 	:=''
		SC5->C5_INCISS 	:=''
		SC5->C5_OK     	:=''
		SC5->C5_DESCONT	:=''
		SC5->C5_PEDEXP 	:=''
		SC5->C5_OS     	:=''
		SC5->C5_PDESCAB	:=''
		SC5->C5_MENS1  	:=''
		SC5->C5_MENS2  	:=''
		SC5->C5_TXMOEDA	:=''
		SC5->C5_MENS3  	:=''
		SC5->C5_CONTABI	:=''
		SC5->C5_ENDCOB 	:=''
		SC5->C5_MUNC   	:=''
		SC5->C5_ESTC   	:=''
		SC5->C5_BAIRROC	:=''
		SC5->C5_CEPC   	:=''
		SC5->C5_BLQ    	:=''
		SC5->C5_FORNISS	:=''
		SC5->C5_CONTRA 	:=''
		SC5->C5_KM     	:=''
		SC5->C5_VLR_FRT	:=''
		SC5->C5_PARC1  	:=''
		SC5->C5_DATA1  	:=''
		SC5->C5_PARC2  	:=''
		SC5->C5_DATA2  	:=''
		SC5->C5_PARC3  	:=''
		SC5->C5_DATA3  	:=''
		SC5->C5_PARC4  	:=''
		SC5->C5_DATA4  	:=''
		SC5->C5_PARC5  	:=''
		SC5->C5_DATA5  	:=''
		SC5->C5_PARC6  	:=''
		SC5->C5_DATA6  	:=''
		SC5->C5_PARC7  	:=''
		SC5->C5_DATA7  	:=''
		SC5->C5_PARC8  	:=''
		SC5->C5_DATA8  	:=''
		SC5->C5_PARC9  	:=''
		SC5->C5_DATA9  	:=''
		SC5->C5_DTLANC 	:=''
		SC5->C5_PARCA  	:=''
		SC5->C5_DATAA  	:=''
		SC5->C5_PARCB  	:=''
		SC5->C5_DATAB  	:=''
		SC5->C5_PARCC  	:=''
		SC5->C5_DATAC  	:=''
		SC5->C5_USUARIO	:=''
		SC5->C5_RECISS 	:=''
		SC5->C5_RECFAUT	:=''
		SC5->C5_MDCONTR	:=''
		SC5->C5_MDNUMED	:=''
		SC5->C5_MDPLANI	:=''
		SC5->C5_SOLFRE 	:=''
		SC5->C5_VEICULO	:=''
		SC5->C5_CODED  	:=''
		SC5->C5_NUMPR  	:=''
		SC5->C5_RESREM 	:=''
		SC5->C5_DTESERV	:=''
		SC5->C5_X_CNPJ 	:=''
		SC5->C5_FECENT 	:=''
		SC5->C5_SUGENT 	:=''
		SC5->C5_PREPEMB	:=''
		SC5->C5_XMSGNOT	:=''
		SC5->C5_RASTR  	:=''
		SC5->C5_CLIRET 	:=''
		SC5->C5_LOJARET	:=''
		SC5->C5_PEDECOM	:=''
		SC5->C5_STATUS 	:=''
		SC5->C5_FILGCT 	:=''
		SC5->C5_MOEDTIT	:=''
		SC5->C5_CODEMB 	:=''
		SC5->C5_REMCTR 	:=''
		SC5->C5_REMREV 	:=''
		SC5->C5_NOMMOT 	:=''
		SC5->C5_CODMOT 	:=''
		SC5->C5_SDOCSUB	:=''
		SC5->C5_CODVGLP	:=''
		SC5->C5_PLACA2 	:=''
		SC5->C5_ORCRES 	:=''
		SC5->C5_MODANP 	:=''
		SC5->C5_MUNPRES	:=''
		SC5->C5_SDOC   	:=''
		SC5->C5_DESCMUN	:=''
		SC5->C5_SLENVT 	:=''
		SC5->C5_RET20G 	:=''
		SC5->C5_NFSUBST	:=''
		SC5->C5_SERSUBS	:=''
		SC5->C5_PLACA1 	:=''
		SC5->C5_TRCNUM 	:=''
		SC5->C5_CODSAF 	:=''
		SC5->C5_FRTCFOP	:=''
		SC5->C5_UFORIG 	:=''
		SC5->C5_CMUNOR 	:=''
		SC5->C5_UFDEST 	:=''
		SC5->C5_CMUNDE 	:=''
		SC5->C5_CLIREM 	:=''
		SC5->C5_LOJAREM	:=''
		SC5->C5_TXREF  	:=''
		SC5->C5_DTTXREF	:=''
		SC5->C5_ORIGEM 	:=''
		SC5->C5_OBRA   	:=''
		SC5->C5_ESTPRES	:=''
		SC5->C5_ECSEDEX	:=''
		SC5->C5_ECPRESN	:=''
		SC5->C5_ECVINCU	:=''
		SC5->C5_NUMENT 	:=''
		SC5->C5_NTEMPEN	:=''
		SC5->C5_TIPOBRA	:=''
		SC5->C5_INDPRES	:=''
		SC5->C5_VOLTAPS	:=''
		SC5->C5_MSBLQL 	:=''
		SC5->C5_CNO    	:=''
		SC5->C5_ARTOBRA	:=''
		SC5->C5_TABTRF 	:=''
		SC5->C5_CLIINT 	:=''
		SC5->C5_IMINT  	:=''
		SC5->C5_CGCINT 	:=''
	*/
		SC5->(MsUnlock())

		lRet	:=	.T.
	End If

	For n:=1 To len(aItens)

	/* ORDEM DOS CAMPOS
		aadd(aLinha,cItem) //1
		aadd(aLinha,cB1Cod)//2
		aadd(aLinha,(cSemCPF)->QTD)//3
		aadd(aLinha,(cSemCPF)->(ZAD_VLRXCA/QTD))//4
		aadd(aLinha,(cSemCPF)->(ZAD_VLRXCA/QTD))//5
		aadd(aLinha,(cSemCPF)->ZAD_VLRXCA)//6
		aadd(aLinha,cF4TES)//7
		aadd(aLinha,cEpep)//8
		11
	*/
		If SC6->(RecLock("SC6",.T.)) .And. lRet
			SC6->C6_FILIAL	:=	xFilial("SC6")
			SC6->C6_ITEM	:=	aItens[n][1]
			SC6->C6_PRODUTO	:=	aItens[n][2]

			SB1->(MsSeek(xFilial("SB1") + aItens[n][2]))
			SC6->C6_DESCRI	:=	SB1->B1_DESC

			SC6->C6_UM		:=	SB1->B1_UM
			SC6->C6_QTDVEN	:=	aItens[n][3]
			SC6->C6_PRCVEN	:=	aItens[n][4]
			SC6->C6_VALOR 	:=	aItens[n][6]
			SC6->C6_SEGUM	:= 	SB1->B1_SEGUM
			SC6->C6_TES		:=	aItens[n][7]
			SC6->C6_CONTA	:=	SB1->B1_CONTA
			SC6->C6_ITEMCC	:=	aItens[n][8]

			SC6->C6_PREOPER	:=	'R'
			SC6->C6_ENTREG	:=	aCabec[09]
			SC6->C6_LOCAL	:=	'01'

			SF4->(MsSeek(xFilial("SF4") + aItens[n][7]))
			SC6->C6_CF		:= 	IIf(SA1->A1_EST == 'SP','5','6')	+	SUBSTR(SF4->F4_CF,2,3)

			SC6->C6_CLI		:=	aCabec[3]
			SC6->C6_LOJA	:=	aCabec[4]
			SC6->C6_PRUNIT	:=	aItens[n][5]
			SC6->C6_NUM		:=	aCabec[1]
			SC6->C6_CLASFIS	:=	SB1->B1_ORIGEM + SF4->F4_SITTRIB
			SC6->C6_CODISS	:=	SB1->B1_CODISS
			SC6->C6_TPOP	:=	'F'
			SC6->C6_SUGENTR	:=	aCabec[09]
			SC6->C6_DTFIMNT	:= 	aCabec[09]
			SC6->C6_RATEIO	:=	'2'
			SC6->C6_TPPROD	:=	'1'
			SC6->C6_DATCPL	:=	aCabec[09]
			SC6->C6_INTROT	:=	'1'

		/*RESTANTE DOS CAMPOS DA SC6
			SC6->C6_QTDLIB :=''
			SC6->C6_OPER   :=''
			SC6->C6_QTDLIB2:=''
			SC6->C6_QTDENT :=''
			SC6->C6_QTDENT2:=''
			SC6->C6_SLDALIB:=''
			SC6->C6_LA     :=''
			SC6->C6_CCUSTO :=''
			SC6->C6_UNSVEN :=''
			SC6->C6_DATFAT :=''
			SC6->C6_DESCONT:=''
			SC6->C6_VALDESC:=''
			SC6->C6_NOTA   :=''
			SC6->C6_SERIE  :=''
			SC6->C6_COMIS1 :=''
			SC6->C6_COMIS2 :=''
			SC6->C6_COMIS3 :=''
			SC6->C6_BLOQUEI:=''
			SC6->C6_COMIS4 :=''
			SC6->C6_NFORI  :=''
			SC6->C6_COMIS5 :=''
			SC6->C6_PEDCLI :=''
			SC6->C6_IPIDEV :=''
			SC6->C6_IDENTB6:=''
			SC6->C6_BLQ    :=''
			SC6->C6_SERIORI:=''
			SC6->C6_ITEMORI:=''
			SC6->C6_GRADE  :=''
			SC6->C6_ITEMGRD:=''
			SC6->C6_LOTECTL:=''
			SC6->C6_NUMLOTE:=''
			SC6->C6_NUMORC :=''
			SC6->C6_RESERVA:=''
			SC6->C6_OPC    :=''
			SC6->C6_LOCALIZ:=''
			SC6->C6_NUMSERI:=''
			SC6->C6_NUMOP  :=''
			SC6->C6_ITEMOP :=''
			SC6->C6_OP     :=''
			SC6->C6_OK     :=''
			SC6->C6_PICMRET:=''
			SC6->C6_DTVALID:=''
			SC6->C6_CHASSI :=''
			SC6->C6_QTDRESE:=''
			SC6->C6_CONTRAT:=''
			SC6->C6_NUMOS  :=''
			SC6->C6_NUMOSFA:=''
			SC6->C6_CODFAB :=''
			SC6->C6_LOJAFA :=''
			SC6->C6_ITEMCON:=''
			SC6->C6_REVISAO:=''
			SC6->C6_SERVIC :=''
			SC6->C6_ENDPAD :=''
			SC6->C6_TPESTR :=''
			SC6->C6_CONTRT :=''
			SC6->C6_TPCONTR:=''
			SC6->C6_QTDEMP :=''
			SC6->C6_QTDEMP2:=''
			SC6->C6_ITCONTR:=''
			SC6->C6_GEROUPV:=''
			SC6->C6_PROJPMS:=''
			SC6->C6_EDTPMS :=''
			SC6->C6_TASKPMS:=''
			SC6->C6_TRT    :=''
			SC6->C6_PROJET :=''
			SC6->C6_ITPROJ :=''
			SC6->C6_POTENCI:=''
			SC6->C6_LICITA :=''
			SC6->C6_COMPLE1:=''
			SC6->C6_COMPLE2:=''
			SC6->C6_COMPLE3:=''
			SC6->C6_COMPLE4:=''
			SC6->C6_MOPC   :=''
			SC6->C6_REGWMS :=''
			SC6->C6_NUMSC  :=''
			SC6->C6_ITEMSC :=''
			SC6->C6_NUMCP  :=''
			SC6->C6_CONTAG :=''
			SC6->C6__CONTRA:=''
			SC6->C6_ABSCINS:=''
			SC6->C6_ABATISS:=''
			SC6->C6_ABATMAT:=''
			SC6->C6_FUNRURA:=''
			SC6->C6_FETAB  :=''
			SC6->C6_CODROM :=''
			SC6->C6_TPDEDUZ:=''
			SC6->C6_MOTDED :=''
			SC6->C6_FORDED :=''
			SC6->C6_LOJDED :=''
			SC6->C6_SERDED :=''
			SC6->C6_NFDED  :=''
			SC6->C6_VLNFD  :=''
			SC6->C6_PCDED  :=''
			SC6->C6_VLDED  :=''
			SC6->C6_ABATINS:=''
			SC6->C6_ALIQISS:=''
			SC6->C6_BASVEIC:=''
			SC6->C6_TNATREC:=''
			SC6->C6_CNATREC:=''
			SC6->C6_GRPNATR:=''
			SC6->C6_PEDCOM :=''
			SC6->C6_ITPC   :=''
			SC6->C6_FILPED :=''
			SC6->C6_ITEMED :=''
			SC6->C6_CODINF :=''
			SC6->C6_CODLAN :=''
			SC6->C6_INFAD  :=''
			SC6->C6_CODLPRE:=''
			SC6->C6_ITLPRE :=''
			SC6->C6_D1DOC  :=''
			SC6->C6_D1ITEM :=''
			SC6->C6_D1SERIE:=''
			SC6->C6_TURNO  :=''
			SC6->C6_VDMOST :=''
			SC6->C6_FCICOD :=''
			SC6->C6_VDOBS  :=''
			SC6->C6_PVCOMOP:=''
			SC6->C6_HORENT :=''
			SC6->C6_ITEMPC :=''
			SC6->C6_PMSID  :=''
			SC6->C6_VLIMPOR:=''
			SC6->C6_PROGRAM:=''
			SC6->C6_PEDVINC:=''
			SC6->C6_NUMPCOM:=''
			SC6->C6_ALMTERC:=''
			SC6->C6_REVPROD:=''
			SC6->C6_PRODFIN:=''
			SC6->C6_NRSEQCQ:=''
			SC6->C6_ITEMGAR:=''
			SC6->C6_SOLCOM :=''
			SC6->C6_ITEMCTA:=''
			SC6->C6_ORCGAR :=''
			SC6->C6_CLVL   :=''
			SC6->C6_GCPIT  :=''
			SC6->C6_HORCPL :=''
			SC6->C6_GCPLT  :=''
			SC6->C6_CC     :=''
			SC6->C6_IPITRF :=''
			SC6->C6_SDOC   :=''
			SC6->C6_SDOCDED:=''
			SC6->C6_SDOCORI:=''
			SC6->C6_SDOCSD1:=''
			SC6->C6_CSTPIS :=''
			SC6->C6_CTVAR  :=''
			SC6->C6_CATEG  :=''
			SC6->C6_PENE   :=''
			SC6->C6_CULTRA :=''
			SC6->C6_DATAEMB:=''
			SC6->C6_TPREPAS:=''
		*/
			SC6->(MsUnlock())
		End If
	Next n

	lRet	:=	.T.

	ConfirmSX8()

	//Libera pedido para faturamento gerando SC9
	If lRet
		For n:=1 To len(aItens)

			SC6->(RecLock("SC9",.T.))
			SC9->C9_FILIAL		:=		xfilial("SC9")
			SC9->C9_PEDIDO		:=		aCabec[1]
			SC9->C9_ITEM		:=		aItens[n][1]
			SC9->C9_CLIENTE		:=		aCabec[3]
			SC9->C9_LOJA		:=		aCabec[4]
			SC9->C9_PRODUTO		:=		aItens[n][2]
			SC9->C9_QTDLIB		:=		aItens[n][3]
			SC9->C9_DATALIB		:=		aCabec[09]
			SC9->C9_SEQUEN		:=		'01'

			SB1->(MsSeek(xFilial("SB1") + aItens[n][2]))
			SC9->C9_GRUPO		:=		SB1->B1_GRUPO

			SC9->C9_PRCVEN		:=		aItens[n][4]
			SC9->C9_QTDRESE		:=		0
			SC9->C9_LOCAL		:=		'01'
			SC9->C9_TPCARGA		:=		'2'
			SC9->C9_QTDLIB2		:=		aItens[n][3]
			SC9->C9_POTENCI		:=		0
			SC9->C9_CODISS		:=		SB1->B1_CODISS
			SC9->C9_RETOPER		:=		'2'
			SC9->C9_TPOP		:=		'1'
			SC9->C9_DATENT		:=		aCabec[09]
			SC9->C9_SOLFLG		:=		0

		/* DEMAIS CAMPOS SC9
			SC9->C9_IDDCF		:=
			SC9->C9_OK			:=
			SC9->C9_LICITA		:=
			SC9->C9_NFISCAL		:=
			SC9->C9_SERIENF		:=
			SC9->C9_FILAGRU		:=
			SC9->C9_PROJPMS		:=
			SC9->C9_EDTPMS		:=
			SC9->C9_TASKPMS		:=
			SC9->C9_ORDSEP		:=
			SC9->C9_SERIREM		:=
			SC9->C9_BLINF		:=
			SC9->C9_LOTNFC		:=
			SC9->C9_BLTMS		:=
			SC9->C9_REGWMS		:=
			SC9->C9_NUMSEQ		:=
			SC9->C9_NUMCP		:=
			SC9->C9_TRT			:=
			SC9->C9_DAV			:=
			SC9->C9_ROMEMB		:=
			SC9->C9_SDOCREM		:=
			SC9->C9_SDOCNF		:=
			SC9->C9_SD3SEQ		:=
			SC9->C9_AGREG		:=
			SC9->C9_IDENTB6		:=
			SC9->C9_VENDA		:=
			SC9->C9_BLEST		:=
			SC9->C9_BLCRED		:=
			SC9->C9_BLOQUEI		:=
			SC9->C9_LOTECTL		:=
			SC9->C9_NUMLOTE		:=
			SC9->C9_NUMSERI		:=
			SC9->C9_REMITO		:=
			SC9->C9_ITEMREM		:=
			SC9->C9_DTVALID		:=
			SC9->C9_RESERVA		:=
			SC9->C9_BLWMS		:=
			SC9->C9_CARGA		:=
			SC9->C9_SEQCAR		:=
			SC9->C9_SEQENT		:=
			SC9->C9_SERVIC		:=
			SC9->C9_STSERV		:=
			SC9->C9_ENDPAD		:=
			SC9->C9_TPESTR		:=
		*/

			SC9->(MsUnlock())
		Next n
	EndIf

	RestArea(aAreaSc5)
	RestArea(aAreaSc6)
	RestArea(aAreaSc9)

Return lRet


//TODO - Na consulta para gerar os pedidos usar a chave TRANSID e SLUID para não gerar duplicidade na tabela financeiro
// e gerar totalizador por SLUID na tabela financeiro
