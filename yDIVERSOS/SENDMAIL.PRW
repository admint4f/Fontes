#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "ap5mail.ch"

/*/{Protheus.doc} SENDMAIL
description A classe TMailManager realiza a comunicação com o servidor de e-mail. 
Ela permite a utilização de diversos protocolos:
@type function
@version 
@author roger
@since 17/11/2020
@param cTO, character, param_description
@param cCc, character, param_description
@param cBcc, character, param_description
@param cSubject, character, param_description
@param cBody, character, param_description
@return return_type, return_description
/*/
User function SENDMAIL(cTO,cCc,cBcc,cSubject,cBody)

    Local oServer     := Nil
    Local oMessage    := Nil
    Local nret        := 0
    Local cSMTPServer := GetMv('MV_RELSERV')
    Local cAccount    := GetMv('MV_RELACNT')
    Local cPass       := Alltrim(GetMv('MV_RELAPSW'))

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
    oMessage:cCc            := cCc            
    oMessage:cBcc           := cBcc           
    oMessage:cSubject       := cSubject       
    oMessage:cBody          := cBody          

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

Return