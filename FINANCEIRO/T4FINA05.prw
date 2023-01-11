#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FINA05  ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para liberação de documentos para aprovação SCR.      ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function T4FINA05()

	Local _cFiltro	:= ""
	Local cUserAdm	:= GetMv("MV_XADMUSR",,"000000")
	Local _aCores	:= {{ 'CR_STATUS== "01"', 'BR_AZUL' },;   //Bloqueado p/ sistema (aguardando outros niveis)
						{ 'CR_STATUS== "02"', 'DISABLE' },;   //Aguardando Liberacao do usuario
						{ 'CR_STATUS== "03"', 'ENABLE'  },;   //Pedido Liberado pelo usuario
						{ 'CR_STATUS== "04"', 'BR_PRETO'},;   //Pedido Bloqueado pelo usuario
						{ 'CR_STATUS== "05"', 'BR_CINZA'} }   //Pedido Liberado por outro usuario	

	Private cCadastro	:= "Liberação"
	Private _cCodUsr	:= RetCodUsr()
	Private aRotina		:= {}
	Private _aIndSCR	:= {}
	Private _bFilSCR	:= {||}
	Private _cFilSCR	:= ""

	If Pergunte("MTA097",.T.)
		dbSelectArea("SAK")
		dbSetOrder(2)
		If !MsSeek(xFilial("SAK")+_cCodUsr)
			Aviso(OEMTOANSI("Atenção"),"O  acesso  e  a utilizacao desta rotina e destinada apenas aos usuarios envolvidos no processo de aprovacao. Usuario sem permissao para utilizar esta rotina.",{"OK"},2)
			Return()
		EndIf

		_cFilSCR	:= Iif((__cUserID $ cUserAdm),"","CR_USER='" + _cCodUsr + "'")
		Do Case
			Case mv_par01 == 1
			_cFilSCR += Iif(Empty(_cFilSCR),""," .AND. ") + "CR_STATUS='02'"
			Case mv_par01 == 2
			_cFilSCR += Iif(Empty(_cFilSCR),""," .AND. ") + "(CR_STATUS='03' .OR. CR_STATUS='05')"
			Case mv_par01 == 3
			_cFilSCR += " "
			OtherWise
			_cFilSCR += Iif(Empty(_cFilSCR),""," .AND. ") + "(CR_STATUS='01' .OR. CR_STATUS='04' )"
		EndCase

		Aadd(aRotina,{"Pesquisar"				,"AxPesqui"		,0,1})
		Aadd(aRotina,{"Consulta Doc."			,"U_fConDoc"	,0,2})
		Aadd(aRotina,{"Consulta Saldos"			,"U_fConSld"	,0,2})
		Aadd(aRotina,{"Liberar"					,"U_fLibera"	,0,4})
		Aadd(aRotina,{"Estorno"					,"U_fEstorno"	,0,4})
		Aadd(aRotina,{"Superior"				,"U_fSuperio"	,0,4})
		Aadd(aRotina,{"Transf. para Superior"	,"U_fTranSup"	,0,4})
		Aadd(aRotina,{"Ausencia Temporaria"		,"U_fAusTemp"	,0,3})
		Aadd(aRotina,{"Legenda"					,"U_fLegLib"	,0,2})

		_bFilSCR 	:= {|| FilBrowse("SCR",@_aIndSCR,@_cFilSCR) }
		Eval(_bFilSCR)

		MBrowse(6, 1,22,75,"SCR",,,,,,_aCores,,,,,,,,_cFiltro)
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLibera   ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para liberação do docuemnto.                          ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fLibera(cAlias,nReg,nOpcx)

	Local _aArea		:= GetArea()
	Local _aRetSaldo	:= {}
	Local _cObs			:= IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,CriaVar("CR_OBS"))
	Local _nSaldo		:= 0
	Local _nTotal		:= 0
	Local _nSalDif		:= 0
	Local _nOpc			:= 0
	Local _CRMoeda		:= ""
	Local _cName		:= ""
	Local _cTpLim		:= ""
	Local _dRefer		:= dDataBase
	Local _oDlgPA		:= Nil
	Local _cCodLib 		:= SCR->CR_APROV
	Local lAprov		:= .F.
	Local _lOk			:= .T.
	Local aCposObrig	:= {"D1_ITEM","D1_COD","D1_QUANT","D1_VUNIT","D1_PEDIDO","D1_ITEMPC","C7_QUANT","C7_PRECO","C7_QUJE","Divergência"}
	Local aHeadCpos 	:= {}
	Local aHeadSize 	:= {}
	Local aArrayNF		:= {}
	Local aCampos   	:= {}
	Local aRetSaldo 	:= {}
	Local cObs 			:= IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,CriaVar("CR_OBS"))
	Local ca097User 	:= RetCodUsr()
	Local cTipoLim  	:= ""
	Local CRoeda    	:= ""
	Local cAprov    	:= ""
	Local cName     	:= ""
	Local cSavColor 	:= ""
	Local cGrupo		:= ""
	Local cCodLiber 	:= SCR->CR_APROV
	Local cDocto    	:= SCR->CR_NUM
	Local cTipo     	:= SCR->CR_TIPO   
	Local cFilDoc   	:= SCR->CR_FILIAL
	Local dRefer 		:= dDataBase
	Local cPCLib		:= ""
	Local cPCUser		:= ""
	Local lMta097    	:= ExistBlock("MTA097S")	                                                           
	Local lAprov    	:= .F.
	Local lLiberou		:= .F.
	Local lLibOk    	:= .F.                                               
	Local lContinua 	:= .T.
	Local lShowBut  	:= .T.
	Local lOGpaAprv 	:= SuperGetMv("MV_OGPAPRV",.F.,.F.)

	Local nSavOrd  	 	:= IndexOrd()        
	Local nSaldo    	:= 0
	Local nOpc      	:= 0
	Local nSalDif		:= 0
	Local nTotal    	:= 0
	Local nMoeda		:= 1
	Local nX        	:= 1
	Local nRecnoAS400	:= 1

	Local oDlg
	Local oDataRef
	Local oSaldo
	Local oSalDif
	Local oBtn1
	Local oBtn2
	Local oBtn3
	Local oQual     

	Local aSize 		:= {0,0}

	Local lUsaACC 		:= If(FindFunction("WebbConfig"),WebbConfig(),.F.)

	Local lA097PCO		:= ExistBlock("A097PCO")
	Local lLanPCO		:= .T.	//-- Podera ser modificada pelo PE A097PCO

	Local lPrjCni 		:= FindFunction("ValidaCNI") .And. ValidaCNI()
	Local aComa080 		:= {}
	Local cMT097APR		:= Iif(ExistBlock("MT097APR"),.T.,.F.) 
	Local cMT097APR		:= Iif(ExistBlock("MT097APR"),.T.,.F.)

	If SCR->CR_STATUA <> "02"
		Aviso(OEMTOANSI("Atenção"),"O título selecionado não poderá ser aprovado. Por favor, verificar o status",{"Ok"})
	Else

		If SCR->CR_TIPO == "ZZ"

			dbSelectArea("ZZE")
			ZZE->(dbSetOrder(1))
			MsSeek(xFilial("ZZE")+PadR(ALLTRIM(SCR->CR_NUM),TamSX3("ZZE_NUMERO")[1]))

			dbSelectArea("SA2")
			ZZE->(dbSetOrder(1))
			MsSeek(xFilial("SA2")+ZZE->ZZE_FORNEC)

			_aRetSaldo	:= MaSalAlc(_cCodLib,_dRefer)
			_nSaldo 	:= _aRetSaldo[1]
			_CRMoeda 	:= A097Moeda(_aRetSaldo[2])
			_cName  	:= UsrRetName(_cCodUsr)
			_nTotal    	:= xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,_aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)

			Do Case
				Case SAK->AK_TIPO == "D"
				_cTpLim :=OemToAnsi("Diario") // "Diario"
				Case  SAK->AK_TIPO == "S"
				_cTpLim := OemToAnsi("Semanal") //"Semanal"
				Case  SAK->AK_TIPO == "M"
				_cTpLim := OemToAnsi("Mensal") //"Mensal"
				Case  SAK->AK_TIPO == "A"
				_cTpLim := OemToAnsi("Anual") //"Anual"
			EndCase

			_nSalDif := _nSaldo - _nTotal
			If (_nSalDif) < 0
				Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
				_lOk := .F.
			EndIf

			If _lOk
				DEFINE MSDIALOG _oDlgPA FROM 0,0 TO 290,410 TITLE OemToAnsi("Liberação PA") PIXEL

				@ 0.5,01 TO 44,204 LABEL "" OF _oDlgPA PIXEL

				@ 07,06  Say OemToAnsi("Número PA") OF _oDlgPA PIXEL //"Numero do Pedido "
				@ 07,45  MSGET SCR->CR_NUM     When .F. SIZE 28 ,9 OF _oDlgPA PIXEL

				@ 07,120 Say OemToAnsi("Emissão") OF _oDlgPA SIZE 50,9 PIXEL //"Emissao "
				@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45 ,9 OF _oDlgPA PIXEL

				@ 19,06  Say OemToAnsi("Fornecedor") OF _oDlgPA PIXEL //"Fornecedor "
				@ 19,45  MSGET SA2->A2_NOME    When .F. SIZE 155,9 OF _oDlgPA PIXEL

				@ 31,06  Say OemToAnsi("Aprovador") OF _oDlgPA PIXEL SIZE 30,9 //"Aprovador "
				@ 31,45  MSGET _cName           When .F. SIZE 50 ,9 OF _oDlgPA PIXEL

				@ 31,120 Say OemToAnsi("Data de Ref.") SIZE 60,9 OF _oDlgPA PIXEL  //"Data de ref.  "
				@ 31,155 MSGET oDataRef VAR _dRefer When .F. SIZE 45 ,9 OF _oDlgPA PIXEL

				@ 45,01  TO 128,204 LABEL "" OF _oDlgPA PIXEL
				@ 53,06  Say OemToAnsi("Limite min.") +_CRMoeda OF _oDlgPA PIXEL //"Limite min."
				@ 53,42  MSGET SAK->AK_LIMMIN Picture PesqPict('SAK','AK_LIMMIN')When .F. SIZE 60,9 OF _oDlgPA PIXEL RIGHT

				@ 53,103 Say OemToAnsi("Limite max.")+_CRMoeda SIZE 60,9 OF _oDlgPA PIXEL //"Limite max. "
				@ 53,141 MSGET SAK->AK_LIMMAX Picture PesqPict('SAK','AK_LIMMAX')When .F. SIZE 59,1 OF _oDlgPA PIXEL RIGHT

				@ 65,06  Say OemToAnsi("Limite")+_CRMoeda  OF _oDlgPA PIXEL //"Limite  "
				@ 65,42  MSGET SAK->AK_LIMITE Picture PesqPict('SAK','AK_LIMITE')When .F. SIZE 60,9 OF _oDlgPA PIXEL RIGHT

				@ 65,103 Say OemToAnsi("Tipo lim.") OF _oDlgPA PIXEL //"Tipo lim."
				@ 65,141 MSGET _cTpLim When .F. SIZE 59,9 OF _oDlgPA PIXEL CENTERED

				@ 77,06  Say OemToAnsi("Saldo na Data")+_CRMoeda OF _oDlgPA PIXEL //"Saldo na data  "
				@ 77,115 MSGET oSaldo VAR _nSaldo Picture "@E 999,999,999,999.99" When .F. SIZE 85,14 OF _oDlgPA PIXEL RIGHT        

				If SCR->CR_MOEDA == _aRetSaldo[2]
					@ 89,06 Say OemToAnsi("Total do Doc.")+_CRMoeda OF _oDlgPA PIXEL //"Total do documento "
				Else
					@ 89,06 Say OemToAnsi("Total do Doc., convertido em")+_CRMoeda OF _oDlgPA PIXEL //"Total do documento, convertido em "
				EndIf

				@ 89,115 MSGET _nTotal Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF _oDlgPA PIXEL RIGHT

				@ 101,06 Say OemToAnsi("Saldo disponível após liberação") +_CRMoeda SIZE 130,10 OF _oDlgPA PIXEL //"Saldo disponivel apos liberacao  "
				@ 101,115 MSGET oSaldif VAR _nSalDif Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF _oDlgPA PIXEL RIGHT

				@ 113,06 Say OemToAnsi("Observações") SIZE 100,10 OF _oDlgPA PIXEL //"Observa‡äes "
				@ 113,115 MSGET _cObs Picture "@!" SIZE 85,9 OF _oDlgPA PIXEL

				@ 132, 39 BUTTON OemToAnsi("Data Ref.") 	SIZE 40 ,11  FONT _oDlgPA:oFont ACTION fDataRef(oDataRef,oSaldo,oSalDif,@_dRefer,_aRetSaldo,@_cCodLib,@nSaldo,@_CRMoeda,@cName,@_cCodUsr,@_nTotal,@_nSalDif,lAprov) OF _oDlgPA PIXEL
				@ 132, 80 BUTTON OemToAnsi("Liberar") 		SIZE 40 ,11  FONT _oDlgPA:oFont ACTION If(A097ValObs(_cObs),(_nOpc:=2,_oDlgPA:End()),Nil)  OF _oDlgPA PIXEL
				@ 132,121 BUTTON OemToAnsi("Cancelar") 		SIZE 40 ,11  FONT _oDlgPA:oFont ACTION (_nOpc:=1,_oDlgPA:End())  OF _oDlgPA PIXEL
				@ 132,162 BUTTON OemToAnsi("Bloqueia Doc.") SIZE 40 ,11  FONT _oDlgPA:oFont ACTION (_nOpc:=3,_oDlgPA:End())  OF _oDlgPA PIXEL

				ACTIVATE MSDIALOG _oDlgPA CENTERED
			EndIf

			If _nOpc == 2 .Or. _nOpc == 3
				SCR->(dbClearFilter())

				If ( Select("SCR") > 0 )
					SCR->(dbCloseArea())
				EndIf

				dbSelectArea("SCR")
				SCR->(dbSetOrder(1))
				SCR->(dbGoTo(nReg))
				Begin Transaction
					lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,_nTotal,_cCodLib,,ZZE->ZZE_XGRPAP,,,,,_cObs},_dRefer,If(_nOpc==2,4,6))
				End Transaction
			EndIf	
		Else

			If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
				Help(" ",1,"A097LIB")  //Aviso(STR0038,STR0039,{STR0037},2) //"Atencao!"###"Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."###"Voltar"
				lContinua := .F.
			ElseIf lContinua .And. SCR->CR_STATUS$"01"
				Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"Ok"}) 
				lContinua := .F.
			EndIf

			If lContinua

				//----------------------------------------------------------------------------------------------------------------------------------------
				// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
				//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
				/*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta o Header com os titulos do TWBrowse             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SX3")
				dbSetOrder(2)
				For nx	:= 1 to Len(aCposObrig)
					If MsSeek(aCposObrig[nx])
						AADD(aHeadCpos,AllTrim(X3Titulo()))
						
						AADD(aHeadSize,	CalcFieldSize(SX3->X3_TIPO	,;
										SX3->X3_TAMANHO				,;
										SX3->X3_DECIMAL				,;
										SX3->X3_PICTURE				,;
										X3Titulo()					))
						
						AADD(aCampos,{	SX3->X3_CAMPO				,;
										SX3->X3_TIPO				,;
										SX3->X3_CONTEXT				,;
										SX3->X3_PICTURE				})
					Else
						AADD(aHeadCpos,"Divergencia") // 
						AADD(aCampos,{" ","C"})
					EndIf
				Next
				*/
				For nx	:= 1 to Len(aCposObrig)
					If MsSeek(aCposObrig[nx])
						AADD(aHeadCpos,AllTrim(X3Titulo()))
						
						AADD(aHeadSize,	CalcFieldSize(GetSX3Cache(aCposObrig[nx],"X3_TIPO"))	,;
										GetSX3Cache(aCposObrig[nx],"X3_TAMANHO" )				,;
										GetSX3Cache(aCposObrig[nx],"X3_DECIMAL" )				,;
										GetSX3Cache(aCposObrig[nx],"X3_PICTURE" )				,;
										X3Titulo()												)
						
						AADD(aCampos,{	GetSX3Cache(aCposObrig[nx],"X3_CAMPO"   )				,;
										GetSX3Cache(aCposObrig[nx],"X3_TIPO"    )				,;
										GetSX3Cache(aCposObrig[nx],"X3_CONTEXT" )				,;
										GetSX3Cache(aCposObrig[nx],"X3_PICTURE" )				})
						
					Else
						AADD(aHeadCpos,"Divergencia") // 
						AADD(aCampos,{" ","C"})
					EndIf
				Next
				
				//{ Fim } --------------------------------------------------------------------------------------------------------------------------------				
				
				dbSelectArea("SAL")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa as variaveis utilizadas no Display.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aRetSaldo := MaSalAlc(cCodLiber,dRefer)
				nSaldo 	  := aRetSaldo[1]
				CRoeda 	  := A097Moeda(aRetSaldo[2])
				cName  	  := UsrRetName(ca097User)
				nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)

				Do Case
					Case SAK->AK_TIPO == "D"
					cTipoLim :=OemToAnsi("Diario") // 
					Case  SAK->AK_TIPO == "S"
					cTipoLim := OemToAnsi("Semanal") //
					Case  SAK->AK_TIPO == "M"
					cTipoLim := OemToAnsi("Mensal") //
					Case  SAK->AK_TIPO == "A"
					cTipoLim := OemToAnsi("Anual") //
				EndCase

				Do Case
					Case SCR->CR_TIPO == "NF"

					dbSelectArea("SF1")
					dbSetOrder(1)
					MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
					cGrupo := SF1->F1_APROV

					dbSelectArea("SD1")
					dbSetOrder(1)
					MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

					While ( !Eof().And. SD1->D1_FILIAL == xFilial("SD1") .And. SD1->D1_DOC     == SF1->F1_DOC     .And. ;
					SD1->D1_SERIE  == SF1->F1_SERIE  .And. SD1->D1_FORNECE == SF1->F1_FORNECE .And. SD1->D1_LOJA == SF1->F1_LOJA )

						Aadd(aArrayNF,Array(Len(aCampos)))

						If !Empty(SD1->D1_PEDIDO)
							dbSelectArea("SC7")
							dbSetOrder(1)
							MsSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
						EndIf

						For nX := 1 to Len(aCampos)

							If Substr(aCampos[nX][1],1,2) == "D1"
								If aCampos[nX][2] == "N"
									aArrayNF[Len(aArrayNF)][nX] := Transform(SD1->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SD1",aCampos[nX][1]))
								Else
									aArrayNF[Len(aArrayNF)][nX] := SD1->(FieldGet(FieldPos(aCampos[nX][1])))
								Endif
							Elseif Substr(aCampos[nX][1],1,2) == "C7"
								If !Empty(SD1->D1_PEDIDO)
									If aCampos[nX][2] == "N"
										aArrayNF[Len(aArrayNF)][nX] := Transform(SC7->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
									Else
										aArrayNF[Len(aArrayNF)][nX] := SC7->(FieldGet(FieldPos(aCampos[nX][1])))
									Endif
								Else
									aArrayNF[Len(aArrayNF)][nX] := " "
								EndIf
							Else
								If !Empty(SD1->D1_PEDIDO)
									If SD1->D1_QUANT <> SC7->C7_QUANT .And. SD1->D1_VUNIT == SC7->C7_PRECO
										aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Quantidade") //
									ElseIf SD1->D1_QUANT <> SC7->C7_QUANT .And. SD1->D1_VUNIT <> SC7->C7_PRECO
										aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Qtde/Preco") //
									ElseIf SD1->D1_QUANT == SC7->C7_QUANT .And. SD1->D1_VUNIT <> SC7->C7_PRECO
										aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Preco     ") //
									Else
										aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("OK        ") //
									Endif
								Else
									aArrayNF[Len(aArrayNF)][nX] := OemToAnsi("Sem Pedido") //
								EndIf
							EndIf

						Next nX

						SD1->( dbSkip() )
					EndDo

					dbSelectArea("SA2")
					dbSetOrder(1)
					MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)

					dbSelectArea("SAL")
					dbSetOrder(3)
					MsSeek(xFilial("SAL")+SF1->F1_APROV+SAK->AK_COD)

					If Eof()    
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
						//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
						//| de destino não fizer parte do Grupo de Aprovação.                           |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
						If !Empty(SCR->(FieldPos("CR_USERORI")))
							dbSeek(xFilial("SAL")+SF1->F1_APROV+SCR->CR_APRORI) 
						EndIf
					EndIf

					If lOGpaAprv
						If Eof()
							Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+SF1->F1_APROV+CRLF+"Verifique a configuração do parâmetro: MV_OGPAPRV caso não queira tornar obrigatório a existência do aprovador no grupo de aprovação.",{"Ok"}) // +STR0090
							lContinua := .F.
						EndIf
					EndIf 

					Case SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"

					dbSelectArea("SC7")
					dbSetOrder(1)
					MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
					cGrupo := SC7->C7_APROV

					dbSelectArea("SA2")
					dbSetOrder(1)
					MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

					dbSelectArea("SAL")       
					dbSetOrder(3)
					MsSeek(xFilial("SAL")+SC7->C7_APROV+SAK->AK_COD)    

					If Eof()    
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
						//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
						//| de destino não fizer parte do Grupo de Aprovação.                           |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
						If !Empty(SCR->(FieldPos("CR_USERORI")))
							dbSeek(xFilial("SAL")+SC7->C7_APROV+SCR->CR_APRORI) 
						EndIf
					EndIf

					If lOGpaAprv
						If Eof()
							Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+SC7->C7_APROV+CRLF+"Verifique a configuração do parâmetro: MV_OGPAPRV caso não queira tornar obrigatório a existência do aprovador no grupo de aprovação.",{"Ok"}) //
							lContinua := .F.	    
						EndIf              
					Endif

					Case SCR->CR_TIPO == "CP"

					dbSelectArea("SC3")
					dbSetOrder(1)
					MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)))
					cGrupo := SC3->C3_APROV

					dbSelectArea("SA2")
					dbSetOrder(1)
					MsSeek(xFilial("SA2")+SC3->C3_FORNECE+SC3->C3_LOJA)

					dbSelectArea("SAL")
					dbSetOrder(3)
					MsSeek(xFilial("SAL")+SC3->C3_APROV+SAK->AK_COD)

					If Eof()    
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
						//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
						//| de destino não fizer parte do Grupo de Aprovação.                           |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
						If !Empty(SCR->(FieldPos("CR_USERORI")))
							dbSeek(xFilial("SAL")+SC3->C3_APROV+SCR->CR_APRORI) 
						EndIf
					EndIf

					If lOGpaAprv
						If Eof()
							Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+SC3->C3_APROV+CRLF+"Verifique a configuração do parâmetro: MV_OGPAPRV caso não queira tornar obrigatório a existência do aprovador no grupo de aprovação.",{"Ok"}) // +STR0090
							lContinua := .F.	    	    
						EndIf
					EndIf

					Case SCR->CR_TIPO == "MD"

					dbSelectArea("CND")
					dbSetOrder(4)
					MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
					cGrupo := CND->CND_APROV

					dbSelectArea("SA2")
					dbSetOrder(1)
					MsSeek(xFilial("SA2")+CND->CND_FORNEC+CND->CND_LJFORN)

					dbSelectArea("SAL")                      
					dbSetOrder(3)
					MsSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)

					If Eof()    
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
						//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
						//| de destino não fizer parte do Grupo de Aprovação.                           |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
						If !Empty(SCR->(FieldPos("CR_USERORI")))
							dbSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI) 
						EndIf
					EndIf

					If lOGpaAprv
						If Eof()
							Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+cGrupo+CRLF+"Verifique a configuração do parâmetro: MV_OGPAPRV caso não queira tornar obrigatório a existência do aprovador no grupo de aprovação.",{"Ok"}) // +STR0090
							lContinua := .F.	    	    
						EndIf
					EndIf

					Case SCR->CR_TIPO == "CT"

					dbSelectArea("CN9")
					dbSetOrder(1)
					MsSeek(xFilial("CN9")+Substr(SCR->CR_NUM,1,len(CN9->CN9_NUMERO)))
					cGrupo := CN9->CN9_APROV               

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Obtem o primeiro fornecedor relacionado ao contrato e na liberacao sera 		³
					//³apresentado o primeiro fornecedor incluido no contrato 						³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
					dbSelectArea("CNC")
					dbSetOrder(1)
					MsSeek(xFilial("CNC")+CN9->CN9_NUMERO)

					dbSelectArea("SA2")
					dbSetOrder(1)
					MsSeek(xFilial("SA2")+CNC->CNC_CODIGO+CNC->CNC_LOJA)

					dbSelectArea("SAL")                      
					dbSetOrder(3)
					MsSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)

					If Eof()    
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
						//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
						//| de destino não fizer parte do Grupo de Aprovação.                           |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
						If !Empty(SCR->(FieldPos("CR_USERORI")))
							dbSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI) 
						EndIf
					EndIf

					If lOGpaAprv
						If Eof()
							Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+cGrupo+CRLF+"Verifique a configuração do parâmetro: MV_OGPAPRV caso não queira tornar obrigatório a existência do aprovador no grupo de aprovação.",{"Ok"}) // +STR0090
							lContinua := .F.	    	    
						EndIf
					EndIf 
				EndCase

				If SAL->AL_LIBAPR != "A"
					lAprov := .T.
					cAprov := OemToAnsi("VISTO / LIVRE") // 
				EndIf
				nSalDif := nSaldo - IIF(lAprov,0,nTotal)
				If (nSalDif) < 0
					Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
					lContinua := .F.
				EndIf
			EndIf

			If lContinua

				If lA097PCO
					lLanPCO := ExecBlock("A097PCO",.F.,.F.,{SC7->C7_NUM,cName,lLanPCO})
				Endif

				If lLanPCO
					PcoIniLan("000055")
				EndIf

				If SCR->CR_TIPO <> "NF"
					aSize := {290,410}

					DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[1],aSize[2] TITLE OemToAnsi("Liberacao do PC") PIXEL  //
					@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL

					@ 07,06  Say OemToAnsi("No. do Pedido ") OF oDlg PIXEL //
					If SCR->CR_TIPO == "CT"
						@ 07,45  MSGET SCR->CR_NUM     When .F. SIZE 65 ,9 OF oDlg PIXEL
					Else
						@ 07,45  MSGET SCR->CR_NUM     When .F. SIZE 28 ,9 OF oDlg PIXEL
					EndIf

					@ 07,120 Say OemToAnsi("Emissao ") OF oDlg SIZE 50,9 PIXEL //
					@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45 ,9 OF oDlg PIXEL

					@ 19,06  Say OemToAnsi("Fornecedor ") OF oDlg PIXEL //
					@ 19,45  MSGET SA2->A2_NOME    When .F. SIZE 155,9 OF oDlg PIXEL

					@ 31,06  Say OemToAnsi("Aprovador ") OF oDlg PIXEL SIZE 30,9 
					@ 31,45  MSGET cName           When .F. SIZE 50 ,9 OF oDlg PIXEL

					@ 31,120 Say OemToAnsi("Data de ref.  ") SIZE 60,9 OF oDlg PIXEL  //
					@ 31,155 MSGET oDataRef VAR dRefer When .F. SIZE 45 ,9 OF oDlg PIXEL

					@ 45,01  TO 128,204 LABEL "" OF oDlg PIXEL
					@ 53,06  Say OemToAnsi("Limite min.") +CRoeda OF oDlg PIXEL //
					@ 53,42  MSGET SAK->AK_LIMMIN Picture PesqPict('SAK','AK_LIMMIN')When .F. SIZE 60,9 OF oDlg PIXEL RIGHT

					@ 53,103 Say OemToAnsi("Limite max. ")+CRoeda SIZE 60,9 OF oDlg PIXEL //
					@ 53,141 MSGET SAK->AK_LIMMAX Picture PesqPict('SAK','AK_LIMMAX')When .F. SIZE 59,1 OF oDlg PIXEL RIGHT

					@ 65,06  Say OemToAnsi("Limite  ")+CRoeda  OF oDlg PIXEL //
					@ 65,42  MSGET SAK->AK_LIMITE Picture PesqPict('SAK','AK_LIMITE')When .F. SIZE 60,9 OF oDlg PIXEL RIGHT

					@ 65,103 Say OemToAnsi("Tipo lim.") OF oDlg PIXEL //
					@ 65,141 MSGET cTipoLim When .F. SIZE 59,9 OF oDlg PIXEL CENTERED

					@ 77,06  Say OemToAnsi("Saldo na data  ")+CRoeda OF oDlg PIXEL //
					@ 77,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999,999.99" When .F. SIZE 85,14 OF oDlg PIXEL RIGHT

					If lAprov .Or. SCR->CR_MOEDA == aRetSaldo[2]
						@ 89,06 Say OemToAnsi("Total do documento ")+CRoeda OF oDlg PIXEL //
					Else
						@ 89,06 Say OemToAnsi("Total do documento, convertido em ")+CRoeda OF oDlg PIXEL //
					EndIf
					If lAprov
						@ 89,115 MSGET cAprov Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
					Else
						@ 89,115 MSGET nTotal Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
					EndIf

					@ 101,06 Say OemToAnsi("Saldo disponivel apos liberacao  ") +CRoeda SIZE 130,10 OF oDlg PIXEL //
					@ 101,115 MSGET oSaldif VAR nSalDif Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT

					@ 113,06 Say OemToAnsi("Observações ") SIZE 100,10 OF oDlg PIXEL //
					@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL

					If ExistBlock("MT097DTR")
						lShowBut := IIf(Valtype(lShowBut:=ExecBlock("MT097DTR",.F.,.F.,{SCR->CR_TIPO}))=='L',lShowBut,.T.) 
					Endif

					If lShowBut
						@ 132, 39 BUTTON OemToAnsi("Data de Ref.") SIZE 40 ,11  FONT oDlg:oFont ACTION A097Data(oDataRef,oSaldo,oSalDif,@dRefer,aRetSaldo,@cCodLiber,@nSaldo,@cRoeda,@cName,@ca097User,@nTotal,@nSalDif,lAprov) OF oDlg PIXEL
					Endif	

					@ 132, 80 BUTTON OemToAnsi("Liberar") 			SIZE 40 ,11  FONT oDlg:oFont ACTION If(ValidPcoLan(lLanPCO) .And. A097ValObs(cObs),(nOpc:=2,oDlg:End()),Nil)  OF oDlg PIXEL
					@ 132,121 BUTTON OemToAnsi("Cancelar") 			SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
					@ 132,162 BUTTON OemToAnsi("Bloqueia Docto.") 	SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL


					ACTIVATE MSDIALOG oDlg CENTERED
				Else
					aSize := {400,780}

					DEFINE MSDIALOG oDlg FROM 000,000 TO aSize[1],aSize[2] TITLE OemToAnsi("Liberacao do PC") PIXEL  //

					@ 001,001  TO 050,425 LABEL "" OF oDlg PIXEL

					@ 007,006 Say OemToAnsi("No. do Pedido ") OF oDlg PIXEL SIZE 080,009  //
					@ 007,045 MSGET SCR->CR_NUM        When .F. SIZE 065,009 OF oDlg PIXEL

					@ 007,130 Say OemToAnsi("Emissao ") OF oDlg PIXEL SIZE 050,009  //
					@ 007,155 MSGET SCR->CR_EMISSAO    When .F. SIZE 045,009 OF oDlg PIXEL

					@ 007,216 Say OemToAnsi("Aprovador ") OF oDlg PIXEL SIZE 030,009  //
					@ 007,270 MSGET cName              When .F. SIZE 050,009 OF oDlg PIXEL RIGHT

					@ 021,006 Say OemToAnsi("Fonecedor ") OF oDlg PIXEL SIZE 030,009  //
					@ 021,045 MSGET SA2->A2_NOME       When .F. SIZE 155,009 OF oDlg PIXEL

					@ 021,216 Say OemToAnsi("Data de ref.  ") OF oDlg PIXEL SIZE 060,009  //
					@ 021,270 MSGET oDataRef VAR dRefer When .F. SIZE 050,009 OF oDlg PIXEL RIGHT

					@ 035,006 Say OemToAnsi("Observações ") OF oDlg PIXEL SIZE 100,010  //
					@ 035,115 MSGET cObs           Picture "@!" SIZE 085,009 OF oDlg PIXEL

					@ 035,216 Say OemToAnsi("Liberacao do docto") OF oDlg PIXEL SIZE 100,010  //
					@ 035,270 MSGET OemToAnsi("Visto / Livre") When .F. SIZE 050,009 OF oDlg PIXEL RIGHT

					oQual:= TWBrowse():New( 051,001,389,133,,aHeadCpos,aHeadSize,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
					oQual:SetArray(aArrayNF)
					oQual:bLine := { || aArrayNF[oQual:nAT] }

					If ExistBlock("MT097DTR")
						lShowBut := IIf(Valtype(lShowBut:=ExecBlock("MT097DTR",.F.,.F.,{SCR->CR_TIPO}))=='L',lShowBut,.T.) 
					Endif

					If lShowBut		
						@ 187,217 BUTTON OemToAnsi("Data de Ref.") SIZE 040,011  FONT oDlg:oFont ACTION A097Data(oDataRef,oSaldo,oSalDif,@dRefer,aRetSaldo,@cCodLiber,@nSaldo,@cRoeda,@cName,@ca097User,@nTotal,@nSalDif,lAprov) OF oDlg PIXEL
					Endif

					@ 187,258 BUTTON OemToAnsi("Liberar") 			SIZE 040,011 FONT oDlg:oFont ACTION If(ValidPcoLan(lLanPCO) .And. A097ValObs(cObs),(nOpc:=2,oDlg:End()),Nil)  OF oDlg PIXEL
					@ 187,299 BUTTON OemToAnsi("Cancelar") 			SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End()) OF oDlg PIXEL
					@ 187,340 BUTTON OemToAnsi("Bloqueia Docto.") 	SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL

					ACTIVATE MSDIALOG oDlg CENTERED
				EndIf

				If nOpc == 2 .Or. nOpc == 3
					SCR->(dbClearFilter())

					If ( Select("SCR") > 0 )
						SCR->(dbCloseArea())
					EndIf

					dbSelectArea("SCR")
					SCR->(dbSetOrder(1))
					SCR->(dbGoTo(nReg))

					#IFDEF TOP
					If TcSrvType() == "AS/400"
						dbSelectArea("SCR") 
						Do While !Eof()
							SCR->(dbSkip())
							If  MV_PAR01 == 1 .And. ( SCR->CR_FILIAL == xFilial("SCR") .And. SCR->CR_USER == ca097User .And. SCR->CR_STATUS == "02" )
								aArea		:= GetArea()
								nRecnoAS400 := SCR->(Recno())
								SCR->(dbSkip()) 
							EndIf
						EndDo
						SCR->(dbGoTo(nReg))
					EndIf	
					#ENDIF

					If ( SCR->CR_TIPO == "NF" )
						lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)),SCR->CR_TIPO)
					ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
						lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)),SCR->CR_TIPO)
					ElseIf SCR->CR_TIPO == "CP"
						lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC3->C3_NUM)),SCR->CR_TIPO)
					ElseIf SCR->CR_TIPO == "MD"
						lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(CND->CND_NUMMED)),SCR->CR_TIPO)
					ElseIf SCR->CR_TIPO == "CT"
						If !FindFunction("CN100CtrVg")
							Aviso("Atenção!","Necessário actualizar CNTA100.prw para prosseguir.",{"OK"})
							lLibOk := .F.
						Else
							lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(CN9->CN9_NUMERO)),SCR->CR_TIPO)
						EndIf
					EndIf
					If lLibOk
						Begin Transaction
							If lMta097 .And. nOpc == 2
								If ExecBlock("MTA097",.F.,.F.)
									lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
								EndIf
							Else
								lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
							EndIf

							//-- Apenas o PE A097PCO pode alterar o valor de lA097PCO
							//-- Se ele nao existir ela devera seguir o valor da liberacao (lLiberou)
							If !lA097PCO
								lLanPCO := lLiberou
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Envia e-mail ao comprador ref. Liberacao do pedido para compra- 034³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
							If lLiberou
								cPCLib  := SC7->C7_NUM
								cPCUser := SC7->C7_USER	
								MEnviaMail("034",{cPCLib,SCR->CR_TIPO},cPCUser) 				
							Endif
							If lLiberou .or. lLanPCO
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If lLanPCO
									PcoDetLan("000055","02","MATA097")
								EndIf

								If lLiberou .and. (SCR->CR_TIPO == "NF")
									dbSelectArea("SF1")
									Reclock("SF1",.F.)
									SF1->F1_STATUS := If(SF1->F1_STATUS=="B"," ",SF1->F1_STATUS)
									MsUnlock()
								ElseIf (SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE")
									If lLiberou .and. SuperGetMv("MV_EASY")=="S" .AND. SC7->(FieldPos("C7_PO_EIC"))<>0 .And. !Empty(SC7->C7_PO_EIC)
										If SW2->(MsSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. SW2->(FieldPos("W2_CONAPRO"))<>0 .AND. !Empty(SW2->W2_CONAPRO)
											Reclock("SW2",.F.)
											SW2->W2_CONAPRO := "L"
											MsUnlock()
										EndIf
									EndIf
									dbSelectArea("SC7")
									cPCLib := SC7->C7_NUM
									cPCUser:= SC7->C7_USER
									While !SC7->(Eof()) .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
										If lLiberou
											Reclock("SC7",.F.)
											SC7->C7_CONAPRO := "L"
											MsUnlock()
											
											//----------------------------------------------------------------------------
											// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
											//----------------------------------------------------------------- { Inicio }
											//If ExistBlock("MT097APR")
											
											If cMT097APR
												ExecBlock("MT097APR",.F.,.F.)      
											EndIf
											
											//{ Fim } -------------------------------------------------------------------
											
										EndIf
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If lLanPCO
											PcoDetLan("000055","01","MATA097")
										EndIf
										SC7->(dbSkip())
									EndDo

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Integracao ACC envia aprovacao do pedido            ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									SC7->(dbSkip(-1))
									If lLiberou .and. lUsaACC .And. !Empty(SC7->C7_ACCNUM)
										If IsBlind()
											Webb533(SC7->C7_NUM)
										Else
											MsgRun("Aguarde, comunicando aprovação ao portal...","Portal ACC",{|| Webb533(SC7->C7_NUM)})	// ## 
										EndIf
									EndIf

									If lPrjCni
										BeginSQL Alias "SC1TMP"
											SELECT C1_NUM, C1_ITEM
											FROM %Table:SC1% SC1
											WHERE C1_FILIAL = %xFilial:SC1% AND C1_PEDIDO = %Exp:SC7->C7_NUM% AND SC1.%NotDel%
										EndSQL

										SC1TMP->(dbGoTop())

										If !Empty(SC7->C7_NUMSC) .And. !Empty(SC7->C7_ITEMSC)
											While !SC1TMP->(EOF())
												aComa080 := {SC1TMP->C1_NUM,SC1TMP->C1_ITEM,SC1TMP->C1_FORNECE,SC1TMP->C1_LOJA}
												COMA080("COK",aComa080,"COK_DTHLIB","COK_ULIB",/*lEstorno*/,/*cUser*/,"COK_DOCLIB",SC7->C7_NUM)
												//									COMA080(SC1TMP->C1_NUM,SC1TMP->C1_ITEM,"COI_DTHLIB","COI_ULIB",/*lEstorno*/,/*cUser*/,"COI_DOCLIB",SC7->C7_NUM)
												SC1TMP->(dbSkip())
											EndDo
										Else
											While !SC1TMP->(EOF())
												SC1->(dbSetOrder(8))//C1_FILIAL+C1_CODED+C1_NUMPR+C1_PRODUTO+C1_NUM+C1_ITEM
												SC1->(dbSeek(xFilial() + SC7->C7_CODED + SC7->C7_NUMPR + SC7->C7_PRODUTO )) //todas as SCs de todos os produtos do pedido

												While SC1->(!EOF())
													aComa080 := {SC1TMP->C1_NUM,SC1TMP->C1_ITEM,SC1TMP->C1_FORNECE,SC1TMP->C1_LOJA}
													COMA080("COK",aComa080,"COK_DTHLIB","COK_ULIB",/*lEstorno*/,/*cUser*/,"COK_DOCLIB",SC7->C7_NUM)
													//										COMA080(SC1->C1_NUM,SC1->C1_ITEM,"COI_DTHLIB","COI_ULIB",/*lEstorno*/,/*cUser*/,"COI_DOCLIB",SC7->C7_NUM)
													SC1->(dbSkip())
												EndDo

												SC1TMP->(dbSkip())
											EndDo
										Endif
										SC1TMP->(dbCloseArea())
									EndIf

								ElseIf lLiberou .and. SCR->CR_TIPO == "CP"
									dbSelectArea("SC3")
									While !SC3->(Eof()) .And. SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) == xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM))
										Reclock("SC3",.F.)
										SC3->C3_CONAPRO := "L"
										MsUnlock()
										
										//----------------------------------------------------------------------------
										// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
										//----------------------------------------------------------------- { Inicio }
										//If ExistBlock("MT097APR")
										If cMT097APR
											ExecBlock("MT097APR",.F.,.F.)
										EndIf
										//{ Fim } -------------------------------------------------------------------
										
										dbSkip()
									EndDo
								ElseIf lLiberou .and. SCR->CR_TIPO == "MD"
									dbSelectArea("CND")
									dbSetOrder(4)
									If CND->(dbSeek(xFilial("CND")+SCR->CR_NUM))
										Reclock("CND",.F.)
										CND->CND_ALCAPR := "L"
										MsUnlock()
										If ExistBlock("MT097APR")
											ExecBlock("MT097APR",.F.,.F.)
										EndIf
									EndIf
								ElseIf lLiberou .and. SCR->CR_TIPO == "CT"
									dbSelectArea("CN9")
									dbSetOrder(1)
									If dbSeek(xFilial("CN9")+SCR->CR_NUM)
										Reclock("CN9",.F.)
										CN9->CN9_SITUAC := "05" //Vigente 
										CN9->CN9_DTASSI := dDataBase
										MsUnlock()
										If ExistBlock("MT097APR")
											ExecBlock("MT097APR",.F.,.F.)
										EndIf
									EndIf
								EndIf
							EndIf
						End Transaction

						If lLanPCO
							//-- Finaliza a gravacao dos lancamentos do SIGAPCO
							PcoFinLan("000055")
						EndIf

					Else
						Help(" ",1,"A097LOCK")
					Endif
					If cTipo == "NF"
						SF1->(MsUnlockAll())
					ElseIf cTipo == "PC" .Or. cTipo == "AE"
						SC7->(MsUnlockAll())
					ElseIf cTipo == "CP"
						SC3->(MsUnlockAll())
					ElseIf cTipo == "MD"
						CND->(MsUnlockAll())
					EndIf
				EndIf
				dbSelectArea("SCR")
				dbSetOrder(1)
				If lLanPCO
					PcoFreeBlq("000055")
				EndIf
			EndIf
		EndIf	
	EndIf
	RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDataRef  ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para alterar a data de referencia.                    ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fDataRef(oDataRef,oSaldo,oSalDif,dRefer ,aRetSaldo ,cCodLiber,nSaldo,cRoeda,cName,ca097User,nTotal,nSalDif,lAprov)

	Local dNewData:= dRefer
	Local lCancel :=.T.
	Local oDlg
	Local oDtNewRef

	DEFINE MSDIALOG oDlg TITLE "Data Referencia" From 145,0 To 270,400 OF oMainWnd PIXEL
	@ 10,15 TO 40,100 LABEL "Data Ref" OF oDlg PIXEL	
	@ 20,20 MSGET oDtNewRef Var dNewData Picture "@E" VALID A097VldRef(@oDlg,@oDtNewRef,@dNewData,dRefer,@lCancel) OF oDlg PIXEL 
	DEFINE SBUTTON FROM 50,131 TYPE 1 ACTION (lCancel:=.F.,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 50,158 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg

	If !lCancel
		dRefer   := dNewData
		aRetSaldo:= MaSalAlc(cCodLiber,dRefer)
		nSaldo 	 := aRetSaldo[1]
		CRoeda 	 := A097Moeda(aRetSaldo[2])
		cName  	 := UsrRetName(ca097User)
		nTotal   := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
		nSalDif  := nSaldo - IIF(lAprov,0,nTotal)

		If oDataRef <> Nil
			oDataRef:Refresh()
		EndIf

		If oSaldo <> Nil 
			oSaldo:Refresh()
		EndIf  

		If oSalDif <>Nil
			oSalDif:Refresh()
		EndIf

	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fConDoc   ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para consultar documento posicionado.                 ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fConDoc(cAlias,nReg,nOpcx)

	Local nConta		:= 1
	Local _aArea		:= GetArea()
	Local cSavAlias		:= Alias()
	Local cSavOrd		:= IndexOrd()
	Local cSavReg		:= RecNo()

	PRIVATE nTipoPed	:= 1
	PRIVATE l120Auto	:= .F.

	Private aMoedas		:= {}

	If SCR->CR_TIPO == "ZZ"
		
		//----------------------------------------------------------------------------------------------------------------------------------------
		// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
		//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
		/*
		SX6->( Dbsetorder(1) )
		While .T.
			If SX6->( Dbseek(xFilial("SX6")+"MV_MOEDA"+Alltrim(Str(nConta,2))) )
				Aadd(aMoedas,SX6->X6_CONTEUD);	nConta++
			Else
				Exit
			EndIf
		EndDo
		*/
		aMoedas := StrTokArr(GvGetMoedas(),";")
		nConta 	:= Len(aMoedas)
		
		//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

		dbSelectArea("ZZE")
		ZZE->(dbSetOrder(1))
		MsSeek(xFilial("ZZE")+PadR(ALLTRIM(SCR->CR_NUM),TamSX3("ZZE_NUMERO")[1]))
		cFilAnt	:= ZZE->ZZE_FILIAL
		U_VerPA()
	Else
		If SCR->CR_TIPO == "NF"
			dbSelectArea("SF1")
			dbSetOrder(1)
			If MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
				Pergunte("MTA103",.F.)
				Mata103(NIL,NIL,nOpcx)
			EndIf
		ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
			dbSelectArea("SC7")
			dbSetOrder(1)
			If MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
				Mata120(NIL,NIL,NIL,nOpcx)
			EndIf
		ElseIf SCR->CR_TIPO == "CP"
			dbSelectArea("SC3")
			dbSetOrder(1)
			If MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)))
				Mata125(NIL,NIL,nOpcx)
			EndIf
		ElseIf SCR->CR_TIPO == "MD"
			dbSelectArea("CND")
			dbSetOrder(4)
			If MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
				PRIVATE lAuto := .F.
				CN130Manut("CND",CND->(Recno()),nOpcx)
			EndIf
		ElseIf SCR->CR_TIPO = "CT"	//Documento do Tipo Contrato
			DbSelectArea("CN9")
			DbSetOrder(1)
			If MsSeek(xFilial("CN9")+SCR->CR_NUM)
				CN100Manut("CN9",CN9->(Recno()),nOpcx,.T.)
			EndIf
		EndIf

		Pergunte("MTA097",.F.)
		dbSelectArea(cSavAlias)
		dbSetOrder(cSavOrd)
		dbGoto(cSavReg)

	EndIf

	RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fEstorno  ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para estornar documento posicionado.                  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fEstorno(cAlias,nReg,nOpcx)

	Local _aArea	:= GetArea()
	Local _aAreaZZE	:= ZZE->(GetArea())
	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSCR	:= SCR->(GetArea())

	Local cNumero	:= ""
	Local cChave    := ""
	Local cAlias    := "SC7"
	Local cTipo     := SCR->CR_TIPO
	Local cSituac	:= ""
	Local cRevisa	:= ""

	Local lEstorna	:= .T.
	Local lContinua := .T.
	Local lLibOk    := .F.

	Local nOpc      := 0
	Local nReg		:= SCR->(Recno())

	If SCR->CR_TIPO == "NF"
		dbSelectArea("SF1")
		cAlias := "SF1"
		cChave := Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		If MsSeek(xFilial(cAlias)+cChave)
			If SF1->F1_STATUS $ "AB"
				Help(" ",1,"NOALTERA")
				lContinua := .F.
			EndIf
		EndIf
	ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
		dbSelectArea("SC7")
		cAlias := "SC7"
		cChave := Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
		MsSeek(xFilial("SC7")+cChave)
		While xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)) = SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) .And. !Eof()
			If C7_QUJE > 0
				Help(" ",1,"NOALTERA")
				lContinua := .F.
				dbSkip()
			EndIf
			dbSkip()
		EndDo
	ElseIf SCR->CR_TIPO == "CP"
		dbSelectArea("SC3")
		cAlias := "SC3"
		cChave := Substr(SCR->CR_NUM,1,len(SC3->C3_NUM))
		MsSeek(xFilial(cAlias)+cChave)
		While xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)) = SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) .And. !Eof()
			If C3_QUJE > 0
				Help(" ",1,"NOALTERA")
				lContinua := .F.
				dbSkip()
			EndIf
			dbSkip()
		EndDo
	ElseIf SCR->CR_TIPO == "MD"
		dbSelectArea("CND")
		dbSetOrder(4)
		cAlias := "CND"
		cChave := Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED))
		If dbSeek(xFilial(cAlias)+cChave)
			If !Empty(CND->CND_DTFIM)
				Help(" ",1,"NOALTERA")
				lContinua := .F.
			EndIf
		EndIf
	EndIf

	If lContinua .And. SCR->CR_STATUS$"01"
		Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"Ok"})
		lContinua := .F.
	EndIf

	If Aviso("Atencao!","Ao confirmar este processo todas aprovações pendentes do aprovador serão transferidas ao aprovador superior. Confirma a Transferência ?",{"Cancelar","Confirma"},2) == 2 
		dbSelectArea(cAlias)
		MsSeek(xFilial(cAlias)+cChave)
		cNumero := cChave
		SCR->(dbClearFilter())
		SCR->(dbGoTo(nReg))

		If cTipo == "CT"
			cNumero := SCR->CR_NUMERO
		EndIf

		PcoIniLan("000055")
		Begin Transaction
			If cTipo == "ZZ"
				dbSelectArea("ZZE")
				ZZE->(dbSetOrder(1))
				MsSeek(xFilial("ZZE")+PadR(ALLTRIM(SCR->CR_NUM),TamSX3("ZZE_NUMERO")[1]))
				lEstorna := MaAlcDoc({SCR->CR_NUM,"ZZ",0,SCR->CR_LIBAPRO,,ZZE->ZZE_XGRPAP},ZZE->ZZE_DATA,5)
			Else
				PcoDetLan("000055","02","MATA097",.T.)
				If cTipo == "NF"
					lEstorna := MaAlcDoc({SCR->CR_NUM,"NF",0,SCR->CR_LIBAPRO,,SF1->F1_APROV},SF1->F1_EMISSAO,5)
					dbSelectArea("SF1")
					Reclock("SF1",.F.)
					SF1->F1_STATUS := "B"
					MsUnlock()
				ElseIf cTipo == "PC" .Or. cTipo == "AE"
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,SC7->C7_APROV},SC7->C7_EMISSAO,5)
					dbSelectArea("SC7")
					MsSeek(xFilial("SC7")+cNumero)
					If SuperGetMv("MV_EASY")=="S" .AND. SC7->(FieldPos("C7_PO_EIC"))<>0 .And. !EMPTY(SC7->C7_PO_EIC)
						If SW2->(MsSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. SW2->(FieldPos("W2_CONAPRO"))<>0 .AND. !Empty(SW2->W2_CONAPRO)
							Reclock("SW2",.F.)
							SW2->W2_CONAPRO := "B"
							MsUnlock()
						EndIf
					EndIf
					dbSelectArea("SC7") 

					While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+cNumero
						Reclock("SC7",.F.)
						SC7->C7_CONAPRO := "B"
						MsUnlock()
						PcoDetLan("000055","01","MATA097",.T.)
						dbSkip()
					EndDo
				ElseIf cTipo == "CP"
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,SC3->C3_APROV},SC3->C3_EMISSAO,5)
					dbSelectArea("SC3")
					MsSeek(xFilial("SC3")+cNumero)
					While !Eof() .And. SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) == xFilial("SC3")+cNumero
						Reclock("SC3",.F.)
						SC3->C3_CONAPRO := "B"
						MsUnlock()
						dbSkip()
					EndDo
				ElseIf cTipo == "MD"
					lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,CND->CND_APROV},CND->CND_DTINIC,5)
					dbSelectArea("CND")
					dbSetOrder(4)
					If MsSeek(xFilial("CND")+cNumero)
						Reclock("CND",.F.)
						CND->CND_ALCAPR := "B"
						MsUnlock()
					EndIf
				ElseIf cTipo == "CT"
					dbSelectArea("CN9")
					CN9->(DbSetOrder(1))

					If CN9->(MsSeek(xFilial("CN9")+cNumero))

						If CN9->CN9_SITUAC $ "05/07/08/09/10"	//Vigente/Sol.Final./Finalizado/Em Revisão/Revisado
							Aviso("A097ESTCTR","Nao é possivel estornar o documento. O estorno é permitido apenas para documentos gerados a partir de contratos com a situação Em Aprovação.",{"Ok"})
						Else
							lEstorna := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,SCR->CR_TOTAL,SCR->CR_LIBAPRO,,},,5)

							Reclock("CN9",.F.)
							CN9->CN9_SITUAC := "02"	//Em Elaboracao
							MsUnlock()
						EndIf

					EndIf
				EndIf
			EndIf                               
		End Transaction
		PcoFinLan("000055")
	EndIf

	RestArea(_aArea)
	RestArea(_aAreaZZE)
	RestArea(aAreaSCR)
	RestArea(aAreaSC7)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fConSld   ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para consultar o saldo do aprovador.                  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fConSld(cAlias,nReg,nOpcx)

	If SCR->CR_STATUS$"01"
		Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"OK"}) //
	Else
		A095Consulta("MTA097")

		dbSelectArea("SCR")
		dbSetOrder(1)
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSuperio  ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para liberar pelo superior.                           ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fSuperio(cAlias,nReg,nOpcx)

	Local aArea		:= GetArea()
	Local aRetSaldo := {}

	Local cObs 		:= CriaVar("CR_OBS")
	Local CRoeda    := ""
	Local cTipoLim  := ""
	Local cAprovS	:= ""
	Local cAprovacao:= ""
	Local cGrupo    := ""
	Local cName     := ""
	Local cSavColor := ""
	Local cOriAprov := SCR->CR_APROV
	Local cSavAprov := SCR->CR_APROV
	Local cDocto    := SCR->CR_NUM
	Local cTipo     := SCR->CR_TIPO
	Local cCodLiber := SCR->CR_APROV 
	Local cFilDoc   := SCR->CR_FILIAL
	Local ca097User := RetCodUsr()
	Local dRefer 	:= MaAlcDtRef(cOriAprov,dDataBase)
	Local cPCLib	:= ""
	Local cPCUser	:= ""

	Local lMta097   := ExistBlock("MTA097S")
	Local lLiberou  := .F.
	Local lLibOk    := .F.
	Local lAprov    := .F.
	Local lContinua := .T.
	Local lShowBut  := .T.
	Local lOGpaAprv := SuperGetMv("MV_OGPAPRV",.F.,.F.)
	Local lUsaACC   := If(FindFunction("WebbConfig"),WebbConfig(),.F.)

	Local nSaldo    := 0
	Local nOpc      := 0
	Local nSalDif	:= 0
	Local nTotal    := 0

	Local oDlg
	Local oDataRef
	Local oSaldo
	Local oSalDif

	If ExistBlock("MT097LIB")
		ExecBlock("MT097LIB",.F.,.F.)
	EndIf

	If ExistBlock("MT097SOK")
		lContinua := ExecBlock("MT097SOK",.F.,.F.)
		If ValType(lContinua) # 'L'
			lContinua := .T.
		Endif
	EndIf

	If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
		Help(" ",1,"A097LIB")  //Aviso(STR0038,STR0039,{STR0037},2) //"Atencao!"###"Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."###"Voltar"
		lContinua := .F.
	ElseIf lContinua .And. SCR->CR_STATUS$"01"
		Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"OK"})
		lContinua := .F.
	EndIf

	If lContinua

		dbSelectArea("SAK")
		dbSetOrder(1)
		MsSeek(xFilial("SAK")+SCR->CR_APROV)

		If Empty(SAK->AK_APROSUP)
			Help(" ",1,"A097APSUP")  //Aviso(STR0044,STR0045,{STR0037},2) //"Superior nao cadastrado"###"Aprovador Superior nao cadastrado para efetuar esta operacao. Verifique o cadastro de aprovadores. "###"Voltar"
			lContinua := .F.
		EndIf
	EndIf

	If lContinua

		cAprovS := SAK->AK_APROSUP

		dbSelectArea("SAK")
		dbSetOrder(1)
		MsSeek(xFilial("SAK")+cAprovS)

		cOriAprov := SAK->AK_USER
		aRetSaldo := MaSalAlc(cAprovS,dRefer)
		nSaldo 	  := aRetSaldo[1]
		CRoeda 	  := A097Moeda(aRetSaldo[2])
		cName  	  := UsrRetName(cOriAprov)
		nTotal    := xMoeda(SCR->CR_TOTAL,If(SCR->(FieldPos("CR_MOEDA")>0),SCR->CR_MOEDA,1),aRetSaldo[2],SCR->CR_EMISSAO,,If(SCR->(FieldPos("CR_TXMOEDA")>0),SCR->CR_TXMOEDA,0))

		Do Case
			Case SAK->AK_TIPO == "D"
			cTipoLim := "Diario" 
			Case  SAK->AK_TIPO == "S"
			cTipoLim := "Semanal" //
			Case  SAK->AK_TIPO == "M"
			cTipoLim := "Mensal" //
			Case  SAK->AK_TIPO == "A"
			cTipoLim := "Anual" //
		EndCase

		dbSelectArea("SAK")
		dbSetOrder(1)
		MsSeek(xFilial("SAK")+cSavAprov)

		If SCR->CR_TIPO == "NF"
			dbSelectArea("SF1")
			dbSetOrder(1)
			MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
			cGrupo := SF1->F1_APROV
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)

			dbSelectArea("SAL")
			dbSetOrder(3)
			MsSeek(xFilial("SAL")+SF1->F1_APROV+cAprovS)

			If lOGpaAprv
				If Eof()
					Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação " +SF1->F1_APROV+CRLF+"Verifique a configuração do parâmetro: MV_OGPAPRV caso não queira tornar obrigatório a existência do aprovador no grupo de aprovação.",{"Ok"}) //+STR0090 
					lContinua := .F.
				EndIf
			Endif
		ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
			dbSelectArea("SC7")
			dbSetOrder(1)
			MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
			cGrupo := SC7->C7_APROV
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

			dbSelectArea("SAL")
			dbSetorder(3)
			MsSeek(xFilial("SAL")+SC7->C7_APROV+cAprovS)

			If lOGpaAprv
				If Eof()
					Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+SC7->C7_APROV+CRLF+"Verifique a configuração do parâmetro: MV_OGPAPRV caso não queira tornar obrigatório a existência do aprovador no grupo de aprovação.",{"Ok"}) // +STR0090
					lContinua := .F.	    
				EndIf
			EndIf
		ElseIf SCR->CR_TIPO == "CP"
			dbSelectArea("SC3")
			dbSetOrder(1)
			MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)))
			cGrupo := SC3->C3_APROV
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SC3->C3_FORNECE+SC3->C3_LOJA)

			dbSelectArea("SAL")
			dbSetorder(3)
			MsSeek(xFilial("SAL")+SC3->C3_APROV+cAprovS)

			If lOGpaAprv
				If Eof()
					Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+SC3->C3_APROV+CRLF+"Verifique a configuração do parâmetro: MV_OGPAPRV caso não queira tornar obrigatório a existência do aprovador no grupo de aprovação.",{"Ok"}) // +STR0090
					lContinua := .F.	    	    
				EndIf              
			EndIf
		ElseIf SCR->CR_TIPO == "MD"
			dbSelectArea("CND")
			dbSetOrder(4)
			MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
			cGrupo := CND->CND_APROV
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+CND->CND_FORNEC+CND->CND_LJFORN)

			dbSelectArea("SAL")
			dbSetorder(3)
			MsSeek(xFilial("SAL")+cGrupo+cAprovS)

			If lOGpaAprv
				If Eof()
					Aviso("A097NOAPRV","O aprovador não foi encontrado no grupo de aprovação deste documento, verifique e se necessário inclua novamente o aprovador no grupo de aprovação "+cGrupo+CRLF+"Verifique a configuração do parâmetro: MV_OGPAPRV caso não queira tornar obrigatório a existência do aprovador no grupo de aprovação.",{"Ok"}) // +STR0090
					lContinua := .F.	    	    
				EndIf
			EndIf
		EndIf

		nSalDif := nSaldo - IIF(lAprov,0,nTotal)
		If (nSalDif) < 0
			Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
			lContinua := .F.
		EndIf

	EndIf                                

	If lContinua

		dbSelectArea("SAK")
		dbSetOrder(2)
		MsSeek(xFilial("SAK")+cOriAprov)

		nSalDif := nSaldo - IIF(lAprov,0,nTotal)
		DEFINE MSDIALOG oDlg FROM 0,0 TO 290,410 TITLE OemToAnsi("Liberacao do PC") PIXEL  //
		@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL
		@ 45,01  TO 128,204 LABEL "" OF oDlg PIXEL
		@ 07,06 Say OemToAnsi("Numero do Pedido ") OF oDlg PIXEL //
		@ 07,120 Say OemToAnsi("Emissao ") OF oDlg SIZE 50,9 PIXEL //
		@ 19,06 Say OemToAnsi("Fonecedor ") OF oDlg PIXEL //
		@ 31,06 Say OemToAnsi("Aprovador ") OF oDlg PIXEL SIZE 30,9 //
		@ 31,120 Say OemToAnsi("Data de ref.  ") SIZE 60,9 OF oDlg PIXEL  //
		@ 53,06 Say OemToAnsi("Limite min.") +CRoeda OF oDlg PIXEL //
		@ 53,103 Say OemToAnsi("Limite max. ")+CRoeda SIZE 60,9 OF oDlg PIXEL //
		@ 65,06 Say OemToAnsi("Limite  ")+CRoeda  OF oDlg PIXEL //
		@ 65,103 Say OemToAnsi("Tipo lim.") OF oDlg PIXEL //
		@ 77,06 Say OemToAnsi("Saldo na data  ")+CRoeda OF oDlg PIXEL //
		If lAprov .Or. SCR->CR_MOEDA == aRetSaldo[2]
			@ 89,06 Say OemToAnsi("Total do documento ")+CRoeda OF oDlg PIXEL //
		Else
			@ 89,06 Say OemToAnsi("Total do documento, convertido em ")+CRoeda OF oDlg PIXEL //
		EndIf
		@ 101,06 Say OemToAnsi("Saldo disponivel apos liberacao  ") +CRoeda SIZE 130,10 OF oDlg PIXEL //
		@ 113,06 Say OemToAnsi("Observações ") SIZE 100,10 OF oDlg PIXEL //
		If SCR->CR_TIPO == "CT"
			@ 07,45 MSGET SCR->CR_NUM When .F. SIZE 65,9 OF oDlg PIXEL
		Else  
			@ 07,45 MSGET SCR->CR_NUM When .F. SIZE 28,9 OF oDlg PIXEL
		EndIf
		@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45,9 OF oDlg PIXEL
		@ 19,45 MSGET SA2->A2_NOME When .F. SIZE 155,9 OF oDlg PIXEL
		@ 31,45 MSGET cName        When .F. SIZE 50,9 OF oDlg PIXEL
		@ 31,155 MSGET oDataRef VAR dRefer When .F. SIZE 45,9 OF oDlg PIXEL
		@ 53,42 MSGET SAK->AK_LIMMIN Picture PesqPict('SAK','AK_LIMMIN') When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
		@ 53,141 MSGET SAK->AK_LIMMAX Picture PesqPict('SAK','AK_LIMMAX') When .F. SIZE 59,1 OF oDlg PIXEL RIGHT
		@ 65,42 MSGET SAK->AK_LIMITE Picture PesqPict('SAK','AK_LIMITE') When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
		@ 65,141 MSGET cTipoLim When .F. SIZE 59,9 OF oDlg PIXEL CENTERED
		@ 77,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		If lAprov
			@ 89,115 MSGET cAprovacao Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		Else
			@ 89,115 MSGET nTotal Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		EndIf
		@ 101,115 MSGET oSalDif VAR nSalDif Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL

		If ExistBlock("MT097DTR")
			lShowBut := IIf(Valtype(lShowBut:=ExecBlock("MT097DTR",.F.,.F.,{SCR->CR_TIPO}))=='L',lShowBut,.T.) 
		Endif

		If lShowBut		
			@ 132,39 BUTTON OemToAnsi("Data Ref.") SIZE 40 ,11  FONT oDlg:oFont ACTION A097Data(oDataRef,oSaldo,oSalDif,@dRefer,aRetSaldo,@cCodLiber,@nSaldo,@cRoeda,@cName,@ca097User,@nTotal,@nSalDif,lAprov) OF oDlg PIXEL
		Endif	

		@ 132,80 BUTTON OemToAnsi("Liberar") SIZE 40 ,11  FONT oDlg:oFont ACTION If(A097Pass(cOriAprov),(nOpc := 2,oDlg:End()),(nOpc:=1,oDlg:End())) OF oDlg PIXEL
		@ 132,121 BUTTON OemToAnsi("Cancelar") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
		@ 132,162 BUTTON OemToAnsi("Bloq") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpc == 2 .Or. nOpc == 3
			SCR->(dbClearFilter())
			SCR->(dbGoTo(nReg))
			If ( SCR->CR_TIPO == "NF" )
				lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)),SCR->CR_TIPO)
			ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
				lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC7->C7_NUM)),SCR->CR_TIPO)
			ElseIf SCR->CR_TIPO == "CP"
				lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(SC3->C3_NUM)),SCR->CR_TIPO)
			ElseIf SCR->CR_TIPO == "MD"
				lLibOk := A097Lock(Substr(SCR->CR_NUM,1,Len(CND->CND_NUMMED)),SCR->CR_TIPO)
			EndIf

			If lLibOk
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa a gravacao dos lancamentos do SIGAPCO          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoIniLan("000055")
				Begin Transaction
					If lMta097 .And. nOpc == 2
						If ExecBlock("MTA097S",.F.,.F.)
							Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cAprovS,,cGrupo,,,,,cObs,cSavAprov},dRefer,If(nOpc==2,4,6))})
						EndIf
					Else
						Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cAprovS,,cGrupo,,,,,cObs,cSavAprov},dRefer,If(nOpc==2,4,6))})
					EndIf

					If lLiberou
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						PcoDetLan("000055","02","MATA097")

						If SCR->CR_TIPO == "NF"
							dbSelectArea("SF1")
							Reclock("SF1",.F.)
							SF1->F1_STATUS := If(SF1->F1_STATUS=="B"," ",SF1->F1_STATUS)
							MsUnlock()
						ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
							If SuperGetMv("MV_EASY")=="S" .AND. SC7->(FieldPos("C7_PO_EIC"))<>0 .And. !Empty(SC7->C7_PO_EIC)
								If SW2->(MsSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. SW2->(FieldPos("W2_CONAPRO"))<>0 .AND. !Empty(SW2->W2_CONAPRO)
									Reclock("SW2",.F.)
									SW2->W2_CONAPRO := "L"
									MsUnlock()
								EndIf
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Integracao ACC envia aprovacao do pedido            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
							If lUsaACC .And. !Empty(SC7->C7_ACCNUM)
								If IsBlind()
									Webb533(SC7->C7_NUM)
								Else
									MsgRun("Aguarde, comunicando aprovação ao portal...","Portal ACC",{|| Webb533(SC7->C7_NUM)})	// ## 
								EndIf
							EndIf

							dbSelectArea("SC7")
							cPCLib := SC7->C7_NUM
							cPCUser:= SC7->C7_USER
							While !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
								Reclock("SC7",.F.)
								SC7->C7_CONAPRO := "L"
								MsUnlock()
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								PcoDetLan("000055","01","MATA097")
								dbSkip()
							EndDo

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Envia e-mail ao comprador ref. Liberacao do pedido para compra- 034³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							MEnviaMail("034",{cPCLib,SCR->CR_TIPO},cPCUser)

						ElseIf SCR->CR_TIPO == "CP"
							dbSelectArea("SC3")
							While !Eof() .And. SC3->C3_FILIAL+Substr(SC3->C3_NUM,1,len(SC3->C3_NUM)) == xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM))
								Reclock("SC3",.F.)
								SC3->C3_CONAPRO := "L"
								MsUnlock()
								dbSkip()
							EndDo
						ElseIf SCR->CR_TIPO == "MD"
							dbSelectArea("CND")
							dbSetOrder(4)
							If dbSeek(xFilial("CND")+CND->CND_NUMMED)
								Reclock("SC3",.F.)
								CND->CND_ALCAPR := "L"
								MsUnlock()
								dbSkip()
							EndIf
						EndIf
					EndIf
				End Transaction
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Finaliza a gravacao dos lancamentos do SIGAPCO            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoFinLan("000055")
			Else
				Help(" ",1,"A097LOCK")

				If cTipo == "NF"
					SF1->(MsUnlockAll())
				ElseIf cTipo == "PC" .Or. cTipo == "AE"
					SC7->(MsUnlockAll())
				ElseIf cTipo == "CP"
					SC3->(MsUnlockAll())
				ElseIf cTipo == "MD"
					CND->(MsUnlockAll())
				EndIf
			Endif
		EndIf
		dbSelectArea("SCR")
		dbSetOrder(1)



	EndIf

	dbSelectArea("SC7")
	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fTranSup  ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para transferir aprovação para o superior.            ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fTranSup(cAlias,nReg,nOpcx)

	Local aArea		 := GetArea()
	Local aRetSaldo  := {}

	Local cObs 		 := CriaVar("CR_OBS")
	Local CRoeda     := ""
	Local cTipoLim   := ""
	Local cAprovS	 := ""
	Local cAprovacao := ""
	Local cSavColor  := ""
	Local cName      := ""
	Local cDocto     := SCR->CR_NUM
	Local cTipo      := SCR->CR_TIPO
	Local cSavAprov  := SCR->CR_APROV
	Local cOriAprov  := SCR->CR_APROV 
	Local cFilDoc    := SCR->CR_FILIAL
	Local dRefer 	 := MaAlcDtRef(cOriAprov,dDataBase)

	Local lMta097    := ExistBlock("MTA097S")
	Local lLiberou   := .F.
	Local lAprov     := .F.
	Local lContinua  := .T. 

	Local nSaldo     := 0
	Local nOpc       := 0
	Local nSalDif	 := 0
	Local nTotal     := 0

	Local oDlg
	Local oDataRef
	Local oSaldo
	Local oSalDif

	If ExistBlock("MT097LIB")
		ExecBlock("MT097LIB",.F.,.F.)
	EndIf

	If ExistBlock("MT097SOK")
		lContinua := ExecBlock("MT097SOK",.F.,.F.)
		If ValType(lContinua) # 'L'
			lContinua := .T.
		Endif
	EndIf

	If lContinua .And. !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
		Help(" ",1,"A097LIB")  //Aviso(STR0038,STR0039,{STR0037},2) //"Atencao!"###"Este pedido ja foi liberado anteriormente. Somente os pedidos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados."###"Voltar"
		lContinua := .F.
	ElseIf lContinua .And. SCR->CR_STATUS$"01"
		Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"OK"}) //
		lContinua := .F.
	EndIf

	If lContinua
		dbSelectArea("SAK")
		dbSetOrder(1)
		MsSeek(xFilial("SAK")+SCR->CR_APROV)

		If Empty(SAK->AK_APROSUP)
			Help(" ",1,"A097APSUP")
			lContinua := .F.
		EndIf
	EndIf

	If lContinua

		cAprovS := SAK->AK_APROSUP

		dbSelectArea("SAK")
		dbSetOrder(1)
		MsSeek(xFilial("SAK")+cAprovS)

		cOriAprov := SAK->AK_USER
		aRetSaldo := MaSalAlc(cAprovS,dRefer)
		nSaldo 	  := aRetSaldo[1]
		CRoeda 	  := A097Moeda(aRetSaldo[2])
		cName  	  := UsrRetName(cOriAprov)
		nTotal    := xMoeda(SCR->CR_TOTAL,If(SCR->(FieldPos("CR_MOEDA")>0),SCR->CR_MOEDA,1),aRetSaldo[2],SCR->CR_EMISSAO,,If(SCR->(FieldPos("CR_TXMOEDA")>0),SCR->CR_TXMOEDA,0))

		Do Case
			Case SAK->AK_TIPO == "D"
			cTipoLim := "Diario" //
			Case  SAK->AK_TIPO == "S"
			cTipoLim := "Semanal" //
			Case  SAK->AK_TIPO == "M"
			cTipoLim := "Mensal" //
			Case  SAK->AK_TIPO == "A"
			cTipoLim := "Anual" //
		EndCase

		dbSelectArea("SAK")
		dbSetOrder(1)
		MsSeek(xFilial("SAK")+cSavAprov)

		If SCR->CR_TIPO == "NF"
			dbSelectArea("SF1")
			dbSetOrder(1)
			MsSeek(xFilial("SF1")+Substr(SCR->CR_NUM,1,Len(SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
			dbSelectArea("SAL")
			dbSetOrder(3)
			MsSeek(xFilial("SAL")+SF1->F1_APROV+cAprovS)
		ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
			dbSelectArea("SC7")
			dbSetOrder(1)
			MsSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
			dbSelectArea("SAL")
			dbSetorder(3)
			MsSeek(xFilial("SAL")+SC7->C7_APROV+cAprovS)
		ElseIf SCR->CR_TIPO == "CP"
			dbSelectArea("SC3")
			dbSetOrder(1)
			MsSeek(xFilial("SC3")+Substr(SCR->CR_NUM,1,len(SC3->C3_NUM)))
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SC3->C3_FORNECE+SC3->C3_LOJA)
			dbSelectArea("SAL")
			dbSetorder(3)
			MsSeek(xFilial("SAL")+SC3->C3_APROV+cAprovS)
		ElseIf SCR->CR_TIPO == "MD"
			dbSelectArea("CND")
			dbSetOrder(4)
			MsSeek(xFilial("CND")+Substr(SCR->CR_NUM,1,len(CND->CND_NUMMED)))
			cGrupo := CND->CND_APROV
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+CND->CND_FORNEC+CND->CND_LJFORN)
			dbSelectArea("SAL")
			dbSetorder(3)
			MsSeek(xFilial("SAL")+CND->CND_APROV+cAprovS)
		EndIf

		If SAL->AL_LIBAPR != "A"
			lAprov	  := .T.
			cAprovacao := OemToAnsi("VISTO / LIVRE") // 
		EndIf

		dbSelectArea("SAK")
		dbSetOrder(2)
		MsSeek(xFilial("SAK")+cOriAprov)

		nSalDif := nSaldo - IIF(lAprov,0,nTotal)
		DEFINE MSDIALOG oDlg FROM 0,0 TO 290,410 TITLE OemToAnsi("Transferencia para Superior") PIXEL  //
		@ 0.5,01  TO 44,204 LABEL ""     OF oDlg PIXEL
		@ 45 ,01  TO 128,204 LABEL ""    OF oDlg PIXEL
		@ 07 ,06  Say OemToAnsi("Numero do Pedido ") OF oDlg PIXEL //
		@ 07 ,120 Say OemToAnsi("Emissao ") OF oDlg SIZE 50,9 PIXEL //
		@ 19 ,06  Say OemToAnsi("Fonecedor ") OF oDlg PIXEL //
		@ 31 ,06  Say OemToAnsi("Superior ") OF oDlg PIXEL SIZE 30,9 //
		@ 31 ,120 Say OemToAnsi("Data de ref.  ") SIZE 60,9 OF oDlg PIXEL  //
		@ 53 ,06  Say OemToAnsi("Limite min.")+CRoeda    OF oDlg PIXEL //
		@ 53 ,103 Say OemToAnsi("Limite max. ")+CRoeda SIZE 60,9 OF oDlg PIXEL //
		@ 65 ,06  Say OemToAnsi("Limite  ")+CRoeda OF oDlg PIXEL //
		@ 65 ,103 Say OemToAnsi("Tipo lim.") OF oDlg PIXEL //
		@ 77 ,06  Say OemToAnsi("Saldo na data  ")+CRoeda OF oDlg PIXEL //
		If lAprov .Or. SCR->CR_MOEDA == aRetSaldo[2]
			@ 89,06 Say OemToAnsi("Total do documento ")+CRoeda OF oDlg PIXEL //
		Else
			@ 89,06 Say OemToAnsi("Total do documento, convertido em ")+CRoeda OF oDlg PIXEL //
		EndIf
		@ 101,06  Say OemToAnsi("Saldo disponivel apos liberacao  ") +CRoeda SIZE 130,10 OF oDlg PIXEL //
		@ 113,06  Say OemToAnsi("Observações ") SIZE 100,10 OF oDlg PIXEL //
		If SCR->CR_TIPO == "CT"
			@ 07 ,45  MSGET SCR->CR_NUM     When .F. SIZE 65,9 OF oDlg PIXEL
		Else 
			@ 07 ,45  MSGET SCR->CR_NUM     When .F. SIZE 28,9 OF oDlg PIXEL
		EndIf
		@ 07 ,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45,9 OF oDlg PIXEL
		@ 19 ,45  MSGET SA2->A2_NOME    When .F. SIZE 155,9 OF oDlg PIXEL
		@ 31 ,45  MSGET cName           When .F. SIZE 50,9 OF oDlg PIXEL
		@ 31 ,155 MSGET oDataRef VAR dRefer When .F. SIZE 45,9 OF oDlg PIXEL
		@ 53 ,42  MSGET SAK->AK_LIMMIN Picture PesqPict('SAK','AK_LIMMIN') When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
		@ 53 ,141 MSGET SAK->AK_LIMMAX Picture PesqPict('SAK','AK_LIMMAX') When .F. SIZE 59,9 OF oDlg PIXEL RIGHT
		@ 65 ,42  MSGET SAK->AK_LIMITE Picture PesqPict('SAK','AK_LIMITE') When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
		@ 65 ,141 MSGET cTipoLim When .F. SIZE 45,9 OF oDlg PIXEL CENTERED
		@ 77 ,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999,999.99" When .F. SIZE 85,14 OF oDlg PIXEL RIGHT

		If lAprov
			@ 89,115 MSGET cAprovacao Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		Else
			@ 89,115 MSGET nTotal Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		EndIf 
		@ 101,115 MSGET oSalDif VAR nSalDif Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
		@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL
		@ 132,121 BUTTON OemToAnsi("Cancelar") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End()) OF oDlg PIXEL
		@ 132,162 BUTTON OemToAnsi("Transferir") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End()) OF oDlg PIXEL
		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpc == 1  //Confirma a transferencia
			Begin Transaction
				If lMta097
					If ExecBlock("MTA097S",.F.,.F.)
						Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,cAprovS,,,,,,,cObs},dRefer,2)})
					EndIf
				Else
					Processa({|lEnd| lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,cAprovS,,,,,,,cObs},dRefer,2)})
				EndIf
			End Transaction
		EndIf
		dbSelectArea("SCR")
		dbSetOrder(1)
	EndIf

	dbSelectArea("SC7")
	If ExistBlock("MT097END")
		ExecBlock("MT097END",.F.,.F.,{cDocto,cTipo,nOpc,cFilDoc})
	EndIf
	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAusTemp  ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para transferir pelo motivo de ausencia.              ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fAusTemp(cAlias,nReg,nOpcx)

	Local aArea		:= GetArea()
	Local aCpos     := {"CR_NUM","CR_TIPO","CR_USER","CR_APROV","CR_STATUS","CR_TOTAL","CR_EMISSAO"}
	Local aHeadCpos := {}
	Local aHeadSize := {}
	Local aArraySCR	:= {}
	Local aCampos   := {}
	Local aCombo    := {}
	Local cAliasSCR := "SCR"
	Local cAprov    := ""
	Local cUserName := ""   
	Local cUsrApvSup:= "" 
	Local cUser     := RetCodUsr()
	Local nX        := 0
	Local nOpc      := 0
	Local nOk       := 0
	Local nRegSak   := 0

	Local oDlg
	Local oQual

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nx	:= 1 to Len(aCpos)
		If MsSeek(aCpos[nx])
			AADD(aHeadCpos,AllTrim(X3Titulo()))
			AADD(aHeadSize,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
			AADD(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
		EndIf
	Next
	*/

	For nx	:= 1 to Len(aCpos)
		If MsSeek(aCpos[nx])
			AADD(aHeadCpos,	AllTrim(X3Titulo()))
			AADD(aHeadSize,	CalcFieldSize(GetSX3Cache(aCpos[nx],"X3_CAMPO"))	,;
							GetSX3Cache(aCpos[nx],"X3_TAMANHO"	)				,;
							GetSX3Cache(aCpos[nx],"X3_DECIMAL"	)				,;
							GetSX3Cache(aCpos[nx],"X3_PICTURE"	)				,;
							X3Titulo()											)
			
			AADD(aCampos,{	GetSX3Cache(aCpos[nx],"X3_CAMPO"	)				,;
							GetSX3Cache(aCpos[nx],"X3_TIPO"		)				,;
							GetSX3Cache(aCpos[nx],"X3_CONTEXT"	)				,;
							GetSX3Cache(aCpos[nx],"X3_PICTURE"	)				})
		EndIf
	Next

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	dbSelectArea("SAK")
	dbSetOrder(2)
	If dbSeek(xFilial("SAK")+cUser)
		While ( !Eof().And. SAK->AK_FILIAL == xFilial("SAK") .AND. SAK->AK_USER == cUser )
			nRegSak 	:= Recno()    
			cUsrApvSup := SAK->AK_COD
			dbSeek(xFilial("SAK"))
			While ( !Eof().And. SAK->AK_FILIAL == xFilial("SAK") )
				If SAK->AK_APROSUP == cUsrApvSup 
					AADD(aCombo,SAK->AK_COD+" - "+SAK->AK_NOME)
				EndIf  
				SAK->(dbSkip())
			EndDo
			dbgoto(nRegSak)  
			SAK->(dbSkip())
		EndDo                        
	EndIf

	cUsrApvSup := ""

	If Len(aCombo) > 0

		A097Aprov(cAliasSCR,Substr(aCombo[1],1,6),@aArraySCR,aCampos,aCombo)

		DEFINE MSDIALOG oDlg FROM 000,000 TO 400,780 TITLE "Transferencia por Ausencia Temporaria de Aprovadores" PIXEL // 
		@ 001,001  TO 050,425 LABEL "" OF oDlg PIXEL

		@ 012,006 Say "Aprovador Ausente " OF oDlg PIXEL SIZE 080,009 // 
		@ 012,058 MSCOMBOBOX cAprov ITEMS aCombo SIZE 250,090 WHEN .T. VALID A097Aprov(cAliasSCR,cAprov,@aArraySCR,aCampos,aCombo,oQual) OF oDlg PIXEL

		@ 030,006 Say "Aprovador Superior"  OF oDlg PIXEL SIZE 080,009 // 
		@ 030,058 MSGET cUserName : = (trim(A097UsuSup(cAprov))+If(Len(aCombo)>1," Atenção: existe mais de um Aprovador Ausente para o Aprovador Superior","")) When .F. SIZE 250,009 OF oDlg PIXEL   //+STR0086

		oQual:= TWBrowse():New( 051,001,389,133,,aHeadCpos,aHeadSize,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oQual:SetArray(aArraySCR)
		oQual:bLine := { || aArraySCR[oQual:nAT] }

		@ 187,299 BUTTON "Transferir" SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL // "Transferir"
		@ 187,340 BUTTON "Cancelar" SIZE 040,011 FONT oDlg:oFont ACTION (nOpc:=2,oDlg:End())  OF oDlg PIXEL // "Cancelar  "

		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpc == 1 
			cUsrApvSup:=Substr(cUserName,1,6)

			If !Empty(aArraySCR[1][1])

				nOk := Aviso("Atencao!","Ao confirmar este processo todas aprovações pendentes do aprovador serão transferidas ao aprovador superior. Confirma a Transferência ? ",{"Cancelar","Confirma"},2) //######

				If  nOk == 2  // Confirma a transferencia

					For nX := 1 To Len(aArraySCR)
						dbSelectArea("SCR")                
						dbSetOrder(2)
						dbSeek(xFilial("SCR")+aArraySCR[nX][2]+aArraySCR[nX][1]+aArraySCR[nX][3])

						Begin Transaction
							MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,,cUsrApvSup,cUser,,,SCR->CR_MOEDA,SCR->CR_TXMOEDA,,"Tranferido por Ausencia"},,2) // 
						End Transaction	
					Next nX

				EndIf 

			Else
				Aviso("A097NOSCR","Não existem registros para serem transferidos",{"OK"})          
			EndIf

		EndIf	
	Else
		Aviso("A097NOSUP","Para utilizar esta opção é necessario que exista no minimo um aprovador com um superior cadastrado",{"OK"}) //
	EndIf

	RestArea(aArea)	

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLegLib   ºAutor  ³Bruna Zechetti      º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para legenda de liberações.                           ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function fLegLib()

	Local aLegeUsr   := {}
	Local aLegenda   := {{"BR_AZUL" , "Bloqueado (Aguardando outros niveis)"},; //
	{"DISABLE" , "Aguardando Liberacao do usuario"},; //
	{"ENABLE"  , "Pedido Liberado pelo usuario"},; //
	{"BR_PRETO", "Pedido Bloqueado pelo usuario"},; //
	{"BR_CINZA", "Pedido Liberado por outro usuario"}}  //

	BrwLegenda(cCadastro,"Legenda",aLegenda)    	

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPcoLan ºAutor  ³Bruna Zechetti    º Data ³  17/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para validação de lançamento.                         ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPcoLan(lLanPCO)
	Local lRet	   := .T.
	Local aArea    := GetArea()
	Local aAreaSC7 := SC7->(GetArea())

	Default lLanPCO := .T.

	If lLanPCO
		If SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
			dbSelectArea("SC7")
			DbSetOrder(1)
			DbSeek(xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM)))
		Endif
		If lRet	:=	PcoVldLan('000055','02','MATA097')
			If SCR->CR_TIPO == "NF"
				dbSelectArea("SF1")
			ElseIf SCR->CR_TIPO == "PC" .Or. SCR->CR_TIPO == "AE"
				While lRet .And. !Eof() .And. SC7->C7_FILIAL+Substr(SC7->C7_NUM,1,len(SC7->C7_NUM)) == xFilial("SC7")+Substr(SCR->CR_NUM,1,len(SC7->C7_NUM))
					lRet	:=	PcoVldLan("000055","01","MATA097")
					dbSelectArea("SC7")
					dbSkip()
				EndDo
			ElseIf SCR->CR_TIPO == "CP"
				dbSelectArea("SC3")
			EndIf
		Endif
		If !lRet
			PcoFreeBlq("000055")
		Endif
	EndIf

	RestArea(aAreaSC7)
	RestArea(aArea)
Return lRet