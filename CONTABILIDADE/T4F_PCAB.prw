#include "fileio.ch"
#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "totvs.ch"

/*
+------------+-----------+--------+----------------------+-------+-------------+
| Programa:  | T4F_PCOMAB| Autor: | Luiz Eduardo         | Data: |  01/04/2020 |
+------------+-----------+--------+----------------------+-------+-------------+
| Descricao: | Geração do relatorio de pedidos de compras em aberto e efetuar a|
|            | contabilizar do valor                                           |
|            |                                                                 |
+------------+-----------------------------------------------------------------+
| Alterado   | 02/07 Alteração solicitada pelo Wellington, data de corte para  |
| 	  	     | Emissão e Entrega	 				      					   |
+------------+-----------------------------------------------------------------+
*/

User Function T4F_PCAB()

	Local oBtn1
	Local oBtn2
	Local oSay1,oSay2,oSay3
	Local cTexto:= "Esta rotina tem a finalidade de estornar a contabilização das "+;
		"provisões dos pedidos de compra e efetuar a nova contabilização "+;
		"de provisão desses pedidos:"
	Local oGet
	Private dDataEst := lastday(Ultprov())+1
	Private dDataCom := lastday(Ultprov())
	Private oDlg
	nOpcoes := 1

	DEFINE DIALOG oDlg TITLE "Parametros" FROM 0,0 TO 300,330 COLOR CLR_BLACK,CLR_WHITE PIXEL

	@ 05,05 SAY oSay1 PROMPT cTexto SIZE 150,300 OF oDlg PIXEL
	@ 37,05 SAY oSay2 PROMPT "Data da ultima contabilização do estorno: "+cValtochar(Ultprov()) SIZE 150,300 OF oDlg PIXEL
	@ 63,05 SAY oSay2 PROMPT "Data para contabilização dos pedidos de compra:" SIZE 80,200 OF oDlg PIXEL
	@ 93,05 SAY oSay3 PROMPT "Data para estorno das contabilizações:" SIZE 80,200 OF oDlg PIXEL

	@ 63,90 GET oGet VAR dDataCom SIZE 60,08 OF oDlg PIXEL
	@ 93,90 GET oGet VAR dDataEst SIZE 60,08 OF oDlg PIXEL
	@ 125,30 BUTTON oBtn1 PROMPT 'Ok' ACTION (nOpcao:=1,oDlg:End()) SIZE 40, 013 OF oDlg PIXEL
	@ 125,100 BUTTON oBtn2 PROMPT 'Sair' ACTION (oDlg:End()) SIZE 40, 013 OF oDlg PIXEL

	ACTIVATE DIALOG oDlg CENTER

	If (nOpcao=1,T4F_PCA1(dDataCom,dDataEst),)

Return

Static Function T4F_PCA1(dDataCom,dDataEst)

	Processa({||geratmp()}, "Aguarde", "Apurando Pedidos de Compras em Aberto")

		if MsgBox ("Deseja contabilizar a provisão e estornar?","Escolha","YESNO")
			//cTp := "1"
			dbSelectArea("CT5")
			dbSeek(xFilial()+"Z01")
			Processa({||Contabiliza("1")}, "Contabilizando", "Montando contabilização das provisões")
			dbSelectArea("CT5")
			dbSeek(xFilial()+"Z03")
			Processa({||Contabiliza("2")}, "Contabilizando", "Montando contabilização dos estornos")
		endif
Return

