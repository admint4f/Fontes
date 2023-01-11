#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP571     �Autor  �Gilberto Oliveira   � Data �  24/08/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Utilizado para configurar o lancamento padrao da contabi-  ���
���          � lizaco dos cheques sobre titulo (na exclusao).             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LP571(cParam, cCtaPad)
Local aArea:= GetArea()
Local xRet

If cParam == 'D'      
     xRet := POSICIONE("SA6",1,XFILIAL("SA6")+cBanco390+cAgencia390+cConta390,"A6_CONTA")     
ElseIf cParam == 'C'
     xRet:= SA2->A2_CONTA //POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CONTA")   
ElseIf cParam == "H"
	xRet:= "CANC.CH."+TRIM(cCheque390)+" NF:"+TRIM(SEF->EF_TITULO)+" "+SUBS(SA2->A2_NOME,1,15) 
ElseIf cParam == 'V'
	If SEF->( !Eof() )
		xRet:= SEF->EF_VALOR
	EndIf
EndIf

RestArea(aArea)
Return(xRet)                                                    

// conta debito : U_LP571("D")
// conta credito: U_LP571("C")
// valor........: U_LP571("V")
// historico....: U_LP571("H")
// hist.aglutin.: U_LP571("H")
// outra inf.debito : U_LP571("D")
// outra inf.credito: U_LP571("C")