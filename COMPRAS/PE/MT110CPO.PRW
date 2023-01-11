#INCLUDE 'Protheus.ch'
#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} IMPRET
Ponto de entrada para adicionar campos na solicitação compras
@type function
@version 1.00
@author Lucas Valins
@since 04/11/2020
/*/

User Function MT110CPO()

Local aNewCpos :=  PARAMIXB[1]  //Array contendo os campos da tabela SC1 (Default) 
aAdd(aNewCpos, "C1_MOEDA")  //-- Adiciona os campos do usuario 

Return aNewCpos
