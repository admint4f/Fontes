#Include "Protheus.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ PEDCIE   ³ Autor ³ Adriano Migoto       	³ Data ³18/06/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Pedido de Compras     / Aut. ENtrega   		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ T4F                           			 		  		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function PEDCIE1()

	Private cPerg	    := "LIBCI3"
	Private cTitulo	    := "Autorização de Pagamento"
	Private x           := 0

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 16/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	PutSx1(cPerg,"01","Ped.Compra:    ","","","mv_ch1","C",06,0,0,"G","","SC7","","","mv_par01","","","","","","","","","","","","","","","","",{"Informe o Pedido de Compras Inicial a ser","considerado no relatório."},{},{})
	//PutSx1(cPerg,"02","Até o Ped.Compras/Aut.Entrega ","","","mv_ch2","C",06,0,0,"G","","SC7","","","mv_par02","","","","","","","","","","","","","","","","",{"Informe o Pedido de Compras  Final  a ser","considerado no relatório."},{},{})
	PutSx1(cPerg,"02","Da Data            ","","","mv_ch2","D",08,0,0,"G","","   ","","","mv_par02","","","","","","","","","","","","","","","","",{"Informe a Data de Emissão Inicial a ser","considerado no relatório."},{},{})
	PutSx1(cPerg,"03","Até a Data       ","","","mv_ch3","D",08,0,0,"G","","   ","","","mv_par03","","","","","","","","","","","","","","","","",{"Informe a Data de Emissão  Final  a ser","considerado no relatório."},{},{})
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	If Pergunte(cPerg,.T.,"Impressão da Autorização de Pagamento")
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

	Private Li          := 0
	Private nPag        := 0
	Private oFtSublin	:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	Private oFtNegrito 	:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	Private oFtNormal	:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	Private oFtGrande	:= TFont():New("Arial",09,12,,.T.,,,,.T.,.F.)
	Private oFtMedia 	:= TFont():New("Arial",09,10,,.F.,,,,.T.,.F.)
	Private oFtMediaNeg	:= TFont():New("Arial",09,10,,.T.,,,,.T.,.F.)
	Private oFtItem1 	:= TFont():New("Arial",09,10,,.T.,,,,.T.,.F.)
	Private oFtItem2 	:= TFont():New("Arial",09,08,,.T.,,,,.T.,.F.)
	Private cTexto		:= ""
	Private oPen		:= TPen():New(,7,CLR_BLACK,oPrint)    
	Private xPedido		:= ""

	oPrint:=TMSPrinter():New( cTitulo )
	oPrint:SetLandScape()
	oPrint:Setup()

	MsgRun("Aguarde... Gerando as Autorizações de Pagamento...",,{|| CursorWait(), PCProc(oPrint,cTitulo) ,CursorArrow()})


	oPrint:Preview()

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
	Local OBS  := ""

	// SB1->(dbSetOrder(1))

	dbSelectArea("SC7")
	dbSetOrder(1)

	//Set filter to DTOS(SC7->C7_EMISSAO) > "20061231"

	dbSeek(xFilial("SC7")+mv_par01,.T.)

	oPrint:StartPage()

	//-> Imprime o Cabecalho

	PCCabec(oPrint,nPag,cTitulo)




	While !Eof()  .and. SC7->C7_NUM=MV_PAR01 //.and. SC7->C7_NUM <= mv_par02

		//If SC7->C7_NUM <> mv_par01                    //.Or. SC7->C7_NUM > mv_par02
		//	dbSkip()
		//	Loop
		//EndIf

		IF SC7->C7_DATPRF<mv_par02 .OR. SC7->C7_DATPRF>mv_par03
			DBSKIP()
			LOOP
		ENDIF


		numcot  := C7_NUMCOT
		condpag := C7_COND
		mennota := C7_MENNOTA
		justif  := C7_JUSTIF
		obs     := obs + " " + alltrim(C7_OBS)


		cPedido := SC7->C7_NUM

		//-> Imprime os Itens do Pedido de Compra
		xDesconto	:= xDesconto + C7_VLDESC
		xTotal      := XTOTAL + C7_TOTAL
		xTotPc      := XTOTPC + C7_TOTAL
		xTotIcm     := xTotIcm + C7_VALICM                                               

		oPrint:Say(Li+15 , 425,Transform(C7_QUANT,"@E 99,999"), oFtItem1 )       

		oPrint:Say(Li+15 , 550,C7_UM, oFtItem1 )

		oPrint:Say(Li+15 , 750, SUBSTR(C7_DESCRI,1,34), oFtItem1 )

		oPrint:Say(Li+15 ,1400,Transform(SC7->C7_PRECO,"@E 9,999,999.99"), oFtItem1 )

		oPrint:Say(Li+15 ,1685,Transform(SC7->C7_TOTAL,"@E 9,999,999.99"), oFtItem1 )

		oPrint:Say(Li+15 ,1950,  DTOC(SC7->C7_DATPRF), oFtItem1)

		oPrint:Say(Li+15 ,2150,SC7->C7_CC, oFtItem1 )

		//oPrint:Say(Li+15 ,1750,C7_CLVL, oFtItem1 )

		//oPrint:Say(Li+15 ,1900,C7_CONTA, oFtItem1 )
		//	oPrint:Say(Li+15 ,2150,C7_CONTAG, oFtItem1 )
		//DESCONTA := Posicione("CT1",1,xFilial("CT1")+C7_CONTA,"CT1_DESC01")		
		//	oPrint:Say(Li+15 ,2100,SUBSTR(DESCONTA,1,24), oFtItem1 )  //2400
		//	oPrint:Say(Li+15 ,2680,C7_ITEMCTA, oFtItem1 )  // 3015
		//	oPrint:Say(Li+15 ,3000,C7_CHAVE1, oFtItem2 )

		Li += 48


		IF SUBS(C7_CHAVE1,1,3) <> "999"                                      
			oPrint:Say(Li+15 , 025,C7_ARTISTA + " "  + C7_CASA + " " + C7_COMPLE1 + " " + C7_COMPLE2 + " " + C7_COMPLE3 + " " + C7_COMPLE4, oFtItem2 )   
			Li += 48
			X:=X+1

		ENDIF            

		X:=X+1
		If  X > 19
			oPrint:Say(Li ,025,"Continua..................", oFtItem1 )
			oPrint:EndPage()
			oPrint:StartPage()
			nPag ++
			Li := 30
			oPrint:Box(Li ,020, 300, 3300,oPen)
			IF SM0->M0_CGC == "00532511000154"
				oPrint:SayBitmap(55,90,xPath+"\l_vicar.bmp",400,200)
			ELSE			
				oPrint:SayBitmap(55,90,xPath+"\l_t4f.bmp",400,200)
			ENDIF

			Li += 48
			oPrint:Say(Li ,(3300-(Len(xRazao)	* 26)) / 2,xRazao 	 ,oFtGrande	)
			Li += 48
			oPrint:Say(Li ,(3300-(Len(xEnd) 	* 16)) / 2,xEnd	 ,oFtNormal	)
			Li += 48                                                
			oPrint:Say(Li ,(3300-(Len(xFone) 	* 16)) / 2,xFone	 ,oFtNormal	)
			Li += 48
			oPrint:Say(Li ,(3300-(Len(xCnpj) 	* 16)) / 2,xCnpj	 ,oFtNormal	)
			Li += 83
			oPrint:Box(Li,020, 368, 3300,oPen)
			Li += 5
			oPrint:Say(Li ,(3300-(Len(cPed)	* 16)) / 2,cPed	 ,oFtMediaNeg	)
			Li += 60
			oPrint:Box(Li ,020, 505, 3300,oPen)
			Li += 25
			oPrint:Box(Li ,020, 870, 3300,oPen)
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

			//oPrint:Say(Li+10 ,3150,"Analise", oFtItem1 )      
			//oPrint:Say(Li+10 ,2950,"Elem.Pep", oFtItem1 )
			//oPrint:Say(Li+10 ,2450,"Descrição Conta ", oFtItem1 )
			//oPrint:Say(Li+10 ,2150,"C.Gerencial", oFtItem1 )
			//oPrint:Say(Li+10 ,1950,"C.Fiscal", oFtItem1 )                 
			//	oPrint:Say(Li+10 ,1750,"DIV.", oFtItem1 )        


			oPrint:Say(Li+10 ,1950,"C.Custo", oFtItem1 )
			oPrint:Say(Li+10 ,1505,"Vlr. Total", oFtItem1 )
			oPrint:Say(Li+10 ,1220,"Vlr. Unit.", oFtItem1 )
			oPrint:Say(Li+10 , 670,"Produto", oFtItem1 )
			oPrint:Say(Li+10 , 370,"UM", oFtItem1 )
			oPrint:Say(Li+10 , 225,"Qtde.", oFtItem1 )
			oPrint:Say(Li+10 ,1700,"Pagamento", oFtItem1 )


			Li += 70
			X=0
		ENDIF


		//	oPrint:EndPage()

		dbSkip()

		xpedido := SC7->C7_NUM

		//    IF XPEDIDO <= MV_PAR02

	EndDo

	//IF xpedido <> cpedido 
	X:= 0
	Li += 50

	//-> Imprime Totais
	//-> Valor Total
	oPrint:Say(Li ,900,"Total.............R$", oFtItem1 )
	oPrint:Say(Li ,1685,Transform(xTotal,"@E 9,999,999.99"), oFtItem1 )
	xTotGe := xTotal


	LI +=50



	Li += 100               		                 


	oPrint:Say(Li ,1300,"______________________________________", oFtMedia )
	Li += 48

	oPrint:Say(Li ,1550,"Solicitante", oFtMedia )

	Li += 200

	IF XPEDIDO <= MV_PAR01
		oPrint:EndPage()   
		xDesconto	:= 0
		xTotal      := 0
		xTotPc      := 0
		xTotIcm     := 0        
		obs := " "
		cPedido := SC7->C7_NUM    
		numcot  := SC7->C7_NUMCOT
		condpag := SC7->C7_COND
		mennota := SC7->C7_MENNOTA
		justif  := SC7->C7_JUSTIF

		oPrint:StartPage()
		//PCCabec(oPrint,nPag,cTitulo)
		nPag ++
		Li := 30
		//--> Box do Cabecalho
		oPrint:Box(Li ,020, 300, 3300,oPen)
		//--> Tamanho da Figura 141x80 Pixels
		//		oPrint:SayBitmap(55,90,xPath+"\l_doc_cl.bmp",400,200) 


		IF SM0->M0_CGC == "00532511000154"
			oPrint:SayBitmap(55,90,xPath+"\l_vicar.bmp",400,200)
		ELSE			
			oPrint:SayBitmap(55,90,xPath+"\l_t4f.bmp",400,200)
		ENDIF

		//oPrint:SayBitmap(55,90,cPath+"\"+AllTrim(SM0->M0_LOGO),400,200)
		Li += 48
		oPrint:Say(Li ,(3300-(Len(xRazao)	* 26)) / 2,xRazao 	 ,oFtGrande	)
		Li += 48
		oPrint:Say(Li ,(3300-(Len(xEnd) 	* 16)) / 2,xEnd	 ,oFtNormal	)
		Li += 48                                                
		oPrint:Say(Li ,(3300-(Len(xFone) 	* 16)) / 2,xFone ,oFtNormal	)
		Li += 48
		oPrint:Say(Li ,(3300-(Len(xCnpj) 	* 16)) / 2,xCnpj ,oFtNormal	)
		Li += 83
		//--> Box do Numero do Pedido de Compras/Autorizacao de Entrega
		oPrint:Box(Li,020, 368, 3300,oPen)
		Li += 5
		oPrint:Say(Li ,(3300-(Len("LIBERAÇÃO DE DOCUMENTO P/ PAGAMENTO : " + xpedido )	* 16)) / 2,"LIBERAÇÃO DE DOCUMENTO P/ PAGAMENTO : " + xpedido	 ,oFtMediaNeg	)
		Li += 60
		//--> Box do Local de Entrega/Cobranca
		oPrint:Box(Li ,020, 505, 3300,oPen)
		Li += 25
		oPrint:Box(Li ,020, 870, 3300,oPen)
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

		oPrint:Say(Li+10 ,1950,"C.Custo", oFtItem1 )
		oPrint:Say(Li+10 ,1505,"Vlr. Total", oFtItem1 )
		oPrint:Say(Li+10 ,1220,"Vlr. Unit.", oFtItem1 )
		oPrint:Say(Li+10 , 670,"Produto", oFtItem1 )
		oPrint:Say(Li+10 , 370,"UM", oFtItem1 )
		oPrint:Say(Li+10 , 225,"Qtde.", oFtItem1 )
		oPrint:Say(Li+10 ,1700,"Pagamento", oFtItem1 )
		Li += 70

	endif
	//ENDIF

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

	Local cPicIE:= If(Len(AllTrim(SM0->M0_INSC))>8,"@R 999.999.999.999","@R 99.999.999")
	Public cPed  := ""

	Public xEnd  := AllTrim(SM0->M0_ENDCOB) + " - " + AllTrim(SM0->M0_CIDCOB) + " - " + SM0->M0_ESTCOB + " - CEP " + Transform(SM0->M0_CEPCOB,"@R 99999-999")
	Public xFone := "Fone (+55)" + Transform(SubStr(SM0->M0_TEL,3,10),"@R 99-9999-9999") + "  -  Fax (+55)" + Transform(SubStr(SM0->M0_FAX,3,10),"@R 99-9999-9999") + "  - www.t4f.com.br"
	Public xCnpj := "CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + "      I.E: " + Transform(SM0->M0_INSC,cPicIE)

	Public xRazao:= AllTrim(SM0->M0_NOMECOM)
	Public xPath	:= GetSrvProfString("Startpath","")


	//--> Titulo do Formulario


	cPed := "AUTORIZAÇÃO DE  PAGAMENTO : " + SC7->C7_NUM + " Contrato : "+SC7->C7_PARCERI

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

	//oPrint:SayBitmap(55,90,cPath+"\"+AllTrim(SM0->M0_LOGO),400,200)
	Li += 48
	oPrint:Say(Li ,(3300-(Len(xRazao)	* 26)) / 2,xRazao 	 ,oFtGrande	)
	Li += 48
	oPrint:Say(Li ,(3300-(Len(xEnd) 	* 16)) / 2,xEnd	 ,oFtNormal	)
	Li += 48                                                
	oPrint:Say(Li ,(3300-(Len(xFone) 	* 16)) / 2,xFone	 ,oFtNormal	)
	Li += 48
	oPrint:Say(Li ,(3300-(Len(xCnpj) 	* 16)) / 2,xCnpj	 ,oFtNormal	)
	Li += 83
	//--> Box do Numero do Pedido de Compras/Autorizacao de Entrega
	oPrint:Box(Li,020, 368, 3300,oPen)
	Li += 5
	oPrint:Say(Li ,(3300-(Len(cPed)	* 16)) / 2,cPed	 ,oFtMediaNeg	)
	Li += 60
	//--> Box do Local de Entrega/Cobranca
	oPrint:Box(Li ,020, 505, 3300,oPen)
	Li += 25

	oPrint:Say(Li ,0030,"Local de Entrega:" 	,oFtMediaNeg 	)
	oPrint:Say(Li ,0400,xEnd + " Filial " + xFilial("SC7"),oFtMedia 	)
	Li += 50
	oPrint:Say(Li ,0030,"Local de Cobrança:" 	,oFtMediaNeg 	)
	oPrint:Say(Li ,0400,xEnd           	    ,oFtMedia 	)
	Li += 65                                    



	//--> Box dos Dados do Fornecedor ****************************************************
	oPrint:Box(Li ,020, 870, 3300,oPen)
	Li += 15
	oPrint:Say(Li , 050,"Fornecedor", oFtMediaNeg )
	oPrint:Say(Li ,1500,"Condições de Pagamento:  " + AllTrim(Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")) 	,oFtMediaNeg )
	//oPrint:Say(Li ,1500,"Condições de Pagamento:  " + AllTrim(Posicione("SE4",1,xFilial("SE4")+CONDPAG,"E4_DESCRI")) 	,oFtMediaNeg )
	Li += 48
	oPrint:Say(Li , 050,SC7->C7_FORNECE + "/" + SC7->C7_LOJA + " . " + SA2->A2_NOME , oFtMedia )
	oPrint:Say(Li ,1500,"Mapa de Cotação:  " + SC7->C7_numcot 	,oFtMediaNeg )
	Li += 48
	oPrint:Say(Li , 050,SA2->A2_END + " " + SA2->A2_BAIRRO , oFtMedia )

	psworder(2)
	auser := pswret(1)
	cemail := alltrim(auser[1,14])

	oPrint:Say(Li ,1500,"Solicitante:  " + UsrRetName(SC7->C7_USER), oFtMediaNeg )
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

	//--> Sera montado inversamente, pois em Linux os Boxes nao sao transparentes 
	//--> NAO REFLETIRA NADA EM AMBIENTE WINDOWS


	oPrint:Box(Li ,020, 2325, 3300,oPen)                     
	//oPrint:Say(Li+10 ,3150,"Analise", oFtItem1 )      
	//oPrint:Say(Li+10 ,2950,"Elem.Pep", oFtItem1 )
	//oPrint:Say(Li+10 ,2450,"Descrição Conta ", oFtItem1 )
	//oPrint:Say(Li+10 ,2150,"C.Gerencial", oFtItem1 )

	//oPrint:Say(Li+10 ,1950,"C.Fiscal", oFtItem1 )                 

	//oPrint:Say(Li+10 ,1750,"DIV.", oFtItem1 )
	//-> C.Custo  
	//oPrint:Box(Li , 020, 950,2140,oPen)

	oPrint:Say(Li+10 ,2150,"C.Custo", oFtItem1 )
	//-> Valor Total
	//oPrint:Box(Li , 020, 950,1710,oPen)

	oPrint:Say(Li+10 ,1685,"Vlr. Total", oFtItem1 )
	//-> Precos Unitario
	//oPrint:Box(Li , 020, 950,1480,oPen)

	oPrint:Say(Li+10 ,1420,"Vlr. Unit.", oFtItem1 )
	//-> Produto e Descricao
	//oPrint:Box(Li , 020, 950,1250,oPen)

	oPrint:Say(Li+10 , 770,"Produto", oFtItem1 )
	//-> Unid. Medida
	//oPrint:Box(Li , 020, 950, 240,oPen)

	oPrint:Say(Li+10 , 550,"UM", oFtItem1 )
	//-> Qtde
	// oPrint:Box(Li , 020, 950, 150,oPen)

	oPrint:Say(Li+10 , 425,"Qtde.", oFtItem1 )

	oPrint:Say(Li+10 ,1900,"Pagamento", oFtItem1 )


	Li += 70
return

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


