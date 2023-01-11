#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Rwmake.ch"

#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#INCLUDE "tbiconn.ch"

#INCLUDE "ap5mail.ch"

User function T4FMPErrorLog()
    Local oServer       := Nil
    Local oMessage      := Nil
    Local nret          := 0
    Local cSMTPServer   := GetMv('MV_RELSERV')
    Local cAccount      := GetMv('MV_RELACNT')
    Local cPass         := Alltrim(GetMv('MV_RELAPSW'))

    Local cTo           := SuperGetMV("MV_MPMAIL",.F.)
    Local cSubject      := "Erros de Integração Meep "+DTOC(DATE())

    Local cArquivo      := "\MeepMailLogs\LogErroIntegMeep"+DTOS(DATE())+"-"+SUBSTR(TIME(), 1, 2)+"h"+SUBSTR(TIME(), 4, 2)+".csv"

    Local nTotErro      := 0
    Local cLogErro      := ""

    Local lCabOrdTp     := .T.
    Local lCabStA       := .T.
    Local lCabStB       := .T.
    Local lCabStC       := .T.
    Local lCabStD       := .T.
    Local lCabStOther   := .T.

	Local _cEnter   	:= CHR(13)+CHR(10)

    //============================= Query com erros =============================

    if !empty(cTo)
        cQuery := " SELECT "
        cQuery += "     ZBM_ORDID, "
        cQuery += "     ZBM_CLICOD, "
        cQuery += "     ZBM_CLILO, "
        cQuery += "     ZBM_DTMP, "
        cQuery += "     ZBM_NUMB, "
        cQuery += "     ZBM_SERIE, "
        cQuery += "     ZBM_STATUS, "
        cQuery += "     ZBM_ORDTP, "
        cQuery += "     ZBM_KEYNFC, "
        cQuery += "     ZBM_EPEP, "
        cQuery += "     ZBM_VALUE, "
        cQuery += "     ZBM_OBS "
        cQuery += " FROM "
        cQuery += "		"+RetSQLName( "ZBM" )+" ZBM "
        cQuery += " WHERE "
        cQuery += "		    ZBM.D_E_L_E_T_ <> '*' "
        // cQuery += "		AND ( ZBM.ZBM_STATUS = 'A' OR ZBM.ZBM_STATUS = 'B' OR ZBM.ZBM_STATUS = 'C' OR ZBM.ZBM_STATUS = 'D' "
        // cQuery += "		OR ZBM.ZBM_ETAPA = '1' ) "
        cQuery += "		AND ZBM.ZBM_ETAPA = '1' "
        cQuery += " ORDER BY "
        cQuery += "		ZBM.ZBM_ORDTP, "
        cQuery += "		ZBM.ZBM_STATUS, "
        cQuery += "		ZBM.ZBM_ORDID "
        TCQuery cQuery New Alias "ZBMERROR"

        ZBMERROR->(DbGoTop())
        If ZBMERROR->(!Eof())
            cLogErro := "Erro n#;Num/Serie Cupom;Status;EPEP;Data Cupom;Valor;ID Venda;Obs Integração"
            While ZBMERROR->( !Eof() )
                nTotErro++
                IF ZBMERROR->ZBM_ORDTP == '1'
                    If ZBMERROR->ZBM_STATUS == 'A'
                        If lCabStA
                            cLogErro += +_cEnter+_cEnter+"====================================================="+_cEnter
                            cLogErro += +"Erro na criação do Orçamento"+_cEnter
                            cLogErro += +"====================================================="+_cEnter+_cEnter
                            lCabStA   := .F.
                        EndIf
                        cLogErro += +cValToChar(nTotErro)+";"+alltrim(ZBMERROR->ZBM_NUMB)+"/"+alltrim(ZBMERROR->ZBM_SERIE)+";"+alltrim(ZBMERROR->ZBM_STATUS);
                                    +";"+alltrim(ZBMERROR->ZBM_EPEP)+";"+ZBMERROR->ZBM_DTMP+";"+cValToChar(ZBMERROR->ZBM_VALUE);
                                    +";"+alltrim(ZBMERROR->ZBM_ORDID)+";"+alltrim(ZBMERROR->ZBM_OBS)+";"+_cEnter
                    ElseIf ZBMERROR->ZBM_STATUS == 'B'
                        If lCabStB
                            cLogErro += +_cEnter+_cEnter+"====================================================="+_cEnter
                            cLogErro += +"Venda sem Cupom"+_cEnter
                            cLogErro += +"====================================================="+_cEnter+_cEnter
                            lCabStB   := .F.
                        EndIf
                        cLogErro += +cValToChar(nTotErro)+";"+alltrim(ZBMERROR->ZBM_NUMB)+alltrim(ZBMERROR->ZBM_SERIE)+";"+alltrim(ZBMERROR->ZBM_STATUS);
                                    +";"+alltrim(ZBMERROR->ZBM_EPEP)+";"+ZBMERROR->ZBM_DTMP+";"+cValToChar(ZBMERROR->ZBM_VALUE);
                                    +";"+alltrim(ZBMERROR->ZBM_ORDID)+";"+alltrim(ZBMERROR->ZBM_OBS)+";"+_cEnter
                    ElseIf ZBMERROR->ZBM_STATUS == 'C'
                        If lCabStC
                            cLogErro += +_cEnter+_cEnter+"====================================================="+_cEnter
                            cLogErro += +"Sem saldo no endereço"+_cEnter
                            cLogErro += +"====================================================="+_cEnter+_cEnter
                            lCabStC   := .F.
                        EndIf
                        cLogErro += +cValToChar(nTotErro)+";"+alltrim(ZBMERROR->ZBM_NUMB)+"/"+alltrim(ZBMERROR->ZBM_SERIE)+";"+alltrim(ZBMERROR->ZBM_STATUS);
                                    +";"+alltrim(ZBMERROR->ZBM_EPEP)+";"+ZBMERROR->ZBM_DTMP+";"+cValToChar(ZBMERROR->ZBM_VALUE);
                                    +";"+alltrim(ZBMERROR->ZBM_ORDID)+";"+alltrim(ZBMERROR->ZBM_OBS)+";"+_cEnter
                    ElseIf ZBMERROR->ZBM_STATUS == 'D'
                        If lCabStD
                            cLogErro += +_cEnter+_cEnter+"====================================================="+_cEnter
                            cLogErro += +"Data de Emissão do Cupom antes da data do último fechamento (MV_ULMES)"+_cEnter
                            cLogErro += +"====================================================="+_cEnter+_cEnter
                            lCabStD   := .F.
                        EndIf
                        cLogErro += +cValToChar(nTotErro)+";"+alltrim(ZBMERROR->ZBM_NUMB)+"/"+alltrim(ZBMERROR->ZBM_SERIE)+";"+alltrim(ZBMERROR->ZBM_STATUS);
                                    +";"+alltrim(ZBMERROR->ZBM_EPEP)+";"+ZBMERROR->ZBM_DTMP+";"+cValToChar(ZBMERROR->ZBM_VALUE);
                                    +";"+alltrim(ZBMERROR->ZBM_ORDID)+";"+alltrim(ZBMERROR->ZBM_OBS)+";"+_cEnter
                    Else
                        If lCabStOther
                            cLogErro += +_cEnter+_cEnter+"====================================================="+_cEnter
                            cLogErro += +"Outros erros"+_cEnter
                            cLogErro += +"====================================================="+_cEnter+_cEnter
                            lCabStOther   := .F.
                        EndIf
                        cLogErro += +cValToChar(nTotErro)+";"+alltrim(ZBMERROR->ZBM_NUMB)+"/"+alltrim(ZBMERROR->ZBM_SERIE)+";"+alltrim(ZBMERROR->ZBM_STATUS);
                                    +";"+alltrim(ZBMERROR->ZBM_EPEP)+";"+ZBMERROR->ZBM_DTMP+";"+cValToChar(ZBMERROR->ZBM_VALUE);
                                    +";"+alltrim(ZBMERROR->ZBM_ORDID)+";"+alltrim(ZBMERROR->ZBM_OBS)+";"+_cEnter
                    EndIf
                Else
                    If lCabOrdTp
                        cLogErro += +_cEnter+_cEnter+"====================================================="+_cEnter
                        cLogErro += +"Vendas em CashLess - Não configurado no sistema"+_cEnter
                        cLogErro += +"====================================================="+_cEnter+_cEnter
                        lCabOrdTp   := .F.
                    EndIf
                    cLogErro += +cValToChar(nTotErro)+";;";
                                +";"+alltrim(ZBMERROR->ZBM_EPEP)+";"+ZBMERROR->ZBM_DTMP+";"+cValToChar(ZBMERROR->ZBM_VALUE);
                                +";"+alltrim(ZBMERROR->ZBM_ORDID)+";"+alltrim(ZBMERROR->ZBM_OBS)+";"+_cEnter
                EndIf
                ZBMERROR->(DbSkip())
            EndDo

            cCorpoMsg   := "Houveram erros na integração de vendas com o Meep<br><br>"
            cCorpoMsg   += +"Total de Erros: "+cValtoChar(nTotErro)
            cCorpoMsg   += +"<br><br>Mais detalhes no arquivo em anexo."

            MemoWrite(cArquivo, cLogErro)


            //============================= Envia email =============================

            oServer := TMailManager():New()
            oServer:Init( "", cSMTPServer, cAccount, cPass, 0 )

            nRet := oServer:SmtpConnect()

            If nRet != 0
                conout( "[SMTPCONNECT] Falha ao conectar" )
                conout( "[SMTPCONNECT][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
                Return .F.
            EndIf

            oMessage := TMailMessage():New()
            oMessage:Clear()
            oMessage:cFrom          := cAccount
            oMessage:cTo            := cTo
            // oMessage:cCc            := cCc            
            // oMessage:cBcc           := cBcc           
            oMessage:cSubject       := cSubject       
            oMessage:cBody          := cCorpoMsg       
            oMessage:AttachFile( cArquivo )   

            nRet := oMessage:Send( oServer )

            If nRet != 0
                conout( "[SEND] Fail to send message" )
                conout( "[SEND][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
            Else
                conout( "[SEND] Success to send message" )
            EndIf

            conout( "[DISCONNECT] smtp disconnecting ... " )
            nRet := oServer:SmtpDisconnect()

            If nRet != 0
                conout( "[DISCONNECT] Fail smtp disconnecting ... " )
                conout( "[DISCONNECT][ERROR] " + str( nRet, 6 ), oServer:GetErrorString( nRet ) )
            Else
                conout( "[DISCONNECT] Success smtp disconnecting ... " )
            EndIf
        EndIf
        ZBMERROR->(dbCloseArea())
    EndIf
Return
