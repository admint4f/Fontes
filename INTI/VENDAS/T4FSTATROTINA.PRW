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
// 	Programa ...: T4FSTATROTINA                        Modulo : SIGAFAT     //
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

/*/{Protheus.doc} T4FSTATROTINA
Fonte desenvolvido para apresentar tela com dados do pedido gerado e da 
contabilização realizada 									
	@type.......:	function												
	@version....:	1.00													
	@author.....:	Rogério Costa											
	@since......: 	05/02/2022	
	@param......:	nReg, Numerico, Numero do registro da tabela ZAD	
/*/

User Function T4FSTATROTINA(aParamEmp)

	Local cHTML		:=''
	Local cQry		:= " "
	Local cAlias as character
	Local cAlias2
	Local cDataIni

	If aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U"
		cEmp := aParamEmp[1]
		cFil := aParamEmp[2]
	Else
		cEmp := "08"
		cFil := "01"
	EndIf

	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SB6","SED","SF4","ZAD","ZAF"

	cDataIni :=  GetMV("MV_DTBLINT")
	cDtFim	 :=  Dtos(dDataBase-1)

	//verifica se existem registros pendentes de processamento
	cQry+= "SELECT ZAD_DTVEND DTVENDA, COUNT(*) PENDENTES " + CRLF
	cQry+= " FROM " + RetSqlName("ZAD") +" PROC " + CRLF
	cQry+= " WHERE ZAD_FILIAL='01'  " + CRLF
	cQry+= " AND ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDtFim+"' " + CRLF
	cQry+= " AND ZAD_ITEMID <> ' '  " + CRLF
	cQry+= " AND ZAD_EPEP <> ' '  " + CRLF
	cQry+= " AND ZAD_TKTID <> ' '  " + CRLF
	cQry+= " AND ZAD_TPTRAN = '1'  " + CRLF
	cQry+= " AND ZAD_STATUS IN ('1','2')  " + CRLF
	cQry+= " AND ZAD_TPITEM IN ('1','2','3','4','6','7','8')  " + CRLF
	cQry+= " AND ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDtFim+"' " + CRLF
	cQry+= " AND ZAD_SLUID IN  " + CRLF
	cQry+= "   (SELECT ZAF_SLUID	 " + CRLF
	cQry+= "  FROM "+RetSqlName("ZAF")+ " ZAF " + CRLF
	cQry+= "   WHERE ZAF_FILIAL = '01'  " + CRLF
	cQry+= "    AND ZAF_NUMERO <> ' '  " + CRLF
	cQry+= "      AND ZAF_EPEP <> ' '  " + CRLF
	cQry+= "   AND ZAF_TIPO = 'Venda'  " + CRLF

	If cEmpAnt == '33'
		cQry	+= " 	AND  ZAF_TPRECB = 'Indireto' " + CRLF
		cQry	+= " 	AND ZAF_TPPGTO <> 'Bonificado          '		" + CRLF
		cQry	+= "    AND ZAF_TPPGTO <> 'INTI Wallet'    " + CRLF
	EndIf

	cQry+= "   AND ZAF_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDtFim+"' " + CRLF
	cQry+= "   AND ZAF.D_E_L_E_T_ = ' '	 " + CRLF
	cQry+= "   GROUP BY ZAF_SLUID)			 " + CRLF
	cQry+= "  AND (ZAD_VLRTKT>0 OR ZAD_VLRTXO >0 OR ZAD_VLRTXS >0 OR ZAD_VLRTXC >0 OR ZAD_VLRTXI >0 OR ZAD_VLRXCA >0 OR ZAD_VLRSOC >0 OR ZAD_VLENTR >0 )  " + CRLF
	cQry+= "  AND D_E_L_E_T_ = ' ' " + CRLF
	cQry+= "  GROUP BY ZAD_DTVEND " + CRLF

	cQry	:= ChangeQuery(cQry)

	cAlias	:= MPSysOpenQuery(cQry)

	(cAlias)->(DbGotop())

	If (cAlias)->PENDENTES > 20

		//Verifica a hora de emissao e analisar se rotina está parada
		cQry:=	""

		cQry+= 	"   SELECT MAX(ZAD_HREMIS) HORA		" 				+ CRLF
		cQry+= 	"   	FROM "+RetSqlName('ZAD') 	  			  	+ CRLF
		cQry+= 	"   	WHERE ZAD_DTPV = '"+DtoS(dDataBase) +"'	" 	+ CRLF
		cQry+= 	"   	AND ZAD_STATUS = '3'		" 				+ CRLF
		cQry+= 	"   	AND ZAD_DTPV <>' '			" 				+ CRLF
		cQry+= 	"   	AND D_E_L_E_T_ =' '			" 				+ CRLF

		cQry	:= ChangeQuery(cQry)

		cAlias2	:= MPSysOpenQuery(cQry)

		cTempo	:=	ElapTime((cAlias2)->HORA,time())

		cNomeEmp	:=	Alltrim(FWGrpName(cEmpAnt))
		

		If cTempo > '00:10:00'

			// Monta o Texto no formato HTML
			cHTML +='      <head>'
			cHTML +='         <title>STATUS DE DA ROTINA DE PROCESSAMENTOS | BYINTI x PROTHEUS </title>'
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
			cHTML +='span class="texto2"><br><br><br>STATUS DA ROTINA DE PROCESSAMENTO DE PEDIDOS | BYINTI x PROTHEUS - EMPRESA '+Alltrim(cNomeEmp)+ '<br><br></span>   </td>'
			cHTML +='         <td align="right" width="20%"><span class="texto"><br>' + dtoc(dDataBase) + ' Hr.:'+Time()+'<br><br>      </span>'
			cHTML +='</td></table><table width="100%" border="2" align="left" cellpadding="0" cellspacing="0" class="tabela">'
			cHTML +='         <tr>'
			cHTML +='            <hr style="height:2px;border-width:0;color:red;background-color:#84000B">'
			cHTML +='         </tr>'
			cHTML +='         <tr> <span class="texto5"><b><br><br><br>A rotina de processamento de pedidos está parada a '+ cTempo + ' <b><br><br>      '
			cHTML +='</span> </tr>'
			cHTML +='      </table>'
			cHTML +='      </div></body></html>'

			cTO	:= "ti@t4f.com.br;contabil@t4f.com.br"
			cBcc:= ""
			cCc := "rogerio.costa@crmservices.com.br"

			cTxtemail := "INTEGRACOES INTI EMPRESA :" + cNomeEmp + " DATA: " + DTOC(dDataBase)

			U_T4COMMAIL(cTO, cCc, cTxtemail, cHTML,{},'')

		EndIf

	EndIf

Return



