#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA103BUT ºAutor  ³Bruno Daniel Borges º Data ³  31/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada p/ adicionar botoes na tela de inclusao    º±±
±±º          ³da NF de Entrada                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA103BUT() 
Local aRetorno := {}
Local aRestArea := getarea()
Local aRestSD1  := SD1->(getarea())
Local aRestCTD  := CTD->(getarea())
Local aRestCTT  := CTT->(getarea())
Local aRestZZP  := ZZP->(getarea())
Local aRestZZE  := ZZE->(getarea())

Aadd(aRetorno, {'CRITICA',{|| U_relbols()},OemToAnsi("Selecionar Reembolsos de Despesas/Pagamentos Avulsos liberados para este fornecedor"),"Reembolso"} )

Restarea(aRestArea)
Restarea(aRestSD1)
Restarea(aRestCTD)
Restarea(aRestCTT)
Restarea(aRestZZP)
Restarea(aRestZZE)
Return(aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Sel_ReembolsoºAutor  ³Bruno Daniel Borges º Data ³  31/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de selecao dos reembolsos de despesas/prestacao contas  º±±
±±º          ³                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function relbols()
Local cQuery       := ""    
Local cItemSel     := ""
Local bQuery       := {|| Iif(Select("TRB_ZZE") > 0, TRB_ZZE->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB_ZZE",.F.,.T.), dbSelectArea("TRB_ZZE"), TRB_ZZE->(dbGoTop())}
Local oDlgDesp	   := Nil   
Local oList        := Nil    
Local aCoordenadas := MsAdvSize(.T.)     
Local nOpClick     := 0       
Local aDespesas    := {}    
Local nPosProd     := AScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"     }) 
Local nPosQuant    := AScan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"   }) 
Local nPosVUnit    := AScan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"   }) 
Local nPosCC       := AScan(aHeader,{|x| AllTrim(x[2]) == "D1_CC"      }) 
Local nPosItemCta  := AScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEMCTA" }) 
Local nPosDespesa  := AScan(aHeader,{|x| AllTrim(x[2]) == "D1__DESPES" }) 
Local nPosTES      := AScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"     })
Local i,j

If Empty(cA100For) .Or. Empty(cLoja) 
	MsgAlert("Informe o fornecedor e loja antes de consultar os reembolsos de despesas e/ou prestação de contas liberadas")
	Return(Nil)
EndIf

cQuery := " SELECT ZZE_NUMERO, ZZE_DATA, ZZE_VALOR, ZZE_HISTOR, ZZE_CCUSTO, ZZE_PEP "
cQuery += " FROM " + RetSQLName("ZZE")
cQuery += " WHERE ZZE_FILIAL = '" + xFilial("ZZE") + "' AND "
cQuery += "       ZZE_FORNEC = '" + cA100For + "' AND ZZE_LOJA = '" + cLoja + "' AND D_E_L_E_T_ = ' ' AND "
cQuery += "       ZZE_STATUS = 'L' AND (ZZE_TIPO = 6 OR ZZE_TIPO = 7) AND ZZE_TITULO = '"+Space( TamSx3("ZZE_TITULO")[1] )+"' "
//cQuery += "       ZZE_STATUS = 'L' AND (ZZE_TIPO = 6 OR ZZE_TIPO = 7) AND ZZE_TITULO = '      ' "   

LJMsgRun("Buscando reembolsos de despesas/prestação de contas desse fornecedor...","Aguarde",bQuery)
If TRB_ZZE->(Eof())
	MsgAlert("Atenção, não há reembolsos de despesas e/ou prestação de contas liberadas para esse fornecedor.")
	Return(Nil)
Else
	TRB_ZZE->(dbEval({|| AAdd(aDespesas,{	.F.,;
											TRB_ZZE->ZZE_NUMERO,;
											SToD(TRB_ZZE->ZZE_DATA),;
											Transform(TRB_ZZE->ZZE_VALOR,"@E 999,999,999.99"),;
											TRB_ZZE->ZZE_HISTOR,;
											AllTrim(Posicione("CTT",1,xFilial("CTT")+AllTrim(TRB_ZZE->ZZE_CCUSTO),"CTT->CTT_DESC01")),;
											AllTrim(Posicione("CTD",1,xFilial("CTD")+AllTrim(TRB_ZZE->ZZE_PEP),"CTD->CTD_DESC01")),;
											TRB_ZZE->ZZE_CCUSTO,;
											TRB_ZZE->ZZE_PEP  }) }))
EndIf

//Tela de provisao de pedidos de compras                                                                               
oDlgDesp := TDialog():New(aCoordenadas[7],000,aCoordenadas[6]/1.5,aCoordenadas[5]/1.5,"Reembolso de Despesas/Prestação de Contas",,,,,,,,oMainWnd,.T.)

	@ 014,001 ListBox oList Var cItemSel Fields Header " ","Numero","Data Pagto.","Valor Total","Historico","Centro Custo","Elemento PEP" Size oDlgDesp:nClientWidth/2-5,oDlgDesp:nClientHeight/2-50 ;
		Pixel Of oDlgDesp ;
		On dblClick( aDespesas[oList:nAt][1] := !aDespesas[oList:nAt][1] ) 
		oList:SetArray(aDespesas)
		oList:bLine := {||{	IIf(aDespesas[oList:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
							aDespesas[oList:nAt][2],;
							aDespesas[oList:nAt][3],; 
							aDespesas[oList:nAt][4],;
							aDespesas[oList:nAt][5],;
							aDespesas[oList:nAt][6],;
							aDespesas[oList:nAt][7] }}  
EnchoiceBar(oDlgDesp,{|| nOpClick := 1, oDlgDesp:End()},{|| nOpClick := 0, oDlgDesp:End()})
oDlgDesp:Activate(,,,.T.)

If nOpClick == 1     
	//Testa se houve despesas marcadas
	For i := 1 To Len(aDespesas)
		If aDespesas[i,1]  
			N := 0
			aCols := {}
			Exit          
		EndIf
	Next i

	//Preenche o aCols
	For i := 1 To Len(aDespesas)
		If aDespesas[i,1]
			dbSelectArea("ZZP")
			ZZP->(dbSetOrder(1))
			ZZP->(dbSeek(xFilial("ZZP")+aDespesas[i][2] ))
			While ZZP->(!Eof()) .And. ZZP->ZZP_FILIAL + ZZP->ZZP_CODIGO == xFilial("ZZP")+aDespesas[i][2]
				AAdd(aCols,Array(Len(aHeader)+1))

				N := Len(aCols)
				
				For j := 1 To Len(aHeader)                              
					If AllTrim(aHeader[j][2]) == "D1_ITEM"
						aCols[Len(aCols)][j] := StrZero(N,4)
					ElseIf !(AllTrim(aHeader[j][2]) $ "D1_ALI_WT,D1_REC_WT")
						aCols[Len(aCols)][j] := CriaVar(aHeader[j][2])     
					EndIf					
				Next j

				aCols[Len(aCols)][Len(aHeader)+1] := .F.

				//Campos Especificos
				aCols[Len(aCols)][nPosProd]    := ZZP->ZZP_COD   
				Gatilho("D1_COD",ZZP->ZZP_COD,N)

				
				aCols[Len(aCols)][nPosQuant]   := ZZP->ZZP_QUANT
				Gatilho("D1_QUANT",ZZP->ZZP_QUANT,N)

				aCols[Len(aCols)][nPosVUnit]   := ZZP->ZZP_VRUNIT
				Gatilho("D1_VUNIT",ZZP->ZZP_VRUNIT,N)

				aCols[Len(aCols)][nPosCC]      := ZZP->ZZP_CC
				Gatilho("D1_CC",ZZP->ZZP_CC,N)

				aCols[Len(aCols)][nPosItemCta] := aDespesas[i][9]
				//Gatilho("D1_ITEMCTA",aDespesas[i][8],N)
				                                
				//Refaz o gatilho de produtos
				Gatilho("D1_COD",ZZP->ZZP_COD,N)

				aCols[Len(aCols)][nPosDespesa] := aDespesas[i][2]
				
				//Recalculo dos Impostos  
				//Caso tenha Elemento PEP será custo (TES 181) caso contrário será despesa (TES 182)
				if !empty(aDespesas[i][9])
					MaFisAlt("IT_TES","181",n)
				else
  					MaFisAlt("IT_TES","182",n)
				endif
//				MaFisAlt("IT_TES",aCols[n,nPosTES],n)
				MaFisToCols(aHeader,aCols,,"MT100")
				MaFisAlt("IT_ALIQICM",0,n)		
				MaFisAlt("IT_ALIQIPI",0,n)		

				ZZP->(dbSkip())
			EndDo
		EndIf	
	Next i
	
	Eval(bRefresh)
	Eval(bGDRefresh)
	
EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Gatilho  ºAutor  ³Bruno Daniel Borges º Data ³  31/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que executa o gatilho dos campos para simular a in-  º±±
±±º          ³clusao de uma linha no aCols da NF de Entrada               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Gatilho(cCampo,uValorDoCampo,nI)
Local cVarAtu  := ReadVar()
Local lRet     := .T.
Local cPrefixo := "M->"
Local bValid

__ReadVar := cPrefixo+cCampo

&(cPrefixo+cCampo) := uValorDoCampo

SX3->( dbSetOrder(2) )
SX3->( dbSeek(cCampo) )
bValid := "{|| "+IIF(!Empty(SX3->X3_VALID),Rtrim(SX3->X3_VALID)+IIF(!Empty(SX3->X3_VLDUSER),".And.",""),"")+Rtrim(SX3->X3_VLDUSER)+" }"

lRet := Eval( &(bValid) )

If lRet
     SX3->(DbSetOrder(2))
     SX3->(DbSeek(cCampo))

     If ExistTrigger(cCampo)
         RunTrigger(2,ni)
     EndIf
EndIf

__ReadVar := cVarAtu

Return(lRet)