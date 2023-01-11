#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"


//-------------------------------------------------------------------
/*/{Protheus.doc} T4FCANCNET
@Description Função para ler os registros de cancelamento e efetuar as exclusões no Protheus
@type User Function
@author  Alessandra Costa
@version    1.00
@since      03/07/2022
/*/
//-------------------------------------------------------------------
user function T4FCANCNET()

    Local nZ := 1
    Local lRET    := .F.
    
    Private lLogado  := Type('cEmpAnt') == 'C'

    IF !lLogado
        cEmp := "20"
        cFil := "01"

        RPCSetType(3)
        PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "LOJA"
    ENDIF

	cEvento	 := SuperGetMv("ES_EVTNETP",.F.,"11254") 
	oTransacao := Nil
    nTamPrd   := TamSx3("B1_COD")[1]
    
    cQuery := " SELECT UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZZX_JSON, 2000, 1)) JSON, R_E_C_N_O_ RECNO"
	cQuery += " FROM " + RETSQLNAME("ZZX") + " ZZX WHERE "
    cQuery += "		ZZX.D_E_L_E_T_ <> '*' "
	cQuery += "		AND ZZX.ZZX_FILIAL =  '"+xFilial("ZZX")+"' "
	cQuery += "		AND ZZX_IDEVEN = '"+cEvento+"'"
    cQuery += "		AND ZZX_INTEGR = 'N' AND ZZX_STATUS = 'A' "
    cQuery += "		AND ZZX_OPERAC = 'CANCEL. CONSUMO               '"
    cQuery += "     ORDER BY "
	cQuery += "		ZZX.ZZX_DATA DESC, ZZX.ZZX_HORA DESC , ZZX.ZZX_IDPDV"
	TCQuery cQuery New Alias "ZZXCANC"


    ZZXCANC->(DbGoTop())
	If ZZXCANC->(!Eof())
		While ZZXCANC->( !Eof() )

            cRecno      := ZZXCANC->RECNO  //oTransacao := JsonObject():New()
            oTransacao := JsonObject():new()
            oTransacao:FromJson(ZZXCANC->JSON)
            cOperacao   := ALLTRIM(Upper(FwNoAccent(DecodeUtf8(oTransacao["operacao"]))))
            IF !(cOperacao == 'CANCEL. CONSUMO')
                ZZXCANC->(DBSKIP())
                loop
            ENDIF
            cTransOrig   := cValToChar(oTransacao["transacao_original_id"])
            cIDPDV       := cValToChar(oTransacao["transacao_id"])

            oProdutos := oTransacao['produtos']
			If ValType(oTransacao["produtos"]) == "A"
				nProd   := Len(oProdutos)
				cLogMsg := ""
                //BEGIN TRANSACTION
				For nZ := 1 To nProd
					cProduto := PadR(cValToChar(oProdutos[nZ]["cod_produto"]),nTamPrd)
                    nVlrUnit := oProdutos[nZ]["valor_unitario"]
                    nQtdPrd  := oProdutos[nZ]["quantidade"]
                    
                    cQryProd:= "SELECT ZZW.ZZW_PRDDE PRODDE,ZZW_PRDPAR PRODPARA " 
					cQryProd+= " FROM SIGA.ZZW200 ZZW WHERE ZZW.D_E_L_E_T_  <> '*' "
					cQryProd+= " AND ZZW.ZZW_PRDDE = '"+ PadR(cProduto,TamSx3("ZZW_PRDDE")[1]) +"'"
					MPSysOpenQuery(cQryProd,"TRBPROD")

					DbSelectArea("TRBPROD")
					TRBPROD->(DBGOTOP())
					IF !(TRBPROD->(EOF()))
						cProduto := PadR(AllTrim(TRBPROD->(PRODPARA)),nTamPrd)
                    ENDIF
                    TRBPROD->(DBCLOSEAREA( ))
                    
                    DbSelectArea("ZZX")
                    DbSetOrder(1)
                    dbgotop()
                    IF Dbseek(xFilial("ZZX")+cEvento+cTransOrig)
                        While ZZX->(!EOF()) .and. ZZX->ZZX_IDEVEN = cEvento .and. ZZX->ZZX_IDPDV = cTransOrig
                            IF  ZZX->ZZX_STATUS == '7'
                                lRet:=.T.
                                EXIT
                            ENDIF

                            IF (ZZX->ZZX_PRODUT == cProduto)
                                IF (ZZX->ZZX_QUANT == nQtdPrd)
                                    IF (ZZX->ZZX_STATUS == '1') .or. ZZX->ZZX_STATUS == 'A'
                                        RECLOCK ("ZZX",.F.)
                                            ZZX->ZZX_STATUS = '7'
                                           
                                        MsUnlock()
                                         lRet:=.T.
                                    ELSE
                                        lRet:= CANCPDV(cTransOrig,ZZX->ZZX_STATUS)
                                        if lRet
                                            RECLOCK ("ZZX",.F.)
                                                ZZX->ZZX_STATUS = '7'
                                            
                                            MsUnlock()
                                        endif
                                        
                                    ENDIF
                                ENDIF
                            ENDIF
                            ZZX->(DBSKIP())
                        END
                    ENDIF

                    ZZX->(DBCLOSEAREA())   	
                Next nZ

                IF lRET
                    cStatus:= 'C'
                ELSE
                    cStatus:= 'D'
                ENDIF
                DbSelectArea("ZZX")
                DbSetOrder(1)
                dbgoto(cRecno)
                IF ALLTRIM(cIDPDV) == ALLTRIM(ZZX->ZZX_IDPDV)
                    RecLock("ZZX", .F.)
                       ZZX->ZZX_STATUS := cStatus
                    MsUnlock()
                ENDIF
                
                //END TRANSACTION
            ENDIF
            ZZXCANC->(DBSKIP())
        END
	ENDIF
    
    ZZXCANC->(DBCLOSEAREA())
    
    EXCSL1CANC()

    IF !lLogado
        RESET ENVIRONMENT
    ENDIF

