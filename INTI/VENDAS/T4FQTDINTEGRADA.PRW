#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13) )
#ENDIF

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4FQTDINTEGRADA                        Modulo : SIGAFAT  //
//                                                                          //
//  Fonte desenvolvido para apresentar tela com dados do pedido 			// 
//  gerado e da contabilização realizada 									// 
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa											//
//                                                                          //
//	@since......: 	05/02/2022												//	
//                                                                          //
//	@param......:	nReg, Numerico, Numero do registro da tabela ZAD		//
/*////////////////////////////////////////////////////////////////////////////

/*/{Protheus.doc} T4FQTDINTEGRADA
Fonte desenvolvido para apresentar tela com dados do pedido gerado e da contabilização realizada 									
	@type.......:	function												
	@version....:	1.00													
	@author.....:	Rogério Costa											
	@since......: 	05/02/2022	
	@param......:	nReg, Numerico, Numero do registro da tabela ZAD	
/*/


User Function T4FQTDINTEGRADA(cDtIni,cDtFim)

	Local cPasta  	:= "\workflow\wfpc\"
	Local cArqHtml  := cPasta + "status_integracao"+cEmpAnt+".htm"
	Local cHTML		:=""
	Local cQryHtml	:= " "
	Local cAliasHtml as character 		//:= GetNextAlias()
	Local dDtVend
	Local nPendente := 0
	/*
	Local aSize     := MsAdvSize()
	Local nPort     := 0
	Local oModal
	Local oWebEngine
	*/
	//Private oWebChannel := TWebChannel():New()


	cQryHtml+= "SELECT DTVENDA, SUM(PROCESSADOS) PROCESSADOS, SUM(PENDENTES) PENDENTES, SUM(TOTAL) TOTAL " + CRLF
	cQryHtml+= "FROM ( " + CRLF

	cQryHtml+= "SELECT DTVENDA, count(*) TOTAL, 0 PENDENTES, 0 PROCESSADOS FROM
	cQryHtml+= "(SELECT ZAD_DTVEND DTVENDA, ZAD_NUMERO " + CRLF
	cQryHtml+= " FROM " + RetSqlName("ZAD") +" PROC " + CRLF
	cQryHtml+= " WHERE ZAD_FILIAL='01'  " + CRLF
	cQryHtml+= " AND ZAD_DTVEND BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' " + CRLF
	cQryHtml+= " AND ZAD_ITEMID > ' '  " + CRLF
	cQryHtml+= " AND ZAD_EPEP 	> ' '  " + CRLF
	cQryHtml+= " AND ZAD_TKTID 	> ' '  " + CRLF
	cQryHtml+= " AND ZAD_TPTRAN = '1'  " + CRLF
	cQryHtml+= " AND ZAD_STATUS NOT IN ('4','5')  " + CRLF
	cQryHtml+= " AND ZAD_TPITEM IN ('1','2','3','4','6','7','8')  " + CRLF
	cQryHtml+= " AND EXISTS  " + CRLF
	cQryHtml+= "   (SELECT ZAF_SLUID	 " + CRLF
	cQryHtml+= "  FROM "+RetSqlName("ZAF")+ " ZAF " + CRLF
	cQryHtml+= "   WHERE ZAF_FILIAL = PROC.ZAD_FILIAL  " + CRLF
	cQryHtml+= "    AND ZAF_NUMERO 	> ' '  " + CRLF
	cQryHtml+= "    AND ZAF_EPEP  	= PROC.ZAD_EPEP  " + CRLF
	cQryHtml+= "    AND ZAF_SLUID 	= PROC.ZAD_SLUID  " + CRLF
	cQryHtml+= "    AND ZAF_SEARCH 	= PROC.ZAD_SEARCH  " + CRLF
	cQryHtml+= "    AND ZAF_TIPO  	= 'Venda'  " + CRLF

	If cEmpAnt == '33' // INTI NÃO CONTABILIZA ESSES MOVIMENTOS
		cQryHtml	+= " 	AND  ZAF_TPRECB = 'Indireto' " + CRLF
		cQryHtml	+= " 	AND ZAF_TPPGTO <> 'Bonificado          '		" + CRLF
		cQryHtml	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    " + CRLF
	EndIf
	
	cQryHtml+= "   AND ZAF_TPPGTO <> ' '    " + CRLF
	cQryHtml+= "   AND ZAF_DTVEND BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' " + CRLF
	cQryHtml+= "   AND ZAF.D_E_L_E_T_ = ' '	 " + CRLF
	cQryHtml+= "   GROUP BY ZAF_SLUID)			 " + CRLF
	cQryHtml+= "  AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 )  " + CRLF
	cQryHtml+= "  AND D_E_L_E_T_ = ' ' " + CRLF
	cQryHtml+= "  GROUP BY ZAD_DTVEND,ZAD_NUMERO) " + CRLF
	cQryHtml+= " GROUP BY DTVENDA " + CRLF

	cQryHtml+= "UNION ALL  " + CRLF


	cQryHtml+= "SELECT DTVENDA,0 TOTAL, 0 PENDENTES, count(*) PROCESSADOS FROM
	cQryHtml+= "(SELECT ZAD_DTVEND DTVENDA, ZAD_NUMERO " + CRLF
	cQryHtml+= " FROM " + RetSqlName("ZAD") +" PROC " + CRLF
	cQryHtml+= " WHERE ZAD_FILIAL='01'  " + CRLF
	cQryHtml+= " AND ZAD_DTVEND BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' " + CRLF
	cQryHtml+= " AND ZAD_ITEMID > ' '  " + CRLF
	cQryHtml+= " AND ZAD_EPEP 	> ' '  " + CRLF
	cQryHtml+= " AND ZAD_TKTID 	> ' '  " + CRLF
	cQryHtml+= " AND ZAD_TPTRAN = '1'  " + CRLF
	cQryHtml+= " AND ZAD_STATUS ='3'  " + CRLF
	cQryHtml+= " AND ZAD_TPITEM IN ('1','2','3','4','6','7','8')  " + CRLF
	cQryHtml+= " AND EXISTS  " + CRLF
	cQryHtml+= "   (SELECT ZAF_SLUID	 " + CRLF
	cQryHtml+= "  FROM "+RetSqlName("ZAF")+ " ZAF " + CRLF
	cQryHtml+= "   WHERE ZAF_FILIAL = PROC.ZAD_FILIAL  " + CRLF
	cQryHtml+= "    AND ZAF_NUMERO 	> ' '  " + CRLF
	cQryHtml+= "    AND ZAF_EPEP  	= PROC.ZAD_EPEP  " + CRLF
	cQryHtml+= "    AND ZAF_SLUID 	= PROC.ZAD_SLUID  " + CRLF
	cQryHtml+= "    AND ZAF_SEARCH 	= PROC.ZAD_SEARCH  " + CRLF
	cQryHtml+= "    AND ZAF_TIPO  	= 'Venda'  " + CRLF

	If cEmpAnt == '33' // INTI NÃO CONTABILIZA ESSES MOVIMENTOS
		cQryHtml	+= " 	AND  ZAF_TPRECB = 'Indireto' " + CRLF
		cQryHtml	+= " 	AND ZAF_TPPGTO <> 'Bonificado          '		" + CRLF
		cQryHtml	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    " + CRLF
	EndIf
	
	cQryHtml+= "   AND ZAF_TPPGTO <> ' '    " + CRLF
	cQryHtml+= "   AND ZAF_DTVEND BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' " + CRLF
	cQryHtml+= "   AND ZAF.D_E_L_E_T_ = ' '	 " + CRLF
	cQryHtml+= "   GROUP BY ZAF_SLUID)			 " + CRLF
	cQryHtml+= "  AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 )  " + CRLF
	cQryHtml+= "  AND D_E_L_E_T_ = ' ' " + CRLF
	cQryHtml+= "  GROUP BY ZAD_DTVEND,ZAD_NUMERO) " + CRLF
	cQryHtml+= " GROUP BY DTVENDA " + CRLF

	cQryHtml+= "UNION ALL  " + CRLF

	cQryHtml+= "SELECT DTVENDA, 0 TOTAL, count(*) PENDENTES,  0 PROCESSADOS FROM
	cQryHtml+= "(SELECT ZAD_DTVEND DTVENDA, ZAD_NUMERO " + CRLF
	cQryHtml+= " FROM " + RetSqlName("ZAD") +" PEND " + CRLF
	cQryHtml+= " WHERE ZAD_FILIAL='01'  " + CRLF
	cQryHtml+= " AND ZAD_DTVEND BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' " + CRLF
	cQryHtml+= " AND ZAD_ITEMID 	> ' '  " + CRLF
	cQryHtml+= " AND ZAD_EPEP 		> ' '  " + CRLF
	cQryHtml+= " AND ZAD_TKTID 		> ' '  " + CRLF
	cQryHtml+= " AND ZAD_TPTRAN 	= '1'  " + CRLF
	cQryHtml+= " AND ZAD_STATUS IN ('1','2')  " + CRLF
	cQryHtml+= " AND ZAD_TPITEM IN ('1','2','3','4','6','7','8')  " + CRLF
	cQryHtml+= " AND EXISTS  " + CRLF
	cQryHtml+= "   (SELECT ZAF_SLUID	 " + CRLF
	cQryHtml+= "  FROM "+RetSqlName("ZAF")+ " ZAF " + CRLF
	cQryHtml+= "   WHERE ZAF_FILIAL = PEND.ZAD_FILIAL  " + CRLF
	cQryHtml+= "    AND ZAF_NUMERO 	> ' '  " + CRLF
	cQryHtml+= "    AND ZAF_EPEP  	= PEND.ZAD_EPEP  " + CRLF
	cQryHtml+= "    AND ZAF_SLUID 	= PEND.ZAD_SLUID  " + CRLF
	cQryHtml+= "    AND ZAF_SEARCH 	= PEND.ZAD_SEARCH  " + CRLF
	cQryHtml+= "    AND ZAF_TIPO  	= 'Venda'  " + CRLF

	If cEmpAnt == '33' // INTI NÃO CONTABILIZA ESSES MOVIMENTOS
		cQryHtml	+= " 	AND  ZAF_TPRECB = 'Indireto' " + CRLF
		cQryHtml	+= " 	AND ZAF_TPPGTO <> 'Bonificado          '		" + CRLF
		cQryHtml	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    " + CRLF
	EndIf

	cQryHtml+= "   AND ZAF_TPPGTO <> ' '    " + CRLF
	cQryHtml+= "   AND ZAF_DTVEND BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' " + CRLF
	cQryHtml+= "   AND ZAF.D_E_L_E_T_ = ' '	 " + CRLF
	cQryHtml+= "   GROUP BY ZAF_SLUID)			 " + CRLF
	cQryHtml+= "  AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 )  " + CRLF
	cQryHtml+= "  AND D_E_L_E_T_ = ' ' " + CRLF
	cQryHtml+= "  GROUP BY ZAD_DTVEND,ZAD_NUMERO) " + CRLF
	cQryHtml+= " GROUP BY DTVENDA " + CRLF
	cQryHtml+= " ) " + CRLF
	cQryHtml+= "	GROUP BY DTVENDA " + CRLF
	cQryHtml+= "	ORDER BY DTVENDA " + CRLF

	TcQuery cQryHtml New Alias (cAliasHtml:=GetNextAlias())
	dbSelectArea(cAliasHtml)

	(cAliasHtml)->(DbGotop())

	// Monta o Texto no formato HTML
	cNomeEmp	:=	Alltrim(FWGrpName(cEmpAnt))

	dDtVend	:=	FirstDate(STOD((cAliasHtml)->DTVENDA))

	cHTML +='<head>'
	cHTML +='   <title>STATUS DE PROCESSAMENTOS | BYINTI x PROTHEUS - EMPRESA - '+ cNomeEmp +'</title>'
	cHTML +='</head> <style> .texto {color: #666666;font-family: Verdana;font-size: 10px;background-color: #FFFFFF;margin: 0px;padding: 0px;border-collapse: collapse;}.texto2 {color: #666666;font-family:'
	cHTML +='Verdana;font-size: 15px;background-color: #FFFFFF;margin: 0px;padding: 0px;border-collapse: collapse;}'
	cHTML +='.texto3 {color: #000000;font-family:Verdana;font-size: 15px;background-color: #FFFFCC;margin: 0px;padding: 0px;border-collapse: collapse;}'
	cHTML +='.texto4 {color: #FFFFFF;font-family:Verdana;font-size: 15px;background-color: #FB5F21;margin: 0px;padding: 0px;border-collapse: collapse;}'
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
	cHTML +='      <br><br><br>STATUS DE PROCESSAMENTOS | BYINTI x PROTHEUS EMPRESA: '+ cNomeEmp +'<br><br>
	cHTML +='      </span>
	cHTML +='   </td>
	cHTML +='   <td align="right" width="20%">
	cHTML +='      <span class="texto">
	cHTML +='      <br>'+DTOC(dDataBase)+ " Hr.:"+Time()+'<br><br>
	cHTML +='      </span>
	cHTML +='   </td>
	cHTML +='</table>
	cHTML +='<table width="100%" border="2" align="left" cellpadding="0" cellspacing="0" class="tabela">
	cHTML +='   <tr>
	cHTML +='      <td  width="03%" class="cabecalho_2" align="center">DATA</td>
	cHTML +='      <td  width="03%" class="cabecalho_2" align="center">TOTAL REGISTROS</td>
	cHTML +='      <td  width="03%" class="cabecalho_2" align="center">PROCESSADOS</td>
	cHTML +='      <td  width="03%" class="cabecalho_2" align="center">PENDENTES</td>
	cHTML +='      <td  width="03%" class="cabecalho_2" align="center">STATUS</td>
	cHTML +='   </tr>

	While (cAliasHtml)->(!Eof())

		If dDtVend == STOD((cAliasHtml)->DTVENDA)
			cHTML +='   <tr>
			cHTML +='      <td width="03 %" class="texto2" align="center"><br>'+DTOC(dDtVend)+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2" align="center"><br>'+ALLTRIM(STR((cAliasHtml)->TOTAL))+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2" align="center"><br>'+ALLTRIM(STR((cAliasHtml)->PROCESSADOS))+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2" align="center"><br>'+ALLTRIM(STR((cAliasHtml)->PENDENTES))+'<br><br> </td>
		Else
			cHTML +='   <tr>
			cHTML +='      <td width="03 %" class="texto2" align="center"><br>'+DTOC(dDtVend)+'<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2" align="center"><br>0<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2" align="center"><br>0<br><br> </td>
			cHTML +='      <td width="03 %" class="texto2" align="center"><br>0<br><br> </td>
		EndIf

		If dDtVend == Stod(GetMV("MV_DTPED"))
			cHTML +='      <td width="03 %" class="texto3" align="center"><br>PROCESSANDO REGISTROS<br><br> </td>
		ElseIf (cAliasHtml)->PROCESSADOS == 0
			cHTML +='      <td width="03 %" class="texto4" align="center"><br>AGUARDANDO PROCESSAMENTO<br><br> </td>
		Else
			cHTML +='      <td width="03 %" class="texto2" align="center"><br>REGISTROS PROCESSADOS<br><br> </td>
		EndIf

		If dDtVend == STOD((cAliasHtml)->DTVENDA)
			(cAliasHtml)->(DBSKIP())

			dDtVend	:= dDtVend + 1
		ElseIf dDtVend <= dDataBase

			dDtVend	:= dDtVend + 1
			Loop
		Else
			(cAliasHtml)->(DBSKIP())

		EndIf

	EndDo

	cHTML +='   </tr>
	cHTML +='</table>
	cHTML +='</div>
	cHTML +='</body>
	cHTML +='</html>

	nPendente := (cAliasHtml)->PENDENTES
	
	(cAliasHtml)->(Dbclosearea())

	FERASE(cArqHtml)

	//Se o arquivo não existir, cria um vazio
	MemoWrite(cArqHtml, cHTML)

	//oModal := MSDialog():New(aSize[7]/1.5,0,aSize[6]/1.5,aSize[5]/1.5, "BYINTI x PROTHEUS",,,,,,,,,.T./*lPixel*/)

	//Prepara o conector
	//nPort := oWebChannel::connect()
	//cBaseUrl := 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Time_For_Fun.jpg/250px-Time_For_Fun.jpg'

	//Cria o componente que irá carregar o arquivo local
	//oWebEngine := TWebEngine():New(oModal, 0, 0, 100, 100,/*cUrl*/, nPort)
	//oWebEngine:SetHtml(cHTML,cBaseUrl)
	//oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT
	//oModal:Activate()

	If FWIsInCallStack('U_T4FPEDAUT')

		If nPendente <= 10 .And. (TIME() > '09:00:00' .AND. TIME() < '09:05:00')

			cTO	:= GETMV("MV_LOGRPS")
			cCc	:= ""
			cBcc:= ""

			cTxtemail := "STATUS PROCESSAMENTO BILHETERIA: " + cNomeEmp

			U_T4COMMAIL(cTO, cCc, cTxtemail, cHTML,{},'')

		EndIf

	Else

		ShellExecute( "open", 'http://10.200.182.7:8090/workflow/wfpc/status_integracao'+cEmpAnt+'.htm', "", "", 3 )
	EndIf

Return (.T.)
