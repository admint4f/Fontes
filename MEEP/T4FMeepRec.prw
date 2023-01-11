#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

User Function IMMPRec(aCliPad,dDataInt)
Local aVetSE1       := {}
Local dEmissao      := date()
Local dVencto       := date()
Local nValor        := 0
Local cTipoVenda    := ""
Local cNatureza     := ""
Local cHist         := ""

//Local cCodCliPd     := aCliPad[1]
//Local cLojCliPd     := aCliPad[2]
Local cCodCliPd     := "000001"
Local cLojCliPd     := "01"

// Local cNatDin       := GetMV("MV_NATDINH")       // Natureza Dinheiro
// Local cNatCC        := GetMV("MV_NATCART")       // Natureza Cartão de Crédito
// Local cNatCD        := GetMV("MV_NATTEF")        // Natureza Cartão de Débito

Local cNatDin       := SuperGetMV("MV_MPNATDN",.F.,"101500")        // Natureza Dinheiro
Local cNatCC        := SuperGetMV("MV_MPNATCC",.F.,"101500")        // Natureza Cartão de Crédito
Local cNatCD        := SuperGetMV("MV_MPNATCD",.F.,"101500")        // Natureza Cartão de Débito

Local cContContab   := SuperGetMV("MV_MPCTCB",.F.,"")                  // Usar "6501010006          " para teste que roda
Local cPrefixo      := ""
Local cParcela      := ""

Default dDataInt    := date()-1

