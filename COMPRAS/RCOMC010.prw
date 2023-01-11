#INCLUDE "Protheus.ch"

#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOMC010 ºAutor  ³Bruno Daniel Borges º Data ³  02/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de consulta e exportacao p/ Excel do CONSOLIDADO     º±±
±±º          ³do MAPA DE COMPRAS                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCOMC010()
	Local aPerguntas	:= {} 
	Local cQuery		:= ""
	Local nTotReg		:= 0
	Local bQuery		:= {|| Iif(Select("TRB") > 0,TRB->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbEval({|| nTotReg++ })), TRB->(dbGoTop()) }

	//Grupo de Perguntas - Filtros do Relatorio
	Aadd(aPerguntas,{"RCOMC1","01","Filial Inicial"				,"mv_ch1"	,"C",02,00,"G","","mv_par01","","","","","","SM0",""})
	Aadd(aPerguntas,{"RCOMC1","02","Filial Final"	   			,"mv_ch2"	,"C",02,00,"G","","mv_par02","","","","","","SM0",""})
	Aadd(aPerguntas,{"RCOMC1","03","Emissão S.C. Inicial"		,"mv_ch3"	,"D",08,00,"G","","mv_par03","","","","","","",""})
	Aadd(aPerguntas,{"RCOMC1","04","Emissão S.C. Final"			,"mv_ch4"	,"D",08,00,"G","","mv_par04","","","","","","",""})
	Aadd(aPerguntas,{"RCOMC1","05","Centro Custo Inicial"		,"mv_ch5"	,"C",20,00,"G","","mv_par05","","","","","","CTT",""})
	Aadd(aPerguntas,{"RCOMC1","06","Centro Custo Final"	   		,"mv_ch6"	,"C",20,00,"G","","mv_par06","","","","","","CTT",""})
	Aadd(aPerguntas,{"RCOMC1","07","Elemento PEP Inicial"		,"mv_ch7"	,"C",20,00,"G","","mv_par07","","","","","","CTD",""})
	Aadd(aPerguntas,{"RCOMC1","08","Elemento PEP Final"	   		,"mv_ch8"	,"C",20,00,"G","","mv_par08","","","","","","CTD",""})
	Aadd(aPerguntas,{"RCOMC1","09","Necessidade Inicial"		,"mv_ch9"	,"D",08,00,"G","","mv_par09","","","","","","",""})
	Aadd(aPerguntas,{"RCOMC1","10","Necessidade Final"			,"mv_chA"	,"D",08,00,"G","","mv_par10","","","","","","",""})
	Aadd(aPerguntas,{"RCOMC1","11","Emissão P.C. Inicial"		,"mv_chB"	,"D",08,00,"G","","mv_par11","","","","","","",""})
	Aadd(aPerguntas,{"RCOMC1","12","Emissão P.C. Final"			,"mv_chC"	,"D",08,00,"G","","mv_par12","","","","","","",""})
	Aadd(aPerguntas,{"RCOMC1","13","Recebimento N.F. Inicial"	,"mv_chD"	,"D",08,00,"G","","mv_par13","","","","","","",""})
	Aadd(aPerguntas,{"RCOMC1","14","Recebimento N.F. Final"		,"mv_chE"	,"D",08,00,"G","","mv_par14","","","","","","",""})
	Aadd(aPerguntas,{"RCOMC1","15","Fase do Processo Compras"	,"mv_chF"	,"N",01,00,"C","","mv_par15","Solicitacao Compras","Pedido Compras","Estágio de N.F.","Estágio de Pagamento","","",""})
	Aadd(aPerguntas,{"RCOMC1","16","Ordem de Listagem"			,"mv_chG"	,"N",01,00,"C","","mv_par16","Filial + S.C.","Filial + Emissão S.C.","Filial + C.C.","","","",""})

	//------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
	//------------------------------------------------------------------- { Inicio }

	//ValidSX1(aPerguntas)

	//{ Fim } ----------------------------------------------------------------------	

	If !Pergunte("RCOMC1",.T.)
		Return(Nil)
	EndIf 

	//Query da consulta   
	cQuery := " SELECT DECODE(C1_FILENT,'  ',C1_FILIAL,C1_FILENT) AS FILIAL, C1_NUM, C1_PRODUTO, C1_DESCRI, C1_QUANT, C1_VUNIT, C1_EMISSAO, C1_CC, " + ENTER
	cQuery += "        C.AK_NOME AS APROV_SC, ZZ6_NIVEL, ZZ6_DTSAI, ZZ6_HRSAI, C1_PEDIDO, A2_NOME, A2_CGC, C7_EMISSAO, Y1_NOME, E.AK_NOME AS APROV_PC, " + ENTER
	cQuery += "        D1_SERIE, D1_DOC, D1_EMISSAO, MIN(E2_VENCREA) AS VENC_INI, MAX(E2_VENCREA) AS VENC_FIM, SUM(E2_SALDO) AS SALDO, " + ENTER
	cQuery += "        E4_DESCRI, CTT_DESC01, C1_FORNECE, C1_SOLICIT, C7_DATPRF, C1_OBS, MAX(C7_VALIPI) AS C7_VALIPI, MAX(C7_VALICM) AS C7_VALICM, SUM(C7_VALIR) AS C7_VALIR, SUM(C7_TOTAL) AS C7_TOTAL " + ENTER
	cQuery += " FROM " + RetSQLName("SC1") + " A, " + RetSQLName("ZZ6") + " B, " + RetSQLName("SAK") + " C, " + RetSQLName("SC7") + " D, " + RetSQLName("SAK") + " E, " + RetSQLName("SCR") + " F, " + RetSQLName("SY1") + " G, " + RetSQLName("SD1") + " H, " + RetSQLName("SA2") + " I, " + RetSQLName("SE2") + " J, " + RetSQLName("SE4") + " K, " + RetSQLName("CTT") + " L " + ENTER
	cQuery += " WHERE C1_FILIAL BETWEEN '  ' AND 'ZZ' AND " //Incluido apenas p/ uso do indice na base
	cQuery += "       C1_EMISSAO BETWEEN '" + DToS(mv_par03) + "' AND '" + DToS(mv_par04) +"' AND " + ENTER
	cQuery += "       C1_CC BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND " + ENTER
	cQuery += "       C1_ITEMCTA BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND " + ENTER
	cQuery += "       DECODE(C1_FILENT,'  ',C1_FILIAL,C1_FILENT) BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND " + ENTER
	cQuery += "       C1_DATPRF BETWEEN '" + DToS(mv_par09) + "' AND '" + DToS(mv_par10) + "' AND " + ENTER
	cQuery += "       A.D_E_L_E_T_ = ' ' AND " + ENTER
	cQuery += "       CTT_FILIAL(+) = '" + xFilial("CTT") + "' AND CTT_CUSTO(+) = C1_CC AND L.D_E_L_E_T_(+) = ' ' AND " + ENTER
	cQuery += "       ZZ6_FILIAL = C1_FILIAL AND ZZ6_SC = C1_NUM AND B.D_E_L_E_T_ = ' ' AND " + ENTER
	cQuery += "       C.AK_FILIAL = '" + xFilial("SAK") + "' AND C.AK_COD = ZZ6_APROV AND C.D_E_L_E_T_ = ' ' AND " + ENTER
	cQuery += "       C7_FILIAL(+) = DECODE(C1_FILENT,'  ',C1_FILIAL,C1_FILENT) AND C7_NUM(+) = C1_PEDIDO AND C7_ITEM(+) = C1_ITEMPED AND D.D_E_L_E_T_(+) = ' ' AND " + ENTER
	cQuery += "       C7_EMISSAO(+) BETWEEN '" + DToS(mv_par11) + "' AND '" + DToS(mv_par12) + "' AND " + ENTER
	cQuery += "       A2_FILIAL(+) = '" + xFilial("SA2") + "' AND A2_COD(+) = C7_FORNECE AND A2_LOJA(+) = C7_LOJA AND I.D_E_L_E_T_(+) = ' ' AND " + ENTER
	cQuery += "       CR_FILIAL(+) = C7_FILIAL AND CR_NUM(+) = C7_NUM AND CR_DATALIB(+) <> '        ' AND F.D_E_L_E_T_(+) = ' ' AND " + ENTER
	cQuery += "       E.AK_FILIAL(+) = '" + xFilial("SAK") + "' AND E.AK_COD(+) = CR_APROV AND E.D_E_L_E_T_(+) = ' ' AND " + ENTER
	cQuery += "       Y1_FILIAL(+) = '" + xFilial("SY1") + "' AND Y1_USER(+) = C7_USER AND G.D_E_L_E_T_(+) = ' ' AND " + ENTER
	cQuery += "       D1_FILIAL(+) = C7_FILIAL AND D1_PEDIDO(+) = C7_NUM AND D1_ITEMPC(+) = C7_ITEM AND H.D_E_L_E_T_(+) = ' ' AND " + ENTER
	cQuery += "       D1_EMISSAO(+) BETWEEN '" + DToS(mv_par13) +"' AND '" + DToS(mv_par14) + "' AND " + ENTER
	cQuery += "       E2_FILIAL(+) = '" + xFilial("SE2") + "' AND E2_PREFIXO(+) = D1_SERIE AND E2_NUM(+) = D1_DOC AND E2_FORNECE(+) = D1_FORNECE AND " + ENTER
	cQuery += "       E2_LOJA(+) = D1_LOJA AND J.D_E_L_E_T_(+) = ' ' AND " + ENTER
	cQuery += "       E4_FILIAL(+) = '" + xFilial("SE4") + "' AND E4_CODIGO(+) = C7_COND AND K.D_E_L_E_T_(+) = ' ' " + ENTER
	cQuery += " GROUP BY  DECODE(C1_FILENT,'  ',C1_FILIAL,C1_FILENT), C1_NUM, C1_PRODUTO, C1_DESCRI, C1_QUANT, C1_VUNIT, C1_EMISSAO, C1_CC, " + ENTER
	cQuery += "           C.AK_NOME , ZZ6_NIVEL, ZZ6_DTSAI, ZZ6_HRSAI, C1_PEDIDO, A2_NOME, A2_CGC, C7_EMISSAO, Y1_NOME, E.AK_NOME, " + ENTER
	cQuery += "           D1_SERIE, D1_DOC, D1_EMISSAO, E4_DESCRI, CTT_DESC01, C1_FORNECE, C1_SOLICIT, C7_DATPRF, C1_OBS " + ENTER
	cQuery := ChangeQuery(cQuery)

	LJMsgRun("Consultando Informações...","Aguarde...",bQuery)

	If TRB->(Eof())
		MsgAlert("Atenção, nenhuma informação foi encontrada com os parâmetros informados.")
		Return(Nil)
	EndIf

	Processa({|| RCOMC010_Prc(nTotReg) })

