#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"
#include "PRTOPDEF.CH"

Static cEmpUse     := "20"
Static cFilUse     := "01"

 /*----------------------------------------------------------------------*
 | Func:  U_JBMPPROD()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  JOB que chama a função de atribuir códigos do clientes para   |
 |        as vendas                                                     |
 *----------------------------------------------------------------------*/

User Function JBMPPROD()
    Local aSM0      := {}
    Local cQuery    := ""
    Local i         := 1

	RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "EST"
        aSM0 := ArraySM0()
    RESET ENVIRONMENT

    For i:=1 to len(aSM0)
    
        RPCSetType(3)
        PREPARE ENVIRONMENT EMPRESA aSM0[i][1] FILIAL aSM0[i][2] MODULO "LOJA"
    
        cQuery := " SELECT "
        cQuery += "		ZB0.ZB0_EMP, "                                          + CRLF
        cQuery += "		ZB0.ZB0_FIL, "                                          + CRLF
        cQuery += "		ZB0.ZB0_NUM "                                           + CRLF
        cQuery += " FROM "                                                      + CRLF
        cQuery += "		"+RetSQLName( "ZB0" )+" ZB0 "                           + CRLF
        cQuery += " WHERE "                                                     + CRLF
        cQuery += "		ZB0.D_E_L_E_T_ <> '*' "                                 + CRLF
        cQuery += "		AND ZB0.ZB0_EMP = '"+aSM0[i][1] +"' "                   + CRLF
        cQuery += "		AND ZB0.ZB0_FIL = '"+aSM0[i][2]+"' "                    + CRLF
        cQuery += "		AND ZB0.ZB0_ATIVO = '1' "                               + CRLF
        TCQuery cQuery New Alias "ZB0Loop"

        ZB0Loop->(DbGoTop())
        
        If ZB0Loop->(!Eof())
            While ZB0Loop->( !Eof() )
                U_IMPROD(ZB0Loop->ZB0_NUM)        //Verifica/Cadastra Cliente     - Status 1
                ZB0Loop->(DbSkip())
            EndDo
        EndIf
        ZB0Loop->(dbCloseArea())

        RESET ENVIRONMENT
    Next i

Return (.T.)

/*----------------------------------------------------------------------*
 | Func:  U_JBMPZBM()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Rotina responsï¿½vel por consultar a API do Meep de Vendas e 	|
 |        gerar as tabelas ZBM, ZBN e ZBP para inï¿½cio da integraï¿½ï¿½o. 	|
 *----------------------------------------------------------------------*/

User Function JBMPZBM(dDataInt,cHrInt)
    Local aSM0          := {}
    Default dDataInt      := date()
    Default cHrInt        := SubStr(Time(), 1, 2)

    If ValType(dDataInt) == "C"
        dDataInt := CToD(dDataInt)
    EndIf

    PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "LOJA"
        aSM0 := ArraySM0()
    RESET ENVIRONMENT

    RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA aSM0[1][1] FILIAL aSM0[1][2] MODULO "LOJA"
        U_IMCadZBM(dDataInt,cHrInt)        //Cria ZBM                      - Status 0
    RESET ENVIRONMENT

Return (.T.)

 /*----------------------------------------------------------------------*
 | Func:  U_JBMPCLI()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  JOB que chama a funï¿½ï¿½o de atribuir cï¿½digos do clientes para   |
 |        as vendas                                                     |
 *----------------------------------------------------------------------*/

User Function JBMPCLI()
    Local cCliPd      := ""
    Local cCliLjPD    := ""

    Local aCliPad 	:= {}          //Dados do Cliente Padrï¿½o {a1_num,a1_loja,}
    Local aSM0      := {}

	RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "LOJA"
        aSM0 := ArraySM0()
    RESET ENVIRONMENT

	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA aSM0[1][1] FILIAL aSM0[1][2] MODULO "LOJA"
        cCliPd      := SuperGetMV("MV_MPCLIPD",.F.,"000001")
        cCliLjPD    := SuperGetMV("MV_MPCLILO",.F.,"01")
        aCliPad 	:= {cCliPd,cCliLjPD,.T.}
        U_IMCliente(aCliPad)        //Verifica/Cadastra Cliente     - Status 1
    RESET ENVIRONMENT

