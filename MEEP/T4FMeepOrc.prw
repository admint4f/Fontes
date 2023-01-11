#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#INCLUDE "tbiconn.ch"

/*----------------------------------------------------------------------*
 | Func:  U_IMCadOrc()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Função responsável por gerar as tabelas SL1, SL2 e SL4 do    	|
 |        SIGALOJA via ExecAuto.                                        |
 | Parm:  cEmpJOB:      Empresa que será criado as tabelas.          	|
 |        cFilJob:      Filial que será criado as tabelas.           	|
 |        aOrdIdList:   Array com os OrdID da tabela ZBM.             	|
 *----------------------------------------------------------------------*/

User Function IMCadOrc(cEmpJOB,cFilJob,aOrdIdList)
    Local nItem         := 1
    Local cVendaAnt     := ""

    Local _aCab         := {} //Array do Cabeçalho do Orçamento
    Local _aItem        := {} //Array dos Itens do Orçamento
    Local _aParcelas    := {} //Array das Parcelas do Orçamento

    Local aZBMAtu       := {}

    Local lExec701      := .T.
    Local cObs          := ""
    Local cCodErro      := ""
    Local nVlrTot       := 0
    Local nValPag       := 0

    Local nTabela       := 2
    Local cProdAnt      := ""

    Local dVirada       := date()

    //Definidas
    Local nComissao     := 0
    Local cMenNota      := "INTEGRAÇÃO MEEP"
    Local _cVendedor    := "000001"
    Local cSitua        := "RX"
    // Local cPDV          := "MEEP"
    Local cImprime      := "5S"
    Local cTipoVenda    := "V"
    Local cPDV          := ""
    Local cEstacao      := ""
    Local cSerSat       := ""

    //Precisa Verificar
    Local cCodBanco     := "237"

    Local dDataMeep     := date()
    Local dDataPaym     := date()

    Local nTotMov       := 0
    Local nOrdId        := 0
    Private lMsHelpAuto := .T. //Variavel de controle interno do ExecAuto
    Private lMsErroAuto := .F. //Variavel que informa a ocorrência de erros no ExecAuto
    Private INCLUI      := .T. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
    Private ALTERA      := .F. //Variavel necessária para o ExecAuto identificar que se trata de uma alteração

    // RPCSetType(3)
    // PREPARE ENVIRONMENT EMPRESA cEmpJOB FILIAL cFilJob MODULO "LOJA"

    dVirada       := GetMv("MV_ULMES")