Static Function geratmp()

	Local cQuery := ""

	If Select ("TMP") > 0
		TMP->(dbCloseArea())
	EndIf

	cQuery := " SELECT DISTINCT C7_FILIAL,  "+CRLF
	cQuery +="C7_NUM,  "+CRLF
	cQuery +="C7_ITEM,  "+CRLF
	cQuery +="C7_NUMSC,  "+CRLF
	cQuery +="C7_PRODUTO,  "+CRLF
	cQuery +="C7_DESCRI,  "+CRLF
	cQuery +="C7_UM,  "+CRLF
	cQuery +="C7_QUANT,  "+CRLF
	cQuery +="C7_QUJE,  "+CRLF
	cQuery +="C7_PRECO,  "+CRLF
	cQuery +="C7_TOTAL,  "+CRLF
	cQuery +="C7_FORNECE,  "+CRLF
	cQuery +="C7_LOJA,  "+CRLF
	cQuery +="A2_NREDUZ,  "+CRLF
	cQuery +="A2_NATUREZ,  "+CRLF
	cQuery +="C7_OPER_F,  "+CRLF
	cQuery +="C7_DATPRF,  "+CRLF
	cQuery +="C7_CC,  "+CRLF
	cQuery +="C7_CONTA,  "+CRLF
	cQuery +="C7_ITEMCTA,  "+CRLF
	cQuery +="C7_OBS,  "+CRLF
	cQuery +="C7_COND,  "+CRLF
	cQuery +="C7_CONTATO,  "+CRLF
	cQuery +="C7_EMISSAO,  "+CRLF
	cQuery +="C7_APROV,  "+CRLF
	cQuery +="C7_CONAPRO,  "+CRLF
	cQuery +="C7_USER,  "+CRLF
	cQuery +="C7_USUARIO,  "+CRLF
	cQuery +="C7_RATEIO,  "+CRLF
	cQuery +="C7_XOBSFO,  "+CRLF
	cQuery +="C7_XOBSAPR,  "+CRLF
	cQuery +="C7_XCCAPR  "+CRLF
	cQuery += " FROM "+RetSqlName("SC7")+" C7 (NOLOCK)              "+CRLF
	cQuery += " JOIN "+RetSqlName("SA2")+" A2 (NOLOCK)              "+CRLF
	cQuery += " ON A2_COD = C7_FORNECE                              "+CRLF
	cQuery += " AND A2_LOJA = C7_LOJA                               "+CRLF
	cQuery += " AND A2.D_E_L_E_T_ = ''                              "+CRLF

	cQuery += " WHERE C7.D_E_L_E_T_ = ''                            "+CRLF
	cQuery += " AND C7.C7_EMISSAO  <= '"+dtos(dDataCom)+"'         "+CRLF
	cQuery += " AND C7.C7_DATPRF  <= '"+dtos(dDataCom)+"'         "+CRLF

	cQuery += " AND C7_QUJE<C7_QUANT AND C7_RESIDUO=' '             "+CRLF
	cQuery += " AND C7_ENCER <> 'E' 					            "+CRLF
	cQuery += " AND C7_CONAPRO='L'                                  "+CRLF

	cQuery:=ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP", .F., .T.)

	TCSetField( "TMP", "QUANT"     , "N", 12, 2 )
	TCSetField( "TMP", "QUJE"      , "N", 12, 2 )
	TCSetField( "TMP", "PRECO"     , "N", 12, 2 )
	TCSetField( "TMP", "TOTAL"     , "N", 12, 0 )
	TCSetField( "TMP", "EMISSAO"   , "D", 08, 0 )
	TCSetField( "TMP", "DATPRF"    , "D", 08, 0 )

	Count to nRegs

	ProcRegua(nRegs)

	TMP->(dbGotop())

	IF SELECT("TRB") # 0
		TRB->(DBCLOSEAREA( ))
	ENDIF

	//????????????????????????????????
	//?Cria array para gerar arquivo de trabalho
	//????????????????????????????????
	aCampos := {}
	AADD(aCampos,{ "C7_FILIAL",'C',2,0})
	AADD(aCampos,{ "C7_NUM",'C',6,0})
	AADD(aCampos,{ "C7_ITEM",'C',4,0})
	AADD(aCampos,{ "C7_NUMSC",'C',6,0})
	AADD(aCampos,{ "C7_PRODUTO",'C',15,0})
	AADD(aCampos,{ "C7_DESCRI",'C',40,0})
	AADD(aCampos,{ "C7_UM",'C',2,0})
	AADD(aCampos,{ "C7_QUANT",'N',12,2})
	AADD(aCampos,{ "C7_QUJE",'N',12,2})
	AADD(aCampos,{ "C7_PRECO",'N',14,4})
	AADD(aCampos,{ "C7_TOTAL",'N',14,2})
	AADD(aCampos,{ "C7_FORNECE",'C',6,0})
	AADD(aCampos,{ "C7_LOJA",'C',2,0})
	AADD(aCampos,{ "A2_NREDUZ",'C',40,0})
	AADD(aCampos,{ "A2_NATUREZ",'C',40,0})
	AADD(aCampos,{ "C7_OPER_F",'C',2,0})
	AADD(aCampos,{ "C7_DATPRF",'D',8,0})
	AADD(aCampos,{ "C7_CC",'C',20,0})
	AADD(aCampos,{ "CREDITO",'C',20,0})
	AADD(aCampos,{ "DEBITO",'C',20,0})
	AADD(aCampos,{ "C7_CONTA",'C',20,0})
	AADD(aCampos,{ "C7_ITEMCTA",'C',20,0})
	AADD(aCampos,{ "C7_OBS",'C',120,0})
	AADD(aCampos,{ "C7_COND",'C',3,0})
	AADD(aCampos,{ "C7_CONTATO",'C',15,0})
	AADD(aCampos,{ "C7_EMISSAO",'D',8,0})
	AADD(aCampos,{ "C7_APROV",'C',6,0})
	AADD(aCampos,{ "C7_CONAPRO",'C',1,0})
	AADD(aCampos,{ "C7_USER",'C',6,0})
	AADD(aCampos,{ "C7_USUARIO",'C',15,0})
	AADD(aCampos,{ "C7_RATEIO",'C',1,0})
	AADD(aCampos,{ "C7_XOBSFO",'C',120,0})
	AADD(aCampos,{ "C7_XOBSAPR",'C',120,0})
	AADD(aCampos,{ "C7_XCCAPR",'C',20,0})
	AADD(aCampos,{ "NATUREZA",'C',09,0})
	AADD(aCampos,{ "TP",'C',01,0})

	cTemp := CriaTrab(nil,.f.)
	dbCreate(cTemp,aCampos)
	dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

	Select Tmp
	InclNotas()
	InclResid()
	Select TRB
	dbgotop()

	cPed := ""
	nTot := 0
	Select Tmp
	dbgotop()
	do while !eof()
		Select SCR
		dbSetOrder(1)
		Seek tmp->C7_FILIAL+"PC"+Tmp->C7_NUM
		dDataLib := ctod("0")
		Do while !eof() .and.  CR_NUM=Tmp->C7_NUM
			dDataLib := scr->cr_datalib
			skip
		Enddo
		Select Tmp
		if dDataLib>dDataCom
			skip
			loop
		endif
//	cQuery += " AND C7_QUJE<C7_QUANT AND C7_RESIDUO=' '             "+CRLF

		// Regra definida em 09/06/2020 - Quando Epep genérico ou sem Epep fazer a provisão apenas para o mês corrente
		IF substr(tmp->C7_ITEMCTA,2,3)='GGG' .OR. EMPTY(tmp->C7_ITEMCTA)

			if stod(tmp->C7_DATPRF)>=dDataCom
				skip
				loop
			Endif
		endif
		nSaldo := tmp->(C7_QUANT)
