#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"


/*/{Protheus.doc} T4F01STAT
@author Rogério Costa - CRM SERVICES
@since 11/11/2021
@version 1.0
@type Function
/*/
User Function T4F01STAT(aParamEmp,cEmp,cFil,cDataIni)

	Local cAlias	:= GetNextAlias()
	Local cAliasC5	:= GetNextAlias()
	Local cHtml		:= ""
	Local cTO		:= ""
	Local cBcc		:= ""
	Local nCont     := 1
	Local cQuery	:= ""
	Local cNomeEmp	:=" "


	If Empty(cDataIni)

		If aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U"
			cEmp := aParamEmp[1]
			cFil := aParamEmp[2]
		Else
			cEmp := "08"
			cFil := "01"
		EndIf

		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4", "ZAD", "ZAF","ZAE"

		cQry:="SELECT C5_EMISSAO "
		cQry+="FROM "+ RetSqlName("SC5") "
		cQry+=" WHERE C5_PAGTO = 'BYINTI' "
		cQry+=" AND C5_EMISSAO >='" + DTOS(FirstDate(dDataBase)) + "'"
		cQry+=" AND D_E_L_E_T_ =' ' "
		cQry+=" GROUP BY C5_EMISSAO "
		cQry+=" ORDER BY C5_EMISSAO DESC "
		
		TCQUERY (cQry) NEW ALIAS (cAliasC5)

		(cAliasC5)->(DbGotop())

		cDataIni :=(cAliasC5)->C5_EMISSAO //DTOS(STOD(GetMV("MV_DTPED"))-2)

	EndIf

	cQuery+=" SELECT " + CRLF
	cQuery+="       CTD_ITEM EVENTO, " + CRLF
	cQuery+="       CTD_DESC01 DESCRICAO, " + CRLF
	cQuery+=" 	  (SELECT to_char(SUM(ZAD_VLRTKT + ZAD_VLRSOC + ZAD_VLRTXC + ZAD_VLRTXI + ZAD_VLRTXO + ZAD_VLENTR + ZAD_VLRTXS + ZAD_VLRXCA),'FM999G999G999D90','nls_numeric_characters='',.''') IMPORTADOS " + CRLF
	cQuery+=" 		FROM " + RetSqlName("ZAD")  + CRLF
	cQuery+=" 		WHERE ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
	cQuery+="       AND ZAD_TPTRAN = '1'" + CRLF
	cQuery+="       AND ZAD_EPEP = CTD_ITEM
	cQuery+="       AND ZAD_TPITEM IN ('1', '2', '3', '4', '6', '7', '8') " + CRLF
	cQuery+=" 		AND D_E_L_E_T_ = ' ') IMPORTADOS, " + CRLF

	cQuery+="       to_char(SUM(ZAD_VLRTKT + ZAD_VLRSOC + ZAD_VLRTXC + ZAD_VLRTXI + ZAD_VLRTXO + ZAD_VLENTR + ZAD_VLRTXS + ZAD_VLRXCA),'FM999G999G999D90','nls_numeric_characters='',.''') APTOSFATURAR, " + CRLF

	cQuery+="       (SELECT to_char(SUM(D2_TOTAL),'FM999G999G999D90', 'nls_numeric_characters='',.''') " + CRLF
	cQuery+=" 		FROM " + RetSqlName("SD2") + CRLF
	cQuery+=" 		WHERE D_E_L_E_T_ =' ' " + CRLF
	cQuery+=" 		AND D2_ITEMCC = CTD_ITEM " + CRLF
	cQuery+=" 		AND D2_SERIE IN ('S','I','INT') " + CRLF
	cQuery+=" 		AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataIni+"') FATURADOS, " + CRLF

	cQuery+=" 		(SELECT to_char(sum(ct2_valor),'FM999G999G999D90', 'nls_numeric_characters='',.''')  " + CRLF
	cQuery+=" 		 		FROM "+ RetSqlName("CT2")  + CRLF
	cQuery+=" 		 		WHERE CT2_LOTE='008820' " + CRLF
	cQuery+=" 		 		AND CT2_DATA BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
	cQuery+=" 		 		AND CT2_HIST LIKE '%BYINTI%' " + CRLF
	cQuery+=" 		 		AND CT2_CREDIT = '1104010009'  " + CRLF
	cQuery+=" 		 		AND CT2_ITEMD = CTD_ITEM  " + CRLF
	cQuery+=" 		 		AND D_E_L_E_T_ = ' ') DEVOLVIDOS, " + CRLF

	cQuery+=" 	  (SELECT to_char(sum(ct2_valor),'FM999G999G999D90', 'nls_numeric_characters='',.''')  " + CRLF
	cQuery+=" 		FROM " + RetSqlName("CT2")  + CRLF
	cQuery+=" 		WHERE CT2_LOTE='008820' " + CRLF
	cQuery+=" 		AND CT2_DATA BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
	cQuery+=" 		AND CT2_DEBITO = '1104010009' " + CRLF
	cQuery+=" 		AND CT2_ITEMD = CTD_ITEM " + CRLF
	cQuery+=" 		AND D_E_L_E_T_ = ' ') CONTABILIZADOS " + CRLF
	
	cQuery+="   FROM " + RetSqlName("CTD") +" CTD, "  + RetSqlName("ZAD") + " ZAD " + CRLF
	cQuery+="   	WHERE " + CRLF
	cQuery+="       CTD_ITEM = ZAD_EPEP " + CRLF
	cQuery+="       AND ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
	cQuery+="       AND ZAD_TPTRAN = '1'" + CRLF
	cQuery+="       AND EXISTS (SELECT NULL  " + CRLF
	cQuery+="       					FROM "+RetSqlName("ZAF")  + CRLF
	cQuery+="       						WHERE ZAF_FILIAL = '01' " + CRLF
	cQuery+= " 							    AND ZAF_NUMERO <> ' ' " + CRLF
	cQuery+= " 		  					    AND ZAF_EPEP = ZAD_EPEP " + CRLF
	cQuery+="								AND ZAF_TIPO ='Venda' " + CRLF

	If cEmp == '33' // INTI NÃO CONTABILIZA ESSES MOVIMENTOS
		cQuery	+= " 	AND ZAF_TPPGTO <> 'Bonificado          '		" + CRLF
		cQuery	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    "
	EndIf

