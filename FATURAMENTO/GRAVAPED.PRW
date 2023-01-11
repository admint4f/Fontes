#include "protheus.ch"

// ESTA CUSTONMIZAÇÃO GERA PEDIDOS DE VENDA PARA FATURAMENTO DAS VENDAS DE SIGALOJA EFETUADAS. VENDAS FATURADAS.
// DEVEM SER REVISTAS AS REGRAS PARA TES
// DEVE SER REVISADO CODIGO PARA FAZER CONSISTENCIA DOS DADOS

// alterado 16/09/10 - Renato Takao
// mostrar mensagem do pedido gerado
// alimentação TES / EPEP / CCUSTO / CTA FISCAL

User Function GravaPed()

	Local aAmb  := GetArea()
	Local cPerg := "PV0001"
	Local _aPedidos:={}
	Local l1Filial,l1Num,l1Cliente,l1Loja,l1TipoCli,l1VlrTot,l1DtLim,l1Doc,l1Serie,l1Pdv,l1EmisNf,l1Operado,l1Emissao,l1CodShow,NumPV
	
	If Pergunte(cPerg,.T.)
	   GeraCup()
	EndIf
	
	RestArea(aAmb)
Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRAVAPED  ºAutor  ³Microsiga           º Data ³  04/13/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraCup()

	Local _cMsgNota		:= ""
	Local _cDescS		:= ""
	Local _cTES			:= ""
	Local _cItemCC		:= ""
	Local _cQuery		:= ""
	Local _cCtaPrd		:= ""
	Local _cItem		:= "001"
	Local _cAliasTMP	:= GetNextAlias()
	Local _aAliasSL1	:= SL1->(GetArea())
	Local _aAliasSL2	:= SL2->(GetArea())
	Local cQuery		:= ""
	Local _lSeek
	Local _lSeekIt
	Local __filial 		:= ""
	Local __codshow		:= ""
	Local __emisnf
	Local __l1serie		:= ""
	Local __doc    		:= "" 
	Local __produto 	:= ""
	Local __descri		:= ""
	Local __um        	:= ""
	Local __qtd       	:= 0
	Local __vlunit    	:= 0
	Local __vlitem    	:= 0
	Local __emissao
	
	Private _aCabPv		:= {}
	Private _aItemPv	:= {}
	Private lMsErroAuto	:= .F.

	/////////////////////////////////////////////////////////////////////////////////////////////////
	//| Autor | Denis Dias de Almeida | Data | 30/09/2015 | Hora | 19:22
	//| Motivo| Sistema não processa as Filiais 04/02
	/////////////////////////////////////////////////////////////////////////////////////////////////
	cQuery  := "SELECT * FROM "+RetSqlName("SL1")+" WHERE L1_FILIAL='"+xFilial("SL1")+"' AND D_E_L_E_T_=' ' AND L1_PDV IN ('"+Padr(mv_par03,TamSx3("L1_PDV")[1])+"') AND L1_DOC IN ('"+Padr(mv_par01,TamSx3("L1_DOC")[1])+"')"
	cQuery  := ChangeQuery(cQuery)
	dBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSL1",.F.,.T.)
	If( TMPSL1->( !eof() ) ) 
		__filial := TMPSL1->L1_FILIAL
		__codshow:= TMPSL1->L1_CODSHOW
		__emisnf := TMPSL1->L1_EMISNF
		__l1serie:= TMPSL1->L1_SERIE
		__doc    := TMPSL1->L1_DOC
	EndIf
	TMPSL1->( DbCloseArea() )	
	
	If !empty(__codshow) .and. !empty(__emisnf)
	                                                                                                    	
		Begin Transaction		
			DbSelectarea("SC5")
			/////////////////////////////////////////////////////////////////////////////////////////////////
			//| Autor | Denis Dias de Almeida | Data | 30/09/2015 | Hora | 19:22
			//| Motivo| Erro de rotina pois a mesma procura em parâmetro o último código de Pedido de Vendas
			//| 	  | alterado para pegar o ultimo pedido referenciando qualquer Filial do sistema sem 
			//|       | duplicar por Filial evitando _UNQ contratint error
			/////////////////////////////////////////////////////////////////////////////////////////////////			
			NumPv := Soma1(GetMv("MV_NUMPV"), TamSx3("C5_NUM")[1])
					
			_cDescS		:= AllTrim(Posicione("PA5",1,xFilial("PA5") + __codshow,"PA5_DESCRI"))
			_cMsgNota	:= "CONSUMO SHOW " + __codshow + " - " + TRIM(_cDescS) + " - CUPOM:" + alltrim(mv_par01) + " - ECF:" + alltrim(mv_par03) + "/ CONF. ART 135 DO RICMS/00"
			
			SC5->( dbSetOrder(1) )
			_lSeek := SC5->( dbSeek( xFilial("SC5")+Padr(NumPv,TamSx3("C5_NUM")[1]) ) ) 
                                                                                                                                              
			If RecLock("SC5", !_lSeek)
				SC5->C5_FILIAL	:= __filial
				SC5->C5_NUM		:= NumPv
				SC5->C5_TIPO	:= "N"
				SC5->C5_CLIENTE	:= "RECAEB"
				SC5->C5_LOJACLI	:= "01" 
				SC5->C5_CLIENT	:= "RECAEB"
				SC5->C5_LOJAENT	:= "01" 
				SC5->C5_TIPOCLI	:= "F"
				SC5->C5_NATUREZ	:= "101100"
				SC5->C5_CONDPAG	:= "FIX"
				SC5->C5_PAGTO	:= "B"
				SC5->C5_EMISSAO	:= Stod(__emisnf)
				SC5->C5_MOEDA	:= 1
				SC5->C5_MENNOTA	:= _cMsgNota
				SC5->C5_TIPLIB	:= "1" 
				SC5->C5_LIBEROK	:= "S" 
				SC5->C5_TPCARGA	:= "2" 
				SC5->C5_TXMOEDA	:= 1 
				SC5->C5_PARC1	:= 100
				SC5->C5_DATA1	:= Stod(__emisnf)
				SC5->(MsUnLock())
			EndIf			
			
			/////////////////////////////////////////////////////////////////////////////////////////////////
			//| Autor | Denis Dias de Almeida | Data | 30/09/2015 | Hora | 19:22
			//| Motivo| Sistema não processa as Filiais 04/02
			/////////////////////////////////////////////////////////////////////////////////////////////////
			cQuery  := "SELECT * FROM "+RetSqlName("SL2")+" WHERE L2_FILIAL='"+xFilial("SL2")+"' AND D_E_L_E_T_=' ' AND L2_SERIE IN ('"+Padr(__l1serie,TamSx3("L2_SERIE")[1])+"') AND L2_DOC IN ('"+Padr(__doc,TamSx3("L2_DOC")[1])+"')"
			cQuery  := ChangeQuery(cQuery)
			dBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSL2",.F.,.T.) 								
			/////////////////////////////////////////////////////////////////////////////////////////////////
			//| Autor | Denis Dias de Almeida | Data | 06/10/2015 | Hora | 15:11
			//| Motivo| Inclusão do campo TMPSL2->L2_ITEMCC no lugar da validação anterior pelo 
			//|       | Posicione na PA5 
			/////////////////////////////////////////////////////////////////////////////////////////////////
			If TMPSL2->( !eof() )	
				SC6->( dbSetOrder(1) )
				While ( TMPSL2->L2_SERIE == __l1serie .And. TMPSL2->L2_DOC == __doc )					
					_cTES		:= Iif(SL2->L2_TES == "803", "530", Iif(SL2->L2_TES == "802","523","530"))
					_cItemCC	:= TMPSL2->L2_ITEMCC  //AllTrim(Posicione("PA5",1,xFilial("PA5") + SL1->L1_CODSHOW,"PA5_ITEMCO"))
					_cCtaPrd	:= "1104020006"															
					__produto 	:= TMPSL2->L2_PRODUTO
					__descri	:= TMPSL2->L2_DESCRI
					__um        := TMPSL2->L2_UM
					__qtd       := TMPSL2->L2_QUANT
					__vlunit    := TMPSL2->L2_VRUNIT
					__vlitem    := TMPSL2->L2_VLRITEM
					__emissao	:= TMPSL2->L2_EMISSAO
					_lSeekIt := SC6->( dbSeek( xFilial("SC6")+Padr(NumPv,TamSx3("C6_NUM")[1])+Padr(_cItem,TamSx3("C6_ITEM")[1])+Padr(__produto,TamSx3("C6_PRODUTO")[1]) ) )
															
					If RecLock("SC6", !_lSeekIt)
						SC6->C6_FILIAL	:= __filial
						SC6->C6_NUM		:= NumPv
			  			SC6->C6_ITEM	:= _cItem
						SC6->C6_PRODUTO	:= __produto
						SC6->C6_DESCRI	:= __descri
						SC6->C6_UM		:= __um
						SC6->C6_QTDVEN	:= __qtd
						SC6->C6_PRCVEN	:= __vlunit
						SC6->C6_VALOR	:= __vlitem
						SC6->C6_TES		:= _cTES
						SC6->C6_CONTA	:= _cCtaPrd
						SC6->C6_ITEMCC	:= _cItemCC
						SC6->C6_CCUSTO	:= "03031102"
						SC6->C6_PREOPER	:= "R"
						SC6->C6_CLVL	:= "20"
						SC6->C6_ENTREG	:= Stod(__emissao)
						SC6->C6_LOCAL	:= "01"
						SC6->C6_CF		:= "5929" 
						SC6->C6_CLI		:= "RECAEB" 
						SC6->C6_LOJA	:= "01"	
						SC6->C6_TPOP	:= "F"
						SC6->( MsUnLock() )	
					EndIf
					TMPSL2->( DbSkip() )
					_cItem	:= Soma1(_cItem)
				End 
				TMPSL2->( DbCloseArea() )					

				PutMv("MV_NUMPV",NumPv)
				Aviso("Atencao!", "Pedido: " + numpv + " gerado com sucesso!",{"Ok"},1)
			
			Else
				Alert("O CUPOM: "+MV_PAR01+" NÃO FOI ENCONTRADO !"+CHR(13)+"Verifique se os itens do CUPOM foram processados corretamente.")
				DisarmTransaction()
				Break
			EndIf

		End Transaction
	Else
		Alert("O CUPOM: "+MV_PAR01+" NÃO FOI ENCONTRADO !"+CHR(13)+"Verifique se o CUPOM não foi emitido por outro PDV.")
	EndIf

	RestArea(_aAliasSL1)
	RestArea(_aAliasSL2)
	
Return( Nil )