//		nSaldo := tmp->(C7_QUANT-C7_QUJE)
//		if nSaldo > 0
		//5,6 e 7		Conta do PC	2101039999
		//Estoque		1106019999	2101039999
		//Imobilizado	1208059999	2101039999
		//Epep Futuro	1109019999	2101039999
		cDeb := cCred := ""
		do case
		case left(tmp->C7_CONTA,1)$"5*6*7"
			DBSelectArea('CTD')
			CTD->(DBSeek(FWxfilial("CTD")+tmp->C7_ITEMCTA)) // Inclusão efetuada por Lucas Valins, a rotina deve olhar a data do evento do elemento PEP
			//cDtEpep := stod('20'+substr(tmp->C7_ITEMCTA,6,6))
			/*cDtEpep := CTD->CTD_DTEVEN
			If cDtEpep <= dDataCom
				cDeb  := tmp->C7_CONTA
			else
				cDeb  := "1109019999"
			endif*/

			cDtEpep := CTD->CTD_DTEVEN
			If cDtEpep <= dDataCom
				cDeb  := tmp->C7_CONTA
			ElseIf cDtEpep >= dDataCom .and. Alltrim(tmp->C7_PRODUTO)$'170603332/201202840/170603334'
				cDeb  := "1109019999"
			else
				cDeb  := tmp->C7_CONTA
			endif

			cCred := "2101039999"
		Case left(tmp->C7_CONTA,6)$"110601"
			cDeb  := "1106019999"
			cCred := "2101039999"
		Case left(tmp->C7_CONTA,6)$"120805"
			cDeb  := "1208059999"
			cCred := "2101039999"
		OTHERWISE
			skip
			loop
		endcase
		nValPed:= (tmp->C7_TOTAL/tmp->C7_QUANT)*nSaldo
		cPed := tmp->C7_NUM
		nTot += nValPed
		RecLock("trb",.t.)
		trb->C7_FILIAL:= tmp->C7_FILIAL
		trb->C7_NUM:= tmp->C7_NUM
		trb->C7_ITEM:= tmp->C7_ITEM
		trb->C7_NUMSC:= tmp->C7_NUMSC
		trb->C7_PRODUTO:= tmp->C7_PRODUTO
		trb->C7_DESCRI:= tmp->C7_DESCRI
		trb->C7_UM:= tmp->C7_UM
		trb->C7_QUANT:= tmp->C7_QUANT
		trb->C7_QUJE:= tmp->C7_QUJE
		trb->C7_PRECO:= tmp->C7_PRECO
		trb->C7_TOTAL:= nValPed
		trb->C7_FORNECE:= tmp->C7_FORNECE
		trb->C7_LOJA:= tmp->C7_LOJA
		trb->A2_NREDUZ:= tmp->A2_NREDUZ
		trb->C7_OPER_F:= tmp->C7_OPER_F
		trb->C7_DATPRF:= stod(tmp->C7_DATPRF)
		trb->C7_CC:= tmp->C7_CC
		trb->CREDITO:= cCred
		trb->DEBITO:= cDeb
		trb->C7_CONTA:= tmp->C7_CONTA
		trb->C7_ITEMCTA:= tmp->C7_ITEMCTA
		trb->C7_OBS:= tmp->C7_OBS
		trb->C7_COND:= tmp->C7_COND
		trb->C7_CONTATO:= tmp->C7_CONTATO
		trb->C7_EMISSAO:= stod(tmp->C7_EMISSAO)
		trb->C7_APROV:= tmp->C7_APROV
		trb->C7_CONAPRO:= tmp->C7_CONAPRO
		trb->C7_USER:= tmp->C7_USER
		trb->C7_USUARIO:= tmp->C7_USUARIO
		trb->C7_RATEIO:= "1"
		trb->C7_XOBSFO:= tmp->C7_XOBSFO
		trb->C7_XOBSAPR:= tmp->C7_XOBSAPR
		trb->C7_XCCAPR:= tmp->C7_XCCAPR
		trb->NATUREZA:= tmp->A2_NATUREZ
		msunlock()
		Select SCH
		dbSetOrder(2)
		dbSeek(tmp->(C7_FILIAL+C7_NUM+C7_ITEM))
		if !eof()
			RecLock("trb",.f.)
			trb->C7_RATEIO:= "2"
			MsUnLock()
		endif
		DO WHILE !eof() .and. tmp->(C7_FILIAL+C7_NUM+C7_ITEM) = SCH->(CH_FILIAL+CH_PEDIDO+CH_ITEMPD)
			do case
			case left(trb->C7_CONTA,1)$"5*6*7"
				DBSelectArea('CTD')
				CTD->(DBSeek(FWxfilial("TRB")+TRB->C7_ITEMCTA)) // Inclusão efetuada por Lucas Valins, a rotina deve olhar a data do evento do elemento PEP
				//cDtEpep := stod('20'+substr(trb->C7_ITEMCTA,6,6))
				/*cDtEpep:= CTD->CTD_DTEVEN
				if cDtEpep <= dDataCom
					cDeb  := trb->C7_CONTA
				else
					cDeb  := "1109019999"
				endif*/

			cDtEpep := CTD->CTD_DTEVEN
			If cDtEpep <= dDataCom
				cDeb  := TRB->C7_CONTA
			ElseIf cDtEpep >= dDataCom .and. Alltrim(TRB->C7_PRODUTO)$'170603332/201202840/170603334'
				cDeb  := "1109019999"
			else
				cDeb  := TRB->C7_CONTA
			endif

				
				cCred := "2101039999"
			Case left(trb->C7_CONTA,6)$"110601"
				cDeb  := "1106019999"
				cCred := "2101039999"
			Case left(trb->C7_CONTA,6)$"120805"
				cDeb  := "1208059999"
				cCred := "2101039999"
			Otherwise
				skip
				loop
			endcase

			RecLock("trb",.t.)
			trb->C7_FILIAL:= tmp->C7_FILIAL
			trb->C7_NUM:= tmp->C7_NUM
			trb->C7_ITEM:= tmp->C7_ITEM
			trb->C7_NUMSC:= "RATEIO"
			trb->C7_CC:= SCH->CH_CC
			trb->CREDITO:= cCred
			trb->DEBITO:= cDeb
			trb->C7_CONTA:= SCH->CH_CONTA
			trb->C7_ITEMCTA:= SCH->CH_ITEMCTA

			trb->C7_PRODUTO:= tmp->C7_PRODUTO
			trb->C7_DESCRI:= tmp->C7_DESCRI
			trb->C7_UM:= tmp->C7_UM
			trb->C7_QUANT:= nSaldo // tmp->C7_QUANT
			//				trb->C7_QUJE:= tmp->C7_QUJE
			trb->C7_TOTAL:= nValPed*SCH->CH_PERC/100
			trb->C7_FORNECE:= tmp->C7_FORNECE
			trb->C7_LOJA:= tmp->C7_LOJA
			trb->A2_NREDUZ:= tmp->A2_NREDUZ
			trb->C7_COND:= tmp->C7_COND
			trb->C7_CONTATO:= tmp->C7_CONTATO
			trb->C7_EMISSAO:= stod(tmp->C7_EMISSAO)
			trb->C7_DATPRF := stod(tmp->C7_DATPRF)
			trb->C7_APROV:= tmp->C7_APROV
			trb->C7_RATEIO:= "1"
			trb->NATUREZA:= tmp->A2_NATUREZ
			msunlock()
			Select SCH
			dbskip()
		enddo
