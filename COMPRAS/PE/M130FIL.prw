#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M130FIL     � Autor � AP6 IDE            � Data �  18/07/08 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para filtrar solicitacoes de compras      ���
���          � emergenciais, de acordo com o parametro MV_C1EMERG         ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Obs.: O parametro MV_C1EMERG eh especifico da T4F, indica quais tipos de 
solicitacoes de compras serao geradas, 1 - Somente Emergenciais ou 2 - Todas.
/*/

User Function M130FIL

Local nTPSC1 := getmv("MV_C1EMERG")	
Local cFiltro := ""

do case
	case nTpSC1 = 1	// Somente solicitacoes de compras emergenciais
		cFiltro := "C1_EMERGEN = 'S'"
	case nTpSC1 = 2	// Somente solicitacaoes de compras NAO emergenciais
		cFiltro := "C1_EMERGEN = 'N'"
	//otherwise
	//	cFiltro := "C1_EMERGEN = 'S' .or. C1_EMERGEN = 'N'"
endcase	

If !empty(cFiltro)
	cFiltro +=" .and. " 
Endif
cFiltro +="empty(C1__CONTRA)" 

return cFiltro