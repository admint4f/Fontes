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
User Function T4FMED01(aParamEmp)

	Local _aEmp //aParamEmp:= {'08','02'}

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

	cMsg:='['+cProcName+']: T4F - T4FMED01 : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Fun: "+cFun
	OutMessage(cMsg)

	If aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U"

		cEmp:=aParamEmp[1]
		cFil:=aParamEmp[2]

		cMsg:='['+cProcName+']: T4F - T4FMED01 : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
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

			U_CONSOLE("T4FMED01 - MD() / ["+cNameLck+"] Empresa["+cEmpAnt+"] | Filial["+cFilAnt+"] Iniciado com Sucesso")

			cMsg:='['+cProcName+']: T4F - U__T4FMED01(1) : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)
			U__T4FMED01(1)	// 1 - Envio CTR PARA APROVADORES
			cMsg:='['+cProcName+']: T4F - U__T4FMED01(1) : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

			cMsg:='['+cProcName+']: T4F - U__T4FMED01(3) : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)
			U__T4FMED01(3)	// 3 - Envio CTR ITENS APROVADOS PARA SOLICITANTE
			cMsg:='['+cProcName+']: T4F - U__T4FMED01(3) : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

			cMsg:='['+cProcName+']: T4F - U__T4FMED01(4) : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)
			U__T4FMED01(4) // 4 - Envio CTR ITENS REPROVADOS PARA SOLICITANTE
			cMsg:='['+cProcName+']: T4F - U__T4FMED01(4) : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

			cMsg:='['+cProcName+']: T4F - U__T4FMED01(5) : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)
			U__T4FMED01(5)	// 5 - ENVIO DA NOTIFICAO POR TIMEOUT
			cMsg:='['+cProcName+']: T4F - U__T4FMED01(5) : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

			UnLockByName(@cNameLck,@lEmpLck,@lFilLck,@lMayIUseDisk)

			cMsg:='['+cProcName+']: T4F - UnLockByName : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
			OutMessage(cMsg)

		Else

			U_CONSOLE("T4FMED01 - MD() / ["+cNameLck+"] Empresa["+cEmpAnt+"] | Filial["+cFilAnt+"] Em Execuo por outra Instancia")

		EndIF

		if (l_svEmpFil)
			RpcSetEnv(c_svEmpAnt,c_svFilAnt)
		else
			RpcClearEnv()
		endif

		cMsg:='['+cProcName+']: T4F - T4FMED01 : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
		OutMessage(cMsg)

	EndIf

Return(NIL)

