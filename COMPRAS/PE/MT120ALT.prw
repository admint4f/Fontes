#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TopConn.Ch"
#INCLUDE "RwMake.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A010TOK   �Autor  �     � Data �  18/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na confirma��o do cadastro de Produtos.     ��
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT120ALT()

if inclui .and. FunName()=="MATA121"
//Aviso("OPERA��O N�O PERMITIDA ","INCLUIR PEDIDO ATRAV�S DA ROTINA 'SOLICITA��O DE COMPRAS'",{"Ok"})
//Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Favor utilizar a op��o : incluir solicita��o de compras "),{"Ok"},2)
Aviso(OEMTOANSI("OPERA��O N�O PERMITIDA"),OEMTOANSI("INCLUIR PEDIDO ATRAV�S DA ROTINA 'SOLICITA��O DE COMPRAS'"),{"Ok"},2)
return .f.
endif

Return(.T.)