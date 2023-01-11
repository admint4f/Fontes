#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/06/01

User Function M460FIM()        // incluido pelo assistente de conversao do AP5 IDE em 20/06/01

SetPrvt("_AAMBIENTE,_CALIASATU,_NI,")
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
_aAmbiente:={}
SalvaAmbiente()              
                                    
Select SA1
seek xFilial()+SD2->(D2_CLIENTE+D2_LOJA)
Select SE1
dbSetOrder(6)
seek xFilial()+DTOS(SD2->D2_EMISSAO)+SA1->A1_NREDUZ
Do while !eof() .and. DTOS(SD2->D2_EMISSAO)+SD2->(D2_CLIENTE+D2_LOJA) = DTOS(SE1->E1_EMISSAO)+SE1->(E1_CLIENTE+E1_LOJA)
	IF SE1->E1_NUM = SD2->D2_DOC .AND. SE1->E1_SERIE = SD2->D2_SERIE
		dbSelectArea("SB1")
		dbsetorder(1)
		seek xfilial()+sd2->d2_cod
		dbSelectArea("SE1")
		SE1->(RecLock("SE1",.F.))
		SE1->E1_CCONTAB	:= SD2->D2_CONTA
		SE1->E1_CCUSTO  := SD2->D2_CCUSTO
		SE1->E1_CCD		:= SD2->D2_CCUSTO
		SE1->E1_CCC		:= SD2->D2_CCUSTO
		SE1->E1_ITEMD	:= SD2->D2_ITEMCC
		SE1->E1_ITEMC	:= SD2->D2_ITEMCC
		SE1->E1_ITEM    := SD2->D2_ITEMCC
		SE1->E1_HIST	:= sb1->b1_desc
		
		SE1->(MsUnlock())
	ENDIF
	SE1->(dbSkip())
Enddo
dbSetOrder(1)
//+--------------------------------------------------------------+
//¦ Restaura o ambiente                                          ¦
//+--------------------------------------------------------------+
RestAmbiente()
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
