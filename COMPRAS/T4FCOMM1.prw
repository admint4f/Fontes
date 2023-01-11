#include "totvs.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#xtranslate NToS([<n,...>])=>LTrim(Str([<n>]))

#DEFINE WF_ID			1
#DEFINE WF_DTLIMITE		2
#DEFINE WF_HRLIMITE		3
#DEFINE WF_DTVALIDA		4
#DEFINE WF_HRVALIDA		5
#DEFINE WF_HTMLFILE		6
#DEFINE WF_START		7

#DEFINE WF_MAX			7

//Chamada por empresa
User Function T4FCOMM(aParamEmp)

	Local _aEmp

	Local cEmp
	Local cFil
	
	Local cMsg 
	Local cFun
	
	Local cProcName

	Local c_svEmpAnt
	Local c_svFilAnt
	Local l_svEmpFil

	Local cNameLck
	Local lEmpLck
	Local lFilLck
	Local lMayIUseDisk
	
	Private _aEmprFil:={}
	Private _cPrefMsg:=""
	
	cProcName:=ProcName()
	cFun:=cProcName

    cMsg:='['+cProcName+']: T4F - T4FCOMM : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Fun: "+cFun
	OutMessage(cMsg)

	If aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U"
	
		cEmp:=aParamEmp[1]
		cFil:=aParamEmp[2]

	    cMsg:='['+cProcName+']: T4F - T4FCOMM : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
		OutMessage(cMsg)

		l_svEmpFil:=((Type("cEmpAnt")=="C").and.(Type("cFilAnt")=="C"))

		if (l_svEmpFil)
			c_svEmpAnt:=cEmpAnt
			cEmpAnt:=cEmp
			c_svFilAnt:=cFilAnt
			cFilAnt:=cFil
		endif

		RpcSetType(3)
		RpcSetEnv(cEmp,cFil)

		cNameLck:=ProcName()
		lEmpLck:=.T.
		lFilLck:=.T.
		lMayIUseDisk:=.T.

		IF (LockByName(@cNameLck,@lEmpLck,@lFilLck,@lMayIUseDisk))

		    cMsg:='['+cProcName+']: T4F - LockByName : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)
	
			U_CONSOLE("T4FCOMM - PC() / ["+cNameLck+"] Empresa["+cEmpAnt+"] | Filial["+cFilAnt+"] Iniciado com Sucesso")

		    cMsg:='['+cProcName+']: T4F - U__fWFPC(1) : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)
				U__fWFPC(1)	// 1 - ENVIO PC PARA APROVADORES
		    cMsg:='['+cProcName+']: T4F - U__fWFPC(1) : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

		    cMsg:='['+cProcName+']: T4F - U__fWFPC(3) : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)
				U__fWFPC(3)	// 3 - ENVIO PC ITENS APROVADOS PARA SOLICITANTE
		    cMsg:='['+cProcName+']: T4F - U__fWFPC(3) : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

		    cMsg:='['+cProcName+']: T4F - U__fWFPC(4) : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)
				U__fWFPC(4) // 4 - ENVIO PC ITENS REPROVADOS PARA SOLICITANTE
		    cMsg:='['+cProcName+']: T4F - U__fWFPC(4) : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

		    cMsg:='['+cProcName+']: T4F - U__fWFPC(5) : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)
				U__fWFPC(5)	// 5 - ENVIO DA NOTIFICAวรO POR TIMEOUT
		    cMsg:='['+cProcName+']: T4F - U__fWFPC(5) : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

			UnLockByName(@cNameLck,@lEmpLck,@lFilLck,@lMayIUseDisk)

		    cMsg:='['+cProcName+']: T4F - UnLockByName : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

		Else

			U_CONSOLE("T4FCOMM - PC() / ["+cNameLck+"] Empresa["+cEmpAnt+"] | Filial["+cFilAnt+"] Em Execu็ใo por outra Instancia")

		EndIF

		if (l_svEmpFil)
        	RpcSetEnv(c_svEmpAnt,c_svFilAnt)
		else
 			RpcClearEnv()
 		endif

	    cMsg:='['+cProcName+']: T4F - T4FCOMM : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
		OutMessage(cMsg)

	EndIf