RETURN


Static Function CANCPDV(cTransOrig,cStatus)

    Local lRet:=.F.
    LOcal cDoc:= ZZX->ZZX_DOC

    IF cStatus == '6'

        DbSelectArea("SL1")
        DbSetOrder(2)
        DBGOTOP()
        IF dbseek (xFilial("SL1")+'2  '+ cDoc)
            cNumOrc :=  SL1->L1_NUM
            cRecnoSL1:= SL1->(RECNO())
            RecLock("SL1", .F.)
                SL1->L1_SITUA := 'X0'
            MsUnlock()
            Sleep(10000) //10 segundos de pausa
            lRetSefaz:= .F.
            WHILE !lRetSefaz
                cSitua:= GETADVFVAL("SL1", "L1_SITUA",xFILIAL("SL1")+cNumOrc,1,"")
                IF cSitua == 'X0' .OR. cSitua == 'X1'
                    Sleep(10000) //10 segundos de pausa
                
                ELSEIF cSitua == 'X2' //cancelamento autorizado sefaz
                    cHistor:= "Excluído DOC:"+ALLTRIM(cDoc) + " | ORC:"+ALLTRIM(cNumOrc)
                    cMsg:= "Excluido por cancelamento"
                    cStatus:= "1"
                    lRet:= U_grvStZZX(cStatus,,cNumOrc,cDoc,cMsg,cHistor,.T.)
                    lRet:=.T.
                    lRetSefaz:=.T.
                ELSEIF cSitua == 'X3' //cancelamento  NAO autorizado sefaz
                    RecLock("SL1", .F.)
                        SL1->L1_SITUA := 'T3'
                    MsUnlock()
                    lRetSefaz:=.T.
                ENDIF
            END
            
            /*
            xRet140 := Lj140Exc( "SL1", cRecnoSL1, 2, Nil, .T., SL1->L1_FILIAL, SL1->L1_NUM )
            If ValType(xRet140) == "N"
                If xRet140 <> 1
                    //SE ERRO AO EXCLUIR
                    cHistor:= "ROTINA EXCLUSAO"
                    cMsg   := "ERRO AO EXCLUIR NF E ORÇAMENTO"
                Else
                    
                    
                EndIf
            ENDIF*/
        ENDIF
                           

    ELSEIF cStatus $ ('2|3|4|5') 
        c:=1

    ENDIF

Return lRet


static function EXCSL1CANC()

    cQuery := " SELECT ZZX_ORC ORC, SL1.R_E_C_N_O_ SL1RECNO "
    cQuery += " FROM "+ retsqlname("ZZX") + " ZZX, "+ retsqlname("SL1") + " SL1"
	cQuery += " WHERE ZZX.D_E_L_E_T_ <> '*' AND SL1.D_E_L_E_T_ <> '*'
    cQuery += " AND ZZX_ORC = SL1.L1_NUM "
    cQuery += "	AND ZZX_IDEVEN = '"+cEvento+"'"
    cQuery += "	AND ZZX_STATUS = '7' AND ZZX_INTEGR = 'S' "
	cQuery += "	AND ZZX_ORC <> '  ' "
	
	TCQuery cQuery New Alias "ZZXSL1"

    ZZXSL1->(DbGoTop())
	If ZZXSL1->(!Eof())
		While ZZXSL1->( !Eof() )
            DbSelectArea("SL1")
            dbgoto(ZZXSL1->SL1RECNO)
            IF ZZXSL1->ORC == SL1->L1_NUM
                xRet140 := Lj140Exc( "SL1", ZZXSL1->SL1RECNO, 2, Nil, .T., SL1->L1_FILIAL, SL1->L1_NUM )
            ENDIF
            ZZXSL1->(dbskip())
        END
    ENDIF
    ZZXSL1->(DBCLOSEAREA())
Return
    
	
	
	
	