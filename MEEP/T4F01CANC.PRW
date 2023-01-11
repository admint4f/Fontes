#INCLUDE "Fisa022.ch"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"

#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#DEFINE TAMMAXXML 400000  //- Tamanho maximo do XML em bytesS
/*/{Protheus.doc} T4F01CANC
@Description **Funçao criada para processar o cancelamento das vendas na plataforma INTI**
@type User function
@version 1.00 
@author Rogério Costa
@since 11/02/2021
@return Nil, N/A
/*/
User Function T4F01CANC(aParamEmp)

	Local aNotas	:=	{}
	Local n			:=	0
	Local cTMPCanc	:=	""
	Local cTMPZAD	:=	""
	Local cTMPZAD2	:=	""
	Local cAliasSF2	:=	""
	Local lMostraCtb:=	.F.
	Local lAglCtb	:=	.F.
	Local lContab 	:=	.F.
	Local lCarteira	:=	.F.
	Local nRecnoSF2	:=	0
	Local aCabec	:=	{}
	Local aLinha	:=	{}
	Local aItens	:=	{}
	Local cArqLog 	:= 	" "
	Local cMsgLog	:= 	" "
	Local cItem		:=	" "
	Local cDocTot	:=  " "
	Local cSerieTot	:=  " "
	Local nTotMov	:=	0
	Local	cAlias    	:= 	'SF2'
	Local	cDEST		:=	''
	Local	cGravaDest	:= 	''
	Local	lSF3Canc	:= 	.T.
	Local	cNotasOk 	:= 	''
	Local	cSerie		:=	''
	Local	cCodMun 	:= 	''
	Local	cNotaIni	:= 	''
	Local	cNotaFim	:= 	''
	Local	lUsaColab	:= 	.F.
	Local	lAuto		:= 	.T.
	Local	aParam		:= 	{'','',''}
	Local 	aNFCanc		:=	{}
	Local 	cTesDev		:=	""
	Local	cItemOri	:= 	""
	Local	cNumSeq		:= 	""

	Private lMsErroAuto := .F.

	If aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U"
		cEmp:=aParamEmp[1]
		cFil:=aParamEmp[2]
	ELse
		cEmp:='33'
		cFil:='01'
	EndIf

	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4","ZAD","SF2"

	cCodMun 	:= 	SM0->M0_CODMUN
	cUsaColab	:= GetNewPar("MV_SPEDCOL","N")
	cURL       	:= Padr(GetNewPar("MV_SPEDURL",""),250)
	cInscMun   	:= Alltrim(SM0->M0_INSCM)
	cVerTSS    	:= ""
	cTypeaXML  	:= ""
	cEntSai		:= "1"
	cIdent		:= 	U_GetIdEnt()

//	cRetorno := FisaCanc(cCodMun,cAlias,@cNotasOk,'S  ','000317736','000317736',cDest,lAuto,cGravaDest,lUsaColab,lSF3Canc)

