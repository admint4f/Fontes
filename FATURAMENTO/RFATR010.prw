#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR010 º Autor ³ AP6 IDE            º Data ³  22/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de contratos x apropriacoes x faturamentos       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RFATR010()
	
	Local aBotoes	:= {}
	Local aSays		:= {}
	Local aPergunt	:= {}
	Local nOpcao	:= 0 

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	//Parametros da rotina
	Aadd(aPergunt,{"RFATR1","01","Do Cliente"	   		,"mv_ch1"	,"C",06,00,"G","","mv_par01","","","","","","SA1",""})
	Aadd(aPergunt,{"RFATR1","02","Ate o Cliente"   		,"mv_ch2"	,"C",06,00,"G","","mv_par02","","","","","","SA1",""})
	Aadd(aPergunt,{"RFATR1","03","Vigente Entre"   		,"mv_ch3"	,"D",08,00,"G","","mv_par03","","","","","","",""})
	Aadd(aPergunt,{"RFATR1","04","Vigente Ate"   		,"mv_ch4"	,"D",08,00,"G","","mv_par04","","","","","","",""}) 
	Aadd(aPergunt,{"RFATR1","05","Acumula Ate Data"		,"mv_ch5"	,"D",08,00,"G","","mv_par05","","","","","","",""}) 
	Aadd(aPergunt,{"RFATR1","06","Lista Saldo Por"		,"mv_ch6"	,"N",01,00,"C","","mv_par06","Mes/Ano","Ano","","","","",""}) 
	Aadd(aPergunt,{"RFATR1","07","Movimento"			,"mv_ch7"	,"N",01,00,"C","","mv_par07","Realizado","A Realizar","Ambos","","","",""}) 
	Aadd(aPergunt,{"RFATR1","08","Tipo Contrato"		,"mv_ch8"	,"N",01,00,"C","","mv_par08","Briefing","Contrato/Permuta","Todos","","","",""}) 
	Aadd(aPergunt,{"RFATR1","09","Status     "   		,"mv_ch9"	,"C",01,00,"G","","mv_par09","","","","","","Z0",""})
	// Gilberto - 03/02/2011
	Aadd(aPergunt,{"RFATR1","10","Dt.Inclusao de"   	,"mv_chA"	,"D",08,00,"G","","mv_par10","","","","","","",""})
	Aadd(aPergunt,{"RFATR1","11","Dt.Inclusao ate"		,"mv_chB"	,"D",08,00,"G","","mv_par11","","","","","","",""}) 

	ValidSX1(aPergunt)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	Pergunte("RFATR1",.F.)

	//Tela de aviso e acesso aos parametros
	AAdd(aSays,"[RELATÓRIO COM LISTA DE CONTRATOS x APROPRIAÇÕES E FATURAMENTOS]")
	AAdd(aSays,"Esse programa irá gerar a planilha contendo os contratos conforme")
	AAdd(aSays,"parâmetros e as parcelas de apropriação e/ou faturamento")

	AAdd(aBotoes,{ 5,.T.,{|| Pergunte("RFATR1",.T. ) } } )
	AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
	AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )        
	FormBatch( "Planilha de Contratos", aSays, aBotoes )

	If nOpcao == 1
		Processa({|| RFATR010_Prc()})
	EndIf

