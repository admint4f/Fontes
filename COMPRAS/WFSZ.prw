#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
                              //X3Combo("C7_XTPCPR",SC7->C7_XTPCPR)
//Chamada por empresa
User Function WFSZ(aParamEmp)
	Local _aEmp             		   
	
	Private _cEmpresa  := "08,09,15,16,20,25"  
	Private _aEmprFil	:= {}
	Private _cPrefMsg := "" 		
	
	If aParamEmp == Nil .OR. VALTYPE(aParamEmp) == "U"
		private aParamEmp := {}
		aAdd( aParamEmp,"08")
		aAdd( aParamEmp,"01")
	EndIf
	
	RpcSetType(3)
	RpcSetEnv(aParamEmp[1],aParamEmp[2])	
	
    DbSelectArea("SM0")
    SM0->(DbSetOrder(1))
	WHILE !SM0->(EOF()) 
	
		If !(SM0->M0_CODIGO $ _cEmpresa)
			SM0->(DbSkip())
			Loop
		EndIf
		
		aAdd(_aEmprFil,{SM0->M0_CODIGO,SM0->M0_CODFIL})

		SM0->(DbSkip())	 
	EndDo
			
	For _nx := 1 to Len(_aEmprFil)
		RpcSetType(3)
		RpcSetEnv(_aEmprFil[_nx][1],_aEmprFil[_nx][2])	
		
	    DbSelectArea("SM0")
    	SM0->(DbSetOrder(1))
    	SM0->( DbSeek(_aEmprFil[_nx][1]+_aEmprFil[_nx][2]) )
                
		cEmpAnt	:= _aEmprFil[_nx][1]
		cFilAnt	:= _aEmprFil[_nx][2]
		U_CONSOLE('PC() /' + cEmpAnt + cFilAnt)
	
		U_WFPC(1)  		// 1 - ENVIO PC PARA APROVADORES
	    
		U_WFPC(3)  		// 3 - ENVIO PC ITENS APROVADOS PARA SOLICITANTE
    	aAreaAtu:=Alias()
		U_LOGAPR(3)     // LOG PC ITENS Aprovados
		Restarea(aAreaAtu)


		U_WFPC(4)  		// 4 - ENVIO PC ITENS REPROVADOS PARA SOLICITANTE   
		aAreaAtu:=Alias()
	    U_LOGAPR(4)     // LOG PC ITENS Aprovados
		Restarea(aAreaAtu)
		
		
		U_WFPC(5)        // 5 - ENVIO DA NOTIFICAÇÃO POR TIMEOUT  
        


        RpcClearEnv()
	Next
			
/*    For _aEmp := 1 To Len(_aEmpresa)   
		U_PC({_aEmpresa[_aEmp],1})  		// 1 - ENVIO PC PARA APROVADORES
		U_PC({_aEmpresa[_aEmp],3})  		// 3 - ENVIO PC ITENS APROVADOS PARA SOLICITANTE
		U_PC({_aEmpresa[_aEmp],4})  		// 4 - ENVIO PC ITENS REPROVADOS PARA SOLICITANTE   
		U_PC({_aEmpresa[_aEmp],5})          // 5 - ENVIO DA NOTIFICAÇÃO POR TIMEOUT
    Next  */
	

Return
   	
//Chamada por empresa - TimeOut      //wfout
User Function WFSZ_TO()
	Local _aEmpTO
	Private _aEmpresaTO:= {"08"}              //
    For _aEmpTO := 1 To Len(_aEmpresaTO)   
		U_PC({_aEmpresaTO[_aEmpTO],5})  		// 1 - ENVIO PC PARA APROVADORES
    Next
    Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PC    ºAutor  ³Totvs			         º Data ³  24/09/13   º±±
±±º          ³Rotina WF de aprovacao de Pedido de Compra                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico T4F 			                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  
*/

User Function PC( aParam )
	If aParam == Nil .OR. VALTYPE(aParam) == "U"
		U_CONSOLE("Parametros nao recebidos => PC()")
		RETURN
	EndIf
	
	RpcSetType(3)
	RpcSetEnv(aParam[1],'01')
	                                                   
	CHKFILE("SM0")
	
	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(aParam[1],.F.)
	
	U_CONSOLE('PC() /' + aParam[1] )
	
	WHILE !SM0->(EOF()) .AND. SM0->M0_CODIGO == aParam[1] 
		cEmpAnt	:= SM0->M0_CODIGO
		cFilAnt	:= SM0->M0_CODFIL                                                          

		U_CONSOLE('PC() /' + aParam[1] + cFilAnt)
		U_WFPC(aParam[2])
		SM0->(DBSkip())
	END
	RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFPC-PEDIDO DE COMPRAS                 º Data ³  15/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ 1 - ENVIO DE EMAIL PARA APROVADORES                        º±±
±±º          ³ 2 - RETORNO DE EMAIL COM RESPOSTA DE APROVADORES           º±±
±±º          ³ 3 - ENVIA RESPOSTA DE PEDIDO APROVADO  PARA O COMPRADOR	  º±±
±±º          ³ 4 - ENVIA RESPOSTA DE PEDIDO REPROVADO PARA O COMPRADOR	  º±±
±±º          ³ 5 - ENVIO DE EMAIL - NOTIFICACAO DE TIME-OUT               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFPC(_nOpc, oProcess , oProcesf)
Local _cIndex, _cFiltro, _cOrdem
Local _cFilial, _cOpcao, _cObs
Local _lProcesso := .F.
Local _cPrefMsg := "" 		

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


DO 	CASE 
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³1 - Prepara os pedidos a serem enviados para aprovacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
	CASE _nOpc == 1
		U_CONSOLE("1 - Prepara os pedidos a serem enviados para aprovacao")
		U_CONSOLE("1 - EmpFil:" + cEmpAnt + cFilAnt)
	  	_cQuery := ""
	  	_cQuery += " SELECT"
	  	_cQuery += " CR_FILIAL," 
	  	_cQuery += " CR_TIPO,"   
	  	_cQuery += " CR_NUM,"
	  	_cQuery += " CR_NIVEL," 
	  	_cQuery += " CR_TOTAL," 
	  	_cQuery += " CR_USER,"   
	  	_cQuery += " CR_APROV,"   
	  	_cQuery += " CR_DTLIMIT,"
	  	_cQuery += " CR_HRLIMIT,"
	  	_cQuery += " SCR.R_E_C_N_O_"   
	  	_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
	  	_cQuery += " WHERE SCR.D_E_L_E_T_ <> '*'"
	  	_cQuery += " AND CR_FILIAL = '" + cFilAnt + "'"
	  	_cQuery += " AND CR_TIPO = 'PC'"
	  	_cQuery += " AND CR_STATUS = '02'"  								// Em aprovacao
	  	_cQuery += " AND CR_DTLIMIT  <= '" + DTOS(MSDATE()) + "'"      	// Data Limite
	  	_cQuery += " AND CR_WF = ' '"
	  	
	  	_cQuery += " ORDER BY"
	  	_cQuery += " CR_FILIAL," 
	  	_cQuery += " CR_NUM,"
	  	_cQuery += " CR_NIVEL,"
	  	_cQuery += " CR_USER"
	  	
		TcQuery _cQuery New Alias "TMP"
	
		dbGotop()
		While !TMP->(Eof())
            
			IF !EMPTY(TMP->CR_DTLIMIT)
				IF TMP->CR_DTLIMIT == DTOS(MSDATE())
					IF TMP->CR_HRLIMIT  >  LEFT(TIME(),5)
						TMP->(DBSkip())
						LOOP						
					ENDIF
				ENDIF
			ENDIF

			DBSelectArea("SC7")
			DBSetOrder(1)
			DBSeek(xFilial("SC7")+PADR(ALLTRIM(TMP->CR_NUM),6))    //ver

			IF EMPTY(SC7->C7_APROV)
				DBSelectarea("SCR")
				DBSetOrder(2)
				IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
					Reclock("SCR",.F.)
					SCR->CR_WF			:= "1" 		    	// Status 1 - envio para aprovadores / branco-nao houve envio
		  			SCR->CR_WFID		:= "N/D"		   // Rastreabilidade
					MSUnlock()
				ENDIF	
			ELSE 				
				_aWF	 		:= EnviaPC(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) , TMP->CR_TOTAL , STOD(TMP->CR_DTLIMIT), TMP->CR_HRLIMIT, _nOpc)
				DBSelectarea("SCR")
				DBSetOrder(2)

//-----comentado abaixo apenas para testes------------///				

				IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
					Reclock("SCR",.F.)
					SCR->CR_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
		  			SCR->CR_WFID		:= _aWF[1]		// Rastreabilidade
					SCR->CR_DTLIMIT		:= _aWF[2]		// Data Limite
					SCR->CR_HRLIMIT		:= _aWF[3]		// Hora Limite
				   	SCR->CR_WFLINK		:= _aWF[4]		// Arquivo HTML //link timeout Vitor 28/11/13
				   	MSUnlock()     
				ENDIF

			ENDIF

			_lProcesso := .T.
			
			TMP->(DBSkip())           
		End
		
		dbSelectArea("TMP")
		dbCloseArea()

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³2 - Processa O RETORNO DO EMAIL                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
		CASE _nOPC	== 2
			U_CONSOLE("2 - Processa O RETORNO DO EMAIL")
			U_CONSOLE("2 - EmpFil:" + cEmpAnt + cFilAnt)
			U_CONSOLE("2 - Semaforo Vermelho" )
			nWFPC2 		:= U_Semaforo("WFPC2")
			cFilAnt		:= alltrim(oProcess:oHtml:RetByName("CFILANT"))
			cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
