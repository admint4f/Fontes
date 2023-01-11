#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MT120APV  ºAutor  ³mICROSIGA     º Data ³  01/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na gravacao do SCR   :no momento em que     ±±
±±º           o pedido de compra é gerado                                 º±±
±±ºUso       ³                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120APV
Local lRet := .t.
Local aArea		:= GetArea()
Local _cNumped  := SC7->C7_NUM
Local _cGrAprov := ""
Local _cCC		:= IIF( Empty(SC7->C7_XCCAPR), SC7->C7_CC, SC7->C7_XCCAPR)
Local _nRecSC7	:= SC7->( Recno() )
Local _lPreApro	:= .F.
Local lExec     := .F.



//Direcionamento conforme C.Custo
_cGrAprov := Posicione("CTT",1,xFilial("CTT")+_cCC,"CTT_XGRAPR")

//Caso C.Custo nao possuir Grupo Aprovacao PC nasce aprovado, caso contrario realiza analise rentabilidade
If !Empty(_cGrAprov)
	
	//Checagem de Analise Rentabilidade - Pre-aprovado = PCO T4F
	DbSelectArea("SC7")
	DbSetOrder(1)
	SC7->( DbSeek(xFilial("SC7")+_cNumped) )
	While !SC7->( EOF() ) .AND. xFilial("SC7")+_cNumped == SC7->(C7_FILIAL+C7_NUM)       
	
		//Garantir criação das tabelas envolvidas
		DbSelectArea("ZZF")
		DbSelectArea("ZZH")		
		DbSelectArea("ZZA")		
		
		If !Empty(SC7->C7_ITEMCTA) .AND. !Empty(SC7->C7_CONTA)
			cQry := "SELECT ZZF_FILIAL, ZZF_ANALIS, ZZF_ELEPEP, ZZF_CCUSTO, ZZA_CONTAB, ZZA_ORCAME, ZZH_CONTA, ZZF_STATUS, ZZH_TOTAL "
			cQry += " FROM " + RetSqlName("ZZF") + " ZZF "
			cQry += " INNER JOIN " + RetSqlName("ZZH") + " ZZH "
			cQry += " 	ON ZZH_FILIAL='" + xFilial("ZZH") + "' "
			cQry += " 	AND ZZH_ANALIS = ZZF_ANALIS "
			cQry += " 	AND ZZH.D_E_L_E_T_ = ' ' "
			cQry += " INNER JOIN " + RetSqlName("ZZA") + " ZZA "
			cQry += " 	ON ZZA_FILIAL='" + xFilial("ZZA") + "' "
			cQry += " 	AND ZZA_ORCAME = ZZH_CONTA "
			cQry += " 	AND ZZA.D_E_L_E_T_ = ' ' "
			cQry += " WHERE ZZF_FILIAL='" + xFilial("ZZF") + "' "
			cQry += " AND ZZF_ELEPEP='" + SC7->C7_ITEMCTA +"' "
			cQry += " AND ZZF_STATUS='A' "
			cQry += " AND ZZA_CONTAB='" + SC7->C7_CONTA + "' "
			cQry += " AND ZZF_CCUSTO = '"+_cCC+"' AND ZZF.D_E_L_E_T_=' ' "
			cQry := ChangeQuery(cQry)
			
			If Select("QRY") > 0
				QRY->( DbCloseArea() )
			EndIf
			DbUseArea(.T., "TOPCONN", TcGenQry( , , cQry), "QRY")
			
			If !QRY->( EOF() ) //Possui Analise Aprovada - Busca Total de pedidos com mesmo Ele.Pep e mesma Conta.
				cQry := " SELECT SUM(C7_TOTAL) AS C7_TOTAL FROM " + RetSqlName("SC7")
				cQry += " WHERE C7_FILIAL='" + xFilial("SC7") + "' AND C7_ITEMCTA='" +QRY->ZZF_ELEPEP + "'  "
				cQry += " AND C7_CONTA='" +QRY->ZZA_CONTAB + "' AND C7_RESIDUO=' ' AND D_E_L_E_T_= ' ' "
				cQry := ChangeQuery(cQry)
				
				If Select("QRY2") > 0
					QRY2->( DbCloseArea() )
				EndIf
				DbUseArea(.T., "TOPCONN", TcGenQry( , , cQry), "QRY2")
				
				If !QRY2->( EOF() )
					If QRY2->C7_TOTAL <= QRY->ZZH_TOTAL //Caso total dos PCs do msm EPEP e msm Cta for menor que Valor Pre-aprovado, o item é considerado pre-aprovado.
						_lPreApro := .T.
					Else
						_lPreApro := .F.
						Exit
					EndIf
				Else
					_lPreApro := .T.
				EndIf
				
			Else //Nao Possui Analise aprovada - PC sera direcionado para aprovacao
				_lPreApro := .F.
				Exit
			EndIf
			
		Else
			_lPreApro := .F.
			Exit
		EndIf
		
		SC7->(DbSkip())
	EndDo
	
	SC7->( DbGoTo(_nRecSC7) )
EndIf
     

If _lPreApro .or. Empty(_cGrAprov)

	If _lPreApro
		MsgInfo("Pedido de Compra com alçada aprovada via PCO.")
	EndIf       
	
	_cGrAprov	:= ""
	DbSelectArea("SC7")
	DbSetOrder(1)
	SC7->( DbSeek(xFilial("SC7")+_cNumped) )
	
	If Empty(Type("_cGeraPA"))
		lExec := .T.
	EndIf
	
	If (SC7->C7_XSOLPA = '2' .And. SC7->C7_XVALPA > 0 .And. !(Empty(SC7->C7_XVENPA)) ) 
		U_T4COMC01(_nValPA,_dVencPA) //Chama a função de geração da solicitação de PA (ZZE).
		lExec := .F.
	EndIf
	
	If lExec
	 	If _cGeraPA = '2' .And. _nValPA > 0 .And. !(Empty(_dVencPA)) 
	 		U_T4COMC01(_nValPA,_dVencPA) //Chama a função de geração da solicitação de PA (ZZE).
	 	EndIf
	EndIf
	
EndIf

RestArea(aArea)

Return _cGrAprov