//	cQuery+="       						AND ZAF_TPRECB = 'Indireto' " + CRLF
	cQuery+="       						AND ZAF_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
	cQuery+="       						AND D_E_L_E_T_ =' ' " + CRLF
	cQuery+="       						GROUP BY ZAF_SLUID) " + CRLF

	cQuery+="       AND ZAD_TPITEM IN ('1', '2', '3', '4', '6', '7', '8') " + CRLF
	cQuery+="       AND CTD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery+="       AND ZAD.D_E_L_E_T_ = ' ' " + CRLF
	cQuery+="   GROUP BY " + CRLF
	cQuery+="       CTD_ITEM, " + CRLF
	cQuery+="       CTD_DESC01 " + CRLF

	TCQUERY (cQuery) NEW ALIAS (cAlias)

	(cAlias)->( DbGotop() )

	If !Empty((cAlias)->EVENTO)

		cNomeEmp	:=	Alltrim(FWGrpName(cEmp))

		cHTML +='<head>'
		cHTML +='   <title>STATUS INTEGRACAO | BYINTI x PROTHEUS - EMPRESA - '+ cNomeEmp +'</title>'
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
		cHTML +='      <br><br><br>STATUS INTEGRACAO | BYINTI x PROTHEUS EMPRESA: '+ cNomeEmp +'<br><br>
		cHTML +='      </span>
		cHTML +='   </td>
		cHTML +='   <td align="right" width="20%">
		cHTML +='      <span class="texto">
		cHTML +='      <br>'+DTOC(stod(cDataIni))+'<br><br>
		cHTML +='      </span>
		cHTML +='   </td>
		cHTML +='</table>
		cHTML +='<table width="100%" border="2" align="left" cellpadding="0" cellspacing="0" class="tabela">
		cHTML +='   <tr>
		cHTML +='      <td  width="03%" class="cabecalho_2">EVENTO</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">DESCRICAO</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">IMPORTADOS</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">APTOS A FATURAR</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">FATURADOS</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">DEVOLVIDOS</td>
		cHTML +='      <td  width="03%" class="cabecalho_2">CONTABILIZADOS</td>
		cHTML +='   </tr>

		While (cAlias)->(!Eof())

			cHTML +='   <tr>
			cHTML +='      <td width="03 %" class="texto2"><br>'+(cAlias)->EVENTO+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2"><br>'+(cAlias)->DESCRICAO+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2"><br>'+(cAlias)->IMPORTADOS+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2"><br>'+(cAlias)->APTOSFATURAR+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2"><br>'+(cAlias)->FATURADOS+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2"><br>'+(cAlias)->DEVOLVIDOS+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2"><br>'+(cAlias)->CONTABILIZADOS+'<br><br> </td>

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
	cCc := "rogerio.costa@crmservices.com.br"

	cTxtemail := "INTEGRACOES INTI EMPRESA :" + cNomeEmp + " DATA: " + DTOC(STOD(cDataIni))

	If (nCont > 1)

		U_T4COMMAIL(cTO, cCc, cTxtemail, cHTML,{},'')

	EndIf

Return
