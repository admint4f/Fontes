#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NotifyAdm ºAutor  ³Microsiga           º Data ³  08/15/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Utilizado para enviar qualquer notificacao ao administrador º±±
±±º          ³do Siga.     												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Notifica(cEmail, cSubject, cMsgcompl)
 	Local lOk := .T.

	cMsg := '<html>'
	cMsg += '<head>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<div style="color: rgb(0, 0, 153);"><big><span'
	cMsg += ' class="610203920-12022004"><img alt="logo" src= "'+Alltrim(GetMV("MV_WFDHTTP"))+'/html/CIP_LOGO.JPG"</span><font face="Verdana"'
	cMsg += ' size="2"><big><strong><small><br>'
	cMsg += '<br>'
	cMsg += '</small><span style="color: rgb(255, 0, 0);">Workflow</span>'
	cMsg += '- Servi&ccedil;o Envio de Mensagens<br>'
	cMsg += '</strong></big></font></span></big></div>'
	cMsg += '<hr>'
	cMsg += '<div><font color="#000080" face="Verdana"'
	cMsg += ' size="3"><span class="216593018-10022004"><br>'
	cMsg += cMsgcompl
	cMsg += '<hr>'
	cMsg += '</body>'
	cMsg += '</html>'

	CONNECT SMTP SERVER GetMV("MV_WFSMTP") ACCOUNT GetMV("MV_WFACC") PASSWORD GetMV("MV_WFPASSW") RESULT lOk

	If lOk
		SEND MAIL FROM GetMV("MV_WFACC") ;
		TO cEmail ;
		SUBJECT cSubject ;
		BODY cMsg ;
		RESULT lOk

		If !lOk
			GET MAIL ERROR cError
			Help("",1,"Atencao",,cError + " " + cError ,4,5)
		Endif
	Else 
		MsgAlert("Nao foi possivel conexao com servidor de e-mail, verifique os parametros MV_WFSMTP, MV_WFPASSW e MV_MV_WFACC")
	Endif				
	Return lOk

USER FUNCTION NotifyAdm(cTitle, aMsg, aFiles )
RETURN U_MailNotify( , cTitle, aMsg, aFiles )

USER FUNCTION MailNotify(cTo, cTitle, aMsg, aFiles )
Local cBody, nInd

	cBody := '<html>'
	cBody += '<head>'
	cBody += '</head>'
	cBody += '<body>'
   	cBody += '<br>'
	cBody += '<div><font color="#000080" face="Verdana"'
	cBody += ' size="3"><span class="216593018-10022004"></SPAN></FONT></DIV><br>'
	DEFAULT aMsg:=Array(0)
	For nInd := 1 TO Len(aMsg)
		cBody += '<DIV><FONT face=Verdana color=#000080 size=3><SPAN class=216593018-10022004>' + aMsg[nInd] + '</SPAN></FONT></DIV><p>'
	Next
	cBody += '<p></p>'
	cBody += '<FONT face=Arial size=1>Workflow - Servi&ccedil;o Envio de Mensagens</FONT><br>'
	cBody += '</body>'
	cBody += '</html>'

	DEFAULT aFiles:=Array(0)
	
	RETURN WFNotifyAdmin( cTo , cTitle, cBody, aFiles )
	

//---------------- RETORNO E ENVIO

User Function Ret
	U_REC({'01'})

User Function Snd
	U_SEND({'01'})

//------------------------------------------------------------------------
// ENVIO DE EMAIL
//------------------------------------------------------------------------

USER FUNCTION SEND(aParam)
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => SENDMAIL(cEmp)" )
		RETURN
	EndIf
	
	U_CONSOLE('SENDMAIL() /' + aParam[1] )
	
	WFSENDMAIL({aParam[1],"01"})
	RETURN

//------------------------------------------------------------------------
// RETORNO DO WORKFLOW
//------------------------------------------------------------------------

USER FUNCTION REC( aParam )
	IF aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => RECMAIL()")
		RETURN
	EndIf

	PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL "01"
	
	U_CONSOLE('RECMAIL() /' + aParam[1] )
	
	IF ! U_SMTPConnect()
		U_CONSOLE("Nao foi possivel conexao SMTP" )
		RETURN
	ENDIF
	
	RESET ENVIRONMENT
	
	WFReturn({aParam[1],"01"})
	RETURN

//------------------------------------------------------------------------
// SEMAFORO
//------------------------------------------------------------------------
                    
USER FUNCTION SEMAFORO(Params)
Local nHdl 	:= 0                  
Local cFile := ""

    IF Params == Nil .OR. ! ValType(Params) $ "N|C" 
    	U_CONSOLE("SEMAFORO - Parametro invalido")
    	RETURN
    ENDIF            

	IF VALTYPE(Params) == "C"	// Quando for caracter - fecha o semaforo
		cFile := TRIM(Params) + ".LCK"
		       
		IF !FILE(cFile)
			nHdl:=MSFCREATE(cFile,0)
			fClose(nHdl)
		ENDIF
			
		While .T.
			nHdl := FOPEN(cFile , 16)
			IF nHdl > 0
			   	EXIT
			ENDIF			    
		    
			SLEEP(5000)
		END
	ENDIF
	
	IF VALTYPE(Params) == "N"	// Quando for numerico - abre o semaforo
		fClose(Params)
	ENDIF
	
	RETURN IIF(nHdl <> 0, nHdl, Nil)

*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetTimeOut                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
*/
User function GetTimeOut(nTimeOut,dData, cHora)
Local cQuery := ""
                  
IF dData == Nil
	dData	:= MSDATE()
