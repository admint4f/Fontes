#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONSANA   ºAutor  ³Microsiga           º Data ³  10/25/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CONSANA()

Local aAnalise := {}
Local oDlg
Local oLbx
Local cperg := "RSZL"
Local aAreaAnt  := GetArea()
// Local aPlanos := {}

Pergunte(cPerg,.T.)

DbSelectArea("SC7")
//dbSetOrder(18)
SC7->( DbOrderNickName("18") )
SC7->( DbSeek(xFilial("SC7")+mv_par01,.T.) )

While SC7->( !Eof() ) .And. ( SC7->C7_CHAVE1 <= mv_par01 )
	nome    := Posicione("SA2",1,xFilial("SA2")+Sc7->C7_FORNECE,"A2_NOME")
	produto := Posicione("SB1",1,xFilial("SB1")+Sc7->C7_PRODUTO,"B1_DESC")
	aAdd(aAnalise, { C7_PRODUTO, produto, C7_TOTAL, C7_FORNECE, nome, C7_NUM, C7_CHAVE1, C7_USUARIO, C7_ARTISTA, C7_ENCER, C7_EMISSAO, C7_ITEMCTA })
	artista := SC7->C7_ARTISTA
	SC7->( DdbSkip() )
EndDo

If Len(aAnalise) > 0
	Define MsDialog oDlg Title "Consulta da Analise: " + mv_par01 + ARTISTA From 0,0 To 516,791 Of oMainWnd Pixel
	@ 13,0 ListBox oLbx Fields Header "Produto","Descrição Produto","Total","Fornecedor","Nome","Numero","Analise","Usuario","Artista","Encerrado","Emissao","Elemento Pep" ;
	Size 382,220 Of oDlg Pixel
	oLbx:SetArray(aAnalise)
	oLbx:bLine := { || { aAnalise[oLbx:nAt,1],aAnalise[oLbx:nAt,2],transform(aAnalise[oLbx:nAt,3],"@E 9,999,999.99"),aAnalise[oLbx:nAt,4],aAnalise[oLbx:nAt,5],aAnalise[oLbx:nAt,6],aAnalise[oLbx:nAt,7],aAnalise[oLbx:nAt,8],aAnalise[oLbx:nAt,9],aAnalise[oLbx:nAt,10],aAnalise[oLbx:nAt,11],aAnalise[oLbx:nAt,12] } }
	
	Activate MsDialog oDlg Center On Init EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})
Else
	Aviso("ATENÇÃO !!!","Não Há Pedidos para a Analise " + AllTrim(aAnalise) + " !",{ " << Voltar " },2," " + AllTrim(mv_par01))
EndIf


RestArea(aAreaAnt)

Return