Return (.T.)


 /*----------------------------------------------------------------------*
 | Func:  U_JBMPCLI()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  JOB que chama a funï¿½ï¿½o de atribuir cï¿½digos do clientes para   |
 |        as vendas                                                     |
 *----------------------------------------------------------------------*/

User Function JBMPOP()
    Local aSM0      := {}
    Local i         := 0

	//RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "LOJA"
        aSM0 := ArraySM0()
    RESET ENVIRONMENT

    For i:=1 to len(aSM0)
        //RPCSetType(3)
        PREPARE ENVIRONMENT EMPRESA aSM0[i][1] FILIAL aSM0[i][2] MODULO "LOJA"
            U_IMOrdProd()        //Cria e aponta OP     - Status 1
        RESET ENVIRONMENT
    Next i

Return (.T.)


/*----------------------------------------------------------------------*
 | Func:  U_JBMPORC()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  JOB responsï¿½vel por gerar as tabelas SL1, SL2 e SL4 do    	|
 |        SIGALOJA via ExecAuto.                                        |
 |        Compete com a função JBRLMPORC, ative somente uma das duas.   |
 *----------------------------------------------------------------------*/

USER FUNCTION JBMPORC()
    Local aSM0          := {}
    Local i             := 0

    Local nOrcExec      := 0

    Local aZBM          := {}
    Local cZBM          := ""
    Local nQtdInt       := ""

	RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "LOJA"
        aSM0 := ArraySM0()
    RESET ENVIRONMENT

    nOrcExec := 0
    For i:=1 to len(aSM0)
        aZBM := {}
        cZBM          := ""
        if nOrcExec == 0
            RPCSetType(3)
            PREPARE ENVIRONMENT EMPRESA aSM0[i][1] FILIAL aSM0[i][2] MODULO "LOJA"
                nQtdInt     := SuperGetMV("MV_MPQTORC",.F.,1)
                nQtdInt     := 30

                cQuery := "         SELECT "
                cQuery += "             ZBM_ORDID, "
                cQuery += "             ZBM_CLICOD, "
                cQuery += "             ZBM_CLILO, "
                cQuery += "             ZBM_DTMP, "
                cQuery += "             ZBM_NUMB, "
                cQuery += "             ZBM_SERIE, "
                cQuery += "             ZBM_KEYNFC, "
                cQuery += "             ZBM_EPEP, "
                cQuery += "             ZBM_STATUS, "
                cQuery += "             ZBM_VALUE, "
                cQuery += "             ZBM_ORDTP "
                cQuery += "         FROM "+RetSQLName( "ZBM" )+" ZBM "
                cQuery += "         INNER JOIN "+RetSQLName( "ZB0" )+" ZB0 ON ( "
                cQuery += "             ZBM.ZBM_STORE = ZB0.ZB0_MEEP "
                cQuery += "         ) "
                cQuery += "         WHERE "
                cQuery += "		        ZBM.D_E_L_E_T_ <> '*' "
                cQuery += "		        AND ZB0.ZB0_FIL =  '"+ALLTRIM(SM0->M0_CODFIL)+"' "
                cQuery += "		        AND ZB0.ZB0_EMP =  '"+ALLTRIM(SM0->M0_CODIGO)+"' "
                cQuery += "             AND ZB0.D_E_L_E_T_ <> '*' " 
                cQuery += " 	        AND ZB0.ZB0_ATIVO = '1' "		
                // cQuery += "		        AND ( ZBM.ZBM_STATUS = '1' OR ZBM.ZBM_STATUS = 'A' OR ZBM.ZBM_STATUS = 'B' OR ZBM.ZBM_STATUS = 'C' OR ZBM.ZBM_STATUS = 'D' ) "
                cQuery += "		        AND ( ZBM.ZBM_STATUS = '1' AND ZBM.ZBM_ETAPA = '0' ) "
                cQuery += "		        AND ZBM.ZBM_ORDTP  = '1' "
                cQuery += "		        AND (ZBM.ZBM_SEFCD  = '100' OR (ZBM.ZBM_SEFCD  = '128' AND ZBM.ZBM_DTCANC  <> '  '))"
                // cQuery += "		        AND ZBM.ZBM_KEYNFC <> '"+space(TAMSX3("ZBM_KEYNFC")[1])+"' "
                cQuery += "		        AND ROWNUM <= "+cvaltochar(nQtdInt)+" "
                TCQuery cQuery New Alias "ZBMCONT"

                ZBMCONT->(DbGoTop())
                Count To nOrcExec
                ZBMCONT->(DbGoTop())

                if nOrcExec > 0
                    While ZBMCONT->( !Eof() )
                        dbSelectArea("ZBM")
                        dbSetOrder(2)
                        If dbSeek(xFilial("ZBM")+ZBMCONT->ZBM_ORDID)
                            if ZBM->ZBM_STATUS == '1'
                                RecLock('ZBM', .F.)
                                    ZBM->ZBM_STATUS     := "X"
                                ZBM->(MsUnlock())
                                aadd(aZBM,ZBM->ZBM_ORDID)
                                if len(cZBM) == 0
                                    cZBM += ZBM->ZBM_ORDID
                                else
                                    cZBM += ","+ZBM->ZBM_ORDID
                                endif
                            Elseif ZBM->ZBM_STATUS == 'X'
                                lVldCup := .F.
                            EndIf
                        EndIf
                        ZBMCONT->(DbSkip())
                    EndDo

                   // StartJob("U_IMCADORC()",GetEnvServer(),.F.,aSM0[i][1],aSM0[i][2],aZBM)
                     U_IMCADORC(aSM0[i][1],aSM0[i][2],aZBM)
                    conout("[Integraï¿½ï¿½o Meep] Orï¿½amento Fim  || Emp: "+aSM0[1][1]+" - Filial: "+aSM0[1][1]+" - "+dtoc(date())+" "+time())
                EndIf

                If Select("ZBMCONT") > 0
					ZBMCONT->(dbCloseArea())
				EndIf
                // (ZBMCONT)->(dbCloseArea())
                
            RESET ENVIRONMENT
        EndIf
    Next i

