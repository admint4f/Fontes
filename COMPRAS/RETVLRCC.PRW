#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RetVlrCC ºAutor  ³Bruno Daniel Borges º Data ³  09/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de calculo de % conforme valor informado             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³Adicionado das Linhas 30 a 34 - Sergio Celestino            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RetVlrCC(nOpc) //A variavel nOpc e passada pelo gatilho - Sergio Celestino
Local nRetorno  := 0
Local nPosItem  := 0
Local nPosQtde  := 0
Local nPosValor := 0 
Local oGetDad        
              
Local nPosVRat 	:= 3
Local nPosPRat 	:= 2
Local nPosISc  	:= 8
Local nPosCta	:= 5
Local nPosPep	:= 6
//Local nPosVRat  := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_VALOR"  })
//Local nPosPRat  := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_PERC"   })
//Local nPosISc   := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMSC" })
//Local nPosCta   := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_CONTA"  })
//Local nPosPep   := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMCTA"})

Local nTotal    := 0

Public nPConta 	 := " "
Public nPPepe	 := " "
Public nPosItem  := " "
Public nPosItemX := " "

If Alltrim(Upper(FunName(0))) == 'MATA110'		
	nPosItemx := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_ITEM"       })
	nPosQtde  := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_QUANT"      })
	nPosValor := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_VUNIT"      })
    nPConta   := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_CONTA"      })
    nPPepe    := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C1_ITEMCTA"    })
Else
	nPosItemx := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_ITEM"      })
	nPosQtde  := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_QUANT"      })
	nPosValor := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_PRECO"      })
    nPConta   := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_CONTA"      })
    nPPepe    := AScan(aOrigHeader,{|x| AllTrim(x[2]) == "C3_ITEMCTA"    })
Endif	

//For i := 1 To Len(aOrigAcols) comentado pelo Sergio Celestino
//	If !aOrigAcols[i,Len(aOrigHeader)+1] comentado pelo Sergio Celestino
		nTotal := aOrigAcols[nOrigN,nPosQtde] * aOrigAcols[nOrigN,nPosValor]
//	EndIf
//Next i

If nOpc == 1 //Calcular % pelo valor digitado
	//Calcula o %   
	If nTotal > 0
		nRetorno := Round(M->Z2_VALOR *100/nTotal,2)
//	    oGetDad:aCols[oGetDad:oBrowse:nat][nPosVRat] := M->Z2_VALOR
//		nRetorno := Round(oGetDad:aCols[oGetDad:oBrowse:nat][nPosVRat] * 100 / nTotal,2) //Alterado variavel de momorial pelo objeto ( Sergio Celestino )
	EndIf                                                        
Else
	//Calcula o Valor pelo percentual digitado
	If nTotal > 0
		nRetorno := Round(nTotal*M->Z2_PERC/100,2)
//		oGetDad:aCols[oGetDad:oBrowse:nat][nPosPRat] := M->Z2_PERC
//		nRetorno := Round(oGetDad:aCols[oGetDad:oBrowse:nat][nPosPRat] * nTotal / 100,2)//Alterado variavel de momorial pelo objeto ( Sergio Celestino )
	EndIf
Endif
                
  
//m->Z2_ITEMSC := aOrigAcols[nOrigN,nPosItem]                       
m->Z2_ITEMSC := aOrigAcols[nOrigN,1]
m->Z2_CONTA	 := aOrigAcols[nOrigN,nPConta]
m->Z2_ITEMCTA:= aOrigAcols[nOrigN,nPPepe]

//oGetDad:aCols[oGetDad:oBrowse:nat][nPosISc] := aOrigAcols[nOrigN,nPosItem] //Atualizo campo do item da sc no rateio ( Sergio Celestino )

//oGetDad:aCols[oGetDad:oBrowse:nat][nPosCta] := aOrigAcols[nOrigN,nPConta] //Retornar Conta Contabil
//oGetDad:aCols[oGetDad:oBrowse:nat][nPosPep] := aOrigAcols[nOrigN,nPPepe ] //Retornar Conta Contabil

Return(nRetorno)