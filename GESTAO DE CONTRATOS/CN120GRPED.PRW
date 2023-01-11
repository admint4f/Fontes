User Function CN120GRPED()

Local lRet:=.T.

If MsgNoYes( "Deseja que esta medição gere pedido de compra/venda ???", "A T E N Ç Ã O" )
     lRet := .T.
Else
     lRet := .F.
Endif          

Return(lRet)
