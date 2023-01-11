#include "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
#include "tbiconn.ch"


#DEFINE ENTER Chr(13)+Chr(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCTBM020 ºAutor  ³Bruno Daniel Borges º Data ³  26/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de geracao de planilhas Excel com visoes gerenciais  º±±
±±º          ³separando em colunas as empresas do consolidado             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ Bandeira - 16/1/09 - Copiado do RCTBM010 / Modificado para º±±
±±º          ³ considerar filiais /                                       º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RCTBM020()

	Local cPathDestino	:= ""
	Local oRegua		:= Nil
	Local nDivide		:= 1
	Private _aFils	:= {}
	Private aSM0 := {}

	Process()
	/*/
	@ 050,1 TO 500,800 DIALOG oDlg3 TITLE "Parametros do Relatorio"
	ACTIVATE DIALOG oDlg3 CENTERED ON INIT EnchoiceBar(oDlg3,{|| Process()}, {|| Close(oDlg3)} , ,  )
	/*/

	//Utiliza o mesmo grupo de perguntas do padrao (CTR190)
	//If !Pergunte("CTBM10",.T.)
	If !Pergunte("CTR040",.T.)
		Return(Nil)
	EndIf

	cPathDestino := cGetFile("\", "Diretorio Destino",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)

	oRegua := MsNewProcess():New({|lEnd| RCTBM020_Prc(@oRegua,cPathDestino) },"Montando Relatório...","",.T.)
	oRegua:Activate()

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBM020_PrcºAutor  ³Bruno Daniel Borges º Data ³  26/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de processamento do relatorio                          º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RCTBM020_Prc(oRegua,cPathDestino)
	Local oMeter		:= Nil
	Local oText			:= Nil
	Local oDlg			:= Nil
	Local oExcel		:= Nil
	Local lEnd			:= .F.
	Local aEstrut		:= {}
	Local aSetOfBook	:= {}
	Local i				:= 0
	//Local nRecnoSM0		:= SM0->(RecNo())
	Local nDivide		:= 1
	Local cFileTRB		:= ""
	Local cArqTmp		:= ""
	Local lImpAntLP		:= (mv_par22 == 1)
	Local dDataLP		:= mv_par23
	Local lVlrZerado	:= (mv_par07==1)
	Local lImpSint		:= Iif(mv_par05=1 .Or. mv_par05 ==3,.T.,.F.)
	Local lRecDesp0		:= (mv_par25 == 1)
	Local cRecDesp		:= mv_par26
	Local dDtZeraRD		:= mv_par27
	Local cMoedaDsc		:= mv_par29
	Local oTMPTable		:= Nil

	//Obriga a ser informada a visao gerencial desejada
	If Empty(mv_par06)
		MsgAlert("Atenção, para uso dessa rotina é obrigatório informar o parâmetro COD. CONF. LIVROS com uma visão gerencial válida.")
		Return(Nil)
	EndIf

	//Obriga a ser informada as empresas a serem listadas

	/*/
	If Empty(mv_par30) .Or. mv_par31 == "ZZ" .Or. Empty(mv_par31)
	MsgAlert("Atenção, é obrigatório que seja informados os números iniciais e finais de empresa a serem listadas. Não pode ser informada de '  ' até 'ZZ'.")
	Return(Nil)
	EndIf
	/*/


	//Obriga a ser informado o diretorio de Destino
	If Empty(cPathDestino)
		MsgAlert("Atenção, é obrigatório a seleção do diretório de destino da planilha a ser gerada.")
		Return(Nil)
	EndIf

	aSetOfBook := CTBSetOf(mv_par06)

	//oRegua:SetRegua1(Val(mv_par31) - Val(mv_par30)+1)

	//Estrutura do arquivo com o resumo por empresa
	Aadd(aEstrut,{"ENTIDADE","C",020,00,"ENTIDADE CONTABIL"})
	Aadd(aEstrut,{"DESC_ENT","C",100,00,"DESCRICAO"})
	//For i := Val(mv_par30) To Val(mv_par31)

	_nContEmp	:= 0
	For j := 1 to Len(aSM0)
		If (aSM0[j,1])	// esta selecionado
			++_nContEmp
			i := Val( aSM0[j,2])
			AADD(_aFils, i)
			/*/		
			Aadd(aEstrut,{"SALANT_"+StrZero(i,2)	,"N",14,02})
			Aadd(aEstrut,{"DEB_"+StrZero(i,2)		,"N",14,02})
			Aadd(aEstrut,{"CRD_"+StrZero(i,2)		,"N",14,02})
			/*/		
			Aadd(aEstrut,{"SALATU_"+StrZero(i,2)	,"N",14,02,aSM0[j,3]})
		Endif
	Next i

	//Somente para termos a quantidade exata de empresas selecionadas
	oRegua:SetRegua1(_nContEmp)

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	cFileTRB := CriaTrab(aEstrut,.T.)
	IIf(Select("TMP_M10") > 0, TMP_M10->(dbCloseArea()),Nil)
	dbUseArea(.T.,__LocalDriver,cFileTRB,"TMP_M10",.T.)
	IndRegua("TMP_M10",CriaTrab(Nil,.F.),"ENTIDADE",,,"Indexando Arquivo Temporario...")
	*/
	
	IIf(Select("TMP_M10") > 0, TMP_M10->(dbCloseArea()),Nil)
	
	oTMPTable:= FWTemporaryTable():New("TMP_M10")
	oTMPTable:SetFields( aEstrut )
	oTMPTable:AddIndex("1", {"ENTIDADE"} )
	oTMPTable:Create()	
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	//Chama a funcao de geracao do Balancete para cada empresa
	//For i := Val(mv_par30) To Val(mv_par31)
	For j := 1 to Len(_aFils)
		i := _aFils[j]
		If !SM0->(dbSeek(StrZero(i,2)))
			Loop
		EndIf
		//SM0->(dbGoTo(nRecnoSM0))

		//dbclosearea("CT1")
		//DBUSEAREA( .F., "TOPCONN", "CT1"+StrZero(i,2)+"0", "CT1")
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA SM0->M0_CODIGO FILIAL SM0->M0_CODFIL MODULO "CTB"		//TABLES 'SI2','SZC','SE2'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Arquivo Temporario para Impressao							  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
		CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
		mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
		mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
		.f.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado) },;
		OemToAnsi("Criando Arquivo Tempor rio... Empresa: " + StrZero(i,2)),;
		OemToAnsi("Visão Gerencial Por Empresa..."))

		/*/

		MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
		CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
		mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
		mv_par10,aSetOfBook,mv_par12,mv_par13,mv_par14,mv_par15,;
		.f.,.F.,mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,;	//32
		,;				//33
		,;				//34
		,;				//35
		,;				//36
		,;				//37
		,;				//38
		,;				//39
		,;				//40
		,;				//41
		,;				//42
		,;				//43
		{"","","","","","",Padr(StrZero(i,2),20),Padr(StrZero(i,2),20)} , ;
		,;				//44
		,;				//45
		lImpSint,;		//46
		"",;			//47
		lRecDesp0,;		//48
		cRecDesp,;		//49
		dDtZeraRD,;		//50
		,;				//51
		,;				//52
		,;				//53
		,;				//54
		,;				//55
		.T.,;			//56
		cMoedaDsc)},;	//57
		OemToAnsi("Criando Arquivo Tempor rio... Empresa: " + StrZero(i,2)),;
		OemToAnsi("Visão Gerencial Por Empresa..."))
		/*/


		//Grava na tabela temporaria o resultado dos valores da empresa atual
		oRegua:IncRegua1("Empresa: " + StrZero(i,2))

		dbSelectArea("cArqTmp")
		oRegua:SetRegua2(RecCount())
		//inicio do arquivo, para gravar a coluna referente a empresa (variavel i)
		dbGoTop()
		While !Eof()
			dbSelectArea("TMP_M10")
			//If StrZero(i,2) == mv_par30 .Or. !TMP_M10->(dbSeek( cArqTmp->CONTA ))
			If ! TMP_M10->(dbSeek( ALLTRIM( cArqTmp->CONTA ) ))
				TMP_M10->(RecLock("TMP_M10",.T.))
				TMP_M10->ENTIDADE				:= cArqTmp->CONTA
				TMP_M10->DESC_ENT				:= cArqTmp->DESCCTA
			Else
				TMP_M10->(RecLock("TMP_M10",.F.))
			EndIf

			//Gravacao dos Campos
			/*/
			TMP_M10->&("SALANT_"+StrZero(i,2))	:= cArqTmp->SALDOANT
			TMP_M10->&("DEB_"+StrZero(i,2))	:= cArqTmp->SALDODEB
			TMP_M10->&("CRD_"+StrZero(i,2))	:= cArqTmp->SALDOCRD
			/*/
			TMP_M10->&("SALATU_"+StrZero(i,2))	:= cArqTmp->SALDOATU
			TMP_M10->(MsUnlock())

			dbSelectArea("cArqTmp")
			dbSkip()

			oRegua:IncRegua2("Processando...")
		EndDo
		Iif(Select("cArqTmp") > 0,cArqTmp->(dbCloseArea()),Nil)

		RpcClearEnv()

		//oRegua:IncRegua1("Empresa: " + StrZero(i,2))
	Next i

	//Fecha o arquivo e copia para a estacao do usuario

	oRegua:IncRegua2("Gerando Planilha...")

	//aHeader := CriaHeader("TMP_M10")
	//geraCSV("TMP_M10",,aEstrut)

	RCTBM020_CSV(TMP_M10->(Lastrec()),cPathDestino,cFileTRB,aEstrut,"TMP_M10")

	/*/
	TMP_M10->(dbGoTop())
	TMP_M10->(__dbCopy((cFileTRB),{},,,,,.F., "DBFCDXADS" ))
	CpyS2T(Upper(cFileTRB)+".DBF",cPathDestino,.F.)
	/*/

	TMP_M10->(dbClosearea())

	//Cria o link com o Excel

	/*/

	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open( cPathDestino+Upper(cFileTRB)+".DBF" )
	oExcel:SetVisible(.T.)

	/*/