//	aParam 		:= {'S  ','000317736','000317736'}
//	aRetNotas	:=	MonitNFSe(aParam)


	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))

	BEGINSQL Alias "cTMPCanc"
		SELECT ZAD_SETOTV,ZAD_NFTOTV,ZAD_STATUS,ZAD_TPTRAN,ZAD_TPITEM ,
				ZAD_CPF,
				ZAD_DTVEND,
				ZAD_EPEP,
				ZAD_SEARCH,
				COUNT(*) QTD, ZAD_EPEP ZAD_EPEP, SUM(ZAD_VLRTKT) ZAD_VLRTKT, SUM(ZAD_VLRTXO) ZAD_VLRTXO, SUM(ZAD_VLRTXS) ZAD_VLRTXS,
				SUM(ZAD_VLRTXC) ZAD_VLRTXC,SUM(ZAD_VLRTXI) ZAD_VLRTXI,SUM(ZAD_VLRXCA) ZAD_VLRXCA,SUM(ZAD_VLRSOC) ZAD_VLRSOC
		FROM %table:ZAD% ZAD
		WHERE ZAD_STATUS ='1'
		AND ZAD_TPTRAN ='2'
		AND ZAD_DTCANC <> ' '
		AND ZAD_DTIMP BETWEEN '20210401' AND '20210408'
		AND ZAD.%NotDel%
		GROUP BY ZAD_SETOTV,ZAD_NFTOTV,ZAD_STATUS,ZAD_TPTRAN,ZAD_TPITEM ,ZAD_CPF,ZAD_DTVEND,ZAD_EPEP,ZAD_SEARCH
	ENDSQL

	//Query para cancelamento total
	While ("cTMPCanc")->(!Eof())

		BEGINSQL Alias "cTMPZAD"
			SELECT A1_COD, 
			A1_LOJA ,
			ZAD_NFTOTV,
			ZAD_SETOTV,
			ZAD_STATUS,
			ZAD_TPTRAN,
			ZAD_TPITEM,
			ZAD_CPF,
			ZAD_DTVEND,
			ZAD_EPEP,
			ZAD_SEARCH,COUNT(*) QTD, SUM(ZAD_VLRTKT) ZAD_VLRTKT, SUM(ZAD_VLRTXO) ZAD_VLRTXO, SUM(ZAD_VLRTXS) ZAD_VLRTXS,
			SUM(ZAD_VLRTXC) ZAD_VLRTXC,SUM(ZAD_VLRTXI) ZAD_VLRTXI,SUM(ZAD_VLRXCA) ZAD_VLRXCA,SUM(ZAD_VLRSOC) ZAD_VLRSOC
			FROM %table:ZAD% ZAD2, %table:SF2% SF2, %table:SA1% SA1
			WHERE ZAD_TPITEM	= %EXP:("cTMPCanc")->ZAD_TPITEM%
			AND ZAD_CPF		= %EXP:("cTMPCanc")->ZAD_CPF%	
			AND ZAD_DTVEND	= %EXP:("cTMPCanc")->ZAD_DTVEND%
			AND ZAD_EPEP	= %EXP:("cTMPCanc")->ZAD_EPEP%
			AND ZAD_SEARCH	= %EXP:("cTMPCanc")->ZAD_SEARCH%
			AND ZAD_STATUS ='3'
			AND ZAD_TPTRAN ='1'
			AND ZAD_NFTOTV = F2_DOC
			AND ZAD_SETOTV = F2_SERIE
			AND ZAD_CPF	   = A1_CGC
			AND F2_CLIENTE = A1_COD
			AND F2_LOJA	   = A1_LOJA
			AND ZAD2.%NotDel%
			AND SF2.%NotDel%
			AND SA1.%NotDel%
			GROUP BY A1_COD, A1_LOJA, ZAD_NFTOTV,ZAD_SETOTV,ZAD_STATUS,ZAD_TPTRAN,ZAD_TPITEM,ZAD_CPF,ZAD_DTVEND,ZAD_EPEP,ZAD_SEARCH
			HAVING COUNT(*) = %EXP:("cTMPCanc")->QTD%

		ENDSQL

		While ("cTMPZAD")->(!Eof())

			aadd(aNotas,{("cTMPZAD")->A1_COD	,;
				("cTMPZAD")->A1_LOJA	,;
				("cTMPZAD")->ZAD_SETOTV,;
				("cTMPZAD")->ZAD_NFTOTV,;
				("cTMPZAD")->QTD		,;
				("cTMPZAD")->ZAD_CPF	,;
				("cTMPZAD")->ZAD_DTVEND,;
				("cTMPZAD")->ZAD_EPEP	,;
				("cTMPZAD")->ZAD_SEARCH})

			("cTMPZAD")->(dbSkip())

		EndDo
		("cTMPZAD")->(dbCloseArea())

		("cTMPCanc")->(dbSkip())

	EndDo

	For n:=1 To len(aNotas)

		BEGINSQL Alias "cAliasSF2"
			SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,R_E_C_N_O_ SF2RECNO
			FROM %table:SF2% SF2
			WHERE SF2.F2_FILIAL	=	%EXP:xFilial("SF2")%
			AND SF2.F2_SERIE	= 	%EXP:aNotas[n][3]%
			AND SF2.F2_DOC		= 	%EXP:aNotas[n][4]%
			AND SF2.F2_CLIENTE	= 	%EXP:aNotas[n][1]%
			AND SF2.F2_LOJA		= 	%EXP:aNotas[n][2]%
			AND SF2.%NotDel%
			ORDER BY F2_FILIAL,F2_SERIE,F2_DOC
		ENDSQL

		("cAliasSF2")->(dbGotop())

		DbSelectArea("SF2")

		While ("cAliasSF2")->(!Eof()) .And. ("cAliasSF2")->F2_FILIAL == xFilial("SF2")

			SF2->(DbGoTo(("cAliasSF2")->SF2RECNO))
			Begin Transaction
				aRegSD2 := {}
				aRegSE1 := {}
				aRegSE2 := {}
				//ConOut('FatJobNFe('+StrZero(02,2)+'): MaCanDelF2 - '+("cAliasSF2")->F2_SERIE+("cAliasSF2")->F2_DOC)
				If MaCanDelF2("SF2",SF2->(recno()),@aRegSD2,@aRegSE1,@aRegSE2) .AND. MA521VerSC6(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Estorna o documento de saida                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//	ConOut('FatJobNFe('+StrZero(02,2)+'): MaDelNFS - '+("cAliasSF2")->F2_SERIE+("cAliasSF2")->F2_DOC)

					cSerieSF2	:=	SF2->F2_SERIE
					cNotaSF2	:=	SF2->F2_DOC

					lContab	:=	.T.

					SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))

					//Atualiza o status da ZAD
					_cQuery:=""

					_cQuery+=" UPDATE "+RetSqlName("ZAD") + " "
					_cQuery+=" 	SET ZAD_STATUS ='5'"
					_cQuery+=" 	,ZAD_OBS ='CANCELAMENTO PROCESSADO'"
					_cQuery+=" WHERE ZAD_SEARCH ='" +	aNotas[n][9]	+"'"
					_cQuery+="	AND ZAD_CPF		= '" +	aNotas[n][6]	+"'"
					_cQuery+="	AND ZAD_DTVEND	= '" +	aNotas[n][7]	+"'"
					_cQuery+="	AND ZAD_EPEP	= '" +	aNotas[n][8]	+"'"
					_cQuery+="	AND ZAD_STATUS ='1'"
					_cQuery+="	AND ZAD_TPTRAN ='2'"
					_cQuery+="	AND ZAD_DTCANC <> ' '"
					_cQuery+="	AND D_E_L_E_T_ = ' '"

					TCSQLEXEC(_cQuery)
					DBCOMMIT()

				EndIf
				MsUnLockAll()

				If (ALLTRIM(cSerieSF2)	==	'S')
					aadd(aNFCanc,{cSerieSF2,cNotaSF2})
				EndIf

			End Transaction
			nRecnoSF2	:=	("cAliasSF2")->SF2RECNO

			("cAliasSF2")->(dbSkip())
		EndDo
		("cAliasSF2")->(DbCloseArea())

		//Envia cancelamento prefeitura
		/*
		For ny:=1 To Len(aNFCanc)
			cRetorno := FisaCanc(cCodMun,cAlias,@cNotasOk,aNFCanc[n][1],aNFCanc[n][2],aNFCanc[n][2],cDest,lAuto,cGravaDest,lUsaColab,lSF3Canc)

			aParam 		:= {aNotas[n][3],aNotas[n][4],aNotas[n][4]}
			aRetNotas	:=	MonitNFSe(aParam)

			cRetMsg		:=	""

			For nu:=1 To Len(aRetNotas)

				cRetMsg += dtoc(MsDate()) +"-"+ ALLTRIM(TIME()) + " - Nota fiscal - "	+	Alltrim(aRetNotas[nu][2]) + "-" + Alltrim(aRetNotas[nu][6]) + CRLF

			Next nu

			If !Empty(cRetMsg)

				u_T4F01LOG(cRetMsg)

				cTO:="rogerio.costa@crmservices.com.br"
				U_EnvEmail(cTO," Transmissao RPS "+ dtoc(MsDate()),cRetMsg,{},.F.)
			EndIf
		Next ny
		*/

	Next n

	dbSelectArea("cTMPCanc")
	dbGotop()