//		Endif
		Select Tmp
		skip
		Select Tmp
	Enddo

	oReport := RptDef("PCABERTO")
	//if MsgBox ("Deseja abrir planilha Excel ?","Escolha","YESNO")
	oReport:PrintDialog()
	//endif
	Select Trb
	dbgotop()
Return

Static Function RptDef(cNome)

	Local oReport := Nil
	Local oSection1:= Nil
	//Local oBreak
	//Local oFunction

	oReport := TReport():New(cNome,"Pedidos de Compras em Aberto",cNome,{|oReport| ReportPrint(oReport)},"Pedidos em Aberto")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)

	if nOpcoes = 1

		oSection1 := TRSection():New(oReport,"PC Aberto", {"TRB"}, , .F., .T.)

		TRCell():New(oSection1,'C7_FILIAL','TRB','Filial','@!',2)
		TRCell():New(oSection1,'C7_NUM','TRB','Numero PC','@!',6)
		TRCell():New(oSection1,'C7_ITEM','TRB','Item','@!',4)
		TRCell():New(oSection1,'C7_NUMSC','TRB','Numero da SC','@!',6)
		TRCell():New(oSection1,'C7_PRODUTO','TRB','Produto','@!',15)
		TRCell():New(oSection1,'C7_DESCRI','TRB','Descricao','@!',40)
		TRCell():New(oSection1,'C7_UM','TRB','Unidade','@!',2)
		TRCell():New(oSection1,'C7_QUANT','TRB','Quantidade','@e  999,999,999.99',15)
		TRCell():New(oSection1,'C7_QUJE','TRB','Qtd.Entregue','@e  999,999,999.99',15)
		TRCell():New(oSection1,'C7_PRECO','TRB','Prc Unitario','@e  999,999,999.99',15)
		TRCell():New(oSection1,'C7_TOTAL','TRB','Vlr.Total','@e  999,999,999.99',15)
		TRCell():New(oSection1,'C7_FORNECE','TRB','Fornecedor','@!',6)
		TRCell():New(oSection1,'C7_LOJA','TRB','Loja','@!',2)
		TRCell():New(oSection1,'A2_NREDUZ','TRB','Nome','@!',40)
		TRCell():New(oSection1,'C7_OPER_F','TRB','Tp. Operacao','@!',2)
		TRCell():New(oSection1,'C7_DATPRF','TRB','Dt. Entrega','@!',8)
		TRCell():New(oSection1,'C7_CC','TRB','Centro Custo','@!',20)
		TRCell():New(oSection1,'C7_CONTA','TRB','Cta Fiscal','@!',20)
		TRCell():New(oSection1,'C7_ITEMCTA','TRB','Elem Pep','@!',20)
		TRCell():New(oSection1,'C7_OBS','TRB','Observacoes','@!',120)
		TRCell():New(oSection1,'C7_COND','TRB','Cond. Pagto','@!',3)
		TRCell():New(oSection1,'C7_CONTATO','TRB','Contato','@!',15)
		TRCell():New(oSection1,'C7_EMISSAO','TRB','DT Emissao','@!',8)
		TRCell():New(oSection1,'C7_APROV','TRB','Grupo Aprov.','@!',6)
		TRCell():New(oSection1,'C7_CONAPRO','TRB','Controle Ap.','@!',1)
		TRCell():New(oSection1,'C7_USER','TRB','Cod. Usuario','@!',6)
		TRCell():New(oSection1,'C7_USUARIO','TRB','USUARIO','@!',15)
		TRCell():New(oSection1,'C7_RATEIO','TRB','Rateio','@!',1)
		TRCell():New(oSection1,'C7_XOBSFO','TRB','Obs.Forn','@!',120)
		TRCell():New(oSection1,'C7_XOBSAPR','TRB','Obs.p/Aprov.','@!',120)
		TRCell():New(oSection1,'C7_XCCAPR','TRB','CC.p/Aprov.','@!',20)

	Else
		oSection1 := TRSection():New(oReport,"Financeiro", {"TRBFIN"}, , .F., .T.)

		TRCell():New(oSection1,'C7_FILIAL','TRBFIN','Filial','@!',2)
		TRCell():New(oSection1,'C7_NUM','TRBFIN','Numero PC','@!',6)
		TRCell():New(oSection1,'C7_TOTAL','TRBFIN','Vlr.Total','@e  999,999,999.99',15)
		TRCell():New(oSection1,'VENCTO','TRBFIN','Vencimento','@!',8)
		TRCell():New(oSection1,'C7_FORNECE','TRBFIN','Fornecedor','@!',6)
		TRCell():New(oSection1,'C7_LOJA','TRBFIN','Loja','@!',2)
		TRCell():New(oSection1,'A2_NREDUZ','TRBFIN','Nome','@!',40)
		TRCell():New(oSection1,'C7_DATPRF','TRBFIN','Dt. Entrega','@!',8)
		TRCell():New(oSection1,'C7_COND','TRBFIN','Cond. Pagto','@!',3)
		TRCell():New(oSection1,'C7_EMISSAO','TRBFIN','DT Emissao','@!',8)
		TRCell():New(oSection1,'C7_CC','TRBFIN','Centro Custo','@!',20)
		TRCell():New(oSection1,'C7_CONTA','TRBFIN','Cta Fiscal','@!',20)
		TRCell():New(oSection1,'C7_ITEMCTA','TRBFIN','Elem Pep','@!',20)
		TRCell():New(oSection1,'NATUREZA','TRBFIN','Natureza','@!',20)

	Endif

	TRFunction():New(oSection1:Cell("C7_NUM"),NIL,"COUNT",,,,,.F.,.T.)

	oReport:SetTotalInLine(.F.)

	//quebra  por seção
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)

	Local oSection1 := oReport:Section(1)

	//Local cQuery    := ""
	//Local cPedido   := ""
	//Local lPrim 	:= .T.

	if nOpcoes = 1
		dbSelectArea("TRB")
		TRB->(dbGoTop())

		oReport:SetMeter(TRB->(LastRec()))

		While !Eof() // total Geral

			If oReport:Cancel()
				Exit
			EndIf

			//inicializo a primeira secao
			oSection1:Init()

			oReport:IncMeter()

			dbSelectArea("TRB")

			IncProc("Imprimindo ")

			Do while !eof()
				if trb->C7_RATEIO= "2"
					skip
					loop
				endif
				oReport:IncMeter()

				//imprimo a primeira secao
				oSection1:Cell("C7_FILIAL"):SetValue(TRB->C7_FILIAL)
				oSection1:Cell("C7_NUM"):SetValue(TRB->C7_NUM)
				oSection1:Cell("C7_ITEM"):SetValue(TRB->C7_ITEM)
				oSection1:Cell("C7_NUMSC"):SetValue(TRB->C7_NUMSC)
				oSection1:Cell("C7_PRODUTO"):SetValue(TRB->C7_PRODUTO)
				oSection1:Cell("C7_DESCRI"):SetValue(TRB->C7_DESCRI)
				oSection1:Cell("C7_UM"):SetValue(TRB->C7_UM)
				oSection1:Cell("C7_QUANT"):SetValue(TRB->C7_QUANT)
				oSection1:Cell("C7_QUJE"):SetValue(TRB->C7_QUJE)
				oSection1:Cell("C7_PRECO"):SetValue(TRB->C7_PRECO)
				oSection1:Cell("C7_TOTAL"):SetValue(TRB->C7_TOTAL)
				oSection1:Cell("C7_FORNECE"):SetValue(TRB->C7_FORNECE)
				oSection1:Cell("C7_LOJA"):SetValue(TRB->C7_LOJA)
				oSection1:Cell("A2_NREDUZ"):SetValue(TRB->A2_NREDUZ)
				oSection1:Cell("C7_OPER_F"):SetValue(TRB->C7_OPER_F)
				oSection1:Cell("C7_DATPRF"):SetValue(TRB->C7_DATPRF)
				oSection1:Cell("C7_CC"):SetValue(TRB->C7_CC)
				oSection1:Cell("C7_CONTA"):SetValue(TRB->debito)
				oSection1:Cell("C7_ITEMCTA"):SetValue(TRB->C7_ITEMCTA)
				oSection1:Cell("C7_OBS"):SetValue(TRB->C7_OBS)
				oSection1:Cell("C7_COND"):SetValue(TRB->C7_COND)
				oSection1:Cell("C7_CONTATO"):SetValue(TRB->C7_CONTATO)
				oSection1:Cell("C7_EMISSAO"):SetValue(TRB->C7_EMISSAO)
				oSection1:Cell("C7_APROV"):SetValue(TRB->C7_APROV)
				oSection1:Cell("C7_CONAPRO"):SetValue(TRB->C7_CONAPRO)
				oSection1:Cell("C7_USER"):SetValue(TRB->C7_USER)
				oSection1:Cell("C7_USUARIO"):SetValue(TRB->C7_USUARIO)
				oSection1:Cell("C7_RATEIO"):SetValue(TRB->C7_RATEIO)
				oSection1:Cell("C7_XOBSFO"):SetValue(TRB->C7_XOBSFO)
				oSection1:Cell("C7_XOBSAPR"):SetValue(TRB->C7_XOBSAPR)
				oSection1:Cell("C7_XCCAPR"):SetValue(TRB->C7_XCCAPR)


				oSection1:Printline()
				TRB->(dbSkip())
			Enddo

			//finalizo a primeira secao
		Enddo
