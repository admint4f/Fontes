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
Local nFaltaEnviar  := 0
Local nQtdItem      := 0
Private lMsHelpAuto := .F. // se .t. direciona as mensagens de help
Private lMsErroAuto := .F. //necessario a criacao

Default dDataInt    := date()-1

    cQuery := " SELECT  "
    cQuery += "     ZBN.ZBN_COD, "
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
    cQuery += "		AND ZBN.ZBN_STATUS = '0'      "
    cQuery += "		AND ZBM.ZBM_FILORC  = '"+FWFilial()+"'      "
    cQuery += "		AND ZBM.ZBM_DTMPFT = '"+DTOS(dDataInt)+"'      "
    cQuery += " GROUP BY "
    cQuery += "     ZBN.ZBN_COD, "
    cQuery += "     ZBM.ZBM_EPEP, "
    cQuery += "     ZB0.ZB0_LOCAL "
    cQuery += " ORDER BY "
    cQuery += "     ZBM.ZBM_EPEP, "
    cQuery += "     ZBN.ZBN_COD, "
    cQuery += "     ZB0.ZB0_LOCAL "
    TCQuery cQuery New Alias "ZBNMOVMEEP"

    ZBNMOVMEEP->(DbGoTop())
    If ZBNMOVMEEP->(!Eof())
        While ZBNMOVMEEP->( !Eof() )
            _aListItem      := {}
            _aCab1          := {}
            _aItem          := {}
            lMsErroAuto     := .F.

            Begin Transaction    //Inicia o controle de transação

                _aCab1 := {{"D3_DOC" ,NextNumero("SD3",2,"D3_DOC",.T.), NIL},;
                        {"D3_TM" ,cCodigoTM , NIL},;
                        {"D3_CC" ,cCentCust, NIL},;
                        {"D3_EMISSAO" ,date(), NIL}}

                cEpepAtu    := ZBNMOVMEEP->ZBM_EPEP

                While cEpepAtu == ZBNMOVMEEP->ZBM_EPEP

                    cQuery := " SELECT  "
                    cQuery += "     SUM(SB2.B2_QATU) AS QTD"
                    cQuery += " FROM "
                    cQuery += "		"+RetSQLName( "SB2" )+" SB2 "
                    cQuery += " WHERE "
                    cQuery += "		SB2.D_E_L_E_T_ <> '*' "
                    cQuery += "		AND SB2.B2_COD = '"+ZBNMOVMEEP->ZBN_COD+"' "
                    cQuery += "		AND SB2.B2_FILIAL = '"+xFilial("SBF")+"' "
                    cQuery += "		AND SB2.B2_LOCAL = '"+ZBNMOVMEEP->ZB0_LOCAL+"' "
                    TCQuery cQuery New Alias "SLDSBFMEEPMOV"

                    SLDSBFMEEPMOV->(DbGoTop())

                    If SLDSBFMEEPMOV->(!Eof())
                        cQtdEnd := SLDSBFMEEPMOV->QTD
                    else
                        cQtdEnd := 0
                    EndIf
                    SLDSBFMEEPMOV->(dbCloseArea())

                    if cQtdEnd > ZBNMOVMEEP->QTD
                        SB1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
                        SB1->(MsSeek(xFilial("SB1")+ZBNMOVMEEP->ZBN_COD))

                        cQuery := " SELECT  "
                        cQuery += "     SBF.BF_LOTECTL, "
                        cQuery += "     SUM(SBF.B2_QATU) AS QTD"
                        cQuery += " FROM "
                        cQuery += "		"+RetSQLName( "SBF" )+" SBF "
                        cQuery += " WHERE "
                        cQuery += "		SBF.D_E_L_E_T_ <> '*' "
                        cQuery += "		AND SBF.BF_PRODUTO = '"+ZBNMOVMEEP->ZBN_COD+"' "
                        cQuery += "		AND SBF.BF_FILIAL = '"+xFilial("SBF")+"' "
                        cQuery += "		AND SBF.BF_LOCAL = '"+ZBNMOVMEEP->ZB0_LOCAL+"' "
                        cQuery += " GROUP BY "
                        cQuery += "     SBF.BF_LOTECTL "
                        TCQuery cQuery New Alias "SLDSBFMEEPMOV"

                        SLDSBFMEEPMOV->(DbGoTop())
                        
                        nFaltaEnviar := ZBNMOVMEEP->QTD

                        while nFaltaEnviar > 0
                            if SLDSBFMEEPMOV->QTD >= nFaltaEnviar
                                nQtdItem := nFaltaEnviar
                            else
                                nQtdItem := SLDSBFMEEPMOV->QTD
                            endif
                            
                            _aItem :=  {{"D3_COD"       ,SB1->B1_COD                ,NIL},;
                                        {"D3_UM"        ,SB1->B1_UM                 ,NIL},; 
                                        {"D3_QUANT"     ,nQtdItem                   ,NIL},;
                                        {"D3_LOCAL"     ,ZBNMOVMEEP->ZB0_LOCAL      ,NIL},;
                                        {"D3_LOTECTL"   ,SLDSBFMEEPMOV->BF_LOTECTL  ,NIL},;
                                        {"D3_LOCALIZ"   ,ZBNMOVMEEP->ZB0_LOCALI     ,NIL}}
                            aadd(_aListItem,_aItem)

                            nFaltaEnviar := nFaltaEnviar-nQtdItem

                            SLDSBFMEEPMOV->(DbSkip())
                        enddo

                        SLDSBFMEEPMOV->(dbCloseArea())
                    else
                        //Configurar erro
                    Endif
                    cEpepAtu := ZBNMOVMEEP->ZBM_EPEP
                    ZBNMOVMEEP->(DbSkip())
                EndDo

                lMsErroAuto := .F.
                MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_aListItem,3)
                
                //Se houve erro, mostra o erro ao usuário e desarma a transação
                If lMsErroAuto
                    // MostraErro()
                    DisarmTransaction()
                Else
                    cUpdZBN := " UPDATE "+RetSQLName( "ZBN" )+" ZBN "
                    cUpdZBN += " SET ZBN.ZBN_STATUS = '1' "
                    cUpdZBN += " where "
                    cUpdZBN += "     exists ( "
                    cUpdZBN += "         select ZBM.ZBM_ORDID  "
                    cUpdZBN += "         from "+RetSQLName( "ZBM" )+" ZBM "
                    cUpdZBN += "         where "
                    cUpdZBN += "             ZBM.ZBM_FILORC  = '"+FWFilial()+"' "
                    cUpdZBN += "             AND ZBM.D_E_L_E_T_ <> '*'  "
                    cUpdZBN += "             AND ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "
                    cUpdZBN += "		     AND ZBM.ZBM_DTMPFT = '"+DTOS(dDataInt)+"'      "
                    cUpdZBN += "     ) "
                    cUpdZBN += "     AND ZBN.D_E_L_E_T_ <> '*'  "
                    cUpdZBN += "     AND ZBN.ZBN_STATUS  = '0'  "
                    TcSqlExec(cUpdZBN) 
                EndIf
            End Transaction
            ZBNMOVMEEP->(DbSkip())
        EndDo
    EndIf
    ZBNMOVMEEP->(dbCloseArea())
return .T.

