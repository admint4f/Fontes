#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
/*/{Protheus.doc} T4FTJOBNF 
@description ** Fonte copiado da funГЦo padrЦo FATJOBNF - Job para cancelamento de notas, uso para gerar as notas **
@type function
@version 1.00
@author RogИrio Costa 
@since 13/10/2020
@param cTabela, character, Alias da MarkBrowse        
@param cSerie, character, Serie da Nota Fiscal a ser considerada 
@param lMostraCtb, logical, Mostra Lanc.Ctb.
@param lAglutCtb, logical, Aglut.Lancamentos  
@param lCtbOnLine, logical, Lct.Ctb.On-Line 
@param lCtbCusto, logical, Lct.Ctb.Custo On-Line
@param lReajusta, logical, Reajusta na mesma nota
@param nCalAcrs, numeric, Calc.Acr.Fin
@param nArredPrcLis, numeric, Arred.Prc.Unit
@param nFatMin, numeric, Valor Minimo para faturamento
@param lAtuSA7, logical, Atualiza Amarracao Cliente x Produto
@param lECF, logical, Cupom Fiscal
@param cDocumento, character, Numero do documento ( Pedido/Carga )
@param nIdJob, numeric, Numero do ID do Job 
@return return_type, return_description
/*/
User Function T4FTJOBNF(cTabela,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,nFatMin,lAtuSA7,lECF,cDocumento,nIdJob,cProdSC9,oSay,oGridPv,aDadosZAD)

	Local aArea     := GetArea()
	Local aAreaSC9  := SC9->(GetArea())
	Local aAreaZAD2 := ZAD->(GetArea())
	Local aQuebra   := {}
	Local aQuebra2  := {}
	Local aPvlNfs   := {}
	Local cKeySC9   := "C9_FILIAL+"
	Local cAuxKey   := ""
	Local cQrySc9   := ""
	Local cCursor1  := IIf(cTabela==Nil,"SC9",cTabela)
	Local cCursor2  := "SC9"
	Local cCursor3  := "SC9"
	Local cFldQry   := ""
	Local cPedido   := ""
	Local lQuebra   := .F.
	Local lContinua := .T.
	Local lConfirma := .T.
	Local lQuery    := .F.
	Local lAcima    := .F.
	Local lFilDAK   := cTabela == "DAK" .And. OsVlEntCom()<>1
	Local nPrcVen   := 0
	Local nItemNf   := 30 //a460NumIt(cSerie) -- DEFINE A QUANTIDADE DE ITENS POR NOTA
	Local nX        := 0
	Local nl		:= 0
	Local nTotal    := 0
	Local bWhile1   := {||.T.}
	Local bWhile2   := {||.T.}
	Local bWhile3   := {||.T.}
	Local cNota     := ""
	Local aNotas	:= {}

	dbSelectArea("ZAD")
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁVerifica o Fechamento do Estoque                                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	/*
	If ( MVUlmes() >= dDataBase )
		lContinua := .F.
	EndIf
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁVerifica o Fechamento do Fiscal                                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If ( !FisChkDt(dDataBase) )
		lContinua := .F.
	EndIf
*/
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁMontagem das querys necessarias a fim de otimizar o programa            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	TcSrvMap("SB2")
	SB2->(MsGoto(RecNo()))
	TcSrvMap("SB6")
	SB6->(MsGoto(RecNo()))
	TcSrvMap("SC9")
	SC9->(MsGoto(RecNo()))
	TcSrvMap("SF4")
	SF4->(MsGoto(RecNo()))
	TcSrvMap("SED")
	SED->(MsGoto(RecNo()))
	TCInternal(5,"*OFF")
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁInicializa as variaveis de otimizacao da rotina de documento de saida   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	MaNfsInit()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁProcessamento do Job                                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lContinua
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁAnalise dos itens do pedido de venda aptos a faturar                    Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		Do Case
		Case cTabela == "SC9"
			bWhile1 := {|| !Eof() .And. xFilial("SC9") == (cCursor1)->C9_FILIAL .And. (cCursor1)->C9_PEDIDO == cDocumento}
			bWhile2 := {|| !Eof() .And. xFilial("SC9") == (cCursor2)->C9_FILIAL .And. (cCursor1)->C9_PEDIDO == cDocumento}
			bWhile3 := {|| !Eof() .And. xFilial("SC9") == (cCursor3)->C9_FILIAL .And. (cCursor1)->C9_PEDIDO == cDocumento}
		Case cTabela == "DAK"
			cFilBrw += ".AND.DAK_FEZNF<>'1' "
			cQryBrw += " AND DAK_FEZNF<>'1' "
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁVerifica a necessidade do DAI                                           Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If ( lFilDAK )
				cCursor2:= "DAI"
				cQryBrw += "AND DAI.DAI_FILIAL='"+xFilial("DAI")+"' "
				cQryBrw += "AND DAI.DAI_COD=DAK.DAK_COD "
				cQryBrw += "AND DAI.DAI_SEQCAR=DAK.DAK_SEQCAR "
				cQryBrw += "AND DAI.D_E_L_E_T_ = ' ' "
				cQryBrw += "AND DAI.DAI_PEDIDO = SC9.C9_PEDIDO "
				bWhile1 := {|| !Eof() .And. (cCursor1)->DAK_FILIAL == xFilial("DAK") .AND. (cCursor1)->DAK_CARGA == cDocumento }
				bWhile2 := {|| !Eof() .And. (cCursor2)->DAI_FILIAL == xFilial("DAI") .AND. (cCursor2)->DAI_COD==(cCursor1)->DAK_COD .And. (cCursor2)->DAI_SEQCAR==(cCursor1)->DAK_SEQCAR}
				bWhile3 := {|| !Eof() .And. xFilial("SC9") == (cCursor3)->C9_FILIAL .AND. (cCursor3)->C9_CARGA==(cCursor1)->DAK_COD .And. (cCursor3)->C9_SEQCAR==(cCursor1)->DAK_SEQCAR}
				If lFilDAK
					cFldQry := ",DAI.DAI_FILIAL,DAI.DAI_COD,DAI.DAI_SEQCAR,DAI.DAI_FILPV,DAK.DAK_COD,DAK.DAK_SEQCAR,DAK.R_E_C_N_O_ DAKRECNO "
				Else
					cFldQry := ",DAI.DAI_FILIAL,DAI.DAI_COD,DAI.DAI_SEQCAR,DAK.DAK_COD,DAK.DAK_SEQCAR,DAK.R_E_C_N_O_ DAKRECNO "
				EndIf
			Else
				bWhile1 := {|| !Eof() .And. (cCursor1)->DAK_FILIAL == xFilial("DAK") .AND. (cCursor1)->DAK_CARGA == cDocumento}
				bWhile2 := {|| !Eof() .And. xFilial("SC9") == (cCursor3)->C9_FILIAL .AND. (cCursor3)->C9_CARGA==(cCursor1)->DAK_COD .AND. (cCursor3)->C9_SEQCAR==(cCursor1)->DAK_SEQCAR }
				bWhile3 := {|| !Eof() .And. xFilial("SC9") == (cCursor3)->C9_FILIAL .AND. (cCursor3)->C9_CARGA==(cCursor1)->DAK_COD .AND. (cCursor3)->C9_SEQCAR==(cCursor1)->DAK_SEQCAR}
				cFldQry := ",DAK.DAK_COD,DAK.DAK_SEQCAR,DAK.R_E_C_N_O_ DAKRECNO "
			EndIf
		EndCase
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁVerifica qual a Ordem em que a NFS deve ser gerada                      Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If !lFilDAK
			cKeySC9 += "C9_CARGA+C9_SEQCAR+"
			cKeySC9 += "C9_SEQENT+C9_AGREG+"
		Else
			cKeySC9 += "C9_CARGA+C9_SEQCAR+C9_SEQENT+"
			cKeySC9 += "C9_AGREG+"
		EndIf
		cKeySC9 += "C9_PEDIDO+"
		If ( SuperGetMv("MV_LIBGRUPO")=="S" )
			cKeySC9 += "C9_GRUPO+"
		EndIf
		dbSelectArea("SC9")
		dbSetOrder(1)
		cKeySC9 += IndexKey()
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁRetira os itens duplicados da ordem de Geracao da NFS                   Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cAuxKey := cKeySC9
		cKeySC9 := ""
		While ( (nX := At("+",cAuxKey))<>0 )
			If ( !SubStr(cAuxKey,1,nX-1)$cKeySC9 )
				cKeySC9 += "+"+SubStr(cAuxKey,1,nX-1)
			EndIf
			cAuxKey := SubStr(cAuxKey,nX+1)
		EndDo
		If ( !cAuxKey$cKeySC9 )
			cKeySC9 += "+"+cAuxKey
		EndIf
		cKeySC9 := SubStr(cKeySC9,2)
		If ExistBlock("M460ORD")
			cKeySC9 := ExecBlock("M460ORD",.F.,.F.,cKeySC9)
		EndIf
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁRealiza a Selecao do SC9 e da Tabela da Markbrowse se esta existir      Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

		If TcSrvType()<>"AS/400"
			cQrySC9 := ""
			cCursor1:= "MA460PROC"
			cCursor2:= cCursor1
			cCursor3:= cCursor2
			lQuery := .T.
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁMontagem dos campos do SC9                                              Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea("SC9")
			For nX := 1 To FCount()
				cQrySC9 += ","+FieldName(nX)
			Next nX
			Do Case
			Case "ORACLE"==Upper(TcGetDb())
				cQrySC9 := "SELECT DISTINCT /*+FIRST_ROWS*/ "+SubStr(cQrySC9,2)
			Case "CACHE"==Upper(TcGetDb())
				cQrySC9 := "SELECT "+SubStr(cQrySC9,2)
			OtherWise
				cQrySC9 := "SELECT DISTINCT "+SubStr(cQrySC9,2)
			EndCase
			cQrySC9 += ",SC9.R_E_C_N_O_ C9RECNO "
			cQrySC9 += ",SC5.R_E_C_N_O_ C5RECNO "
			cQrySC9 += ",SC6.R_E_C_N_O_ C6RECNO, SC6.C6_QTDENT, SC6.C6_QTDVEN "
			cQrySC9 += ",SE4.R_E_C_N_O_ E4RECNO "
			cQrySC9 += ",SB1.R_E_C_N_O_ B1RECNO "
			cQrySC9 += ",SB2.R_E_C_N_O_ B2RECNO "
			cQrySC9 += ",SF4.R_E_C_N_O_ F4RECNO "
			cQrySC9 += ",SF4.F4_ISS F4ISS "
			cQrySC9 += ",SC5.C5_MOEDA "
			cQrySC9 += cFldQry
			cQrySC9 += ",SB2.B2_LOCAL "
			cQrySC9 += "FROM "+RetSqlName("SC9")+" SC9 ,"
			If ( cTabela == "DAK" )
				cQrySC9 += RetSqlName(cTabela)+" "+cTabela+","
				cQrySC9 += RetSqlName("DAI")+" DAI,"
			EndIf
			cQrySC9 += RetSqlName("SC5")+" SC5 ,"
			cQrySC9 += RetSqlName("SC6")+" SC6 ,"
			cQrySC9 += RetSqlName("SE4")+" SE4 ,"
			cQrySC9 += RetSqlName("SB1")+" SB1 ,"
			cQrySC9 += RetSqlName("SB2")+" SB2 ,"
			cQrySC9 += RetSqlName("SF4")+" SF4  "
			cQrySC9 += "WHERE "
			If cTabela <> "SC9"
				cQrySC9 += "DAK.DAK_FILIAL='"+xFilial("DAK")+"' "+cQryBrw
			Else
				cQrySC9 += "SC9.C9_FILIAL='"+xFilial("SC9")+"' "
			EndIf
			cQrySC9 += " AND SC9.C9_PEDIDO='"+cDocumento+"'"
			cQrySC9 += " AND SC9.C9_BLCRED='"+Space(Len(SC9->C9_BLCRED))+"'"
			cQrySC9 += " AND SC9.C9_BLEST='"+Space(Len(SC9->C9_BLEST))+"'"
			cQrySC9 += " AND SC9.C9_BLWMS IN('  ','05','06','07') "
			cQrySC9 += " AND SC9.D_E_L_E_T_=' ' "
			cQrySC9 += " AND SC5.C5_FILIAL="+IIF(lFilDAK,OsFilQry("SC5","DAI.DAI_FILPV"),"'"+xFilial("SC5")+"'")
			cQrySC9 += " AND SC5.C5_NUM=SC9.C9_PEDIDO"
			cQrySC9 += " AND SC5.D_E_L_E_T_=' '"
			cQrySC9 += " AND SC6.C6_FILIAL="+IIf(lFilDAK,OsFilQry("SC6","DAI.DAI_FILPV"),"'"+xFilial("SC6")+"'")
			cQrySC9 += " AND SC6.C6_NUM=SC9.C9_PEDIDO"
			cQrySC9 += " AND SC6.C6_ITEM=SC9.C9_ITEM"


			If !Empty(cProdSC9)
				cQrySC9 += " AND SC6.C6_PRODUTO = '" + cProdSC9 + "'"
			EndIf

			cQrySC9 += " AND SC6.C6_PRODUTO=SC9.C9_PRODUTO"
			cQrySC9 += " AND SC6.D_E_L_E_T_=' '"
			cQrySC9 += " AND SE4.E4_FILIAL="+IIf(lFilDAK,OsFilQry("SE4","DAI.DAI_FILPV"),"'"+xFilial("SE4")+"'")
			cQrySC9 += " AND SE4.E4_CODIGO=SC5.C5_CONDPAG "
			cQrySC9 += " AND SE4.D_E_L_E_T_=' '"
			cQrySC9 += " AND SB1.B1_FILIAL="+IIf(lFilDAK,OsFilQry("SB1","DAI.DAI_FILPV"),"'"+xFilial("SB1")+"'")
			cQrySC9 += " AND SB1.B1_COD=SC9.C9_PRODUTO"
			cQrySC9 += " AND SB1.D_E_L_E_T_=' '"
			cQrySC9 += " AND SB2.B2_FILIAL="+IIf(lFilDAK,OsFilQry("SB2","DAI.DAI_FILPV"),"'" + xFilial("SB2") + "'")
			cQrySC9 += " AND SB2.B2_COD=SC9.C9_PRODUTO"
			cQrySC9 += " AND SB2.B2_LOCAL=SC9.C9_LOCAL"
			cQrySC9 += " AND SB2.D_E_L_E_T_=' '"
			cQrySC9 += " AND SF4.F4_FILIAL="+IIf(lFilDAK,OsFilQry("SF4","DAI.DAI_FILPV"),"'"+xFilial("SF4")+"'")
			cQrySC9 += " AND SF4.F4_CODIGO=SC6.C6_TES"
			cQrySC9 += " AND SF4.D_E_L_E_T_=' '"
			If lFilDAK
				cKeySC9 := StrTran(cKeySC9,"C9_PEDIDO","DAI_FILPV,C9_PEDIDO")
			EndIf
			cQrySC9 += " ORDER BY "+SqlOrder(cKeySC9)

			cQrySC9 := ChangeQuery(cQrySC9)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySC9),cCursor3,.F.,.T.)
		Else
			dbSetOrder(1)
			MsSeek(xFilial()+cDocumento)
		EndIf
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁVerifica as condicoes de quebra de nota fiscal                          Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lFilDAK
			aadd(aQuebra2,{"DAI->DAI_FILPV",})
		EndIf
		aadd(aQuebra,{"SC9->C9_CARGA",})
		aadd(aQuebra,{"SC9->C9_SEQCAR",})
		aadd(aQuebra,{"SC9->C9_AGREG",})
		aadd(aQuebra,{"SC9->C9_PEDIDO",})
		aadd(aQuebra,{"SC9->C9_CODISS",}) // INCLUSцO DE QUEBRA CONFORME DEFINIгцO ERICA - 21/10/2020
		If ( lQuery )
			aEval(aQuebra,{|x| x[1]:= SubStr(x[1],6)})
			aEval(aQuebra2,{|x| x[1]:= SubStr(x[1],6)})
		EndIf
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁProcessa o Arquivo do Browse                                            Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		dbSelectArea(cCursor1)
		While Eval(bWhile1)
			Do Case
			Case cCursor2 == "DAI" .And. cTabela == "DAK"
				dbSelectArea(cCursor2)
				dbSetOrder(1)
				MsSeek(xFilial("DAI")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
			Case cCursor2 == "SC9" .And. cTabela == "DAK"
				If !lQuery
					dbSelectArea(cCursor3)
					dbSetOrder(nIndSC9+1)
					MsSeek(xFilial("SC9")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
				EndIf
			EndCase
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//ЁProcessa a tabela vinculada ao browse                                   Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dbSelectArea(cCursor2)
			While Eval(bWhile2)
				If cTabela == "DAK"
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁVerifica a Filial nal qual deve ser gerada a Nota Fiscal de Saida       Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If lFilDAK
						If cFilAnt <> (cCursor2)->DAI_FILPV
							cFilAnt := (cCursor2)->DAI_FILPV
							MaNFSEnd()
							MaNFSInit()
						EndIf
					EndIf
					If !lQuery
						dbSelectArea(cCursor3)
						dbSetOrder(nIndSC9+1)
						MsSeek(xFilial("SC9")+(cCursor1)->DAK_COD+(cCursor1)->DAK_SEQCAR)
						If cCursor2 <> cCursor3
							(cCursor2)->(dbSkip())
						EndIf
					EndIf
				EndIf
				dbSelectArea(cCursor3)
				While Eval(bWhile3)
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁPosiciona Registros                                                     Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If ( !lQuery )
						dbSelectArea("SB1")
						dbSetOrder(1)
						MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)

						dbSelectArea("SC5")
						dbSetOrder(1)
						MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)

						dbSelectArea("SC6")
						dbSetOrder(1)
						MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

						dbSelectArea("SB2")
						dbSetOrder(1)
						MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)

						dbSelectArea("SF4")
						dbSetOrder(1)
						MsSeek(xFilial("SF4")+SC6->C6_TES)

						dbSelectArea("SE4")
						dbSetOrder(1)
						MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
					EndIf
					dbSelectArea(cCursor3)
					lConfirma := .T.
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁAtualiza os itens de Quebra                                             Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					aEval(aQuebra,{|x| x[2] := &(x[1])})
					aEval(aQuebra2,{|x| x[2] := &(x[1])})
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁInicializa as variaveis de quebra do SC9                                Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If lQuery
						cPedido := (cCursor3)->C9_PEDIDO
					Else
						cPedido := SC9->C9_PEDIDO
					EndIf
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//ЁEfetua a selecao dos registros                                          Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If ( !lQuery )
						If !( SC9->C9_BLCRED==Space(Len(SC9->C9_BLCRED)) .And.;
								SC9->C9_BLWMS$"05/06/07/  " .And.;
								SC9->C9_BLEST==Space(Len(SC9->C9_BLEST)) )
							lConfirma:= .F.
						EndIf
					EndIf
					If ( lConfirma )
						nPrcVen := C9_PRCVEN
						If ( !lQuery )
							dbSelectArea("SC5")
						EndIf
						If ( C5_MOEDA <> 1 )
							nPrcVen := A410Arred(xMoeda(nPrcVen,C5_MOEDA,1,dDataBase,8),"D2_PRCVEN")
						EndIf
						If ( !lQuery )
							dbSelectArea("SC9")
						EndIf
						If nPrcVen <> 0
							If Ma461QIsOk(aPvlNfs,IIf(!lQuery,"SC6",cCursor3),IIf(!lQuery,"SC9",cCursor3))
								aadd(aPvlNfs,{ C9_PEDIDO,;
									C9_ITEM,;
									C9_SEQUEN,;
									C9_QTDLIB,;
									nPrcVen,;
									C9_PRODUTO,;
									If(lQuery,F4ISS=="S",SF4->F4_ISS=="S"),;
										If(lQuery,C9RECNO,SC9->(RecNo())),;
											If(lQuery,C5RECNO,SC5->(RecNo())),;
												If(lQuery,C6RECNO,SC6->(RecNo())),;
													If(lQuery,E4RECNO,SE4->(RecNo())),;
														If(lQuery,B1RECNO,SB1->(RecNo())),;
															If(lQuery,B2RECNO,SB2->(RecNo())),;
																If(lQuery,F4RECNO,SF4->(RecNo())),;
																	If(lQuery,B2_LOCAL,SB2->B2_LOCAL),;
																		If(cTabela<>"DAK",0,If(lQuery,DAKRECNO,DAK->(RecNo())))})
																	Else
																		lAcima := .T.
																	EndIf
																Else
																	lTxMoeda := .T.
																EndIf
															EndIf
															dbSelectArea(cCursor3)
															dbSkip()
															//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
															//ЁPosiciona Registros                                                     Ё
															//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
															If ( !lQuery )
																dbSelectArea("SB1")
																dbSetOrder(1)
																MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)

																dbSelectArea("SC5")
																dbSetOrder(1)
																MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)

																dbSelectArea("SC6")
																dbSetOrder(1)
																MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

																dbSelectArea("SB2")
																dbSetOrder(1)
																MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)

																dbSelectArea("SF4")
																dbSetOrder(1)
																MsSeek(xFilial("SF4")+SC6->C6_TES)

																dbSelectArea("SE4")
																dbSetOrder(1)
																MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
															EndIf
															//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
															//ЁVerifica a quebra                                                       Ё
															//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
															lQuebra := .F.
															If ( aScan(aQuebra,{|x| If(!Empty(x[2]),&(x[1])<>x[2],.F.) }) <> 0 )
																lQuebra := .T.
															ElseIf ( aScan(aQuebra2,{|x| If(!Empty(x[2]),&(x[1])<>x[2],.F.) }) <> 0 )
																lQuebra := .T.
															EndIf

															If ( ExistBlock("M460NITE") )
																nItemNf := ExecBlock("M460NITE",.F.,.F.,{Len(aPvlNfs),aPvlNfs})
															EndIf

															If ( Len(aPvlNfs) >= nItemNf )
																lQuebra := .T.
															EndIf
															//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
															//ЁEfetua a Geracao da Nfs                                                 Ё
															//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
															dbSelectArea(cCursor3)

															SetFunName("MATA461")

															If ( lQuebra .Or. ( !Eval(bWhile3) .And. !Eval(bWhile2) ) )
																//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
																//ЁVerifica a quebra por numero de itens de nota fiscal                    Ё
																//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
																aEval(aPvlNfs,{|x| nTotal += NoRound(If(x[4]<>0,x[4],1)*x[5],2)})

																lCtbOnLine	:= 	.T. //OTIMIZAR GERAгцO
																lCtbCusto	:=	.F. //OTIMIZAR GERAгцO
																lAtuSA7		:=	.F. //OTIMIZAR GERAгцO
																lAglutCtb	:=	.F. //OTIMIZAR GERAгцO
																lMostraCtb	:=  .F.
																lReajusta	:=  .F.
																nCalAcrs	:=  0
																nArredPrcLis:=	2
																lAtuSA7		:=	.F.
																lECF		:=	.F.
																cEmbExp		:= ''

																dbSelectArea("SC6")
																dbSetOrder(1)

																If ( nTotal > nFatMin .And. !Empty(aPvlNfs) )

																	dbSelectArea("SC9")
																	dDataMoe   := dDatabase
																	lJunta	   := .F.

																	Pergunte("MT460A",.F.)
																	
																	//cNota :=MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF,,,,,,dDataMoe,lJunta)

																	cNota := MaPvlNfs(  /*aPvlNfs*/         aPvlNfs,;  // 01 - Array com os itens a serem gerados
																						/*cSerieNFS*/       cSerie,;    // 02 - Serie da Nota Fiscal
																						/*lMostraCtb*/      lMostraCtb,;       // 03 - Mostra LanГamento ContАbil
																						/*lAglutCtb*/       lAglutCtb,;       // 04 - Aglutina LanГamento ContАbil
																						/*lCtbOnLine*/      lCtbOnLine,;       // 05 - Contabiliza On-Line
																						/*lCtbCusto*/       lCtbCusto,;       // 06 - Contabiliza Custo On-Line
																						/*lReajuste*/       lReajusta,;       // 07 - Reajuste de preГo na Nota Fiscal
																						/*nCalAcrs*/        nCalAcrs,;         // 08 - Tipo de AcrИscimo Financeiro
																						/*nArredPrcLis*/    nArredPrcLis,;         // 09 - Tipo de Arredondamento
																						/*lAtuSA7*/         lAtuSA7,;       // 10 - Atualiza AmarraГЦo Cliente x Produto
																						/*lECF*/            lECF,;       // 11 - Cupom Fiscal
																						/*cEmbExp*/         cEmbExp,;   // 12 - NЗmero do Embarque de ExportaГЦo
																						/*bAtuFin*/         {||},;      // 13 - Bloco de CСdigo para complemento de atualizaГЦo dos tМtulos financeiros
																						/*bAtuPGerNF*/      {||},;      // 14 - Bloco de CСdigo para complemento de atualizaГЦo dos dados apСs a geraГЦo da Nota Fiscal
																						/*bAtuPvl*/         {||},;      // 15 - Bloco de CСdigo de atualizaГЦo do Pedido de Venda antes da geraГЦo da Nota Fiscal
																						/*bFatSE1*/         {|| .T. },; // 16 - Bloco de CСdigo para indicar se o valor do Titulo a Receber serА gravado no campo F2_VALFAT quando o parБmetro MV_TMSMFAT estiver com o valor igual a "2".
																						/*dDataMoe*/        dDataMoe,; // 17 - Data da cotaГЦo para conversЦo dos valores da Moeda do Pedido de Venda para a Moeda Forte
																						/*lJunta*/          lJunta)        // 18 - Aglutina Pedido Iguais

																	If !Empty(cNota)
																		If Alltrim(cSerie) == 'S'
																			If FWIsInCallStack('U_T4FPEDMAN')
																				cMsg := "TRANSMITINDO RPS: "+cNota+ " PARA PREFEITURA..."
																				oGridPv:SetIncMeter(1,cMsg)
																				U_T4F01TRNFE({},cSerie,cNota,'','',oSay,oGridPv)
																			EndIf
																		EndIf

																		If Alltrim(cSerie) == 'S' .OR. Alltrim(cSerie) == 'INT'

																			For nx:=1 to Len(aPvlNfs)
																				If SC6->(MsSeek(xFilial("SC6")+aPvlNfs[nx][1]+aPvlNfs[nx][2]+aPvlNfs[nx][6]))
																					If !EMPTY(SC6->C6_NOTA)
																						If FWIsInCallStack('U_T4FPEDMAN')
																							cMsg := "GRAVANDO NUMERO DA NOTA TABELA ZAD, PEDIDO: "+SC6->C6_NUM
																							oGridPv:SetIncMeter(1,cMsg)
																						EndIf

																						cQueryZAD1  := " UPDATE "+RetSqlName("ZAD") + " "			 	+ CRLF
																						cQueryZAD1  += "  SET ZAD_STATUS = '3' " 					 	+ CRLF
																						cQueryZAD1  += "  ,ZAD_SETOTV		= '"+SC6->C6_SERIE+"'" 	 	+ CRLF
																						cQueryZAD1  += "  ,ZAD_NFTOTV		= '"+SC6->C6_NOTA+"'" 	 	+ CRLF
																						cQueryZAD1	+= "  ,ZAD_OBS = 'Fim.Inc.NF:" + Alltrim(Time()) +"'"+ CRLF
																						cQueryZAD1	+= " WHERE ZAD_FILIAL 	= '01'"					  	+ CRLF
																						cQueryZAD1	+= " 	AND ZAD_DTVEND 	= '"+DTOS(DDATABASE)+"'" 	+ CRLF
																						cQueryZAD1	+= " 	AND ZAD_ITEMID 	> ' '" 						+ CRLF
																						cQueryZAD1  += " 	AND ZAD_EPEP 	= '" + SC6->C6_ITEMCC +"'"	+ CRLF
																						cQueryZAD1  += "  	AND ZAD_TKTID 	= '" + SC6->C6_CHASSI +"'"	+ CRLF
																						cQueryZAD1	+= " 	AND	ZAD_ITTYPE 	> ' '" 						+ CRLF
																						cQueryZAD1  += "  	AND ZAD_PEDIDO 	= '" + SC6->C6_NUM+ "'" 	+ CRLF
																						cQueryZAD1  += "  	AND ZAD_TPITEM 	= '" + SC6->C6_PEDCLI +"'"	+ CRLF
																						cQueryZAD1  += "  	AND ZAD_STATUS 	= 	'2'  " 					+ CRLF
																						cQueryZAD1  += "  	AND D_E_L_E_T_ = ' ' "						+ CRLF

																						nStatus := TcSqlExec(cQueryZAD1)
																						DBCommit()

																						If (nStatus < 0)
																							cErro :=  REPLICATE("*", 5)+ CRLF
																							cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
																							u_T4F01LOG(cErro)
																						EndIf
																					EndIf
																				EndIf
																			Next nx

																		Else
																			For nx:=1 to Len(aPvlNfs)
																				If SC6->(MsSeek(xFilial("SC6")+aPvlNfs[nx][1]+aPvlNfs[nx][2]+aPvlNfs[nx][6]))

																					If !EMPTY(SC6->C6_NOTA)
																						If FWIsInCallStack('U_T4FPEDMAN')
																							cMsg := "GRAVANDO NUMERO DA NOTA TABELA ZAD, PEDIDO: "+SC6->C6_NUM
																							oGridPv:SetIncMeter(1,cMsg)
																						EndIf

																						For nl:=1 To Len(aDadosZAD)

																							If SC6->C6_ITEM == aDadosZAD[nl][6]

																								cQueryZAD1  := " UPDATE "+RetSqlName("ZAD") + " "			 + CRLF
																								cQueryZAD1  += "  SET ZAD_STATUS = '3' " 					 + CRLF
																								cQueryZAD1  += "  ,ZAD_SETOTV		= '"+SC6->C6_SERIE+"'" 	 + CRLF
																								cQueryZAD1  += "  ,ZAD_NFTOTV		= '"+SC6->C6_NOTA+"'" 	 + CRLF
																								cQueryZAD1	+= "  ,ZAD_OBS = 'Fim.Inc.NF:" + Alltrim(Time()) +"'"+ CRLF
																								cQueryZAD1  += "  WHERE ZAD_FILIAL 	= '01'"					  	+ CRLF
																								cQueryZAD1	+= " 	AND ZAD_DTVEND 	= '"+DTOS(DDATABASE)+"'" 	+ CRLF
																								cQueryZAD1	+= " 	AND ZAD_ITEMID 	> ' '" 						+ CRLF
																								cQueryZAD1	+= " 	AND ZAD_EPEP = '"+aDadosZAD[nl][1]+"'" 		+ CRLF
																								cQueryZAD1  += "  	AND ZAD_TKTID 	= '"+aDadosZAD[nl][5]+"'" 	+ CRLF
																								cQueryZAD1	+= " 	AND ZAD_SLUID = '"+aDadosZAD[nl][3]+"'" 	+ CRLF
																								cQueryZAD1	+= " 	AND	ZAD_ITTYPE 	> ' '" 						+ CRLF
																								cQueryZAD1  += "  	AND ZAD_PEDIDO 	= '" + SC6->C6_NUM+ "'" 	+ CRLF
																								cQueryZAD1  += "  	AND ZAD_TPITEM 	= '"+aDadosZAD[nl][4]+"'" 	+ CRLF
																								cQueryZAD1  += "  	AND ZAD_STATUS 	= 	'2'  " 					+ CRLF

																								If Len(alltrim(aDadosZAD[nl][2])) > 3
																									cQueryZAD1	+= " AND ZAD_SEARCH = '"+aDadosZAD[nl][2]+"'" + CRLF
																								EndIf

																								cQueryZAD1  += "  AND D_E_L_E_T_ = ' ' "						+ CRLF

																								nStatus := TcSqlExec(cQueryZAD1)


																								If (nStatus < 0)
																									cErro :=  REPLICATE("*", 5)+ CRLF
																									cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
																									u_T4F01LOG(cErro)
																								EndIf
																							EndIf
																						Next nl
																					EndIf
																				EndIf
																			Next nx

																		EndIf

																	Else

																		cArqLog := SubStr( Time(),1,5 ) + ".log"
																		cMsgLog := MostraErro("\log_INTI", cArqLog) + CRLF

																		cLog :=  Alltrim(DTOC(DDATABASE))+"-"+" NЦo foi gerada nota para o pedido - " + aPvlNfs[1][1] + CRLF + cMsgLog

																		u_T4F01LOG(cLog)
																	EndIf
																EndIf

																nTotal  := 0
																aPvlNfs := {}
															EndIf
															dbSelectArea(cCursor3)
														EndDo
													EndDo
													If ( cCursor1 <> cCursor2 )
														dbSelectArea(cCursor1)
														dbSkip()
													EndIf
												EndDo
												//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
												//ЁRestaura a entrada da rotina                                            Ё
												//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
												If ( lQuery )
													dbSelectArea(cCursor3)
													dbCloseArea()
													dbSelectArea("SC9")
												EndIf
											EndIf

											RestArea(aAreaZAD2)
											RestArea(aAreaSC9)
											RestArea(aArea)

											Return()





