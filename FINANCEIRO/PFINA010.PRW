#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} FINA010
Pontos de entrada padrão para o cadastro de Naturezas em MVC
Consistem em efetuar o bloqueio de uma nova inclusão de natureza onde somente o Fiscal pode liberar.
Envio de workflow para aprovação.
@author Lucas Valins
@since 29/01/2021
@version 12.1.25
/*/

User Function FINA010()
	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObjForm
	Local cIdExec
	Local cIdForm
	Local cUsers := SuperGetMV('MV_NATBLOQ',,'admin')

// Na hipótese dos parâmetros serem nulos, aborto a execução dos pontos de entrada do MVC
	If aParam != Nil
		oObjForm := aParam[1]
		cIdExec :=  aParam[2]
		cIdForm :=  aParam[3]
// Antes da gravação da tabela do formulário - FORMCOMMITTTSPRE
		//GetOperation()
		//1 - View
		//3 - Insert
		//4 - Update
		//5 - Delete
		//6 - Only Update
		If cIdExec == "MODELVLDACTIVE" .and. !cUsername$cUsers//'frferreira/tborges/vviveiros/emaimone/tmoraes'
        oObjForm:GetModel("SEDMASTER"):GetStruct():SetProperty("ED_MSBLQL", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN ,".F."))
        Endif
        If cIdExec == 'FORMCOMMITTTSPRE'
            If oObjForm:GetOperation() == 3 // Equivale ao FIN010INC
                xRet := .T.
                cTo := 'tax@t4f.com.br'
                cCc := 'cadastros@t4f.com.br'
                cBcc := ''
				cSubject := 'INCLUSAO DA NATUREZA: '+M->ED_CODIGO
				cBody :='<p>&nbsp;</p>'
				cBody += '<p><strong> <img src="https://ncdn0.infojobs.com.br/logos/Company_Evaluation/59837.jpg"'
				cBody += 'width="190" height="64" align="left" border="0" /></strong></p>''
				cBody += '<p align="center"><span style="color: #ff0000; font-family: Arial; font-size: x-large;">'
				cBody += '<strong> Inclusao da natureza: '+Alltrim(M->ED_CODIGO)+' - '+Alltrim(M->ED_DESCRIC)+'</strong></span></p>'
				EVMAIL(cTO,cCc,cBcc,cSubject,cBody)
            EndIf
            If oObjForm:GetOperation() == 4 // Equivale ao FIN010ALT
                If !cUsername$cUsers//'frferreira/tborges/vviveiros/emaimone/tmoraes'
                    xRet := .T.
                	cTo := 'tax@t4f.com.br'
              		cCc :='cadastros@t4f.com.br'
                    cBcc := ''
                    cSubject := 'ALTERACAO DA NATUREZA: '+M->ED_CODIGO
                    cBody :='<p>&nbsp;</p>'
					cBody += '<p><strong> <img src="https://ncdn0.infojobs.com.br/logos/Company_Evaluation/59837.jpg"'
					cBody += 'width="190" height="64" align="left" border="0" /></strong></p>''
					cBody += '<p align="center"><span style="color: #ff0000; font-family: Arial; font-size: x-large;">'
					cBody += '<strong> Altera&ccedil;&atilde;o da natureza: '+Alltrim(M->ED_CODIGO)+' - '+Alltrim(M->ED_DESCRIC)+'</strong></span></p>'
                    EVMAIL(cTO,cCc,cBcc,cSubject,cBody)
                    Reclock('SED',.F.)
                    SED->ED_MSBLQL := '1'
                    MsUnlock()
                EndIf
            EndIf
        EndIf   
    EndIf
Return xRet

Static function EVMAIL(cTO,cCc,cBcc,cSubject,cBody)

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