return


/*----------------------------------------------------------------------*
 | Func:  U_JBRLMPORC()                                                 |
 | Autor: Felipe Sakaguti                                               |
 | Data:  19/03/2021                                                    |
 | Desc:  JOB responsÃ¡vel por gerar as tabelas SL1, SL2 e SL4 do       |
 |        SIGALOJA via inserção no banco (RecLock).                     |
 |        Compete com a função JBRLMPORC, ative somente uma das duas.   |
 *----------------------------------------------------------------------*/
/*
USER FUNCTION JBRLMPORC()
    Local aSM0          := {}
    Local i             := 0

    Local nOrcExec      := 0

    Local aZBM          := {}
    Local cZBM          := ""

    PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "LOJA"
        aSM0 := ArraySM0()
    RESET ENVIRONMENT


    nOrcExec := 0
    For i:=1 to len(aSM0)
        aZBM := {}
        cZBM          := ""
        if nOrcExec == 0
            RPCSetType(3)
            PREPARE ENVIRONMENT EMPRESA aSM0[i][1] FILIAL aSM0[i][2] MODULO "LOJA"
                nQtdInt     := SuperGetMV("MV_MPQTORC",.F.,1)
                cQuery := "         SELECT "
                cQuery += "             ZBM_ORDID, "
                cQuery += "             ZBM_CLICOD, "
                cQuery += "             ZBM_CLILO, "
                cQuery += "             ZBM_DTMP, "
                cQuery += "             ZBM_NUMB, "
                cQuery += "             ZBM_SERIE, "
                cQuery += "             ZBM_KEYNFC, "
                cQuery += "             ZBM_EPEP, "
                cQuery += "             ZBM_STATUS, "
                cQuery += "             ZBM_VALUE, "
                cQuery += "             ZBM_ORDTP "
                cQuery += "         FROM "+RetSQLName( "ZBM" )+" ZBM "
                cQuery += "         INNER JOIN "+RetSQLName( "ZB0" )+" ZB0 ON ( "
                cQuery += "             ZBM.ZBM_STORE = ZB0.ZB0_MEEP "
                cQuery += "         ) "
                cQuery += "         WHERE "
                cQuery += "		        ZBM.D_E_L_E_T_ <> '*' "
                cQuery += "		        AND ZB0.ZB0_FIL =  '"+ALLTRIM(SM0->M0_CODFIL)+"' "
                cQuery += "		        AND ZB0.ZB0_EMP =  '"+ALLTRIM(SM0->M0_CODIGO)+"' "
                cQuery += "             AND ZB0.D_E_L_E_T_ <> '*' " 
                // cQuery += "		        AND ( ZBM.ZBM_STATUS = '1' OR ZBM.ZBM_STATUS = 'A' OR ZBM.ZBM_STATUS = 'B' OR ZBM.ZBM_STATUS = 'C' OR ZBM.ZBM_STATUS = 'D' ) "
                cQuery += "		        AND ( ZBM.ZBM_STATUS = '1' AND ZBM.ZBM_ETAPA = '0' ) "
                cQuery += "		        AND ZBM.ZBM_ORDTP  = '1' "
                cQuery += "		        AND ROWNUM <= "+cvaltochar(nQtdInt)+" "
                TCQuery cQuery New Alias "ZBMCONT"

                ZBMCONT->(DbGoTop())
                Count To nOrcExec
                ZBMCONT->(DbGoTop())

                if nOrcExec > 0
                    While ZBMCONT->( !Eof() )
                        dbSelectArea("ZBM")
                        dbSetOrder(2)
                        If dbSeek(xFilial("ZBM")+ZBMCONT->ZBM_ORDID)
                            if ZBM->ZBM_STATUS == '1'
                                RecLock('ZBM', .F.)
                                    ZBM->ZBM_STATUS     := "X"
                                ZBM->(MsUnlock())
                                aadd(aZBM,ZBM->ZBM_ORDID)
                                if len(cZBM) == 0
                                    cZBM += ZBM->ZBM_ORDID
                                else
                                    cZBM += ","+ZBM->ZBM_ORDID
                                endif
                            Elseif ZBM->ZBM_STATUS == 'X'
                                lVldCup := .F.
                            EndIf
                        EndIf
                        ZBMCONT->(DbSkip())
                    EndDo

                    //StartJob("U_IMRLCadOrc()",GetEnvServer(),.F.,aSM0[i][1],aSM0[i][2],aZBM)
                    U_IMRLCadOrc(aSM0[i][1],aSM0[i][2],aZBM)
                    conout("[Integracao Meep] Orcamento Fim  || Emp: "+aSM0[1][1]+" - Filial: "+aSM0[1][1]+" - "+dtoc(date())+" "+time())
                EndIf
                
                If Select(ZBMCONT) > 0
					(ZBMCONT)->(dbCloseArea())
				EndIf
                //ZBMCONT->(dbCloseArea())
                
            RESET ENVIRONMENT
        EndIf
    Next i

return
*/
/*----------------------------------------------------------------------*
 | Func:  U_JBMPVLD()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  JOB responsável por chamar o Batch de execução do Protheus   	|
 |        que irá transformar a venda em Documento de saída, Livro      |
 |        Fiscal, Financeiro e Contabil (LJGRVBATCH).                   |
 *----------------------------------------------------------------------*/