Return(NIL)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFPC-PEDIDO DE COMPRAS                 บ Data ณ  15/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 1 - ENVIO DE EMAIL PARA APROVADORES                        บฑฑ
ฑฑบ          ณ 2 - RETORNO DE EMAIL COM RESPOSTA DE APROVADORES           บฑฑ
ฑฑบ          ณ 3 - ENVIA RESPOSTA DE PEDIDO APROVADO  PARA O COMPRADOR	  บฑฑ
ฑฑบ          ณ 4 - ENVIA RESPOSTA DE PEDIDO REPROVADO PARA O COMPRADOR	  บฑฑ
ฑฑบ          ณ 5 - ENVIO DE EMAIL - NOTIFICACAO DE TIME-OUT               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _fWFPC(_nOpc,oProcess,oProcesf)

	Local aMsg:={} 
	Local aWFReturn
	
	Local cMsg
	Local _cIndex,_cFiltro,_cOrdem
	Local _cFilial,_cOpcao,_cObs
	Local _lProcesso:=.F.
	Local _cPrefMsg:=""
	Local _cNumPed:=""
	Local _cFilPed:=""
	Local _lOkPed:=.T.

	Local cTMP:=GetNextAlias()
	Local cFilter:="1=1"
	Local cCRKeySeek
	Local cC7Filial:=xFilial("SC7")
	Local cCRFilial:=xFilial("SCR")

	Local cWFFilial
	
	Local cProcName:=ProcName()

	Local cCRDTLIMIT:=DTOS(MSDATE())
	Local cCRHRLIMIT:=LEFT(TIME(),5)

	Local cSVFilAnt:=cFilAnt

	Local nSCRRecNo

	Local dEDate:=CtoD('  /  /  ')

	Local nCRNum:=GetSX3Cache("CR_NUM","X3_TAMANHO")
	Local nC7Num:=GetSX3Cache("C7_NUM","X3_TAMANHO")
	Local nSC7RecNo
	Local nSA2RecNo

	Local lRet:=.T.
    
    Private aSC7RecNos:=Array(0)

    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
	OutMessage(cMsg)

	ChkFile("SE4")
	ChkFile("SC1")
	ChkFile("SC8")
	ChkFile("SA2")
	ChkFile("SB1")
	ChkFile("SBM")
	ChkFile("SCR")
	ChkFile("SC7")
	ChkFile("SAL")
	ChkFile("SCS")
	ChkFile("SAK")

	BEGIN SEQUENCE

		DO 	CASE

			/*
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ1 - Prepara os pedidos a serem enviados para aprovacaoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			*/
			CASE (_nOpc==1)

			    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
				OutMessage(cMsg)

				U_CONSOLE("T4FCOMM - 1 - Prepara os pedidos a serem enviados para aprovacao")
				U_CONSOLE("T4FCOMM - 1 - EmpFil:"+cEmpAnt+cFilAnt)

			  	_cQuery := "SELECT"
			  	_cQuery += "	SCR.CR_FILIAL"
			  	_cQuery += " 	,SCR.CR_TIPO"
			  	_cQuery += " 	,SCR.CR_NUM"
			  	_cQuery += " 	,SCR.CR_NIVEL"
			  	_cQuery += " 	,SCR.CR_TOTAL"
			  	_cQuery += " 	,SCR.CR_USER"
			  	_cQuery += " 	,SCR.CR_APROV"
			  	_cQuery += " 	,SCR.CR_DTLIMIT"
			  	_cQuery += " 	,SCR.CR_HRLIMIT"
			  	_cQuery += " 	,SCR.R_E_C_N_O_ SCRRECNO"
			  	_cQuery += "  FROM "+RetSqlName("SCR")+" SCR"
			  	_cQuery += " WHERE SCR.D_E_L_E_T_<>'*'"
			  	_cQuery += "   AND SCR.CR_FILIAL='"+cFilAnt+"'"
			  	_cQuery += "   AND SCR.CR_TIPO='PC'"
			  	_cQuery += "   AND SCR.CR_STATUS='02'"  				// Em aprovacao
			  	_cQuery += "   AND SCR.CR_DTLIMIT<='"+cCRDTLIMIT+"'"	// Data Limite
			  	_cQuery += "   AND SCR.CR_WF=' '"
			  	_cQuery += " ORDER BY"
			  	_cQuery += " 		 SCR.CR_FILIAL"
			  	_cQuery += " 		,SCR.CR_NUM"
			  	_cQuery += " 		,SCR.CR_NIVEL"
			  	_cQuery += " 		,SCR.CR_USER"

				TCQUERY (_cQuery) NEW ALIAS (cTMP)

				While (cTMP)->(!Eof())

					IF !EMPTY((cTMP)->CR_DTLIMIT)
						IF (cTMP)->CR_DTLIMIT>=cCRDTLIMIT
							IF (cTMP)->CR_HRLIMIT>cCRHRLIMIT
								(cTMP)->(dbSkip())
								LOOP
							ENDIF
						ENDIF
					ENDIF

					//Obtem o RecNo para a Tabela SCR
					nSCRRecNo:=(cTMP)->SCRRECNO

					//Garante o Posicionamento na Tabela SCR
					SCR->(dbGoTo(nSCRRecNo))

					//Tenta Garantir o Lock na Tabela SCR
					IF .not.(SCR->(SoftLock("SCR")))
						(cTMP)->(dbSkip())
						LOOP
					EndIF

					SC7->(dbSetOrder(1))
					SC7->(dbSeek(cC7Filial+PADR(ALLTRIM((cTMP)->CR_NUM),nC7Num)))

					IF EMPTY(SC7->C7_APROV)

						SCR->(MsGoTo(nSCRRecNo))
						IF SCR->(!Eof())
							//Tenta Garantir o Lock na Tabela SCR
							IF .not.(SCR->(SoftLock("SCR")))
								(cTMP)->(dbSkip())
								LOOP
							EndIF
							if SCR->(Reclock("SCR",.F.))
								SCR->CR_WF:="1"	    // Status 1 - envio para aprovadores / branco-nao houve envio
				  				SCR->CR_WFID:="N/D"	// Rastreabilidade
								SCR->(MSUnlock())
							endif
						ENDIF

					ELSE

						SCR->(MsGoTo(nSCRRecNo))

						//Tenta Garantir o Lock na Tabela SCR
						IF .not.(SCR->(SoftLock("SCR")))
							(cTMP)->(dbSkip())
							LOOP
						EndIF

						aWFReturn:=(cTMP)->(EnviaPC(CR_FILIAL,CR_NUM,CR_USER,(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER),CR_TOTAL,STOD(CR_DTLIMIT),CR_HRLIMIT,_nOpc))

						If Len(aWFReturn)>0
							SCR->(MsGoTo(nSCRRecNo))
							IF SCR->(!Eof())
								if SCR->(Reclock("SCR",.F.))
									SCR->CR_WF:=IF(!(aWFReturn[WF_START]),SCR->CR_WF,"1")	// Status 1 - envio para aprovadores / branco-nao houve envio
						  			SCR->CR_WFID:=aWFReturn[WF_ID]					        // Rastreabilidade
									SCR->CR_DTLIMIT:=aWFReturn[WF_DTLIMITE]			        // Data Limite
									SCR->CR_HRLIMIT:=aWFReturn[WF_HRLIMITE]			        // Hora Limite
									SCR->CR_WFLINK:=aWFReturn[WF_HTMLFILE]			        // Arquivo HTML //link timeout Vitor 28/11/13
									SCR->(MSUnlock())
								endif
							ENDIF
						EndIf

					ENDIF

					SCR->(MsGoTo(nSCRRecNo))

					//Tenta Garantir o Lock na Tabela SCR
					SCR->(MsUnLock())

					_lProcesso:=.T.

					(cTMP)->(dbSkip())

				End

				dbSelectArea(cTMP)
				(cTMP)->(dbCloseArea())
				dbSelectArea("SCR")

			    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
				OutMessage(cMsg)

			/*
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ2 - Processa O RETORNO DO EMAIL                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			*/
			CASE (_nOPC==2)

				    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
					OutMessage(cMsg)

					U_CONSOLE("T4FCOMM - 2 - Processa O RETORNO DO EMAIL")
					U_CONSOLE("T4FCOMM - 2 - EmpFil:"+cEmpAnt+cFilAnt)
					U_CONSOLE("T4FCOMM - 2 - Semaforo Vermelho")

					if !LockByName("WFPC2",.T.,.T.,.T.)
					    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): BREAK : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
						OutMessage(cMsg)
						break
					endif

					cWFFilial:=alltrim(oProcess:oHtml:RetByName("CFILANT"))
					if .not.(cWFFilial==alltrim(cFilAnt))
						RpcSetType(3)
						RpcSetEnv(cEmp,cWFFilial)
						U_CONSOLE("T4FCOMM - 2 - EmpFil (WF):"+cEmpAnt+cFilAnt)
					endif

					if !LockByName("WFPC2",.T.,.T.,.T.)
					    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): BREAK : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
						OutMessage(cMsg)
						break
					endif

					cChaveSCR:=alltrim(oProcess:oHtml:RetByName("CHAVE"))
					cOpc:=alltrim(oProcess:oHtml:RetByName("OPC"))
					cObs:=alltrim(oProcess:oHtml:RetByName("OBS"))
					cWFID:=alltrim(oProcess:oHtml:RetByName("WFID"))

					cTo:=SUBS(alltrim(oProcess:cRetFrom),AT('<',alltrim(oProcess:cRetFrom))+1,LEN(alltrim(oProcess:cRetFrom))-AT('<',alltrim(oProcess:cRetFrom))-1)

					oProcess:Finish() // FINALIZA O PROCESSO

					U_CONSOLE("T4FCOMM - 2 - cFilAnt:"+cFilAnt)
					U_CONSOLE("T4FCOMM - 2 - Chave:"+cChaveSCR)
					U_CONSOLE("T4FCOMM - 2 - Opc:"+cOpc)
					U_CONSOLE("T4FCOMM - 2 - Obs:"+cObs)
					U_CONSOLE("T4FCOMM - 2 - WFId:"+cWFID)
					U_CONSOLE("T4FCOMM - 2 - cTo:"+cTo)

					IF (cOpc$"S|N")  // Aprovacao S-Sim N-Nao
						ChkFile("SCR")
						ChkFile("SAL")
						ChkFile("SC7")
						ChkFile("SCS")
						ChkFile("SAK")
						ChkFile("SM2")
						// Posiciona na tabela de Alcadas
						dbSelectArea("SCR")
						SCR->(dbSetOrder(2))
						SCR->(dbSeek(cChaveSCR))
						IF SCR->(!FOUND().OR.TRIM(SCR->CR_WFID)<>TRIM(cWFID))
							//"Este processo nao foi encontrado e portanto deve ser descartado
							// abre uma notificacao a pessoa que respondeu
							U_CONSOLE("T4FCOMM - 2 - Processo nao encontrado:"+cWFID+" Processo atual:"+SCR->CR_WFID)
							U_CONSOLE("T4FCOMM - 2 - Semaforo Verde")
							UnLockByName("WFPC2",.T.,.T.,.T.)
							lRet:=.T.
						    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): BREAK : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
							OutMessage(cMsg)
							BREAK
						ENDIF

						If SCR->(Reclock("SCR",.F.))
							SCR->CR_WF:="2"	// Status 2 - respondido
							SCR->(MSUnlock())
						EndIf

						If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
							U_CONSOLE("T4FCOMM - 2.1 - Processo respondido anteriormente:"+cWFID)
							U_CONSOLE("T4FCOMM - 2.1 - Semaforo Verde")
							cSubject:=_cPrefMsg+ Alltrim(SM0->M0_NOME)+" - AVISO - Pedido de Compra No. "+Substr(cChaveSCR,5,6) +" respondido anteriormente"
							_cEmail:=UsrRetMail(Substr(cChaveSCR,55,6))
							aSize(aMsg,0)
							aAdd(aMsg,"Sr. Aprovador,")
							aAdd(aMsg,"<br></br>")
							aAdd(aMsg,'O Pedido de Compra No.: '+Substr(cChaveSCR,5,6)+' foi anteriormente '+SCR->CR_OBS)
							aAdd(aMsg,"<br></br>")
							aAdd(aMsg,"<br></br>")
							U_MailNotify(_cEmail,cSubject,aMsg)
							UnLockByName("WFPC2",.T.,.T.,.T.)
							lRet:=.T.
						    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): BREAK : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
							OutMessage(cMsg)
							BREAK
						EndIf

						// Verifica se o pedido de compra esta aprovado
						// Se estiver,finaliza o processo
						dbSelectArea("SC7")
						SC7->(dbSetOrder(1))
						SC7->(dbSeek(cC7Filial+Padr(SCR->CR_NUM,nC7Num)))

						IF SC7->C7_CONAPRO <> "B"  // NAO ESTIVER BLOQUEADO
							U_CONSOLE("T4FCOMM - xFilial(): "+cC7Filial)
							U_CONSOLE("T4FCOMM - SCR->CR_NUM: "+PadR(SCR->CR_NUM),nC7Num)
							U_CONSOLE("T4FCOMM - C7_FILIAL:"+SC7->C7_FILIAL)
							U_CONSOLE("T4FCOMM - C7_NUM:"+SC7->C7_NUM)
							U_CONSOLE("T4FCOMM - 2.2 - Processo ja respondido via sistema:"+cWFID)
							U_CONSOLE("T4FCOMM - 2.2 - Semaforo Verde")
							UnLockByName("WFPC2",.T.,.T.)
							lRet:=.T.
						    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): BREAK : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
							OutMessage(cMsg)
							BREAK
						ENDIF

						// REPosiciona na tabela de Alcadas
						dbSelectArea("SCR")
						SCR->(dbSetOrder(2))
						SCR->(dbSeek(cChaveSCR))

						// verifica quanto a saldo de al็ada para aprova็ใo
						// Se valor do pedido estiver dentro do limite Maximo e minimo
						// Do aprovador,utiliza o controle de saldos,caso contrแrio nao
						// faz o tratamento como vistador.
						nTotal:=SCR->CR_TOTAL
						lLiberou:=U_MaAlcDoc({SCR->CR_NUM,"PC",nTotal,SCR->CR_APROV,,SC7->C7_APROV,,,,,cObs},msdate(),If(cOpc=="S",4,6))

						//Alterado 05/11/2015 - Incluso aprova็ใo pelo grupo de aprova็ใo.
						dbSelectArea("SC7")
						SC7->(dbSetOrder(1))
						If SC7->(dbSeek(cC7Filial+PADR(ALLTRIM(SCR->CR_NUM),nC7Num)))
							MaAlcDoc({SCR->CR_NUM,"PC",nTotal,SCR->CR_APROV,,SC7->C7_APROV,,,,,},msdate(),4)
						EndIf

						U_CONSOLE("T4FCOMM - 2 - Liberado:"+IIF(lLiberou,"Sim","Nao"))
						U_CONSOLE("T4FCOMM - 2 - Pedido:"+SC7->C7_NUM)
						_lProcesso:=.T.

						_cNumPed:=Padr(SC7->C7_NUM,nC7Num)
						_cFilPed:=SC7->C7_FILIAL
  						_lOkPed:=fTCOMM1(_cNumPed,_cFilPed)
					 	If _lOkPed
						 	_nRecSC7Bkp:=SC7->(RecNo())
						 	dbSelectArea("SC7")
							SC7->(dbSetOrder(1))
							If SC7->(dbSeek(cC7Filial+_cNumPed))
							  While SC7->(!Eof().And.(C7_FILIAL+C7_NUM)==(cC7Filial+_cNumPed))
							  	If SC7->(Reclock("SC7",.F.))
				 					SC7->C7_CONAPRO:="L"
				 					SC7->C7_WF:="2"
				 					SC7->(MsUnlock())
							  	EndIf
			 					SC7->(dbSkip())
							  EndDo
							EndIf
			  				SC7->(MSGoTo(_nRecSC7Bkp))
					 	EndIf

						If lLiberou
							_nRecSC7Bkp:=SC7->(RecNo())     //vitor
							_cNumPed:=Padr(SC7->C7_NUM,nC7Num)
							dbSelectArea("SCR")
							SCR->(dbSetOrder(1))
							If SCR->(dbSeek(cCRFilial+PadR(_cNumPed,nCRNum)))
				  				While SCR->(!Eof().And.(CR_FILIAL+PadR(CR_NUM,nC7Num)==SC7->(C7_FILIAL+C7_NUM)))
				  					If Empty(SCR->CR_DATALIB)
				  						lLiberou:=.F.
				  						EXIT
				  					EndIf
 									SCR->(dbSkip())
				  				EndDo
						 	EndIf
			  				If lLiberou
				  				dbSelectArea("SC7")
								SC7->(dbSetOrder(1))
								If SC7->(dbSeek(cC7Filial+_cNumPed))
					  				While SC7->(!Eof().And.(C7_FILIAL+C7_NUM)==(cC7Filial+_cNumPed))
					  					If SC7->(Reclock("SC7",.F.))
											 SC7->C7_CONAPRO:="L"
											 SC7->C7_WF:="2"
											 SC7->(MsUnlock())
										EndIf
										SC7->(dbSkip())
									EndDo
								EndIf
			  				EndIf
			  				SC7->(DbGoTo(_nRecSC7Bkp))  //vitor
							//Chama rotina para gerar Solic.PA     vitor
			  				If SC7->(C7_XSOLPA = '2' .And. C7_XVALPA > 0 .And. !(Empty(C7_XVENPA)))
								U_T4COMC01() //Chama a fun็ใo de gera็ใo da solicita็ใo de PA (ZZE).
								//U_T4COMC01(SC7->C7_XVALPA,stod(SC7->C7_XVENPA)) 
							EndIf
						EndIf
					EndIf

				    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
					OutMessage(cMsg)

					UnLockByName("WFPC2",.T.,.T.,.T.)

					U_CONSOLE("T4FCOMM - 2 - Semaforo Verde")

				    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
					OutMessage(cMsg)

			/*
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ3 - Envia resposta de pedido aprovado para o comprador ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			*/
			CASE _nOpc == 3  
			
			    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
				OutMessage(cMsg)
		
				U_CONSOLE("T4FCOMM - 3 - Envia resposta de pedido APROVADO para o comprador")
				U_CONSOLE("T4FCOMM - 3 - EmpFil:"+cEmpAnt+cFilAnt)

				/*
					TODO: Verificar ALวADA
					C7_TIPO=1				// 1-Pedido de compra
					C7_CONAPRO='L'			// Liberado
					C7_APROV <> '      '	// Grupo Aprovador
				  	C7_WF <> '1'			// 1 Enviado EMAIL
				 */

                cFilter:="%("+cFilter+")%"

				BEGINSQL Alias cTMP
					SELECT SC7.R_E_C_N_O_ SC7RECNO
						  ,SA2.R_E_C_N_O_ SA2RECNO
				  	  FROM %table:SC7% SC7
						  ,%table:SA2% SA2
				  	 WHERE SC7.%NotDel%
				  	   AND SA2.%NotDel%
				  	   AND SC7.C7_FILIAL=%xFilial:SC7%
				  	   AND SA2.A2_FILIAL=%xFilial:SA2%
					   AND SC7.C7_TIPO=1
					   AND SC7.C7_CONAPRO='L'
					   AND SC7.C7_APROV<>'      '
				       AND SC7.C7_WF<>'1'
				       AND SC7.C7_FORNECE=SA2.A2_COD
				       AND SC7.C7_LOJA=SA2.A2_LOJA
         			   AND (%exp:cFilter%)
         		       AND EXISTS (
	         				SELECT DISTINCT 1
	         				  FROM %table:SCR% SCR
	         				 WHERE SCR.%NotDel%
					  		   AND SCR.CR_FILIAL=SC7.C7_FILIAL
						       AND SCR.CR_TIPO='PC'
				 			   AND SCR.CR_STATUS='03'
				 			   AND SCR.CR_LIBAPRO<>' '
							   AND TRIM(SCR.CR_NUM)=SC7.C7_NUM
					  )
				  	ORDER BY SC7.C7_FILIAL
							,SC7.C7_NUM
							,SC7.C7_ITEM
				ENDSQL

				SCR->(dbSetOrder(1))

				While (cTMP)->(!Eof())

					nSC7RecNo:=(cTMP)->SC7RECNO
					if (aScan(aSC7RecNos,{|nRecNo|(nRecNo==nSC7RecNo)})>0)
                        (cTMP)->(dbSkip())
                        loop
                    endif                    
                    
                    SC7->(dbGoTo(nSC7RecNo))

					_cNum:=SC7->C7_NUM

					cCRKeySeek:=SC7->C7_FILIAL
					cCRKeySeek+="PC"
					cCRKeySeek+=PadR(_cNum,nCRNum)

					nSA2RecNo:=(cTMP)->SA2RECNO
					SA2->(MsGoTo(nSA2RecNo))

					_lAchou:=.F.
					_lAprov:=.F.
					_cChave:=''
					_nTotal:=0

					SCR->(dbSeek(cCRKeySeek,.T.))

					//TODO: Verificar Corretamente a ALวADA
					While SCR->(!EOF().AND.CR_FILIAL+CR_TIPO+CR_NUM==cCRKeySeek)
  						//SOMENTE CASO APROVADO
  						IF SCR->(CR_STATUS=='03'.AND.!EMPTY(CR_LIBAPRO))
							_cChave:=SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
							_lAprov:=.T.
							_lAchou:=.T.
	  						_nTotal:=SCR->CR_TOTAL
						ENDIF
  						SCR->(dbSkip())
  					End

					IF !_lAchou
						SC7->(MsGoTo(nSC7RecNo))
						If SC7->(Reclock("SC7",.F.))
							SC7->C7_WF:="1"   	// Status 1 - enviou email
				  			SC7->C7_WFID:="N/D"	// Rastreabilidade
							SC7->(MSUnlock())
						EndIf
					ENDIF

	 				IF _lAprov

						aWFReturn:=SC7->(EnviaPC(C7_FILIAL,C7_NUM,C7_USER,_cChave,_nTotal,dEDate,'     ',_nOpc))

						_lMailFor:=.F.
						SC7->(MsGoTo(nSC7RecNo))
						If SC7->C7_XTPCPR<>"E"
							SA2->(MsGoTo(nSA2RecNo))
       						If SC7->(Alltrim(C7_XMAILF)<>"".AND.C7_XENVMAI<>"S")
						       	_cToFor:=Alltrim(SC7->C7_XMAILF)
						       	_cToFor+=";tmoraes@t4f.com.br"
								U_CONSOLE("T4FCOMM - Chamando _fEPCFor para enviar pedido aprovado")
								SC7->(U__fEPCFor(C7_FILIAL,C7_NUM,C7_USER,_cChave,_nTotal,dEDate,'     ',/*nOpc*/,_cToFor,,cEmpAnt))
								_lMailFor:=.T.
							Elseif SC7->(C7_XENVMAI<>"S") //Envia Email do Fornecedor para o Solicitante.
       							_cToFor:=UsrRetMail(SC7->C7_USER)
       							_cToFor+=";tmoraes@t4f.com.br"
		 						U_CONSOLE("T4FCOMM - Chamando _fEPCFor para enviar pedido aprovado para o Solicitante. Fornecedor Sem Email.")
								SC7->(U__fEPCFor(C7_FILIAL,C7_NUM,C7_USER,_cChave,_nTotal,dEDate,'     ',/*nOpc*/,_cToFor,,cEmpAnt))
								_lMailFor:=.T.
	 							U_CONSOLE("T4FCOMM - Ignorando _fEPCFor,e-mail em branco ou mail forn ja processado anteriormente.")
		 					Endif
		 					_lProcesso:=.T.
		 				EndIf

						If (Len(aWFReturn)>0)

							SC7->(MsGoTo(nSC7RecNo))

							While SC7->(!EOF().AND._cNum==C7_NUM)
								If SC7->(Reclock("SC7",.F.))
                                    SC7->C7_WF:=IF(!(aWFReturn[WF_START]),SC7->C7_WF,"1")   // Status 1 - envio email / branco -nao enviado
                                    SC7->C7_WFID:=aWFReturn[WF_ID]                          // Rastreabilidade
						  			If SC7->C7_XENVMAI<>"S".AND._lMailFor
							  			SC7->C7_XENVMAI:="S"
							  		EndIf
									SC7->(MSUnlock())
								EndIf
								SC7->(dbSkip())
							ENDDo
							
							_lProcesso:=.T.

							(cTMP)->(dbSkip())
							Loop

						Else

							//Na ocorrencia de Erro no WF,vai para o proximo registro e continua
							(cTMP)->(dbSkip())
							Loop

						EndIf

					ELSE

						//Nao Aprovou. Continua...
						(cTMP)->(dbSkip())
						Loop

					ENDIF
					
					(cTMP)->(dbSkip())
					_lProcesso:=.T.

				END
				
			    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
				OutMessage(cMsg)

				dbSelectArea(cTMP)
				(cTMP)->(dbCloseArea())
				dbSelectArea("SC7")

			    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
				OutMessage(cMsg)

			/*
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ4 - Envia resposta de pedido bloqueado para o compradorณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			*/
			CASE _nOpc == 4

				U_CONSOLE("T4FCOMM - 4 - Envia resposta de pedido bloqueado para o comprador")

				U_CONSOLE("T4FCOMM - 5 - EmpFil:"+cEmpAnt+cFilAnt)

			  	_cQuery := "SELECT SCR.CR_FILIAL"
			  	_cQuery += " 	  ,SCR.CR_TIPO"
			  	_cQuery += " 	  ,SCR.CR_NUM"
			  	_cQuery += " 	  ,SCR.CR_NIVEL"
			  	_cQuery += " 	  ,SCR.CR_TOTAL"
			  	_cQuery += " 	  ,SCR.CR_USER"
			  	_cQuery += " 	  ,SCR.CR_APROV"
			  	_cQuery += "  FROM "+RetSqlName("SCR")+" SCR"
			  	_cQuery += " WHERE SCR.D_E_L_E_T_ <> '*'"
			  	_cQuery += "   AND SCR.CR_FILIAL = '"+cFilAnt+"'"
			  	_cQuery += "   AND SCR.CR_LIBAPRO <> '      '" 		// Seleciona o Aprovador que reprovou
			  	_cQuery += "   AND SCR.CR_STATUS = '04'"              // REPROVADO
			  	_cQuery += "   AND SCR.CR_TIPO = 'PC'"                // PEDIDO DE COMPRA
			  	_cQuery += "   AND SCR.CR_WF <> '1'"   				// 1-Enviado
			  	_cQuery += " ORDER BY"
			  	_cQuery += " 	 SCR.CR_FILIAL"
			  	_cQuery += " 	,SCR.CR_NUM"
			  	_cQuery += " 	,SCR.CR_NIVEL"
			  	_cQuery += " 	,SCR.CR_USER"

				TCQUERY (_cQuery) NEW ALIAS (cTMP)

				While (cTMP)->(!Eof())
					dbSelectArea("SC7")
					SC7->(dbSetOrder(1))
					SC7->(dbSeek(cC7Filial+PadR((cTMP)->CR_NUM,nC7Num)))
					IF EMPTY(SC7->C7_APROV)
						dbSelectArea("SCR")
						SCR->(dbSetOrder(2))
						IF SCR->(dbSeek((cTMP)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)))
							If SCR->(Reclock("SCR",.F.))
								SCR->CR_WF:="1"		// Status 1 - envio para aprovadores / branco-nao houve envio
					  			SCR->CR_WFID:="N/D"	// Rastreabilidade
								SCR->(MSUnlock())
							EndIf
						ENDIF
					ELSE
						aWFReturn:=EnviaPC((cTMP)->CR_FILIAL,(cTMP)->CR_NUM,SC7->C7_USER,(cTMP)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV),(cTMP)->CR_TOTAL,ctod('  /  /  '),'     ',_nOpc)
						If Len(aWFReturn)>0
							dbSelectArea("SCR")
							SCR->(dbSetOrder(2))
							IF dbSeek((cTMP)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
								if Reclock("SCR",.F.)
									SCR->CR_WF:=IF(!(aWFReturn[WF_START]),SCR->CR_WF,"1")   // Status 1 - envio para aprovadores / branco-nao houve envio
						  			SCR->CR_WFID:=aWFReturn[WF_ID]					        // Rastreabilidade
									SCR->(MSUnlock())
								endif
							ENDIF
						EndIf
					ENDIF
					_lProcesso:=.T.
					(cTMP)->(dbSkip())
				End
				(cTMP)->(dbCloseArea())
				dbSelectArea("SCR")

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ5 - ENVIO de Email - Acao TIME-OUT             		 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			CASE (_nOpc==5)
			
			    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
				OutMessage(cMsg)

					U_CONSOLE("T4FCOMM - 5 - Acao TimeOut : Begin")
	
					CHKFile("SAL")
					CHKFile("SCR")
					CHKFile("SC7")
					ChkFile("SCS")
					ChkFile("SAK")
					ChkFile("SM2")
	
					//TimeOut()

					U_CONSOLE("T4FCOMM - 5 - Acao TimeOut : End")
	
			    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
				OutMessage(cMsg)

		END CASE

	END SEQUENCE

    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
	OutMessage(cMsg)

	MsUnLockAll()

	UnLockByName("WFPC2",.T.,.T.,.T.)

	cFilAnt:=cSVFilAnt

	UnLockByName("WFPC2",.T.,.T.,.T.)

	IF _lProcesso
		U_CONSOLE("T4FCOMM -  Mensagem processada ")
	ELSE
		U_CONSOLE("T4FCOMM -  Nao houve processamento")
	ENDIF

    cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
	OutMessage(cMsg)

RETURN(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaPC   บAutor  ณMicrosiga           บ Data ณ  08/15/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaPC(_cFilial,_cNum,_cUser,_cChave,_nTotal,_dDTLimit,_cHRLimit,_nOpc)

	Local aWFReturn:=Array(WF_MAX)

	Local aDados:={}
	Local aJustif:={}
	Local aCotacao:={}
	Local aFornece:={}
	Local aFortela:={}
	Local aProduto:={}

	Local _cCC	:=''
	Local _cFornece,_cLoja
	Local _cMailSol:=''

	Local cC7Filial
	Local cB1Filial
	Local cB5Filial
	Local cBMFilial

	Local cCTDFilial
    
    local lSC7Lock:=.F.
    
    Local nSC7Recno:=Len(aSC7RecNos)
    Local nSC7Recnos:=nSC7Recno

	Private aMsg:={}
	
	aWFReturn[WF_ID]:=""
	aWFReturn[WF_DTLIMITE]:=dDataBase
	aWFReturn[WF_HRLIMITE]:=Time()
	aWFReturn[WF_DTVALIDA]:=aWFReturn[WF_DTLIMITE]
	aWFReturn[WF_HRVALIDA]:=aWFReturn[WF_HRLIMITE]
	aWFReturn[WF_HTMLFILE]:=""
    aWFReturn[WF_START]:=.F.

	// ----- FIM DA VALIDACAO

	ChkFile("SE4")
	ChkFile("SC1")
	ChkFile("SC8")
	ChkFile("SA2")
	ChkFile("SB1")
	ChkFile("SBM")
	ChkFile("SCR")
	ChkFile("SC7")
	CHKFile("SAL")

	cC7Filial:=xFilial("SC7",_cFilial)
	cB1Filial:=xFilial("SB1")
	cB5Filial:=xFilial("SB5")
	cBMFilial:=xFilial("SBM")

	cCTDFilial:=xFilial("CTD")

	_cHttp:=GetNewPar("MV_WFDHTTP","http://COMPAQ:91/workflow")

	// TimeOut - Dias
	_nDD:=GetNewPar("MV_WFTODD",0)

	_dDataLib:=IIF(!EMPTY(_dDTLimit),_dDTLimit,MSDATE())
	_cHoraLib:=IIF(!EMPTY(_cHRLimit),_cHRLimit,LEFT(TIME(),5))

	// WF-Workflow TO-TimeOut PC-Pedido de Compras
	_cTimeOut:=GetNewPar("MV_WFTOPC","24:00")
	_nTimeOut:=(_nDD*24)+VAL(LEFT(_cTimeOut,2))+(VAL(RIGHT(_cTimeOut,2))/60)

	_cTo:=UsrRetMail(_cUser)

	U_CONSOLE("T4FCOMM - "+NToS(_nOpc)+" - E-mail: "+_cTo+"  - cUser "+_cUser)
	U_CONSOLE("T4FCOMM - "+NToS(_nOpc)+" - Pedido:"+_cNum)

	_cEmail:=UsrRetMail(_cUser)

	_aTimeOut:=U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)

	If ((_nOpc==3).OR.(_nOpc==4))
		_cMailSol:=U__fRMSol(Posicione("SC7",1,cC7Filial+Alltrim(_cNum),"C7_NUMSC"))
		If !Empty(_cMailSol).AND.!(Alltrim(_cMailSol)$_cTo)
			_cTo += ";"+_cMailSol
		EndIf
	EndIf

	//------------------- VALIDACAO
	_lError:=.F.
// 2019_02_22 - Comentado abaixo por motivo de estar enviando um monte de email de cadastro de usuario sem a conta de email (Solicitado Thiago Moraes - Geraldo Sabino)
  	/*
		if Empty(_cTo)
		aSize(aMsg,0)
		cTitle:="Administrador do Workflow: NOTIFICACAO"
		aAdd(aMsg,REPLICATE('*',80))
		aAdd(aMsg,Dtoc(MSDate())+" - "+Time()+' * Ocorreu um ERRO no envio da mensagem:')
		aAdd(aMsg,"Pedido de Compra No: "+_cNum+" Filial: "+cFilAnt+" Usuario: "+UsrRetName(_cUser))
		aAdd(aMsg,"Campo EMAIL do cadastro de usuario NAO PREENCHIDO")
		aAdd(aMsg,REPLICATE('*',80))
		_lError:=.T.
	Endif
	*/

	IF _lError
		U_NotifyAdm(cTitle,aMsg,{})
		aWFReturn[WF_ID]:=""
		aWFReturn[WF_DTLIMITE]:=_aTimeOut[1]
		aWFReturn[WF_HRLIMITE]:=_aTimeOut[2]
		aWFReturn[WF_DTVALIDA]:=_aTimeOut[3]
		aWFReturn[WF_HRVALIDA]:=_aTimeOut[4]
		aWFReturn[WF_HTMLFILE]:=""
        aWFReturn[WF_START]:=.F.
		RETURN(aWFReturn)
	ENDIF

	_cChaveSCR:=_cFilial+'PC'+_cNum
	_cNum:=PADR(ALLTRIM(_cNum),GetSX3Cache("C7_NUM","X3_TAMANHO"))
	lDetalhe:=.F.

	dbSelectArea("SCR")
	SCR->(dbSetOrder(2))
	SCR->(dbSeek(_cChaveSCR))

	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+cFilAnt))

	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(cC7Filial+_cNum))

	_cNumCot:=SC7->C7_NUMCOT

	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))

	dbSelectArea("SE4")
	SE4->(dbSetOrder(1))
	SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND))

	dbSelectArea("SC1")
	SC1->(dbSetOrder(1))
	SC1->(dbSeek(_cFilial+_cNum,.f.))

	dbSelectArea("SAL")
	SAL->(dbSetOrder(3))
	SAL->(dbSeek(xFilial("SAL")+SC7->C7_APROV+SCR->CR_APROV))

	// REFAZ O TIMEOUT CONFORME REGRA NO CADASTRO DE GRUPO DE APROVADORES
	// TimeOut - Dias
	_nDD:=GetNewPar("MV_WFTODD",0)
	_cTimeOut:=GetNewPar("MV_WFTOPC","24:00")
	_dDataLib:=IIF(!EMPTY(_dDTLimit),_dDTLimit,MSDATE())
	_cHoraLib:=IIF(!EMPTY(_cHRLimit),_cHRLimit,LEFT(TIME(),5))
	_nTimeOut:=(_nDD*24)+VAL(LEFT(_cTimeOut,2))+(VAL(RIGHT(_cTimeOut,2))/60)
	_aTimeOut:=U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)

	DO CASE
	//-------------------------------------------------------- INICIO PROCESSO WORKFLOW
		CASE _nOpc == 1		// Envio de email para aprovacao
		// COLOCAR REGRA PARA CONTAR 4 DIAS AQUI....
			oProcess:=TWFProcess():New("000001","Envio Aprovacao PC:"+_cFilial+"/"+TRIM(_cNum))
			oProcess:NewTask("Envio PC para aprovacao: "+_cFilial+_cNum,"\WORKFLOW\HTML\PCAPROV_SZ.HTM")
			oProcess:cSubject:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - Aprovacao do Pedido de Compra "+_cFilial+"/"+_cNum
			oProcess:bReturn:="U__fWFPC(2)" //wfout descomentei esta linha para reenvio ao aprova็ใo
	    CASE _nOpc == 3 // Envio de email Aprovacao para solicitante
			oProcess:=TWFProcess():New("000003","Envio p/comprador PC aprovado: "+_cFilial+"/"+TRIM(_cNum))
			oProcess:NewTask("Envio PC aprovado: "+_cFilial+_cNum,"\WORKFLOW\HTML\PCRESP_SZ.HTM")
			oProcess:cSubject:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - Pedido de Compra aprovado "+_cFilial+"/"+_cNum
			_cResposta:=" A P R O V A D O "
		CASE _nOpc == 4	// Envio de email Reprovado para solicitante
			oProcess:=TWFProcess():New("000004","Envio p/comprador PC reprovado: "+_cFilial+"/"+TRIM(_cNum))
			oProcess:NewTask("Envio PC reprovado: "+_cFilial+_cNum,"\WORKFLOW\HTML\PCRESP_SZ.HTM")
			oProcess:cSubject:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - Pedido de Compra reprovado "+_cFilial+"/"+_cNum
			_cResposta:="<font color='#FF0000'>R E P R O V A D O </font>"
	ENDCASE

	oProcess:UserSiga:=_cUser
	oProcess:NewVersion(.T.)
 	oHtml:=oProcess:oHTML

	IF _nOpc == 1
		// Hidden Fields
		oHtml:ValByName("OBS","")
		oHtml:ValByName("CR_USER",UsrFullName(_cUser))
		oHtml:ValByName("CHAVE",_cChave)
		oHtml:ValByName("CFILANT",cFilAnt)
		oHtml:ValByName("WFID",oProcess:fProcessId)
		oHtml:ValByName("OBS","")
	ENDIF

	IF ((_nOpc==3).OR.(_nOpc==4))
		oHtml:ValByName("mensagem",_cResposta)
	ENDIF

     // gsabino 2019_02_15 - Imprime o numero do PA caso exista na Tabela ZZE
     // Salva Area 
     
    _aAreaAtu:=GetArea()
    _aAreaZZE:=ZZE->(GetArea())
    
    dbSelectarea("ZZE")
    dBSetOrder(2)
    _cPa :=""
    IF dBSeek(xFilial("ZZE") + SC7->C7_NUM)                                        
       _cPa := "/PA "+ZZE->ZZE_NUMERO
    ENDIF
    Restarea(_aAreaZZE)
    RestArea(_aAreaAtu)

	oHtml:ValByName("CEMPANT",SM0->M0_NOME)
	oHtml:ValByName("C7_FILIAL",SM0->M0_FILIAL)
	oHtml:ValByName("C7_NUM",SC7->C7_NUM + _cPa)
	oHtml:ValByName("C7_EMISSAO",DTOC(SC7->C7_EMISSAO))

	 If SC7->(C7_XTPCPR$"E,D")
 		_cComprad:=Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC,"C1_USER")
	 ELSE
	 	_cComprad:=SC7->C7_USER
	 ENDIF
	oHtml:ValByName("C7_USER",UsrFullName(_cComprad))

	_cCCAprov:=SC7->(IIF(Empty(C7_CC),C7_XCCAPR,C7_CC))
	_cCdSolic:=Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC,"C1_USER")

	oHtml:ValByName("C7_XTPCPR",X3Combo("C7_XTPCPR",SC7->C7_XTPCPR))
	oHtml:ValByName("A2_NOME",SA2->A2_NOME)
	oHtml:ValByName("A2_EMAIL",SC7->C7_XMAILF)
	oHtml:ValByName("A2_TEL",SA2->A2_TEL)
	oHtml:ValByName("C7_COND",SC7->C7_COND+" / "+POSICIONE("SE4",1,XFILIAL("SE4")+SC7->C7_COND,"E4_DESCRI"))
   	oHtml:ValByName("C7_OBS",Alltrim(SC7->C7_XOBSAPR))
   	oHtml:ValByName("C7_NUMSC",SC7->C7_NUMSC)
	oHtml:ValByName("C7_SOLICIT",UsrFullName(_cCdSolic))
	oHtml:ValByName("C7_CC",_cCCAprov+" / "+POSICIONE("CTT",1,XFILIAL("CTT")+_cCCAprov,"CTT_DESC01"))
	oHtml:ValByName("C7_VALPA",TRANSFORM(SC7->C7_XVALPA,'@E 9,999,999.99'))
	oHtml:ValByName("C7_VENPA",DTOC(SC7->C7_XVENPA))

	//-------------------------------------------------------------
	// ALIMENTA A TELA DE ITENS DO PEDIDO DE COMPRA
	//-------------------------------------------------------------
	_nC7_TOTAL:=0
	_nC7_VLDESC:=0
	_nFRETEDESP:=0

	SB1->(dbSetOrder(1))
	SBM->(dbSetOrder(1))
	SB5->(dbSetOrder(1))

	While SC7->(!EOF().AND.(C7_FILIAL==cC7Filial).AND.(C7_NUM==_cNum))

		aAdd(aSC7RecNos,SC7->(RecNo()))
        ++nSC7Recnos
        lSC7Lock:=SoftLock("SC7")
        if .not.(lSC7Lock)
            exit
        endif
                    
        SB1->(MSSeek(cB1Filial+SC7->C7_PRODUTO))

		SBM->(MSSeek(cBMFilial+SB1->B1_GRUPO))

		If SB5->(MSSeek(cB5Filial+SC7->C7_PRODUTO))
			_cDescPro:=SB5->B5_CEME
		Else
			_cDescPro:=SB1->B1_DESC
		EndIf

		aAdd((oHtml:ValByName("t.1")),SC7->C7_ITEM)
		aAdd((oHtml:ValByName("t.2")),SC7->C7_PRODUTO+" - "+_cDescPro)
		aAdd((oHtml:ValByName("t.3")),SC7->(TRANSFORM(C7_QUANT,'@E 9,999,999.99')))
		aAdd((oHtml:ValByName("t.4")),SC7->(Alltrim(C7_ITEMCTA)+"-"+Alltrim(Posicione("CTD",1,cCTDFilial+C7_ITEMCTA,"CTD_DESC01")))) //andre aprova็ใo
		aAdd((oHtml:ValByName("t.5")),SC7->(TRANSFORM(C7_PRECO,'@E 9,999,999.99')))
		aAdd((oHtml:ValByName("t.6")),SC7->(TRANSFORM(C7_VALFRE+C7_DESPESA,'@E 9,999,999.99')))
		aAdd((oHtml:ValByName("t.7")),SC7->(TRANSFORM(C7_VLDESC,'@E 9,999,999.99')))
		aAdd((oHtml:ValByName("t.8")),SC7->(TRANSFORM((C7_QUANT*C7_PRECO)+(C7_VALFRE+C7_DESPESA-C7_VLDESC),'@E 9,999,999.99')))
		aAdd((oHtml:ValByName("t.c")),SC7->C7_CONTA)
		aAdd((oHtml:ValByName("t.9")),SC7->C7_DATPRF)

		_nC7_TOTAL+=SC7->C7_TOTAL
		_nC7_VLDESC+=SC7->C7_VLDESC
		_nFRETEDESP+=SC7->(C7_VALFRE+C7_DESPESA)

		SC7->(dbSkip())

	Enddo
    
    if (lSC7Lock)

        oHtml:ValByName("CR_TOTAL",TRANSFORM(_nC7_TOTAL,'@E 99,999,999.99'))
        oHtml:ValByName("DESCONTO",TRANSFORM(_nC7_VLDESC,'@E 99,999,999.99'))
        oHtml:ValByName("FRETEDESP",TRANSFORM(_nFRETEDESP,'@E 99,999,999.99'))
        oHtml:ValByName("CR_LIQUIDO",TRANSFORM((_nC7_TOTAL-(_nC7_VLDESC+_nFRETEDESP)),'@E 99,999,999.99'))

        //-------------------------------------------------------------
        // ALIMENTA A TELA DE PROCESSO DE APROVAวรO DE PEDIDO DE COMPRA
        //-------------------------------------------------------------

        _nCHAVESCR:=TamSx3("CR_FILIAL")[1]
        _nCHAVESCR+=TamSx3("CR_TIPO")[1]
        _nCHAVESCR+=TamSx3("CR_NUM")[1]
        _cCHAVESCR:=SubStr(_cCHAVE,1,_nCHAVESCR) // 01PC123456
        dbSelectArea("SCR")
        SCR->(dbSetOrder(1))
        SCR->(dbSeek(_cCHAVESCR,.T.))

        WHILE SCR->(!EOF().AND.(CR_FILIAL+CR_TIPO+CR_NUM)==_cCHAVESCR)
            Do Case
                 Case (SCR->CR_STATUS=="01")
                 	cSituaca:="Aguardando"
                 Case (SCR->CR_STATUS=="02")
                 	cSituaca:="Em Aprovacao"
                 Case (SCR->CR_STATUS=="03")
                 	cSituaca:="Aprovado" //Iif(_nOpc == 3,"Aprovado","Reprovado")
                 Case (SCR->CR_STATUS=="04")
                 	cSituaca:="Bloqueado"
                 	lBloq:=.T.
                 Case (SCR->CR_STATUS=="05")
                 	cSituaca:=Iif(_nOpc==3,"Nivel Liberado","Nivel Bloqueado")
                otherwise
                	cSituaca:=""
            EndCase
            _cT4:=UsrRetName(SCR->CR_USERLIB)
            _cT6:=SCR->CR_OBS
            aAdd((oHtml:ValByName("ta.2")),UsrFullName(SCR->CR_USER))
            aAdd((oHtml:ValByName("ta.3")),cSituaca)
            aAdd((oHtml:ValByName("ta.4")),IIF(EMPTY(_cT4),"",_cT4))
            aAdd((oHtml:ValByName("ta.5")),DTOC(SCR->CR_DATALIB))
            aAdd((oHtml:ValByName("ta.6")),IIF(EMPTY(_cT6),"",_cT6))
            SCR->(dbSkip())
        ENDDO

        // ARRAY DE RETORNO
        aWFReturn[WF_ID]:=oProcess:fProcessId
        aWFReturn[WF_DTLIMITE]:=_aTimeOut[1]
        aWFReturn[WF_HRLIMITE]:=_aTimeOut[2]
        aWFReturn[WF_DTVALIDA]:=_aTimeOut[3]
        aWFReturn[WF_HRVALIDA]:=_aTimeOut[4]
        aWFReturn[WF_HTMLFILE]:=""
        oHtml:ValByName("data_hora",DTOC(MSDATE())+" as "+LEFT(TIME(),5))
        oProcess:nEncodeMime:=0

        DO CASE
            CASE (_nOpc==1)
                    cSubject:=oProcess:cSubject
                    // start workflow
                    cProcess:=oProcess:Start("\workflow\wfpc\")
                    // para gravar o nome do html na SCR
                    aWFReturn[WF_HTMLFILE]:=cProcess
                    aSize(aMsg,0)
                    aAdd(aMsg,"Sr. Aprovador,")
                    aAdd(aMsg,"<br></br>")
                    aAdd(aMsg,'O <a href="'+_cHttp+'/workflow/wfpc/' +alltrim(cProcess)+'.htm">Pedido de Compra No.: '+_cNum+'</a> aguarda seu parecer.')
                    aAdd(aMsg,"<br></br>")
                    aAdd(aMsg,"<br></br>")
                    _cEmail+= ";tmoraes@t4f.com.br"
                    U_MailNotify(_cEmail,cSubject,aMsg)
            OTHERWISE
                oProcess:cTo:=_cTo
                oProcess:Start()
        END CASE
        
        for nSC7Recno:=(nSC7Recno+1) to nSC7Recnos
            SC7->(dbGoTo(aSC7RecNos[nSC7Recno]))
            if SC7->(RecLock("SC7",.F.))
                SC7->C7_WF:=IF((_nOpc==1),"0","1")
                SC7->(MsUnLock())
            endif
        next nSC7Recno

        aWFReturn[WF_START]:=.T.
        
    endif
        
return(aWFReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTimeOUT   บAutor  ณMicrosiga           บ Data ณ  10/22/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP7 TimeOut -                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TimeOut() //wfout
	
	Local aMsg:={}
	Local _cQuery
	Local _nQtdEnvio:=GetNewPar("MV_XQTDENV",3)// DEFINE O QTD DE ENVIO WF
	Local cTmp:=GetNextAlias()

	_cHttp:=GetNewPar("MV_WFDHTTP","http://COMPAQ:91/workflow")

  	_cQuery := "SELECT DISTINCT "
  	_cQuery += " 	 SC7.C7_USER"
  	_cQuery += " 	,SC7.C7_FILIAL"
  	_cQuery += " 	,SC7.C7_NUM"
  	_cQuery += " 	,SC7.C7_FORNECE"
  	_cQuery += " 	,SC7.C7_LOJA"
  	_cQuery += " 	,SC7.C7_EMISSAO"
  	_cQuery += " 	,SC7.C7_APROV"
  	_cQuery += " 	,SCR.CR_WFLINK"
  	_cQuery += " 	,SCR.CR_FILIAL"
  	_cQuery += " 	,SCR.CR_TIPO"
  	_cQuery += " 	,SCR.CR_NUM"
  	_cQuery += " 	,SCR.CR_NIVEL"
  	_cQuery += " 	,SCR.CR_USER"
  	_cQuery += " 	,SCR.CR_APROV"
  	_cQuery += " 	,SCR.CR_TOTAL"
  	_cQuery += " 	,SCR.CR_DTLIMIT"
  	_cQuery += " 	,SCR.CR_HRLIMIT"
  	_cQuery += " 	,SCR.CR_XQTDENV"
  	_cQuery += " FROM "+RetSqlName("SCR")+" SCR"
  	_cQuery += " JOIN "+RetSqlName("SC7")+" SC7 
  	_cQuery += "   ON (C7_FILIAL='"+xFilial('SC7')+"' "
  	If Upper(TcGetDb())=="ORACLE"
  		_cQuery += " AND SC7.C7_NUM=TRIM(SCR.CR_NUM)"
  	Else
	  	_cQuery += " AND SC7.C7_NUM=TRIM(SCR.CR_NUM)"
	EndIf
  	_cQuery += "  AND SC7.C7_APROV<>'      '"
  	_cQuery += "  AND SC7.C7_CONAPRO='B'"
  	_cQuery += "  AND SC7.D_E_L_E_T_=' ')"
  	_cQuery += " JOIN "+RetSqlName("SAL")+" SAL"
  	_cQuery += "   ON (SAL.AL_FILIAL = '"+xFilial('SAL')+"' AND SAL.AL_COD=SC7.C7_APROV AND SAL.AL_APROV=SCR.CR_APROV AND SAL.D_E_L_E_T_=' ')"
  	_cQuery += " WHERE SCR.D_E_L_E_T_=' '"
  	_cQuery += "   AND SCR.CR_FILIAL='"+xFilial('SCR') +"'"
  	_cQuery += "   AND SCR.CR_STATUS='02'"
  	_cQuery += "   AND SCR.CR_TIPO='PC'"
  	_cQuery += "   AND SCR.CR_DTLIMIT<='"+DTOS(MSDATE())+"'"
  	_cQuery += "   AND SCR.CR_WF='1'"
  	_cQuery += "   AND SCR.CR_WFID<>' '"
	// DEFINE QUE ENQUANTO A QTD DE ENVIO FOR MENOR QUE _nQtdEnvio O SISTEMA FAZ O LOOP..
  	_cQuery += "   AND SCR.CR_XQTDENV<"+NToS(_nQtdEnvio)
  	_cQuery += " ORDER BY SC7.C7_USER"
  	_cQuery += " 		 ,SCR.CR_DTLIMIT"
  	_cQuery += " 		 ,SCR.CR_HRLIMIT"

	TCQUERY (_cQuery) NEW ALIAS (cTMP)

	IF (cTMP)->(!Eof())

		_cUser:=""

		// WF-Workflow TO-TimeOut SA-Solicitacao Armazem -- caracter
		_cTimeOut:=GetNewPar("MV_WFTOPC","24:00")

		While (cTMP)->(!Eof())

			IF (cTMP)->CR_DTLIMIT == DTOS(MSDATE())
				IF (cTMP)->CR_HRLIMIT>LEFT(TIME(),5)
					(cTMP)->(dbSkip())
					LOOP
				ENDIF
			ENDIF

			IF _cUser<>(cTMP)->C7_USER
				_cUser:=(cTMP)->C7_USER
				_aReg:={}
			ENDIF

			// TimeOut - Dias       numerico 04
			_nDD:=GetNewPar("MV_WFTODD",0)
			_cTimeOut:=_cTimeOut
			_nTimeOut:=(_nDD*24)+VAL(LEFT(_cTimeOut,2))+(VAL(RIGHT(_cTimeOut,2))/60)
			_aTimeOut:=U_GetTimeOut(_nTimeOut,StoD((cTMP)->CR_DTLIMIT),(cTMP)->CR_HRLIMIT)

			dbSelectArea("SCR")
			SCR->(dbSetOrder(2))
			SCR->(dbSeek((cTMP)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)))
			IF SCR->(FOUND())
				if SCR->(RECLOCK("SCR",.F.))
					SCR->CR_DTLIMIT:=_aTimeOut[3]	 // ALTERADO [1] PARA [3] PARA RECEBER A NOVA DATA NO CAMPO CR_DTLIMIT //ANDRE
					SCR->CR_HRLIMIT:=_aTimeOut[2]
					SCR->CR_XQTDENV:=SCR->CR_XQTDENV+1  // INCREMENTADO ESTA LINHA PARA RECEBER A QTD DE ENVIO DO WF
					SCR->(MSUNLOCK())
				endif
			ENDIF

			(cTMP)->(;
						aAdd(_aReg,{;
										C7_FILIAL+"-"+C7_NUM,;
										DTOC(STOD(C7_EMISSAO)),;
										C7_FORNECE,;
										DTOC(STOD(CR_DTLIMIT))+'-'+CR_HRLIMIT,;
										CR_NIVEL,;
										UsrRetName(CR_USER),;
										UsrRetMail(CR_USER);
								    };
						);
			)

			cTo:=UsrRetMail((cTMP)->CR_USER)
			cTitle:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - TimeOut Pedido de Compras No."+(cTMP)->C7_FILIAL+"-"+(cTMP)->C7_NUM

			aSize(aMsg,0)
			aAdd(aMsg,Dtoc(MSDate())+" - "+Time()+" Sr Aprovador: "+UsrFullName((cTMP)->CR_USER))
			aAdd(aMsg,'O <a href="'+_cHttp+'/workflow/wfpc/' +alltrim((cTMP)->CR_WFLINK)+'.htm">Pedido de Compra No.: '+ Alltrim(SM0->M0_NOME)+":" +(cTMP)->C7_FILIAL+"-"+(cTMP)->C7_NUM+'</a> encontra-se pendente de sua aprova็ใo .')

			U_MailNotify(cTo,cTitle,aMsg)

			(cTMP)->(dbSkip())

		END

	EndIf

	dbSelectArea(cTMP)
	(cTMP)->(dbCloseArea())
	dbSelectArea("SCR")

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTO_NOTIF  บAutor  ณMicrosiga           บ Data ณ  10/22/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ AP7 TimeOut - Notificacao                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TO_Notif(_cUser,_aReg)

	_cTo:=UsrRetMail(_cUser)

	//-------------------------------------
	//------------------- VALIDACAO
	if Empty(_cTo)

		cTitle:="Administrador do Workflow: NOTIFICACAO"
		cBody:=REPLICATE('*',80)
		cBody+= Dtoc(MSDate())+" - "+Time()+' * Ocorreu um ERRO no envio da mensagem:'
		cBody+= "Timeout PC - Usuario: "+UsrRetName(_cUser)
		cBody+= "Campo EMAIL do cadastro de usuario NAO PREENCHIDO"
		cBody+= REPLICATE('*',80)

		U_Console("TimeOutPC() - "+CHR(10)+CHR(13)+cBody)

		U_NotifyAdm(cTitle,cBody)
		RETURN
	Endif

	// WORKFLOW
	oProcess:=TWFProcess():New("000005","PC-Timeout Solicitacao de Compra / "+_cUser)
	oProcess          	:NewTask("Timeout de resposta PC Cod.User:"+_cUser,"\WORKFLOW\HTML\PCNotif_SZ.HTM")
	oProcess:cSubject:=_cPrefMsg+OemToAnsi("Timeout Pedido de Compras")
	oProcess:cTo:=_cTo
	oProcess:UserSiga:=_cUser
	oProcess:NewVersion(.T.)

	// OBJETO OHTML
  	oHtml:=oProcess:oHTML

	// CABEวALHO
	oHtml:ValByName("USER"  	,UsrRetName(_cUser))			// Usuario
	oHtml:ValByName("DATA_HORA",DTOC(MSDATE())+' - '+LEFT(TIME(),5))				// Data e hora da geracao

	For _nInd:=1 TO Len(_aReg)

		cEmail	:="  --  NAO INFORMADO -- "
		IF !EMPTY(_aReg[_nInd][7])
			cEmail:="<A href='mailto:"+_aReg[_nInd][7]+"'>"+_aReg[_nInd][7]+"</A>"
		ENDIF

		aAdd((oHtml:ValByName("t.1")),_aReg[_nInd][1])
		aAdd((oHtml:ValByName("t.2")),_aReg[_nInd][2])
		aAdd((oHtml:ValByName("t.3")),_aReg[_nInd][3])
		aAdd((oHtml:ValByName("t.4")),_aReg[_nInd][4])
		aAdd((oHtml:ValByName("t.5")),_aReg[_nInd][5])
		aAdd((oHtml:ValByName("t.6")),_aReg[_nInd][6])
		aAdd((oHtml:ValByName("t.7")),cEmail)
	  //	aAdd((oHtml:ValByName("t.10")),_aReg[_nInd][7])

	Next

	// ARRAY DE RETORNO
	oProcess:nEncodeMime:=0
	oProcess:Start()

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณEnvPCFor   บAutor  ณPedro Augusto      บ Data ณ 12/08/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบUso       ณ TV Alphaville                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _fEPCFor(_cFilial,_cNum,_cUser,_cChave,_nTotal,_dDTLimit,_cHRLimit,_nOpc,_cToFor,_cGio,cEmpAnt)

	Local _nVALMERC:=0
	Local _nVALIPI:=0
	Local _nFRETE:=0
	Local _nSEGURO:=0
	Local _nDESCONTO:=0
	Local _nDESPESA:=0
	Local _nVALTOT:=0
	
	Local cModelHtml:=""
	
	Local cC7Filial
	Local cBMFilial   

	// Incluido GSABINO 2019_02_22 _ Dando erro de variavel not exist - Informa??o do Thiago             
	Local cB1Filial:=xFilial("SB1")             
	
	// prepare environment empresa "08" filial _cFilial
	prepare environment empresa cEmpAnt filial _cFilial
	
	If valtype(_cGio) <> 'C'
        Private _cGio:=' '
	EndIf
	
	_cChaveSCR:=PADR(_cFilial+'PC'+_cNum,60)
	_cNum:=PADR(ALLTRIM(_cNum),GetSX3Cache("C7_NUM","X3_TAMANHO"))
	
	dbSelectArea("SCR")
	SCR->(dbSetOrder(2))
	SCR->(dbSeek(_cChave))
	
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+cFilAnt))
	
	dbSelectArea("SC7")
	cC7Filial:=xFilial("SC7",_cFilial)
	SC7->(dbSetOrder(1))
	SC7->(dbSeek(cC7Filial+_cNum))
	
	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
	
	dbSelectArea("SE4")
	SE4->(dbSetOrder(1))
	SE4->(dbSeek(xFilial("SE4")+SC7->C7_COND))
	
	_cTo:=_cToFor
	_cVersao:=""
	
	dbSelectArea("SCY")
	SCY->(dbSetOrder(1))
	SCY->(dbSeek(_cFilial+_cNum))
	
	While SCY->(!EOF().AND.(CY_FILIAL+CY_NUM==_cFilial+_cNum))
		_cVersao:=Alltrim(SCY->CY_VERSAO)
		SCY->(dbSkip())
	Enddo
	
	//tratamento de HTML diferente para cada umas das empresas
	do case
	case SM0->M0_CODIGO == "08"
	    cModelHtml:="\WORKFLOW\HTML\PCRESP_FN08.HTM"
	case SM0->M0_CODIGO == "09"
	    cModelHtml:="\WORKFLOW\HTML\PCRESP_FN09.HTM"
	case SM0->M0_CODIGO == "15"
	    cModelHtml:="\WORKFLOW\HTML\PCRESP_FN15.HTM"
	case SM0->M0_CODIGO == "16"
	    cModelHtml:="\WORKFLOW\HTML\PCRESP_FN16.HTM"
	case SM0->M0_CODIGO == "20"
	    cModelHtml:="\WORKFLOW\HTML\PCRESP_FN20.HTM"
	case SM0->M0_CODIGO == "25"
	    cModelHtml:="\WORKFLOW\HTML\PCRESP_FN25.HTM"
	case SM0->M0_CODIGO == "32"
	    cModelHtml:="\WORKFLOW\HTML\PCRESP_FN32.HTM"
	endcase
	
	U_CONSOLE("Chamando _fEPCFor: enviando email")
	oProcess:=TWFProcess():New("000006","Envio p/fornecedor PC aprovado: "+_cFilial+"/"+TRIM(_cNum))
	oProcess:NewTask("Envio PC aprovado: "+_cFilial+_cNum,cModelHtml)
	
	oProcess:cTo:=_cTo
	
	oHtml:=oProcess:oHTML
	
	//Cabecalho//
	// oHtml:ValByName("C7_FILIAL",SM0->M0_FILIAL)
	oHtml:ValByName("C7_NUM",SC7->C7_NUM)
	oHtml:ValByName("C7_EMISSAO",DTOC(SC7->C7_EMISSAO))
	
	//Dados Empresa
	oHtml:ValByName("C_NOME",SM0->M0_NOMECOM)
	oHtml:ValByName("C_CNPJ",Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")))
	oHtml:ValByName("C_ENDER",Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_CIDCOB) +" - "+Alltrim(SM0->M0_ESTCOB))
	oHtml:ValByName("C_CEP",SM0->M0_CEPCOB)
	oHtml:ValByName("C_TELFAX",Alltrim(SM0->M0_TEL)+Iif(Alltrim(SM0->M0_FAX) == "",""," / "+SM0->M0_FAX))
	
	If SC7->C7_XTPCPR $ "E,D"
        _cCont:=Posicione ("SC1",1,xFilial("SC1")+SC7->C7_NUMSC,"C1_USER")
	ELSE
        _cCont:=SC7->C7_USER
	ENDIF
	
	oHtml:ValByName("C_CONTATO",UsrFullName(_cCont))
	oHtml:ValByName("C_EMAIL",UsrRetMail(_cCont))
	oHtml:ValByName("MAILRESP",UsrRetMail(_cCont))
	
	//Dados Fornecedor
	oHtml:ValByName("V_NOME",SA2->A2_NOME)
	oHtml:ValByName("V_CNPJ",Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC")))
	oHtml:ValByName("V_ENDER",Alltrim(SA2->A2_END)+" - " +Alltrim(SA2->A2_NR_END)+" - "+Alltrim(SA2->A2_MUN) +" - "+Alltrim(SA2->A2_EST))
	oHtml:ValByName("V_CEP",SA2->A2_CEP)
	oHtml:ValByName("V_TELFAX",Alltrim(SA2->A2_TEL)+Iif(Alltrim(SA2->A2_FAX) == "",""," / "+SA2->A2_FAX))
	oHtml:ValByName("V_CONTATO",SA2->A2_CONTATO)
	oHtml:ValByName("V_EMAIL",SC7->C7_XMAILF)
	
	//Dados cond. pagamento
	oHtml:ValByName("E4_DESCRI",SE4->E4_DESCRI)
	
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(dbSeek(cEmpAnt+SC7->C7_FILENT))
	
	// Dados local entrega
	/*  //comentado - Vitor 07/11/13
	oHtml:ValByName("E_NOME",SM0->M0_NOMECOM)
	oHtml:ValByName("E_CNPJ",Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")))
	oHtml:ValByName("E_ENDER",Alltrim(SM0->M0_ENDENT)+" - "+Alltrim(SM0->M0_CIDENT) +" - "+Alltrim(SM0->M0_ESTENT))
	oHtml:ValByName("E_CEP",SM0->M0_CEPCOB)
	*/
	//Inf.Adicionais
	oHtml:ValByName("C7_XOBSFO",SC7->C7_XOBSFO)
	
	SB1->(dbSetOrder(1))
	
	SBM->(dbSetOrder(1))
	cBMFilial:=xFilial("SBM")
	
	//-------------------------------------------------------------
	// ALIMENTA A TELA DE ITENS DO PEDIDO DE COMPRA
	//-------------------------------------------------------------
	While SC7->(!EOF().and.(C7_FILIAL==cC7Filial).and.(C7_NUM==_cNum))
	
		Select SB1
		Seek xFilial()+SC7->C7_PRODUTO
//        SB1->(dbSeek(cC7Filial+SC7->C7_PRODUTO))
        SBM->(MsSeek(cBMFilial+SB1->B1_GRUPO))
        
        aAdd((oHtml:ValByName("t.1")),SC7->C7_ITEM)
        aAdd((oHtml:ValByName("t.2")),SC7->C7_PRODUTO)
        aAdd((oHtml:ValByName("t.3")),Alltrim(SB1->B1_DESC))
        aAdd((oHtml:ValByName("t.4")),iif(_cGio='x',SB1->B1_UM,'b'))
        aAdd((oHtml:ValByName("t.5")),Alltrim(TRANSFORM(SC7->C7_QUANT,'@E 9,999,999,999.99')))
        aAdd((oHtml:ValByName("t.6")),Alltrim(TRANSFORM(SC7->C7_PRECO,'@E 9,999,999,999.99')))
        aAdd((oHtml:ValByName("t.7")),Alltrim(TRANSFORM(SC7->C7_IPI,'@E 99.99')))
        aAdd((oHtml:ValByName("t.8")),Alltrim(TRANSFORM(SC7->C7_TOTAL,'@E 9,999,999,999,999.99')))
        aAdd((oHtml:ValByName("t.9")),Alltrim(TRANSFORM(SC7->C7_PICM,'@E 99.99')))
        aAdd((oHtml:ValByName("t.10")),SC7->C7_DATPRF)
        
        _nVALMERC+=SC7->C7_TOTAL
        _nVALIPI+=SC7->C7_VALIPI
        _nFRETE+=SC7->C7_VALFRE
        _nSEGURO+=SC7->C7_SEGURO
        _nDESPESA+=SC7->C7_DESPESA
        _nDESCONTO+=SC7->C7_VLDESC
        
        SC7->(dbSkip())
	
	Enddo
	
	_nVALTOT:=(_nVALMERC+((_nVALIPI+_nFRETE+_nSEGURO+_nDESPESA)-_nDESCONTO))
	
	oHtml:ValByName("VALMERC",Alltrim(TRANSFORM(_nValmerc,'@E 9,999,999,999,999.99')))
	oHtml:ValByName("VALBRU",Alltrim(TRANSFORM(_nValmerc+_nVALIPI,'@E 9,999,999,999,999.99')))
	oHtml:ValByName("FRETE",Alltrim(TRANSFORM(_nFRETE,'@E 9,999,999,999,999.99')))
	oHtml:ValByName("SEGURO",Alltrim(TRANSFORM(_nSeguro,'@E 9,999,999,999,999.99')))
	oHtml:ValByName("DESPESA",Alltrim(TRANSFORM(_nDespesa,'@E 9,999,999,999,999.99')))
	oHtml:ValByName("DESCONTO",Alltrim(TRANSFORM(_nDesconto,'@E 9,999,999,999,999.99')))
	oHtml:ValByName("VALTOT",Alltrim(TRANSFORM(_nVALTOT,'@E 9,999,999,999,999.99')))
	
	oProcess:nEncodeMime:=0
	
	oProcess:cSubject:="WORKFLOW  - Pedido de compra "+_cNum+Iif(_cVersao<>""," Revisใo: "+_cVersao,"")+" - APROVADO"
	oProcess:Start()

return .T.

//fun็ใo para pegar o e-mail da sc
User Function _fRMSol(cNumSC)

	Local aArea:=GetArea()
	Local aAreaSC1:=SC1->(GetArea())
	Local cEmail:=""
	
	cNumSC:=PADR(Alltrim(cNumSC),TamSX3("C1_NUM")[1])
	
	SC1->(dbSetOrder(1))
	If !Empty(cNumSC).and.SC1->(dbSeek(xFilial("SC1")+cNumSC))
		cEmail:=Alltrim(UsrRetMail(SC1->C1_USER))
	EndIf
	
	RestArea(aAreaSC1)
	RestArea(aArea)
	
Return(cEmail)

Static Function fTCOMM1(cNumPed,cFilPed)

	Local cQuery:=""
	Local cAliasPed:=GetNextAlias()
	Local lRet:=.T.

	cQuery:="SELECT SCR.CR_NUM "
	cQuery+= "  FROM "+RetSqlName("SCR")+" SCR"
	cQuery+= " WHERE SCR.CR_NUM='"+cNumPed+"'"
	cQuery+= "   AND SCR.CR_FILIAL='"+cFilPed+"'"
	cQuery+= "   AND SCR.CR_DATALIB<>' ' "
	cQuery+= "   AND SCR.D_E_L_E_T_=' '"
	
	TCQUERY (cQuery) NEW ALIAS (cAliasPed)

	If (cAliasPed)->(!EOF())
		lRet:=.F.
	EndIf
	
	(cAliasPed)->(dbCloseArea())
	
	dbSelectArea("SCR")

Return(lRet)

Static Procedure OutMessage(cMsg)
    PTInternal(1,cMsg)
	#IFDEF TOP
		TCInternal(1,cMsg)    
	#ENDIF
    U_CONSOLE(cMsg)
	Return    
