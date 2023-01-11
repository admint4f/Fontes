#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CodBarBB  �Autor  �Gilberto Amancio    � Data �  30/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Formata o codigo de barras para ser inserido no CNAB BB.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CODBARBB
Local cCodBar:= ''
/*
OBS.:
O conteudo da linha digitavel o mesmo do codigo de barras, porem os dados
dados nao est�o dispostos na mesma ordem e sequencia.
O codigo de barras e composto de 44 posicoes e a linha digitavel de 47.
Deverao ser desprezadas na linha digitavel as posicoes  10, 21 e 32,
para que esta passe a ter tambem a quantidade de 44 posicoes a ser informada no segmento-J .

10        20        30        40        50        60        70        80        90
123456789 1234567890 234567890123456789012345678901234567890123456789012345678901234567890
1234567890 1234567891
*/
cCodBar:= Substr(SE2->E2_CODBAR,1,9)+Substr(SE2->E2_CODBAR,11,10)+Substr(SE2->E2_CODBAR,22,11)+Substr(SE2->E2_CODBAR,33)
Return(cCodBar)
