#include "rwmake.ch" 

User Function T4FLP_530()



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ISOP508  � Autor � Fabio Mendes    � Data �  16/01/09                  �
�������������������������������������������������������������������������͹��
���Descricao � Execblock Lp 532 preencher conta debito                               ���
���          �                                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � T4F				                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

return (iif(SE5->E5_TIPO $ "TX ",POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA"),IIF(POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_PERMUTA")=="S",POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA"),SA2->A2_CONTA)))           

//IIF(POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_PERMUTA")=="S",POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTA"),SA2->A2_CONTA) - LP 530 
//iif(SE5->E5_TIPO $ "TX ",SE2->E2_CCONTAB,IIF(POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_PERMUTA")=="S",POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA"),SA2->A2_CONTA)) - LP 532           
