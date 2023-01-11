/*/{Protheus.doc} T4FLOGINT
** Rotina desenvolvida para gerar html com os registros que não foram integrados **
@author Rogério Costaio
@since 24/07/2018
@version 1.0
@type Function
/*/
User Function T4FLOGINT(aParamEmp)

	Local cAlias	:= ""
	Local cHtml		:= ""
	Local cTO		:= ""
	Local cBcc		:= ""
	Local nCont     := 1
	Local cDate		:=' '
	Local cLogFile  := ""
	Local CRLF		:= Chr(13) + Chr(10)

	If aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U"
		cEmp:=aParamEmp[1]
		cFil:=aParamEmp[2]
	ELse
		cEmp:='08'
		cFil:='01'
	EndIf

	RpcSetType(3)
	RpcSetEnv(cEmp,cFil)

	cAlias	:= GetNextAlias()

	cDate	:= DTOS(DDATABASE-1)

	BeginSql Alias cAlias

		SELECT  
	CASE ZAD_TPTRAN
            WHEN '1' THEN 'VENDA' 
            WHEN '2' THEN 'CANCELAMENTO' 
	END as TP_TRANS ,
                ZAD_EPEP    , 
                ZAD_NFINTI  , 
                ZAD_DTIMP   ,
				ZAD_DTVEND  ,
				ZAD_EVENTO	, 
				ZAD_OBS		,  
                SUM(ZAD_VLRTKT) ZAD_VLRTKT  ,
                SUM(ZAD_VLENTR) ZAD_VLENTR  , 
                SUM(ZAD_VLRTXC) ZAD_VLRTXC  , 
                SUM(ZAD_VLRTXI) ZAD_VLRTXI  , 
                SUM(ZAD_VLRTXO) ZAD_VLRTXO  , 
                SUM(ZAD_VLRTXS) ZAD_VLRTXS  , 
                SUM(ZAD_VLRXCA) ZAD_VLRXCA              
        FROM %TABLE:ZAD% ZAD
        WHERE ZAD_STATUS IN ('4','1')
        AND ZAD_DTVEND >= %exp:cDate%
		AND ZAD.%notDel%
		GROUP BY ZAD_TPTRAN , ZAD_EPEP, ZAD_EVENTO, ZAD_NFINTI, ZAD_DTIMP, ZAD_DTVEND, ZAD_OBS
		ORDER BY ZAD_DTVEND
	EndSql

	If !Empty((cAlias)->ZAD_DTIMP)

		cHTML +='<head>'
		cHTML +='   <title>INTEGRACAO | T4F - INTI x PROTHEUS</title>'
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
		cHTML +='      <br><br><br>REGISTROS COM PROBLEMAS NA INTEGRAÇÃO<br><br>
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
		cHTML +='      <td  width="03%" class="cabecalho_2">Tipo</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">Dt imp</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">EPEP</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">Desc.</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">Dt Venda</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">doc inti</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">Obs.</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">vlr tkt</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">tx ent</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">tx conv</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">tx impre</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">tx oper</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">tx serv</td>
		cHTML +='   </tr>


		While (cAlias)->(!Eof())

			cHTML +='   <tr>
			cHTML +='      <td width="03 %" class="texto2"><br>'+(cAlias)->TP_TRANS+'<br><br> </td>
			cHTML +='      <td class="texto2"><br>'+DTOC(STOD((cAlias)->ZAD_DTIMP))+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+(cAlias)->ZAD_EPEP+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+(cAlias)->ZAD_EVENTO +'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+DTOC(STOD((cAlias)->ZAD_DTVEND))+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+(cAlias)->ZAD_NFINTI+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+(cAlias)->ZAD_OBS+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+Transform((cAlias)->ZAD_VLRTKT,"@E 9,999,999.99")+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+Transform((cAlias)->ZAD_VLENTR,"@E 9,999,999.99")+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+Transform((cAlias)->ZAD_VLRTXC,"@E 9,999,999.99")+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+Transform((cAlias)->ZAD_VLRTXI,"@E 9,999,999.99")+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+Transform((cAlias)->ZAD_VLRTXO,"@E 9,999,999.99")+'<br><br></td>
			cHTML +='      <td class="texto2"><br>'+Transform((cAlias)->ZAD_VLRXCA,"@E 9,999,999.99")+'<br><br></td>

			nCont +=  nCont

			(cAlias)->(DBSKIP())

		EndDo

		cHTML +='   </tr>
		cHTML +='</table>
		cHTML +='</div>
		cHTML +='</body>
		cHTML +='</html>
	End If

	(cAlias)->(Dbclosearea())

	cTO	:= "tax@t4f.com.br;contabil@t4f.com.br"
	cBcc:= ""

	cTxtemail := REPLICATE("*", 5)+"Problemas Integracao INTI Empresa: " + cEmp +"-"

	If (nCont > 1)

		cCc	:= ""
		cBcc:= ""

		U_T4COMMAIL(cTO, cCc, cTxtemail, cHTML,{},'')

	EndIf

	cLogFile	:= "log_INTI\LOG_INTI_"+DTOS(DDATABASE)+".LOG"

	cMsgLog		:= ' '

//Definindo o arquivo a ser lido
	oFile := FWFileReader():New(cLogFile)

//Se o arquivo pode ser aberto
	If (oFile:Open())

		//Se não for fim do arquivo
		If ! (oFile:EoF())
			//Enquanto houver linhas a serem lidas
			While (oFile:HasLine())
				//Buscando o texto da linha atual
				cMsgLog  += oFile:GetLine() + CRLF
			EndDo
		EndIf

		//Fecha o arquivo e finaliza o processamento
		oFile:Close()
	EndIf

	cTxtemail := "Log de Erros Integração INTI "+ dtoc(MsDate())

	U_SENDMAIL(cTO,cCc,cBcc,cTxtemail+ dtoc(MsDate()),cMsgLog)

//Apago o log de cinco dias atrás.
	cLogFile	:= "log_INTI\LOG_INTI_"+DTOS(DDATABASE-5)+".LOG"

	If File(cLogFile)
		Ferase(cLogFile)
	EndIf

	RpcClearEnv()

Return
