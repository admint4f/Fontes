#Include "Protheus.ch"

#Define STR_PULA	Chr(13)+Chr(10)

Static cDirTmp := GetTempPath()

/*/{Protheus.doc} Rotina para importaÁ„o de clientes.
Fun√ß√£o Gen√©rica para Carga de Dados no Protheus (ImportaÁ„o de Dados)
@type function
@author Lucas Valins
@since 16/11/2020
@version 1.0
/*/
User Function Importcad()

	Local aArea := GetArea()
	//Dimens√µes da janela
	Local nJanAltu := 180
	Local nJanLarg := 650
	//Objetos da tela
	Local oGrpPar
	Local oGrpAco
	Local oBtnSair
	Local oBtnImp
	Local oBtnObri
	Local oBtnArq
	//Local cAviso := ""
	Private aIteTip := {}
	Private oSayArq, oGetArq, cGetArq := Space(99)
	Private oSayTip, oCmbTip, cCmbTip := ""
	Private oSayCar, oGetCar, cGetCar := ';'
	Private oDlgPvt

	//Inserindo as op√ß√µes dispon√≠veis no Carga Dados Gen√©rico
	aIteTip := {"01=Clientes",;
				"02=Fornecedores",}

	cCmbTip := aIteTip[1]

	//Criando a janela
	DEFINE MSDIALOG oDlgPvt TITLE "Carga Dados - Clientes" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
	//Grupo Par√¢metros
	@ 003, 003 	GROUP oGrpPar TO 060, (nJanLarg/2) 	PROMPT "Par‚metros: " 		OF oDlgPvt COLOR 0, 16777215 PIXEL
	//Caminho do arquivo
	@ 013, 006 SAY        oSayArq PROMPT "Arquivo:"                  SIZE 060, 007 OF oDlgPvt PIXEL
	@ 010, 070 MSGET      oGetArq VAR    cGetArq                     SIZE 240, 010 OF oDlgPvt PIXEL
	oGetArq:bHelp := {||	ShowHelpCpo(	"cGetArq",;
		{"Arquivo CSV ou TXT que ser√° importado."+STR_PULA+"Exemplo: C:\teste.CSV"},2,;
		{},2)}
	@ 010, 311 BUTTON oBtnArq PROMPT "..."      SIZE 008, 011 OF oDlgPvt ACTION (fPegaArq()) PIXEL

	//Tipo de ImportaÁ„o
	@ 028, 006 SAY        oSayTip PROMPT "Tipo ImportaÁ„o:"          SIZE 060, 007 OF oDlgPvt PIXEL
	@ 025, 070 MSCOMBOBOX oCmbTip VAR    cCmbTip ITEMS aIteTip       SIZE 100, 010 OF oDlgPvt PIXEL
	oCmbTip:bHelp := {||	ShowHelpCpo(	"cCmpTip",;
		{"Tipo de ImportaÁ„o que ser· processada."+STR_PULA+"Exemplo: 1 = Bancos"},2,;
		{},2)}

	//Caracter de Separa√ß√£o do CSV
	@ 043, 006 SAY        oSayCar PROMPT "Carac.Sep.:"               SIZE 060, 007 OF oDlgPvt PIXEL
	@ 040, 070 MSGET      oGetCar VAR    cGetCar                     SIZE 030, 010 OF oDlgPvt PIXEL VALID fVldCarac()
	oGetArq:bHelp := {||	ShowHelpCpo(	"cGetCar",;
		{"Caracter de separaÁ„o no arquivo."+STR_PULA+"Exemplo: ';'"},2,;
		{},2)}

	//Grupo Ajustes
	@ 063, 003 	GROUP oGrpAco TO (nJanAltu/2)-3, (nJanLarg/2) 	PROMPT "Ajustes: " 		OF oDlgPvt COLOR 0, 16777215 PIXEL

	//Bot√µes
	@ 070, (nJanLarg/2)-(63*1)  BUTTON oBtnSair PROMPT "Sair"          SIZE 60, 014 OF oDlgPvt ACTION (oDlgPvt:End()) PIXEL
	@ 070, (nJanLarg/2)-(63*2)  BUTTON oBtnImp  PROMPT "Importar"      SIZE 60, 014 OF oDlgPvt ACTION (Processa({|| fConfirm(1) }, "Aguarde...")) PIXEL
	@ 070, (nJanLarg/2)-(63*3)  BUTTON oBtnObri PROMPT "Camp.Obrig."   SIZE 60, 014 OF oDlgPvt ACTION (Processa({|| fConfirm(2) }, "Aguarde...")) PIXEL
	ACTIVATE MSDIALOG oDlgPvt CENTERED

	RestArea(aArea)