//Criar ZBP_STATUS e ZBP_DATAFT

    cQuery := " SELECT  "
    // cQuery += "     ZBP.ZBP_ORDID, "
    // cQuery += "     ZBP.ZBP_ITEM, "
    // cQuery += "     ZBP.ZBP_VALOR, "
    // cQuery += "     ZBP.ZBP_FEE, "
    cQuery += "     ZBP.ZBP_DATAFT, "
    cQuery += "     ZBP.ZBP_FORMA, "
    cQuery += "     ZBM.ZBM_EPEP, "
    cQuery += "     ZBM.ZBM_DTMPFT, "
    cQuery += "     SUM(ZBP.ZBP_VALOR-ZBP.ZBP_FEE) AS VLRTOT"
    cQuery += " FROM "
    cQuery += "		"+RetSQLName( "ZBP" )+" ZBP "
    cQuery += "     INNER JOIN "+RetSQLName( "ZBM" )+" ZBM ON ( "
    cQuery += "         ZBM.ZBM_ORDID = ZBP.ZBP_ORDID "
    cQuery += "     ) "
    cQuery += " WHERE "
    cQuery += "		ZBP.D_E_L_E_T_ <> '*' "
    // cQuery += "		AND ZBP.ZBP_PAYTP = '1'      "
    cQuery += "		AND ZBP.ZBP_STATUS = '0'      "
    cQuery += "		AND ZBM.ZBM_FILORC  = '"+FWFilial()+"'      "
    //cQuery += "		AND ZBM.ZBM_DTMPFT = '"+DTOS(dDataInt)+"'      "
    cQuery += "		AND ZBM.ZBM_DTMPFT BETWEEN '20211001' AND '20211031'      "
    cQuery += "		AND ZBM.ZBM_CANC <> '4'      "
    cQuery += " GROUP BY "
    cQuery += "     ZBP.ZBP_DATAFT, "
    cQuery += "     ZBP.ZBP_FORMA, "
    cQuery += "     ZBM.ZBM_EPEP, "
    cQuery += "     ZBM.ZBM_DTMPFT "
    TCQuery cQuery New Alias "ZBPORCAB"

    ZBPORCAB->(DbGoTop())
    If ZBPORCAB->(!Eof())
        While ZBPORCAB->( !Eof() )
            
            dbSelectArea("ZB0")
            dbSetOrder(1)
            dbSeek(xFilial("ZB0")+ZBPORCAB->ZBM_EPEP+FWCodEmp())

            Begin Transaction    //Inicia o controle de transação
                aVetSE1 := {}
                if ZBPORCAB->ZBP_FORMA == "CC"
                    cNatureza   := cNatCC
                    cParcela    := "A"
                elseif ZBPORCAB->ZBP_FORMA == "CD"
                    cNatureza   := cNatCD
                    cParcela    := "A"
                else 
                    cParcela    := ""
                    cNatureza   := cNatDin
                endif

                If alltrim(ZBPORCAB->ZBP_FORMA) == "R$"
                    cTipoVenda  := "R$"
                Else
                    cTipoVenda  := ZBPORCAB->ZBP_FORMA
                EndIf

                // cTipoVenda  := ZBPORCAB->ZBP_FORMA
                dEmissao    := stod(ZBPORCAB->ZBM_DTMPFT)
                dVencto     := stod(ZBPORCAB->ZBP_DATAFT)
                nValor      := ZBPORCAB->VLRTOT
                cHist       := "Meep - "+alltrim(ZBPORCAB->ZBM_EPEP)+" / "+alltrim(cTipoVenda)+" / "+dtoc(dEmissao)

                SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
                SA1->(MsSeek(xFilial("SA1")+cCodCliPd+cLojCliPd))

                aAdd(aVetSE1, {"E1_FILIAL",     FWxFilial("SE1"),               Nil})
                aAdd(aVetSE1, {"E1_NUM",        GetSx8Num("SE1", "E1_NUM"),     Nil})
                aAdd(aVetSE1, {"E1_PREFIXO",    "MEP",                          Nil})
                // aAdd(aVetSE1, {"E1_PARCELA",    cParcela,                       Nil})
                aAdd(aVetSE1, {"E1_TIPO",       cTipoVenda,                     Nil})
                aAdd(aVetSE1, {"E1_NATUREZ",    cNatureza,                      Nil})
                aAdd(aVetSE1, {"E1_CLIENTE",    SA1->A1_COD,                    Nil})
                aAdd(aVetSE1, {"E1_LOJA",       SA1->A1_LOJA,                   Nil})
                aAdd(aVetSE1, {"E1_NOMCLI",     SA1->A1_NOME,                   Nil})
                aAdd(aVetSE1, {"E1_EMISSAO",    dEmissao,                       Nil})
                aAdd(aVetSE1, {"E1_VENCTO",     dVencto,                        Nil})
                aAdd(aVetSE1, {"E1_ITEM",       ZBPORCAB->ZBM_EPEP,             Nil})
                aAdd(aVetSE1, {"E1_PARCELA",    cParcela,                       Nil})
                aAdd(aVetSE1, {"E1_PREFIXO",    cPrefixo,                       Nil})
                aAdd(aVetSE1, {"E1_CCONTAB",    cContContab,                    Nil})
                // aAdd(aVetSE1, {"E1_VENCREA", dVencReal,                      Nil})
                aAdd(aVetSE1, {"E1_VALOR",      nValor,                         Nil})
                aAdd(aVetSE1, {"E1_VLCRUZ",     nValor,                         Nil})
                // aAdd(aVetSE1, {"E1_LA",         'S',                         Nil})
                // aAdd(aVetSE1, {"E1_VALJUR",  nValJuros,                      Nil})
                // aAdd(aVetSE1, {"E1_PORCJUR", nPorcJuros,                     Nil})
                aAdd(aVetSE1, {"E1_HIST",       cHist,                          Nil})
                aAdd(aVetSE1, {"E1_MOEDA",      1,                              Nil})
                aAdd(aVetSE1, {"E1_FLUXO",      "S",                            Nil})

                //Chama a rotina automática
                lMsErroAuto := .F.
                MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)
                
                //Se houve erro, mostra o erro ao usuário e desarma a transação
                If lMsErroAuto
                    MostraErro()
                    DisarmTransaction()
                Else
                    cUpdZBP := " UPDATE "+RetSQLName( "ZBP" )+" ZBP "
                    cUpdZBP += " SET ZBP.ZBP_STATUS = '1' "
                    cUpdZBP += " where "
                    cUpdZBP += "     exists ( "
                    cUpdZBP += "         SELECT ZBM.ZBM_ORDID  "
                    cUpdZBP += "         from "+RetSQLName( "ZBM" )+" ZBM "
                    cUpdZBP += "         where "
                    cUpdZBP += "             ZBM.ZBM_FILORC  = '"+FWFilial()+"' "
                    cUpdZBP += "             AND ZBM.ZBM_EPEP    = '"+ZBPORCAB->ZBM_EPEP+"' "
                    cUpdZBP += "             AND ZBM.ZBM_DTMPFT  = '"+ZBPORCAB->ZBM_DTMPFT+"' "
                    cUpdZBP += "             AND ZBM.D_E_L_E_T_ <> '*'  "
                    cUpdZBP += "             AND ZBM.ZBM_ORDID = ZBP.ZBP_ORDID "
                    cUpdZBP += "     ) "
                    cUpdZBP += "     AND ZBP.D_E_L_E_T_ <> '*'  "
                    cUpdZBP += "     AND ZBP.ZBP_STATUS  = '0'  "
                    cUpdZBP += "     AND ZBP.ZBP_DATAFT  = '"+ZBPORCAB->ZBP_DATAFT+"'  "
                    cUpdZBP += "     AND ZBP.ZBP_FORMA   = '"+ZBPORCAB->ZBP_FORMA+"' "
                    TcSqlExec(cUpdZBP) 
                EndIf
            End Transaction
            ZBPORCAB->(DbSkip())
        EndDo
    EndIf
    ZBPORCAB->(dbCloseArea())
return .T.