ENDIF
IF cHora == Nil
	cHora	:= TIME()
ENDIF
IF nTimeOut == Nil
	nTimeOut:= 24
ENDIF

cHoraI 	:= GetNewPar("MV_WFHORAI","00:00")  //08:00
cHoraF  := GetNewPar("MV_WFHORAF","24:00")  //18:00

nHora	:= Val(Left(cHora,2))  + Val(Substr(cHora,4,2))/60
nHoraI  := Val(Left(cHoraI,2)) + Val(Substr(cHoraI,4,2))/60
nHoraF  := Val(Left(cHoraF,2)) + Val(Substr(cHoraF,4,2))/60

IF nHora<=nHoraI  
	nHora	:= nHoraI 
ENDIF                
  
dDtVld := dData
While .T.
	IF (nHora + nTimeOut) <= nHoraF
		nHora	:= nHora + nTimeOut
		EXIT
	ENDIF
	nTimeOut	:= nTimeOut - (nHoraF - nHora)
	nHora		:= nHoraI

	dDtVld		:= dDtVld + 1     
	dDtVld		:= DataValida(dDtVld,.T.)
END

return {dData,cHora,dDtVld, ALLTRIM(STRZERO(int(nHora),2)) + ":" + ALLTRIM(STRZERO((nHora - Int(nHora)) * 60,2))}


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MAAlcDoc Autor ³ Aline Correa do Vale   ³  Data ³07.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controla a alcada dos documentos (SCS-Saldos/SCR-Bloqueios)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MAAlcDoc(ExpA1,ExpD1,ExpN1,ExpC1)                     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com informacoes do documento                 ³±±
±±³          ³       [1] Numero do documento                              ³±±
±±³          ³       [2] Tipo de Documento                                ³±±
±±³          ³       [3] Valor do Documento                               ³±±
±±³          ³       [4] Codigo do Aprovador                              ³±±
±±³          ³       [5] Codigo do Usuario                                ³±±
±±³          ³       [6] Grupo do Aprovador                               ³±±
±±³          ³       [7] Aprovador Superior                               ³±±
±±³          ³       [8] Moeda do Documento                               ³±±
±±³          ³       [9] Taxa da Moeda                                    ³±±
±±³          ³      [10] Data de Emissao do Documento                     ³±±
±±³          ³      [11] Grupo de Compras                                 ³±±
±±³          ³ ExpD1 = Data de referencia para o saldo                    ³±±
±±³          ³ ExpN1 = Operacao a ser executada                           ³±±
±±³          ³       1 = Inclusao do documento                            ³±±
±±³          ³       2 = Estorno do documento                             ³±±
±±³          ³       3 = Exclusao do documento                            ³±±
±±³          ³       4 = Aprovacao do documento                           ³±±
±±³          ³       5 = Estorno da Aprovacao                             ³±±
±±³          ³       6 = Bloqueio Manual da Aprovacao                     ³±±
±±³          ³ ExpC1 = Respondido a 1 Vez ou a 2						  		  ³±±
±±³          ³ ExpB1 = Chamado via Menu do Sistema .T. or .F.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MAAlcDoc(aDocto,dDataRef,nOper, lTimeOut)
	Local cDocto	:= aDocto[1]
	Local cTipoDoc	:= aDocto[2]
	Local nValDcto	:= aDocto[3]
	Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
	Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
	Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
	Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
	Local aArea		:= GetArea()
	Local aAreaSCS  := SCS->(GetArea())
	Local aAreaSCR  := SCR->(GetArea())
	Local nSaldo	:= 0
	Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
	Local lFirstNiv:= .T.
	Local cAuxNivel:= ""
	Local cNextNiv := ""
	Local lAchou	:= .F.
	Local nRec		:= 0
	Local lRetorno	:= .T.
	Local aSaldo	:= {}
	Local nAprov	:= 0
	Local aAprov	:= {}
	
	Local cSAKFilial
	Local cSALFilial
	Local cSCRFilial   
	Local cSCSFilial
	
	dDataRef 	:= dDataBase
	cDocto 		:= cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
	lTimeOut	:= IF(lTimeOut==Nil, .F. , lTimeOut)

	CHKFile("SAK")
	CHKFile("SC7")
	CHKFile("SCR")
	CHKFile("SCS")
	CHKFile("SAL")
	
	cSAKFilial:=xFilial("SAK")
	cSALFilial:=xFilial("SAL")
	cSCRFilial:=xFilial("SCR")
	cSCSFilial:=xFilial("SCS")
			
	If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
		SAK->(dbSetOrder(1))
		SAK->(dbSeek(cSAKFilial+cAprov))
		cUsuario:=SAK->AK_USER
		nMoeDcto:=SAK->AK_MOEDA
		nTxMoeda:=0
	EndIf
	If nOper==1  //Inclusao do Documento
		cGrupo:=If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		SAL->(dbSetOrder(2))
		If !Empty(cGrupo) .And. SAL->(dbSeek(cSALFilial+cGrupo))
			While SAL->(!Eof().And.cSALFilial+cGrupo==AL_FILIAL+AL_COD)
	  		 	If SAL->(AL_AUTOLIM=="S".And.!MaAlcLim(AL_APROV,nValDcto,nMoeDcto,nTxMoeda).AND.!EMPTY(cWF))
					SAL->(dbSkip())
					Loop
				EndIf
				If lFirstNiv
					cAuxNivel:=SAL->AL_NIVEL
					lFirstNiv:=.F.
				EndIf
				IF SCR->(Reclock("SCR",.T.))
					SCR->CR_FILIAL	:= cSCRFilial
					SCR->CR_NUM		:= cDocto
					SCR->CR_TIPO	:= cTipoDoc
					SCR->CR_NIVEL	:= SAL->AL_NIVEL
					SCR->CR_USER	:= SAL->AL_USER
					SCR->CR_APROV	:= SAL->AL_APROV
					SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL==cAuxNivel,"02","01")
					SCR->CR_TOTAL	:= nValDcto
					SCR->CR_EMISSAO := aDocto[10]
			   		SCR->CR_MOEDA	:=	nMoeDcto
			    	SCR->CR_TXMOEDA := nTxMoeda
					SCR->(MsUnlock())
				EndIF
				SAL->(dbSkip())
			EndDo
		EndIf
		lRetorno:=lFirstNiv
	EndIf
	
	If nOper == 3  //exclusao do documento
		SAK->(dbSetOrder(1))
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(cSCRFilial+cTipoDoc+cDocto))
		While SCR->(!Eof().And.CR_FILIAL+CR_TIPO+CR_NUM==cSCRFilial+cTipoDoc+cDocto)
			If SCR->CR_STATUS=="03"
				SAL->(dbSetOrder(3))
				SAL->(dbSeek(cSALFilial+cGrupo+SAK->AK_COD))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SAK->(dbSeek(cSAKFilial+SCR->CR_LIBAPRO))
				If SAL->(AL_LIBAPR=="A".and.MaAlcLim(AL_APROV,nValDcto,nMoeDcto,nTxMoeda))
					SCS->(dbSetOrder(2))
					If SCS->(dbSeek(cSCSFilial+SAK->AK_COD+DTOS(MaAlcDtRef(SCR->CR_LIBAPRO,SCR->CR_DATALIB,SCR->CR_TIPOLIM))))
						if RecLock("SCS",.F.)
							SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
							SCS->(MsUnlock())
						endif
					EndIf
				EndIf
			EndIf
			if SCR->(Reclock("SCR",.F.,.T.))
				SCR->(dbDelete())
				SCR->(MsUnlock())
			endif
			SCR->(dbSkip())
		EndDo
	EndIf
	
	If nOper == 4 //Aprovacao do documento

		U_CONSOLE(" 4 -Aprovacao ")

		SCS->(dbSetOrder(2))
		aSaldo:=MaSalAlc(cAprov,dDataRef,.T.)
		nSaldo:=aSaldo[1]
		dDataRef:=aSaldo[3]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o saldo do aprovador.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		u_console("c A p r o v : "+cAprov)

		SAK->(dbSetOrder(1))
		SAK->(dbSeek(cSAKFilial+cAprov))
		SAL->(dbSetOrder(3))
		SAL->(dbSeek(cSALFilial+cGrupo+cAprov))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Libera o pedido pelo aprovador.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAuxNivel:=SCR->CR_NIVEL
		U_CONSOLE(" 4 -Aprovacao - CR STATUS = 03")
		if SCR->(Reclock("SCR",.F.))
			SCR->CR_STATUS:="03"
			SCR->CR_DATALIB:=dDataBase
			SCR->CR_USERLIB:=SAK->AK_USER
			SCR->CR_LIBAPRO:=SAK->AK_COD
			SCR->CR_VALLIB:=nValDcto
			SCR->CR_TIPOLIM:=SAK->AK_TIPO
			SCR->(MsUnlock())
		endif
		
		U_CONSOLE("nValDcto  - "+Alltrim(Str(nValDcto)))
		
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(cSCRFilial+cTipoDoc+cDocto+cAuxNivel))
		nRec := SCR->(RecNo())
		
		While SCR->(!Eof().And.cSCRFilial+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO)
			If SCR->(cAuxNivel==CR_NIVEL .And. CR_STATUS!="03" .And. SAL->AL_TPLIBER$"U ")
				Exit
			EndIf
			If SCR->(cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP")
				if SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS:="05"
					SCR->CR_DATALIB:=dDataBase
					SCR->CR_USERLIB:=SAK->AK_USER
					SCR->CR_LIBAPRO:=SAK->AK_COD
					SCR->CR_VALLIB:=nValDcto
					SCR->CR_TIPOLIM:=SAK->AK_TIPO
					SCR->CR_OBS:="aprovado por "+UsrRetName(SAK->AK_USER)
					SCR->(MsUnlock())
				endif
			EndIf		
			If SCR->(CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou)
				lAchou:=.T.
				cNextNiv:=SCR->CR_NIVEL
			EndIf
			If SCR->(lAchou.And.CR_NIVEL==cNextNiv.And.!(CR_STATUS$"03|05"))
				if SCR->(Reclock("SCR",.F.))
					IF (SAL->AL_TPLIBER=="P".AND.!lTimeOut)
						SCR->CR_STATUS:="05"
						SCR->CR_DATALIB:=dDataBase
						SCR->CR_USERLIB:=SAK->AK_USER
						SCR->CR_LIBAPRO:=SAK->AK_COD
						SCR->CR_VALLIB:=nValDcto
						SCR->CR_TIPOLIM:=SAK->AK_TIPO
						SCR->CR_OBS:="aprovado por "+UsrRetName(SAK->AK_USER)
					ENDIF			
					SCR->(MsUnlock())
				Endif
			endif
			SCR->(dbSkip())
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reposiciona e verifica se ja esta totalmente liberado.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    
		SCR->(dbGoto(nRec))
		While SCR->(!Eof() .And. cSCRFilial+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM)
			If SCR->(CR_STATUS != "03" .And. CR_STATUS != "05" )
				lRetorno := .F.
				exit
			EndIf
			SCR->(dbSkip())
		EndDo

		If SAL->(AL_LIBAPR=="A".and.MaAlcLim(AL_APROV,nValDcto,nMoeDcto,nTxMoeda).and.nAprov>=2)
			If SCS->(dbSeek(cSCSFilial+cAprov+dToS(dDataRef)))
				SCS->(Reclock("SCS",.F.))
			Else
				SCS->(Reclock("SCS",.T.))
			EndIf
			SCS->CS_FILIAL:=cSCSFilial
			SCS->CS_SALDO:=SCS->CS_SALDO-nValDcto
			SCS->CS_APROV:=cAprov
			SCS->CS_MOEDA:=nMoeDcto
			SCS->CS_DATA:=dDataRef
			SCS->(MsUnlock())
			                       
			// LIBERA OS NIVEIS SUPERIORES QUANDO FOR APROVADO COM ALÇADAS
			SCR->(dbGoto(nRec))
			U_Console("nRec "+Alltrim(Str(nRec)))
			While SCR->(!Eof() .And. cSCRFilial+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM)
				U_Console("SCR->CR_USER "+SCR->CR_USER)
				U_Console("SAK->AK_USER "+SAK->AK_USER)
				U_CONSOLE("Reposiciona e verifica aAprov(len): "+Alltrim(Str(len(aAprov))))
				IF (SCR->CR_USER<>SAK->AK_USER)  // ADICIONADO ESTA LINHA
					if SCR->(RECLOCK("SCR",.F.))
						SCR->CR_STATUS:="05"
						SCR->CR_DATALIB:=dDataBase
						SCR->CR_USERLIB:=SAK->AK_USER
						SCR->CR_LIBAPRO:=SAK->AK_COD
						SCR->CR_VALLIB:=nValDcto
						SCR->CR_TIPOLIM:=SAK->AK_TIPO
						SCR->CR_OBS:="aprovado por "+UsrRetName(SAK->AK_USER)
						SCR->(MsUnlock())
					endif
				ENDIF
				SCR->(dbSkip())
			EndDo			
			lRetorno := .T.	// LIBERA APROVACAO POIS O APROVADOR TEM SALDO PARA ISSO
		EndIf
	EndIf
	
	If nOper == 5  //Estorno da Aprovacao
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)

		SAK->(dbSetOrder(1))
		SCR->(dbSetOrder(1))

		SCR->(dbSeek(cSCRFilial+cTipoDoc+cDocto))
		
		nMoeDcto := SCR->CR_MOEDA
		nTxMoeda := SCR->CR_TXMOEDA
		
		While SCR->(!Eof() .And. CR_FILIAL+CR_TIPO+CR_NUM == cSCRFilial+cTipoDoc+cDocto)
			If SCR->CR_STATUS == "03"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SAK->(dbSeek(cSAKFilial+SCR->CR_LIBAPRO))
				SAL->(dbSetOrder(3))
				SAL->(dbSeek(cSALFilial+cGrupo+SAK->AK_COD))
				If SAL->(AL_LIBAPR == "A" .and. MaAlcLim(AL_APROV,nValDcto,nMoeDcto,nTxMoeda) )
					SCS->(dbSetOrder(2))
					If SCS->(dbSeek(cSCSFilial+SAK->AK_COD+DTOS(MaAlcDtRef(SAK->AK_COD,SCR->CR_DATALIB))))
						IF SCS->(RecLock("SCS",.F.))
							SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
							If SCS->CS_SALDO > SAK->AK_LIMITE
								SCS->CS_SALDO := SAK->AK_LIMITE
							EndIf
							SCS->(MsUnlock())
						ENDIF
					EndIf
				EndIf
			EndIf
			IF SCR->(Reclock("SCR",.F.,.T.))
				SCR->(dbDelete())
				SCR->(MsUnlock())
			EndIF
			SCR->(dbSkip())
		EndDo
	
		SAL->(dbSetOrder(2))
		If SAL->(!Empty(cGrupo) .And. dbSeek(cSALFilial+cGrupo))
			While SAL->(!Eof() .And. cSALFilial+cGrupo == AL_FILIAL+AL_COD)
				If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda) 
					SAL->(dbSkip())
					Loop
				EndIf
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				IF SCR->(Reclock("SCR",.T.))
					SCR->CR_FILIAL:=cSCRFilial
					SCR->CR_NUM:=cDocto
					SCR->CR_TIPO:=cTipoDoc
					SCR->CR_NIVEL:=SAL->AL_NIVEL
					SCR->CR_USER:=SAL->AL_USER
					SCR->CR_APROV:=SAL->AL_APROV
					SCR->CR_STATUS:=IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
					SCR->CR_TOTAL:=nValDcto
					SCR->CR_EMISSAO:=dDataRef
				   	SCR->CR_MOEDA:=nMoeDcto
			    	SCR->CR_TXMOEDA:=nTxMoeda
					SCR->(MsUnlock())
				EndIF
				SAL->(dbSkip())
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 6  //Bloqueio manual

		U_CONSOLE("  6  - Bloqueio por " + cAprov)

		SAK->(dbSetOrder(1))
		SAK->(dbSeek(cSAKFilial+cAprov))
			
		cAuxNivel := SCR->CR_NIVEL
		
		IF SCR->(Reclock("SCR",.F.))
			SCR->CR_STATUS:="04"
			SCR->CR_OBS:=If(Len(aDocto)>10,aDocto[11],"Reprovaçao manual")
			SCR->CR_DATALIB:=dDataBase
			SCR->CR_USERLIB:=SAK->AK_USER
			SCR->CR_LIBAPRO:=SAK->AK_COD
			SCR->(MsUnlock())
		ENDIF
			
		cNome:=UsrRetName(SAK->AK_USER)
		cNome:=ALLTRIM(cNome)
				
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(cSCRFilial+cTipoDoc+cDocto+cAuxNivel))
		      
		nRec := SCR->(RecNo())
		While SCR->(!Eof() .And. cSCRFilial+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO)
		    SCR->(U_CONSOLE(" 6 - Bloqueio - LOOP SCR " + CR_FILIAL+CR_NUM+CR_TIPO+CR_NIVEL+CR_STATUS ))
		    
			If SCR->(CR_NIVEL==cAuxNivel .And. CR_STATUS != "04" ) 
				IF SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS	:= "04"
					SCR->CR_DATALIB:=dDataBase
					SCR->CR_USERLIB:=SAK->AK_USER
					SCR->CR_LIBAPRO:=SAK->AK_COD
					SCR->CR_OBS		:= "reprovado por "+cNome
					SCR->(MsUnlock())
				EndIF
			EndIf
			SCR->(dbSkip())
		EndDo
		lRetorno := .F.
	EndIf
	
	SCR->(RestArea(aAreaSCR))
	SCS->(RestArea(aAreaSCS))
	
	RestArea(aArea) 
	
	Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SCAlcDoc Autor ³ Aline Correa do Vale   ³  Data ³07.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controla a alcada dos documentos (SCS-Saldos/SCR-Bloqueios)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SCAlcDoc(ExpA1,ExpD1,ExpN1,ExpC1)                     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com informacoes do documento                 ³±±
