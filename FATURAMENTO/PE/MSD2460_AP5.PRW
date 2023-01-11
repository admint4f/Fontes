#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/06/01
User Function MSD2460()        // incluido pelo assistente de conversao do AP5 IDE em 20/06/01
//SetPrvt("_AAMBIENTE,_CALIASATU,_NI,")
/*/
____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦ MSD2460            ¦ Modulo ¦ FATURAMENTO¦ Data ¦ 23/01/04 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Autor(a)  ¦ Ednei Camara Mauriz                                        ¦¦¦
¦¦¦Cliente   ¦ CIE BRASIL                                                 ¦¦¦
¦¦¦Aplicaçäo ¦ PONTO DE ENTRADA para para gravar no item da nota fiscal de¦¦¦
¦¦¦          ¦ saida o CONTA/CC/ITEM/CLASSE contabil digitado no item  pve¦¦¦
¦¦¦Parâmetros¦                                                            ¦¦¦
¦¦¦Comentário¦ Visa a facilitar a conciliacao na contabilidad nos periodos¦¦¦
¦¦¦          ¦ de fechamento                                              ¦¦¦
¦¦+----------+------------------------------------------------------------+¦¦
¦¦¦Histórico ¦                                          ¦      ¦          ¦¦¦
¦¦¦          +------------------------------------------------------------¦¦¦
¦¦¦Comentário¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+--------------------------------------------------------------+
//¦ Salva ambiente                                               ¦
//+--------------------------------------------------------------+
//_aAmbiente:={}
//SalvaAmbiente()              
If !SM0->M0_CODIGO $ "26/30/31"
    	dbSelectArea("SB1")
    	dbSetOrder(1)
    	Seek xfilial("SB1")+SD2->D2_COD
    	dbSelectArea("SD2")
		Reclock("SD2",.F.)
			// Alteração em 04/08/2020 para buscar a conta receita no momento do faturamento
             SD2->D2_CONTA :=IIF(!empty(SB1->B1_CONTAG),SB1->B1_CONTAG,SC6->C6_CONTA)
    	     SD2->D2_CCUSTO:=SC6->C6_CCUSTO
             SD2->D2_ITEMCC:=SC6->C6_ITEMCC
             SD2->D2_CLVL  :=SC6->C6_CLVL
 		MsUnlock()
EndIf
//+--------------------------------------------------------------+
//¦ Restaura o ambiente                                          ¦
//+--------------------------------------------------------------+
//RestAmbiente()
Return()       
/*/
____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ SalvaAmb ¦ Autor ¦ Expedito Mendonca Jr. ¦ Data ¦ 29/12/99 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Salva o ambiente atual                                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function SalvaAmbiente()
_cAliasAtu:=Alias()
for _ni := 1 to Len(_aAmbiente)
	dbSelectArea(_aAmbiente[_ni,1])	
	AADD(_aAmbiente[_ni],indexord())
	AADD(_aAmbiente[_ni],recno())
next
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ RestAmb  ¦ Autor ¦ Expedito Mendonca Jr. ¦ Data ¦ 29/12/99 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Restaura o ambiente salvo                                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico                                                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function RestAmbiente()
for _ni:=1 to Len(_aAmbiente)
	dbSelectArea(_aAmbiente[_ni,1])
	dbSetOrder(_aAmbiente[_ni,2])
	dbGoto(_aAmbiente[_ni,3])
next
dbSelectArea(_cAliasAtu)
Return



