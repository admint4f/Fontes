#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RVENDAS   º Autor ³ AP5 IDE            º Data ³  23/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP5 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RVENDAS()


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local aOrd := {}
	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Pedidos de Vendas "
	Local cPict          := ""
	Local titulo       := "Pedidos de Vendas "
	Local nLin         := 80

	//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//0         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
	//Filial Item Produto         Descricao                        Qtde.          Preço          Valor TES Conta                Centro               Elemento             Cliente Emissao  Pedido Nota   Serie  Tipo
	//                                                                                                     Contabil             Custo                PEP                                          Fiscal        Pagamento
	//99     9999 XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999,99 999,999,999.99 999,999,999.99 999 99999999999999999999 99999999999999999999 99999999999999999999 999999  99/99/99 999999 999999 XXX    XXXXXXXXXXXXXXX
	//99     9999 XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999,99 999,999,999.99 999,999,999.99 999 99999999999999999999 99999999999999999999 99999999999999999999 999999  99/99/99 999999 999999 XXX    XXXXXXXXXXXXXXX
	//99     9999 XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999,99 999,999,999.99 999,999,999.99 999 99999999999999999999 99999999999999999999 99999999999999999999 999999  99/99/99 999999 999999 XXX    XXXXXXXXXXXXXXX
	//Local Cabec1       := "FI IT COD.PRODUTO     DESCRIÇÃO DO PRODUTO           QUANT.    PREÇO         VALOR          TS  C.CONTABIL          DIVISÃO     CENTRO CUSTO         ELEMENTO PEP    CLIENTE  EMISSÃO NUM.PED.NUM.NF SÉRIE CONTA GERENCIAL"

	Local Cabec1		:= "Filial Item Produto         Descricao                        Qtde.          Preço          Valor TES Conta                Centro               Elemento             Cliente Emissao  Pedido Nota   Serie  Tipo"
	Local Cabec2        := "                                                                                                     Contabil             Custo                PEP                                          Fiscal        Pagamento"
	Local imprime      := .T.

	Private cString
	Private CbTxt        := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite           := 220
	Private tamanho          := "G"
	Private nomeprog         := "RVENDAS" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 15
	Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cPerg       := "RSC6"
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01

	Private wnrel      := "RVENDAS" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cString := "SC6"
	Private total := 0
	dbSelectArea("SC6")
	dbSetOrder(1)

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	
	//ValidPerg()
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP5 IDE            º Data ³  23/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local cMenNota := ""
	Local cQuery := ""
	Local cQuebra	:= ""
	Local bQuery	:= {|| Iif(Select("TRB") > 0,TRB->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.), dbSelectArea("TRB"), TRB->(dbEval({|| nTotReg++ })), TRB->(dbGoTop()) }
	Local nTotReg	:= 0

	cQuery := " SELECT A.R_E_C_N_O_ AS REGNOSC6, C6_NUM "
	cQuery += " FROM " + RetSQLName("SC6") + " A, " + RetSQLName("SC5") + " B "
	cQuery += " WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND C6_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND "
	cQuery += "       C6_CLI BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' AND A.D_E_L_E_T_ = ' ' AND "
	cQuery += "       C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_EMISSAO BETWEEN '" + DToS(mv_par03) + "' AND '" + DToS(mv_par04) + "' AND "
	cQuery += "       B.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY C6_NUM "
	Eval(bQuery)

	SetRegua(nTotReg)

	While TRB->(!EOF())  //.And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM <= mv_par02
		cQuebra := TRB->C6_NUM

		While TRB->(!Eof()) .And. TRB->C6_NUM == cQuebra


			dbSelectArea("SC6")
			SC6->(dbGoTo(TRB->REGNOSC6))


			cMenNota := Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_MENNOTA")

			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			SC5->(dbSeek(xFilial("SC5")+SC6->C6_NUM))


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o cancelamento pelo usuario...                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio. . .                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif

			// Coloque aqui a logica da impressao do seu programa...
			// Utilize PSAY para saida na impressora. Por exemplo:
			// @nLin,00 PSAY SA1->A1_COD


			//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			//0         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
			//Filial Item Produto         Descricao                        Qtde.          Preço          Valor TES Conta                Centro               Elemento             Cliente Emissao  Pedido Nota   Serie  Tipo
			//                                                                                                     Contabil             Custo                PEP                                          Fiscal        Pagamento
			//99     9999 XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 9999,99  99,999,999.99  99,999,999.99 999 99999999999999999999 99999999999999999999 99999999999999999999 999999  99/99/99 999999 999999 XXX    XXXXXXXXXXXXXXX


			@ nLin,00 PSAY SC6->C6_FILIAL
			@ nLin,07 PSAY SC6->C6_ITEM
			@ nLin,12 PSAY SC6->C6_PRODUTO
			@ nLin,28 PSAY substr(SC6->C6_DESCRI,1,30)
			@ nLin,59 PSAY Transform(SC6->C6_QTDVEN,"@E 9999.99")
			@ nLin,68 PSAY Transform(SC6->C6_PRCVEN,"@E 99,999,999.99")
			@ nLin,83 PSAY Transform(SC6->C6_VALOR,"@E 99,999,999.99")
			@ nLin,97 PSAY SC6->C6_TES
			@ nLin,101 PSAY SC6->C6_CONTA
			@ nLin,122 PSAY SC6->C6_CCUSTO
			//@ nLin,143 PSAY SC6->C6_CLVL
			@ nLin,143 PSAY SC6->C6_ITEMCC
			//@ nLin,123 PSAY Posicione("SC5",1,xFilial("SC5")+SC6->C6_NUM,"C5_TS125")
			@ nLin,164 PSAY Posicione("SC5",1,xFilial("SC5")+SC6->C6_NUM,"C5_CLIENTE")
			@ nLin,172 PSAY Posicione("SC5",1,xFilial("SC5")+SC6->C6_NUM,"C5_EMISSAO")
			@ nLin,181 PSAY SC6->c6_NUM
			@ nLin,188 PSAY SC6->C6_NOTA
			@ nLin,195 PSAY SC6->C6_SERIE
			@ nLin,202 PSAY ALLTRIM(SC5->C5_PAGTO)

			total := total + SC6->C6_VALOR
			obs := Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_DATA1")
			obs1 := Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_DATA2")
			obs2 := Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_DATA3")
			obs3 := Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_DATA4")
			parc1 :=Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_PARC1")
			parc2 :=Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_PARC2")
			parc3 :=Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_PARC3")
			parc4 :=Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_PARC4")
			condpag := Posicione("SC5",1,xFilial("SC5")+Sc6->c6_NUM,"C5_CONDPAG")
			cliente := Posicione("SA1",1,xFilial("SA1")+Sc5->C5_CLIENTE,"A1_NOME")       
			cnpj := Posicione("SA1",1,xFilial("SA1")+Sc5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CGC")
			// natureza := Posicione("SA1",1,xFilial("SA1")+Sc5->C5_CLIENTE,"A1_NATUREZ")
			TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo

			nLin := nLin + 1 // Avanca a linha de impressao
		Enddo

		If nLin+8 > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		@ nLin,64 PSAY "Total --->"
		@ nLin,78 PSAY total Picture "9,999,999.99"
		nLin := nLin + 1
		@ nLin,1 PSAY "Cliente :"
		@ nLin,14 PSAY cliente  
		@ nLin, 64 PSAY "CNPJ: " + Transform(cnpj,"@R 99.999.999/9999-99") 
		// @ nLin, 70 PSAY cnpj Picture "99.999.999/9999-99"
		// @ nLin,70 PSAY natureza
		nLin := nLin + 1
		@ nLin,1 PSAY "Vencimento 1 :"
		@ nLin,14 PSAY OBS
		@ nLin,27 PSAY "Parcela 1 : "
		@ nLin,40 PSAY parc1
		nLin := nLin + 1
		@ nLin,1 PSAY "Vencimento 2 :"
		@ nLin,14 PSAY OBS1
		@ nLin,27 PSAY "Parcela 2 : "
		@ nLin,40 PSAY parc2
		nLin := nLin + 1
		@ nLin,1 PSAY "Vencimento 3 :"
		@ nLin,14 PSAY OBS2
		@ nLin,27 PSAY "Parcela 3 : "
		@ nLin,40 PSAY parc3
		nLin := nLin + 1
		@ nLin,1 PSAY "Vencimento 4 :"
		@ nLin,14 PSAY OBS3
		@ nLin,27 PSAY "Parcela 4 : "
		@ nLin,40 PSAY parc4

		nLin++
		@ nLin,1 PSAY  "Cond.Pag. : "
		@ nLin,14 PSAY condpag
		nLin++
		@ nLin,001 PSay "Observações: " + AllTrim(Upper(cMenNota))
		nLin++
		@ nLin,0 Psay Replicate("-",220)
		//                  12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		nLin := nLin + 1
		total := 0
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SET DEVICE TO SCREEN

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  23/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,len(X1_GRUPO))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	//aAdd(aRegs,{cPerg,"","","mv_ch1","",00,00,0,"","","mv_par","","","","","","","","","","","","","",""})

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"01",; 				//Ordem
	"Do Pedido",;				//Pergunta em Portugues
	"De",;				//Pergunta em Espanhol
	"De",;				//Pergunta em Ingles
	"mv_ch1",;			//Variavel
	"C",;	   			//Tipo
	6,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				//
	"",;				//Validacao
	"mv_par01","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"02",; 				//Ordem
	"Ate Pedido",;				//Pergunta em Portugues
	"Ate",;				//Pergunta em Espanhol
	"Ate",;				//Pergunta em Ingles
	"mv_ch2",;			//Variavel
	"C",;	   			//Tipo
	6,0,0,;			//Tamanho, Decimal, Pre-Selecionada
	"G",;				//
	"",;				//Validacao
	"mv_par02","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"03",; 				//Ordem
	"Da Emissao",;				//Pergunta em Portugues
	"De",;				//Pergunta em Espanhol
	"De",;				//Pergunta em Ingles
	"mv_ch3",;			//Variavel
	"D",;	   			//Tipo
	8,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				//
	"",;				//Validacao
	"mv_par03","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"04",; 				//Ordem
	"Ate a Emissao",;				//Pergunta em Portugues
	"De",;				//Pergunta em Espanhol
	"De",;				//Pergunta em Ingles
	"mv_ch4",;			//Variavel
	"D",;	   			//Tipo
	8,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				//
	"",;				//Validacao
	"mv_par04","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"05",; 				//Ordem
	"Do Cliente",;				//Pergunta em Portugues
	"De",;				//Pergunta em Espanhol
	"De",;				//Pergunta em Ingles
	"mv_ch5",;			//Variavel
	"C",;	   			//Tipo
	6,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				//
	"",;				//Validacao
	"mv_par05","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"06",; 				//Ordem
	"Ate o Cliente",;				//Pergunta em Portugues
	"De",;				//Pergunta em Espanhol
	"De",;				//Pergunta em Ingles
	"mv_ch6",;			//Variavel
	"C",;	   			//Tipo
	6,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				//
	"",;				//Validacao
	"mv_par06","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	dbSelectArea(_sAlias)

Return