//	oSection1:Finish()
	Else
		dbSelectArea("TRBFIN")
		TRBFIN->(dbGoTop())

		oReport:SetMeter(TRBFIN->(LastRec()))

		While !Eof() // total Geral

			//inicializo a segunda secao
			oSection1:Init()

			oReport:IncMeter()

			dbSelectArea("TRBFIN")

			IncProc("Imprimindo ")

			Do while !eof()
				oReport:IncMeter()

				//imprimo a primeira secao
				oSection1:Cell("C7_FILIAL"):SetValue(TRBFIN->C7_FILIAL)
				oSection1:Cell("C7_NUM"):SetValue(TRBFIN->C7_NUM)
				oSection1:Cell("C7_TOTAL"):SetValue(TRBFIN->C7_TOTAL)
				oSection1:Cell("VENCTO"):SetValue(TRBFIN->VENCTO)
				oSection1:Cell("C7_FORNECE"):SetValue(TRBFIN->C7_FORNECE)
				oSection1:Cell("C7_LOJA"):SetValue(TRBFIN->C7_LOJA)
				oSection1:Cell("A2_NREDUZ"):SetValue(TRBFIN->A2_NREDUZ)
				oSection1:Cell("C7_DATPRF"):SetValue(TRBFIN->C7_DATPRF)
				oSection1:Cell("C7_COND"):SetValue(TRBFIN->C7_COND)
				oSection1:Cell("C7_EMISSAO"):SetValue(TRBFIN->C7_EMISSAO)

				oSection1:Cell("C7_CC"):SetValue(TRBFIN->C7_CC)
				oSection1:Cell("C7_CONTA"):SetValue(TRBFIN->C7_CONTA)
				oSection1:Cell("C7_ITEMCTA"):SetValue(TRBFIN->C7_ITEMCTA)
				oSection1:Cell("NATUREZA"):SetValue(TRBFIN->NATUREZA)

				oSection1:Printline()
				TRBFIN->(dbSkip())
			Enddo

			//finalizo a segunda secao
		Enddo

	Endif

	oSection1:Finish()
