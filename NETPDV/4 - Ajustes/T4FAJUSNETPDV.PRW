#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"


User Function AtuStatusNetPDV()

    Local lEnd		:= .F.
    Local oGrid	 	:= Nil
    Local cTitulo	 := "Integração NetPDV x Protheus"
    Local cDescricao := "Atualiza status dos registros na ZZX, de acordo com dados da NFCE no TSS."

    Private lLogado  := Type('cEmpAnt') == 'C'

    IF !lLogado
        cEmp := "20"
        cFil := "01"

        RPCSetType(3)
        PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "LOJA"

        atuStatus()
    ELSE

        oGrid := FWGridProcess():New("AtuStatusNetPDV",cTitulo,cDescricao,{|lEnd| atuStatus(oGrid)},/*cPergunta*/,/*cGrid*/,/*lSaveLog*/)
        oGrid:SetMeters(1)
        oGrid:Activate()
        If oGrid:IsFinished()
            FWAlertSuccess("Processamento finalizado com sucesso!", "Sucesso!")
        Else
            FWAlertError("Erro ao realizar Processamento!","Error!")
        EndIf
        oGrid:DeActivate()
        FwFreeObj(oGrid)
    ENDIF

    
RETURN


Static Function atuStatus(oGrid)

    cEvento	 := SuperGetMv("ES_EVTNETP",.F.,"11254") 

    //Corrige status dos que foram autorizados
    IF lLogado
        oGrid:SetIncMeter(1,"Corrigindo Autorizadas")
    ENDIF
    ATUSTAT6(cEvento)


    //Corrige status dos que foram cancelados
    IF lLogado
        oGrid:SetIncMeter(1,"Corrigindo Canceladas")
    ENDIF
    ATUSTAT7(cEvento)

RETURN

Static FUnction ATUSTAT6(cEvento,oGrid)
   
    cQuery:= " SELECT ZZX_IDPDV, ZZX_STATUS , SUBSTR(L1_RETSFZ,16,40) RETSEFAZ, SL1.L1_SITUA , SL1.L1_NUM ORC, F2_DOC DOC, SPED.STATUS, SPED.DOC_CHV "
    cQuery+= " ,SPED.NFE_PROT ||'|100|Autorizado o uso da NF-e ' MSGPROT, SL1.R_E_C_N_O_  SL1RECNO"
    cQuery+= " FROM "+retsqlname("ZZX")+" ZZX, "+retsqlname("SL1")+" SL1, "+retsqlname("SF2")+" SF2, SPED050 SPED "
    cQuery+= " WHERE SL1.D_E_L_E_T_ <> '*' AND ZZX.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SPED.D_E_L_E_T_ <> '*' "
    cQuery+= " AND ZZX_ORC = SL1.L1_NUM AND ZZX_DOC = SF2.F2_DOC AND SF2.F2_SERIE = '2  ' AND L1_SERIE = '2  ' AND SPED.NFE_ID = '2  '||F2_DOC "
    cQuery+= " AND ZZX.ZZX_IDEVEN = '"+cEvento+"' "
    cQuery+= " AND ZZX_STATUS <> '6' AND SPED.STATUS  = '6' "
    cQuery+= " GROUP BY ZZX_IDPDV ,ZZX_STATUS , SUBSTR(L1_RETSFZ,16,40) , SL1.L1_SITUA, SL1.L1_NUM , F2_DOC "
    cQuery+= " ,SPED.STATUS, SPED.DOC_CHV,SPED.NFE_PROT , SL1.R_E_C_N_O_"
    cQuery+= " ORDER BY ZZX_STATUS,SPED.STATUS "

    TCQuery cQuery New Alias "ZZXSTAT"


    ZZXSTAT->(DbGoTop())
	If ZZXSTAT->(!Eof())
		While ZZXSTAT->( !Eof() )

            DbSelectArea("SL1")
            DBGOTO( ZZXSTAT->SL1RECNO )
            IF !(ZZXSTAT->RETSEFAZ == "|100|Autorizado o uso da NF-e           " .and. ZZXSTAT->L1_SITUA == "T3")
                IF SL1->L1_NUM == ZZXSTAT->ORC
                    RecLock("SL1", .F.)
                        SL1->L1_SITUA   := "T3"   
                        SL1->L1_RETSFZ  := ZZXSTAT->MSGPROT
                    MsUnlock()
                ENDIF
            ENDIF
            cStatus:= "6"
            cMsg:= "NFCE AUTORIZADA"
            U_grvStZZX(cStatus,,ZZXSTAT->ORC,ZZXSTAT->DOC,cMsg,"ROTINA ATUSTATUS",,DTOS(SL1->L1_EMISNF))

            ZZXSTAT->(dbSKIP())
        END
    ENDIF

    ZZXSTAT->(DBCLOSEAREA())