User Function _T4FMED01(_nOpc,oProcess,oProcesf)

	Local aMsg:={}
	Local aWFReturn

	Local cMsg
	Local _cIndex,_cFiltro,_cOrdem
	Local _cFilial,_cOpcao,_cObs
	Local _lProcesso:=.F.
	Local _cPrefMsg:=""
	Local _cNumMED:=""
	Local _cFilMED:=""
	Local _lOkMed:=.T.

	Local cTMP		:=GetNextAlias()
	Local cTMPCND 	:=GetNextAlias()
	Local cFilter:="1=1"
	Local cCRKeySeek
	Local cCNDFilial:=xFilial("CND")
	Local cCN9Filial:=xFilial("CN9")

	Local cCRFilial:=xFilial("SCR")

	Local cWFFilial

	Local cProcName:=ProcName()

	Local cCRDTLIMIT:=DTOS(MSDATE())
	Local cCRHRLIMIT:=LEFT(TIME(),5)

	Local cSVFilAnt:=cFilAnt

	Local nSCRRecNo

	Local dEDate:=CtoD('  /  /  ')

	Local nCRNum:=GetSX3Cache("CR_NUM","X3_TAMANHO")
	Local nCNDNum:=GetSX3Cache("CND_NUMNED","X3_TAMANHO")
	Local nCNDRecNo
	Local nSA2RecNo

	Local lRet:=.T.

	Private aCNDRecNos:=Array(0)

	cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
	OutMessage(cMsg)

	ChkFile("SE4")
	ChkFile("SC1")
	ChkFile("SC8")
	ChkFile("SA2")
	ChkFile("SB1")
	ChkFile("SBM")
	ChkFile("SCR")
	ChkFile("CND")
	ChkFile("CN9")
	ChkFile("SAL")
	ChkFile("SCS")
	ChkFile("SAK")

	BEGIN SEQUENCE

		DO 	CASE

			/*
			//?
			//1 - Prepara os pedidos a serem enviados para aprovacao
			//
			*/
		CASE (_nOpc==1)

			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

			U_CONSOLE("T4FMED01 - 1 - Prepara as medições/contratos a serem enviados para aprovacao")
			U_CONSOLE("T4FMED01 - 1 - EmpFil:"+cEmpAnt+cFilAnt)

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
			_cQuery += " 	,SCR.CR_XCONTRA"
			_cQuery += " 	,SCR.CR_XREVISA"
			_cQuery += "  FROM "+RetSqlName("SCR")+" SCR"
			_cQuery += " WHERE SCR.D_E_L_E_T_<>'*'"
			_cQuery += "   AND SCR.CR_FILIAL='"+cFilAnt+"'"
			_cQuery += "   AND SCR.CR_TIPO IN ('MD','CT','RV')"
			_cQuery += "   AND SCR.CR_STATUS='02'"
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

				If (cTMP)->CR_TIPO == 'MD'

					CND->(dbSetOrder(7))
					CND->(MsSeek(cCNDFilial+(cTMP)->CR_XCONTRA+(cTMP)->CR_XREVISA+(cTMP)->CR_NUM))

					IF EMPTY(CND->CND_APROV)

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

						aWFReturn:=(cTMP)->(EnvMED(CR_FILIAL,CR_NUM,CR_USER,(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER),CR_TOTAL,STOD(CR_DTLIMIT),CR_HRLIMIT,_nOpc,CR_XCONTRA,CR_XREVISA))

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

				ElseIf (cTmp)->CR_TIPO == 'CT' .OR. (cTmp)->CR_TIPO == 'RV'

					CN9->(dbSetOrder(1))
					CN9->(MsSeek(cCN9Filial+(cTMP)->CR_XCONTRA+(cTMP)->CR_XREVISA))

					IF EMPTY(CN9->CN9_APROV)

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

						aWFReturn:=(cTMP)->(EnvMED(CR_FILIAL,CR_NUM,CR_USER,(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER),CR_TOTAL,STOD(CR_DTLIMIT),CR_HRLIMIT,_nOpc,CR_XCONTRA,CR_XREVISA))

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
			//?
			//2 - Processa O RETORNO DO EMAIL                       
			//
			*/
		CASE (_nOPC==2)


			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

			U_CONSOLE("T4FMED01 - 2 - Processa O RETORNO DO EMAIL")
			U_CONSOLE("T4FMED01 - 2 - EmpFil:"+cEmpAnt+cFilAnt)
			U_CONSOLE("T4FMED01 - 2 - Semaforo Vermelho")

			if !LockByName("WFMED",.T.,.T.,.T.)
				cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): BREAK : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
				OutMessage(cMsg)
				break
			endif

			cWFFilial:=alltrim(oProcess:oHtml:RetByName("CFILANT"))
			if .not.(cWFFilial==alltrim(cFilAnt))
				RpcSetType(3)
				RpcSetEnv(cEmp,cWFFilial)
				U_CONSOLE("T4FMED01 - 2 - EmpFil (WF):"+cEmpAnt+cFilAnt)
			endif

			if !LockByName("WFMED",.T.,.T.,.T.)
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

			U_CONSOLE("T4FMED01 - 2 - cFilAnt:"+cFilAnt)
			U_CONSOLE("T4FMED01 - 2 - Chave:"+cChaveSCR)
			U_CONSOLE("T4FMED01 - 2 - Opc:"+cOpc)
			U_CONSOLE("T4FMED01 - 2 - Obs:"+cObs)
			U_CONSOLE("T4FMED01 - 2 - WFId:"+cWFID)
			U_CONSOLE("T4FMED01 - 2 - cTo:"+cTo)

			IF (cOpc$"S|N")  // Aprovacao S-Sim N-Nao
				ChkFile("SCR")
				ChkFile("SAL")
				ChkFile("CND")
				ChkFile("CN9")
				ChkFile("SCS")
				ChkFile("SAK")
				ChkFile("SM2")
				// Posiciona na tabela de Alcadas
				dbSelectArea("SCR")
				SCR->(dbSetOrder(2))
				SCR->(MsSeek(cChaveSCR))
				IF SCR->(!FOUND().OR.TRIM(SCR->CR_WFID)<>TRIM(cWFID))
					//"Este processo nao foi encontrado e portanto deve ser descartado
					// abre uma notificacao a pessoa que respondeu
					U_CONSOLE("T4FMED01 - 2 - Processo nao encontrado:"+cWFID+" Processo atual:"+SCR->CR_WFID)
					U_CONSOLE("T4FMED01 - 2 - Semaforo Verde")
					UnLockByName("WFMED",.T.,.T.,.T.)
					lRet:=.T.
					cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): BREAK : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
					OutMessage(cMsg)
					BREAK
				ENDIF

				If SCR->(Reclock("SCR",.F.))
					SCR->CR_WF:="2"	// Status 2 - respondido
					SCR->CR_OBS:=cObs
					SCR->(MSUnlock())
				EndIf
				If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
					U_CONSOLE("T4FMED01 - 2.1 - Processo respondido anteriormente:"+cWFID)
					U_CONSOLE("T4FMED01 - 2.1 - Semaforo Verde")
					cSubject:=_cPrefMsg+ Alltrim(SM0->M0_NOME)+" - AVISO - Contrato No. "+Substr(cChaveSCR,5,6) +" respondido anteriormente"
					_cEmail:=UsrRetMail(Substr(cChaveSCR,55,6))
					aSize(aMsg,0)
					aAdd(aMsg,"Sr. Aprovador,")
					aAdd(aMsg,"<br></br>")
					aAdd(aMsg,'O Contrato No.: '+Substr(cChaveSCR,5,6)+' foi anteriormente '+SCR->CR_OBS)
					aAdd(aMsg,"<br></br>")
					aAdd(aMsg,"<br></br>")
					U_MailNotify(_cEmail,cSubject,aMsg)
					UnLockByName("WFMED",.T.,.T.,.T.)
					lRet:=.T.
					cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): BREAK : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
					OutMessage(cMsg)
					BREAK
				EndIf

				// REPosiciona na tabela de Alcadas
				dbSelectArea("SCR")
				SCR->(dbSetOrder(2))
				SCR->(MsSeek(cChaveSCR))

				// verifica quanto a saldo de alada para aprovao
				// Se valor do pedido estiver dentro do limite Maximo e minimo
				// Do aprovador,utiliza o controle de saldos,caso contrrio nao
				// faz o tratamento como vistador.
				nTotal:=SCR->CR_TOTAL
				lLiberou:=U_MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,SCR->CR_APROV,,SCR->CR_APROV,,,,,cObs},msdate(),If(cOpc=="S",4,6))

				U_CONSOLE("T4FMED01 - 2 - Liberado:"+IIF(lLiberou,"Sim","Nao"))
				U_CONSOLE("T4FMED01 - 2 - Medio:"+CND->CND_NUMERO)
				_lProcesso:=.T.

				_cNumMED:=Alltrim(SCR->CR_NUM)
				_cFilMED:=SCR->CR_FILIAL
				_lOkMed:=FTMED1(_cFilMED,SCR->CR_XCONTRA,SCR->CR_XREVISA,SCR->CR_NUM,SCR->CR_TIPO)

				If _lOkMed .AND. cOpc == "S"
					If SCR->CR_TIPO == 'MD'
						_nRecCNDBkp:=CND->(RecNo())

						dbSelectArea("CND")
						CND->(dbSetOrder(7))

						If CND->(MsSeek(cCNDFilial+SCR->CR_XCONTRA+SCR->CR_XREVISA+SCR->CR_NUM))
							While CND->(!Eof()) .And. CND_FILIAL==cCNDFilial .AND. Alltrim(CND->CND_CONTRA)==Alltrim(SCR->CR_XCONTRA) .AND. CND->CND_REVISA==SCR->CR_XREVISA .AND. Alltrim(CND->CND_NUMMED)==Alltrim(SCR->CR_NUM)
								If CND->(Reclock("CND",.F.))
									CND->CND_ALCAPR:="L"
									CND->CND_SITUAC:="A"
									CND->(MsUnlock())
								EndIf
								CND->(dbSkip())
							EndDo
						EndIf

					ElseIf SCR->CR_TIPO == 'CT' .OR. SCR->CR_TIPO == 'RV'

						_nRecCN9Bkp:=CN9->(RecNo())

						dbSelectArea("CN9")
						CN9->(dbSetOrder(1))

						If CN9->(MsSeek(cCN9Filial+SCR->CR_XCONTRA+SCR->CR_XREVISA))

							If SCR->CR_TIPO == 'CT'
								CN100SitCh(CN9->CN9_NUMERO,CN9->CN9_REVISA,"05",,.F.)	
							Else
								CN300Aprov(.T.) //aprovação de revisões
								//CN100SitCh(CN9->CN9_NUMERO,CN9->CN9_REVISA,"10",,.F.)
							EndIf

							If (GetNewPar( "MV_CNPROVI" ,  "S" ) == "S") .AND. SCR->CR_TIPO == 'CT'
								CN100CTit(CN9->CN9_NUMERO,CN9->CN9_REVISA) //Gera Titulos provisorios
								CN100RecTi(CN9->CN9_NUMERO,CN9->CN9_REVISA) //Gera Titulos provisorios recorrentes
							EndIf
						EndIf
					EndIf

				EndIf

				_lOkMed	:=	BLQCTR(SCR->CR_FILIAL,SCR->CR_XCONTRA,SCR->CR_XREVISA)

				If (!_lOkMed)
					If SCR->CR_TIPO == 'CT' .OR. SCR->CR_TIPO == 'RV'
						dbSelectArea("CN9")
						CN9->(dbSetOrder(1))

						If CN9->(MsSeek(cCN9Filial+SCR->CR_XCONTRA+SCR->CR_XREVISA))
							CN100SitCh(CN9->CN9_NUMERO,CN9->CN9_REVISA,"11",,.F.)
						EndIf
					EndIf
				EndIf

				cTipo2	:=	SCR->CR_TIPO
				cRNum 	:=	SCR->CR_NUM
				
				dbSelectArea("SCR")
				SCR->(dbSetOrder(1))
				If SCR->(MsSeek(xFilial("SCR")+cTipo2+cRNum))
					If SCR->CR_STATUS == '03'
						cProxNiv:= STRZERO(VAL(SCR->CR_NIVEL )+1,2)
						SCR->(dbSkip())
						While (SCR->(!EOF()) .AND. SCR->CR_NUM==cRNum)
							IF SCR->CR_NIVEL > cProxNiv 
								exit
							END
							If (SCR->CR_STATUS == '01' .And. SCR->CR_WF==" ")
								SCR->(Reclock("SCR",.F.))
								SCR->CR_STATUS:="02"	// Status 2 - respondido
								SCR->(MSUnlock())
							ELSEIf SCR->CR_STATUS == '03'
								cProxNiv:= STRZERO(VAL(SCR->CR_NIVEL )+1,2)
							EndIf
							SCR->(dbSkip())
						END
					EndIf



				EndIf

				If lLiberou
					_nRecCNDBkp:=CND->(RecNo())     //vitor
					_cNumMED:=Alltrim(CND->CND_NUMMED)
					dbSelectArea("SCR")
					SCR->(dbSetOrder(1))
					If SCR->(MsSeek(cCRFilial+PadR(_cNumMED,nCRNum)))
						While SCR->(!Eof().And.(CR_FILIAL+PadR(CR_NUM,nCNDNum)==CND->(CND_FILIAL+CND_NUMMED)))
							If Empty(SCR->CR_DATALIB)
								lLiberou:=.F.
								EXIT
							EndIf
							SCR->(dbSkip())
						EndDo
					EndIf

				EndIf

			EndIf

			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

			UnLockByName("WFMED",.T.,.T.,.T.)

			U_CONSOLE("T4FMED01 - 2 - Semaforo Verde")

			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

			/*
			//?
			//3 - Envia resposta de pedido aprovado para o comprador 
			//
			*/
		CASE _nOpc == 3


			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

			U_CONSOLE("T4FMED01 - 3 - Envia resposta de contrato APROVADO para o comprador")
			U_CONSOLE("T4FMED01 - 3 - EmpFil:"+cEmpAnt+cFilAnt)

			cFilter:="%("+cFilter+")%"

			//CONTRATOS

			BEGINSQL Alias cTMP
					SELECT CN9.R_E_C_N_O_ CN9RECNO
				  	  FROM %table:CN9% CN9
				  	 WHERE CN9.CN9_FILIAL=%xFilial:CN9%
					   AND CN9.CN9_SITUAC='05'
					   AND CN9.CN9_APROV<>'      '
				       AND CN9.CN9_WF<>'1'
					   AND CN9.%NotDel%
				       AND (%exp:cFilter%)
         		       AND EXISTS (
	         				SELECT DISTINCT 1
	         				  FROM %table:SCR% SCR
	         				 WHERE SCR.%NotDel%
					  		   AND SCR.CR_FILIAL=CN9.CN9_FILIAL
						       AND SCR.CR_TIPO IN ('CT','RV')
				 			   AND SCR.CR_STATUS='03'
				 			   AND SCR.CR_LIBAPRO<>' '
							   AND TRIM(SCR.CR_NUM)=CN9.CN9_NUMERO
					  )
				  	ORDER BY CN9.CN9_FILIAL
							,CN9.CN9_NUMERO
			ENDSQL

			SCR->(dbSetOrder(1))

			While (cTMP)->(!Eof())

				nCN9RecNo:=(cTMP)->CN9RECNO

				CN9->(dbGoTo(nCN9RecNo))

				_cNum:=CN9->CN9_NUMERO

				cCRKeySeek:=CN9->CN9_FILIAL
				cCRKeySeek+="CT"
				cCRKeySeek+=PadR(_cNum,nCRNum)

				_lAchou:=.F.
				_lAprov:=.F.
				_cChave:=''
				_nTotal:=0

				SCR->(MsSeek(cCRKeySeek,.T.))

				//TODO: Verificar Corretamente a ALÇADA
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
					CN9->(MsGoTo(nCN9RecNo))
					If CN9->(Reclock("CN9",.F.))
						CN9->CN9_WF:="1"   	// Status 1 - enviou email
						CN9->(MSUnlock())
					EndIf
				ENDIF

				DbSelectArea("CNN")
				Set Filter TO CNN_USRCOD<>' ' .AND. CNN_FILIAL == CN9->CN9_FILIAL .AND.  CNN_CONTRA = CN9->CN9_NUMERO
				CNN->(dbSetOrder(1))
				DbGotop()
				cUser := CNN->CNN_USRCOD

				IF _lAprov

					aWFReturn:=CN9->(EnvMED(CN9_FILIAL,CN9_NUMERO,cUser,_cChave,_nTotal,dEDate,'     ',_nOpc))

					If (Len(aWFReturn)>0)

						CN9->(MsGoTo(nCN9RecNo))
						If CN9->(Reclock("CN9",.F.))
							CN9->CN9_WF:=IF(!(aWFReturn[WF_START]),CN9->CN9_WF,"1")   // Status 1 - envio email / branco -nao enviado
							CN9->(MSUnlock())
						EndIf

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
			dbSelectArea("CN9")

			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName

			OutMessage(cMsg)

			//MEDIÇÕES

			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

			U_CONSOLE("T4FMED01 - 3 - Envia resposta das medições aprovadas para o comprador")
			U_CONSOLE("T4FMED01 - 3 - EmpFil:"+cEmpAnt+cFilAnt)

			cFilter:="%("+cFilter+")%"

			BEGINSQL Alias cTMPCND
					SELECT CND.R_E_C_N_O_ CNDRECNO
				  	  FROM %table:CND% CND
				  	 WHERE CND.CND_FILIAL=%xFilial:CND%
					   AND CND.CND_ALCAPR ='L'
					   AND CND.CND_SITUAC ='A'
					   AND CND.CND_APROV<>'      '
				       AND CND.CND_WF<>'1'
					   AND CND.%NotDel%
				       AND EXISTS (
	         				SELECT DISTINCT 1
	         				  FROM %table:SCR% SCR
	         				 WHERE SCR.%NotDel%
					  		   AND SCR.CR_FILIAL=CND.CND_FILIAL
						       AND SCR.CR_TIPO='MD'
				 			   AND SCR.CR_STATUS='03'
				 			   AND SCR.CR_LIBAPRO<>' '
							   AND TRIM(SCR.CR_NUM)=CND.CND_NUMMED
							   AND SCR.CR_XCONTRA	=CND.CND_CONTRA
							   AND SCR.CR_XREVISA	=CND.CND_REVISA

					  )
				  	ORDER BY CND.CND_FILIAL
							,CND.CND_NUMMED
			ENDSQL

			SCR->(dbSetOrder(1))

			While (cTMPCND)->(!Eof())

				nCNDRecNo:=(cTMPCND)->CNDRECNO

				CND->(dbGoTo(nCNDRecNo))

				_cNum:=CND->CND_NUMMED

				cCRKeySeek:=CND->CND_FILIAL
				cCRKeySeek+="MD"
				cCRKeySeek+=PadR(_cNum,nCRNum)

				_lAchou:=.F.
				_lAprov:=.F.
				_cChave:=''
				_nTotal:=0

				SCR->(MsSeek(cCRKeySeek,.T.))

				//TODO: Verificar Corretamente a ALÇADA
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
					CND->(MsGoTo(nCNDRecNo))
					If CND->(Reclock("CND",.F.))
						CND->CND_WF:="1"   	// Status 1 - enviou email
						CND->(MSUnlock())
					EndIf
				ENDIF

				DbSelectArea("CNN")
				Set Filter TO CNN_USRCOD<>' ' .AND. CNN_FILIAL == CND->CND_FILIAL .AND.  CNN_CONTRA = CND->CND_CONTRA
				CNN->(dbSetOrder(1))
				DbGotop()
				cUser := CNN->CNN_USRCOD

				IF _lAprov

					aWFReturn:=CND->(EnvMED(CND_FILIAL,CND_NUMMED,cUser,_cChave,_nTotal,dEDate,'     ',_nOpc))

					If (Len(aWFReturn)>0)

						CND->(MsGoTo(nCNDRecNo))
						If CND->(Reclock("CND",.F.))
							CND->CND_WF:=IF(!(aWFReturn[WF_START]),CND->CND_WF,"1")   // Status 1 - envio email / branco -nao enviado
							CND->(MSUnlock())
						EndIf

						_lProcesso:=.T.

						(cTMPCND)->(dbSkip())
						Loop
					Else

						//Na ocorrencia de Erro no WF,vai para o proximo registro e continua
						(cTMPCND)->(dbSkip())
						Loop

					EndIf
				ELSE

					//Nao Aprovou. Continua...
					(cTMPCND)->(dbSkip())
					Loop

				ENDIF

				(cTMPCND)->(dbSkip())
				_lProcesso:=.T.

			END

			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

			dbSelectArea(cTMPCND)
			(cTMPCND)->(dbCloseArea())
			dbSelectArea("CND")

			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

			/*
			//?
			//4 - Envia resposta de pedido bloqueado para o comprador
			//
			*/
		CASE _nOpc == 4

			U_CONSOLE("T4FMED01 - 4 - Envia resposta de pedido bloqueado para o comprador")

			U_CONSOLE("T4FMED01 - 5 - EmpFil:"+cEmpAnt+cFilAnt)

			_cQuery := "SELECT SCR.CR_FILIAL"
			_cQuery += " 	  ,SCR.CR_TIPO"
			_cQuery += " 	  ,SCR.CR_NUM"
			_cQuery += " 	  ,SCR.CR_NIVEL"
			_cQuery += " 	  ,SCR.CR_TOTAL"
			_cQuery += " 	  ,SCR.CR_USER"
			_cQuery += " 	  ,SCR.CR_APROV"
			_cQuery += " 	  ,SCR.CR_XCONTRA"
			_cQuery += " 	  ,SCR.CR_XREVISA"
			_cQuery += "  FROM "+RetSqlName("SCR")+" SCR"
			_cQuery += " WHERE SCR.D_E_L_E_T_ <> '*'"
			_cQuery += "   AND SCR.CR_FILIAL = '"+cFilAnt+"'"
			_cQuery += "   AND SCR.CR_LIBAPRO <> '      '" 		// Seleciona o Aprovador que reprovou
			_cQuery += "   AND SCR.CR_STATUS = '04'"              // REPROVADO
			_cQuery += "   AND SCR.CR_TIPO IN ('MD','CT','RV')"                // Contrato
			_cQuery += "   AND SCR.CR_WF <> '1'"   				// 1-Enviado
			_cQuery += " ORDER BY"
			_cQuery += " 	 SCR.CR_FILIAL"
			_cQuery += " 	,SCR.CR_NUM"
			_cQuery += " 	,SCR.CR_NIVEL"
			_cQuery += " 	,SCR.CR_USER"

			TCQUERY (_cQuery) NEW ALIAS (cTMP)

			While (cTMP)->(!Eof())
				//aWFReturn:=EnvMED((cTMP)->CR_FILIAL,(cTMP)->CR_NUM,SCR->C7_USER,(cTMP)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV),(cTMP)->CR_TOTAL,ctod('  /  /  '),'     ',_nOpc)
				aWFReturn:=(cTMP)->(EnvMED(CR_FILIAL,CR_NUM,CR_USER,(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER),CR_TOTAL,ctod('  /  /  '),'     ',_nOpc,CR_XCONTRA,CR_XREVISA))
				If Len(aWFReturn)>0
					dbSelectArea("SCR")
					SCR->(dbSetOrder(2))
					IF MsSeek((cTMP)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
						if Reclock("SCR",.F.)
							SCR->CR_WF:=IF(!(aWFReturn[WF_START]),SCR->CR_WF,"1")   // Status 1 - envio para aprovadores / branco-nao houve envio
							SCR->CR_WFID:=aWFReturn[WF_ID]					        // Rastreabilidade
							SCR->(MSUnlock())
						endif
					ENDIF
				EndIf

				_lProcesso:=.T.
				(cTMP)->(dbSkip())
			End
			(cTMP)->(dbCloseArea())
			dbSelectArea("SCR")

			//?
			//5 - ENVIO de Email - Acao TIME-OUT
			//
		CASE (_nOpc==5)

			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

			U_CONSOLE("T4FMED01 - 5 - Acao TimeOut : Begin")

			CHKFile("SAL")
			CHKFile("SCR")
			CHKFile("CND")
			ChkFile("SCS")
			ChkFile("SAK")
			ChkFile("SM2")

			//TimeOut()

			U_CONSOLE("T4FMED01 - 5 - Acao TimeOut : End")

			cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
			OutMessage(cMsg)

		END CASE

	END SEQUENCE

	cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
	OutMessage(cMsg)

	MsUnLockAll()

	UnLockByName("WFMED",.T.,.T.,.T.)

	cFilAnt:=cSVFilAnt

	UnLockByName("WFMED",.T.,.T.,.T.)

	IF _lProcesso
		U_CONSOLE("T4FMED01 -  Mensagem processada ")
	ELSE
		U_CONSOLE("T4FMED01 -  Nao houve processamento")
	ENDIF

	cMsg:='['+cProcName+']: T4F - '+cProcName+'('+NToS(_nOpc)+'): END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmpAnt+" Fil: "+cFilAnt+" Fun: "+cProcName
	OutMessage(cMsg)

RETURN(lRet)

/*


?
Programa  EnvMED   Autor  Microsiga            Data   08/15/02   
?
Uso        AP6                                                        
?


*/

Static Function EnvMED(_cFilial,_cNum,_cUser,_cChave,_nTotal,_dDTLimit,_cHRLimit,_nOpc,_cNumCTR,_cNRevisa)

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

	Local cCNDFilial
	Local cB1Filial
	Local cB5Filial
	Local cBMFilial

	Local cCTDFilial

	local lCNDLock:=.F.

	Local nCNDRecNo:=Len(aCNDRecNos)
	Local nCNDRecNos:=nCNDRecNo
	Local nValAdt	:=0

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
	ChkFile("CND")
	CHKFile("SAL")
	CHKFile("CN9")

	cCNDFilial	:=	xFilial("CND",_cFilial)
	cB1Filial	:=	xFilial("SB1")
	cB5Filial	:=	xFilial("SB5")
	cBMFilial	:=	xFilial("SBM")
	cN9Filial	:=	xFilial("CN9",_cFilial)
	cCTDFilial	:=	xFilial("CTD")

	_cHttp:=GetNewPar("MV_WFDHTTP","http://COMPAQ:91/workflow")

	// TimeOut - Dias
	_nDD:=GetNewPar("MV_WFTODD",0)

	_dDataLib:=IIF(!EMPTY(_dDTLimit),_dDTLimit,MSDATE())
	_cHoraLib:=IIF(!EMPTY(_cHRLimit),_cHRLimit,LEFT(TIME(),5))

	// WF-Workflow TO-TimeOut PC-Contratos
	_cTimeOut:=GetNewPar("MV_WFTOPC","24:00")
	_nTimeOut:=(_nDD*24)+VAL(LEFT(_cTimeOut,2))+(VAL(RIGHT(_cTimeOut,2))/60)

	_cTo:=UsrRetMail(_cUser)

	U_CONSOLE("T4FMED01 - "+NToS(_nOpc)+" - E-mail: "+_cTo+"  - cUser "+_cUser)
	U_CONSOLE("T4FMED01 - "+NToS(_nOpc)+" - Pedido:"+_cNum)

	_cEmail:=UsrRetMail(_cUser) //_cEmail:= "alessandra.costa@crmservices.com.br"

	_aTimeOut:=U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)

