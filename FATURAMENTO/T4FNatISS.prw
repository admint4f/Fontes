#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FNATISS ºAutor  ³Microsiga           º Data ³  06/22/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Execblock para decidir qual ser a natureza do titulo de ISS º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function T4FNATISS  
 

Local aArea:= GetArea()
Local cRet:= "0302318"
Local cISSFat:= SuperGetMv("T4F_ISSFAT",,"0302302")
Local cISSRet:= SuperGetMv("T4F_ISSFAT",,cRet)
// ISS S/Faturamento -  0302302  - São os Títulos do Tipo: "TX"
// ISS Retido  - 0302318 - São os Títulos do Tipo: "ISS"

If TRIM(FUNNAME()) = 'MATA460A' .or. TRIM(SE2->E2_ORIGEM)='MATA460' .OR. TRIM(FUNNAME()) = 'MATA461' .OR. TRIM(FUNNAME()) = 'MATA460'
	cRet:= "0302302"
Endif
//cRet:= Iif( Alltrim(SE2->E2_TIPO) == "TX", "0302302", cRet )                   

// PARA EXCLUSAO. Se nao tiver esse bloco nao exclui o titulo de ISS no Contas a Pagar (SE2)
If FUNNAME() == 'MATA521A' .AND. SE2->E2_FORNECE == Alltrim(GetMv("MV_MUNIC")) 
   cRet:= SE2->E2_NATUREZ
EndIf   

RestArea( aArea )
Return(cRet)
