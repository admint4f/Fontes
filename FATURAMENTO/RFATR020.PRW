#INCLUDE "Protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR020 ºAutor  ³Bruno Daniel Borges º Data ³  09/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Impressao da NF de Debito da T4F                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteraco  ³03-09-2009 Ronald Piscioneri:                               º±±
±±º          ³Remocao do site da moldura da Nota de Debito.               º±±
±±º          ³Pesquisa descricao do produto no PV, se nao achar, pega do  º±±
±±º          ³cadastro de produtos.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RFATR020()
	
	Local aSays 	:= {}
	Local aButtons 	:= {}
	Local aPergs	:= {}
	Local nOpca		:= 0

	Public oPrint		:= Nil
	Public lTrt01		:= ( SuperGetMV("T4F_RFTR20",,"S") == "S" ) // Remove site (www...) da moldura da ND?
	Public cFilSC6		:= xFilial("SC6")
	Public cFilSB1		:= xFilial("SB1")
	Public cFilSF2		:= xFilial("SF2")
	Public cFilSE1		:= xFilial("SE1")
	Public cFilSA1		:= xFilial("SA1")
	Public cFilSD2		:= xFilial("SD2")
	Public cFilSC5		:= xFilial("SC5")
	Public oFonte1		:= TFont():New("Tahoma",,10)
	Public oFonte2		:= TFont():New("Tahoma",,10,,.T.)
	Public oFonte3		:= TFont():New("Tahoma",,8,,.T.)
	Public cLogoCasa	:= "LOGO_CASA_"+SM0->M0_CODIGO+"_"+SM0->M0_CODFIL+".BMP"
	Public aCondPagto	:= {}
	Public aMensagem 	:= {}
	Public aAtuArea		:= {}
	Public aSC6Area		:= {}
	Public aSB1Area		:= {}
	Public cDescProd	:= ""
	Public nLinha		:= 0

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	Aadd(aPergs,{"RFATR2","01","Da Serie"		   ,"mv_ch1"	,"C",03,00,"G","","mv_par01","","","","","","",""})
	Aadd(aPergs,{"RFATR2","02","Ate a Serie"	   ,"mv_ch2"	,"C",03,00,"G","","mv_par02","","","","","","",""})
	Aadd(aPergs,{"RFATR2","03","Da NF"			   ,"mv_ch3"	,"C",09,00,"G","","mv_par03","","","","","","",""})
	Aadd(aPergs,{"RFATR2","04","Ate a NF"		   ,"mv_ch4"	,"C",09,00,"G","","mv_par04","","","","","","",""})
	Aadd(aPergs,{"RFATR2","05","Da Emissao"		,"mv_ch5"	,"D",08,00,"G","","mv_par05","","","","","","",""})
	Aadd(aPergs,{"RFATR2","06","Ate a Emissao"	,"mv_ch6"	,"D",08,00,"G","","mv_par06","","","","","","",""})
	ValidSX1(aPergs)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	


	Pergunte("RFATR2",.F.)

	AADD(aSays, "[NOTA DE DÉBITO]" )
	AADD(aSays, "Rotina de impressão da nota de débito da T4F conforme" )
	AADD(aSays, "faturamento de pedidos de venda" )
	AADD(aSays, "" )

	AADD(aButtons, { 5,.T.,{|| Pergunte("RFATR2",.T. ) } } )
	AADD(aButtons, { 1,.T.,{|| nOpca:= 1, FechaBatch() }} )
	AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( "Geração de Nota de Débito" , aSays, aButtons,,240,405 )

	If nOpca == 0
		Return(Nil)
	EndIf

	Processa({|| RFATR020_Prc() })

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR020_PrcºAutor  ³Bruno Daniel Borges º Data ³  09/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de processamento da impressao da Nota de Debito        º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFATR020_Prc()
	Local cQuery		:= ""
	Local cObs			:= ""
	Local nTotReg		:= 0
	//Local nLinha		:= 0
	Local nTotal		:= 0
	Local bQuery		:= {|| Iif(Select("TRB") > 0, TRB->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbGoTop()), TRB->(dbEval({|| nTotReg++ })), TRB->(dbGoTop()) }
	//Local oPrint		:= Nil
	//Local oFonte1		:= TFont():New("Tahoma",,10)
	//Local oFonte2		:= TFont():New("Tahoma",,10,,.T.)
	//Local oFonte3		:= TFont():New("Tahoma",,8,,.T.)
	//Local cLogoCasa	:= "LOGO_CASA_"+SM0->M0_CODIGO+"_"+SM0->M0_CODFIL+".BMP"
	//Local aCondPagto	:= {}
	//Local aMensagem 	:= {}
	//Local aAtuArea		:= {}
	//Local aSC6Area		:= {}
	//Local aSB1Area		:= {}
	//Local cDescProd	:= ""
	//Local lTrt01		:= ( SuperGetMV("T4F_RFTR20",,"S") == "S" ) // Remove site (www...) da moldura da ND?
	//Local cFilSC6		:= xFilial("SC6")
	//Local cFilSB1		:= xFilial("SB1")
	//Local cFilSF2		:= xFilial("SF2")
	//Local cFilSE1		:= xFilial("SE1")
	//Local cFilSA1		:= xFilial("SA1")
	//Local cFilSD2		:= xFilial("SD2")
	//Local cFilSC5		:= xFilial("SC5")
	Local i

	//Busca as NFs geradas como NFs de Debito
	cQuery := " SELECT SF2.R_E_C_N_O_ AS REGNO FROM " + RetSQLName("SF2") + " SF2 "
	cQuery += " WHERE F2_FILIAL = '" + cFilSF2 + "' AND "
	cQuery += "       F2_EMISSAO BETWEEN '" + DToS(mv_par05) + "' AND '" + DToS(mv_par06) + "' AND "
	cQuery += "       F2_SERIE BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND "
	cQuery += "       F2_DOC BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
	cQuery += "       SF2.D_E_L_E_T_ = ' ' "
	LjMsgRun("Aguarde, buscando notas de débito...","Aguarde...",bQuery)

	ProcRegua(nTotReg)

	If nTotReg <= 0
		MsgAlert("Atenção, nenhuma informação foi localizada com os parâmetros informados.")
		Return(Nil)
	EndIf

	nLinha := 3000
	//Criacao do objeto de impressao
	oPrint := TMSPrinter():New("Nota de Débito")
	oPrint:EndPage()
	oPrint:StartPage()

	While TRB->(!Eof())
		IncProc("Imprimindo...")

		if nLinha >2300
			ImpCabec() 
		endif


		//Lista os itens da NF
		dbSelectArea("SD2")
		SD2->(dbSetOrder(3))
		SD2->(dbSeek(cFilSD2+SF2->F2_DOC+SF2->F2_SERIE))
		cObs 		:= ""
		aMensagem 	:= {"","",""}
		While SD2->(!Eof()) .And. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE == cFilSF2+SF2->F2_DOC+SF2->F2_SERIE

			//------------------------------------------------------------------------------------------------------
			//Busca Descricao do Produto, primeiro no Pedido de Vendas, e se nao tiver, pega do cadastro de produtos
			//------------------------------------------------------------------------------------------------------
			aAtuArea		:= GetArea()
			aSC6Area		:= SC6->(GetArea())
			aSB1Area		:= SB1->(GetArea())
			cDescProd	:= ""
			dbSelectArea("SC6")
			SC6->(dbSetOrder(1)) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			If SC6->(dbSeek(cFilSC6+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
				cDescProd := Alltrim(SC6->C6_DESCRI)
			EndIf
			If Empty(cDescProd)
				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))//B1_FILIAL+B1_COD
				If SB1->(dbSeek(cFilSB1+SD2->D2_COD))
					cDescProd := Alltrim(SB1->B1_DESC)
				EndIf
			EndIf
			RestArea(aSC6Area)
			RestArea(aSB1Area)
			RestArea(aAtuArea)

			oPrint:Say(nLinha,100,AllTrim(Capital(cDescProd)),oFonte1)
			oPrint:Say(nLinha,1900,"R$ " + Transform(SD2->D2_TOTAL,"@E 999,999,999.99"),oFonte1)
			nLinha += 65
			nTotal += SD2->D2_TOTAL

			if nLinha >2300
				oPrint:EndPage()
				oPrint:StartPage()
				ImpCabec()
			endif
			//Testa se existe mensagens nos itens do pedido de venda
			dbSelectArea("SC6")
			SC6->(dbSetOrder(1))
			If SC6->(dbSeek(cFilSC6+SD2->D2_PEDIDO+SD2->D2_ITEMPV ))
				If !Empty(SC6->C6_COMPLE1)
					oPrint:Say(nLinha,100,AllTrim(Capital(SC6->C6_COMPLE1)),oFonte1)
					nLinha += 65
				EndIf

				If !Empty(SC6->C6_COMPLE2)
					oPrint:Say(nLinha,100,AllTrim(Capital(SC6->C6_COMPLE2)),oFonte1)
					nLinha += 65
				EndIf

				If !Empty(SC6->C6_COMPLE3)
					oPrint:Say(nLinha,100,AllTrim(Capital(SC6->C6_COMPLE3)),oFonte1)
					nLinha += 65
				EndIf
				if nLinha >2300
					oPrint:EndPage()
					oPrint:StartPage()
					ImpCabec()
				endif

			EndIf

			//Busca mensagem do pedido de venda
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(dbSeek(cFilSC5+SD2->D2_PEDIDO)) .And. (!Empty(SC5->C5_MENNOTA) .Or. !Empty(SC5->C5_MENS1) .Or. !Empty(SC5->C5_MENS2) .Or. !Empty(SC5->C5_MENS3) )
				aMensagem[1] := SC5->C5_MENS1
				aMensagem[2] := SC5->C5_MENS2
				aMensagem[3] := SC5->C5_MENS3
			EndIf

			/*
			If Empty(cObs)
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			If SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)) .And. (!Empty(SC5->C5_MENNOTA) .Or. !Empty(SC5->C5_MENS1) .Or. !Empty(SC5->C5_MENS2) .Or. !Empty(SC5->C5_MENS3) )
			cObs := AllTrim(AllTrim(SC5->C5_MENNOTA) + " " +AllTrim(SC5->C5_MENS1) + " " + AllTrim(SC5->C5_MENS2) + " " + AllTrim(SC5->C5_MENS3))
			EndIf
			EndIf
			*/

			SD2->(dbSkip())
		EndDo

		If ChkQtdParc() > 1  // Gilberto: 19/08/2010 -> Solicitado por Sandro (RJ) para nao ser redundante quando for parcela unica.

			If SC5->C5_PARC1 <> 0
				oPrint:Say(nLinha,100,"Parcela: 1  Vencto.: " + DToC(SC5->C5_DATA1) + " Valor: R$ " + transform (SC5->C5_PARC1,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARC2 <> 0
				oPrint:Say(nLinha,100,"Parcela: 2  Vencto.: " + DToC(SC5->C5_DATA2) + " Valor: R$ " + transform (SC5->C5_PARC2,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARC3 <> 0
				oPrint:Say(nLinha,100,"Parcela: 3  Vencto.: " + DToC(SC5->C5_DATA3) + " Valor: R$ " + transform (SC5->C5_PARC3,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARC4 <> 0
				oPrint:Say(nLinha,100,"Parcela: 4  Vencto.: " + DToC(SC5->C5_DATA4) + " Valor: R$ " + transform (SC5->C5_PARC4,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARC5 <> 0
				oPrint:Say(nLinha,100,"Parcela: 5  Vencto.: " + DToC(SC5->C5_DATA5) + " Valor: R$ " + transform (SC5->C5_PARC5,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARC6 <> 0
				oPrint:Say(nLinha,100,"Parcela: 6  Vencto.: " + DToC(SC5->C5_DATA6) + " Valor: R$ " + transform (SC5->C5_PARC6,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARC7 <> 0
				oPrint:Say(nLinha,100,"Parcela: 7  Vencto.: " + DToC(SC5->C5_DATA7) + " Valor: R$ " + transform (SC5->C5_PARC7,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARC8 <> 0
				oPrint:Say(nLinha,100,"Parcela: 8  Vencto.: " + DToC(SC5->C5_DATA8) + " Valor: R$ " + transform (SC5->C5_PARC8,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARC9 <> 0
				oPrint:Say(nLinha,100,"Parcela: 9  Vencto.: " + DToC(SC5->C5_DATA9) + " Valor: R$ " + transform (SC5->C5_PARC9,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARCA <> 0
				oPrint:Say(nLinha,100,"Parcela: 10 Vencto.: " + DToC(SC5->C5_DATAA) + " Valor: R$ " + transform (SC5->C5_PARCA,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARCB <> 0
				oPrint:Say(nLinha,100,"Parcela: 11 Vencto.: " + DToC(SC5->C5_DATAB) + " Valor: R$ " + transform (SC5->C5_PARCB,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			If SC5->C5_PARCC <> 0
				oPrint:Say(nLinha,100,"Parcela: 12 Vencto.: " + DToC(SC5->C5_DATAC) + " Valor: R$ " + transform (SC5->C5_PARCC,"@E 999,999,999.99"),oFonte1)
				nLinha += 65
			EndIf
			if nLinha >2300
				oPrint:EndPage()
				oPrint:StartPage()
				ImpCabec()
			endif

		EndIf

		If SC5->C5_PARC1 = 0
			aCondPagto := Condicao(SF2->F2_VALMERC,SF2->F2_COND,,SF2->F2_EMISSAO)
			// Gilberto: 19/08/2010-> Solicitado por Sandro (RJ) para nao ser redundante quando for parcela unica.
			If Len(aCondPagto) > 1 
				For i := 1 To Len(aCondPagto)
					oPrint:Say(nLinha,100,"Parcela: " + AllTrim(Str(i)) + " Vencto.: " + DToC(aCondPagto[i,1]) + " Valor: R$ " + transform (aCondPagto[i,2],"@E 999,999,999.99"),oFonte1)//(SC5->C5_PARC1,"@E 999,999,999.99"),oFonte1)//(SF2->F2_VALMERC,"@E 999,999,999.99"),oFonte1)
					nLinha += 65
				Next i
			EndIf
		Endif

		nLoop := 1
		For i := 1 To 3
			oPrint:Say(2300+(nLoop*50),340,aMensagem[i],oFonte1)
			nLoop++
		Next i
		aMensagem 	:= {"","",""}

		/*
		If !Empty(cObs)
		If Len(cObs) > 90
		nLoop := 1
		For i := 1 To Len(cObs) Step 90
		oPrint:Say(2300+(nLoop*50),340,SubStr(cObs,i,90),oFonte1)

		If nLoop == 3
		Exit
		EndIf
		nLoop++
		Next i
		Else
		oPrint:Say(2350,340,cObs,oFonte1)
		EndIf
		EndIf
		*/

		oPrint:Say(2650,2000,"R$ " + Transform(nTotal,"@E 999,999,999.99"),oFonte1)
		oPrint:EndPage()

		nTotal := 0    //moises 0811
		nLinha := 3000 //moises 0811
		TRB->(dbSkip())
	EndDo

	oPrint:Preview()

Return(Nil)

Static Function ChkQtdParc()
	Local uGetArea:= GetArea()
	Local x, nPos
	Local nCont:= 0       
	Local cInd:= "0"
	For x:= 1 to 24   

		cInd:= Soma1(cInd,1)
		nPos := FieldPos( "C5_PARC" + cInd )

		If nPos > 0 
			If &("SC5->C5_PARC"+cInd) > 0 
				nCont ++
			EndIf	 
		Else
			Exit  // Forca a saida pois eh desnecessario continuar verificando ate as 24 parcelas   
		EndIf         

	Next      
	RestArea(uGetArea)
Return( nCont)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidSX1 ºAutor  ³Bruno Daniel Borges º Data ³  22/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que valida as perguntas do SX1 e cria os novos regis-º±±
±±º          ³tros                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidSX1(aPergunt)
	Local aAreaBKP := GetArea()
	Local cGrpPerg := ""
	Local lTipLocl := .T.
	Local i
	Local nTamX1

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	SX1->(dbGoTop())

	If Len(aPergunt) <= 0
		Return(Nil)
	EndIf
	nTamX1:= Len(SX1->X1_GRUPO)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida as perguntas do usuario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cGrpPerg := PadR(aPergunt[1,1],nTamX1)
	For i := 1 To Len(aPergunt)
		lTipLocl := !SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))
		SX1->(RecLock("SX1",lTipLocl))
		SX1->X1_GRUPO		:= padr(cGrpPerg,nTamX1)
		SX1->X1_ORDEM		:= aPergunt[i,2]
		SX1->X1_PERGUNT		:= aPergunt[i,3]
		SX1->X1_PERSPA		:= aPergunt[i,3]
		SX1->X1_PERENG		:= aPergunt[i,3]
		SX1->X1_VARIAVL		:= aPergunt[i,4]
		SX1->X1_TIPO		:= aPergunt[i,5]
		SX1->X1_TAMANHO		:= aPergunt[i,6]
		SX1->X1_DECIMAL		:= aPergunt[i,7]
		SX1->X1_GSC			:= aPergunt[i,8]
		SX1->X1_VALID		:= aPergunt[i,09]
		SX1->X1_VAR01		:= aPergunt[i,10]
		SX1->X1_DEF01		:= aPergunt[i,11]
		SX1->X1_DEF02		:= aPergunt[i,12]
		SX1->X1_DEF03		:= aPergunt[i,13]
		SX1->X1_DEF04		:= aPergunt[i,14]
		SX1->X1_DEF05		:= aPergunt[i,15]
		SX1->X1_F3			:= aPergunt[i,16]
		SX1->X1_PICTURE		:= aPergunt[i,17]
		SX1->(MsUnlock())
	Next i
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	RestArea(aAreaBKP)

Return(Nil)

//*************************
Static Function ImpCabec()
	//*************************

	dbSelectArea("SF2")
	SF2->(dbGoTo(TRB->REGNO))

	//Impressao da MOLDURA do Relatorio
	oPrint:StartPage()
	If lTrt01
		If AllTRim(SF2->F2_SERIE) == "RL"
			oPrint:SayBitMap(000,050, "MOLDURA_NOTA_DEBITO_SEM_WWW_RL_"+SM0->M0_CODIGO+".BMP",2300, 2800)
		Else
			oPrint:SayBitMap(000,050, "MOLDURA_NOTA_DEBITO_SEM_WWW_"+SM0->M0_CODIGO+".BMP",2300, 2800)
		EndIf
	Else
		If AllTRim(SF2->F2_SERIE) == "RL"
			oPrint:SayBitMap(000,050, "MOLDURA_NOTA_DEBITO_RL_"+SM0->M0_CODIGO+".BMP",2300, 2800)
		Else
			oPrint:SayBitMap(000,050, "MOLDURA_NOTA_DEBITO_"+SM0->M0_CODIGO+".BMP",2300, 2800)
		EndIf
	EndIf
	//oPrint:SayBitMap(010,2000,cLogoCasa,350,270)

	//Impressao do cabecalho do documento
	//oPrint:Say(300,730,AllTrim(Capital(SM0->M0_NOMECOM)),oFonte1)
	//oPrint:Say(300,730,AllTrim(SM0->M0_NOMECOM),oFonte1)


	cNomeEmp:= ''
	cNome:= SM0->M0_NOMECOM
	While ( nC:= At(" ",cNome) ) > 0
		cNomeEmp+= Capital( Alltrim(Subs(cNome,1,nC)) )+" "
		cNome:= Alltrim( Substr(cNome,nC,Len(cNome)) )
	End-While
	If Len(cNome) > 0
		cNomeEmp+= cNome
	EndIf

	oPrint:Say(300,730,AllTrim(cNomeEmp),oFonte1)

	oPrint:Say(350,730,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),oFonte1)
	oPrint:Say(400,730,Transform(SM0->M0_INSC,"@R 999.999.999.999"),oFonte1)
	oPrint:Say(450,730,Capital(AllTrim(SM0->M0_ENDCOB)),oFonte1)
	If cEmpAnt != "09"
		oPrint:Say(500,730,AllTrim(Capital(SM0->M0_CIDCOB)) + " / " + AllTrim(Capital(SM0->M0_ESTCOB)),oFonte1)
	EndIf
	//	oPrint:Say(600,730,AllTrim(Capital(SM0->M0_ESTCOB)),oFonte1)

	//oPrint:Say(550,730,Iif(SM0->M0_CODIGO == "08","http://www.t4f.com.br","http://www.stockcar.com.br"),oFonte1)

	If Len(SF2->F2_DOC) > 6
		oPrint:Say(405,2100,Transform(SF2->F2_DOC,"@R 999.999.999"),oFonte3)
	Else
		oPrint:Say(405,2100,Transform(SF2->F2_DOC,"@R 999.999"),oFonte3)
	EndIf
	oPrint:Say(550,1445,DToC(SF2->F2_EMISSAO),oFonte2)

	//Busca os dados do vencimento
	dbSelectArea("SE1")
	SE1->(dbSetOrder(1))
	If SE1->(dbSeek(cFilSE1+SF2->F2_PREFIXO+SF2->F2_DUPL))
		oPrint:Say(550,1795,DToC(SE1->E1_VENCREA),oFonte2)
	EndIf

	//Busca dados do contrato caso exista
	dbSelectArea("SC6")
	SC6->(dbSetOrder(4))
	If SC6->(dbSeek(cFilSC6+SF2->F2_DOC+SF2->F2_SERIE)) .And. SC6->C6__CONTRA > 0
		dbSelectArea("ZZ0")
		ZZ0->(dbGoTo(SC6->C6__CONTRA))
		oPrint:Say(550,2155,AllTrim(ZZ0->ZZ0_CONTRA),oFonte2)
	EndIf

	//Dados do cliente
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(cFilSA1+SF2->F2_CLIENTE+SF2->F2_LOJA))
	oPrint:Say(675,500,AllTrim(Capital(SA1->A1_NOME)),oFonte1)
	oPrint:Say(725,500,AllTrim(Capital(SA1->A1_END)),oFonte1)
	oPrint:Say(775,500,Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFonte1)
	oPrint:Say(775,1390,Capital(SA1->A1_MUN),oFonte1)
	oPrint:Say(775,1820,SA1->A1_EST,oFonte1)
	oPrint:Say(775,2100,Transform(SA1->A1_CEP,"@R 99999-999"),oFonte1)
	oPrint:Say(850,500,AllTrim(Capital(Iif(Empty(SA1->A1_ENDCOB),SA1->A1_END,SA1->A1_ENDCOB))),oFonte1)
	oPrint:Say(850,1390,AllTrim(SA1->A1_TEL),oFonte1)
	oPrint:Say(850,1820,AllTrim(Iif(Empty(SA1->A1_ESTC),SA1->A1_EST,SA1->A1_ESTC)),oFonte1)
	oPrint:Say(850,2090,Transform(Iif(Empty(SA1->A1_CEPC),SA1->A1_CEP,SA1->A1_CEPC),"@R 99999-999"),oFonte1)
	oPrint:Say(900,500,SA1->A1_INSCR,oFonte1)
	oPrint:Say(900,1430,Capital(Iif(!Empty(SA1->A1_MUNC),SA1->A1_MUNC,SA1->A1_MUN)),oFonte1)
	oPrint:Say(900,2000,Capital(Iif(!Empty(SA1->A1_BAIRROC),SA1->A1_BAIRROC,SA1->A1_BAIRRO)),oFonte1)

	nLinha 	:= 1050
	nTotal	:= 0
