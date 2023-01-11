#INCLUDE "rwmake.ch"
/*


?
Programa  GERASE2    Autor  Claudio             Data   03/07/08   
?
Descricao  Gera um titulo a pagar a partir de uma Solicitacao de      
           Pagamento Adiantado aprovada.                              
?
Alteracao  Incluido campo E2_NUMPC Linha 166 na geracao do SE2-       
          Sergio Celestino                                            
                                                                      
?
Uso        T4F - Gestao de Pessoal                                    
?


*/
// Gilberto 19 e 20/05/2011 -> Inclusao de tratamento para gerao de titulo do tipo FT (repasse) prefixo PRT: Pagamento Repasse Terceiros.

//ZZ6_STATUS //1=Aguardando Aprovacao;2=Aprovada;3=Rejeitada;4=Aguardando Nivel Anterior;5=Inativa Nesse Nivel //alterado por Marcio Frade

User Function GERASE2

	Private aCampos:= {{"ZZE_NUMERO","Numero"},;
		{"ZZE_FORNEC","Fornecedor"},;
		{"ZZE_VALOR" ,"Valor"},;
		{"ZZE_DATA"  ,"Data pagto."},;
		{"ZZE_PREF"  ,"Prefixo"},;
		{"ZZE_TITULO","Numero"},;
		{"ZZE_PARC"  ,"Parcela"}}

	Private aCores		:= {{"empty(ZZE_PREF)","ENABLE"},{"!empty(ZZE_PREF)","DISABLE"}}
	Private cCadastro	:= "Geracao de titulos a pagar a partir das solicitacoes de Pagto Antecipado/Avulso/Repasse"

//
// OBSERVACAO OBSERVACAO OBSERVACAO OBSERVACAO OBSERVACAO
//
// 23/02/10 - OBSERVACAO: Procure pela funcao U_EXCADTO no fonte: EstornaAdto()  - Gilberto.

	Private aRotina		:= {{"Pesquisar","AxPesqui",0,1},;
		{"Visualizar","AxVisual",0,2},;
		{"Gerar titulo","U_GeraTit",0,2},;
		{"Excluir Tit.","U_ExcAdto",0,2},;
		{"Hist Aprovacao","U_fHistApr",0,2},; //alterado por Marcio Frade
	{"Gerar RA","U_GeraSE1",0,2},;
		{"Legenda","U_LEGSE2",0,2}}


	Private aIndice		:= {}		// para uso do filtro da mbrowse
//Private cCondicao	:= "ZZE_STATUS == 'L' .and. ZZE_TIPO <> 4 .and. ZZE_TIPO <> 7 .and. ZZE_TIPO <> 6 "
//bFiltraBrw := { || FilBrowse("ZZE",@aIndice,@cCondicao) }
//Eval(bFiltraBrw)
//mBrowse( 6,1,22,75,"ZZE",,,,,,aCores)

// NOTA: A utilizacao do filtro direto no mbrowse libera o boto "filtro"para ser utilizado pelo usurio.
	MBrowse(6, 1,22,75,"ZZE",,,,,,aCores,,,,,,,,"ZZE_STATUS = 'L' and ZZE_TIPO<>4 and ZZE_TIPO<>7 and ZZE_TIPO<>6")

	RetIndex("ZZE")
	dbClearFilter()
return .t.

/*/

	?
	Funo     GeraTit   Autor Alexandre Inacio Lemes Data  11/04/2006
	?
	Descrio  Gera um titulo no SE2 a partir da solicitacao de PA
	?
	Uso       T4F
	?


/*/

User Function GeraTit()

	//Local cArquivo
	//Local lPadrao	:= .f.
	//Local nHdlPrv	:= 0
	//Local nTotal 	:= 0
	Local nTipo		:= ZZE->ZZE_TIPO
	Local cTipo		:= Space(03)
	Local xPrefixo	:= "AUT"

