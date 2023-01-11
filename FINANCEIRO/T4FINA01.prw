#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณT4FINA01  บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para gera็ใo de pagamentos antecipados                ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function T4FINA01()

	//Static aTipoFor 	:= {"","1-Fornecedor","2-Colaborador","3-Artista","4-Troco","5-Avulso","6-Presta็ใo Contas","7-Reembolso Avulso","8-Impostos","9-Repasse Terceiros", "0-Devol.Ingressos"}
	Static aTipoFor 	:= {"0-Devol.Ingressos"}
	
	Local aCores		:= {}
	Local cQuery1		:= ""
	Local cTexto		:= ""
	Local nConta		:= 1
	Local cUserAdmin	:= GetMv("MV_XADMUSR",,"000000")
	
	Private cAprov		:= fVldAprov(__cUserID)
	Private cNumero		:= Space(06)
	Private cTipoFor	:= Space(11)	// Tamanho maximo do tipo de fornecedor
	Private cCadastro	:= "Solicita็๕es de Troco/Pagto Antecipado/Impostos/Repasse"
	Private aMoedas		:= {}
	Private aRotina		:= {}

	Public cUserLolla    := GetMv("MV_XUSRLOL",,"000000")
	Public _cTemp		:= ""
	Public _lOk
	Public _nRegistro	:= 0
	Public 	nPassagem 	:= 0
	Public  lLolla
	
	// Adiciona elementos ao aRotina
	Aadd(aRotina,{"Pesquisar","AxPesqui",0,1})
	Aadd(aRotina,{"Visualizar","U_fPagAnt(2)",0,2})
	Aadd(aRotina,{"Incluir","U_fPagAnt(3)",0,3})
	Aadd(aRotina,{"Aprovar","U_fPagAnt(4)",0,2})
	Aadd(aRotina,{"Cancelar","U_fPagAnt(5)",0,3})
	Aadd(aRotina,{"Hist Aprovacao","U_fHistApr",0,2})
	Aadd(aRotina,{"Legenda","U_fLegend",0,2})
	lLolla := .f.
//	If (__cUserID $ cUserLolla) .and. trim(SM0->M0_CODIGO) $ "08*20*32"    // Somente A&B e PLF e T4f - Informar nesse parโmetro os usuแrios habilitados a importar a planilha de devolu็๕es
	If  trim(SM0->M0_CODIGO) $ "08*20*32"    // Somente A&B e PLF e T4f - Informar nesse parโmetro os usuแrios habilitados a importar a planilha de devolu็๕es
		Aadd(aRotina,{"Importar Planilha","U_T4FIN01a",0,3})
		lLolla := .t.
	endif	
	
	// Configuracao das cores da Legenda.
	Aadd(aCores,{'ZZE_STATUS = "L"','ENABLE'})		// Liberado
	Aadd(aCores,{'ZZE_STATUS = "P"','DISABLE'})	    // Aguardando analise pelos aprovadores
	Aadd(aCores,{'ZZE_STATUS = "E"','BR_AMARELO'})	// Em processo de aprovacao
	Aadd(aCores,{'ZZE_STATUS = "C"','BR_PRETO'})	// Cancelado
	
	SX6->( Dbsetorder(1) )
	While .T.
		If SX6->( Dbseek(xFilial("SX6")+"MV_MOEDA"+Alltrim(Str(nConta,2))) )
			Aadd(aMoedas,SX6->X6_CONTEUD);	nConta++
		Else
			Exit
		EndIf
	EndDo
	
	If !(__cUserID $ cUserAdmin)
		
		If !Empty(cAprov)
			
			cQuery1 := "SELECT CTT_CUSTO"
			cQuery1 += " FROM " + RetSqlName("CTT") + " CTT "

			cQuery1 += " JOIN " + RetSqlName("SAL") + " SAL "
			cQuery1 += " ON AL_FILIAL = ''"
			cQuery1 += " AND AL_COD = CTT_XGRAPR"
			cQuery1 += " AND AL_APROV IN ("+cAprov+")"
			cQuery1 += " AND SAL.D_E_L_E_T_ <> '*'"

			cQuery1 += " WHERE CTT_FILIAL = ''"
			cQuery1 += " AND CTT.D_E_L_E_T_ <> '*' "
			cQuery1 := ChangeQuery(cQuery1)
			
			DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery1),'TRBZZE',.F.,.T. )
			TRBZZE->(DbGoTop())
			TRBZZE->(DbEval({ || cTexto += "'"+alltrim(TRBZZE->CTT_CUSTO)+"'," }))
			cTexto := SubStr(cTexto,1,Len(cTexto)-1)
			
			if !lLolla
				MBrowse(6, 1,22,75,"ZZE",,,,,,aCores,,,,,,,,"ZZE_CCAPRO IN ("+cTexto+") OR ZZE_USERID = '"+__cUserId+"'")
			else
				MBrowse(6, 1,22,75,"ZZE",,,,,,aCores)
			endif
			
		Else
			
			MBrowse(6, 1,22,75,"ZZE",,,,,,aCores,,,,,,,,"ZZE_USERID = '"+__cUserId+"'")
			
		Endif
	Else
		
		MBrowse(6, 1,22,75,"ZZE",,,,,,aCores)
		
	EndIf
	
	// Fecha a tabela temporaria (se estiver aberta).
	If Select("TRBZZE") > 0
		TRBZZE->(Dbclosearea())
	Endif
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldAprov บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo do aprovador.                          ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldAprov(cCodigo)

	Local aAreaAnt:= GetArea()
	Local cAprov:= Space(06)
	
	SAK->( Dbsetorder(2) )		// AK_FILIAL+AK_USER
	SAK->( Dbseek(xFilial("SAK")+cCodigo) )
	
	Do While SAK->(!Eof()) .And. ( SAK->AK_FILIAL + SAK->AK_USER == xFilial("SAK")+cCodigo )                                            
	
		cAprov += "'"+SAK->AK_COD + "',"
		SAK->(DbSkip())
	EndDo
	
	If !Empty(cAprov)
		cAprov := SubStr(Alltrim(cAprov),1,Len(Alltrim(cAprov))-1)
	EndIf
	
	// Restaura Area Anterior.
	RestArea(aAreaAnt)
	
