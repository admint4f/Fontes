
//Criado por Thiago Moraes
//O Ponto de Entrada MT094CPC tem como funcionalidade exibir informa��es de outros campos reais do pedido de compra no momento da libera��o do documento. Campos do tipo MEMO n�o s�o exibidos na grid.
//Esse pono de entrada ser� utilizado no app meu protheus para mostrar o campo observa��o ao aprovador na op��o "ver mais" do app.

#Include 'Protheus.ch'
User Function MT094CPC()
//Local cCampos := "C7_XBO|C7_QUJE|C7_IPIBRUT|C7_VALICM" //  A separa��o dos campos devem ser feitos com uma barra vertical ( | ), igual � demonstrado no exemplo. 
Local cCampos := "C7_XOBSAPR|C7_OBS"
Return (cCampos)
