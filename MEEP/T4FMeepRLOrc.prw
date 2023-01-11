#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#INCLUDE "tbiconn.ch"

/*----------------------------------------------------------------------*
 | Func:  U_IMRLCadOrc()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Função responsável por gerar as tabelas SL1, SL2 e SL4 do    	|
 |        SIGALOJA via ExecAuto.                                        |
 | Parm:  cEmpJOB:      Empresa que será criado as tabelas.          	|
 |        cFilJob:      Filial que será criado as tabelas.           	|
 |        aOrdIdList:   Array com os OrdID da tabela ZBM.             	|
 *----------------------------------------------------------------------*/

User Function IMRLCadOrc(cEmpJOB,cFilJob,aOrdIdList)
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

    RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA cEmpJOB FILIAL cFilJob MODULO "LOJA"

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
    cQuery += "         ZBMSUB.ZBM_STORE = ZB0.ZB0_MEEP  "
    cQuery += "     ) "
    cQuery += "     INNER JOIN "+RetSQLName( "ZBN" )+" ZBN ON ( "
    cQuery += "         ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "
    cQuery += "     ) "
	cQuery += " WHERE "
	cQuery += "		ZB0.ZB0_FIL =  '"+ALLTRIM(SM0->M0_CODFIL)+"' "
	cQuery += "		AND ZB0.ZB0_EMP =  '"+ALLTRIM(SM0->M0_CODIGO)+"' "
    cQuery += "     AND ZB0.D_E_L_E_T_ <> '*' "
    cQuery += "     AND ZBN.D_E_L_E_T_ <> '*' "
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

                dDataMeep   := SUBSTR(ZBMST1->ZBM_DTMP,9,2)+"/"+SUBSTR(ZBMST1->ZBM_DTMP,6,2)+"/"+LEFT(ZBMST1->ZBM_DTMP,4)
                dDataMeep   := ctod(dDataMeep)

                If dDataMeep < dVirada
                    lExec701    := .F.
                    cCodErro    := "D"
                    cObs        :=  "Data cupom: "+DTOC(dDataMeep)+" | Fechamento: "+DTOC(dVirada)
                EndIf

                aAdd( _aCab, _cVendedor         )    //L1_VEND
                aAdd( _aCab, nComissao          )    //L1_COMIS
                aAdd( _aCab, SA1->A1_COD        )    //L1_CLIENTE
                aAdd( _aCab, SA1->A1_LOJA       )    //L1_LOJA
                aAdd( _aCab, SA1->A1_TIPO       )    //L1_TIPOCLI
                aAdd( _aCab, dDataMeep          )    //L1_DTLIM
                aAdd( _aCab, dDataMeep          )    //L1_EMISSAO
                aadd( _aCab, cMenNota           )    //L1_MENNOTA
                aAdd( _aCab, cCodBanco          )    //L1_OPERADO
                aAdd( _aCab, cPDV               )    //L1_PDV
                aAdd( _aCab, cEstacao           )    //L1_ESTACAO
                
                nItem := 1
                cVendaAnt := ZBMST1->ZBM_ORDID
                nVlrTot   := 0
                nVlrSemDesc   := 0
                while ZBMST1->ZBM_ORDID == cVendaAnt
                    nVlrTot   += (ZBMST1->ZBN_VLUN-ZBMST1->ZBN_DESCO) * ZBMST1->ZBN_QTD 
                    nVlrSemDesc += ZBMST1->ZBN_VLUN*ZBMST1->ZBN_QTD
                    SB1->(DbSetOrder(1)) 
                    SB1->(MsSeek(xFilial("SB1")+ZBMST1->ZBN_COD))

                    if ALLTRIM(cProdAnt) == ALLTRIM(ZBMST1->ZBN_COD) 
                        nTabela++
                    Else
                        nTabela := 2
                    EndIf

                    cFieldName  := "B0_PRV"+cvaltochar(nTabela)

                    aAdd( _aItem, {} )
                    aAdd( _aItem[Len(_aItem)], StrZero(nItem,2)         )    // L2_ITEM         1
                    aAdd( _aItem[Len(_aItem)], SB1->B1_COD              )    // L2_PRODUTO      2
                    aAdd( _aItem[Len(_aItem)], ZBMST1->ZBN_QTD          )    // L2_QUANT        3
                    aAdd( _aItem[Len(_aItem)], ZBMST1->ZBN_VLUN         )    // L2_VRUNIT       4
                    aAdd( _aItem[Len(_aItem)], ZBMST1->ZB0_LOCAL        )    // L2_LOCAL        5
                    aAdd( _aItem[Len(_aItem)], ""                       )    // L2_LOCALIZ      6
                    // aAdd( _aItem[Len(_aItem)], ZBMST1->ZB0_LOCALI       )    // L2_LOCALIZ      6
                    aAdd( _aItem[Len(_aItem)], SB1->B1_UM               )    // L2_UM           7
                    aAdd( _aItem[Len(_aItem)], SB1->B1_DESC             )    // L2_DESCRI       8
                    aAdd( _aItem[Len(_aItem)], ZBMST1->ZBN_TES          )    // L2_TES          9
                    aAdd( _aItem[Len(_aItem)], ZBMST1->ZBN_DESCO        )    // L2_VALDESC      10
                    aAdd( _aItem[Len(_aItem)], _cVendedor               )    // L2_VEND         11
                    aAdd( _aItem[Len(_aItem)], cValToChar(nTabela)      )    // L2_TABELA       12

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
                    aadd(aZBMAtu,ZBMST1->ZB0_FIL)

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
                    nContPag    := 0
                    nValorOrc   := 0
                    nValPag     := 0
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
                        nContPag++
                        dDataPaym   := SUBSTR(ZBPCAR->ZBP_DATA,9,2)+"/"+SUBSTR(ZBPCAR->ZBP_DATA,6,2)+"/"+LEFT(ZBPCAR->ZBP_DATA,4)
                        dDataPaym   := ctod(dDataPaym)

                        if ZBPCAR->ZBP_FORMA == "R$"   
                            cAdminFin := ""
                        else
                            cAdminFin := aZBMAtu[6]
                        endif

                        aAdd( _aParcelas, {} )
                        aAdd( _aParcelas[Len(_aParcelas)], dDataPaym            )
                        aAdd( _aParcelas[Len(_aParcelas)], ZBPCAR->ZBP_VALOR    )
                        aAdd( _aParcelas[Len(_aParcelas)], ZBPCAR->ZBP_FORMA    )
                        aAdd( _aParcelas[Len(_aParcelas)], ZBPCAR->ZBP_MOEDA    )
                        aAdd( _aParcelas[Len(_aParcelas)], cAdminFin            )
                        aAdd( _aParcelas[Len(_aParcelas)], " "                  )
                        aAdd( _aParcelas[Len(_aParcelas)], " "                  )
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

                lExec701 := .T.

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
                    Begin Transaction
                        cNumOrc := GetSx8Num("SL1", "L1_NUM")

                        if _aParcelas[1][3] == "CC"
                            nCartao := _aParcelas[1][2]
                            nVlrDeb := 0
                            nDinheir := 0
                        elseif _aParcelas[1][3] == "CD"
                            nCartao := 0
                            nVlrDeb := _aParcelas[1][2]
                            nDinheir := 0
                        else
                            nCartao := 0
                            nVlrDeb := 0
                            nDinheir := _aParcelas[1][2]
                        endif

                        RecLock("SL1", .T.)
                            SL1->L1_FILIAL      := aZBMAtu[7]
                            SL1->L1_NUM         := cNumOrc
                            SL1->L1_VEND        := _aCab[1]
                            SL1->L1_COMIS       := _aCab[2]
                            SL1->L1_CLIENTE     := _aCab[3]
                            SL1->L1_LOJA        := _aCab[4]
                            SL1->L1_TIPOCLI     := _aCab[5]
                            SL1->L1_VLRTOT      := nValPag                 //Valor com desconto (Soma itens - Desconto)
                            SL1->L1_DESCONT     := 0.00            // zerado mesmo no desconto, wtf?
                            SL1->L1_VLRLIQ      := nValPag                // Igual Valor Tot (Aqui é o desconto sobre a venda total, não sobre cada item)
                            // SL1->L1_NROPCLI     :=
                            SL1->L1_DTLIM       := _aCab[6]
                            SL1->L1_DOC		    :=	aZBMAtu[1]
                            SL1->L1_SERIE		:=	aZBMAtu[2]
                            SL1->L1_PDV		    :=	cPDV
                            SL1->L1_EMISNF		:=	dDataMeep
                            SL1->L1_VALBRUT     := nValPag                 // Igual Valor Tot
                            SL1->L1_VALMERC     := nVlrSemDesc                 // Valor sem desconto
                            SL1->L1_TIPO		:=	cTipoVenda
                            SL1->L1_DESCNF	    := 0.00             // Zerado
                            SL1->L1_OPERADO     := _aCab[9]
                            
                            SL1->L1_DINHEIR     := nDinheir                 //Valor SL4 para R$
                            // SL1->L1_CHEQUES     :=
                            SL1->L1_CARTAO      := nCartao                 //Valor SL4 para CC
                            // SL1->L1_CONVENI     :=
                            // SL1->L1_VALES       :=
                            // SL1->L1_FINANC      :=
                            // SL1->L1_OUTROS      :=
                            SL1->L1_ENTRADA     := nDinheir                 //Preencher com valor SL4 quando R$
                            // SL1->L1_JUROS       :=
                            SL1->L1_PARCELA     := nContPag
                            // SL1->L1_INTERV      :=
                            // SL1->L1_COND        :=
                            // SL1->L1_FORMA       :=
                            SL1->L1_VALICM      := 0                  //Calcular de acordo SB1 e TES
                            SL1->L1_VALIPI      := 0                 //Calcular de acordo SB1 e TES SAKAGUTI
                            SL1->L1_VALISS      := 0                 //Calcular de acordo SB1 e TES SAKAGUTI
                            SL1->L1_TXDESC      := 0.00
                            SL1->L1_CONDPG      := "CN"
                            SL1->L1_FORMPG      := _aParcelas[1][3]         // R$/CC/CD
                            // SL1->L1_CREDITO     :=

                            SL1->L1_EMISSAO     := _aCab[7]
                            SL1->L1_MENNOTA     := _aCab[8]
                            SL1->L1_NUMCFIS	    :=	aZBMAtu[1]
                            SL1->L1_IMPRIME		:=	cImprime
                            SL1->L1_SITUA		:=	cSitua
                            SL1->L1_ESTACAO     :=  cEstacao
                            SL1->L1_KEYNFCE     :=  aZBMAtu[3]
                            SL1->L1_TROCO1      :=  0
                            SL1->L1_SERSAT      :=  cSerSat
                            SL1->L1_ESPECIE     :=  "SATCE"

                            SL1->L1_VLRDEBI     := nVlrDeb                 //Valor SL4 para CD
                            SL1->L1_CONFVEN     := "SSSSSSSSNSSS"
                            SL1->L1_HORA        := TIME()
                            SL1->L1_TIPODES     := '0'

                            // SL1->L1_NOMCLI      :=          //Pode preencher com o nome do cliente
                            // SL1->L1_CGCCLI      :=          //Pode preencher
                            SL1->L1_SERPDV      := '-1,                 '   //Confere esse paranaue

                                //Sem Preenchimento
                                // SL1->L1_VEND2       :=
                                // SL1->L1_VEND3       :=
                                // SL1->L1_MULTNOT     := 
                                // SL1->L1_FATOR       :=
                                // SL1->L1_VENDTEF     :=
                                // SL1->L1_DATATEF     :=
                                // SL1->L1_HORATEF     :=
                                // SL1->L1_DOCTEF      :=
                                // SL1->L1_AUTORIZ     :=
                                // SL1->L1_DOCCANC     :=
                                // SL1->L1_DATCANC     :=
                                // SL1->L1_HORCANC     :=
                                // SL1->L1_INSTITU     :=
                                // SL1->L1_NSUTEF      :=
                                // SL1->L1_TIPCART     :=
                                // SL1->L1_TEFSTAT     :=
                                // SL1->L1_ADMFIN      :=
                                // SL1->L1_STATUS      :=
                                // SL1->L1_OPERACA     :=
                                // SL1->L1_NUMORIG     :=
                                // SL1->L1_SUBSERI     :=
                                // SL1->L1_TXMOEDA     :=
                                // SL1->L1_MOEDA       :=
                                // SL1->L1_ENDCOB      :=
                                // SL1->L1_ENDENT      :=
                                // SL1->L1_TPFRET      :=
                                // SL1->L1_BAIRROC     :=
                                // SL1->L1_CEPC        :=
                                // SL1->L1_MUNC        :=
                                // SL1->L1_ESTC        :=
                                // SL1->L1_BAIRROE     :=
                                // SL1->L1_CEPE        :=
                                // SL1->L1_MUNE        :=
                                // SL1->L1_ESTE        :=
                                // SL1->L1_FRETE       :=
                                // SL1->L1_SEGURO      :=
                                // SL1->L1_DESPESA     :=
                                // SL1->L1_PLIQUI      :=
                                // SL1->L1_PBRUTO      :=
                                // SL1->L1_VOLUME      :=
                                // SL1->L1_TRANSP      :=
                                // SL1->L1_MARCA       :=
                                // SL1->L1_NUMERO      :=
                                // SL1->L1_PLACA       :=
                                // SL1->L1_UFPLACA     :=
                                // SL1->L1_BLCRED      :=
                                // SL1->L1_RESERVA     :=
                                // SL1->L1_VEICTIP     :=
                                // SL1->L1_VEIPESQ     :=
                                // SL1->L1_NRDOC       :=
                                // SL1->L1_TIPOJUR     :=
                                // SL1->L1_EMPRES      :=
                                // SL1->L1_FILRES      :=
                                // SL1->L1_ORCRES      :=
                                // SL1->L1_FORCADA     :=
                                // SL1->L1_DOCPED      :=
                                // SL1->L1_CGCCART     :=
                                // SL1->L1_SERPED      :=
                                // SL1->L1_BRICMS      :=
                                // SL1->L1_CLIENT      :=
                                // SL1->L1_LOJENT      :=
                                // SL1->L1_NSO         :=
                                // SL1->L1_CONTRA      :=
                                // SL1->L1_LOGDESC     :=
                                // SL1->L1_ICMSRET     :=
                                // SL1->L1_PARCTEF     :=
                                // SL1->L1_ABTOPCC     :=
                                // SL1->L1_VALPIS      :=
                                // SL1->L1_VALCOFI     :=
                                // SL1->L1_VALCSLL     :=
                                // SL1->L1_DIAFIXO     :=
                                // SL1->L1_NUMMOV      :=
                                // SL1->L1_NUMATEN     :=
                                // SL1->L1_PEDRES      :=
                                // SL1->L1_NUMORC      :=
                                // SL1->L1_TPORC       :=
                                // SL1->L1_CONTDOC     :=
                                // SL1->L1_CONTONF     :=
                                // SL1->L1_CONTRG      :=
                                // SL1->L1_CONTCDC     :=
                                // SL1->L1_TABELA      :=
                                // SL1->L1_TEFBAND     :=
                                // SL1->L1_MIDIA       :=
                                // SL1->L1_TRCXGER     :=
                                // SL1->L1_TREFETI     :=
                                // SL1->L1_STATUES     :=
                                // SL1->L1_COODAV      :=
                                // SL1->L1_PAFMD5      :=
                                // SL1->L1_IMPNF       :=
                                // SL1->L1_CARTFID     :=
                                // SL1->L1_VALIRRF     :=
                                // SL1->L1_STORC       :=
                                // SL1->L1_VEND1       :=
                                // SL1->L1_VEND4       :=
                                // SL1->L1_VEND5       :=
                                // SL1->L1_USRST       :=
                                // SL1->L1_DTST        :=
                                // SL1->L1_HRST        :=
                                // SL1->L1_IFSANST     :=
                                // SL1->L1_IFSCDM1     :=
                                // SL1->L1_IFSCDM2     :=
                                // SL1->L1_DESCFIN     :=
                                // SL1->L1_MARCVEI     :=
                                // SL1->L1_MODEVEI     :=
                                // SL1->L1_ANOFVEI     :=
                                // SL1->L1_PLACVEI     :=
                                // SL1->L1_RNVMVEI     :=
                                // SL1->L1_NUMFAB      :=
                                // SL1->L1_DVOSORI     :=
                                // SL1->L1_DOCRPS      :=
                                // SL1->L1_SERRPS      :=
                                // SL1->L1_ORIGEM      :=
                                // SL1->L1_STBATCH     :=
                                // SL1->L1_UNDOBTC     :=
                                // SL1->L1_ERROBTC     :=
                                // SL1->L1_PEDPRS      :=
                                // SL1->L1_CODMNEG     :=
                                // SL1->L1_TIMEATE     :=
                                // SL1->L1_TIMEITE     :=
                                // SL1->L1_ECFLAG      :=
                                // SL1->L1_VLRARR      :=
                                // SL1->L1_VALINSS     :=
                                // SL1->L1_UMOVINF     :=
                                // SL1->L1_UMOV        :=
                                // SL1->L1_RECISS      :=
                                // SL1->L1_DOCCCF      :=
                                // SL1->L1_ECPEDEC     :=
                                // SL1->L1_CONHTL      :=
                                // SL1->L1_VALCOMI     :=
                                // SL1->L1_ESPECI1     :=
                                // SL1->L1_BASEIPI     :=
                                // SL1->L1_BASFECP     :=
                                // SL1->L1_BSFCPST     :=
                                // SL1->L1_VALFECP     :=
                                // SL1->L1_VFECPST     :=
                                // SL1->L1_LTRAN       :=
                                // SL1->L1_PRONFCE     :=
                                // SL1->L1_RESEHTL     :=
                                // SL1->L1_TOTEST      :=
                                // SL1->L1_TOTFED      :=
                                // SL1->L1_TOTMUN      :=
                                // SL1->L1_ECRASTR     :=
                                // SL1->L1_ECSTATU     :=
                                // SL1->L1_NUMFRT      :=
                                // SL1->L1_ERGRVBT     :=
                                // SL1->L1_VEICUL1     :=
                                // SL1->L1_VLRJUR      :=
                                // SL1->L1_SDOCRPS     :=
                                // SL1->L1_SDOC        :=
                                // SL1->L1_SDOCPED     :=
                                // SL1->L1_SDOCSUB     :=
                                // SL1->L1_DTUMOV      :=
                                // SL1->L1_HRUMOV      :=

                                // Não achei na tabela
                                // SL1->L1_ARRED       :=
                                // SL1->L1_IFSMSG1     :=
                                // SL1->L1_IFSMSG2     :=
                                // SL1->L1_PRODUTO     :=
                                // SL1->L1_RETSFZ      :=

                        SL1->(MsUnlock())
                        cPOSIPI     := ""
                        cCest       := ""
                        cSegUM      := ""
                        
                        for nItem := 1 to len(_aItem)
                            dbSelectArea("ZBN")
                            dbSetOrder(1)
                            If dbSeek(xFilial("ZBN")+padr(aZBMAtu[5],TAMSX3("ZBN_ORDID")[1] ," ")+_aItem[nItem][1])
                                RecLock('ZBN', .F.)
                                    ZBN->ZBN_NUM        := SL1->L1_NUM
                                ZBN->(MsUnlock())
                            EndIf

                            dbSelectArea("SF4")
                            dbSetOrder(1)
                            If dbSeek(xFilial("SF4")+_aItem[nItem][9])
                                cCodFiscal  := SF4->F4_CF
                                cClasFisc   := SF4->F4_SITTRIB
                            EndIf

                            dbSelectArea("SB1")
                            dbSetOrder(1)
                            If dbSeek(xFilial("SB1")+padr(_aItem[nItem][2],TAMSX3("B1_COD")[1] ," "))
                                cPOSIPI     := SB1->B1_POSIPI
                                cCest       := SB1->B1_CEST
                                cSegUM      := SB1->B1_SEGUM
                            EndIf

                            nVlrDesc := _aItem[nItem][4]-_aItem[nItem][10]

                            RecLock("SL2", .T.)
                                SL2->L2_FILIAL      := aZBMAtu[7]
                                SL2->L2_NUM         := cNumOrc
                                SL2->L2_ITEM        := _aItem[nItem][1]
                                SL2->L2_DOC		    := aZBMAtu[1]
                                SL2->L2_SERIE       := aZBMAtu[2]
                                SL2->L2_ITEMCC      := aZBMAtu[4]
                                SL2->L2_PDV         := cPdv
                                SL2->L2_PRODUTO     := _aItem[nItem][2]
                                SL2->L2_QUANT       := _aItem[nItem][3]
                                SL2->L2_VRUNIT      := nVlrDesc
                                SL2->L2_LOCAL       := _aItem[nItem][5]         
                                SL2->L2_LOCALIZ     := _aItem[nItem][6]
                                SL2->L2_UM          := _aItem[nItem][7]
                                SL2->L2_DESCRI      := _aItem[nItem][8]
                                SL2->L2_TES         := _aItem[nItem][9]
                                SL2->L2_VALDESC     := _aItem[nItem][10]
                                SL2->L2_VEND        := _aItem[nItem][11]
                                SL2->L2_TABELA      := _aItem[nItem][12]

                                SL2->L2_VLRITEM      := nVlrDesc*_aItem[nItem][3]                        //L2_VRUNIT*L2_QUANT
                                SL2->L2_DESC         := (_aItem[nItem][10]/(_aItem[nItem][10]+nVlrDesc))                        //Porcentagem do desconto (Valor desconto/Valor total sem desconto) ou (L2_VALDESC/(L2_VALDESC+L2_VLRITEM))
                                SL2->L2_CF           := cCodFiscal                        //Conforme TES
                                SL2->L2_EMISSAO      := _aCab[7]                        //Data Emissao Meep
                                SL2->L2_PRCTAB       := _aItem[nItem][4]                        //Preço unit sem desconto (Oq ta na tabela)
                                SL2->L2_GRADE        := "N"
                                SL2->L2_ENTREGA      := '1'
                                // SL2->L2_DTVALID      := '000000'
                                SL2->L2_SEGUM        := cSegUM                //SB1
                                // SL2->L2_SITTRIB      := 'T1800'          //Acho q é TES, pode ser Sb1 - T+TAXA se nao tributar -> N1 - SAKAGUTI
                                SL2->L2_SERPDV       := '-1,'
                                SL2->L2_POSIPI       := cPOSIPI                //Pegar SB1
                                // SL2->L2_CLASFIS      := cClasFisc               //Sakaguti
                                SL2->L2_VLTROCA      := '2'
                                SL2->L2_CEST         := cCest  //Estava vazio, mas eu acho que usa
                                
                                //Tem que testar com TES
                                //Tem que olhar aliquota PIS e COFINS -- acho q é TES
                                // SL2->L2_VALIPI       := 0         //tudo zerado
                                // SL2->L2_VALICM       := 0
                                // SL2->L2_VALISS       := 0         //tudo zerado
                                // SL2->L2_BASEICM      :=             //Valor total de base com desconto (L2_VLRITEM)
                                // SL2->L2_VALPIS       :=

                                // SL2->L2_ICMSRET      := 0
                                // SL2->L2_BRICMS       := 0
                                // SL2->L2_VALCOFI      := 0
                                // SL2->L2_VALCSLL      := 0
                                // SL2->L2_VALPS2       := 0
                                // SL2->L2_VALCF2       := 0 
                                // SL2->L2_BASEPS2      := 0
                                // SL2->L2_BASECF2      := 0 
                                // SL2->L2_ALIQPS2      := 0
                                // SL2->L2_ALIQCF2      := 0
                                
                                    // SL2->L2_REVLPRE      :=
                                    // SL2->L2_MSGLPRE      :=
                                    // SL2->L2_VDMOST       :=
                                    // SL2->L2_ITEMLAY      :=
                                    // SL2->L2_NUMLAY       :=
                                    // SL2->L2_CODITE       :=
                                    // SL2->L2_DESCPRO      :=  
                                    // SL2->L2_VENDIDO      :=
                                    // SL2->L2_STATUS       :=
                                    // SL2->L2_CUSTO1       :=
                                    // SL2->L2_CUSTO2       :=
                                    // SL2->L2_PREMIO       :=
                                    // SL2->L2_LOTECTL      :=
                                    // SL2->L2_NLOTE        :=
                                    // SL2->L2_NSERIE       :=
                                    // SL2->L2_BCONTA       :=
                                    // SL2->L2_SITUA        :=
                                    // SL2->L2_RESERVA      :=
                                    // SL2->L2_LOJARES      :=
                                    // SL2->L2_PEDFAT       :=
                                    // SL2->L2_VALFRE       :=
                                    // SL2->L2_SEGURO       :=
                                    // SL2->L2_DESPESA      :=
                                    // SL2->L2_EMPRES       :=
                                    // SL2->L2_FILRES       :=
                                    // SL2->L2_ORCRES       :=
                                    // SL2->L2_ITEMSD1      :=
                                    // SL2->L2_PEDRES       :=
                                    // SL2->L2_FDTENTR      :=
                                    // SL2->L2_CODCONT      :=
                                    // SL2->L2_FDTMONT      :=
                                    // SL2->L2_CODREG       :=
                                    // SL2->L2_VLDESRE      :=
                                    // SL2->L2_TURNO        :=
                                    // SL2->L2_NUMORIG      :=
                                    // SL2->L2_VALEPRE      :=
                                    // SL2->L2_CODLAN       :=
                                    // SL2->L2_VDOBS        :=
                                    // SL2->L2_MARCA        :=
                                    // SL2->L2_TIPO         :=
                                    // SL2->L2_MODELO       :=
                                    // SL2->L2_DESCORC      :=
                                    // SL2->L2_PEDSC5       :=
                                    // SL2->L2_QUALIDA      :=
                                    // SL2->L2_ESPECIE      :=
                                    // SL2->L2_ITESC6       :=
                                    // SL2->L2_SEQUEN       :=
                                    // SL2->L2_SOLCOM       :=
                                    // SL2->L2_CONTDOC      :=
                                    // SL2->L2_PAFMD5       :=
                                    // SL2->L2_CODLPRE      :=
                                    // SL2->L2_GARANT       :=
                                    // SL2->L2_ITLPRE       :=
                                    // SL2->L2_MSMLPRE      :=
                                    // SL2->L2_REMLPRE      :=
                                    // SL2->L2_NUMCFID      :=
                                    // SL2->L2_MESREC       :=
                                    // SL2->L2_DTSDFID      :=
                                    // SL2->L2_VLRCFID      :=
                                    // SL2->L2_PROCFID      :=
                                    // SL2->L2_CODBAR       :=
                                    // SL2->L2_ORIGEM       :=
                                    // SL2->L2_MODBC        :=
                                    // SL2->L2_CODISS       :=
                                    // SL2->L2_LEGCOD       :=
                                    // SL2->L2_ITEMNF       :=
                                    // SL2->L2_VALACRS      :=
                                    // SL2->L2_VLGAPRO      :=
                                    // SL2->L2_VLIMPOR      :=
                                    // SL2->L2_FCICOD       :=
                                    // SL2->L2_ECPRESN      :=
                                    // SL2->L2_ECSEDEX      :=
                                    // SL2->L2_DOCPED       :=
                                    // SL2->L2_PEDPRS       :=
                                    // SL2->L2_SERPED       :=
                                    // SL2->L2_ECMSGPR      :=
                                    // SL2->L2_CLIENT       :=
                                    // SL2->L2_CLILOJA      :=
                                    // SL2->L2_BASEIPI      :=
                                    // SL2->L2_IPI          :=
                                    // SL2->L2_DTUMOV       :=
                                    // SL2->L2_BSFCPST      :=
                                    // SL2->L2_BASFECP      :=
                                    // SL2->L2_HRUMOV       :=
                                    // SL2->L2_FLUMOV       :=
                                    // SL2->L2_INDPAR       :=
                                    // SL2->L2_BLEST        :=
                                    // SL2->L2_CSTCOF       :=
                                    // SL2->L2_CSTPIS       :=
                                    // SL2->L2_REV          :=
                                    // SL2->L2_PREDIC       :=
                                    // SL2->L2_ALQFECP      :=
                                    // SL2->L2_VALFECP      :=
                                    // SL2->L2_KIT          :=
                                    // SL2->L2_CNAE         :=
                                    // SL2->L2_ECVALOR      :=
                                    // SL2->L2_TOTFED       :=
                                    // SL2->L2_IPPT         :=
                                    // SL2->L2_DECQTD       :=
                                    // SL2->L2_DECVLU       :=
                                    // SL2->L2_IAT          :=
                                    // SL2->L2_DESCICM      :=
                                    // SL2->L2_MOTDICM      :=
                                    // SL2->L2_ALIQCOF      :=
                                    // SL2->L2_ALIQISS      :=
                                    // SL2->L2_ALIQPIS      :=
                                    // SL2->L2_ALQCSLL      :=
                                    // SL2->L2_ALQIRRF      :=
                                    // SL2->L2_BASCSLL      :=
                                    // SL2->L2_BASECOF      :=
                                    // SL2->L2_BASEISS      :=
                                    // SL2->L2_BASEPIS      :=
                                    // SL2->L2_BASIRRF      :=
                                    // SL2->L2_CCUSTO       :=
                                    // SL2->L2_CLVL         :=
                                    // SL2->L2_PICM         :=
                                    // SL2->L2_VALIRRF      :=
                                    // SL2->L2_ALIQSOL      :=
                                    // SL2->L2_TOTIMP       :=
                                    // SL2->L2_QTDEDEV      :=
                                    // SL2->L2_ITEMGAR      :=
                                    // SL2->L2_GARDEV       :=
                                    // SL2->L2_ITEMCOB      :=
                                    // SL2->L2_PRDCOBE      :=
                                    // SL2->L2_IDITREL      :=
                                    // SL2->L2_ALQFCST      :=
                                    // SL2->L2_VFECPST      :=
                                    // SL2->L2_TOTMUN       :=
                                    // SL2->L2_TOTEST       :=
                                    // SL2->L2_SDOC         :=
                                    // SL2->L2_SDOCPED      :=
                                    // SL2->L2_ABATISS      :=
                            SL2->(MsUnlock())
                        Next nItem
                        
                        dbSelectArea("ZBM")
                        dbSetOrder(2)
                        If dbSeek(xFilial("ZBM")+padr(aZBMAtu[5],TAMSX3("ZBM_ORDID")[1] ," "))
                            RecLock('ZBM', .F.)
                                ZBM->ZBM_STATUS     := "2"
                                ZBM->ZBM_OBS        := ""
                                ZBM->ZBM_NUM        := SL1->L1_NUM
                                ZBM->ZBM_FILORC     := ALLTRIM(SM0->M0_CODFIL)   
                                ZBM->ZBM_ETAPA      := "0"
                            ZBM->(MsUnlock())
                        EndIf

                        for nItem := 1 to len(_aParcelas)
                            RecLock("SL4", .T.)
                                SL4->L4_FILIAL      := aZBMAtu[7]
                                SL4->L4_NUM         := cNumOrc
                                SL4->L4_DATA        := _aParcelas[nItem][1]
                                SL4->L4_VALOR       := _aParcelas[nItem][2]             //Valor com desconto - Valor Real Pago
                                SL4->L4_FORMA       := _aParcelas[nItem][3]
                                SL4->L4_MOEDA       := 0
                                SL4->L4_ADMINIS     := _aParcelas[nItem][5]
                                SL4->L4_NUMCART     := _aParcelas[nItem][6]
                                // SL4->L4_FORMAID     := _aParcelas[nItem][7]

                                SL4->L4_TERCEIR     := .F.
                                // SL4->L4_AGENCIA     :=
                                // SL4->L4_CONTA       :=
                                // SL4->L4_RG          :=
                                // SL4->L4_TELEFON     :=
                                // SL4->L4_OBS         :=
                                // SL4->L4_SITUA       :=
                                // SL4->L4_DATATEF     :=
                                // SL4->L4_HORATEF     :=
                                // SL4->L4_DOCTEF      :=
                                // SL4->L4_AUTORIZ     :=
                                // SL4->L4_DATCANC     :=
                                // SL4->L4_HORCANC     :=
                                // SL4->L4_DOCCANC     :=
                                // SL4->L4_INSTITU     :=
                                // SL4->L4_NSUTEF      :=
                                // SL4->L4_TIPCART     :=
                                // SL4->L4_MESACTA     :=
                                // SL4->L4_ANOACTA     :=
                                // SL4->L4_TIPOCHQ     :=
                                // SL4->L4_CGC         :=
                                // SL4->L4_NOMECLI     :=
                                // SL4->L4_SERCHQ      :=
                                // SL4->L4_COMP        :=
                                // SL4->L4_ORIGEM      :=
                                // SL4->L4_FORMPG      :=
                                // SL4->L4_VENDTEF     :=
                                // SL4->L4_PARCTEF     :=
                                // SL4->L4_TROCO       :=
                                // SL4->L4_ITEM        := 
                                // SL4->L4_ESTORN      :=
                                // SL4->L4_OPERAES     :=
                                // SL4->L4_SERPDV      :=
                                // SL4->L4_PAFMD5      :=
                                // SL4->L4_DOC         :=
                                // SL4->L4_CONTDOC     :=
                                // SL4->L4_CONTONF     :=
                                // SL4->L4_DESPRC      :=
                                // SL4->L4_BANPRC      :=
                                // SL4->L4_ACRSFIN     :=
                                // SL4->L4_PROCFID     :=
                                // SL4->L4_NUMCFID     :=
                                // SL4->L4_CONHTL      :=
                                // SL4->L4_CODVP       :=
                                // SL4->L4_DESCMN      :=
                                // SL4->L4_IDPGVFP     :=
                                // SL4->L4_IDRSPFI     :=
                                // SL4->L4_IDCNAB      :=
                            SL4->(MsUnlock())
                        Next nItem

                        ConfirmSX8()
                    End Transaction
                EndIf
            Else
                ZBMST1->(DbSkip())
            EndIf
        EndDo
    EndIf

	ZBMST1->(dbCloseArea())

Next nOrdId

    RESET ENVIRONMENT

    DBCloseAll()
   
return
