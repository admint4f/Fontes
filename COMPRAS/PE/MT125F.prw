#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  MT125F  ºAutor  ³Bruno Daniel Borges º Data ³  24/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos a gravacao do contrato de parceria    º±±
±±º          ³de fornecedores                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT125F()
Local aAreaBKP 	:= GetArea() 
Local cContrat	:= SC3->C3_NUM  
Local nTotCont	:= 0 
Local nTotApro	:= 0
                            
If !INCLUI
	U_RCOMA010(SC3->C3_NUM)
                     
ElseIf ALTERA
	//Avalia se houve alteracao de valor do contrato
	dbSelectArea("SC3")
	SC3->(dbSetOrder(1))
	SC3->(dbGoTop())
	SC3->(dbSeek(xFilial("SC3")+cContrat))
	While SC3->(!Eof()) .And. SC3->C3_FILIAL + SC3->C3_NUM == xFilial("SC3")+cContrat
		nTotCont += SC3->C3_TOTAL
		SC3->(dbSkip())
	EndDo
	
	//Compara com soma das parcelas de apropriacao
	dbSelectArea("ZZ1")
	ZZ1->(dbSetOrder(2))
	ZZ1->(dbSeek(xFilial("ZZ1")+"F"+cContrat))
	While ZZ1->(!Eof()) .And. ZZ1->ZZ1_FILIAL + ZZ1->ZZ1_TPCONT + ZZ1->ZZ1_CONTRA == xFilial("ZZ1")+"F"+cContrat
		nTotApro += ZZ1->ZZ1_VALOR
		ZZ1->(dbSkip())
	EndDo
	     
	
	If NoRound(nTotApro,0) <> NoRound(nTotCont,0)
		If MsgYesNo("Atenção, o contrato já possui um método de apropriação contábil cadastrado. E a soma das parcelas de apropriação não confere com o total do contrato. Deseja atualizar a forma de apropriação ?")
			U_RCOMA010(SC3->C3_NUM)
		EndIf
	EndIf
 
//Testa os dados na exclusao
Else
	dbSelectArea("ZZ1")
	ZZ1->(dbSetOrder(2))
	If ZZ1->(dbSeek(xFilial("ZZ1")+"F"+cContrat))
		MsgAlert("Atenção, esse contrato possui método de apropriação contábil cadastrado. Entre em contato com o depto. contábil para que sejam estornadas as apropriações já realizadas.")
	EndIf
EndIf      

RestArea(aAreaBKP)

Return(Nil)