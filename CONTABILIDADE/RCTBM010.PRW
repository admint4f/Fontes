#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCTBM010 ºAutor  ³Bruno Daniel Borges º Data ³  26/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de geracao de planilhas Excel com visoes gerenciais  º±±
±±º          ³separando em colunas as empresas do consolidado             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCTBM010()
	Local cPathDestino	:= ""
	Local oRegua		:= Nil
	Local nDivide		:= 1

	//Utiliza o mesmo grupo de perguntas do padrao (CTR190)
	If !Pergunte("CTBM10",.T.)
		Return(Nil)
	EndIf

	cPathDestino := cGetFile("\", "Diretorio Destino",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)

	oRegua := MsNewProcess():New({|lEnd| RCTBM010_Prc(@oRegua,cPathDestino) },"Montando Relatório...","",.T.)
	oRegua:Activate()

Return(Nil)                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBM010_PrcºAutor  ³Bruno Daniel Borges º Data ³  26/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de processamento do relatorio                          º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RCTBM010_Prc(oRegua,cPathDestino)
	Local oMeter		:= Nil
	Local oText			:= Nil
	Local oDlg			:= Nil
	Local oExcel		:= Nil
	Local lEnd			:= .F.
	Local aEstrut		:= {}
	Local aSetOfBook	:= {}
	Local i				:= 0
	Local nRecnoSM0		:= SM0->(RecNo())
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
	If Empty(mv_par30) .Or. mv_par31 == "ZZ" .Or. Empty(mv_par31)
		MsgAlert("Atenção, é obrigatório que seja informados os números iniciais e finais de empresa a serem listadas. Não pode ser informada de '  ' até 'ZZ'.")
		Return(Nil)
	EndIf  

	//Obriga a ser informado o diretorio de Destino
	If Empty(cPathDestino)
		MsgAlert("Atenção, é obrigatório a seleção do diretório de destino da planilha a ser gerada.")
		Return(Nil)
	EndIf

	aSetOfBook := CTBSetOf(mv_par06)

	oRegua:SetRegua1(Val(mv_par31) - Val(mv_par30)+1)

	//Estrutura do arquivo com o resumo por empresa
	Aadd(aEstrut,{"ENTIDADE","C",020,00})
	Aadd(aEstrut,{"DESC_ENT","C",100,00})
	
	For i := Val(mv_par30) To Val(mv_par31)
	
		If !SM0->(dbSeek(StrZero(i,2)))
			Loop
		EndIf
	
		SM0->(dbGoTo(nRecnoSM0))	

		Aadd(aEstrut,{"SALANT_"+StrZero(i,2)	,"N",14,02})
		Aadd(aEstrut,{"DEB_"+StrZero(i,2)		,"N",14,02})
		Aadd(aEstrut,{"CRD_"+StrZero(i,2)		,"N",14,02})
		Aadd(aEstrut,{"SALATU_"+StrZero(i,2)	,"N",14,02})
	
	Next i

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
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
	For i := Val(mv_par30) To Val(mv_par31) 
		If !SM0->(dbSeek(StrZero(i,2)))
			Loop
		EndIf
		SM0->(dbGoTo(nRecnoSM0))	

		MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
		CTGerPlan(	oMeter,;		//1
		oText,;			//2
		oDlg,;			//3
		@lEnd,;			//4
		@cArqTmp,;		//5
		mv_par01,;		//6
		mv_par02,;		//7
		"CT7",;			//8
		"",;			//9
		mv_par03,;		//10
		mv_par04,;		//11
		,;				//12
		,;				//13
		,;				//14
		,;				//15
		,;				//16
		,;				//17
		mv_par08,;		//18
		mv_par10,;		//19
		aSetOfBook,;	//20
		mv_par12,;		//21
		mv_par13,;		//22
		mv_par14,;		//23
		mv_par15,;		//24
		.F.,;			//25
		.F.,;			//26
		mv_par11,;		//27
		,;				//28
		lImpAntLP,;		//29
		dDataLP,;		//30
		nDivide,;		//31
		lVlrZerado,;	//32
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
		{"","","","","","",Padr(StrZero(i,2),20),Padr(StrZero(i,2),20)},;				//44
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
		OemToAnsi("Criando Arquivo Tempor rio..."),;
		OemToAnsi("Visão Gerencial Por Empresa...")) 

		//Grava na tabela temporaria o resultado dos valores da empresa atual
		dbSelectArea("cArqTmp")						 				
		oRegua:SetRegua2(RecCount())
		dbGoTop()
		While !Eof()
			dbSelectArea("TMP_M10")    
			If StrZero(i,2) == mv_par30 .Or. !TMP_M10->(dbSeek( cArqTmp->CONTA ))
				TMP_M10->(RecLock("TMP_M10",.T.))
			Else
				TMP_M10->(RecLock("TMP_M10",.F.))
			EndIf

			//Gravacao dos Campos
			TMP_M10->ENTIDADE					:= cArqTmp->CONTA
			TMP_M10->DESC_ENT					:= cArqTmp->DESCCTA 
			TMP_M10->&("SALANT_"+StrZero(i,2))	:= cArqTmp->SALDOANT
			TMP_M10->&("DEB_"+StrZero(i,2))	:= cArqTmp->SALDODEB
			TMP_M10->&("CRD_"+StrZero(i,2))	:= cArqTmp->SALDOCRD
			TMP_M10->&("SALATU_"+StrZero(i,2))	:= cArqTmp->SALDOATU
			TMP_M10->(MsUnlock())	

			dbSelectArea("cArqTmp")
			dbSkip()   

			oRegua:IncRegua2("Processando...")
		EndDo  
		Iif(Select("cArqTmp") > 0,cArqTmp->(dbCloseArea()),Nil)

		oRegua:IncRegua1("Empresa: " + StrZero(i,2))
	Next i                                                      

	//Fecha o arquivo e copia para a estacao do usuario
	TMP_M10->(dbGoTop())                          

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	// TMP_M10->(__dbCopy((cFileTRB),{},,,,,.F., "DBFCDXADS" ))
	TMP_M10->(__dbCopy((cFileTRB),{},,,,,.F., "TOPCONN" ))
	
	//CpyS2T(Upper(cFileTRB)+".DBF",cPathDestino,.F.)
	CpyS2T(Upper(cFileTRB)+".DBF",cPathDestino,.F.)
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	//Cria o link com o Excel
	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open( cPathDestino+Upper(cFileTRB)+".DBF" )
	oExcel:SetVisible(.T.)

Return(Nil)