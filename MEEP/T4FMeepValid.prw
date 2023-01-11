#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#INCLUDE "tbiconn.ch"

/*----------------------------------------------------------------------*
 | Func:  U_IMValCup()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Função que chama o JOB que valida venda e cria os controles 	|
 |        de status da integração.									 	|
 *----------------------------------------------------------------------*/

User Function IMValCup()
	// local lJobGRV	:= .T.

    cQuery := " SELECT L1_FILIAL, L1_NUM, L1_SITUA "
	cQuery += " FROM "
	cQuery += "		"+RetSQLName( "SL1" )+" SL1 "
	cQuery += " WHERE "
	cQuery += "		SL1.D_E_L_E_T_ <> '*' "
	cQuery += "		AND SL1.L1_SITUA = 'RX' "
	cQuery += "		AND SL1.L1_FILIAL =  '"+xFilial("SL1")+"' "
	cQuery += " GROUP BY L1_FILIAL, L1_NUM, L1_SITUA "
	TCQuery cQuery New Alias "SL1GRVBATCH"

    SL1GRVBATCH->(DbGoTop())
	If SL1GRVBATCH->(!Eof())
		
		U_T4FLJGRV(FWCodEmp(),FWFilial())

		While SL1GRVBATCH->( !Eof() )
			dbSelectArea("SL1")
			dbSetOrder(1)
			If dbSeek(SL1GRVBATCH->L1_FILIAL+SL1GRVBATCH->L1_NUM)
				If ALLTRIM(SL1->L1_SITUA) == "OK"
					cQuery := " SELECT ZBM_FILORC, ZBM_ORDID, ZBM_NUM, ZBM_STORE, ZBN_ITEMO, ZBN_COD, ZBN_QTD, ZBN_TES "
					cQuery += " FROM "
					cQuery += "		"+RetSQLName( "ZBM" )+" ZBM "
					cQuery += "     INNER JOIN "+RetSQLName( "ZBN" )+" ZBN ON ( "
					cQuery += "         ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "
					cQuery += "     ) "
					cQuery += " WHERE "
					cQuery += "		    ZBM.D_E_L_E_T_ <> '*' "
					cQuery += "		AND ZBM.ZBM_NUM = '"+SL1->L1_NUM+"' "
					cQuery += "		AND ZBM.ZBM_FILORC  = '"+SL1->L1_FILIAL+"' "
					cQuery += " ORDER BY ZBM_FILORC, ZBM_NUM, ZBN_ITEMO "
					TCQuery cQuery New Alias "ZBMST3"
					ZBMST3->(DbGoTop())
					If ZBMST3->(!Eof())
						dbSelectArea("ZBM")
						dbSetOrder(2)		// Filial Orcamento + Num Orc + Item Orc
						If dbSeek(xFilial("ZBM")+padr(ZBMST3->ZBM_ORDID,TAMSX3("ZBM_ORDID")[1] ," "))
							RecLock('ZBM', .F.)
								ZBM->ZBM_STATUS      := "3"
								// ZBM->ZBM_DTFIM       := date()
								// ZBM->ZBM_HRFIM       := time()
							ZBM->(MsUnlock())
							conout("[Integração Meep] - SIT OK - "+ZBM->ZBM_NUM+" | "+DTOC(DATE())+" "+TIME())

							If ZBM->ZBM_CANC == "4"
								RecLock('SL1', .F.)
									SL1->L1_SITUA      := "X1"
								SL1->(MsUnlock())

								RecLock('ZBM', .F.)
									ZBM->ZBM_STATUS      := "5"		//Cancelada
								ZBM->(MsUnlock())
							EndIf
						EndIf

						dbSelectArea("SF4")
						dbSetOrder(1)		// Filial + TES
						If dbSeek(xFilial("SF4")+ZBN_TES)
							IF SF4->F4_ESTOQUE == "S"
								While ZBMST3->( !Eof() )
									dbSelectArea("ZB2")
									dbSetOrder(1)		//Filial + StoreIdMeep + CodProdutoProtheus (ZBM_STORE+ZBN_COD)
									If dbSeek(xFilial("ZB2")+ZBMST3->ZBM_STORE+ZBMST3->ZBN_COD)
										RecLock('ZB2', .F.)
											ZB2->ZB2_QTBAIX := ZB2->ZB2_QTBAIX+ZBMST3->ZBN_QTD
											ZB2->ZB2_QTINT := ZB2->ZB2_QTINT-ZBMST3->ZBN_QTD
										ZB2->(MsUnlock())
									EndIf
									dbSelectArea("ZBN")
									dbSetOrder(1)		// Filial + OrdId + Item Orc
									If dbSeek(xFilial("ZBN")+ZBM_ORDID+ZBN_ITEMO)
										ZBN_STATUS	:= "1"
									EndIf
									ZBMST3->(DbSkip())
								EndDo
							EndIf
						EndIf
					EndIf
					ZBMST3->(dbCloseArea())
				EndIf
			endif

			SL1GRVBATCH->(DbSkip())
        EndDo
    EndIf

	SL1GRVBATCH->(dbCloseArea())
    
return .T.