Return

/*---------------------------------------------------------------------------------*/

Static Function fVldCarac()
	Local lRet := .T.
	Local cInvalid := "'./\"+'"'

	//Se o caracter estiver contido nos que n„o podem, retorna erro
	If cGetCar $ cInvalid
		lRet := .F.
		MsgAlert("Caracter invalido, ele nao estar contido em <b>"+cInvalid+"</b>!", "AtenÁ„o")
	EndIf
Return lRet

 /*---------------------------------------------------------------------------------*/

Static Function fPegaArq()
	Local cArqAux := ""
	cArqAux := cGetFile( "Arquivo Texto | *.*",;				//M√°scara
	"Arquivo...",;						//T√≠tulo
	,;										//N√∫mero da m√°scara
	,;										//Diret√≥rio Inicial
	.F.,;									//.F. == Abrir; .T. == Salvar
	GETF_LOCALHARD,;						//Diret√≥rio full. Ex.: 'C:\TOTVS\arquivo.xlsx'
	.F.,)									//n„o exibe diret√≥rio do servidor

	//Caso o arquivo n„o exista ou estiver em branco ou n„o for a extens√£o txt
	If Empty(cArqAux) .Or. !File(cArqAux) .Or. (SubStr(cArqAux, RAt('.', cArqAux)+1, 3) != "txt" .And. SubStr(cArqAux, RAt('.', cArqAux)+1, 3) != "csv")
		MsgStop("Arquivo <b>inv·lido</b>!", "AtenÁ„o")

		//Sen„o, define o get
	Else
		cGetArq := PadR(cArqAux, 99)
		oGetArq:Refresh()
	EndIf
Return

/*---------------------------------------------------------------------------------*/
Static Function fConfirm(nTipo)
	Local nModBkp			:= nModulo
	Local aAux				:= {}
	Local nAux				:= 0
	Local cAux				:= ""
	Local cFunBkp			:= FunName()
	Default nTipo			:= 2
	Private cRotina		:= ""
	Private cTabela		:= ""
	Private cCampoChv		:= ""
	Private cFilialTab	:= ""
	Private nTotalReg		:= 0
	Private cAliasTmp		:= "TMP_"+RetCodUsr()
	Private oBrowChk
	Private cFiles
	Private cMark			:= "OK"
	Private aCampos		:= {}
	Private aStruTmp		:= {}
	Private aHeadImp		:= {}
	Private cCampTipo		:= ""
	Private lChvProt		:= .F.
	Private lFilProt		:= .F.
	Private cLinhaCab		:= ""

	//Clientes
	If cCmbTip == "01"
		cRotina	:= "MSExecAuto({|x, y| MATA030(x, y)}, aDados, 3) "
		cTabela	:= "SA1"
		cCampoChv	:= "A1_COD"
		cFilialTab	:= FWxFilial(cTabela)
		nModulo	:= 5
		SetFunName("MATA030")

		//Fornecedores
	ElseIf cCmbTip == "02"
		cRotina	:= "MSExecAuto({|x, y| MATA020(x, y)}, aDados, 3) "
		cTabela	:= "SA2"
		cCampoChv	:= "A2_COD"
		cFilialTab	:= FWxFilial(cTabela)
		nModulo	:= 2
		SetFunName("MATA020")

		//OpÁ„o Inv·lida
	Else
		nModulo	:= nModBkp
		MsgStop("OpÁ„o <b>Inv·lida</b>!", "AtenÁ„o")
		Return
	EndIf

	//ImportaÁ„o dos dados
	If nTipo == 1
		//Se o arquivo existir
		If File(cGetArq)
			//Abrindo o arquivo
			Ft_FUse(cGetArq)
			nTotalReg := Ft_FLastRec()

			//Se o total de registros for menor que 2, arquivo inv·lido
			If nTotalReg < 2
				MsgAlert("Arquivo inv·lido, possui menos que <b>2</b> linhas!", "AtenÁ„o")

				//Sen„o, chama a tela de observa√ß√£o e depois a ImportaÁ„o
			Else
				//Monta tabela tempor√°ria
				fMontaTmp()

				//Pegando o cabe√ßalho
				cLinhaCab := Ft_FReadLn()
				cLinhaCab := Iif(SubStr(cLinhaCab, Len(cLinhaCab)-1, 1) == ";", SubStr(cLinhaCab, 1, Len(cLinhaCab)-1), cLinhaCab)
				aAux := Separa(cLinhaCab, cGetCar)
				Ft_FSkip()

				//Percorrendo o aAux e adicionando no array
				For nAux := 1 To Len(aAux)
					cAux := GetSX3Cache(aAux[nAux], 'X3_TIPO')

					//Se o t√≠tulo estiver em branco, quer dizer que o campo n„o existe, ent√£o √© um campo reservado do execauto (como o LINPOS)
					If Empty(GetSX3Cache(aAux[nAux], 'X3_TITULO'))
						cCampTipo += aAux[nAux]+";"
					EndIf

					//Adiciona na grid
					aAdd(aHeadImp, {	aAux[nAux],;								//Campo
					Iif(Empty(cAux), ' ', cAux),;			//Tipo
					.F.})										//Exclu√≠do
				Next

				//Chama a tela de observa√ß√£o para preenchimento das informAjustes auxiliares
				If fTelaObs(!Empty(cCampoChv))

					//Chama a rotina de ImportaÁ„o
					fImport()

					//Se houve erros na rotina
					(cAliasTmp)->(DbGoTop())
					If ! (cAliasTmp)->(EoF())
						fTelaErro()

						//Sen„o, mostra mensagem de sucesso
					Else
						MsgInfo("ImportaÁ„o finalizada com Sucesso!", "AtenÁ„o")
					EndIf
				EndIf

				//Fechando a tabela e excluindo o arquivo tempor√°rio
				(cAliasTmp)->(DbCloseArea())
				fErase(cAliasTmp + GetDBExtension())
			EndIf
			Ft_FUse()

			//Sen„o, mostra erro
		Else
			MsgAlert("Arquivo inv·lido / n„o encontrado!", "AtenÁ„o")
		EndIf

		//Gera√ß√£o de arquivo com cabe√ßalho dos campos obrigat√≥rios
	ElseIf nTipo == 2
		fObrigat()
	EndIf

	nModulo := nModBkp
	SetFunName(cFunBkp)