±±³          ³       [1] Numero do documento                              ³±±
±±³          ³       [2] Tipo de Documento                                ³±±
±±³          ³       [3] Valor do Documento                               ³±±
±±³          ³       [4] Codigo do Aprovador                              ³±±
±±³          ³       [5] Codigo do Usuario                                ³±±
±±³          ³       [6] Grupo do Aprovador                               ³±±
±±³          ³       [7] Aprovador Superior                               ³±±
±±³          ³       [8] Moeda do Documento                               ³±±
±±³          ³       [9] Taxa da Moeda                                    ³±±
±±³          ³      [10] Data de Emissao do Documento                     ³±±
±±³          ³      [11] Grupo de Compras                                 ³±±
±±³          ³ ExpD1 = Data de referencia para o saldo                    ³±±
±±³          ³ ExpN1 = Operacao a ser executada                           ³±±
±±³          ³       1 = Inclusao do documento                            ³±±
±±³          ³       2 = Estorno do documento                             ³±±
±±³          ³       3 = Exclusao do documento                            ³±±
±±³          ³       4 = Aprovacao do documento                           ³±±
±±³          ³       5 = Estorno da Aprovacao                             ³±±
±±³          ³       6 = Bloqueio Manual da Aprovacao                     ³±±
±±³          ³ ExpC1 = Observacao                						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SCAlcDoc(cFilSCR,aDocto,dDataRef,nOper, lTimeOut, cObs)
	
	Local cDocto	:= aDocto[1]
	Local cTipoDoc	:= aDocto[2]    
	Local nValDcto	:= aDocto[3]
	Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
	Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
	Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
	Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
	Local aArea		:= GetArea()
	Local aAreaSCS  := SCS->(GetArea())
	Local aAreaSCR  := SCR->(GetArea())
	Local nSaldo	:= 0
	Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
	Local lFirstNiv:= .T.
	Local cAuxNivel:= ""
	Local cNextNiv := ""
	Local lAchou	:= .F.
	Local nRec		:= 0
	Local lRetorno	:= .T.
	Local aSaldo	:= {}

	Local cSAKFilial
	Local cSALFilial
	Local cSC1Filial
	Local cSC7Filial
	Local cSCRFilial   
	Local cSCSFilial

	CHKFile("SAK")
	CHKFile("SC7")
	CHKFile("SC1")
	CHKFile("SCR")
	CHKFile("SCS")
	CHKFile("SAL")

	cSAKFilial:=xFilial("SAK")
	cSALFilial:=xFilial("SAL")
	cSC1Filial:=xFilial("SC1")
	cSC7Filial:=xFilial("SC7")
	cSCRFilial:=xFilial("SCR")
	cSCSFilial:=xFilial("SCS")

	dDataRef:=dDataBase
	cDocto:=cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
	lTimeOut:= IF(lTimeOut==Nil, .F. , lTimeOut)

	If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
		SAK->(dbSetOrder(1))
		SAK->(dbSeek(cSAKFilial+cAprov))
		cUsuario:=SAK->AK_USER
		nMoeDcto:=SAK->AK_MOEDA
		nTxMoeda:=0
	EndIf
	If nOper == 1  //Inclusao do Documento
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		SAL->(dbSetOrder(2))
		If SAL->(!Empty(cGrupo) .And. dbSeek(cSALFilial+cGrupo))
			While SAL->(!Eof() .And. cSALFilial+cGrupo == AL_FILIAL+AL_COD)
	  		 	If SAL->(AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda))
					SAL->(dbSkip())
					Loop
				EndIf
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				IF Reclock("SCR",.T.)
					SCR->CR_FILIAL:=cSCRFilial
					SCR->CR_NUM:=cDocto
					SCR->CR_TIPO:=cTipoDoc
					SCR->CR_NIVEL:=SAL->AL_NIVEL
					SCR->CR_USER:=SAL->AL_USER
					SCR->CR_APROV:=SAL->AL_APROV
					SCR->CR_STATUS:=IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
					SCR->CR_TOTAL:=nValDcto
					SCR->CR_EMISSAO:=aDocto[10]
			   		SCR->CR_MOEDA:=nMoeDcto
			    	SCR->CR_TXMOEDA:=nTxMoeda
					SCR->(MsUnlock())
				ENDIF
				SAL->(dbSkip())
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 3  //exclusao do documento

		SAK->(dbSetOrder(1))

		SCR->(dbSetOrder(1))
		SCR->(dbSeek(cSCRFilial+cTipoDoc+cDocto))
		While SCR->(!Eof() .And. CR_FILIAL+CR_TIPO+CR_NUM == cSCRFilial+cTipoDoc+cDocto)
			If SCR->CR_STATUS == "03"
				SAL->(dbSetOrder(3))
				SAL->(dbSeek(cSALFilial+cGrupo+SAK->AK_COD))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SAK->(dbSeek(cSAKFilial+SCR->CR_LIBAPRO))
				If SAL->(AL_LIBAPR == "A" .and. MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda))
					SCS->(dbSetOrder(2))
					If SCS->(dbSeek(cSCSFilial+SAK->AK_COD+DTOS(MaAlcDtRef(SCR->CR_LIBAPRO,SCR->CR_DATALIB,SCR->CR_TIPOLIM))))
						if SCS->(RecLock("SCS",.F.))
							SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
							SCS->(MsUnlock())
						endif
					EndIf
				EndIf
			EndIf
			if SCR->(Reclock("SCR",.F.,.T.))
				SCR->(dbDelete())
				SCR->(MsUnlock())
			endif
			SCR->(dbSkip())
		EndDo
	EndIf
	
	If nOper == 4 //Aprovacao do documento

		U_CONSOLE(" 4 -Aprovacao ")
		
		SCS->(dbSetOrder(2))
		aSaldo 		:= MaSalAlc(cAprov,dDataRef,.T.)
		nSaldo 		:= aSaldo[1]
		dDataRef	:= aSaldo[3]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o saldo do aprovador.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SAK->(dbSetOrder(1))
		SAK->(dbSeek(cSAKFilial+cAprov))
		SAL->(dbSetOrder(3))
		SAL->(dbSeek(cSALFilial+cGrupo+cAprov))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Libera o pedido pelo aprovador.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAuxNivel := SCR->CR_NIVEL
		if SCR->(Reclock("SCR",.F.))
			SCR->CR_STATUS	:= "03"
			SCR->CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
			SCR->CR_DATALIB	:= dDataBase
			SCR->CR_USERLIB	:= SAK->AK_USER
			SCR->CR_LIBAPRO	:= SAK->AK_COD
			SCR->CR_VALLIB	:= nValDcto
			SCR->CR_TIPOLIM	:= SAK->AK_TIPO
			SCR->CR_DTLIMIT  := CTOD("  /  /  ")
			SCR->CR_HRLIMIT  := "     "
	    	SCR->CR_OBS := cObs
			SCR->(MsUnlock())
		endif		
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(cFilSCR+cTipoDoc+cDocto+cAuxNivel))
		nRec := SCR->(RecNo())
		While SCR->(!Eof() .And. cFilSCR+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO)
			If SCR->(cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"U ")
				Exit
			EndIf
			If SCR->(cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP")
				if SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS:="05"
					SCR->CR_DATALIB:=dDataBase
					SCR->CR_USERLIB:=SAK->AK_USER
					SCR->CR_LIBAPRO:=SAK->AK_COD
					SCR->CR_VALLIB:=nValDcto
					SCR->CR_TIPOLIM:=SAK->AK_TIPO
					SCR->CR_DTLIMIT:=CTOD("  /  /  ")
					SCR->CR_HRLIMIT:= "     "
					SCR->CR_OBS:="aprovado por "+UsrRetName(SAK->AK_USER)
					SCR->(MsUnlock())
				endif
			EndIf
			If SCR->(CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou)
				lAchou 	:= .T.
				cNextNiv := SCR->CR_NIVEL
			EndIf
			If SCR->(lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03")
				if SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS:="02"
					IF (SAL->AL_TPLIBER=="P" .AND. !lTimeOut )
						SCR->CR_STATUS:="05"
						SCR->CR_DATALIB:=dDataBase
						SCR->CR_USERLIB:=SAK->AK_USER
						SCR->CR_LIBAPRO:=SAK->AK_COD
						SCR->CR_VALLIB:=nValDcto
						SCR->CR_TIPOLIM:=SAK->AK_TIPO
						SCR->CR_DTLIMIT:=CTOD("  /  /  ")
						SCR->CR_HRLIMIT:= "     "
						SCR->CR_OBS:="aprovado por "+UsrRetName(SAK->AK_USER)
						SCR->(MsUnlock())
					ENDIF			
					SCR->(MsUnlock())
				Endif
			Endif
			SCR->(dbSkip())
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reposiciona e verifica se ja esta totalmente liberado.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		lRetorno := .T.
		SCR->(dbGoto(nRec))
		While SCR->(!Eof() .And. cFilSCR+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM)
			If SCR->(CR_STATUS != "03" .And. CR_STATUS != "05" )
				lRetorno := .F.
				Exit
			EndIf
			SCR->(dbSkip())
		EndDo

		If SAL->(AL_LIBAPR == "A" .and. MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda))
			If SCS->(dbSeek(cSCSFilial+cAprov+dToS(dDataRef)))
				Reclock("SCS",.F.)
			Else
				Reclock("SCS",.T.)
			EndIf
			SCS->CS_FILIAL:=cSCSFilial
			SCS->CS_SALDO:=SCS->CS_SALDO-nValDcto
			SCS->CS_APROV:=cAprov
			SCS->CS_USER:=cUsuario
			SCS->CS_MOEDA:=nMoeDcto
			SCS->CS_DATA:=dDataRef
			SCS->(MsUnlock())
			                       
			// LIBERA OS NIVEIS SUPERIORES QUANDO FOR APROVADO COM ALÇADAS
			SCR->(dbGoto(nRec))
			While SCR->(!Eof() .And. cFilSCR+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM)
				IF SCR->CR_USER <> SAK->AK_USER  // ADICIONADO ESTA LINHA
					if SCR->(RECLOCK("SCR",.F.))
						SCR->CR_STATUS:="05"
						SCR->CR_DATALIB:=dDataBase
						SCR->CR_USERLIB:=SAK->AK_USER
						SCR->CR_LIBAPRO:=SAK->AK_COD
						SCR->CR_VALLIB:=nValDcto
						SCR->CR_TIPOLIM:=SAK->AK_TIPO
						SCR->CR_DTLIMIT:=CTOD("  /  /  ")
						SCR->CR_HRLIMIT:= "     "
						SCR->CR_OBS:="aprovado por "+UsrRetName(SAK->AK_USER)
						SCR->(MsUnlock())
					endif
				ENDIF
				SCR->(dbSkip())
			EndDo
			
			lRetorno := .T.	// LIBERA APROVACAO POIS O APROVADOR TEM SALDO PARA ISSO
		EndIf
	EndIf
	
	If nOper == 5  //Estorno da Aprovacao
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)

		SAK->(dbSetOrder(1))
		
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(cSCRFilial+cTipoDoc+cDocto))
		
		nMoeDcto := SCR->CR_MOEDA
		nTxMoeda := SCR->CR_TXMOEDA
		
		While SCR->(!Eof() .And. CR_FILIAL+CR_TIPO+CR_NUM == cSCRFilial+cTipoDoc+cDocto)
			If SCR->CR_STATUS == "03"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SAK->(dbSeek(cSAKFilial+SCR->CR_LIBAPRO))
				SAL->(dbSetOrder(3))
				SAL->(dbSeek(cSALFilial+cGrupo+SAK->AK_COD))
				If SAL->(AL_LIBAPR == "A" .and. MaAlcLim(AL_APROV,nValDcto,nMoeDcto,nTxMoeda))
					SCS->(dbSetOrder(2))
					If SCS->(dbSeek(cSCSFilial+SAK->AK_COD+DTOS(MaAlcDtRef(SAK->AK_COD,SCR->CR_DATALIB))))
						if RecLock("SCS",.F.)
							SCS->CS_SALDO:=SCS->CS_SALDO+SCR->CR_VALLIB
							If SCS->CS_SALDO>SAK->AK_LIMITE
								SCS->CS_SALDO:=SAK->AK_LIMITE
							EndIf
							SCS->(MsUnlock())
						endif
					EndIf
				EndIf
			EndIf
			if Reclock("SCR",.F.,.T.)
				SCR->(dbDelete())
				SCR->(MsUnlock())
			endif	
			SCR->(dbSkip())
		EndDo
	
		SAL->(dbSetOrder(2))
		If SAL->(!Empty(cGrupo) .And. dbSeek(cSALFilial+cGrupo))
			While SAL->(!Eof() .And. cSALFilial+cGrupo == AL_FILIAL+AL_COD)
				If SAL->(AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda))
					SAL->(dbSkip())
					Loop
				EndIf
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				if Reclock("SCR",.T.)
					SCR->CR_FILIAL	:= cSCRFilial
					SCR->CR_NUM		:= cDocto
					SCR->CR_TIPO	:= cTipoDoc
					SCR->CR_NIVEL	:= SAL->AL_NIVEL
					SCR->CR_USER	:= SAL->AL_USER
					SCR->CR_APROV	:= SAL->AL_APROV
					SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
					SCR->CR_TOTAL	:= nValDcto
					SCR->CR_EMISSAO:= dDataRef
				   	SCR->CR_MOEDA	:=	nMoeDcto
			    	SCR->CR_TXMOEDA:= nTxMoeda
					SCR->(MsUnlock())
				endif	
				SAL->(dbSkip())
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 6  //Bloqueio manual

		U_CONSOLE("  6  - Bloqueio por " + cAprov)

		SAK->(dbSetOrder(1))
		SAK->(dbSeek(cSAKFilial+cAprov))
			
		cAuxNivel := SCR->CR_NIVEL
		
		IF Reclock("SCR",.F.)
			SCR->CR_STATUS:="04"
			SCR->CR_OBS:=If(Len(aDocto)>10,aDocto[11],"Reprovaçao manual")
			SCR->CR_DATALIB:=dDataBase
			SCR->CR_USERLIB:=SAK->AK_USER
			SCR->CR_LIBAPRO:=SAK->AK_COD
			SCR->CR_DTLIMIT:=CTOD("  /  /  ")
			SCR->CR_HRLIMIT:="     "
			SCR->(MsUnlock())
		EndIF
			
		cNome:=UsrRetName(SAK->AK_USER)
				
		SCR->(dbSetOrder(1))
		SCR->(dbSeek(cSCRFilial+cTipoDoc+cDocto+cAuxNivel))
		      
		nRec := SCR->(RecNo())
		While SCR->(!Eof() .And. cSCRFilial+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO)
		    SCR->(U_CONSOLE(" 6 - Bloqueio - LOOP SCR " + CR_FILIAL+CR_NUM+CR_TIPO+CR_NIVEL+CR_STATUS ))
		    
			If SCR->(cAuxNivel == CR_NIVEL .And. CR_STATUS != "04")
				if SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS:="05"
					SCR->CR_DATALIB:=dDataBase
					SCR->CR_USERLIB:=SAK->AK_USER
					SCR->CR_LIBAPRO:=SAK->AK_COD
					SCR->CR_DTLIMIT:=CTOD("  /  /  ")
					SCR->CR_HRLIMIT:="     "
					SCR->CR_OBS:= "reprovado por "+cNome
					SCR->(MsUnlock())
				endif
			EndIf
			If SCR->(CR_NIVEL > cAuxNivel .And. CR_STATUS != "04" .And. !lAchou)
				lAchou 	:= .T.
				cNextNiv := SCR->CR_NIVEL
			EndIf
			If SCR->(lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "04")
				if SCR->(Reclock("SCR",.F.))
					SCR->CR_STATUS:="05"
					SCR->CR_DATALIB:=dDataBase
					SCR->CR_USERLIB:=SAK->AK_USER
					SCR->CR_LIBAPRO:=SAK->AK_COD
					SCR->CR_DTLIMIT:=CTOD("  /  /  ")
					SCR->CR_HRLIMIT:="     "
					SCR->CR_OBS:= "reprovado por "+cNome
					SCR->(MsUnlock())
				endif
			Endif
			SCR->(dbSkip())
		    
		EndDo
		
		lRetorno := .F.
	EndIf
	
	dbSelectArea("SCR")
	RestArea(aAreaSCR)

	dbSelectArea("SCS")
	RestArea(aAreaSCS)
	RestArea(aArea) 
	Return(lRetorno)