/*
	If ((_nOpc==3).OR.(_nOpc==4))
		_cMailSol:=U__fRMSol(Posicione("CND",1,cCNDFilial+Alltrim(_cNum),"CND_NUMEROSC"))
		If !Empty(_cMailSol).AND.!(Alltrim(_cMailSol)$_cTo)
			_cTo += ";"+_cMailSol
		EndIf
	EndIf
*/
	//------------------- VALIDACAO
	_lError:=.F.
// 2019_02_22 - Comentado abaixo por motivo de estar enviando um monte de email de cadastro de usuario sem a conta de email (Solicitado Thiago Moraes - Geraldo Sabino)
  	/*
	if Empty(_cTo)
		aSize(aMsg,0)
		cTitle:="Administrador do Workflow: NOTIFICACAO"
		aAdd(aMsg,REPLICATE('*',80))
		aAdd(aMsg,Dtoc(MSDate())+" - "+Time()+' * Ocorreu um ERRO no envio da mensagem:')
		aAdd(aMsg,"Contrato No: "+_cNum+" Filial: "+cFilAnt+" Usuario: "+UsrRetName(_cUser))
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

	_cChaveSCR 	:= 	_cChave//_cFilial+'MD'+_cNum
	_cNum		:=	PADR(ALLTRIM(_cNum),GetSX3Cache("CND_NUMMED","X3_TAMANHO"))
	lDetalhe	:=	.F.

	dbSelectArea("SCR")
	SCR->(dbSetOrder(2))
	SCR->(MsSeek(_cChaveSCR))

	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(MsSeek(cEmpAnt+cFilAnt))

	dbSelectArea("CN9")
	CN9->(dbSetOrder(1))
	CN9->(MsSeek(cN9Filial+SCR->CR_XCONTRA+SCR->CR_XREVISA))

	If SUBSTR(_CCHAVE,3,2)	==	'MD'
		dbSelectArea("CND")
		CND->(dbSetOrder(7))
		CND->(MsSeek(cCNDFilial+SCR->CR_XCONTRA+SCR->CR_XREVISA+_cNum))

		dbSelectArea("CNE")
		CNE->(dbSetOrder(5))
		CNE->(MsSeek(cCNDFilial+SCR->CR_XCONTRA+SCR->CR_XREVISA+_cNum))

		dbSelectArea("SAL")
		SAL->(dbSetOrder(3))
		SAL->(MsSeek(xFilial("SAL")+CND->CND_APROV+SCR->CR_APROV))

	EndIf

	dbSelectArea("CNC")
	CNC->(dbSetOrder(1))
	CNC->(MsSeek(cCNDFilial+SCR->CR_XCONTRA+SCR->CR_XREVISA))

	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(MsSeek(xFilial("SA2")+CNC->CNC_CODIGO+CNC->CNC_LOJA))

	dbSelectArea("SE4")
	SE4->(dbSetOrder(1))
	SE4->(MsSeek(xFilial("SE4")+CN9->CN9_CONDPG))

	dbSelectArea("CNX")
	CNX->(dbSetOrder(1))
	CNX->(MsSeek(cCNDFilial+SCR->CR_XCONTRA))

	While CNX->(!Eof()) .AND. (CNX->CNX_FILIAL=cCNDFilial) .AND. (CNX->CNX_CONTRA==CND->CND_CONTRA)
		nValAdt+=CNX->CNX_VLADT
		CNX->(dbSkip())
	EndDo

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
		If SUBSTR(_CCHAVE,3,2)	==	'MD'

			oProcess:=TWFProcess():New("000001","Envio Aprovacao MED:"+_cFilial+"/"+TRIM(SCR->CR_NUM))
			oProcess:NewTask("Envio medição para aprovacao: "+_cFilial+_cNum,"\WORKFLOW\HTML\MEDAprov.HTM")
			oProcess:cSubject:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - Aprovacao de Medicao "+_cFilial+"/"+TRIM(SCR->CR_NUM)

		ElseIf SUBSTR(_CCHAVE,3,2)	==	'CT' .OR. SUBSTR(_CCHAVE,3,2)	==	'RV'

			oProcess:=TWFProcess():New("000001","Envio Aprovacao CTR:"+_cFilial+"/"+TRIM(SCR->CR_NUM))
			oProcess:NewTask("Envio contrato para aprovacao: "+_cFilial+_cNum,"\WORKFLOW\HTML\MEDAprov.HTM")
			oProcess:cSubject:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - Aprovacao de Contrato "+_cFilial+"/"+TRIM(SCR->CR_NUM)

		EndIf
		oProcess:bReturn:="U__T4FMED01(2)" //wfout descomentei esta linha para reenvio ao aprovao

	CASE _nOpc == 3 // Envio de email Aprovacao para solicitante

		If SUBSTR(_CCHAVE,3,2)	==	'MD'
			oProcess:=TWFProcess():New("000003","Envio p/responsável Medição: "+_cFilial+"/"+TRIM(SCR->CR_NUM))
			oProcess:NewTask("Envio Medição aprovada: "+_cFilial+_cNum,"\WORKFLOW\HTML\MEDResp.HTM")
			oProcess:cSubject:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - Medição aprovada "+_cFilial+"/"+TRIM(SCR->CR_NUM)
		ElseIf SUBSTR(_CCHAVE,3,2)	==	'CT' .OR. SUBSTR(_CCHAVE,3,2)	==	'RV'
			oProcess:=TWFProcess():New("000003","Envio p/responsável Contrato: "+_cFilial+"/"+TRIM(SCR->CR_NUM))
			oProcess:NewTask("Envio Contrato aprovado: "+_cFilial+_cNum,"\WORKFLOW\HTML\MEDResp.HTM")
			oProcess:cSubject:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - Contrato aprovado "+_cFilial+"/"+TRIM(SCR->CR_NUM)
		EndIf

		_cResposta:=" A P R O V A D O "

	CASE _nOpc == 4	// Envio de email Reprovado para solicitante

		If SUBSTR(_CCHAVE,3,2)	==	'MD'

			oProcess:=TWFProcess():New("000004","Envio p/ responsável medição reprovada: "+_cFilial+"/"+TRIM(SCR->CR_NUM))
			oProcess:NewTask("Envio CTR reprovado: "+_cFilial+_cNum,"\WORKFLOW\HTML\MEDResp.HTM")
			oProcess:cSubject:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - Medição/Contrato reprovada "+_cFilial+"/"+TRIM(SCR->CR_NUM)

		ElseIf SUBSTR(_CCHAVE,3,2)	==	'CT' .OR. SUBSTR(_CCHAVE,3,2)	==	'RV'

			oProcess:=TWFProcess():New("000004","Envio p/ responsável contrato reprovado: "+_cFilial+"/"+TRIM(SCR->CR_NUM))
			oProcess:NewTask("Envio CTR reprovado: "+_cFilial+_cNum,"\WORKFLOW\HTML\MEDResp.HTM")
			oProcess:cSubject:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - Medição/Contrato reprovada "+_cFilial+"/"+TRIM(SCR->CR_NUM)

		EndIf

		_cResposta:="<font color='#FF0000'>R E P R O V A D O </font>"

	ENDCASE

	oProcess:UserSiga:=_cUser
	oProcess:NewVersion(.T.)
	oHtml:=oProcess:oHTML

	dbSelectarea("SYP")
	SYP->(dBSetOrder(1))
	cObsCND :=""
/*
	IF SYP->(MsSeek(xFilial("SYP") + Alltrim(CND->CND_CODOBJ)))
		cObsCND += SYP->YP_TEXTO
	ENDIF
*/

	IF _nOpc == 1
		// Hidden Fields
		oHtml:ValByName("CR_USER",UsrFullName(_cUser))
		oHtml:ValByName("CHAVE",_cChave)
		oHtml:ValByName("CFILANT",cFilAnt)
		oHtml:ValByName("WFID",oProcess:fProcessId)
	ENDIF


	IF ((_nOpc==3).OR.(_nOpc==4))
		oHtml:ValByName("mensagem",_cResposta)
	ENDIF

	// gsabino 2019_02_15 - Imprime o numero do PA caso exista na Tabela ZZE
	// Salva Area
