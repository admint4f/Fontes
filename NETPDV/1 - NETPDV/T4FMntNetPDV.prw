#INCLUDE "TOTVS.ch"
#INCLUDE "FWMVCDef.ch"
#INCLUDE "FWEditPanel.ch"

#DEFINE ALIAS_ZZX     "ZZX"
#DEFINE ROTINA_FILE	  "T4FMntNetPDV.prw"
#DEFINE VERSAO 		  " | v" + Trim(AllToChar(GetAPOInfo(ROTINA_FILE)[04])) + " - " + Trim(AllToChar(GetAPOInfo(ROTINA_FILE)[05])) + "[" + Trim(AllToChar(GetAPOInfo(ROTINA_FILE)[03])) + "]"
#DEFINE TITULO_MODEL  "Monitor Integrações NetPDV"//+SubStr(VERSAO,1,25)
#DEFINE MODEL_MASTER  "ZZXMASTER"

/*/{Protheus.doc} T4FMntNetPDV
Monta Browse com as opções - CRUD MVC da tabela de Log de Monitoramenteo (NetPDV)
@type function
@author Joalisson Laurentino | CRMServices | 1198975-3610 | Skype: jslaurentino
@since 10/03/2022
/*/
User Function T4FMntNetPDV()
	Local cTitulo   := TITULO_MODEL
	Local cSetAlias := ALIAS_ZZX
	Local oBrowse   := Nil
	Local nOrdem	:= 1

	Private aRotina := FwLoadMenuDef("T4FMntNetPDV")

	If (FwAliasInDic(cSetAlias))
		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias(cSetAlias)  
		oBrowse:AddLegend("ZZX_STATUS == '0'","BR_PRETO","Registro Importado") 	//Aguardando execução - A mensagem está na fila do JOB e ainda não começou a execução (o seu envio ou o seu processamento)
		oBrowse:AddLegend("ZZX_STATUS == '1'","BR_LARANJA","Gerou Cliente") 	//Aguardando execução - A mensagem está na fila do JOB e ainda não começou a execução (o seu envio ou o seu processamento)
		oBrowse:AddLegend("ZZX_STATUS == '2'","BR_AZUL","Gerou Orçamento") 	//Aguardando execução - A mensagem está na fila do JOB e ainda não começou a execução (o seu envio ou o seu processamento)
		oBrowse:AddLegend("ZZX_STATUS == '3'","BR_PINK" ,"Erro Gerar Orc")			//Finalizada - A mensagem foi processada sem erros ou foi enviada sem erros;
		oBrowse:AddLegend("ZZX_STATUS == '4'","BR_VERMELHO" ,"Erro Gerar Doc")			//Finalizada - A mensagem foi processada sem erros ou foi enviada sem erros;
		oBrowse:AddLegend("ZZX_STATUS == '5'","BR_AMARELO" ,"NFCE Recusada") 		//Falhou - Houve um erro no envio da mensagem ou no seu recebimento;
		oBrowse:AddLegend("ZZX_STATUS == '6'","GREEN","NFCE Autorizada") 	//Aguardando execução - A mensagem está na fila do JOB e ainda não começou a execução (o seu envio ou o seu processamento)
		oBrowse:AddLegend("ZZX_STATUS == 'A'","BR_CANCEL"   ,"Não gera integração") 		//Falhou - Houve um erro no envio da mensagem ou no seu recebimento;
		oBrowse:SetDescription(cTitulo)
		
		// Ordenando a tabela temporária de forma decrescente
		ZZX->(DbSetOrder(nOrdem))
		ZZX->(OrdDescend(nOrdem,cValToChar(nOrdem),.T.))
		ZZX->(DbGoTop())

		oBrowse:Activate()
		oBrowse:Destroy()
	Else
		FWAlertHelp("Alias da Tabela [ "+cSetAlias+" ] não foi criado nesse grupo de empresa.","Entre em contato com o suporte para criar a tabela [ "+cSetAlias+" ] no ambiente.")
	Endif
Return()
/*/{Protheus.doc} ModelDef
Define o modelo de dados MVC da tabela de Log de Monitoramento (NetPDV)
@type function
@author Joalisson Laurentino | CRMServices | 1198975-3610 | Skype: jslaurentino
@since 05/03/2022
/*/
Static Function ModelDef()
    Local oModel	:= Nil
    Local oStruZZX	:= FwFormStruct(1,ALIAS_ZZX)

    oModel := MPFormModel():New('MT4FMntNetPDV',/*bMPre*/,/*bMPost*/,/*bMCommit*/,/*bMCancel*/)
    oModel:AddFields(MODEL_MASTER,/*cOwner*/,oStruZZX,/*bPreVld*/,/*bPostVld*/,/*bLoad*/)
    oModel:SetDescription('Logs Processamento NetPDV')
    oModel:SetPrimaryKey({'ZZX_IDPDV'})
