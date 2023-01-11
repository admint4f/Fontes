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
User Function T4F01TRNFE(aParamEmp)

	Local	cForca
	Local	dDataIni
	Local	dDataFim
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
	MV_PAR07	:= 	DDATABASE
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


	BEGINSQL Alias cTMP
	
		SELECT F3_EMISSAO, F3_SERIE, F3_NFISCAL 
		FROM %table:SF3% SF3 
		WHERE R_E_C_N_O_ IN (
					SELECT MIN(R_E_C_N_O_ ) 
					FROM %table:SF3% SF3
					WHERE F3_SERIE ='S'
					AND SUBSTR(SF3.F3_CFO,1,1) >= '5' 
					AND SF3.F3_CODRET <> '111'
					AND SF3.F3_EMISSAO >= %EXP:dDataIni%
					AND SF3.F3_NFISCAL <>' '
					AND SF3.%NotDel%
					UNION 
					SELECT MAX(R_E_C_N_O_ ) FROM %table:SF3% SF3
					WHERE SF3.%NotDel%
					AND F3_SERIE ='S'
					AND SUBSTR(F3_CFO,1,1) >= '5' 
					AND F3_CODRET <> '111'
					AND F3_EMISSAO >= %EXP:dDataIni%
					AND F3_NFISCAL <>' '
					)
	ENDSQL

	(cTMP)->(dbGoTop())
	cNotaIni	:=	(cTMP)->F3_NFISCAL
	dDataIni	:=	(cTMP)->F3_EMISSAO
	cSerie		:=	(cTMP)->F3_SERIE

	(cTMP)->(dbSkip())
	cNotaFim	:=	If (Empty((cTMP)->F3_NFISCAL),cNotaIni,(cTMP)->F3_NFISCAL)
	dDataFim	:=	If (Empty((cTMP)->F3_EMISSAO),dDataIni,(cTMP)->F3_EMISSAO) 

	cRetorno	:=	Fisa022Trs(SM0->M0_CODMUN,cSerie, cNotaIni,cNotaFim,cForca, cAlias,@cNotasOk,  cDEST,nForca,  @cMensRet, dDataIni,dDataFim,lAuto,         ,cGravaDest,lUsaColab,lNFTE)

	aParam 		:= {cSerie, cNotaIni, cNotaFim}
	aRetNotas	:=	MonitNFSe(aParam)

	cRetMsg		:=	""

	For nX:=1 To Len(aRetNotas)

		cRetMsg += dtoc(MsDate()) +"-"+ ALLTRIM(TIME()) + " - Nota fiscal - "	+	Alltrim(aRetNotas[nX][2]) + "-" + Alltrim(aRetNotas[nX][6]) + CRLF

	Next nX

	If !Empty(cRetMsg)
		u_T4F01LOG(cRetMsg)
	EndIf

	(cTMP)->(DbCloseArea())

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
