#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} T4FZBPMP
/*/

User Function T4FZBPMP()

	Local oBrowse

    DbSelectArea('ZBP')

//Cria o objeto do tipo FWMBrowse
    oBrowse := FWMBrowse():New()

//Alias ta tabela a ser utiliZBPa no browse
    oBrowse:SetAlias('ZBP')

//Descrição da rotina
    oBrowse:SetDescription("Historico de Integracao Pagto INTI")

    oBrowse:AddLegend( "ZBP->ZBP_FORMA=='R$'", "GREEN","Dinheiro")
    oBrowse:AddLegend( "ZBP->ZBP_FORMA=='CC'", "BLUE","Cartap Credito")
    oBrowse:AddLegend( "ZBP->ZBP_FORMA=='CD'", "RED","Cartao Debito")

    oBrowse:SetMenuDef('T4FZBPMP')

    oBrowse:Activate()

Return

/*/{Protheus.doc} ModelDef
/*/
Static Function ModelDef()

// Cria a estrutura a ser usada no Model
    Local oStruZBP      := FWFormStruct( 1, 'ZBP', /*bAvalCampo*/, /*lViewUsado*/ )
    Local oModel
//    Local bPosValidacao := {||u_VldZBP(oModel)}


//Cria o objeto do Modelo de Dados
    oModel := MPFormModel():New( 'T4FZBPHIST', /*bPreValidacao*/ ,/* bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:SetDescription('Historico Integracao Pagto MEEP')
//Adiciona ao modelo uma estrutura de formulário de edição por campo (antiga enchoice)
    oModel:AddFields( 'ZBPMASTER', /*cOwner*/, oStruZBP, )

//Chave Primaria
   oModel:SetPrimaryKey({"ZBP_FILIAL,ZBP_ORDID,ZBP_ITEM"})

//Adiciona a descricao do Modelo de Dados
    oModel:SetDescription("Historico Integracao Pagto MEEP")

//Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZBPMASTER' ):SetDescription( 'Master' )

Return oModel

/*/{Protheus.doc} ViewDef
/*/
Static Function ViewDef()

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado 
    Local oModel   	 :=  FWLoadModel( 'T4FZBPMP' )
    Local oView

// Cria a estrutura a ser usada na View
    Local oStruZBP 	:= FWFormStruct( 2, 'ZBP' )

// Cria o objeto de View
    oView := FWFormView():New()

// Define qual o Modelo de dados será utiliZBPo
    oView:SetModel( oModel )

    // oStruZBP:AddGroup("GrpCli", "Dados Cliente", "", 2)
    // // oStruZBP:AddGroup("GrpReg", "Dados Pedido INTI", "", 2)

    // //Dados Promotor
    // oStruZBP:SetProperty("ZBP_NOME"	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")
    // oStruZBP:SetProperty("ZBP_CPF" 	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField( 'VIEW_ZBP', oStruZBP, 'ZBPMASTER' )

    oStruZBP:RemoveField('ZBP_FILIAL' )
    // oStruZBP:RemoveField('ZBP_VERSAO' )

// Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR'  	, 100)

// Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_ZBP', 'SUPERIOR')

Return oView

/*/{Protheus.doc} MenuDef

/*/
Static Function MenuDef()

    Private aRotina	:= {}

    ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
    ADD OPTION aRotina Title "Visualizar" 				Action 'VIEWDEF.T4FZBPMP' 	OPERATION 2 ACCESS 0

Return aRotina



