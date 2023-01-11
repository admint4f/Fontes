#INCLUDE "Protheus.ch"

Static aRateioCC  := {}
Static aColsAux   := {}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA125BUT ºAutor  ³Bruno Daniel Borges º Data ³  24/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada que adiciona botoes de usuario na tela de  º±±
±±º          ³contrato te parcerias com fornecedores                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA125BUT()
	Local aRetorno := {}

	If !INCLUI
		AAdd(aRetorno,{"GRAF3D",{|| U_RCOMA010(SC3->C3_NUM)},"Método de apropriação contábil do contrato","Apropriação"})
	EndIf   
	Aadd(aRetorno,{"CHECKED" ,{|| IIF(INCLUI,Nil,U_T4FRATGER())}	,"Consulta do historico de aprovação."              ,"Aprov." })
	Aadd(aRetorno,{"S4WB013N",{|| U_Rateio_CC() 		}			,"Rateio entre vários centros de custo do contrato.","Rateio" }) 

	//Busca o rateio do Contrato de Parceria
	dbSelectArea("SZ2")
	SZ2->(dbSetOrder(2))
	SZ2->(dbSeek(xFilial("SZ2")+SC3->C3_NUM))
	While SZ2->(!Eof()) .And. SZ2->Z2_FILIAL + SZ2->Z2__SC1 == xFilial("SZ2")+SC3->C3_NUM
		If ALLTRIM(SZ2->Z2_TIPO) == "C"
			AAdd(aRateioCC,{	SZ2->Z2_ITEM,   ;
			SZ2->Z2_PERC,   ;
			SZ2->Z2_CONTA,  ;
			SZ2->Z2_ITEMCTA,;
			SZ2->Z2_CLVL,   ;
			SZ2->Z2_CC ,    ;
			SZ2->Z2_VALOR,  ;
			SZ2->Z2_ITEMSC  })
		Endif    
		SZ2->(dbSkip())
	EndDo

Return(aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT125GRV  ºAutor  ³Microsiga           º Data ³  04/13/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravar Rateio do Contrato de Parceria                      º±±
±±º          ³ Ponto de Entrada na gravacao do contrato de Parceria       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT125GRV
	Local aArea:=GetArea()
	Local lBloq:= .f.
	/*
	If INCLUI .Or. ALTERA
	dbSelectArea("SZ2")
	SZ2->(dbSetOrder(3))
	For i := 1 To Len(aRateioCC)
	If !DbSeek(xFilial("SZ2") + aRateioCC[i,1] + SC3->C3_NUM + aRateioCC[i,8] )
	RecLock("SZ2",.T.)
	SZ2->Z2_FILIAL	  := xFilial("SZ2")
	SZ2->Z2_ITEM	  := aRateioCC[i,1]
	SZ2->Z2_PERC	  := aRateioCC[i,2]
	SZ2->Z2_CONTA	  := aRateioCC[i,3]
	SZ2->Z2_ITEMCTA   := aRateioCC[i,4]
	SZ2->Z2_CLVL	  := aRateioCC[i,5]
	SZ2->Z2_CC		  := aRateioCC[i,6]
	SZ2->Z2_VALOR     := aRateioCC[i,7]
	SZ2->Z2_NUMSC     := SC3->C3_NUM
	SZ2->Z2_ITEMSC    := aRateioCC[i,8]
	SZ2->Z2__SC1	  := SC3->C3_NUM
	MsUnlock()
	Endif
	Next i
	EndIf
	*/

	If INCLUI .Or. ALTERA
		dbSelectArea("ZZ6")
		ZZ6->(dbSetOrder(4))
		ZZ6->(dbSeek(xFilial("ZZ6")+SC3->C3_NUM+"C" ))
		While ZZ6->(!Eof()) .And. ZZ6->ZZ6_FILIAL + ZZ6->ZZ6_SC+ZZ6->ZZ6_TIPO == xFilial("ZZ6")+SC3->C3_NUM+"C"
			ZZ6->(RecLock("ZZ6",.F.))
			ZZ6->(dbDelete())
			ZZ6->(MsUnlock())
			ZZ6->(dbSkip())
			lBloq:= .t.
		EndDo        


		LJMsgRun("Gerando Alçada de Aprovação","Aguarde",{|| U_Gera_Alcada_SC(SC3->C3_NUM,SC3->C3_CC,.T.) })
	Endif

	DbSelectArea("SC3")
	If lBloq
		SC3->C3_CONAPRO := "B"
	EndIF

	RestArea(aArea)

Return