#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"
#INCLUDE 'FWMVCDEF.CH'

/*----------------------------------------------------------------------*
 | Func:  U_T4FZB0ZZ                                                  	|
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Menu Browse com inclusão da tabela ZB0                		|
 *----------------------------------------------------------------------*/

User function T4FZB0ZZ()
    Local oBrowse

    DbSelectArea('ZB0')

//Cria o objeto do tipo FWMBrowse
    oBrowse := FWMBrowse():New()

//Alias ta tabela a ser utilizada no browse
    oBrowse:SetAlias('ZB0')

//Descrição da rotina
    oBrowse:SetDescription("Dados Integração Meep")

    oBrowse:AddLegend( "ZB0->ZB0_ATIVO =='1'", "GREEN")
    oBrowse:AddLegend( "ZB0->ZB0_ATIVO =='2'", "RED")

    oBrowse:SetMenuDef('T4FZB0ZZ')

    oBrowse:Activate()

Return

/*/{Protheus.doc} ModelDef/*/

Static Function ModelDef()

// Cria a estrutura a ser usada no Model
    Local oStruZAE      := FWFormStruct( 1, 'ZB0', /*bAvalCampo*/, /*lViewUsado*/ )
    Local oModel
    // Local bPosValidacao := {||u_VldZAE(oModel)}


//Cria o objeto do Modelo de Dados
    oModel := MPFormModel():New( 'Dados Integração', /*bPreValidacao*/ , /*bPosValidacao*/ , /*bCommit*/, /*bCancel*/ )
    oModel:SetDescription('Dados Integração')
//Adiciona ao modelo uma estrutura de formulário de edição por campo (antiga enchoice)
    oModel:AddFields( 'ZB0MASTER', /*cOwner*/, oStruZAE, )

//Chave Primaria
    oModel:SetPrimaryKey({"ZB0_FILIAL,ZB0_EPEP,ZB0_EMP"})

//Adiciona a descricao do Modelo de Dados
    oModel:SetDescription("Dados Integração Meep")

//Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZB0MASTER' ):SetDescription( 'Master' )

Return oModel

Static Function ViewDef()

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado 
    Local oModel   	 :=  FWLoadModel( 'T4FZB0ZZ' )
    Local oView

// Cria a estrutura a ser usada na View
    Local oStruZB0 	:= FWFormStruct( 2, 'ZB0' )

// Cria o objeto de View
    oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
    oView:SetModel( oModel )

    oStruZB0:AddGroup("GrpLog", "Dados Logisticos", "", 2)
    oStruZB0:AddGroup("Meep",  "Meep", "", 2)

    //Dados Promotor
    oStruZB0:SetProperty("ZB0_NUM"	    , MVC_VIEW_GROUP_NUMBER, "GrpLog")
    // oStruZB0:SetProperty("ZB0_EPEP"	    , MVC_VIEW_GROUP_NUMBER, "GrpLog")
    oStruZB0:SetProperty("ZB0_DESC" 	, MVC_VIEW_GROUP_NUMBER, "GrpLog")
    oStruZB0:SetProperty("ZB0_EMP" 	    , MVC_VIEW_GROUP_NUMBER, "GrpLog")
    oStruZB0:SetProperty("ZB0_LOCAL" 	, MVC_VIEW_GROUP_NUMBER, "GrpLog")
    oStruZB0:SetProperty("ZB0_FIL" 	    , MVC_VIEW_GROUP_NUMBER, "GrpLog")
    // oStruZB0:SetProperty("ZB0_LOCALI" 	, MVC_VIEW_GROUP_NUMBER, "GrpLog")
    oStruZB0:SetProperty("ZB0_TABPC" 	, MVC_VIEW_GROUP_NUMBER, "GrpLog")
    oStruZB0:SetProperty("ZB0_TES" 	    , MVC_VIEW_GROUP_NUMBER, "GrpLog")
    oStruZB0:SetProperty("ZB0_ADMINI" 	, MVC_VIEW_GROUP_NUMBER, "GrpLog")
    oStruZB0:SetProperty("ZB0_ATIVO" 	, MVC_VIEW_GROUP_NUMBER, "GrpLog")
    // oStruZB0:SetProperty("ZB0_DTFIM" 	, MVC_VIEW_GROUP_NUMBER, "GrpLog")

    //Evento
    oStruZB0:SetProperty("ZB0_MEEP" 	, MVC_VIEW_GROUP_NUMBER, "Meep")

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField( 'VIEW_ZB0', oStruZB0, 'ZB0MASTER' )

    oStruZB0:RemoveField('ZB0_FILIAL' )
    oStruZB0:RemoveField('ZB0_CTEST' )
    oStruZB0:RemoveField('ZB0_LOCALI' )
   
// Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR'  	, 100)

// Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_ZB0', 'SUPERIOR')

Return oView

Static Function MenuDef()

    Private aRotina	:= {}

    ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
    ADD OPTION aRotina Title "Visualizar" 				Action 'VIEWDEF.T4FZB0ZZ' 	OPERATION 2 ACCESS 0

    ADD OPTION aRotina Title "Incluir"	    			Action 'VIEWDEF.T4FZB0ZZ' 	OPERATION 3 ACCESS 0
    ADD OPTION aRotina Title "Alterar"  				Action 'VIEWDEF.T4FZB0ZZ' 	OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Legenda'                  ACTION 'u_T4FZB0LEG'         OPERATION 6 ACCESS 0

Return aRotina

User Function T4FZB0LEG()
    Local aLegenda := {}

    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "Ativo"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Inativo"})

    BrwLegenda("Dados Integração Meep", "Dados Integração Meep", aLegenda)
Return

User function VLDCODMP()
    Local lRet      := .T.
    Local cToken
    Local oRestClient
    Local cPostRet
    Local aHeadProd     := {}
    Local cUrlMeep      := ""
    Local cPath         := ""

    if !empty(alltrim(M->ZB0_MEEP))
        cToken	:= U_MeepAuth()
        cUrlMeep := SuperGetMV("MV_MPURL",.T.,"https://server.meep.cloud")

        oRestClient   := FWRest():New(cUrlMeep)

        Aadd(aHeadProd, 'Authorization: Bearer '+cToken)

        cPath    := "/api/third/stores?storeId="+alltrim(M->ZB0_MEEP)

        oRestClient:setPath(cPath)
        If oRestClient:Get(aHeadProd)
            cPostRet := (oRestClient:GetResult())
        Else 
            cPostRet := (oRestClient:GetLastError())
            lRet := .F.
        EndIf
    EndIf
Return lRet