for nOrdId := 1 to len(aOrdIdList)
    cQuery := " SELECT "
    cQuery += "     ZBM_ORDID, "
    cQuery += "     ZBM_CLICOD, "
    cQuery += "     ZBM_CLILO, "
    cQuery += "     ZBM_DTMP, "
    cQuery += "     ZBM_NUMB, "
    cQuery += "     ZBM_SERIE, "
    cQuery += "     ZBM_KEYNFC, "
    cQuery += "     ZBM_EPEP, "
    cQuery += "     ZBM_VALUE, "
    cQuery += "     ZBM_DTMPFT, "
    cQuery += "     ZBM_DTEMIS, "
    cQuery += "     ZBM_HREMIS, "
    cQuery += "     ZB0_LOCAL, "
    cQuery += "     ZB0_LOCALI, "
    cQuery += "     ZB0_FIL, "
    cQuery += "     ZB0_ADMINI, "
    cQuery += "     ZBN_ITEMMP, "
    cQuery += "     ZBN_COD, "
    cQuery += "     ZBN_QTD, "
    cQuery += "     ZBN_VLUN, "
    cQuery += "     ZBN_TES, "
    cQuery += "     ZBN_DESCO "
	cQuery += " FROM "
	cQuery += "		"+RetSQLName( "ZBM" )+" ZBM "
    cQuery += "     INNER JOIN "+RetSQLName( "ZB0" )+" ZB0 ON ( "
    cQuery += "         ZBM.ZBM_STORE = ZB0.ZB0_MEEP  "
    cQuery += "     ) "
    cQuery += "     INNER JOIN "+RetSQLName( "ZBN" )+" ZBN ON ( "
    cQuery += "         ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "
    cQuery += "     ) "
	cQuery += " WHERE "
	cQuery += "		ZB0.ZB0_FIL =  '"+ALLTRIM(SM0->M0_CODFIL)+"' "
	cQuery += "		AND ZB0.ZB0_EMP =  '"+ALLTRIM(SM0->M0_CODIGO)+"' "
    cQuery += "		AND ZB0.ZB0_ATIVO =  '1' "
    cQuery += "     AND ZB0.D_E_L_E_T_ <> '*' "
    cQuery += "     AND ZBN.D_E_L_E_T_ <> '*' "
    cQuery += "     AND ZBM.D_E_L_E_T_ <> '*' "
	cQuery += "		AND ZBM.ZBM_ORDID = '"+aOrdIdList[nOrdId]+"' "
	cQuery += " ORDER BY "
	cQuery += "		ZBM.ZBM_ORDID, "
	cQuery += "		ZBN.ZBN_COD, "
	cQuery += "		ZBN.ZBN_ITEMMP "
	TCQuery cQuery New Alias "ZBMST1"

    ZBMST1->(DbGoTop())
    Count To nTotMov
    ZBMST1->(DbGoTop())

	If ZBMST1->(!Eof()) 
		While ZBMST1->( !Eof() )
            _aCab       := {}
            _aItem      := {}
            lExec701    := .T.
            nTabela     := 2
            lVldCup     := .T.

            SA3->(DbSetOrder(1)) //A3_FILIAL+A3_COD
            SA3->(MsSeek(xFilial("SA3")+_cVendedor))

            if lVldCup
                SA1->(DbSetOrder(1)) //A1_FILIAL+A1_COD+A1_LOJA
                SA1->(MsSeek(xFilial("SA1")+ZBMST1->ZBM_CLICOD+ZBMST1->ZBM_CLILO))

                SLG->(DbSetOrder(2)) // LG_FILIAL+LG_SERIE
                If SLG->(dbSeek(xFilial("SLG")+ZBMST1->ZBM_SERIE))
                    cPDV        := SLG->LG_PDV
                    cEstacao    := SLG->LG_CODIGO
                    cSerSat     := SLG->LG_SERSAT
                Else
                    lExec701    := .F.
                    cCodErro    := "A"
                    cObs        := "Terminal não cadastrado (Série)"
                EndIf

                // dDataMeep   := SUBSTR(ZBMST1->ZBM_DTMP,9,2)+"/"+SUBSTR(ZBMST1->ZBM_DTMP,6,2)+"/"+LEFT(ZBMST1->ZBM_DTMP,4)
                dDataMeep   := SToD(ZBMST1->ZBM_DTEMIS)

                If dDataMeep < dVirada
                    lExec701    := .F.
                    cCodErro    := "D"
                    cObs        :=  "Data cupom: "+DTOC(dDataMeep)+" | Fechamento: "+DTOC(dVirada)
                EndIf

                aAdd( _aCab, {"LQ_VEND"     , _cVendedor                    , NIL} )
                aAdd( _aCab, {"LQ_COMIS"    , nComissao                     , NIL} )
                aAdd( _aCab, {"LQ_CLIENTE"  , SA1->A1_COD                   , NIL} )
                aAdd( _aCab, {"LQ_LOJA"     , SA1->A1_LOJA                  , NIL} )
                aAdd( _aCab, {"LQ_TIPOCLI"  , SA1->A1_TIPO                  , NIL} )
                aAdd( _aCab, {"LQ_DTLIM"    , dDataBase                     , NIL} )
                aAdd( _aCab, {"LQ_EMISSAO"  , SToD(ZBMST1->ZBM_DTEMIS)      , NIL} )
                aadd( _aCab, {"LQ_MENNOTA"  , cMenNota                      , Nil} )
                aAdd( _aCab, {"LQ_OPERADO"  , cCodBanco                     , NIL} )
                aAdd( _aCab, {"LQ_PDV"      , cPDV                          , NIL} )
                aAdd( _aCab, {"LQ_ESTACAO"  , cEstacao                      , NIL} )
                aAdd( _aCab, {"LQ_EMISNF"   , SToD(ZBMST1->ZBM_DTEMIS)      , NIL} )
                // aAdd( _aCab, {"LQ_HORATEF"  , ZBMST1->ZBM_HREMIS            , NIL} )
                aAdd( _aCab, {"LQ_HORA"     , ZBMST1->ZBM_HREMIS            , NIL} )
                
                nItem := 1
                cVendaAnt := ZBMST1->ZBM_ORDID
                nVlrTot   := 0
                while ZBMST1->ZBM_ORDID == cVendaAnt
                    nVlrTot   += ZBMST1->ZBN_VLUN * ZBMST1->ZBN_QTD 
                    SB1->(DbSetOrder(1)) 
                    SB1->(MsSeek(xFilial("SB1")+ZBMST1->ZBN_COD))

                    if ALLTRIM(cProdAnt) == ALLTRIM(ZBMST1->ZBN_COD) 
                        nTabela++
                    Else
                        nTabela := 2
                    EndIf

                    cFieldName  := "B0_PRV"+cvaltochar(nTabela)

                    aAdd( _aItem, {} )
                    aAdd( _aItem[Len(_aItem)], {"LR_ITEM"       , StrZero(nItem,2)      , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_PRODUTO"    , SB1->B1_COD           , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_QUANT"      , ZBMST1->ZBN_QTD       , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_VRUNIT"     , ZBMST1->ZBN_VLUN      , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_LOCAL"      , ZBMST1->ZB0_LOCAL     , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_LOCAL"      , ZBMST1->ZB0_LOCAL     , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_LOCALIZ"    , ZBMST1->ZB0_LOCALI    , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_UM"         , SB1->B1_UM            , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_DESCRI"     , SB1->B1_DESC          , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_TES"        , ZBMST1->ZBN_TES       , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_VALDESC"    , ZBMST1->ZBN_DESCO     , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_VEND"       , _cVendedor            , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_TABELA"     , cValToChar(nTabela)   , NIL} )
                    aAdd( _aItem[Len(_aItem)], {"LR_EMISSAO"    , dDataBase, NIL} )

                    dbSelectArea("SB0")
                    dbSetOrder(1)
                    If dbSeek(xFilial("SB0")+SB1->B1_COD)
                        RecLock("SB0", .F.)
                            SB0->&(cFieldName)	:= ZBMST1->ZBN_VLUN
                        SB0->(MsUnlock())

                    else
                        RecLock("SB0", .T.)
                            SB0->B0_FILIAL	    := xFilial("SB0")
                            SB0->B0_COD 	    := SB1->B1_COD
                            SB0->&(cFieldName)	:= ZBMST1->ZBN_VLUN
                        SB0->(MsUnlock())
                    EndIf

                    dbSelectArea("ZBN")
                    dbSetOrder(3)
                    If dbSeek(xFilial("ZBN")+padr(ZBMST1->ZBM_ORDID,TAMSX3("ZBN_ORDID")[1] ," ")+ZBN_ITEMMP)
                        RecLock('ZBN', .F.)
                            ZBN->ZBN_ITEMO       := StrZero(nItem,2)
                        ZBN->(MsUnlock())
                    EndIf

                    //======================================= Verifica SBF

                    // cQuery := " SELECT  "
                    // cQuery += "     SBF.BF_PRODUTO, "
                    // cQuery += "     SUM(SBF.BF_QUANT) AS BFQUANT"
                    // cQuery += " FROM "
                    // cQuery += "		"+RetSQLName( "SBF" )+" SBF "
                    // cQuery += " WHERE "
                    // cQuery += "		SBF.D_E_L_E_T_ <> '*' "
                    // cQuery += "		AND SBF.BF_PRODUTO = '"+ZBMST1->ZBN_COD+"'      "
                    // cQuery += "		AND SBF.BF_LOCALIZ = '"+ZBMST1->ZB0_LOCALI+"'   "
                    // cQuery += "		AND SBF.BF_LOCAL   = '"+ZBMST1->ZB0_LOCAL+"'    "
                    // cQuery += "		AND SBF.BF_FILIAL  = '"+ZBMST1->ZB0_FIL+"'      "
                    // cQuery += " GROUP BY "
                    // cQuery += "		SBF.BF_PRODUTO "
                    // TCQuery cQuery New Alias "SBFSALDO"

                    // SBFSALDO->(DbGoTop())
                    // If SBFSALDO->(!Eof())
                    //     While SBFSALDO->( !Eof() )
                    //         if ZBMST1->ZBN_QTD > SBFSALDO->BFQUANT
                    //             lExec701    := .F.
                    //             cCodErro    := "C"
                    //             cObs        :=  "Saldo: "+cValToChar(SBFSALDO->BFQUANT)+" | Cod: "+ALLTRIM(ZBMST1->ZBN_COD);
                    //                             +" | "+ZBMST1->ZB0_FIL+"/"+ZBMST1->ZB0_LOCAL+"/"+ZBMST1->ZB0_LOCALI
                    //         EndIf
                    //         SBFSALDO->(DbSkip())
                    //     EndDo
                    // Else
                    //     lExec701    := .F.
                    //     cCodErro    := "C"
                    //     cObs        :=  "Saldo: "+cValToChar(SBFSALDO->BFQUANT)+" | Cod: "+ALLTRIM(ZBMST1->ZBN_COD);
                    //                         +" | "+ZBMST1->ZB0_FIL+"/"+ZBMST1->ZB0_LOCAL+"/"+ZBMST1->ZB0_LOCALI
                    // EndIf

                    // SBFSALDO->(dbCloseArea())

                //======================================= Cria array Venda Atual
    
                    aZBMAtu := {}
                    aadd(aZBMAtu,ZBMST1->ZBM_NUMB)
                    aadd(aZBMAtu,ZBMST1->ZBM_SERIE)
                    aadd(aZBMAtu,ZBMST1->ZBM_KEYNFC)
                    aadd(aZBMAtu,ZBMST1->ZBM_EPEP)
                    aadd(aZBMAtu,ZBMST1->ZBM_ORDID)
                    aadd(aZBMAtu,ZBMST1->ZB0_ADMINI)

                    cVendaAnt := ZBMST1->ZBM_ORDID
                    cProdAnt  := ZBMST1->ZBN_COD
                    ZBMST1->(DbSkip())
                    nItem++
                EndDo

                //======================================= Cria array pagamento
                _aParcelas := {}
                cQuery := " SELECT  "
                cQuery += "     ZBP.ZBP_DATA, "
                cQuery += "     ZBP.ZBP_VALOR, "
                cQuery += "     ZBP.ZBP_FORMA, "
                cQuery += "     ZBP.ZBP_TXFEE, "
                cQuery += "     ZBP.ZBP_MOEDA "
                cQuery += " FROM "
                cQuery += "		"+RetSQLName( "ZBP" )+" ZBP "
                cQuery += " WHERE "
                cQuery += "		ZBP.D_E_L_E_T_ <> '*' "
                cQuery += "		AND ZBP.ZBP_ORDID = '"+aZBMAtu[5]+"' "
                cQuery += " ORDER BY "
                cQuery += "		ZBP.ZBP_ORDID, "
                cQuery += "		ZBP.ZBP_ITEM "
                TCQuery cQuery New Alias "ZBPCAR"

                
                ZBPCAR->(DbGoTop())
                If ZBPCAR->(!Eof())
                    nValPag   := 0
                    dbSelectArea("SAE")
                    dbSetOrder(1)
                    If dbSeek(xFilial("SAE")+aZBMAtu[6]) .AND. !(empty(aZBMAtu[6]))
                        if !((ZBPCAR->ZBP_TXFEE + 0.1) >= SAE->AE_TAXA .AND. SAE->AE_TAXA >= (ZBPCAR->ZBP_TXFEE - 0.1))
                            lExec701    := .F.
                            cCodErro    := "A"
                            cObs        := "Taxa da Administradora Financeira incorreta."
                        EndIf
                    Else
                        lExec701    := .F.
                        cCodErro    := "A"
                        cObs        := "Administradora Financeira inexistente."
                    EndIf
                    While ZBPCAR->( !Eof() )
                        nValPag   += ZBPCAR->ZBP_VALOR
                        dDataPaym   := SUBSTR(ZBPCAR->ZBP_DATA,9,2)+"/"+SUBSTR(ZBPCAR->ZBP_DATA,6,2)+"/"+LEFT(ZBPCAR->ZBP_DATA,4)
                        dDataPaym   := ctod(dDataPaym)

                        aAdd( _aParcelas, {} )
                        aAdd( _aParcelas[Len(_aParcelas)], {"L4_DATA" ,     dDataPaym           , NIL} )
                        aAdd( _aParcelas[Len(_aParcelas)], {"L4_VALOR" ,    ZBPCAR->ZBP_VALOR   , NIL} )
                        aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMA" ,    ZBPCAR->ZBP_FORMA   , NIL} )
                        aAdd( _aParcelas[Len(_aParcelas)], {"L4_MOEDA" ,    ZBPCAR->ZBP_MOEDA   , NIL} )
                        aAdd( _aParcelas[Len(_aParcelas)], {"L4_ADMINIS" ,  aZBMAtu[6]  , NIL} )
                        aAdd( _aParcelas[Len(_aParcelas)], {"L4_NUMCART" ,  " "                 , NIL} )
                        aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMAID" ,  " "                 , NIL} )
                        ZBPCAR->(DbSkip())
                    EndDo

                    if nVlrTot > nValPag
                        lExec701    := .F.
                        cCodErro    := "A"
                        cObs        := "Valor dos itens acima do valor de orçamento."
                    endif
                Else
                    lExec701    := .F.
                    cCodErro    := "A"
                    cObs        := "Pagamentos vazio [ZBP]"
                EndIf

                ZBPCAR->(dbCloseArea())

                // if empty(alltrim(aZBMAtu[1]))
                //     lExec701    := .F.
                //     cCodErro    := "B"
                //     cObs        := "Venda sem Cupom"
                // EndIf

                //======================================= Executa Loja701
                lUseSAT := LjGetStation("LG_USESAT")

                if !lExec701    
                    dbSelectArea("ZBM")
                    dbSetOrder(2)
                    If dbSeek(xFilial("ZBM")+padr(aZBMAtu[5],TAMSX3("ZBM_ORDID")[1] ," "))
                        RecLock('ZBM', .F.)
                            ZBM->ZBM_STATUS     := cCodErro
                            ZBM->ZBM_ETAPA      := "1"
                            ZBM->ZBM_OBS        := cObs
                        ZBM->(MsUnlock())
                    EndIf
                else
                    // dbSelectArea("SLG")					
                    // dbSetOrder(1)
                    // dbSeek(xFilial("SLG")+cPdv)

                    lMsErroAuto := .F.

                    SetFunName("LOJA701")
                    MSExecAuto({|a,b,c,d,e,f,g,h| Loja701(a,b,c,d,e,f,g,h)},.F.,3,"","",{},_aCab,_aItem,_aParcelas)
            
                    lUseSAT := .T.
                    If lMsErroAuto
                        cArqLog:= ALLTRIM(aZBMAtu[1])+".txt"
                        MostraErro("\log_MEEP", cArqLog)
                        dbSelectArea("ZBM")
                        dbSetOrder(2)
                        If dbSeek(xFilial("ZBM")+padr(aZBMAtu[5],TAMSX3("ZBM_ORDID")[1] ," "))
                            RecLock('ZBM', .F.)
                                ZBM->ZBM_STATUS     := "A"
                                ZBM->ZBM_OBS        := "Erro no MSExecAuto"
                                ZBM->ZBM_ETAPA      := "1"
                            ZBM->(MsUnlock())
                        EndIf
                    Else
                        RecLock("SL1", .F.)
                            SL1->L1_DOC		    :=	aZBMAtu[1]
                            SL1->L1_NUMCFIS	    :=	aZBMAtu[1]
                            SL1->L1_SERIE		:=	aZBMAtu[2]
                            SL1->L1_EMISNF		:=	dDataMeep
                            SL1->L1_TIPO		:=	cTipoVenda
                            SL1->L1_IMPRIME		:=	cImprime
                            SL1->L1_SITUA		:=	cSitua
                            SL1->L1_PDV		    :=	cPDV
                            SL1->L1_ESTACAO     :=  cEstacao
                            SL1->L1_OPERADO     :=  cCodBanco
                            SL1->L1_KEYNFCE     :=  aZBMAtu[3]
                            SL1->L1_TROCO1      :=  0
                            // SL1->L1_SERSAT      :=  cSerSat
                            SL1->L1_ESPECIE     :=  "NFCE"
                        SL1->(MsUnlock())

                        dbSelectArea("ZBM")
                        dbSetOrder(2)
                        If dbSeek(xFilial("ZBM")+padr(aZBMAtu[5],TAMSX3("ZBM_ORDID")[1] ," "))
                            RecLock('ZBM', .F.)
                                ZBM->ZBM_STATUS     := "2"
                                ZBM->ZBM_OBS        := ""
                                ZBM->ZBM_ETAPA      := "0"
                                ZBM->ZBM_NUM        := SL1->L1_NUM
                                ZBM->ZBM_FILORC     := ALLTRIM(SM0->M0_CODFIL)   
                            ZBM->(MsUnlock())
                        EndIf  

                        cQuery := " SELECT "
                        cQuery += "		SL2.L2_FILIAL, "
                        cQuery += "		SL2.L2_NUM, "
                        cQuery += "		SL2.L2_ITEM, "
                        cQuery += "		SL2.L2_PRODUTO "
                        cQuery += " FROM "
                        cQuery += "		"+RetSQLName( "SL2" )+" SL2 "
                        cQuery += " WHERE "
                        cQuery += "		SL2.D_E_L_E_T_ <> '*' "
                        cQuery += "		AND SL2.L2_FILIAL = '"+SL1->L1_FILIAL+"' "
                        cQuery += "		AND SL2.L2_NUM = '"+SL1->L1_NUM+"' "
                        cQuery += "		AND SL2.L2_QUANT <> 0 "
                        cQuery += " ORDER BY "
                        cQuery += "		SL2.L2_FILIAL, "
                        cQuery += "		SL2.L2_PRODUTO, "
                        cQuery += "		SL2.L2_LOCALIZ "
                        TCQuery cQuery New Alias "ItensSL2"

                        ItensSL2->(DbGoTop())
                        
                        If ItensSL2->(!Eof())
                            While ItensSL2->(!Eof())
                                dbSelectArea("ZBN")
                                dbSetOrder(1)
                                If dbSeek(xFilial("ZBN")+padr(ZBMST1->ZBM_ORDID,TAMSX3("ZBN_ORDID")[1] ," ")+ItensSL2->L2_ITEM)
                                    RecLock('ZBN', .F.)
                                        ZBN->ZBN_NUM        := SL1->L1_NUM
                                    ZBN->(MsUnlock())
                                EndIf

                                dbSelectArea("SL2")
                                dbSetOrder(1)
                                If dbSeek(ItensSL2->L2_FILIAL+ItensSL2->L2_NUM+ItensSL2->L2_ITEM+ItensSL2->L2_PRODUTO)
                                    RecLock("SL2", .F.)
                                        SL2->L2_DOC		    := aZBMAtu[1]
                                        SL2->L2_SERIE       := aZBMAtu[2]
                                        SL2->L2_ITEMCC      := aZBMAtu[4]
                                        SL2->L2_PDV         :=  cPdv
                                    SL2->(MsUnlock())
                                EndIf
                                ItensSL2->(DbSkip())
                            EndDo
                        EndIf
                        ItensSL2->(dbCloseArea())            
                    EndIf
                EndIf
            Else
                ZBMST1->(DbSkip())
            EndIf
        EndDo
    EndIf

	ZBMST1->(dbCloseArea())

Next nOrdId

    // RESET ENVIRONMENT

    // DBCloseAll()
   
return
