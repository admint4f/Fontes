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

User Function IMCOrrOrc()

    //Precisa Verificar

    Local nTotMov       := 0
    Private lMsHelpAuto := .T. //Variavel de controle interno do ExecAuto
    Private lMsErroAuto := .F. //Variavel que informa a ocorrência de erros no ExecAuto
    Private INCLUI      := .T. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
    Private ALTERA      := .F. //Variavel necessária para o ExecAuto identificar que se trata de uma alteração

    RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA "20" FILIAL "01" MODULO "LOJA"

    cQuery := " SELECT "
    cQuery += "     ZBM_ORDID, "
    cQuery += "     ZBM_CLICOD, "
    cQuery += "     ZBM_CLILO, "
    cQuery += "     ZBM_DTMP, "
    cQuery += "     ZBM_NUM, "
    cQuery += "     ZBM_SERIE, "
    cQuery += "     ZBM_KEYNFC, "
    cQuery += "     ZBM_EPEP, "
    cQuery += "     ZBM_VALUE, "
    cQuery += "     ZBM_FILORC, "
    cQuery += "     ZBM_DTMPFT, "
    cQuery += "     ZBM_DTEMIS, "
    cQuery += "     ZBM_HREMIS, "
    cQuery += "     ZB0_LOCAL, "
    cQuery += "     ZB0_LOCALI, "
    cQuery += "     ZB0_FIL, "
    cQuery += "     ZB0_ADMINI "
    // cQuery += "     ZBN_ITEMMP, "
    // cQuery += "     ZBN_COD, "
    // cQuery += "     ZBN_QTD, "
    // cQuery += "     ZBN_VLUN, "
    // cQuery += "     ZBN_TES, "
    // cQuery += "     ZBN_DESCO "
	cQuery += " FROM "
	cQuery += "		"+RetSQLName( "ZBM" )+" ZBM "
    cQuery += "     INNER JOIN "+RetSQLName( "ZB0" )+" ZB0 ON ( "
    cQuery += "         ZBM.ZBM_STORE = ZB0.ZB0_MEEP  "
    cQuery += "     ) "
    // cQuery += "     INNER JOIN "+RetSQLName( "ZBN" )+" ZBN ON ( "
    // cQuery += "         ZBM.ZBM_ORDID = ZBN.ZBN_ORDID "
    // cQuery += "     ) "
	cQuery += " WHERE "
	cQuery += "		ZB0.ZB0_FIL =  '"+ALLTRIM(SM0->M0_CODFIL)+"' "
	cQuery += "		AND ZB0.ZB0_EMP =  '"+ALLTRIM(SM0->M0_CODIGO)+"' "
    cQuery += "     AND ZB0.D_E_L_E_T_ <> '*' "
    // cQuery += "     AND ZBN.D_E_L_E_T_ <> '*' "
    cQuery += "     AND ZBM.D_E_L_E_T_ <> '*' "
    cQuery += "     AND ZBM.ZBM_STATUS = '2' "
	cQuery += " ORDER BY "
	cQuery += "		ZBM.ZBM_ORDID "
	// cQuery += "		ZBN.ZBN_COD, "
	// cQuery += "		ZBN.ZBN_ITEMMP "
	TCQuery cQuery New Alias "ZBMST1"

    ZBMST1->(DbGoTop())
    Count To nTotMov
    ZBMST1->(DbGoTop())

	If ZBMST1->(!Eof()) 
		While ZBMST1->( !Eof() )
            
            dbSelectArea("SL1")
            dbSetOrder(1)

            If dbSeek(ZBMST1->ZBM_FILORC+padr(Alltrim(ZBMST1->ZBM_NUM),TAMSX3("L1_NUM")[1] ," "))
                RecLock("SL1", .F.)
                    SL1->L1_EMISSAO		:=	SToD(ZBMST1->ZBM_DTEMIS)
                    SL1->L1_EMISNF		:=	SToD(ZBMST1->ZBM_DTEMIS)
                SL1->(MsUnlock())
            EndIf

        /*
            // dbSelectArea("ZBM")
            // dbSetOrder(2)
            // If dbSeek(xFilial("ZBM")+padr(aZBMAtu[5],TAMSX3("ZBM_ORDID")[1] ," "))
            //     RecLock('ZBM', .F.)
            //         ZBM->ZBM_STATUS     := "2"
            //         ZBM->ZBM_OBS        := ""
            //         ZBM->ZBM_ETAPA      := "0"
            //         ZBM->ZBM_NUM        := SL1->L1_NUM
            //         ZBM->ZBM_FILORC     := ALLTRIM(SM0->M0_CODFIL)
            //     ZBM->(MsUnlock())
            // EndIf  

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
        */      
            ZBMST1->(dbSkip())    
        EndDo
    EndIf

	ZBMST1->(dbCloseArea())

    RESET ENVIRONMENT

    DBCloseAll()
   
return