Return

//Contabilizacao
Static Function Contabiliza(cTipo)

	// Obedecer a seguinte regra definida pela contabilidade
	//Grupo		Débito		Crédito
	//5,6 e 7		Conta do PC	2101039999
	//Estoque		1106019999	2101039999
	//Imobilizado	1208059999	2101039999
	//Epep Futuro	1109019999	2101039999

	aRotina := {}
	cArquivo := "TRB"
	nTotal    := 0
	lDigita   := .T.
	cLote     := "PROVPC"
	if cTipo="1"
		// Lançamento
		cPadrao   := "Z01" // CODIGO DO LANCAMENTO PADRAO CRIADO PARA ATENDER ESTA ROTINA
	else
		// Estorno
		cPadrao   := "Z02" // CODIGO DO LANCAMENTO PADRAO CRIADO PARA ATENDER ESTA ROTINA
	endif
	nHdlPrv:= HeadProva(cLote,"T4F_PCAB",Alltrim(cUserName),@cArquivo)

	DbSelectArea("TRB")
	cTemp := CriaTrab(nil,.f.)
	//	IndRegua("TRB", cTemp, "C7_CONTA+C7_CC+C7_ITEMCTA", , , "Selecionando Registros...")
	ProcRegua(RecCount())
	DBGOTOP()
	//DbGobottom()

	//skip-5  // Fiz a contabilização apenas dos 10 últimos lançamentos para teste
	Do While !Eof()
		IncProc("Gerando Lancamento Contabil...")
		if trb->C7_RATEIO <> "2" .and. !empty(trb->debito)
			nTotal := nTotal + DetProva(nHdlPrv,cPadrao,"T4F_PCAB",cLote)
		endif
		DbSelectArea("TRB")
		DbSkip()
	EndDo

	RodaProva(nHdlPrv,nTotal)
	nTotal := 0
	
	If cPadrao  = "Z01"
	// Envia para Lancamento Contabil
	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.,,dDataCom) // Essa e a funcao do quadro dos lancamentos.
	Else
	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.,,dDataEst) // Essa e a funcao do quadro dos lancamentos.
	EndIF

Return

Static Function	InclNotas()

	If Select ("TMPD1") > 0
		TMPD1->(dbCloseArea())
	EndIf

	cQuery := " SELECT DISTINCT D1_FILIAL,              	         "+CRLF
	cQuery += " D1_PEDIDO,D1_ITEMPC,D1_FORNECE,D1_LOJA				 "+CRLF
	cQuery += " FROM "+RetSqlName("SD1")+" SD1 (NOLOCK)              "+CRLF
	cQuery += " WHERE SD1.D_E_L_E_T_ = ''                            "+CRLF
	cQuery += " AND SD1.D1_DTDIGIT  > '"+DTOS(dDataCom)+"'       		 "+CRLF
	cQuery:=ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMPD1", .F., .T.)
	dbgotop()

	Select Tmpd1
	do while !eof()
		Select SCR
		dbSetOrder(1)
		Seek tmpd1->D1_FILIAL+"PC"+tmpd1->d1_pedido
		dDataLib := date()
		Do while !eof() .and.  CR_NUM=tmpd1->d1_pedido
			dDataLib := scr->cr_datalib
			skip
		Enddo
		Select TmpD1
		if dDataLib>dDataCom
			skip
			loop
		endif
		Select SC7
		dbSetOrder(1)
		Seek TMPD1->(D1_FILIAL+D1_PEDIDO+D1_ITEMPC)
		Select SA2
		Seek xFilial()+tmpd1->(d1_fornece+d1_loja)
		Select TmpD1
		// Regra definida em 09/06/2020 - Quando Epep genérico ou sem Epep fazer a provisão apenas para o mês corrente
