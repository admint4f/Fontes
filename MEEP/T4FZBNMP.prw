#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} T4FZBNMP
/*/

User Function T4FZBNMP()

	Local oBrowse

    DbSelectArea('ZBN')

//Cria o objeto do tipo FWMBrowse
    oBrowse := FWMBrowse():New()

//Alias ta tabela a ser utiliZBNa no browse
    oBrowse:SetAlias('ZBN')

//Descrição da rotina
    oBrowse:SetDescription("Historico de Integracao Item Venda INTI")

    oBrowse:AddLegend( "ZBN->ZBN_NUM<>''", "GREEN","Sem or�amento")
    // oBrowse:AddLegend( "ZBN->ZBN_FORMA=='CC'", "BLUE","Cartap Credito")
    oBrowse:AddLegend( "ZBN->ZBN_NUM=''", "RED","Com or�amento")

    oBrowse:SetMenuDef('T4FZBNMP')

    oBrowse:Activate()

Return

/*/{Protheus.doc} ModelDef
/*/
Static Function ModelDef()

// Cria a estrutura a ser usada no Model
    Local oStruZBN      := FWFormStruct( 1, 'ZBN', /*bAvalCampo*/, /*lViewUsado*/ )
    Local oModel
//    Local bPosValidacao := {||u_VldZBN(oModel)}


//Cria o objeto do Modelo de Dados
    oModel := MPFormModel():New( 'T4FZBNHIST', /*bPreValidacao*/ ,/* bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:SetDescription('Historico Integracao Item Venda MEEP')
//Adiciona ao modelo uma estrutura de formulário de edição por campo (antiga enchoice)
    oModel:AddFields( 'ZBNMASTER', /*cOwner*/, oStruZBN, )

//Chave Primaria
   oModel:SetPrimaryKey({"ZBN_FILIAL,ZBN_ORDID,ZBN_ITEMO"})

//Adiciona a descricao do Modelo de Dados
    oModel:SetDescription("Historico Integracao Item Venda MEEP")

//Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZBNMASTER' ):SetDescription( 'Master' )

Return oModel

/*/{Protheus.doc} ViewDef
/*/
Static Function ViewDef()

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado 
    Local oModel   	 :=  FWLoadModel( 'T4FZBNMP' )
    Local oView

// Cria a estrutura a ser usada na View
    Local oStruZBN 	:= FWFormStruct( 2, 'ZBN' )

// Cria o objeto de View
    oView := FWFormView():New()

// Define qual o Modelo de dados será utiliZBNo
    oView:SetModel( oModel )

    // oStruZBN:AddGroup("GrpCli", "Dados Cliente", "", 2)
    // // oStruZBN:AddGroup("GrpReg", "Dados Pedido INTI", "", 2)

    // //Dados Promotor
    // oStruZBN:SetProperty("ZBN_NOME"	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")
    // oStruZBN:SetProperty("ZBN_CPF" 	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField( 'VIEW_ZBN', oStruZBN, 'ZBNMASTER' )

    oStruZBN:RemoveField('ZBN_FILIAL' )
    // oStruZBN:RemoveField('ZBN_VERSAO' )

// Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR'  	, 100)

// Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_ZBN', 'SUPERIOR')

Return oView

/*/{Protheus.doc} MenuDef

/*/
Static Function MenuDef()

    Private aRotina	:= {}

    ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
    ADD OPTION aRotina Title "Visualizar" 				Action 'VIEWDEF.T4FZBNMP' 	OPERATION 2 ACCESS 0

Return aRotina