Return(oModel)

/*/{Protheus.doc} ViewDef
Define o modelo de visualização MVC da tabela de Log de Monitoramento (NetPDV)
@type function
@author Joalisson Laurentino | CRMServices | 1198975-3610 | Skype: jslaurentino
@since 10/03/2022
/*/
Static Function ViewDef()
	Local oView	   := FwFormView():New()
	Local oModel   := FWLoadModel('T4FMntNetPDV')
	Local oStruZZX := FwFormStruct(2,ALIAS_ZZX) 

	oStruZZX:AddGroup('GRP_01','Dados da Transação de Venda','',2)
    oStruZZX:AddGroup('GRP_02','Dados da Requisição - Json','',2)
/*
	ZZX->ZZX_FILIAL     := xFilial("ZZX")
	ZZX->ZZX_IDEVEN		:= cCodEvento
	ZZX->ZZX_NMEVEN 	:= cNmEvento
	ZZX->ZZX_OPERAC		:= cOpecacao
	ZZX->ZZX_IDPDV      := cIDTrasacao
	ZZX->ZZX_DATA       := dDataVenda //STOD((cAliasZZV)->CDATA)
	ZZX->ZZX_HORA		:= cHoraVenda
	ZZX->ZZX_CPF        := cDocCli
	ZZX->ZZX_CODCLI		:= cCodCli
	ZZX->ZZX_LOJCLI		:= cLojaCli
	ZZX->ZZX_ITEM       := STRZERO(nZ,2)
	ZZX->ZZX_INTEGR    	:= cIntegra
	ZZX->ZZX_PRODUT     := cProduto
	ZZX->ZZX_CATEGO  	:= cCatPRD
											ZZX->ZZX_QUANT      := nQtdPrd
											ZZX->ZZX_VLUNIT     := nVlrUnit
											ZZX->ZZX_TOTAL      := nVlrTot
											ZZX->ZZX_STATUS     := cStatZZX
											ZZX->ZZX_JSON		:= sJson
											ZZX->ZZX_MSG        := cMsg
											ZZX->ZZX_DTIMPO		:= date()
											ZZX->ZZX_HRIMPO		:= time()

*/
    oStruZZX:SetProperty("ZZX_IDEVEN",MVC_VIEW_GROUP_NUMBER,"GRP_01")
    oStruZZX:SetProperty("ZZX_NMEVEN",MVC_VIEW_GROUP_NUMBER,"GRP_01")
    oStruZZX:SetProperty("ZZX_OPERAC",MVC_VIEW_GROUP_NUMBER,"GRP_01")
    oStruZZX:SetProperty("ZZX_IDPDV",MVC_VIEW_GROUP_NUMBER,"GRP_01")
    oStruZZX:SetProperty("ZZX_CPF",MVC_VIEW_GROUP_NUMBER,"GRP_01")
	oStruZZX:SetProperty("ZZX_DATA",MVC_VIEW_GROUP_NUMBER,"GRP_01")
	oStruZZX:SetProperty("ZZX_HORA",MVC_VIEW_GROUP_NUMBER,"GRP_01")
	oStruZZX:SetProperty("*"         ,MVC_VIEW_GROUP_NUMBER,"GRP_01")
	oStruZZX:SetProperty("ZZX_ITEM"  ,MVC_VIEW_GROUP_NUMBER,"GRP_02")
	oStruZZX:SetProperty("ZZX_PRODUT"  ,MVC_VIEW_GROUP_NUMBER,"GRP_02")
	oStruZZX:SetProperty("ZZX_QUANT"  ,MVC_VIEW_GROUP_NUMBER,"GRP_02")
	oStruZZX:SetProperty("ZZX_VLUNIT"  ,MVC_VIEW_GROUP_NUMBER,"GRP_02")
	oStruZZX:SetProperty("ZZX_TOTAL"  ,MVC_VIEW_GROUP_NUMBER,"GRP_02")
	oStruZZX:SetProperty("ZZX_MSG"	,MVC_VIEW_GROUP_NUMBER,"GRP_02")
	oStruZZX:SetProperty("ZZX_JSON"  ,MVC_VIEW_GROUP_NUMBER,"GRP_02")
	oStruZZX:SetProperty("ZZX_HISTOR"  ,MVC_VIEW_GROUP_NUMBER,"GRP_02")
	

	oView:SetModel(oModel)
	oView:AddField(MODEL_MASTER,oStruZZX,MODEL_MASTER)

	oView:SetViewProperty(MODEL_MASTER,"SETLAYOUT",{FF_LAYOUT_VERT_DESCR_TOP,-1 })
	oView:CreateHorizontalBox('SUPERIOR',100)
	oView:SetOwnerView(MODEL_MASTER,'SUPERIOR')