//		IF substr(SC7->C7_ITEMCTA,2,3)='GGG' .OR. EMPTY(SC7->C7_ITEMCTA)
		if (SC7->C7_DATPRF)>=dDataCom
			skip
			loop
		Endif
//		endif
		//5,6 e 7		Conta do PC	2101039999
		//Estoque		1106019999	2101039999
		//Imobilizado	1208059999	2101039999
		//Epep Futuro	1109019999	2101039999
		cDeb := cCred := ""
		do case
		case left(SC7->C7_CONTA,1)$"5*6*7
			DBSelectArea('CTD')
			CTD->(DBSetOrder(1))
			CTD->(DBGoTop())
			CTD->(MsSeek(FWXfilial("CTD")+SC7->C7_ITEMCTA)) // Inclusão efetuada por Lucas Valins, a rotina deve olhar a data do evento do elemento PEP
			//cDtEpep := stod('20'+substr(SC7->C7_ITEMCTA,6,6))
				/*cDtEpep := CTD->CTD_DTEVEN
			if cDtEpep <= dDataCom
					cDeb  := SC7->C7_CONTA
			else
					cDeb  := "1109019999"
			endif*/

			cDtEpep := CTD->CTD_DTEVEN
			If cDtEpep <= dDataCom
				cDeb  := SC7->C7_CONTA
			ElseIf cDtEpep >= dDataCom .and. Alltrim(SC7->C7_PRODUTO)$'170603332/201202840/170603334'
				cDeb  := "1109019999"
			else
				cDeb  := SC7->C7_CONTA
			endif

				cCred := "2101039999"
		Case left(SC7->C7_CONTA,6)$"110601"
				cDeb  := "1106019999" 
				cCred := "2101039999"
		Case left(SC7->C7_CONTA,6)$"120805"
				cDeb  := "1208059999" 
				cCred := "2101039999"
		OTHERWISE
				skip
				loop
		endcase
			nValPed:= (SC7->C7_TOTAL)
			cPed := SC7->C7_NUM
			RecLock("trb",.t.)
			trb->C7_FILIAL:= SC7->C7_FILIAL
			trb->C7_NUM:= SC7->C7_NUM
			trb->C7_ITEM:= SC7->C7_ITEM
			trb->C7_NUMSC:= SC7->C7_NUMSC
			trb->C7_PRODUTO:= SC7->C7_PRODUTO
			trb->C7_DESCRI:= SC7->C7_DESCRI
			trb->C7_UM:= SC7->C7_UM
			trb->C7_QUANT:= SC7->C7_QUANT
			trb->C7_QUJE:= SC7->C7_QUJE
			trb->C7_PRECO:= SC7->C7_PRECO
			trb->C7_TOTAL:= nValPed
			trb->C7_FORNECE:= SC7->C7_FORNECE
			trb->C7_LOJA:= SC7->C7_LOJA
			trb->A2_NREDUZ:= SA2->A2_NREDUZ
			trb->C7_OPER_F:= SC7->C7_OPER_F
			trb->C7_DATPRF:= (SC7->C7_DATPRF)
			trb->C7_CC:= SC7->C7_CC
			trb->CREDITO:= cCred
			trb->DEBITO:= cDeb
			trb->C7_CONTA:= SC7->C7_CONTA
			trb->C7_ITEMCTA:= SC7->C7_ITEMCTA
			trb->C7_OBS:= SC7->C7_OBS
			trb->C7_COND:= SC7->C7_COND
			trb->C7_CONTATO:= SC7->C7_CONTATO
			trb->C7_EMISSAO:= (SC7->C7_EMISSAO)
			trb->C7_APROV:= SC7->C7_APROV
			trb->C7_CONAPRO:= SC7->C7_CONAPRO
			trb->C7_USER:= SC7->C7_USER
			trb->C7_USUARIO:= SC7->C7_USUARIO
			trb->C7_RATEIO:= "1"
			trb->C7_XOBSFO:= SC7->C7_XOBSFO
			trb->C7_XOBSAPR:= SC7->C7_XOBSAPR
			trb->C7_XCCAPR:= SC7->C7_XCCAPR
			trb->NATUREZA:= SA2->A2_NATUREZ
			trb->TP:= "N"
			msunlock()
		Select TmpD1
		skip
	Enddo

Return

Static Function	InclResid()

	If Select ("TMPC7") > 0
			TMPC7->(dbCloseArea())
	EndIf

		cQuery := " SELECT DISTINCT C7_FILIAL,              	         "+CRLF
		cQuery += " C7_NUM,C7_ITEM,C7_FORNECE,C7_LOJA					 "+CRLF
		cQuery += " FROM "+RetSqlName("SC7")+" SC7 (NOLOCK)              "+CRLF
		cQuery += " WHERE SC7.D_E_L_E_T_ = ''                            "+CRLF
		cQuery += " AND SC7.C7_EMISSAO <='"+DTOS(dDataCom)+"'       		 "+CRLF
		cQuery += " AND SC7.C7_RESIDUO<>' '					       		 "+CRLF
		cQuery += " AND SC7.C7_XDTRESI > '"+DTOS(dDataCom)+"'       		 "+CRLF
		cQuery += " AND SC7.C7_XDTRESI <> '"+space(8)+"'	       		 "+CRLF
		cQuery:=ChangeQuery(cQuery)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMPC7", .F., .T.)
		dbgotop()

	Select TmpC7
	do while !eof()
		Select SCR
		dbSetOrder(1)
		Seek tmpC7->C7_FILIAL+"PC"+tmpC7->C7_NUM
		dDataLib := date()
		Do while !eof() .and.  CR_NUM=tmpC7->C7_NUM
			dDataLib := scr->cr_datalib
			skip
		Enddo
		Select TmpC7
		if dDataLib>dDataCom
