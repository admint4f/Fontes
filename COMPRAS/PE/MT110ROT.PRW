#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT110ROT ºAutor  ³Bruno Daniel Borges º Data ³  19/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para retirar alguns botoes do BROWSE da    º±±
±±º          ³S.C. que sera substituidos por botoes customizados          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT110ROT()
Local aRetorno	:= {} 
Local i			:= 0 
Local cBotOut	:= "A110Aprov|A110Cancela|A110Copia" //"A110Aprov|A110Cancela|A110Altera|A110Copia"  // Alterado Takao - não pode alterar
Local aRetSc1	:= Getarea()
Local cFuncPCE  := GetMV("T4F_GERPC",,"consultoriati16/Administrador")//Adicionado por Sergio Celestino ( parametro com usuarios que poderão executar rotina de geracao de pedido de compras )

For i := 1 To Len(aRotina)
	If !(Upper(AllTrim(aRotina[i,2])) $ Upper(cBotOut))
		AAdd(aRetorno,aRotina[i])
	EndIf
Next i         

//Adiciona consulta especifica de aprovacao de S.C.
AAdd(aRetorno,{"Copiar"			,"U_ACopiaSC",0,4})
//AAdd(aRetorno,{"Aprovacao"		,"U_RCOMA070",0,4})
AAdd(aRetorno,{"Aprovacao"		,"U_T4FRATGER",0,4})
AAdd(aRetorno,{"Cancelar"		,"U_RCOMA090",0,4}) 

//-----------------------------------------------------------------------------------
// Adicionar Rotina de Geração de PCs com base na SCs Emergenciais - Sergio Celestino
//-----------------------------------------------------------------------------------
If Alltrim(Upper(cUserName)) $ Alltrim(Upper(cFuncPCE))   
   aAdd(aRetorno, { OemToAnsi("Geração de Pcs"),"u_GeraPCSC"	, 0 , 4,6})	
Endif

Restarea(aRetSc1)
Return(aRetorno)
                                         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ACopiaSC ºAutor  ³Bruno Daniel Borges º Data ³  19/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina Customizada de Copia de SCs                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACopiaSC(cAlias,nReg,nOpcX)
Local xRet
Local aRestArea := Getarea()
lCopia := .T.
l110Alt:= .F.                                               
//INCLUI := .T.

If !SC1->(Eof())
	xRet := A110Inclui(cAlias,nReg,4,lCopia,lCopia) //Alterado BZO - 26/02/2016
EndIf
Restarea(aRestArea)
Return(Nil)