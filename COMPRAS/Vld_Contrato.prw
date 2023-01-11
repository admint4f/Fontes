#INCLUDE "Protheus.ch"

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  �Vld_Contrato�Autor  �Bruno Daniel Borges � Data �  23/07/08   ���
���������������������������������������������������������������������������͹��
���Desc.     �Funcao de gatilho do contrato de parceria quando existe apenas���
���          �um vigente do produto informado                               ���
���������������������������������������������������������������������������͹��
���Uso       � T4F                                                          ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function Vld_Contrato()  
Local aAreaBKP  := GetArea()
Local cQuerySC3 := "" 
Local cRetorno  := ""  
Local nTotReg   := 0

cQuerySC3 := " SELECT C3_NUM||C3_ITEM AS CONTRATO FROM " + RetSQLName("SC3")
cQuerySC3 += " WHERE C3_FILIAL = '" + xFilial("SC3") + "' AND C3_PRODUTO = '" + M->C1_PRODUTO + "' AND "
cQuerySC3 += "       C3_QUANT > C3_QUJE AND C3_DATPRF >= '" + DToS(dDataBase) + "' AND D_E_L_E_T_ = ' ' AND C3_CONPER = '      ' "

Iif(Select("TRB_SC3") > 0, TRB_SC3->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySC3),"TRB_SC3",.F.,.T.)
dbSelectArea("TRB_SC3")
TRB_SC3->(dbEval({|| nTotReg++ })) 
If nTotReg == 1
	TRB_SC3->(dbGoTop())  
	cRetorno := TRB_SC3->CONTRATO
EndIf

RestArea(aAreaBKP)

Return(cRetorno)