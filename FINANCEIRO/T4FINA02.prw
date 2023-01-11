#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#INCLUDE "Colors.Ch"

#Define CRLF chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FINA02  ºAutor  ³Bruna Zechetti      º Data ³  26/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para geração de de títulos da tabela ZZE.             ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function T4FINA02()


	Private aCampos	:= {	{"ZZE_NUMERO","Numero"},;
							{"ZZE_FORNEC","Fornecedor"},;
							{"ZZE_VALOR" ,"Valor"},;
							{"ZZE_DATA"  ,"Data pagto."},;
							{"ZZE_PREF"  ,"Prefixo"},;
							{"ZZE_TITULO","Numero"},;
							{"ZZE_PARC"  ,"Parcela"}}

	Private aRotina		:= {{"Pesquisar"		,"AxPesqui"	,0,1},;
							{"Visualizar"		,"AxVisual"	,0,2},;
							{"Gerar titulo"		,"U_fGerTit",0,2},;
							{"Excluir Tit."		,"U_fExcTit",0,2},;
							{"Hist Aprovacao"	,"U_fHistApr",0,2},;
							{"Legenda"			,"U_fLegSE2",0,2}}

	
	Private aCores		:= {{"!Empty(ZZE->ZZE_IDBDUP) .AND. EMPTY(ZZE->ZZE_TITULO)","BR_AZUL"},{"empty(ZZE_PREF)","ENABLE"},{"!empty(ZZE_PREF)","DISABLE"}}
	Private cCadastro	:= "Geracao de titulos a pagar a partir das solicitacoes de Pagto Antecipado/Avulso/Repasse"
	Private aIndice		:= {}

	MBrowse(6, 1,22,75,"ZZE",,,,,,aCores,,,,,,,,"ZZE_STATUS = 'L' and ZZE_TIPO<>4 and ZZE_TIPO<>7 and ZZE_TIPO<>6")
	
	RetIndex("ZZE")
	dbClearFilter()

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fExcTit   ºAutor  ³Bruna Zechetti      º Data ³  26/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para exclusão do título.                              ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fExcTit()
        
	ApmsgInfo("Atenção: "+chr(13)+;
			  "O titulo gerado por essa rotina somente poderá " + chr(13) +;
			  "ser excluído através da rotina de Contas à Pagar." + chr(13) + chr(13) +;
			  "Prefixo: " + ZZE->ZZE_PREF + CHR(13) +;
			  "Título.: " + ZZE->ZZE_TITULO + CHR(13) +;
			  "Parc...: " + ZZE->ZZE_PARC )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGerTit   ºAutor  ³Bruna Zechetti      º Data ³  26/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para geração de títulos PA.                           ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fGerTit()

	Local cArquivo		:= ""
	Local c513			:= Nil
	Local nHdlPrv		:= 0
	Local nTotal 		:= 0
	Local nTotalCTB		:= 0
	Local nTipo			:= ZZE->ZZE_TIPO
	Local cTipo			:= Space(03)
	Local cPerg         := "GERSE2"
	Local xPrefixo		:= Iif(!Empty(ZZE->ZZE_PREF),ZZE->ZZE_PREF,"AUT")
	Local cLctPad		:= "513"
	Local cArqCtb		:= ""
	Local cPrograma		:= "GERASE2"
	Local cLoteCtb		:= "8820"
	Local _cQuery		:= ""
	Local _cNumSE2		:= ""
	Local _cParcela		:= "0"
	Local aCT5			:= {}
	Local aFlagCTB		:= {}
	Local lDigita		:= .f.
	Local lAglutina		:= .T.
	Local lPadrao		:= .f.
	Local _lOk			:= .F.
	Local _aArea		:= GetArea()

	Private lMsErroAuto := .F.
	Private cLote

	If !Empty(ZZE->ZZE_PREF) .And. Empty(ZZE->ZZE_IDBDUP)
		MsgBox("Ja foi gerado titulo a pagar para essa solicitacao de Pagamento Antecipado/Avulso","Atencao","ERROR")
		Return(.F.)
	Endif
	
	If Msgbox("Confirma a geração de um titulo a PAGAR a partir da Solicitacao de Pagto  "+chr(13)+;
		"Antecipado/Avulso ou Repasse, nr.: "+alltrim(ZZE->ZZE_NUMERO)+" ?","Atencao","YESNO")
		
		If ZZE->ZZE_TIPO == 9 .Or. ZZE->ZZE_TIPO == 0
			
			MV_PAR05:= 1		
			fVldPRep("REPPERG")
			If !Pergunte("REPPERG",.T.)
				Return(.f.)
			Else
				
				If mv_par02 < ddatabase
					ApMsgStop("Data de Vencimento Informada é Menor que a data de hoje!")
					Return(.f.)
				EndIf
				
				If ZZE->ZZE_TIPO == 9
					If !fVldNum("PRT",PADR(MV_PAR01,9))
						Return(.f.)
					EndIf
				ElseIf ZZE->ZZE_TIPO == 0
					If !fVldNum("DVI",PADR(MV_PAR01,9))
						Return(.f.)
					EndIf
					
				EndIf
				
				If !MsgYesNo("Confirma Geração do Titulo de Repasse.")
					Return(.f.)
				EndIf
				
			EndIf
			
			MV_PAR04:= ZZE->ZZE_NATURE
			If ZZE->ZZE_TIPO == 9
				MV_PAR06:= "RT " //"FT "
				xPrefixo:= "PRT" // Pagto Repasse Terceiros.
			ElseIf ZZE->ZZE_TIPO == 0
				MV_PAR06:= "DV " //"FT "
				xPrefixo:= "DVI" // Devolução de Ingressos		
			EndIf
			
		Else
			
			fVldPerg(cPerg)
			Pergunte(cPerg,.F.)
			MV_PAR01	:= ZZE->ZZE_BANCO
			MV_PAR02	:= ZZE->ZZE_AGENC 
			MV_PAR03	:= ZZE->ZZE_CONTA
			MV_PAR04	:= ZZE->ZZE_NATURE
			
			If !Empty(ZZE->ZZE_DIRF)
				MV_PAR06 := "TX "
			Else
				If !Pergunte("GERSE2",.t.)
					Return .f.
				EndIf
			Endif
			
		EndIf
		
		SED->(DbSetorder(1))
		SED->(DbGotop())
		If SED->(DbSeek(xFilial("SED") + MV_PAR04))
		
			SM2->(DbSetorder(1))
			SM2->(DbGotop())
			SM2->(DbSeek(Date()))
			
			If ZZE->ZZE_TIPO == 5
				cTipo := MV_PAR06
			Else
				If ZZE->ZZE_TIPO == 8
					cTipo := "TX "
				Else
					If ZZE->ZZE_TIPO == 9
						cTipo := "RT "
						xPrefixo := "PRT" // Pagamento Repasse Terceiro
					ElseIf ZZE->ZZE_TIPO == 0
						cTipo := "DV "
						xPrefixo := "DVI" // Devolução Ingresso
					Else
						cTipo := "PA "
					EndIF
				EndIf
			Endif
			
			If ( ZZE->ZZE_TIPO  == 9 .Or. ZZE->ZZE_TIPO == 0 )				
				cNumTitulo:= mv_par01				
			Else
				cNumTitulo := GetSXENum("SE2","E2_NUM")
				ConfirmSX8() // Evita a todo custo a repeticao do numero titulo. Gilberto.
			EndIF
		
			_cQuery	:= "SELECT 	ZZE_VALOR, ZZE_DIRF, ZZE_PEDIDO, ZZE_NUMERO, ZZE_FORNEC, ZZE_LOJA,"
			_cQuery	+= "		ZZE_TIPO, ZZE_PEP, ZZE_MOEDA, ZZE_CCUSTO, ZZE_HISTOR, R_E_C_N_O_ as CRECNO"
			_cQuery	+= "	FROM " + RetSqlName("ZZE")
			_cQuery	+= "	WHERE ZZE_FILIAL = '" + xFilial("ZZE") + "'"
			_cQuery	+= "	AND ZZE_NUMERO = '" + ZZE->ZZE_NUMERO + "'"	
			_cQuery	+= "	AND D_E_L_E_T_ <> '*'"	
			TcQuery _cQuery New Alias "TMPZZE2"
			
			TMPZZE2->(dbGoTop())
			If TMPZZE2->(!EOF())
			                    
				While TMPZZE2->(!EOF())
				
						_cParcela	:= Soma1(_cParcela)
						
						aVetorSE2 := {}
						aAdd(aVetorSE2,{"E2_FILIAL"		,xFilial("SE2")																	,Nil})
						aAdd(aVetorSE2,{"E2_PREFIXO"	,xPrefixo																		,Nil})
						aAdd(aVetorSE2,{"E2_NUM"		,cNumTitulo																		,Nil})
						aAdd(aVetorSE2,{"E2_PARCELA"	,_cParcela																		,Nil})
						aAdd(aVetorSE2,{"E2_TIPO"		,cTipo																			,Nil})
						
						If ( cTipo = "PA " )
							aAdd(aVetorSE2,{"AUTBANCO"	,MV_PAR01		   																,Nil})
							aAdd(aVetorSE2,{"AUTAGENCIA",MV_PAR02																		,Nil})
							aAdd(aVetorSE2,{"AUTCONTA"	,MV_PAR03																		,Nil})
							aAdd(aVetorSE2,{"E2_BCOPAG"	,MV_PAR01																		,Nil})
							aAdd(aVetorSE2,{"E2_AGPAG"	,MV_PAR02																		,Nil})
							aAdd(aVetorSE2,{"E2_CTAPAG"	,MV_PAR03																		,Nil})
							aAdd(aVetorSE2,{"E2_NUMPC" 	,TMPZZE2->ZZE_PEDIDO															,Nil})
						Endif
						
						aAdd(aVetorSE2,{"E2_NUMSPA"		,TMPZZE2->ZZE_NUMERO															,Nil})
						aAdd(aVetorSE2,{"E2_NATUREZ"	,MV_PAR04																		,Nil})
						If !Empty(ZZE->ZZE_DIRF)
							aAdd(aVetorSE2,{"E2_CODRET"	,TMPZZE2->ZZE_DIRF																,Nil})
							aAdd(aVetorSE2,{"E2_DIRF"	,"1"																			,Nil})
						EndIf
						aAdd(aVetorSE2,{"E2_FORNECE"	,TMPZZE2->ZZE_FORNEC															,Nil})
						aAdd(aVetorSE2,{"E2_LOJA"		,TMPZZE2->ZZE_LOJA																,Nil})
						aAdd(aVetorSE2,{"E2_EMISSAO"	,dDataBase																		,Nil})
						aAdd(aVetorSE2,{"E2_VENCTO"		,iif( TMPZZE2->ZZE_TIPO==9 .Or. TMPZZE2->ZZE_TIPO == 0, mv_par02, dDataBase)	,Nil})
						aAdd(aVetorSE2,{"E2_VENCREA"	,DataValida(iif( TMPZZE2->ZZE_TIPO==9 .Or. TMPZZE2->ZZE_TIPO == 0, mv_par02,dDataBase )),Nil})
						aAdd(aVetorSE2,{"E2_VALOR"		,TMPZZE2->ZZE_VALOR																,Nil})
						aAdd(aVetorSE2,{"E2_ITEM"		,TMPZZE2->ZZE_PEP																,Nil})
						aAdd(aVetorSE2,{"E2_MOEDA"		,TMPZZE2->ZZE_MOEDA																,Nil})
						aAdd(aVetorSE2,{"E2_TXMOEDA"	,IIf(AllTrim(MV_PAR06) $ "TX/RT",1,MV_PAR05)									,Nil})
						aAdd(aVetorSE2,{"E2_CONTAD"		,SED->ED_DEBITO																	,Nil})
						aAdd(aVetorSE2,{"E2_CONTAD"		,SED->ED_DEBITO																	,Nil})
						aAdd(aVetorSE2,{"E2_CCUSTO"		,TMPZZE2->ZZE_CCUSTO															,Nil})
						aAdd(aVetorSE2,{"E2_ITEM"		,TMPZZE2->ZZE_PEP																,Nil})
						aAdd(aVetorSE2,{"E2_HIST"		,TMPZZE2->ZZE_HISTOR															,Nil})
						
						If !empty(MV_PAR05)
							aAdd(aVetorSE2,{"E2_VLCRUZ"	,Round(NoRound((TMPZZE2->ZZE_VALOR * MV_PAR05),3),2)	,Nil})
						Else
							aAdd(aVetorSE2,{"E2_VLCRUZ"	,Round(NoRound(TMPZZE2->ZZE_VALOR,3),2),Nil})
						Endif
					
						lMsErroAuto := .f.
						MsExecAuto({|x,y| Fina050(x,y)},aVetorSE2,3)
					
						If lMsErroAuto
							SE2->(RollBackSXE())
							MostraErro()							
						Else
							ZZE->(dbGoTo(TMPZZE2->CRECNO))
							If RecLock("ZZE",.f.)
								ZZE->ZZE_PREF	:= xPrefixo
								ZZE->ZZE_TITULO	:= cNumTitulo
								ZZE->ZZE_PARC	:= _cParcela
								MsUnLock()
							Endif
							
							_cNumSE2	+= xPrefixo + " \ " + cNumTitulo + " \ " + _cParcela + CRLF
							_lOk	:= .T.							
						Endif
					TMPZZE2->(dbSkip())
				EndDo
				
				If _lOk	
					Aviso(	"Titulo a pagar gerado com sucesso","Para a Solicitação de Pagamento Antecipado/Avulso Nro. " + TMPZZE2->ZZE_NUMERO + CRLF + ;
							"Titulo(s) gerado(s) : " + CRLF + "Prefixo \ Numero \ Parcela. " + CRLF + Alltrim(_cNumSE2) ,{"OK"})
				EndIf
			EndIf
			TMPZZE2->(dbCloseArea())
		EndIf
	Endif
	
	RestArea(_aArea)
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVldNum   ºAutor  ³Bruna Zechetti      º Data ³  26/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para validação do número informado para o título.     ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fVldNum(cPrefixo,cNum)

	Local _lOk		:= .T.
	Local aSE2Area	:= SE2->( GetArea() )
	
	// Repasse terceiros. Devolução de Ingressos
	If (cPrefixo == "PRT" .Or. cPrefixo == "DVI")
		SE2->(DbSetOrder(1))
		If SE2->(DbSeek(xFilial("SE2") + cPrefixo + cNum))
			ApMsgStop("ATENÇÃO : Esse numero de título já foi utilizado !!" + chr(13) + chr(10) + "** Por favor digite outro numero... ***")
			lOk:= .F.
		EndIf
	EndIf
	
	RestArea(aSE2Area)
