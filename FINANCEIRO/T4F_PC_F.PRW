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
| Alterado   |                                                                 |                   
+------------+-----------------------------------------------------------------+
*/
User Function T4F_PC_F()

	local i
	Private dFech
	Private aParamBox   := {}
	Private aPerg       := {}
	Private aCpos       := {}
	Private aStruct     := {}
	Private aOpcoes     := {"Contábil","Financeiro"}
	Private nOpcoes
	Private cDestino    := ""
	Public cTp

	aAdd(aParamBox,{1,"DataBase           ",DDATABASE           ,"","","   ","",80,.F.})  //01
	aAdd(aParamBox,{6,"Diretorio Gravacao ",Space(80),"",,"", 90 ,.F.,"Arquivos .CSV |*.CSV","C:\",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY})  //03
	//aAdd(aParamBox,{2,"Tipo de relatório ? ",3                   ,aOpcoes    ,80,"",.F.})  //02

	If !ParamBox(aParamBox, "Parametros...", aPerg)
		Return Nil
	EndIf

	cDestino := AllTrim(aPerg[02])
	nOpcoes := 2

	Processa({|| geratmp()  }, "Aguarde", "Apurando Pedidos de Compras em Aberto")

Return


Static Function geratmp()

	Local cQuery        := ""
	Local aDados        := ""

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

	cQuery += " WHERE C7.D_E_L_E_T_ = ''                             "+CRLF
	cQuery += " AND C7.C7_EMISSAO  <= '"+DTOS(aPerg[01])+"'       "+CRLF
	cQuery += " AND C7_QUJE<C7_QUANT AND C7_RESIDUO=' '              "+CRLF
if nOpcoes = 1  // Se contábil verifica se está aprovado
	cQuery += " AND C7_CONAPRO='L'                                   "+CRLF
endif

	cQuery:=ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP", .F., .T.)

	TCSetField( "TMP", "QUANT"     , "N", 12, 2 )
	TCSetField( "TMP", "QUJE"      , "N", 12, 2 )
	TCSetField( "TMP", "PRECO"     , "N", 12, 2 )
	TCSetField( "TMP", "TOTAL"     , "N", 12, 0 )
	TCSetField( "TMP", "EMISSAO"   , "D", 08, 0 )
	TCSetField( "TMP", "DATPRF"    , "D", 08, 0 )

	dbSelectArea("TMP")
	Count to nRegs

	ProcRegua(nRegs)

	TMP->(dbGotop())

	IF SELECT("TRBFIN") # 0
		TRBFIN->(DBCLOSEAREA( ))
	ENDIF

	aCampos := {}
	AADD(aCampos,{ "C7_FILIAL",'C',2,0})
	AADD(aCampos,{ "C7_NUM",'C',6,0})
	AADD(aCampos,{ "C7_TOTAL",'N',14,2})
	AADD(aCampos,{ "VENCTO",'D',8,0})
	AADD(aCampos,{ "C7_FORNECE",'C',6,0})
	AADD(aCampos,{ "C7_LOJA",'C',2,0})
	AADD(aCampos,{ "A2_NREDUZ",'C',40,0})
	AADD(aCampos,{ "C7_DATPRF",'D',8,0})
	AADD(aCampos,{ "C7_COND",'C',3,0})
	AADD(aCampos,{ "C7_EMISSAO",'D',8,0})
	AADD(aCampos,{ "C7_CC",'C',20,0})
	AADD(aCampos,{ "CREDITO",'C',20,0})
	AADD(aCampos,{ "DEBITO",'C',20,0})
	AADD(aCampos,{ "C7_CONTA",'C',20,0})
	AADD(aCampos,{ "C7_ITEMCTA",'C',20,0})
	AADD(aCampos,{ "NATUREZA",'C',09,0})

	cTempFin := CriaTrab(nil,.f.)
	dbCreate(cTempFin,aCampos)
	dbUseArea( .T.,,cTempFin,"TRBFIN", Nil, .F. )


	IF SELECT("TRB") # 0
		TRB->(DBCLOSEAREA( ))
	ENDIF

	//????????????????????????????????
	//?Cria array para gerar arquivo de trabalho                    ?
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

	cTemp := CriaTrab(nil,.f.)
	dbCreate(cTemp,aCampos)
	dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )
	cPed := ""
	nTot := 0
	Select Tmp
	do while !eof()
		nSaldo := tmp->(C7_QUANT-C7_QUJE)
		if nSaldo > 0
			//5,6 e 7		Conta do PC	2101039999
			//Estoque		1106019999	2101039999
			//Imobilizado	1208059999	2101039999
			//Epep Futuro	1109019999	2101039999
			cDeb := cCred := ""
			do case
				case left(trb->C7_CONTA,1)$"5*6*7"
				cDtEpep := stod('20'+substr(tmp->C7_ITEMCTA,6,6)) 
				if cDtEpep <= dFech
					cDeb  := trb->C7_CONTA
				else
					cDeb  := "1109019999"
				endif
				cCred := "2101039999"
				Case left(trb->C7_CONTA,6)$"110601"
				cDeb  := "1106019999" 
				cCred := "2101039999"
				Case left(trb->C7_CONTA,6)$"120805"
				cDeb  := "1208059999" 
				cCred := "2101039999"
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
			else
				GravaFin()
			endif
			DO WHILE !eof() .and. tmp->(C7_FILIAL+C7_NUM+C7_ITEM) = SCH->(CH_FILIAL+CH_PEDIDO+CH_ITEMPD)
				do case
					case left(trb->C7_CONTA,1)$"5*6*7"
					cDtEpep := stod('20'+substr(tmp->C7_ITEMCTA,6,6)) 
					if cDtEpep <= dFech
						cDeb  := trb->C7_CONTA
					else
						cDeb  := "1109019999"
					endif
					cCred := "2101039999"
					Case left(trb->C7_CONTA,6)$"110601"
					cDeb  := "1106019999" 
					cCred := "2101039999"
					Case left(trb->C7_CONTA,6)$"120805"
					cDeb  := "1208059999" 
					cCred := "2101039999"
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
				GravaFin()
				Select SCH
				dbskip()
			enddo
		Endif
		Select Tmp
		skip
		Select Tmp
	Enddo

	oReport := RptDef("PCABERTO")
	//if MsgBox ("Deseja abrir planilha Excel ?","Escolha","YESNO")
	oReport:PrintDialog() 
	//endif


Return		

Static Function GravaFin()

			dbSelectArea("SE4")
			dbSetOrder(1)
			Seek xFilial()+trb->C7_COND
			aVenc := {}
			do case
			case E4_TIPO='1' .AND. !','$E4_COND
				nParc := 1
				aAdd(aVenc,{(trb->C7_DATPRF)+val(substr(E4_COND,1,3))})
			case E4_TIPO='1' .AND.  ','$E4_COND
			
    			q := 1
				For n:=1 to len(trim(E4_COND))
					x:=at(",",substr(E4_COND,q,40))
					aAdd(aVenc,{(trb->C7_DATPRF)+val(substr(E4_COND,q,x-1))})
					q := x+1
				Next n
				nParc := n
			case E4_TIPO<>'1'
				n:=1
				aAdd(aVenc,{trb->C7_DATPRF})
			Endcase 

			For n:=1 to len(aVenc)
				//Grava dados do financeiro
				RecLock("trbfin",.t.)
				trbfin->C7_FILIAL:= trb->C7_FILIAL
				trbfin->C7_NUM:= trb->C7_NUM
				trbfin->C7_TOTAL:= nValPed
				trbfin->C7_FORNECE:= trb->C7_FORNECE
				trbfin->C7_LOJA:= trb->C7_LOJA
				trbfin->A2_NREDUZ:= trb->A2_NREDUZ
				trbfin->C7_EMISSAO:= trb->C7_EMISSAO
				trbfin->C7_DATPRF := trb->C7_DATPRF
				trbfin->C7_COND:= trb->C7_COND
				trbfin->NATUREZA:= trb->NATUREZA
				trbfin->C7_CC:= trb->C7_CC
				trbfin->CREDITO:= trb->CREDITO
				trbfin->DEBITO:= trb->DEBITO
				trbfin->C7_CONTA:= trb->C7_CONTA
				trbfin->C7_ITEMCTA:= trb->C7_ITEMCTA
				trbfin->VENCTO:= aVenc[n][1]
				MsUnLock()
			Next n

Static Function RptDef(cNome)

	Local oReport := Nil
	Local oSection1:= Nil
	Local oBreak
	Local oFunction   

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

	Local cQuery    := ""
	Local cPedido   := ""
	Local lPrim 	:= .T.

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
			oSection1:Cell("C7_CONTA"):SetValue(TRB->C7_CONTA)
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

