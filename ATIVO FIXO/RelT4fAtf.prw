#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#define _EOL chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELAT4FATFº Autor ³Gilberto A Oliveira º Data ³  18/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio da Base de Ativo Fixo com os campos definidos    º±±
±±º          ³ pelo usuario T4f                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F / ATIVO FIXO                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RelT4fAtf()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "Relatorio Ativo Fixo"
	Local cPict        := ""
	Local titulo       := "Relatorio Ativo Fixo"
	Local nLin         := 80
	Local Cabec1       := "Filial C.Base Bem Item Conta Contabil                                        Dt. Aquis. Descrição do Bem                         Taxa Depr.    Depreciacao Mes     Valor Original    Depre.Acumulada     Valor Residual"
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd         := {}
	Private lEnd       := .F.
	Private lAbortPrint:= .F.
	Private CbTxt      := ""
	Private limite     := 220
	Private tamanho    := "G"
	Private nomeprog   := "RELT4FATF" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo      := 15
	Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey   := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "RELT4FAF" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cString := "SN1"
	Private cPerg   := "ATFT4F"

	dbSelectArea("SN1")
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao CodeAnalisys 				                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	PutSx1(cPerg,"01",	"Conta Contabil de ?",	"Conta Contabil de ?" ,	"Conta Contabil de ?",	"mv_ch1",	"C",20,	0,	0,	"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02",	"Conta Contabil ate ?","Conta Contabil ate ?","Conta Contabil ate ?",	"mv_ch2",	"C",20,	0,	0,	"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03",	"Filial de ?",	"Filial de ?" ,	"Filial de ?",	"mv_ch3",	"C",2,	0,	0,	"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"04",	"Filial ate ?","Filial de ?","Filial de ?",	"mv_ch4",	"C",2,	0,	0,	"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"05",	"Data Aquisic. de ?", "Data Acquisition?" ,	"Conta Contabil de ?",	"mv_ch5",	"D",8,	0,	0,	"G","","","","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"06",	"Data Aquisic. Ate ?","Date of acquisition up to?","Conta Contabil ate ?",	"mv_ch6",	"D",8,	0,	0,	"G","","","","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"07",	"Criar Planilha ?","Create Spreadsheet?","Create Spreadsheet ?","mv_ch7",	"C",02,0,0,	"C","","","","","mv_par07","Sim"         ,"","","","Não"            ,"","","","","","","","","","","",{"Caso deseje gerar um arquivo a ser aberto",'no Excel, escolha "Sim"'},{},{})
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

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

	If Empty(MV_PAR04)
		mv_par04:= "ZZ"
	EndIf

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  18/01/10   º±±
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
	Local dUltDepr		:= GetMv("MV_ULTDEPR")
	Local nTotDMes		:= 0
	Local nTotVOrig		:= 0
	Local nTotDAcum		:= 0
	Local nGTotDMes		:= 0
	Local nGTotVOrig	:= 0
	Local nGTotDAcum	:= 0
	Local cCContabil	:= ''
	Local cDescCta		:= ''
	Local cQuery		:= ''
	
	
	//----------------------------------------------------------------------------------------
	// Revisao de Fontes Virada de Versao - CodeAnalisys Carlos Eduardo Saturnino 15/08/2019
	//----------------------------------------------------------------------------- { Inicio }
	/*
	cQuery+= "SELECT "+_EOL
	cQuery+= "SN1.N1_FILIAL, "+_EOL
	cQuery+= "SN3.N3_FILIAL, "+_EOL
	cQuery+= "SN1.N1_CBASE, "+_EOL
	cQuery+= "SN1.N1_ITEM, "+_EOL
	cQuery+= "SN3.N3_CCONTAB, "+_EOL
	cQuery+= "SN3.N3_AQUISIC, "+_EOL
	cQuery+= "SN1.N1_DESCRIC || N3_HISTOR AS DESCRIC, "+_EOL
	cQuery+= "SN3.N3_TXDEPR1, "+_EOL
	cQuery+= "SN3.N3_VRDMES1, "+_EOL
	cQuery+= "SN3.N3_VORIG1, "+_EOL
	cQuery+= "SN3.N3_VRDACM1, "+_EOL
	cQuery+= "SN3.N3_CBASE, "+_EOL
	cQuery+= "SN3.N3_ITEM, "+_EOL
	cQuery+= "SN3.N3_BAIXA, "+_EOL
	cQuery+= "SN1.N1_BAIXA, "+_EOL
	cQuery+= "SN3.R_E_C_N_O_ RECNO  "+_EOL
	cQuery+= "FROM "+RetSqlName("SN3")+" SN3, "+_EOL
	cQuery+= RetSqlName("SN1")+" SN1 "+_EOL
	cQuery+= "WHERE "+_EOL
	cQuery+= "SN3.N3_FILIAL >= '"+MV_PAR03+"' AND SN3.N3_FILIAL <= '"+MV_PAR04+"' AND "+ _EOL 
	cQuery+= "SN3.N3_CCONTAB <> ' ' AND "+_EOL
	cQuery+= "SN3.N3_CCONTAB >= '"+MV_PAR01+"' AND SN3.N3_CCONTAB <= '"+MV_PAR02+"' AND "+_EOL
	cQuery+= "SN3.N3_AQUISIC >= '"+DTOS(MV_PAR05)+"' AND SN3.N3_AQUISIC <= '"+DTOS(MV_PAR06)+"' AND "+_EOL
	cQuery+= "SN3.N3_DTBAIXA = ' ' AND "+_EOL
	cQuery+= "SN3.D_E_L_E_T_=' ' AND "+_EOL
	cQuery+= "SN1.N1_FILIAL = SN3.N3_FILIAL AND "+_EOL
	cQuery+= "SN1.N1_CBASE  = SN3.N3_CBASE AND "+_EOL
	cQuery+= "SN1.N1_ITEM   = SN3.N3_ITEM  AND "+_EOL
	cQuery+= "SN1.D_E_L_E_T_=' ' "+_EOL
	cQuery+= "ORDER BY SN3.N3_CCONTAB,SN3.N3_FILIAL,SN1.N1_CBASE,SN1.N1_ITEM"+_EOL

	cQuery:= ChangeQuery(cQuery)
	Memowrite("C:\RELT4FATF.SQL",cquery)   
	
	MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"ATFSQL",.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")	
	
	*/
	BeginSql Alias "ATFSQL"
		
		Column N3_BAIXA as DATE
		Column N1_BAIXA as DATE
		
		SELECT 	SN1.N1_FILIAL, 
		        SN3.N3_FILIAL, 
		        SN1.N1_CBASE, 
		        SN1.N1_ITEM, 
		        SN3.N3_CCONTAB, 
		        SN3.N3_AQUISIC, 
		        SN1.N1_DESCRIC || N3_HISTOR AS DESCRIC, 
		        SN3.N3_TXDEPR1, 
		        SN3.N3_VRDMES1, 
		        SN3.N3_VORIG1, 
		        SN3.N3_VRDACM1, 
		        SN3.N3_CBASE, 
		        SN3.N3_ITEM, 
		        SN3.N3_BAIXA, 
		        SN1.N1_BAIXA, 
		        SN3.R_E_C_N_O_ RECNO 
		FROM	%TABLE:SN3% SN3, 
		        %TABLE:SN1% SN1 
		WHERE 	SN3.N3_FILIAL 	>= %EXP:MV_PAR03% 
		AND   	SN3.N3_FILIAL 	<= %EXP:MV_PAR04% 
		AND   	SN3.N3_CCONTAB 	<> ' ' 
		AND   	SN3.N3_CCONTAB 	>= %EXP:MV_PAR01% 
		AND   	SN3.N3_CCONTAB 	<= %EXP:MV_PAR02% 
		AND   	SN3.N3_AQUISIC 	>= %EXP:MV_PAR05% 
		AND   	SN3.N3_AQUISIC 	<= %EXP:MV_PAR06% 
		AND    	SN3.N3_DTBAIXA 	= ' ' 
		AND   	SN1.N1_FILIAL 	= SN3.N3_FILIAL 
		AND    	SN1.N1_CBASE 	= SN3.N3_CBASE 
		AND   	SN1.N1_ITEM 	= SN3.N3_ITEM 
		AND   	SN1.%NOTDEL% 
		AND   	SN3.%NOTDEL%
		ORDER BY 
				SN3.N3_CCONTAB, 
				SN3.N3_FILIAL, 
				SN1.N1_CBASE, 
				SN1.N1_ITEM	
	EndSQL
	
	// { Fim } -------------------------------------------------------------------------------
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Compatibiliza os campos com a TopField ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTamSX3	:= TAMSX3("N3_AQUISIC") ; TcSetField("ATFSQL", "N3_AQUISIC",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3	:= TAMSX3("N3_TXDEPR1") ; TcSetField("ATFSQL", "N3_TXDEPR1",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3	:= TAMSX3("N3_VRDMES1") ; TcSetField("ATFSQL", "N3_VRDMES1",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3	:= TAMSX3("N3_VORIG1")  ; TcSetField("ATFSQL", "N3_VORIG1",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3	:= TAMSX3("N3_VRDACM1") ; TcSetField("ATFSQL", "N3_VRDACM1",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3 := TAMSX3("N3_BAIXA") 	; TcSetField("ATFSQL", "N3_BAIXA",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3 := TAMSX3("N1_BAIXA") 	; TcSetField("ATFSQL", "N1_BAIXA",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	
	DbSelectArea("ATFSQL")
	DbCommitAll()         

	ATFSQL->( DbGotop() )

	If MV_PAR07 == 3
		_cArquivo:= "C:\TESTE"
		_cPNome:= "AtivoFixo"
		_cAlias:= "ATFSQL"

		MsAguarde( { || u_DB2XML(_cArquivo, _cPNome, _cAlias)},"Aguarde .. Gerando arquivo XML...")

	EndIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	SetRegua(RecCount())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
	//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
	//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
	//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
	//³                                                                     ³
	//³ dbSeek(xFilial())                                                   ³
	//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cCContabil:= ATFSQL->N3_CCONTAB

	While ATFSQL->( !EOF() )

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
			nLin := 8      
			@nLin,00 PSAY "DATA DO ULTIMO CALCULO DA DEPRECIACAO : "+DTOC(dUltDepr)
			nLin := nLin + 2 // Avanca a linha de impressao	   

		Endif

		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		// @nLin,00 PSAY SA1->A1_COD

		//Cod.Base Item   C 10  - N1_CBASE, N3_CBASE
		//Cod.Item        C  4  - N1_ITEM, N3_ITEM
		//Dt.Aquisicao    D  8  - N1_AQUISIC, N3_AQUISIC
		//Descricao(Sint) C 40  - N1_DESCRIC
		//Histor          C 40  - N3_HISTOR
		//Taxa Depr       N  8,4  - N3_TXDEPR1
		//Depr.Mês        N 16,2  - N3_VRDMES1 @E 999,999,999,999.99                        
		//Vlr.Original    N 16,2  - N3_VORIG1  @E 999,999,999,999.99  
		//Depr.Acumulada  N 16,2  - N3_VRDACM1 @E 999,999,999,999.99  

		//         10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220              
		//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234
		//Filial C.Base Bem Item Conta Contabil                                        Dt. Aquis. Descrição do Bem                         Taxa Depr.    Depreciacao Mes     Valor Original    Depre.Acumulada     Valor Residual
		//------ ---------- ---- ----------------------------------------------------- ---------- ---------------------------------------- ---------- ------------------ ------------------ ------------------ ------------------
		//99     1234567890 1234 12345678901234567890 - 123456789012345678901234567890 99/99/9999 1234567890123456789012345678901234567890     999.99 999,999,999,999.99 999,999,999,999.99 999,999,999,999.99 999,999,999,999.99   

		cDescCta:= Alltrim(ATFSQL->N3_CCONTAB)+" - "+Substr( Posicione("CT1",1,XFILIAL("CT1")+ATFSQL->N3_CCONTAB,"CT1_DESC01") ,1,30 )

		@nLin,00  PSAY ATFSQL->N1_FILIAL
		@nLin,07  PSAY ATFSQL->N1_CBASE
		@nLin,18  PSAY ATFSQL->N1_ITEM   
		@nLin,23  PSAY cDescCta

		@nLin,77  PSAY ATFSQL->N3_AQUISIC
		@nLin,88  PSAY Substr(ATFSQL->DESCRIC,1,40)
		@nLin,133 PSAY ATFSQL->N3_TXDEPR1 Picture "@E 999.99"
		@nLin,140 PSAY ATFSQL->N3_VRDMES1 Picture "@E 999,999,999,999.99"
		@nLin,159 PSAY ATFSQL->N3_VORIG1  Picture "@E 999,999,999,999.99"
		@nLin,178 PSAY ATFSQL->N3_VRDACM1 Picture "@E 999,999,999,999.99"             
		@nLin,197 PSAY ATFSQL->N3_VORIG1 - ATFSQL->N3_VRDACM1 Picture "@E 999,999,999,999.99"                          

		nLin := nLin + 1 // Avanca a linha de impressao

		nTotDMes+= ATFSQL->N3_VRDMES1 
		nTotVOrig+= ATFSQL->N3_VORIG1  
		nTotDAcum+= ATFSQL->N3_VRDACM1 

		ATFSQL->( dbSkip() ) // Avanca o ponteiro do registro no arquivo

		If ( cCContabil != ATFSQL->N3_CCONTAB ) 

			nLin := nLin + 2 // Avanca a linha de impressao   

			@nLin,00 PSAY "TOTAIS DA CONTA : "+cDescCta
			@nLin,140 PSAY nTotDMes  Picture "@E 999,999,999,999.99"
			@nLin,159 PSAY nTotVOrig Picture "@E 999,999,999,999.99"
			@nLin,178 PSAY nTotDAcum Picture "@E 999,999,999,999.99"             
			@nLin,197 PSAY nTotVOrig - nTotDAcum Picture "@E 999,999,999,999.99"                          

			nLin:= nLin + 1
			@nLin,00 PSAY Repl("-",220)        

			nGTotDMes+= nTotDMes
			nGTotVOrig+= nTotVOrig
			nGTotDAcum+= nTotDAcum	 

			nTotDMes:= 0
			nTotVOrig:= 0
			nTotDAcum:= 0

			If ATFSQL->( !Eof() )
				cCContabil:= ATFSQL->N3_CCONTAB
				nLin:= 80		  
			EndIf

		EndIf

	EndDo

	ATFSQL->( DbCloseArea() )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nGTotDMes != 0 .Or. nGTotVOrig != 0 .Or. nGTotDAcum != 0
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8      
			@nLin,00 PSAY "DATA DO ULTIMO CALCULO DA DEPRECIACAO : "+DTOC(dUltDepr)
			nLin := nLin + 2 // Avanca a linha de impressao	   
		Endif
		nLin := nLin + 2 // Avanca a linha de impressao   
		@nLin,00 PSAY "TOTAL GERAL : "
		@nLin,140 PSAY nGTotDMes  Picture "@E 999,999,999,999.99"
		@nLin,159 PSAY nGTotVOrig Picture "@E 999,999,999,999.99"
		@nLin,178 PSAY nGTotDAcum Picture "@E 999,999,999,999.99"             
		@nLin,197 PSAY nGTotVOrig - nGTotDAcum Picture "@E 999,999,999,999.99"                          
	EndIf


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

Return(Nil)