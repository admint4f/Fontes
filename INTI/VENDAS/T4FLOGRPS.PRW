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
User Function T4FLOGRPS(cEmp,cFil,cSerie,cNota,cDataIni,cDataFim)

	Local	lUsaColab
	Local	aParam
	Local	aMonitor 	:= {}
	Local	cHTML		:=""
	Local 	ny			:=0
	Local 	oWsTss
	Local 	cQuery 		:= " "
	Local	cIdent		:= 	" "
	Local	cTMP		:=	GetNextAlias()
	Local 	aDadosNf	:= {}
	Local 	cNomeEmp	:= ""

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

	If Select("SX2") == 0

		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SB1","SC5","SC6","SC9","SB1","SB2","SF4","SE4","ZAD","ZAE"

	EndIf

	cHrIni := Time() > '10:00:00' .And. Time() < '10:01:00'
	cHrFim := Time() > '16:00:00' .And. Time() < '16:01:00'

	If (cHrIni .Or. cHrFim)

		dDataIni	:= 	FirstDate(STOD(GETMV("MV_DTPED")))
		dDataFim	:= 	DDATABASE-2

		cIdent		:= 	RetIdEnt()

		If dDataIni == DDATABASE
			dDataIni:= dDataIni - 1
		EndIf

		aArea			:= Lj7GetArea({"SA1"})

		cQuery+= "	SELECT F3_EMISSAO, F3_SERIE, F3_NFISCAL, F3_CLIENT, F3_LOJA, F3_ESTADO, F3_DESCRET  " + CRLF
		cQuery+= "		FROM "+RetSqlName("SF3")+ ' SF3 ' + CRLF
		cQuery+= "		WHERE F3_FILIAL = '"+xFilial('SF3') + "'" + CRLF
		cQuery+= "		AND SF3.F3_ENTRADA BETWEEN '"+ DTOS(dDataIni)+"' AND '" + DTOS(dDataFim) + "'" + CRLF
		cQuery+= "		    AND F3_SERIE = 'S  ' "+ CRLF
		cQuery+= "			AND SUBSTR(SF3.F3_CFO,1,1) >= '5'  " + CRLF
		cQuery+= "			AND SF3.F3_NFELETR =' ' " + CRLF
		cQuery+= "			AND SF3.F3_DTCANC = ' ' " + CRLF
		cQuery+= "			AND SF3.D_E_L_E_T_ =' ' " + CRLF
		cQuery+= "		GROUP BY F3_EMISSAO, F3_SERIE, F3_NFISCAL, F3_CLIENT, F3_LOJA,F3_ESTADO,F3_DESCRET " + CRLF
		cQuery+= "		ORDER BY F3_EMISSAO, F3_NFISCAL

		cQuery	:= ChangeQuery(cQuery)

		TcQuery cQuery New Alias (cTMP)
		dbSelectArea(cTMP)

		(cTMP)->(dbGoTop())

		cURL     := AllTrim(GetNewPar("MV_SPEDURL","http://localhost:8080/nfse"))
		cCodMun     := SM0->M0_CODMUN
		oWsTss:= WsSpedCfgNFe():New()
		oWsTss:cUSERTOKEN      := "TOTVS"
		oWsTss:cID_ENT         := cIdEnt
		oWSTss:_URL            := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		lOk                    := .T.

		If lOk
			lOk     := oWsTss:CfgTSSVersao()
			cVerTss := oWsTss:cCfgTSSVersaoResult
		EndIf

		aParam:={}
		lUsaColab:= .F.
		cMens	:= ' '

		While !(cTMP)->(Eof())

			aadd(aParam,(cTMP)->F3_SERIE)
			aadd(aParam,(cTMP)->F3_NFISCAL)
			aadd(aParam,(cTMP)->F3_NFISCAL)

			aMonitor	:= WsNFSeMnt( cIdEnt, aParam, lUsaColab )

			If Len(aMonitor) > 0
				cMens:= AMONITOR[1][9][1][2]
			ElseIf Empty((cTMP)->F3_DESCRET)
				cMens:= 'Erro desconhecido na transmissão do RPS, verifique os dados do cliente'
			Else
				cMens:= Alltrim((cTMP)->F3_DESCRET)
			EndIf

			If (cMens <> 'Emissao de Nota Autorizada.' .And. cMens<> ' ')
				aAdd(aDadosNf,{(cTMP)->F3_CLIENT,(cTMP)->F3_LOJA,(cTMP)->F3_ESTADO,(cTMP)->F3_NFISCAL,(cTMP)->F3_SERIE,cMens})
			EndIf

			aParam:={}

			(cTMP)->(DBSkip())

		EndDo

		(cTMP)->(DbCloseArea())

		cNomeEmp	:=	Alltrim(FWGrpName(cEmpAnt))

		If Len(aDadosNf) > 0

			cHTML :='<head>'
			cHTML +='   <title>RPS | T4F - INTI x PROTHEUS</title>'
			cHTML +='</head> <style> .texto {color: #666666;font-family: Verdana;font-size: 10px;background-color: #FFFFFF;margin: 0px;padding: 0px;border-collapse: collapse;}.texto2 {color: #666666;font-family:'
			cHTML +='Verdana;font-size: 15px;background-color: #FFFFFF;margin: 0px;padding: 0px;border-collapse: collapse;}'
			cHTML +='   .titulo{font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 16px;font-weight: bold;color: #406496;margin: 0px;padding: 0px;}'
			cHTML +='   .tabela {color: #000000;padding: 0px;border-collapse: collapse;}
			cHTML +='   .tabela tr td {border:1px solid #CFCFCF;}
			cHTML +='   .texto {color: #666666;font-family: Verdana;font-size: 10px;background-color: #FFFFFF;margin: 0px;padding: 0px;border-collapse: collapse;}
			cHTML +='   .titulo{font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 16px;font-weight: bold;color: #406496;margin: 0px;padding: 0px;}
			cHTML +='   .cabecalho_2 {color: #000000;font-weight: bold;font-family: Verdana;font-size: 12px;text-transform: uppercase;background-color: #DFE5F3;border-collapse: collapse;margin: 3px;padding: 3px;}
			cHTML +='</style>
			cHTML +='<body style='
			cHTML +='background: #FFF;
				cHTML +='background: -moz-linear-gradient(top, #f4f3f0 0%, #FFF 100%);
				cHTML +='background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFF), color-stop(100%,#FFF));
				cHTML +='filter: progid:DXImageTransform.Microsoft.gradient( startColorstr=#ba   d0e4, endColorstr=#d7e5f1,GradientType=0 );
				cHTML +='width: 100%;
				cHTML +='margin: 0px;
				cHTML +='padding: 0px;
				cHTML +='background-attachment:fixed;>
			cHTML +='<div id="principal" style='
			cHTML +='width: 100%;
				cHTML +='padding: 15px;
				cHTML +='margin-right: auto;
				cHTML +='margin-left: auto;
				cHTML +='margin-top: 20px;
				cHTML +='margin-bottom: 20px;
				cHTML +='background-color: #FFF;
				cHTML +='border: 0px solid #006087; >
			cHTML +='<table width="100%" bgcolor="#FFFFFF" border="0" align="center" >
			cHTML +='   <td align="center">
			cHTML +='      <img border=0 align="left" width="15%" src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Time_For_Fun.jpg/250px-Time_For_Fun.jpg">
			cHTML +='      <span style="font-family: Verdana, Geneva, sans-serif;
				cHTML +='         font-size: 30px;
				cHTML +='         color: #406496;
				cHTML +='         text-align: left;
				cHTML +='         font-weight: bold;
				cHTML +='         padding-right: 0px; >
			cHTML +='         <br><br><br>TOTVS | Workflow<br><br>
			cHTML +='         </span>
			cHTML +='         </td>
			cHTML +='         <td align="center" width="80%">
			cHTML +='      <span class="texto2">
			cHTML +='      <br><br><br>RPS COM PROBLEMAS NO ENVIO - EMPRESA - '+cNomeEmp+'<br><br>
			cHTML +='      </span>
			cHTML +='   </td>
			cHTML +='   <td align="right" width="20%">
			cHTML +='      <span class="texto">
			cHTML +='      <br>'+DTOC(DDATABASE)+'<br><br>
			cHTML +='      </span>
			cHTML +='   </td>
			cHTML +='</table>
			cHTML +='<table width="100%" border="2" align="left" cellpadding="0" cellspacing="0" class="tabela">
			cHTML +='   <tr>
			cHTML +='      <td  width="03%" class="cabecalho_2">Cliente</td>
			cHTML +='      <td  width="03%" class="cabecalho_2">Loja</td>
			cHTML +='      <td  width="03%" class="cabecalho_2">Estado</td>
			cHTML +='      <td  width="03%" class="cabecalho_2">RPS</td>
			cHTML +='      <td  width="03%" class="cabecalho_2">Serie</td>
			cHTML +='      <td  width="03%" class="cabecalho_2">Erro</td>

			cHTML +='   </tr>

			For nY:= 1 To Len(aDadosNf)

				cHTML +='   <tr>
				cHTML +='      <td width="03 %" class="texto2"><br>'+aDadosNf[nY][1]+'<br><br></td>
				cHTML +='      <td width="03 %  class="texto2"><br>'+aDadosNf[nY][2]+'<br><br></td>
				cHTML +='      <td width="03 %" class="texto2"><br>'+aDadosNf[nY][3]+'<br><br></td>
				cHTML +='      <td width="03 %  class="texto2"><br>'+aDadosNf[nY][4]+'<br><br></td>
				cHTML +='      <td width="03 %" class="texto2"><br>'+aDadosNf[nY][5]+'<br><br></td>
				cHTML +='      <td width="03 %  class="texto2"><br>'+aDadosNf[nY][6]+'<br><br></td>

			Next nY

			cHTML +='   </tr>
			cHTML +='</table>
			cHTML +='</div>
			cHTML +='</body>
			cHTML +='</html>

			cMail:=' '
			
			cTO	:= GETMV("MV_LOGRPS")
			cCc	:= " " 
			cBcc:= ""
			cTxtemail:= "PROBLEMAS NO ENVIO DE RPS - INTEGRACAO INTI - "+cNomeEmp

			U_T4COMMAIL(cTO, cCc, cTxtemail, cHTML,{},'')

		EndIf

		VerStatTran()

		Lj7RestArea(aArea)

	EndIf

