#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "APWIZARD.CH"

////////////////////////////////////////////////////////////////////////////
/*/{Protheus.doc} T4FCORRZAD
	Função que altera o status dos itens na ZAD quando existir evento 
	cadastrado e os itens estiverem com status = 4 
	@type.......:	function												
	@version....:	1.00													
	@author.....:	Rogério Costa | CRM SERVICES											
	@since......: 	22/06/2022												
	@param......:	
/*//////////////////////////////////////////////////////////////////////////

User Function T4FCORRZAD()

	Local oSay
	Local oGrid

	Private aParamBox		:= {}
	Private aRet			:= {}
	Private cDataIni		:= ' '
	Private cDataFim		:= ' '
	Private cEpep			:= ' '
	Private cMsgRet			:= ' '

	aAdd(aParamBox,{1,"Data Inicial",DDATABASE           		,"","","   ","",80,.F.})  //01
	aAdd(aParamBox,{1,"Data Final"	,DDATABASE           		,"","","   ","",80,.F.})  //02
	aAdd(aParamBox,{1,"EPEP-Evento"	,SPAC(TamSX3("CTD_ITEM")[1]),"","","CTD","",80,.F.})  //03

	If !ParamBox(aParamBox, "Correção dos Itens importados.", aRet)
		Return Nil
	Else
		cDataIni	:= DTOS(aRet[1])
		cDataFim	:= DTOS(aRet[2])
		cEpep		:= aRet[3]
	End If

	oGrid:=FWGridProcess():New("T4FCORRZAD", "Atualização das vendas importadas ", "Realiza a atualização do status para itens importados sem EPEP cadastrado", {|lEnd| T4FATUZAD(cDataIni,cDataFim,cEpep,oSay,oGrid,cMsgRet),CursorWait()},"","")

	oGrid:SetMeters(1)

	oGrid:Activate()

	If oGrid:IsFinished()
		FWAlertSuccess("Processo finalizado..")
	Else
		FWAlertError("Fim com erro.")
	EndIf

Return

/*/{Protheus.doc} T4FCORRZAD
description
@type function
@version  
@author roger
@since 22/06/2022
@param cDataIni, character, param_description
@param cDataFim, character, param_description
@param cEpep, character, param_description
@param oSay, object, param_description
@param oGrid, object, param_description
@return variant, return_description
/*/
Static Function T4FATUZAD(cDataIni,cDataFim,cEpep,oSay,oGrid,cMsgRet)

	Local cMsg 		:= ' '
	Local cQryUpd	:= ' '
	Local nStatus	:= 0


	cMsg := "Atualizando registros.. "
	oGrid:SetIncMeter(1,cMsg)

	cQryUpd	:= "UPDATE "+ RetSqlName('ZAD') 	+ CRLF
	cQryUpd	+= " SET ZAD_STATUS ='1'" 			+ CRLF
	cQryUpd	+= " WHERE ZAD_FILIAL = '01'"		+ CRLF
	cQryUpd	+= " AND  ZAD_DTVEND BETWEEN '"+cDataIni+"' AND '"+cDataIni+"' " + CRLF
	cQryUpd	+= " AND  ZAD_ITEMID 	> ' '" 		+ CRLF
	cQryUpd	+= " AND  ZAD_EPEP 		= '"+cEpep+"'" 		+ CRLF
	cQryUpd	+= " AND  ZAD_STATUS ='4'
	cQryUpd	+= " AND EXISTS (SELECT NULL FROM "+RetSqlName('ZAE')  + CRLF
	cQryUpd	+= "				WHERE ZAE_EPEP = ZAD_EPEP "+ CRLF
	cQryUpd	+= "				AND ZAE_MSBLQL = '2' "+ CRLF
	cQryUpd	+= "				AND D_E_L_E_T_=' ') "+ CRLF
	cQryUpd	+= "AND D_E_L_E_T_=' ' "+ CRLF

	nStatus := TcSqlExec(cQryUpd)

	If (nStatus < 0)

		cMsgRet :=  REPLICATE("*", 15)+ CRLF
		cMsgRet +=  " Erro durante a atualização. " + CRLF
		cMsgRet +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
		FWAlertError(cMsgRet)
	Else

		FWAlertSuccess("Atualização realizada com sucesso....")

	EndIf

Return
