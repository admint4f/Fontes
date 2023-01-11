#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA010 บAutor  ณBruno Daniel Borges บ Data ณ  24/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manutencao na forma de apropriacao de contratos   บฑฑ
ฑฑบ          ณde parceria com fornecedores                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA010(cContrato)
	
	Local aAreaBKP		:= GetArea()
	Local aHead1		:= {}
	Local aCols1		:= {} 
	Local aCoordenadas	:= MsAdvSize(.T.)
	Local oDlgMain		:= Nil 
	Local oGetDad1		:= Nil
	Local nOpcGetD		:= GD_INSERT+GD_DELETE+GD_UPDATE 
	Local nOpcClick		:= 0 
	Local nTotal		:= 0  
	Local i				:= 0  
	
	//Local cCposHeader	:= "ZZ1_VALOR|ZZ1_DATA|ZZ1_LA"
	Local cContaC		:= Space(20)
	Local nRecnoSC3		:= SC3->(RecNo())
	Local nPosItem		:= 0
	Local aCmpZZ3		:= U__fRetCpos("ZZ3")
	Local nI

	Private cContaD		:= Space(20)

	//Apura o total do contrato
	dbSelectArea("SC3")
	SC3->(dbSetOrder(1))
	SC3->(dbGoTop())
	SC3->(dbSeek(xFilial("SC3")+cContrato))
	While SC3->(!Eof()) .And. SC3->C3_FILIAL + SC3->C3_NUM == xFilial("SC3")+cContrato
		nTotal += SC3->C3_TOTAL     
		SC3->(dbSkip())
	EndDo
	SC3->(dbGoTo(nRecnoSC3))

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	//Monta os aHeaders
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("ZZ3"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "ZZ3"
		If X3Uso(SX3->X3_USADO) //AllTrim(SX3->X3_CAMPO) $ cCposHeader
			Aadd(aHead1,{	Trim(X3Titulo())			,;
							SX3->X3_CAMPO				,;
							SX3->X3_PICTURE				,; 
							SX3->X3_TAMANHO				,;
							SX3->X3_DECIMAL				,;
							SX3->X3_VALID				,;
							SX3->X3_USADO				,;
							SX3->X3_TIPO				,;
							SX3->X3_F3					,;
							SX3->X3_CONTEXT				,;
							SX3->X3_CBOX				,;
														,;
							""							,;
							SX3->X3_VISUAL				,;
							SX3->X3_VLDUSER				,;
							SX3->X3_PICTVAR				,;
							SX3->X3_OBRIGAT 			})
		EndIf
		SX3->(dbSkip())
	EndDo
	*/
	For nI := 1 to Len(aCmpZZ3)
		If Trim(GetSX3Cache(aCmpZZ3[nI],"X3_CAMPO")) <> Nil .And. X3Usado(GetSX3Cache(aCmpZZ3[nI],"X3_USADO")) 
			Aadd(aHead1,{	Trim(X3Titulo())			,;
							GetSX3Cache(aCmpZZ3[nI],"X3_CAMPO"		)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_PICTURE"	)	,; 
							GetSX3Cache(aCmpZZ3[nI],"X3_TAMANHO"	)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_DECIMAL"	)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_VALID"		)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_USADO"		)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_TIPO"		)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_F3"			)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_CONTEXT"	)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_CBOX"		)	,;
																		,;
							""											,;
							GetSX3Cache(aCmpZZ3[nI],"X3_VISUAL"		)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_VLDUSER"	)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_PICTVAR"	)	,;
							GetSX3Cache(aCmpZZ3[nI],"X3_OBRIGAT" 	)	})
		EndIf
	Next nI
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	//Busca apropriacoes ja existentes do contrato informado
	dbSelectArea("ZZ3")
	ZZ3->(dbSetOrder(1))
	ZZ3->(dbSeek(xFilial("ZZ3")+cContrato))
	While ZZ3->(!Eof()) .And. ZZ3->ZZ3_FILIAL + ZZ3->ZZ3_CONTRA == xFilial("ZZ3")+cContrato
		AAdd(aCols1,Array(Len(aHead1)+1))
		For i := 1 To Len(aHead1)
			aCols1[Len(aCols1),i] := ZZ3->&(aHead1[i,2])
		Next i
		aCols1[Len(aCols1),Len(aHead1)+1] := .F.   

		cContaC := ZZ3->ZZ3_CONTAC
		cContaD := ZZ3->ZZ3_CONTAD

		ZZ3->(dbSkip())
	EndDo

	If Len(aCols1) <= 0
		AAdd(aCols1,Array(Len(aHead1)+1))
		For i := 1 To Len(aHead1)
			If AllTrim(aHead1[i,2]) == "ZZ3_ITEM"
				aCols1[1,i] := "001"
			Else
				aCols1[1,i] := CriaVar(aHead1[i,2])
			EndIf
		Next i
		aCols1[1,Len(aHead1)+1] := .F.
	EndIf

	//Tela de Apropriacao
	oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6]/1.5,aCoordenadas[5]/1.5,OemToAnsi("Forma de Apropria็ใo"),,,,,,,,oMainWnd,.T.)
	TSay():New(014,001, {|| "Conta D้bito"}, oDlgMain,,,.F.,,,.T.,CLR_HBLUE,,100,011)
	@ 024,001 MSGET cContaD SIZE 060,010 WHEN .T. F3 'CT1' PICTURE '@!' PIXEL OF oDlgMain  

	TSay():New(014,090, {|| "Conta Cr้dito"}, oDlgMain,,,.F.,,,.T.,CLR_HBLUE,,100,011)  
	@ 024,090 MSGET cContaC SIZE 060,010 WHEN .T. F3 'CT1' PICTURE '@!' PIXEL OF oDlgMain 

	TSay():New(014,200, {|| "Valor Total do Contrato: " + AllTrim(Transform(nTotal,"@E 999,999,999.99")) }, oDlgMain,,,.F.,,,.T.,CLR_HBLUE,,100,011)  

	TButton():New(040,001,OemToAnsi("Gerar Parcelas de &Apropria็ใo"),oDlgMain,{|| RCOMA010_A(@oGetDad1,nTotal) },100,010,,,,.T.,,,,{|| })   		
	oGetDad1 := MsNewGetDados():New(052,001,oDlgMain:nClientHeight/2-34,oDlgMain:nClientWidth/2-3,nOpcGetD,,,"+ZZ3_ITEM",,,9999,,,,oDlgMain,aHead1,aCols1)

	EnchoiceBar(oDlgMain,{|| Iif(RCOMA010_B(oGetDad1,nTotal,cContaC,cContaD),nOpcClick := 1,nOpcClick := 0), Iif(nOpcClick == 1,oDlgMain:End(),Nil)},{|| nOpcClick := 0, oDlgMain:End()})
	oDlgMain:Activate(,,,.T.)

	//Gravacao           
	nPosItem := AScan(oGetDad1:aHeader,{|x| AllTrim(x[2]) == "ZZ3_ITEM" })
	dbSelectArea("ZZ3")
	ZZ3->(dbSetOrder(1))
	For i := 1 To Len(oGetDad1:aCols)
		If oGetDad1:aCols[i][Len(oGetDad1:aHeader)+1] .And. ZZ3->(dbSeek(xFilial("ZZ3")+cContrato+oGetDad1:aCols[i][nPosItem]))
			ZZ3->(RecLock("ZZ3",.F.))
			ZZ3->(dbDelete())
			ZZ3->(MsUnlock())
		ElseIf !oGetDad1:aCols[i][Len(oGetDad1:aHeader)+1] 
			If ZZ3->(dbSeek(xFilial("ZZ3")+cContrato+oGetDad1:aCols[i][nPosItem]))
				ZZ3->(RecLock("ZZ3",.F.))
			Else
				ZZ3->(RecLock("ZZ3",.T.))
			EndIf

			ZZ3->ZZ3_FILIAL	:= xFilial("ZZ3")
			ZZ3->ZZ3_CONTAC	:= cContaC
			//ZZ3->ZZ3_CONTAD	:= cContaD         
			ZZ3->ZZ3_CONTRA	:= cContrato
			For j := 1 To Len(oGetDad1:aHeader)
				If oGetDad1:aHeader[j,10] <> "V"
					ZZ3->&(oGetDad1:aHeader[j,2]) := oGetDad1:aCols[i][j]
				EndIf
			Next j
			ZZ3->(MsUnlock())
		EndIf
	Next i

	RestArea(aAreaBKP)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMA010_AบAutor  ณBruno Daniel Borges บ Data ณ  24/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que preenche as parcelas de apropriacao conforme     บฑฑ