Return(Nil)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º  Funcao  ³ Process  º Autor ³ Fabiano Migoto     º Data ³  19/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡„o ³ Seleciona as Nfs que serão expedidas junto a Original      ³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno  ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Process()
	Local nOpcao := 0
	Local aButton := {}
	Local aSay := {}
	Local cSQL
	Local cAliasSZ2 := "SZ2_TOP"
	Local oOk := LoadBitmap(GetResources(),"LBOK")
	Local oNo := LoadBitmap(GetResources(),"LBNO")
	Local nLin1 := 10
	Local nCol1 := 20
	Local nLin2 := 20
	Local nCol2 := 60
	Local oBmp
	Local oLbx
	Local aSE1_Aux := {}
	//Private aSM0 := {}
	Private cCadastro := "Selecao das Filiais"
	Private oWnd

	dbSelectArea("SM0")
	dbSetOrder(1)
	dbGoTop()

	cont := 0
	While !Eof()
		//	Inclui Apenas a empresa
		aAdd(aSM0,{.F.,SM0->M0_CODIGO,SM0->M0_NOMECOM})
		cont++
		cCodAnt := SM0->M0_CODIGO
		While ! SM0->(Eof()) .AND. cCodAnt == SM0->M0_CODIGO
			SM0->(dbSkip())
		ENDDO
	End

	DEFINE MSDIALOG oWnd TITLE cCadastro FROM nLin1,nCol1 TO nLin2,nCol2 Of oMainWnd //PIXEL STYLE DS_MODALFRAME STATUS

	@ 14,2 LISTBOX oLbx VAR cVar FIELDS HEADER ;
	" ",;
	"Empresa",;
	"Nome";
	SIZE (150),(60);
	OF oWnd PIXEL ON dblClick(aSM0[oLbx:nAt,1] := !aSM0[oLbx:nAt,1],oLbx:Refresh())

	oLbx:SetArray(aSM0)
	oLbx:bLine := {|| {Iif(aSM0[oLbx:nAt,1],oOk,oNo),;
	aSM0[oLbx:nAt,2],;
	aSM0[oLbx:nAt,3]}}

	ACTIVATE MSDIALOG oWnd CENTERED ON INIT GEDBar01(oWnd,{||oWnd:End()})

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º  Funcao  ³ GEDBar01 º Autor ³ Fabiano Migoto     º Data ³  19/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡„o ³Esta função cria um enchoicebar específica para este program³±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º oObj     | Objeto com as propriedades do Enchoice                     º±±
±±º bObj     | Coordenadas do Enchoice                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno  ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GEDBar01(oObj,bObj)
	Local lOk,oBar,oBtnImp,oBtnFim
	//DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oObj
	DEFINE BUTTON oBtnImp RESOURCE "OK" 	  OF oBar ACTION GEDSM0()        TOOLTIP "Gravar" //S4WB010N
	DEFINE BUTTON oBtnFin RESOURCE "FINAL"    OF oBar ACTION (lOk:=Eval(bObj)) TOOLTIP "Sair"
	oBar:bRClicked:={||AllwaysTrue()}
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º  Funcao  ³ GEDSZ2   º Autor ³ Fabiano Migoto     º Data ³  19/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡„o ³Esta função irá gravar o SZ2 para as Nfs escolhidas         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno  ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GEDSM0()
	Local i := 0

	Close(oWnd)