// Variaveis de contabilizacao
	//Local cLctPad		:= "513"

	//Local c513			:= Nil
	//Local cArqCtb		:= ""
	//Local cPrograma		:= "GERASE2"
	//Local cLoteCtb		:= "8820"
	//Local aCT5			:= {}
	//Local aFlagCTB		:= {}
	//Local lDigita		:= .f.
	//Local lAglutina		:= .T.
	//Local nTotalCTB		:= 0
	Local cPerg         := "GERSE2"
	Local aAreaCNX  := CNX->(GetArea())
	Private lMsErroAuto := .F.
	Private cLote

	If (nTipo==5)
		MsgBox("O titulo selecionado  um RA, utilize a funo 'Gerar RA'","Atencao","ERROR")
		Return .f.
	Else

		If !Empty(ZZE->ZZE_PREF).AND.ZZE->ZZE_PREF<>"ADT"
			MsgBox("Ja foi gerado titulo a pagar para essa solicitacao de Pagamento Antecipado/Avulso","Atencao","ERROR")
			Return .f.
		Endif

		If Msgbox("Confirma a gerao de um titulo a PAGAR a partir da Solicitacao de Pagto  "+chr(13)+;
				"Antecipado/Avulso ou Repasse, nr.: "+alltrim(ZZE->ZZE_NUMERO)+" ?","Atencao","YESNO")



			If ZZE->ZZE_TIPO == 9 .Or. ZZE->ZZE_TIPO == 0

				MV_PAR05:= 1
				PergRepasse("REPPERG")
				If !Pergunte("REPPERG",.T.)
					Return(.f.)
				Else

					If mv_par02 < ddatabase
						ApMsgStop("Data de Vencimento Informada  Menor que a data de hoje!")
						Return(.f.)
					EndIf

					If ZZE->ZZE_TIPO == 9
						If !VldNumRep("PRT",PADR(MV_PAR01,9))
							Return(.f.)
						EndIf
					ElseIf ZZE->ZZE_TIPO == 0
						If !VldNumRep("DVI",PADR(MV_PAR01,9))
							Return(.f.)
						EndIf

					EndIf

					If !MsgYesNo("Confirma Geração do Titulo de Repasse.","Geração Título Repasse")
						Return(.f.)
					EndIf

				EndIf

				MV_PAR04:= ZZE->ZZE_NATURE
				If ZZE->ZZE_TIPO == 9
					MV_PAR06:= "RT " //"FT "
					xPrefixo:= "PRT" // Pagto Repasse Terceiros.
				ElseIf ZZE->ZZE_TIPO == 0
					MV_PAR06:= "DV " //"FT "
					xPrefixo:= "DVI" // Devoluo de Ingressos
				EndIf

			Else

				ValidPerg(cPerg)
