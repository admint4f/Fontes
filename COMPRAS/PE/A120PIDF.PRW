#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ A120PIDF บAutor  ณBruno Daniel Borges บ Data ณ  19/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada p/ filtrar apenas solicitacoes de contratosบฑฑ
ฑฑบ          ณna tela de inclusao de pedido de compras                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function A120PIDF()
Local aRetorno := {"",""}

If MsgYesNo("Deseja visualizar apenas solicita็๕es de compras de contratos ?"+CHR(10)+CHR(13)+"Para as solicita็๕es de compras, serแ aplicado o filtro da filial de entrega do pedido (cabe็alho).")
	aRetorno[1] := "C1_FILIAL == xFilial('SC1') .And. !Empty(C1__CONTRA) .And. C1_FORNECE+C1_LOJA == ca120Forn+ca120Loj" //Filtro xBase
	aRetorno[2] := ""
Else  // Inserido Takao para filtrar somente 
//	aRetorno[1] := "C1_FILENT == cFilialEnt" //Filtro xBase
	aRetorno[1] := 'C1_FILENT == cFilialEnt .And. C1_QUJE < C1_QUANT .And. C1_TPOP<>"P" .And. C1_APROV$" ,L" .And.( C1_COTACAO == "'+Space(Len(SC1->C1_COTACAO))+'" .Or. C1_COTACAO == "'+Replicate("X",Len(SC1->C1_COTACAO))+'")'+IIF(SC1->(FieldPos("C1_FLAGGCT"))>0.And.nTipoPed!=2,' .And. ((SC1->C1_QUJE > 0 .And. SC1->C1_FLAGGCT == " ") .Or. (SC1->C1_QUJE == 0 ))','') //Filtro xBase
	aRetorno[2] := ""
EndIf


Return(aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVld_Qtd_SC1บAutor  ณBruno Daniel Borges บ Data ณ  20/06/08   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao do campo QUANTIDADE na S.C. para nao per-บฑฑ
ฑฑบ          ณmitir inclusao de quantidade maiores do que o saldo contrato บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Vld_Qtd_SC1()
Local aAreaBKP := GetArea()
Local nPosCont := AScan(aHeader,{|x| AllTrim(x[2]) == "C1__CONTRA" })

If !Empty(aCols[N,nPosCont])
	dbSelectArea("SC3")
	SC3->(dbSetOrder(1))
	If SC3->(dbSeek(xFilial("SC3")+aCols[N,nPosCont])) .And. (SC3->C3_QUANT - SC3->C3_QUJE) < M->C1_QUANT
		MsgAlert("Aten็ใo, esse contrato nใo tem saldo suficiente para atender a essa quantidade solicitada. Altere a quantidade ou entre em contato com a แrea de Suprimentos.")
		Return(.F.)	
	EndIf
EndIf

RestArea(aAreaBKP)

Return(.T.)