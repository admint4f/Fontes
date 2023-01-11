#include "rwmake.ch" 

User Function T4FLP_530()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ISOP508  º Autor ³ Fabio Mendes    º Data ³  16/01/09                  ±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Execblock Lp 532 preencher conta debito                               º±±
±±º          ³                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F				                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

return (iif(SE5->E5_TIPO $ "TX ",POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA"),IIF(POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_PERMUTA")=="S",POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA"),SA2->A2_CONTA)))           

//IIF(POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_PERMUTA")=="S",POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTA"),SA2->A2_CONTA) - LP 530 
//iif(SE5->E5_TIPO $ "TX ",SE2->E2_CCONTAB,IIF(POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_PERMUTA")=="S",POSICIONE("SED",1,XFILIAL("SED")+SE5->E5_NATUREZ,"ED_CONTA"),SA2->A2_CONTA)) - LP 532           