Return(Nil)                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMC010_PrcºAutor  ³Bruno Daniel Borges º Data ³  02/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de processamento e geracao do arquivo p/ abrir via     º±±
±±º          ³Excel                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RCOMC010_Prc(nTotReg)
	Local nHdl		:= 0
	Local i			:= 0
	Local cFile		:= ""
	Local cLinhaCSV	:= ""
	Local aCabec	:= {} 
	Local oExcel	:= Nil  
	Local aAreaSM0	:= SM0->(GetArea())

	//Cria o arquivo CSV
	cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
	cFile 	+= "\"+Upper(CriaTrab(Nil,.F.))+".CSV"
	nHdl	:= FCreate(cFile)

	If nHdl <= 0
		MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
		Return(Nil)
	EndIf

	//Monta o cabecalho
	AAdd(aCabec,{"UNIDADE"					,"C","FILIAL"			})
	AAdd(aCabec,{"SOLICITACAO"				,"C","C1_NUM"			})
	AAdd(aCabec,{"NOME SOLICITANTE"			,"C","C1_SOLICIT"		})
	AAdd(aCabec,{"CODIGO PRODUTO"			,"C","C1_PRODUTO"		})
	AAdd(aCabec,{"DESCRICAO PRODUTO"		,"C","C1_DESCRI"		})
	AAdd(aCabec,{"QUANTIDADE"				,"N","C1_QUANT"			})
	AAdd(aCabec,{"VALOR UNITARIO"			,"N","C1_VUNIT"			})
	AAdd(aCabec,{"EMISSAO"					,"D","C1_EMISSAO"		})
	AAdd(aCabec,{"CENTRO CUSTO"				,"C","C1_CC"			})
	AAdd(aCabec,{"DESCRICAO CENTRO CUSTO"	,"C","CTT_DESC01"		})
	AAdd(aCabec,{"APROVADOR S.C."			,"C","APROV_SC"			})
	AAdd(aCabec,{"NIVEL APROVADOR"			,"C","ZZ6_NIVEL"		})
	AAdd(aCabec,{"DATA APROVAÇÃO"			,"D","ZZ6_DTSAI"		})
	AAdd(aCabec,{"HORA APROVAÇÃO"			,"C","ZZ6_HRSAI"		})
	AAdd(aCabec,{"PEDIDO DE COMPRA"			,"C","C1_PEDIDO"		})
	AAdd(aCabec,{"VALOR TOTAL PEDIDO"		,"N","C7_TOTAL"			})
	AAdd(aCabec,{"CODIGO FORNECEDOR"		,"C","C1_FORNECEDOR"	})
	AAdd(aCabec,{"NOME FORNECEDOR"			,"C","A2_NOME"	 		})
	AAdd(aCabec,{"CNPJ FORNECEDOR"			,"C","A2_CGC"	 		})
	AAdd(aCabec,{"EMISSAO PEDIDO"			,"D","C7_EMISSAO"		})
	AAdd(aCabec,{"DATA ENTREGA"				,"D","C7_DATPRF"		})
	AAdd(aCabec,{"COMPRADOR"				,"C","Y1_NOME"	  		})
	AAdd(aCabec,{"APROVADOR PEDIDO"			,"C","APROV_PC"	  		})
	AAdd(aCabec,{"SERIE NF"					,"C","D1_SERIE"	  		})
	AAdd(aCabec,{"NUMERO NF"				,"C","D1_DOC"	  		})
	AAdd(aCabec,{"EMISSAO NF"				,"D","D1_EMISSAO" 		})
	AAdd(aCabec,{"PRIMEIRO VENCIMENTO"		,"D","VENC_INI"	   		})
	AAdd(aCabec,{"ULTIMO VENCIMENTO"		,"D","VENC_FIM"	   		})
	AAdd(aCabec,{"SALDO A PAGAR"			,"N","SALDO"	   		})
	AAdd(aCabec,{"CONDICAO DE PAGAMENTO"	,"C","E4_DESCRI"   		})
	AAdd(aCabec,{"OBSERVAÇÃO SOLICITAÇÃO"	,"C","C1_OBS"			})
	AAdd(aCabec,{"VALOR ICMS"				,"N","C7_VALICM"		})
	AAdd(aCabec,{"VALOR IMPOSTO RENDA"		,"N","C7_VALIR"			})

	For i := 1 To Len(aCabec)
		cLinhaCSV += aCabec[i,1] + ";"
	Next i                            
	FWrite(nHdl,cLinhaCSV+ENTER)

	ProcRegua(nTotReg)

	//Geracao do arquivo CSV
	While TRB->(!Eof())  
		IncProc()
		cLinhaCSV := ""

		For i := 1 To Len(aCabec)
			If aCabec[i,2] == "C"
				cLinhaCSV += TRB->&(aCabec[i,3])+";"
			ElseIf aCabec[i,2] == "D"
				cLinhaCSV += DToC(SToD(TRB->&(aCabec[i,3])))+";"
			ElseIf aCabec[i,2] == "N"
				cLinhaCSV += Transform(TRB->&(aCabec[i,3]),"@E 999,999,999.99")+";"
			EndIf
		Next i

		FWrite(nHdl,cLinhaCSV+ENTER)
		TRB->(dbSkip())
	EndDo   

	FClose(nHdl)
	oExcel := MSExcel():New()
	oExcel:WorkBooks:Open(cFile)
	oExcel:SetVisible(.T.)   

	RestArea(aAreaSM0)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidSX1 ºAutor  ³Bruno Daniel Borges º Data ³  22/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que valida as perguntas do SX1 e cria os novos regis-º±±