Return

/*/

±±³Program   ³CtGerPlan ³ Autor ³ Simone Mie Sato       ³ Data ³ 25.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri+.o ³Gerar Arquivo Temporario para Balancetes.                   |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                                      ³±±
±±³          ³ ExpO2 = Objeto oText                                       ³±±
±±³          ³ ExpO3 = Objeto oDlg                                        ³±±
±±³          ³ ExpL1 = lEnd                                               ³±±
±±³          ³ ExpD1 = Data Inicial                                       ³±±
±±³          ³ ExpD2 = Data Final                                         ³±±
±±³          ³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpC2 = Conta Inicial                                      ³±±
±±³          ³ ExpC3 = Conta Final                                        ³±±
±±³          ³ ExpC4 = Centro de Custo Inicial                            ³±±
±±³          ³ ExpC5 = Centro de Custo Final                             ³±±
±±³          ³ ExpC6 = Centro de Custo Inicial                            ³±±
±±³          ³ ExpC7 = Centro de Custo Final                             ³±±
±±³          ³ ExpC8 = Item Inicial                                       ³±±
±±³          ³ ExpC9 = Item Final                                         ³±±
±±³          ³ ExpC10= Classe de Valor Inicial                            ³±±
±±³          ³ ExpC11= Classe de Valor Final                             ³±±
±±³          ³ ExpC12= Moeda                                                ³±±
±±³          ³ ExpC13= Saldo                                               ³±±
±±³          ³ ExpA1 = Set Of Book                                           ³±±
±±³          ³ ExpC13= Ate qual segmento sera impresso (nivel)                ³±±
±±³          ³ ExpC8 = Filtra por Segmento                                    ³±±
±±³          ³ ExpC9 = Segmento Inicial                                       ³±±
±±³          ³ ExpC10= Segmento Final                                        ³±±
±±³          ³ ExpC11= Segmento Contido em                                ³±±
±±³          ³ ExpL2 = Se Imprime Entidade sem movimento                  ³±±
±±³          ³ ExpL3 = Se Imprime Conta                                   ³±±
±±³          ³ ExpN1 = Grupo                                              ³±±
±±³          ³ cSegmentoG = Filtra por Segmento     (CC/Item ou ClVl)        ³±±
±±³          ³ cSegIniG = Segmento Inicial                                    ³±±
±±³          ³ cSegFimG = Segmento Final                                     ³±±
±±³          ³ cFiltSegmG = Segmento Contido em                            ³±±
±±³          ³ aGeren = Matriz que armazena os compositores do Pl. Ger.   ³±±
±±³          ³                para efetuar o filtro de relatorio.               ³±±

/*/




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
Static Function RCTBM020_CSV(nTotReg,cPathDestino,cFileTRB,aEstrut,cTRB)
	Local nHdl		:= 0
	Local i			:= 0
	Local cFile		:= ""
	Local cLinhaCSV	:= ""
	Local aCabec	:= {} 
	Local oExcel	:= Nil  
	Local aAreaSM0	:= SM0->(GetArea())

	//Cria o arquivo CSV

	//cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
	//cFile 	+= "\"+Upper(CriaTrab(Nil,.F.))+".CSV"
	cFile	:= cPathDestino+"\"+UPPER(cFileTRB)+".CSV"

	nHdl	:= FCreate(cFile)

	If nHdl <= 0
		MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
		Return(Nil)
	EndIf

	//Monta o cabecalho
	//Aadd(aEstrut,{"ENTIDADE","C",020,00,"ENTIDADE CONTABIL"})

	For _nCtt := 1 to Len( aEstrut)
		AAdd(aCabec,{ aEstrut[_nCtt,5],aEstrut[_nCtt,2],aEstrut[_nCtt,1]})
	Next

	For i := 1 To Len(aCabec)
		cLinhaCSV += aCabec[i,1] + ";"
	Next i                            
	FWrite(nHdl,cLinhaCSV+ENTER)

	ProcRegua(nTotReg)

	//Geracao do arquivo CSV
	(cTRB)->(!DBGOTOP())
	While (cTRB)->(!Eof())  
		IncProc()
		cLinhaCSV := ""

		For i := 1 To Len(aCabec)
			If aCabec[i,2] == "C"
				cLinhaCSV += (cTRB)->&(aCabec[i,3])+";"
			ElseIf aCabec[i,2] == "D"
				cLinhaCSV += DToC(SToD( (cTRB)->&(aCabec[i,3])))+";"
			ElseIf aCabec[i,2] == "N"
				cLinhaCSV += Transform( (cTRB)->&(aCabec[i,3]),"@E 99,999,999,999.99")+";"
			EndIf
		Next i

		FWrite(nHdl,cLinhaCSV+ENTER)
		(cTRB)->(dbSkip())
	EndDo   

	FClose(nHdl)
	oExcel := MSExcel():New()
	oExcel:WorkBooks:Open(cFile)
	oExcel:SetVisible(.T.)   

	RestArea(aAreaSM0)