User Function JBMPVLD()
    Local aSM0          := {}
    Local i             := 0
    Local nOrcExec      := 0
    Local nJobSimult    := 1
    
    PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "LOJA"
        aSM0 := ArraySM0()
    RESET ENVIRONMENT


    For i:=1 to len(aSM0)
        nOrcExec := 0
        RPCSetType(3)
        PREPARE ENVIRONMENT EMPRESA aSM0[i][1] FILIAL aSM0[i][2] MODULO "LOJA"
            cQuery := " SELECT L1_NUM "
            cQuery += " FROM "
            cQuery += "		"+RetSQLName( "SL1" )+" SL1 "
            cQuery += " WHERE "
            cQuery += "		SL1.D_E_L_E_T_ <> '*' "
            cQuery += "		AND SL1.L1_SITUA = 'RX' "
            cQuery += "		AND SL1.L1_FILIAL = '"+aSM0[i][2]+"' "
            cQuery += "		AND SL1.L1_SERIE = '1  ' "
            cQuery += " ORDER BY L1_NUM "
            TCQuery cQuery New Alias "SL1STRX"

            SL1STRX->(DbGoTop())
            Count To nOrcExec
            SL1STRX->(DbGoTop())

            nJobSimult	:= SuperGetMV("MV_JBLJSMT",.F.,10)

            if nOrcExec > 0            
                StartJob("U_T4FLJGRV",GetEnvServer(),.F.,aSM0[i][1],aSM0[i][2],cvaltochar(nJobSimult))
                // U_T4FLJGRV(aSM0[i][1],aSM0[i][2],cvaltochar(nJobSimult))
            EndIf

            SL1STRX->(dbCloseArea())

        RESET ENVIRONMENT
    Next i