//			cDisp     	:= alltrim(oProcess:oHtml:RetByName("DISP"))
			cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
			cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
			cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))
			cTo   		:= SUBS( alltrim(oProcess:cRetFrom), AT('<',alltrim(oProcess:cRetFrom)) + 1 , LEN(alltrim(oProcess:cRetFrom))-AT('<',alltrim(oProcess:cRetFrom))-1 )   			
			oProcess:Finish() // FINALIZA O PROCESSO
			U_CONSOLE("2 - cFilAnt :" + cFilAnt)
			U_CONSOLE("2 - Chave   :" + cChaveSCR)
			U_CONSOLE("2 - Opc     :" + cOpc)
			U_CONSOLE("2 - Obs     :" + cObs)
			U_CONSOLE("2 - WFId    :" + cWFID)
			U_CONSOLE("2 - cTo     :" + cTo)
			IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
				ChkFile("SCR")
				ChkFile("SAL")
				ChkFile("SC7")
				ChkFile("SCS")                    
				ChkFile("SAK")                    
				ChkFile("SM2")                    
				// Posiciona na tabela de Alcadas 
				DBSelectArea("SCR")
				DBSetOrder(2)
				DBSeek(cChaveSCR)
				IF !FOUND() .OR. TRIM(SCR->CR_WFID) <> TRIM(cWFID)
					//"Este processo nao foi encontrado e portanto deve ser descartado
					// abre uma notificacao a pessoa que respondeu
					U_CONSOLE("2 - Processo nao encontrado :" + cWFID + " Processo atual :" + SCR->CR_WFID)
					U_CONSOLE("2 - Semaforo Verde" )
					U_Semaforo(nWFPC2)
					Return .T.
				ENDIF
				Reclock("SCR",.F.)
				SCR->CR_WF		:= "2"			// Status 2 - respondido
				MSUnlock()
				If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
					U_CONSOLE("2.1 - Processo respondido anteriormente :" + cWFID)
					U_CONSOLE("2.1 - Semaforo Verde" )
					cSubject    := _cPrefMsg+ Alltrim(SM0->M0_NOME)+" - AVISO - Pedido de Compra No. " + Substr(cChaveSCR,5,6) +" respondido anteriormente"
					_cEmail		:= UsrRetMail(Substr(cChaveSCR,55,6))
					aMsg := {}
					aaDD(aMsg, "Sr. Aprovador,")
					aaDD(aMsg, "<br></br>")
					AADD(aMsg, 'O Pedido de Compra No.: ' + Substr(cChaveSCR,5,6) + ' foi anteriormente '+SCR->CR_OBS)
					aaDD(aMsg, "<br></br>")
					aaDD(aMsg, "<br></br>")
					
					
					U_MailNotify( _cEmail, cSubject , aMsg )
	
					U_Semaforo(nWFPC2)
					Return .T.
				EndIf
				// Verifica se o pedido de compra esta aprovado
				// Se estiver, finaliza o processo
				dbSelectArea("SC7")
				dbSetOrder(1)
				dbSeek(xFilial()+Padr(SCR->CR_NUM,6))
				
				IF SC7->C7_CONAPRO <> "B"  // NAO ESTIVER BLOQUEADO
					U_CONSOLE("xFilial(): "+xFilial() )
					U_CONSOLE("SCR->CR_NUM: "+SCR->CR_NUM )
					U_CONSOLE("C7_FILIAL:"+SC7->C7_FILIAL )
					U_CONSOLE("C7_NUM   :"+SC7->C7_NUM )
					U_CONSOLE("2.2 - Processo ja respondido via sistema :" + cWFID)
					U_CONSOLE("2.2 - Semaforo Verde" )
					U_Semaforo(nWFPC2)
					Return .T. 
   	
				ENDIF
				// REPosiciona na tabela de Alcadas 
				DBSelectArea("SCR")
				DBSetOrder(2)
				DBSeek(cChaveSCR)
				// verifica quanto a saldo de alçada para aprovação				
				// Se valor do pedido estiver dentro do limite Maximo e minimo 
				// Do aprovador , utiliza o controle de saldos, caso contrário nao
				// faz o tratamento como vistador.
				nTotal := SCR->CR_TOTAL
				lLiberou := U_MaAlcDoc({SCR->CR_NUM,"PC",nTotal,SCR->CR_APROV,,SC7->C7_APROV,,,,,cObs},msdate(),If(cOpc=="S",4,6))
				
				//Alterado 05/11/2015 - Incluso aprovação pelo grupo de aprovação.
				DBSelectArea("SC7")
				DBSetOrder(1)
				If DBSeek(xFilial("SC7")+PADR(ALLTRIM(SCR->CR_NUM),TamSX3("C7_NUM")[1]))
					MaAlcDoc({SCR->CR_NUM,"PC",nTotal,SCR->CR_APROV,,SC7->C7_APROV,,,,,    },msdate(),4)
				EndIf
				
				U_CONSOLE("2 - Liberado :" + IIF(lLiberou, "Sim", "Nao"))
				_lProcesso := .T.
				If lLiberou  
					_nRecSC7Bkp := SC7->(Recno())     //vitor
					dbSelectArea("SC7")
					dbSetOrder(1)
					dbSeek(xFilial()+Padr(SCR->CR_NUM,6))
			        While !Eof() .And. SC7->C7_FILIAL+SC7->C7_NUM == SCR->CR_FILIAL+Padr(SCR->CR_NUM,6)
		                Reclock("SC7",.F.)
		                SC7->C7_CONAPRO 	:= "L"
		                MsUnlock()
		                dbSkip()
			        EndDo     
			        SC7->(DbGoTo(_nRecSC7Bkp))  //vitor 
			        //Chama rotina para gerar Solic.PA     vitor
			        If SC7->C7_XSOLPA = '2' .And. SC7->C7_XVALPA > 0 .And. !(Empty(SC7->C7_XVENPA))  
						//      U_T4COMC01() //Chama a função de geração da solicitação de PA (ZZE).																				
							u_T4COMC01(10,stod("20191130"))  // Teste Luiz Eduardo 26/11
					EndIf
				EndIf
			EndIf				
			U_CONSOLE("2 - Semaforo Verde" )
			U_Semaforo(nWFPC2)

	/*        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³3 - Envia resposta de pedido aprovado para o comprador ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	CASE _nOpc == 3

		U_CONSOLE("3 - Envia resposta de pedido APROVADO para o comprador")
		U_CONSOLE("3 - EmpFil:" + cEmpAnt + cFilAnt)

	  	_cQuery := ""
	  	_cQuery += " SELECT"   
	  	_cQuery += " C7_FILIAL," 
	  	_cQuery += " C7_FORNECE,"
	  	_cQuery += " C7_LOJA,"
	  	_cQuery += " C7_NUM,"
	  	_cQuery += " C7_ITEM,"    
	  	_cQuery += " C7_USER,"   
	  	_cQuery += " C7_XTPCPR,"   	  	
	  	_cQuery += " C7_XMAILF, C7_XENVMAI"   	  		  	
	  	
	  	_cQuery += " FROM " + RetSqlName("SC7") + " SC7"
	  	_cQuery += " WHERE SC7.D_E_L_E_T_ <> '*'"
	  	_cQuery += " AND C7_FILIAL   = '" + cFilAnt + "'"
		_cQuery += " AND C7_TIPO=1      "									// 1-Pedido de compra
		_cQuery += " AND C7_CONAPRO='L' "									// Liberado
		_cQuery += " AND C7_APROV <> '      ' "							// Grupo Aprovador
	  	_cQuery += " AND C7_WF <> '1'"	      					    	// 1 Enviado EMAIL
	  	                     
	  	_cQuery += " ORDER BY"
	  	_cQuery += " C7_FILIAL," 
	  	_cQuery += " C7_NUM,"
	  	_cQuery += " C7_ITEM"
		  	
		TcQuery _cQuery New Alias "TMP"
	
		dbGotop()
		While !TMP->(Eof())

			_cNum	   := Padr(TMP->C7_NUM,50)
			
			DBSelectarea("SCR")
			DBSetOrder(1)
			DBSeek(TMP->C7_FILIAL+"PC"+_cNum,.T.)
                       
			_lAchou  := .F.
			_lAprov	:= .F.
			_cChave	:= ''
			_nTotal	:= 0
			
			While !SCR->(EOF()) .AND. ;
    				   		SCR->CR_FILIAL		== TMP->C7_FILIAL  	.AND. ;
		    	  			SCR->CR_TIPO 		== "PC" 					.AND. ;
        					TRIM(SCR->CR_NUM) == TRIM(TMP->C7_NUM)
        		
        		IF SCR->CR_STATUS == '03' .AND. !EMPTY(SCR->CR_LIBAPRO)   // SOMENTE CASO APROVADO
        				_cChave	:= SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
        				_lAprov	:= .T.
						_lAchou  := .T.        				
        				_nTotal	:= SCR->CR_TOTAL
        			ENDIF
        		
        		SCR->(DBSkip())
        	End

			IF !_lAchou
				DBSelectarea("SC7")
				DBSetOrder(1)
				IF DBSeek(TMP->(C7_FILIAL+C7_NUM+C7_ITEM))
					Reclock("SC7",.F.)
					SC7->C7_WF			:= "1"   	                        // Status 1 - envio email
		  			SC7->C7_WFID		:= "N/D"   									// Rastreabilidade
					MSUnlock()
				ENDIF
			ENDIF
				
    		IF _lAprov
				
				_aWF	 		:= EnviaPC(TMP->C7_FILIAL, PADR(TMP->C7_NUM, LEN(SCR->CR_NUM)), TMP->C7_USER , _cChave , _nTotal , CtoD('  /  /  '),'     ',_nOpc)
		
				  //==============================
				_lMailFor := .F.
				If TMP->C7_XTPCPR <> "E"
					DBSelectArea("SA2")
	     			DBSetOrder(1)
	    	    	DBSeek(xFilial("SA2")+TMP->C7_FORNECE+TMP->C7_LOJA)
	                If Alltrim(TMP->C7_XMAILF) <> "" .AND. TMP->C7_XENVMAI <> "S"                                                                           
	                		_cToFor := Alltrim(TMP->C7_XMAILF)
	    					U_CONSOLE("Chamando EnvPCFor para enviar pedido aprovado" )      					
	      					U_EnvPCFor	(TMP->C7_FILIAL	, TMP->C7_NUM, TMP->C7_USER, _cChave, _nTotal, ctod('  /  /  '), '     ', /*nOpc*/, _cToFor,,cEmpAnt)
      					
	      					_lMailFor := .T.
					Else
	    					 U_CONSOLE("Ignorando EnvPCFor, e-mail em branco ou mail forn ja processado anteriormente." )
	    			Endif
	    			 _lProcesso  := .T.                         
	    		EndIf					           
				//========================	           
				While !TMP->(EOF()) .AND. Alltrim(_cNum) == Alltrim(TMP->C7_NUM)

					DBSelectarea("SC7")
					DBSetOrder(1)
					IF DBSeek(TMP->(C7_FILIAL+C7_NUM+C7_ITEM))
						Reclock("SC7",.F.)
						SC7->C7_WF			:= IIF(EMPTY(_aWF[1]), " ", "1")   	// Status 1 - envio email / branco -nao enviado
			  			SC7->C7_WFID		:= _aWF[1]      // Rastreabilidade
			  			If SC7->C7_XENVMAI <> "S" .AND. _lMailFor
				  			SC7->C7_XENVMAI		:= "S"
				  		EndIf								
						MSUnlock()
					ENDIF
					
					TMP->(DBSkip())
				END
			ENDIF
			_lProcesso := .T.
		END
		
		dbSelectArea("TMP")
		dbCloseArea()

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³4 - Envia resposta de pedido bloqueado para o comprador³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
	CASE _nOpc == 4

		U_CONSOLE("4 - Envia resposta de pedido bloqueado para o comprador")

		U_CONSOLE("5 - EmpFil:" + cEmpAnt + cFilAnt)

	  	_cQuery := ""
	  	_cQuery += " SELECT"
	  	_cQuery += " CR_FILIAL," 
	  	_cQuery += " CR_TIPO,"   
	  	_cQuery += " CR_NUM,"    
	  	_cQuery += " CR_NIVEL," 
	  	_cQuery += " CR_TOTAL," 
	  	_cQuery += " CR_USER,"   
	  	_cQuery += " CR_APROV"    
	  	_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
	  	_cQuery += " WHERE SCR.D_E_L_E_T_ <> '*'"
	  	_cQuery += " AND CR_FILIAL = '" + cFilAnt + "'"
	  	_cQuery += " AND CR_LIBAPRO <> '      '" 		// Seleciona o Aprovador que reprovou
	  	_cQuery += " AND CR_STATUS = '04'"              // REPROVADO
	  	_cQuery += " AND CR_TIPO = 'PC'"                // PEDIDO DE COMPRA
	  	_cQuery += " AND CR_WF <> '1'"	      			// 1-Enviado
	  	_cQuery += " ORDER BY"
	  	_cQuery += " CR_FILIAL," 
	  	_cQuery += " CR_NUM,"
	  	_cQuery += " CR_NIVEL,"
	  	_cQuery += " CR_USER"
		  	
		TcQuery _cQuery New Alias "TMP"
		dbGotop()
		While !TMP->(Eof())
			DBSelectArea("SC7")
			DBSetOrder(1)
			DBSeek(xFilial("SC7")+Substr(TMP->CR_NUM,1,6))
			IF EMPTY(SC7->C7_APROV)
				DBSelectarea("SCR")
				DBSetOrder(2)
				IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
					Reclock("SCR",.F.)
					SCR->CR_WF	:= "1" 		 	// Status 1 - envio para aprovadores / branco-nao houve envio
		  			SCR->CR_WFID:= "N/D"		   // Rastreabilidade
					MSUnlock()
				ENDIF	
			ELSE 				
				_aWF := EnviaPC(TMP->CR_FILIAL, TMP->CR_NUM, SC7->C7_USER , TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV) , TMP->CR_TOTAL, ctod('  /  /  '), '     ', _nOpc)
				DBSelectarea("SCR")
				DBSetOrder(2)
				IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
					Reclock("SCR",.F.)
					SCR->CR_WF			:= IIF(EMPTY(_aWF[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
		  			SCR->CR_WFID		:= _aWF[1]							// Rastreabilidade
					MSUnlock()
				ENDIF
			ENDIF		
			_lProcesso := .T.
			dbSelectArea("TMP")
			DBSkip()
		End
		dbSelectArea("TMP")
		dbCloseArea()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³5 - ENVIO de Email - Acao TIME-OUT             		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE _nOpc	== 5
		U_CONSOLE("5 - Acao TimeOut")
		CHKFile("SAL")
		CHKFile("SCR")
		CHKFile("SC7")
		ChkFile("SCS")                    
		ChkFile("SAK")                    
		ChkFile("SM2")                    

		TimeOut()	

/*
		U_CONSOLE("1 - Liberação")
		TimeOut("1")	// LIBERAÇÃO

		U_CONSOLE("2 - Bloqueio")
		TimeOut("2")	// BLOQUEIO

		U_CONSOLE("3 - Notificação")
		TimeOut("3")	// NOTIFICAÇÃO

		U_CONSOLE("A - Envia para Superior")
		TimeOut("4")	// ENVIA PARA O SUPERIOR (SAK->AK_APROSUP)
*///======================================================================================
	END CASE			
	IF 	_lProcesso 
		U_CONSOLE(" Mensagem processada " )
	ELSE
		U_CONSOLE(" Nao houve processamento")
	ENDIF	
RETURN                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaPC   ºAutor  ³Microsiga           º Data ³  08/15/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EnviaPC(_cFilial,_cNum, _cUser, _cChave, _nTotal, _dDTLimit, _cHRLimit, _nOpc)
	Local aDados   := {}
	Local aJustif  := {}
	Local aCotacao := {}
	Local aFornece := {}
	Local aFortela := {}
	Local aProduto := {}
	Local _cCC	   := ''
	Local _cFornece, _cLoja 
	Local _cMailSol:= ''
	Local _aReturn := {}
	Private aMsg   := {}
	_cHttp		:= GetNewPar("MV_WFDHTTP", "http://COMPAQ:91/workflow")

	_nDD   	  	:= GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias
	_dDataLib	:= IIF( !EMPTY(_dDTLimit), _dDTLimit, MSDATE() )
	_cHoraLib	:= IIF( !EMPTY(_cHRLimit), _cHRLimit, LEFT(TIME(),5) )
	_cTimeOut	:= GetNewPar("MV_WFTOPC","24:00")		// WF-Workflow TO-TimeOut PC-Pedido de Compras    
	_nTimeOut  	:= (_nDD * 24) + VAL(LEFT(_cTimeOut,2)) + (VAL(RIGHT(_cTimeOut,2))/60)
	_cTo		:= IIF(_nOpc == 1, _cUser , UsrRetMail(_cUser))
//	_cTo		:= UsrRetMail(_cUser)
	_cEmail		:= UsrRetMail(_cUser)

	_aTimeOut	:= U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)                                                    
	
	If _nOpc ==3 .OR. _nOpc == 4
		_cMailSol := U_RetMailSol( Posicione("SC7",1, xFilial("SC7")+Alltrim(_cNum), "C7_NUMSC") )
		If !Empty( _cMailSol ) .AND. !(Alltrim(_cMailSol) $ _cTo)
			_cTo += ";" + _cMailSol
		EndIf
	EndIf
	

	//------------------- VALIDACAO
	
	/*_lError := .F.
	if Empty(_cTo)
		aMsg := {}
		cTitle  := "Administrador do Workflow : NOTIFICACAO" 
		aADD(aMsg , REPLICATE('*',80) )
		aADD(aMsg , Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' )
		aADD(aMsg , "Pedido de Compra No: " + _cNum + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(_cUser) )
		aADD(aMsg , "Campo EMAIL do cadastro de usuario NAO PREENCHIDO" )
		aADD(aMsg , REPLICATE('*',80) )
		
		_lError := .T.
	Endif
    */              
	
	IF _lError
		U_NotifyAdm(cTitle, aMsg)
		_aReturn := {}
		AADD(_aReturn, "")
		AADD(_aReturn, _aTimeOut[1])
		AADD(_aReturn, _aTimeOut[2])
		
		RETURN _aReturn
	ENDIF

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
              
	_cChaveSCR	:= _cFilial + 'PC' + _cNum
	_cNum 		:= PADR(ALLTRIM(_cNum),6)

	lDetalhe 	:= .F.	

	DBSelectArea("SCR")
	DBSetOrder(2)
	DBSeek(_cChaveSCR)

	DBSelectArea("SM0")
	DBSetOrder(1)
	DBSeek(cEmpAnt+cFilAnt)
	
	DBSelectArea("SC7")
	DBSetOrder(1)
	DBSeek(_cFilial+_cNum)

	_cNumCot := SC7->C7_NUMCOT

	DBSelectArea("SA2")
	DBSetOrder(1)
	DBSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

	DBSelectArea("SE4")
	DBSetOrder(1)
	DBSeek(xFilial("SE4")+SC7->C7_COND)

	DBSelectArea("SC1")
	DBSetOrder(1)
	DBSeek(_cFilial+_cNum,.f.)

	DBSelectArea("SAL")
	DBSetOrder(3)
	DBSeek(xFilial("SAL")+SC7->C7_APROV+SCR->CR_APROV)

	// REFAZ O TIMEOUT CONFORME REGRA NO CADASTRO DE GRUPO DE APROVADORES
	_nDD   	  	:= GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias
	_cTimeOut	:= GetNewPar("MV_WFTOPC","24:00")
	_dDataLib	:= IIF( !EMPTY(_dDTLimit), _dDTLimit, MSDATE() )
	_cHoraLib	:= IIF( !EMPTY(_cHRLimit), _cHRLimit, LEFT(TIME(),5) )
	_nTimeOut  	:= (_nDD * 24) + VAL(LEFT(_cTimeOut,2)) + (VAL(RIGHT(_cTimeOut,2))/60)
	_aTimeOut	:= U_GetTimeOut(_nTimeOut,_dDATALIB,_cHoraLib)

	DO CASE 
	//-------------------------------------------------------- INICIO PROCESSO WORKFLOW
		CASE _nOpc == 1		// Envio de email para aprovacao      
		// COLOCAR REGRA PARA CONTAR 4 DIAS AQUI....
				oProcess          	:= TWFProcess():New( "000001", "Envio Aprovacao PC :" + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PC para aprovacao: "+_cFilial + _cNum, "\WORKFLOW\HTML\PCAPROV_SZ.HTM" )
				oProcess:cSubject 	:= _cPrefMsg + Alltrim(SM0->M0_NOME)+" - Aprovacao do Pedido de Compra " + _cFilial + "/" +  _cNum
				oProcess:bReturn  	:= "U_WFPC(2)" //wfout descomentei esta linha para reenvio ao aprovação
//				oProcess:bTimeOut 	:= { { "U_WFPC(5)", _nDD, nHH, nMM } }
//				oProcess:attachfile(cAttachFile)	//wfout   

		CASE _nOpc == 3		// Envio de email Aprovacao para solicitante
		        
				oProcess          	:= TWFProcess():New( "000003", "Envio p/comprador PC aprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PC aprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\PCRESP_SZ.HTM" )   
//				oProcess:cSubject 	:= _cPrefMsg + Alltrim(SM0->M0_NOME)+" - Pedido de Compra aprovado " + _cFilial + "/" +  _cNum 
     			oProcess:cSubject   := _cPrefMsg + Alltrim(SM0->M0_NOME)+" - Pedido de Compra aprovado " + _cFilial + "/" +  _cNum+iif(!empty(ZZE->ZZE_NUMERO),"/ PA "+ZZE->ZZE_NUMERO,"")
				_cResposta			:= " A P R O V A D O "
		        //	_cCC				:= Alltrim(Posicione("SA2",1,xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA),"A2_EMAIL")) //ANDRE  para envio ao fornecedor     // descomentei para teste
			    //	If Empty(_cCC) 
			  	//_cFornece	:= SC7->C7_FORNECE 		// desomentei a sessão
				//	_cLoja		:= SC7->C7_LOJA	   	// desomentei a sessão
			    //	Else                            // desomentei a sessão
			   	//	oProcess:cCc  		:= _cCC  	// desomentei a sessão                        
			  	//Endif 							// desomentei a sessão  
			  
			
		CASE _nOpc == 4		// Envio de email Reprovado para solicitante
				oProcess          	:= TWFProcess():New( "000004", "Envio p/comprador PC reprovado : " + _cFilial + "/" +  TRIM(_cNum) )
				oProcess          	:NewTask( "Envio PC reprovado : "+_cFilial + _cNum, "\WORKFLOW\HTML\PCRESP_SZ.HTM" )
				oProcess:cSubject 	:= _cPrefMsg + Alltrim(SM0->M0_NOME)+" - Pedido de Compra reprovado " + _cFilial + "/" +  _cNum
				_cResposta				:= "<font color='#FF0000'>R E P R O V A D O </font>" 
				
	ENDCASE

	oProcess:cTo      		:= _cTo
	oProcess:UserSiga		:= _cUser
	oProcess:NewVersion(.T.)
	
 	oHtml     				:= oProcess:oHTML

	IF _nOpc == 1
		// Hidden Fields
		oHtml:ValByName( "OBS"		   , "" )      		
		oHtml:ValByName( "CR_USER"		, UsrFullName(_cUser))
		oHtml:ValByName( "CHAVE"	   , _cChave)
		oHtml:ValByName( "CFILANT"	   , cFilAnt)
		oHtml:ValByName( "WFID"		   , oProcess:fProcessId)
		oHtml:ValByName( "OBS"		   , "" )
//		oHtml:ValByName( "CR_USER"		, UsrFullName(_cUser))
	ENDIF

	IF _nOpc == 3 .OR. _nOpc == 4
		oHtml:ValByName( "mensagem" , _cResposta)	 
	ENDIF
   
	oHtml:ValByName( "CEMPANT"		, SM0->M0_NOME )
	oHtml:ValByName( "C7_FILIAL"	, SM0->M0_FILIAL )
	oHtml:ValByName( "C7_NUM"		, SC7->C7_NUM )
	oHtml:ValByName( "C7_EMISSAO"	, DTOC(SC7->C7_EMISSAO) )    
	 
//	If _nOpc == 1
		 If SC7->C7_XTPCPR $ "E,D"  
	 		_cComprad:= Posicione ("SC1",1,xFilial("SC1")+SC7->C7_NUMSC,"C1_USER")
		 ELSE 
		 	_cComprad:=SC7->C7_USER
		 ENDIF
		oHtml:ValByName( "C7_USER"		, UsrFullName(_cComprad))
//	Else
//		oHtml:ValByName( "C7_USER"		, UsrFullName(SC7->C7_USER))
//	EndIf		
	                                    
	_cCCAprov	:= IIF(Empty(SC7->C7_CC), SC7->C7_XCCAPR, SC7->C7_CC ) 
	_cCdSolic	:= Posicione ("SC1",1,xFilial("SC1")+SC7->C7_NUMSC,"C1_USER")
	oHtml:ValByName( "C7_XTPCPR"	, X3Combo("C7_XTPCPR",SC7->C7_XTPCPR))  //ANDRE
	oHtml:ValByName( "A2_COD"		, SA2->A2_COD)
	oHtml:ValByName( "A2_NOME"		, SA2->A2_NOME)
	oHtml:ValByName( "A2_EMAIL"		, SC7->C7_XMAILF)    //ANDRE  
	oHtml:ValByName( "A2_TEL"		, SA2->A2_TEL)     //ANDRE  
	oHtml:ValByName( "C7_COND"		, SC7->C7_COND + " / " + POSICIONE("SE4", 1, XFILIAL("SE4") + SC7->C7_COND, "E4_DESCRI")) //ANDRE  
   	oHtml:ValByName( "C7_OBS"		, Alltrim(SC7->C7_XOBSAPR) )    //ANDRE 
   	oHtml:ValByName( "C7_NUMSC"		, SC7->C7_NUMSC )//ANDRE 
	oHtml:ValByName( "C7_SOLICIT"	, UsrFullName(_cCdSolic))//ANDRE 
	oHtml:ValByName( "C7_CC"    	, _cCCAprov + " / " + POSICIONE("CTT", 1, XFILIAL("CTT") + _cCCAprov, "CTT_DESC01"))//ANDRE  

	oHtml:ValByName( "C7_VALPA"		, TRANSFORM(SC7->C7_XVALPA,'@E 9,999,999.99') )    //Vitor  
	oHtml:ValByName( "C7_VENPA"		, DTOC(SC7->C7_XVENPA))    //Vitor  		
	

//	oHtml:ValByName( "CR_TOTAL"	, TRANSFORM(_nTotal,'@E 999,999.99'))

	//-------------------------------------------------------------
	// ALIMENTA A TELA DE ITENS DO PEDIDO DE COMPRA
	//-------------------------------------------------------------
	_nC7_TOTAL		:= 0
	_nC7_VLDESC		:= 0
	_nFRETEDESP		:= 0     
	cObpc			:=""

	aTemp			:= {} 
	
	While !SC7->(EOF()) .AND. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == _cNum
           
    	//cObpc+= ALLTRIM(SC7->C7_OBS)+" "      //ANDRE
                                             
		DBSELECTAREA("SB1")
		DBSetOrder(1)
		DBSeek(xFilial()+SC7->C7_PRODUTO)

		DBSELECTAREA("SBM")
		DBSetOrder(1)
		DBSeek(xFilial()+SB1->B1_GRUPO)      

		DBSELECTAREA("SB5")
		dbSetOrder(1)       
		_cDescPro := SC7_DESCRI
		If SB5->(dbSeek( xFilial("SB5") + SC7->C7_PRODUTO )) 
			if empty(SB5->B5_CEME)
			_cDescPro := SB5->B5_CEME   
			endif
		Else
//			_cDescPro := SB1->B1_DESC
		EndIf

		AAdd( (oHtml:ValByName( "t.1"    )), SC7->C7_ITEM)
		AAdd( (oHtml:ValByName( "t.2"    )), SC7->C7_PRODUTO + " - " +_cDescPro)
		AAdd( (oHtml:ValByName( "t.3"    )), TRANSFORM(SC7->C7_QUANT,'@E 9,999,999.99'))
		AAdd( (oHtml:ValByName( "t.4"    )), Alltrim(SC7->C7_ITEMCTA)+"-"+Alltrim(Posicione("CTD",1,xFilial("CTD")+SC7->C7_ITEMCTA,"CTD_DESC01")) ) //andre aprovação
		AAdd( (oHtml:ValByName( "t.5"    )), TRANSFORM(SC7->C7_PRECO					,'@E 9,999,999.99'))
		AAdd( (oHtml:ValByName( "t.6"    )), TRANSFORM(SC7->C7_VALFRE + SC7->C7_DESPESA	,'@E 9,999,999.99'))
		AAdd( (oHtml:ValByName( "t.7"    )), TRANSFORM(SC7->C7_VLDESC 					,'@E 9,999,999.99'))
//		AAdd( (oHtml:ValByName( "t.8"    )), TRANSFORM(SC7->C7_QUANT*(SC7->C7_PRECO + (SC7->C7_VALFRE + SC7->C7_DESPESA) - SC7->C7_VLDESC),'@E 9,999,999.99'))
		AAdd( (oHtml:ValByName( "t.8"    )), TRANSFORM((SC7->C7_QUANT*SC7->C7_PRECO) + (SC7->C7_VALFRE + SC7->C7_DESPESA - SC7->C7_VLDESC),'@E 9,999,999.99'))
		AAdd( (oHtml:ValByName( "t.9"   )), SC7->C7_DATPRF)  
	   //	oHtml:ValByName( "C7_OBS"		, cObpc)    //ANDRE 
		
		_nC7_TOTAL 		:= _nC7_TOTAL 		+ SC7->C7_TOTAL
		_nC7_VLDESC		:= _nC7_VLDESC		+ SC7->C7_VLDESC
		_nFRETEDESP	:= _nFRETEDESP	+ (SC7->C7_VALFRE + SC7->C7_DESPESA)
		SC7->(dbSkip()) 
	Enddo
	oHtml:ValByName( "CR_TOTAL"	    , TRANSFORM(_nC7_TOTAL 							,'@E 99,999,999.99'))
	oHtml:ValByName( "DESCONTO" 	, TRANSFORM(_nC7_VLDESC							,'@E 99,999,999.99'))
	oHtml:ValByName( "FRETEDESP"	, TRANSFORM(_nFRETEDESP							,'@E 99,999,999.99'))
	oHtml:ValByName( "CR_LIQUIDO"   , TRANSFORM(_nC7_TOTAL-_nC7_VLDESC+_nFRETEDESP 	,'@E 99,999,999.99'))
//	
//  Imprimir as cotacoes 
// 
  //	If _nOpc == 1 .and. _cNumCot <> ''
	//	oHtml:ValByName( "C8_NUM"   , Iif(Alltrim(_cNumCot) = '','***Não há cotação para este pedido***',_cNumCot))
	  //	DBSelectArea("SC8")
	  //	DBSetOrder(1)
	  //	DBSeek(xFilial("SC8")+_cNumCot) 
	//	WFVcota(_cNumCot, _cNum)

		//-------------------------------------------------------------
		// ALIMENTA A TELA DE PROCESSO DE APROVAÇÃO DE PEDIDO DE COMPRA
		//-------------------------------------------------------------
		
		_cCHAVESCR := SUBS(_cCHAVE, 1, 54) // 01PC123456
		DBSelectarea("SCR")
		DBSetOrder(1)
		DBSeek(_cCHAVESCR,.T.)
		
		WHILE !SCR->(EOF()) .AND. SCR->(CR_FILIAL+CR_TIPO+CR_NUM) == _cCHAVESCR
			cSituaca := ""
			Do Case
	             Case SCR->CR_STATUS == "01"
	                     cSituaca := "Aguardando"
	             Case SCR->CR_STATUS == "02"
	                     cSituaca := "Em Aprovacao"
	             Case SCR->CR_STATUS == "03"
	                     cSituaca := "Aprovado" //Iif(_nOpc == 3,"Aprovado","Reprovado")
	             Case SCR->CR_STATUS == "04"
	                     cSituaca := "Bloqueado"
	                     lBloq := .T.
	             Case SCR->CR_STATUS == "05"
	                     cSituaca := Iif(_nOpc == 3,"Nivel Liberado","Nivel Bloqueado")
	        EndCase	
	                                             
			_cT4 := UsrRetName(SCR->CR_USERLIB)
			_cT6 := SCR->CR_OBS
			
		   //	AAdd( (oHtml:ValByName( "ta.1"    )), SCR->CR_NIVEL)   
			AAdd( (oHtml:ValByName( "ta.2"    )), UsrFullName(SCR->CR_USER))
			AAdd( (oHtml:ValByName( "ta.3"    )), cSituaca    )
			AAdd( (oHtml:ValByName( "ta.4"    )), IIF(EMPTY(_cT4),"", _cT4))
			AAdd( (oHtml:ValByName( "ta.5"    )), DTOC(SCR->CR_DATALIB))
			AAdd( (oHtml:ValByName( "ta.6"    )), IIF(EMPTY(_cT6),"", _cT6))
			
			SCR->(DBSkip())
	   ENDDO
//	Endif
	// ARRAY DE RETORNO
	_aReturn := {}
	AADD(_aReturn, oProcess:fProcessId)
	AADD(_aReturn, _aTimeOut[3])
	AADD(_aReturn, _aTimeOut[4])	//ANDRE
	oHtml:ValByName( "data_hora"	, DTOC(MSDATE()) + " as " + LEFT(TIME(),5) )
	oProcess:nEncodeMime := 0    
	
	DO CASE
		CASE _nOpc == 1

				cSubject  := oProcess:cSubject
				
				cProcess := oProcess:Start("\workflow\wfpc\")	// start workflow
				AADD(_aReturn, cProcess)  // para gravar o nome do html na SCR //link timeout Vitor 28/11/13

				aMsg := {}
				aaDD(aMsg, "Sr. Aprovador,")
				aaDD(aMsg, "<br></br>")
				AADD(aMsg, 'O <a href="' + _cHttp + '/workflow/wfpc/'  + alltrim(cProcess) + '.htm">Pedido de Compra No.: ' + _cNum + '</a> aguarda seu parecer.')
				aaDD(aMsg, "<br></br>")
				aaDD(aMsg, "<br></br>")
//				AADD(aMsg, "Código de controle : <i>" + oProcess:fProcessId + "</i>")
				
				U_MailNotify( _cEmail, cSubject , aMsg )      // comentei apenas testes locais //
		OTHERWISE               
				oProcess:Start()
	END CASE

	// Envia aviso aos fornecedores
	return _aReturn
                            



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Empresa  ³ MICROSIGA S.A                                               ±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Funcao   ³    ³ Autor ³ ³                                       Data ³³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Geracao do html Mapa de Cotacao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ZS                                                         ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


Static Function WFVcota(cCotacao, cPedido)

	Local aDados   := {}
	Local aJustif  := {}
	Local aCotacao := {}
	WFProc(cCotacao,cPedido,@aDados,@aJustif,@aCotacao )
	WFFormato(@aDados,@aJustif,@aCotacao)
	Return
	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³WFFormato ³ Autor ³ Everson Carlos        ³ Data ³25/04/2013  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Mapa de Cotacao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SZ                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
                           
Static Function WFFormato(aDados,aJustif,aCotacao)
	Local aFornece := {}
	Local aForTela := {}
	Local aTotais  := {{0,0,Space(25),Space(25)},{0,0,Space(25),Space(25)},{0,0,Space(25),Space(25)},{0,0,Space(25),Space(25)}}
	Local aPosTela := {45+60,73+60,101+60,129+60}
	Local aPosFor  := {{45+60,46+60,47+60,48+60,58+60,59+60,69+60,70+60},{73+60,74+60,75+60,76+60,86+60,87+60,97+60,98+60},{101+60,102+60,103+60,104+60,114+60,115+60,125+60,126+60},{129+60,130+60,131+60,132+60,142+60,143+60,153+60,154+60}}
	Local cCabec1  := " "
	Local cCabec2  := " "
	Local cCotacao := " "
	Local cLinha   := ""
	Local cCCust   := ""
	Local nPosFor  := 0
	Local nTotMP   := 0
	Local nPaginas := 0
	Local nLimLnh  := 90
	Local nTam     := 0
	Local nNumFor  := 0
	Local nJust    := 0
	Local nCol     := 0
	Local nObs     := 0
	Local nc, nf, np, nj, no, nLi 
	Local nw 	   := 0
	
	Private Li          := 0
	Private LiPag       := 7
	Private nPag        := 0
	Private cTexto		:= ""
	
	
	If Len(aCotacao) = 0 // quando nao houver cotacao //
		AAdd( (oHtml:ValByName( "tc.1"    )), '') 
		AAdd( (oHtml:ValByName( "tc.2"    )), '') 
		AAdd( (oHtml:ValByName( "tc.3"    )), '')
		AAdd( (oHtml:ValByName( "tc.4"    )), '') 
	    For nz := 1 To 4
			AAdd( (oHtml:ValByName( "tc.5"+Alltrim(Str(nz))    )), "")
			AAdd( (oHtml:ValByName( "tc.5"+Alltrim(Str(nz))+"t")), "")
		Next nz
	Else
		For nc := 1 To Len(aCotacao)
			cCCust   := Posicione("CTT",1,xFilial("CTT")+aCotacao[nc,4],"CTT_DESC01")
			aFornece := aCotacao[nc,3]
			aProduto := aCotacao[nc,2]
			nPaginas := 0
			nTotMp   := 0
			nNumFor  := Len(aFornece)
			
		//	NUMERO DE COMULA POR FORNECEDOR
			While nNumFor <> 4
				If nNumFor < 4
					aAdd(aFornece, {" "," "," "," "})
					nNumFor  := Len(aFornece)
				Else
					nNumFor-=4
				EndIf
			EndDo
			
			nNumFor := Len(aFornece)
			For nPag := 1 To nNumFor Step 4
			  	
				nPaginas++
				nPosFor  := 0
				aForTela := {}
		
				WFCabec(@nPag,aCotacao[nc,1],@aFornece,nPosFor,@aForTela,nPaginas,nNumFor/4,cCCust,aCotacao[nc,5])		
		
				nPosFor  := 0
				For nf := nPag To nPag+3
					nPosFor++
				Next nf
				Li := 385
		
				For np:=1 To Len(aProduto)		
		
		          LiPag++
		          If LiPag <= 30
		
					cProduto := AllTrim(aProduto[np,2]+" - "+AllTrim(Left(Posicione("SB1",1,xFilial("SB1")+aProduto[np,2],"B1_DESC"),30))+" ")
					nObs := Len(cProduto)/nLimLnh
					nObs := Iif(Int(nObs)<nObs,Int(nObs)+1,Int(nObs))
		
					For no := 1 To nObs
						If no == 1
							AAdd( (oHtml:ValByName( "tc.1"    )), aProduto[np,1]) 
						EndIf
						AAdd( (oHtml:ValByName( "tc.2"    )), SubStr(cProduto,(no*nLimLnh-nLimLnh+1),nLimLnh)) 
					Next no
		                            
					AAdd( (oHtml:ValByName( "tc.3"    )), aProduto[np, 3])
					AAdd( (oHtml:ValByName( "tc.4"    )), Transform(aProduto[np, 4],"@E 99,999")) 
		            
		            nw:= 0
		            For nz := 1 To Len(aForTela)
						nPosDados := aScan(aDados,{ |x| x[1]+x[2]+x[3]+x[4]+x[5] == aCotacao[nc,1]+aProduto[np,1]+aProduto[np,2]+aForTela[nz,1]+aForTela[nz,2]})
						If nPosDados <>  0
							AAdd( (oHtml:ValByName( "tc.5"+Alltrim(Str(nz))    )), Transform(aDados[nPosDados,6],"@E 999,999.99"))
							AAdd( (oHtml:ValByName( "tc.5"+Alltrim(Str(nz))+"t")), Transform(aDados[nPosDados,7],"@E 999,999.99"))
							aForTela[nz, 5] += aDados[nPosDados,7]
							aForTela[nz, 6] += Iif(aDados[nPosDados,12] == "*",aDados[nPosDados,7],0)
							aForTela[nz, 7] := Space(5) + Posicione("SE4",1,xFilial("SE4")+aDados[nPosDados,9],"E4_DESCRI") + Space(5)
							aForTela[nz, 8] := Space(8) + Str(aDados[nPosDados,10],4) + " Dias        "
							aForTela[nz, 9] += aDados[nPosDados,13]
							aForTela[nz,10] += aDados[nPosDados,14]
							aForTela[nz,11] += aDados[nPosDados,15]
							aForTela[nz,12] += aDados[nPosDados,16]
							aForTela[nz,13] += aDados[nPosDados,18] //ANDRE
							nTotMP		    += Iif(aDados[nPosDados,12] == "*",aDados[nPosDados,7],0)
						Else
							AAdd( (oHtml:ValByName( "tc.5"+Alltrim(Str(nz))    )), "")
							AAdd( (oHtml:ValByName( "tc.5"+Alltrim(Str(nz))+"t")), "")
						EndIf
					Next nz
		         EndIf	
		         		
				Next np
		
				//Total
				oHtml:ValByName( "TOTAL1"   , _cNumCot)
				For ni := 1 To 4
					oHtml:ValByName( "TOTAL"+Alltrim(Str(ni))   , Transform(aForTela[ni,5],"@E 99,999,999.99"))
				Next
		
				//Imprime Descontos
				For ni := 1 To 4
					oHtml:ValByName( "DESC"+Alltrim(Str(ni))   , Transform(aForTela[ni,9],"@E 99,999,999.99"))
				Next
		
		        //Imprime Valor Frete+Despesa
				For ni := 1 To 4
					oHtml:ValByName( "FRETDESP"+Alltrim(Str(ni))   , Transform(aForTela[ni,10],"@E 99,999,999.99"))
				Next
		//		Li := Li+55
		
		        //Imprime Total Geral
				For ni := 1 To 4
					oHtml:ValByName( "TOTGER"+Alltrim(Str(ni))   , Transform(aForTela[ni,5]-aForTela[ni,9]+aForTela[ni,10],"@E 99,999,999.99"))
				Next
		//		Li := Li+55
		
				//Imprime Cond. Pagto.
				For ni := 1 To 4
					oHtml:ValByName( "CONDPAG"+Alltrim(Str(ni))   , AllTrim(aForTela[ni,7]))
				Next
				Li := Li+55
		
				//Imprime Pz. Entrega
				For ni := 1 To 4
					oHtml:ValByName( "PRAZO"+Alltrim(Str(ni))   , AllTrim(aForTela[ni,8]))
				Next
		
				nLinhas := 0     
				 //	oHtml:ValByName( "C7_OBS"		, cObpc)    //ANDRE 
				//========================MOTIVO===============================
				   //	oHtml:ValByName( "OBS", AllTrim(aForTela[ni,13]))//andre  utilizadi para justificar a escolha da cotação
				//=============================================================				
				If Len(AllTrim(aForTela[2,4]))/25 > nLinhas
					nLinhas := Len(AllTrim(aForTela[2,4]))/25
				EndIf
				If Len(AllTrim(aForTela[3,4]))/25 > nLinhas
					nLinhas := Len(AllTrim(aForTela[3,4]))/25
				EndIf
				If Len(AllTrim(aForTela[4,4]))/25 > nLinhas
					nLinhas := Len(AllTrim(aForTela[4,4]))/25
				EndIf
				
				If Int(nLinhas)<nLinhas .Or. nLinhas == 0
					nLinhas := Int(nLinhas)+1
				Else
					nLinhas := Int(nLinhas)
				EndIf
		
				nLi :=1
		
				// Observação
				
				For nb:=1 To nLinhas
					For ni := 1 To 2
		//				oPrint:Say(Li+220,3000-nDisColum*(5-ni)+15,aForTela[ni,4], oFtItem3 )
					Next
					nLi+=25
					Li := Li+55
				Next nb
			Next nPag
			nTotMP   := 0
		
		Next nX
	Endif	
	Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³  WFProc   ³ Autor ³ Everson Carlos        ³ Data ³25/04/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SZ                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function WFProc(cCotacao,cPedido,aDados,aJustif,aCotacao)

Local cAliasTRB := AllTrim("SindSC8" + xFilial("SC8"))
Local cUltComp  := 0
Local cQuery  	:= ""
Local cVencedor := " "
Local cContato  := " "
Local cSolicit  := ""
Local cObserv   := ""
Local cObserv1  := ""
Local nPos      := 0
Local nPosProd  := 0
Local nPosForn  := 0
Local aProduto  := {}
Local aFornece  := {}

dbSelectArea("SC8")
dbSetOrder(1)
dbSeek(xFilial("SC8")+cCotacao,.T.)
While !SC8->(Eof()) .And. SC8->C8_NUM <= cCotacao
	
//C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM
	DbselectArea("SC7")
	DbSetOrder(4)
	If SC7->(DbSeek(SC8->(C8_FILIAL+C8_PRODUTO)+cPedido))
		dbSelectArea("SC8")
		cVencedor := If(AllTrim(C8_NUMPED+C8_ITEMPED)=="XXXXXXXXXX".Or.Empty(C8_NUMPED+C8_ITEMPED)," ","*")
		cSolicit  := SC8->(C8_NUMSC+C8_ITEMSC)
//		cObserv   := IIF(!Empty(C8_OBS+C8_XOBS),AllTrim(C8_OBS)+" "+AllTrim(C8_XOBS)," ")
		//cObserv1  := IIF(!Empty(C8_XOBS),AllTrim(C8_ITEM)+"-"+AllTrim(C8_XOBS)," ")
		cTpPlan   := Posicione("SB1",1,xFilial("SB1")+C8_PRODUTO,"B1_GRUPO")
		cUltComp  := Posicione("SB1",1,xFilial("SB1")+C8_PRODUTO,"B1_UPRC")
		cTpPlan   := Posicione("SBM",1,xFilial("SBM")+cTpPlan,"BM_DESC")
		
	   //	aAdd(aDados,{	C8_NUM, C8_ITEM, C8_PRODUTO, C8_FORNECE, C8_LOJA, C8_PRECO, C8_TOTAL+C8_VALIPI,;
		 //				C8_ALIIPI, C8_COND, C8_PRAZO, AllTrim(C8_OBS), cVencedor,C8_VLDESC, C8_VALFRE+C8_DESPESA+C8_SEGURO,;
		 //				C8_VALIPI, C8_VALICM, cUltComp,C8_MOTIVO})//ANDRE
		
		nPos     := aScan(aCotacao, { |x| x[1] == C8_NUM})
		If nPos == 0
			aFornece := {}
			aProduto := {}
			aAdd(aProduto ,{C8_ITEM, C8_PRODUTO, C8_UM, C8_QUANT, Posicione("SC1",1,xFilial("SC1")+cSolicit,"C1_OBS")})
			aAdd(aFornece ,{C8_FORNECE, C8_LOJA, C8_CONTATO,cObserv})
			aAdd(aCotacao ,{C8_NUM ,aProduto ,aFornece,Posicione("SC1",1,xFilial("SC1")+cSolicit,"C1_CC"),cSolicit})
		Else
			
			nPosProd := aScan(aCotacao[nPos,2],{ |x| x[1]+x[2] == C8_ITEM+C8_PRODUTO })
			nPosForn := aScan(aCotacao[nPos,3],{ |x| x[1]+x[2] == C8_FORNECE+C8_LOJA })
			
			If nPosProd == 0
				aProduto := aCotacao[nPos,2]
				aAdd(aProduto,{C8_ITEM, C8_PRODUTO, C8_UM, C8_QUANT, Posicione("SC1",1,xFilial("SC1")+cSolicit,"C1_OBS")})
				aCotacao[nPos,2] := aProduto
			EndIf
			If nPosForn == 0
				aFornece := aCotacao[nPos,3]
				aAdd(aFornece,{C8_FORNECE, C8_LOJA, C8_CONTATO, cObserv})
				aCotacao[nPos,3] := aFornece
			Else
				If !Empty(cObserv)
					aFornece[nPosForn,4]:= aFornece[nPosForn,4]+"; "+cObserv
					aCotacao[nPos,3] := aFornece
				EndIf
			EndIf
		EndIf
	Endif
	dbSelectArea("SC8")
	dbSkip()
EndDo

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ WFCABEC ³ Autor ³ Everson Carlos        ³ Data ³14/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SZ                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function WFCabec(nPag,cCotacao,aFornece,nPosFor,aForTela,nPaginas,nPgTot,cCCust,cSolicit)
       
Local lMonta := Len(aForTela)==0
Local cNumSc   := ""
Local cUsuCota := ""     
Local cMotiv   := ""
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Traz o Solicitante e o Motivo da Compra do MP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//
cNumSc := Posicione("SC8",1,xFilial("SC8")+cCotacao,"C8_NUMSC")
If !Empty(cNumSc)
	cUsuCota := Posicione("SC1",1,xFilial("SC1")+cNumSc,"C1_SOLICIT")
	cMotiv   := "" //Posicione("SC1",1,xFilial("SC1")+cNumSc,"C1_S_MOTIV")
EndIf	

For nf := 1 To 4
	nPosFor++	
//	oPrint:Box(220,3000-nDisColum*(5-nPosFor),330,3000-nDisColum*(4-nPosFor),oPen)
	If !Empty(aFornece[nf,1]+aFornece[nf,2])
		oHtml:ValByName( "FORN"+ALLTRIM(Str(nf)), SubStr(AllTrim(Posicione("SA2",1,xFilial("SA2")+aFornece[nf,1]+aFornece[nf,2],"A2_NREDUZ")),1,15) )
		oHtml:ValByName( "FONE"+ALLTRIM(Str(nf)), AllTrim(Posicione("SA2",1,xFilial("SA2")+aFornece[nf,1]+aFornece[nf,2],"A2_TEL")) )
		oHtml:ValByName( "CONTATO"+ALLTRIM(Str(nf)), aFornece[nf,3])
	Else
		oHtml:ValByName( "FORN"+ALLTRIM(Str(nf)), "" )
		oHtml:ValByName( "FONE"+ALLTRIM(Str(nf)), "" )
		oHtml:ValByName( "CONTATO"+ALLTRIM(Str(nf)), "")
	EndIf

//	oPrint:Say(345,3000-nDisColum*(5-nPosFor)+63,"Pr Unit.", oFtItem1 )
//	oPrint:Say(345,3000-nDisColum*(5-nPosFor)+(nDisColum/2)+16,"Pr. Total", oFtItem1 )
	//
	aAdd(aForTela,{aFornece[nf,1],aFornece[nf,2],aFornece[nf,3],aFornece[nf,4],0,0,Space(25),Space(25),0,0,0,0})
Next
//
//if mv_par06 == 1
//   oPrint:Box(330,3000-nDisColum*(5-nPosFor)+(nDisColum/2),385,3221-nDisColum*(4-nPosFor),oPen)    // Ultima Compra
//   oPrint:Say(345,3000-nDisColum*(5-nPosFor)+(nDisColum/2)+227,"Ult. Comp.", oFtItem1 )            // Ultima Compra
//endif   
//
Li := 1350

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TimeOUT   ºAutor  ³Microsiga           º Data ³  10/22/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 TimeOut -                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TimeOut() //wfout
Local _cQuery                             
Local _nQtdEnvio	:= GetNewPar("MV_XQTDENV", 3 )// DEFINE O QTD DE ENVIO WF       
_cHttp		:= GetNewPar("MV_WFDHTTP", "http://COMPAQ:91/workflow")

  	_cQuery := ""
  	_cQuery += " SELECT DISTINCT "
  	_cQuery += " C7_USER, "
  	_cQuery += " C7_FILIAL, "
  	_cQuery += " C7_NUM, "
  	_cQuery += " C7_FORNECE, "
  	_cQuery += " C7_LOJA, "
  	_cQuery += " C7_EMISSAO,"
  	_cQuery += " C7_APROV,"   
  	_cQuery += " CR_WFLINK,"
//  	_cQuery += " AL_TIMEOUT,"    
  	_cQuery += " CR_FILIAL, "
  	_cQuery += " CR_TIPO,"
  	_cQuery += " CR_NUM,"
  	_cQuery += " CR_NIVEL,"
  	_cQuery += " CR_USER,"
  	_cQuery += " CR_APROV,"
  	_cQuery += " CR_TOTAL,"
  	_cQuery += " CR_DTLIMIT,"
  	_cQuery += " CR_HRLIMIT,"
  	_cQuery += " CR_XQTDENV "
  	_cQuery += " FROM " + RetSqlName("SCR") + " SCR"
  	_cQuery += " JOIN " + RetSqlName("SC7") + " SC7 ON (C7_FILIAL = '" + xFilial('SC7') + "' "       
  	If Upper(TcGetDb()) = "ORACLE"                
  		_cQuery += " AND C7_NUM = SUBSTR(CR_NUM,1,6) "
  	Else
	  	_cQuery += " AND C7_NUM = LEFT(CR_NUM,6) "
	EndIf
  	_cQuery += " AND C7_APROV <> '      ' AND C7_CONAPRO = 'B' AND SC7.D_E_L_E_T_ = ' ' )"		
  	_cQuery += " JOIN " + RetSqlName("SAL") + " SAL ON (AL_FILIAL = '" + xFilial('SAL') + "' AND AL_COD = C7_APROV AND AL_APROV = CR_APROV AND SAL.D_E_L_E_T_ = ' ' )"		
  	_cQuery += " WHERE SCR.D_E_L_E_T_ = ' '"		
  	_cQuery += " AND CR_FILIAL 	= '" + xFilial('SCR') +"'"
  	_cQuery += " AND CR_STATUS 	= '02'"				
  	_cQuery += " AND CR_TIPO 	= 'PC'"				
  	_cQuery += " AND CR_DTLIMIT  <= '" + DTOS(MSDATE()) + "'"
  	_cQuery += " AND CR_WF 	= '1'"		
  	_cQuery += " AND CR_WFID 	<> ' '"		
  	_cQuery += " AND CR_XQTDENV < " + str(_nQtdEnvio) // DEFINE QUE ENQUANTO A QTD DE ENVIO FOR MENOR QUE _nQtdEnvio O SISTEMA FAZ O LOOP..

  	_cQuery += " ORDER BY"
  	_cQuery += " C7_USER," 
  	_cQuery += " CR_DTLIMIT,"
  	_cQuery += " CR_HRLIMIT"

	TcQuery _cQuery New Alias "TMP"

	dbGotop()

	IF !TMP->(Eof())
	   	_cUser		:= ""         
		_cTimeOut	:= GetNewPar("MV_WFTOPC","24:00")		// WF-Workflow TO-TimeOut SA-Solicitacao Armazem -- caracter
	
		While !TMP->(Eof())
	
			IF TMP->CR_DTLIMIT == DTOS(MSDATE())
				IF TMP->CR_HRLIMIT  >  LEFT(TIME(),5)
					TMP->(DBSkip())
					LOOP						
				ENDIF
			ENDIF

			IF _cUser <> TMP->C7_USER
				_cUser 		:= TMP->C7_USER
				_aReg	 	:= {}
			ENDIF
		
			_nDD   	  	:= GetNewPar("MV_WFTODD", 0)		// TimeOut - Dias       numerico 04
			_cTimeOut	:= _cTimeOut 
			_nTimeOut  	:= (_nDD * 24) + VAL(LEFT(_cTimeOut,2)) + (VAL(RIGHT(_cTimeOut,2))/60)
			_aTimeOut	:= U_GetTimeOut(_nTimeOut, StoD(TMP->CR_DTLIMIT),TMP->CR_HRLIMIT)
	
			DBSelectArea("SCR")
			DBSetOrder(2)
			DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
			IF FOUND()
				RECLOCK("SCR",.F.)
				SCR->CR_DTLIMIT	:= _aTimeOut[3]	 // ALTERADO [1] PARA [3] PARA RECEBER A NOVA DATA NO CAMPO CR_DTLIMIT //ANDRE
				SCR->CR_HRLIMIT	:= _aTimeOut[2]
				SCR->CR_XQTDENV := SCR->CR_XQTDENV + 1  // INCREMENTADO ESTA LINHA PARA RECEBER A QTD DE ENVIO DO WF
				MSUNLOCK()
			ENDIF
	
			AADD( _aReg, {;
					TMP->C7_FILIAL + "-" +TMP->C7_NUM, ;
					DTOC(STOD(TMP->C7_EMISSAO)), ;
					TMP->C7_FORNECE, ;
					DTOC(STOD(TMP->CR_DTLIMIT)) + '-' + TMP->CR_HRLIMIT, ;
					TMP->CR_NIVEL, ;
					UsrRetName(TMP->CR_USER),;
					UsrRetMail(TMP->CR_USER)})

			cTo		:= UsrRetMail(TMP->CR_USER)   
			/* //Comentado este bloco porque passou a enviar o link do timeout no email, logo - Vitor 28/11/13
			If TMP->CR_XQTDENV == 1 //Identifica que no segundo e-mail enviara tambem para superior
				SAK->( DbSetOrder(1)) 
				If SAK->( DbSeek(xFilial("SAK") + TMP->CR_APROV ))
					If !Empty(SAK->AK_APROSUP)
						If SAK->( DbSeek(xFilial("SAK") + SAK->AK_APROSUP ))					
							cTo += ";" + UsrRetMail(SAK->AK_USER)
						EndIf
					EndIf
				EndIf
			EndIf                                                                                             
			*/
			/* //Comentado este bloco porque passou a enviar o link do timeout no email, logo - Vitor 28/11/13
			If TMP->CR_XQTDENV == (_nQtdEnvio-1) //Ultimo envio de e-mail Timeout
				_cMailSol := U_RetMailSol( Posicione("SC7",1, xFilial("SC7")+TMP->C7_NUM, "C7_NUMSC") )
				If !Empty( _cMailSol ) .AND. !(Alltrim(_cMailSol) $ cTo)
					cTo += ";" + _cMailSol
				EndIf					
			EndIf
			*/
			cTitle	:= _cPrefMsg + Alltrim(SM0->M0_NOME)+" - TimeOut Pedido de Compras No." + TMP->C7_FILIAL+"-"+TMP->C7_NUM
			aMsg := {}
			aaDD(aMsg, Dtoc(MSDate()) + " - " + Time() + " Sr Aprovador: " + UsrFullName(TMP->CR_USER))   
			AADD(aMsg, 'O <a href="' + _cHttp + '/workflow/wfpc/'  + alltrim(TMP->CR_WFLINK) + '.htm">Pedido de Compra No.: '+ Alltrim(SM0->M0_NOME)+":" +TMP->C7_FILIAL+"-"+ TMP->C7_NUM + '</a> encontra-se pendente de sua aprovação .')
//			aaDD(aMsg, " O pedido de compras "+ Alltrim(SM0->M0_NOME)+":" +TMP->C7_FILIAL+"-"+ TMP->C7_NUM + " encontra-se pendente de sua aprovação .") //28/11/13 Vitor 
         
			U_MailNotify(cTo, cTitle, aMsg)

			dbSelectArea("TMP")
			DBSkip()
	
			IF (TMP->(EOF()) .OR. _cUser <> TMP->C7_USER) .AND. !EMPTY(_cUser)
			   //	TO_Notif(_cUser, _aReg)
			ENDIF
		END		
	EndIf
	dbSelectArea("TMP")
	dbCloseArea()
RETURN 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TO_NOTIF  ºAutor  ³Microsiga           º Data ³  10/22/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 TimeOut - Notificacao                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TO_Notif(_cUser, _aReg)
		
	_cTo			:= UsrRetMail(_cUser)

	//-------------------------------------
	//------------------- VALIDACAO
	/*
	if Empty(_cTo)
		
		cTitle  := "Administrador do Workflow : NOTIFICACAO" 
		cBody	:= REPLICATE('*',80) 
		cBody	+= Dtoc(MSDate()) + " - " + Time() + ' * Ocorreu um ERRO no envio da mensagem :' 
		cBody	+= "Timeout PC - Usuario : " + UsrRetName(_cUser) 
		cBody	+= "Campo EMAIL do cadastro de usuario NAO PREENCHIDO" 
		cBody	+= REPLICATE('*',80) 
		
		U_Console("TimeOutPC() - " + CHR(10) + CHR(13) + cBody)
		
		U_NotifyAdm(cTitle, cBody)
		RETURN
	Endif
   */
	// WORKFLOW   
	oProcess          	:= TWFProcess():New( "000005", "PC-Timeout Solicitacao de Compra / " + _cUser )
	oProcess          	:NewTask( "Timeout de resposta PC Cod.User :"+_cUser, "\WORKFLOW\HTML\PCNotif_SZ.HTM" )
	oProcess:cSubject 	:= _cPrefMsg + OemToAnsi("Timeout Pedido de Compras")
	oProcess:cTo      	:= _cTo
	oProcess:UserSiga	:= _cUser
	oProcess:NewVersion(.T.)

	// OBJETO OHTML                   
  	oHtml     			:= oProcess:oHTML

	// CABEÇALHO 
	oHtml:ValByName( "USER"  	 	, UsrRetName(_cUser))			// Usuario
	oHtml:ValByName( "DATA_HORA" 	, DTOC(MSDATE()) + ' - ' + LEFT(TIME(),5) )				// Data e hora da geracao

	For _nInd := 1 TO Len(_aReg)

		cEmail	 := "  --  NAO INFORMADO -- "
		IF !EMPTY(_aReg[_nInd][7])
			cEmail := "<A href='mailto:" + _aReg[_nInd][7] + "'>" + _aReg[_nInd][7] + "</A>"
		ENDIF
	
		AAdd( (oHtml:ValByName( "t.1"    )), _aReg[_nInd][1])
		AAdd( (oHtml:ValByName( "t.2"    )), _aReg[_nInd][2])
		AAdd( (oHtml:ValByName( "t.3"    )), _aReg[_nInd][3])
		AAdd( (oHtml:ValByName( "t.4"    )), _aReg[_nInd][4])
		AAdd( (oHtml:ValByName( "t.5"    )), _aReg[_nInd][5])
		AAdd( (oHtml:ValByName( "t.6"    )), _aReg[_nInd][6])
		AAdd( (oHtml:ValByName( "t.7"    )), cEmail) 
	  //	AAdd( (oHtml:ValByName( "t.10"    )), _aReg[_nInd][7])
		
	Next
	
	// ARRAY DE RETORNO
	oProcess:nEncodeMime := 0
	oProcess:Start()
	RETURN

                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³EnvPCFor   ºAutor  ³Pedro Augusto      º Data ³ 12/08/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TV Alphaville                                              º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EnvPCFor(_cFilial,_cNum, _cUser, _cChave, _nTotal, _dDTLimit, _cHRLimit, _nOpc, _cToFor, _cGio, cEmpAnt)  //vitor - alterei de static para user

 Local _nVALMERC	:= 0
 Local _nVALIPI		:= 0
 Local _nFRETE  	:= 0
 Local _nSEGURO  	:= 0
 Local _nDESCONTO 	:= 0   
 Local _nDESPESA  	:= 0    
 Local _nVALTOT  	:= 0

 Local cModelHtml 	:= ""

// prepare environment empresa "08" filial _cFilial
prepare environment empresa cEmpAnt filial _cFilial
  
 If valtype(_cGio) <> 'C'
 Private _cGio:= ' ' 
 EndIf
 _cChaveSCR := PADR(_cFilial + 'PC' + _cNum,60)
 _cNum   := PADR(ALLTRIM(_cNum),6)

 DBSelectArea("SCR")
 DBSetOrder(2)
 DBSeek(_cChave)

 DBSelectArea("SM0")
 DBSetOrder(1)
 DBSeek(cEmpAnt+cFilAnt)
 
 DBSelectArea("SC7")
 DBSetOrder(1)
 DBSeek(_cFilial+_cNum)

 DBSelectArea("SA2")
 DBSetOrder(1)
 DBSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

 DBSelectArea("SE4")
 DBSetOrder(1)
 DBSeek(xFilial("SE4")+SC7->C7_COND)

 _cTo := _cToFor
 _cVersao := ""

 DBSelectArea("SCY")
 DBSetOrder(1)
 DBSeek(_cFilial+_cNum) 
 
 While SCY->CY_FILIAL + SCY->CY_NUM == _cFilial+_cNum .AND. !SCY->(EOF())
  _cVersao := Alltrim(SCY->CY_VERSAO)
  SCY->(DbSkip())
 Enddo

 //tratamento de HTML diferente para cada umas das empresas
 do case
 	case SM0->M0_CODIGO == "08"
 		cModelHtml := "\WORKFLOW\HTML\PCRESP_FN08.HTM" 
	case SM0->M0_CODIGO == "09"
		cModelHtml := "\WORKFLOW\HTML\PCRESP_FN09.HTM"
	case SM0->M0_CODIGO == "15"
		cModelHtml := "\WORKFLOW\HTML\PCRESP_FN15.HTM"
	case SM0->M0_CODIGO == "16"
		cModelHtml := "\WORKFLOW\HTML\PCRESP_FN16.HTM"
	case SM0->M0_CODIGO == "20"
		cModelHtml := "\WORKFLOW\HTML\PCRESP_FN20.HTM"
	case SM0->M0_CODIGO == "25"
		cModelHtml := "\WORKFLOW\HTML\PCRESP_FN25.HTM"
 endcase

 U_CONSOLE("Chamando EnvPCFor: enviando email" )
 oProcess           := TWFProcess():New( "000006", "Envio p/fornecedor PC aprovado : " + _cFilial + "/" +  TRIM(_cNum) )
 oProcess           :NewTask( "Envio PC aprovado : "+_cFilial + _cNum, cModelHtml )

 oProcess:cTo       := _cTo

  oHtml         := oProcess:oHTML

 //Cabecalho//
 // oHtml:ValByName( "C7_FILIAL" , SM0->M0_FILIAL )
 oHtml:ValByName( "C7_NUM"		, SC7->C7_NUM )
 oHtml:ValByName( "C7_EMISSAO"	, DTOC(SC7->C7_EMISSAO) )

    //Dados Empresa
 oHtml:ValByName( "C_NOME"		, SM0->M0_NOMECOM)
 oHtml:ValByName( "C_CNPJ"		, Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")))
 oHtml:ValByName( "C_ENDER"		, Alltrim(SM0->M0_ENDCOB) + " - " + Alltrim(SM0->M0_CIDCOB)  + " - " + Alltrim(SM0->M0_ESTCOB))
 oHtml:ValByName( "C_CEP"		, SM0->M0_CEPCOB )
 oHtml:ValByName( "C_TELFAX"	, Alltrim(SM0->M0_TEL) + Iif(Alltrim(SM0->M0_FAX) == "",""," / "+SM0->M0_FAX))
 
 If SC7->C7_XTPCPR $ "E,D"  
 	_cCont:= Posicione ("SC1",1,xFilial("SC1")+SC7->C7_NUMSC,"C1_USER")
 ELSE 
 	_cCont:=SC7->C7_USER
 ENDIF
 	
 oHtml:ValByName( "C_CONTATO"	, UsrFullName(_cCont))
 oHtml:ValByName( "C_EMAIL"  	, UsrRetMail(_cCont))
 oHtml:ValByName( "MAILRESP"	, UsrRetMail(_cCont))

    //Dados Fornecedor
 oHtml:ValByName( "V_NOME"		, SA2->A2_NOME )
 oHtml:ValByName( "V_CNPJ"    	, Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC")) )
 oHtml:ValByName( "V_ENDER"   	, Alltrim(SA2->A2_END ) + " - " +Alltrim(SA2->A2_NR_END ) + " - " + Alltrim(SA2->A2_MUN )  + " - " + Alltrim(SA2->A2_EST ))
 oHtml:ValByName( "V_CEP"   	, SA2->A2_CEP )
 oHtml:ValByName( "V_TELFAX"  	, Alltrim(SA2->A2_TEL) + Iif(Alltrim(SA2->A2_FAX) == "",""," / "+SA2->A2_FAX))
 oHtml:ValByName( "V_CONTATO" 	, SA2->A2_CONTATO)
 oHtml:ValByName( "V_EMAIL"  	, SC7->C7_XMAILF)

 //Dados cond. pagamento
 oHtml:ValByName( "E4_DESCRI"   , SE4->E4_DESCRI)

 DBSelectArea("SM0")
 DBSetOrder(1)
 DBSeek(cEmpAnt+SC7->C7_FILENT)
 
 // Dados local entrega               
 /*  //comentado - Vitor 07/11/13
 oHtml:ValByName( "E_NOME"  , SM0->M0_NOMECOM)
 oHtml:ValByName( "E_CNPJ"    , Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")))
 oHtml:ValByName( "E_ENDER"   , Alltrim(SM0->M0_ENDENT) + " - " + Alltrim(SM0->M0_CIDENT)  + " - " + Alltrim(SM0->M0_ESTENT))
 oHtml:ValByName( "E_CEP"   , SM0->M0_CEPCOB )
   */
 //Inf.Adicionais
  oHtml:ValByName( "C7_XOBSFO"   , SC7->C7_XOBSFO )

 //-------------------------------------------------------------
 // ALIMENTA A TELA DE ITENS DO PEDIDO DE COMPRA
 //-------------------------------------------------------------
 While !SC7->(EOF()) .AND. SC7->C7_FILIAL == _cFilial .AND. SC7->C7_NUM == _cNum

  DBSELECTAREA("SB1")
  DBSetOrder(1)
  DBSeek(xFilial()+SC7->C7_PRODUTO)
  
  DBSELECTAREA("SBM")
  DBSetOrder(1)
  DBSeek(xFilial()+SB1->B1_GRUPO)
                                                        
  AAdd( (oHtml:ValByName( "t.1"    )), SC7->C7_ITEM)
  AAdd( (oHtml:ValByName( "t.2"    )), SC7->C7_PRODUTO)
  AAdd( (oHtml:ValByName( "t.3"    )), Alltrim(SB1->B1_DESC)) //+ Iif(!Empty(SC7->C7_OBS)," - " + SC7->C7_OBS,""))
  AAdd( (oHtml:ValByName( "t.4"    )), iif(_cGio='x',SB1->B1_UM,'b'))//ANDRE DISPARA HTML FORNEC...
  AAdd( (oHtml:ValByName( "t.5"    )), Alltrim(TRANSFORM(SC7->C7_QUANT ,'@E 9,999,999,999.99')))
  AAdd( (oHtml:ValByName( "t.6"    )), Alltrim(TRANSFORM(SC7->C7_PRECO ,'@E 9,999,999,999.99')))
  AAdd( (oHtml:ValByName( "t.7"    )), Alltrim(TRANSFORM(SC7->C7_IPI   ,'@E 99.99')))
  AAdd( (oHtml:ValByName( "t.8"    )), Alltrim(TRANSFORM(SC7->C7_TOTAL ,'@E 9,999,999,999,999.99')))  
  AAdd( (oHtml:ValByName( "t.9"    )), Alltrim(TRANSFORM(SC7->C7_PICM  ,'@E 99.99')))
  AAdd( (oHtml:ValByName( "t.10"   )), SC7->C7_DATPRF)
  //AAdd( (oHtml:ValByName( "t.11"   )), SB1->B1_UM) //ANDRE
  
  _nVALMERC  := _nVALMERC +  SC7->C7_TOTAL        
  _nVALIPI  := _nVALIPI  +  SC7->C7_VALIPI
  _nFRETE   := _nFRETE   +  SC7->C7_VALFRE
  _nSEGURO  := _nSEGURO  +  SC7->C7_SEGURO
  _nDESPESA  := _nDESPESA +  SC7->C7_DESPESA  
  _nDESCONTO  := _nDESCONTO+  SC7->C7_VLDESC  
  _nVALTOT  := _nVALMERC  + (_nVALIPI + _nFRETE + _nSEGURO + _nDESPESA - _nDESCONTO)
  
  SC7->(dbSkip()) 
 Enddo

 oHtml:ValByName( "VALMERC"	, Alltrim(TRANSFORM(_nValmerc		    , '@E 9,999,999,999,999.99')))
 oHtml:ValByName( "VALBRU"  , Alltrim(TRANSFORM(_nValmerc+_nVALIPI  , '@E 9,999,999,999,999.99')))
 oHtml:ValByName( "FRETE"   , Alltrim(TRANSFORM(_nFRETE    			, '@E 9,999,999,999,999.99')))
 oHtml:ValByName( "SEGURO"  , Alltrim(TRANSFORM(_nSeguro   			, '@E 9,999,999,999,999.99')))
 oHtml:ValByName( "DESPESA" , Alltrim(TRANSFORM(_nDespesa     		, '@E 9,999,999,999,999.99')))
 oHtml:ValByName( "DESCONTO", Alltrim(TRANSFORM(_nDesconto   		, '@E 9,999,999,999,999.99')))
 oHtml:ValByName( "VALTOT"  , Alltrim(TRANSFORM(_nVALTOT   			, '@E 9,999,999,999,999.99')))

 // ARRAY DE RETORNO
 oProcess:nEncodeMime := 0

// oProcess:cSubject    := "PEDIDO DE COMPRA No. " + _cNum  + " APROVADO"
 oProcess:cSubject    := "WORKFLOW  - Pedido de compra " + _cNum +Iif(_cVersao <> ""," Revisão: "+_cVersao,"") + " - APROVADO" 
 oProcess:Start()
 return .T.
 
//função para pegar o e-mail da sc

User Function RetMailSol(cNumSC)
Local aArea   	:= GetArea()
Local aAreaSC1 	:= SC1->(GetArea())   
Local cEmail	:= ""
 
cNumSC := PADR(Alltrim(cNumSC), TamSX3("C1_NUM")[1] )
              
SC1->(DbSetOrder(1))
If SC1->( DbSeek(xFilial("SC1")+cNumSC ) ) .AND. !Empty(cNumSC)
	cEmail := Alltrim(UsrRetMail(SC1->C1_USER))
	cEmail +=";tmoraes@t4f.com.br;luiz.totalit@t4f.com.br"
	EndIf
 
RestArea(aAreaSC1)
RestArea(aArea)
Return cEmail   


User Function LogApr(nPar)
AA1->(ReclocK("AA1",.T.))
AA1->AA1_CODTEC  := STRZERO(AA1->(Recno()),13)
AA1->AA1_NOMTEC  := ALLTRIM(SCR->CR_NUM)+"-"+SCR->CR_USER + "-"+ SCR->CR_APROV + "-"+SCR->CR_GRUPO
AA1->AA1_NOMUSU  := SCR->CR_NIVEL + "-"+SCR->CR_STATUS + "-"+DTOC(SCR->CR_DATALIB) + "-"+SC7->C7_CONAPRO + "-"+SC7->C7_NUM
AA1->AA1_FONE    := SC7->C7_NUM + "-"+SC7->C7_ITEM+ "-"+SC7->C7_CONAPRO
AA1->AA1_EMAIL   := Str(nPar)+"-"+SCR->CR_USERLIB + "-"+SCR->CR_LIBAPRO
AA1->(MSUnlock())
RETURN
