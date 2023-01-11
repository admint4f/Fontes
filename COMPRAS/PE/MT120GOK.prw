#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MT120GOK  ºAutor  ³microsiga       º Data ³  12/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na gravacao do pedido:no momento em que     ±±
±±º           o pedido de compra é gerado                                 º±±
±±ºUso       ³                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120GOK()
Local aArea		:= GetArea()
Local aAreaSC7	:= SC7->(GetArea())
Local aAreaSC1	:= SC1->(GetArea())
//Local _nTotSC7 := 0


IF !Inclui .AND. !altera    // Está excluindo
	// 2019_02_08_ THIAGO SOLICITA CORRIGIR O ZZE080, POIS O VALOR FOI ALTERADO NO PEDIDO E A TABELA ZZE FICA ERRADA
	_cHist  := "ADIANTAMENTO AUTOMATICO GERADO PELO PC "+CA120NUM
	_cQuery := "SELECT R_E_C_N_O_ REGZZE FROM "+RETSQLNAME("ZZE")+ " WHERE D_E_L_E_T_<>'*' AND ZZE_HISTOR = '"+_cHist+"' "
	IF SELECT("TMPZZE") <> 0
		dBSelectarea("TMPZZE")
		dBclosearea()
	ENDIF
	
	TCQUERY _cQuery New Alias "TMPZZE"
	
	IF !TMPZZE->(Eof())
		dBSelectarea("ZZE")
		dbgoto(TMPZZE->REGZZE)
		ZZE->(Reclock("ZZE",.F.))
		ZZE->(dBdelete())
		ZZE->(MSUnlock())
	ENDIF
	
	IF SELECT("TMPZZE") <> 0
		dBSelectarea("TMPZZE")
		dBclosearea()
	ENDIF
	
Endif



If Inclui .or. altera
	
	// 2019_02_08_ THIAGO SOLICITA CORRIGIR O ZZE080, POIS O VALOR FOI ALTERADO NO PEDIDO E A TABELA ZZE FICA ERRADA
	_cHist  := "ADIANTAMENTO AUTOMATICO GERADO PELO PC "+CA120NUM
	_cQuery := "SELECT R_E_C_N_O_ REGZZE FROM "+RETSQLNAME("ZZE")+ " WHERE D_E_L_E_T_<>'*' AND ZZE_HISTOR = '"+_cHist+"' "
	IF SELECT("TMPZZE") <> 0
		dBSelectarea("TMPZZE")
		dBclosearea()
	ENDIF
	
	TCQUERY _cQuery New Alias "TMPZZE"
	
	IF !TMPZZE->(Eof())
		
		If inclui
			dBSelectarea("ZZE")
			dbgoto(TMPZZE->REGZZE)
			ZZE->(Reclock("ZZE",.F.))
			ZZE->ZZE_VALOR := _nValPA
			ZZE->(MSUnlock())
		Else
			dBSelectarea("ZZE")
			dbgoto(TMPZZE->REGZZE)
			ZZE->(Reclock("ZZE",.F.))
			ZZE->(dBdelete())
			ZZE->(MSUnlock())
		Endif
		
	ENDIF
	
	IF SELECT("TMPZZE") <> 0
		dBSelectarea("TMPZZE")
		dBclosearea()
	ENDIF
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA))

	DbSelectArea("SC7")
	DbSetOrder(1)
	DbSeek(xFilial("SC7")+ca120num)
	While  !SC7->(Eof()) .AND. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7")+ca120num
		
		_Regra := Posicione("SF4",1,xFilial("SF4")+SC7->C7_TES,"F4_REGRA")

		// 2019_02_08_ THIAGO SOLICITA CORRIGIR O ZZE080, POIS O VALOR FOI ALTERADO NO PEDIDO E A TABELA ZZE FICA ERRADA
		dBSelectarea("SC1")
		dBSetOrder(1)
		IF dbSeek(xFilial("SC1")+SC7->(C7_NUMSC+C7_ITEMSC),.T.)
			
			SC1->(Reclock("SC1",.F.))
			SC1->C1_XVALPA := _nValPA
			SC1->(MSUnlock())
			
		ENDIF
		
		
		RecLock("SC7", .F.)
		SC7->C7_XTPCPR  := _cTpCpr
		SC7->C7_XSOLPA 	:= _cGeraPA
		SC7->C7_XVALPA 	:= _nValPA
		SC7->C7_XVENPA 	:= _dVencPA
		SC7->C7_XOBSAPR	:= _cObsAprov
		SC7->C7_XOBSFO	:= _cObsForn
		SC7->C7_WF		:= Space(1)
		SC7->C7_WFID	:= Space(10)
		SC7->C7_XMAILF  :=_eMailForn
		/*// Luiz Tapajós 18.07.2019 - Bloquear inclusao se informacoes da TES incompatíveis com Pessoa Fisica
				If _Regra<>"08" .and. sa2->a2_tipo="F"
				if !empty(SC7->C7_ITEMCTA)
					SC7->C7_TES := "181"
				else
					SC7->C7_TES := "182"
				endif
				EndIf
		*/
		If IsInCallStack("MATA110")
			SC7->C7_FILIAL := SC7->C7_FILENT
		EndIf
		
		SC7->(MsUnlock()  )
		SC7->( DbCommit() )
		//Grava Rateio SC para PC
		If Inclui .AND. !Empty(SC7->C7_NUMSC)
			SZ2->(DbSetOrder(4)) //Z2_FILIAL+Z2__SC1+Z2_TIPO
			lAchou := .F.
			If SZ2->( DbSeek(xFilial("SZ2")+SC7->C7_NUMSC ) )
				While !SZ2->( EOF() ) .AND. xFilial("SZ2")+SC7->C7_NUMSC == SZ2->(Z2_FILIAL+Z2__SC1)
					If SZ2->Z2_ITEMSC <> SC7->C7_ITEMSC
						SZ2->(DbSkip())
						Loop
					EndIf
					RecLock("SCH",.T.)
					SCH->CH_FILIAL	:= xFilial("SCH")
					SCH->CH_PEDIDO	:= SC7->C7_NUM
					SCH->CH_FORNECE	:= SC7->C7_FORNECE
					SCH->CH_LOJA	:= SC7->C7_LOJA
					SCH->CH_ITEMPD 	:= SC7->C7_ITEM
					SCH->CH_ITEM	:= SZ2->Z2_ITEM
					SCH->CH_PERC	:= SZ2->Z2_PERC
					SCH->CH_CC		:= SZ2->Z2_CC
					SCH->CH_CONTA	:= SZ2->Z2_CONTA
					SCH->CH_ITEMCTA	:= SZ2->Z2_ITEMCTA
					SCH->CH_CLVL	:= SZ2->Z2_CLVL
					SCH->(MsUnLock())
					lAchou := .T.
					SZ2->(DbSkip())
				EndDo
				If lAchou
					RecLock("SC7", .F.)
					SC7->C7_CC 		:= ""
					SC7->C7_RATEIO  := "1"
					SC7->(MsUnLock())
				EndIf
			EndIf
		EndIf
		
		SC7->(DbSkip() )
	Enddo
Endif
RestArea(aArea)
RestArea(aAreaSC1)
RestArea(aAreaSC7)
Return .t.