Return(Nil)      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATR010_Prc ºAutor  ³Bruno Daniel Borges º Data ³  22/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de geracao da planilha conforme parametros              º±±
±±º          ³                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFATR010_Prc() 
	Local cQuery	:= "" 
	Local cQueryZZ1	:= "" 
	Local cQueryZZ2	:= "" 
	Local cFile		:= ""
	Local cLinhaTXT	:= ""
	Local cLinhaCab	:= "" 
	Local cUltPer	:= ""
	Local cGroupBy	:= ""
	Local bQuery	:= {|| IIf(Select("TRB_REL") > 0, TRB_REL->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB_REL",.F.,.T.), dbSelectArea("TRB_REL"), TRB_REL->(dbEval({|| nTotReg++ })), TRB_REL->(dbGoTop()) }
	Local bQueryZZ1	:= {|| IIf(Select("TRB_ZZ1") > 0, TRB_ZZ1->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryZZ1),"TRB_ZZ1",.F.,.T.), dbSelectArea("TRB_ZZ1"), TRB_ZZ1->(dbGoTop()) }
	Local bQueryZZ2	:= {|| IIf(Select("TRB_ZZ2") > 0, TRB_ZZ2->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryZZ2),"TRB_ZZ2",.F.,.T.), dbSelectArea("TRB_ZZ2"), TRB_ZZ2->(dbGoTop()) }
	Local aPerAprop	:= {}
	Local aPerFat	:= {}
	Local nTotReg	:= 0 
	Local nHdlCSV	:= 0
	Local nPosPer	:= 0 
	Local oExcel	:= Nil       
	Local i

	//Query que lista os contratos
	//cQuery := " SELECT ZZ0_CONTRA, ZZ0_ELEPEP, ZZ0_CLIENT, A1_NOME, B1_DESC, ZZ0_VALOR, ZZ0_DATA1, ZZ0_DATA2, ZZ0_ITEM, DECODE(ZZ0_TPCONT,'1','CONTRATO','2','BRIEFING','3','PERMULTA','CONTRATO') AS ZZ0_TPCONT, CTD_DESC01, "
	cQuery := " SELECT ZZ0_CONTRA, ZZ0_ELEPEP, ZZ0_CLIENT, A1_NOME, B1_DESC, ZZ0_VALOR, ZZ0_DATA1, ZZ0_DATA2, ZZ0_ITEM, DECODE(ZZ0_TPCONT,'1','CONTRATO','2','BRIEFING','3','PERMUTA','CONTRATO') AS ZZ0_TPCONT, CTD_DESC01, "
	cQuery += "        ZZ0_CONTA, ZZ0_CTPIS, ZZ0_ALQPIS, ZZ0_CTCOF, ZZ0_ALQCOF, ZZ0_CTISS, ZZ0_ALQISS, ZZ0_CC, ZZ0_DTINC "
	cQuery += " FROM " + RetSQLName("ZZ0") + " A, " + RetSQLName("SA1") + " B, " + RetSQLName("SB1") + " C, " + RetSQLName("CTD") + " D "
	cQuery += " WHERE ZZ0_FILIAL = '" + xFilial("ZZ0") + "' AND ZZ0_CLIENT BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND "  
	cQuery += "       ZZ0_DATA1 >= '" + DToS(mv_par03) + "' AND ZZ0_DATA2 <= '" + DToS(mv_par04) + "' AND A.D_E_L_E_T_ = ' ' AND "
	cQuery += "       A1_FILIAL = '" + xFilial("SA1") + "' AND A1_COD = ZZ0_CLIENT AND A1_LOJA = ZZ0_LOJA AND B.D_E_L_E_T_ = ' ' AND "
	cQuery += "       B1_FILIAL = '" + xFilial("SB1") + "' AND B1_COD = ZZ0_PRODUT AND C.D_E_L_E_T_ = ' ' AND "  
	cQuery += "       CTD_FILIAL = '" + xFilial("CTD") + "' AND CTD_ITEM = ZZ0_ELEPEP AND D.D_E_L_E_T_ = ' ' " 

	If mv_par08 == 1
		cQuery += "       AND ZZ0_TPCONT = '2' "
	ElseIf mv_par08 == 2
		cQuery += "       AND ZZ0_TPCONT IN ('1','3') "
	EndIf

	If mv_par09 = "0"
		cQuery += " AND ZZ0_DATA2 < '" + DToS(dDataBase) + "' "
	ElseIf mv_par09 $ "1/2/3/4/5"
		cQuery += " AND ZZ0_STATUS = '" + mv_par09 + "' "
	ElseIf mv_par09 = "8"
		cQuery += " AND ZZ0_STATUS <> '5' "
	EndIf

	cQuery += " ORDER BY ZZ0_CONTRA, ZZ0_ITEM "
	LJMsgRun("Buscando Contratos","Aguarde",bQuery)

	ProcRegua(nTotReg)

	//Solicita diretorio de destino do arquivo 
	If nTotReg > 0
		cFile := AllTrim(cGetFile(, "Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
		cFile += Upper(AllTrim(CriaTrab(Nil,.F.)))+".CSV"
		nHdlCSV := FCreate(cFile)
		If nHdlCSV <= 0
			MsgAlert("Não foi possível criar a planilha com os dados de contratos no diretório informado. Verifique as permissões de acesso desse diretório.")
			Return(Nil)
		EndIf
	EndIf

	//Monta periodos a serem listados 
	TRB_REL->(dbGoTop())
	While TRB_REL->(!Eof())    

		//Busca Periodos da Apropriacao
		If mv_par06 == 1
			cQueryZZ1 := " SELECT DISTINCT SUBSTR(ZZ1_DATA,1,6) AS PERIODO "
		Else
			cQueryZZ1 := " SELECT DISTINCT SUBSTR(ZZ1_DATA,1,4) AS PERIODO "
		EndIf
		cQueryZZ1 += " FROM " + RetSQLName("ZZ1")
		cQueryZZ1 += " WHERE ZZ1_FILIAL = '" + xFilial("ZZ1") + "' AND ZZ1_CONTRA = '" + TRB_REL->ZZ0_CONTRA + "' AND D_E_L_E_T_ = ' ' AND "
		cQueryZZ1 += " 	     ZZ1_DATA > '" + DToS(mv_par05) + "' AND ZZ1_ITEM = '"  + TRB_REL->ZZ0_ITEM + "' "
		If mv_par07 == 1 //Movimentos Realizados
			cQueryZZ1 += "       AND ZZ1_LA = 'S' "
		ElseIf mv_par07 == 2 //Movimentos a Realizar
			cQueryZZ1 += "       AND ZZ1_LA <> 'S' "
		EndIf

		Eval(bQueryZZ1)
		TRB_ZZ1->(dbGoTop()) 
		TRB_ZZ1->(dbEval({|| 	nPosPer := AScan(aPerAprop,{|x| x == TRB_ZZ1->PERIODO}),;
		Iif(nPosPer <= 0,AAdd(aPerAprop,TRB_ZZ1->PERIODO),Nil) }))

		//Busca Periodos de Faturamentos
		If mv_par06 == 1
			cQueryZZ2 := " SELECT DISTINCT SUBSTR(ZZ2_VENCTO,1,6) AS PERIODO "
		Else
			cQueryZZ2 := " SELECT DISTINCT SUBSTR(ZZ2_VENCTO,1,4) AS PERIODO "
		EndIf
		cQueryZZ2 += " FROM " + RetSQLName("ZZ2")
		cQueryZZ2 += " WHERE ZZ2_FILIAL = '" + xFilial("ZZ2") + "' AND ZZ2_CONTRA = '" + TRB_REL->ZZ0_CONTRA + "' AND D_E_L_E_T_ = ' ' AND "
		cQueryZZ2 += " 	     ZZ2_VENCTO > '" + DToS(mv_par05) + "' AND ZZ2_ITEM = '"  + TRB_REL->ZZ0_ITEM + "' "  
		If mv_par07 == 1 //Movimentos Realizados
			//cQueryZZ2 += "       AND ZZ2_PEDIDO <> '      ' "
			cQueryZZ2 += " AND (EXISTS (SELECT F2_DOC FROM " + RetSQLName("SF2") + " SF2 WHERE F2_FILIAL = ZZ2_FILIAL " 
			cQueryZZ2 += " AND F2_SERIE = ZZ2_SERNF AND F2_DOC = ZZ2_NUMNF AND SF2.d_e_l_e_t_ = ' ') OR ZZ2_SERNF = 'XXX') "
		ElseIf mv_par07 == 2 //Movimentos a Realizar
			cQueryZZ2 += " AND ZZ2_SERNF <> 'XXX' "
			cQueryZZ2 += " AND NOT EXISTS (SELECT F2_DOC FROM " + RetSQLName("SF2") + " SF2 WHERE F2_FILIAL = ZZ2_FILIAL " 
			cQueryZZ2 += " AND F2_SERIE = ZZ2_SERNF AND F2_DOC = ZZ2_NUMNF AND SF2.d_e_l_e_t_ = ' ') "
		EndIf

		Eval(bQueryZZ2) 
		TRB_ZZ2->(dbGoTop())
		TRB_ZZ2->(dbEval({|| 	nPosPer := AScan(aPerFat,{|x| x == TRB_ZZ2->PERIODO}),;
		Iif(nPosPer <= 0,AAdd(aPerFat,TRB_ZZ2->PERIODO),Nil) }))

		TRB_REL->(dbSkip())
	EndDo  

	ASort(aPerFat,,,{|x,y| x < y})
	ASort(aPerAprop,,,{|x,y| x < y})

	//Linha de cabecalho da planilha
	//cLinhaCab := "Contrato;Tipo Contrato;Elemento PEP;Descrição Elemento PEP;Conta Fiscal;Descriçãos;Centro Custo;Descrição;Conta PIS;Descrição;Aliquota PIS;Conta COFINS;Descrição;Aliquota COFINS;Conta ISS;Descrição;Aliquota ISS;Código Cliente;Nome Cliente;Nome Produto;Valor Contrato;Data Inicio;Data Final;Saldo Até " + DToC(mv_par05)+";"
	//cLinhaTXT := ";;;;;;;;;;;;;;;;;;;;;Vigencia;;"+ Iif(mv_par07==1,"Parcelas Faturadas;",Iif(mv_par07 == 2,"Parcelas a Faturar;","Parcelas Faturadas/Faturar;"))+Replicate(";",Len(aPerFat))+Iif(mv_par07==1,"Parcelas Apropriadas",Iif(mv_par07 == 2,"Parcelas a Apropriar","Parcelas Apropriadas/A Apropriar"))+Chr(13)+Chr(10)
	//AEval(aPerFat,{|x| cLinhaCab += Iif(mv_par06 == 1,SubStr(x,5,2)+"/"+SubStr(x,1,4),x)+";" })
	//cLinhaCab += "Saldo Até " + DToC(mv_par05)+";"
	//AEval(aPerAprop,{|x| cLinhaCab += Iif(mv_par06 == 1,SubStr(x,5,2)+"/"+SubStr(x,1,4),x)+";" })
	//cLinhaCab += Chr(13)+Chr(10)

	cLinhaTXT := "        ;             ;            ;                      ;            ;          ;            ;         ;         ;         ;            ;            ;         ;               ;         ;         ;            ;              ;            ;            ;              ;             ;Vigencia   ;          ;"+ Iif(mv_par07==1,"Parcelas Faturadas;",Iif(mv_par07 == 2,"Parcelas a Faturar;","Parcelas Faturadas;Parcelas a Faturar;"))+Replicate(";",Len(aPerFat))+Iif(mv_par07==1,"Parcelas Apropriadas",Iif(mv_par07 == 2,"Parcelas a Apropriar","Parcelas Apropriadas;Parcelas a Apropriar"))+Chr(13)+Chr(10)
	cLinhaCab := "Contrato;Tipo Contrato;Elemento PEP;Descrição Elemento PEP;Conta Fiscal;Descriçãos;Centro Custo;Descrição;Conta PIS;Descrição;Aliquota PIS;Conta COFINS;Descrição;Aliquota COFINS;Conta ISS;Descrição;Aliquota ISS;Código Cliente;Nome Cliente;Nome Produto;Valor Contrato;Data Inclusao;Data Inicio;Data Final;Até " + DToC(mv_par05)+";"
	cLinhaCab += IiF(mv_par07==3,";","")
	AEval(aPerFat,{|x| cLinhaCab += Iif(mv_par06 == 1,SubStr(x,5,2)+"/"+SubStr(x,1,4),x)+";" })
	cLinhaCab += "Até " + DToC(mv_par05)+";"+IiF(mv_par07==3,";","")
	AEval(aPerAprop,{|x| cLinhaCab += Iif(mv_par06 == 1,SubStr(x,5,2)+"/"+SubStr(x,1,4),x)+";" })
	cLinhaCab += Chr(13)+Chr(10)



	If Len(aPerFat)	<= 0 .And. Len(aPerAprop)	<= 0
		MsgAlert("Atenção, nenhum contrato foi localizado nessa filial com os parametros informados.")
		Return(Nil)
	EndIf

	FWrite(nHdlCSV,cLinhaTXT+cLinhaCab)

	//Impressao do Relatorio
	TRB_REL->(dbGoTop())
	While TRB_REL->(!Eof())
		cLinhaTXT := 	AllTrim(TRB_REL->ZZ0_CONTRA+"-"+TRB_REL->ZZ0_ITEM)+";"+AllTrim(TRB_REL->ZZ0_TPCONT)+";"+AllTrim(TRB_REL->ZZ0_ELEPEP)+";"+AllTrim(TRB_REL->CTD_DESC01)+";"+;
		AllTrim(TRB_REL->ZZ0_CONTA)+";"+Posicione("CT1",1,xFilial("CT1")+AllTrim(TRB_REL->ZZ0_CONTA),"CT1->CT1_DESC01")+";"+;
		AllTrim(TRB_REL->ZZ0_CC)+";"+Posicione("CTT",1,xFilial("CTT")+AllTrim(TRB_REL->ZZ0_CC),"CTT->CTT_DESC01")+";"+;
		AllTrim(TRB_REL->ZZ0_CTPIS)+";"+Posicione("CT1",1,xFilial("CT1")+AllTrim(TRB_REL->ZZ0_CTPIS),"CT1->CT1_DESC01")+";"+Transform(TRB_REL->ZZ0_ALQPIS,"@E 999.99")+";"+;
		AllTrim(TRB_REL->ZZ0_CTCOF)+";"+Posicione("CT1",1,xFilial("CT1")+AllTrim(TRB_REL->ZZ0_CTCOF),"CT1->CT1_DESC01")+";"+Transform(TRB_REL->ZZ0_ALQCOF,"@E 999.99")+";"+;
		AllTrim(TRB_REL->ZZ0_CTISS)+";"+IIf(!Empty(TRB_REL->ZZ0_CTISS),Posicione("CT1",1,xFilial("CT1")+AllTrim(TRB_REL->ZZ0_CTISS),"CT1->CT1_DESC01"),"")+";"+Transform(TRB_REL->ZZ0_ALQISS,"@E 999.99")+";"+;
		TRB_REL->ZZ0_CLIENT+";"+AllTrim(TRB_REL->A1_NOME)+";"+AllTrim(TRB_REL->B1_DESC)+";"+Transform(TRB_REL->ZZ0_VALOR,"@E 999,999,999.99")+";"+DToC(SToD(TRB_REL->ZZ0_DTINC))+";"+DToC(SToD(TRB_REL->ZZ0_DATA1))+";"+DToC(SToD(TRB_REL->ZZ0_DATA2))+";"

		//Busca as parcelas faturadas a partir da data do parametro          
		cQueryZZ2a := " SELECT SUM(ZZ2_VALOR) AS TOT_FAT FROM " + RetSQLName("ZZ2")
		cQueryZZ2a += " WHERE ZZ2_FILIAL = '" + xFilial("ZZ2") + "' AND ZZ2_CONTRA = '" + TRB_REL->ZZ0_CONTRA + "' AND ZZ2_VENCTO <= '" + DToS(mv_par05) + "' AND D_E_L_E_T_ = ' ' AND ZZ2_ITEM = '"  + TRB_REL->ZZ0_ITEM + "' "

		cQueryZZ2b := " AND (EXISTS (SELECT F2_DOC FROM " + RetSQLName("SF2") + " SF2 WHERE F2_FILIAL = ZZ2_FILIAL " 
		cQueryZZ2b += " AND F2_SERIE = ZZ2_SERNF AND F2_DOC = ZZ2_NUMNF AND SF2.d_e_l_e_t_ = ' ') OR ZZ2_SERNF = 'XXX')

		cQueryZZ2c := " AND ZZ2_SERNF <> 'XXX' "
		cQueryZZ2c += " AND NOT EXISTS (SELECT F2_DOC FROM " + RetSQLName("SF2") + " SF2 WHERE F2_FILIAL = ZZ2_FILIAL " 
		cQueryZZ2c += " AND F2_SERIE = ZZ2_SERNF AND F2_DOC = ZZ2_NUMNF AND SF2.d_e_l_e_t_ = ' ')

		If mv_par07 == 1 //Movimentos Realizados
			cQueryZZ2 := cQueryZZ2a+cQueryZZ2b
			Eval(bQueryZZ2)
			TRB_ZZ2->(dbGoTop())
			Iif(TRB_ZZ2->(!Eof()),cLinhaTXT += Transform(TRB_ZZ2->TOT_FAT,"@E 999,999,999.99")+";" ,cLinhaTXT += "0;")
		ElseIf mv_par07 == 2 //Movimentos a Realizar
			cQueryZZ2 := cQueryZZ2a+cQueryZZ2c
			Eval(bQueryZZ2)
			TRB_ZZ2->(dbGoTop())
			Iif(TRB_ZZ2->(!Eof()),cLinhaTXT += Transform(TRB_ZZ2->TOT_FAT,"@E 999,999,999.99")+";" ,cLinhaTXT += "0;")
		ElseIf mv_par07 == 3 //ambos
			cQueryZZ2 := cQueryZZ2a+cQueryZZ2b
			Eval(bQueryZZ2)
			TRB_ZZ2->(dbGoTop())
			Iif(TRB_ZZ2->(!Eof()),nFat := TRB_ZZ2->TOT_FAT,nFat := 0)
			cQueryZZ2 := cQueryZZ2a+cQueryZZ2c
			Eval(bQueryZZ2)
			TRB_ZZ2->(dbGoTop())
			Iif(TRB_ZZ2->(!Eof()),naFat := TRB_ZZ2->TOT_FAT,naFat := 0)
			cLinhaTXT += Transform(nFat,"@E 999,999,999.99")+";"+Transform(naFat,"@E 999,999,999.99")+";" 
		EndIf


		If mv_par06 == 1
			cQueryZZ2 	:= " SELECT SUBSTR(ZZ2_VENCTO,1,6) AS PERIODO, SUM(ZZ2_VALOR) AS ZZ2_VALOR "
			cGroupBy 	:= " GROUP BY SUBSTR(ZZ2_VENCTO,1,6) "
		Else
			cQueryZZ2 	:= " SELECT SUBSTR(ZZ2_VENCTO,1,4) AS PERIODO, SUM(ZZ2_VALOR) AS ZZ2_VALOR "
			cGroupBy 	:= " GROUP BY SUBSTR(ZZ2_VENCTO,1,4) "
		EndIf
		cQueryZZ2 += " FROM " + RetSQLName("ZZ2")
		cQueryZZ2 += " WHERE ZZ2_FILIAL = '" + xFilial("ZZ2") + "' AND ZZ2_CONTRA = '" + TRB_REL->ZZ0_CONTRA + "' AND ZZ2_VENCTO > '" + DToS(mv_par05) + "' AND D_E_L_E_T_ = ' ' AND ZZ2_ITEM = '"  + TRB_REL->ZZ0_ITEM + "' "
		If mv_par07 == 1 //Movimentos Realizados
			//cQueryZZ2 += "       AND ZZ2_PEDIDO <> '      ' "
			cQueryZZ2 += " AND (EXISTS (SELECT F2_DOC FROM " + RetSQLName("SF2") + " SF2 WHERE F2_FILIAL = ZZ2_FILIAL " 
			cQueryZZ2 += " AND F2_SERIE = ZZ2_SERNF AND F2_DOC = ZZ2_NUMNF AND SF2.d_e_l_e_t_ = ' ') OR ZZ2_SERNF = 'XXX') "
		ElseIf mv_par07 == 2 //Movimentos a Realizar
			cQueryZZ2 += " AND ZZ2_SERNF <> 'XXX' "
			cQueryZZ2 += " AND NOT EXISTS (SELECT F2_DOC FROM " + RetSQLName("SF2") + " SF2 WHERE F2_FILIAL = ZZ2_FILIAL " 
			cQueryZZ2 += " AND F2_SERIE = ZZ2_SERNF AND F2_DOC = ZZ2_NUMNF AND SF2.d_e_l_e_t_ = ' ')
		EndIf

		cQueryZZ2 += cGroupBy
		cQueryZZ2 += " ORDER BY PERIODO "
		Eval(bQueryZZ2)
		TRB_ZZ2->(dbGoTop())
		For i := 1 To Len(aPerFat)
			TRB_ZZ2->(dbGoTop())
			nPosPer := 0
			While TRB_ZZ2->(!Eof())
				If TRB_ZZ2->PERIODO == aPerFat[i]
					nPosPer := 1
					cLinhaTXT += Transform(TRB_ZZ2->ZZ2_VALOR,"@E 999,999,999.99")+";"
					Exit
				EndIf

				TRB_ZZ2->(dbSkip())
			Enddo

			IIf(nPosPer == 0,cLinhaTXT += ";",Nil)
		Next i

		//Busca as parcelas aproprias a partir da data do parametro
		cQueryZZ1a := " SELECT SUM(ZZ1_VALOR) AS TOT_APR FROM " + RetSQLName("ZZ1")
		cQueryZZ1a += " WHERE ZZ1_FILIAL = '" + xFilial("ZZ1") + "' AND ZZ1_CONTRA = '" + TRB_REL->ZZ0_CONTRA + "' AND ZZ1_DATA <= '" + DToS(mv_par05) + "' AND D_E_L_E_T_ = ' ' AND ZZ1_ITEM = '"  + TRB_REL->ZZ0_ITEM + "' "

		cQueryZZ1b := "       AND ZZ1_LA = 'S' "

		cQueryZZ1c := "       AND ZZ1_LA <> 'S' "


		If mv_par07 == 1 //Movimentos Realizados
			cQueryZZ1 := cQueryZZ1a+cQueryZZ1b
			Eval(bQueryZZ1)
			TRB_ZZ1->(dbGoTop())
			Iif(TRB_ZZ1->(!Eof()),cLinhaTXT += Transform(TRB_ZZ1->TOT_APR,"@E 999,999,999.99")+";" ,cLinhaTXT += "0;")
		ElseIf mv_par07 == 2 //Movimentos a Realizar
			cQueryZZ1 := cQueryZZ1a+cQueryZZ1c
			Eval(bQueryZZ1)
			TRB_ZZ1->(dbGoTop())
			Iif(TRB_ZZ1->(!Eof()),cLinhaTXT += Transform(TRB_ZZ1->TOT_APR,"@E 999,999,999.99")+";" ,cLinhaTXT += "0;")
		ElseIf mv_par07 == 3 //ambos
			cQueryZZ1 := cQueryZZ1a+cQueryZZ1b
			Eval(bQueryZZ1)
			TRB_ZZ1->(dbGoTop())
			Iif(TRB_ZZ1->(!Eof()),nAPR := TRB_ZZ1->TOT_APR,nAPR := 0)
			cQueryZZ1 := cQueryZZ1a+cQueryZZ1c
			Eval(bQueryZZ1)
			TRB_ZZ1->(dbGoTop())
			Iif(TRB_ZZ1->(!Eof()),naAPR := TRB_ZZ1->TOT_APR,naAPR := 0)
			cLinhaTXT += Transform(nAPR,"@E 999,999,999.99")+";"+Transform(naAPR,"@E 999,999,999.99")+";" 
		EndIf

		If mv_par06 == 1
			cQueryZZ1 := " SELECT SUBSTR(ZZ1_DATA,1,6) AS PERIODO, SUM(ZZ1_VALOR) AS ZZ1_VALOR "
		Else
			cQueryZZ1 := " SELECT SUBSTR(ZZ1_DATA,1,4) AS PERIODO, SUM(ZZ1_VALOR) AS ZZ1_VALOR "
		EndIf

		cQueryZZ1 += " FROM " + RetSQLName("ZZ1")
		cQueryZZ1 += " WHERE ZZ1_FILIAL = '" + xFilial("ZZ1") + "' AND ZZ1_CONTRA = '" + TRB_REL->ZZ0_CONTRA + "' AND ZZ1_DATA > '" + DToS(mv_par05) + "' AND D_E_L_E_T_ = ' ' AND ZZ1_ITEM = '"  + TRB_REL->ZZ0_ITEM + "' "

		If mv_par07 == 1 //Movimentos Realizados
			cQueryZZ1 += "       AND ZZ1_LA = 'S' "
		ElseIf mv_par07 == 2 //Movimentos a Realizar
			cQueryZZ1 += "       AND ZZ1_LA <> 'S' "
		EndIf 

		If mv_par06 == 1
			cQueryZZ1 += " GROUP BY SUBSTR(ZZ1_DATA,1,6) "
		Else
			cQueryZZ1 += " GROUP BY SUBSTR(ZZ1_DATA,1,4) "
		EndIf

		cQueryZZ1 += " ORDER BY PERIODO "
		Eval(bQueryZZ1) 
		TRB_ZZ1->(dbGoTop())
		For i := 1 To Len(aPerAprop)
			TRB_ZZ1->(dbGoTop())
			nPosPer := 0
			While TRB_ZZ1->(!Eof())
				If TRB_ZZ1->PERIODO == aPerAprop[i]
					nPosPer := 1
					cLinhaTXT += Transform(TRB_ZZ1->ZZ1_VALOR,"@E 999,999,999.99")+";"
					Exit
				EndIf

				TRB_ZZ1->(dbSkip())
			Enddo

			IIf(nPosPer == 0,cLinhaTXT += ";",Nil)
		Next i

		FWrite(nHdlCSV,cLinhaTXT+Chr(13)+Chr(10))
		IncProc() 
		TRB_REL->(dbSkip())
	EndDo

	//Integracao com MS-Excel   
	FClose(nHdlCSV)
	oExcel := MSExcel():New()
	oExcel:WorkBooks:Open(cFile)
	oExcel:SetVisible(.T.)

Return(Nil)

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
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
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
	cGrpPerg := PadR(aPergunt[1,1],len(X1_GRUPO))
	For i := 1 To Len(aPergunt)
		lTipLocl := !SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))	
		SX1->(RecLock("SX1",lTipLocl))
		SX1->X1_GRUPO		:= PadR(cGrpPerg,len(X1_GRUPO))
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


