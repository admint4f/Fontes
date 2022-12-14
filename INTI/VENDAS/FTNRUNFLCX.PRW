#Include "Protheus.ch"

/*/{Protheus.doc} FTNRUNFLCX - 
@description **Permite executar ou n?o o processamento de Fluxo de caixa, ao incluir um pedido de venda.**
@type User function
@version 1.00  
@author Rog?rio Costa
@since 11/02/2021
@return lRet, .T. - Executa o processamento de fluxo de caixa - .F. - N?o executa o processamento de fluxo de caixa
/*/  
User Function FTNRUNFLCX()
 
Local lRet := .F. // N?o executar? o processamento do fluxo de caixa, ap?s a gera??o do pedido de venda.
  
Return lRet