Return


/*---------------------------------------------------------------------------------*/
Static Function fObrigat()
	Local aAreaX3	:= SX3->(GetArea())
	Local cConteud	:= ""
	Local cCaminho	:= cDirTmp
	Local cArquivo	:= "obrigatorio."
	Local cExtensao	:= ""
//	Local aAreaSA1	:= GetnextAlias()

	//Selecionando a SX3 e posicionando na tabela
	DbSelectArea("SX3")
	SX3->(DbSetOrder(1)) //TABELA
	SX3->(DbGoTop())
	SX3->(DbSeek(cTabela))

	//Enquanto houver registros na SX3 e for a mesma tabela
	While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cTabela
		//Se o campo for obrigat√≥rio
		If X3Obrigat(SX3->X3_CAMPO) .AND. Alltrim(SX3->X3_CAMPO)#"A1_CBAIRRE" .Or. SX3->X3_CAMPO $ "B1_PICM;B1_IPI;B1_CONTRAT;B1_LOCALIZ"
			cConteud += Alltrim(SX3->X3_CAMPO)+cGetCar
		EndIf

		SX3->(DbSkip())
	EndDo

	/*cQuery := "SELECT * FROM SIGA."+RetSqlName("SX3")+ "SX3"
	cQuery += "WHERE"
	cQuery += "SX3.D_E_L_E_T_ = ' '"
	cQuery += "SX3.X3_ARQUIVO = 'SA1'"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),aAreaSA1,.T.,.T.)*/

	cConteud := Iif(!Empty(cConteud), SubStr(cConteud, 1, Len(cConteud)-1), "")
	
	//Se escolher txt
	If MsgYesNo("Deseja gerar com a extens„o <b>txt</b>?", "AtenÁ„o")
		cExtensao := "txt"
		
	//Sen„o, ser√° csv
	Else
		cExtensao := "csv"
	EndIf
	
	//Gera o arquivo
	MemoWrite(cCaminho+cArquivo+cExtensao, cConteud)
	
	//Tentando abrir o arquivo
	nRet := ShellExecute("open", cArquivo+cExtensao, "", cCaminho, 1)
	
	//Se houver algum erro
	If nRet <= 32
		MsgStop("N„o foi possÌvel abrir o arquivo <b>"+cCaminho+cArquivo+cExtensao+"</b>!", "AtenÁ„o")
	EndIf
	
	RestArea(aAreaX3)