//---------------- TESTA SE HÁ CONEXAO COM O SERVIDOR SMTP

User Function SMTPConnect()
Local  lRet 	   := .F.
Local  lSmtpAuth   := GetMv("MV_RELAUTH",,.F.)
Static cMailConta  := NIL
Static cMailServer := NIL
Static cMailSenha  := NIL  
Static cMailCtaAut := NIL
Static lAvalMMail  := NIL
Static lAvalFiltr  := NIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Obtem dados necessarios a conexao                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMailConta  := If(cMailConta == NIL,GETMV("MV_WFACC"),cMailConta)
cMailServer := If(cMailServer== NIL,GETMV("MV_WFSMTP"),cMailServer)
cMailSenha  := If(cMailSenha == NIL,GETMV("MV_WFPASSW"),cMailSenha)
		
cMailCtaAut := If(cMailCtaAut == NIL,GETMV("MV_WFACC"),cMailCtaAut)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Caso nao exista conta definida, pega o proprio e-mail origem                       |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty( cMailCtaAut ) 
	cMailCtaAut := cMailConta
EndIf 		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia e-mail com os dados necessarios                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha) .And. !Empty(cMailCtaAut) 
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Conecta uma vez com o servidor de e-mails                                        |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CONNECT SMTP SERVER cMailServer ACCOUNT cMailCtaAut PASSWORD cMailSenha RESULT lOk

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Se configurado, efetua a autenticacao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( lSmtpAuth ) 
		lAutOk := MailAuth(cMailCtaAut,cMailSenha)
	Else
		lAutOk := .T.
	EndIf 
			
	If lOk .And. lAutOk 
		DISCONNECT SMTP SERVER
		lRet := .T.
	EndIf
