#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AxCadZZJ  � Autor � AP6 IDE            � Data �  06/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � AxCadastro de manuten��o padr�o para a tabela ZZJ (Cad. de ���
���          � Bens).                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXCADZZJ()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZZJ"

dbSelectArea("ZZJ")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Localiza��es dos Bens do Ativo Fixo",cVldExc,cVldAlt)

Return