Return (.T.)

/*----------------------------------------------------------------------*
 | Func:  U_ITMEEPSCH()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Rotina de Scheduler responsável pela criação de financeiro, 	|
 |        movimentação de estoque e envio de email com logs de erros. 	|
 *----------------------------------------------------------------------*/

User Function ITMEEPSCH()
    Local aSM0          := {}
    Local i             := 0
    Local aCliPad 	    := {}          //Dados do Cliente Padrï¿½o {a1_num,a1_loja,}

    Local cCliPd      := ""
    Local cCliLjPD    := ""

    Local dDataInt      := date()-1

    // dDataInt      := CToD("09/15/2021")   

    PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "LOJA"
        aSM0 := ArraySM0()
    RESET ENVIRONMENT

    For i:=1 to len(aSM0)
        RPCSetType(3)
        PREPARE ENVIRONMENT EMPRESA aSM0[i][1] FILIAL aSM0[i][2] MODULO "LOJA"

            cCliPd      := SuperGetMV("MV_MPCLIPD",.F.,"000001")
            cCliLjPD    := SuperGetMV("MV_MPCLILO",.F.,"01")
            aCliPad 	:= {cCliPd,cCliLjPD,.T.}

            U_IMMPRec(aCliPad,dDataInt)
            // U_IMMPMov(dDataInt)

            // T4FMPErrorLog()

        RESET ENVIRONMENT
    Next i

Return (.T.)

/*----------------------------------------------------------------------*
 | Func:  ArraySM0()                                           	        |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Função que cria array com empresas e filiais que deverï¿½o ser 	|
 |        consideradas para a Integraï¿½ï¿½o Meep.                          |
 | Ret:   Array de Empresas + Filiais                                	|
 *----------------------------------------------------------------------*/

Static Function ArraySM0()
    Local aSM0  := {}

    /* //Função Para pegar empresas e filiais do SM0, funciona, mas passa por todas filiais da empresa, perdendo perfomance
        Local cEmp  := SuperGetMV("MV_MPEMP",.F.,"99")
        Local aEmp  := Separa(cEmp,',', .T.)       //Array de Empresas a serem Integradas

        RPCSetEnv()

        cQuery := " SELECT M0_CODIGO, M0_CODFIL, M0_FILIAL, M0_NOME "
        cQuery += " FROM "
        cQuery += "		"+RetSQLName( "SM0" )+" SM0 "
        cQuery += " WHERE "
        cQuery += "		SM0.D_E_L_E_T_ <> '*' "
        // cQuery += "		AND SM0.M0_CODIGO = '20' "
        cQuery += " ORDER BY M0_CODIGO, M0_CODFIL, M0_FILIAL, M0_NOME "
        TCQuery cQuery New Alias "SM0MEEP"

        SM0MEEP->(DbGoTop())

        If SM0MEEP->(!Eof())
            While SM0MEEP->( !Eof() )
                nEmp    := ASCAN(aEmp,alltrim(SM0MEEP->M0_CODIGO))
                if nEmp <> 0
                    aadd(aSM0,{SM0MEEP->M0_CODIGO,alltrim(SM0MEEP->M0_CODFIL)})
                EndIf
                SM0MEEP->(DbSkip())
            EndDo
        EndIf
        SM0MEEP->(dbCloseArea())
    */

    aSM0 := {}

    aadd(aSM0,{"20","01"})      //Empresa 20 - Filial 01

Return aSM0