/*
	_aAreaAtu:=GetArea()
	_aAreaZZE:=ZZE->(GetArea())

	dbSelectarea("ZZE")
	dBSetOrder(2)
	_cPa :=""
	IF MsSeek(xFilial("ZZE") + Alltrim(CND->CND_NUMERO))
		_cPa := "/PA "+ZZE->ZZE_NUMERO
	ENDIF
	Restarea(_aAreaZZE)
	RestArea(_aAreaAtu)
*/
	oHtml:ValByName("CND_CONTRA",Alltrim(CN9->CN9_NUMERO))
	oHtml:ValByName("CN9_REVISA",Alltrim(CN9->CN9_REVISA))
	oHtml:ValByName("CEMPANT",SM0->M0_NOME)
	oHtml:ValByName("CND_FILIAL",SM0->M0_FILIAL)

	If SUBSTR(_CCHAVE,3,2)	==	'MD'
		oHtml:ValByName("CND_NUMERO","Medição Numero: "+Alltrim(CND->CND_NUMMED))
		oHtml:ValByName("TPAPROV","Medição ")
		
	ElseIf SUBSTR(_CCHAVE,3,2)	==	'CT' .OR. SUBSTR(_CCHAVE,3,2)	==	'RV'
		oHtml:ValByName("CND_NUMERO",'')
		oHtml:ValByName("TPAPROV","Contrato/Revisão ")
	EndIF
	//oHtml:ValByName("CND_DTINIC",DTOC(CND->CND_DTINIC))

	/*
	If CND->(C7_XTPCPR$"E,D")
 		_cComprad:=Posicione("SC1",1,xFilial("SC1")+CND->CND_NUMEROSC,"C1_USER")
	ELSE
	 	_cComprad:=CND->C7_USER
	ENDIF
*/

