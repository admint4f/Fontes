#include "Totvs.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "Fileio.ch"
#Include "ParmType.ch"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "DBINFO.CH"
//----------------------------------------------------EXECAUTO---------------
/*/{Protheus.doc}  ImpSB1
Realiza a importação de Produtos a partir de planilha excel
@author  Willian Aparecido Carvalho / Geraldo Sabino Ferreira
@since   28/05/2022MVP
@version 1.0
/*/
//-------------------------------------------------------------------
User Function T4FATUSB1()   //SB1
Local cTitulo   := "Importacao de Produtos"
Local nOpcao    := 0
Local aButtons  := {}
Local aSays     := {}
//
Private cArea   := GetArea()
Private cArquivo
Private cIniPet
Private aBotOpc
Private nOpc
Private cTit
Private cTotal
Private ltotal
Private aParamBox     := {}
Private aRet          := {}
Private cCPO          := "B1_COD/B1_UM/B1_MSBLQL/                                                                   "
Private nAlert        := 0

aAdd(aParamBox,{1,"Campos da Planilha "	 ,cCpo,"","","","",80,.T.})
aAdd(aParamBox,{1,"Alerts de Gravacao "	 ,nAlert   ,"","","","",20,.T.})

If !ParamBox(aParamBox, "Confirma os campos da Planilha ?", aRet)
	Return Nil
EndIf

AADD(aSays,OemToAnsi("Esta rotina tem como objetivo de importar Produtos"))
AADD(aSays,OemToAnsi("Clique no botão PARAM para informar o arquivo que será importado."))
AADD(aSays,OemToAnsi("Após isso, clique no botão OK."))

AADD(aButtons, { 1,.T.,{|o| nOpcao:= 1,o:oWnd:End()} } )
AADD(aButtons, { 2,.T.,{|o| nOpcao:= 2,o:oWnd:End()} } )
AADD(aButtons, { 5,.T.,{| | cArquivo := cGetFile("*.xls*" , "Selecione o arquivo..." )  } } )

FormBatch( cTitulo, aSays, aButtons,,200,530 )

if nOpcao = 1
	If Empty(cArquivo)
		MsgAlert("Não há arquivos a importar...","AVISO")
	Else
		FWMsgRun(, {|oSay| RProcessa(oSay,MV_PAR01,MV_PAR02) }, "Processando", "Processando dados aguarde...")
	EndIf
endif

RestArea(cArea)

Return