Return


/*---------------------------------------------------------------------------------*/
Static Function fMontaTmp()
	Local aArea := GetArea()
	
	//Se tiver aberto a tempor√°ria, fecha e exclui o arquivo
	If Select(cAliasTmp) > 0
		(cAliasTmp)->(DbCloseArea())
	EndIf
	fErase(cAliasTmp + GetDBExtension())
	
	//Adicionando a Estrutura (Campo, Tipo, Tamanho, Decimal)
	aStruTmp:={}
	aAdd(aStruTmp,{	"TMP_SEQ",		"C",	010,						0})
	aAdd(aStruTmp,{	"TMP_LINHA",	"N",	018,						0})
	aAdd(aStruTmp,{	"TMP_ARQ",		"C",	250,						0})
	
	//Criando tabela tempor√°ria
	cFiles := CriaTrab( aStruTmp, .T. )             
	dbUseArea( .T., "DBFCDX", cFiles, cAliasTmp, .T., .F. )
	
	//Setando os campos que ser√£o mostrados no MsSelect
	aCampos := {}
	aAdd(aCampos,{	"TMP_SEQ",		,	"Sequencia",		"@!"})
	aAdd(aCampos,{	"TMP_LINHA",	,	"Linha Erro",		""})
	aAdd(aCampos,{	"TMP_ARQ",		,	"Arquivo Log.",	""})
	
	RestArea(aArea)
Return


