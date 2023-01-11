#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  MT125F  �Autor  �Bruno Daniel Borges � Data �  24/01/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada apos a gravacao do contrato de parceria    ���
���          �de fornecedores                                             ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		If MsgYesNo("Aten��o, o contrato j� possui um m�todo de apropria��o cont�bil cadastrado. E a soma das parcelas de apropria��o n�o confere com o total do contrato. Deseja atualizar a forma de apropria��o ?")
			U_RCOMA010(SC3->C3_NUM)
		EndIf
	EndIf
 
//Testa os dados na exclusao
Else
	dbSelectArea("ZZ1")
	ZZ1->(dbSetOrder(2))
	If ZZ1->(dbSeek(xFilial("ZZ1")+"F"+cContrat))
		MsgAlert("Aten��o, esse contrato possui m�todo de apropria��o cont�bil cadastrado. Entre em contato com o depto. cont�bil para que sejam estornadas as apropria��es j� realizadas.")
	EndIf
EndIf      

RestArea(aAreaBKP)

Return(Nil)