//	oHtml:ValByName("C7_USER",UsrFullName(_cComprad))
/*
	_cCCAprov:=CND->(IIF(Empty(C7_CC),C7_XCCAPR,C7_CC))
	_cCdSolic:=Posicione("SC1",1,xFilial("SC1")+CND->CND_NUMEROSC,"C1_USER")
*/       
	If(CN9->CN9_ESPCTR=="1")
		oHtml:ValByName("CN9_ESPCTR","COMPRA")
		oHtml:ValByName("TPCLIFOR","Fornecedor:")
		oHtml:ValByName("A2_NOME",SA2->A2_NOME)
	ELSE
		oHtml:ValByName("CN9_ESPCTR","VENDA")
		oHtml:ValByName("TPCLIFOR","Cliente:")
		oHtml:ValByName("A2_NOME",SA1->A1_NOME)
	ENDIF
	oHtml:ValByName("cObjCN9",ALLTRIM(MSMM(CN9->CN9_CODOBJ))) 
	                     
	//oHtml:ValByName("EPEP",CNE->CNE_CODOBJ)
	
//	oHtml:ValByName("A2_EMAIL",CND->C7_XMAILF)
//	oHtml:ValByName("A2_TEL",SA2->A2_TEL)
	oHtml:ValByName("CND_CONDPG",CN9->CN9_CONDPG+" / "+POSICIONE("SE4",1,XFILIAL("SE4")+CN9->CN9_CONDPG,"E4_DESCRI"))
