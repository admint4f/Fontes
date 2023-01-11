#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA410DEL ºAutor  ³Bruno Daniel Borges º Data ³  07/04/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos a gravacao do pedido de venda. Usado  º±±
±±º          ³no caso da exclusao do PV para estornar no contrato         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA410DEL()
Local cQueryDEL := ""
Local bQuery	:= {|| Iif(Select("TRB") > 0,TRB->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryDEL),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbGoTop()) }

cQueryDEL := " SELECT R_E_C_N_O_ AS REGNO FROM " + RetSQLName("ZZ2")
cQueryDEL += " WHERE ZZ2_FILIAL = '" + xFilial("ZZ2") + "' AND ZZ2_PEDIDO = '" + SC5->C5_NUM + "' "
LJMsgRun("Estornando Contratos","Aguarde...",bQuery)
While TRB->(!Eof())
    dbSelectArea("ZZ2")
    ZZ2->(dbGoTo(TRB->REGNO))
    
	ZZ2->(RecLock("ZZ2",.F.))
		ZZ2->ZZ2_PEDIDO	:= ""
		ZZ2->ZZ2_SERNF	:= ""
		ZZ2->ZZ2_NUMNF	:= ""
	ZZ2->(MsUnlock())       

	TRB->(dbSkip())
EndDo

Return(Nil)