//Query para cancelamento parcial, gera nota de devolução
	("cTMPCanc")->(DbGotop())

	dbSelectArea("SF4")
	dbSetOrder(1)

	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))

	dbSelectArea("SA1")
	dbSetOrder(3)

	While ("cTMPCanc")->(!Eof())

		If !Empty(("cTMPCanc")->ZAD_CPF)

			If SA1->(DbSeek( xFilial("SA1") + Alltrim(("cTMPCanc")->ZAD_CPF) ) )
				cCli	:=	SA1->A1_COD
				cLoja	:=	SA1->A1_LOJA
			Else
				cCli	:=	"CONSUM"
				cLoja	:=	"01"
			EndIf

		Else
			cCli	:=	"CONSUM"
			cLoja	:=	"01"
		EndIf

//testar outra consulta
		/*
		BEGINSQL Alias "cTMPZAD2"
			
			SELECT DISTINCT ZAD.ZAD_SETOTV, 
					ZAD.ZAD_NFTOTV, ZAD_SEARCH,ZAD_DTVEND,ZAD_CPF,ZAD_EPEP,
					(SELECT D2_ITEM 
						FROM %table:SD2% SD2 
						WHERE 	(D2_COD 	= 	ZAE_PRDTKT 	OR 
								 D2_COD 	= 	ZAE_PRDTXO  OR 
								 D2_COD 	= 	ZAE_PRDTXS 	OR 
								 D2_COD 	= 	ZAE_PRDTXC 	OR 
								 D2_COD 	= 	ZAE_PRDTXI 	OR 
								 D2_COD 	= 	ZAE_PDTXCA 	OR 
								 D2_COD 	= 	ZAE_PRDENT 	OR 
								 D2_COD = ZAE_PRDSOC ) 
				AND D2_DOC		=	ZAD.ZAD_NFTOTV 
				AND D2_SERIE 	= 	ZAD.ZAD_SETOTV 
				AND D2_SERIE	= 	'I  ' // NÃO HAVERÁ CANCELAMENTO PARCIAL PARA NOTAS DE SERVIÇOS
				AND D2_CLIENTE	=	%EXP:cCli%
				AND D2_LOJA		=	%EXP:cLoja%
				AND SD2.D_E_L_E_T_=' ') ITEM,
					(SELECT D2_NUMSEQ 
						FROM %table:SD2% SD22 
						WHERE (SD22.D2_COD 		= 	ZAE_PRDTKT 	OR 
								 SD22.D2_COD 	= 	ZAE_PRDTXO  OR 
								 SD22.D2_COD 	= 	ZAE_PRDTXS 	OR 
								 SD22.D2_COD 	= 	ZAE_PRDTXC 	OR 
								 SD22.D2_COD 	= 	ZAE_PRDTXI 	OR 
								 SD22.D2_COD 	= 	ZAE_PDTXCA 	OR 
								 SD22.D2_COD 	= 	ZAE_PRDENT 	OR 
								 SD22.D2_COD 	= 	ZAE_PRDSOC ) 
						AND SD22.D2_DOC		=	ZAD.ZAD_NFTOTV 
						AND SD22.D2_SERIE 	= 	ZAD.ZAD_SETOTV 
						AND SD22.D2_SERIE	= 	'I  ' // NÃO HAVERÁ CANCELAMENTO PARCIAL PARA NOTAS DE SERVIÇOS
						AND SD22.D2_CLIENTE	=	%EXP:cCli%
						AND SD22.D2_LOJA	=	%EXP:cLoja%
						AND SD22.D_E_L_E_T_=' ') NUMSEQ ,  
					(SELECT D2_TES
						FROM %table:SD2% SD23 
						WHERE (SD23.D2_COD 		= 	ZAE_PRDTKT 	OR 
								 SD23.D2_COD 	= 	ZAE_PRDTXO  OR 
								 SD23.D2_COD 	= 	ZAE_PRDTXS 	OR 
								 SD23.D2_COD 	= 	ZAE_PRDTXC 	OR 
								 SD23.D2_COD 	= 	ZAE_PRDTXI 	OR 
								 SD23.D2_COD 	= 	ZAE_PDTXCA 	OR 
								 SD23.D2_COD 	= 	ZAE_PRDENT 	OR 
								 SD23.D2_COD 	= 	ZAE_PRDSOC ) 
						AND SD23.D2_DOC		=	ZAD.ZAD_NFTOTV 
						AND SD23.D2_SERIE 	= 	ZAD.ZAD_SETOTV 
						AND SD23.D2_CLIENTE	=	%EXP:cCli%
						AND SD23.D2_SERIE	= 	'I  ' // NÃO HAVERÁ CANCELAMENTO PARCIAL PARA NOTAS DE SERVIÇOS
						AND SD23.D2_LOJA	=	%EXP:cLoja%
						AND SD23.D_E_L_E_T_=' ') TES ,  
					ZAE_PRDTXC,
					ZAE_PRDSOC,
					ZAE_PRDTKT,
					ZAE_PRDTXO,
					ZAE_PRDTXS,
					ZAE_PRDTXI,
					ZAE_PDTXCA,
					ZAE_PRDENT, 
					ZAD.ZAD_VLRTKT , 
					ZAD.ZAD_VLRXCA  ,
					ZAD.ZAD_VLRTXO ,
					ZAD.ZAD_VLRTXS ,
					ZAD.ZAD_VLRTXC ,
					ZAD.ZAD_VLRTXI ,
					ZAD.ZAD_VLRSOC ,
					ZAD.ZAD_SEARCH
			FROM %table:ZAD% ZAD
				INNER JOIN %table:ZAD% ZAD3 
							ON ZAD3.ZAD_TPITEM		= ZAD.ZAD_TPITEM 
							AND ZAD3.ZAD_CPF		= ZAD.ZAD_CPF
							AND ZAD3.ZAD_DTVEND		= ZAD.ZAD_DTVEND
							AND ZAD3.ZAD_EPEP		= ZAD.ZAD_EPEP
							AND ZAD3.ZAD_SEARCH		= ZAD.ZAD_SEARCH
							AND ZAD3.ZAD_STATUS 	='1'
							AND ZAD3.ZAD_TPTRAN 	='2'
				INNER JOIN %table:ZAE% ZAE 
							ON ZAE_EPEP = ZAD3.ZAD_EPEP
							AND ZAE.D_E_L_E_T_ =' '
			WHERE ZAD.ZAD_CPF		= %EXP:("cTMPCanc")->ZAD_CPF%	
			AND ZAD.ZAD_TPITEM		= %EXP:("cTMPCanc")->ZAD_TPITEM%
			AND ZAD.ZAD_DTVEND		= %EXP:("cTMPCanc")->ZAD_DTVEND%
			AND ZAD.ZAD_EPEP		= %EXP:("cTMPCanc")->ZAD_EPEP%
			AND ZAD.ZAD_SEARCH		= %EXP:("cTMPCanc")->ZAD_SEARCH%
			AND ZAD.ZAD_STATUS 		='3'
			AND ZAD.ZAD_TPTRAN 		='1' 
			AND ZAD.ZAD_SETOTV		= 'I  '

		ENDSQL
		*/

		BEGINSQL Alias "cTMPZAD2"
			
			SELECT 	ZAE_PRDTKT,
					ZAE_PRDTXO,
					ZAE_PRDTXS,
					ZAE_PRDTXC,
					ZAE_PRDTXI,	
					ZAE_PDTXCA,	
					ZAE_PRDENT,	
					ZAE_PRDSOC,
					ZAD_SETOTV, 
					ZAD_NFTOTV, 
					ZAD_SEARCH,
					ZAD_DTVEND,
					ZAD_CPF,
					ZAD_EPEP,
					ZAD_VLRTKT , 
					ZAD_VLRXCA ,
					ZAD_VLRTXO ,
					ZAD_VLRTXS ,
					ZAD_VLRTXC ,
					ZAD_VLRTXI ,
					ZAD_VLRSOC ,
					ZAD_SEARCH
			FROM %table:ZAD% ZAD,%table:ZAE% ZAE
			WHERE ZAD.ZAD_CPF		= %EXP:("cTMPCanc")->ZAD_CPF%	
			AND ZAD.ZAD_TPITEM		= %EXP:("cTMPCanc")->ZAD_TPITEM%
			AND ZAD.ZAD_DTVEND		= %EXP:("cTMPCanc")->ZAD_DTVEND%
			AND ZAD.ZAD_EPEP		= %EXP:("cTMPCanc")->ZAD_EPEP%
			AND ZAD.ZAD_EPEP		= ZAE_EPEP
			AND ZAD.ZAD_SEARCH		= %EXP:("cTMPCanc")->ZAD_SEARCH%
			AND ZAD.ZAD_STATUS 		='3'
			AND ZAD.ZAD_TPTRAN 		='1' 
			AND ZAD.ZAD_SETOTV		= 'I  '
			AND ZAD.%NotDel%
			AND ZAE.%NotDel%

		ENDSQL

		("cTMPZAD2")->(DbGotop())
		Count To nTotMov
		("cTMPZAD2")->(DbGoTop())

		If nTotMov > 0
			aLinha 	:= {}

			cItem		:=	'0001'
			cSerieTot	:=	("cTMPZAD2")->ZAD_SETOTV
			cDocTot 	:=	NxtSx5Nota(cSerieTot, .T., GetNewPar("MV_TPNRNFS","3"))

			While ("cTMPZAD2")->(!Eof())
				If ("cTMPZAD2")->ZAD_VLRTKT	 > 0 .OR. ("cTMPZAD2")->ZAD_VLRXCA 		> 0 .OR. ;
						("cTMPZAD2")->ZAD_VLRTXO > 0 .OR.	("cTMPZAD2")->ZAD_VLRTXS 	> 0 .OR. ;
						("cTMPZAD2")->ZAD_VLRTXC > 0 .OR.	("cTMPZAD2")->ZAD_VLRTXI 	> 0 .OR. ;
						("cTMPZAD2")->ZAD_VLRSOC > 0

					If Len(aCabec) = 0

						aadd(aCabec, {"F1_DOC" 		, cDocTot					,Nil 	})
						aadd(aCabec, {"F1_SERIE" 	, cSerieTot					,Nil 	})
						aadd(aCabec, {"F1_FORNECE" 	, cCli						,Nil 	})
						aadd(aCabec, {"F1_LOJA" 	, cLoja						,Nil 	})
						aadd(aCabec, {"F1_EMISSAO" 	, dDataBase					,Nil 	})
						aadd(aCabec, {"F1_DTDIGIT" 	, dDataBase					,Nil 	})
						AADD(aCabec, {"F1_EST"		, SA1->A1_EST 				,Nil 	})
						aadd(aCabec, {"F1_COND"		, "001"						,Nil	})
						Aadd(aCabec, {"F1_RECBMTO" 	, dDataBase		        	,Nil 	})
						Aadd(aCabec, {"F1_CHVNFE"  	, ''			       		,Nil 	})
						aadd(aCabec, {"F1_TIPO" 	, "D"						,Nil 	})
						aadd(aCabec, {"F1_FORMUL" 	, "S"						,Nil	})
						aadd(aCabec, {"F1_ESPECIE"	, "NFE" 					,Nil	})
						AAdd(aCabec, {"F1_TPFRETE" 	, "C"				 		,Nil	})
						Aadd(aCabec, {"F1_NATUREZ" 	, "101700"    		 		,Nil 	})
						Aadd(aCabec, {""			,("cTMPZAD2")->ZAD_SEARCH	,Nil 	}) //16
						Aadd(aCabec, {""			,("cTMPZAD2")->ZAD_DTVEND	,Nil 	}) //17
						Aadd(aCabec, {""			,("cTMPZAD2")->ZAD_CPF		,Nil 	}) //18
						Aadd(aCabec, {""			,("cTMPZAD2")->ZAD_EPEP		,Nil 	}) //19
					EndIf

					If ("cTMPZAD2")->ZAD_VLRTKT > 0

						cB1Cod  :=  ("cTMPZAD2")->ZAE_PRDTKT
						nValor	:=	("cTMPZAD2")->ZAD_VLRTKT

						If SB1->(MsSeek(xFilial("SB1") + Alltrim(cB1Cod)))
							cF4TES := SB1->B1_TS
						End If

					ElseIf ("cTMPZAD2")->ZAD_VLRXCA > 0

						cB1Cod  :=  ("cTMPZAD2")->ZAE_PDTXCA
						nValor	:=	("cTMPZAD2")->ZAD_VLRXCA

						If SB1->(MsSeek(xFilial("SB1") + Alltrim(cB1Cod)))
							cF4TES := SB1->B1_TS
						End If

					ElseIf ("cTMPZAD2")->ZAD_VLRTXO > 0

						cB1Cod  :=  ("cTMPZAD2")->ZAE_PRDTXO
						nValor	:=	("cTMPZAD2")->ZAD_VLRTXO

						If SB1->(MsSeek(xFilial("SB1") + Alltrim(cB1Cod)))
							cF4TES := SB1->B1_TS
						End If

					ElseIf ("cTMPZAD2")->ZAD_VLRTXS > 0

						cB1Cod  :=  ("cTMPZAD2")->ZAE_PRDTXS
						nValor	:=	("cTMPZAD2")->ZAD_VLRTXS

						If SB1->(MsSeek(xFilial("SB1") + Alltrim(cB1Cod)))
							cF4TES := SB1->B1_TS
						End If

					ElseIf ("cTMPZAD2")->ZAD_VLRTXC > 0

						cB1Cod  :=  ("cTMPZAD2")->ZAE_PRDTXC
						nValor	:=	("cTMPZAD2")->ZAD_VLRTXC

						If SB1->(MsSeek(xFilial("SB1") + Alltrim(cB1Cod)))
							cF4TES := SB1->B1_TS
						End If

					ElseIf ("cTMPZAD2")->ZAD_VLRTXI > 0

						cB1Cod  :=  ("cTMPZAD2")->ZAE_PRDTXI
						nValor	:=	("cTMPZAD2")->ZAD_VLRTXI

						If SB1->(MsSeek(xFilial("SB1") + Alltrim(cB1Cod)))
							cF4TES := SB1->B1_TS
						End If

					ElseIf ("cTMPZAD2")->ZAD_VLRSOC > 0

						cB1Cod  :=  ("cTMPZAD2")->ZAE_PRDSOC
						nValor	:=	("cTMPZAD2")->ZAD_VLRSOC

						If SB1->(MsSeek(xFilial("SB1") + Alltrim(cB1Cod)))
							cF4TES := SB1->B1_TS
						End If

					EndIf

					If SD2->(MsSeek(xFilial("SD2") + ("cTMPZAD2")->ZAD_NFTOTV + ("cTMPZAD2")->ZAD_SETOTV + cCli + cLoja + Alltrim(cB1Cod))) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

						cItemOri	:= SD2->D2_ITEM
						cNumSeq		:= SD2->D2_NUMSEQ

					End If

					aAdd(aLinha,	{"D1_ITEM" 		,	cItem 									,Nil	})
					aAdd(aLinha,	{"D1_EMISSAO"	,	dDataBase 								,Nil	})
					aadd(aLinha,	{"D1_COD" 		,	cB1Cod				 					,Nil	})
					Aadd(aLinha, 	{"D1_UM"      	, 	"UN"              						,Nil	})
					aadd(aLinha,	{"D1_QUANT" 	,	("cTMPCanc")->QTD 						,Nil	})
					aadd(aLinha,	{"D1_VUNIT" 	,	nValor				 					,Nil	})
					aadd(aLinha,	{"D1_TOTAL" 	,	("cTMPCanc")->QTD*nValor			 	,Nil	})

					If SF4->(MSSeek(xFilial("SF4")+cF4TES))
						cTesDev	:=	SF4->F4_TESDV
						cCf		:=	SF4->F4_CF
					EndIf

					aadd(aLinha,	{"D1_TES" 		,	If(Empty(cTesDev),'008',cTesDev)		,Nil	})//TES DEVOLUÇÃO
					aadd(aLinha,	{"D1_NFORI" 	,	("cTMPZAD2")->ZAD_NFTOTV 				,Nil	}) // nota de origem
					aadd(aLinha,	{"D1_SERIORI"	,	("cTMPZAD2")->ZAD_SETOTV 				,Nil	})
					aadd(aLinha,	{"D1_ITEMORI"	,	cItemOri								,Nil	})
					AAdd(aLinha,	{"D1_IDENTB6"	,	cNumSeq									,Nil	})
					aadd(aLinha,	{"AUTDELETA" 	,	"N" 									,Nil	})

					aAdd(aItens,aLinha)

					aLinha	:=	{}

					cItem	:=	Soma1(cItem)

				EndIf
				("cTMPZAD2")->(dbSkip())
			EndDo

			If Len(aCabec) > 0
				Begin Transaction
					MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCabec,aItens,3)

					If !lMsErroAuto

						_cQuery:=""

						_cQuery+=" UPDATE "+RetSqlName("ZAD") 			+ " "
						_cQuery+=" 	SET ZAD_STATUS ='5'" 				+ " "
						_cQuery+=" 	, ZAD_SETOTV= '" + cSerieTot 		+ "'"
						_cQuery+=" 	, ZAD_NFTOTV='" + cDocTot 			+ "'"
						_cQuery+=" 	,ZAD_OBS ='DEVOLUÇÃO PROCESSADA'"
						_cQuery+=" WHERE ZAD_SEARCH ='" +	Alltrim(aCabec[16][2])	+"'"
						_cQuery+="	AND ZAD_CPF		= '" +	aCabec[18][2]	+" '"
						_cQuery+="	AND ZAD_DTVEND	= '" +	Alltrim(aCabec[17][2])	+"'"
						_cQuery+="	AND ZAD_EPEP	= '" +	Alltrim(aCabec[19][2])	+"'"
						_cQuery+="	AND ZAD_STATUS ='1'"
						_cQuery+="	AND ZAD_TPTRAN ='2'"
						_cQuery+="	AND ZAD_DTCANC <> ' '"
						_cQuery+="	AND D_E_L_E_T_ = ' '"

						TCSQLEXEC(_cQuery)
						DBCOMMIT()

					Else

						cArqLog := SubStr( Time(),1,5 ) + ".log"

						cMsgLog := MostraErro("\log_INTI", cArqLog) + CRLF

						u_T4F01LOG(cMsgLog)

						DisarmTransaction()
					EndIf
				End Transaction
			EndIf
		EndIf

		("cTMPZAD2")->(dbCloseArea())

		("cTMPCanc")->(dbSkip())

	EndDo

	dbCloseAll()

	RESET ENVIRONMENT
