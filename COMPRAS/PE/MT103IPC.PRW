#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍlÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT103IPC ºAutor  ³TOTVS		     º Data ³  12/08/13       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada utilizado para acertar a descricao do pro-º±±
±±º          ³ duto na importacao do pedido de compra                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SERVENG                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103IPC  

_nLinha := PARAMIXB[1]

dbSelectArea("SD1")
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_CC"})] 		:= SC7->C7_CC  
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_ITEMCTA"})]	:= SC7->C7_ITEMCTA
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_CLVL"})] 	:= SC7->C7_CLVL
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_T4FLROU"})]	:= SC7->C7_T4FLROU  
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_XCCAPR"})] 	:= SC7->C7_XCCAPR 
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_PREOPER"})] := SC7->C7_PREOPER
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_XDESC"})]     := SC7->C7_OBS

_cCdProdu	:= aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_COD"})]
aCols[_nLinha][AScan(aHeader,{|x|AllTrim(x[2])=="D1_DESCRI"})]	:= Posicione("SB1",1,xFilial("SB1")+_cCdProdu, "B1_DESC") 

Return(.t.)