EndIf
RETURN lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MONTA AS TABELAS NO BANCO A PARTIR DO ARQUIVO TEXTO CHKFILE.TXT
// INFORMAR O CONTEUDO DA SEGUINTE FORMA :
// SA1,SA2,SA3
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function Tab01()

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

cPath := AllTrim( GetSrvProfString( "StartPath","\" ) )
cPath += if( Right( cPath,1 ) == "\", "", "\" )
cParam1 := cPath + "chkfile.txt"

if !file( cParam1 )
	WFSaveFile( cParam1, "" )
end
if file( cParam1 )
	cTabela := AllTrim( WFLoadFile( cParam1 ) )
	cTabela := StrTran( cTabela, chr(13), "" )
	cTabela := StrTran( cTabela, chr(10), "" )
	aTabela   := WFTokenChar( cTabela, "," )
	for nInd := 1 to Len( aTabela )
		IF !Empty(aTabela[nInd])
			if chkfile(aTabela[nInd])
				DBSelectArea(aTabela[nInd])
				CONOUT(aTabela[nInd] + " Ok")
			endif
		ENDIF
	next
ENDIF
RETURN

User Function TST01()

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
      
cUser	:= PADR("JACKSON",15)
PswOrder(2)
lRet := PswSeek( cUser ) 
IF lRet     
	aRet := PswRet(1)
	if !Empty( aRet[1,14] )
		cMail := PadR( aRet[1,14], 255 )
		CONOUT(cMail)
	endif
ENDIF

RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONSOLE   ºAutor  ³Microsiga           º Data ³  Ago/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³
±±º          ³
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Console(_ctxt)
local _ctxt

if _ctxt == NIL
	_ctxt := 'nulo'
endif

CONOUT(_cTXT)

nHdl2:= FOPEN("conout.log",2)
IIF(nHdl2 > 0,,nHdl2:=MSFCREATE("conout.log",0))
fseek(nHdl2,0,2)

_cLogBody := ''
_cLogBody += DTOC(DATE()) +" @ "+ TIME() +" "+ _cTxt + chr(13) + chr(10)
Fwrite(nHdl2,_cLogBody,len(_cLogBody))

_cLogBody := replicate('-',80) + chr(13) + chr(10)
Fwrite(nHdl2,_cLogBody,len(_cLogBody))

FCLOSE(nHdl2)
Return