//Layout do Relatorio
//             |              |              |              |               |   Vigencia   | Acumulado Até          | Parcelas Faturadas |                 | Nro.     | Acumulado Ate          | Apropriacao  Receita | 
//Elemento PEP | Cod. Cliente | Nome Cliente | Tipo Receita | Vlr. Contrato | Inicio | Fim | 99/99/99 - Faturamento | 9999 | 9999 | 9999 | Total Faturados | Parcelas | 99/99/99 - Apropriacao | 9999 | 9999 | 9999   |Total Apropriado

/*/
//Busca as parcelas faturadas a partir da data do parametro          
cQueryZZ2 := " SELECT SUM(ZZ2_VALOR) AS TOT_FAT FROM " + RetSQLName("ZZ2")
cQueryZZ2 += " WHERE ZZ2_FILIAL = '" + xFilial("ZZ2") + "' AND ZZ2_CONTRA = '" + TRB_REL->ZZ0_CONTRA + "' AND ZZ2_VENCTO <= '" + DToS(mv_par05) + "' AND D_E_L_E_T_ = ' ' AND ZZ2_ITEM = '"  + TRB_REL->ZZ0_ITEM + "' "
If mv_par07 == 1 //Movimentos Realizados
//cQueryZZ2 += "       AND ZZ2_PEDIDO <> '      ' "
cQueryZZ2 += " AND EXISTS (SELECT F2_DOC FROM " + RetSQLName("SF2") + " SF2 WHERE F2_FILIAL = ZZ2_FILIAL " 
cQueryZZ2 += " AND F2_SERIE = ZZ2_SERNF AND F2_DOC = ZZ2_NUMNF AND SF2.d_e_l_e_t_ = ' ')
ElseIf mv_par07 == 2 //Movimentos a Realizar
//cQueryZZ2 += "       AND ZZ2_PEDIDO = '      ' "
cQueryZZ2 += " AND NOT EXISTS (SELECT F2_DOC FROM " + RetSQLName("SF2") + " SF2 WHERE F2_FILIAL = ZZ2_FILIAL " 
cQueryZZ2 += " AND F2_SERIE = ZZ2_SERNF AND F2_DOC = ZZ2_NUMNF AND SF2.d_e_l_e_t_ = ' ')
EndIf   
Eval(bQueryZZ2)
TRB_ZZ2->(dbGoTop())
//Iif(TRB_ZZ2->(!Eof()),cLinhaTXT += Transform(TRB_ZZ2->TOT_FAT,"@E 999,999,999.99")+";" ,cLinhaTXT += "0;")
If TRB_ZZ2->(!Eof())
If mv_par07 == 3
cLinhaTXT += Transform(TRB_ZZ2->TOT_FAT,"@E 999,999,999.99")+";;" 
Else
cLinhaTXT += Transform(TRB_ZZ2->TOT_FAT,"@E 999,999,999.99")+";"
EndIf
Else
If mv_par07 == 3
cLinhaTXT += "0;0;"	                                                           
Else
cLinhaTXT += "0;"	                                                           
EndIf
EndIf


/*/