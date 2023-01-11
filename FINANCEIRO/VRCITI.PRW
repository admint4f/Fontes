#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VRCITI    ºAutor  ³Microsiga           º Data ³  00/00/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAtualiza- ³ 24Ag2011 - Parametro T4F_VALREM. Possibilidade de retornar º±±
±±ºcoes      ³ o mesmo valor que vai impresso no boleto. Chamada da       º±±
±±º          ³ funcao R170VALORTIT() que faz parte do fonte RBOL745.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VRCITI()

Local cExcessao:= "NV0225;NV0312;NV0336;NV0805;NV0824;NV1000;NV1032"
Local VR:= 0
Local nValPad:= SE1->E1_VALOR+SE1->E1_ACRESC-SE1->E1_CSLL-SE1->E1_COFINS-SE1->E1_PIS-SE1->E1_IRRF-SE1->E1_INSS
Local nValPCC:= SE1->E1_VALOR+SE1->E1_ACRESC-SE1->E1_CSLL-SE1->E1_COFINS-SE1->E1_PIS-SE1->E1_IRRF-SE1->E1_INSS-SE1->E1_ISS
Local nValImp:= SE1->E1_VALOR+SE1->E1_ACRESC-SE1->E1_IRRF-SE1->E1_ISS-SE1->E1_INSS
Local lSaldo := SuperGetMV( "TC_VLRBOL", .F., .T. )
Local nSaldo:= 0
	
If GetMv("T4F_VALREM") == "R"
	
	// Calculo Valor Nominal CITI.REM
	If (SE1->E1_ISS == 0) .And.;
		(SE1->E1_VALOR >= 5000.00)
		
		VR := StrZero(Int(Round((nValPad)*100,2)),13)
		
	ElseIf (SE1->E1_ISS >  0) .And.;
		(SE1->E1_CLIENTE $ cExcessao) .And.;
		(SE1->E1_VALOR >= 5000.00)
		
		VR := StrZero(Int(Round((nValPCC)*100,2)),13)
		
	ElseIf (SE1->E1_ISS > 0) .And.;
		(SE1->E1_CLIENTE $ cExcessao).And.;
		(SE1->E1_VALOR < 5000.00)
		
		VR:= StrZero(Int(Round((nValImp)*100,2)),13)
		
	Else
		
		VR := StrZero(Int(Round((nValPad)*100,2)),13)
		
	EndIf
	
Else

	//VR:= u_R170VALORTIT( SE1->(RECNO()) )        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o saldo do título ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nSaldo:= u_T4FSaldoTit(lSaldo,SE1->(Recno()))        
	VR := StrZero(Int(Round((nSaldo)*100,2)),13)
	
EndIf

Return(VR)	
