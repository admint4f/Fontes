#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "Fisa022.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"

#DEFINE TAMMAXXML 400000  //- Tamanho maximo do XML em bytesS
#DEFINE CRLF (chr(13)+chr(10))


/*/{Protheus.doc} T4F01TRNFE
Usado para Transmitir a NFS-e
@type function
@version 1.00 
@author roger
@since 12/03/2021
@param aNfTrf, array, notas a serem transmitidas
/*/
User Function T4F01TRNFE(aParamEmp,cSerie,cNota,cDataIni,cDataFim,oGridRPS,cEm,cFi)

	Local 	lRunSched	 := FWGetRunSchedule()
	Local	cForca
	Local	MV_PAR08
	Local	cAlias
	Local	cNotasOk
	Local	cDEST
	Local	MV_PAR05
	Local	cMensRet
	Local	MV_PAR06
	Local	MV_PAR07
	Local	cGravaDest
	Local	lUsaColab
	Local	lAuto
	Local	lNFTE
	Local	nForca
	Local	aParam
	Local	aMonitor
	Local 	nX
	Local	cAssunto
	Local 	aNotas		:={}
	Local	cHTML		:=""
	Local 	ny			:=0
	Local 	aRetNotas	:={}
	Local 	aErrRPS		:={}
	Local 	nI			:= 0
	Local 	nQtdAtiva	:= 0

	Private cUsaColab
	Private cURL
	Private cInscMun
	Private cVerTSS
	Private cTypeaXML
	Private cEntSai
	Private lBtnFiltro
	Private lDirCert
	Private aUf
	Private cCodMun
	Private aRotina
	Private aSigaMat01
	Private	cIdent

	If (aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U" ) .And. Len(aParamEmp) > 0
		cEmp := aParamEmp[1]
		cFil := aParamEmp[2]
	Else
		cEmp := cEm
		cFil := cFi
	EndIf

	aUserInfo	:= 	GetUserInfoArray()
	cEmpFil		:=	cEmp + "/" + cFil

	For nI:=1 To Len(aUserInfo)
		If ("T4F01TRNFE" $ aUserInfo[nI][11] .And. cEmpFil $ aUserInfo[nI][11])
			nQtdAtiva := nQtdAtiva + 1
		EndIf
	Next nI

	If nQtdAtiva > 2
		Sleep(100)
	EndIf

	If !(FWIsInCallStack('U_T4F02M'))

		If Select("SX2") == 0

			PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SB1","SC5","SC6","SC9","SB1","SB2","SF4","SE4","ZAD","ZAE"

		EndIf

		dDataIni	:= 	FirstDate(STOD(GETMV("MV_DTPED")))
		dDataFim	:= 	LastDate(STOD(GETMV("MV_DTPED")))

		If dDataIni == DDATABASE
			dDataIni:= dDataIni - 1
		EndIf

	Else

		dDataIni := Stod(cDataIni)
		dDataFim := Stod(cDataFim)
	EndIf

	aArea			:= Lj7GetArea({"SA1"})

	cIdent		:= 	U_GetIdEnt()
	cTMP		:=	GetNextAlias()
	cTMP2		:=	GetNextAlias()
	cNotaIni	:=	""
	cNotaFim	:=	""
	cSerie		:=	""
	cQuery		:= 	""

	cQuery+= "	SELECT * FROM
	cQuery+= "(SELECT F3_EMISSAO, F3_SERIE, F3_NFISCAL  " + CRLF
	cQuery+= "		FROM "+RetSqlName("SF3")+ ' SF3, ' + RetSqlName('CC2') + ' CC2 ' + CRLF
	cQuery+= "		WHERE F3_FILIAL = '"+xFilial('SF3') + "'" + CRLF

	If FWIsInCallStack('U_T4FTJOBNF')
		cQuery+= "		AND SF3.F3_NFISCAL = '"+ cNota + "'" + CRLF
	Else
		cQuery+= "		AND SF3.F3_ENTRADA BETWEEN '"+ DTOS(dDataIni)+"' AND '" + DTOS(dDataFim) + "'" + CRLF
	EndIf

	cQuery+= "		    AND F3_SERIE = 'S  ' "+ CRLF
	cQuery+= "			AND SUBSTR(SF3.F3_CFO,1,1) >= '5'  " + CRLF
	cQuery+= "			AND SF3.F3_NFELETR =' ' " + CRLF
	cQuery+= "			AND SF3.F3_ESTADO = CC2_EST " + CRLF

	cQuery+= "			AND SF3.F3_DTCANC = ' ' " + CRLF
	cQuery+= "			AND SF3.D_E_L_E_T_ =' ' " + CRLF
	cQuery+= "			AND CC2.D_E_L_E_T_  =' '" + CRLF
	cQuery+= "		GROUP BY F3_EMISSAO, F3_SERIE, F3_NFISCAL " + CRLF
	cQuery+= "		ORDER BY F3_EMISSAO, F3_NFISCAL) " + CRLF
	cQuery+= "		WHERE ROWNUM < 200
	cQuery+= "		ORDER BY F3_NFISCAL,F3_EMISSAO " + CRLF

	cQuery	:= ChangeQuery(cQuery)

	TcQuery cQuery New Alias (cTMP)
	dbSelectArea(cTMP)

	(cTMP)->(dbGoTop())

	nMaxTrans	:= 20

	aDadosNf	:=	{}
	aDadosNf2	:=	{}

	cNotaAnt   	:=	(cTMP)->F3_NFISCAL

	cNotaFim	:=	(cTMP)->F3_NFISCAL
	dDataFim	:=	(cTMP)->F3_EMISSAO
	cNotaIni	:=	(cTMP)->F3_NFISCAL
	dDataIni	:=	(cTMP)->F3_EMISSAO

	cMensRet	:=  ""
	cNotasOk	:=  ""

	While !(cTMP)->(Eof())

		If (Val((cTMP)->F3_NFISCAL) - Val(cNotaAnt)) == 0 .OR. (Val((cTMP)->F3_NFISCAL) - Val(cNotaAnt)) == 1
			aAdd(aDadosNf,{(cTMP)->F3_NFISCAL,(cTMP)->F3_SERIE,(cTMP)->F3_EMISSAO})
		Else
			aAdd(aDadosNf2,{(cTMP)->F3_NFISCAL,(cTMP)->F3_SERIE,(cTMP)->F3_EMISSAO})
		EndIf

		If Len(aDadosNf) == nMaxTrans //Envia a cada 20 notas na ordem
			RUNTRANSM(aDadosNf)
			aDadosNf:={}
		ElseIf Len(aDadosNf2) > 0
			RUNTRANSM(aDadosNf2) //Envia a quantidade que tem fora da ordem
			aDadosNf2:={}

			If Len(aDadosNf) > 0
				RUNTRANSM(aDadosNf) //Envia a quantidade que tem fora da ordem
				aDadosNf:={}
			EndIf

		EndIf

		cNotaAnt   	:=	(cTMP)->F3_NFISCAL

		(cTMP)->(DBSkip())

	EndDo

	(cTMP)->(DbCloseArea())

	If Len(aDadosNf) < nMaxTrans .And. Len(aDadosNf) > 0
		RUNTRANSM(aDadosNf)
		aDadosNf:={}
	EndIf

	Lj7RestArea(aArea)

Return

User Function GetIdEnt(cError)

	Local cIdEnt 	  := ""
	Local lUsaColab := UsaColaboracao("3")
	Default cError  := ""

	IF lUsaColab
		if !( ColCheckUpd() )
			//Aviso("SPED","UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 3.0",{STR0114},3)
		else
			cIdEnt := "000000"
		endif
	Else
		if isConnTSS(@cError) // Verifica a conexão do TSS antes de iniciar o processo de validação da entidade
			cIdEnt := getCfgEntidade(@cError)
		endif
	EndIF

Return(cIdEnt)


/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 02/06/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function RUNTRANSM(aDadosNf)

	MV_PAR06	:= 	DDATABASE
	MV_PAR07	:= 	DDATABASE
	cForca		:=	""
	MV_PAR08	:= 	''
	cAlias  	:= 	"SF2"
	cNotasOk	:=	""
	cDEST		:= 	Space(10)
	MV_PAR05	:=	""
	cMensRet	:=	""
	cGravaDest	:=	""
	lUsaColab	:=	.F.
	lAuto		:=	.T.
	lNFTE		:=	.F.
	nForca		:= 	1
	aParam		:=	{}
	aMonitor	:=	{}
	cVerTss 	:= 	""

	cUsaColab	:= GetNewPar("MV_SPEDCOL","N")
	cURL       	:= Padr(GetNewPar("MV_SPEDURL",""),250)
	cInscMun   	:= Alltrim(SM0->M0_INSCM)
	cVerTSS    	:= ""
	cTypeaXML  	:= ""
	cEntSai		:= "1"
	lBtnFiltro 	:= .F.
	lDirCert   	:= .T.
	aUf			:= {}
	cCodMun     := SM0->M0_CODMUN
	aRotina   	:= {}
	aSigaMat01	:= {}

	cRetorno	:=	Fisa022Trs(SM0->M0_CODMUN,aDadosNf[1][2], aDadosNf[1][1],aDadosNf[len(aDadosNf)][1],cForca, cAlias,@cNotasOk,  cDEST,nForca,  @cMensRet, STOD(aDadosNf[1][3]),STOD(aDadosNf[len(aDadosNf)][3]),lAuto,nMaxTrans,cGravaDest,lUsaColab,lNFTE)

	If FWIsInCallStack('U_T4F02M')
		cMsg := "TRANSMITINDO RPS: "
		oGridRPS:SetIncMeter(1,cMsg)
	EndIf

	aParam 		:= {aDadosNf[1][2], aDadosNf[1][1],aDadosNf[len(aDadosNf)][1]}
	aRetNotas	:=	MonitNFSe(aParam)

Return