//-------------------------------------------------------------------
/*/{Protheus.doc}  fProcessa
Realiza o processamento dos dados a partir da planilha selecionada
@author  Willian Aparecido Carvalho
@since   28/05/2022
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function RProcessa( oSay,cCampos,nAlert ) // Se o nome do arquivo nÆo for passado
Local nCol           := 1
Local nLin           := 1
Local lContinua      := .T.
Local aFields        := {}
Local oTable		 := Nil
Local nI			 := 0
Local nX             := 0
Local cTabAlias		 := ""
Local cTabName       := ""
Local cAlias         := GetNextAlias()
Local cQuery         := ""
Local cTipo          := ""
Local aCposPlan      := {}
Local aCabec         := {}
Local aItens         := {}
Local aLinha         := {}
Local cFileName		 := ""
Local cPed			 := ""
Local cTxtLog 		 := ""
Local nVar           := 0
Local aPD            := {}
Local aPD2           := {}
Local pp             := 0
Local nn             := 0
Local x              := 0
Local nLim           := 0
Local aColunas       :={}
Local xx             :={}

// variável de controle interno da rotina automatica que informa se houve erro durante o processamento
Private lMsErroAuto := .F.
Private lErro       := .F.

// variável que define que o help deve ser gravado no arquivo de log e que as informações
// estão vindo à partir da rotina automática.
Private lMsHelpAuto	:= .T.

// força a gravação das informações de erro em array para manipulação da gravação ao invés
//de gravar direto no arquivo temporário
Private lAutoErrNoFile := .T.

dbSelectArea("SB1")
SB1->(DBSetOrder(1))

oSay:SetText("Iniciando leitura do arquivo...")

oExcel:= LerExcel():new()
oExcel:OpenRead(cArquivo)

//Determinando Linhas

While ValType(oExcel:CellRead(1,nCol)) <> 'U'
	nCol++
EndDo

//cCampos:="B1_COD/B1_UM/B1_MSBLQL/"

nLim:=len(alltrim(ccampos))

nCol:=1
cInfo:=""


For x:=1 to nLim
	
	IF Substr(cCampos,x,1) = "/"
		AADD(aColunas,cInfo)
		nCol:=nCol+1
		cInfo:=""
	else
		IF x = len(alltrim(cCampos))
			IF Substr(cCampos,x,1) <> '/'
				cInfo:=cInfo + Substr(cCampos,x,1)
				AADD(aColunas,cInfo)
			ENDIF
		else
			cInfo:=cInfo + Substr(cCampos,x,1)
		ENDIF
	ENDIF
	
NEXT




IF nCol=1
	MsgAlert("só tem uma coluna e são necessárias mais...","COLUNAS DA PLANILHA")
	Return
ENDIF
//Determinando Linhas
While ValType(oExcel:CellRead(nLin,1)) <> 'U'
	nLin++
EndDo


nLin -= 1
nCol -= 1

If nLin < 2 //Se Numero de Linhas for menor que 2 significa que somente há cabeçalho
	lContinua := .F.
	MsgAlert('So tem Cabecalho !!!')
	MsgAlert("A Planilha "+cArquivo+" não possui linhas a serem processadas!!!","Atencao")
EndIf
//
//

If  lContinua
	oSay:SetText("Arquivo Lido, estrutura com "+cValToChar(nCol)+" colunas e "+cValToChar(nLin)+" linhas")
	Sleep(300) //Somente uma pausa para exibição da mensagem
	
	//Definindo os campos que serão usados na importação
	//Na estrutura abaixo: NomeColunaExcel,NomeSQL,Tipo Dado,Tamanho,Decimais,manter_zerado
	
	lErro := .F.
	For x:=1 to len(aColunas)
		dBSelectarea("SX3")
		dBSetOrder(2)
		IF dBSeek(PADR(aColunas[x],10))
			IF SX3->X3_TIPO = "C"
				aAdd(aCposPlan,{aColunas[x]	,aColunas[x]	,"C",20,0,0})
			else
				MsgAlert(SX3->X3_CAMPO + "-Só é permitido a alteração de campos do tipo CARACTER. O Campo informado é do tipo ->"+SX3->X3_TIPO,"ERRO DE PLANILHA")
				lErro :=.T.
			ENDIF
		else
			MsgAlert("Coluna inexistente no SX3 informada em Parametros na chamada desta rotina...","ERRO DE PARAMETRO")
			lErro :=.T.
			Exit
		Endif
	NEXT
	
	IF lerro
		Return
	ENDIF
	
	//Criando Estrutura de Tabela Tamporária
	oTable := FWTemporaryTable():New( cAlias )
	//
	//Montando Campos da Tabela
	//
	For nI := 1 to nCol
		
		oSay:SetText("Gerando estrutura para processamento...")
		
		nPosCol := aScan( aCposPlan, { |x| AllTrim(Upper(x[1])) == Upper(ALLtrim(oExcel:CellRead(1,nI)))} )
		
		If nPosCol <= 0
			Loop
		Else
			aCposPlan[nPosCol,6] := nI //Informar na posição 6 do vetor qual coluna da planilha
		EndIf
		//
		
		
		
		cTipo := aCposPlan[nPosCol,3]
		nTam  := aCposPlan[nPosCol,4]
		nDec  := aCposPlan[nPosCol,5]
		
		aAdd(aFields,{aCposPlan[nPosCol,2],cTipo,nTam,nDec})
		
	Next nI
	
	oTable:SetFields( aFields )
	//Criando índices
	oTable:AddIndex("01", {aColunas[1]} )
	//
	
	//Agora a tabela será criada no espaço temporário do DB
	oTable:Create()
	
	//Pego o alias da tabela temporária
	cTabAlias := oTable:GetAlias()
	
	//Pego o nome real da tabela temporária no banco de dados
	cTabName := oTable:GetRealName()
	
	For nI := 2 to nLin
		
		oSay:SetText("Gravando dados da planilha na tabela temporaria: "+cTabName)
		
		(cAlias)->(DBAppend())
		For nX := 1 to Len(aCposPlan)
			If aCposPlan[nX,3] == "C"
				(cAlias)->&(aFields[nX,1]) := AllTrim(cValToChar(oExcel:CellRead(nI,aCposPlan[nX,6])))
			Else
				(cAlias)->&(aFields[nX,1]) := oExcel:CellRead(nI,aCposPlan[nX,6])
			EndIf
		Next nX
		(cAlias)->(DBCommit())
	Next nLin
	
	//Não há mais necessidade de manter o arquivo excel aberto, então fecho.
	oExcel:CloseRead()
	
	cAreaQuery := GetNextAlias()
	
	//MsgInfo("Sera Solicitado o local para gravar o log de processamento.","Gravacao LOG")
	//cFileName := cGetFile('*.Log', 'Salvar Log', 1, 'C:\', .T., GETF_LOCALHARD+GETF_LOCALFLOPPY)+".Log"
	//
	//Executa query para leitura da tabela
	cQuery := "select * from "+ cTabName
	//
	DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAreaQuery, .T., .T.)
	
	(cAreaQuery)->(DBGoTop())
	aPD:={}
	while !(cAreaQuery)->(eof())
		
		
		DO CASE
			CASE LEN(aColunas)=2
				cCampo1 := aColunas[1]
				cCampo2 := aColunas[2]
				
				AADD(aPD,{&cCampo1,&cCampo2})
				
			CASE LEN(aColunas)=3
				cCampo1 := aColunas[1]
				cCampo2 := aColunas[2]
				cCampo3 := aColunas[3]
				
				AADD(aPD,{&cCampo1,&cCampo2,&cCampo3})
				
				
			CASE LEN(aColunas)=4
				cCampo1 := aColunas[1]
				cCampo2 := aColunas[2]
				cCampo3 := aColunas[3]
				cCampo4 := aColunas[4]
				
				AADD(aPD,{&cCampo1,&cCampo2,&cCampo3,&cCampo4})
				
				
			CASE LEN(aColunas)=5
				cCampo1 := aColunas[1]
				cCampo2 := aColunas[2]
				cCampo3 := aColunas[3]
				cCampo4 := aColunas[4]
				cCampo5 := aColunas[5]
				
				AADD(aPD,{&cCampo1,&cCampo2,&cCampo3,&cCampo4,&ccampo5})
		Endcase
		
		
		(cAreaQuery)->(dbskip())
	Enddo
	(cAreaQuery)->(DBCloseArea())  //
	
	IF Len(aPD) = 0
		Alert("Sem dados ")
		Return
	ENDIF
	
	ASORT(aPD, , , { | x,y | x[1]  < y[1] } )
	
	
	
	// Verifica a existencia de dados validos (Cliente, Produto, Tes, e nao segue o processamento caso nao exista
	_nErros :=0
	
	IF _nErros > 0
		MSGALERT(cTXTlog)
	ENDIF
	
	
	cId     := ""
	aPD2    :={}
	
	For nVar:=1 to Len(aPD)
		IF aPd[nVar,1]<>cId
			
			
			
			DO CASE
				CASE LEN(aColunas)=2
					AADD(aPD2,{aPd[nVar,1],aPd[nVar,2]})
					
					
				CASE LEN(aColunas)=3
					AADD(aPD2,{aPd[nVar,1],aPd[nVar,2],aPd[nVar,3]})
					
					
				CASE LEN(aColunas)=4
					AADD(aPD2,{aPd[nVar,1],aPd[nVar,2],aPd[nVar,3],aPd[nVar,4]})
					
					
				CASE LEN(aColunas)=5
					AADD(aPD2,{aPd[nVar,1],aPd[nVar,2],aPd[nVar,3],aPd[nVar,4],aPd[nVar,5]})
					
			Endcase
			
			
			cId  := aPD[nVar,1]
		ENDIF
	NEXT
	
	aLog := {}
	For nn:=1 to Len(aPD2)
		dBSelectarea("SB1")
		dBSetOrder(1)
		nTamB1_COD:=LEN(SB1->B1_COD)
		
		IF !dBSeek(xFilial("SB1")+Substr(aPD2[nn,1],1,nTamB1_COD))
			//Gravação de informações de erro ocorridos durante o processo
			AADD(aLog,"Produto nao existente em Cadastro de Produtos consta da Planilha -> "+aPD2[nn,1])
		ENDIF
	NEXT
	
	
	//  MsgAlert("ERROS -> "+STR(LEN(aLog)),"Corrija os erros e faça a importação Novamente ")
	
	
	IF Len(aLog) > 0
		MsgAlert("INICIANDO","AVISO DE OCORRENCIAS INICIAIS, TECLE ENTER PARA CONTINUAR")
		
		For nn:=1 to len(aLog)
			MsgAlert(aLog[NN],"AVISO")
			
			IF NN >5
				EXIT
			ENDIF
			//
		NEXT
		
		IF NN > 0
			RETURN
		ENDIF
	ELSE
		MsgAlert("ARQUIVO OK - Registros a serem atualizados -> "+STR(LEN(aPD2)),"PRODUTOS VALIDOS")
	ENDIF
	
	cTxtLog := ""
	nItens  :=0
	For nn:=1 to Len(aPD2)
		
		cPrd :=  aPD2[nn,1]
		
		aDados := {}
		
		DO CASE
			CASE LEN(aColunas)=2
				
				For xx:=1 to Len(aColunas)
					
					SX3->(dBSetOrder(2))
					SX3->(dBSeek(PADR(alltrim(aColunas[XX]),10)))
					
					IF SX3->X3_TIPO = "C"
						aAdd(aDados,{ aColunas[xx]  , ALLTRIM(aPd2[nn,xx]), NIL })
					ELSEIF SX3->X3_TIPO = "N"
						aAdd(aDados,{ aColunas[xx]  , VAL(ALLTRIM(aPd2[nn,xx])), NIL })
					ELSEIF SX3->X3_TIPO = "D"
						aAdd(aDados,{ aColunas[xx]  , CTOD(ALLTRIM(aPd2[nn,xx])), NIL })
					ENDIF
					
				NEXT
				
				
				
			CASE LEN(aColunas)=3
				For xx:=1 to Len(aColunas)
					
					SX3->(dBSetOrder(2))
					SX3->(dBSeek(PADR(alltrim(aColunas[XX]),10)))
					
					IF SX3->X3_TIPO = "C"
						aAdd(aDados,{ aColunas[xx]  , ALLTRIM(aPd2[nn,xx]), NIL })
					ELSEIF SX3->X3_TIPO = "N"
						aAdd(aDados,{ aColunas[xx]  , VAL(ALLTRIM(aPd2[nn,xx])), NIL })
					ELSEIF SX3->X3_TIPO = "D"
						aAdd(aDados,{ aColunas[xx]  , CTOD(ALLTRIM(aPd2[nn,xx])), NIL })
					ENDIF
					
				NEXT
				
				
				
			CASE LEN(aColunas)=4
				
				
				
				For xx:=1 to Len(aColunas)
					
					SX3->(dBSetOrder(2))
					SX3->(dBSeek(PADR(alltrim(aColunas[XX]),10)))
					
					IF SX3->X3_TIPO = "C"
						aAdd(aDados,{ aColunas[xx]  , ALLTRIM(aPd2[nn,xx]), NIL })
					ELSEIF SX3->X3_TIPO = "N"
						aAdd(aDados,{ aColunas[xx]  , VAL(ALLTRIM(aPd2[nn,xx])), NIL })
					ELSEIF SX3->X3_TIPO = "D"
						aAdd(aDados,{ aColunas[xx]  , CTOD(ALLTRIM(aPd2[nn,xx])), NIL })
					ENDIF
					
				NEXT
				
				
				
			CASE LEN(aColunas)=5
				
				For xx:=1 to Len(aColunas)
					
					SX3->(dBSetOrder(2))
					SX3->(dBSeek(PADR(alltrim(aColunas[XX]),10)))
					
					IF SX3->X3_TIPO = "C"
						aAdd(aDados,{ aColunas[xx]  , ALLTRIM(aPd2[nn,xx]), NIL })
					ELSEIF SX3->X3_TIPO = "N"
						aAdd(aDados,{ aColunas[xx]  , VAL(ALLTRIM(aPd2[nn,xx])), NIL })
					ELSEIF SX3->X3_TIPO = "D"
						aAdd(aDados,{ aColunas[xx]  , CTOD(ALLTRIM(aPd2[nn,xx])), NIL })
					ENDIF
					
				NEXT
				
		Endcase
		
		
		// valida os produtos da planilha
		
		MSExecAuto({|x,y| Mata010(x,y)},aDados,4)
		aLog := {}
		If lMsErroAuto
			
			//Gravação de informações de erro ocorridos durante o processo da rotina automática
			aLog := GetAutoGRLog()
			lErro :=.F.
			
			FOR XX:=1 to LEN(ALOG)
				IF "INVALIDO" $ UPPER(aLog[xx])
					lErro :=.T.
					
				    IF xx>5	
					
					   cLOG1:=aLog[2]+CRLF
                       cLOG1+=aLog[3]+CRLF
					   cLOG1+=aLog[4]+CRLF
					   cLOG1+=aLog[5]+CRLF
					   cLOG1+=aLog[6]

					   ALERT(UPPER(cLOG1))
				    					
					ENDIF
				
				ENDIF




			NEXT
			
			
			IF lerro
				If !MsgBox(OEMTOANSI('Veja campos com erro'+ CRLF +;
					'Erro de informação em campos com validação'+ CRLF +;
					'Deseja continuar ?'),"Atencao","YESNO")
					RETURN
				Endif
				
			Endif
			
			If Len(aLog) > 0
				cTxtLog += "Produto Arquivo: "+cPrd+", gerou erros de gravacao, segue detalhes: "
				For nI := 1 to Len(aLog)
					cTxtLog += aLog[nI]
				Next nI
				cTxtLog += "---------------------------------------------------------------------------------"+CRLF
				
				
				IF Mod(len(alltrim(cTxtLog)),208) > 0
					MOSTRAERRO()
				ENDIF
				
			ENDIF
			
		else
			
			If Empty(aLog)
				cTxtLog += "Produto no Arquivo: "+cPrd+", atualizou com sucesso o produto "+cPrd+" no Protheus."
				cTxtLog += "---------------------------------------------------------------------------------"+CRLF
				cLog:="Produto no Arquivo: "+cPrd+", atualizou com sucesso o Produto "+cPrd+" no Protheus."
				nItens++
				
				if nItens <= nAlert
					ALERT(cLog)
				ENDIF
				
			EndIf
			
		EndIf
	NEXT
Else
	MsgAlert("Nao Processado !!!")
EndIf

Return