/*---------------------------------------------------------------------------------*/
Static Function fTelaObs(lAtivChav)
	Local lRet := .F.
	//Dimens√µes da janela
	Local nJanAltu := 500
	Local nJanLarg := 700
	//Objetos da tela
	Local oGrpDad
	Local oGrpCam
	Local oGrpOpc
	Local oGrpAco
	Local oBtnConf
	Local oBtnCanc
	//Janela
	Local oDlgObs
	//Radios - Chave
	Local oSayChave, oRadChave, nRadChave := 1
	//Radios - Filial
	Local oSayFilial, oRadFilial, nRadFilial := 1
	//Campos no grupo de Dados
	Local oSayTab, oGetTab, cGetTab := cTabela
	Local oSayCam, oGetCam, cGetCam := cCampoChv
	Local oSayFil, oGetFil, cGetFil := cFilialTab
	Local oSayRot, oGetRot, cGetRot := cRotina
	//Grid
	Private oMsNew
	Private aHeadNew := {}
	Private aColsNew := aClone(aHeadImp)
	Default lAtivChav := .T.
	
	//Setando o cabe√ßalho
	//Cabe√ßalho ...	Titulo				Campo			Mask		Tamanho	Dec		Valid				Usado	Tip		F3	CBOX
	aAdd(aHeadNew,{	"Campo",			"XX_CAMP",		"@!",		10,			0,		".F.",				".F.",	"C",	"",	""})
	aAdd(aHeadNew,{	"Tipo",			"XX_TIPO",		"@!",		1,			0,		"u_zCargaTp()",	".T.",	"C", 	"",	"C;N;L;D;M",	"C=Caracter;N=Num√©rico;L=L√≥gico;D=Data;M=Memo"})
	
	//Criando a janela
	DEFINE MSDIALOG oDlgObs TITLE "ObservAjustes" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
		//Grupo Dados
		@ 003, 003 	GROUP oGrpDad TO 055, (nJanLarg/2) 	PROMPT "Dados: " 		OF oDlgObs COLOR 0, 16777215 PIXEL
			//Tabela
			@ 010, 005 SAY   oSayTab PROMPT "Tabela:"  SIZE 040, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
			@ 017, 005 MSGET oGetTab VAR    cGetTab    SIZE 040, 010 OF oDlgObs PIXEL
			oGetTab:lActive := .F.
			
			//Campo Chave
			@ 010, 121 SAY   oSayCam PROMPT "Campo Chave:"  SIZE 040, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
			@ 017, 121 MSGET oGetCam VAR    cGetCam    SIZE 040, 010 OF oDlgObs PIXEL
			oGetCam:lActive := .F.
			
			//Filial
			@ 010, 237 SAY   oSayFil PROMPT "Filial Atual:"  SIZE 040, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
			@ 017, 237 MSGET oGetFil VAR    cGetFil    SIZE 040, 010 OF oDlgObs PIXEL
			oGetFil:lActive := .F.
			
			//Rotina
			@ 031, 005 SAY   oSayRot PROMPT "Rotina:"  SIZE 040, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
			@ 038, 005 MSGET oGetRot VAR    cGetRot    SIZE 272, 010 OF oDlgObs PIXEL
			oGetRot:lActive := .F.
			
		//Grupo Campos
		@ 058, 003 	GROUP oGrpCam TO 180, (nJanLarg/2) 	PROMPT "Campos: " 	OF oDlgObs COLOR 0, 16777215 PIXEL
			oMsNew := MsNewGetDados():New(	058+12,;									//nTop
    											006,;										//nLeft
    											177,;										//nBottom
    											(nJanLarg/2)-6,;							//nRight
    											GD_INSERT+GD_DELETE+GD_UPDATE,;			//nStyle
    											"AllwaysTrue()",;							//cLinhaOk
    											,;											//cTudoOk
    											"",;										//cIniCpos
    											{"XX_TIPO"},;								//aAlter
    											,;											//nFreeze
    											999,;										//nMax
    											,;											//cFieldOK
    											,;											//cSuperDel
    											,;											//cDelOk
    											oDlgObs,;									//oWnd
    											aHeadNew,;									//aHeader
    											aColsNew)									//aCols
			oMsNew:lInsert := .F.
			
		//Grupo OpÁıes
		@ 183, 003 	GROUP oGrpOpc TO 220, (nJanLarg/2) 	PROMPT "OpÁıes: " 	OF oDlgObs COLOR 0, 16777215 PIXEL
			//Chave
			@ 190, 005 SAY   oSayChave PROMPT "Campo Chave importado?"  SIZE 100, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
			@ 200, 005 RADIO oRadChave VAR	nRadChave ITEMS "Conforme Arquivo","Conforme Sequencia do Protheus (SXE/SXF)" SIZE 120, 019 OF oDlgObs COLOR 0, 16777215 PIXEL
			oRadChave:lActive := lAtivChav
			
			//Filial
			@ 190, 180 SAY   oSayFilial PROMPT "Campo Filial importado?"  SIZE 100, 011 OF oDlgObs COLORS 0, 16777215 PIXEL
			@ 200, 180 RADIO oRadFilial VAR	nRadFilial ITEMS "Conforme Arquivo","Conforme Filial do Protheus (xFilial)" SIZE 120, 019 OF oDlgObs COLOR 0, 16777215 PIXEL
			
		//Grupo Ajustes
		@ 223, 003 	GROUP oGrpAco TO 247, (nJanLarg/2) 	PROMPT "Ajustes: " 		OF oDlgObs COLOR 0, 16777215 PIXEL
			@ 229, (nJanLarg/2)-(63*1)  BUTTON oBtnCanc PROMPT "Cancelar"      SIZE 60, 014 OF oDlgObs ACTION (lRet := .F., oDlgObs:End()) PIXEL
			@ 229, (nJanLarg/2)-(63*2)  BUTTON oBtnConf PROMPT "Confirmar"     SIZE 60, 014 OF oDlgObs ACTION (aHeadImp := aClone(oMsNew:aCols), lRet := .T., oDlgObs:End()) PIXEL
	ACTIVATE MSDIALOG oDlgObs CENTERED
	
	//Se a tela for confirmada, atualiza as vari√°veis
	If lRet
		lChvProt := nRadChave  == 2
		lFilProt := nRadFilial == 2
	EndIf
Return lRet

/*/{Protheus.doc} zCargaTp
ValidaÁ„o do campo Tipo na tela tipo de obs.
@type function
@author Atilio
@since 16/11/2020
@version 1.0
/*/

User Function zCargaTp()
	Local lRetorn := .F.
	Local aColsAux := oMsNew:aCols
	Local nLinAtu := oMsNew:nAt

	//Se o campo atual estiver contido nos campos pr√≥prios do execauto (como LINPOS)
	If aColsAux[nLinAtu][01] $ cCampTipo
		lRetorn := .T.

		//Sen„o, campo n„o pode ser alterado
	Else
		lRetorn := .F.
		MsgAlert("Campo n„o pode ser alterado!", "AtenÁ„o")
	EndIf

