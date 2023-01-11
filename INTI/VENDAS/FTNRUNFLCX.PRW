#Include "Protheus.ch"

/*/{Protheus.doc} FTNRUNFLCX - 
@description **Permite executar ou não o processamento de Fluxo de caixa, ao incluir um pedido de venda.**
@type User function
@version 1.00  
@author Rogério Costa
@since 11/02/2021
@return lRet, .T. - Executa o processamento de fluxo de caixa - .F. - Não executa o processamento de fluxo de caixa
/*/  
User Function FTNRUNFLCX()
 
Local lRet := .F. // Não executará o processamento do fluxo de caixa, após a geração do pedido de venda.
  
Return lRet
