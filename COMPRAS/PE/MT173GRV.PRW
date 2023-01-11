#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT173GRV  ºAutor  ³desconhec.          º Data ³  desconhec. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada localizado na rotina de MATA173.           º±±
±±º          ³"Gera Autorizacao de Entrega por Contrato de Parceria"      º±±
±±º          ³Localizado apos a gravacao do Pedido de Compra baseado nos  º±±
±±º          ³Contratos de Entrega.                                       º±±
±±º          ³Complementa a gravacao do SC7.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRevisao   ³ Revisao e documentacao: Gilberto. Em: 08/11/2010           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PE MATA173 / T4F.                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT173GRV()
Local aArea:= GetArea()

//Local cEmail   := "mjusto@ciebrasil.com"
//Local cTexto   := SC3->C3_CONTAG + " " + SUBSTR(CUSUARIO,7,15)
//Local cTitulo  := "Novo Contrato " + SC3->C3_NUM

Reclock("SC7",.F.)
SC7->C7_PARCERI	:= SC3->C3_NUM
SC7->C7_CONTA 	:= SC3->C3_CONTA
SC7->C7_CONTAG	:= SC3->C3_CONTAG
SC7->C7_ITEMCTA	:= SC3->C3_ITEMCTA
SC7->C7_CLVL	:= SC3->C3_CLVL
SC7->C7_CC		:= SC3->C3_CC
SC7->C7_TES		:= "015"
SC7->C7_USUARIO	:= cUserName // SubStr(CUSUARIO,7,15)
SC7->C7_CHAVE1	:= "999"
SC7->(Msunlock())

//U_SendMail(cEmail,cTitulo,cTexto)
RestArea(aArea)
RETURN()
