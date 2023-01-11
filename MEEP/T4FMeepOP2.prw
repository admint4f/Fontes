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
	Local cNewStatus	:= "2"
	Local aProd			:= {}		//{ [CodProd,cLocal,Qtd1,lOPApontada1,cOP1,cOPObs] }
	Local i 			:= 0
	Local cNumOP		:= ""
	Local cObsOP		:= ""

    cQuery := " SELECT  "													+ CRLF
	cQuery += "		ZBN.*, "                                          		+ CRLF
	cQuery += "		ZB0.ZB0_LOCAL "                                         + CRLF
	cQuery += " FROM "														+ CRLF
	cQuery += "		"+RetSQLName( "ZBM" )+" ZBM "							+ CRLF
	cQuery += " INNER JOIN "+RetSQLName( "ZBN" )+" ZBN ON ( "				+ CRLF
	cQuery += " 	ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "							+ CRLF
	cQuery += "		ZBN.D_E_L_E_T_ <> '*' "									+ CRLF
	cQuery += " ) "															+ CRLF
	cQuery += " INNER JOIN "+RetSQLName( "ZB0" )+" ZB0 ON ( "				+ CRLF
	cQuery += " 	ZBM.ZBM_STORE = ZB0.ZB0_MEEP "							+ CRLF
	cQuery += " 	ZB0.ZB0_ATIVO = '1' "									+ CRLF
	cQuery += " 	ZB0.ZB0_FIL = '" + FWFilial() + "' "					+ CRLF
	cQuery += " 	ZB0.ZB0_EMP = '" + FWCodEmp() + "' "					+ CRLF
	cQuery += "		ZB0.D_E_L_E_T_ <> '*' "									+ CRLF
	cQuery += " ) "															+ CRLF
	cQuery += " WHERE "														+ CRLF
	cQuery += "		ZBM.D_E_L_E_T_ <> '*' "									+ CRLF
	cQuery += "		AND ZBM.ZBM_FILIAL = '"+xFilial("ZBM")+"' "				+ CRLF
	cQuery += "		AND ZBM.ZBM_APONT = '0' "								+ CRLF
	cQuery += " ORDER BY "													+ CRLF
	cQuery += "		ZBM.ZBM_ORDID "											+ CRLF
	TCQuery cQuery New Alias "ZBMOP"

	ZBMOP->(DbGoTop())
	If ZBMOP->(!Eof())
		While ZBMOP->( !Eof() )

			nPosCod := aScan(aProd,{|x| AllTrim(x[1]) + AllTrim(x[2]) == Alltrim(ZBMOP->ZBN_COD) + AllTrim(ZBMOP->ZB0_LOCAL) }) //Procura produto

			If nPosCod > 0 //Achou o produto
				aProd[nPosCod][3] += ZBMOP->ZBN_QTD
			Else
				AAdd(aProd,[ZBMOP->ZBN_COD,ZBMOP->ZB0_LOCAL,ZBMOP->ZBN_QTD,.F.,,])
			EndIf

			ZBMOP->(DbSkip())
        EndDo
		ZBMOP->(DbGoTop())
    EndIf

	//Criação de OP
	For i := 1 to Len(aProd)

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+padr(AllTrim(aProd[i][1]),TAMSX3("B1_COD")[1] ," "))

		if AllTrim(SB1->B1_TIPO) == 'PA'
			If CriaOP(aProd[i][1],aProd[i][3],aProd[i][2],@cNumOP,@cObsOP)
				aProd[i][4] := .T.
				aProd[i][5]	:= cNumOP	//Num OP
				aProd[i][6]	:= cObsOP	//Obs
			EndIf
		EndIf

	Next i

	//Atualiza ZBN e ZBM

	ZBMOP->(DbGoTop())
	If ZBMOP->(!Eof())
		cNewStatus := "1"
		While ZBMOP->( !Eof() )

			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+padr(AllTrim(ZBMOP->ZBN_COD),TAMSX3("B1_COD")[1] ," "))

			If SB1->B1_TIPO == 'PA'
			
				nPosCod := aScan(aProd,{|x| AllTrim(x[1]) + AllTrim(x[2]) == Alltrim(ZBMOP->ZBN_COD) + AllTrim(ZBMOP->ZB0_LOCAL) }) //Procura produto

				If aProd[nPosCod][4]
					AtuZBNPA(ZBMOP->ZBN_ORDID,ZBMOP->ZBN_ITEMMP,cNewStatus,aProd[nPosCod][5],aProd[nPosCod][6])
				Else
					AtuZBNPA(ZBMOP->ZBN_ORDID,ZBMOP->ZBN_ITEMMP,"0","",aProd[nPosCod][6])
				EndIf

			Else
				AtuZBNMP(ZBMOP->ZBN_ORDID,ZBMOP->ZBN_ITEMMP,cNewStatus)
			EndIf

			ZBMOP->(DbSkip())
        EndDo
    EndIf

	//Apontamento de OP
	For i := 1 to Len(aProd)

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+padr(AllTrim(aProd[i][1]),TAMSX3("B1_COD")[1] ," "))

		if AllTrim(SB1->B1_TIPO) == 'PA'
			If CriaOP(aProd[i][1],aProd[i][3],aProd[i][2],@cNumOP,@cObsOP)
				aProd[i][4] := .T.
				aProd[i][5]	:= cNumOP	//Num OP
				aProd[i][6]	:= cObsOP	//Obs
			EndIf
		EndIf

	Next i

	//Fecha Tabela Temp
	ZBMOP->(dbCloseArea())


