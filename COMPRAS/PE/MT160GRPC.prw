#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160GRPC ºAutor  ³Carlos Tagliaferri  º Data ³  Set/2012   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para gravar no PC campos da SC                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ METROREC                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT160GRPC()

Local aArea := GetArea()

RecLock("SC7",.F.)
	SC7->C7_CONTA 	:= SC1->C1_CONTA
	SC7->C7_ITEMCTA := SC1->C1_ITEMCTA
	SC7->C7_CLVL 	:= SC1->C1_CLVL
	SC7->C7_CC 		:= SC1->C1_CC          
	SC7->C7_OBS  	:= SC1->C1_OBS 
	SC7->C7_XCCAPR	:= SC1->C1_CC
	SC7->C7_FILENT	:= SC1->C1_FILENT   		

	SC7->C7_T4FLROU := SC1->C1_T4FLROU
	SC7->C7_XMAILF 	:= SC1->C1_XMAILF 
	SC7->C7_XTPCPR  := SC1->C1_XTPCPR   
	SC7->C7_XSOLPA 	:= SC1->C1_XSOLPA  
	SC7->C7_XVALPA 	:= SC1->C1_XVALPA
	SC7->C7_XVENPA 	:= SC1->C1_XVENPA                
	SC7->C7_XOBSAPR	:= SC1->C1_XOBSAPR
	SC7->C7_XOBSFO	:= SC1->C1_XOBSFO
	SC7->C7_SOLICIT := SC1->C1_SOLICIT	
MsUnlock()

RestArea(aArea)

Return	