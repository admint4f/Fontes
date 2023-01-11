#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} T4FZBMMP
/*/

User Function T4FZBMMP()

	Local oBrowse

    DbSelectArea('ZBM')

//Cria o objeto do tipo FWMBrowse
    oBrowse := FWMBrowse():New()

//Alias ta tabela a ser utiliZBMa no browse
    oBrowse:SetAlias('ZBM')

//Descrição da rotina
    oBrowse:SetDescription("Histórico de Integração INTI")

    oBrowse:AddLegend( "ZBM->ZBM_STATUS=='1'", "GREEN","Pendente")
    oBrowse:AddLegend( "ZBM->ZBM_STATUS=='2'", "BLUE","Pedido Gerado")
    oBrowse:AddLegend( "ZBM->ZBM_STATUS=='3'", "RED","Nota Gerada")

    oBrowse:SetMenuDef('T4FZBMMP')

    oBrowse:Activate()

Return

/*/{Protheus.doc} ModelDef
/*/
Static Function ModelDef()

// Cria a estrutura a ser usada no Model
    Local oStruZBM      := FWFormStruct( 1, 'ZBM', /*bAvalCampo*/, /*lViewUsado*/ )
    Local oModel
//    Local bPosValidacao := {||u_VldZBM(oModel)}


//Cria o objeto do Modelo de Dados
    oModel := MPFormModel():New( 'T4FZBMHIST', /*bPreValidacao*/ ,/* bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:SetDescription('Histórico Integração Meep')
//Adiciona ao modelo uma estrutura de formulário de edição por campo (antiga enchoice)
    oModel:AddFields( 'ZBMMASTER', /*cOwner*/, oStruZBM, )

//Chave Primaria
   oModel:SetPrimaryKey({"ZBM_FILIAL,ZBM_VENDA"})

//Adiciona a descricao do Modelo de Dados
    oModel:SetDescription("Histórico Integração MEEP")

//Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZBMMASTER' ):SetDescription( 'Master' )

Return oModel

/*/{Protheus.doc} ViewDef
/*/
Static Function ViewDef()

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado 
    Local oModel   	 :=  FWLoadModel( 'T4FZBMMP' )
    Local oView

// Cria a estrutura a ser usada na View
    Local oStruZBM 	:= FWFormStruct( 2, 'ZBM' )

// Cria o objeto de View
    oView := FWFormView():New()

// Define qual o Modelo de dados será utiliZBMo
    oView:SetModel( oModel )

    oStruZBM:AddGroup("GrpCli", "Dados Cliente", "", 2)
    // oStruZBM:AddGroup("GrpReg", "Dados Pedido INTI", "", 2)

    //Dados Promotor
    //oStruZBM:SetProperty("ZBM_NOME"	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")
    oStruZBM:SetProperty("ZBM_CPF" 	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")

    //Regras Meep
    // oStruZBM:SetProperty("ZBM_NFINTI" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    // oStruZBM:SetProperty("ZBM_SERINT" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")


    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField( 'VIEW_ZBM', oStruZBM, 'ZBMMASTER' )

    oStruZBM:RemoveField('ZBM_FILIAL' )
    // oStruZBM:RemoveField('ZBM_VERSAO' )

// Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR'  	, 100)

// Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_ZBM', 'SUPERIOR')

Return oView

/*/{Protheus.doc} MenuDef

/*/
Static Function MenuDef()

    Private aRotina	:= {}

    ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
    ADD OPTION aRotina Title "Visualizar" 				Action 'VIEWDEF.T4FZBMMP' 	OPERATION 2 ACCESS 0
    ADD OPTION aRotina Title "Alterar"  				Action 'VIEWDEF.T4FZBMMP' 	OPERATION 4 ACCESS 0

Return aRotina