Return


Static Function ATUSTAT7(cEvento,oGrid)

    Private lRet      := .F.

    
    cQuery:= " SELECT ZZX_IDPDV, ZZX_STATUS STATUSZZX, SUBSTR(L1_RETSFZ,16,40) RETSEFAZ, SL1.L1_SITUA , SL1.L1_NUM ORC, F2_DOC DOC, SPED.STATUS STATUSSPED, "
    cQuery+= " SPED.DOC_CHV, SL1.R_E_C_N_O_  SL1RECNO"
    cQuery+= " FROM "+retsqlname("ZZX")+" ZZX, "+retsqlname("SL1")+" SL1, "+retsqlname("SF2")+" SF2, SPED050 SPED "
    cQuery+= " WHERE SL1.D_E_L_E_T_ <> '*' AND ZZX.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SPED.D_E_L_E_T_ <> '*' "
    cQuery+= " AND ZZX_ORC = SL1.L1_NUM AND ZZX_DOC = SF2.F2_DOC AND SF2.F2_SERIE = '2  ' AND L1_SERIE = '2  ' AND SPED.NFE_ID = '2  '||F2_DOC "
    cQuery+= " AND ZZX.ZZX_IDEVEN = '"+cEvento+"' "
    cQuery+= " AND ZZX_STATUS <> '6' AND SPED.STATUS  = '7' AND SPED.STATUSCANC = '2' "
    cQuery+= " GROUP BY ZZX_IDPDV ,ZZX_STATUS , SUBSTR(L1_RETSFZ,16,40) , SL1.L1_SITUA, SL1.L1_NUM , F2_DOC "
    cQuery+= " ,SPED.STATUS, SPED.DOC_CHV, SL1.R_E_C_N_O_"
    cQuery+= " ORDER BY ZZX_STATUS,SPED.STATUS "

    TCQuery cQuery New Alias "ZZXSTAT"


    ZZXSTAT->(DbGoTop())
	If ZZXSTAT->(!Eof())
        
		While ZZXSTAT->( !Eof() )

            cNumero     := ZZXSTAT->DOC
			cOrcamento  := ZZXSTAT->ORC
			cStatOld    := ZZXSTAT->STATUSZZX
            cRecnoSL1   := ZZXSTAT->SL1RECNO

			DbSelectArea("SL1")
			DBGOTO(cRecnoSL1)
			//IF dbseek (xFilial("SL1")+'2  '+ ZZXSTAT->DOC)
                begin transaction
				    reclock("SL1",.F.)
                        SL1->L1_ESPECIE := ""
						SL1->L1_KEYNFCE := ""
					MsUnlock()
					xRet140 := Lj140Exc( "SL1", cRecnoSL1, 2, Nil, .T., SL1->L1_FILIAL, SL1->L1_NUM )
					If ValType(xRet140) == "N"
						If xRet140 <> 1
					    	//SE ERRO AO EXCLUIR
                            cHistor:= "ROTINA EXCLUSAO"
                            cMsg   := "ERRO AO EXCLUIR NF E ORÇAMENTO"
						Else
                            cHistor:= "Excluído DOC:"+ALLTRIM(cNumero) + " | ORC:"+ALLTRIM(cOrcamento)
                            cMsg   := "NF EXCLUIDA"
						    cStatus:= "1"
						EndIf
					Else
						//ERRO DESCONHECIDO NA EXCLUSAO
                        cHistor:= "ROTINA EXCLUSAO"
                        cMsg   := "ERRO AO EXCLUIR NF E ORÇAMENTO"
					EndIf

                    lRet:= U_grvStZZX(cStatus,,cOrcamento,cNumero,cMsg,cHistor,.T.,,cStatOld)
                    IF !lRet
                        DisarmTransaction()
                    ENDIF
                        
                end transaction

            //ENDIF
			SL1->(DBCLOSEAREA())
			ZZXSTAT->(dbSKIP())
        END
    ENDIF

    ZZXSTAT->(DBCLOSEAREA())

Return





