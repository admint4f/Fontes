#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
+------------+-----------+--------+----------------------+-------+-------------+
| Programa:  | t4f_ctr01 | Autor: | Luiz Eduardo TapajГіs | Data: |  14/05/2020 |
+------------+-----------+--------+----------------------+-------+-------------+
| DescriГ§ГЈo: | RelatГіrio de contratos						                   |
+------------+-----------------------------------------------------------------+
| Alterado   |                                                                 |                   
+------------+-----------------------------------------------------------------+
*/

User Function t4f_ctr01()
	local i
	Private aParamBox   := {}
	Private aPerg       := {}
	Private aCpos       := {}
	Private aStruct     := {}
	Private lFuturo     := .F.
	Private cDestino    := ""
	Private aOpcoes     := {"Sim","Nao"}
	Private aTipoctr    := {"1=Comercial","2=Eventos","3=Permuta"}
	Private aStatctr    := {"1=Aguardando Aprovaзгo","2=Rejeitado","3=Aguardando Cadastro","4=Em Andamento","5=Cancelado","6=Todos"}
	Private nOpcoes
	Private nTipoctr
	Private nSTATCTR
	Private aSintetico  := {}
	Private nVenctos    := 2



	/*/Define Tamanho Campos
	aCpos := {  FWSizeFilial(),;            //01
	TamSX3('E1_NUM')[1],; //02
	TamSX3('E1_XPEDMEN')[1],; //03
	TamSX3('E1_XTIPOPE')[1],; //04
	TamSX3('E1_XPARCEL')[1],; //05
	TamSX3('E1_TIPO')[1],; //06
	TamSX3('E1_NATUREZ')[1],; //07
	TamSX3('E1_XBCO')[1],; //08
	TamSX3('E1_XAGENCI')[1],; //09
	TamSX3('E1_CLIENTE')[1],; //10
	TamSX3('E1_LOJA')[1],; //11
	TamSX3('E1_NOMCLI')[1],; //12
	TamSX3('E1_XCONTAT')[1],; //13
	TamSX3('E1_XDTPAG')[1],; //14
	TamSX3('E1_XDTDISP')[1],; //15
	TamSX3('E1_XDESCOP')[1],; //16
	TamSX3('E1_VALOR')[1],; //17
	TamSX3('E1_XJUROS')[1],; //19
	TamSX3('E1_XMULTA')[1],; //20
	TamSX3('E1_XVLTAXA')[1],; //21
	TamSX3('E1_XDESCON')[1],; //22
	TamSX3('E1_XNUMCV')[1],; //23
	TamSX3('E1_XNUMAUT')[1],; //24
	TamSX3('E1_BAIXA')[1]} //25
	/*/
	//aAdd(aParamBox,{1,"Data de               ",DDATABASE           ,"","","   ","",80,.F.})  //01
	//aAdd(aParamBox,{1,"Data ate              ",DDATABASE           ,"","","   ","",80,.F.})  //02
	//aAdd(aParamBox,{6,"Diretorio Gravacao    ",Space(80),"",,"", 90 ,.F.,"Arquivos .CSV |*.CSV","C:\",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY})
	//aAdd(aParamBox,{4,"Tipo de Contrato ?",.F.,"1=Comercial",90,"",.F.})  //05
        //aAdd(aParamBox,{4,"",.F.,"2=Eventos",90,"",.F.})  //06
        //aAdd(aParamBox,{4,"",.F.,"3=Permuta",90,"",.F.})  //07
        //aAdd(aParamBox,{2,"Status do Contratos   ",4 ,aStatCtr    ,80,"",.F.})  //08


	aAdd(aParamBox,{1,"Data de               ",DDATABASE           ,"","","   ","",50,.F.})  //01
	aAdd(aParamBox,{1,"Data ate              ",DDATABASE           ,"","","   ","",50,.F.})  //02
	aAdd(aParamBox,{6,"Diretorio Gravacao    ",Space(80),"",,"", 70 ,.F.,"Arquivos .CSV |*.CSV","C:\",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY})
//	aAdd(aParamBox,{2,"Tipo de Contrato      ",3                   ,aTipoCtr    ,80,"",.F.})  //04
        aAdd(aParamBox,{4,"Tipo de Contrato ?",.F.,"1=Comercial",50,"",.F.})  //05
        aAdd(aParamBox,{4,"",.F.,"2=Eventos",50,"",.F.})  //06
        aAdd(aParamBox,{4,"",.F.,"3=Permuta",50,"",.F.})  //07
        aAdd(aParamBox,{2,"Status do Contratos   ",4 ,aStatCtr    ,70,"",.F.})  //08
        aAdd(aParamBox,{9," ",150,7,.T.})    

	If !ParamBox(aParamBox, "Parametros...", aPerg)
		Return Nil
	EndIf

	cDestino := AllTrim(aPerg[03])
	
	//aperg[4] - Tipo contrato = 1
	//aperg[5] - Tipo contrato = 2
	//aperg[6] - Tipo contrato = 3
	//aperg[7] - Tipo contrato = 3

	If ValType(aPerg[07]) = "C"
		For i := 1 to Len(aStatCtr)
			If val(aPerg[07]) == val(aStatCtr[i])
				nStatCtr := i
			EndIf
		Next
	Else
		nStatCtr := aPerg[07]
	EndIf

	Processa({|| geraarq()  }, "Aguarde", "Apurando Contratos")

	Processa({||  APLImpExcel()  }, "Aguarde", "Gerando Planilha ...")

Return

/*
+------------+-----------+--------+---------------------+-------+------------+
| Programa:  |  GERAARQ  | Autor: | Luiz Eduardo TapajГіs| Data: | 14/05/2020 |
+------------+-----------+--------+---------------------+-------+------------+
| DescriГ§ГЈo: | Gera dados para processamento da planilha                     |
+------------+---------------------------------------------------------------+
| Uso:       | T4f                                                           |
+------------+---------------------------------------------------------------+
|            |                                                               |
| AlteraГ§Гµes |                                                               |
|            |                                                               |
+------------+---------------------------------------------------------------+
*/

Static Function geraarq()

	Local cQuery        := ""
	Local aDados        := ""
	Local nSaldo
	Local nDifDt        := 0

	If Select ("TMP") > 0
		TMP->(dbCloseArea())
	EndIf

cQuery :=' SELECT DISTINCT ZZ0_FILIAL ,' 
cQuery +='	ZZ0_CONTRA ,' 
cQuery +='	ZZ0_ITEM,' 
cQuery +='	ZZ0_TPCONT,' 
cQuery +='	ZZ0_ELEPEP, '
cQuery +='	CTD_DESC01,'
cQuery +='	ZZ0_NATURE,'
cQuery +='	ZZ0_CONTA,'
cQuery +='	CT1_DESC01,'
cQuery +='	ZZ0_CC,'
cQuery +='	CTT_DESC01,'	
cQuery +='  ZZ0_CTPIS,' 

cQuery +=' CASE '  
cQuery +=" WHEN ZZ0_CTPIS = '4401030004'" 
cQuery +=" THEN 'PIS - PATROCINIO - CO-PATROCINIO'" 
cQuery +=" ELSE 'ERRO DESCRICAO'" 
cQuery +=' END AS "DescCtaPis",'         

cQuery +=' ZZ0_ALQPIS,' 
cQuery +=' ZZ0_CTCOF, '

cQuery +=' CASE ' 
cQuery +=" WHEN ZZ0_CTCOF = '4402030004'" 
cQuery +=" THEN 'COFINS - PATROCINIO - CO PATROCINIO'" 
cQuery +=" ELSE 'ERRO DESCRICAO' "
cQuery +=' END AS "DescCtaCof",'
 
cQuery +=' ZZ0_ALQCOF,'
cQuery +=' ZZ0_CTISS,' 

cQuery +=' CASE '  
cQuery +=" WHEN ZZ0_CTISS = '4403030004' "
cQuery +=" THEN 'ISS - PATROCINIO - CO-PATROCINIO'" 
cQuery +=" ELSE 'ERRO DESCRICAO' "
cQuery +=' END AS "DescCtaISS",'

cQuery +=' ZZ0_ALQISS,'
cQuery +=' ZZ0_CLIENT,'
cQuery +=' ZZ0_LOJA, '
cQuery +=' ZZ0_CLICOB,' 
cQuery +=' ZZ0_PRODUT,'
cQuery +=' ZZ0_VALOR,' 
cQuery +=' ZZ0_DATA1,' 
cQuery +=' ZZ0_DATA2, '
cQuery +=' ZZ0_DTINC,' 
cQuery +=' ZZ0_RESPON,' 
cQuery +=' ZZ2_PEDIDO, '
cQuery +=' ZZ2_VALOR, '
cQuery +=' ZZ2_VENCTO,' 
cQuery +=' ZZ2_VENCTI,' 
cQuery +=' ZZ2_NUMNF,'
cQuery +=' ZZ0_STATUS,'
cQuery +=' ZZ0.R_E_C_N_O_ as REGISTRO'

cQuery +="	FROM " + RetSqlName("ZZ0") + " ZZ0 "
cQuery +="	FULL JOIN  " + RetSqlName("ZZ2") + " ZZ2 "
cQuery +="	ON ZZ2_CONTRA = ZZ0_CONTRA"
cQuery +="	AND ZZ2_ITEM = ZZ0_ITEM"
cQuery +="	AND ZZ2_FILIAL = ZZ0_FILIAL"
cQuery +="	AND ZZ0.D_E_L_E_T_ = ' '"
cQuery +="	AND ZZ2.D_E_L_E_T_ = ' '"
cQuery +="	FULL JOIN " + RetSqlName("CTD") + " CTD "
cQuery +="	ON CTD_ITEM = ZZ0_ELEPEP"
cQuery +="	FULL JOIN " + RetSqlName("CT1") + " CT1 "
cQuery +="	ON CT1_CONTA = ZZ0_CONTA"
cQuery +="	FULL JOIN " + RetSqlName("CTT") + " CTT "
cQuery +="	ON CTT_CUSTO = ZZ0_CC"
cQuery +="	JOIN " + RetSqlName("SB1") + " B1 "
cQuery +="	ON B1_COD = ZZ0_PRODUT"
cQuery +="	WHERE ZZ0_DTINC BETWEEN '"+dtos(aPerg[1])+"' AND '"+dtos(aPerg[2])+"'"
//cQuery +="	AND ZZ0_TPCONT IN ('1','3')"
//cQuery +="	AND ZZ0_STATUS = '4'"
cQuery +="	AND ZZ0.D_E_L_E_T_ = ' '"
cQuery +="	AND ZZ2.D_E_L_E_T_ = ' '"
cQuery +="	ORDER BY ZZ0_FILIAL, ZZ0_CONTRA, ZZ0_ITEM, ZZ2_VENCTO"


	cQuery:=ChangeQuery(cQuery)

	//cQuery += "DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP", .F., .T.)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP", .F., .T.)
	

//COPY TO \X
/*	TCSetField( "TMP", "VALOR"     , "N", 12, 2 )
	TCSetField( "TMP", "JUROS"     , "N", 12, 2 )
	TCSetField( "TMP", "MULTA"     , "N", 12, 2 )
	TCSetField( "TMP", "TAXA"      , "N", 12, 2 )
	TCSetField( "TMP", "DESCONTO"  , "N", 12, 2 )
	TCSetField( "TMP", "VALORTOT"  , "N", 12, 2 )
	TCSetField( "TMP", "PAGAMENTO" , "D", 08, 0 )
	TCSetField( "TMP", "DTDISPO"   , "D", 08, 0 )
	TCSetField( "TMP", "DTBAIXA"   , "D", 08, 0 )
*/
	dbSelectArea("TMP")
	Count to nRegs



Return


/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ"пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅAPLIMPEXCEL  пїЅAutor  пїЅMicrosiga        пїЅ Data пїЅ  11/30/15   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                        пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
STATIC Function APLIMPEXCEL()
	Local oExcel
	Local nExcel        := 0
	Local cArq          := ""
	Local nI            := 0
	Local nX            := 0
	Local cPlan1        := "RESULTADO"
	Local aDados        := {}
	local i

	oExcel := FWMSEXCEL():New()

	//Inclui nova Planilha no Arquivo
	oExcel:AddworkSheet(cPlan1)

	//Adiciona Tabela
	cTab        := "Contratos - Gerador por "+UPPER(Alltrim(cUserName))+" EM "+DtoC(Date())+" AS "+Time()+" DATABASE "+DtoC(aPerg[01])+iif(nOpcoes=1," atй "+DtoC(aPerg[02]),"")

	oExcel:AddTable(cPlan1,cTab)

oExcel:AddColumn(cPlan1,cTab,"Filial" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Nє Contrato" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Nє Item Contrato" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Tipo Contrato" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Elemento PEP" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Descriзгo Epep",1,1)
oExcel:AddColumn(cPlan1,cTab,"Centro de Custo" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Descriзгo CC" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Natureza" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Conta Fiscal" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Descriзгo Conta" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Conta Pis" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Descriзгo Conta Pis" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Aliquota Pis" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Conta Cofins", 1,1)
oExcel:AddColumn(cPlan1,cTab,"Descriзгo Conta Cof",1,1)
oExcel:AddColumn(cPlan1,cTab,"Aliquota Cofins" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Conta Iss" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Descriзгo Conta ISS" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Aliquota Iss" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Cуdigo Cliente" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Loja", 1,1)
oExcel:AddColumn(cPlan1,cTab,"Nome do Cliente" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Produto" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Valor Contrato" ,3,2)
oExcel:AddColumn(cPlan1,cTab,"Data Inicio" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Data Fim" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Data Inclusao Contrato" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Executivo Responsбvel" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Pedido de Vendas" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Valor da Parcela" ,1,1)
oExcel:AddColumn(cPlan1,cTab,"Data do Faturamento",1,1)
oExcel:AddColumn(cPlan1,cTab,"Data do Vencimento",1,1)
oExcel:AddColumn(cPlan1,cTab,"Numero NF",1,1)
oExcel:AddColumn(cPlan1,cTab,"Status Contrato",1,1)
oExcel:AddColumn(cPlan1,cTab,"Registro",3,2)

	dbSelectArea("TMP")
	Count to nExcel

	ProcRegua(nExcel)

	TMP->(dbGotop())
	
	While TMP->(!Eof())
		IncProc("Gerando Excel...")
		if !aperg[4] .and. val(ZZ0_TPCONT)=1
			skip
			loop
		endif
		if !aperg[5] .and. val(ZZ0_TPCONT)=2
			skip
			loop
		endif
		if !aperg[6] .and. val(ZZ0_TPCONT)=3
			skip
			loop
		endif
		if nStatCtr<>6
			IF val(ZZ0_STATUS)<>nStatCtr
				SKIP
				LOOP
			ENDIF
		endif
		
		Select CT1
		dbSetOrder(1)
		Seek xFilial()+tmp->ZZ0_CONTA
		cConta := ct1_desc01
		Seek xFilial()+tmp->ZZ0_CTPIS
		cCTpis := ct1_desc01
		Seek xFilial()+tmp->ZZ0_CTCOF
		cCtcof := ct1_desc01
		Seek xFilial()+tmp->ZZ0_CTISS
		cCtiss := ct1_desc01

		Select Tmp
		
		aDados := {TMP->ZZ0_FILIAL,;
		ZZ0_CONTRA,;
		ZZ0_ITEM,;
		ZZ0_TPCONT,;
		ZZ0_ELEPEP,;
		CTD_DESC01,;
		ZZ0_CC,;
		CTT_DESC01,;
		ZZ0_NATURE,;
		ZZ0_CONTA,;
		cConta,;
		ZZ0_CTPIS,;
		cCtPIS,;
		ZZ0_ALQPIS,;
		ZZ0_CTCOF,;
		cCTCof,;
		ZZ0_ALQCOF,;
		ZZ0_CTISS,;
		cCTISS,;
		ZZ0_ALQISS,;
		ZZ0_CLIENT,;
		ZZ0_LOJA,;
		ZZ0_CLICOB,;
		ZZ0_PRODUT,;
		ZZ0_VALOR,;
		ZZ0_DATA1,;
		ZZ0_DATA2,;
		ZZ0_DTINC,;
		ZZ0_RESPON,;
		ZZ2_PEDIDO,;
		ZZ2_VALOR,;
		ZZ2_VENCTO,;
		ZZ2_VENCTI,;
		ZZ2_NUMNF,;
		ZZ0_STATUS;
		,REGISTRO}

		oExcel:AddRow(cPlan1,cTab,aDados)

		Tmp->(dbSkip())
	EndDo

	oExcel:Activate()

	//Cria nome para arquivo
	cArq := CriaTrab( NIL, .F. ) + ".xml"
	cArq := "T4F_CTR_" + Substr(DtoS(Date()),7,2)+"-"+Substr(DtoS(Date()),5,2)+"-"+Substr(DtoS(Date()),1,4) + "_" + StrTran(Time(),":") + ".xml"
	oExcel:GetXMLFile( cArq )

	//Copia arquivo para diretпїЅrio temporпїЅrio do usuпїЅrio
	//e realiza abertura do mesmo
	If __CopyFile( cArq, cDestino+"\"+ cArq )
		MsgInfo( cArq +" Relatorio gravado na Pasta " + cDestino )
		oExcel := MsExcel():New()
		oExcel:WorkBooks:Open(cDestino+cArq)
		oExcel:SetVisible(.T.)
		oExcel:Destroy()
	Else
		MsgInfo( "Arquivo nгo copiado para temporбrio do usuбrio." )
	Endif

	TMP->(dbCloseArea())

Return