Return(_lOk )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLegSE2   ºAutor  ³Bruna Zechetti      º Data ³  26/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função pata montagem da legenda dos títulos ZZE.             ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fLegSE2()

	Local aLegenda	:= {{"ENABLE","Disponivel para gerar titulo"},;
						{"DISABLE","Titulo ja gerado"},;
						{"BR_AZUL","Titulo BuildUp"}}
	
	BrwLegenda("","Legendas", aLegenda )
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVldPerg  ºAutor  ³Bruna Zechetti      º Data ³  26/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função pata montagem das perguntas.                          ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fVldPerg(cPerg)

	Local j,i
	
	cPerg	:= padr(cPerg,len(SX1->X1_GRUPO))
	cAlias	:= Alias()
	aRegs	:={}
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aadd(aRegs,{cPerg,"01","Banco (somente para PA´s)   ?","","","mv_ch1","C", 3,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","",""})
	aadd(aRegs,{cPerg,"02","Agencia (somente para PA´s) ?","","","mv_ch2","C", 5,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"03","Conta (somente para PA´s)   ?","","","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"04","Natureza (somente para PA´s)?","","","mv_ch4","C",10,0,0,"G","existcpo('SED',MV_PAR04,1) .and. naovazio()","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED","","",""})
	aadd(aRegs,{cPerg,"05","Taxa da moeda               ?","","","mv_ch5","N",11,4,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"06","Tipo de titulo (exceto PA´s)?","","","mv_ch6","C", 3,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","05","","",""})
	
	for i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnLock()
		EndIf
	Next
	
	dbSelectArea(cAlias)
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVldPRep  ºAutor  ³Bruna Zechetti      º Data ³  26/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para geração das perguntas na geração do titulo.      ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fVldPRep(cPerg)

	Local j,i
	Local cPerg := PadR(cPerg,Len(SX1->X1_GRUPO))
	Local cAlias := Alias()
	
	Local aRegs   :={}
	DbSelectArea("SX1")
	SX1->( DbSetOrder(1) )
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aadd(aRegs,{cPerg,"01","Nr.Titulo : ","","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"02","Dt.Vencto : ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	for i:=1 to Len(aRegs)
		
		If !dbSeek(cPerg+aRegs[i,2])
			
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnLock()
			
		Else
			
			If ( aRegs[i,2] == "01" )
				Reclock("SX1",.F.)
				If Empty(SX1->X1_VALID)
					SX1->X1_VALID:= "!Empty(mv_par01)"
				EndIF
				
				SX1->X1_CNT01:= SPACE(LEN(SX1->X1_CNT01))
				MsUnLock()
			EndIf
			
			If ( aRegs[i,2] == "02" )
				Reclock("SX1",.F.)
				If Empty(SX1->X1_VALID)
					SX1->X1_VALID:= "DTOS(mv_par02)>=DTOS(DDATABASE)"
				EndIF
				SX1->X1_CNT01:= SPACE(LEN(SX1->X1_CNT01))
				MsUnLock()
			EndIf
			
		EndIf
		
	Next
	
	dbSelectArea(cAlias)
Return(.T.)