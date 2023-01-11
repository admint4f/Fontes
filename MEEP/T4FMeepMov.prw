#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

/*----------------------------------------------------------------------*
 | Func:  U_IMMPMov()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Função responsável pelo consumo do estoque pela Mov Multipla.	|
 *----------------------------------------------------------------------*/

User Function IMMPMov(dDataInt)
Local _aCab1        := {}
Local _aItem        := {}
Local _aListItem    := {}
Local cCodigoTM     := SuperGetMV("MV_MPTESBX",.F.,"501")
Local cCentCust     := SuperGetMV("MV_MPCCBX",.F.,"        ")
Local cQuery        := ""
Local cEpepAtu      := ""
Private lMsHelpAuto := .F. // se .t. direciona as mensagens de help
Private lMsErroAuto := .F. //necessario a criacao

Default dDataInt    := date()-1

    cQuery := " SELECT  "
    cQuery += "     ZBN.ZBN_COD, "
    cQuery += "     ZBM.ZBM_EPEP, "
    cQuery += "     ZB0.ZB0_LOCAL, "
    cQuery += "     ZBN.ZBN_VLUN, "
    cQuery += "     SUM(ZBN.ZBN_QTD) AS QTD"
    cQuery += " FROM "
    cQuery += "		"+RetSQLName( "ZBN" )+" ZBN "
    cQuery += "     INNER JOIN "+RetSQLName( "ZBM" )+" ZBM ON ( "
    cQuery += "         ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "
    cQuery += "     ) "
    cQuery += "     INNER JOIN "+RetSQLName( "ZB0" )+" ZB0 ON ( "
    cQuery += "         ZBM.ZBM_STORE = ZB0.ZB0_MEEP AND "
    cQuery += "         ZB0.ZB0_EMP = '"+FWCodEmp()+"' "
    cQuery += "     ) "
    cQuery += " WHERE "
    cQuery += "		ZBN.D_E_L_E_T_ <> '*' "
    cQuery += "		AND ZBM.D_E_L_E_T_ <> '*' "
    cQuery += "		AND ZB0.D_E_L_E_T_ <> '*' "
    cQuery += "		AND ZBN.ZBN_STATUS = '0'      "
    cQuery += "		AND ZBM.ZBM_FILORC  = '"+FWFilial()+"'      "
    cQuery += "		AND ZBM.ZBM_DTMPFT = '"+DTOS(dDataInt)+"'      "
    cQuery += " GROUP BY "
    cQuery += "     ZBN.ZBN_COD, "
    cQuery += "     ZBM.ZBM_EPEP, "
    cQuery += "     ZBN.ZBN_VLUN, "
    cQuery += "     ZB0.ZB0_LOCAL "
    cQuery += " ORDER BY "
    cQuery += "     ZBM.ZBM_EPEP, "
    cQuery += "     ZBN.ZBN_COD, "
    cQuery += "     ZBN.ZBN_VLUN, "
    cQuery += "     ZB0.ZB0_LOCAL "
    TCQuery cQuery New Alias "ZBNMEEPMOB"

    ZBNMEEPMOB->(DbGoTop())
    If ZBNMEEPMOB->(!Eof())
        While ZBNMEEPMOB->( !Eof() )
            _aListItem      := {}
            _aCab1          := {}
            _aItem          := {}
            lMsErroAuto     := .F.

            Begin Transaction    //Inicia o controle de transação

                // _aCab1 := {{"D3_DOC" ,NextNumero("SD3",2,"D3_DOC",.T.), NIL},;
                //         {"D3_TM" ,cCodigoTM , NIL},;
                //         {"D3_CC" ,cCentCust, NIL},;
                //         {"D3_EMISSAO" ,dDataInt, NIL}}

                _aCab1 := {{"D3_DOC" ,GetSxeNum("SD3","D3_DOC"), NIL},;
                        {"D3_TM" ,cCodigoTM , NIL},;
                        {"D3_CC" ,cCentCust, NIL},;
                        {"D3_EMISSAO" ,dDataInt, NIL}}

                cEpepAtu    := ZBNMEEPMOB->ZBM_EPEP

                While cEpepAtu == ZBNMEEPMOB->ZBM_EPEP

                    SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
                    SB1->(MsSeek(xFilial("SB1")+ZBNMEEPMOB->ZBN_COD))

                    SB2->(DbSetOrder(1)) //B2_FILIAL+B2_COD+B2_LOCAL
                    SB2->(MsSeek(xFilial("SB2")+ZBNMEEPMOB->ZBN_COD+ZBNMEEPMOB->ZB0_LOCAL))
                
                    If SB2->B2_QATU > ZBNMEEPMOB->QTD

                        _aItem :=  {{"D3_COD"       ,SB1->B1_COD                                ,NIL},;
                                    {"D3_UM"        ,SB1->B1_UM                                 ,NIL},; 
                                    {"D3_QUANT"     ,ZBNMEEPMOB->QTD                            ,NIL},;
                                    {"D3_ITEMCTA"   ,ZBNMEEPMOB->ZBM_EPEP                       ,NIL},;
                                    {"D3_LOCAL"     ,ZBNMEEPMOB->ZB0_LOCAL                      ,NIL}}
                                    
                        aadd(_aListItem,_aItem)
                    EndIF

                    cEpepAtu := ZBNMEEPMOB->ZBM_EPEP
                    
                    ZBNMEEPMOB->(DbSkip())

                EndDo

                lMsErroAuto := .F.
                MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_aListItem,3)
                
                //Se houve erro, mostra o erro ao usuário e desarma a transação
                If lMsErroAuto
                    // MostraErro()
                    RollBackSX8()
                    DisarmTransaction()
                Else
                    ConfirmSX8()
                    
                    cUpdZBN1St := " UPDATE "+RetSQLName( "ZBN" )+" ZBN "
                    cUpdZBN1St += " SET ZBN.ZBN_STATUS = '1' "
                    cUpdZBN1St += " where "
                    cUpdZBN1St += "     exists ( "
                    cUpdZBN1St += "         select ZBM.ZBM_ORDID  "
                    cUpdZBN1St += "         from "+RetSQLName( "ZBM" )+" ZBM "
                    cUpdZBN1St += "         where "
                    cUpdZBN1St += "             ZBM.ZBM_FILORC  = '"+FWFilial()+"' "
                    cUpdZBN1St += "             AND ZBM.D_E_L_E_T_ <> '*'  "
                    cUpdZBN1St += "             AND ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "
                    cUpdZBN1St += "		     AND ZBM.ZBM_DTMPFT = '"+DTOS(dDataInt)+"'      "
                    cUpdZBN1St += "     ) "
                    cUpdZBN1St += "     AND ZBN.D_E_L_E_T_ <> '*'  "
                    cUpdZBN1St += "     AND ZBN.ZBN_STATUS  = '0'  "
                    TcSqlExec(cUpdZBN1St) 
                EndIf
            End Transaction
            ZBNMEEPMOB->(DbSkip())
        EndDo

        //Atualização ZB2 e ZBN

        cQuery := " SELECT  "
        cQuery += "     ZBN.ZBN_COD, "
        cQuery += "     ZBM.ZBM_STORE, "
        cQuery += "     ZBM.ZBM_EPEP, "
        cQuery += "     ZB0.ZB0_LOCAL, "
        cQuery += "     SUM(ZBN.ZBN_QTD) AS QTD"
        cQuery += " FROM "
        cQuery += "		"+RetSQLName( "ZBN" )+" ZBN "
        cQuery += "     INNER JOIN "+RetSQLName( "ZBM" )+" ZBM ON ( "
        cQuery += "         ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "
        cQuery += "     ) "
        cQuery += "     INNER JOIN "+RetSQLName( "ZB0" )+" ZB0 ON ( "
        cQuery += "         ZBM.ZBM_STORE = ZB0.ZB0_MEEP AND "
        cQuery += "         ZB0.ZB0_EMP = '"+FWCodEmp()+"' "
        cQuery += "     ) "
        cQuery += " WHERE "
        cQuery += "		ZBN.D_E_L_E_T_ <> '*' "
        cQuery += "		AND ZBM.D_E_L_E_T_ <> '*' "
        cQuery += "		AND ZB0.D_E_L_E_T_ <> '*' "
        cQuery += "		AND ZBN.ZBN_STATUS = '1'      "
        cQuery += "		AND ZBM.ZBM_FILORC  = '"+FWFilial()+"'      "
        cQuery += "		AND ZBM.ZBM_DTMPFT = '"+DTOS(dDataInt)+"'      "
        cQuery += " GROUP BY "
        cQuery += "     ZBN.ZBN_COD, "
        cQuery += "     ZBM.ZBM_EPEP, "
        cQuery += "     ZBM.ZBM_STORE, "
        cQuery += "     ZB0.ZB0_LOCAL "
        cQuery += " ORDER BY "
        cQuery += "     ZBM.ZBM_EPEP, "
        cQuery += "     ZBM.ZBM_STORE, "
        cQuery += "     ZBN.ZBN_COD, "
        cQuery += "     ZB0.ZB0_LOCAL "
        TCQuery cQuery New Alias "ZBNCTRLEST"

        ZBNCTRLEST->(DbGoTop())
        If ZBNCTRLEST->(!Eof())
            While ZBNCTRLEST->( !Eof() )
                dbSelectArea("ZB2")
                dbSetOrder(1)		//Filial + StoreIdMeep + CodProdutoProtheus (ZBM_STORE+ZBN_COD)
                If dbSeek(xFilial("ZB2")+ZBNCTRLEST->ZBM_STORE+ZBNCTRLEST->ZBN_COD)
                    RecLock('ZB2', .F.)
                        ZB2->ZB2_QTBAIX := ZB2->ZB2_QTBAIX+ZBNCTRLEST->QTD
                        ZB2->ZB2_QTINT := ZB2->ZB2_QTINT-ZBNCTRLEST->QTD
                    ZB2->(MsUnlock())
                EndIf
                ZBNCTRLEST->(DbSkip())
            EndDo
        EndIf
        ZBNCTRLEST->(dbCloseArea())

        cUpdZBN2St := " UPDATE "+RetSQLName( "ZBN" )+" ZBN "
        cUpdZBN2St += " SET ZBN.ZBN_STATUS = '2' "
        cUpdZBN2St += " where "
        cUpdZBN2St += "     exists ( "
        cUpdZBN2St += "         select ZBM.ZBM_ORDID  "
        cUpdZBN2St += "         from "+RetSQLName( "ZBM" )+" ZBM "
        cUpdZBN2St += "         where "
        cUpdZBN2St += "             ZBM.ZBM_FILORC  = '"+FWFilial()+"' "
        cUpdZBN2St += "             AND ZBM.D_E_L_E_T_ <> '*'  "
        cUpdZBN2St += "             AND ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "
        cUpdZBN2St += "		     AND ZBM.ZBM_DTMPFT = '"+DTOS(dDataInt)+"'      "
        cUpdZBN2St += "     ) "
        cUpdZBN2St += "     AND ZBN.D_E_L_E_T_ <> '*'  "
        cUpdZBN2St += "     AND ZBN.ZBN_STATUS  = '1'  "
        TcSqlExec(cUpdZBN2St) 

    EndIf
    ZBNMEEPMOB->(dbCloseArea())

return .T.

