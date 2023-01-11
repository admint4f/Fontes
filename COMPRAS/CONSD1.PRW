#Include "Rwmake.Ch"

USER FUNCTION CONSD1()                          

Local aNota := {}   
Local oDlg
Local oLbx
// Local aPlanos := {}

local cperg := "RSD1"
Local aAreaAnt  := GetArea()

Pergunte(cPerg,.T.)

dbSelectArea("SD1")
dbSetOrder(10)
dbGotop()

DbSeek(xFilial("SD1")+mv_par01,.T.)


While !EOF() .And. SD1->D1_FILIAL = xFilial("SD1") .And. SD1->D1_FORNECE = mv_par01

        nome      := Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE,"A2_NOME")
        produto   := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC") 
		obsc7     := Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_OBS")
        usuc7     := Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_USUARIO")
        anac7     := Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_CHAVE1")
        ARTc7     := Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_ARTISTA")
        emic7     := Posicione("SC7",1,xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC,"C7_EMISSAO")        
        desccon   := Posicione("CT1",1,xFilial("CT1")+SD1->D1_CONTAG,"CT1_DESC01")
        descitem  := Posicione("CTD",1,xFilial("CTD")+SD1->D1_ITEMCTA,"CTD_DESC01")
        desccc    := Posicione("CTT",1,xFilial("CTT")+SD1->D1_CC,"CTT_DESC01")
        aAdd(aNota, { D1_DOC,D1_ITEM,D1_COD, PRODUTO, D1_QUANT, D1_VUNIT, D1_TOTAL, D1_CONTAG, DESCCON, D1_CC, DESCCC , D1_ITEMCTA, DESCITEM,D1_CLVL,  D1_PEDIDO, D1_ITEMPC, EMIC7, OBSC7, D1_FORNECE, NOME,  D1_EMISSAO,  D1_TES , USUC7, ANAC7, ARTC7 })
        

		dbSkip()
EndDo        
		If Len(aNota) > 0
//			Define MsDialog oDlg Title "Consulta da Analise: " + mv_par01 + c7_artista From 0,0 To 516,791 Of oMainWnd Pixel
            Define MsDialog oDlg Title "Consulta  "  From 0,0 To 516,791 Of oMainWnd Pixel
			@ 13,0 ListBox oLbx Fields Header "Nr.Documento","Item NF","Codigo Produto","Descrição Produto","Quant.","Vr.Unit.","Total","Conta Contabil","Descrição Conta","Centro Custo","Descrição Centro Custo","Elemento Pep","Descrição Elem.Pep","Divisão","Pedido","Item Pedido","Emissão Pedido","Observação Pedido","Cod.Fornec.","Nome","Emissão N.F.","Tes","Usuário","Analise","Artista" ;
							Size 382,220 Of oDlg Pixel
			oLbx:SetArray(aNota)
//			oLbx:bLine := { || { aNota[oLbx:nAt,1],transform(aNota[oLbx:nAt,2],"@E 9,999,999.99"),transform(aNota[oLbx:nAt,3],"@E 9,999,999.99"),transform(aNota[oLbx:nAt,4],"@E 9,999,999.99"),aNota[oLbx:nAt,5] } }
			oLbx:bLine := { || { aNota[oLbx:nAt,1],aNota[oLbx:nAt,2],aNota[oLbx:nAt,3],aNota[oLbx:nAt,4],aNota[oLbx:nAt,5],transform(aNota[oLbx:nAt,6],"@E 9,999,999.99"),transform(aNota[oLbx:nAt,7],"@E 9,999,999.99"),aNota[oLbx:nAt,8],aNota[oLbx:nAt,9],aNota[oLbx:nAt,10],aNota[oLbx:nAt,11],aNota[oLbx:nAt,12],aNota[oLbx:nAt,13],aNota[oLbx:nAt,14],aNota[oLbx:nAt,15],aNota[oLbx:nAt,16],aNota[oLbx:nAt,17],aNota[oLbx:nAt,18],aNota[oLbx:nAt,19],aNota[oLbx:nAt,20],aNota[oLbx:nAt,21],aNota[oLbx:nAt,22],aNota[oLbx:nAt,23],aNota[oLbx:nAt,24],aNota[oLbx:nAt,25] } }
			Activate MsDialog oDlg Center On Init EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})
		Else
		Aviso("ATENÇÃO !!!","Não Há Notas " + AllTrim(aNota) + " !",{ " << Voltar " },2," " )
	  	EndIf


RestArea(aAreaAnt)

Return