//			skip
//			loop
		endif
		Select SC7
		dbSetOrder(1)
		Seek TMPC7->(C7_FILIAL+C7_NUM+C7_ITEM)
		Select SA2
		Seek xFilial()+tmpC7->(C7_fornece+C7_loja)
		Select TmpC7
		// Regra definida em 09/06/2020 - Quando Epep genérico ou sem Epep fazer a provisão apenas para o mês corrente
//		IF substr(SC7->C7_ITEMCTA,2,3)='GGG' .OR. EMPTY(SC7->C7_ITEMCTA)
		if (SC7->C7_DATPRF)>=dDataCom
		 		skip
		 		loop
		Endif
//		endif
			//5,6 e 7		Conta do PC	2101039999
			//Estoque		1106019999	2101039999
			//Imobilizado	1208059999	2101039999
			//Epep Futuro	1109019999	2101039999
			cDeb := cCred := ""
		do case
		case left(SC7->C7_CONTA,1)$"5*6*7"
				
				/*cDtEpep := stod('20'+substr(SC7->C7_ITEMCTA,6,6)) 
			if cDtEpep <= dDataCom
					cDeb  := SC7->C7_CONTA
			else
					cDeb  := "1109019999"
			endif*/

			cDtEpep := CTD->CTD_DTEVEN
			If cDtEpep <= dDataCom
				cDeb  := SC7->C7_CONTA
			ElseIf cDtEpep >= dDataCom .and. Alltrim(SC7->C7_PRODUTO)$'170603332/201202840/170603334'
				cDeb  := "1109019999"
			else
				cDeb  := SC7->C7_CONTA
			endif

				cCred := "2101039999"
		Case left(SC7->C7_CONTA,6)$"110601"
				cDeb  := "1106019999" 
				cCred := "2101039999"
		Case left(SC7->C7_CONTA,6)$"120805"
				cDeb  := "1208059999" 
				cCred := "2101039999"
		OTHERWISE
				skip
				loop
		endcase
			nValPed:= (SC7->C7_TOTAL)//SC7->C7_QUANT)*nSaldo
			cPed := SC7->C7_NUM
			RecLock("trb",.t.)
			trb->C7_FILIAL:= SC7->C7_FILIAL
			trb->C7_NUM:= SC7->C7_NUM
			trb->C7_ITEM:= SC7->C7_ITEM
			trb->C7_NUMSC:= SC7->C7_NUMSC
			trb->C7_PRODUTO:= SC7->C7_PRODUTO
			trb->C7_DESCRI:= SC7->C7_DESCRI
			trb->C7_UM:= SC7->C7_UM
			trb->C7_QUANT:= SC7->C7_QUANT
			trb->C7_QUJE:= SC7->C7_QUJE
			trb->C7_PRECO:= SC7->C7_PRECO
			trb->C7_TOTAL:= nValPed
			trb->C7_FORNECE:= SC7->C7_FORNECE
			trb->C7_LOJA:= SC7->C7_LOJA
			trb->A2_NREDUZ:= SA2->A2_NREDUZ
			trb->C7_OPER_F:= SC7->C7_OPER_F
			trb->C7_DATPRF:= (SC7->C7_DATPRF)
			trb->C7_CC:= SC7->C7_CC
			trb->CREDITO:= cCred
			trb->DEBITO:= cDeb
			trb->C7_CONTA:= SC7->C7_CONTA
			trb->C7_ITEMCTA:= SC7->C7_ITEMCTA
			trb->C7_OBS:= SC7->C7_OBS
			trb->C7_COND:= SC7->C7_COND
			trb->C7_CONTATO:= SC7->C7_CONTATO
			trb->C7_EMISSAO:= (SC7->C7_EMISSAO)
			trb->C7_APROV:= SC7->C7_APROV
			trb->C7_CONAPRO:= SC7->C7_CONAPRO
			trb->C7_USER:= SC7->C7_USER
			trb->C7_USUARIO:= SC7->C7_USUARIO
			trb->C7_RATEIO:= "1"
			trb->C7_XOBSFO:= SC7->C7_XOBSFO
			trb->C7_XOBSAPR:= SC7->C7_XOBSAPR
			trb->C7_XCCAPR:= SC7->C7_XCCAPR
			trb->NATUREZA:= SA2->A2_NATUREZ
			trb->TP:= "R"
			msunlock()
		Select TmpC7
		skip
	Enddo

Return

Static Function Ultprov()

Local dUltest
Local cAlias := GetNextAlias()

	BeginSql Alias cAlias
	SELECT R_E_C_N_O_, CT2_DATA FROM %table:CT2% CT2
	WHERE 
	R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  AS  RECNO
		FROM  %table:CT2% CT2 
		WHERE D_E_L_E_T_<>'*' AND 
	CT2.CT2_DATA <= '20211231' AND 
	CT2.CT2_LOTE='PROVPC') AND
	SUBSTR(CT2_ORIGEM,1,3)<>'Z03'	
	EndSql

	dUltest:=(cAlias)->CT2_DATA
	dUltest:=sTod(dUltest)

(cAlias)->(dbCloseArea())

Return(dUltest)