Return lRetorn

/*---------------------------------------------------------------------------------*/
Static Function fImport()
	Local nLinAtu	:= 2
	Local cLinAtu	:= ""
	Local aAuxAtu	:= {}
	Local cArqLog	:= ""
	Local cConLog	:= ""
	Local cSequen	:= StrZero(1, 10)
	Local nPosAux	:= 1
	Local lFalhou	:= .F.
	Local xConteud:= ""
	Local nAuxLog	:= 0
	Local aLogAuto:= {}
	Private aDados	:= {}
	ProcRegua(nTotalReg)

	//Percorrendo os registros
	While !Ft_FEoF() .And. nLinAtu <= FT_FLastRec()
		IncProc("Analisando linha "+cValToChar(nLinAtu)+" de "+cValToChar(nTotalReg)+"...")
		cArqLog := "log_"+cCmbTip+"_lin_"+cValToChar(nLinAtu)+"_"+dToS(dDataBase)+"_"+StrTran(Time(), ":", "-")+".txt"
		cConLog := "Tipo:     "+cCmbTip+STR_PULA
		cConLog += "Usu√°rio:  "+UsrRetName(RetCodUsr())+STR_PULA
		cConLog += "Ambiente: "+GetEnvServer()+STR_PULA
		cConLog += "Data:     "+dToC(dDataBase)+STR_PULA
		cConLog += "Hora:     "+Time()+STR_PULA
		cConLog += "----"+STR_PULA+STR_PULA

		//Pegando a linha atual e transformando em array
		cLinAtu := Ft_FReadLn()
		cLinAtu := Iif(SubStr(cLinAtu, Len(cLinAtu), 1) == ";", SubStr(cLinAtu, 1, Len(cLinAtu)-1), cLinAtu)
		aAuxAtu := Separa(cLinAtu, cGetCar)

		//Se tiver dados
		If !Empty(cLinAtu)
			//Se o tamanho for diferente, registra erro
			If Len(aAuxAtu) != Len(aHeadImp)
				cConLog += "O tamanho de campos da linha, difere do tamanho de campos do cabe√ßalho!"+STR_PULA
				cConLog += "Linha:     "+cValToChar(Len(aAuxAtu))+STR_PULA
				cConLog += "Cabe√ßalho: "+cValToChar(Len(aHeadImp))+STR_PULA

				//Gerando o arquivo
				MemoWrite(cDirTmp+cArqLog, cConLog)

				//Gravando o registro
				RecLock(cAliasTmp, .T.)
				TMP_SEQ	:= cSequen
				TMP_LINHA	:= nLinAtu
				TMP_ARQ	:= cArqLog
				(cAliasTmp)->(MsUnlock())

				//Incrementa a sequencia
				cSequen := Soma1(cSequen)

				//Sen„o, carrega as informAjustes no array
			Else
				aDados	:= {}
				lFalhou:= .F.

				//Iniciando a transa√ß√£o
				Begin Transaction
					//Percorre o cabe√ßalho
					For nPosAux := 1 To Len(aHeadImp)
						xConteud := aAuxAtu[nPosAux]

						//Se o tipo do campo for Num√©rico
						If aHeadImp[nPosAux][2] == 'N'
							xConteud := Val(aAuxAtu[nPosAux])

							//Se o tipo for L√≥gico
						ElseIf aHeadImp[nPosAux][2] == 'L'
							xConteud := Iif(aAuxAtu[nPosAux] == '.T.', .T., .F.)

							//Se o tipo for Data
						ElseIf aHeadImp[nPosAux][2] == 'D'
							//Se tiver '/' na data, √© padr√£o DD/MM/YYYY
							If '/' $ aAuxAtu[nPosAux]
								xConteud := cToD(aAuxAtu[nPosAux])

								//Sen„o, √© padr√£o YYYYMMDD
							Else
								xConteud := sToD(aAuxAtu[nPosAux])
							EndIf
						EndIf

						//Se for o campo filial
						If '_FILIAL' $ aHeadImp[nPosAux][1]
							//Se a filial for conforme o protheus
							If lFilProt
								xConteud := FWxFilial(cTabela)
							EndIf
						EndIf

						//Se for o campo chave
						If Alltrim(cCampoChv) == Alltrim(aHeadImp[nPosAux][1])
							//Se a chave for conforme o protheus
							If lChvProt
								xConteud := GetSXENum(cTabela, cCampoChv)
							EndIf
						EndIf

						//Adicionando no vetor que ser√° importado
						aAdd(aDados,{	aHeadImp[nPosAux][1],;			//Campo
						xConteud,;							//Conte√∫do
						Nil})								//Compatibilidade
					Next

					//Seta as vari√°veis de log do protheus
					lAutoErrNoFile	:= .T.
					lMsErroAuto		:= .F.

					//Executa o execauto
					&(cRotina)

					//Se tiver alguma falha
					If lMsErroAuto
						lFalhou := .T.

						//Pegando log do ExecAuto
						aLogAuto := GetAutoGRLog()

						//Gerando log
						For nAuxLog :=1 To Len(aLogAuto)
							cConLog += aLogAuto[nAuxLog] + STR_PULA
						Next

						DisarmTransaction()
					EndIf
				End Transaction

				//Se houve falha na ImportaÁ„o, grava na tabela tempor√°ria
				If lFalhou
					//Gerando o arquivo
					MemoWrite(cDirTmp+cArqLog, cConLog)

					//Gravando o registro
					RecLock(cAliasTmp, .T.)
					TMP_SEQ	:= cSequen
					TMP_LINHA	:= nLinAtu
					TMP_ARQ	:= cArqLog
					(cAliasTmp)->(MsUnlock())

					//Incrementa a sequencia
					cSequen := Soma1(cSequen)
				EndIf
			EndIf
		EndIf

		nLinAtu++
		Ft_FSkip()
	EndDo