Return


/*/
01-oMeter      = Objeto, Controle da régua 
02-oText       = Objeto, Controle da régua  
03-oDlg        = Objeto, Janela
04-lEnd        = Lógico, Controle da régua -> finalizar  
05-cArqTmp     = Caracter, Arquivo temporário          
06-dDataIni    = Data, Data Inicial de Processamento       
07-dDataFim    = Data, Data Final de Processamento 
08-cAlias      = Caracter, Alias do Arquivo   
09-cIdent      = Caracter, Identificador do arquivo a ser processado       
10-cContaIni   = Caracter, Conta Inicial                   
11-cContaFim = Caracter, Conta Final         
12-cCCIni      = Caracter, Centro de Custo Inicial 
13-cCCFim      = Caracter, Centro de Custo Final 
14-cItemIni    = Carater, Item Inicial                    
15-cItemFim    = Caracter, Item Final                    
16-cClvlIni    = Caracter, Classe de Valor Inicial  
17-cClvlFim    = Caracter, Classe de Valor Final  
18-cMoeda      = Caracter, Moeda                        
19-cSaldos     = Caracter, Tipos de Saldo a serem processados  
20-aSetOfBook  = Array, Matriz de configuração de livros   
21-cSegmento   = Caracter, Indica qual o segmento será filtrado 
22-cSegIni     = Caracter, Conteúdo Inicial do segmento              
23-cSegFim     = Caracter, Conteúdo Final do segmento              
24-cFiltSegm   = Caracter, Filtra por Segmento                
25-lNImpMov    = Lógico, Se Imprime Entidade sem movimento
26-lImpConta   = Lógico, Se Imprime Conta                                 
27-nGrupo      = Numerico, Grupo                                             
28-cHeader     = Caracter, Identifica qual a Entidade Principal 
29-lImpAntLP   = Lógico, Se imprime lançamentos Lucros e Perdas 
30-dDataLP     = Data, Data da ultima Apuração de Lucros e Perdas 
31-nDivide     = Numerico, Divide valores por (100,1000,1000000)           
32-lVlrZerado  = Lógico, Grava ou não valores zerados no arq temporário
33-cFiltroEnt  = Caracter, Entidade Gerencial que servira de filtro dentro  de outra Entidade Gerencial. Ex.: Centro de Custo  sendo filtrado por Item Contábil (CTH)            
34-cCodFilEnt  = Caracter, Código da Entidade Gerencial utilizada como filtro
35-cSegmentoG  = Caracter, Filtra por Segmento Gerencial (CC/Item ou ClVl)
36-cSegIniG    = Caracter, CSegmento Gerencial Inicial                         
37-cSegFimG    = Caracter, Segmento Gerencial Final                         
38-cFiltSegmG  = Caracter, Segmento Gerencial Contido em              
39-lUsGaap     = Lógico, Se e Balancete de Conversão de moeda     
40-cMoedConv   = Caracter, Moeda para a qual buscara o critério de conversão  no Pl.Contas                                       
41-cConsCrit   = Caracter, Critério de conversão utilizado: 1-Diário, 2-Médio, 3-Mensal, 4-Informada, 5-Plano de Contas           
42-dDataConv   = Data, Data de Conversão                                  
43-nTaxaConv   = Numerico, Taxa de Conversão                                 
44-aGeren      = Array, Matriz que armazena os compositores do Pl. Ger. para efetuar o filtro de relatorio.                
45-lImpMov     = Lógico, Não utilizado                                      
46-lImpSint    = Lógico, Se atualiza sintéticas                             
47-cFilUSU     = Caracter, Filtro informado pelo usuário              
48-lRecDesp0   = Lógico, Se imprime saldo anterior do período anterior  zerado                                             
49-cRecDesp    = Caracter, Grupo de receitas e despesas                       
50-dDtZeraRD   = Data, Data de zeramento de receitas e despesas 
51-lImp3Ent    = Lógico, Se e Balancete C.Custo / Conta / Item         
52-lImp4Ent    = Lógico, Se e Balancete por CC x Cta x Item x Cl.Valor
53-lImpEntGer  = Lógico, Se e Balancete de Entidade (C.Custo/Item/Cl.Vlr  por Entid. Gerencial)                              
54-lFiltraCC   = Lógico, Se considera o filtro das perguntas para C.Custo   
55-lFiltraIt   = Lógico, Se considera o filtro das perguntas para Item     
56-lFiltraCV   = Lógico, Se considera o filtro das perguntas para Cl.Valor  
/*/