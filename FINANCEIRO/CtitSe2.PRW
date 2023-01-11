

#include "rwmake.ch"  

user function CtitSe2()

Local cDivisao := " "
Local cUser	   := " "  

aCores:= {{"!empty(E2_SALDO)" , "BR_VERDE"} ,;  
          {"!empty(E2_SALDO).AND.!empty(E2_VALOR) " , "BR_AZUL"} ,;
          {"E2_TIPO == 'PA'" , "BR_BRANCO"} ,;         
	      {"empty(E2_SALDO)" , "BR_VERMELHO"}}    
	      
RecLock("SZ1",.F.)
dbSelectArea("SZ1")
dbSetOrder(1)

if DbSeek(xFilial()+cUsername)

	cUser    := alltrim(SZ1->Z1_USUARIO)
	cDivisao :=alltrim(SZ1->Z1_DIVISAO)
	
Else

ApMsgInfo("Esse Usuario nao esta cadastrado para efetuar essa consulta ","Atencao")

Endif
MsUnlock()
DbSelecTArea("SE2")
DbseTOrder(1)


Private cCadastro:= "Contas a Pagar"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                     {"Visualizar","AxVisual",0,2} ,;
                     {"Legenda","u_BrwLegenda()",0,3}}                
      
          



	SET FILTER TO ALLTRIM(SE2->E2_CLVL)$  ALLTRIM(cDivisao)
  

 
 
   
 mBrowse( 6,1,22,75,"SE2",,,,,,aCores)
 SET FILTER TO     
 RETURN
 
user function BrwLegenda() 
 
BrwLegenda(cCadastro,"Situação", {{"BR_VERDE","Titulo em Aberto"},;
								  {"BR_VERMELHO","Titulo Baixado"},; 
								  {"BR_BRANCO","Adiantamento com saldo"},;
								  {"BR_AZUL","Baixado Parcialmente"},; 
								  {"BR_PRETO","Titulo em bordero" }} ) 
								  							  
Return .T.    

          