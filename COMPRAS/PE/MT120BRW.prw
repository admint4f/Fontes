#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120BRW  º Autor ³ AP6 IDE            º Data ³  27;03;13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ponto de entrada para inserir botao no browse              º±±
±±º          ³  de pedidos de compra                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4f                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT120BRW()
	aAdd(aRotina,{"Envia p/Fornec","U_PCEnvEm" , 0, 1  }) //"Enviar pedido de compra por e-mail "
Return                                                                                           



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120BRW  ºAutor  ³Microsiga           º Data ³  09/28/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Envio de email para fornecedor	                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PCEnvEm()                     
Local oConfirm
Local oMails
Local cMails := Space(120)
Local lOk	:= .F.
Local oDlg

_cChave	:= SC7->C7_FILIAL+'PC'+SC7->C7_NUM

If SC7->C7_CONAPRO =='L'    

	//Busca e-mail Fornecedor
	If Alltrim(SC7->C7_XMAILF) <> ""                                                                           
		cMails := PADR(Alltrim(SC7->C7_XMAILF),120)   
	Else
		DBSelectArea("SA2")
		DBSetOrder(1)
		DBSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)	
		cMails := PADR(Alltrim(SA2->A2_EMAIL),120)   
	EndIf

	//Monta tela
	DEFINE MSDIALOG oDlg TITLE "Envio e-mail PC para Fornecedor" FROM 000, 000  TO 120, 700 COLORS 0, 16777215 PIXEL

    @ 011, 013 SAY cTxt PROMPT "Enviar e-mail Fornecedor para:" SIZE 121, 011 OF oDlg COLORS 0, 16777215 PIXEL  
    @ 020, 010 MSGET oMails VAR cMails SIZE 329, 012 OF oDlg COLORS 0, 16777215 PIXEL
    @ 039, 242 BUTTON oConfirm PROMPT "Enviar" SIZE 034, 014 OF oDlg ACTION (lOk:=.T.,oDlg:End()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

	If lOk .and. !Empty(cMails)
//		U_EnvPCFor(SC7->C7_FILIAL, SC7->C7_NUM, /*cUser*/, _cChave, /*_nTotal*/, /*_dDTLimit*/, /*_cHRLimit*/, /*_nOpc*/, cMails,'x')  
		u__fEnvPCF(SC7->C7_FILIAL, SC7->C7_NUM, /*cUser*/, _cChave, /*_nTotal*/, /*_dDTLimit*/, /*_cHRLimit*/, /*_nOpc*/, cMails,'x')  
		MsgInfo("Processo concluido.")
	EndIf
Else
	MsgAlert("Este pedido não encontra-se Liberado. Verifique!")
EndIf

Return


User Function _fEnvPCF(_cFilial,_cNum, _cUser, _cChave, _nTotal, _dDTLimit, _cHRLimit, _nOpc, _cToFor,_cGio)  //vitor - alterei de static para user

	Local _nVALMERC		:= 0
	Local _nVALIPI		:= 0
	Local _nFRETE  		:= 0
	Local _nSEGURO  	:= 0
	Local _nDESCONTO 	:= 0   
	Local _nDESPESA  	:= 0    
	Local _nVALTOT  	:= 0
	
	Local cModelHtml 	:= ""
	
//	prepare environment empresa "08" filial "01"
	RpcSetType(3)
	RpcSetEnv(cEmpAnt,_cFilial,,,'FAT')
	  
	If valtype(_cGio) <> 'C'
		Private _cGio:= ' ' 
	EndIf
	
	_cChaveSCR	:= PADR(_cFilial + 'PC' + _cNum,60)
	_cNum   	:= PADR(ALLTRIM(_cNum),6)
	
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
		case SM0->M0_CODIGO == "32"
			cModelHtml := "\WORKFLOW\HTML\PCRESP_FN32.HTM"			
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
	
//	RpcClearEnv()

return .T.