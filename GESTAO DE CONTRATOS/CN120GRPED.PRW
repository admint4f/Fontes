User Function CN120GRPED()

Local lRet:=.T.

If MsgNoYes( "Deseja que esta medi??o gere pedido de compra/venda ???", "A T E N ? ? O" )
     lRet := .T.
Else
     lRet := .F.
Endif          

Return(lRet)