//		Pergunte(cPerg,.F.)
//		MV_PAR04 := ZZE->ZZE_NATURE
				dbSelectArea("SX1")
				SX1->(dbSetORder(1))
				If SX1->(dbSeek(PadR(cPerg,10) + "04"))
					If RecLock("SX1",.F.)
						SX1->X1_CNT01 := ZZE->ZZE_NATURE
						SX1->(MsUnLock())
					EndIf
				EndIF

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
			SED->(DbSeek(xFilial("SED")+MV_PAR04))

			SM2->(DbSetorder(1))
			SM2->(DbGotop())
			SM2->(DbSeek(Date()))

			If ZZE->ZZE_TIPO == 5
				cTipo := MV_PAR06
				If !Empty(ZZE->ZZE_IDBDUP)
					xPrefixo := "GPE" // Pagamento Folha de Pagamento
				EndIf
			Else
				If ZZE->ZZE_TIPO == 8
					cTipo := "TX "
				Else
					If ZZE->ZZE_TIPO == 9
						cTipo := "RT "
						xPrefixo := "PRT" // Pagamento Repasse Terceiro
					ElseIf ZZE->ZZE_TIPO == 0
						cTipo := "DV "
						xPrefixo := "DVI" // Devoluo Ingresso

					Else
						cTipo := "PA "
					EndIF
				EndIf
			Endif

			//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
			If ( ZZE->ZZE_TIPO  == 9 .Or. ZZE->ZZE_TIPO == 0 )

				cNumTitulo:= mv_par01

			Else

				While .T.

					cNumTitulo := GetSXENum("SE2","E2_NUM")
					ConfirmSX8() // Evita a todo custo a repeticao do numero titulo. Gilberto.

					DbSelectArea("SE2")
					SE2->( DbSetOrder(1) )		 // unique key. Gilberto.
					//SE2->( DbSetOrder(6) )
					//If SE2->( DbSeek(xFilial("SE2")+ZZE->ZZE_FORNECE+ZZE->ZZE_LOJA+xPrefixo+cNumTitulo+"1"+cTipo) ) // Linha retirada para utilizacao da chave unica do sistema.
					If SE2->( DbSeek(xFilial("SE2")+xPrefixo+cNumTitulo+"1"+cTipo+ZZE->ZZE_FORNEC+ZZE->ZZE_LOJA) )
						cNumTitulo := GetSXENum("SE2","E2_NUM")
						ConfirmSX8()
						Loop
					Else
						Exit
					EndIf

				EndDo

			EndIF

			aVetorSE2 := {}
			aAdd(aVetorSE2,{"E2_PREFIXO",xPrefixo,Nil})
			aAdd(aVetorSE2,{"E2_NUM"	,cNumTitulo,Nil})
			aAdd(aVetorSE2,{"E2_PARCELA","1",Nil})
			aAdd(aVetorSE2,{"E2_TIPO",cTipo,Nil})

			If ( cTipo = "PA " )
				aAdd(aVetorSE2,{"AUTBANCO",MV_PAR01,Nil})
				aAdd(aVetorSE2,{"AUTAGENCIA",MV_PAR02,Nil})
				aAdd(aVetorSE2,{"AUTCONTA",MV_PAR03,Nil})
				aAdd(aVetorSE2,{"E2_BCOPAG",MV_PAR01,Nil})
				aAdd(aVetorSE2,{"E2_AGPAG",MV_PAR02,Nil})
				aAdd(aVetorSE2,{"E2_CTAPAG",MV_PAR03,Nil})
				aAdd(aVetorSE2,{"E2_NUMPC" ,ZZE->ZZE_PEDIDO	,Nil})//Adicionado por Sergio Celestino
			Endif

			aAdd(aVetorSE2,{"E2_NUMSPA",ZZE->ZZE_NUMERO,Nil})
			aAdd(aVetorSE2,{"E2_NATUREZ",MV_PAR04,Nil})
			If !Empty(ZZE->ZZE_DIRF)
				aAdd(aVetorSE2,{"E2_CODRET",ZZE->ZZE_DIRF,Nil})
				aAdd(aVetorSE2,{"E2_DIRF","1",Nil})
			EndIf
			aAdd(aVetorSE2,{"E2_FORNECE",ZZE->ZZE_FORNEC,Nil})
			aAdd(aVetorSE2,{"E2_LOJA"	,ZZE->ZZE_LOJA,Nil})
			aAdd(aVetorSE2,{"E2_EMISSAO",dDataBase,Nil})
			aAdd(aVetorSE2,{"E2_VENCTO"	,iif( ZZE->ZZE_TIPO==9 .Or. ZZE->ZZE_TIPO == 0, mv_par02,dDataBase ),Nil})
			aAdd(aVetorSE2,{"E2_VENCREA",DataValida(iif( ZZE->ZZE_TIPO==9 .Or. ZZE->ZZE_TIPO == 0, mv_par02,dDataBase )),Nil})
			aAdd(aVetorSE2,{"E2_VALOR"	,ZZE->ZZE_VALOR,Nil})
			aAdd(aVetorSE2,{"E2_ITEM",	ZZE->ZZE_PEP,Nil})
			aAdd(aVetorSE2,{"E2_MOEDA",	ZZE->ZZE_MOEDA,Nil})
			//	aAdd(aVetorSE2,{"E2_TXMOEDA",IIf(AllTrim(MV_PAR06) $ "TX/FT",1,MV_PAR05),Nil})
			aAdd(aVetorSE2,{"E2_TXMOEDA",IIf(AllTrim(MV_PAR06) $ "TX/RT",1,MV_PAR05),Nil})
			aAdd(aVetorSE2,{"E2_CONTAD",SED->ED_DEBITO,Nil})
			aAdd(aVetorSE2,{"E2_CCUSTO",ZZE->ZZE_CCUSTO,Nil})
			aAdd(aVetorSE2,{"E2_ITEM",ZZE->ZZE_PEP,Nil})
			aAdd(aVetorSE2,{"E2_HIST",ZZE->ZZE_HISTOR,Nil})
			aAdd(aVetorSE2,{"E2_MDCONTR",RIGHT(ZZE->ZZE_HISTOR,15),Nil})

			// multiplicar diretamente o valor pela taxa informada
			If !empty(MV_PAR05)
				aAdd(aVetorSE2,{"E2_VLCRUZ",Round(NoRound((ZZE->ZZE_VALOR * MV_PAR05),3),2)	,Nil})
			Else
				aAdd(aVetorSE2,{"E2_VLCRUZ",Round(NoRound(ZZE->ZZE_VALOR,3),2),Nil})
			Endif

			lMsErroAuto := .f.
			MsExecAuto({|x,y| Fina050(x,y)},aVetorSE2,3)

	/*
	dbSelectArea("SE2")
	RecLock("SE2", .T.)
	
	SE2->E2_PREFIXO:=xPrefixo
	SE2->E2_NUM:=cNumTitulo
	SE2->E2_PARCELA:="1"
	SE2->E2_TIPO:=cTipo
	
			If ( cTipo = "PA " )
		//aAdd(aVetorSE2,{"AUTBANCO",MV_PAR01,Nil})
		//aAdd(aVetorSE2,{"AUTAGENCIA",MV_PAR02,Nil})
		//aAdd(aVetorSE2,{"AUTCONTA",MV_PAR03,Nil})
		SE2->E2_BCOPAG:=MV_PAR01
		SE2->E2_AGPAG:=MV_PAR02
		SE2->E2_CTAPAG:=MV_PAR03
		SE2->E2_NUMPC:=ZZE->ZZE_PEDIDO
			Endif
	
	SE2->E2_NUMSPA:=ZZE->ZZE_NUMERO
	SE2->E2_NATUREZ:=MV_PAR04
			If !Empty(ZZE->ZZE_DIRF)
		SE2->E2_CODRET:=ZZE->ZZE_DIRF
		SE2->E2_DIRF:="1"
			EndIf
	SE2->E2_FORNECE:=ZZE->ZZE_FORNEC
	SE2->E2_LOJA:=ZZE->ZZE_LOJA
	SE2->E2_EMISSAO:=dDataBase
	SE2->E2_VENCTO:=iif( ZZE->ZZE_TIPO==9 .Or. ZZE->ZZE_TIPO == 0, mv_par02,dDataBase )
	SE2->E2_VENCREA:=DataValida(iif( ZZE->ZZE_TIPO==9 .Or. ZZE->ZZE_TIPO == 0, mv_par02,dDataBase ))
	SE2->E2_VALOR:=ZZE->ZZE_VALOR
	SE2->E2_ITEM:=ZZE->ZZE_PEP
	SE2->E2_MOEDA:=ZZE->ZZE_MOEDA
	//	aAdd(aVetorSE2,{"E2_TXMOEDA",IIf(AllTrim(MV_PAR06) $ "TX/FT",1,MV_PAR05),Nil})
	SE2->E2_TXMOEDA:=IIf(AllTrim(MV_PAR06) $ "TX/RT",1,MV_PAR05)
	SE2->E2_CONTAD:=SED->ED_DEBITO
	SE2->E2_CCUSTO:=ZZE->ZZE_CCUSTO
	SE2->E2_ITEM:=ZZE->ZZE_PEP
	SE2->E2_HIST:=ZZE->ZZE_HISTOR
	
	// multiplicar diretamente o valor pela taxa informada
			If !empty(MV_PAR05)
		SE2->E2_VLCRUZ:=Round(NoRound((ZZE->ZZE_VALOR * MV_PAR05),3),2)	
			Else
		SE2->E2_VLCRUZ:=Round(NoRound(ZZE->ZZE_VALOR,3),2)
			Endif
    */
			If lMsErroAuto
				MostraErro()
				// RollbackSx8() -> Ainda que ocorra erro a opcao e por gerar um  novo numero afim de evitar qualquer possibilidade de coincidencia numerica.
			Else

				// Retirado por ser desnecessario.
				// Explico: O motivo do prefixo ficar em branco e' que existia um gatilho mau-feito limpando o conteudo do campo PREFIXO sem
				// verificar a rotina, nem o tipo de titulo.  Gilberto - 26/10/10

				//dbSelectArea("SE2")
				//dbSetOrder(6)
				//If !dbSeek(xFilial("SE2")+ZZE->ZZE_FORNECE+ZZE->ZZE_LOJA+xPrefixo+cNumTitulo+"1"+cTipo)
				//    dbSelectArea("SE2")
				//    dbSetOrder(6)
				//   If dbSeek(xFilial("SE2")+ZZE->ZZE_FORNECE+ZZE->ZZE_LOJA+"   "+cNumTitulo+"1"+cTipo)
				//      reclock("SE2",.F.)
				///         SE2->E2_PREFIXO := xPrefixo
				//       msunlock()
				//   Endif
				//EndIf

				//dbSetOrder(1)
				//dbseek(xFilial("SE2")+cPrf+cNumTitulo)

				// if reclock("SE2",.F.)
				//    SE2->E2_PREFIXO := cPrf
				//    msunlock()
				// endif

				// ConfirmSX8()

				//EXCLUSAO DO TITULO PR GERADO POR CONTRATO -- CRM
				aRotAuto:={}

				DbSelectArea("SE2")
				SE2->( DbSetOrder(1) )
				If SE2->( DbSeek(xFilial("SE2")+ZZE->ZZE_PREF+ZZE->ZZE_TITULO+" "+"PR "+ZZE->ZZE_FORNEC+ZZE->ZZE_LOJA) )
					If Found()

						AAdd( aRotAuto, { "E2_NUM"    , SE2->E2_NUM, NIL } )
						AAdd( aRotAuto, { "E2_PREFIXO", SE2->E2_PREFIXO, NIL } )
						AAdd( aRotAuto, { "E2_NATUREZ", SE2->E2_NATUREZ, NIL } )
						AAdd( aRotAuto, { "E2_TIPO"   , SE2->E2_TIPO, NIL } )
						AAdd( aRotAuto, { "E2_FORNECE", SE2->E2_FORNECE, NIL } )
						AAdd( aRotAuto, { "E2_LOJA"   , SE2->E2_LOJA, NIL } )
						

						MSExecAuto({|x, y, z| FINA050(x, y, z)}, aRotAuto, 5, 5)
					Endif
				Endif

				//ALTERAO DOS DADOS DO TITULO GERADO NO CONTRATO - CRM
				DbSelectArea("CNX")
				CNX->( DbSetOrder(1) )
				If CNX->( DbSeek(xFilial("CNX")+RIGHT(ZZE->ZZE_HISTOR,15)+ZZE->ZZE_PEDIDO) ) //NUM CONTRTO+NUM ADT
					RecLock("CNX",.F.)
					CNX->CNX_PREFIX	:= xPrefixo
					CNX->CNX_NUMTIT	:= cNumTitulo
					MsUnLock()
				EndIf

				If RecLock("ZZE",.f.)
					ZZE->ZZE_PREF	:= xPrefixo
					ZZE->ZZE_TITULO	:= cNumTitulo
					ZZE->ZZE_PARC	:= "1"
					MsUnLock()
				Endif

				dbSelectArea("SE5") //LUIZ EDUARDO - Alterao em 21/03/2019 para gerar a PA com o tipo BA para aparecer no extrato bancrio
				dbSetOrdeR(7)
				//SE5->(DbSeek(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
				SE5->(MsSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))//LV

				If !(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA="                          ")
					If(SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA) = (SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
						RecLock("SE5",.f.)
						SE5->E5_TIPODOC	:= "PA"
						MsUnLock()
					EndIf
				Endif

				MsgBox("Para a Solicitao de Pagamento Antecipado/Avulso Nro. "+ZZE->ZZE_NUMERO+" Foi gerado o titulo de nr. "+alltrim(cNumTitulo)+".",;
					"Titulo a pagar gerado com sucesso","INFO")

			Endif

		Endif
	Endif
	RestArea(aAreaCNX)

Return(Nil)



Static Function VldNumRep(cPrefixo,cNum)
	Local lOk:= .t.
	Local aSE2Area:= SE2->( GetArea() )

// Repasse terceiros. Devoluo de Ingressos
	If ( cPrefixo == "PRT" .Or. cPrefixo == "DVI" )
		SE2->( DbSetOrder(1) )
		If SE2->( DbSeek( xFilial("SE2")+cPrefixo+cNum) )
			ApMsgStop("ATENO : Esse numero de ttulo j foi utilizado !!"+chr(13)+chr(10)+"** Por favor digite outro numero... ***")
			lOk:= .f.
		EndIf
	EndIf

	RestArea(aSE2Area)
Return( lok )

/*/

	?
	Funo     LEG       Autor Claudio                Data  03/07/2008
	?
	Descrio  Cria uma janela contendo a legenda da mBrowse
	?
	Uso       T4F
	?


/*/
User Function LEGSE2()

	Local aLegenda	:= {{"ENABLE","Disponivel para gerar titulo"},{"DISABLE","Titulo ja gerado"}}

	BrwLegenda("","Legendas", aLegenda )
return .T.

/*/


	?
	Funcao    ValidPerg   Autor  Claudio            Data   03/07/08
	?
	Descrio  Funcao de verificacao da existencia dos parametros a serem
	informados
	?
	Uso
	?


/*/

Static Function ValidPerg(cPerg)

	Local j,i
	cPerg := padr(cPerg,len(SX1->X1_GRUPO))
	cAlias := Alias()
//cPerg   := "GERSE2"
	aRegs   :={}
	dbSelectArea("SX1")
	dbSetOrder(1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aadd(aRegs,{cPerg,"01","Banco (somente para PAs)   ?","","","mv_ch1","C", 3,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","",""})
	aadd(aRegs,{cPerg,"02","Agencia (somente para PAs) ?","","","mv_ch2","C", 5,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"03","Conta (somente para PAs)   ?","","","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"04","Natureza (somente para PAs)?","","","mv_ch4","C",10,0,0,"G","existcpo('SED',MV_PAR04,1) .and. naovazio()","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SED","","",""})
	aadd(aRegs,{cPerg,"05","Taxa da moeda               ?","","","mv_ch5","N",11,4,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"06","Tipo de titulo (exceto PAs)?","","","mv_ch6","C", 3,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","05","","",""})

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
Return .t.

/*


?
Funo    PergRepas Autor  Gilberto Oliveira    Data   20/05/11   
?
Desc.       Pergunta sobre titulo de repasse.                         
                                                                      
?
Uso        AP                                                         
?


*/

Static Function PergRepasse(cPerg)

	Local j,i
	Local cAlias := Alias()
	Local aRegs   :={}

	cPerg := PadR(cPerg,Len(SX1->X1_GRUPO))

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
Return .t.

User Function GeraSE1()

	If !Empty(ZZE->ZZE_PREF).AND.ZZE->ZZE_PREF<>"ADT"
		MsgBox("Ja foi gerado titulo a receber para essa solicitacao de Recebimento Antecipado","Atencao","ERROR")
		Return .f.
	Endif

	If !MsgYesNo("Confirma Geração do Titulo de Recebimento Antecipado.","Geração RA antecipado")
		Return()
	EndIf

	FwMsgRun(,{ || ProcRa() }, "Geração de Recebimento Antecipado", 'Gerando titulo de recebimento antecipado, por favor aguarde...')

Return

Static Function ProcRa()
	Local nTipo		:= ZZE->ZZE_TIPO
	Local cTipo		:= Space(03)
	//Local xPrefixo	:= "AUT"
	//Local aAreaCNX  := CNX->(GetArea())
	Local aRotAuto	:=	{}
	Local lRet		:=	.T.
	Private lMsErroAuto := .F.

	If !(nTipo == 5)
		ApMsgStop("Titulo selecionado no  RA, favor verificar!")
		Return(.f.)
	Else

		If !Pergunte("GERSE1",.T.)
			Return .f.
		EndIf

		ProcRegua(2)
		SED->(DbSetorder(1))
		SED->(DbGotop())
		SED->(DbSeek(xFilial("SED")+MV_PAR04))

		SM2->(DbSetorder(1))
		SM2->(DbGotop())
		SM2->(DbSeek(Date()))

		/*	
		//ATUALIZA DADOS DO ADIANTAMENTO CONTRATO
		cAliasCNX:= GetNextAlias()

		BeginSQL Alias cAliasCNX

				SELECT CNX.R_E_C_N_O_ RECNO,CNX_CONTRA,CNX_NUMERO
				FROM %TABLE:ZZE% ZZE
				LEFT JOIN %TABLE:CNX% CNX
				ON CNX.CNX_NUMTIT=zze.zze_titulo
				AND cnx.cnx_client=zze.zze_fornec
				AND cnx.cnx_lojacl=zze.zze_loja
				AND CNX_BANCO = ZZE_BANCO
				AND CNX_CONTA = ZZE_CONTA
				AND CNX_AGENCI= zze.zze_agenc 
				AND CNX_VLADT=zze.zze_valor
				AND CNX_DTADT=zze.zze_data
				AND cnx.cnx_prefix='ADT'
				WHERE ZZE_PREF='   '
				AND ZZE.%NOTDEL%
				AND CNX.%NOTDEL%

		EndSQL
		*/

		cTipo 	:= 	"RA"
		cNumSe1	:=	"AUT"+RIGHT(GetSX8Num("SE1","E1_NUM"),6)//RIGHT((cAliasCNX)->CNX_CONTRA,6) + RIGHT((cAliasCNX)->CNX_NUMERO,3)

		AAdd( aRotAuto, { "E1_NUM"    , cNumSe1, NIL } )
		AAdd( aRotAuto, { "E1_PREFIXO", "AUT", NIL } )
		AAdd( aRotAuto, { "E1_NATUREZ", MV_PAR04, NIL } )
		AAdd( aRotAuto, { "E1_TIPO"   , cTipo, NIL } )
		AAdd( aRotAuto, { "E1_CLIENTE", ZZE->ZZE_FORNEC, NIL } )
		AAdd( aRotAuto, { "E1_LOJA"   , ZZE->ZZE_LOJA, NIL } )
		AAdd( aRotAuto, { "E1_VALOR"  , ZZE->ZZE_VALOR, NIL } )
		AAdd( aRotAuto, { "E1_EMISSAO", dDataBase, NIL } )
		AAdd( aRotAuto, { "E1_VENCTO" , dDataBase, NIL } )
		AAdd( aRotAuto, { "E1_VENCREA", DataValida( dDataBase ), NIL } )
		AADD( aRotAuto, { "E1_VENCORI", DataValida( Ddatabase,.T.),NIL })
		AADD( aRotAuto, { "E1_MOEDA"  , 1, NIL})
		AADD( aRotAuto, { "E1_MDREVIS", "", NIL})
		AADD( aRotAuto, { "CBCOAUTO"  , MV_PAR01, NIL } )
		AADD( aRotAuto, { "CAGEAUTO"  , MV_PAR02, NIL } )
		AADD( aRotAuto, { "CCTAAUTO"  , MV_PAR03, NIL } )
		AADD( aRotAuto, { "E1_HIST"   , "RA SOBRE CONTRATO N. "+RIGHT(ZZE->ZZE_HISTOR,15), NIL } )

		cNumTitAnt:=ZZE->ZZE_CCAPRO

		BEGIN TRANSACTION

			/*
			If !Empty((cAliasCNX)->RECNO)
				DbSelectArea("CNX")
				CNX->(DbGoto((cAliasCNX)->RECNO))
				If RecLock("CNX",.F.)

					CNX_PREFIX	:= "AUT"
					CNX_NUMTIT  := cNumSe1
					CNX_BANCO   := MV_PAR01
					CNX_AGENCI  := MV_PAR02
					CNX_CONTA   := MV_PAR03

					CNX->(MsUnlock())

				Else
					MsgBox("Não foi possivel gerar o titulo solicitado, verifique com o Admnistrador","INFO")
					lRet := .F.
					DisarmTransaction()
				End If
				*/
				If RecLock("ZZE",.F.)

					cTit := cNumSe1

					ZZE_PREF    := "AUT"
					ZZE_CCAPRO 	:= ""
					ZZE_TITULO	:= cTit
					ZZE_BANCO   := MV_PAR01
					ZZE_AGENC   := MV_PAR02
					ZZE_CONTA   := MV_PAR03

					ZZE->(MsUnlock())

				Else
					lRet := .F.
					MsgBox("Não foi possivel gerar o titulo solicitado, verifique com o Admnistrador","INFO")
					DisarmTransaction()
				End If

				//Endif

				If lRet
					MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3)
				End If

				If lMsErroAuto
					lRet := .F.
					MOSTRAERRO()

				/*
				DbSelectArea("CNX")
				CNX->(DbGoto((cAliasCNX)->RECNO))
					If RecLock("CNX",.F.)

					CNX_PREFIX    := " "
					CNX_NUMTIT    := cNumSe1

					CNX->(MsUnlock())

					End If
				*/
					If RecLock("ZZE",.F.)

						cTit := cNumSe1

						ZZE_PREF    := ""
						ZZE_CCAPRO 	:= ""
						ZZE_TITULO	:= cTit

						ZZE->(MsUnlock())

					End If
					DisarmTransaction()

				Else
					//EXCLUSAO DO TITULO PROVISORIO
					DbSelectArea("SE1")
					SE1->( DbSetOrder(2) )
					If SE1->(MsSeek(xFilial("SE1")+ZZE->ZZE_FORNEC+ZZE->ZZE_LOJA+"ADT"+Alltrim(cNumTitAnt)+" "+"PR ") )
						RecLock("SE1",.F.)
						dbDelete()
						MsUnLock()
					Else

						MsgBox("Não foi possivel excluir o titulo provisório numero "+cNumTitAnt+" Contate o administrador do sistema.","INFO")
						lRet:=.F.
						//DisarmTransaction()

					Endif

				End If
				If lRet
					MsgBox("Para a Solicitao de Recebimento Antecipado Nro. "+ZZE->ZZE_NUMERO+" Foi gerado o titulo de nr. "+alltrim(cTit)+".",;
						"Titulo a receber gerado com sucesso","INFO")
				End If
			END TRANSACTION
		End If
		Return(Nil)