ฑฑบ          ณparametros informados pelo usuario                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RCOMA010_A(oGetDados,nTotal)
	Local oDlgParcelas 		:= Nil       
	Local nQtdParcelas		:= 0 
	Local cDia				:= Space(2)
	Local nUltMes			:= 0
	Local dDataInicial		:= dDataBase
	Local lContinua			:= .F.
	Local nPosValor			:= AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ3_VALOR" 	})
	Local nPosData			:= AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ3_DATA" 	})
	Local nPosLA			:= AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ3_LA"	 	})
	Local nPosItem			:= AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ3_ITEM" 	}) 
	Local nPosConta			:= AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ3_CONTAD" 	}) 
	Local i					:= 0 
	Local nUltAno			:= 0 
	Local dDataParc			:= CToD("  /  /  ")

	oDlgParcelas := TDialog():New(000,000,175,130,OemToAnsi("Forma de Apropria็ใo"),,,,,,,,oMainWnd,.T.)
	TSay():New(001,001,{|| OemToAnsi("Quantidade Parcelas")},oDlgParcelas,,,,,,.T.,,,oDlgParcelas:nWidth/2-5,10)                     
	@ 011,001 MsGet nQtdParcelas Picture "@E 999,999.99" Size oDlgParcelas:nWidth/2-5,8 Valid(nQtdParcelas >= 1) Of oDlgParcelas Pixel

	TSay():New(025,001,{|| OemToAnsi("Dia da Parcela")},oDlgParcelas,,,,,,.T.,,,oDlgParcelas:nWidth/2-5,10)
	@ 035,001 MsGet cDia Picture "99" Size oDlgParcelas:nWidth/2-5,8 Valid(!Empty(cDia)) Of oDlgParcelas Pixel

	TSay():New(049,001,{|| OemToAnsi("Data Inicial")},oDlgParcelas,,,,,,.T.,,,oDlgParcelas:nWidth/2-5,10)
	@ 059,001 MsGet dDataInicial Size oDlgParcelas:nWidth/2-5,8 Valid(!Empty(dDataInicial)) Of oDlgParcelas Pixel

	TButton():New(075,001,OemToAnsi("Gerar Parcelas"),oDlgParcelas,{|| oDlgParcelas:End()  },060,010,,,,.T.,,,,{|| })   			
	oDlgParcelas:Activate(,,,.T.)

	If Len(oGetDados:aCols) >= 1 .And. !Empty(oGetDados:aCols[1,2])
		lContinua := MsgYesNo("Aten็ใo, jแ existe uma forma de apropria็ใo cadastrada. Voc๊ confirma a altera็ใo ?")   
	Else
		lContinua := .T.
	EndIf 

	If lContinua
		oGetDados:aCols := {}
		nUltMes := Month(dDataInicial)
		nUltAn	:= Year(dDataInicial)

		For i := 1 To nQtdParcelas
			AAdd(oGetDados:aCols,Array(Len(oGetDados:aHeader)+1))

			If i == 1 
				oGetDados:aCols[Len(oGetDados:aCols),nPosData] := dDataInicial
			Else
				If nUltMes > 12
					nUltMes := 1
					nUltAn++
				EndIf
			EndIf

			dDataParc := CToD(StrZero(Val(cDia),2)+"/"+StrZero(nUltMes,2)+"/"+SubStr(AllTrim(Str(nUltAn)),3,2))
			If Empty(dDataParc)
				dDataParc := LastDay(CToD("01/"+"/"+StrZero(nUltMes,2)+"/"+SubStr(AllTrim(Str(nUltAn)),3,2)))
			EndIf                                                                    

			oGetDados:aCols[Len(oGetDados:aCols),nPosItem]					:= StrZero(i,3)
			oGetDados:aCols[Len(oGetDados:aCols),nPosData] 				:= dDataParc
			oGetDados:aCols[Len(oGetDados:aCols),nPosValor]				:= NoRound(nTotal / nQtdParcelas,2) 
			oGetDados:aCols[Len(oGetDados:aCols),nPosLA]					:= "N"   
			oGetDados:aCols[Len(oGetDados:aCols),nPosConta]				:= cContaD
			oGetDados:aCols[Len(oGetDados:aCols),Len(oGetDados:aHeader)+1]	:= .F.   

			nUltMes++
		Next i	
	EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCOMA010_BบAutor  ณBruno Daniel Borges บ Data ณ  24/01/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da confirmacao da tela                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RCOMA010_B(oGetDados,nTotal,cContaC,cContaD)
	Local nTotInf	:= 0
	Local i			:= 0
	Local nPosValor	:= AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZ3_VALOR" 	})

	For i := 1 To Len(oGetDados:aCols)
		If !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
			nTotInf += oGetDados:aCols[i,nPosValor]
		EndIf
	Next i

	If NoRound(nTotal,0) <> NoRound(nTotInf,0)
		MsgAlert(	"Aten็ใo o total informado nas parcelas de apropria็ใo esta diferente do total do contrato:" + Chr(13)+Chr(10)+;
		" - Total Contrato: R$ " + AllTrim(Transform(NoRound(nTotal,0),"@E 999,999,999.99"))+Chr(13)+Chr(10)+;
		" - Total Informado: R$ " + AllTrim(Transform(NoRound(nTotInf,0),"@E 999,999,999.99"))+Chr(13)+Chr(10) )
		Return(.F.)
	EndIf

	If Empty(cContaC) .Or. Empty(cContaD)
		MsgAlert("Os campos Conta Cr้dito e Conta D้bito sใo de preenchimento obrigat๓rio")
		Return(.F.)
	EndIf

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMA01B บAutor  ณBruno Daniel Borges บ Data ณ  12/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do elemento PEP com a data de inicio    บฑฑ
ฑฑบ          ณdo contrato                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCOMA01B()
	Local aAreaBKP := GetArea()

	dbSelectArea("CTD")
	CTD->(dbSetOrder(1))
	If CTD->(dbSeek(xFilial("CTD")+M->ZZ0_ELEPEP))
		If CTD->CTD_DTEVEN <> M->ZZ0_DATA1
			MsgAlert("Aten็ใo, a data de inicio do Elemento PEP esta diferente da data de inicio do contrato.")
			Return(.F.)
		EndIf
	EndIf

	RestArea(aAreaBKP)

Return(.T.)