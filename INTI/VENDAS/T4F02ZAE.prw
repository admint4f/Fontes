//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

//Variáveis Estáticas
Static cTitulo := "Regras para Integração Plataforma INTI | Calendário de Eventos"

/*/{Protheus.doc} T4F02ZAE
Função para cadastro de Grupo de Produtos (SBM) e Produtos (SB1), exemplo de Modelo 3 em MVC
@author Atilio
@since 17/08/2015
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_T4F02ZAE()
    @obs Não se pode executar função MVC dentro do fórmulas
/*/

User Function T4F02ZAE()
	Local aArea   := GetArea()
	Local oBrowse

	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()

	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZAE")

	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)
	//Legendas
	oBrowse:AddLegend( "ZAE->ZAE_MSBLQL==' ' .OR. ZAE->ZAE_MSBLQL=='2'", "GREEN")
	oBrowse:AddLegend( "ZAE->ZAE_MSBLQL=='1'", "RED")

	oBrowse:SetMenuDef('T4F02ZAE')

	//Ativa a Browse
	oBrowse:Activate()

	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    Local oModel        := Nil
    Local oStruZAE      := FWFormStruct(1, 'ZAE')
    Local oStruZAJ      := FWFormStruct(1, 'ZAJ')
    Local cNum 			:= GetSx8Num("ZAE","ZAE_CODIGO")
	Local aZAJRel       := {}
    Local bPosValidacao := {||VldT4F02ZAE(oModel,cNum)}
	Local bLinePre 		:= {|oModel, cAction, cField| VldLin(oModel, cAction, cField) }
     
    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('Cadastro Regras INTI', /*bPreValidacao*/ , bPosValidacao, /*bCommit*/, /*bCancel*/ )
    oModel:AddFields('ZAEMASTER',/*cOwner*/,oStruZAE)
    oModel:AddGrid('ZAJDETAIL','ZAEMASTER',oStruZAJ,bLinePre, {|oModel| fValGrid(oModel,cNum)},/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence

    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aZAJRel, {'ZAJ_FILIAL',    'ZAE_FILIAL'} )
    aAdd(aZAJRel, {'ZAJ_EPEP',      'ZAE_EPEP'}) 
     
    oModel:SetRelation('ZAJDETAIL', aZAJRel, ZAJ->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
    oModel:GetModel('ZAJDETAIL'):SetUniqueLine({"ZAJ_FILIAL","ZAJ_EPEP","ZAJ_ITEM","ZAJ_DATA"})    //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
     
    //Setando as descrições
    oModel:GetModel("ZAJDETAIL"):SetMaxLine(200)
    oModel:SetDescription("Integração Plataforma INTI")
    oModel:GetModel('ZAEMASTER'):SetDescription('Modelo Grupo')
    oModel:GetModel('ZAJDETAIL'):SetDescription('Modelo Produtos')
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local oView       := Nil
    Local oModel      := FWLoadModel('T4F02ZAE')
    Local oStruZAE    := FWFormStruct(2, 'ZAE')
    Local oStruZAJ    := FWFormStruct(2, 'ZAJ')
     
    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)

    oStruZAE:AddGroup("GrpEv",  "Dados do Evento", "", 2)
	oStruZAE:AddGroup("GrpCli", "Dados Promotor", "", 2)
    oStruZAE:AddGroup("GrpReg", "Regras INTI", "", 2)
	oStruZAE:AddGroup("GrpPed", "Produtos do Pedido de Venda", "", 2)
	oStruZAE:AddGroup("GrpCtb", "Apropriação de Resultado", "", 2)

    //Evento
	oStruZAE:SetProperty("ZAE_EPEP"     , MVC_VIEW_GROUP_NUMBER, "GrpEv")
	oStruZAE:SetProperty("ZAE_EVENTO" 	, MVC_VIEW_GROUP_NUMBER, "GrpEv")
    oStruZAE:SetProperty("ZAE_CC" 	    , MVC_VIEW_GROUP_NUMBER, "GrpEv")
    oStruZAE:SetProperty("ZAE_MSBLQL" 	, MVC_VIEW_GROUP_NUMBER, "GrpEv")

    //DADOS PEDIDO
	oStruZAE:SetProperty("ZAE_PRDTKT" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
	oStruZAE:SetProperty("ZAE_PRDTXO" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
	oStruZAE:SetProperty("ZAE_PRDTXS" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
	oStruZAE:SetProperty("ZAE_PRDTXC" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
	oStruZAE:SetProperty("ZAE_PRDTXI" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
	oStruZAE:SetProperty("ZAE_PDTXCA" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
	oStruZAE:SetProperty("ZAE_PRDENT" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
    oStruZAE:SetProperty("ZAE_PRDSOC" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
    oStruZAE:SetProperty("ZAE_PRDWAL" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
	oStruZAE:SetProperty("ZAE_PRTKT2" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
        
    //Regras INTI
	//oStruZAE:SetProperty("ZAE_TPVEND" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    //oStruZAE:SetProperty("ZAE_ENTIDA" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    //oStruZAE:SetProperty("ZAE_TPRECB" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
	    
    //Dados Promotor
	oStruZAE:SetProperty("ZAE_TPREPA" 	, MVC_VIEW_GROUP_NUMBER, "GrpCli")
	oStruZAE:SetProperty("ZAE_CDPROM" 	, MVC_VIEW_GROUP_NUMBER, "GrpCli")
    oStruZAE:SetProperty("ZAE_DIASTR" 	, MVC_VIEW_GROUP_NUMBER, "GrpCli")

	
	//Dados da Contabilização
	oStruZAE:SetProperty("ZAE_CTBREC" 	, MVC_VIEW_GROUP_NUMBER, "GrpCtb")
	oStruZAE:SetProperty("ZAE_CTBPIS" 	, MVC_VIEW_GROUP_NUMBER, "GrpCtb")
    oStruZAE:SetProperty("ZAE_CTBCOF" 	, MVC_VIEW_GROUP_NUMBER, "GrpCtb")
    
    //Adicionando os campos do cabeçalho e o grid dos filhos
    oView:AddField('VIEW_ZAE',oStruZAE,'ZAEMASTER')
    
    oStruZAE:RemoveField('ZAE_FILIAL' )
	oStruZAE:RemoveField('ZAE_CODIGO' )
	oStruZAE:RemoveField('ZAE_VERSAO' )
	oStruZAE:RemoveField('ZAE_TPTRAN' )
	oStruZAE:RemoveField('ZAE_DTEVEN' )
	oStruZAE:RemoveField('ZAE_RECEIT' )
    
    oView:AddGrid('VIEW_ZAJ',oStruZAJ,'ZAJDETAIL')
    oStruZAJ:RemoveField('ZAJ_FILIAL' )
    oStruZAJ:RemoveField('ZAJ_EPEP' )
	oStruZAJ:RemoveField('ZAJ_CODIGO' )
	oStruZAJ:RemoveField('ZAJ_MSBLQL' )
	     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC',60)
    oView:CreateHorizontalBox('GRID',40)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_ZAE','CABEC')
    oView:SetOwnerView('VIEW_ZAJ','GRID')
    oView:EnableControlBar(.T.)

    //Define o campo incremental da grid como o ZAJ_ITEM
    oView:AddIncrementField('VIEW_ZAJ', 'ZAJ_ITEM')
     
    //Habilitando título
    oView:EnableTitleView('VIEW_ZAE','Regras de Integração')
    oView:EnableTitleView('VIEW_ZAJ','Calendário')
Return oView


/*/{Protheus.doc} T4F01Leg
@description **Funcao de Legenda**
@type function
@version 1.00
@author Rogério Costa
@since 13/10/2020
@return Array, aRotina
/*/
User Function T4F02Leg()
	Local aLegenda := {}

	//Monta as cores
	AADD(aLegenda,{"BR_VERDE",        "Ativo"  })
	AADD(aLegenda,{"BR_VERMELHO",    "Inativo"})

	BrwLegenda("Cadastro Regras INTI", "Regras INTI", aLegenda)
Return

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/08/2015                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Private aRotina := {}

	ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
	ADD OPTION aRotina Title "Visualizar" 				Action 'VIEWDEF.T4F02ZAE' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title "Incluir"	    			Action 'VIEWDEF.T4F02ZAE' 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina Title "Alterar"  				Action 'VIEWDEF.T4F02ZAE' 	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Legenda'                  ACTION 'u_T4F02Leg'         OPERATION 6 ACCESS 0
	//ADD OPTION aRotina Title "Copia"	    			Action 'VIEWDEF.T4F02ZAE' 	OPERATION 9 ACCESS 0
   
Return aRotina

/*/{Protheus.doc} VldMVC
@Description ** Função desenvolvida para validar os dados **
@type function
@author Atilio
@since 14/01/2017
@version 1.0
/*/
Static Function VldT4F02ZAE(oModel,cNum)
	Local aArea      := GetArea()
	Local lRet       := .T.
	Local oModelDad  := FWModelActive()
	Local cEpep    	 := oModelDad:GetValue('ZAEMASTER', 'ZAE_EPEP')
	Local cCc    	 := oModelDad:GetValue('ZAEMASTER', 'ZAE_CC')
	Local cCodigo  	 := oModelDad:GetValue('ZAEMASTER', 'ZAE_CODIGO')
	Local nOpc       := oModelDad:GetOperation()
	
	DbSelectArea('ZAE')
	ZAE->(DbSetOrder(1))

	DbSelectArea('SB2')
	SB2->(DbSetOrder(1))

	If nOpc == 3 //3=incluir, 4=alterar

		oModelZA2 := oModelDad:GetModel('ZAEMASTER')
		oModelZA2:SetValue('ZAE_CODIGO',cNum)

		cQryZAE:= "SELECT ZAE_EPEP 			  " + CRLF
		cQryZAE+= " FROM "+RetSqlName('ZAE')   		+ CRLF
		cQryZAE+= " WHERE ZAE_EPEP = '"+cEpep+"'"	+ CRLF
		cQryZAE+= " AND ZAE_CODIGO <> '"+cCodigo+"' 		  " + CRLF
		cQryZAE+= " AND ZAE_MSBLQL = '2' 		  " + CRLF
		cQryZAE+= " AND D_E_L_E_T_ = ' ' 		  " + CRLF

		cQryZAE	:= ChangeQuery(cQryZAE)

		cAliasZAE	:= MPSysOpenQuery(cQryZAE)

		(cAliasZAE)->(DbGotop())

		If Alltrim((cAliasZAE)->ZAE_EPEP) == Alltrim(cEpep)

			msg := "ATENCAO!"+CHR(13)+CHR(10)
			msg +=  CHR(13)+CHR(10)
			msg += "Já existe regra cadastrada para esse EPEP e a mesma não está bloqueada." + CHR(13)+CHR(10)
			msg +=  CHR(13)+CHR(10)
			msg += "Para prosseguir, bloqueie o registro de código " + ZAE->ZAE_CODIGO
			msg +=  CHR(13)+CHR(10)

			FWAlertError(msg)

			lRet:= .F.

		EndIf

	EndIf

	If Empty(cCc)

		msg := "ATENCAO!"+CHR(13)+CHR(10)
		msg +=  CHR(13)+CHR(10)
		msg += "Centro de custo em branco."
		msg +=  CHR(13)+CHR(10)
		msg += "Para prosseguir preencha o campo Centro de Custo."
		msg +=  CHR(13)+CHR(10)

		Alert(msg)

		lRet:= .F.
	EndIf


	RestArea(aArea)
Return lRet

//Função que faz a validação da grid
Static Function fValGrid(oModel,cNum)
	Local lRet          := .T.
	Local nDeletados    := 0
	Local nLinAtual     :=0
	Local nOper         := oModel:GetOperation()
	Local oModelZAJ     := oModel:GetModel('ZAJDETAIL' )
	Local nQtdLinhas    := oModel:GetQtdLine()
	Local nLinha        := oModel:nLine
	Local dDtCtb   		:= oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_DTCTB')

	Local dData   		:= oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_DATA')
	Local cHora   		:= oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_HORA')
	Local cBlq    		:= oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_MSBLQL')

	//Percorrendo todos os itens da grid
	For nLinAtual := 1 To nQtdLinhas

		If nOper == 4  .And. !Empty(dDtCtb) .And. oModel:IsDeleted()

			Help(,,'Sessão Contabilizada',,'A sessão não poderá ser excluida pois já foi contabilizada',1,0,,,,,,{'Você pode bloquear sessões contabilizadas'})

			Return(.F.)

			//Se a linha for excluida, incrementa a variável de deletados, senão irá incrementar o valor digitado em um campo na grid
			If oModel:IsDeleted()
				nDeletados++
			Else
				oModel:GoLine(nLinAtual)

				If dData == oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_DATA') .And. cHora == oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_HORA') .And. nLinAtual <> nLinha;
						.And. cBlq == oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_MSBLQL')

					Help(,,'Data e Hora',,'Data e Hora já estão cadastradas',1,0,,,,,,{'Cadastre uma nova data ou uma nova hora para o evento'})

					Return(.F.)

				EndIf

			EndIf
		ElseIf nOper == 3  

			//Se a linha for excluida, incrementa a variável de deletados, senão irá incrementar o valor digitado em um campo na grid
			If oModel:IsDeleted()
				nDeletados++
			Else
				oModel:GoLine(nLinAtual)

				oModelZAJ:SetValue('ZAJDETAIL', 'ZAJ_CODIGO',cNum)

				If dData == oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_DATA') .And. cHora == oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_HORA') .And. nLinAtual <> nLinha;
						.And. cBlq == oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_MSBLQL')

					Help(,,'Data e Hora',,'Data e Hora já estão cadastradas',1,0,,,,,,{'Cadastre uma nova data ou uma nova hora para o evento'})

					Return(.F.)

				EndIf

			EndIf
		
		EndIf

	Next nLinAtual

	//Se o tamanho da Grid for igual ao número de itens deletados, acusa uma falha
	If nQtdLinhas==nDeletados
		lRet :=.F.
		Help( , , 'Dados Inválidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha válida!"})
	EndIf

Return lRet

//Função que faz a validação da grid
Static Function VldLin(oModel,nLine, nOper, cField)
	
	Local lRet          := .T.
	Local oModelZAJ 	:= oModel:GetModel()
	Local dDtCtb   		:= oModelZAJ:GetValue('ZAJDETAIL', 'ZAJ_DTCTB')
	
  // Valida se pode ou não apagar uma linha do Grid
  If nOper == 'DELETE' .AND. !Empty(dDtCtb)
    lRet := .F.
    Help(,,'Sessão Contabilizada',,'A sessão não poderá ser excluida pois já foi teve sua bilheteria apropriada na contabilidade',1,0,,,,,,{'Você poderá bloquear sessões apropriadas'})
  EndIf

Return lRet


