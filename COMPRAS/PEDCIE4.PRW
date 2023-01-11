#Include "Protheus.Ch"
Static cPicIE, cPed, xEnd, xFone, xCnpj, xRazao, xPath

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ PEDCIE   ³ Autor ³ Marcos Justo        	³ Data ³03/02/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Pedido de Compras       			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CIE-BRASIL                           			 		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

// Alterado Takao 13/08/08 para tratar C7_FILENT
// Alterado Lotvs 13/11/2013 para tratamento de impressão de pedidos liberados
User Function PEDCIE4()

	Private cPerg	    := "LIBCI2"
	Private cTitulo	 := "Liberação de Pagamentos"
	Private x          := 0

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 16/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	PutSx1(cPerg,"01","Do Ped.Compras    ","","","mv_ch1","C",06,0,0,"G","","SC7","","","mv_par01","","","","","","","","","","","","","","","","",{"Informe o Pedido de Compras Inicial a ser","considerado no relatório."},{},{})
	PutSx1(cPerg,"02","Até o Ped.Compras/Aut.Entrega ","","","mv_ch2","C",06,0,0,"G","","SC7","","","mv_par02","","","","","","","","","","","","","","","","",{"Informe o Pedido de Compras  Final  a ser","considerado no relatório."},{},{})
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01            // Do Pedido de Compras                  ³
	//³ mv_par02            // Ate o Pedido de Compras               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Pergunte(cPerg,.T.,"Impressão da Liberação de Pagamentos")
		PCompImp()
	EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ PCompImp  ³ Autor ³ Marcos Justo         ³ Data ³03/02/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Processa a Impressao dos Pedidos de Compras                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PCompImp()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CIE-BRASIL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PCompImp()

	Local oPrint

	Public xTotPc    := 0
	Public xTotal    := 0
	Public xTotGe    := 0
	Public xDesconto := 0
	Public xtoticm   := 0

	Private Li            := 0
	Private nPag          := 0
	Private oFtSublin	  := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	Private oFtNegrito    := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	Private oFtNormal	  := TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	Private oFtGrande	  := TFont():New("Arial",09,12,,.T.,,,,.T.,.F.)
	Private oFtMedia 	  := TFont():New("Arial",09,10,,.F.,,,,.T.,.F.)
	Private oFtMediaNeg   := TFont():New("Arial",09,10,,.T.,,,,.T.,.F.)
	Private oFtItem1 	  := TFont():New("Arial",09,10,,.T.,,,,.T.,.F.)
	Private oFtItem2 	  := TFont():New("Arial",09,08,,.T.,,,,.T.,.F.)
	Private cTexto		  := ""
	Private oPen		  := TPen():New(,7,CLR_BLACK,oPrint)
	Private _lPrint		  := .T.

	oPrint:=TMSPrinter():New( cTitulo )

	If !oPrint:IsPrinterActive()
		oPrint:Setup()	// Escolhe a impressora
	Endif

	oPrint:SetLandScape()

	MsgRun("Aguarde... Gerando as Liberações de Pagamento...",,{|| CursorWait(), PCProc(oPrint,cTitulo) ,CursorArrow()})

	If _lPrint
		oPrint:Preview()
		//oPrint:Print()  // Novo
	EndIf

	//MS_FLUSH()

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ PCProc    ³ Autor ³ Marcos Justo         ³ Data ³03/02/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Processa a Impressao dos Pedidos de Compras                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PCProc(ExpO1,ExpC1)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 - Objeto da Impressao                                ³±±
±±³          ³ ExpC1 - Titulo do Relatorio                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CIE-BRASIL                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PCProc(oPrint,cTitulo)
	Local cCond   	:= ""
	Local cCC       := ""
	Local cInd    	:= ""
	Local cNomArq 	:= CriaTrab("",.F.)
	Local cNota     := ""
	Local cObs1     := ""
	Local cObs2     := ""
	Local cPedido   := ""
	Local nTipo     := 0
	Local nCount    := 0
	Local nFrete    := 0
	Local nDespesa  := 0
	Local nDesconto := 0
	Local nRegSC7   := 0
	Local nValicm   := 0
	Local nValipi   := 0
	Local nTotIpi   := 0
	Local nX
	Local OBS  		:= ""
	Local _lImp		:= .F.
	Local _aBloq	:= {}
	Local _cBloq	:= ""
	Local _nPos		:= 0
	Local _nI		:= 0
	Local _nPedidos	:= 0

	DbSelectArea("SC7")
	SC7->( DbSetOrder(1) )
	SC7->( DbSeek(xFilial("SC7")+mv_par01,.T.) )

	//If SC7->C7_CONAPRO == "L"
	//-> Imprime o Cabecalho
	oPrint:StartPage() // Inicia Pagina.  

	PCCabec(oPrint,nPag,cTitulo)
	//EndIf

	While SC7->( !Eof() )  .and. SC7->C7_NUM <= mv_par02

		If SC7->C7_NUM < mv_par01 .Or. SC7->C7_NUM > mv_par02
			DbSelectArea("SC7")
			SC7->( dbSkip() )
			Loop
		EndIf

		cPedido := SC7->C7_NUM

		//	If SC7->C7_CONAPRO == "L"

		_lImp	:= .T.	

		NumCot  := SC7->C7_NUMCOT
		CondPag := SC7->C7_COND
		MenNota := SC7->C7_MENNOTA
		Justif  := SC7->C7_JUSTIF
		Obs     := Obs + " " + Alltrim(SC7->C7_OBS)	

		//-> Imprime os Itens do Pedido de Compra
		xDesconto:= xDesconto + SC7->C7_VLDESC
		xTotal   := xTotal    + SC7->C7_TOTAL
		xTotPc   := xTotPC    + SC7->C7_TOTAL
		xTotIcm  := xTotIcm   + SC7->C7_VALICM

		oPrint:Say(Li+15 , 025,Transform(SC7->C7_QUANT,"@E 99,999"), oFtItem2 )
		oPrint:Say(Li+15 , 170,SC7->C7_UM, oFtItem2 )
		oPrint:Say(Li+15 , 270, SUBSTR(SC7->C7_DESCRI,1,34), oFtItem2 )
		oPrint:Say(Li+15 ,1000, Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_POSIPI"), oFtItem2 )
		oPrint:Say(Li+15 ,1348,Transform(SC7->C7_PRECO,"@E 99,999,999.99"), oFtItem2 )
		oPrint:Say(Li+15 ,1632,Transform(SC7->C7_TOTAL,"@E 99,999,999.99"), oFtItem2 )
		oPrint:Say(Li+15 ,1880,SC7->C7_CC, oFtItem2 )
		oPrint:Say(Li+15 ,2130,SC7->C7_CLVL, oFtItem2 )
		oPrint:Say(Li+15 ,2330,SC7->C7_CONTA, oFtItem2 )

		DesConta := Posicione("CT1",1,xFilial("CT1")+SC7->C7_CONTA,"CT1_DESC01")

		oPrint:Say(Li+15 ,2500,SUBSTR(DesConta,1,24), oFtItem2 )  //2400
		oPrint:Say(Li+15 ,2930,SC7->C7_ITEMCTA, oFtItem2 )  // 3015
		oPrint:Say(Li+15 ,3130,SC7->C7_CHAVE1, oFtItem2 )

		Li += 48

		If SUBS(SC7->C7_CHAVE1,1,3) <> "999"

			oPrint:Say(Li+15 , 025,SC7->C7_ARTISTA + " "  + SC7->C7_CASA + " " + SC7->C7_COMPLE1 + " " + SC7->C7_COMPLE2 + " " + SC7->C7_COMPLE3 + " " + SC7->C7_COMPLE4, oFtItem2 )
			Li += 48
			x ++

		EndIf

		x++

		If ( x > 19 )

			oPrint:Say(Li ,025,"Continua..................", oFtItem1 )


			oPrint:EndPage()   // Finaliza Pagina.
			oPrint:StartPage() // Inicia nova pagina

			nPag ++

			Li:= 30
			oPrint:Box(Li ,020, 300, 3300,oPen)

			IF SM0->M0_CGC == "00532511000154"
				oPrint:SayBitmap(55,90,xPath+"\l_vicar.bmp",400,200)
			Else
				oPrint:SayBitmap(55,90,xPath+"\l_t4f.bmp",400,200)
			EndIf

			Li += 48
			oPrint:Say(Li ,(3200-(Len(xRazao)	* 26)) / 2,xRazao 	 ,oFtGrande	)
			Li += 48
			oPrint:Say(Li ,(3200-(Len(xEnd) 	* 16)) / 2,xEnd	 ,oFtNormal	)
			Li += 48
			oPrint:Say(Li ,(3200-(Len(xFone) 	* 16)) / 2,xFone	 ,oFtNormal	)
			Li += 48
			oPrint:Say(Li ,(3200-(Len(xCnpj) 	* 16)) / 2,xCnpj	 ,oFtNormal	)
			Li += 83

			oPrint:Box(Li,020, 368, 3300,oPen)  
			Li += 5
			oPrint:Say(Li ,(3200-(Len(cPed)	* 16)) / 2,cPed	 ,oFtMediaNeg	)

			Li += 60
			oPrint:Box(Li ,020, 505, 3300,oPen) 

			Li += 25 
			oPrint:Box(Li ,020, 830, 3300,oPen)

			Li += 15
			oPrint:Say(Li , 050,"Fornecedor", oFtMediaNeg )
			oPrint:Say(Li ,1500,"Condições de Pagamento:  " + AllTrim(Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI")) 	,oFtMediaNeg )
			Li += 48
			oPrint:Say(Li , 050,SC7->C7_FORNECE + "/" + SC7->C7_LOJA + " . " + SA2->A2_NOME , oFtMedia )
			oPrint:Say(Li ,1500,"Mapa de Cotação:  " + numcot 	,oFtMediaNeg )
			Li += 48
			oPrint:Say(Li , 050,SA2->A2_END + " " + SA2->A2_BAIRRO , oFtMedia )

			psworder(2)
			auser := pswret(1)
			cemail := alltrim(auser[1,14])

			oPrint:Say(Li ,1500,"Solicitante:  " + SC7->C7_USUARIO, oFtMediaNeg )
			Li += 48
			oPrint:Say(Li , 050,SA2->A2_MUN + " CEP: " + Transform(SA2->A2_CEP,"@R 99999-999") + "   UF: " + SA2->A2_EST , oFtMedia )
			Li += 48
			oPrint:Say(Li , 050,"Fone: " + SA2->A2_TEL + If(!Empty(SA2->A2_FAX),"  Fax: " + SA2->A2_FAX,""), oFtMedia )
			oPrint:Say(Li ,1500,"Validador/Recebedor (Nome, Visto e data) :_________________________________________________  ", oFtMediaNeg )
			Li += 48
			oPrint:Say(Li , 050,"CNPJ/CPF: " + If(Len(SA2->A2_CGC)>11,Transform(SA2->A2_CGC,"@R 99.999.999/9999-99"),Transform(SA2->A2_CGC,"@E 999.999.999-99")) + "  IE : " + SA2->A2_INSCR , oFtMedia )
			Li += 48
			oPrint:Say(Li , 050,"Contato: " + SA2->A2_CONTATO , oFtMedia )
			oPrint:Say(Li ,1500,"Emissão : " + DtoC(SC7->C7_EMISSAO) + "       Hora : " + Time(),oFtMediaNeg	)

			Li += 63		
			oPrint:Box(Li ,020, 2325, 3300,oPen) 

			oPrint:Say(Li+10 ,3130,"Analise", oFtItem1 )
			oPrint:Say(Li+10 ,2930,"Elem.Pep", oFtItem1 )
			oPrint:Say(Li+10 ,2330,"Descrição Conta ", oFtItem1 )
			oPrint:Say(Li+10 ,2130,"C.Fiscal", oFtItem1 )
			oPrint:Say(Li+10 ,1880,"C.Custo", oFtItem1 )
			oPrint:Say(Li+10 ,1635,"Vlr. Total", oFtItem1 )
			oPrint:Say(Li+10 ,1350,"Vlr. Unit.", oFtItem1 )
			oPrint:Say(Li+10 ,1000,"NCM", oFtItem1 )
			oPrint:Say(Li+10 , 270,"Produto", oFtItem1 )
			oPrint:Say(Li+10 , 170,"UM", oFtItem1 )
			oPrint:Say(Li+10 , 025,"Qtde.", oFtItem1 )

			Li += 70
			X=0              

		EndIf	
		/*	Else
		_nPos := Ascan(_aBloq,{|x|x == SC7->C7_NUM })
		IF _nPos == 0
		Aadd(_aBloq, SC7->C7_NUM)
		EndIf
		EndIf*/

		SC7->( dbSkip() )

		xPedido := SC7->C7_NUM

		If xPedido <> cPedido 
			_nPedidos++

			If _lImp

				x:= 0
				Li += 50

				//-> Imprime Totais
				//-> Valor Total
				oPrint:Say(Li ,900,"Total.............R$", oFtItem1 )
				oPrint:Say(Li ,1285,Transform(xTotal,"@E 99,999,999.99"), oFtItem1 )
				xTotGe := xTotal

				Li += 48
				oPrint:Say(Li ,900,"Desconto..........R$", oFtItem1 )
				oPrint:Say(Li ,1285,Transform(xDesconto,"@E 9,999,999.99"), oFtItem1 )
				if xtoticm > 0
					oPrint:Say(Li ,1800,"Icms..............R$", oFtItem1 )
					oPrint:Say(Li ,2100,Transform(xtoticm,"@E 99,999.99"), oFtItem1 )
				endif
				xTotal -= xDesconto

				Li += 48
				oPrint:Say(Li ,900,"Total do Pedido...R$", oFtItem1 )
				oPrint:Say(Li ,1285,Transform(xTotal,"@E 99,999,999.99"), oFtItem1 )

				If SA2->A2_CP == "X"
					oPrint:Say(Li ,2450,"==>EXISTE CONTRATO DE PARCERIA<==", oFtItem1 )
				EndIf

				Li +=50;		oPrint:Say(Li ,025,Replicate("_",204), oFtItem2 )
				Li +=50;		oPrint:Say(Li ,025,"Observações           : " + obs , oFtItem2 )
				Li +=50;		oPrint:Say(Li ,025,"Historico             : " + substr(mennota,1,180) , oFtItem2 )
				Li +=50;		oPrint:Say(Li ,025,"Continuação Hist. : " +substr(mennota,181,180) , oFtItem2 )
				LI +=50;		oPrint:Say(Li ,025,"Justificativa    : " + justif, oFtItem1 )
				Li +=50;		oPrint:Say(Li ,025,Replicate("_",204), oFtItem2 )

				Li += 100

				oPrint:Say(Li , 400,"______________________________________", oFtMedia )
				oPrint:Say(Li ,1300,"______________________________________", oFtMedia )
				oPrint:Say(Li ,2300,"______________________________________", oFtMedia )

				Li += 48

				oPrint:Say(Li , 550,"- COMPRADOR -", oFtMedia )
				oPrint:Say(Li ,1550,"- GERÊNCIA -", oFtMedia )
				oPrint:Say(Li ,2550,"- DIRETORIA -", oFtMedia )

				Li += 200

				oPrint:EndPage()  // Finaliza Pagina.
			EndIf

			If ( xPedido <= MV_PAR02 ) //.And. SC7->C7_CONAPRO == "L"

				xDesconto	:= 0
				xTotal      := 0
				xTotPc      := 0
				xTotIcm     := 0

				Obs := " "
				cPedido := SC7->C7_NUM
				NumCot  := SC7->C7_NUMCOT
				CondPag := SC7->C7_COND
				MenNota := SC7->C7_MENNOTA
				Justif  := SC7->C7_JUSTIF

				oPrint:StartPage()   // Inicia Nova Pagina.

				// Reseta as variaveis cadastrais
				SetaFilial()

				nPag ++
				Li := 30                 


				//--> Box do Cabecalho
				oPrint:Box(Li ,020, 300, 3300,oPen) 

				//--> Tamanho da Figura 141x80 Pixels
				If SM0->M0_CGC == "00532511000154"
					oPrint:SayBitmap(55,90,xPath+"\l_vicar.bmp",400,200)
				Else
					oPrint:SayBitmap(55,90,xPath+"\l_t4f.bmp",400,200)
				EndIf

				Li += 48
				oPrint:Say(Li ,(3200-(Len(xRazao)	* 26)) / 2,xRazao 	 ,oFtGrande	)
				Li += 48
				oPrint:Say(Li ,(3200-(Len(xEnd) 	* 16)) / 2,xEnd	 ,oFtNormal	)
				Li += 48
				oPrint:Say(Li ,(3200-(Len(xFone) 	* 16)) / 2,xFone ,oFtNormal	)
				Li += 48
				oPrint:Say(Li ,(3200-(Len(xCnpj) 	* 16)) / 2,xCnpj ,oFtNormal	)
				Li += 83
				//--> Box do Numero do Pedido de Compras/Autorizacao de Entrega
				oPrint:Box(Li,020, 368, 3300,oPen) 

				Li += 5
				oPrint:Say(Li ,(3200-(Len("LIBERAÇÃO DE DOCUMENTO P/ PAGAMENTO : " + xpedido )	* 16)) / 2,"LIBERAÇÃO DE DOCUMENTO P/ PAGAMENTO : " + xpedido	 ,oFtMediaNeg	)
				Li += 60

				//--> Box do Local de Entrega/Cobranca
				oPrint:Box(Li ,020, 505, 3300,oPen)  
				Li += 25

				oPrint:Box(Li ,020, 830, 3300,oPen)
				Li += 15

				SA2->(dbSetOrder(1))
				SA2->(dbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA)))

				oPrint:Say(Li , 050,"Fornecedor", oFtMediaNeg )
				oPrint:Say(Li ,1500,"Condições de Pagamento:  " + AllTrim(Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")) 	,oFtMediaNeg )
				Li += 48
				oPrint:Say(Li , 050,SC7->C7_FORNECE + "/" + SC7->C7_LOJA + " . " + SA2->A2_NOME , oFtMedia )
				oPrint:Say(Li ,1500,"Mapa de Cotação:  " + SC7->C7_numcot 	,oFtMediaNeg )
				Li += 48
				oPrint:Say(Li , 050,SA2->A2_END + " " + SA2->A2_BAIRRO , oFtMedia )
				oPrint:Say(Li ,1500,"Solicitante:  " + SC7->C7_USUARIO, oFtMediaNeg )
				Li += 48
				oPrint:Say(Li , 050,SA2->A2_MUN + " CEP: " + Transform(SA2->A2_CEP,"@R 99999-999") + "   UF: " + SA2->A2_EST , oFtMedia )
				Li += 48
				oPrint:Say(Li , 050,"Fone: " + SA2->A2_TEL + If(!Empty(SA2->A2_FAX),"  Fax: " + SA2->A2_FAX,""), oFtMedia )
				oPrint:Say(Li ,1500,"Validador/Recebedor (Nome, Visto e data) :_________________________________________________  ", oFtMediaNeg )
				Li += 48
				oPrint:Say(Li , 050,"CNPJ/CPF: " + If(Len(SA2->A2_CGC)>11,Transform(SA2->A2_CGC,"@R 99.999.999/9999-99"),Transform(SA2->A2_CGC,"@E 999.999.999-99")) + "  IE : " + SA2->A2_INSCR , oFtMedia )
				Li += 48
				oPrint:Say(Li , 050,"Contato: " + SA2->A2_CONTATO , oFtMedia )
				oPrint:Say(Li ,1500,"Emissão : " + DtoC(SC7->C7_EMISSAO) + "       Hora : " + Time(),oFtMediaNeg	)
				Li += 63

				oPrint:Box(Li ,020, 2325, 3300,oPen)  

				oPrint:Say(Li+10 ,3130,"Analise", oFtItem1 )
				oPrint:Say(Li+10 ,2930,"Elem.Pep", oFtItem1 )
				oPrint:Say(Li+10 ,2330,"Descrição Conta ", oFtItem1 )
				oPrint:Say(Li+10 ,2130,"C.Fiscal", oFtItem1 )
				oPrint:Say(Li+10 ,1880,"C.Custo", oFtItem1 )    //-> C.Custo
				oPrint:Say(Li+10 ,1635,"Vlr. Total", oFtItem1 ) //-> Valor Total 
				oPrint:Say(Li+10 ,1350,"Vlr. Unit.", oFtItem1 ) //-> Precos Unitario
				oPrint:Say(Li+10 ,1000,"NCM", oFtItem1 )     //-> Produto e Descricao
				oPrint:Say(Li+10 , 270,"Produto", oFtItem1 )    //-> Produto e Descricao
				oPrint:Say(Li+10 , 170,"UM", oFtItem1 )         //-> Unid. Medida
				oPrint:Say(Li+10 , 025,"Qtde.", oFtItem1 )      //-> Qtde

				Li += 70

				/*		ElseIf ( xPedido <= MV_PAR02 ) .And. SC7->C7_CONAPRO <> "L" 
				_nPos := Ascan(_aBloq,{|x| x == SC7->C7_NUM })
				IF _nPos == 0
				Aadd(_aBloq, SC7->C7_NUM)
				EndIf */
			Endif

		EndIf

	EndDo

	If Len(_aBloq) > 0
		For _nI	:= 1 To Len(_aBloq)
			_cBloq	+= _aBloq[_nI] + CRLF
		Next _nI
		Aviso("Atenção","Não foi possível realizar a impressão de liberação de pagamento, devido ao bloqueio, para o(s) pedido(s):" + CRLF + _cBloq ,{"Ok"},3)
		If Len(_aBloq) == _nPedidos
			_lPrint	:= .F.
		EndIf
	EndIf

	dbSelectArea("SC7")
	RetIndex("SC7")
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PCCabec  ³ Autor ³ Marcos Justo   		³ Data ³07/12/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cabecaclho do Pedido de Compras                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PCCabec(ExpO1,ExpN1,ExpC1)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±³          ³ ExpN1 = Contador de paginas                                ³±±
±±³          ³ ExpC1 = Titulo                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CIE                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PCCabec(oPrint,nPag,cTitulo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o Arquivo de Empresa SM0 na Filial de entrega      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetaFilial()

	// Retorna SM0
	//dbSelectArea("SM0")
	//dbSetOrder(1)   // forca o indice na ordem certa
	//dbGoto(nRegistro)
	//dbSelectArea( cAlias )

	//--> Titulo do Formulario

	cPed := "LIBERAÇÃO DE DOCUMENTO P/ PAGAMENTO : " + SC7->C7_NUM

	//--> Posiciona no Fornecedor
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA)))

	nPag ++
	Li := 30
	//--> Box do Cabecalho
	oPrint:Box(Li ,020, 300, 3300,oPen) 
	//--> Tamanho da Figura 141x80 Pixels

	IF SM0->M0_CGC == "00532511000154"
		oPrint:SayBitmap(55,90,xPath+"\l_vicar.bmp",400,200)
	ELSE
		oPrint:SayBitmap(55,90,xPath+"\l_t4f.bmp",400,200)
	ENDIF

	Li += 48; oPrint:Say(Li ,(3200-(Len(xRazao)	* 26)) / 2,xRazao 	 ,oFtGrande	)
	Li += 48; oPrint:Say(Li ,(3200-(Len(xEnd) 	* 16)) / 2,xEnd	 ,oFtNormal	)
	Li += 48; oPrint:Say(Li ,(3200-(Len(xFone) 	* 16)) / 2,xFone	 ,oFtNormal	)
	Li += 48; oPrint:Say(Li ,(3200-(Len(xCnpj) 	* 16)) / 2,xCnpj	 ,oFtNormal	)


	//--> Box do Numero do Pedido de Compras/Autorizacao de Entrega
	Li += 83; oPrint:Box(Li,020, 368, 3300,oPen) 
	Li += 05; oPrint:Say(Li ,(3200-(Len(cPed)	* 16)) / 2,cPed	 ,oFtMediaNeg	)

	//--> Box do Local de Entrega/Cobranca                               
	Li += 60; oPrint:Box(Li ,020, 505, 3300,oPen)  
	//--> Box dos Dados do Fornecedor 
	Li += 25; oPrint:Box(Li ,020, 830, 3300,oPen)
	Li += 15; oPrint:Say(Li , 050,"Fornecedor", oFtMediaNeg )
	oPrint:Say(Li ,1500,"Condições de Pagamento:  " + AllTrim(Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")) 	,oFtMediaNeg )
	Li += 48; oPrint:Say(Li , 050,SC7->C7_FORNECE + "/" + SC7->C7_LOJA + " . " + SA2->A2_NOME , oFtMedia )
	oPrint:Say(Li ,1500,"Mapa de Cotação:  " + SC7->C7_numcot 	,oFtMediaNeg )
	Li += 48; oPrint:Say(Li , 050,SA2->A2_END + " " + SA2->A2_BAIRRO , oFtMedia )

	PswOrder(2)
	aUser := pswret(1)
	cEmail := alltrim(auser[1,14])

	oPrint:Say(Li ,1500,"Solicitante:  " + UsrRetName(SC7->C7_USER), oFtMediaNeg )
	Li += 48; oPrint:Say(Li , 050,SA2->A2_MUN + " CEP: " + Transform(SA2->A2_CEP,"@R 99999-999") + "   UF: " + SA2->A2_EST , oFtMedia )
	Li += 48; oPrint:Say(Li , 050,"Fone: " + SA2->A2_TEL + If(!Empty(SA2->A2_FAX),"  Fax: " + SA2->A2_FAX,""), oFtMedia )
	oPrint:Say(Li ,1500,"Validador/Recebedor (Nome, Visto e data) :_________________________________________________  ", oFtMediaNeg )
	Li += 48; oPrint:Say(Li , 050,"CNPJ/CPF: " + If(Len(SA2->A2_CGC)>11,Transform(SA2->A2_CGC,"@R 99.999.999/9999-99"),Transform(SA2->A2_CGC,"@E 999.999.999-99")) + "  IE : " + SA2->A2_INSCR , oFtMedia )
	Li += 48; oPrint:Say(Li , 050,"Contato: " + SA2->A2_CONTATO , oFtMedia )
	oPrint:Say(Li ,1500,"Emissão : " + DtoC(SC7->C7_EMISSAO) + "       Hora : " + Time(),oFtMediaNeg	)

	//--> Sera montado inversamente, pois em Linux os Boxes nao sao transparentes
	//--> NAO REFLETIRA NADA EM AMBIENTE WINDOWS
	Li += 63

	oPrint:Box(Li ,020, 2325, 3300,oPen)
	oPrint:Say(Li+10 ,3130,"Analise", oFtItem1 )
	oPrint:Say(Li+10 ,2930,"Elem.Pep", oFtItem1 )
	oPrint:Say(Li+10 ,2330,"Descrição Conta ", oFtItem1 )
	oPrint:Say(Li+10 ,2130,"C.Fiscal", oFtItem1 )
	oPrint:Say(Li+10 ,1880,"C.Custo", oFtItem1 )      //-> C.Custo
	oPrint:Say(Li+10 ,1635,"Vlr. Total", oFtItem1 )   //-> Valor Total
	oPrint:Say(Li+10 ,1350,"Vlr. Unit.", oFtItem1 )   //-> Precos Unitario
	oPrint:Say(Li+10 ,1000,"NCM", oFtItem1 )     	  //-> Pos. IPI/NCM
	oPrint:Say(Li+10 , 270,"Produto", oFtItem1 )     //-> Produto e Descricao
	oPrint:Say(Li+10 , 170,"UM", oFtItem1 )          //-> Unid. Medida
	oPrint:Say(Li+10 , 025,"Qtde.", oFtItem1 )       //-> Qtde

	Li += 70

Return

Static Function SetaFilial()

	aAreaAnt:= GetArea()
	aAreaSM0:= SM0->( GetArea() )

	// cAlias := Alias()
	DbSelectArea("SM0")
	SM0->( DbSetOrder(1) )   // forca o indice na ordem certa
	//nRegistro := SM0->( Recno() )
	SM0->( DbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT) )

	//Public cPicIE:= If(Len(AllTrim(SM0->M0_INSC))>8,"@R 999.999.999.999","@R 99.999.999")
	//Public cPed  := ""
	//Public xEnd  := AllTrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - " + SM0->M0_ESTCOB + " - CEP " + Transform(SM0->M0_CEPCOB,"@R 99999-999")
	//Public xFone := "Fone (+55)" + Transform(SubStr(SM0->M0_TEL,3,10),"@R 99-9999-9999") + "  -  Fax (+55)" + Transform(SubStr(SM0->M0_FAX,3,10),"@R 99-9999-9999") + "  - www.t4f.com.br"
	//Public xCnpj := "CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + "      I.E: " + Transform(SM0->M0_INSC,cPicIE)
	//Public xRazao:= AllTrim(SM0->M0_NOMECOM)
	//Public xPath := GetSrvProfString("Startpath","")

	cPicIE:= If(Len(AllTrim(SM0->M0_INSC))>8,"@R 999.999.999.999","@R 99.999.999")
	cPed  := ""
	xEnd  := AllTrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - " + SM0->M0_ESTCOB + " - CEP " + Transform(SM0->M0_CEPCOB,"@R 99999-999")
	xFone := "Fone (+55)" + Transform(SubStr(SM0->M0_TEL,3,10),"@R 99-9999-9999") + "  -  Fax (+55)" + Transform(SubStr(SM0->M0_FAX,3,10),"@R 99-9999-9999") + "  - www.t4f.com.br"
	xCnpj := "CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + "      I.E: " + Transform(SM0->M0_INSC,cPicIE)
	xRazao:= AllTrim(SM0->M0_NOMECOM)
	xPath := GetSrvProfString("Startpath","")

	// Restaura area anterior.
	SM0->( RestArea( aAreaSM0 ) )
	RestArea(aAreaAnt)

Return


//**************************************************************************
//**************************************************************************
//********************** FILTRA ITENS PC                       *************
//**************************************************************************
//**************************************************************************
Static Function FILTRA(cpedido)

	// Local aarea := getarea()

	Public aNota := {}
	Public xTotPc    := 0
	Public xTotal    := 0
	Public xTotGe    := 0
	Public xDesconto := 0


	Private cAliasTRB := AllTrim("SC7SC") + xFilial("SC7")


	cQuery := "Select C7_NUM ,C7_MENNOTA,C7_NUMCOT,C7_JUSTIF,C7_EMISSAO,C7_QUANT,C7_DESCRI,C7_PRECO,C7_TOTAL,C7_CC,C7_CLVL,C7_CONTA,C7_CONTAG,C7_ITEMCTA,C7_CHAVE1,C7_UM,C7_VLDESC,C7_ITEM"
	cQuery += "From " + RetSqlName("SC7") + " "
	cQuery += "Where C7_FILIAL     = '" + xFilial("SC7") + "' "
	cQuery += "  AND C7_ENCER <> 'E'"
	cQuery += "  And D_E_L_E_T_     = ' '"
	//cQuery += "Order By C7_ITEM"

	cQuery := ChangeQuery(cQuery)
	MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

	dbSelectArea(cAliasTRB)
	dbGoTop()
	While !EOF()

		if C7_NUM <> cPedido
			dbSkip()
			Loop
		endif

		xDesconto	:= xDesconto + C7_VLDESC
		xTotal      := XTOTAL + C7_TOTAL
		xTotPc      := XTOTPC + C7_TOTAL

		Public   mennota := C7_MENNOTA
		Public   justif  := C7_JUSTIF

		aAdd(aNota, { C7_NUM,C7_MENNOTA,C7_NUMCOT,C7_JUSTIF,C7_EMISSAO,C7_QUANT,C7_DESCRI,C7_PRECO,C7_TOTAL,C7_CC,C7_CLVL,C7_CONTA,C7_CONTAG,C7_ITEMCTA,C7_CHAVE1,C7_UM,C7_ITEM  })
		dbSkip()
	Enddo
	(cAliasTRB)->(dbCloseArea())


	dbSelectarea("SC7")

Return
