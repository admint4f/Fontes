#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/{Protheus.doc} WFPE007
description - Permite customizar a mensagem de processamento do workflow por link
@type function
@version  
@author roger
@since 28/01/2021
@return cHTML, Modelo html de retorno Wrokflow
/*/
User Function WFPE007()

	Local cHTML     :=  ""
	Local lSuccess  :=  ParamIXB[1]
	Local cMessage  :=  ParamIXB[2]
	Local cProcessID:=  ParamIXB[3]
	Local cTMP      :=  GetNextAlias()
	Local cTMP2     :=  GetNextAlias()
	Local nRecnoSCR :=  0
	Local nRecnoSC  :=  0
	Local _lOkMed   := .T.


	cHTML +='            <head>
	cHTML +='               <title>WORKFLOW | T4F</title>
	cHTML +='            </head>
	cHTML +='            <style> .texto {color: #666666;font-family: Verdana;font-size: 10px;background-color: #FFFFFF;margin: 0px;padding: 0px;border-collapse: collapse;}.texto2 {color: #666666;font-family: Verdana;font-size: 15px;background-color: #FFFFFF;margin: 0px;padding: 0px;border-collapse: collapse;}
	cHTML +='                    .titulo{font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 16px;font-weight: bold;color: #406496;margin: 0px;padding: 0px;}
	cHTML +='                    .tabela {color: #000000;padding: 0px;border-collapse: collapse;}
	cHTML +='                    .tabela tr td {border:1px solid #CFCFCF;}
	cHTML +='                    .texto {color: #666666;font-family: Verdana;font-size: 10px;background-color: #FFFFFF;margin: 0px;padding: 0px;border-collapse: collapse;}
	cHTML +='                    .titulo{font-family: Verdana, Arial, Helvetica, sans-serif;font-size: 16px;font-weight: bold;color: #406496;margin: 0px;padding: 0px;}
	cHTML +='                    .cabecalho_2 {color: #000000;font-weight: bold;font-family: Verdana;font-size: 12px;text-transform: uppercase;background-color: #DFE5F3;border-collapse: collapse;margin: 3px;padding: 3px;}</style>
	cHTML +='            <body style='
	cHTML +='               background: #FFF;
	cHTML +='               background: -moz-linear-gradient(top, #f4f3f0 0%, #FFF 100%);
	cHTML +='               background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFF), color-stop(100%,#FFF));
	cHTML +='               filter: progid:DXImageTransform.Microsoft.gradient( startColorstr=#ba 	d0e4, endColorstr=#d7e5f1,GradientType=0 );
	cHTML +='               width: 100%;
	cHTML +='               margin: 0px;
	cHTML +='               padding: 0px;
	cHTML +='               background-attachment:fixed;>
	cHTML +='               <div id="principal" style='
	cHTML +='                  width: 95%;
	cHTML +='                  padding: 15px;
	cHTML +='                  margin-right: auto;
	cHTML +='                  margin-left: auto;
	cHTML +='                  margin-top: 20px;
	cHTML +='                  margin-bottom: 20px;
	cHTML +='                  background-color: #FFF;
	cHTML +='                  border: 0px solid #006087; >
	cHTML +='                  <table width="100%" bgcolor="#FFFFFF" border="0" align="center" cellspacing="0" cellpadding="0">
	cHTML +='                  <td align="center">
	cHTML +='            <img border=0 align="left" width="15%" src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Time_For_Fun.jpg/250px-Time_For_Fun.jpg">
	cHTML +='            <span style="font-family: Verdana, Geneva, sans-serif;
	cHTML +='                       font-size: 30px;
	cHTML +='            color: #406496;
	cHTML +='            text-align: left;
	cHTML +='                       font-weight: bold;
	cHTML +='                       padding-right: 0px; >
	cHTML +='            <br><br><br>TOTVS | Workflow<br><br>
	cHTML +='            </span>
	cHTML +='                     </td>
	cHTML +='                     <td align="center" width="10%">
	cHTML +='            <span class="texto2">
	cHTML +='            <br><br><br>TOTVS | Workflow<br><br>
	cHTML +='            </span>
	cHTML +='         </td>
	cHTML +='            <td align="center" width="10%">
	cHTML +='            <span class="texto">
	cHTML +='            <br>'+DTOC(DDATABASE)+'<br><br>
	cHTML +='            </span>
	cHTML +='         </td>
	cHTML +='                  </table>
	cHTML +='                  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="tabela">
	cHTML +='         <tr>
	cHTML +='            <td width="23%" class="cabecalho_2">Alerta</td>
	cHTML +='         </tr>
	cHTML +='         <tr>
	cHTML +='            <td width="23%" class="texto2"><br>'+cMessage+'<br><br></td>
	cHTML +='         </tr>
	cHTML +='                  </table>
	cHTML +='               </div>
	cHTML +='            </body>
	cHTML +='         </html>

Return cHTML
