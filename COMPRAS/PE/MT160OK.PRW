#include "PROTHEUS.CH"

// PE da MATA160 para validar os 5% maior que pre?o da solicita??o.
// Renato Takao
/*
PARAMIXB[_n][1] = "XX" selecionada
PARAMIXB[_n][2] = fornece
PARAMIXB[_n][3] = loja
PARAMIXB[_n][13] = item
PARAMIXB[_n][5] = numpro
k1 - C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO
*/
USER FUNCTION MT160OK()

Local nPercLim	:= Getnewpar("MV_XLIMSC",5)
Local cGrpsOut	:= AllTrim(GetMv("MV_XGRPCC",,"ZZZZ"))
_lRet:=.T.
For _n:=1 to len(PARAMIXB)

	For _x:=1 to len(PARAMIXB[_n])
	
		If PARAMIXB[_n][_x][1] = "XX"
			dbselectarea("SC8")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SC8")+cA160num+PARAMIXB[_n][_x][2]+PARAMIXB[_n][_x][3]+PARAMIXB[_n][_x][13]+PARAMIXB[_n][_x][5])
				dbSelectArea("SC1")
				dbSetOrder(1)
				If dbSeek(xFilial("SC1")+SC8->(C8_NUMSC+C8_ITEMSC))
					If (SC1->C1_VUNIT < SC8->C8_PRECO) .And. NoRound(100 - (SC1->C1_VUNIT*100/SC8->C8_PRECO),2) > nPercLim
						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(xFilial("SB1")+SC1->C1_PRODUTO)
						If !(SB1->B1_GRUPO $ cGrpsOut)
							MsgAlert("Aten??o, o valor informado pelo solicitante ? menor do que O valor cotado para o item : "+SC8->C8_ITEM +". O limite m?ximo para diferen?a de valores ? de " + AllTrim(Str(nPercLim)) + "%. "+"A diferen?a ? de "+alltrim(STR(NoRound(100 - (SC1->C1_VUNIT * 100 / SC8->C8_PRECO),2)))+"%. **** PROCESSO N?O SER? FINALIZADO!!.")
							_lRet:=.F.
						EndIf
					EndIf
				Endif
			ENDIF
		ENDIF
	Next _x	
NEXT _n

RETURN(_lRet)