#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

/*----------------------------------------------------------------------*
 | Func:  U_IMCadZBM()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Rotina responsável por consultar a API do Meep de Vendas e 	|
 |        gerar as tabelas ZBM, ZBN e ZBP para início da integração. 	|
 | Parm:  aCliPad:  Array com as informações do cód e loja do cliente  	|
 |					que será utilizado quando o mesmo não for informado |
 |                  na venda.                                       	|
 |        			[1] Cód Cliente										|
 |                  [2] Loja Cliente									|
 *----------------------------------------------------------------------*/

User Function IMOrdProd()
    Local cQuery
	Local cNumOP		:= ""
	Local cObsOP		:= ""
	Local lOk			:= .T.
	Local cNSIOP		:= ""
	Local dDataOP		:= CToD("  /  /    ")

    cQuery := " SELECT  "																		+ CRLF
	cQuery += "		ZBN.*, "                                          							+ CRLF
	cQuery += "		ZBM.ZBM_DTMPFT, "                                          					+ CRLF
	cQuery += "		ZB0.ZB0_LOCAL "                                         					+ CRLF
	cQuery += " FROM "																			+ CRLF
	cQuery += "		"+RetSQLName( "ZBM" )+" ZBM "												+ CRLF
	cQuery += " INNER JOIN "+RetSQLName( "ZBN" )+" ZBN ON ( "									+ CRLF
	cQuery += " 	ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "												+ CRLF
	cQuery += "		AND ZBN.D_E_L_E_T_ <> '*' "													+ CRLF
	cQuery += " ) "																				+ CRLF
	cQuery += " INNER JOIN "+RetSQLName( "ZB0" )+" ZB0 ON ( "									+ CRLF
	cQuery += " 	ZBM.ZBM_STORE = ZB0.ZB0_MEEP "												+ CRLF
	cQuery += " 	AND ZB0.ZB0_ATIVO = '1' "													+ CRLF
	cQuery += " 	AND ZB0.ZB0_FIL = '" + FWFilial() + "' "									+ CRLF
	cQuery += " 	AND ZB0.ZB0_EMP = '" + FWCodEmp() + "' "									+ CRLF
	cQuery += "		AND ZB0.D_E_L_E_T_ <> '*' "													+ CRLF
	cQuery += " ) "																				+ CRLF
	cQuery += " WHERE "																			+ CRLF
	cQuery += "		ZBM.D_E_L_E_T_ <> '*' "														+ CRLF
	//cQuery += "		AND ZBM.ZBM_DTMPFT = '20211021' "      					+ CRLF //Quando necessário forçar uma data
	cQuery += "		AND ZBM.ZBM_APONT <> '1' "													+ CRLF
	cQuery += "		AND ZBM.ZBM_STATUS = '0' "													+ CRLF
	cQuery += "		AND ZBM.ZBM_ETAPA = '0' "													+ CRLF
	cQuery += "		AND ZBM.ZBM_KEYNFC <> '"+space(TAMSX3("ZBM_KEYNFC")[1])+"' " 				+ CRLF
	cQuery += "		AND ZBM.ZBM_ORDID IN (   "													+ CRLF
	cQuery += "			SELECT ZBMCONT.ZBM_ORDID  "												+ CRLF
	cQuery += "		  	FROM "+RetSQLName( "ZBM" )+" ZBMCONT "									+ CRLF
	cQuery += "		  	WHERE ZBMCONT.D_E_L_E_T_ <> '*'	"										+ CRLF
	cQuery += "				AND ZBMCONT.ZBM_APONT <> '1' "										+ CRLF
	cQuery += "				AND ZBMCONT.ZBM_STATUS = '0' "										+ CRLF
	cQuery += "				AND ZBMCONT.ZBM_ETAPA = '0' "										+ CRLF
	cQuery += "				AND ZBMCONT.ZBM_KEYNFC <> '"+space(TAMSX3("ZBM_KEYNFC")[1])+"' "	+ CRLF
	cQuery += "				AND ROWNUM <= 30 "											+ CRLF
	cQuery += "		)	"																		+ CRLF
	cQuery += " ORDER BY "																		+ CRLF
	cQuery += "		ZBM.ZBM_ORDID "																+ CRLF
	TCQuery cQuery New Alias "ZBMOP"

    ZBMOP->(DbGoTop())
    Count To nTotMov
	ZBMOP->(DbGoTop())
	If ZBMOP->(!Eof())
		While ZBMOP->( !Eof() )

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+padr(AllTrim(ZBMOP->ZBN_COD),TAMSX3("B1_COD")[1] ," "))

			If SB1->B1_TIPO == 'PA'

				dDataOP := SToD(ZBMOP->ZBM_DTMPFT)

				 //CriaOP(cProd,nQtd,cLocal,cNumOP,cObsOP)
				If CriaOP(AllTrim(ZBMOP->ZBN_COD),ZBMOP->ZBN_QTD,AllTrim(ZBMOP->ZB0_LOCAL),@cNumOP,@cObsOP,@cNSIOP,dDataOP)
					AtuZBNPA(ZBMOP->ZBN_ORDID,ZBMOP->ZBN_ITEMMP,"1",cNumOP,cObsOP)
					If ApontaOP(cNSIOP,ZBMOP->ZB0_LOCAL,dDataOP)
						AtuZBNPA(ZBMOP->ZBN_ORDID,ZBMOP->ZBN_ITEMMP,"2",cNumOP,cObsOP)
					Else
						lOk := .F.
					EndIf
				Else
					AtuZBNPA(ZBMOP->ZBN_ORDID,ZBMOP->ZBN_ITEMMP,"0","",cObsOP)
					lOk := .F.
				EndIf

			Else
				AtuZBNMP(ZBMOP->ZBN_ORDID,ZBMOP->ZBN_ITEMMP,"2")
			EndIf

			cOrdId := ZBMOP->ZBN_ORDID

			ZBMOP->(DbSkip())

			If AllTrim(cOrdId) <> Alltrim(ZBMOP->ZBN_ORDID)
				If lOk
					//Atualizar ZBM
					AltZBMSt(cOrdId,'1')
				Else
					lOk := .T.
				EndIf
			EndIf
        EndDo
    EndIf

	ZBMOP->(dbCloseArea())