Return

Static Function RetIdEnt(cError)

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


Static Function VerStatTran()

	Local cQry		:= ' '
	Local cHTML 	:= ' '
	Local cNomeEmp	:=	Alltrim(FWGrpName(cEmpAnt))

	cQry+= "	SELECT * FROM ( "										+ CRLF
	cQry+= "	SELECT MAX(F3_EMISSAO) EMISSAO, F3_HORNFE,F3_NFISCAL"	+ CRLF
	cQry+= "	FROM "+RetSqlName("SF3")								+ CRLF
	cQry+= "	WHERE F3_CFO >'499'"									+ CRLF
	cQry+= "	AND F3_SERIE ='S  '"									+ CRLF
	cQry+= "	AND F3_CODNFE <> ' '"									+ CRLF
	cQry+= "	AND F3_DTCANC = ' '"									+ CRLF
	cQry+= "	AND D_E_L_E_T_ =' '"									+ CRLF
	cQry+= "	GROUP BY  F3_HORNFE, F3_NFISCAL"						+ CRLF
	cQry+= "	ORDER BY EMISSAO DESC ,F3_HORNFE DESC, F3_NFISCAL)"		+ CRLF
	cQry+= "	WHERE ROWNUM = 1"										+ CRLF

	cQry	:= ChangeQuery(cQry)

	TcQuery cQry New Alias (cTMPSF3:=GetNextAlias())
	dbSelectArea(cTMPSF3)

	If Stod((cTMPSF3)->EMISSAO) == DDATABASE-1
		Return
	Else

		cHTML +='      <head>'
		cHTML +='         <title>STATUS DA ROTINA DE TRANSMISSAO DE RPS</title>'
		cHTML +='      </head>'
		cHTML +='      <style> .texto {color: #666666;font-family: Verdana;font-size: 10px;background-color: #FFFFFF;margin: 0px;padding:'
		cHTML +='         0px;border-collapse: collapse;}.texto2 {color: #666666;font-family:Verdana;font-size: 15px;background-color: '
		cHTML +='         #FFFFFF;margin: '
		cHTML +='            0px;padding: 0px;border-collapse: collapse;}.texto3 {color: #000000;font-family:Verdana;font-size: '
		cHTML +='15px;background-color: #FFFFCC;margin: 0px;padding: '
		cHTML +='            0px;border-collapse: collapse;}.texto4 {color: #FFFFFF;font-family:Verdana;font-size: '
		cHTML +='15px;background-color: #FB5F21;margin: 0px;padding: 0px;border-collapse: '
		cHTML +='            collapse;}.texto5 {color: #666666;font-family:Verdana;font-size: 16px;background-color: #FFFFFF;margin: '
		cHTML +='0px;padding: 0px;border-collapse: collapse;}   .titulo{font-family: '
		cHTML +='            Verdana, Arial, Helvetica, sans-serif;font-size: 16px;font-weight: bold;color: #406496;margin: 0px;padding: '
		cHTML +='0px;}   .tabela {color: #000000;padding: 0px;border-collapse: collapse;}   '
		cHTML +='            .tabela tr td {border:1px solid #CFCFCF;}   '
		cHTML +='            .texto {color: #666666;font-family: Verdana;font-size: 10px;background-color: #FFFFFF;margin: 0px;padding: '
		cHTML +='0px;border-collapse: collapse;}   .titulo{font-family: Verdana, Arial, Helvetica, '
		cHTML +='            sans-serif;font-size: 16px;font-weight: bold;color: #406496;margin: 0px;padding: 0px;}   .cabecalho_2 '
		cHTML +='{color: #000000;font-weight: bold;font-family: Verdana;font-size: 12px;text-transform: '
		cHTML +='            uppercase;background-color: #DFE5F3;border-collapse: collapse;margin: 3px;padding: 3px;}</style>'
		cHTML +='            <body style=background: #FFF;background: -moz-linear-gradient(top, #f4f3f0 0%, #FFF 100%);background: '
		cHTML +='-webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFF), '
		cHTML +='            color-stop(100%,#FFF));filter: progid:DXImageTransform.Microsoft.gradient( startColorstr=#ba   d0e4, '
		cHTML +='endColorstr=#d7e5f1,GradientType=0 );width: 100%;margin: 0px;padding: 0px;background-attachment:fixed;>'
		cHTML +='            <div id="principal" style=width: 100%;padding: 15px;margin-right: auto;margin-left: auto;margin-top: '
		cHTML +='20px;margin-bottom: 20px;background-color: #FFF;border: 0px solid #006087; >'
		cHTML +='      <table width="100%" bgcolor="#FFFFFF" border="0" align="center" >'
		cHTML +='         <td align="center">      <img border=0 align="left" width="15%" src="https://upload.wikimedia.org/wikipedia/'
		cHTML +='commons/thumb/4/47/Time_For_Fun.jpg/250px-Time_For_Fun.jpg">     '
		cHTML +='             <span style="font-family: Verdana, Geneva, sans-serif;         font-size: 30px;         color: #406496;'
		cHTML +='text-align: left;font-weight: bold;         padding-right: 0px; >         '
		cHTML +='            <br><br><br>TOTVS | Workflow<br><br>         </span>         </td>         <td align="center" width="80%"><'
		cHTML +='span class="texto2"><br><br><br>STATUS DA ROTINA DE TRANSMISSÃO DE RPS PROTHEUS - EMPRESA '+Alltrim(cNomeEmp)+ '<br><br></span>   </td>'
		cHTML +='         <td align="right" width="20%"><span class="texto"><br>' + dtoc(dDataBase) + ' Hr.:'+Time()+'<br><br>      </span>'
		cHTML +='</td></table><table width="100%" border="2" align="left" cellpadding="0" cellspacing="0" class="tabela">'
		cHTML +='         <tr>'
		cHTML +='            <hr style="height:2px;border-width:0;color:red;background-color:#84000B">'
		cHTML +='         </tr>'
		cHTML +='         <tr> <span class="texto5"><b><br><br><br>Atenção !!!!! O Ultimo RPS foi transmitido em '+ Dtoc(Stod((cTMPSF3)->EMISSAO)) +' as ' +Alltrim((cTMPSF3)->F3_HORNFE) + ' <b><br><br>'
		cHTML +='</span> </tr>'
		cHTML +='      </table>'
		cHTML +='      </div></body></html>'

		cTO	:= GETMV("MV_LOGRPS")
		cCc	:= "" 
		cBcc:= ""
	
		cTxtemail := "Status da Transmissao de RPS empresa :" + cNomeEmp + " DATA: " + DTOC(dDataBase)

		U_T4COMMAIL(cTO, cCc, cTxtemail, cHTML,{},'')
	EndIf

Return