//	oHtml:ValByName("CND_OBJCTO","VERIFICAR")
//	oHtml:ValByName("CND_NUMEROSC",CND->CND_NUMEROSC)
//	oHtml:ValByName("C7_SOLICIT",UsrFullName(_cCdSolic))
//	oHtml:ValByName("CNE_CC",_cCCAprov+" / "+POSICIONE("CTT",1,XFILIAL("CTT")+_cCCAprov,"CTT_DESC01"))
//	oHtml:ValByName("CNXVALPA",TRANSFORM(nValAdt,'@E 9,999,999.99'))
	oHtml:ValByName("CNXVALPA",0)
//	oHtml:ValByName("C7_VENPA",DTOC(CND->C7_XVENPA))
	//oHtml:ValByName("cObsCND",cObsCND)

	//-------------------------------------------------------------
	// ALIMENTA A TELA DE ITENS DO Contrato
	//-------------------------------------------------------------
	_nC7_TOTAL:=0
	_nC7_VLDESC:=0
	_nFRETEDESP:=0

	SB1->(dbSetOrder(1))
	SBM->(dbSetOrder(1))
	//SB5->(dbSetOrder(1))

	If SUBSTR(_CCHAVE,3,2)	==	'MD'

		dbSelectArea("CNE")
		CNE->(dbSetOrder(5))
		CNE->(MsSeek(cCNDFilial+SCR->CR_XCONTRA+SCR->CR_XREVISA+_cNum))

		While CNE->(!EOF())	.AND.CNE->CNE_FILIAL==cCNDFilial .AND. Alltrim(CNE->CNE_CONTRA)==CN9->CN9_NUMERO .AND. CNE->CNE_NUMMED==CND->CND_NUMMED

			aAdd(aCNDRecNos,CNE->(RecNo()))
			++nCNDRecNos
			lCNDLock:=SoftLock("CNE")
			if .not.(lCNDLock)
				exit
			endif

			SB1->(MSSeek(cB1Filial+CNE->CNE_PRODUT))

			SBM->(MSSeek(cBMFilial+SB1->B1_GRUPO))

			If SB5->(MSSeek(cB5Filial+CNE->CNE_PRODUT))
				_cDescPro:=SB5->B5_CEME
			Else
				_cDescPro:=SB1->B1_DESC
			EndIf

			aAdd((oHtml:ValByName("t.1")),CNE->CNE_ITEM)
			aAdd((oHtml:ValByName("t.2")),CNE->CNE_PRODUT+" - "+_cDescPro)
			aAdd((oHtml:ValByName("t.3")),CNE->(TRANSFORM(CNE_QUANT,'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.4")),CNE->(Alltrim(CNE_ITEMCT)+"-"+Alltrim(Posicione("CTD",1,cCTDFilial+CNE_ITEMCT,"CTD_DESC01")))) //andre aprovao
			aAdd((oHtml:ValByName("t.5")),CNE->(TRANSFORM(CNE_VLUNIT,'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.6")),CNE->(TRANSFORM(0,'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.7")),CNE->(TRANSFORM(CNE_VLDESC,'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.8")),CNE->(TRANSFORM((CNE_VLTOT)-(CNE_VLDESC),'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.c")),CNE->CNE_CONTA)
			//aAdd((oHtml:ValByName("t.9")),'')

			_nC7_TOTAL+=CNE->CNE_VLTOT
			_nC7_VLDESC+=CNE->CNE_VLDESC
			_nFRETEDESP+=0

			CNE->(dbSkip())
		Enddo

	ElseIf SUBSTR(_CCHAVE,3,2)	==	'CT' .OR. SUBSTR(_CCHAVE,3,2)	==	'RV'

		dbSelectArea("CNB")
		CNB->(dbSetOrder(1))
		CNB->(MsSeek(cN9Filial+CN9->CN9_NUMERO+CN9->CN9_REVISA))

		While CNB->(!EOF())	.AND.CNB->CNB_FILIAL==cN9Filial .AND. Alltrim(CNB->CNB_CONTRA)==CN9->CN9_NUMERO .AND. CNB->CNB_REVISA==CN9->CN9_REVISA

			aAdd(aCNDRecNos,CNB->(RecNo()))
			++nCNDRecNos
			lCNDLock:=SoftLock("CNB")
			if .not.(lCNDLock)
				exit
			endif

			SB1->(MSSeek(cB1Filial+CNB->CNB_PRODUT))

			SBM->(MSSeek(cBMFilial+SB1->B1_GRUPO))

			If SB5->(MSSeek(cB5Filial+CNB->CNB_PRODUT))
				_cDescPro:=SB5->B5_CEME
			Else
				_cDescPro:=SB1->B1_DESC
			EndIf

			aAdd((oHtml:ValByName("t.1")),CNB->CNB_ITEM)
			aAdd((oHtml:ValByName("t.2")),CNB->CNB_PRODUT+" - "+_cDescPro)
			aAdd((oHtml:ValByName("t.3")),CNB->(TRANSFORM(CNB_QUANT,'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.4")),CNB->(Alltrim(CNB_ITEMCT)+"-"+Alltrim(Posicione("CTD",1,cCTDFilial+CNB_ITEMCT,"CTD_DESC01")))) //andre aprovao
			aAdd((oHtml:ValByName("t.5")),CNB->(TRANSFORM(CNB_VLUNIT,'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.6")),CNB->(TRANSFORM(0,'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.7")),CNB->(TRANSFORM(CNB_VLDESC,'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.8")),CNB->(TRANSFORM((CNB_VLTOT)-(CNB_VLDESC),'@E 9,999,999.99')))
			aAdd((oHtml:ValByName("t.c")),CNB->CNB_CONTA)
			//aAdd((oHtml:ValByName("t.9")),'')

			_nC7_TOTAL+=CNB->CNB_VLTOT
			_nC7_VLDESC+=CNB->CNB_VLDESC
			_nFRETEDESP+=0

			CNB->(dbSkip())

		Enddo
	EndIf

	if (lCNDLock)

		oHtml:ValByName("CR_TOTAL",TRANSFORM(_nC7_TOTAL,'@E 99,999,999.99'))
		oHtml:ValByName("DESCONTO",TRANSFORM(_nC7_VLDESC,'@E 99,999,999.99'))
		oHtml:ValByName("FRETEDESP",TRANSFORM(_nFRETEDESP,'@E 99,999,999.99'))
		oHtml:ValByName("CR_LIQUIDO",TRANSFORM((_nC7_TOTAL-(_nC7_VLDESC+_nFRETEDESP)),'@E 99,999,999.99'))

		//-------------------------------------------------------------
		// ALIMENTA A TELA DE PROCESSO DE APROVAO DE Contrato
		//-------------------------------------------------------------

		_nCHAVESCR:=TamSx3("CR_FILIAL")[1]
		_nCHAVESCR+=TamSx3("CR_TIPO")[1]
		_nCHAVESCR+=TamSx3("CR_NUM")[1]
		_cCHAVESCR:=SubStr(_cCHAVE,1,_nCHAVESCR) // 01PC123456
		dbSelectArea("SCR")
		SCR->(dbSetOrder(1))
		SCR->(MsSeek(_cCHAVESCR,.T.))

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

			If SUBSTR(_CCHAVE,3,2)	==	'MD'

				aAdd(aMsg,'A medição No.: <a href="'+_cHttp+'/workflow/wfpc/' +alltrim(cProcess)+'.htm">'+Alltrim(CND->CND_NUMMED)+'</a>, referente contrato No.'+Alltrim(CN9->CN9_NUMERO)+ ' aguarda seu parecer.')

			ElseIf SUBSTR(_CCHAVE,3,2)	==	'CT' .OR. SUBSTR(_CCHAVE,3,2)	==	'RV'
				aAdd(aMsg,'O contrato No.: <a href="'+_cHttp+'/workflow/wfpc/' +alltrim(cProcess)+'.htm">'+Alltrim(CN9->CN9_NUMERO)+'</a>, aguarda seu parecer.')

			EndIf

			aAdd(aMsg,"<br></br>")
			aAdd(aMsg,"<br></br>")
			_cEmail+= ";tmoraes@t4f.com.br" //
			U_MailNotify(_cEmail,cSubject,aMsg)
		OTHERWISE

			cSubject:=oProcess:cSubject
			// start workflow
			oProcess:cTo:=_cTo
			cProcess:=oProcess:Start("\workflow\wfpc\")
			// para gravar o nome do html na SCR
			aWFReturn[WF_HTMLFILE]:=cProcess
			aSize(aMsg,0)

			If SUBSTR(_CCHAVE,3,2)	==	'MD'

				aAdd(aMsg,"Referente Status da medição")
				aAdd(aMsg,"<br></br>")
				aAdd(aMsg,'Verifique o status da medição No.: <a href="'+_cHttp+'/workflow/wfpc/' +alltrim(cProcess)+'.htm">'+Alltrim(CND->CND_NUMMED)+'</a>, referente contrato No.'+Alltrim(CN9->CN9_NUMERO))

			ElseIf SUBSTR(_CCHAVE,3,2)	==	'CT' .OR. SUBSTR(_CCHAVE,3,2)	==	'RV'

				aAdd(aMsg,"Referente Status do Contrato")
				aAdd(aMsg,"<br></br>")
				aAdd(aMsg,'Verifique o status do contrato No.: <a href="'+_cHttp+'/workflow/wfpc/' +alltrim(cProcess)+'.htm">'+Alltrim(CN9->CN9_NUMERO)+'</a>')

			EndIf

			aAdd(aMsg,"<br></br>")
			aAdd(aMsg,"<br></br>")

			_cEmail:= ";tmoraes@t4f.com.br"
			U_MailNotify(_cEmail,cSubject,aMsg)

			oProcess:cTo:=_cTo
			oProcess:Start()


		END CASE

		/*
		for nCNDRecNo:=(nCNDRecNo+1) to nCNDRecNos
            CND->(dbGoTo(aCNDRecNos[nCNDRecNo]))
			if CND->(RecLock("CND",.F.))
                CND->C7_WF:=IF((_nOpc==1),"0","1")
                CND->(MsUnLock())
			endif
		next nCNDRecNo
*/
		aWFReturn[WF_START]:=.T.

	endif

return(aWFReturn)

/*


?
Programa  TimeOUT   Autor  Microsiga            Data   10/22/02   
?
Uso        AP7 TimeOut -                                              
?


*/
/*
Static Function TimeOut() //wfout
	
	Local aMsg:={}
	Local _cQuery
	Local _nQtdEnvio:=GetNewPar("MV_XQTDENV",3)// DEFINE O QTD DE ENVIO WF
	Local cTmp:=GetNextAlias()

	_cHttp:=GetNewPar("MV_WFDHTTP","http://COMPAQ:91/workflow")

  	_cQuery := "SELECT DISTINCT "
  	_cQuery += " 	 CND.C9_USER"
  	_cQuery += " 	,CND.CND_FILIAL"
  	_cQuery += " 	,CND.CND_NUMERO"
  	_cQuery += " 	,CND.C7_FORNECE"
  	_cQuery += " 	,CND.C7_LOJA"
  	_cQuery += " 	,CND.C7_EMISSAO"
  	_cQuery += " 	,CND.C7_APROV"
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
  	_cQuery += " JOIN "+RetSqlName("CND")+" CND 
  	_cQuery += "   ON (CND_FILIAL='"+xFilial('CND')+"' "
	If Upper(TcGetDb())=="ORACLE"
  		_cQuery += " AND CND.CND_NUMERO=TRIM(SCR.CR_NUM)"
	Else
	  	_cQuery += " AND CND.CND_NUMERO=TRIM(SCR.CR_NUM)"
	EndIf
  	_cQuery += "  AND CND.C7_APROV<>'      '"
  	_cQuery += "  AND CND.C7_CONAPRO='B'"
  	_cQuery += "  AND CND.D_E_L_E_T_=' ')"
  	_cQuery += " JOIN "+RetSqlName("SAL")+" SAL"
  	_cQuery += "   ON (SAL.AL_FILIAL = '"+xFilial('SAL')+"' AND SAL.AL_COD=CND.C7_APROV AND SAL.AL_APROV=SCR.CR_APROV AND SAL.D_E_L_E_T_=' ')"
  	_cQuery += " WHERE SCR.D_E_L_E_T_=' '"
  	_cQuery += "   AND SCR.CR_FILIAL='"+xFilial('SCR') +"'"
  	_cQuery += "   AND SCR.CR_STATUS='02'"
  	_cQuery += "   AND SCR.CR_TIPO='PC'"
  	_cQuery += "   AND SCR.CR_DTLIMIT<='"+DTOS(MSDATE())+"'"
  	_cQuery += "   AND SCR.CR_WF='1'"
  	_cQuery += "   AND SCR.CR_WFID<>' '"
	// DEFINE QUE ENQUANTO A QTD DE ENVIO FOR MENOR QUE _nQtdEnvio O SISTEMA FAZ O LOOP..
  	_cQuery += "   AND SCR.CR_XQTDENV<"+NToS(_nQtdEnvio)
  	_cQuery += " ORDER BY CND.C7_USER"
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
			SCR->(MsSeek((cTMP)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)))
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
										CND_FILIAL+"-"+CND_NUMERO,;
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
			cTitle:=_cPrefMsg+Alltrim(SM0->M0_NOME)+" - TimeOut Contratos No."+(cTMP)->CND_FILIAL+"-"+(cTMP)->CND_NUMERO

			aSize(aMsg,0)
			aAdd(aMsg,Dtoc(MSDate())+" - "+Time()+" Sr Aprovador: "+UsrFullName((cTMP)->CR_USER))
			aAdd(aMsg,'O <a href="'+_cHttp+'/workflow/wfpc/' +alltrim((cTMP)->CR_WFLINK)+'.htm">Contrato No.: '+ Alltrim(SM0->M0_NOME)+":" +(cTMP)->CND_FILIAL+"-"+(cTMP)->CND_NUMERO+'</a> encontra-se pendente de sua aprovao .')

			U_MailNotify(cTo,cTitle,aMsg)

			(cTMP)->(dbSkip())

		END

	EndIf

	dbSelectArea(cTMP)
	(cTMP)->(dbCloseArea())
	dbSelectArea("SCR")

RETURN
*/
/*


?
Programa  TO_NOTIF  Autor  Microsiga            Data   10/22/02   
?
Uso        AP7 TimeOut - Notificacao                                  
?


*/
/*
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
	oProcess:cSubject:=_cPrefMsg+OemToAnsi("Timeout Contratos")
	oProcess:cTo:=_cTo
	oProcess:UserSiga:=_cUser
	oProcess:NewVersion(.T.)

	// OBJETO OHTML
  	oHtml:=oProcess:oHTML

	// CABEALHO
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
*/

/*

Programa  EnvPCFor   Autor  Pedro Augusto       Data  12/08/2013  
?
Uso        TV Alphaville                                              

*/
User Function fEPCMED(_cFilial,_cNum,_cUser,_cChave,_nTotal,_dDTLimit,_cHRLimit,_nOpc,_cToFor,_cGio,cEmpAnt)

	Local _nVALMERC:=0
	Local _nVALIPI:=0
	Local _nFRETE:=0
	Local _nSEGURO:=0
	Local _nDESCONTO:=0
	Local _nDESPESA:=0
	Local _nVALTOT:=0

	Local cModelHtml:=""

	Local cCNDFilial
	Local cBMFilial

	// Incluido GSABINO 2019_02_22 _ Dando erro de variavel not exist - Informa??o do Thiago
	Local cB1Filial:=xFilial("SB1")

	// prepare environment empresa "08" filial _cFilial
	prepare environment empresa cEmpAnt filial _cFilial

	If valtype(_cGio) <> 'C'
		Private _cGio:=' '
	EndIf

	_cChaveSCR:=PADR(_cFilial+'MD'+_cNum,60)
	_cNum:=PADR(ALLTRIM(_cNum),GetSX3Cache("CND_NUMERO","X3_TAMANHO"))

	dbSelectArea("SCR")
	SCR->(dbSetOrder(2))
	SCR->(MsSeek(_cChave))

	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(MsSeek(cEmpAnt+cFilAnt))

	dbSelectArea("CND")
	cCNDFilial:=xFilial("CND",_cFilial)
	CND->(dbSetOrder(1))
	CND->(MsSeek(cCNDFilial+_cNum))

	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	SA2->(MsSeek(xFilial("SA2")+CND->C7_FORNECE+CND->C7_LOJA))

	dbSelectArea("SE4")
	SE4->(dbSetOrder(1))
	SE4->(MsSeek(xFilial("SE4")+CND->C7_COND))

	_cTo:=_cToFor
	_cVersao:=""

	dbSelectArea("SCY")
	SCY->(dbSetOrder(1))
	SCY->(MsSeek(_cFilial+_cNum))

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
	oProcess:NewTask("Envio CTR aprovado: "+_cFilial+_cNum,cModelHtml)

	oProcess:cTo:=_cTo

	oHtml:=oProcess:oHTML

	//Cabecalho//
	// oHtml:ValByName("CND_FILIAL",SM0->M0_FILIAL)
	oHtml:ValByName("CND_NUMERO",CND->CND_NUMERO)
	oHtml:ValByName("C7_EMISSAO",DTOC(CND->C7_EMISSAO))

	//Dados Empresa
	oHtml:ValByName("C_NOME",SM0->M0_NOMECOM)
	oHtml:ValByName("C_CNPJ",Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")))
	oHtml:ValByName("C_ENDER",Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_CIDCOB) +" - "+Alltrim(SM0->M0_ESTCOB))
	oHtml:ValByName("C_CEP",SM0->M0_CEPCOB)
	oHtml:ValByName("C_TELFAX",Alltrim(SM0->M0_TEL)+Iif(Alltrim(SM0->M0_FAX) == "",""," / "+SM0->M0_FAX))

	If CND->C7_XTPCPR $ "E,D"
		_cCont:=Posicione ("SC1",1,xFilial("SC1")+CND->CND_NUMEROSC,"C1_USER")
	ELSE
		_cCont:=CND->C7_USER
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
	oHtml:ValByName("V_EMAIL",CND->C7_XMAILF)

	//Dados cond. pagamento
	oHtml:ValByName("E4_DESCRI",SE4->E4_DESCRI)

	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(MsSeek(cEmpAnt+CND->CND_FILIAL))

	// Dados local entrega
	/*  //comentado - Vitor 07/11/13
	oHtml:ValByName("E_NOME",SM0->M0_NOMECOM)
	oHtml:ValByName("E_CNPJ",Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")))
	oHtml:ValByName("E_ENDER",Alltrim(SM0->M0_ENDENT)+" - "+Alltrim(SM0->M0_CIDENT) +" - "+Alltrim(SM0->M0_ESTENT))
	oHtml:ValByName("E_CEP",SM0->M0_CEPCOB)
	*/
	//Inf.Adicionais
	oHtml:ValByName("C7_XOBSFO",CND->C7_XOBSFO)

	SB1->(dbSetOrder(1))

	SBM->(dbSetOrder(1))
	cBMFilial:=xFilial("SBM")

	dbSelectArea("CNE")
	CNE->(dbSetOrder(1))
	CNE->(MsSeek(CND->CND_FILIAL+_cNum))

	//-------------------------------------------------------------
	// ALIMENTA A TELA DE ITENS DO Contrato
	//-------------------------------------------------------------
	While CNE->(!EOF().and.(CNE_FILIAL==cCNDFilial).and.(CNE_CONTRA==_cNum))

		Select SB1
		Seek xFilial()+CNE->CNE_PRODUT
//        SB1->(MsSeek(cCNDFilial+CND->C7_PRODUTO))
		SBM->(MsSeek(cBMFilial+SB1->B1_GRUPO))

		aAdd((oHtml:ValByName("t.1")),CNE->CNE_ITEM)
		aAdd((oHtml:ValByName("t.2")),CNE->CNE_PRODUT)
		aAdd((oHtml:ValByName("t.3")),Alltrim(SB1->B1_DESC))
		aAdd((oHtml:ValByName("t.4")),iif(_cGio='x',SB1->B1_UM,'b'))
		aAdd((oHtml:ValByName("t.5")),Alltrim(TRANSFORM(CNE->CNE_QUANT,'@E 9,999,999,999.99')))
		aAdd((oHtml:ValByName("t.6")),Alltrim(TRANSFORM(0,'@E 9,999,999,999.99')))
		aAdd((oHtml:ValByName("t.7")),Alltrim(TRANSFORM(0,'@E 99.99')))
		aAdd((oHtml:ValByName("t.8")),Alltrim(TRANSFORM(0,'@E 9,999,999,999,999.99')))
		aAdd((oHtml:ValByName("t.9")),Alltrim(TRANSFORM(0,'@E 99.99')))
		aAdd((oHtml:ValByName("t.10")),CND->C7_DATPRF)

		_nVALMERC+=CND->C7_TOTAL
		_nVALIPI+=CND->C7_VALIPI
		_nFRETE+=CND->C7_VALFRE
		_nSEGURO+=CND->C7_SEGURO
		_nDESPESA+=CND->C7_DESPESA
		_nDESCONTO+=CND->C7_VLDESC

		CND->(dbSkip())

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

	oProcess:cSubject:="WORKFLOW  - Contrato "+_cNum+Iif(_cVersao<>""," Reviso: "+_cVersao,"")+" - APROVADO"
	oProcess:Start()

return .T.

//funo para pegar o e-mail da sc
User Function _fRMMED1(cNumSC)

	Local aArea:=GetArea()
	Local aAreaSC1:=SC1->(GetArea())
	Local cEmail:=""

	cNumSC:=PADR(Alltrim(cNumSC),TamSX3("C1_NUM")[1])

	SC1->(dbSetOrder(1))
	If !Empty(cNumSC).and.SC1->(MsSeek(xFilial("SC1")+cNumSC))
		cEmail:=Alltrim(UsrRetMail(SC1->C1_USER))
	EndIf

	RestArea(aAreaSC1)
	RestArea(aArea)

Return(cEmail)

Static Function FTMED1(cFilPed,cContra,cRevisa,cNumMed,cTipo)

	Local cQuery:=""
	Local cAliasMed:=GetNextAlias()
	Local lRet:=.T.

	cQuery:="SELECT SCR.CR_NUM "
	cQuery+= "  FROM "+RetSqlName("SCR")+" SCR"
	cQuery+= " WHERE SCR.CR_FILIAL='"+cFilPed+"'"
	cQuery+= " AND SCR.CR_TIPO ='"+cTipo+"'"
	cQuery+= " AND SCR.CR_NUM = '"+cNumMed+"'"
	cQuery+= " AND SCR.CR_XCONTRA='"+cContra+"'"
	cQuery+= " AND SCR.CR_XREVISA='"+cRevisa+"'"
	cQuery+= " AND SCR.CR_DATALIB=' ' "
	cQuery+= " AND SCR.CR_VALLIB=0 "
	cQuery+= " AND SCR.D_E_L_E_T_=' '"

	TCQUERY (cQuery) NEW ALIAS (cAliasMed)

	If (cAliasMed)->(!EOF())
		lRet:=.F.
	EndIf

	(cAliasMed)->(dbCloseArea())

	dbSelectArea("SCR")

Return(lRet)


Static Function BLQCTR(cFilCTR,cContra,cRevisa)

	Local cQuery:=""
	Local cAliasCtr:=GetNextAlias()
	Local lRet:=.T.

	cQuery:="SELECT SCR.CR_NUM "
	cQuery+= "  FROM "+RetSqlName("SCR")+" SCR"
	cQuery+= " WHERE SCR.CR_FILIAL='"+cFilCTR+"'"
	cQuery+= " AND SCR.CR_TIPO IN ('CT','RV')"
	cQuery+= " AND SCR.CR_NUM = '"+cContra+"'"
	cQuery+= " AND SCR.CR_XCONTRA='"+cContra+"'"
	cQuery+= " AND SCR.CR_XREVISA='"+cRevisa+"'"
	cQuery+= " AND SCR.CR_STATUS='04' "
	cQuery+= " AND SCR.D_E_L_E_T_=' '"

	TCQUERY (cQuery) NEW ALIAS (cAliasCtr)

	If (cAliasCtr)->(!EOF())
		lRet:=.F.
	EndIf

	(cAliasCtr)->(dbCloseArea())

	dbSelectArea("SCR")

Return(lRet)


	Static Procedure OutMessage(cMsg)
	PTInternal(1,cMsg)
	#IFDEF TOP
		TCInternal(1,cMsg)
	#ENDIF
	U_CONSOLE(cMsg)
Return
