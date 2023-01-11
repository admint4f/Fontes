#INCLUDE "RWMAKE.CH"

// Ponto de entrada da analise da cotação para mostrar os pedidos gerados.
// Renato Takao

USER FUNCTION MT160WF()

Local _aArea   := GetArea()

_cQuery := "SELECT C7_FILENT, C7_NUM, C7_FORNECE, C7_LOJA, C7_EMISSAO, SUM(C7_TOTAL) TOTAL "
_cQuery += " FROM " + RetSqlName("SC7") 
_cQuery += " WHERE C7_NUMCOT='"+SC7->C7_NUMCOT+"'"
_cQuery += " AND C7_FILIAL='"+SM0->M0_CODFIL+"'" 
_cQuery += " AND C7_EMISSAO='"+DTOS(ddatabase)+"'" 
_cQuery += " AND D_E_L_E_T_=' ' "
_cQuery += " GROUP BY C7_FILENT, C7_NUM, C7_FORNECE, C7_LOJA, C7_EMISSAO"

_cQuery := CHANGEQUERY(_cQuery)

IF Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
ENDIF

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.T.)
DbSelectArea("TRB")
Dbgotop()

_cMsg:=""
While !EOF()

	_cMsg+=TRB->C7_FILENT+"/"+TRB->C7_NUM+" "+DTOC(STOD(TRB->C7_EMISSAO))+" "+TRANSFORM(TRB->TOTAL,"@E 999,999,999.99")+" "+POSICIONE("SA2",1,xFilial("SA2")+TRB->C7_FORNECE+TRB->C7_LOJA,"A2_NOME")+CHR(10)+CHR(13)
	DBSKIP()
		
End

RestArea(_aArea) 

If !Empty(_cMsg)
//	MSGBOX(_cMsg,"Pedidos de compras gerados")
	Aviso("Pedidos de compras gerados", _cMsg,{"Sair"},2)
Endif
RETURN