Return(oView)

/*/{Protheus.doc} MenuDef
Define o menu de operacoes do CRUD MVC
@type function
@author Joalisson Laurentino | CRMServices | 1198975-3610 | Skype: jslaurentino
@since 
/*/
Static Function MenuDef()
	Local aRotina := {}
	Local aRotpos := {}
	Local aRotAju := {}
	Local aRotExe := {}
	
	ADD OPTION aRotpos TITLE "01 - Processar Posicionado"		ACTION "U_T4PROCNETPDV()" 		OPERATION MODEL_OPERATION_INSERT 	ACCESS 2
	ADD OPTION aRotpos TITLE "02 - Alterar" 	 	  			ACTION "VIEWDEF.T4FMntNetPDV" 	OPERATION MODEL_OPERATION_UPDATE 	ACCESS 2 
	
	ADD OPTION aRotAju TITLE "05 - Corrige Status"				ACTION "U_AtuStatusNetPDV()" 	OPERATION MODEL_OPERATION_INSERT 	ACCESS 2		
	ADD OPTION aRotAju TITLE "06 - Excluir Todos c/ Erros"		ACTION "U_T4FEXCNETPDV()" 		OPERATION MODEL_OPERATION_INSERT 	ACCESS 2		
	
	ADD OPTION aRotExe TITLE "03 - Importar NETPDV"		 		ACTION "U_T4FIMPNETPDV()" 		OPERATION MODEL_OPERATION_INSERT 	ACCESS 2	
	ADD OPTION aRotExe TITLE "04 - Gerar OP"					ACTION "U_T4FOPNETPDV()" 		OPERATION MODEL_OPERATION_INSERT 	ACCESS 2		
	ADD OPTION aRotExe TITLE "Ajustes"							ACTION aRotAju 					OPERATION MODEL_OPERATION_INSERT 	ACCESS 2		
	
	
	ADD OPTION aRotina TITLE "+ Detalhes" 						ACTION "VIEWDEF.T4FMntNetPDV"	OPERATION MODEL_OPERATION_VIEW   	ACCESS 1 
	ADD OPTION aRotina TITLE "De/Para Produtos"					ACTION "U_xDePara()" 			OPERATION MODEL_OPERATION_UPDATE 	ACCESS 3	
	ADD OPTION aRotina TITLE "Processamento posicionado"		ACTION aRotpos 					OPERATION MODEL_OPERATION_UPDATE 	ACCESS 2
	ADD OPTION aRotina TITLE "Processamento em lote"			ACTION aRotExe 					OPERATION MODEL_OPERATION_UPDATE 	ACCESS 2

	
	/*
	

	ADD OPTION aRotina TITLE "Incluir" 	 	  				ACTION "VIEWDEF.T4FMntNetPDV" 	OPERATION MODEL_OPERATION_INSERT 	ACCESS 2 
	ADD OPTION aRotina TITLE "Excluir" 	  					ACTION "VIEWDEF.T4FMntNetPDV" 	OPERATION MODEL_OPERATION_DELETE 	ACCESS 2 
	ADD OPTION aRotina TITLE "01 - Importar NetPDV"			ACTION aRotImp 					OPERATION MODEL_OPERATION_UPDATE 	ACCESS 2
	ADD OPTION aRotExe TITLE "00 - Todas Transações Pendentes"	ACTION "U_T4PROCNETPDV()" 		OPERATION MODEL_OPERATION_INSERT 	ACCESS 2
	ADD OPTION aRotina TITLE "02 - Registrar Transações"	    ACTION aRotExe 					OPERATION MODEL_OPERATION_UPDATE 	ACCESS 2*/
	
Return aRotina
/*/{Protheus.doc} xDePara
Menu para Cadastro de DE/Para
@type function
@author Joalisson Laurentino
@since 25/03/2022
/*/
User Function xDePara()
    Local aArea := GetArea()
 
    //Chamando a tela de cadastros
    AxCadastro('ZZW','De/Para de Produtos NetPDV')
 
    RestArea(aArea)
Return