Return (cAprov)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPagAnt   บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para gera็ใo da tela de pagamentos antecipados.       ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fPagAnt(_nOpc)
	
	Local _oFonte1		:= Nil
	Local _oFonte2		:= Nil
	Local clTitulo		:= "Incluir - Solicitacao de Pagto Antecipado/Troco/Repasse"
	Local lOk			:= .T.
	Local lFor			:= .F. 
	Local _lControl		:= .F.
	Local cObrigat		:= ''
	Local _cQuery		:= ""
	Local _cPAOpen		:= ""
	Local _nIndice		:= 1
	Local _nPos			:= 0
	Local _lNum			:= .T.

	Private _aHead		:= {}
	Private _aCols		:= {}
	Private aAreaAnt 	:= GetArea()
	Private _oDlgPA		:= Nil
	Private _oGDadosPA	:= Nil
	Private oCBX1		:= Nil
	Private oFornece	:= Nil
	Private oLoja		:= Nil
	Private oCBX2		:= Nil
	Private oCusto		:= Nil
	Private oDescCC		:= Nil
	Private oPep		:= Nil
	Private oDescPep	:= Nil 
	Private oHistor		:= Nil
	Private oDesc		:= Nil
	Private oQtde		:= Nil
	Private oVlrTot		:= Nil
	Private cNumero		:= GetSxeNum("ZZE","ZZE_NUMERO")
	Private cMoeda		:= "Reais"	
	Private cPedido		:= Space(06)
	Private cFornece	:= Space(06)
	Private cNome		:= Space(40)
	Private cLoja		:= Space(02)
	Private cTipofor	:= Space(10)
	Private cCusto		:= Space(20)
	Private cDescCC		:= Space(40)
	Private cPep		:= Space(20)
	Private cDescPep	:= Space(40)
	Private cBanco		:= Space(03)
	Private cAgencia	:= Space(05)
	Private cContaCorr	:= Space(10)
	Private cHistor		:= Space(60)
	Private cDesc		:= Space(10)
	Private nQtde		:= 0
	Private nVlrTot		:= 0
	Private lPAPC	    := GetMv("MV_PACOMPC",,.F.)
	
	DEFINE FONT _oFonte1 NAME "Arial" BOLD
	DEFINE FONT _oFonte2 NAME "Arial" SIZE 08,17 BOLD
	
	Do Case
		Case _nOpc == 2
			clTitulo	:= "Visualizar - Solicitacao de Pagto Antecipado/Troco/Repasse"
		
		Case _nOpc == 3
			If ZZE->(dbSeek(xFilial("ZZE") + cNumero))
				ZZE->(Confirmsx8())
				While _lNum
					cNumero   := GetSXENum("ZZE","ZZE_NUMERO")
					ZZE->(Confirmsx8())
					ZZE->(dbGoTop())
					If ZZE->(!dbSeek(xFilial("ZZE") + cNumero))
						_lNum	:= .F.
					EndIf
				EndDo
			EndIf
		Case _nOpc == 4
			clTitulo	:= "Aprovacao de Solicitacao de Pagto Antecipado/Troco/Repasse"

			If Empty(cAprov)
				MsgBox("Somente os usuarios registrados como APROVADORES podem utilizar esta funcionalidade.","Atencao","ERROR")
				Return(Nil)
			Endif

			If ZZE->ZZE_STATUS == "C" 
				MsgBox("Essa solicita็ao foi CANCELADA, portanto nao pode ser aprovada.","Atencao","ERROR")
				Return(Nil)
			ElseIf ZZE->ZZE_STATUS == "L"
				MsgBox("Essa solicita็ao ja foi LIBERADA.","Atencao","ERROR")
				Return(Nil)
			EndIf
			
			dbSelectArea("SCR")
			SCR->(dbSetOrder(2))
			If SCR->(dbSeek(xFilial("SCR") + PadR("ZZ",TamSX3("CR_TIPO")[1]) + PadR(ZZE->ZZE_NUMERO,TamSX3("CR_NUM")[1]) + __cUserId))
				If Empty(SCR->CR_DATALIB)
					_lControl:=.T.
				Else
					MsgBox("A aprova็ใo jแ foi realizada pelo usuแrio.","Atencao","ERROR")
					Return(Nil)
				EndIf
			EndIf
			
			If _lControl
				_cQuery	:= "SELECT COUNT(*) XQTD, sum(E2_SALDO) XSALDO FROM "+retsqlname("SE2")+" WHERE "
				_cQuery += " E2_FORNECE = '"+ZZE->ZZE_FORNEC+"' AND E2_LOJA = '"+ZZE->ZZE_LOJA+"' AND E2_SALDO > 0 "
				_cQuery += " AND D_E_L_E_T_ = ' ' AND E2_TIPO='PA'"
				TcQuery _cQuery New Alias "TMPSE2"
				
				If TMPSE2->(!EOF())
					If TMPSE2->XQTD > 0
						_cPAOpen:= "** Hแ "+Alltrim(Str(TMPSE2->XQTD))+" adiantamentos em aberto totalizando "+Alltrim(GetMv("MV_SIMB1"))+Alltrim(Transform(TMPSE2->XSALDO,"@E 9,999,999.99"))
					EndIf
				EndIF
				
				TMPSE2->(dbCloseArea())
			EndIf
			
			
		Case _nOpc == 5
			clTitulo	:= "Cancelamento - Solicitacao de Pagto Antecipado/Troco/Repasse"
			
			If ( __cUserId <> ZZE->ZZE_USERID ) .And. ( Upper(Alltrim(cUserName)) != "ADMINISTRADOR"  )
				Msgbox("Somente o proprio solicitante pode cancelar uma solicitacao de PA.","Atencao","ERROR")
				Return(Nil)
			Endif
			
			If  !Empty(ZZE->ZZE_TITULO)
				Msgbox("Essa Solicitacao de Pagamento Antecipado nao pode ser cancelada porque"+chr(13)+;
				"ja foi gerado o titulo de pagamento antecipado.","Atencao","INFO")
				Return(Nil)
			Endif
			
			If ZZE->ZZE_STATUS == "C"
				Msgbox("Essa solicita็ao jแ estแ cancelada.","Atencao","ERROR")
				Return(Nil)
			Endif			
			
	EndCase
	
	DEFINE MSDIALOG _oDlgPA FROM 050, 042 To 650,875 Title clTitulo Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
	
		@ 011,010 Say "Numero: " 																FONT _oFonte1 OF _oDlgPA PIXEL
		@ 011,150 Say "Tipo: "   																FONT _oFonte1 OF _oDlgPA PIXEL
		@ 011,290 Say "Moeda: "  																FONT _oFonte1 OF _oDlgPA PIXEL
		@ 028,010 Say "Fornec./Colab./Artista:" 												FONT _oFonte1 OF _oDlgPA PIXEL
		@ 044,010 Say "Centro de Custo: " 														FONT _oFonte1 OF _oDlgPA PIXEL
		@ 028,290 Say "Pedido de Compra:" 														FONT _oFonte1 OF _oDlgPA PIXEL
		@ 060,010 Say "Elemento PEP: " 															FONT _oFonte1 OF _oDlgPA PIXEL
		@ 078,010 Say "Historico: " 															FONT _oFonte1 OF _oDlgPA PIXEL
				
		@ 250,010 Say "Qtde: " 						FONT _oFonte1 							OF _oDlgPA PIXEL
		@ 250,150 Say "Valor Total: "   			FONT _oFonte1 							OF _oDlgPA PIXEL
		@ 250,080 MsGet oQtde	Var nQtde	Picture "@E 999,999,999.99" SIZE 60,08 PIXEL	OF _oDlgPA When .F.
		@ 250,190 MsGet oVlrTot	Var nVlrTot Picture "@E 999,999,999.99" SIZE 60,08 PIXEL 	OF _oDlgPA When .F.
		
		
		@ 090,010 TO 155,140 OF _oDlgPA PIXEL
		
		@ 093,013 Say "Dados Bancแrios P/ Pagamento" 											FONT _oFonte1 OF _oDlgPA PIXEL
		@ 113,013 Say "Banco:" 																	FONT _oFonte1 OF _oDlgPA PIXEL
		@ 128,013 Say "Agencia:" 																FONT _oFonte1 OF _oDlgPA PIXEL
		@ 143,013 Say "Conta Corrente:" 														FONT _oFonte1 OF _oDlgPA PIXEL
		
		If _nOpc == 4
			@ 266,010 Say _cPAOpen			 													FONT _oFonte1 OF _oDlgPA PIXEL
		ElseIf _nOpc == 2
			PswOrder(1)
			PswSeek(ZZE->ZZE_USERID,.T.)
			@ 266,010 Say AllTrim(Pswret(1)[1][4]) + Iif( !Empty(ZZE->ZZE_DEPTO), " / " + ZZE->ZZE_DEPTO, "")			 													FONT _oFonte1 OF _oDlgPA PIXEL
		EndIf
		
		@ 090,150 TO 155,409 OF _oDlgPA PIXEL
		
		@ 093,153 Say "Descricao / Motivo da Solicita็ใo de Pagto Antecipado/Troco/Repasse: " 	FONT _oFonte1 OF _oDlgPA PIXEL
		
		If _nOpc == 3
		
			@ 011,080 MsGet oNumero	  Var cNumero  OF _oDlgPA PIXEL SIZE 040,008 When .F.
			
			@ 010,190 COMBOBOX oCBX2  Var cTipoFor ITEMS aTipoFor Valid !Empty(cTipoFor) 	SIZE 65,08 PIXEL OF _oDlgPA FONT _oDlgPA:oFont		
			@ 010,345 COMBOBOX oCBX1  Var cMoeda   ITEMS aMoedas  							SIZE 60,08 PIXEL OF _oDlgPA FONT _oDlgPA:oFont
			
			@ 026,080 MsGet oFornece  Var cFornece  Of _oDlgPA Pixel 				F3 "SA2"	Valid fVldFor(cFornece,"1")
			@ 026,118 MsGet oLoja     Var cLoja     Of _oDlgPA Pixel SIZE 07,08   				Valid fVldLoja(cFornece,cLoja) .And. NaoVazio(cLoja)
			@ 042,080 MsGet oCusto    Var cCusto    Of _oDlgPA Pixel SIZE 040,008 	F3 "CTT"	Valid fVldCC(cCusto)
			@ 042,122 MsGet oDescCC   Var cDescCC   Of _oDlgPA Pixel SIZE 090,008 				 When .F.
			@ 026,345 Msget oPedido   Var cPedido   Of _oDlgPA Pixel 				F3 "SC7"     When .F.
			@ 058,080 MsGet oPep      Var cPep      Of _oDlgPA Pixel SIZE 070,008 	F3 "CTD" 	Valid fVldPep(cPep)
			@ 058,155 MsGet oDescPep  Var cDescPep  Of _oDlgPA Pixel SIZE 130,008 				 When .F.
			@ 076,080 MsGet oHistor   Var cHistor   Of _oDlgPA Pixel SIZE 250,008 				Valid (!Empty(cHistor) .And. fVldHist( Subs(cTipoFor,1,1) , cHistor))

			@ 103,153 Get cDesc MEMO  SIZE 253,049  Pixel Of _oDlgPA
		Else
					
			@ 011,080 MsGet oNumero	  Var ZZE->ZZE_NUMERO  OF _oDlgPA PIXEL SIZE 040,008 When .F.
			
			_nIndice == 1 //Iif(ZZE->ZZE_TIPO == 0, 1, ZZE->ZZE_TIPO)
			
			@ 010,180 MsGet oTipoF	  Var aTipoFor[_nIndice]													Of _oDlgPA Pixel SIZE 105,008	When .F.
			@ 010,345 MsGet oMoeda	  Var aMoedas[ZZE->ZZE_MOEDA]     											Of _oDlgPA Pixel SIZE 050,008	When .F.
						
			@ 026,080 MsGet oFornece  Var ZZE->ZZE_FORNECE  													Of _oDlgPA Pixel 				WHEN .F.
			@ 026,118 MsGet oLoja     Var ZZE->ZZE_LOJA     													Of _oDlgPA Pixel SIZE 07,08   	WHEN .F.
			@ 042,080 MsGet oCusto    Var ZZE->ZZE_CCAPRO    													Of _oDlgPA Pixel SIZE 040,008 	WHEN .F.
			@ 042,122 MsGet oDescCC   Var Posicione("CTT", 1, XFILIAL("CTT")+ZZE->ZZE_CCAPRO , "CTT_DESC01" )   Of _oDlgPA Pixel SIZE 090,008 	When .F.
			@ 026,345 Msget oPedido   Var ZZE->ZZE_PEDIDO														Of _oDlgPA Pixel SIZE 040,008	WHEN .F.
			@ 058,080 MsGet oPep      Var ZZE->ZZE_PEP      													Of _oDlgPA Pixel SIZE 070,008 	WHEN .F.
			@ 058,155 MsGet oDescPep  Var Posicione("CTD", 1, xFilial("CTD")+ZZE->ZZE_PEP, "CTD_DESC01" )  		Of _oDlgPA Pixel SIZE 130,008 	When .F.
			@ 076,080 MsGet oHistor   Var ZZE->ZZE_HISTOR														Of _oDlgPA Pixel SIZE 250,008 	WHEN .F.
			
			@ 27,150  Say Posicione("SA2", 1, XFILIAL("SA2")+ZZE->ZZE_FORNEC + ZZE->ZZE_LOJA , "A2_NOME" )						 SIZE 130,08 PIXEL
			@ 113,080 Say ZZE->ZZE_BANCO 	SIZE 10,08 PIXEL
			@ 128,080 Say ZZE->ZZE_AGENC	SIZE 15,08 PIXEL
			@ 143,080 Say ZZE->ZZE_CONTA 	SIZE 50,08 PIXEL
			
			cDesc := AllTRim(MsMM(ZZE->ZZE_DESC))
			@ 103,153 Get cDesc MEMO  SIZE 253,049	WHEN !(_nOpc==2)  Pixel Of _oDlgPA
		EndIf
		            
		fGDadosPA(_nOpc)

		If _nOpc <> 2
			@ 250,350 BmpButton Type 1 Action Eval( {|| Iif(fVldTela(_nOpc), (fVldPA(_nOpc),_oDlgPA:End()),Nil )   })
		EndIf
		@ 250,383 BmpButton Type 2 Action Eval( {|| Iif(_nOpc == 3,(ZZE->(RollBackSxe()),_oDlgPA:End()),_oDlgPA:End())  })

	Activate MsDialog _oDlgPA Centered
	
	RestArea(aAreaAnt)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldTela  บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo da tela de pagamentos antecipados.     ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldTela(_nOpc)
	
	Local _lOk		:= .T.
	Local _nI		:= 0
	Local _aCols	:= _oGDadosPA:aCols
	Local _nValor	:= GdFieldPos("PA_VALOR" 	,_oGDadosPA:aHeader) 
	Local _nDtPag	:= GdFieldPos("PA_DTPGTO" 	,_oGDadosPA:aHeader) 
	Local _nDtAc	:= GdFieldPos("PA_DTACERT" 	,_oGDadosPA:aHeader) 
	Local _nDirf	:= GdFieldPos("PA_DIRF" 	,_oGDadosPA:aHeader) 
	Local _nNature	:= GdFieldPos("PA_NATUREZ" 	,_oGDadosPA:aHeader) 
	Local _nCCusto	:= GdFieldPos("PA_CCUSTO" 	,_oGDadosPA:aHeader) 
	
	If _nOpc == 3
		If Empty(cTipoFor)
				_lOk		:= .F.
			Aviso("Help", 	"O campo obrigat๓rio Tipo estแ em branco. Por favor preenche-lo!" ,{"Ok"},1)
		Else
			For _nI := 1 To Len(_aCols)
				If Empty(_aCols[_nI,_nNature]) .And. cTipoFor == "9"
					_lOk		:= .F.
					Aviso("Help", 	"O campo obrigat๓rio Natureza estแ em branco. Por favor preenche-lo!" ,{"Ok"},1)
				ElseIf _aCols[_nI,_nDtPag] <= date()
					MsgBox("A data de pagamento deve ser posterior เ data de registro da solicita็ใo.","Atencao","ERROR")
					_oGDadosPA:oBrowse:SetFocus()
					_oGDadosPA:obrowse:nAt		:= _nI
					_oGDadosPA:obrowse:ncolpos	:= _nDtPag 
					_oGDadosPA:oBrowse:bEditCol :={ || _oGDadosPA:oBrowse:GoBottom()}
					_lOk	:= .F.
				ElseIf Empty(_aCols[_nI,_nCCusto])
					MsgBox("O campo Centro de Custo PA estแ em branco. Por favor preenche-lo!","Atencao","ERROR")
					_lOk	:= .F.
				EndIf
			Next _nI
		EndIf	
	EndIf

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGDadosPA บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para gera็ใo do GET de pagamentos antecipados.        ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGDadosPA(_nOpc)

	Local _aAux		:= {}
	Local _aCampos	:= {"PA_VALOR","PA_DTPGTO","PA_DTACERT","PA_DIRF","PA_NATUREZ","PA_CCUSTO"}
	Local _aCampos2	:= {"ZZE_VALOR","ZZE_DATA","ZZE_DTAC","ZZE_DIRF","ZZE_NATURE","ZZE_CCUSTO"}
	Local _aAlter	:= {"PA_VALOR","PA_DTPGTO","PA_DTACERT","PA_DIRF","PA_NATUREZ","PA_CCUSTO"} 
	Local _nOpcPA	:= Iif(_nOpc == 3, 3, 2)
	Local _nI		:= 0
	Local _nValor	:= 0
	Local _nDirf	:= 0
	Local _nDtPag	:= 0
	Local _cQuery	:= ""

	Aadd(_aHead,{ "Seq.",			"PA_SEQ",		"@!"						,4						,0						," ","€€€€€€€€€€€€€€ฐ","C","","","",""})	
	Aadd(_aHead,{ "Valor",			"PA_VALOR",		PesqPict("ZZE","ZZE_VALOR")	,TamSx3("ZZE_VALOR")[1]	,TamSx3("ZZE_VALOR")[2]	," ","€€€€€€€€€€€€€€ฐ","N","","","",""})
	Aadd(_aHead,{ "Dt. Pagamento",	"PA_DTPGTO",	PesqPict("ZZE","ZZE_DATA")	,TamSx3("ZZE_DATA")[1]	,0						," ","€€€€€€€€€€€€€€ฐ","D"," ","","",""})
	Aadd(_aHead,{ "Dt. Acerto",		"PA_DTACERT",	PesqPict("ZZE","ZZE_DTAC")	,TamSx3("ZZE_DTAC")[1]	,0						," ","€€€€€€€€€€€€€€ฐ","D"," ","","",""})
	Aadd(_aHead,{ "Cod. DIRF",		"PA_DIRF",		PesqPict("ZZE","ZZE_DIRF")	,TamSx3("ZZE_DIRF")[1]	,0						," ","€€€€€€€€€€€€€€ฐ","C","37","","","",""})
	Aadd(_aHead,{ "Natureza",		"PA_NATUREZ",	PesqPict("ZZE","ZZE_NATURE"),TamSx3("ZZE_NATURE")[1],0						," ","€€€€€€€€€€€€€€ฐ","C","SED","","","",/*"u_FEditCel()"*/})
	Aadd(_aHead,{ "C. Custo PA",	"PA_CCUSTO",	PesqPict("ZZE","ZZE_CCUSTO"),TamSx3("ZZE_CCUSTO")[1],0						," ","€€€€€€€€€€€€€€ฐ","C","CTT","","","",/*"u_FEditCel()"*/})
	
	If _nOpc <> 3
		_cQuery	:= "SELECT ZZE_VALOR, ZZE_DATA, ZZE_DTAC, ZZE_DIRF, ZZE_NATURE, ZZE_ITEM, ZZE_CCUSTO"
		_cQuery	+= "	FROM " + RetSqlName("ZZE")
		_cQuery	+= "	WHERE ZZE_FILIAL = '" + xFilial("ZZE") + "'"
		_cQuery	+= "	AND ZZE_NUMERO = '" + ZZE->ZZE_NUMERO + "'"	
		_cQuery	+= "	AND ZZE_FORNEC = '" + ZZE->ZZE_FORNEC + "'"	
		_cQuery	+= "	AND D_E_L_E_T_ <> '*'"	
		TcQuery _cQuery New Alias "TMPZZE"
		
		TMPZZE->(dbGoTop())
		If TMPZZE->(!EOF())
			While TMPZZE->(!EOF())
				_aAux	:= {}
				Aadd(_aAux,TMPZZE->ZZE_ITEM)
				Aadd(_aAux,TMPZZE->ZZE_VALOR)
				Aadd(_aAux,TMPZZE->ZZE_DATA)
				Aadd(_aAux,TMPZZE->ZZE_DTAC)
				Aadd(_aAux,TMPZZE->ZZE_DIRF)
				Aadd(_aAux,TMPZZE->ZZE_NATURE)
				Aadd(_aAux,TMPZZE->ZZE_CCUSTO)
				Aadd(_aAux,.F.)
				Aadd(_aCols,_aAux)
				TMPZZE->(DbSkip())
			EndDo
		EndIf
		TMPZZE->(dbCloseArea())
		
		_nValor	:= GdFieldPos("PA_VALOR" 	,_aHead) 
		_nDirf	:= GdFieldPos("PA_DIRF" 	,_aHead) 
		_nDtPag	:= GdFieldPos("PA_DTPGTO" 	,_aHead)
		nQtde 	:= 0
		nVlrTot	:= 0
		
		If _nDtPag > 0
			aEval( _aCols, {|x| nQtde += If( !Empty(x[_nDtPag]) .and. !x[Len(x)],1,0), nVlrTot += If( !Empty(x[_nDtPag]) .and. !x[Len(x)],X[_nValor],0) } )
		EndIf
		oQtde:Refresh()
		oVlrTot:Refresh()
			
	Else
		_aAux := {}
		For _nI := 1 to Len(_aCampos2)
			If _nI == 1
				Aadd(_aAux,"0001")
			EndIf
			Aadd(_aAux,CriaVar(_aCampos2[_nI]))
		Next _nI
		Aadd(_aAux,.F.)
		Aadd(_aCols,_aAux)
	EndIf
			
	_oGDadosPA := MsNewGetDados():New(C(125),C(008),C(190),C(319),_nOpcPA,"u_fVldLin()","AllWaysTrue","+PA_SEQ",_aAlter,000,999,"u_fVldOKPA()","AllWaysTrue",/*"u_FDelOk()"*/"AllWaysTrue",_oDlgPA,_aHead,_aCols)
			
	_oGDadosPA:Refresh()
	_oGDadosPA:Refresh()
	
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldOKPA  บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo do GET de pagamentos antecipados.      ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fVldOKPA()

	Local _lOk		:= .T.
	Local _nValor	:= GdFieldPos("PA_VALOR" 	,_oGDadosPA:aHeader) 
	Local _nDtPag	:= GdFieldPos("PA_DTPGTO" 	,_oGDadosPA:aHeader) 
	Local _nDtAc	:= GdFieldPos("PA_DTACERT" 	,_oGDadosPA:aHeader) 
	Local _nDirf	:= GdFieldPos("PA_DIRF" 	,_oGDadosPA:aHeader) 
	Local _nNature	:= GdFieldPos("PA_NATUREZ" 	,_oGDadosPA:aHeader) 

	If AllTrim(_aHead[_oGDadosPA:OBROWSE:COLPOS,2]) == "PA_NATUREZA"	
		If cTipoFor == "9" .And. Empty(M->PA_NATUREZA)
			MsgBox("Deve ser informada a natureza de repasse (400700).")
			Return(.F.)
		EndIf
	ElseIf AllTrim(_aHead[_oGDadosPA:OBROWSE:COLPOS,2]) == "PA_DTPGTO"	
		If cTipoFor <> "8" .And. M->PA_DTPGTO <= date()
			MsgBox("A data de pagamento deve ser posterior เ data de registro da solicita็ใo.","Atencao","ERROR")
			Return(.F.)
		EndIf
	ElseIf AllTrim(_aHead[_oGDadosPA:OBROWSE:COLPOS,2]) == "PA_CCUSTO"	
		dbSelectArea("CTT")
		CTT->(dbSetOrder(1))
		CTT->(dbGoTop())
		If !CTT->(DbSeek(xFilial("CTT") + M->PA_CCUSTO))
			MsgBox("Centro de Custo nao cadastrado","Atencao","ERROR")
			Return(.F.)
		Else
			If CTT->CTT_BLOQ == '1'
				MsgBox("Centro de Custo Bloqueado.","Atencao","ERROR")
				Return(.F.)
			ElseIf CTT->CTT_CLASSE = "1"
				MsgBox("Nessa rotina sao aceitos somente Centros de Custo Analiticos."+ chr(13) + "Verifique e corrija.","Atencao","ERROR")
				Return(.F.)
			EndIf
		EndIf
	ElseIf AllTrim(_aHead[_oGDadosPA:OBROWSE:COLPOS,2]) == "PA_DIRF"
		If !Empty(M->PA_DIRF)
			Return(ExistCpo("SX5","37" + M->PA_DIRF))
		EndIf
	EndIf
	
	nQtde 	:= 0
	nVlrTot	:= 0
	aEval( _oGDadosPA:aCols, {|x| nQtde += If( !Empty(x[_nDtPag]) .and. !x[Len(x)],1,0), nVlrTot += If( !Empty(x[_nDtPag]) .and. !x[Len(x)],X[_nValor],0) } )
	oQtde:Refresh()
	oVlrTot:Refresh()
		
	_oGDadosPA:Refresh()
        
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldLin   บAutor  ณBruna Zechetti      บ Data ณ  27/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo da linha.                              ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fVldLin()

	Local _lOk	:= .T.
	Local _nValor	:= GdFieldPos("PA_VALOR" 	,_oGDadosPA:aHeader) 
	Local _nDtPag	:= GdFieldPos("PA_DTPGTO" 	,_oGDadosPA:aHeader) 
	Local _nDtAc	:= GdFieldPos("PA_DTACERT" 	,_oGDadosPA:aHeader) 
	Local _nDirf	:= GdFieldPos("PA_DIRF" 	,_oGDadosPA:aHeader) 
	Local _nNature	:= GdFieldPos("PA_NATUREZ" 	,_oGDadosPA:aHeader)
	
	If _oGDadosPA:aCols[N,_nValor] == 0 .Or. Empty(_oGDadosPA:aCols[N,_nDtPag]) .Or. Empty(_oGDadosPA:aCols[N,_nNature]) .And. !(_oGDadosPA:aCols[N,Len(_oGDadosPA:aCols[N])]) //.Or. Empty(_oGDadosPA:aCols[N,_nDirf]) 
		Aviso("Help", 	"Existem campos obrigat๓rios em branco. Por favor preenche-los!" ,{"Ok"},1)
		_lOk	:= .F.
	ElseIf cTipoFor <> "8" .And. _oGDadosPA:aCols[N,_nDtPag] <= date()
		MsgBox("A data de pagamento deve ser posterior เ data de registro da solicita็ใo.","Atencao","ERROR")
		_lOk	:= .F.
	EndIf	

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldFor   บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo do Fornecedor.                         ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldFor(cFornece,cOrigem,cLojaFor)

	Local aAreaAnt		:= Getarea()
	Local lReturn		:=  .t.
	Local nContFor		:= 0
	DEFAULT cLojaFor	:= "01"
	
	If Empty(cFornece)
		MsgBox("Deve ser informado o codigo do fornecedor","Ha pelo menos um campo obrigatorio vazio","ERROR")
		lReturn:= .f.
	Endif
	
	If lReturn
		
		SA2->( DbSetorder(1) )
		If ( cOrigem == "1" ) .Or. ( cOrigem == "2" )
			SA2->( DbSeek(xFilial("SA2")+cFornece) )
		ElseIf cOrigem == "3" .or. cOrigem == "4"
			SA2->( DbSeek(xFilial("SA2")+cFornece+cLojaFor)	 )
		EndIf
		
		If SA2->( !Found() )
			MsgBox("Codigo do fornecedor nใo encontrado.","O codigo do fornecedor nใo foi encontrado.","ERROR")
			lReturn:= .f.
		Else
			
			cNome	   := SA2->A2_NOME
			cLoja	   := SA2->A2_LOJA
			cBanco	   := SA2->A2_BANCO
			cAgencia   := Alltrim(SA2->A2_AGENCIA)+"-"+Alltrim(SA2->A2_DVAGENC)
			cContaCorr := Alltrim(SA2->A2_NUMCON)+"-"+Alltrim(SA2->A2_DVCONTA)
			
			If (cOrigem == "1") .Or. (cOrigem == "3")
				@ 27,150  Say cNome														SIZE 130,08 PIXEL
				@ 113,080 Say SA2->A2_BANCO 											SIZE 10,08 PIXEL
				@ 128,080 Say AllTrim(SA2->A2_AGENCIA) + "-" + AllTrim(SA2->A2_DVAGENC) SIZE 50,08 PIXEL
				@ 143,080 Say AllTrim(SA2->A2_NUMCON) + "-" + AllTrim(SA2->A2_DVCONTA) 	SIZE 50,08 PIXEL
			Endif
			
		EndIf
		
	EndIf
	
	Restarea(aAreaAnt)
	
