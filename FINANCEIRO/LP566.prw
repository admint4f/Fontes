#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP566     ºAutor  ³Gilberto Oliveira   º Data ³  24/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Utilizado para configurar o lancamento padrao da contabi-  º±±
±±º          ³ lizaco dos cheques sobre titulo.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP566(cParam, cCtaPad)
Local aArea:= GetArea()
Local xRet

If cParam == 'D'      
     xRet:= SA2->A2_CONTA //POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CONTA")   
ElseIf cParam == 'C'
       xRet := POSICIONE("SA6",1,XFILIAL("SA6")+cBanco390+cAgencia390+cConta390,"A6_CONTA")
ElseIf cParam == "H"
	xRet:= "CH."+TRIM(cCheque390)+" NF:"+TRIM(SE2->E2_NUM)+" "+SUBS(SA2->A2_NOME,1,15) 
ElseIf cParam == 'V'
	If SE2->( !Eof() )
		xRet:= xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,1,,,SE2->E2_TXMOEDA)//-nTotAbat
	EndIf
EndIf

RestArea(aArea)
Return(xRet)                                                    

// conta debito : u_LP566("D",SPACE(02))
// conta credito: u_LP566("C",SPACE(02))
// valor........: u_LP566("V")
// historico....: u_LP566("H")      
// hist.aglutin.: u_LP566("H")
// outra inf.debito : u_LP566("D",SPACE(02))
// outra inf.credito: u_LP566("C",SPACE(02))

// backup das configuracoes anteriores do LP
// conta debito : POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CONTA")
// conta credito: POSICIONE("SA6",1,XFILIAL("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA,"A6_CONTA")
// valor........: SE5->E5_VALOR
// historico....: "CH.AVUL.S/TIT."+TRIM(SE5->E5_NUMCHEQ)+" "+TRIM(SE5->E5_BENEF)
// hist.aglutin.: "CH.AVUL.S/TIT."+TRIM(SE5->E5_NUMCHEQ)+" "+TRIM(SE5->E5_BENEF)
// outra inf.debito : POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CONTA")
// outra inf.credito: POSICIONE("SA6",1,XFILIAL("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA,"A6_CONTA")