return .T.


User Function CriaOP(cProd,nQtd,cLocal,cNumOP,cObsOP)

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
		{"C2_DATPRI"    , DDATABASE                 ,NIL},;
		{"C2_DATPRF"    , DDATABASE                 ,NIL},;
		{'AUTEXPLODE'   , "S"                       ,NIL};
	}

	msExecAuto({|x,Y| Mata650(x,Y)},aCabc,nOpc)

	If !lMsErroAuto
		ConOut("Sucesso! ")
	Else
		ConOut("Erro!")
		Return .F.
	EndIf

	cNumOP  := SC2->C2_NUM
	cObsOP  := ""

	//Chama o apontamento da ordem de produção.
	// xProduz(cProd,cNumOp,cQuant) //CHAMA A ROTINA DE APONTAMENTO DE PRODUCAO

Return .T.

Static Function xProduz(cProd,cNumOp,cQuant)

	Local aVetor  := {}
	Local nOpc    := 3 //-Opção de execução da rotina, informado nos parametros quais as opções possiveisl
	Local _aAreaOP:= GetArea() // ARMAZENA ÁREA CORRENTE

	Private MsErroAuto := .F.

	aVetor :=	{{"D3_OP" 		,cNumOp			,NIL},;
		{"D3_FILIAL"	,xFilial("SD3") ,NIL},;
		;//{"D3_QUANT"     ,cQuant   			,NIL},;
		{"D3_TM"       	,"010"    		,NIL}}

	MSExecAuto({|x, y| mata250(x, y)},aVetor, nOpc )

	If !lMsErroAuto
		ConOut("Sucesso! ")

		//Limpa as variaveis para zerar o conteudo da tela
		cProd := space(6)
		cDesc := space(100)
		cQtd := 0
	Else
		//	ConOut("Erro!")
		MostraErro()
	EndIf

	RestArea(_aAreaOP)

Return

Static Function AltZBMSt(cOrdemId,cNewStatus)
	dbSelectArea("ZBM")
	dbSetOrder(2)
	If dbSeek(xFilial("ZBM")+padr(cOrdemId,TAMSX3("ZBM_ORDID")[1] ," "))
		RecLock('ZBM', .F.)
			
			ZBM->ZBM_APONT     := '1'

			If !Empty(AllTrim(ZBM->ZBM_CLICOD))
				ZBM->ZBM_STATUS     := cNewStatus
			EndIf

		ZBM->(MsUnlock())
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

			ZBM->(MsUnlock())
		Else
			RecLock('ZBN', .F.)
				
				ZBN->ZBN_OPSTAT     := '0'
				ZBN->ZBN_OBSOP     	:= cOPObs

			ZBM->(MsUnlock())
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
