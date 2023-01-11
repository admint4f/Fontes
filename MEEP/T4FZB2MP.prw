#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} T4F01ZAE
description Browse cadastro para configuração das regras de integração INTI
@type function
@version 1.00 
@author Rogério Costa
@since 13/10/2020
@return return_type, Nil
/*/

User function T4FZB2ZZ()
    Local oBrowse

    DbSelectArea('ZB2')

//Cria o objeto do tipo FWMBrowse
    oBrowse := FWMBrowse():New()

//Alias ta tabela a ser utilizada no browse
    oBrowse:SetAlias('ZB2')

//Descrição da rotina
    oBrowse:SetDescription("Integracao Meep - Produtos")

    oBrowse:AddLegend( "ZB2->ZB2_STATUS = '1'", "GREEN")
    oBrowse:AddLegend( "ZB2->ZB2_STATUS = '0'", "RED")

    oBrowse:SetMenuDef('T4FZB2ZZ')

    oBrowse:Activate()

Return

/*/{Protheus.doc} ModelDef/*/

Static Function ModelDef()

// Cria a estrutura a ser usada no Model
    Local oStruZAE      := FWFormStruct( 1, 'ZB2', /*bAvalCampo*/, /*lViewUsado*/ )
    Local oModel
    // Local bPosValidacao := {||u_VldZAE(oModel)}


//Cria o objeto do Modelo de Dados
    oModel := MPFormModel():New( 'Integracao Meep - Produtos', /*bPreValidacao*/ , /*bPosValidacao*/ , /*bCommit*/, /*bCancel*/ )
    oModel:SetDescription('Integracao Meep - Produtos')
//Adiciona ao modelo uma estrutura de formulário de edição por campo (antiga enchoice)
    oModel:AddFields( 'ZB2MASTER', /*cOwner*/, oStruZAE, )

//Chave Primaria
    oModel:SetPrimaryKey({"ZB2_FILIAL,ZB2_EPEP,ZB2_EMP"})

//Adiciona a descricao do Modelo de Dados
    oModel:SetDescription("Integracao Meep - Produtos")

//Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZB2MASTER' ):SetDescription( 'Master' )

Return oModel

/*/{Protheus.doc} ViewDef
description Define a interface com usuario
@type function
@version 
@author roger
@since 13/10/2020
@return Objeto, oView
/*/
Static Function ViewDef()

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado 
    Local oModel   	 :=  FWLoadModel( 'T4FZB2ZZ' )
    Local oView

// Cria a estrutura a ser usada na View
    Local oStruZB2 	:= FWFormStruct( 2, 'ZB2' )

// Cria o objeto de View
    oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
    oView:SetModel( oModel )

    oStruZB2:AddGroup("GrupoGeral", "Dados", "", 2)

    //Dados Promotor
    oStruZB2:SetProperty("ZB2_STORE"	    , MVC_VIEW_GROUP_NUMBER, "GrupoGeral")
    oStruZB2:SetProperty("ZB2_COD" 	, MVC_VIEW_GROUP_NUMBER, "GrupoGeral")
    oStruZB2:SetProperty("ZB2_IDMEEP" 	    , MVC_VIEW_GROUP_NUMBER, "GrupoGeral")
    oStruZB2:SetProperty("ZB2_QTINT" 	, MVC_VIEW_GROUP_NUMBER, "GrupoGeral")
    oStruZB2:SetProperty("ZB2_LOCALI" 	, MVC_VIEW_GROUP_NUMBER, "GrupoGeral")

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField( 'VIEW_ZB2', oStruZB2, 'ZB2MASTER' )

    oStruZB2:RemoveField('ZB2_FILIAL' )
   
// Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR'  	, 100)

// Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_ZB2', 'SUPERIOR')

Return oView

/*/{Protheus.doc} MenuDef
description Funcao de definição do aRotina
@type function
@version 
@author roger
@since 13/10/2020
@return Array, aRotina
/*/
Static Function MenuDef()

    Private aRotina	:= {}

    ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
    ADD OPTION aRotina Title "Visualizar" 				Action 'VIEWDEF.T4FZB2ZZ' 	OPERATION 2 ACCESS 0

    // ADD OPTION aRotina Title "Incluir"	    			Action 'VIEWDEF.T4FZB2ZZ' 	OPERATION 3 ACCESS 0
    // ADD OPTION aRotina Title "Alterar"  				Action 'VIEWDEF.T4FZB2ZZ' 	OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Legenda'                  ACTION 'u_T4FZB2Leg'         OPERATION 6 ACCESS 0

Return aRotina

/*/{Protheus.doc} T4FZB2Leg
description Funcao de Legenda
@type function
@version 
@author roger
@since 13/10/2020
@return Array, aRotina
/*/
User Function T4FZB2Leg()
    Local aLegenda := {}

    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "Ativo"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Inativo"})

    BrwLegenda("Integracao Meep - Produtos", "Integracao Meep - Produtos", aLegenda)
Return