Return

/* trecho para envio do cancelamento para prefeitura

MV_PAR01:=cSerie   := aParam[01] := PadR(ParamLoad(cParTrans,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
MV_PAR02:=cNotaini := aParam[02] := PadR(ParamLoad(cParTrans,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
MV_PAR03:=cNotaFin := aParam[03] := PadR(ParamLoad(cParTrans,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
MV_PAR04:=""
MV_PAR05:=""
MV_PAR06:= dData
MV_PAR07:= dData
MV_PAR08:= aParam[08] := PadR(ParamLoad(cParTrans,aPerg,8,aParam[08]),100)
cAlias  := "SF2"
cNotasOk:=""
cDEST	:= Space(10)
MV_PAR05:=""
cMensRet:=""
MV_PAR06:= dDataIni
MV_PAR07:= dDataFim
cGravaDest:=""
lUsaColab:=.F.
lAuto		:=.T.
lNFTE		:=.F.
nForca		:= 1

cRetorno:=FisaCanc('3550308',cAlias,cNotasOk,cSerie,cNotaIni,cNotaFim,cDest,lAuto,cGravaDest,lUsaColab,lSF3Canc)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISA022   ºAutor  ³Microsiga           º Data ³  05/17/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FisaCanc(cCodMun,cAlias,cNotasOk,cSerie,cNotaIni,cNotaFim,cDest,lAuto,cGravaDest,lUsaColab,lSF3Canc)

	local aArea     	:= GetArea()
	local aRemessa 	:= {}
	local cAliasSF3 	:= "SF3"
	local cRetorno   	:= ""
	local cMotCancela	:= ""
	local cXjust		:= ""
	local cCodCanc		:= ""
	local cRdMakeNFSe	:= ""
	local cSerieIni	:= cSerie
	local cSerieFim	:= cSerie

	local lXjust    	:= GetNewPar("MV_INFXJUS","") == "S"
	local lHabCanc		:= GetNewPar("MV_CODCANC",.F.) //Habilita a tela de seleção dos códigos de cancelamento (#Piloto Itajaí - SC)
	local lOk			:= .T.
	local lReproc		:= .F.
	local lCanc		:= .T.
	local lMontaXML	:= .F.

	local nCount		:= 0
	local cCondQry	:= ""
	Local cEntSai 	:= "1"

	default cSerie		:= ""
	default cNotaIni	:= ""
	default cNotaFim	:= ""
	default cDest		:= ""
	default lUsaColab	:= UsaColaboracao("3")
	default lSF3Canc	:= .T. // Verdadeiro se a NFS ja foi cancelada
	default cGravaDest:= ""

	cGravaDest	:= alltrim (cGravaDest)
	Procregua((cAliasSF3)->(reccount()))

	cCondQry:="%"

	If cEntSai == "1"

		cCondQry +="F3_CFO >= '5' "

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

	cRdMakeNFSe	:= getRDMakeNFSe(cCodMun,cEntSai)
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
				autoNfseMsg ("[Query Cancelamento  ] "+ getlastquery()[2],.F.)
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

Return(cNotasOk)