Return(lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldLoja  บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo da loja do fornecedor.                 ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldLoja(cFornece,cLoja,cOrigem)

	Local lReturn   := .t.
	Local aAreaAnt	:= GetArea()
	
	DEFAULT cOrigem := "3"
	
	If Empty(cLoja)
		MsgBox("Deve ser informada a loja do fornecedor","Ha pelo menos um campo obrigatorio vazio","ERROR")
		lReturn:= .f.
	Else
		lReturn:= fVldFor(cFornece,cOrigem,cLoja)
	EndIf
	
	RestArea(aAreaAnt)
	
Return(lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldCC    บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo do centro de custo.                    ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldCC(cCusto)

	Local aAreaAnt:= GetArea()
	Local lRet:= .f.
	
	CTT->( DbSetOrder(1) )
	CTT->( DbGoTop() )
	
	If Posicione("CTT",1,xFilial("CTT")+cCusto,"CTT_BLOQ") == '1'
		MsgBox("Centro de Custo Bloqueado.","Atencao","ERROR")
		Return(.f.)
	Endif
	
	If !CTT->(DbSeek(xFilial("CTT")+cCusto))
		MsgBox("Centro de Custo nao cadastrado","Atencao","ERROR")
		lRet := .f.
	ElseIf CTT->CTT_CLASSE = "1"
		MsgBox("Nessa rotina sao aceitos somente Centros de Custo Analiticos."+chr(13)+;
		"Verifique e corrija.","Atencao","ERROR")
		lRet := .f.
	Else
		cDescCC := CTT->CTT_DESC01
//		@ 57,100 Get cDescPep When .f. SIZE 80,08
		lRet := .t.
	Endif
	
	RestArea(aAreaAnt)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldPep   บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo do elemento PEP.                       ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldPep(cPep)

	Local cDescPep:= Space(40)
	Local aAreaAnt:= GetArea()
	Local _lReturn:= .t.
	
	DbSelectArea("CTD")
	CTD->( DbSetOrder(1) )	// CTD_FILIAL+CTD_ITEM
	
	If Empty(cPep)
		
		@ 58,126 Get cDescPep When .f. SIZE 130,08 PIXEL	// para o caso de ter conteudo antigo
		ApMsgStop("Aten็ใo: Elemento Pep ้ obrigat๓rio.")
		_lReturn:= .f.
		
	Else
		
		If !CTD->(dbSeek(xFilial("CTD")+cPep))
			Msgbox("Elemento PEP nใo cadastrado","Aten็ใo","ERROR")
			_lReturn:= .f.
			
		Else
			
			If Posicione("CTD",1,xFilial("CTD")+cPep,"CTD_BLOQ") == '1'
				MsgBox("Elemento PEP estแ bloqueado!")
				_lReturn:= .f.
			Else
				cDescPep := CTD->CTD_DESC01
				_lReturn:= .t.
				@ 058,155 MsGet oDescPep  Var cDescPep  Of _oDlgPA Pixel SIZE 130,008 				 When .F.
	//			@ 58,126 Get cDescPep When .F. SIZE 130,08 PIXEL
			Endif
			
		Endif
		
	EndIf
	
	RestArea(aAreaAnt)
Return(_lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldHist  บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo do campo hist๓rico.                    ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldHist(cTpForX,cHistX)

	Local _lReturn:= .t.
	
	If cTpForX == "4"
		If Empty(cHistX)
			
			Msgbox("Obrigatorio o preenchimento do campo HISTORICO para esse tipo de fornecedor"+chr(13)+;
			"(Tipo: 4 - TROCO)","Atencao","ERROR")
			_lReturn:= .f.
			
		Endif
	Endif

Return( _lReturn )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfHistApr  บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para montagem da tela de hist๓rico de pgto antecipado.ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fHistApr()

	Local aAreaBKP	:= GetArea()
	Local cQuery	:= ""
	Local bQuery	:= {|| Iif(Select("TRB_ZZ6") > 0, TRB_ZZ6->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB_ZZ6",.F.,.T.), dbSelectArea("TRB_ZZ6"), TRB_ZZ6->(dbGoTop()) }
	Local aAlcada	:= {}
	Local aStatus	:= {}
	Local oDlgMain	:= Nil
	Local oListGrps	:= Nil
	Local aCoorden	:= MsAdvSize(.T.)
	Local cNumPA	:= ZZE->ZZE_NUMERO
	Local _lReturn  := .t.
	Local cNomeUser	:= ""
	Local _cAliasCR	:= GetNextAlias()
	Local _cGrpApv	:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")

	
	Aadd( aStatus, "Aguardando aprova็ใo nesse nํvel" )
	Aadd( aStatus, "Aprovada nesse Nํvel" )
	Aadd( aStatus, "Cancelada nesse nํvel" )
	Aadd( aStatus, "Parada em nํveis anteriores" )
	Aadd( aStatus, "Invalida Por Conflito de Al็ada" )
	
	
	If ( ZZE->ZZE_STATUS == "C" )
		
		Msgbox("Essa solicita็ใo de PA foi cancelada","Atencao","INFO")
		
	Else
		
		cQuery := " SELECT ZZ6_NIVEL, ZZ6_STATUS, ZZ6_HRENT, ZZ6_DTENT, ZZ6_HRSAI, ZZ6_DTSAI, AK_NOME, ZZ6_MEMO1 "
		cQuery += " FROM " + RetSQLName("ZZ6") + " A, " + RetSQLName("SAK") + " B "
		cQuery += " WHERE ZZ6_FILIAL = '" + ZZE->ZZE_FILIAL + "' AND ZZ6_PA = '" + cNumPA + "' AND A.D_E_L_E_T_ = ' ' AND "
		cQuery += "       AK_FILIAL = '" + xFilial("SAK") + "' AND AK_COD = ZZ6_APROV AND B.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY ZZ6_NIVEL "
		
		cQuery := ChangeQuery(cQuery)
		
		// Executa Query
		LjMsgRun( "Buscando Hist๓rico de Aprova็ใo","Aguarde...",bQuery)
		
		// Altera็ใo feita por Luiz Eduardo em 06/02/2019 para verificar se o aprovador estแ com o mesmo nํvel do SAL caso negativo vai igualar
		Select SCR
		seek xFilial()+"ZZ"+cNumPA
		Select SAL
		dbSetOrder(3)
		Seek xFilial()+scr->(CR_GRUPO+CR_APROV)
		Select SCR
		if scr->CR_NUM = cNumPA .and. scr->(CR_GRUPO+CR_APROV) = sal->(AL_COD+AL_APROV) .and. sal->AL_Nivel <> scr->Cr_Nivel .and. !eof()
			RecLock("SCR",.f.)
			SCR->CR_NIVEL := SAL->AL_NIVEL
			MsUnLock()
		endif
		// Final da altera็ใo
		
		If TRB_ZZ6->(Eof())
			cQuery := " SELECT AL_NIVEL AS NIVEL, CR_STATUS AS SITUA, CR_EMISSAO AS EMISSAO, CR_DATALIB AS DTLIB, CR_USERLIB AS USRLIB, CR_USER AS USERCOM,AK_NOME AS NOME"
			cQuery += " FROM " + RetSQLName("SCR") + " A, " + RetSQLName("SAK") + " B, " + RetSQLName("SAL") + " C "
//			cQuery += " WHERE CR_FILIAL = '" + xFilial("SCR") + "' AND CR_NUM = '" + cNumPA + "' AND A.D_E_L_E_T_ = ' ' AND "
			cQuery += " WHERE CR_NUM = '" + cNumPA + "' AND A.D_E_L_E_T_ = ' ' AND "
			cQuery += "       AK_FILIAL = '" + xFilial("SAK") + "' AND AK_COD = CR_APROV AND B.D_E_L_E_T_ = ' ' AND "
			cQuery += "       AL_FILIAL = '" + xFilial("SAL") + "' AND AL_APROV = CR_APROV AND AL_NIVEL = CR_NIVEL AND C.D_E_L_E_T_ = ' ' " //AND AL_COD = '" +_cGrpApv + "'"
			cQuery += " GROUP BY AL_NIVEL, CR_STATUS, CR_EMISSAO, CR_DATALIB, CR_USERLIB,CR_USER, AK_NOME"
			cQuery += " ORDER BY AL_NIVEL "
			TcQuery cQuery New Alias &(_cAliasCR)
			
			If (_cAliasCR)->(Eof())
				MsgAlert("Aten็ใo, essa solicita็ใo de pagto. antecipado nใo possui al็ada de aprova็ใo.")
				_lReturn:= .f.
			Else
			
				PswOrder(1)
				PswSeek((_cAliasCR)->USRLIB,.T.)

				if !empty((_cAliasCR)->USRLIB) // VERIFICA SE ESTม LIBERADO OU NรO - Erro ap๓s migra็ใo 12.1.25 - Luiz Eduardo - 20-02-2020
				(_cAliasCR)->( DbEval({|| Aadd(aAlcada,{(_cAliasCR)->NIVEL,;
				(_cAliasCR)->NOME,;
				Iif((_cAliasCR)->SITUA=='01','Aguardando',Iif((_cAliasCR)->SITUA=='02','Em Aprovacao',Iif((_cAliasCR)->SITUA=='03','Aprovado','Bloqueado'))),;
				SToD((_cAliasCR)->EMISSAO),;
				AllTrim(Pswret(1)[1][4]),;
				SToD((_cAliasCR)->DTLIB)}) }))
				else
				PswOrder(1)
				PswSeek((_cAliasCR)->USERCOM,.T.)

				(_cAliasCR)->( DbEval({|| Aadd(aAlcada,{(_cAliasCR)->NIVEL,;
				(_cAliasCR)->NOME,;
				Iif((_cAliasCR)->SITUA=='01','Aguardando',Iif((_cAliasCR)->SITUA=='02','Em Aprovacao',Iif((_cAliasCR)->SITUA=='03','Aprovado','Bloqueado'))),;
				SToD((_cAliasCR)->EMISSAO),;
				AllTrim(Pswret(1)[1][4]),;
				SToD((_cAliasCR)->DTLIB)}) }))
				endif
			
				PswOrder(1)
				PswSeek(ZZE->ZZE_USERID,.T.)
				cNomeUser:= ZZE->ZZE_USERID+" - "+AllTrim(Pswret(1)[1][4])
				
				//Tela de historico da aprovacao
				oDlgMain := TDialog():New(aCoorden[7],000,aCoorden[6]/1.5,aCoorden[5]/1.5,OemToAnsi("Hist๓rico de Aprova็ใo"),,,,,,,,oMainWnd,.T.)
				TSay():New(014,001,{|| OemToAnsi("Solicita็ใo")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
				@ 024,001 MsGet ZZE->ZZE_NUMERO Picture "@!" Size 030,8 When .F. Of oDlgMain Pixel
				
				TSay():New(014,040,{|| OemToAnsi("Solicitante")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
				@ 024,040 MsGet cNomeUser Picture "@!" Size oDlgMain:nWidth/2-50,8 When .F. Of oDlgMain Pixel
				
				@ 040,001 ListBox oListGrps Var cItemSel Fields Header "Nํvel","Nome Aprovador","Status","Data Emissao","Usuario Lib.","Data Liber." Size oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-55 ;
				Pixel Of oDlgMain 
				
				oListGrps:SetArray(aAlcada)
				oListGrps:bLine := {||{		AllTrim(aAlcada[oListGrps:nAt][1]),;
				AllTrim(aAlcada[oListGrps:nAt][2]),;
				AllTrim(aAlcada[oListGrps:nAt][3]),;
				AllTrim(aAlcada[oListGrps:nAt][4]),;
				AllTrim(aAlcada[oListGrps:nAt][5]),;
				AllTrim(aAlcada[oListGrps:nAt][6])}}
				
				oDlgMain:Activate(,,,.T.,,,{||EnchoiceBar(oDlgMain,{|| oDlgMain:End()},{|| oDlgMain:End()})},,)
			EndIf
			(_cAliasCR)->(dbCloseArea())

		Else
			
			TRB_ZZ6->( DbEval({|| Aadd(aAlcada,{TRB_ZZ6->ZZ6_NIVEL,;
			aStatus[Val(TRB_ZZ6->ZZ6_STATUS)],;
			TRB_ZZ6->ZZ6_HRENT,;
			SToD(TRB_ZZ6->ZZ6_DTENT),;
			TRB_ZZ6->ZZ6_HRSAI,;
			SToD(TRB_ZZ6->ZZ6_DTSAI),;
			TRB_ZZ6->AK_NOME,;
			TRB_ZZ6->ZZ6_MEMO1 }) }))
			
			PswOrder(1)
			PswSeek(ZZE->ZZE_USERID,.T.)
			cNomeUser:= ZZE->ZZE_USERID+" - "+AllTrim(Pswret(1)[1][4])
			
			//Tela de historico da aprovacao
			oDlgMain := TDialog():New(aCoorden[7],000,aCoorden[6]/1.5,aCoorden[5]/1.5,OemToAnsi("Hist๓rico de Aprova็ใo"),,,,,,,,oMainWnd,.T.)
			TSay():New(014,001,{|| OemToAnsi("Solicita็ใo")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
			@ 024,001 MsGet ZZE->ZZE_NUMERO Picture "@!" Size 030,8 When .F. Of oDlgMain Pixel
			
			TSay():New(014,040,{|| OemToAnsi("Solicitante")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
			@ 024,040 MsGet cNomeUser Picture "@!" Size oDlgMain:nWidth/2-50,8 When .F. Of oDlgMain Pixel
			
			@ 040,001 ListBox oListGrps Var cItemSel Fields Header "Nํvel","Nome Aprovador","Status","Hr. Entrada","Data Entrada","Hr. Saida","Data Saida","Possui Justificativa" Size oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-55 ;
			Pixel Of oDlgMain ;
			On dblClick( Iif(!Empty(AllTrim(aAlcada[oListGrps:nAt][8])),MsgAlert("JUSTIFICATIVA:"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+Msmm(aAlcada[oListGrps:nAt][8])),Nil) )
			oListGrps:SetArray(aAlcada)
			oListGrps:bLine := {||{		AllTrim(aAlcada[oListGrps:nAt][1]),;
			AllTrim(aAlcada[oListGrps:nAt][7]),;
			AllTrim(aAlcada[oListGrps:nAt][2]),;
			AllTrim(aAlcada[oListGrps:nAt][3]),;
			aAlcada[oListGrps:nAt][4],;
			AllTrim(aAlcada[oListGrps:nAt][5]),;
			aAlcada[oListGrps:nAt][6],;
			Iif(!Empty(AllTrim(aAlcada[oListGrps:nAt][8])),"Sim","Nใo") }}
			
			oDlgMain:Activate(,,,.T.,,,{||EnchoiceBar(oDlgMain,{|| oDlgMain:End()},{|| oDlgMain:End()})},,)
			
		EndIf		
	EndIf
	
	// Restaura Area Anterior
	RestArea(aAreaBKP)
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldPA    บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para inclusใo do pagamento antecipado.                ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldPA(_nOpc)

	Local aAreaAnt		:= GetArea()
	Local _lReturn		:= .f.
	Local _lOk			:= .F.
	Local _cQuery		:= ""
	Local _cNumero		:= ZZE->ZZE_NUMERO
	Local _cCusto		:= Space(TamSx3("ZZ5_CC")[1])
	Local _cNivel		:= Space(TamSx3("ZZ5_NIVEL")[1])
	Local _cAprovAux	:= Space(TamSx3("ZZ6_APROV")[1])
	Local _cUltZZ6		:= Space(TamSx3("ZZ6_NIVEL")[1])
	Local _cNumPA		:= Space(TamSx3("ZZ6_NIVEL")[1])
	Local _aCols		:= _oGDadosPA:aCols
	Local _nI			:= 0
	Local _nSeqPA		:= GdFieldPos("PA_SEQ" 		,_oGDadosPA:aHeader) 
	Local _nValor		:= GdFieldPos("PA_VALOR" 	,_oGDadosPA:aHeader) 
	Local _nDtPag		:= GdFieldPos("PA_DTPGTO" 	,_oGDadosPA:aHeader) 
	Local _nDtAc		:= GdFieldPos("PA_DTACERT" 	,_oGDadosPA:aHeader) 
	Local _nDirf		:= GdFieldPos("PA_DIRF" 	,_oGDadosPA:aHeader) 
	Local _nNature		:= GdFieldPos("PA_NATUREZ" 	,_oGDadosPA:aHeader)
	Local _nCCusto		:= GdFieldPos("PA_CCUSTO" 	,_oGDadosPA:aHeader)
	Local _cGrpApv		:= Posicione("CTT",1,xFilial("CTT")+cCusto,"CTT_XGRAPR")
	Local _cAliasAPV	:= GetNextAlias()
	Local _nVlrPA		:= 0
	
	Do Case
		Case _nOpc == 3
	
			Do Case
				Case Empty(cFornece)
					Msgbox("Deve ser informado o codigo do fornecedor","Ha pelo menos um campo obrigatorio vazio","ERROR")
				Case Empty(cLoja)
					MsgBox("Deve ser informada a loja do fornecedor","Ha pelo menos um campo obrigatorio vazio","ERROR")
				Case Empty(cHistor)
					MsgAlert("Aten็ใo, o camp HISTำRICO ้ de preenchimento obrigat๓rio. Preencha antes de cofirmar a inclusใo.")
				OtherWise
					_lReturn:= .t.
			EndCase
			
			If _lReturn				
				DbSelectArea("ZZE")
				Begin Transaction 
					For _nI	:= 1 To Len(_aCols)
						If _aCols[_nI,_nValor] > 0 .And. !Empty(_aCols[_nI,_nCCusto]) .And. !Empty(_aCols[_nI,_nDtPag]) .And. !Empty(_aCols[_nI,_nNature]) .And. !(_aCols[_nI,Len(_aCols[_nI])]) //  .And. !Empty(_aCols[_nI,_nDirf]) 
							If RecLock("ZZE",.T.)
								ZZE->ZZE_FILIAL	:= xFilial("ZZE")
								ZZE->ZZE_NUMERO	:= cNumero				
								ZZE->ZZE_MOEDA	:= Ascan(aMoedas,cMoeda)
								ZZE->ZZE_FORNEC	:= cFornece
								ZZE->ZZE_LOJA	:= cLoja
								ZZE->ZZE_NOMFOR	:= cNome
								ZZE->ZZE_TIPO	:= Iif(  Subs(cTipoFor,1,1)=="5", 8, Val(Subs(cTipoFor,1,2) ) )
								ZZE->ZZE_CCUSTO	:= _aCols[_nI,_nCCusto]
								ZZE->ZZE_BANCO	:= cBanco
								ZZE->ZZE_AGENC	:= cAgencia
								ZZE->ZZE_CONTA	:= cContaCorr
								ZZE->ZZE_PEDIDO	:= cPedido
								ZZE->ZZE_VALOR	:= _aCols[_nI,_nValor]
								ZZE->ZZE_DATA	:= _aCols[_nI,_nDtPag]
								ZZE->ZZE_HISTOR	:= cHistor
								ZZE->ZZE_USERID	:= __cUserID
								ZZE->ZZE_PEP	:= cPep
								ZZE->ZZE_DTAC	:= _aCols[_nI,_nDtAc]
								ZZE->ZZE_NATURE	:= _aCols[_nI,_nNature]
								ZZE->ZZE_DIRF	:= _aCols[_nI,_nDirf]
								ZZE->ZZE_ITEM	:= _aCols[_nI,_nSeqPA]
								ZZE->ZZE_CCAPRO	:= cCusto
								If !Empty(cPedido)
									ZZE->ZZE_STATUS	:= "L"
								Else
									ZZE->ZZE_STATUS	:= "P"
								Endif
							
								PswOrder(1)
								If PswSeek(__cUserID, .T. )
									ZZE->ZZE_DEPTO := Pswret(1)[1][12]
								Endif
								_cGrpApv		:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCAPRO,"CTT_XGRAPR") 
								ZZE->ZZE_XGRPAP	:= _cGrpApv
								_nVlrPA			+= _aCols[_nI,_nValor]
								MSMM(,,,cDesc,1,,,"ZZE","ZZE_DESC")
						
								ZZE->( Msunlock() )			
								_lOk	:= .T.
								ConfirmSx8()
							EndIf
						EndIf
					Next _nI
					
					If _lOk
	//					fGrvAlc(cNumero,cCusto,.F.,.F.)  
						MaAlcDoc({ZZE->ZZE_NUMERO,"ZZ",_nVlrPA,,,_cGrpApv,,ZZE->ZZE_MOEDA,,ZZE->ZZE_DATA},ZZE->ZZE_DATA,1)
						fVdlNvlU(_cGrpApv)
					EndIf
				End Transaction
			EndIf
			
		Case _nOpc == 5
		
			If MsgBox("Confirma o CANCELAMENTO dessa Solicitacao de Pagamento Antecipado ?","Atencao","YESNO")
				Begin Transaction 
	
					ZZE->(dbGoTop())     
					ZZE->(dbSetOrder(1))
					If ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
						While ZZE->(!EOF()) .And. ZZE->ZZE_NUMERO == _cNumero
							If RecLock("ZZE",.F.)
								ZZE->ZZE_STATUS	:= "C"
								_nVlrPA			+= ZZE->ZZE_VALOR
								ZZE->( MsUnLock() )
							EndIf
							ZZE->(dbSkip())
						EndDo
					EndIf
					
					ZZE->(dbSetOrder(1))
					ZZE->(dbGoTop())
					If ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
						MaAlcDoc({ZZE->ZZE_NUMERO,"ZZ",_nVlrPA,,,ZZE->ZZE_XGRPAP,,ZZE->ZZE_MOEDA,,ZZE->ZZE_DATA},dDataBase,3)				
					EndIf
				End Transaction 
			
			EndIf
			
		Case _nOpc == 4
		
			If MsgBox("Confirma a APROVAวรO desta Solicita็ใo ?","Atencao","YESNO")
				Begin Transaction 
				
					ZZE->(dbSetOrder(1))
					ZZE->(dbGoTop())
					If ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
						While ZZE->(!EOF()) .And. ZZE->ZZE_NUMERO == _cNumero
							_nVlrPA	+= ZZE->ZZE_VALOR
							ZZE->(dbSkip())
						EndDo
					EndIf
					
					dbSelectArea("SCR")
					SCR->(dbSetOrder(2))
					If SCR->(dbSeek(xFilial("SCR") + PadR("ZZ",TamSX3("CR_TIPO")[1]) + PadR(_cNumero,TamSX3("CR_NUM")[1]) + __cUserId))
//						MaAlcDoc({ZZE->ZZE_NUMERO,"ZZ",ZZE->ZZE_VALOR,SCR->CR_APROV,__cUserId,,,ZZE->ZZE_MOEDA,,ZZE->ZZE_DATA},dDataBase,4)				
						MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,_nVlrPA,SCR->CR_APROV,,ZZE->ZZE_XGRPAP,,,,,    },dDataBase,4)				
					EndIf
					
					_cQuery	:= "SELECT CR_NUM "
					_cQuery	+= " FROM " + RetSqlName("SCR") + " SCR "
					_cQuery	+= " WHERE CR_NUM = '" + _cNumero + "'"
					_cQuery	+= " AND CR_DATALIB = ' '"
					_cQuery	+= " AND D_E_L_E_T_ = ' '"
					
					TcQuery _cQuery New Alias &(_cAliasAPV)
					
					If (_cAliasAPV)->(!EOF())
						ZZE->(dbSetOrder(1))
						ZZE->(dbGoTop())
						If ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
							While ZZE->(!EOF()) .And. ZZE->ZZE_NUMERO == _cNumero
								If Reclock("ZZE",.F.)
									ZZE->ZZE_STATUS := "E"
									MSMM(,,,cDesc,1,,,"ZZE","ZZE_DESC")
									MsUnlock()
								EndIf
								ZZE->(dbSkip())
							EndDo
						EndIf
	
					Else
						ZZE->(dbSetOrder(1))
						ZZE->(dbGoTop())
						If ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
							While ZZE->(!EOF()) .And. ZZE->ZZE_NUMERO == _cNumero
								If Reclock("ZZE",.f.)
									ZZE->ZZE_STATUS := "L"
									MSMM(,,,cDesc,1,,,"ZZE","ZZE_DESC")
									MsUnlock()
									If ZZE->ZZE_TIPO == 9 .And. !Empty( GetMv("T4F_MAILRP") )
			//							SendEMail()
									EndIf
								EndIf									
								ZZE->(dbSkip())
							EndDo
						EndIf
					EndIf
				End Transaction
			EndIf
			
			(_cAliasAPV)->(dbCloseArea())
	End Case
		
	RestArea(aAreaAnt)
	Close(_oDlgPA)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVdlNvlU  บAutor  ณBruna Zechetti      บ Data ณ  04/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo do nํvel do usuแrio/aprovador.         ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function fVdlNvlU(_cGrpApv)
	
	Local _aArea		:= GetArea()
	Local _lOk			:= .F.
	Local _cAliasSCR	:= GetNextAlias()
	Local _cAliasSAL    := GetNextAlias()

	dbSelectArea("SA2")
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+ZZE->ZZE_FORNEC+ZZE->ZZE_LOJA))
		If !Empty(SA2->A2_XCODUSR)
			_cQuery	:= "UPDATE " + RetSqlName("SCR")
			_cQuery	+= " SET D_E_L_E_T_ = '*'"
			_cQuery	+= " WHERE CR_FILIAL = '" + xFilial("SCR") + "'"
			_cQuery	+= " AND CR_NUM = '" + ZZE->ZZE_NUMERO + "'"
			_cQuery += " AND CR_TIPO = 'ZZ'"
			_cQuery += " AND CR_USER = '" + SA2->A2_XCODUSR + "'"
			TCSQLEXEC(_cQuery)
			DBCOMMIT()
		EndIf
	EndIf
	
	_cQuery	:= "SELECT CR_NUM "
	_cQuery	+= " FROM " + RetSqlName("SCR") + " SCR "
	_cQuery	+= " WHERE CR_NUM = '" + ZZE->ZZE_NUMERO + "'"
	_cQuery	+= " AND D_E_L_E_T_ = ' '"
	TcQuery _cQuery New Alias &(_cAliasSCR)
	
	If (_cAliasSCR)->(!EOF())
		_lOk	:= .T.
	Else
		_cQuery	:= "SELECT AL_APROV, AL_USER, AL_NIVEL "
		_cQuery	+= " FROM " + RetSqlName("SAL") + " SAL "
		_cQuery	+= " WHERE AL_COD = '" + _cGrpApv + "'"
		_cQuery	+= " AND AL_NIVEL > (SELECT AL_NIVEL FROM SAL080 WHERE AL_COD = '" + _cGrpApv + "' AND AL_USER = '" + SA2->A2_XCODUSR + "' AND D_E_L_E_T_ = ' ')"
		_cQuery	+= " AND D_E_L_E_T_ = ' '"
		_cQuery	+= " ORDER BY AL_NIVEL,AL_ITEM"
		TcQuery _cQuery New Alias &(_cAliasSAL)
		
		If (_cAliasSAL)->(!EOF())
			If RecLock("SCR",.T.)
				SCR->CR_FILIAL	:= xFilial("SCR")
				SCR->CR_TIPO	:= "ZZ"
				SCR->CR_USER	:= (_cAliasSAL)->AL_USER
				SCR->CR_APROV	:= (_cAliasSAL)->AL_APROV
				SCR->CR_NIVEL	:= (_cAliasSAL)->AL_NIVEL
				SCR->CR_STATUS	:= '02'
				SCR->CR_NUM		:= ZZE->ZZE_NUMERO
				SCR->CR_TOTAL	:= ZZE->ZZE_VALOR
				SCR->CR_EMISSAO	:= ZZE->ZZE_DATA
				SCR->CR_MOEDA	:= ZZE->ZZE_MOEDA
				SCR->(MsUnLock())
			EndIf
		EndIf
		(_cAliasSAL)->(dbCloseAre())

	EndIf

	(_cAliasSCR)->(dbCloseAre())
	RestArea(_aArea)

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLEgend   บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para gera็ใo da legenda dos pagamentos antecipados.   ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fLEgend()

	Local aLegenda := {	{"ENABLE",		"Liberado"},;
						{"DISABLE",		"Aguardando analise pelos aprovadores"},;
						{"BR_AMARELO",	"Em processo de aprovacao"},;
						{"BR_PRETO",	"Cancelado"}}

	BrwLegenda("","Legenda", aLegenda )
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSendEMail บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para envio do e-mail pgto ant. liberado.              ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SendEMail()

	Local oDlg
	Local aFiles		:= Array(1)
	Local cDestEmail	:= SuperGetMv("T4F_MAILRP",,"cmissura@t4f.com.br")   // microsiga01@t4f.com.br"  //GetMv("MV_XMAILAP",,"microsiga01@t4f.com.br")
	Local _cSUBJECT		:= "[AVISO] Libera็ใo de Repasse"
	Local cTxtEMail 	:= "Aten็ใo : Foi liberada solicita็ใo de repasse numero : " + ZZE->ZZE_NUMERO + ZZE->ZZE_ITEM
	
	U_EnvEmail(cDestEmail,_cSUBJECT,cTxtEmail,aFiles,.F.,oDlg)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvAlc   บAutor  ณBruna Zechetti      บ Data ณ  20/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para gera็ใo da al็ada de pagamento do PA.            ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrvAlc(cNum,cCentroCusto,lBlqPCO,lPCO)

	Local cPrimNiv	:= "999"
	Local cUser		:= __cUSERID
	Local lOK		:= .F.
	Local lPassa	:= .F.
	Local nRegs		:= 0
	Local aZZ6      := {}
	Local aArea     := {}
	Local lPAPC	    := GetMv("MV_PACOMPC",,.F.)
	
	If lBlqPCO .Or. !lPCO
		
		If !Empty(cPedido) .and. lPAPC

			aArea:=GetArea()
			
			DbSelectArea("SC1")
			SC1->(DbSetOrder(6))	//Filial + Pedido + Item do Pedido + Produto
			SC1->(DbGotop())
			If DbSeek(xFilial("SC1") + cPedido)
				
				DbSelectArea("ZZ6")
				ZZ6->(DbSetOrder(1))	//Filial + SC
				ZZ6->(DbGotop())
				If DbSeek(xFilial("ZZ6") + SC1->C1_NUM)
					While !Eof() .And. ZZ6->ZZ6_SC == SC1->C1_NUM
						aAdd(aZZ6,{ZZ6->ZZ6_APROV,ZZ6->ZZ6_NIVEL,ZZ6->ZZ6_STATUS,ZZ6->ZZ6_HRENT,ZZ6->ZZ6_DTENT,ZZ6->ZZ6_HRSAI,ZZ6->ZZ6_DTSAI} )
						ZZ6->(DbSkip())
					EndDo
				EndIf
				
				For nY := 1 To Len(aZZ6)
					If Reclock("ZZ6",.T.)
						ZZ6->ZZ6_APROV  := aZZ6[nY][1]
						ZZ6->ZZ6_NIVEL  := aZZ6[nY][2]
						ZZ6->ZZ6_STATUS := aZZ6[nY][3]
						ZZ6->ZZ6_HRENT  := aZZ6[nY][4]
						ZZ6->ZZ6_DTENT  := aZZ6[nY][5]
						ZZ6->ZZ6_HRSAI  := aZZ6[nY][6]
						ZZ6->ZZ6_DTSAI  := aZZ6[nY][7]
						ZZ6->ZZ6_PA     :=	 cNum
						MsUnlock()
					EndIf
				Next
			Else
				Alert("Nใo existe SC para o PC informado no PA.Verifique!!!")
			Endif
			
			RestArea(aArea)
			
		Else
			
			DbSelectArea("ZZ5")
			ZZ5->(Dbsetorder(3))  // CC + Nivel
			If Dbseek(xfilial("ZZ5") + cCentroCusto)
				While ZZ5->(!Eof()) .and. (ZZ5->ZZ5_FILIAL + ZZ5->ZZ5_CC == xfilial("ZZ5") + cCentroCusto)
					
					DbSelectArea("SAK")
					SAK->(DbSetOrder(1))
					SAK->(DbSeek(xFilial("SAK") + ZZ5->ZZ5_APROV))  // Pega dados do aprovador
					
					lPassa:= (SAK->AK_USER == CUSER)
					
					If (ZZE->ZZE_VALOR >= SAK->AK_LIMMIN .AND. ZZE->ZZE_VALOR <= SAK->AK_LIMMAX) .OR. (nRegs=0)
						
						DbSelectArea("ZZ6")
						ZZ6->(RecLock("ZZ6",.T.))
						ZZ6->ZZ6_FILIAL	:= xFilial("ZZ6")
						ZZ6->ZZ6_PA		:= cNum
						ZZ6->ZZ6_APROV	:= ZZ5->ZZ5_APROV
						ZZ6->ZZ6_NIVEL	:= ZZ5->ZZ5_NIVEL
						ZZ6->ZZ6_STATUS	:= Iif(ZZ5->ZZ5_NIVEL > cPrimNiv,"4","1")
						
						If ZZ6->ZZ6_STATUS == "1"
							ZZ6->ZZ6_HRENT		:= Time()
							ZZ6->ZZ6_DTENT		:= dDataBase
							cPrimNiv			:= ZZ5->ZZ5_NIVEL
						EndIf
						
						If lPassa
							ZZ6->ZZ6_HRSAI		:= Time()
							ZZ6->ZZ6_DTSAI		:= dDataBase
							ZZ6->ZZ6_STATUS		:= "5"
							If nRegs<0
								cPrimNiv		="888"
							Endif
						Else
							nRegs++
						Endif
						ZZ6->(MsUnlock())
					Endif
					ZZ5->(dbSkip())
				EndDo
			Endif

/*			If nRegs>0
				MSGALERT("Solicita็ใo INVALIDA!! Sem aprovadores cadastrados!!")
			Endif */

		Endif
	Else

		dbSelectArea("ZZ6")
		If RecLock("ZZ6",.T.)
			ZZ6->ZZ6_FILIAL	:= xFilial("ZZ6")
			ZZ6->ZZ6_APROV	:= "PCO"
			ZZ6->ZZ6_NIVEL	:= "X"
			ZZ6->ZZ6_STATUS	:= "6"
			ZZ6->ZZ6_HRENT	:= Time()
			ZZ6->ZZ6_DTENT	:= dDataBase
			ZZ6->ZZ6_HRSAI	:= Time()
			ZZ6->ZZ6_DTSAI	:= dDataBase
			ZZ6->ZZ6_PA		:= cNum
			ZZ6->(MsUnlock())
		EndIf
	EndIf

Return(Nil)
