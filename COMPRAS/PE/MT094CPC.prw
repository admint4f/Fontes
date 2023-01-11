
//Criado por Thiago Moraes
//O Ponto de Entrada MT094CPC tem como funcionalidade exibir informações de outros campos reais do pedido de compra no momento da liberação do documento. Campos do tipo MEMO não são exibidos na grid.
//Esse pono de entrada será utilizado no app meu protheus para mostrar o campo observação ao aprovador na opção "ver mais" do app.

#Include 'Protheus.ch'
User Function MT094CPC()
//Local cCampos := "C7_XBO|C7_QUJE|C7_IPIBRUT|C7_VALICM" //  A separação dos campos devem ser feitos com uma barra vertical ( | ), igual é demonstrado no exemplo. 
Local cCampos := "C7_XOBSAPR|C7_OBS"
Return (cCampos)
