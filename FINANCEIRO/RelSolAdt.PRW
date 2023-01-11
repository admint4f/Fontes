#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#define _EOL chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELSOLADT º Autor ³Gilberto A Oliveira º Data ³  18/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio da Base de Ativo Fixo com os campos definidos    º±±
±±º          ³ pelo usuario T4f                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F / ATIVO FIXO                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELSOLADT()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio de Adiantamentos, Pagto Avulso, etc..."
Local cPict        := ""
Local titulo       := "Relat.Adiantamento, Pagto Avulso, Reembolso"
Local nLin         := 80
Local Cabec1       := "Data     Numero Codigo Fornecedor                                        Valor Historico                                St C.Custo    El.PEP          Solicitante               Prf Titulo    P Tipo"

Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "RELSOLADT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 15
Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELSOLADTO" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "ZZE"
Private cPerg   := "SOLADT"

dbSelectArea("ZZE")
dbSetOrder(1)

PutSx1(cPerg,"01",	"Cod.Produto ?","Cod.Produto ?","Cod.Produto  ?",	"mv_ch1",	"C",15,	0,	0,	"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02",	"Data de ?", "Data ?" ,	"Data de ?",	"mv_ch2",	"D",8,	0,	0,	"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03",	"Data Ate ?","Date ?","Data Ate ?",	"mv_ch3",	"D",8,	0,	0,	"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04",	"Criar Planilha ?","Create Spreadsheet?","Create Spreadsheet ?","mv_ch4",	"C",02,0,0,	"C","","","","","mv_par04","Sim"         ,"","","","Não"            ,"","","","","","","","","","","",{"Caso deseje gerar um arquivo a ser aberto",'no Excel, escolha "Sim"'},{},{})
PutSx1(cPerg,"05",	"Nome Arquivo ?","File Name ?","File Name ?","mv_ch5",	"C",20,0,0,	"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{"Digite o nome do arquivo que deseja","gerar. Escolha, de preferencia, um nome","simples e NÃO COLOQUE EXTENSÃO."},{},{})
PutSx1(cPerg,"06",	"Qual tipo ?","File Name ?","File Name ?","mv_ch6",	"C",20,0,0,	"G","","","","","mv_par06","","","","","","","","","","","","","","","","",{"Digite os tipos que deseja separando","por virgula.","1-Fornecedor","2-Colaborador","3-Artista","4-Troco","5-Avulso","6-Prestação Contas","7-Reembolso Avulso","8-Impostos","9-Repasse Terceiros"},{},{})
PutSx1(cPerg,"07","Qual Status?","What Status ?","Create Spreadsheet ?","mv_ch7",;
		 "C",02,0,1,"C","",;
		 "","","",;
		 "mv_par07","L=Liberado","espanhol","ingles","","P=Aguard.Aprovação","espanhol","ingles","E-Em Proc.Aprov.","espanhol","ingles","C-Cancelado","","","T-Todos","","",{"Qual Status Deseja imprimir?",''},{},{})

//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
//		 cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
//	 	 cF3, cGrpSxg,cPyme,;
//	 	 cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
//		 cDef02,cDefSpa2,cDefEng2,;
//		 cDef03,cDefSpa3,cDefEng3,;
//		 cDef04,cDefSpa4,cDefEng4,;
//		 cDef05,cDefSpa5,cDefEng5,;

Pergunte(cPerg,.f.)
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
Local nTotal:= 0
Local cDataIni:= Dtos(mv_par02)
Local cDataFim:= Dtos(mv_par03)
Local cQuery:= ''
Local aTipo:= {"1-Adto.Fornecedor","2-Adto.Colaborador","3-Adto.Artista","4-Adto.Troco","5-Impostos","6-Prestação Contas","7-Reembolso Avulso"}
Local cPathDestino
Local aStruct

cQuery+= "select "
cQuery+= "case "
cQuery+= " when zze.zze_tipo=1 then '1-Adto.Fornecedor' "
cQuery+= " when zze.zze_tipo=2 then '2-Adto.Colaborador' "
cQuery+= " when zze.zze_tipo=3 then '3-Adto.Artista' "
cQuery+= " when zze.zze_tipo=4 then '4-Troco'
cQuery+= " when zze.zze_tipo=5 then '5-Impostos' "
cQuery+= " when zze.zze_tipo=6 then '6-Prestacao Contas' "
cQuery+= " when zze.zze_tipo=7 then '7-Reembulso Avulso' "
cQuery+= " when zze.zze_tipo>7 then 'Outros'
cQuery+= "end Tipo_Adto, "               
cQuery+= "zze.* from "+retSqlName("zze")+ " zze "
If !Empty(mv_par01) .and. Alltrim(mv_par01) <> '*'
	cQuery+= "where zze_numero in "+_EOL
	cQuery+= "(select zzp_codigo from zzp080 where zzp_cod = '"+mv_par01+"' and D_E_L_E_T_ = '' ) and "+_EOL
Else
	cQuery+= "where "+_EOL
EndIf
cQuery+= "zze_data >= '"+cDataIni+"' and zze_data <= '"+cDataFim+"' and "+_EOL
If !Empty(mv_par06) .And. Alltrim(mv_par06) <> '*'
	cQuery+= "zze_tipo in ("+u_MontaInSql( u_TranSqlString( mv_par06) )+")  and " +_EOL
EndIf
cQuery+= "D_E_L_E_T_ = '' "+_EOL
Do Case
   Case mv_par07 == 1 ;  cQuery+= "and zze_status='L' "
   Case mv_par07 == 2 ;  cQuery+= "and zze_status='P' "
   Case mv_par07 == 3 ;  cQuery+= "and zze_status='E' "
   Case mv_par07 == 4 ;  cQuery+= "and zze_status='C' "   
EndCase

cQuery:= ChangeQuery(cQuery)
Memowrite("C:\RELSOLADT.SQL",cquery)

MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"SOLADT",.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Compatibiliza os campos com a TopField ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aAreaSX3:= SX3->( GetArea() )
SX3->( DbSetOrder(1) )
SX3->( DbSeek("ZZE") )
While (SX3->X3_ARQUIVO == "ZZE") .And. SX3->( !Eof() )
	If SX3->X3_TIPO $ "DN"
		TcSetField("SOLADT", Rtrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL)
	EndIF
	SX3->( DbSkip() )
End-While
RestArea(aAreaSX3)

DbSelectArea("SOLADT")
DbCommitAll()

SOLADT->( DbGotop() )

If MV_PAR04 == 1
	
	cPathDestino := cGetFile("\", "Diretorio Destino",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
	
	//Obriga a ser informado o diretorio de Destino
	If Empty(cPathDestino)
		MsgAlert("Atenção, é obrigatório a seleção do diretório de destino da planilha a ser gerada.")
	Else
		
		//_cArquivo:= "C:\"+Iif( !empty( mv_par08), lower(alltrim(mv_par08)),"solic_adto" )
		_cArquivo:= cPathDestino+Iif( !empty( mv_par05), lower(alltrim(mv_par05)),"solic_adto" )
		_cPNome:= "SolicAdto"
		_cAlias:= "SOLADT"
		
		If File( _cArquivo+".xml" )
			Ferase( _cArquivo+".xml")
		EndIf
		
      aStruct:= {{"Tipo_adto", {|| SOLADT->TIPO_ADTO},0},;
                 {"Data",{||SOLADT->ZZE_DATA},0},;
                 {"Cod.For.",{||SOLADT->ZZE_FORNEC},0},;                  
                 {"Nome For.",{||SOLADT->ZZE_NOMFOR},0},;
                 {"Valor",{||SOLADT->ZZE_VALOR},0},;
                 {"Historico",{||SOLADT->ZZE_HISTOR},0},;
                 {"Status",{|| SOLADT->ZZE_STATUS},0},;
                 {"C.Centro",{|| SOLADT->ZZE_CCUSTO},0},;
                 {"E.Pep",{|| SOLADT->ZZE_PEP},0},;
                 {"Solicitante",{|| Usrfullname(SOLADT->ZZE_USERID) },0},;
                 {"Prefixo",{||SOLADT->ZZE_PREF},0},;
                 {"Titulo",{||SOLADT->ZZE_TITULO},0},;
                 {"Parcela",{||SOLADT->ZZE_PARC},0}} 
      
		MsAguarde( { || u_DB2XML(_cArquivo, _cPNome, _cAlias,aStruct,,,"2007","IIF( !EMPTY(SOLADT->ZZE_DATA), DTOC(SOLADT->ZZE_DATA), ' ' )" )},"Aguarde .. Gerando arquivo XML...")
		
		ApMsgInfo("Arquivo :"+_cArquivo+".xml gerado. Verifique o disco local de sua máquina"+chr(13)+"Aperte OK para continuar gerando o relatório...","Informação","INFO")
		
	EndIf
	
EndIF

SOLADT->( DbGotop() )

If Iif( MV_PAR04 == 1, ApMsgYesNo( "Deseja gerar tambem o relatorio ?" ), .t. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SetRegua(RecCount())
	
	While SOLADT->( !EOF() )
		
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
		Endif
		
		
		//          10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200      210
		// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		// Data     Numero Codigo Fornecedor                                        Valor Historico                                St C.Custo    El.PEP          Solicitante               Prf Titulo    P Tipo
		// 99/99/99 123456 123456 1234567890123456789012345678901234567890 123.456.789,01 1234567890123456789012345678901234567890 L  1234567890 123456789012345 1234567890123456789012345 123 123456789 1 12345678901234567890
		
		@nLin,00  PSAY SOLADT->ZZE_DATA
		@nLin,09  PSAY SOLADT->ZZE_NUMERO
		@nLin,16  PSAY SOLADT->ZZE_FORNEC+" "+SUBS(SOLADT->ZZE_NOMFOR,1,40)
		@nLin,64  PSAY SOLADT->ZZE_VALOR Picture "@e 999,999,999.99"
		@nLin,79  PSAY Subs(SOLADT->ZZE_HISTOR,1,40)
		@nLin,120 PSAY SOLADT->ZZE_STATUS
		@nLin,123 PSAY Subs(SOLADT->ZZE_CCUSTO,1,10)
		@nLin,134 PSAY SOLADT->ZZE_PEP
		@nLin,150 PSAY Subs( Usrfullname(SOLADT->ZZE_USERID),1,25)
		@nLin,176 PSAY SOLADT->ZZE_PREF
		@nLin,180 PSAY SOLADT->ZZE_TITULO
		@nLin,190 PSAY SOLADT->ZZE_PARC
		
		@nLin,192 PSAY Iif( SOLADT->ZZE_TIPO>=1 .and. SOLADT->ZZE_TIPO<=7, aTipo[SOLADT->ZZE_TIPO], SOLADT->ZZE_TIPO )
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		nTotal+= SOLADT->ZZE_VALOR
		
		SOLADT->( dbSkip() ) // Avanca o ponteiro do registro no arquivo
		
		
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nTotal != 0
		nLin ++
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		@nLin,00 PSAY "TOTAL....: "
		@nLin,64 PSAY nTotal Picture "@e 99,999,999,999.99"
		
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
	
EndIf

SOLADT->( DbCloseArea() )

Return(Nil)