return .T.


Static Function CriaOP(cProd,nQtd,cLocal,cNumOP,cObsOP,cNSIOP,dDataOP)

	Local nOpc    := 3 			//  3 - Inclusao || 4 - Alteracao || 5 - Exclusao
	Local aCabc   := {}

	Private lMsErroAuto := .F.

	aCabc  := { ;
		{'C2_FILIAL'    , xFilial("SC2")  ,NIL},;
		{'C2_ITEM'      , "01"                      ,".T."},;
		{'C2_SEQUEN'    , "001"                     ,".T."},;
		{'C2_PRODUTO'   , cProd                     ,NIL},;
		{"C2_QUANT"     , nQtd                      ,NIL},;
		{"C2_STATUS"    , 'N'                       ,NIL},;
		{"C2_LOCAL"     , cLocal					,NIL},;
		{"C2_CC"        , ''                        ,NIL},;
		{"C2_PRIOR"     , '500'                     ,NIL},;
		{"C2_DATPRI"    , dDataOP	                ,NIL},;
		{"C2_DATPRF"    , dDataBase	                ,NIL},;
		{"C2_EMISSAO"   , dDataOP	                ,NIL},;
		{'AUTEXPLODE'   , "S"                       ,NIL};
	}

	msExecAuto({|x,Y| Mata650(x,Y)},aCabc,nOpc)

	If !lMsErroAuto
		ConOut("Sucesso criação op! ")
	Else
		// MostraErro()
		ConOut("Erro criação op!")
		Return .F.
	EndIf

	cNumOP  := SC2->C2_NUM
	cObsOP  := ""
	cNSIOP	:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN

Return .T.

Static Function ApontaOP(cNumOp,cLocal,dDataOP)

	Local aVetor  := {}
	Local nOpc    := 3 //-Opção de execução da rotina, informado nos parametros quais as opções possiveisl

	Private lMsErroAuto := .F.

	aVetor :=	{;
		{"D3_OP" 		,cNumOp			,NIL},;
		{"D3_FILIAL"	,xFilial("SD3") ,NIL},;
		;//{"D3_QUANT"     ,cQuant   			,NIL},;
		;// {"D3_LOCAL"		,cLocal 		,NIL},;
		{"D3_EMISSAO"		,dDataOP 		,NIL},;
		{"D3_TM"    	,"001"    		,NIL}}

	MSExecAuto({|x, y| mata250(x, y)},aVetor, nOpc )

	If !lMsErroAuto
		ConOut("Sucesso apontamento op! ")
	Else
		// MostraErro()
		ConOut("Erro apontamento op!")
		Return .F.
	EndIf

Return .T.

Static Function AltZBMSt(cOrdemId,cNewStatus)
	dbSelectArea("ZBM")
	dbSetOrder(2)
	If dbSeek(xFilial("ZBM")+padr(cOrdemId,TAMSX3("ZBM_ORDID")[1] ," "))

		If !Empty(AllTrim(ZBM->ZBM_CLICOD))
			RecLock('ZBM', .F.)
				ZBM->ZBM_APONT     := '1'
				ZBM->ZBM_STATUS     := cNewStatus
			ZBM->(MsUnlock())
		Else
			RecLock('ZBM', .F.)
				ZBM->ZBM_APONT     := '1'
			ZBM->(MsUnlock())
		EndIf
	EndIf

return .T.


Static Function AtuZBNPA(cOrdemId,cItemMP,cStatus,cOP,cOPObs)
	dbSelectArea("ZBN")
	dbSetOrder(3)
	If dbSeek(xFilial("ZBN")+padr(cOrdemId,TAMSX3("ZBN_ORDID")[1] ," ")+padr(cItemMP,TAMSX3("ZBN_ITEMMP")[1] ," "))
		if !Empty(AllTrim(cOP))
			RecLock('ZBN', .F.)
				
				ZBN->ZBN_OPSTAT     := cStatus
				ZBN->ZBN_OP     	:= cOP
				ZBN->ZBN_OBSOP     	:= cOPObs

			ZBN->(MsUnlock())
		Else
			RecLock('ZBN', .F.)
				
				ZBN->ZBN_OPSTAT     := '0'
				ZBN->ZBN_OBSOP     	:= cOPObs

			ZBN->(MsUnlock())
		EndIf
	EndIf

return .T.


Static Function AtuZBNMP(cOrdemId,cItemMP,cNewStatus)
	dbSelectArea("ZBN")
	dbSetOrder(3)
	If dbSeek(xFilial("ZBN")+padr(cOrdemId,TAMSX3("ZBN_ORDID")[1] ," ")+padr(cItemMP,TAMSX3("ZBN_ITEMMP")[1] ," "))
		RecLock('ZBN', .F.)
			ZBN->ZBN_OPSTAT     := cNewStatus
		ZBM->(MsUnlock())
	EndIf

return .T.
