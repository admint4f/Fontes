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

/*/{Protheus.doc} T4F01MNTNFSE
description
@type function
@version  
@author roger
@since 30/03/2021
@param aParamEmp, array, param_description
@return return_type, return_description
/*/

User Function T4F01MNTNFSE(aParamEmp)

	If aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U"
		cEmp:=aParamEmp[1]
		cFil:=aParamEmp[2]
	ELse
		cEmp:='33'
		cFil:='01'
	EndIf

	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SB1","SC5","SC6","SC9","SB1","SB2","SF4","SE4","ZAD","ZAE"

	cForca		:=	""
	dDataIni	:= 	DDATABASE-1
	dDataFim	:= 	DDATABASE
	MV_PAR08	:= 	''
	cAlias  	:= 	"SF2"
	cNotasOk	:=	""
	cDEST		:= 	Space(10)
	MV_PAR05	:=	""
	cMensRet	:=	""
	MV_PAR06	:= 	DDATABASE
	MV_PAR07	:= 	DDATABASE-1
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
	cIdent		:= 	U_GetIdEnt()
	cTMP		:=	GetNextAlias()
	cTMP2		:=	GetNextAlias()
	cNotaIni	:=	""
	cNotaFim	:=	""
	cSerie		:=	""

    //Monitora as notas enviadas
	BEGINSQL Alias cTMP2
			SELECT F3_EMISSAO, F3_SERIE, F3_NFISCAL 
			FROM %table:SF3% SF3 
			WHERE  F3_SERIE =	'S'
				AND F3_TIPO	=	'S' 
				AND SUBSTR(F3_CFO,1,1) >= '5' 
				AND F3_EMISSAO >= %EXP:dDataIni%
				AND F3_CODISS <> ' '
                AND F3_CODRET <> '111'
				AND SF3.%NotDel%
	ENDSQL

	(cTMP2)->(dbGoTop())
	cNFIni	:=	(cTMP2)->F3_NFISCAL
	dDtIni	:=	(cTMP2)->F3_EMISSAO
	cSer	:=	(cTMP2)->F3_SERIE

	(cTMP2)->(dbSkip())
	cNFim	:=	If (Empty((cTMP2)->F3_NFISCAL),cNFIni,(cTMP2)->F3_NFISCAL)
	dDtFim	:=	If (Empty((cTMP2)->F3_EMISSAO),dDtIni,(cTMP2)->F3_EMISSAO)

	aParam 		:= {cSer, cNFIni,cNFim}
	aRetNotas	:=	MonitNFSe(aParam)

	cRetMsg		:=	""

	For nX:=1 To Len(aRetNotas)

		cRetMsg += dtoc(MsDate()) +"-"+ ALLTRIM(TIME()) + " - Nota fiscal - "	+	Alltrim(aRetNotas[nX][2]) + "-" + Alltrim(aRetNotas[nX][6]) + CRLF

	Next nX

	If !Empty(cRetMsg)
		u_T4F01LOG(cRetMsg)

		cTO:="rogerio.costa@crmservices.com.br"
		U_EnvEmail(cTO," Transmissao RPS "+ dtoc(MsDate()),cRetMsg,{},.F.)
	EndIf

	(cTMP)->(DbCloseArea())

Return()