Return

/*---------------------------------------------------------------------------------*/
Static Function fTelaErro()
	Local aArea		:= GetArea()
	Local oDlgErro
	Local oGrpErr
	Local oGrpAco
	Local oBtnFech
	Local oBtnVisu
	Local nJanLarErr	:= 600
	Local nJanAltErr	:= 400
	//Criando a Janela
	DEFINE MSDIALOG oDlgErro TITLE "Erros na ImportaÁ„o" FROM 000, 000  TO nJanAltErr, nJanLarErr COLORS 0, 16777215 PIXEL
	//Grupo Erros
	@ 003, 003 	GROUP oGrpErr TO (nJanAltErr/2)-28, (nJanLarErr/2) 	PROMPT "Erros: " 		OF oDlgErro COLOR 0, 16777215 PIXEL
	//Criando o MsSelect
	oBrowChk := MsSelect():New(	cAliasTmp,;												//cAlias
	"",;														//cCampo
	,;															//cCpo
	aCampos,;													//aCampos
	,;															//lInv
	,;															//cMar
	{010, 006, (nJanAltErr/2)-31, (nJanLarErr/2)-3},;	//aCord
	,;															//cTopFun
	,;															//cBotFun
	oDlgErro,;													//oWnd
	,;															//uPar11
	)															//aColors
	oBrowChk:oBrowse:lHasMark    := .F.
	oBrowChk:oBrowse:lCanAllmark := .F.

	//Grupo Ajustes
	@ (nJanAltErr/2)-25, 003 	GROUP oGrpAco TO (nJanAltErr/2)-3, (nJanLarErr/2) 	PROMPT "Ajustes: " 		OF oDlgErro COLOR 0, 16777215 PIXEL

	//Bot√µes
	@ (nJanAltErr/2)-18, (nJanLarErr/2)-(63*1)  BUTTON oBtnFech PROMPT "Fechar"        SIZE 60, 014 OF oDlgErro ACTION (oDlgErro:End()) PIXEL
	@ (nJanAltErr/2)-18, (nJanLarErr/2)-(63*2)  BUTTON oBtnVisu PROMPT "Vis.Erro"      SIZE 60, 014 OF oDlgErro ACTION (fVisErro()) PIXEL
	ACTIVATE MSDIALOG oDlgErro CENTERED

	RestArea(aArea)

Return

/*---------------------------------------------------------------------------------*/
Static Function fVisErro()
	Local nRet := 0
	Local cNomeArq := Alltrim((cAliasTmp)->TMP_ARQ)
	//Tentando abrir o objeto
	nRet := ShellExecute("open", cNomeArq, "", cDirTmp, 1)

	//Se houver algum erro
	If nRet <= 32
		MsgStop("n„o foi possÌvel abrir o arquivo " +cDirTmp+cNomeArq+ "!", "AtenÁ„o")
	EndIf
Return