±±º          ³tros                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidSX1(aPergunt)
	Local aAreaBKP := GetArea()
	Local cGrpPerg := ""
	Local lTipLocl := .T.
	Local i

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	SX1->(dbGoTop())

	If Len(aPergunt) <= 0
		Return(Nil)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida as perguntas do usuario³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cGrpPerg := PadR(aPergunt[1,1],10)

	For i := 1 To Len(aPergunt)

		lTipLocl := !SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))	
		SX1->(RecLock("SX1",lTipLocl))
		SX1->X1_GRUPO		:= PadR(cGrpPerg,10)
		SX1->X1_ORDEM		:= aPergunt[i,2]
		SX1->X1_PERGUNT		:= aPergunt[i,3]
		SX1->X1_PERSPA		:= aPergunt[i,3]
		SX1->X1_PERENG		:= aPergunt[i,3] 
		SX1->X1_VARIAVL		:= aPergunt[i,4]
		SX1->X1_TIPO		:= aPergunt[i,5]
		SX1->X1_TAMANHO		:= aPergunt[i,6]
		SX1->X1_DECIMAL		:= aPergunt[i,7]
		SX1->X1_GSC			:= aPergunt[i,8]
		SX1->X1_VALID		:= aPergunt[i,09]
		SX1->X1_VAR01		:= aPergunt[i,10]
		SX1->X1_DEF01		:= aPergunt[i,11]
		SX1->X1_DEF02		:= aPergunt[i,12]
		SX1->X1_DEF03		:= aPergunt[i,13]
		SX1->X1_DEF04		:= aPergunt[i,14]
		SX1->X1_DEF05		:= aPergunt[i,15]
		SX1->X1_F3			:= aPergunt[i,16]
		SX1->X1_PICTURE		:= aPergunt[i,17]
		SX1->(MsUnlock())

	Next i
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	RestArea(aAreaBKP)

Return(Nil)