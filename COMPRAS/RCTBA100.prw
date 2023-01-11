#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCTBA100 � Autor �Bruno Daniel Borges � Data �  24/07/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina de PROVISAO de pedidos de compras por elemento PEP  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RCTBA100()
Private cCadastro 	:= "Provis�o de Pedidos de Compras por Elemento PEP"
Private aRotina 	:= {	{"Pesquisar"  ,"AxPesqui"	,0,1},;
			             	{"Visualizar" ,"AxVisual"	,0,2},;
			             	{"Provis�o"   ,"U_RCTB100a"	,0,4}}
			             	
//Filtra apenas os Elementos PEP do usuario logado
dbSelectArea("CTD")
CTD->(dbSetOrder(1))
mBrowse( 6,1,22,75,"CTD",,,,,,,,,,,,,,"CTD_FILIAL = '" + xFilial("CTD") + "' AND CTD__GESTO = '" + AllTrim(__cUserID) + "' AND SUBSTR(CTD_DTEVEN,1,6) <= '" + SubStr(DToS(dDataBase),1,6) + "' "  )

Return(Nil)
           
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RCTB100a �Autor  �Bruno Daniel Borges � Data �  24/07/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de provisao de pedidos de compras por gestor         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTB100a()
Local oDlgMain	   := Nil   
Local oList        := Nil
Local aAreaBKP	   := GetArea()
Local aPedidos     := {}  
Local aCoordenadas := MsAdvSize(.T.)
Local nOpClick     := 0   
Local nTotal       := 0  
Local i            := 0 
Local nHeadProv    := 0
Local lTemSelecao  := .F.
Local cQuery       := ""     
Local cItemSel     := "" 
Local cArqCTB      := ""
Local bQuery       := {|| IIf(Select("TRB_SC7") > 0, TRB_SC7->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB_SC7",.F.,.T.), dbSelectArea("TRB_SC7"), TRB_SC7->(dbGoTop()) }
Local cLote		   := GetMv("MV_XLOTECT",,"008850")

//Consulta os pedidos do elemento pep que obedecem ao filtro
cQuery := " SELECT C7_FILIAL, C7_NUM, C7_QUANT, C7_PRECO, C7_TOTAL, C7_EMISSAO, A2_NOME, A.R_E_C_N_O_ AS REGNO, B1_DESC "
cQuery += " FROM " + RetSQLName("SC7") + " A, " + RetSQLName("SA2") + " B, " + RetSQLName("SB1") + " C "
cQuery += " WHERE C7_FILIAL BETWEEN '  ' AND 'ZZ' AND "
cQuery += "       C7_CONAPRO = 'L' AND C7_QUJE <> C7_QUANT AND "
cQuery += "       A.D_E_L_E_T_ = ' ' AND C7__LA <> '3' AND C7_ITEMCTA = '" + CTD->CTD_ITEM + "' AND "
cQuery += "       A2_FILIAL = '" + xFilial("SA2") + "' AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND B.D_E_L_E_T_ = ' ' AND "
cQuery += "       B1_FILIAL = '" + xFilial("SB1") + "' AND B1_COD = C7_PRODUTO AND C.D_E_L_E_T_ = ' ' "
LJMsgRun("Buscando Pedidos de Compra","Aguarde...",{|| Eval(bQuery)})

If TRB_SC7->(Eof())
	MsgAlert(	"Aten��o, n�o h� pedidos de compras para esse elemento PEP p/ serem provisionados. Abaixo a regra para provis�o de pedidos: " + Chr(13)+Chr(10)+;
				" - Pedidos em aberto (sem NF de entrega) que o per�odo (M�s/Ano) de inicio do evento seja menor ou igual do que a data do sistema." )
	Return(Nil)				
Else
	TRB_SC7->(dbEval({|| AAdd(aPedidos,{	.F.,;
											TRB_SC7->C7_NUM,;
											TRB_SC7->C7_QUANT,;
											TRB_SC7->C7_PRECO,;
											TRB_SC7->C7_TOTAL,;
											SToD(TRB_SC7->C7_EMISSAO),;
											TRB_SC7->A2_NOME,;
											TRB_SC7->REGNO,;
											TRB_SC7->B1_DESC }) }))
EndIf 

//Tela de provisao de pedidos de compras
oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5],"Provis�o de Pedidos de Compras",,,,,,,,oMainWnd,.T.)
	@ 014,001 ListBox oList Var cItemSel Fields Header " ","Pedido","Quantidade","Pre�o Unit�rio","Total Pedido","Emiss�o","Fornecedor","Produto" Size oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-45 ;
		Pixel Of oDlgMain ;
		On dblClick( aPedidos[oList:nAt][1] := !aPedidos[oList:nAt][1] ) 
		oList:SetArray(aPedidos)
		oList:bLine := {||{	IIf(aPedidos[oList:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
							aPedidos[oList:nAt][2],;
							Transform(aPedidos[oList:nAt][3],"@E 999,999,999.99"),;
							Transform(aPedidos[oList:nAt][4],"@E 999,999,999.99"),;
							Transform(aPedidos[oList:nAt][5],"@E 999,999,999.99"),;
							aPedidos[oList:nAt][6],;
							aPedidos[oList:nAt][7],;
							aPedidos[oList:nAt][9] }}  

	EnchoiceBar(oDlgMain,{|| nOpClick := 1, oDlgMain:End()},{|| nOpClick := 0, oDlgMain:End()})
oDlgMain:Activate(,,,.T.)

//Gera a provisao dos pedidos marcados
If nOpClick == 1 
	Aeval(aPedidos,{|x| Iif(x[1],lTemSelecao := .T.,Nil) } )
	If lTemSelecao
		nHeadProv := HeadProva(cLote,"RCTBA100",Substr(cUsuario,7,6),@cArqCTB)
		
		For i := 1 To Len(aPedidos)
			If aPedidos[i,1]   
				//Posiciona na tabela p/ uso no LP 
				dbSelectArea("SC7")
				SC7->(dbGoTo(aPedidos[i,8]))
				nTotal += DetProva(nHeadProv,"015","RCTBA100",cLote)
			EndIf
		Next i
		
		RodaProva(nHeadProv,nTotal)
		cA100Incl(cArqCTB,nHeadProv,3,cLote,.T.,.F.)
		
		//Atualiza os pedidos provisionados
		For i := 1 To Len(aPedidos)
			If aPedidos[i,1]
				dbSelectArea("SC7")
				SC7->(dbGoTo(aPedidos[i,8]))
				SC7->(RecLock("SC7",.F.))
					SC7->C7__LA 	:= "3"
					SC7->C7_VLRPROV	:= IIF(SC7->C7_TXMOEDA > 0, SC7->C7_TOTAL * SC7->C7_TXMOEDA / SC7->C7_QUANT, SC7->C7_TOTAL / SC7->C7_QUANT )
				SC7->(MsUnlock())				
			EndIf
		Next i
	EndIf
EndIf

RestArea(aAreaBKP)

Return(Nil)